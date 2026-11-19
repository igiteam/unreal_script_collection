/**
 * GearProj_Arrow
 * Projectile tailored for Torque Bow weapon.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearProj_ArrowBase extends GearProj_Grenade
	abstract
	config(Weapon);

var	protected const SoundCue FlyBySound;
var protected const SoundCue ImpactFleshSound;
var protected const SoundCue ImpactStickSound;
var protected const SoundCue RicochetSound;
var protected const SoundCue BounceSound;
var protected transient float LastBounceSoundTime;
var() protected const float RicochetSoundThresh;

var transient array<Actor> TemporarilyIgnoredActors;

/** percentage of how much weapon was charged. 0 -> 1.0 */
var protected repnotify transient float ChargePct;

/** Time in seconds before projectile explodes, after impact. */
var() protected const config float	TimeBeforeExplosion;

/** Normal vector of point of impact. To spawn effects */
var transient vector				ImpactNormal;

/** True if this arrow has ever collided with anything */
var transient bool		bHasCollided;

/** X=min speed (0 charge), Y=max speed (full charge)) */
var() protected config vector2d		SpeedRange;

/** The GearPawn this arrow is stuck in, if any */
var protected transient repnotify GearPawn StuckInPawn;

/** Damage type for this arrow if it is stuck in a pawn */
var protected const class<GearDamageType>	StuckInPawnDamageType;
/** damage type for headshots */
var class<GearDamageType> HeadshotDamageType;

var transient bool				bAllowBounce;
/** True if the arrow may stick in a pawn, false otherwise. */
var bool bAllowStickInPawn;

/** This fires off when it embeds into a wall or ground **/
var protected const ParticleSystem PS_ArrowImpactEffect;

/** This fires off when it embeds into a human **/
var protected const ParticleSystem PS_ArrowImpactEffectHuman;

/** Attached sparks that we need to hide once this arrow blows up **/
var protected transient Emitter Sparkies;

/** Don't want HandleCollision() to be re-entrant (it does a setlocation()) */
var protected transient bool bProcessingCollision;

/** Explosion to use if we're stuck in a pawn. */
var() protected const GearExplosionContent StuckInPawnExplosionTemplate, StuckInPawnExplosionTemplateLambent;
var() protected const GearExplosionContent StuckInPawnExplosionNoGoreTemplate;

/** Explosion sound for explosions that happen when the arrow is stuck in a pawn. */
var() protected const SoundCue			StuckInPawnExplosionSound;

/** Effect to play when grenade explodes in the air */
var() protected const ParticleSystem	InAirExplosionEmitterTemplate;
/** Explosion sound for explosions that happen when the arrow is mid-air. */
var() protected const SoundCue			InAirExplosionSound;

/** Did this arrow headshot and continue traveling during its lifetime */
var transient bool bHeadshotPassthrough;
var transient int NumKills;

replication
{
	if (bNetInitial)
		ChargePct, bAllowBounce;
	if (bNetDirty)
		StuckInPawn;
}

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	if( bDeleteMe )
	{
		return;
	}

	if( FlyBySound != None && WorldInfo.NetMode != NM_DedicatedServer )
	{
		PlaySound(FlyBySound,,, TRUE);
	}
}


/**
 * Figure out how to align explosion effects.
 */
simulated function Destroyed()
{
	local vector ExploNormal;

	// If we are being destroyed because we hit a physicsvolume - dont play explosion
	if(bHitPhysicsVolume)
	{
		return;
	}

	if( !IsZero(ImpactNormal) )
	{
		ExploNormal = ImpactNormal;
	}
	else if( VSize(Velocity) > 1 )
	{
		ExploNormal = Normal(Velocity) * -1.f;
	}
	else
	{
		ExploNormal = vect(0,0,1);
	}

	/*
	if( !bIsSimulating )
	{
		DrawDebugCoordinateSystem(Location, Rotator(ExploNormal), 50.f, TRUE);
	}
	*/

	// hide the sparkies if we have some
	if( Sparkies != none )
	{
		Sparkies.Destroy();
		Sparkies = None;
	}

	if (AvoidanceCylinder != None)
	{
		AvoidanceCylinder.Destroy();
		AvoidanceCylinder = None;
	}

	if (!bHasExploded)
	{
		TriggerExplosion(Location, ExploNormal, StuckInPawn);
	}

	if ( Role == ROLE_Authority && GearGRI(WorldInfo.GRI).IsMultiPlayerGame())
	{
		if (GearPC(InstigatorController) != None && bHeadshotPassthrough && NumKills > 1)
		{
			// @AWARD - Trick Shot
			GearPC(InstigatorController).NotifyEarnedAward('TrickShot');
		}
	}
}

