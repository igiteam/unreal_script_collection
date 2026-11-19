
/**
 * Torque Bow.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearWeap_BowBase extends GearWeapon
	abstract
	config(Weapon);

/** Time it takes to reach full charge */
var	config float		MaxChargeTime;
/** Time it takes to allow projectile to stick (not bounce) */
var config float		StickChargeTime;
var float				MinChargeTime;
/** Time weapon can be held at max charge, before the player gets tired. */
var	config float		HoldTimeUntilTired;

/** Time weapon is charged */
var	transient float		ChargeTimeCount;

var SoundCue AimLoop;
var AudioComponent AimingSound;

var GearProj_Grenade			SimulatedGrenade;

//var Emitter					EM_StartPoint;
//var ParticleSystem			PS_StartPoint;

var ParticleSystemComponent PSC_Trail;
var ParticleSystem			PS_TrailCOG;
var ParticleSystem			PS_TrailLocust;
/** Aiming trail beam to use when at max charge */
var ParticleSystemComponent	PSC_MaxChargeTrail;

var bool bPlayedMaxCharge;
var ForceFeedbackWaveform MaxChargeWaveform;

//
// End points particle effects
//
var ParticleSystemComponent	PSC_EndPoint;
var ParticleSystem	PS_EndPointCOG;
var ParticleSystem	PS_EndPointLocust;


var ParticleSystemComponent	PSC_EndPointFullCharge;
var ParticleSystem	PS_EndPointFullCharge;

var ParticleSystemComponent	PSC_EndPointFail;
var ParticleSystem	PS_EndPointFail;

var ParticleSystemComponent PSC_TorqueBowChargeUp;
var ParticleSystem PS_TorqueBowChargeUp;

var bool			bPendingEndFire;

/** Testing of animations */
enum EAnimStyle
{
	EAS_Closed,
	EAS_Opened,
	EAS_TargetingOpens
};

var EAnimStyle	CurrentStyle;
var bool		bOpened;

/** set during charging after guessing the shooter's target and sending a warning */
var bool bGuessedTarget;

var StaticMeshComponent	ArrowMesh;
var name ArrowSocket;

var protected const SoundCue LaunchSound;

var protected const SoundCue BowMeleeSwingSound;

/** Overridden to set up PSC_MaxChargeTrail */
simulated event PostBeginPlay()
{
	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		PSC_MaxChargeTrail.DeActivateSystem();
		SkeletalMeshComponent(Mesh).AttachComponentToSocket( PSC_MaxChargeTrail, MuzzleFlashArchetype.MuzzleSocketName );
	}

	super.PostBeginPlay();
}

simulated function float GetWeaponRating()
{
	local float Rating;
	local GearAI AI;

	Rating = Super.GetWeaponRating();

	// AI prefers bow at long range
	AI = GearAI(GetWeaponController());
	if (AI != None && AI.Enemy != None)
	{
		if (!AI.IsShortRange(AI.Enemy.Location))
		{
			Rating += 0.5;
		}
		// but not against weak enemies
		if (AI.Enemy.HealthMax <= 300)
		{
			Rating -= 0.75;
		}
	}

	return Rating;
}

/** Kill off the emitters that we spawned **/
simulated function Destroyed()
{
	if( SimulatedGrenade != None )
	{
		SimulatedGrenade.Destroy();
		SimulatedGrenade = none;
	}

	if (Instigator != None)
	{
		Instigator.DetachComponent(PSC_EndPoint);
		Instigator.DetachComponent(PSC_EndPointFail);
		Instigator.DetachComponent(PSC_EndPointFullCharge);
	}

	Super.Destroyed();
}


/** Don't render crosshair for this weapon. */
simulated function DrawWeaponCrosshair( Hud H );


simulated function ToggleCharging(bool bNewCharging)
{
	if ( GearPawn(Instigator) != None )
	{
		GearPawn(instigator).bChargingWeapon = bNewCharging;
	}
	if ( bNewCharging )
	{
		if( PSC_TorqueBowChargeUp == none )
		{
			PSC_TorqueBowChargeUp = new(Outer) class'ParticleSystemComponent';
			PSC_TorqueBowChargeUp.SetTemplate( PS_TorqueBowChargeUp );
			SkeletalMeshComponent(Mesh).AttachComponentToSocket( PSC_TorqueBowChargeUp, 'ChargeUp' );
		}
		PSC_TorqueBowChargeUp.SetHidden( FALSE );
		PSC_TorqueBowChargeUp.ActivateSystem();
	}
	else
	{
		if( PSC_TorqueBowChargeUp != none )
		{
			PSC_TorqueBowChargeUp.SetHidden( TRUE );
			PSC_TorqueBowChargeUp.DeactivateSystem();
		}
	}
}

