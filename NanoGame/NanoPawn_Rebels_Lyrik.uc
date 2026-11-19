/**
 * Lyrik 388
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoPawn_Rebels_Lyrik extends NanoPawn_RebelsBase
	implements(NanoInterface_PatrolDestination)
	config(Pawn);

/** All of the bits needed for showing effects on the hand forge **/
var SkeletalMeshComponent HandForgeSkelMesh;
var StaticMeshComponent HandForgeMesh;
var transient MaterialInstanceTimeVarying MITV_HandForgeMesh;
var ParticleSystem PS_HandForge;
var transient NanoParticleSystemComponent PSC_HandForge;

/** Ref to the scarf cloth component */
var(Scarf) editinline SkeletalMeshComponent	ScarfMesh;
var(Scarf) Vector	ScarfWind;
var(Scarf) float	FanWindScale;

/** Sound for fllyyying up in the fan wind tunnel **/
var SoundCue FlyingWindFanSound;
var transient AudioComponent AC_FlyingWindFanSound;


/** When you do a nano power your body has effects on it. **/
var array<name> SocketNamesToAttachNanoPowerBodyEffects;
var transient array<NanoParticleSystemComponent> NanoPowerParticleBodyEffects;
var protected ParticleSystem PS_HitByTeslaEffect;

/** Pain Sounds! **/
var protected SoundCue PainSound_Small;
var protected SoundCue PainSound_Medium;
var protected SoundCue PainSound_Large;
var protected SoundCue PainSound_LandedDamage;

var protected SoundCue DiedSound;

//`define DEBUG_LYRIK_TRAILS

`if(`isdefined(DEBUG_LYRIK_TRAILS))
var transient float LastTrailTime;
var transient vector LastTrailPosition;
var transient quat LastTrailRotation;
var transient int LastTrailIndex;
var transient color LastTrailColor;
var transient array<vector> DebugTrailPointsFirstEdge;
var transient array<vector> DebugTrailPointsSecondEdge;
var transient array<color> DebugTrailColors;
`endif


/** Blood on char params **/
var name BloodOnChar_Opacity;
var name BloodOnChar_Amount;

/** Grappling effects */
var() ParticleSystem                  PS_GrappleBeam;
var transient ParticleSystemComponent PSC_GrappleBeam;

var() ParticleSystem                  PS_GrappleTargetReady;
var transient ParticleSystemComponent PSC_GrappleTargetReady;

var() LensFlare                       LF_GrappleTargetReady;
var transient LensFlareComponent      LFC_GrappleTargetReady;

var() SoundCue                        GrapplingSound;
var transient AudioComponent          AC_Grapple;

var() SoundCue                        GrapplingStartSound;


var Color ReviveAtSafehouseFadeColor;

var transient string CurrLyrikStoreItem;

var name HatSocketName;
var transient StaticMeshComponent HatMesh;

var transient MaterialInstanceConstant MIC_Staff;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	// start out with hands
	SpawnANanoWeapon(class'NanoWeap_Hands');

	// go ahead and set anchor point at spawn location as otherwise a back button hit will send you to 0 0 0
	TestingTeleportBackToAnchorPoint = Location;
	TestingTeleportBackToAnchorPointRotation = Rotation;

    // create all of the handforge objects
	Mesh.AttachComponentToSocket( HandForgeSkelMesh, HandForgeSocketName );

	Mesh.AttachComponentToSocket( HandForgeMesh, HandForgeSocketName );
	MITV_HandForgeMesh = new(self) class'MaterialInstanceTimeVarying';
	MITV_HandForgeMesh.SetParent( MaterialInstanceConstant'REB_Lyrik.M_Nano_HandforgeGlow_01_INST' );
	HandForgeMesh.SetMaterial( 0, MITV_HandForgeMesh );

	PSC_HandForge = new(self) class'NanoParticleSystemComponent';
	PSC_HandForge.SetTemplate( PS_HandForge );
    Mesh.AttachComponentToSocket( PSC_HandForge, HandForgeSocketName );

	// so for xenon we are currently not going to enable the scarf as it is costing us 24ms!
	if( WorldInfo.IsConsoleBuild() == TRUE && ScarfMesh != None )
	{
		DetachComponent( ScarfMesh );
		ScarfMesh = none;
	}

	Head1MIC = HeadMesh.CreateAndSetMaterialInstanceConstant(1);
	class'NanoTypes'.static.SetMaterialInstanceToDefault( Head1MIC );

	Head2MIC = HeadMesh.CreateAndSetMaterialInstanceConstant(2);
	class'NanoTypes'.static.SetMaterialInstanceToDefault( Head2MIC );

	Head3MIC = HeadMesh.CreateAndSetMaterialInstanceConstant(3);
	class'NanoTypes'.static.SetMaterialInstanceToDefault( Head3MIC );

	Head4MIC = HeadMesh.CreateAndSetMaterialInstanceConstant(4);
	class'NanoTypes'.static.SetMaterialInstanceToDefault( Head4MIC );

	if( ScarfMesh != none )
	{
		Scarf0MIC = ScarfMesh.CreateAndSetMaterialInstanceConstant(0);
		class'NanoTypes'.static.SetMaterialInstanceToDefault( Scarf0MIC );

		Scarf1MIC = ScarfMesh.CreateAndSetMaterialInstanceConstant(1);
		class'NanoTypes'.static.SetMaterialInstanceToDefault( Scarf1MIC );
	}


	MIC_DenseMesh = DenseMesh.CreateAndSetMaterialInstanceConstant(0);
	class'NanoTypes'.static.SetMaterialInstanceToDefault( MIC_DenseMesh );
	MIC_DenseMesh.SetScalarParameterValue( DenseMeshBlendName, 0.0f );

	CreateHitByTeslaCoilEffects();


	// start up our polling the DB for values! ( maybe only do this when chaos is up)
	SetTimer( 1.0f, TRUE, nameof(PollForValueFromDB_LyrikStoreItem) );

	// create weapons so people don't whine about the weapon not being there the first time
	InvManager.CreateInventory( class'NanoWeap_Knife' );

}


/** This can be called from an AnimNotify_Script **/
simulated function ActivateHandForge()
{
	PSC_HandForge.ActivateSystem();
    NanoGRI(WorldInfo.GRI).ParameterizeAMITV( MITV_HandForgeMesh, 'GlowOffset', -1.0f, 0.2f, 0.500f );
}


/** This can be called from an AnimNotify_Script **/
simulated function DeactivateHandForge()
{
	PSC_HandForge.DeactivateSystem();
    NanoGRI(WorldInfo.GRI).ParameterizeAMITV( MITV_HandForgeMesh, 'GlowOffset', 0.2f, -1.0f, 0.500f );
}


State Dying
{
	event BeginState( Name PreviousStateName )
	{
		`log( "Restarting player" );
		if( Controller != None )
		{
			SetTimer( 5.0f, FALSE, nameof(Controller.ServerRestartPlayer), Controller );
		}

		Super.BeginState( PreviousStateName );
	}
}