function SetupAvoidanceCylinder()
{
	local float AvoidRadius;

	if( !bIsSimulating && !bGrenadeHasExploded && !bDeleteMe && AvoidanceCylinder == None )
	{
		AvoidRadius = GetAvoidanceRadius();
		AvoidanceCylinder = Spawn(class'AIAvoidanceCylinder',self,,Location,,,TRUE);
		if(AvoidanceCylinder!=none)
		{
			AvoidanceCylinder.SetBase(self);
			AvoidanceCylinder.SetCylinderSize(AvoidRadius,AvoidRadius*2.0f);
			AvoidanceCylinder.SetDontAffectMesh(true);
			AvoidanceCylinder.SetEnabled(true);
		}
		//DrawDebugSphere(Location,AvoidRadius,16,255,0,0,TRUE);
	}

}

simulated event ReplicatedEvent( name VarName )
{
	local TraceHitInfo EmptyHitInfo;

	if (VarName == 'ChargePct')
	{
		// if ChargePct is set, update client physics accordingly
		InitBasedOnChargePct();
	}
	else if (VarName == nameof(StuckInPawn))
	{
		if (StuckInPawn != None && Physics != PHYS_None)
		{
			StickTo(StuckInPawn, Location, -Normal(Velocity), EmptyHitInfo);
		}
	}
	else
	{
		Super.ReplicatedEvent(VarName);
	}
}


simulated function Init(vector Direction)
{
	local GearWeap_BowBase Bow;

	// we have to account for the case where we've been spawned penetrating something and thus already stuck to it
	if (Base == None)
	{
		if ( Role == ROLE_Authority )
		{
			Bow = GearWeap_BowBase(Owner);
			bAllowBounce = !bIsSimulating && (Bow.ChargeTimeCount < Bow.StickChargeTime);
			bAllowStickInPawn = default.bAllowStickInPawn;
			ChargePct = FClamp(Bow.ChargeTimeCount / Bow.MaxChargeTime, 0.f, 1.f);
			ImpactNormal = vect(0,0,0);

			// Update physics based on time weapon has been charged
			// this MUST be called before the Super call, where velocity is set.
			InitBasedOnChargePct();
		}
		BounceCount = 0;

		if (bRotationFollowsVelocity)
		{
			SetRotation(rotator(Direction));
		}

		Super.Init(Direction);
	}
}

/** Called once ChargePct has been set, to update physics */
simulated function InitBasedOnChargePct()
{
	local float Interp;

	// cubic seems to feel nice
	Interp = ChargePct * ChargePct * ChargePct * ChargePct * ChargePct;

	if( Role == Role_Authority )
	{
		// on server, set speed. Client will have updated replicated velocity.
		Speed = SpeedRange.X + ( Interp * (SpeedRange.Y - SpeedRange.X) );
	}

	// adjust gravity scale.
	GravityScale	= (1 - Interp) * default.GravityScale;
	RotationRate	= (1 - Interp) * default.RotationRate;
}

