
/**
 * GearProj_DiggerMissile
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearProj_DiggerMissile extends GearProj_DiggerGrenadeBase
	abstract;

/** speed when flying through the air */
var config float AirSpeed, AirSpeedAI;

/** sound played when hitting a GearPawn */
var SoundCue PawnHitSound;

/** pop up out of the ground parameters */
var float ExitGroundVelocity;
var float ExitGroundExplosionArmingDelay;
var float ExitGroundExplosionDelay;
var EPhysics ExitGroundPhysics;

/** used for clients to differentiate between burrowing stopping due to falling off a cliff and it doing so because it's doing the pop up to explosion */
var repnotify bool bExploding;

var() protected ParticleSystemComponent PSC_GroundTrail;
var() protected ParticleSystem EnterGroundEffect;
var() protected ParticleSystem ExitGroundEffect;
var DecalData EnterExitDecal;
var protected const SoundCue EnterGroundSoundCue;
var protected const SoundCue ExitGroundSoundCue;
/** ambient sound played while underground */
var SoundCue BurrowAmbientSound;

replication
{
	if (bNetDirty)
		bExploding;
}

simulated event ReplicatedEvent(name VarName)
{
	// suppress default call of ExitGroundAndExplode() if we're continuing off a cliff
	if (VarName == nameof(bBurrowing) && !bBurrowing)
	{
		return;
	}

	if (VarName == nameof(bExploding))
	{
		if (bExploding)
		{
			ExitGroundAndExplode();
		}
	}
	else
	{
		Super.ReplicatedEvent(VarName);
	}
}

simulated function Init(vector Direction)
{
	if (GearAI(InstigatorController) != None && GearAI_TDM(InstigatorController) == None)
	{
		BurrowSpeed = BurrowSpeedAI;
		Speed = AirSpeedAI;
	}
	else
	{
		Speed = AirSpeed;
	}

	Super(GearProjectile).Init(Direction);

	// if we are using this projectile for trajectory simulation, then set it up
	if (bIsSimulating)
	{
		LifeSpan = 0.0;

		if (Mesh != None)
		{
			DetachComponent(Mesh);
			Mesh = None;
		}
	}
}

simulated event Landed(vector HitNormal, Actor FloorActor)
{
	local vector HitLocation, TraceHitNormal;
	local TraceHitInfo HitInfo;

	Trace(HitLocation, TraceHitNormal, Location + Velocity, Location, true,, HitInfo);

	LastTraceResultLoc = Location;
	LastTraceResultNormal = HitNormal;
	LastTraceResultPhysMaterial = HitInfo.PhysMaterial;

	StartBurrowingFX();

	SetPhysics(PHYS_Custom);
	Velocity.Z = 0.0;
	if (IsZero(Velocity))
	{
		Velocity = vector(Rotation);
		Velocity.Z = 0.0;
	}
	Velocity = Normal(Velocity);
	BurrowDir = Velocity;
	bCollideWorld = false;
}

/** handles colliding with a Pawn in flight, for the burrow death
 * server only, results replicated to clients
 */
final function HandlePawnCollision(Pawn P)
{
	local GearPawn GP;
	local rotator NewRot;

	if (!bIsSimulating)
	{
		GP = GearPawn(P);
		// redirect to kidnapper if we hit a hostage, since this weapon should go through meatbags
		if (GP != None && GP.IsAHostage())
		{
			GP = GP.InteractionPawn;
		}
		if ( GP != None && GP.CanBeSpecialMeleeAttacked(GearPawn(Instigator)) && GP.CanDoSpecialMove(SM_DiggerChestDrill) &&
			(GearAI(InstigatorController) == None || GearAI_TDM(InstigatorController) != None) &&
			(WorldInfo.GRI == None || !WorldInfo.GRI.OnSameTeam(InstigatorController, GP)) )
		{
			PlaySound(PawnHitSound);
			if (!IsZero(Velocity))
			{
				SetLocation(P.Location + vect(0,0,0.4) * P.GetCollisionHeight() - Normal(Velocity) * 40.0); // pull back a bit since the projectile is zero extent
				NewRot = P.Rotation;
				NewRot.Yaw = rotator(-Velocity).Yaw;
				P.SetRotation(NewRot);
				P.ClientSetRotation(NewRot);
				SetBase(P);
			}
			StopSimulating();
			GSM_DiggerChestDrill(GP.SpecialMoves[SM_DiggerChestDrill]).Digger = self;
			GP.ServerDoSpecialMove(SM_DiggerChestDrill, true);

			// abort normal explosion, let the special move handle it
			ClearTimer(nameof(DoExplosion));
			ClearTimer(nameof(WarnProjExplode));
		}
		else
		{
			DoExplosion();
		}
	}
	else
	{
		// end the simulation when we hit a Pawn
		SetPhysics(PHYS_None);
	}
}