/** This Pawn has touched a slickified surface **/
simulated function OnSlickify()
{
    Super.OnSlickify();

    FullBodySlot.PlayCustomAnim( 'SMG_Orbitals_Slide', 1.0f, 0.05f, 0.1f, TRUE, TRUE );
	SetTimer( Slickify_DurationOfSlickifySpeedEffect, FALSE, nameof(StopSlideAnim) );
}

simulated function OnTeleport(SeqAct_Teleport Action)
{
	Super.OnTeleport(Action);

	// Fix up scarf post-teleport
	if(ScarfMesh != None)
	{
		ScarfMesh.ResetClothVertsToRefPose();
	}
}

/** This will stop lyrik's slide anim **/
protected simulated function StopSlideAnim()
{
	FullBodySlot.StopCustomAnim( 0.5f );
}

simulated function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	if( HeadMesh != None )
	{
		UpdateHeadAndScarf();
	}

`if(`isdefined(DEBUG_LYRIK_TRAILS))
	DrawTrail();
`endif

    if( NanoGRI(WorldInfo.GRI).GetCurrentChaosLevel() > 0 )
	{
		//NanoGRI(WorldInfo.GRI).AddStimuliInARadiusAroundEvent( class'NanoAI'.default.ConfrontPossibleThreatQuery.MaxDist, self, Location, TRUE, FALSE, TRUE, TRUE );
	}

}

simulated function UpdateClothBlend(float DeltaTime)
{
	Super.UpdateClothBlend(DeltaTime);

	if( ScarfMesh != none )
	{
		// Also blend in physics for scarf
		ScarfMesh.ClothBlendWeight = HeadMesh.ClothBlendWeight;
	}
}

simulated function bool UpdateMaskedMICs( float DeltaTime )
{
	if( Super.UpdateMaskedMICs( DeltaTime ) )
	{
		Head1MIC.SetScalarParameterValue( 'Mask', MaskMICValueCurr );
		Head2MIC.SetScalarParameterValue( 'Mask', MaskMICValueCurr );
		Head3MIC.SetScalarParameterValue( 'Mask', MaskMICValueCurr );
		Head4MIC.SetScalarParameterValue( 'Mask', MaskMICValueCurr );

		if( Scarf0MIC != none )
		{
			Scarf0MIC.SetScalarParameterValue( 'Mask', MaskMICValueCurr );
		}

		if( Scarf1MIC != none )
		{
			Scarf1MIC.SetScalarParameterValue( 'Mask', MaskMICValueCurr );
		}

		return TRUE;
	}

	return FALSE;
}




function SafeHouse FindClosestSafeHouseLocation()
{
	local SafeHouse House;
	local SafeHouse BestHouse;
	local float BestDist;

	BestDist = 999999999;

	foreach AllActors( class'SafeHouse', House )
	{
		if( ( House.bUnlocked == TRUE )
			&& ( VSize(House.Location - Location) < BestDist )
			)
		{
			BestDist = VSize(House.Location - Location);
			BestHouse = House;
		}
	}

	return BestHouse;
}


function ReviveAtSafeHouse( Controller Killer )
{
	local SafeHouse BestHouse;
	local NanoDefensivePoint NDP;

	BestHouse = FindClosestSafeHouseLocation();

	if( BestHouse != None )
	{
		TriggerGlobalEventClass( class'SeqEvt_PlayerRevivedAtSafeHouse', BestHouse );

		TriggerGlobalEventClass( class'SeqEvt_PlayerHasBeenKilled', Killer );
	
		EndSpecialMove();
		Health = DefaultHealth;
		SetLocation( BestHouse.Location );
		SetRotation( BestHouse.Rotation );
		NanoGRI(WorldInfo.GRI).MCP.AddIntToLocalMCPDatum( class'NanoTypes'.static.GetLocalPlayerUserName(), class'NanoMCPKeys'.default.NumRevivesAtSafeHouse, 1 );
		NanoGRI(WorldInfo.GRI).GetCurrentChaosManager().ModifyChaosLevel( self, class'NanoCausingChaosValues'.default.InstantDecreaseToTier1NoReward );

		if( NanoPawn(InteractionActor) != None )
		{
			NanoPawn(InteractionActor).EndSpecialMove();
		}

	
		NanoPC(Controller).ClientSetCameraFade( TRUE, ReviveAtSafehouseFadeColor, vect2d(1.0f,0.0f), 5.0f );

		// reset NDPs
		foreach WorldInfo.AllActors(class'NanoDefensivePoint', NDP)
		{
			NDP.bUnderAttack = FALSE;
			NDP.ActualTimeToSendReinforcements = 0;
		}

		NanoGRI(WorldInfo.GRI).NTM.HandleTutorialEvent( EET_FirstReviveAtSafeHouse, 1 );
		
	}
}



event TakeDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{

	// don't take damage from same team
	if( ( InstigatedBy != None ) && ( InstigatedBy.Pawn != None ) && ( InstigatedBy.Pawn.IsSameTeam( self ) == TRUE ) )
	{
		Damage = 0;
	}


	Super.TakeDamage(Damage,InstigatedBy,HitLocation,Momentum,DamageType,HitInfo,DamageCauser);

	//`log( Damage @ DamageType );

	if( Damage > 0 )
	{
		NanoGRI(WorldInfo.GRI).AIBlackboard.HandleCombatEvent( NCAT_PlayerWasHit, NanoAIBase(InstigatedBy) );

		if( DamageType == class'NDT_TeslaMeleeStick' )
		{
			ActivateRandomTeslaHitEffect();
			// oh we just got smacked so now we need to invoke post hit effects
			InvokePostHitEffects();
		}

		DoPainSounds( DamageType, Damage );
	}
}