simulated function PlayBounceSound()
{
	if (`TimeSince(LastBounceSoundTime) > 0.3f)
	{
		if (VSize(Velocity) > RicochetSoundThresh)
		{
			PlaySound(RicochetSound, true);
		}
		else
		{
			PlaySound(BounceSound, true);
		}

		LastBounceSoundTime = WorldInfo.TimeSeconds;
	}
}

simulated function Bounce(Vector HitLocation, Vector HitNormal, Actor Other)
{
	PlayBounceSound();

	Velocity -= (1.f + Bounciness) * HitNormal * (Velocity Dot HitNormal);
	Velocity *= VelocityDampingFactor;

	bRotationFollowsVelocity = false;
	// no sticking after a bounce
	bAllowStickInPawn = false;
}

/** @return whether we can do the special headshot effect of instagib + pass through */
simulated function bool AllowHeadshots()
{
	return (!bIsSimulating && !bAllowBounce && bAllowStickInPawn);
}

/** Handle arrow collision */
simulated function HandleCollision(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal)
{
	local Pawn HitPawn;
	local TraceHitInfo HitInfo;
	local GearPawn GP;

	// make sure we're not ignored this actor
	if (!bIsSimulating && TemporarilyIgnoredActors.Find(Other) != INDEX_NONE)
	{
		return;
	}

	if (StuckInPawn != None)
	{
		//@note - touches getting stacked up, so in the case of a meatshield we'll first collide with the shield
		// and then process the kidnapper touch since the cylinders overlap, which would normally cause the arrow
		// to stick again into the second touch
		//`log("Already stuck, ignoring multiple collisions");
		return;
	}

	// make sure we haven't stopped moving already
	if (Physics != PHYS_Projectile)
	{
		return;
	}

	if( bHitPhysicsVolume || bProcessingCollision || Other == None || (Other == Instigator && bIgnoreInstigatorCollision) || Other.bTearOff || Other.IsA('Trigger'))
	{
		// shouldn't collide with instigator
		return;
	}

	GP = GearPawn(Other);
	if ( GP != None && AllowHeadshots() && !GP.ComponentIsAnEquippedShield(OtherComp) &&
		(GearAI(InstigatorController) == None || GearAI(InstigatorController).bCanHeadshot) )
	{
		CheckHitInfo( HitInfo, GP.Mesh, Normal(Velocity), HitLocation );
		if (GP.ShouldTorqueBowArrowGoThroughMe(self, HitInfo, HitLocation, Normal(Velocity)))
		{
			bHeadshotPassthrough = true;
			NumKills++;

			// blow off the head and keep traveling
			GP.TakeDamage(9999, InstigatorController, HitLocation, Normal(Velocity), HeadshotDamageType, HitInfo);
			return;
		}
	}

	//`log( WorldInfo.TimeSeconds @ GetFuncName() @ Other @bIsSimulating @Base@ShouldBounce(Other,HitNormal, OtherComp));

	bProcessingCollision = true;
	HitPawn = Pawn(Other);
	bHasCollided = true;

	// Touch() happens after a full movement, so HitLocation is not Location of the impact.
	// So move Arrow back to HitLocation, and add push it back a little more, so effect is visible.
	if( (HitPawn != None || Other.bProjTarget || Other.bWorldGeometry || Other.bBlockActors) && Location != HitLocation )
	{
		SetLocation(HitLocation + HitNormal * 4.f);
	}

	if (ShouldBounce(Other, HitNormal, OtherComp))
	{
		if (!Other.bWorldGeometry)
		{
			TemporarilyIgnoredActors.AddItem(Other);
		}

		// dampen the velocity more when bouncing off pawns
		VelocityDampingFactor = (HitPawn != None) ? (default.VelocityDampingFactor * 0.75) : default.VelocityDampingFactor;

		Bounce(HitLocation, Normal(HitNormal), Other);
		BounceCount++;
	}
	else
	{
		StickTo(Other, HitLocation, HitNormal, HitInfo);
	}

	if (!bIsSimulating && InFlightSound != None)
	{
		InFlightSound.FadeOut(0.5, 0.0);
	}
	bProcessingCollision = false;
}

simulated function StickTo(Actor Other, vector HitLocation, vector HitNormal, const out TraceHitInfo HitInfo)
{
	local Pawn HitPawn;

	HitPawn = Pawn(Other);
	if (bIsSimulating || HitPawn != None || Other.bProjTarget || Other.bWorldGeometry || Other.bBlockActors)
	{
		ImpactNormal = HitNormal;

		SetPhysics(PHYS_None);
		SetBase(None);

		// Turn on movement replication so that base, physics, location, rotation all get pushed.
		bUpdateSimulatedPosition = TRUE;

		if (!bIsSimulating)
		{
			bRotationFollowsVelocity = false;
			LifeSpan = TimeBeforeExplosion;
			bCollideWorld = false;

			// stick into whatever we hit
			if (HitPawn != None)
			{
				SetCollision(false, false);
				HitPawn.TakeDamage(45.0, InstigatorController, HitLocation, vect(0,0,1.f), class'GDT_TorqueBow_Impact', HitInfo);
				SetBase(Other,, SkeletalMeshComponent(HitInfo.HitComponent), HitInfo.BoneName);
				StuckInPawn = GearPawn(HitPawn);			// ok if this is None

				if (StuckInPawn != None)
				{
					AttacheeController = StuckInPawn.Controller;

					GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_StuckExplosiveToEnemy, Instigator, StuckInPawn, 0.3f);
				}

				// we want to leave it semi decent chance of having the sparkies be seen on guys that are around you
				// Pass the HitPawns location to relevancy test, since we care whether or not the pawn is currently visible.
				if ( HitPawn.EffectIsRelevant(HitPawn.Location, false, 4000) )
				{
					Sparkies = Spawn(class'SpawnedGearEmitter',,, HitLocation, Rotation);
					Sparkies.SetTemplate(PS_ArrowImpactEffectHuman, true);
					Sparkies.SetBase(Other);
					// this is semi lame hack as it is some how possible to have the sparkies get attached
					// to a pawn in between the target and yourself  and then those sparkies will never
					// go away.  So we just set the sparkies to hide themselves at the time of the explosion
					Sparkies.LifeSpan = TimeBeforeExplosion;
				}
			}
			else
			{
				// stick to whatever we hit.
				bCollideWorld = false;
				SetBase(Other);
				if ( Other.EffectIsRelevant(Location, false, 4000) )
				{
					WorldInfo.MyEmitterPool.SpawnEmitter(PS_ArrowImpactEffect, HitLocation, Rotation, Other);
				}
			}

			// since we hit something broadcast an avoidme radius
			SetupAvoidanceCylinder();
		}

		ImpactedActor = Other;
	}

	if (!bIsSimulating && Role == Role_Authority)
	{
		// Play Impact sounds
		if (BounceCount == 0)
		{
			if (HitPawn == None)
			{
				PlaySound(ImpactSound);
			}
			else
			{
				PlaySound(ImpactFleshSound);
				PlaySound(ImpactStickSound);
			}
		}
		else
		{
			PlayBounceSound();
		}
	}
}

