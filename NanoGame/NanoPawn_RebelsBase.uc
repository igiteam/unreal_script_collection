/**
 * Rebels pawn base class
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoPawn_RebelsBase extends NanoPawn_Infantry
	native(Pawn)
	abstract;

var transient NanoCrowd_PanicRepulsor CrowdPanicRepulsor;

/** Amount of blood on the pawn */
var transient float BloodAmount;

/** NanoSkill_Dense related items */
var(Dense) editinline SkeletalMeshComponent	DenseMesh;
var transient MaterialInstanceConstant MIC_DenseMesh;

/** MIC name to amke the dense mesh fade in and out **/
var name DenseMeshBlendName;

var transient float DenseMeshBlendGoal;
var transient float DenseMeshBlendCurr;

/** The cradel tendrils that we are on **/
var transient NanoSpline_CradleTendrilBase CurrCradleTendrilSpline;
var transient NanoSpline_CradleTendrilBase TargetCradleTendrilSpline;

/** How far "along" from the bottom to the top are we currently **/
var transient float CurrentCradleTendrilSplinePos;


/** How close we need to be to "latch" onto a tendril **/
var config float RadiusToCheckForCradleTendrils;


// TODO: maybe move these into the tendril class
var SoundCue TendrilStart;
var SoundCue TendrilLoop;
var transient AudioComponent AC_TendrilLoop;
var SoundCue TendrilDismount;

/** Make certain we only do one sound per slow down **/
var transient bool bDidSlowDown;
var SoundCue TendrilSlowDown;

/** Make certain we only do one sound per speed up **/
var transient bool bDidSpeedUp;
var SoundCue TendrilSpeedUp;

/** The effect that plays when the player is attached to a tendril **/
var ParticleSystem TendrilConnectionEffect;
var ParticleSystemComponent PSC_TendrilConnectionEffect;
var name CradleLocName;

var name HandForgeSocketName;

///////////// city scanning
/** Current CityScan target that we're locked on to, if any **/
var transient NanoTargetPoint_CityScanBase  CurrentScanTarget;
/** Current CityScan target acquisition time **/
var transient float CurrentScanTargetAcquisitionTime;
/** Current color of the border, used for proper blending **/
var transient LinearColor   CurrentScanBorderColor;
/** Color to turn the border when there is an active scan target **/
var() LinearColor   ScanTargetAquiredBorderColor;

/** Whether we were tuned into the target's signal last frame **/
var transient   bool    bScanTunedInLastFrame;

/** Time that the player tuned in to the current scan target's audio signal **/
var transient   float   CityScanTunedInTime;

/** TEMP:  Hack to calculate half angle of viewing screen.  Do this properly with bounds calculations in the future **/
var() Vector2D      TunerRadialBounds;

/** How many channels there are on the scanner (each channel is a different z depth on the scanning sphere) **/
const   TOTAL_CITYSCAN_AUDIO_CHANNELS	=   5;
/** Channel we are currently tuned to **/
var transient int   CurrentScanChannel;
/** Time that we switched channels **/
var transient float LastChannelSwitchTime;
/** Sound to play when selecting a new channel **/
var() SoundCue      CityScanChannelChangedSound;
/** Blend time for effects when switching channels **/
var() float         ChannelSwitchBlendTime;
/** Z-depth of a channel **/
var() float         CityScanChannelDepthOffset;
/** Current z-depth of the tuner **/
var transient float CurrentScanChannelDepth;

/** The spherical "view screen" mesh for the city scanning interface **/
var() StaticMesh    CityScanInterfaceMesh;
/** The vertical Y axis of the city scan tuner **/
var() StaticMesh    CityScanTunerVerticalAxis;
/** The horizontal X axis of the city scan tuner **/
var() StaticMesh    CityScanTunerHorizontalAxis;

/** Mesh for the signal you chase on the target **/
var() StaticMesh    CityScanSignalMesh;

/** Speed that the player can move the tuner around with the thumbstick **/
var() float         CityScanTunerSpeed;
/** 2D position of the scanner tuner, between 0.0 and 1.0 on each axis **/
var transient Vector2D  CityScanTunerPosition;

/** Color for scan channel that is currently tuned to **/
var() LinearColor   CityScanActiveChannelColor;
/** Color for scan channel that are not currently tuned to **/
var() LinearColor   CityScanInactiveChannelColor;
/** Color for scan channels that are not currently tuned to when the player is on the signal's proper channel **/
var() LinearColor   CityScanTunedInactiveChannelColor;

/** Since they are rarely needed, components for the above will be instanced and stored here **/
var transient   StaticMeshComponent     CityScanInterfaceComponent;
var transient   StaticMeshComponent     CityScanTunerVerticalAxisComponent;
var transient   StaticMeshComponent     CityScanTunerHorizontalAxisComponent;
var transient   StaticMeshComponent     CityScanSignalComponent;

var transient   MaterialInstanceConstant    CityScanInterfaceMIC;
var transient   MaterialInstanceConstant    CityScanTunerVerticalAxisMIC;
var transient   MaterialInstanceConstant    CityScanTunerHorizontalAxisMIC;

/** Names of the color params in the material for each channel, by channel index **/
var array<Name> ChannelColorParamNames;

/** Sound to play when the signal is acquired **/
var() SoundCue  CityScanSignalAcquired;
/** Sound to play when the signal is lost **/
var() SoundCue  CityScanSignalLost;
/** Ambient noise to play while city scanning **/
var() SoundCue  CityScanAmbient;

/** AudioComponents for the above effects, so we can volume them appropriately **/
var transient AudioComponent    AC_CSAmbient;
var transient AudioComponent    AC_CSSignalTuning;
var transient AudioComponent    AC_CSScanAudio;
var transient AudioComponent    AC_CSScanScrambledAudio;

/** If the payer is escaping, we don't want to shoot them in the back and kill them as that is not exciting. **/
var config float EscapingDamageMultiplier_Ranged;