function InvokePostHitEffects()
{
	NumberOfTeslaShockHitsActive++;
	SetTimer( TeslaShock_Duration, FALSE, nameof(ResetNumberOfTeslaShockHitsActive) );

	// right now only stun if we get hit twice before the "sparklies run out"
	if( NumberOfTeslaShockHitsActive < 2 )
	{
		return;
	}

	if( NumberOfTeslaShockHitsActive >= NumTeslaShockHitsForStunAnimation )
	{
		//`log( `showvar(NumberOfTeslaShockHitsActive) @ `showvar(NumTeslaShockHitsForStunAnimation) );
		DoSpecialMove( 'NSM_StunnedAndDazed', TRUE );
	}

	//`log( "TESLA SHOCK LOCK DOWN" );

	if( TeslaShock_NoRun_Allowed == TRUE )
	{
		TeslaShock_NoRun_ActiveUntil = WorldInfo.TimeSeconds + TeslaShock_NoRun_Duration;
	}

	if( TeslaShock_NoJog_Allowed == TRUE )
	{
		TeslaShock_NoJog_ActiveUntil = WorldInfo.TimeSeconds + TeslaShock_NoJog_Duration;
	}

	if( TeslaShock_NoJump_Allowed == TRUE )
	{
		TeslaShock_NoJump_ActiveUntil = WorldInfo.TimeSeconds + TeslaShock_NoJump_Duration;
	}

	if( TeslaShock_NoAttack_Allowed == TRUE )
	{
		TeslaShock_NoAttack_ActiveUntil = WorldInfo.TimeSeconds + TeslaShock_NoAttack_Duration;
	}
	
}


function ResetNumberOfTeslaShockHitsActive()
{
	NumberOfTeslaShockHitsActive = 0;
}

/** If we have died, then play a death sound!  **/
function bool Died(Controller Killer, class<DamageType> DamageType, vector HitLocation)
{
	// Lyrik no longer "dies".  Instead she will look for a SafeHouse.  If there is one, she will teleport to that location
	// if there is not one then yes she dies

	ReviveAtSafeHouse( Killer );
	return FALSE;



	if( Super.Died( Killer, DamageType, HitLocation ) )
	{
		PlaySound( DiedSound );

		return TRUE;
	}

	return FALSE;
}


simulated function DoPainSounds( class<DamageType> DamageType, int Damage )
{
	local SoundCue PainSound;

	if( DamageType == class'NDT_TeslaMeleeStick' )
	{
		if( Damage > 200 )
		{
			PainSound = PainSound_Large;
		}
		else if( Damage > 100 )
		{
			PainSound = PainSound_Medium;
		}
		else if( Damage > 30 )
		{
			PainSound = PainSound_Small;
		}

	}

	if( DamageType == class'DmgType_Fell' )
	{
		PainSound = PainSound_LandedDamage;
	}


	if( PainSound != none )
	{
		PlaySound( PainSound );
	}
}



simulated function UpdateHeadAndScarf()
{
//	local NanoVolume_Fan Fan;
	local NanoPhysicsVolume Fan;
	local Vector Wind;
	local bool bBlowScarf;

	bBlowScarf = TRUE;

	if( bBlowScarf )
	{
		Fan = NanoPhysicsVolume(PhysicsVolume);
//		Fan = NanoVolume_Fan(PhysicsVolume);
		if( Fan != None )
		{
			Wind += Fan.ZoneVelocity * FanWindScale;
		}
		// Add in constant relative breeze
		Wind += ScarfWind >> Rotation;
	}

	if( ScarfMesh != None )
	{
		ScarfMesh.ClothWind = Wind;

		if( ScarfMesh.HiddenGame != HeadMesh.HiddenGame )
		{
			ScarfMesh.SetHidden( HeadMesh.HiddenGame );
		}

	}
	HeadMesh.ClothWind = Wind;


}

/** Sets misc. materials for activated nano powers */
simulated function SetNanoPowerMaterials(MaterialInstanceConstant ScarfMaterial, MaterialInstanceConstant HandForgerMaterial)
{
	if( ScarfMesh != None )
	{
		ScarfMesh.SetMaterial( 0, ScarfMaterial );
		ScarfMesh.SetMaterial( 1, ScarfMaterial );
	}

	if( HandForgeMesh != None )
	{
		HandForgeMesh.SetMaterial( 0, HandForgerMaterial );
	}
}

/** Restores materials after nano power is deactivated */
simulated function RestoreDefaultNanoPowerMaterials()
{
	if( ScarfMesh != None )
	{
		ScarfMesh.SetMaterial( 0, Scarf0MIC );
		ScarfMesh.SetMaterial( 1, Scarf1MIC );
	}

	if( HandForgeMesh != None )
	{
		HandForgeMesh.SetMaterial( 0, MITV_HandForgeMesh );
	}
}

simulated function String GetHumanReadableName()
{
	return "Lyrik";
}

simulated function bool LandOnPawn( NanoPawn NP )
{
	local NanoAI AI;

	if( InteractionType == PAWNINTER_Pin )
	{
		return TRUE;
	}

	AI = NanoAI(NP.Controller);
	if( AI != None && NP.Physics == PHYS_Walking )
	{
		DoSpecialMove( 'NSM_Melee_PinEnemy', FALSE, NP );
		return TRUE;
	}

	return FALSE;
}

