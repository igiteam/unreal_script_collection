/**
 * This is a bit tricky.  You have the Enum which is what the LDs want to be able to use to tell the fan what speed it should being going (eventually).
 * Once the fan knows how fast it should be going then it needs to interpolate from its current value to the desired value.
 * During that time another event could tell the fan to change back to what it just left.
 * So we have enums that determine where it will go and wants to go.  And we have actual values for what state the fan is in currently
 *
 * This needs to be JUST the base class once the LDs have put in all of the new fans
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoFanBase extends NanoInterpActor
	implements( NanoInterface_PingAffectable )
	abstract
	native
	placeable;


/** Determines whether or not the player is able to ghost through the base of the fan. **/
var bool bAbleToGhostThroughBase;

/** Mesh that is the plume of air shooting forth from the fan **/
var(NanoFan) StaticMeshComponent Plume;

var() StaticMeshComponent OuterMetalRing;

var StaticMeshComponent FanBlades1;


/** Set this for the ZoneVelocity for this fan **/
var deprecated vector ZoneVelocity;

/** This is the height in stories for the collision volume and the plume.  Default scale is 1 story tall so we just multiply by this number. **/
var(NanoFan) vector HeightInStories;
var(NanoFan) transient vector HeightInStoriesOrig;

/** This is the area where the fan will affect **/
var StaticMeshComponent StaticMeshCollisionVolume;
/** This will scale the FanVolume's X and Y by this much so we can have it overlapping the base.  This stops people getting stuck in between the plume and the wall **/
var(NanoFan) float FanVolumeScalar;

var protected NanoVolume_Fan FanVolume;  

/** Ping effects particles **/
var ParticleSystemComponent PSC_PingEffect_Stream;
var ParticleSystemComponent PSC_PingEffect_Spread;

/** This is the fan speed setting **/
enum EFanSpeed
{
	FS_Off,
	FS_HalfHeight,
	FS_FullHeight,
	FS_DoubleHeight
};

/** List of all of the actual numbers we are going to modify the fan component by**/
var protected int FanSpeedNumericalValues[EFanSpeed.EnumCount];

/** The current fan speed **/
var transient EFanSpeed FanSpeed_Curr;
var transient int FanSpeed_Numerical;

/** The desired fan speed**/
var(NanoFan) EFanSpeed FanSpeed_Desired;

/** Amount of time to interp speed changes over **/
var transient float FanSpeed_InterpTime;
var transient float FanSpeed_InterpSpeed;

var transient float CurrFanPlumeHeightMultiplier;
var float FanPlumeHeightMultipliers[EFanSpeed.EnumCount];
var transient float Plume_InterpSpeed;

var SoundCue FanBladeSpinSound;
var transient AudioComponent AC_FanBladeSpin;

var transient float CurrFanBladePitchMultiplier;
var float FanBladePitchMultipliers[EFanSpeed.EnumCount];
var transient float BladePitch_InterpSpeed;
var protected name FanBladePitchName;

/** If this plume has been nano pinged we are going to scale the plume by this much. **/
var transient float PlumeScaleZGoal;
var transient float SavedPlumeScaleZ;

/** 
 * These are the plume visibility values so that we nicely fade in and out the fan wafts 
 * @NOTE: we should convert these to MITVs
 **/
var transient float PlumeVisibilityGoal;
var transient float PlumeVisibilityCurr;

/** 
 * The MIC we are going to use for affected Ping affected plumes. 
 **/
var transient MaterialInstanceConstant MIC_PlumeSwirlPinged;
var transient float PlumeBrightnessGoal;
var transient float PlumeBrightnessCurr;

/** If fan launch targets are specified, when the pawn touches the plume, they will be flung to the target that best matches the pawn's velocity */
struct native FanLaunchTargetInfo
{
	var() Actor LaunchTarget;
	var() float FlightTime;

	structdefaultproperties
	{
		FlightTime=1.f
	}
};
var() array<FanLaunchTargetInfo>  FanLaunchTargets;