simulated event HitWall(vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
	if (Pawn(Wall) != None)
	{
		HandlePawnCollision(Pawn(Wall));
	}
	// sometimes we get HitWall() even when falling straight down, so redirect if we're already doing that
	else if (Physics == PHYS_Falling && VSize2D(Velocity) ~= 0.0)
	{
		Landed(HitNormal, Wall);
	}
	else
	{
		Velocity.X = 0.0;
		Velocity.Y = 0.0;
		SetPhysics(PHYS_Falling);
	}
}

simulated function HandleCollision(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal)
{
	if (Pawn(Other) != None)
	{
		HandlePawnCollision(Pawn(Other));
	}
	else
	{
		Super.HandleCollision(Other, OtherComp, HitLocation, HitNormal);
	}
}

simulated event bool ValidateHitObstacle(Actor Obstacle)
{
	if (!bIsSimulating)
	{
		// damage fracturables we move under
		if (FracturedStaticMeshActor(Obstacle) != None)
		{
			Obstacle.TakeDamage(500, InstigatorController, Location, vect(0,0,0), ExplosionTemplate.MyDamageType);
		}
	}

	return Super.ValidateHitObstacle(Obstacle);
}

simulated function DoExplosion()
{
	Super(GearProj_Grenade).DoExplosion();
}

simulated function Tick(float DeltaTime)
{
	local GearGRI_Horde GRI;
	local GearFortification Fort;
	local float CheckDist;

	if (!bIsSimulating && Physics == PHYS_Custom)
	{
		// check for fortifications in the radius
		GRI = GearGRI_Horde(WorldInfo.GRI);
		if (GRI != None)
		{
			CheckDist = FMax(EnemyAttractRadius, EnemyAutoEmergeRadius) + 100.0; // extra to account for Z offset
			foreach GRI.Fortifications(Fort)
			{
				if (VSize(Location - Fort.Location) < CheckDist && (InstigatorController == None || !WorldInfo.GRI.OnSameTeam(InstigatorController, Fort)))
				{
					ExitGroundAndExplode();
					break;
				}
			}
		}
	}

	Super.Tick(DeltaTime);
}

static simulated function float StaticGetTimeToLocation(vector TargetLoc, vector StartLoc, Controller RequestedBy)
{
	//@warning: assumes air speed roughly equivalent to ground speed
	return (VSize(TargetLoc - StartLoc) / default.BurrowSpeed);
}

simulated function InitForSimulation()
{
	super.InitForSimulation();

	// get rid of unnecessary components, so we don't tick them
	DetachComponent(PSC_GroundTrail);
	PSC_GroundTrail = None;
}

simulated protected function StartBurrowingFX()
{
	local ParticleSystem EntrySystem, TrailSystem;

	Super.StartBurrowingFX();

	if (!bIsSimulating)
	{
		if( WorldInfo.NetMode != NM_DedicatedServer )
		{
			// see if physical material wants different effects
			class'GearPhysicalMaterialProperty'.static.GetDiggerEffects(LastTraceResultPhysMaterial, EntrySystem,, TrailSystem, EnterExitDecal);
			if( EntrySystem != None )
			{
				EnterGroundEffect = EntrySystem;
			}
			if( TrailSystem != None )
			{
				PSC_GroundTrail.SetTemplate(TrailSystem);
			}

			// play "enter ground" effect at this location
			WorldInfo.MyEmitterPool.SpawnEmitter(EnterGroundEffect, Location, Rotation);
			if( EnterExitDecal.bIsValid )
			{
				WorldInfo.MyDecalManager.SpawnDecal(EnterExitDecal.DecalMaterial, Location, rotator(-LastTraceResultNormal), EnterExitDecal.Width, EnterExitDecal.Height, EnterExitDecal.Thickness, !EnterExitDecal.ClipDecalsUsingFastPath,,,,,,, EnterExitDecal.LifeSpan);
			}
		}

		PlaySound(EnterGroundSoundCue, true);
		StopInFlightAudio();
		InFlightSoundTemplate = BurrowAmbientSound;
		StartInFlightAudio();

		Mesh.SetHidden(TRUE);
		PSC_GroundTrail.SetActive(TRUE);

		SetTimer(0.1, true, nameof(DoBurrowForceFeedback));
	}
}