event PlayNanoFanFlyingWindSound()
{
	// if we don't have a AC for the FlyingWindSound
	if( AC_FlyingWindFanSound == None )
	{
		AC_FlyingWindFanSound = new(self) class'AudioComponent';
		if( AC_FlyingWindFanSound != None )
		{
			AC_FlyingWindFanSound.bAutoDestroy = TRUE;
			AC_FlyingWindFanSound.SoundCue = FlyingWindFanSound;
			AttachComponent( AC_FlyingWindFanSound );
			AC_FlyingWindFanSound.FadeIn( 0.100f, 1.0f );
			//`log( "WHHUURRLLLLLL" );
		}
	}

	NanoGRI(WorldInfo.GRI).GetNanoPC().SetSoundMode( 'FanRide' );
}

event StopNanoFanFlyingWindSound()
{
	if( AC_FlyingWindFanSound != None )
	{
		AC_FlyingWindFanSound.FadeOut( 0.100f, 1.0f );
		AC_FlyingWindFanSound = none;
		//`log( "mmmmrrrrrroooouurlll" );
	}


	if( NanoGRI(WorldInfo.GRI).GetNanoPC().GetCurrentSoundMode() == 'FanRide' )
	{
		NanoGRI(WorldInfo.GRI).GetNanoPC().SetSoundMode( 'Default' );
	}
}



function CreateHitByTeslaCoilEffects()
{
	local name SocketName;
	local NanoParticleSystemComponent PSC;

	foreach SocketNamesToAttachNanoPowerBodyEffects( SocketName )
	{
		// get a particle system comp
		PSC = new(self) class'NanoParticleSystemComponent'; // SpawnEmitterCustomLifetime assumes that you are using the PSC immediately and does crazy stuff.  So just make a new one for now
		PSC.bAutoActivate = FALSE;
		PSC.SetAbsolute(FALSE, FALSE);
		PSC.SetTemplate( PS_HitByTeslaEffect );

		NanoPowerParticleBodyEffects.AddItem( PSC );
		Mesh.AttachComponentToSocket( PSC, SocketName );
	}
}


function ActivateRandomTeslaHitEffect()
{
	NanoPowerParticleBodyEffects[ Rand(NanoPowerParticleBodyEffects.Length) ].ActivateSystem();
	NanoPowerParticleBodyEffects[ Rand(NanoPowerParticleBodyEffects.Length) ].ActivateSystem();
	NanoPowerParticleBodyEffects[ Rand(NanoPowerParticleBodyEffects.Length) ].ActivateSystem();
}

simulated function NotifyGrappleTarget()
{
	Super.NotifyGrappleTarget();
// 
// 	if( PS_GrappleTargetReady != None )
// 	{
// 		// Check to see if we're just switching between targets, and only spawn a tell emitter if needed
// 		if( PSC_GrappleTargetReady == None )
// 		{
// 			PSC_GrappleTargetReady = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment( PS_GrappleTargetReady, Mesh, HandForgeSocketName, TRUE );
// 		}
// 		PSC_GrappleTargetReady.SetVectorParameter( 'Endpoint', NanoInterface_Grapple(NanoPC(Controller).GrappleTarget).GetGrappleLocation(self) );
// 	}
// 
// 	if( LF_GrappleTargetReady != None && LFC_GrappleTargetReady == None )
// 	{
// 		LFC_GrappleTargetReady = new(self) class'LensFlareComponent';
// 		LFC_GrappleTargetReady.SetTemplate(LF_GrappleTargetReady);
// 		Mesh.AttachComponentToSocket(LFC_GrappleTargetReady, HandForgeSocketName);
// 	}
}

simulated function NotifyGrappleTargetInvalid()
{
	Super.NotifyGrappleTargetInvalid();

	if( PSC_GrappleTargetReady != None )
	{
		PSC_GrappleTargetReady.DeactivateSystem();
		PSC_GrappleTargetReady = None;
	}

	if( LFC_GrappleTargetReady != None )
	{
		LFC_GrappleTargetReady.SetIsActive(FALSE);
		Mesh.DetachComponent(LFC_GrappleTargetReady);
		LFC_GrappleTargetReady = None;
	}
}

simulated function BeginGrappleEffects( Actor GrappleTarget )
{
	// Turn off the seeking effects
	NotifyGrappleTargetInvalid();

	// Turn on the beam particle system
	if( PS_GrappleBeam != None )
	{
		PSC_GrappleBeam = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment( PS_GrappleBeam, Mesh, HandForgeSocketName, TRUE );
		PSC_GrappleBeam.SetVectorParameter( 'Endpoint', NanoInterface_Grapple(GrappleTarget).GetGrappleLocation(self) );
	}

	if( GrapplingSound != None )
	{
		AC_Grapple = new(self) class'AudioComponent';
		AttachComponent(AC_Grapple);
		AC_Grapple.SoundCue = GrapplingSound;
		AC_Grapple.FadeIn(0.2f, 1.f);
	}

	if( GrapplingStartSound != None )
	{
		PlaySound(GrapplingStartSound);
	}
}

simulated function EndGrappleEffects()
{
	// Stop the beam particle system
	if( PSC_GrappleBeam != None )
	{
		PSC_GrappleBeam.DeactivateSystem();
		PSC_GrappleBeam = None;
	}

	// Fade out the grapple sound
	if( AC_Grapple != None )
	{
		AC_Grapple.FadeOut(0.2f, 0.f);
		DetachComponent(AC_Grapple);
		AC_Grapple = None;
	}
}