cpptext
{
	virtual void TickSpecial( FLOAT DeltaSeconds );
	virtual UBOOL IgnoreBlockingBy( const AActor *Other) const;
	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);
	virtual void SetCollisionForPathBuilding(UBOOL bNowPathBuilding);
}


simulated function PostBeginPlay()
{
	local float StreamLifeTime;
	//local LinearColor LinColor;

	Super.PostBeginPlay();

	DetachComponent( StaticMeshCollisionVolume );

	FanVolume = Spawn( class'NanoVolume_Fan', self,, Location, Rotation );
	FanVolume.FanBelongTo = self;

	//FanVolume.ZoneVelocity = ZoneVelocity;
	FanVolume.SetStaticMeshCollisionVolume( StaticMeshCollisionVolume );

	AC_FanBladeSpin = new(self) class'AudioComponent';
	AC_FanBladeSpin.SoundCue = FanBladeSpinSound;
	AC_FanBladeSpin.FadeIn( 1.0f, 1.0f );
	AttachComponent( AC_FanBladeSpin );

	HeightInStoriesOrig = HeightInStories; // save off the orig fan height for this specific actor
	SetFanSpeed( FanSpeed_Desired, 1.0f );

	MIC_PlumeSwirlPinged = new(self) class'MaterialInstanceConstant';
	MIC_PlumeSwirlPinged.SetParent( Plume.GetMaterial(0) );
	Plume.SetMaterial( 0, MIC_PlumeSwirlPinged );
	MIC_PlumeSwirlPinged.SetScalarParameterValue( 'VertOffset', 0.0f );
	//@todo -- This should be const in default properties since it doesn't change and this is slow
	//LinColor = MakeLinearColor(0.2f,0.2f,0.2f,1);
	//MIC_PlumeSwirlPinged.SetVectorParameterValue( 'ColorOne', LinColor );
	//MIC_PlumeSwirlPinged.SetScalarParameterValue( 'OverallOpacity', 0.05f );
	MIC_PlumeSwirlPinged.SetScalarParameterValue( 'GhostMode', 0.0f );
	

	PlumeVisibilityGoal = 0.0f;
	PlumeVisibilityCurr = PlumeVisibilityGoal;

	// set up the ping effects
	StreamLifeTime = HeightInStories.Z;
	if( PSC_PingEffect_Stream != None )
	{
		PSC_PingEffect_Stream.SetFloatParameter( 'Streamlife', StreamLifeTime );
	}

	if( PSC_PingEffect_Spread != None )
	{
		PSC_PingEffect_Spread.SetTranslation( vect(0,0,1) * (StreamLifeTime * 512.0f ) );
		DetachComponent( PSC_PingEffect_Spread );
		AttachComponent( PSC_PingEffect_Spread );
	}
}


/** Helper function which will modify the plume and the fan volume to be the correct height **/
native function ModifyPlumeAndFanVolumeToMatchHeight( const out vector NewHeighInStories );