/** If player just took a huge amount of damage then we don't want a burst of gun fire to instantly kill them as that is not exciting. **/
var config float JustTookMassiveDamageMultipler_Ranged;




/** Spawn repulsor to make pedestrians run away from my location */
simulated function CauseCrowdPanic()
{
	if(CrowdPanicRepulsor == None)
	{
		CrowdPanicRepulsor = Spawn(class'NanoGame.NanoCrowd_PanicRepulsor', self,,Location,Rotation,,TRUE);
	}
	else
	{
		CrowdPanicRepulsor.SetLocation(Location);
	}
	// CrowdPanicRepulsor.SetBase(self);
	
	// Panic will subside after some time
	CrowdPanicRepulsor.LifeSpan = 10.0;
}

/** Stop crowd from running away */
simulated function ClearCrowdPanic()
{
	if( CrowdPanicRepulsor != none )
	{
		CrowdPanicRepulsor.Destroy();
		CrowdPanicRepulsor = None;
	}
}


event TakeDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	local int ModifiedDamage;

	ModifiedDamage = Damage;

	if( ( ModifiedDamage > 0 )
		&& ( ClassIsChildOf( DamageType, class'NDT_Melee') == FALSE )
		)
	{
		if( NanoGRI(WorldInfo.GRI).NED.IsPlayerDoing( 'Escaping') == TRUE )
		{
			ModifiedDamage *= EscapingDamageMultiplier_Ranged;
		}
		else if( JustTookMassiveDamage_Accumulator > (DefaultHealth * JustTookMassiveDamage_PercentOfHealth) )
		{
			ModifiedDamage *= JustTookMassiveDamageMultipler_Ranged;
		}
	}
	

	Super.TakeDamage(ModifiedDamage,InstigatedBy,HitLocation,Momentum,DamageType,HitInfo,DamageCauser);

	// so if we took damage and it was melee
	if( ( Damage > 0 )
		&& ( ClassIsChildOf( DamageType, class'NDT_Melee') == TRUE )
		)
	{
		NanoGRI(WorldInfo.GRI).AIBlackboard.PlayerWasDamagedByMelee();
	}

	if( Damage > 0 )
	{
		JustTookMassiveDamage_Accumulator += Damage;
		JustTookMassiveDamage_Time = WorldInfo.TimeSeconds;

		// so since we attacked immediately go ahead and reset to allow them to build up again
		NanoGRI(WorldInfo.GRI).AIBlackboard.ResetCombatEffectors();
	}
}




simulated event Tick(float DeltaTime)
{
	local NanoVolume_ChaosZone CZ;

	Super.Tick(DeltaTime);

	CZ = GetChaosZone();
	// At or above tier 2, civilians are always afraid of you
	if( ( CZ != none ) && ( CZ.MyNanoChaosZoneInfo != none ) )
	{
		if( CZ.MyNanoChaosZoneInfo.ChaosManager.GetChaosTier() >= ECT_Tier2 )
		{
			CauseCrowdPanic();
		}
	}

	if( BloodAmount > 0 )
	{
		if( (Role == ROLE_Authority && !NanoPC(Controller).IsInCombat())        // On the server, check the controller, which does a more thorough check and updates bIsInCombat
			|| (Role < ROLE_Authority && !bIsInCombat) )                        // On clients, use the cached replicated version from the server
		{
			RemoveSomeBlood( DeltaTime );
		}
	}

	if( ( DenseMeshBlendCurr != DenseMeshBlendGoal ) && ( MIC_DenseMesh != None ) )
	{
		DenseMeshBlendCurr = FInterpTo( DenseMeshBlendCurr, DenseMeshBlendGoal, DeltaTime, 3 );

		//`log( `showvar(DenseMeshBlendCurr) @ `showvar(DenseMeshBlendCurr) );

		MIC_DenseMesh.SetScalarParameterValue( DenseMeshBlendName, DenseMeshBlendCurr );
	}


	// if we have not taken massive damage inside our window then reset
	if( `TimeSince(JustTookMassiveDamage_Time) > JustTookMassiveDamage_Window )
	{
		JustTookMassiveDamage_Accumulator = 0;
	}

}

/** Util to see if we are in a cooldown volume. */
simulated function bool IsInChaosCooldownVolume()
{
	local int i;

	// Look over all things we are touching, to find a cooldown vol
	for(i=0; i<Touching.length; i++)
	{
		if( NanoVolume_ChaosCooldown(Touching[i]) != None )
		{
			// found one! return TRUE
			return TRUE;
		}
	}

	return FALSE;
}


/** Util to see if we are in a ChaosEventsDoNothing volume. */
simulated function bool IsInChaosEventsDoNothingVolume()
{
	local int i;

	// Look over all things we are touching, to find a cooldown vol
	for(i=0; i<Touching.length; i++)
	{
		if(NanoVolume_ChaosEventsDoNothing(Touching[i]) != None )
		{
			// found one! return TRUE
			return TRUE;
		}
	}

	return FALSE;
}


/** Sets misc. materials for activated nano powers */
simulated function SetNanoPowerMaterials(MaterialInstanceConstant ScarfMaterial, MaterialInstanceConstant HandForgerMaterial);

/** Restores materials after nano power is deactivated */
simulated function RestoreDefaultNanoPowerMaterials();

/** Allows HUD to eat input, e.g. if in-game menu is up */
simulated function bool CradleSurfingFilterButtonInput( Name ButtonName, bool bPressed, int ButtonIdx )
{
	local NanoSpline_CradleTendrilBase ClosestCradleTendril;

	// so for this we are going to check the thumbsticks, X, A

	if( bPressed )
	{
		switch( ButtonName )
		{
			// X will drop on/off the spline
		case 'X':
			ClosestCradleTendril = FindClosestFacingCradleTendril();
			if( ( ClosestCradleTendril != none ) && ( CurrCradleTendrilSpline != ClosestCradleTendril ) )
			{
				CurrCradleTendrilSpline = ClosestCradleTendril;
				TargetCradleTendrilSpline = NanoSpline_CradleTendrilBase(CurrCradleTendrilSpline.GetRandomConnection());
				// let's attach our self and start surfing!!
				GotoState( 'CradleSurfing' );
				return TRUE;
			}
			break;

		default:
			break;
		}
	}

	return FALSE;
}


simulated function NanoSpline_CradleTendrilBase FindClosestFacingCradleTendril()
{
    local NanoSpline_CradleTendrilBase NSCT;

	foreach CollidingActors( class'NanoSpline_CradleTendrilBase', NSCT, RadiusToCheckForCradleTendrils, Location )
	{
		// facing
		if( ( NSCT.bMountPoint == TRUE ) && ( Controller.IsAimingAt( NSCT, 0.90f ) == TRUE ) )
		{
			//`log( NSCT @ NSCT.Location Dot vector(Rotation) );

			return NSCT;
		}
	}

	return None;
}

