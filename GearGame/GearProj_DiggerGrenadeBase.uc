
/**
 * GearProj_DiggerGrenadeBase
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearProj_DiggerGrenadeBase extends GearProj_Grenade
	native(Weapon)
	config(Weapon)
	abstract;

/** XZ dir of burrowing */
var protected vector BurrowDir;
var() protected const float StepUpDist;

/** Unreal Units/Sec. */
var() config float BurrowSpeed, BurrowSpeedAI;
var() config float BurrowAcceleration;
var() protected const float TraceDownDist;
var() protected const float TraceDownDist_Initial;

var() protected const vector2d BurrowDistPitchRange;
var() protected const vector2d BurrowDistRange;
var() protected const vector2d BurrowDistRangeUntargeted;
var float BurrowTime;
var protected float ElapsedBurrowTime;

/** tracking times when grenade is digging "under" something. */
var protected bool bQuietBurrowing;
var protected const float ResumeNormalBurrowingTime;

/** How far this can burrow "under" something, e.g. low cover */
var() protected const float MaxBurrowUnderDist;

/** Grenade will home a little towards enemies within this radius. */
var() float EnemyAttractRadius;
/** Within this distance of an enemy, grenade will burst out of ground and blow up. */
var() float EnemyAutoEmergeRadius;
var() protectedwrite const vector2d TurnScaleRange;

/** radius in which players get a controller rumble effect */
var config float BurrowShakeDistance;

/** Internal simulation vars. */
var protected float TimeTilNextTrace;
var protected const float TimeBetweenTraces;
var protectedwrite vector LastTraceResultLoc;
var protectedwrite vector LastTraceResultNormal;
var protected PhysicalMaterial LastTraceResultPhysMaterial;

var protected repnotify bool bBurrowing;
var config bool bBurrowBehindTargetInCover;


cpptext
{
protected:
	UBOOL InternalDoSim(FLOAT deltaTime);
	virtual UBOOL InternalDoTraces();
	void SetQuietBurrowing(UBOOL bValue);
public:
	virtual void physCustom(FLOAT deltaTime, INT Iterations);
};

replication
{
	if (bNetDirty)
		bBurrowing, bQuietBurrowing;
	if (bNetInitial)
		EnemyAttractRadius;
}

/** That function is specific to the grenade, we don't use it. */
simulated function DoExplosion();

simulated function ReplicatedEvent(name VarName)
{
	if (VarName == nameof(bBurrowing))
	{
		if (bBurrowing)
		{
			StartBurrowingFX();
		}
		else
		{
			ExitGroundAndExplode();
		}
	}
	else
	{
		super.ReplicatedEvent(VarName);
	}
}


simulated native function RunPhysicsSimulationTilEnd(float GrenadeLifeSpan);

simulated protected function bool FindGround(vector StartTrace, float TraceDist, out vector HitLocation, out vector HitNormal, out Actor HitActor, out PhysicalMaterial PhysMaterial)
{
	local vector EndTrace;
	local ImpactInfo Impact;

	// find new surface normal
	EndTrace = StartTrace;
	EndTrace.Z -= TraceDist;

	// @fixme, want to ignore dynamic actors too?
	GroundTrace(StartTrace, Endtrace, Impact);

	HitActor = Impact.HitActor;
	HitNormal = Impact.HitNormal;
	HitLocation = Impact.HitLocation;
	PhysMaterial = Impact.HitInfo.PhysMaterial;

	return Impact.HitActor != None;
}

/**
 * @fixme, move this out into native
 * Support non weapon case for baby corpser attack.
 */
simulated protected event bool GroundTrace(vector StartTrace, vector Endtrace, out ImpactInfo Impact)
{
	// Native trace
	NativeGroundTrace(StartTrace, Endtrace, Impact);

// 	// Uncomment to debug traces.
// 	if( Impact.HitActor != None )
// 	{
// 		DrawDebugLine(StartTrace, Impact.HitLocation, 255, 0, 0, TRUE);
// 		DrawDebugLine(Impact.HitLocation, Impact.HitLocation + Impact.HitNormal * VSize(StartTrace-Endtrace), 255, 0, 255, TRUE);
// 	}
// 	else if( bQuietBurrowing )
// 	{
// 		DrawDebugLine(StartTrace, Endtrace, 0, 0, 255, TRUE);
// 	}
// 	else
// 	{
// 		DrawDebugLine(StartTrace, Endtrace, 0, 255, 0, TRUE);
// 	}

	return Impact.HitActor != None;
}