/** This will set the speed that is desired and also set our "speed" which is just an increment that FInterpConstantTo takes. **/
simulated function SetFanSpeed( const EFanSpeed InNewSpeed, const float InInterpTime )
{
	// need to actually scale the volumes and plumes!
	HeightInStories.Z = HeightInStoriesOrig.Z * FanPlumeHeightMultipliers[ InNewSpeed ];

	ModifyPlumeAndFanVolumeToMatchHeight( HeightInStories );


	FanSpeed_Desired = InNewSpeed;
	FanSpeed_InterpTime = InInterpTime;
	FanSpeed_InterpSpeed = Abs(( FanSpeedNumericalValues[FanSpeed_Desired] - FanSpeedNumericalValues[FanSpeed_Curr] ) / FanSpeed_InterpTime );

	Plume_InterpSpeed = Abs(( ( FanPlumeHeightMultipliers[FanSpeed_Desired]- FanPlumeHeightMultipliers[FanSpeed_Curr] ) * HeightInStories.Z ) / FanSpeed_InterpTime );
	BladePitch_InterpSpeed  = Abs(( FanBladePitchMultipliers[FanSpeed_Desired] - FanBladePitchMultipliers[FanSpeed_Curr] ) / FanSpeed_InterpTime );

	// if we have a fan blade go ahead and check to see if it was just turned off or just turned on
	if( AC_FanBladeSpin != none )
	{
		if( FanSpeed_Desired == FS_Off )
		{
			AC_FanBladeSpin.FadeOut( FanSpeed_InterpTime, 0.0f );
		}
		else
		{
			AC_FanBladeSpin.FadeIn( FanSpeed_InterpTime, 1.0f );
		}
	}

	// so due to the race conditions we can achieve as we are starting at curr and moving to desired over some time period
	// we need to set this now to allow for an immediate SetFanSpeed() call to then change use back to some other speed
	FanSpeed_Curr = FanSpeed_Desired;

}


simulated function OnModifyFan( SeqAct_ModifyFan InAction )
{
	SetFanSpeed( InAction.FanSpeed, InAction.InterpSpeed );
}


simulated function Tick( float DeltaTime )
{
	local float CurrScaleZ;
	local float PlumeVisSpeed;
	//local LinearColor LinColor;

	if( PlumeScaleZGoal != 0.0f )
	{
		CurrScaleZ = FInterpTo( Plume.Scale3D.Z, PlumeScaleZGoal, DeltaTime, 3.0f );

		Plume.SetScale3D( 
			vect(1,0,0) * Plume.Scale3D.X 
			+ vect(0,1,0) * Plume.Scale3D.Y 
			+ vect(0,0,1) * CurrScaleZ
			);

		if( CurrScaleZ == PlumeScaleZGoal )
		{
			PlumeScaleZGoal = 0.0f;
			//`log( "Plume: We are done scaling!" @ PlumeScaleZGoal );
		}
	}

	if( PlumeBrightnessCurr != PlumeBrightnessGoal )
	{
		PlumeBrightnessCurr = FInterpTo( PlumeBrightnessCurr, PlumeBrightnessGoal, DeltaTime, 3.0f );
		//LinColor = MakeLinearColor(PlumeBrightnessCurr,PlumeBrightnessCurr,PlumeBrightnessCurr,1);
		MIC_PlumeSwirlPinged.SetScalarParameterValue( 'GhostMode', PlumeBrightnessCurr );
	}


	if( PlumeVisibilityGoal != PlumeVisibilityCurr )
	{
		if( PlumeVisibilityGoal > PlumeVisibilityCurr )
		{
			PlumeVisSpeed = 10.0f;
		}
		else
		{
			PlumeVisSpeed = 1.0f;
		}

		PlumeVisibilityCurr = FInterpTo( PlumeVisibilityCurr, PlumeVisibilityGoal, DeltaTime, PlumeVisSpeed );
		MIC_PlumeSwirlPinged.SetScalarParameterValue( 'VertOffset', PlumeVisibilityCurr );
		//`log( self @ `showvar(PlumeVisibilityCurr) );
	}

}


/** Called when the ping has affected this object.  The object should now do some sweet effects! **/
function DoPingEffects( bool bActiveReloadPing )
{
	//SavedPlumeScaleZ = Plume.Scale3D.Z; 
	//PlumeScaleZGoal = Plume.Scale3D.Z * 1.5f;
	//PlumeBrightness = 10.0f;

	PSC_PingEffect_Stream.ActivateSystem();
    PSC_PingEffect_Spread.ActivateSystem();

	SetTimer( class'NanoSkill_Ping'.default.DurationOfPingEffectsOnAffectedActors, FALSE, nameof(RestoreFromPingAffected) );
}