`if(`isdefined(DEBUG_LYRIK_TRAILS))
function DrawTrail()
{
	local int TrailPointIdx;
	local byte Red;
	local byte Green;
	local byte Blue;

	Red = 255;
	Green = 255;
	Blue = 0;

	for (TrailPointIdx = 0; TrailPointIdx < DebugTrailPointsFirstEdge.Length; TrailPointIdx++)
	{
		Red = DebugTrailColors[TrailPointIdx].R;
		Green = DebugTrailColors[TrailPointIdx].G;
		Blue = DebugTrailColors[TrailPointIdx].B;
		DrawDebugLine(DebugTrailPointsFirstEdge[TrailPointIdx], DebugTrailPointsSecondEdge[TrailPointIdx], Red, Green, Blue);
		// This code will connect the previous points to draw the edges of the trail
		if (TrailPointIdx > 0)
		{
			DrawDebugLine(DebugTrailPointsFirstEdge[TrailPointIdx-1], DebugTrailPointsFirstEdge[TrailPointIdx], Red, Green, Blue);
			DrawDebugLine(DebugTrailPointsSecondEdge[TrailPointIdx-1], DebugTrailPointsSecondEdge[TrailPointIdx], Red, Green, Blue);
		}
	}
}

/**
 * Called by AnimNotify_Trails
 *
 * @param AnimNotifyData The AnimNotify_Trails which will have all of the various params on it
 */
event TrailsNotify( const AnimNotify_Trails AnimNotifyData )
{
	local TrailSample SamplePoint;
	local vector TrailStart;
	local rotator TrailRotator;

	// START
	LastTrailTime = AnimNotifyData.CurrentTime;
	LastTrailPosition = MatrixGetOrigin(Mesh.LocalToWorld);
	TrailRotator = MatrixGetRotator(Mesh.LocalToWorld);
	LastTrailRotation = QuatFromRotator(TrailRotator);

	SamplePoint = AnimNotifyData.TrailSampledData[0];
	TrailStart = TransformVector(Mesh.LocalToWorld, SamplePoint.FirstEdgeSample);
	DebugTrailPointsFirstEdge.Length = 1;
	DebugTrailPointsFirstEdge[0] = TrailStart;
	TrailStart = TransformVector(Mesh.LocalToWorld, SamplePoint.SecondEdgeSample);
	DebugTrailPointsSecondEdge.Length = 1;
	DebugTrailPointsSecondEdge[0] = TrailStart;

	LastTrailColor.R = 0;
	LastTrailColor.G = 255;
	LastTrailColor.B = 0;
	DebugTrailColors.Length = 1;
	DebugTrailColors[0] = LastTrailColor;

	LastTrailColor.R += 25;
	LastTrailColor.G -= 25;

	LastTrailIndex = 0;
}

/**
 * Called by AnimNotify_Trails
 *
 * @param AnimNotifyData The AnimNotify_Trails which will have all of the various params on it
 */
event TrailsNotifyTick( const AnimNotify_Trails AnimNotifyData )
{
 	local TrailSample SamplePoint;
 	local vector TrailPoint;
	local float InterpTimeStep;
	local float InterpTime;
	local int StepIdx;
	local int NumSteps;
	local vector TrailPosition;
	local rotator TrailRotator;
	local quat TrailRotation;

	local vector InterpPosition;
	local rotator InterpRotator;
	local quat InterpRotation;
	local matrix InterpMatrix;

	local float CurrEndTime;

	// Determine the number of steps to take...
	CurrEndTime = AnimNotifyData.CurrentTime + AnimNotifyData.TimeStep;
	NumSteps = 0;
	if (LastTrailIndex >= 0)
	{
		NumSteps = AnimNotifyData.GetNumSteps(LastTrailIndex);
	}

	if (NumSteps > 0)
	{
		InterpTimeStep = 1.0f / NumSteps;

		DebugTrailPointsFirstEdge.Length = DebugTrailPointsFirstEdge.Length + NumSteps;
		DebugTrailPointsSecondEdge.Length = DebugTrailPointsSecondEdge.Length + NumSteps;
		DebugTrailColors.Length = DebugTrailColors.Length + NumSteps;

		// The current trail info
		TrailPosition = MatrixGetOrigin(Mesh.LocalToWorld);
		TrailRotator = MatrixGetRotator(Mesh.LocalToWorld);
		TrailRotation = QuatFromRotator(TrailRotator);

		for (StepIdx = 0; StepIdx < NumSteps; StepIdx++)
		{
			// Interpolation method...
			InterpTime = (StepIdx + 1) * InterpTimeStep;

			InterpPosition = VLerp(LastTrailPosition, TrailPosition, InterpTime);
			InterpRotation = QuatSlerp(LastTrailRotation, TrailRotation, InterpTime, TRUE);
			InterpRotator = QuatToRotator(InterpRotation);
			InterpMatrix = MakeRotationTranslationMatrix(InterpPosition, InterpRotator);

			SamplePoint = AnimNotifyData.TrailSampledData[LastTrailIndex + 1 + StepIdx];
			TrailPoint = TransformVector(InterpMatrix, SamplePoint.FirstEdgeSample);
			DebugTrailPointsFirstEdge[LastTrailIndex + 1 + StepIdx] = TrailPoint;
			TrailPoint = TransformVector(InterpMatrix, SamplePoint.SecondEdgeSample);
			DebugTrailPointsSecondEdge[LastTrailIndex + 1 + StepIdx] = TrailPoint;

			DebugTrailColors[LastTrailIndex + 1 + StepIdx] = LastTrailColor;

			// No interpolation method
// 			SamplePoint = AnimNotifyData.TrailSampledData[LastTrailIndex + 1 + StepIdx];
// 			TrailPoint = TransformVector(Mesh.LocalToWorld, SamplePoint.FirstEdgeSample);
// 			DebugTrailPointsFirstEdge[LastTrailIndex + 1 + StepIdx] = TrailPoint;
// 			TrailPoint = TransformVector(Mesh.LocalToWorld, SamplePoint.SecondEdgeSample);
// 			DebugTrailPointsSecondEdge[LastTrailIndex + 1 + StepIdx] = TrailPoint;
		}

		LastTrailIndex += NumSteps;
		LastTrailTime = CurrEndTime;
		LastTrailPosition = MatrixGetOrigin(Mesh.LocalToWorld);
		LastTrailRotation = TrailRotation;
		if (LastTrailColor.G - 25 >= 0)
		{
			LastTrailColor.G  -= 25;
		}
		if (LastTrailColor.R + 25 <= 255)
		{
			LastTrailColor.R += 25;
		}
	}
}