/** Implemented Native function to handle traces on the ground. */
native simulated protected final function bool NativeGroundTrace(vector StartTrace, vector Endtrace, out ImpactInfo Impact);

/**
 *  Tell script about that new location, to give it a chance to deny that location for gameplay reasons.
 *  @return TRUE if next trace location is valid, FALSE otherwise.
 */
simulated event bool ValidateNextTraceLocation()
{
	return TRUE;
}

/*
 * Called when traces hit an obstacle.
 * Return FALSE to abort movement
 */
simulated event bool ValidateHitObstacle(Actor Obstacle)
{
	return TRUE;
}

/** Event called when bQuietBurrowing flag changed status */
simulated event QuietBurrowingChanged();

/** Implement in a subclass. */
simulated protected function StartBurrowingFX()
{
	bBurrowing = true;

	if (Role == ROLE_Authority)
	{
		SetTimer(0.25, true, nameof(NoiseTimer));
	}
}

/** called on a timer to call MakeNoise() periodically for AI info */
function NoiseTimer()
{
	if (!bQuietBurrowing)
	{
		MakeNoise(0.25);
	}
}

/** sends controller rumble to nearby players */
simulated final function DoBurrowForceFeedback()
{
	local PlayerController PC;

	foreach LocalPlayerControllers(class'PlayerController', PC)
	{
		if (PC.ViewTarget != None && VSize(PC.ViewTarget.Location - Location) < BurrowShakeDistance)
		{
			PC.ClientPlayForceFeedbackWaveform(class'GearWaveForms'.default.ActiveReloadSuccess);
		}
	}
}

simulated function Init(vector Direction)
{
	local Actor HitActor;
	local float BurrowDist;

	BurrowDir = Direction;
	BurrowDir.Z = 0.f;
	BurrowDir = Normal(BurrowDir);

	//BurrowDist = GetMappedRangeValue(BurrowDistPitchRange, BurrowDistRange, Normal(Direction).Z);
	if ( (GearPawn(Instigator) != None) && GearPawn(Instigator).bIsTargeting )
	{
		BurrowDist = GetMappedRangeValue(BurrowDistPitchRange, BurrowDistRange, float(rotator(Direction).Pitch));
	}
	else
	{
		BurrowDist = GetMappedRangeValue(BurrowDistPitchRange, BurrowDistRangeUntargeted, float(rotator(Direction).Pitch));
	}

	if (GearAI(InstigatorController) != None && GearAI_TDM(InstigatorController) == None)
	{
		BurrowSpeed = BurrowSpeedAI;
		// AI never gets acceleration
		BurrowAcceleration = 0.0;
	}

	BurrowTime = BurrowDist / BurrowSpeed;

 	// find starting point
 	if( FindGround(Location, TraceDownDist_Initial, LastTraceResultLoc, LastTraceResultNormal, HitActor, LastTraceResultPhysMaterial) )
 	{
 		SetLocation(LastTraceResultLoc);
		SetRotation(rotator(LastTraceResultNormal));

		if( !bIsSimulating && Role == Role_Authority )
		{
			StartBurrowingFX();
		}
 	}
	else
	{
		// how to handle this better?
		Destroy();
	}

	// intentionally not calling super here
}

simulated function Tick(float DeltaTime)
{
	Super.Tick(DeltaTime);

	if( !bIsSimulating )
	{
		if( (Physics == PHYS_Custom) && Role == Role_Authority )
		{
			DoSteering(DeltaTime);
		}

		if( bBurrowing )
		{
			if (Role == ROLE_Authority)
			{
				if (Physics == PHYS_None)
				{
					// done burrowing, eject from ground and explode
					ExitGroundAndExplode();
					return;
				}

				// Things we want to do only for the digger grenade, but not for the Mini Corpser
				DiggerGrenadeSpecialTick();
			}
		}
	}
}