/** Helper function to fix up the effects from being affected by the ping **/
function RestoreFromPingAffected()
{
	//PlumeScaleZGoal = SavedPlumeScaleZ;
	//PlumeBrightness = 1.0f;

    PSC_PingEffect_Stream.DeactivateSystem();
	PSC_PingEffect_Spread.DeactivateSystem();
}

event bool GetBestTargetInDirection( vector InLocation, vector InVelocity, out Actor Target, out float FlightTime )
{
	local FanLaunchTargetInfo TargetInfo;
	local int BestIdx, i;
	local float TmpDot, BestDot;

	BestIdx = INDEX_NONE;
	InVelocity = Normal(InVelocity);

	// Iterate over the targets, finding the one best inline with our velocity
	for( i = 0; i < FanLaunchTargets.Length; i++ )
	{
		TargetInfo = FanLaunchTargets[i];
		if( TargetInfo.LaunchTarget != None )
		{
			TmpDot = InVelocity dot Normal(TargetInfo.LaunchTarget.Location - InLocation);
			if( TmpDot > BestDot || BestIdx == INDEX_NONE )
			{
				BestIdx = i;
				BestDot = TmpDot;
			}
		}
		else
		{
			`log(self@"has invalid FanLaunchTarget (index " $ i $ ")");
		}
	}

	if( BestIdx != INDEX_NONE )
	{
		// Found a target!
		Target = FanLaunchTargets[BestIdx].LaunchTarget;
		FlightTime = FanLaunchTargets[BestIdx].FlightTime;

		return TRUE;
	}
	else
	{
		// No targets...
		return FALSE;
	}
}


simulated event BoxSphereBounds GetTargetableBounds()
{
	return StaticMeshCollisionVolume.Bounds;
}


defaultproperties
{
	bCollideActors=TRUE
	bBlockActors=TRUE

   Begin Object Name=StaticMeshComponent0
        StaticMesh=StaticMesh'EditorMeshes.TexPropCube'
		CollideActors=FALSE
		BlockActors=FALSE
		BlockZeroExtent=FALSE
		BlockNonZeroExtent=FALSE
		BlockRigidBody=FALSE
		HiddenGame=TRUE
		HiddenEditor=TRUE
		AlwaysLoadOnClient=FALSE
		AlwaysLoadOnServer=FALSE
   End Object

   // Plume Material is: MaterialInstanceConstant'Nano_FX.Materials.M_Nano_TestAirSwirl_INST'
   // VertOffset in the material applied to the fan's exhaust mesh S_Proto_FanPlume can be set from -8 (very low to the fan effect), to 0 (makes it to the top of the shaft).   
	Begin Object Class=StaticMeshComponent Name=PlumeComp
		StaticMesh=StaticMesh'Effects_Fan.Meshes.S_Nano_ExhaustFan_03'
		//Rotation=(Roll=-16384,Yaw=-16384)
		Scale=1.0f
		bUsePrecomputedShadows=TRUE
		bAcceptsLights=FALSE
		CollideActors=FALSE
		CastShadow=FALSE
		bCastDynamicShadow=FALSE
		MaxDrawDistance=50000
	End Object
	Plume=PlumeComp
	Components.Add(PlumeComp)

	Begin Object Class=StaticMeshComponent Name=OuterMetalRingComp
		//Rotation=(Roll=-16384)
		Translation=(Y=0)
		Scale=1.0
		CollideActors=TRUE
		BlockActors=TRUE
		BlockZeroExtent=TRUE
		BlockNonZeroExtent=TRUE
		BlockRigidBody=TRUE
		bUsePrecomputedShadows=TRUE
		CastShadow=FALSE
		bCastDynamicShadow=FALSE
		MaxDrawDistance=50000 // too big for this probably
	End Object
	OuterMetalRing=OuterMetalRingComp
	Components.Add(OuterMetalRingComp)

	Begin Object Class=StaticMeshComponent Name=SpinningFanComp0
		Rotation=(Roll=-16384)
		//Translation=(Y=48)
		Scale3D=(X=0.06,Y=0.06,Z=0.06)
		CollideActors=FALSE
		CastShadow=FALSE
		bCastDynamicShadow=FALSE
		MaxDrawDistance=50000 // too big for this probably
	End Object
	FanBlades1=SpinningFanComp0
	Components.Add(SpinningFanComp0)


	Begin Object Class=StaticMeshComponent Name=StaticMeshCollisionVolumeComp
		StaticMesh=StaticMesh'Nano_Proto_Fan.SM.Mesh.S_Proto_FanCollisionCylinder'
		Scale3D=(X=1.25,Y=1.25,Z=1)
		bDisableAllRigidBody=TRUE
		CollideActors=TRUE
		BlockActors=FALSE
		BlockZeroExtent=TRUE
		BlockNonZeroExtent=TRUE
		BlockRigidBody=FALSE
		bAcceptsLights=FALSE
		CastShadow=FALSE
		bCastDynamicShadow=FALSE
		MaxDrawDistance=7000
		HiddenGame=TRUE
	End Object
	StaticMeshCollisionVolume=StaticMeshCollisionVolumeComp
	Components.Add(StaticMeshCollisionVolumeComp)

	FanVolumeScalar=1.25f
    ZoneVelocity=(X=0.0,Y=0.0,Z=24.0)
	HeightInStories=(X=1.0,Y=1.0,Z=1.0)

	FanSpeed_Curr=FS_Off
	FanSpeed_Desired=FS_FullHeight

	FanSpeedNumericalValues(FS_Off)=0
	FanSpeedNumericalValues(FS_HalfHeight)=600
	FanSpeedNumericalValues(FS_FullHeight)=2000
	FanSpeedNumericalValues(FS_DoubleHeight)=4000

	CurrFanPlumeHeightMultiplier=0.0f
	FanPlumeHeightMultipliers(FS_Off)=0.0f
	FanPlumeHeightMultipliers(FS_HalfHeight)=0.5f
	FanPlumeHeightMultipliers(FS_FullHeight)=1.0f
	FanPlumeHeightMultipliers(FS_DoubleHeight)=2.0f

	CurrFanBladePitchMultiplier=0.0f
	FanBladePitchMultipliers(FS_Off)=0.0f
	FanBladePitchMultipliers(FS_HalfHeight)=0.5f
	FanBladePitchMultipliers(FS_FullHeight)=1.0f
	FanBladePitchMultipliers(FS_DoubleHeight)=1.6f

	FanBladePitchName="FanBladePitch"
	FanBladeSpinSound=SoundCue'Ambient_Movers.Fan.Mono.Fan_BladeSpin_01Cue'  //This SoundCue has a Continuous Modulator node with PitchMin, PitchMax, VolumeMin, and VolumeMax parameter values all set to 0. This is how the Derrick SoundCue from Gears2 was set up.  PitchMultiplier of .5 will be good for Low speed, 1.0 for Medium Speed, and 1.6 for high Speed. 


// 	Begin Object Class=NanoParticleSystemComponent Name=PingEffectStreamComp
// 		Template=ParticleSystem'Nano_FX_Enviro.Effects.P_FX_Nano_Fanites_Stream' // Streamlife   use 600uus
// 		MaxDrawDistance=50000 // probably too much
// 		bAutoActivate=FALSE
// 	End Object
	//PSC_PingEffect_Stream=PingEffectStreamComp
	//Components.Add(PingEffectStreamComp);


// 	Begin Object Class=NanoParticleSystemComponent Name=PingEffectSpreadComp
// 		Template=ParticleSystem'Nano_FX_Enviro.Effects.P_FX_Nano_Fanites_Spread' // FanRadius
// 		MaxDrawDistance=50000 // probably too much
// 		bAutoActivate=FALSE
// 	End Object
	//PSC_PingEffect_Spread=PingEffectSpreadComp
	//Components.Add(PingEffectSpreadComp);

	bWorldGeometry=TRUE
}