/**
 * Called by AnimNotify_Trails
 *
 * @param AnimNotifyData The AnimNotify_Trails which will have all of the various params on it
 */
event TrailsNotifyEnd( const AnimNotify_Trails AnimNotifyData )
{
	SetTimer(5.0f, FALSE, nameof(KillTrail) );
}

function KillTrail()
{
	DebugTrailPointsFirstEdge.Length = 0;
	DebugTrailPointsSecondEdge.Length = 0;
}
`endif



function RemoveSomeBlood( float DeltaTime )
{
	BloodAmount -= (DeltaTime / 5.0f); // tricky here.   we just keep adding so the longer the battle the longer the blood will stay on the sword
	BodyMIC.SetScalarParameterValue( BloodOnChar_Opacity, BloodAmount );
	BodyMIC.SetScalarParameterValue( BloodOnChar_Amount, BloodAmount );

	ArmMIC.SetScalarParameterValue( BloodOnChar_Opacity, BloodAmount );
	ArmMIC.SetScalarParameterValue( BloodOnChar_Amount, BloodAmount );
}


function AddSomeBlood()
{
	BloodAmount += 0.20f; // tricky here.   we just keep adding so the longer the battle the longer the blood will stay on the sword
	BodyMIC.SetScalarParameterValue( BloodOnChar_Opacity, BloodAmount );
	BodyMIC.SetScalarParameterValue( BloodOnChar_Amount, BloodAmount );

	ArmMIC.SetScalarParameterValue( BloodOnChar_Opacity, BloodAmount );
	ArmMIC.SetScalarParameterValue( BloodOnChar_Amount, BloodAmount );
}


function SetFullBlood()
{
	BloodAmount = 1.0f; // tricky here.   we just keep adding so the longer the battle the longer the blood will stay on the sword
	BodyMIC.SetScalarParameterValue( BloodOnChar_Opacity, BloodAmount );
	BodyMIC.SetScalarParameterValue( BloodOnChar_Amount, BloodAmount );

	ArmMIC.SetScalarParameterValue( BloodOnChar_Opacity, BloodAmount );
	ArmMIC.SetScalarParameterValue( BloodOnChar_Amount, BloodAmount );
}


function BloodyLyrikHands( bool bShouldBloodyHands )
{
	local float BloodOnHandsAmt;

	if( bShouldBloodyHands == TRUE )
	{
		BloodOnHandsAmt = 1.0f;
	}
	else
	{
		BloodOnHandsAmt = 0.0f;
	}

	BodyMIC.SetScalarParameterValue( 'SkinGoreAmount', BloodOnHandsAmt );
	ArmMIC.SetScalarParameterValue( 'SkinGoreAmount', BloodOnHandsAmt );
}


simulated function bool GetPatrolDestination( out Vector out_PatrolDest )
{
	out_PatrolDest = Location;
	return TRUE;
}




function PollForValueFromDB_LyrikStoreItem()
{
	local NanoGRI NGRI;
	local NanoMCP MCP;
	local string UserName;
	local String CurrValueString;

	//`log( self @ GetFuncName() );

	NGRI = NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI);
	MCP = NGRI.MCP;
	UserName = class'NanoMCPKeys'.default.MobileUserID; // class'NanoMobileTypes'.static.GetLocalPlayerUserName();

	MCP.FindStringValue( UserName, class'NanoMCPKeys'.default.LyrikStoreItem, CurrValueString );


	// if we have a new store item
	if( CurrLyrikStoreItem != CurrValueString )
	{
		`log( " Received values from DB" @ `showvar(CurrLyrikStoreItem) @ `showvar(CurrValueString) );

		CurrLyrikStoreItem = CurrValueString;

		HandleNewLyrikStoreItem( CurrLyrikStoreItem );
	}

}





/** Will make a new SMC and attach it to the HatSocket **/
function CreateAndAttachHat( StaticMesh InStaticMesh )
{	
	if( HatMesh != None )
	{
		Mesh.DetachComponent( HatMesh );
		HatMesh = None;
	}

	HatMesh = new(self) class'StaticMeshComponent';
	HatMesh.SetStaticMesh( InStaticMesh );

	`log( HatMesh );

	Mesh.AttachComponentToSocket( HatMesh, HatSocketName );
}