event NanoSpline_CradleTendrilBase FindBestConnectedSpline( bool bLookRight, bool bLookLeft )
{
	local Vector LocalDesiredDir;
	local Vector WorldDesiredDir;


	LocalDesiredDir = vect(1,0,0); // default to straight

	if( bLookRight == TRUE )
	{
		LocalDesiredDir = vect(0,1,0);
	}
	else if( bLookLeft == TRUE )
	{
		LocalDesiredDir = vect(0,-1,0);
	}

	// Transform into world space
	WorldDesiredDir = LocalDesiredDir >> Rotation;


	// Then use function to choose best direction
	return NanoSpline_CradleTendrilBase(CurrCradleTendrilSpline.GetBestConnectionInDirection( WorldDesiredDir ));
}




event NanoSpline_CradleTendrilBase FindAdjacentTendril( bool bLookRight )
{
	local NanoPC PC;
	local Vector Loc;
	local Rotator Rot;
	local vector FaceDir;
	local vector TowardsSpline;
    local NanoSpline_CradleTendrilBase NSCT;
	local vector FacingVec;

	PC = NanoPC(Controller);

	// grab camera location/rotation
	PC.GetPlayerViewPoint( Loc, Rot );

	FaceDir = vector(Rot);

	foreach CollidingActors( class'NanoSpline_CradleTendrilBase', NSCT, RadiusToCheckForCradleTendrils, Location )
	{
		TowardsSpline = Normal(NSCT.Location - Loc);

		// check left/right/ahead
		if( (TowardsSpline dot vector(Rot)) < 0.94f ) // ~20 degree cone
		{
			// figure out left or right
			FacingVec = FaceDir cross vect(0,0,1);
			// left
			if( ( (FacingVec dot TowardsSpline) > 0.0f ) && ( bLookRight == FALSE ) )
			{
				//`log( "left" );
				return NSCT;
			}
			// right
			else
			{
				//`log( "right" );
				return NSCT;
			}
		}
		// ahead
		else
		{
			//`log( "ahead" );
		}

	}


	return None;
}


/** This even will be fired when we reach the end of the tendril we are surfing on **/
event ReachedEndOfCradleTendril();


// this will be our state for when we are on the cradle tendrils surfing them