/** Things we want to do only for the digger grenade, but not for the Mini Corpser */
simulated function DiggerGrenadeSpecialTick()
{
	local GearProj_DiggerGrenadeBase OtherDigger;

	// also pop up if we ram another digger
	foreach CollidingActors(class'GearProj_DiggerGrenadeBase', OtherDigger, 16.0,, false)
	{
		if (OtherDigger.bBurrowing)
		{
			ExitGroundAndExplode();
			OtherDigger.ExitGroundAndExplode();
			break;
		}
	}
}

/** Internal.  Homes grenade in on enemies. Server only. */
protected function DoSteering(float DeltaTime)
{
	local Pawn P, BestAttractP;
	local float BestAttractScore, Score, Dist;
	local vector ToPawn;

	foreach WorldInfo.AllPawns(class'Pawn', P, Location, FMax(EnemyAttractRadius, EnemyAutoEmergeRadius) + 100.0) // extra to account for Z offset
	{
		if (ValidatePawnForSteering(P))
		{
			ToPawn = P.Location - Location;
			Dist = VSize2D(ToPawn);
			// check for auto explosion
			if (PawnDistanceCheck(P, ToPawn, Dist))
			{
				return;
			}
			if (Dist < EnemyAttractRadius)
			{
				// favor targets more aligned with dir of travel
				// reject targets behind
				Score = BurrowDir dot ToPawn;		// 0..1
				if (Score > 0.f)
				{
					// favor closer targets
					Score += (1.f - Dist / EnemyAttractRadius);		// 0..1
				}

				if (Score > BestAttractScore)
				{
					BestAttractScore = Score;
					BestAttractP = P;
				}
			}
		}
	}

	ProcessBestSteeringTarget(BestAttractP, DeltaTime);
}

protected function bool ValidatePawnForSteering(Pawn TestPawn)
{
	local GearPawn GP;

	GP = GearPawn(TestPawn);
	return (!TestPawn.IsInvisible() && !Instigator.IsSameTeam(TestPawn) && (TestPawn.Health > 0 || (GP != None && GP.IsDBNO())));
}

protected function ProcessBestSteeringTarget(Pawn BestPawn, float DeltaTime)
{
	if (BestPawn != None)
	{
		// steer towards him
		SteerTowardsTarget(BestPawn.Location, DeltaTime);
	}
}

protected function SteerTowardsTarget(Vector TargetLocation, float DeltaTime)
{
	local Vector AccelDir, ToTarget;
	local float AccelMag;

	// accel perpendicular to desired axis of rot
	ToTarget = TargetLocation - Location;
	ToTarget.Z = 0.f;
	AccelDir = Normal( BurrowDir cross (ToTarget cross BurrowDir) );

	AccelMag = 1.f - ( Normal(ToTarget) dot Normal(BurrowDir) );
	AccelMag = GetRangeValueByPct(TurnScaleRange, AccelMag);

	// add acceleration, then renormalize to get just the dir
	BurrowDir = Normal( (BurrowDir * BurrowSpeed) + (AccelDir * AccelMag * DeltaTime) );
}

/**
 * Called by the steering code to do checks against nearby Pawns.
 * @return TRUE to stop Pawn check.
 */
protected function bool PawnDistanceCheck(Pawn InPawn, vector ToPawn, float Dist2D)
{
	local vector ToPawnNoZ;
	local GearPawn GP;
	local Vector PopupCheckLoc, HitLocation, HitNormal;

	if (Dist2D < EnemyAutoEmergeRadius)
	{
		GP = GearPawn(InPawn);
		if (GP == None)
		{
			// don't need to check cover for non GearPawns
			CloseEnoughToPawn();
			return true;
		}
		else
		{
			ToPawnNoZ = ToPawn;
			ToPawnNoZ.Z = 0.0f;
			PopupCheckLoc = Location;
			PopupCheckLoc.Z += 120.f;

			if ( !GP.IsProtectedByCover(ToPawnNoZ, true, bBurrowBehindTargetInCover) &&
				(GP.EquippedShield == None || (NoZDot(Normal(ToPawnNoZ), Normal(Velocity)) < 0.0 && VSize(ToPawnNoZ) > GP.CylinderComponent.CollisionRadius)) &&
				class'NavigationHandle'.static.GetPylonFromPos(PopupCheckLoc) != None )
			{

 				if (class'NavigationHandle'.static.ObstacleLineCheck(PopupCheckLoc, GP.Location, HitLocation, HitNormal))
 				{
					// Close enough, blow up.
					CloseEnoughToPawn();
					return true;
 				}
			}
		}
	}

	return false;
}