function HandleNewLyrikStoreItem( string InStoreItem )
{
	local NanoWeap_Staff Staff;
	local MaterialInstanceConstant MIC_NewStaffSkin;
	local LinearColor LC;

	if( InStoreItem == "DizzyHat" )
	{
		CreateAndAttachHat( StaticMesh'COG_Dizzy.Hat' );
		return;
	}
	else if( InStoreItem == "ColeHelmet" )
	{
		CreateAndAttachHat( StaticMesh'COG_Hanover_Stadium.Mesh.S_COG_Hanover_Assets_Helmet' );
		return;
	}
	else if( InStoreItem == "TruckerHat" )
	{
		CreateAndAttachHat( StaticMesh'COG_Hanover_Stadium.Mesh.S_COG_Hanover_Stadium_Hat' );
		return;
	}
	else if( InStoreItem == "12Hour_HealthBoost" )
	{

	}
	else if( InStoreItem == "12Hour_NanoBoost" )
	{

	}
	else if( InStoreItem == "12Hour_RebelBoost" )
	{

	}
	else if( InStoreItem == "BountyToken" )
	{

	}
	else if( InStoreItem == "BlueGear" )
	{
		`log( `showvar(ArmMIC.Parent) );
		//ReflectionColorAlphaIntensity    3 2 200 4
		LC = MakeLinearColor( 3, 2, 200, 4 ); 
		ArmMIC.SetVectorParameterValue( 'ReflectionColorAlphaIntensity', LC );
		return;
	}

	// hack for staff
	Staff = NanoWeap_Staff(Weapon);

	if( Staff == None )
	{
		`warn( "you don't have a staff up! Wield and try again!" @ `showvar(Weapon) );
		// too bad you don't have a staff up
		return;
	}



	if( InStoreItem == "GlassStaff" )
	{
		MIC_NewStaffSkin = MaterialInstanceConstant'REB_Staff.Materials.M_StaffChromeSkin_Glass_INST';
	}
	else if( InStoreItem == "GoldStaff" )
	{
		MIC_NewStaffSkin = MaterialInstanceConstant'REB_Staff.Materials.M_StaffChromeSkin_Master_Gold';
	}
	else if( InStoreItem == "SteelStaff" )
	{
		MIC_NewStaffSkin = MaterialInstanceConstant'REB_Staff.Materials.M_StaffChromeSkin_Master_Steel';
	}
	else if( InStoreItem == "SilverStaff" )
	{
		MIC_NewStaffSkin = MaterialInstanceConstant'REB_Staff.Materials.M_StaffChromeSkin_Master_Silver';
	}
	else if( InStoreItem == "BlueGlowStaff" )
	{
		MIC_NewStaffSkin = MaterialInstanceConstant'REB_Staff.Materials.M_StaffPowerSkin_Master_BlueGlow';
		// ParticleSystem'REB_Staff.Effects.P_StaffEffect_Ribbons'
	}
	else if( InStoreItem == "RedGlowStaff" )
	{
		MIC_NewStaffSkin = MaterialInstanceConstant'REB_Staff.Materials.M_StaffPowerSkin_Master_RedGlow';
	}
	else if( InStoreItem == "FireStaff" )
	{
		MIC_NewStaffSkin = MaterialInstanceConstant'REB_Staff.Materials.M_StaffSkinSpecialEffect_Fire';
		//add ParticleSystem'REB_Staff.Effects.P_FX_FlamingStaff_01' to the Mid_Segment or Root bone.
	}
	else if( InStoreItem == "DigitalStaff" )
	{
		MIC_NewStaffSkin = MaterialInstanceConstant'REB_Staff.Materials.M_StaffSkinSpecialEffect_Digital';
	}


	// now set the value we got
	if( MIC_NewStaffSkin != None )
	{
		MIC_Staff = new(self) class'MaterialInstanceConstant';
		MIC_Staff.SetParent( MIC_NewStaffSkin );
		Staff.Mesh.SetMaterial( 0, MIC_Staff );
	}

}