/**
 * Test condition to validate a rebound
 *
 * @param	Touched, actor the grenade touched
 * @return	true if the grenade should bounce off
 */
simulated function bool ShouldBounce(Actor Touched, vector HitNormal, optional PrimitiveComponent HitComponent)
{
	local GearPawn P;
	local GearGRI GRI;

	P = GearPawn(Touched);
	if ( !bAllowStickInPawn && P != None )
	{
		return TRUE;
	}

	if (GearShield(Touched) != None)
	{
		return TRUE;
	}

	// If Shooter is NOT human controlled AND
	// Target cover is protecting the angle
	// always stick into hostages
	if( P != None && !P.IsAHostage() )
	{
		GRI = GearGRI(WorldInfo.GRI);
		if( (!Instigator.IsHumanControlled() && (GRI == None || !GRI.IsMultiplayerGame() || GRI.IsCoopMultiplayerGame()) &&
				P.IsProtectedByCover( Normal(P.Location-Instigator.Location) )) ||
			P.ComponentIsAnEquippedShield(HitComponent) )
		{
			// bounce
			return TRUE;
		}

		// disallow sticking in friendlies or guys we shouldn't have been able to shoot due to cover
		if (GRI != None && GRI.IsMultiPlayerGame())
		{
			GRI = GearGRI(WorldInfo.GRI);
			if ( (GRI != None && !GRI.bAllowFriendlyFire && GRI.OnSameTeam(P, Instigator)) ||
				P.MultiplayerCoverDamageAdjust(Normal(Velocity), Instigator, Location, 100.0) == 0 )
			{
				return TRUE;
			}
		}
	}

	return (bAllowBounce && BounceCount < MaxBounceCount);
}


simulated protected function GetRadialDamageValues(out float outDamage, out float outRadius, out float outFalloff)
{
	super.GetRadialDamageValues(outDamage, outRadius, outFalloff);

	if (StuckInPawn != None)
	{
		// the thinking here is that the victim absorbs most of the blast.. internally.
		outRadius *= 0.5f;
	}
}

simulated protected function PrepareExplosionTemplate()
{
	Super.PrepareExplosionTemplate();

	// use alternate explosion if stuck in pawn
	if (StuckInPawn != None)
	{
		if (WorldInfo.GRI.ShouldShowGore())
		{
			ExplosionTemplate.ContentTemplate = (GearPawnFX_Lambent(StuckInPawn.GearPawnFX) != None) ? StuckInPawnExplosionTemplateLambent : StuckInPawnExplosionTemplate;
		}
		else
		{
			ExplosionTemplate.ContentTemplate = StuckInPawnExplosionNoGoreTemplate;
		}

		ExplosionTemplate.ExplosionSound = StuckInPawnExplosionSound;
	}
	else if (!IsOnTheGround())
	{
		ExplosionTemplate.ParticleEmitterTemplate = InAirExplosionEmitterTemplate;
		ExplosionTemplate.ExplosionSound = InAirExplosionSound;
	}

	// @fixme, material based explosion effests, like the frag grenade?
}