simulated protected function ExitGroundAndExplode()
{
	local ParticleSystem ExitSystem;

	bExploding = TRUE;

	Super.ExitGroundAndExplode();

	if (bIsSimulating)
	{
		SetPhysics(PHYS_None);
	}
	else
	{
		if (WorldInfo.NetMode != NM_DedicatedServer)
		{
			// see if physical material wants different effects
			class'GearPhysicalMaterialProperty'.static.GetDiggerEffects(LastTraceResultPhysMaterial,, ExitSystem,, EnterExitDecal);
			if (ExitSystem != None)
			{
				ExitGroundEffect = ExitSystem;
			}

			// play "exit ground" effect at this location
			WorldInfo.MyEmitterPool.SpawnEmitter(ExitGroundEffect, Location, rotator(vect(0,0,1)));
			if (EnterExitDecal.bIsValid)
			{
				WorldInfo.MyDecalManager.SpawnDecal(EnterExitDecal.DecalMaterial, LastTraceResultLoc, rotator(-LastTraceResultNormal), EnterExitDecal.Width, EnterExitDecal.Height, EnterExitDecal.Thickness, !EnterExitDecal.ClipDecalsUsingFastPath,,,,,,, EnterExitDecal.LifeSpan);
			}
		}

		PlaySound(ExitGroundSoundCue, true);
		StopInFlightAudio();

		// turn off ground trail
		PSC_GroundTrail.SetActive(false);

		bRotationFollowsVelocity = false;
		SetRotation(rotator(vect(0,0,1)));

		// turn mesh back on
		Mesh.SetHidden(false);

		// launch upward
		setPhysics(ExitGroundPhysics);
		Velocity = vect(0,0,1) * ExitGroundVelocity;
		Acceleration = vect(0,0,0);

		// turn collision back on shortly

		BeginExplosionSequence(ExitGroundExplosionArmingDelay, ExitGroundExplosionDelay);

		ClearTimer(nameof(DoBurrowForceFeedback));

		// warn AI of the impending explosion
		if (Role == ROLE_Authority)
		{
			SetTimer(0.5 * FRand(), false, nameof(WarnProjExplode));
		}
	}
}

simulated event BurrowedOffCliff(vector FinalLoc)
{
	local vector ForwardLoc;

	// if we encountered a cliff while burrowing under something, then we're probably under the world, so stop here
	if (!bQuietBurrowing)
	{
		// allow projectile to keep going when burrowing off relatively small cliffs
		ForwardLoc = FinalLoc + BurrowDir * 50.0;
		if ( FastTrace(ForwardLoc, Location,, true) && FastTrace(FinalLoc - vect(0,0,10), FinalLoc,, true) &&
			FastTrace(FinalLoc, FinalLoc + vect(0,0,100),, true) && !FastTrace(ForwardLoc - vect(0,0,400), ForwardLoc,, true) )
		{
			SetPhysics(PHYS_Falling);
			Velocity = BurrowDir * BurrowSpeed;
			bCollideWorld = true;

			StopInFlightAudio();
			PSC_GroundTrail.SetActive(false);
			Mesh.SetHidden(false);
			ClearTimer(nameof(DoBurrowForceFeedback));
			bBurrowing = false;
			bQuietBurrowing = false;
		}
	}
}

/** Event called when bQuietBurrowing flag changed status */
simulated event QuietBurrowingChanged()
{
	Super.QuietBurrowingChanged();

	if( !bIsSimulating && bBurrowing )
	{
		// Toggle Particle System when needed. SetActive can be safely called every frame.
		PSC_GroundTrail.SetActive(!bQuietBurrowing);
	}
	else
	{
		PSC_GroundTrail.SetActive(FALSE);
	}
}

defaultproperties
{
	CollisionComponent=CollisionCylinder

	Physics=PHYS_Falling
	GravityScale=0.65
	bCollideWorld=true
	bPerformGravity=false
	ExitGroundPhysics=PHYS_Falling
	ExitGroundVelocity=800.0
	EnemyAttractRadius=0.0
	EnemyAutoEmergeRadius=192.0
	StepUpDist=30.0
	BurrowTime=4.0

	ExitGroundExplosionArmingDelay=0.0f
	ExitGroundExplosionDelay=0.9f
}