// stub, should never be called
simulated function bool AI_WantsEarlyFire()
{
	`Warn("Should only be called in state 'Charge'");
	return false;
}

/** Player is charging weapon. */
simulated state Charge
{
	// when we're charging, stop firing and wait a bit before evading so we don't fire the bow while evading
	function float AIDelayBeforeEvade(GearAI AI)
	{
		AI.StopFiring();
		return 0.785f;
	}

	simulated function BeginState( Name PreviousStateName )
	{
		//`log( WorldInfo.TimeSeconds @ GetStateName() @ GetFuncName() );

		// Set firing mode to CHARGE.
		// This is to be replicated to trigger events/animations on all clients.
		SetCurrentFireMode(FIREMODE_CHARGE);

		ChargeTimeCount		= MinChargeTime;
		bPlayedMaxCharge	= FALSE;
		bPendingEndFire		= FALSE;
		bGuessedTarget = false;

		ToggleCharging(true);

		//`log( "HIHIIHIHIH IA M CHARGING" );
	}

	simulated function EndState( Name NextStateName )
	{
		//`log( WorldInfo.TimeSeconds @ GetStateName() @ GetFuncName() );

		ClearTimer('PlayMaxCharge');
		StopSimulation();
		ToggleCharging(false);

		// Reset firing mode back to default
		SetCurrentFireMode(0);
	}

	simulated event bool IsFiring()
	{
		return TRUE;
	}

	simulated function bool AI_WantsEarlyFire()
	{
		if (GearAIController != None)
		{
			if (GearAI_TDM(GearAIController) != None && GearAIController.FireTarget != None)
			{
				return true;
			}
			else if (!WorldInfo.GRI.IsMultiplayerGame() && GearAIController.GetTeamNum() == TEAM_COG)
			{
				return true;
			}
		}
		return false;
	}

	simulated function Tick( float DeltaTime )
	{
		local GearPawn	P;
		local vector StartTrace, EndTrace, HitLocation, HitNormal;
		local Pawn HitPawn;
		local Controller PawnController;

		P = GearPawn(Instigator);

		Super.Tick(DeltaTime);

		PawnController = GetWeaponController();

		// See if we can fire the shot now
		// May not be safe if we're transitioning, we can hit the cover wall
		if( bPendingEndFire && CanReleaseFire() && !P.PawnCommitToFiring(0) )
		{
			bPendingEndFire = FALSE;
			GotoState('Fire');
			return;
		}

		// double charge if active reloaded
		if( ActiveReload_NumBonusShots > 0 )
		{
			ChargeTimeCount += DeltaTime * 2.f;
		}
		else
		{
			ChargeTimeCount += DeltaTime;
		}

		if( ChargeTimeCount >= MaxChargeTime + HoldTimeUntilTired )
		{
			ChargeTimeCount = MaxChargeTime + HoldTimeUntilTired;
			// Force fire when time expires.
			GotoState('Fire');
			return;
		}
		else
		{
			if( !bPlayedMaxCharge && ChargeTimeCount > MaxChargeTime && Instigator.IsLocallyControlled(PawnController) )
			{
				bPlayedMaxCharge = TRUE;
				PlayMaxCharge();
			}
		}

		// AI checks if it wants to release fire here
		if ( AI_WantsEarlyFire() && ChargeTimeCount >= MaxChargeTime &&
			GearAIController.IsFireLineClear() )
		{
			CheckFireShot();
			return;
		}

		// attempt to notify an AI being targeted by the bow as it charges
		// only guess a target once per shot so that if the player is good enough to be able to
		// successfully switch targets mid-charge, they get rewarded by the AI being unable to react
		if (Role == ROLE_Authority && !bGuessedTarget && ChargeTimeCount > 0.75)
		{
			StartTrace = GetMuzzleLoc();
			EndTrace = StartTrace + vector(GetAdjustedAim(StartTrace)) * 5000.0;
			HitPawn = Pawn(Trace(HitLocation, HitNormal, EndTrace, StartTrace, true,,, TRACEFLAG_Bullet));
			if (HitPawn != None && !WorldInfo.GRI.OnSameTeam(HitPawn, Instigator))
			{
				bGuessedTarget = true;
				if (GearAI(HitPawn.Controller) != None)
				{
					GearAI(HitPawn.Controller).ReceiveChargeTargetWarning(Instigator);
				}
			}
		}

		// no trail when blindfiring.
		if( P.IsLocallyControlled(PawnController) && P.IsHumanControlled(PawnController) &&
			P.bIsTargeting && (P.CoverType == CT_None || P.IsLeaning() || P.bDoing360Aiming) )
		{
			SimulateTrajectory();
		}
		else
		{
			StopSimulation();
		}
	}

	// Override this function, to keep the player pressing fire until all animations are ready.
	simulated function EndFire(byte FireModeNum)
	{
		CheckFireShot();
	}

	/** Returns TRUE if weapon wants to define focus loc, false otherwise. */
	simulated function bool GetCameraDOFFocusLocation(out vector FocusLoc)
	{
		if (SimulatedGrenade != None)
		{
			FocusLoc = SimulatedGrenade.Location;
			return TRUE;
		}
		return Super.GetCameraDOFFocusLocation(FocusLoc);
	}
}


/**
 * See if we can fire the shot now
 * May not be safe if we're transitioning, we can hit the cover wall
 */
simulated function bool CanReleaseFire()
{
	local GearPawn	WP;
	local bool		bPawnDelayingFire;

	if( GearAIController != none  && ChargeTimeCount < MaxChargeTime && !GearAIController.IsDead() )
	{
		return false;
	}

	WP = GearPawn(Instigator);
	if( WP != None && WP.CoverType != CT_None && (WP.IsBlindFiring(WP.CoverAction) || WP.CoverAction == CA_Default) )
	{
		bNoAnimDelayFiring	= FALSE;
		bPawnDelayingFire	= WP.ShouldDelayFiring();
		bNoAnimDelayFiring	= TRUE;
	}

	return !bPawnDelayingFire;
}

simulated function CheckFireShot()
{
	// See if we can fire the shot now
	// May not be safe if we're transitioning, we can hit the cover wall
	if( CanReleaseFire() )
	{
		GotoState('Fire');
	}
	else
	{
		bPendingEndFire = TRUE;
	}
}

simulated function NullAimSound()
{
	AimingSound = none;
}

simulated event WeaponFired(byte FiringMode, optional vector HitLocation)
{
	Super.WeaponFired(FiringMode, HitLocation);

	if (AimingSound != None)
	{
		AimingSound.FadeOut(0.5, 0.0);
		SetTimer(0.5, false, nameof(NullAimSound));
	}
}