simulated protected function CloseEnoughToPawn()
{
	// just blow up.  nothing more to do here
	ExitGroundAndExplode();
}

simulated protected function ExitGroundAndExplode()
{
	bBurrowing = false;

	ClearTimer(nameof(NoiseTimer));
}

/** called when burrowing and there is no longer ground below us; i.e. we fell off a cliff
 * this function can change physics to keep the projectile going; default behavior is to go to PHYS_None
 * @param FinalLoc - the start location for the trace that failed to find ground
 */
simulated event BurrowedOffCliff(vector FinalLoc);

simulated function GearExplosionActor TriggerExplosion(vector HitLocation, vector HitNormal, Actor HitActor)
{
	local GearSpawner_EmergenceHoleBase Hole;
	local vector Momentum;
	local GearExplosionActor GEA;

	if (!bIsSimulating && !bGrenadeHasExploded)
	{
		// @fixme, not sure why hitlocation is passed in for momentum, but that's how the old code was...
		// double check this to see if this ia bug
		//Momentum = MomentumTransfer;
		Momentum = HitLocation + HitNormal * 3;

		if( Role == Role_Authority )
		{
			// blow up melee/held guys
			// this stops any exploits of some how getting the HurtOrigin inside a wall or object such that the line checks will fail to hurt the victim
			if( TagVictim != none )
			{
				TagVictim.TakeDamage( 9999.f, InstigatorController, HitLocation, Momentum, class'GDT_FragTag',, self );
			}
			if ( MartyrVictim != None )
			{
				MartyrVictim.TakeDamage( 9999.f, InstigatorController, HitLocation, Momentum, class'GDT_FragMartyr',, self );
			}
		}

		GEA = Super.TriggerExplosion(HitLocation, HitNormal, HitActor);

		if( Role == Role_Authority )
		{
			// check for e-hole near-misses to give player feedback
			// do this after the super call, so the damage has been applied
			foreach CollidingActors(class'GearSpawner_EmergenceHoleBase', Hole, ExploDamageRadius*2, HitLocation)
			{
				if (Hole.HoleStatus == HS_Open)
				{
					// didn't die in the hurtradius call, notify
					GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_EHoleGrenadeMissed, Instigator);
				}
			}
		}
	}

	return GEA;
}

simulated function name AttachInit(Actor Attachee)
{
	local GearPawn VictimGP;

	VictimGP = GearPawn(Attachee);
	if (VictimGP != None)
	{
		GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_StuckExplosiveToEnemy, Instigator, VictimGP, 1.f);
	}

	return super.AttachInit(Attachee);
}

defaultproperties
{
	RemoteRole=ROLE_SimulatedProxy
	bUpdateSimulatedPosition=TRUE
	bReplicateMovement=true

	MaxSimulationTime=10.f
	Physics=PHYS_Custom
	CollisionComponent=None
	bCollideWorld=FALSE
	bNoEncroachCheck=TRUE

	GravityScale=1.f

	BurrowDistPitchRange=(X=2000,Y=-8000.f)
	BurrowDistRange=(X=3500.f,Y=100.f)
	BurrowDistRangeUntargeted=(X=2000.f,Y=1500.f)
	StepUpDist=50.f
	TimeBetweenTraces=0.05f	// 20hz
	TraceDownDist=100		// should be StepUpDist * 2?
	TraceDownDist_Initial=200
	MaxBurrowUnderDist=200

	EnemyAttractRadius=400
	EnemyAutoEmergeRadius=128
	TurnScaleRange=(X=500.f,Y=800.f)

	bNetTemporary=false
}