defaultproperties
{
	CharacterFootStepType=NFST_Lyrik

	BaseEyeHeight=0.0
	EyeHeight=0.0

	Begin Object Name=CollisionCylinder
		CollisionRadius=+0050.000000
		CollisionHeight=+0098.000000
	End Object

	Begin Object Name=NanoPawnMesh
	    SkeletalMesh=SkeletalMesh'REB_Owen.SK_Owen_GDC'
	    PhysicsAsset=PhysicsAsset'REB_Owen.SK_REB_Owen_Physics'

		//SkeletalMesh=SkeletalMesh'REB_Lyrik.SK_REB_Lyrik_Body'
		//PhysicsAsset=PhysicsAsset'REB_Lyrik.Physics.SK_REB_Lyrik_Body_Physics'
		AnimSets.Add(AnimSet'MET_ShockTrooperProto.AS_MET_ShockT_Hit_React')
		Translation=(Z=-100.0)
		AlwaysCheckCollision=TRUE
		bEnableFullAnimWeightBodies=TRUE
	End Object

	Begin Object Name=NanoPawnHeadMesh
		//SkeletalMesh=SkeletalMesh'REB_Lyrik.SK_REB_Lyrik_Head'

		TickGroup=TG_PreAsyncWork
		AlwaysCheckCollision=TRUE
	End Object


	Begin Object Class=SkeletalMeshComponent Name=NanoPawnScarfMesh
		SkeletalMesh=SkeletalMesh'REB_Lyrik.SK_REB_Lyrik_Scarf'
		LightEnvironment=MyLightEnvironment
		bUpdateSkelWhenNotRendered=TRUE
		ParentAnimComponent=NanoPawnMesh
		bCastHiddenShadow=TRUE
		CastShadow=TRUE
		ShadowParent=NanoPawnMesh

		bEnableClothSimulation=TRUE
		bClothUseCompartment=FALSE
		bDisableClothCollision=FALSE
		bClothAwakeOnStartup=FALSE

		//bClothBaseVelClamp=TRUE
		//ClothBaseVelClampRange=(X=200,Y=200,Z=300)

		bClothBaseVelInterp=TRUE
		ClothBaseVelClampRange=(X=0.02,Y=0.02,Z=0.5)

		ClothBlendWeight=1.f

		ClothRBChannel=RBCC_Cloth
		ClothRBCollideWithChannels=(Pawn=TRUE)

		bClothPositionalDampening=FALSE
		MinPosDampRange=(X=150,Y=100,Z=100)
		MaxPosDampRange=(X=50,Y=100,Z=150)
		MinPosDampScale=(X=1.f,Y=1.f,Z=1.f)
		MaxPosDampScale=(X=0.f,Y=0.f,Z=1.f)

		TickGroup=TG_PreAsyncWork
		AlwaysCheckCollision=TRUE

//		bClothWindRelativeToOwner=TRUE
//		ClothWind=(X=-50.f,Y=0.f,Z=5.f)
	End Object
//  ScarfMesh=NanoPawnScarfMesh
//	Components.Add(NanoPawnScarfMesh)

	Begin Object Class=SkeletalMeshComponent Name=DenseMeshComp
	    SkeletalMesh=SkeletalMesh'REB_Lyrik.SK_Reb_Lyrik_Dense'
		bAllowAmbientOcclusion=FALSE
		LightEnvironment=MyLightEnvironment
		ParentAnimComponent=NanoPawnMesh
		ShadowParent=NanoPawnMesh
		bCastHiddenShadow=FALSE
		CastShadow=FALSE
		HiddenGame=TRUE
	End Object
	DenseMesh=DenseMeshComp
	Components.Add(DenseMeshComp)


	ScarfWind=(X=-50.f,Y=0.f,Z=5.f)
	FanWindScale=25.f

	bKillDuringLevelTransition=FALSE

	HackFootStepCue=SoundCue'Foley_Footsteps.Stone.Footstep_Stone_Walk_Cue'
	HackFootStepRunCue=SoundCue'Foley_Footsteps.Stone.Footstep_Stone_Run_Cue'
	LeftKneeBoneName=b_MF_Calf_L
	LeftFootBoneName=b_MF_Foot_L
	RightKneeBoneName=b_MF_Calf_R
	RightFootBoneName=b_MF_Foot_R

	LandedMediumCue=SoundCue'Character_Lyrik_Efforts.Lyrik_Efforts_LandLight_Cue'
	LandedLargeCue=SoundCue'Character_Lyrik_Efforts.Lyrik_Efforts_LandHeavy_Cue'

	DashAttachEffortCue=SoundCue'Character_Lyrik_Efforts.Lyrik_Efforts_DashAttack_Cue'
	DashAttachEffortFinalCue=SoundCue'Character_Lyrik_Efforts.Lyrik_Efforts_DashAttackFinal_Cue'

	PainSound_Small=SoundCue'Character_Lyrik_Efforts.Lyrik_Efforts_PainSmall_Cue'
	PainSound_Medium=SoundCue'Character_Lyrik_Efforts.Lyrik_Efforts_PainMedium_Cue'
	PainSound_Large=SoundCue'Character_Lyrik_Efforts.Lyrik_Efforts_PainLarge_Cue'

	PainSound_LandedDamage=SoundCue'Character_Lyrik_Efforts.Lyrik_Efforts_LandPain_Cue'

	DiedSound=SoundCue'Character_Lyrik_Efforts.Lyrik_Efforts_Death_Cue'

	bAvoidLedges=FALSE
	bStopAtLedges=FALSE
	bCanWalkOffLedges=TRUE
	bCanJump=TRUE

	HandForgeSocketName="HandForge"
	HatSocketName="HatSocket"

	Begin Object Class=StaticMeshComponent Name=HandForgeMeshComp
		//StaticMesh=StaticMesh'REB_Lyrik.S_Nano_Handforge_Glow_01' // GlowOffset from .2 to -1 to hide the glow (and the inverse to reveal it).
	End Object
	HandForgeMesh=HandForgeMeshComp
	Components.Add(HandForgeMeshComp)

	Begin Object Class=SkeletalMeshComponent Name=HandForgeSkelMeshComp
		//SkeletalMesh=SkeletalMesh'REB_Lyrik.SK_REB_Lyrik_HandForge'
		bCastHiddenShadow=FALSE
		CastShadow=FALSE
		bUpdateSkelWhenNotRendered=FALSE
		bAcceptsLights=FALSE

		CollideActors=FALSE
		BlockActors=FALSE
		BlockZeroExtent=FALSE
		BlockNonZeroExtent=FALSE
		BlockRigidBody=FALSE
	End Object
	HandForgeSkelMesh=HandForgeSkelMeshComp
	Components.Add(HandForgeSkelMeshComp)


	//PS_HandForge=ParticleSystem'REB_Lyrik.P_Lyric_Handforge_Active'

	PS_GrappleBeam=ParticleSystem'Nano_Power_FX.Effects.P_FX_NanoPower_SuckBeam'
	PS_GrappleTargetReady=ParticleSystem'Nano_Power_FX.Effects.P_FX_NanoPower_SuckBeam_Tell'
	GrapplingSound=SoundCue'Gameplay_Audio.CradleSurf.CradleSurf_Travel_Loop_Stereo_01Cue'
	GrapplingStartSound=SoundCue'Weapon_Tesla.Stick.Tesla_LandCue'
	LF_GrappleTargetReady=LensFlare'Nano_Proto_IRIS.LF_IRIS_Target_02'

	FlyingWindFanSound=SoundCue'Foley_Body.Player.Body_FlyingWind_Loop_Cue'

	PS_HitByTeslaEffect=ParticleSystem'MET_TeslaStick.Effects.P_Shock_Character'

	SocketNamesToAttachNanoPowerBodyEffects.Add("EffectHead")
	SocketNamesToAttachNanoPowerBodyEffects.Add("EffectBody")
	SocketNamesToAttachNanoPowerBodyEffects.Add("EffectLeftArm")
	SocketNamesToAttachNanoPowerBodyEffects.Add("EffectRightArm")
	SocketNamesToAttachNanoPowerBodyEffects.Add("EffectUpperArmL")
	SocketNamesToAttachNanoPowerBodyEffects.Add("EffectUpperArmR")
	SocketNamesToAttachNanoPowerBodyEffects.Add("EffectLegL")
	SocketNamesToAttachNanoPowerBodyEffects.Add("EffectLegR")
	SocketNamesToAttachNanoPowerBodyEffects.Add("EffectLeftThigh")
	SocketNamesToAttachNanoPowerBodyEffects.Add("EffectRightThigh")

	BloodOnChar_Opacity="BloodSpill"  // 0-1 controls opacity of bloodsplatter
	BloodOnChar_Amount="BloodHeavyBlend" // 0-1 controls mix between faint bloodsplatter and heavy

	DenseMeshBlendName="Blend"


	ReviveAtSafehouseFadeColor=(R=255,G=255,B=255,A=255)

	SupportedEvents.Add( class'SeqEvt_PlayerHasBeenKilled' )
	SupportedEvents.Add( class'SeqEvt_PlayerRevivedAtSafeHouse' )

}