/** Player releases fire button, weapon fires a shot */
simulated state Fire
{
	simulated event bool IsFiring()
	{
		return TRUE;
	}

	simulated function BeginState( Name PreviousStateName )
	{
		local gearpawn GP;
		//`log( WorldInfo.TimeSeconds @ GetStateName() @ GetFuncName() );

		// Make sure we're using the default firing mode.
		SetCurrentFireMode(0);

		GP = GearPawn(Instigator);
		if(GP != none && GP.MyGearAI != none)
		{
			// if we're being fired from an AI who is dead in the process of dying, reset charge time to min so it droops
			if(GP.Health <= 0)
			{
				ChargeTimeCount=MinChargeTime;
			}
		}
		// Fire the first shot right away
		FireAmmunition();
		TimeWeaponFiring(CurrentFireMode);

		// Release Fire button
		if( PendingFire(0) )
		{
			EndFire(0);
		}
	}

	simulated function RefireCheckTimer()
	{
		GotoState('Active');
	}

	simulated function EndState( Name NextStateName )
	{
		//`log( WorldInfo.TimeSeconds @ GetStateName() @ GetFuncName() );

		// Set weapon as not firing
		ClearFlashCount();
		ClearTimer( 'RefireCheckTimer' );
	}

}

simulated function PlayMaxCharge()
{
	local float Delta;
	local PlayerController PC;

	PC = PlayerController(GetWeaponController());
	if( PC != None )
	{
		PC.ClientPlayForceFeedbackWaveform(MaxChargeWaveform);

		if( ChargeTimeCount < MaxChargeTime + HoldTimeUntilTired )
		{
			Delta = FMax((MaxChargeTime + HoldTimeUntilTired - ChargeTimeCount)/HoldTimeUntilTired, 0.1f);
			SetTimer(Delta, FALSE, nameof(PlayMaxCharge));
		}
	}
}


simulated function RefireCheckTimer()
{
	if( bWeaponPutDown )
	{
		PutDownWeapon();
		return;
	}
}

/**
 * This will make the particle system for the grenade arc be invis.
 */
simulated function StopSimulation()
{
	if( PSC_Trail != None )
	{
		PSC_Trail.SetHidden(TRUE);
		PSC_Trail.DeactivateSystem();

		PSC_EndPoint.SetHidden(TRUE);
		PSC_EndPointFullCharge.SetHidden(TRUE);
		PSC_EndPointFullCharge.DeactivateSystem();
		PSC_EndPointFail.SetHidden(TRUE);
	}

	if( PSC_MaxChargeTrail != None )
	{
		PSC_MaxChargeTrail.DeActivateSystem();
		PSC_MaxChargeTrail.SetHidden(TRUE);
	}

	if ( SimulatedGrenade != None )
	{
		SimulatedGrenade.SetHidden( TRUE );
		SimulatedGrenade.SetCollision( FALSE, FALSE, FALSE );
		SimulatedGrenade.Disable( 'Tick' );
	}
}


/**
 * This is the function that will create all of the particle systems and emitters
 * needed to draw the grenade aiming arc.
 */
simulated function SetUpSimulation()
{
	if (PlayerController(GetWeaponController()) == None)
	{
		// no arc for AI
		return;
	}

	if( SimulatedGrenade == None || SimulatedGrenade.bDeleteMe )
	{
		GetWeaponController().ShotTarget = None; // make sure simulated projectile doesn't try to warn an old real target
		SimulatedGrenade = GearProj_Grenade(Spawn(WeaponProjectiles[0],,, GetPhysicalFireStartLoc()));
		if (SimulatedGrenade == None)
		{
			return;
		}
		SimulatedGrenade.RemoteRole = ROLE_None;
		SimulatedGrenade.bIsSimulating = TRUE;
		SimulatedGrenade.bIgnoreFoliageTouch = TRUE;
		SimulatedGrenade.SetOwner(Self);
		SimulatedGrenade.LifeSpan = 0.f;
		SimulatedGrenade.bAddBaseVelocity = FALSE;		// no base vel compensation for simulation, since that happens all in one frame
		if (SimulatedGrenade.TrailEmitter != None)
		{
			SimulatedGrenade.TrailEmitter.Destroy();
		}
	}

	SimulatedGrenade.SetHidden( FALSE );
	SimulatedGrenade.SetCollision( TRUE, FALSE, FALSE );
	SimulatedGrenade.Enable( 'Tick' );

	// grenade arc creation
	if (PSC_EndPoint.Owner != Instigator)
	{
		if( GetWeaponController().GetTeamNum() == 0 )
		{
			PSC_EndPoint.SetTemplate( PS_EndPointCOG );
		}
		else
		{
			PSC_EndPoint.SetTemplate( PS_EndPointLocust );
		}
 		PSC_EndPoint.SetTickGroup(TG_EffectsUpdateWork);
 		Instigator.AttachComponent(PSC_EndPoint);
 		PSC_EndPoint.ActivateSystem(TRUE);
	}
	if (PSC_EndPointFullCharge.Owner != Instigator)
	{
 		PSC_EndPointFullCharge.SetTemplate(PS_EndPointFullCharge);
 		PSC_EndPointFullCharge.SetTickGroup(TG_EffectsUpdateWork);
 		Instigator.AttachComponent(PSC_EndPointFullCharge);
	}
	if (PSC_EndPointFail.Owner != Instigator)
	{
		PSC_EndPointFail.SetTemplate(PS_EndPointFail);
		PSC_EndPointFail.SetTickGroup(TG_EffectsUpdateWork);
		Instigator.AttachComponent(PSC_EndPointFail);
	}

	if( PSC_Trail == None )
	{
		PSC_Trail = new(Outer) class'ParticleSystemComponent';
		if( GetWeaponController().GetTeamNum() == 0 )
		{
			PSC_Trail.SetTemplate(PS_TrailCOG);
		}
		else
		{
			PSC_Trail.SetTemplate(PS_TrailLocust);
		}

		PSC_Trail.SetOnlyOwnerSee(TRUE);
		PSC_Trail.SetActorParameter('TrailActor', SimulatedGrenade);
		PSC_Trail.SetTickGroup(TG_EffectsUpdateWork);

		SimulatedGrenade.AttachComponent(PSC_Trail);
		PSC_Trail.SetHidden(TRUE);
	}
}