simulated protected function PrepareExplosionActor(GearExplosionActor GEA)
{
	Super.PrepareExplosionActor(GEA);

	// The stuck in pawn should be the instigator for any kills outside of their own
	// Pawns that are already dead are excluded unless they died on this frame
	if (StuckInPawn != None && !StuckInPawn.IsAHostage() && (!StuckInPawn.bTearOff || StuckInPawn.TimeOfDeath == WorldInfo.TimeSeconds))
	{
		GEA.AttacheeController = AttacheeController;
	}
	else
	{
		GEA.AttacheeController = None;
	}
}

simulated function GearExplosionActor TriggerExplosion(vector HitLocation, vector HitNormal, Actor HitActor)
{
	local int           DamageToDo;
	local TraceHitInfo  HitInfo;
	local Vector        HL, HN;
	local Actor         HA;
	local GearTurret    HitTurret;

	// In campaign, treat torque hits on locust-driven turrets as if they hit the driver
	HitTurret = GearTurret(Base);
	if (HitTurret != None && HitTurret.Driver != None && 
		HitTurret.Driver.GetTeamNum() != TEAM_COG && WorldInfo.Game.IsA('GearGameSP_Base'))
	{
		StuckInPawn = GearPawn(HitTurret.Driver);
	}

	if (StuckInPawn != None)
	{
		// blow up the unfortunate dude we're embedded in
		ImpactedActor = StuckInPawn;

		if (Role == ROLE_Authority)
		{
			// do enough damage to kill most anything in one shot, but not boomers
			DamageToDo = 1000;
			if ( (!WorldInfo.GRI.IsMultiplayerGame() || WorldInfo.GRI.IsCoopMultiplayerGame()) &&
				StuckInPawn.IsHumanControlled() && GearPawnRidable_Base(StuckInPawn) == None &&
				GearPRI(StuckInPawn.PlayerReplicationInfo).Difficulty.default.bCanDBNO )
			{
				DamageToDo = Max(100, StuckInPawn.Health - ExploDamage - 20);
			}

			HA = Trace( HL, HN, Location + Vector(Rotation) * 32.f, Location, TRUE,, HitInfo, TRACEFLAG_Bullet );
			if( HA == StuckInPawn )
			{
				StuckInPawn.TakeDamage(DamageToDo, InstigatorController, Location, vect(0,0,1), StuckInPawnDamageType, HitInfo, self);
			}
			else
			{
				StuckInPawn.TakeDamage(DamageToDo, InstigatorController, Location, vect(0,0,1), StuckInPawnDamageType,, self);
			}

			if (StuckinPawn.Health <= 0)
			{
				NumKills++;
			}
		}
	}

	// also do normal explosion
	return Super.TriggerExplosion(HitLocation, HitNormal, HitActor);
}


defaultproperties
{
	bNetTemporary=false
	bHardAttach=true
	Lifespan=10.0
	StuckInPawnDamageType=class'GDT_TorqueBow_Explosion'
	HeadshotDamageType=class'GDT_TorqueBow_Impact'
	GravityScale=1.f
	bRotationFollowsVelocity=true
	bAllowStickInPawn=true

	//MomentumTransfer=1.f	// Scale momentum defined in DamageType
	VelocityDampingFactor=0.2
	Bounciness=0.33
	StopSimulatingVelocityThreshhold=1

	bCollideComplex=true	// Ignore simple collision on StaticMeshes, and collide per poly

	Begin Object Class=StaticMeshComponent Name=StaticMeshComponent0
		CollideActors=false
		BlockActors=false
		BlockZeroExtent=false
		BlockNonZeroExtent=false
		BlockRigidBody=false
		bDisableAllRigidBody=true
		Scale=1.0
		Scale3D=(X=1.0,Y=1.0,Z=1.0)
		Rotation=(Yaw=+16384)
		Translation=(X=0,Y=0,Z=0)
	End Object
	Mesh=StaticMeshComponent0
	Components.Add(StaticMeshComponent0)

	// remove light environment
	Begin Object Name=MyLightEnvironment
	    bEnabled=false
	End Object
	Components.Remove(MyLightEnvironment)
	ProjLightEnvironment=None


	Begin Object Name=CollisionCylinder
		CollideActors=true
	End Object

	// explosion
	Begin Object Class=GearExplosion Name=ExploTemplate0
		MyDamageType=class'GDT_TorqueBow_Explosion'
		MomentumTransferScale=1.0	// Scale momentum defined in DamageType

		FractureMeshRadius=80.0
		FracturePartVel=300.0

		bAllowPerMaterialFX=true
		bUsePerMaterialFogVolume=true
	End Object
	ExplosionTemplate=ExploTemplate0

	bStoppedByGrenadeBlockingVolume=false
	bIgnoreInstigatorCollision=true

	RicochetSoundThresh=3000
}