simulated state CradleSurfing
{
	simulated function BeginState( Name PreviousStateName )
	{
		Super.BeginState( PreviousStateName );

		PlaySound( TendrilStart );

		AC_TendrilLoop = new(self) class'AudioComponent';
		if( AC_TendrilLoop != none )
		{
			AC_TendrilLoop.SoundCue = TendrilLoop;
			AC_TendrilLoop.FadeIn( 1.0f, 1.0f );
			AttachComponent( AC_TendrilLoop );
		}

    	PSC_TendrilConnectionEffect = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment( TendrilConnectionEffect, Mesh, HandForgeSocketName, TRUE );

		PreAimFullBodySlot.PlayCustomAnim( 'NW_CradleSurf_Idle', 1.0f, 0.1f, 0.1f, TRUE, TRUE );

		// prob turn off collision here
	}

	simulated function EndState( Name NextStateName )
	{
		Super.EndState( NextStateName );

		if( AC_TendrilLoop != none )
		{
			AC_TendrilLoop.FadeOut( 0.5f, 0.0f );
			AC_TendrilLoop = none;
		}

		PlaySound( TendrilDismount );
		PSC_TendrilConnectionEffect.DeactivateSystem();
		PSC_TendrilConnectionEffect = none;

		CurrCradleTendrilSpline = none;
		TargetCradleTendrilSpline = none;

		PreAimFullBodySlot.StopCustomAnim( 0.1f );

		// restore state
	}

	simulated function Tick( float DeltaTime )
	{
		local NanoPC PC;

		//local SplineComponent CurrentSplineComp;
		//local float Dist, DistFromEndOfCurrentSpline;
		//local vector DirectionToNextSplinePoint;

		Super.Tick( DeltaTime );

		PC = NanoPC(Controller);

		// look left and right and then pass into the thing below

		// this will take our current location and then ask the spline we are connected to for where we are to go next
		// and then this will move us there!
		//`log( "we are cradle surfing!!" @ CurrCradleTendrilSpline @ CurrentCradleTendrilSplinePos );

		MoveAlongSpline( DeltaTime, PC.PlayerInput.RawJoyUp, PC.PlayerInput.RawJoyRight, FALSE );

/*
		// thumbstick forward goes faster
		if( PC.PlayerInput.RawJoyUp > 0.5 )
		{
			`log( " speed up!" );
		}
		else if( PC.PlayerInput.RawJoyUp < -0.5 )
		{
			`log( " slow down!" );
		}
		// thumbstick back goes slower

		// thumstick right/left allows you to change splines at branches

		SetPhysics( PHYS_Falling );

		CurrentSplineComp = CurrCradleTendrilSpline.FindSplineComponentTo( TargetCradleTendrilSpline );
		DistFromEndOfCurrentSpline = CurrCradleTendrilSpline.GetSplineLength() - CurrentCradleTendrilSplinePos;


		if( CurrCradleTendrilSpline )
		{
			DirectionToNextSplinePoint = Location - 
				Acceleration = CradleTendrilSurfSpeed * DirectionToNextSplinePoint;
		}
*/
	}

	event ReachedEndOfCradleTendril()
	{
		local NanoSkill_Jump JumpSkill;

		JumpSkill = GetSkill(class'NanoSkill_Jump');	

		if( JumpSkill != none )
		{
			`log( "End of the spline.  Giving Jump Velocity Air Boost" );
			JumpSkill.PawnOwner = self;
			JumpSkill.ApplyJumpVelocity( JumpSkill.GetMaxJumpLevel( self ), FALSE, FALSE, vect(0,0,0), TRUE,vect(0,0,0) );
		}

		GotoState( '' );  // leave this state
	}


	simulated function bool CradleSurfingFilterButtonInput( Name ButtonName, bool bPressed, int ButtonIdx )
	{
		if( bPressed )
		{
			switch( ButtonName )
			{
			// X will drop on/off the spline
			case 'X':
				CurrCradleTendrilSpline = None;
				GotoState( '' ); // leave this state
				break;

				// A will do a jump at the speed we are currently going (need to check to see how the new speed shizzle works)
			case 'A':
				CurrCradleTendrilSpline = None;
				GotoState( '' ); // leave this state
				break;
			
			default:
				break;
			}
		}

		return FALSE;
	}

	/**
	 * We override here as this is used to determine if the screen goes white due to falling damage possibility
	 * @see NanoPawn.Tick()
 	 **/
	simulated function float GetFallingZImpactBasedOnJumpSkill()
	{
		return 0.0f;
	}


}


/** This will do the actual moving of the player along the spline. **/
native function MoveAlongSpline( float DeltaTime, float InRawJoyUp, float InRawJoyRight, bool bRightSide );


simulated function bool CityScanningFilterButtonInput( Name ButtonName, bool bPressed, int ButtonIdx )
{
	// If the player presses X while on a valid scanning perch point, then enter city scanning mode
	if( bPressed && ButtonName == 'X')
	{
		if( CanCityScan() )
		{
			GotoState('CityScanning');
			return TRUE;
		}
	}

	return FALSE;
}

simulated function bool CanCityScan()
{
	local NanoPerchPoint    NPP;

	// Make sure we're perching on a perch point that supports city scanning
	if( PerchingMode == ENPM_PerchPoint )
	{
		NPP = NanoPerchPoint(Base);
		if( NPP != None && NPP.bCityScanPoint )
		{
			return TRUE;
		}
	}
	
	return FALSE;
}

/** Called when the audio from a city scan target has completed play **/
function OnScanAudioFinished(AudioComponent AC);

simulated state CityScanning
{
	simulated function BeginState( Name PreviousStateName )
	{
		local NanoTargetPoint_CityScanBase ScanTarget;

		Super.BeginState(PreviousStateName);

		// Set up the city scan mesh and materials
		CityScanInterfaceComponent = CreateCityScannerMeshComponent(CityScanInterfaceMesh);
		CityScanTunerVerticalAxisComponent = CreateCityScannerMeshComponent(CityScanTunerVerticalAxis);
		CityScanTunerHorizontalAxisComponent = CreateCityScannerMeshComponent(CityScanTunerHorizontalAxis);
		CityScanSignalComponent = CreateCityScannerMeshComponent(CityScanSignalMesh);

		CityScanInterfaceMIC = CityScanInterfaceComponent.CreateAndSetMaterialInstanceConstant(0);
		CityScanTunerVerticalAxisMIC = CityScanTunerVerticalAxisComponent.CreateAndSetMaterialInstanceConstant(0);
		CityScanTunerHorizontalAxisMIC = CityScanTunerHorizontalAxisComponent.CreateAndSetMaterialInstanceConstant(0);
		CityScanSignalComponent.SetMaterial(0, Material'Nano_ProtoHUD_Ingame.M_HUD_Ingame_CityScanSignal');
		CityScanSignalComponent.SetScale(0.1f);

		// Set up the audio components for tuning and ambiance
		AC_CSAmbient = new(self) class'AudioComponent';
		if( AC_CSAmbient != None && CityScanAmbient != None)
		{
			AttachComponent(AC_CSAmbient);
			AC_CSAmbient.SoundCue = CityScanAmbient;
			AC_CSAmbient.FadeIn(0.25f, 1.f);
		}

		AC_CSSignalTuning = new(self) class'AudioComponent';
		if( AC_CSSignalTuning != None )
		{
			AttachComponent(AC_CSSignalTuning);
		}

		AC_CSScanAudio = new(self) class'AudioComponent';
		if( AC_CSScanAudio != None )
		{
			AttachComponent(AC_CSScanAudio);
		}

		AC_CSScanScrambledAudio = new(self) class'AudioComponent';
		if( AC_CSScanScrambledAudio != None )
		{
			AttachComponent(AC_CSScanScrambledAudio);
		}

		// Reset the scanner position back to the center
		CityScanTunerPosition = vect2d(0.5f, 0.5f);
		bScanTunedInLastFrame = FALSE;

		// Reset target and channel info
		CurrentScanTarget = None;
		CurrentScanChannel = 0;
		CurrentScanChannelDepth = 256.f;

		// Reveal all the scan nodes
		foreach NanoGRI(WorldInfo.GRI).CityScanTargets(ScanTarget)
		{
			ScanTarget.SetHidden(FALSE);
		}

		ClientMessage("Entered city scanning...");
	}

	/** Used to initialize and attach all the scanner mesh components properly **/
	simulated function StaticMeshComponent CreateCityScannerMeshComponent( StaticMesh MeshToSet )
	{
		local StaticMeshComponent RetVal;

		RetVal =  new(self) class'StaticMeshComponent';

		if( RetVal != None )
		{
			RetVal.SetStaticMesh(MeshToSet);
			RetVal.bCastDynamicShadow = FALSE;
			RetVal.bUseAsOccluder = FALSE;
			RetVal.SetTraceBlocking(FALSE, FALSE);

			AttachComponent(RetVal);
		}

		return RetVal;
	}

	simulated function EndState( Name NextStateName )
	{
		local NanoTargetPoint_CityScanBase ScanTarget;

		Super.EndState(NextStateName);

		// Tear down the city scan mesh
		if( CityScanInterfaceComponent != None )
		{
			DetachComponent(CityScanInterfaceComponent);
			CityScanInterfaceComponent = None;
			CityScanInterfaceMIC = None;
		}
		if( CityScanTunerVerticalAxisComponent != None )
		{
			DetachComponent(CityScanTunerVerticalAxisComponent);
			CityScanTunerVerticalAxisComponent = None;
			CityScanTunerVerticalAxisMIC = None;
		}
		if( CityScanTunerHorizontalAxisComponent != None )
		{
			DetachComponent(CityScanTunerHorizontalAxisComponent);
			CityScanTunerHorizontalAxisComponent = None;
			CityScanTunerHorizontalAxisMIC = None;
		}
		if( CityScanSignalMesh != None )
		{
			DetachComponent(CityScanSignalComponent);
			CityScanSignalComponent = None;
		}

		// Audio components
		if( AC_CSAmbient != None )
		{
			AC_CSAmbient.FadeOut(0.25f, 0.f);
			DetachComponent(AC_CSAmbient);
			AC_CSAmbient = None;
		}
		if( AC_CSSignalTuning != None )
		{
			AC_CSSignalTuning.FadeOut(0.25f, 0.f);
			DetachComponent(AC_CSSignalTuning);
			AC_CSSignalTuning = None;
		}
		if( AC_CSScanAudio != None )
		{
			AC_CSScanAudio.FadeOut(0.25f, 0.f);
			DetachComponent(AC_CSScanAudio);
			AC_CSScanAudio = None;
		}
		if( AC_CSScanScrambledAudio != None )
		{
			AC_CSScanScrambledAudio.FadeOut(0.25f, 0.f);
			DetachComponent(AC_CSScanScrambledAudio);
			AC_CSScanScrambledAudio = None;
		}

		// Hide all the scan targets
		foreach NanoGRI(WorldInfo.GRI).CityScanTargets(ScanTarget)
		{
			ScanTarget.SetHidden(TRUE);
		}

		ClientMessage("Leaving city scanning...");
	}

	simulated function Tick( float DeltaTime )
	{
		local NanoTargetPoint_CityScanBase ScanTarget;
		local NanoPC NPC;
		local NanoGRI NGRI;
		local vector CameraLoc;
		local rotator CameraRot;
		local float BlendPercent, TunedPercentage;
		local int i;
		local bool bTunedToCorrectChannel;

		Super.Tick(DeltaTime);

		NPC = NanoPC(Controller);

		// Update the tuner positions based on the player's input
		CityScanTunerPosition.X = FClamp(CityScanTunerPosition.X + NPC.PlayerInput.RawJoyRight * CityScanTunerSpeed, 0.f, 1.f);
		CityScanTunerPosition.Y = FClamp(CityScanTunerPosition.Y + NPC.PlayerInput.RawJoyUp * CityScanTunerSpeed, 0.f, 1.f);

		// Get the current camera position
		NPC.GetPlayerViewPoint(CameraLoc, CameraRot);
		AdjustCityScannerMeshesToCamera(CameraLoc, CameraRot);

		// Scan target acquisition
		if( CurrentScanTarget != None )
		{
			// Align the active target to the pawn
			CurrentScanTarget.AlignScanTargetToPawn(CameraLoc);

			// Make sure we can still tune to this audio source
			if( !CurrentScanTarget.PlayerAbleToTune(CameraLoc, Vector(CameraRot)) )
			{
				// Deactivate the scan target
				CurrentScanTarget.TargetDeactivated();

				CurrentScanTarget = None;
				CurrentScanTargetAcquisitionTime = WorldInfo.TimeSeconds;

				// Fade the ambient audio back up to normal
				if( AC_CSAmbient != None )
				{
					AC_CSAmbient.AdjustVolume(0.25f, 1.f);
				}
			}
			// If we can, update the audio signal position
			else
			{
				CurrentScanTarget.UpdateSignalPosition(DeltaTime);
			}
		}
		else
		{
			NGRI = NanoGRI(WorldInfo.GRI);
			foreach NGRI.CityScanTargets(ScanTarget)
			{
				// Align all the scan targets to the pawn's location
				// Note:  We do this in here, assuming that most of the time, if the player isn't scanning for new targets, they won't notice the minute errors on those targets they're not tuned into
				ScanTarget.AlignScanTargetToPawn(CameraLoc);

				// Determine if we're in range of any scan targets
				if( ScanTarget.PlayerAbleToTune(CameraLoc, Vector(CameraRot)) )
				{
					// Found a valid target!
					CurrentScanTarget = ScanTarget;
					CurrentScanTargetAcquisitionTime = WorldInfo.TimeSeconds;

					CurrentScanTarget.TargetActivated();

					bScanTunedInLastFrame = FALSE;

					// Fade the ambient audio down so we can listen to the tuner and the scan audio
					if( AC_CSAmbient != None )
					{
						AC_CSAmbient.AdjustVolume(0.25f, 0.65f);
					}
					break;
				}
			}
		}
		
		// Update the border to reflect whether or not we have a scan target
		if( `TimeSince(CurrentScanTargetAcquisitionTime) <= ChannelSwitchBlendTime )
		{
			// Determine the percent fade of the border
			BlendPercent = `TimeSince(CurrentScanTargetAcquisitionTime) / ChannelSwitchBlendTime;

			// Blend in or out, depending on if we have a target
			if( CurrentScanTarget != None )
			{
				CurrentScanBorderColor.R = Lerp(0.f, ScanTargetAquiredBorderColor.R, BlendPercent);
				CurrentScanBorderColor.G = Lerp(0.f, ScanTargetAquiredBorderColor.G, BlendPercent);
				CurrentScanBorderColor.B = Lerp(0.f, ScanTargetAquiredBorderColor.B, BlendPercent);
				CurrentScanBorderColor.A = Lerp(0.f, ScanTargetAquiredBorderColor.A, BlendPercent);
			}
			else
			{
				CurrentScanBorderColor.R = Lerp(ScanTargetAquiredBorderColor.R, 0.f, BlendPercent);
				CurrentScanBorderColor.G = Lerp(ScanTargetAquiredBorderColor.G, 0.f, BlendPercent);
				CurrentScanBorderColor.B = Lerp(ScanTargetAquiredBorderColor.B, 0.f, BlendPercent);
				CurrentScanBorderColor.A = Lerp(ScanTargetAquiredBorderColor.A, 0.f, BlendPercent);
			}

			// Set the border to the new color
			CityScanInterfaceMIC.SetVectorParameterValue('BorderColor', CurrentScanBorderColor);
		}

		// Update the channel materials to reflect the state of the scanner
		bTunedToCorrectChannel = (CurrentScanTarget != None) && ( CurrentScanChannel == CurrentScanTarget.ScanAudioChannel);
		for( i = 0; i < TOTAL_CITYSCAN_AUDIO_CHANNELS; i++ )
		{
			if( i == CurrentScanChannel )
			{
				CityScanInterfaceMIC.SetVectorParameterValue(ChannelColorParamNames[i], CityScanActiveChannelColor);
			}
			else
			{
				if( bTunedToCorrectChannel )
				{
					CityScanInterfaceMIC.SetVectorParameterValue(ChannelColorParamNames[i], CityScanTunedInactiveChannelColor);
				}
				else
				{
					CityScanInterfaceMIC.SetVectorParameterValue(ChannelColorParamNames[i], CityScanInactiveChannelColor);
				}
			}
		}

		// Check to see if we're successfully tuned to the target
		if( CurrentScanTarget != None )
		{
			if( CurrentScanTarget.IsPlayerTuned(CityScanTunerPosition, CurrentScanChannel, TunedPercentage) )
			{
				// If we're just tuning in...
				if( !bScanTunedInLastFrame )
				{
					// Play the static tuning in sound
					if( AC_CSSignalTuning != None && CityScanSignalAcquired != None )
					{
						AC_CSSignalTuning.SoundCue = CityScanSignalAcquired;
						AC_CSSignalTuning.FadeIn(0.1f, 1.f);
					}

					// Play the scan target audio
					if( AC_CSScanAudio != None )
					{
						AC_CSScanAudio.SoundCue = CurrentScanTarget.ScanAudio;
						AC_CSScanAudio.FadeIn(0.25f, 1.f);

						// Set the delegate to fire off when this scan audio ends
						AC_CSScanAudio.OnAudioFinished = OnScanAudioFinished;
					}
					if( AC_CSScanScrambledAudio != None )
					{
						AC_CSScanScrambledAudio.SoundCue = CurrentScanTarget.ScanScrambledAudio;
						AC_CSScanScrambledAudio.FadeIn(0.25, 1.f);
					}

					// Record the time that we tuned in the signal
					CityScanTunedInTime = WorldInfo.TimeSeconds;
				}
				// We're already tuned in, so adjust the relative volumes of the scrambled signal and the regular signal
				else if( AC_CSScanAudio != None && AC_CSScanScrambledAudio != None)
				{
					AC_CSScanAudio.AdjustVolume(0.f, TunedPercentage);
					AC_CSScanScrambledAudio.AdjustVolume(0.f, 1.f - TunedPercentage);
				}

				bScanTunedInLastFrame = TRUE;
			}
			else
			{
				// Lost the signal...
				if( bScanTunedInLastFrame )
				{
					// Play the signal lost sound
					if( AC_CSSignalTuning != None && CityScanSignalLost != None )
					{
						AC_CSSignalTuning.SoundCue = CityScanSignalLost;
						AC_CSSignalTuning.FadeIn(0.1f, 1.f);
					}

					// Fade out the scan audio signal
					if( AC_CSScanAudio != None )
					{
						AC_CSScanAudio.FadeOut(0.25f, 0.f);
					}
					if( AC_CSScanScrambledAudio != None )
					{
						AC_CSScanScrambledAudio.FadeOut(0.25, 0.f);
					}
				}

				bScanTunedInLastFrame = FALSE;
			}
		}
		else
		{
			if( bScanTunedInLastFrame )
			{
				// Fade out the scan audio signal, if playing
				if( AC_CSScanAudio != None )
				{
					AC_CSScanAudio.FadeOut(0.25f, 0.f);
				}
				if( AC_CSScanScrambledAudio != None )
				{
					AC_CSScanScrambledAudio.FadeOut(0.25, 0.f);
				}
			}

			bScanTunedInLastFrame = FALSE;
		}
	}

	simulated function AdjustCityScannerMeshesToCamera( vector CameraLoc, rotator CameraRot )
	{
		local vector RelLoc, AxisLoc;
		local rotator RelRot;
		local float ChannelBlendPercent, BoundaryScale, SignalChannelDepth;
		local int   YawAdjustment;
		
		// --- City Scanner Interface Mesh -----------------------------------------------
 		// Add in the offset from the camera, translated into CameraSpace
 		AxisLoc = CameraLoc + (vect(256.f,0.f,0.f) >> CameraRot);
 		RelLoc = (AxisLoc - Location) << Rotation;
 
 		// Temp:  Art was created y-aligned, so kick it back to x-aligned
 		RelRot = rot(0,16384,0);
 		RelRot.Roll = CameraRot.Pitch;
 
 		// Align the meshes to the camera, relative to the pawn
 		CityScanInterfaceComponent.SetRotation(RelRot);
 		CityScanInterfaceComponent.SetTranslation(RelLoc);
 
		// Blend the depth of the axes based on channel depth and blend time
 		ChannelBlendPercent = FClamp(`TimeSince(LastChannelSwitchTime) / ChannelSwitchBlendTime, 0.f, 1.f);
		CurrentScanChannelDepth = FInterpEaseInOut(CurrentScanChannelDepth, 256.f + (CurrentScanChannel * CityScanChannelDepthOffset), ChannelBlendPercent, 2.f);

		BoundaryScale = 256.0f / CurrentScanChannelDepth;
 		
		// --- Vertical Axis Mesh --------------------------------------------------------
		// Align the vertical axis to the angle of the cylindrical screen
		YawAdjustment = BoundaryScale * TunerRadialBounds.X*(CityScanTunerPosition.X - 0.5f);
		AxisLoc = vect(0.f,0.f,0.f);
		AxisLoc.X = CurrentScanChannelDepth;
 		AxisLoc = AxisLoc >> MakeRotator(0, YawAdjustment, 0);
 		AxisLoc = AxisLoc >> CameraRot;
 		AxisLoc += CameraLoc;
 		RelLoc = (AxisLoc - Location) << Rotation;

		// Rotate the local space rotation into the pawn's space
		RelRot = rot(0,16384,0);
		RelRot.Yaw  += YawAdjustment;
		RelRot = QuatToRotator( QuatProduct(QuatFromRotator(CameraRot), QuatFromRotator(RelRot)) );
		RelRot -= Rotation;
		
 		CityScanTunerVerticalAxisComponent.SetRotation(RelRot);
 		CityScanTunerVerticalAxisComponent.SetTranslation(RelLoc);
 
		// --- Horizontal Axis Mesh ------------------------------------------------------
 		// Translate the horizontal axis up and down the cylindrical screen
		AxisLoc = vect(0.f,0.f,0.f);
		AxisLoc.X = CurrentScanChannelDepth;
 		AxisLoc.Z += TunerRadialBounds.Y*(CityScanTunerPosition.Y - 0.5f);
 		AxisLoc = CameraLoc + (AxisLoc >> CameraRot);
 		RelLoc = (AxisLoc - Location) << Rotation;
 		
 		RelRot = rot(0,16384,0);
 		RelRot.Roll = CameraRot.Pitch;

 		CityScanTunerHorizontalAxisComponent.SetRotation(RelRot);
 		CityScanTunerHorizontalAxisComponent.SetTranslation(RelLoc);

		// --- Signal Mesh ---------------------------------------------------------------
		if( CurrentScanTarget != None )
		{
			CityScanSignalComponent.SetHidden(FALSE);

			SignalChannelDepth = 256.f + (CurrentScanTarget.ScanAudioChannel * CityScanChannelDepthOffset);
			BoundaryScale = 256.f / SignalChannelDepth;
			YawAdjustment = BoundaryScale * TunerRadialBounds.X*(CurrentScanTarget.ScanAudioPosition.X - 0.5f);
			
			AxisLoc = vect(0.f,0.f,0.f);
			AxisLoc.X = SignalChannelDepth;
			AxisLoc.Z += TunerRadialBounds.Y*(CurrentScanTarget.ScanAudioPosition.Y - 0.5f);
			AxisLoc = AxisLoc >> MakeRotator(0, YawAdjustment, 0);
 			AxisLoc = AxisLoc >> CameraRot;
 			AxisLoc += CameraLoc;
 			RelLoc = (AxisLoc - Location) << Rotation;

			// Rotate the local space rotation into the pawn's space
			RelRot = rot(0,0,0);
			RelRot.Yaw  += YawAdjustment;
			RelRot = QuatToRotator( QuatProduct(QuatFromRotator(CameraRot), QuatFromRotator(RelRot)) );
			RelRot -= Rotation;

			CityScanSignalComponent.SetRotation(RelRot);
			CityScanSignalComponent.SetTranslation(RelLoc);
		}
		else
		{
			CityScanSignalComponent.SetHidden(TRUE);
		}
		
	}

	simulated function bool CityScanningFilterButtonInput( Name ButtonName, bool bPressed, int ButtonIdx )
	{
		if( bPressed )
		{
			switch(ButtonName)
			{
			//  Exit city scanning mode
			case 'X':
			case 'A':
				GotoState('');
				break;
			//  Tune the active channel up
			case 'L2':
				ChangeCityScanChannel(TRUE);
				break;
			//  Tune the active channel down
			case 'R2':
				ChangeCityScanChannel(FALSE);
				break;
			default:
				break;
			}

			// Unless the player hit start or tried to jump, eat the input
			if( ButtonName != 'Start' && ButtonName != 'A' )
			{
				return TRUE;
			}
		}

		return FALSE;
	}

	/** Handles changing the city scan channel, and playing any effects only if a new channel is selected **/
	simulated function ChangeCityScanChannel( bool bTuneUp )
	{
		if( bTuneUp )
		{
			CurrentScanChannel++;
		}
		else
		{
			CurrentScanChannel--;
		}

		// If we've tuned to a valid channel, play the effects
		if( (CurrentScanChannel >= 0) && (CurrentScanChannel <= TOTAL_CITYSCAN_AUDIO_CHANNELS-1) )
		{
			if( CityScanChannelChangedSound != None )
			{
				PlaySound(CityScanChannelChangedSound);
			}
			
			LastChannelSwitchTime = WorldInfo.TimeSeconds;
		}
		// Otherwise, clamp the channel selection back into the valid range
		else
		{
			CurrentScanChannel = Clamp(CurrentScanChannel, 0, TOTAL_CITYSCAN_AUDIO_CHANNELS-1);
		}
	}

	function OnScanAudioFinished(AudioComponent AC)
	{
		if( CurrentScanTarget != None && AC_CSScanAudio.SoundCue != None )
		{
			// Player has successfully listened to the whole broadcast
			if( `TimeSince(CityScanTunedInTime) >= AC_CSScanAudio.SoundCue.GetCueDuration() )
			{
				ClientMessage("[Scan Complete for Target]");

				CurrentScanTarget.ScanCompleted(self);
				CurrentScanTarget = None;

				// Reset the blend time here so the effects blend out properly
				CurrentScanTargetAcquisitionTime = WorldInfo.TimeSeconds;
			}
		}
	}
};


function int GetDefaultHealth()
{
	local NanoSkill_Health TheSkill;

	TheSkill = GetSkill(class'NanoSkill_Health');
	if( TheSkill != None )
	{
		return DefaultHealth * TheSkill.GetHealthMutliplier( self );
	}

	return DefaultHealth;
}


function int GetDefaultStartinNanoPowerBuckets()
{
	local NanoSkill_NanoBuckets TheSkill;

	TheSkill = GetSkill(class'NanoSkill_NanoBuckets');
	if( TheSkill != None )
	{
		return default.NumOfNanoPowerBuckets * TheSkill.GetNanoBucketMutliplier( self );
	}

	return default.NumOfNanoPowerBuckets;
}


function int GetDefaultStartinNanoPowerForgeCoreBuckets()
{
	local NanoSkill_NanoBuckets TheSkill;

	TheSkill = GetSkill(class'NanoSkill_NanoBuckets');
	if( TheSkill != None )
	{
		return default.NumOfNanoPowerForgeCoreBuckets * TheSkill.GetNanoBucketMutliplier( self );
	}

	return default.NumOfNanoPowerForgeCoreBuckets;
}




defaultproperties
{
	bCanPerformTackle=FALSE

	TendrilStart=SoundCue'Gameplay_Audio.CradleSurf.CradleSurf_Start_Stereo_01Cue'

	TendrilLoop=SoundCue'Gameplay_Audio.CradleSurf.CradleSurf_Travel_Loop_Stereo_01Cue'

	TendrilDismount=SoundCue'Gameplay_Audio.CradleSurf.CradleSurf_Dismount_Stereo_01Cue'

	TendrilSlowDown=SoundCue'Gameplay_Audio.CradleSurf.CradleSurf_SlowDown_Stereo_01Cue'
	TendrilSpeedUp=SoundCue'Gameplay_Audio.CradleSurf.CradleSurf_SpeedUp_Stereo_01Cue'

	TendrilConnectionEffect=ParticleSystem'REB_Lyrik.P_Lyric_Handforge_CradleLink' // Cradleloc and Forgeloc are the vectors.

	CradleLocName="Cradleloc"

	RotationRate=(Pitch=80000,Yaw=80000,Roll=80000)

	CityScanInterfaceMesh=StaticMesh'Nano_ProtoHUD_Ingame.S_UI_HUD_ScanScreen01'
	CityScanTunerVerticalAxis=StaticMesh'Nano_ProtoHUD_Ingame.S_UI_HUD_ScanLineVert'
	CityScanTunerHorizontalAxis=StaticMesh'Nano_ProtoHUD_Ingame.S_UI_HUD_ScanLineHoriz'
	CityScanSignalMesh=StaticMesh'EngineMeshes.Cube'

	CityScanSignalAcquired=SoundCue'Gameplay_Audio.AudioScan.AudioScan_AudioTuneIn_Stereo_01Cue'
	CityScanSignalLost=SoundCue'Gameplay_Audio.AudioScan.AudioScan_Lost_Stereo_01Cue'
	CityScanAmbient=SoundCue'Gameplay_Audio.AudioScan.AudioScan_AmbienceLP_StereoCue'

	ChannelColorParamNames(0)=Channel0Color
	ChannelColorParamNames(1)=Channel1Color
	ChannelColorParamNames(2)=Channel2Color
	ChannelColorParamNames(3)=Channel3Color
	ChannelColorParamNames(4)=Channel4Color

	ScanTargetAquiredBorderColor=(R=0.f,G=0.f,B=0.35f,A=1.f);
	CityScanActiveChannelColor=(R=0.5f,G=0.f,B=0.f,A=1.f);
	CityScanInactiveChannelColor=(R=0.f,G=0.15f,B=0.f,A=1.f);
	CityScanTunedInactiveChannelColor=(R=0.f,G=0.05f,B=0.f,A=1.f);

	CityScanTunerSpeed=0.025f
	CityScanChannelChangedSound=SoundCue'Gameplay_Audio.AudioScan.AudioScan_Change_Stereo_01Cue'
	ChannelSwitchBlendTime=0.2f
	CityScanChannelDepthOffset=32.f

	TunerRadialBounds=(X=12100.f,Y=205.f)


	SkillList.Add((SkillClass=class'NanoSkill_Agility',SkillLevel=0))
	SkillList.Add((SkillClass=class'NanoSkill_Bamf',SkillLevel=0))
	SkillList.Add((SkillClass=class'NanoSkill_Dash',SkillLevel=0))
	SkillList.Add((SkillClass=class'NanoSkill_Dense',SkillLevel=0))
	SkillList.Add((SkillClass=class'NanoSkill_DenseBash',SkillLevel=0))
	SkillList.Add((SkillClass=class'NanoSkill_Ghost',SkillLevel=0))
	SkillList.Add((SkillClass=class'NanoSkill_Grapple',SkillLevel=0))
	SkillList.Add((SkillClass=class'NanoSkill_Hacking',SkillLevel=0))
	SkillList.Add((SkillClass=class'NanoSkill_Health',SkillLevel=0))
	SkillList.Add((SkillClass=class'NanoSkill_Jump',SkillLevel=0))
	SkillList.Add((SkillClass=class'NanoSkill_Melee',SkillLevel=0))
	SkillList.Add((SkillClass=class'NanoSkill_NanoBuckets',SkillLevel=0))
	SkillList.Add((SkillClass=class'NanoSkill_VehicleOverride',SkillLevel=0))

	//SkillList.Add(SkillClass=class'NanoSkill_Tornado',SkillLevel=0)
	//SkillList.Add(SkillClass=class'NanoSkill_Ping',SkillLevel=0)

}