/**
 * This will will simulate the grenade arc (in c++) and then tick the trail emitter
 * which causes the list of particles to grow.
 * At the end of the simulation the particle system has an entire trail of particles
 * representing the arc of the grenade toss.
 *
 * Then the arc is turned "on" so that it is visible to the client.
 */
simulated function SimulateTrajectory()
{
	local Vector	ImpactLoc, StartLoc, ImpactNormal, ImpactDiff;
	local Controller PawnController;

	// purely a client-side effect, no need for server to care
	PawnController = GetWeaponController();
	if ( (Instigator == None) || !Instigator.IsLocallyControlled(PawnController) || !Instigator.IsHumanControlled(PawnController) )
	{
		return;
	}

	SetUpSimulation();

	if( SimulatedGrenade == None || SimulatedGrenade.bDeleteMe )
	{
		`log("SimulatedGrenade == None || SimulatedGrenade.bDeleteMe");
		return;
	}

	// first time activation
	PSC_EndPointFail.SetHidden(TRUE);
	PSC_EndPoint.SetHidden(TRUE);

	PSC_Trail.KillParticlesForced();

	StartLoc = GetPhysicalFireStartLoc();

	// unhide arrow -- it will appear in the bow
	SimulatedGrenade.SetHidden(FALSE);
	SimulatedGrenade.SetLocation(StartLoc);

	DetermineAimingArrowTrajectory(SimulatedGrenade);

	// If the arrow is charged enough to stick, just do a trace and just use the impact location
	if( ChargeTimeCount < StickChargeTime )
	{
		PSC_Trail.SetHidden(FALSE);
		PSC_Trail.ActivateSystem(TRUE);

		SimulatedGrenade.RunPhysicsSimulationTilEnd(0.1f);
		ImpactLoc		= SimulatedGrenade.Location;
		ImpactNormal	= GearProj_ArrowBase(SimulatedGrenade).ImpactNormal;

		PSC_EndPoint.SetHidden(FALSE);
		PSC_EndPointFullCharge.SetHidden(TRUE);
	}
	else
	{
		ArrowInstantTrace(SimulatedGrenade.Location, SimulatedGrenade.Location + vector(GetAdjustedAim(SimulatedGrenade.Location)) * GetTraceRange(), ImpactLoc, ImpactNormal);
		SimulatedGrenade.Speed = 10000;
		SimulatedGrenade.SetLocation(ImpactLoc);

		PSC_EndPoint.SetHidden(TRUE);
		PSC_EndPointFullCharge.SetHidden(FALSE);
	
		// Make sure the appropriate trail effect is being used
		if( PSC_Trail.bIsActive )
		{   
			PSC_Trail.SetHidden(TRUE);
			PSC_Trail.ActivateSystem(FALSE);
		}
		if( !PSC_MaxChargeTrail.bIsActive )
		{
			PSC_MaxChargeTrail.SetHidden(FALSE);
			PSC_MaxChargeTrail.ActivateSystem(TRUE);
		}

		// If we didn't hit anything, just trace out to the max range
		if( !IsZero(ImpactLoc) )
		{
			PSC_MaxChargeTrail.SetVectorParameter('lock_on', ImpactLoc);
		}
		else
		{
			PSC_MaxChargeTrail.SetVectorParameter('lock_on', StartLoc + Vector(GetAdjustedAim(StartLoc)) * GetTraceRange());
		}
	}

	if( IsZero(ImpactNormal) )
	{
		ImpactNormal = vect(0,0,1);
	}

	// debug impact location
	//DrawDebugCoordinateSystem(ImpactLoc, Rotator(ImpactNormal), 25.f);

	ImpactDiff = TransformVectorByRotation(Instigator.Rotation, ImpactLoc - Instigator.Location, true) ;

	// position end points
	if( !PSC_EndPoint.HiddenGame )
	{
		PSC_EndPoint.SetTranslation(ImpactDiff);
		PSC_EndPoint.SetRotation(Rotator(ImpactNormal));

		if( !PSC_EndPoint.bIsActive )
		{
			PSC_EndPoint.ActivateSystem(TRUE);
		}
	}

	if( !PSC_EndPointFullCharge.HiddenGame )
	{
		PSC_EndPointFullCharge.SetTranslation(ImpactDiff);
		PSC_EndPointFullCharge.SetRotation(Rotator(ImpactNormal));

		if( !PSC_EndPointFullCharge.bIsActive )
		{
			PSC_EndPointFullCharge.ActivateSystem(TRUE);
		}
	}

// 	if( !PSC_EndPointFail.HiddenGame )
// 	{
// 		PSC_EndPointFail.SetTranslation(ImpactDiff);
// 		PSC_EndPointFail.SetRotation(Rotator(ImpactNormal));
// 	}
}

/** Perform a trace for the arrow in cases where it is going fast enough to be treated as instant */
simulated function Actor ArrowInstantTrace(vector StartTrace, vector EndTrace, optional out vector HitLocation, optional out vector HitNormal, optional out TraceHitInfo HitInfo)
{
	local Actor HitActor, NextHitActor;
	local bool bOldBlockActors, bOldCollideActors;

	HitActor = GetTraceOwner().Trace(HitLocation, HitNormal, EndTrace, StartTrace, TRUE,, HitInfo, TRACEFLAG_Bullet);

	// Pass through certain actors, such as triggers
	if( PassThroughDamage(HitActor) )
	{
		// Disable collision temporarily for the actor we can pass-through
		HitActor.bProjTarget = false;
		bOldCollideActors = HitActor.bCollideActors;
		bOldBlockActors = HitActor.bBlockActors;
		if( bOldBlockActors )
		{
			HitActor.SetCollision(bOldCollideActors, false);
		}
		// Recurse another trace and override NextHitActor
		NextHitActor = ArrowInstantTrace(HitLocation, EndTrace, HitLocation, HitNormal, HitInfo);

		// And reenable collision for the trigger
		HitActor.bProjTarget = true;
		HitActor.SetCollision(bOldCollideActors, bOldBlockActors);

		HitActor = NextHitActor;
	}

	return HitActor;
}

/** Overridden to use a trace for the arrow above a certain speed threshold */
simulated function Projectile ProjectileFire()
{
	local Projectile Proj;
	local GearProj_ArrowBase Arrow;
	local vector TraceEndLoc, ImpactLoc, ImpactNormal;
	local Actor HitActor;
	local TraceHitInfo HitInfo;

	Proj = Super.ProjectileFire();
	Arrow = GearProj_ArrowBase(Proj);

	// If the arrow is charged enough to stick, do a trace and just move the arrow to the impact location
	if( WorldInfo.Netmode != NM_Client && Arrow != None && ChargeTimeCount >= StickChargeTime )
	{
		TraceEndLoc = Arrow.Location + vector(GetAdjustedAim(Arrow.Location)) * GetTraceRange();
		HitActor = ArrowInstantTrace(Arrow.Location, TraceEndLoc, ImpactLoc, ImpactNormal, HitInfo);
		Arrow.Speed = 10000.f;
		Arrow.SetLocation(ImpactLoc);
		Arrow.HandleCollision(HitActor, HitInfo.HitComponent, ImpactLoc, ImpactNormal);

		// Continue forward if we popped someone's head and didn't stop
		if( Arrow.bHeadshotPassthrough && !Arrow.bHasCollided )
		{
			HitActor = ArrowInstantTrace(Arrow.Location, TraceEndLoc, ImpactLoc, ImpactNormal);
			Arrow.SetLocation(ImpactLoc);
			Arrow.HandleCollision(HitActor, HitInfo.HitComponent, ImpactLoc, ImpactNormal);
		}

		// Update flash location for tracer effects
		if( !IsZero(ImpactLoc) )
		{
			SetFlashLocation(ImpactLoc);
		}
		else
		{
			SetFlashLocation(TraceEndLoc);
		}
	}

	return Proj;
}

simulated function GetProjectileFirePosition( out vector out_ProjLoc, out vector out_ProjDir, optional out float out_ProjSpeed )
{
	local GearPawn		P;
	local vector		StartTrace, SafeSpawnLoc, TestLoc;

	P = GearPawn(Instigator);

	// This is where we would start an instant trace. (what CalcWeaponFire uses)
	StartTrace	= Instigator.GetWeaponStartTraceLocation();
	out_ProjDir	= Vector(GetAdjustedAim( StartTrace ));

	// this is the location where the projectile is spawned.
	out_ProjLoc		= GetMuzzleLoc();
	SafeSpawnLoc	= out_ProjLoc - out_ProjDir * 30.f;

	//DrawDebugLine(SafeSpawnLoc, out_ProjLoc, 255, 0, 0, TRUE);

	// If can't trace to real muzzle location, use safe one
	if( !FastTrace(out_ProjLoc, SafeSpawnLoc) )
	{
		out_ProjLoc = SafeSpawnLoc;
	}

	//DrawDebugSphere(out_ProjLoc, 4.f, 8, 255, 0, 0, TRUE);

	// Special case for mid level blind fire up
	// trace further, and if cover is hit, then adjust loc and dir of projectile to prevent
	// firing into cover wall.
	if( P.CoverType == CT_MidLevel && P.CoverAction == CA_BlindUp && !P.bDoing360Aiming )
	{
		TestLoc = out_ProjLoc + out_ProjDir * 30.f;

		//DrawDebugLine(TestLoc, out_ProjLoc, 0, 255, 0, TRUE);
		if( !FastTrace(TestLoc, out_ProjLoc) )
		{
			// adust location to a safer spot
			if( out_ProjLoc != SafeSpawnLoc )
			{
				out_ProjLoc = SafeSpawnLoc;
			}

			// adjust rotation, aim parallel to cover.
			out_ProjDir.Z	= Vector(P.Rotation).Z;
			out_ProjDir		= Normal(out_ProjDir);
		}
	}
}


/**
 * This will calculate the trajectory of the arrow then init the projectile
 * correctly.
 */
simulated function DetermineAimingArrowTrajectory(GearProj_Grenade AimArrow)
{
	local Vector ProjLoc, ProjDir;

	GetProjectileFirePosition(ProjLoc, ProjDir);

	AimArrow.Init(ProjDir);
}

simulated function bool ShouldDrawCrosshair()
{
	return FALSE;
}

simulated function bool IsApplicableForARDamageBonus()
{
	return TRUE;
}


exec function SetMode( Name Style )
{
	`log( "Mode:" @ Style );

	if( Style == 'Opened' )
	{
		CurrentStyle = EAS_Opened;
	}
	else if( Style == 'Targeting' )
	{
		CurrentStyle = EAS_TargetingOpens;
	}
	else
	{
		CurrentStyle = EAS_Closed;
	}
}

simulated function UpdateBowBasedOnTargeting()
{
	local GearPawn P;

	P = GearPawn(Instigator);

	if( !bOpened && P.bIsTargeting && HasAnyAmmo() && !bWeaponPutDown && !P.bSwitchingWeapons && Instigator.Weapon == self )
	{
		bOpened = TRUE;
		OpenBow();
	}
	else if( bOpened )
	{
		bOpened = FALSE;
		CloseBow();
	}
}

/** Notification that Targeting Mode has changed. */
simulated function TargetingModeChanged(GearPawn P)
{
	Super.TargetingModeChanged(P);

	if( CurrentStyle == EAS_TargetingOpens )
	{
		UpdateBowBasedOnTargeting();
	}
}

simulated function OpenBow()
{
	ClearTimer('OpenBow');
	PlayWeaponAnimByDuration('Open_Idle', EquipTime, EquipTime, -1.f, FALSE, FALSE);
}

simulated function CloseBow()
{
	PlayWeaponAnimByDuration('Close_Idle', PutDownTime, PutDownTime, -1.f, FALSE, FALSE);
}

simulated function TimeWeaponEquipping()
{
	Super.TimeWeaponEquipping();

	if( CurrentStyle == EAS_Opened )
	{
		SetTimer(0.3f, FALSE, nameof(OpenBow));
	}
	else if( CurrentStyle == EAS_TargetingOpens )
	{
		UpdateBowBasedOnTargeting();
	}
	else
	{
		PlayWeaponAnim('Close_Idle', 1.f, 0.05f, -1.f, FALSE, FALSE);
	}
}

simulated function TimeWeaponPutDown()
{
	Super.TimeWeaponPutDown();

	if( CurrentStyle == EAS_Opened )
	{
		CloseBow();
	}
	else if( CurrentStyle == EAS_TargetingOpens )
	{
		UpdateBowBasedOnTargeting();
	}
	else
	{
		PlayWeaponAnim('Close_Idle', 1.f, 0.05f, -1.f, FALSE, FALSE);
	}
}


/**
 * Event called when Pawn.FiringMode has been changed.
 * bViaReplication indicates if this was the result of a replication call.
 */
simulated function FireModeUpdated(byte FiringMode, bool bViaReplication)
{
	if( PreviousFiringMode != FiringMode )
	{
		// Call events that ended first
		switch( PreviousFiringMode )
		{
			case FIREMODE_CHARGE : ChargeEnded();	break;
		}

		// Then call events which started
		switch( FiringMode )
		{
			case FIREMODE_CHARGE : ChargeStarted();	break;
		}
	}

	Super.FireModeUpdated(FiringMode, bViaReplication);
}


/**
 * Event called when player starts to charge.
 * Called on all net modes.
 */
simulated function ChargeStarted()
{
	local float		AnimLength;
	if( CurrentStyle == EAS_Opened || CurrentStyle == EAS_TargetingOpens )
	{
		// Play charge animation
		AnimLength = PlayWeaponAnim('Tension_B', 1.f, 0.05f, -1.f, FALSE, FALSE);
	}
	else
	{
		// Play charge animation
		AnimLength = PlayWeaponAnim('Tension', 1.f, 0.05f, -1.f, FALSE, FALSE);
	}

	if (AimingSound == none)
	{
		AimingSound = CreateAudioComponent(AimLoop, FALSE, TRUE);
		if (AimingSound != None)
		{
			AimingSound.bUseOwnerLocation = TRUE;
			AimingSound.bAutoDestroy = FALSE;
			AimingSound.Location = Owner.Location;
			Owner.AttachComponent(AimingSound);
			AimingSound.Play();
		}
	}
	else
	{
		AimingSound.Play();
	}

	// Set timer to play a looping animation after the intro animation.
	SetTimer(AnimLength, FALSE, nameof(TensionIntroEnded));
}

/** Tension intro anim is done playing, we can blend in the looping animation. */
simulated function TensionIntroEnded()
{
	if( CurrentStyle == EAS_Opened || CurrentStyle == EAS_TargetingOpens )
	{
		// Play looping animation
		PlayWeaponAnim('Tension_Hold_B', 1.f, 0.05f, -1.f, TRUE, FALSE);
	}
	else
	{
		// Play looping animation
		PlayWeaponAnim('Tension_Hold', 1.f, 0.05f, -1.f, TRUE, FALSE);
	}
}


/**
 * Event called when player stops charging.
 * Called on all net modes.
 */
simulated function ChargeEnded()
{
	// Clear TensionIntro timer in case it hasn't been called yet.
	ClearTimer(nameof(TensionIntroEnded));
}


/**
 * Event called when player starts being tired.
 * Called on all net modes.
 */
simulated function TiredStarted()
{
	if( CurrentStyle == EAS_Opened || CurrentStyle == EAS_TargetingOpens )
	{
		// Play firing animation to close bow
		PlayWeaponAnim('Fire_B', 1.f, 0.05f, -1.f, FALSE, FALSE);
	}
	else
	{
		// Play firing animation to close bow
		PlayWeaponAnim('Fire', 1.f, 0.05f, -1.f, FALSE, FALSE);
	}
}


/**
 * Event called when player stops being tired.
 * Called on all net modes.
 */
simulated function TiredEnded()
{
}


/** Event called when weapon fired */
simulated function PlayFireEffects(byte FireModeNum, optional vector HitLocation)
{
	Super.PlayFireEffects(FireModeNum, HitLocation);

	if( CurrentStyle == EAS_Opened || CurrentStyle == EAS_TargetingOpens )
	{
		// Play firing animation to close bow
		PlayWeaponAnim('Fire_B', 1.f, 0.05f, -1.f, FALSE, FALSE);
	}
	else
	{
		// Play firing animation to close bow
		PlayWeaponAnim('Fire', 1.f, 0.05f, -1.f, FALSE, FALSE);
	}

	// Hide Arrow Mesh.
	if( ArrowMesh != None )
	{
		ArrowMesh.SetHidden(TRUE);
	}
}

simulated function PlayOwnedFireEffects(byte FireModeNum, vector HitLocation)
{
	Super.PlayOwnedFireEffects(FireModeNum, HitLocation);

	// Play launching sound
	// This is using non replicated variables, so replicate the resulting sound instead to remote clients.
	WeaponPlaySound(LaunchSound);
}


simulated function PlayWeaponReloading()
{
	Super.PlayWeaponReloading();

	if( CurrentStyle == EAS_TargetingOpens )
	{
		UpdateBowBasedOnTargeting();
	}
}

// Don't want to stop weapon animations on torque bow. Post reload causes issues.
simulated function StopWeaponAnim(optional float BlendOutTime);

/** notification fired from Pawn animation when player grabs another magazine. */
simulated function Notify_AmmoGrab()
{
	// Skip on dedicated servers, below is just cosmetic
	if( WorldInfo.NetMode == NM_DedicatedServer )
	{
		return;
	}

	// Attach magazine mesh to left hand
	SetPawnAmmoAttachment(TRUE);
}


/** notification fired from Pawn animation when player puts new magazine in weapon. */
simulated function Notify_AmmoReload()
{
	// Skip on dedicated servers, below is just cosmetic
	if( WorldInfo.NetMode == NM_DedicatedServer )
	{
		return;
	}

	// Detach magazine mesh from instigator's left hand
	SetPawnAmmoAttachment(FALSE);

	if( ArrowMesh != None )
	{
		ArrowMesh.SetHidden(FALSE);
	}
}

/** If the animation notify got lost due to anim interruption, but we did reload, unhide the arrow */
simulated function EndReloadAnimations()
{
	Super.EndReloadAnimations();

	if (ArrowMesh != None)
	{
		ArrowMesh.SetHidden(FALSE);
	}
}

/*
simulated function LinearColor GetWeaponEmisColor_COG()
{
	return WorldInfo.Gears_COGWeapons.TorqueBow;
}

simulated function LinearColor GetWeaponEmisColor_Locust()
{
	return WorldInfo.Gears_LocustWeapons.TorqueBow;
}
*/

protected simulated function bool IsFireState( name StateName )
{
	return ( (StateName == 'Charge') || (StateName == 'Fire') );
}

simulated function PerformWeaponAttachment(SkeletalMeshComponent MeshCpnt, optional Name SocketName)
{
	local SkeletalMeshComponent WeaponMesh;

	Super.PerformWeaponAttachment(MeshCpnt, SocketName);

	WeaponMesh = SkeletalMeshComponent(Mesh);
	if( ArrowMesh != None && WeaponMesh != None && !WeaponMesh.IsComponentAttached(ArrowMesh) )
	{
		WeaponMesh.AttachComponentToSocket(ArrowMesh, ArrowSocket);

		// Set Shadow parent and light environment.
		ArrowMesh.SetShadowParent(MeshCpnt);
		ArrowMesh.SetLightEnvironment(GearPawn(Instigator).LightEnvironment);
	}

	// Player managed to cancel the reload right after we unhid the arrow, rehide it
	if (ArrowMesh != None && WeaponMagSize - AmmoUsedCount == 0)
	{
		ArrowMesh.SetHidden(TRUE);
	}
}


simulated function DetachWeapon()
{
	Super.DetachWeapon();

	if( ArrowMesh != None )
	{
		// remove shadow parent and light environment, as this causes a nice little crash when garbage collection is performed.
		ArrowMesh.SetShadowParent(None);
		ArrowMesh.SetLightEnvironment(None);
	}
}

/** Have a chance to not play the active reload failed animation */
simulated function bool ShouldPlayFailedActiveReload()
{
	// If we're more than half way through and the pawn is not holding the arrow anymore, then don't play the failed animation.
	if( (GetTimerCount('EndOfReloadTimer') / GetTimerRate('EndOfReloadTimer')) > 0.5f
		&& Instigator.Mesh != None && !Instigator.Mesh.IsComponentAttached(MagazineMesh) )
	{
		return FALSE;
	}

	return TRUE;
}

simulated function PlayMeleeAttack()
{
	super.PlayMeleeAttack();

	if (!bKickThisAttack)
	{
		GearWeaponPlaySoundLocal(BowMeleeSwingSound);
	}
}

/**
 * called when an AI us using this weapon and can't see its target.  Allows the weapon to override the aimloc and provide a safe fire spot when the target is not visible
 * @param out_AimLoc - the aimloc to be adusted
 */
function AdjustAIAimLocWhenCantSeeEnemy(out vector AimLoc)
{
	local float MinRad;
	local vector StartToEnd,StartTraceLoc,EndTraceLoc,perp;

	if( GearAIController == none || GearAIController.MyGearPawn == none || ChargeTimeCount < MinChargeTime )
	{
		return;
	}

	MinRad = class'GearProj_ArrowBase'.default.ExploDamageRadius;


	StartTraceLoc = GearAIController.MyGearPawn.GetWeaponStartTraceLocation();
	StartToEnd = Normal(AimLoc - StartTraceLoc);

	EndTraceLoc = StartTraceLoc + StartToEnd*MinRad*2.0f;

	// if we're going to hit something within explo radius, find a new spot
	if( !FastTrace(EndTraceLoc,StartTraceLoc,vect(0,0,0),true) )
	{
		// try to the right
		perp = (StartToEnd cross vect(0,0,1));

		EndTraceLoc = StartTraceLoc + StartToEnd*MinRad*4.0f;
		EndTraceLoc = EndTraceLoc + perp*100;

		if( !FastTrace(EndTraceLoc,StartTraceLoc,vect(0,0,0),true) )
		{

			// to the right didn't work, try to the left!
			EndTraceLoc = StartTraceLoc + StartToEnd*MinRad*4.0f;
			EndTraceLoc = EndTraceLoc - perp*100;

			if( !FastTrace(EndTraceLoc,StartTraceLoc,vect(0,0,0),true) )
			{

				// left didn't work, try direct perp
				EndTraceLoc = StartTraceLoc  - perp*100;


				if( !FastTrace(EndTraceLoc,StartTraceLoc,vect(0,0,0),true) )
				{

					// THAT didn't work, try other direct perp!
					// left didn't work, try direct perp
					EndTraceLoc = StartTraceLoc + perp*100;

					if( !FastTrace(EndTraceLoc,StartTraceLoc,vect(0,0,0),true) )
					{
						// if that didn't work just bail
						return;
					}
				}
			}
		}
	}

	AimLoc = EndTraceLoc;
}

defaultproperties
{
	WeaponStatName="TorqueBow"

	CurrentStyle=EAS_Opened	// default animation code is bow opened. This can be changed for easy testing.

	FiringStatesArray(0)="Charge"
	WeaponFireTypes(0)=EWFT_Projectile
	InstantHitDamageTypes(MELEE_ATTACK_FIREMODE)=class'GDT_MeleeBlade'

	TracerType=WTT_TorqueMaxSpeed
	TracerTypeAR=WTT_TorqueMaxSpeed
	bAllowTracers=true
	bAlwaysSpawnTracerSmoke=true

	bNoAnimDelayFiring=TRUE	// charge weapon, so no need to delay firing because of animation transitions.
	bWeaponCanBeReloaded=TRUE
	bAutoSwitchWhenOutOfAmmo=FALSE

	MinBlindFireUpAimPitch=-256
	MinBlindFireSideYaw=-600

	AIRating=1.f

	AmmoTypeClass=class'GearAmmoType_TorqueBow'

	Mesh=WeaponMesh
	DroppedPickupMesh=WeaponMesh

	FireOffset=(X=35,Y=0,Z=0)

	Begin Object Class=StaticMeshComponent Name=MagazineMesh0
		CollideActors=FALSE
		BlockActors=FALSE
		BlockZeroExtent=FALSE
		BlockNonZeroExtent=FALSE
		BlockRigidBody=FALSE
		bAcceptsDynamicDecals=FALSE
		MotionBlurScale=0.0
	End Object
	MagazineMesh=MagazineMesh0

	Begin Object Class=StaticMeshComponent Name=ArrowMesh0
		CollideActors=FALSE
		BlockActors=FALSE
		BlockZeroExtent=FALSE
		BlockNonZeroExtent=FALSE
		BlockRigidBody=FALSE
		bAcceptsDynamicDecals=FALSE
		MotionBlurScale=0.0
	End Object
	ArrowMesh=ArrowMesh0

	DamageTypeClassForUI=class'GDT_TorqueBow_Impact'

	bIsSuppressive=false
	bSniping=true
	bCanNegateMeatShield=true
	bIgnoresExecutionRules=true

	BS_PawnWeaponReload={(Stance=((Slot=BS_Layer1,AnimName="ADD_Torquebow_Reload"),
		(Slot=BS_Layer_MidCov_Ready,AnimName="ADD_Torquebow_Cov_Mid_Reload"),
		(Slot=BS_Layer_StdCov_Ready,AnimName="ADD_Torquebow_Cov_Std_Reload"))
		)}

	BS_PawnWeaponReloadFail={(Stance=((Slot=BS_Layer1,AnimName="ADD_Torquebow_Reload_Fail"),
		(Slot=BS_Layer_MidCov_Ready,AnimName="ADD_Torquebow_Cov_Mid_Reload_Fail"),
		(Slot=BS_Layer_StdCov_Ready,AnimName="ADD_Torquebow_Cov_Std_Reload_Fail"))
		)}

	Recoil_Hand={(
					LocAmplitude=(X=-8,Y=2,Z=-2),
					LocFrequency=(X=15,Y=10,Z=10),
					LocParams=(X=ERS_Zero,Y=ERS_Random,Z=ERS_Zero),
					RotAmplitude=(X=1500,Y=200,Z=0),
					RotFrequency=(X=8,Y=5,Z=0),
					RotParams=(X=ERS_Zero,Y=ERS_Random,Z=ERS_Zero),
					TimeDuration=0.5f
					)}

	Recoil_Spine={(
					RotAmplitude=(X=1000,Y=300,Z=0),
					RotFrequency=(X=10,Y=10,Z=0),
					RotParams=(X=ERS_Zero,Y=ERS_Random,Z=ERS_Zero),
					TimeDuration=1.0f
					)}

	MinChargeTime=0.3

	LC_EmisDefaultCOG=(R=0.0,G=25.0,B=100.0,A=1.0)
    LC_EmisDefaultLocust=(R=30.0,G=30.0,B=30.0,A=1.0)

    WeaponID=WC_TorqueBow

	// we run this in the PostUpdateWork tick group to handle the preview arc while riding on moving bases.
	// this isn't ideal, since we can't guarantee tick order within this group, so the whole purpose of this
	// group is violated, but luckily, it doesn't seem to be a problem in this instance.
	TickGroup=TG_PostUpdateWork

	// Max charge targeting beam emitter
	Begin Object Class=ParticleSystemComponent Name=TBParticleSystemComponent0
		bAutoActivate=FALSE
		bOnlyOwnerSee=TRUE
		TickGroup=TG_PostUpdateWork
	End Object
	PSC_MaxChargeTrail=TBParticleSystemComponent0

	Begin Object Class=ParticleSystemComponent Name=EndPoint0
		HiddenGame=TRUE
		bOnlyOwnerSee=TRUE
	End Object
	PSC_EndPoint=EndPoint0

	Begin Object Class=ParticleSystemComponent Name=EndPointFail0
		HiddenGame=TRUE
		bOnlyOwnerSee=TRUE
	End Object
	PSC_EndPointFail=EndPointFail0

	Begin Object Class=ParticleSystemComponent Name=EndPointFullCharge0
		HiddenGame=TRUE
		bOnlyOwnerSee=TRUE
	End Object
	PSC_EndPointFullCharge=EndPointFullCharge0
	ArrowSocket=Arrow
}
