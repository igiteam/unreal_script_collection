/**
 * Mortar Projectile
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearProj_ClusterMortarBase extends GearProj_ExplosiveBase
	abstract
	config(Weapon);


var() protected StaticMeshComponent Mesh;

/** Internal.  How many times this proj has bounced. */
var transient int				BounceCount;

/** Sound that is played as the shell approaches impact. */
var() protected const SoundCue			IncomingSound;
/** AudioComponent that is actively playing IncomingSound. */
var transient protected AudioComponent	IncomingSoundAC;
/** Sound that is played on the shell immediately after launch, sort of an "outgoing" sound. */
var() protected const SoundCue			LaunchSound;
/** Sound that is played on the shell when it bounces off the world. */
var() protected const SoundCue			BounceSound;

/**
* This is the cos of the half angle of the cone that defines the angles of impact for which a
* mortar shell will embed/explode on impact, versus bouncing.
*/
var() protected const config float	ExplodeDotLimit;

var protected transient vector		AnticipatedHitLoc;
var protected transient vector		AnticipatedHitNorm;

var() protected const float			IncomingGUDSRadius;
var() protected const float			HitLocAdjustmentDistForGUDS;

var() protected const float			Bounciness;
var() protected const float			VelocityDampingFactor;

/** Essentially just an .ini-exposed version of the Speed var.*/
var() const config float			MortarLaunchSpeed;

var() transient GearPointOfInterest	POI;



/** How long before impact to explode. */
var() protected const config float	AirBurstLeadTime;

var() protected const config int	NumBombletsToSpawn;
//var()	config	array<vector2d>	BombletMinMaxLifespans;

var() protected const class<GearProjectile> BombletClass;

var() protected const float			BombletMaxSprayVel;

var() protected const vector2d		BombletVelInheritScaleRange;

var transient vector InstigatorToProj, SpawnLocation;
var transient int BombletSpawned, RowCnt, MaxBombletPerRow, BombletPerRow;
var transient float VelScale, DispersionAmt;

var protected const Material HotMaterial;

/** 
 * Save a reference to the instigator's weapon when we first spawn
 * since they may get killed before we can start the impact simulations
 */
var protected Weapon InstigatorWeapon;

/** Used to force replicate the mortar explosion, which is needed because of how the physics simulation works */
var protected transient repnotify bool bMortarHasExploded;

replication
{
	if (bNetDirty)
		bMortarHasExploded;
}

simulated function ReplicatedEvent(name VarName)
{
	if ( VarName == 'bMortarHasExploded' )
	{
		bMortarHasExploded = false;
		TriggerExplosion(Location, vect(0,0,1), None);
	}
	else 
	{
		Super.ReplicatedEvent(VarName);
	}
}

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	if (LaunchSound != None)
	{
		PlaySound(LaunchSound);
	}

	// copy data from inis to where it will be used
	Speed = MortarLaunchSpeed;
	MaxSpeed = Max(MaxSpeed, Speed);

	//if( Role == Role_Authority )
	//{
	//	POI = Spawn( class'GearPointOfInterest', self );
	//}

	// set to "hot" material
	Mesh.SetMaterial(0, HotMaterial);

	SetTimer(1.f,FALSE,nameof(ForceBounce));

	// for dummyfire weapons, get firing weapon from owner
	InstigatorWeapon = (Instigator != None) ? Instigator.Weapon : Weapon(Owner);
}



function Init(vector Direction)
{
	local vector CamLoc;
	local rotator CamRot;
	local GearPC PC;

	Super.Init(Direction);

	PC = (Instigator != None) ? GearPC(Instigator.Controller) : None;
	if (PC != None)
	{
		PC.GetPlayerViewPoint(CamLoc,CamRot);
		InstigatorToProj = vector(CamRot);
		InstigatorToProj.Z = 0;
	}
	else
	{
		InstigatorToProj = Direction;
		InstigatorToProj.Z = 0;
	}
}


simulated function Tick(float DeltaTime)
{
	super.Tick(DeltaTime);

	if (!IsTimerActive(nameof(ForceBounce)) && !IsTimerActive(nameof(DelayImpactAnticipation)))
	{
		AnticipateImpact();
	}

	// start incoming whistle sound at shot apex
	if ( (Velocity.Z < 0.f) && !bHasExploded && (IncomingSoundAC == None) && (IncomingSound != None) )
	{
		IncomingSoundAC = CreateAudioComponent(IncomingSound, FALSE, TRUE);
		if (IncomingSoundAC != None)
		{
			IncomingSoundAC.bUseOwnerLocation = TRUE;
			IncomingSoundAC.bAutoDestroy = TRUE;
			IncomingSoundAC.bShouldRemainActiveIfDropped = TRUE;

			IncomingSoundAC.Play();
		}
	}
}

protected simulated function DeferredDestroy(float DelaySec)
{
	// make sure we have enough time to spawn everything
	Super.DeferredDestroy(NumBombletsToSpawn * 0.35f + 1.f);
}

simulated function Destroyed()
{
	if (!bHasExploded)
	{
		// @fixme, need real normal
		TriggerExplosion(Location, vect(0,0,1), None);
	}

	super.Destroyed();
}

simulated function ForceBounce();

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
	if ( Other == Instigator )
		return;

	if ( !Other.IsA('Projectile') || Other.bProjTarget )
	{
		if (IsTimerActive(nameof(ForceBounce)))
		{
			Bounce(HitLocation,HitNormal);
		}
		else
		if ( Other != Instigator )
		{
			TriggerExplosion(HitLocation, HitNormal, Other);
		}
	}
}

simulated function Bounce(Vector HitLocation, Vector HitNormal)
{
	// bounce off wall with damping
	Velocity -= (1.f + Bounciness) * HitNormal * (Velocity Dot HitNormal);
	Velocity *= VelocityDampingFactor;

	// should we stop simulating?
	if( VSize(Velocity) < 10 )
	{
		StopSimulating();
	}
	/*
	else
	{
		// this will do a little jitter at the end.  We can add another velocity check to stop it
		PlaySound(BounceSound);
	}
	*/

	BounceCount++;

	StopInFlightAudio();
}

simulated protected function StopSimulating()
{
	super.StopSimulating();
	bRotationFollowsVelocity = FALSE;
}

simulated function HitWall(vector HitNormal, actor Wall, PrimitiveComponent WallComp)
{
	local float ImpactAngleDot;

	ImpactAngleDot = HitNormal dot Normal(Velocity);

	if (IsTimerActive(nameof(ForceBounce)))
	{
		Bounce(Location,HitNormal);
	}
	else if (ImpactAngleDot < -ExplodeDotLimit || BounceCount > 10)
	{
		TriggerExplosion(Location, HitNormal, None);
	}
	else
	{
		Bounce(Location, HitNormal);
	}
}

// To catch timer
simulated protected function DelayImpactAnticipation();


protected function TriggerMortarIncomingGUDS()
{
	local GearPawn TestP;
	local array<GearPawn> CandidateSpeakers;
	local vector ExplosionCenter, BombletDropDir;

	// AnticipatedHitLoc isn't actually where the "middle" of the explosion pattern is.  Adjust it.
	BombletDropDir = InstigatorToProj;
	BombletDropDir.Z = 0.f;
	BombletDropDir = Normal(BombletDropDir);
	ExplosionCenter = AnticipatedHitLoc + BombletDropDir * HitLocAdjustmentDistForGUDS;

//	DrawDebugSphere(ExplosionCenter, IncomingGUDSRadius, 12, 255, 120, 120, true);
	// build a list and pick one to instigate the event?
	foreach WorldInfo.AllPawns(class'GearPawn', TestP, ExplosionCenter, IncomingGUDSRadius)
	{
		if (TestP.IsValidGUDSSpeaker() && (Instigator == None || !TestP.IsSameTeam(Instigator)))
		{
			CandidateSpeakers.AddItem(TestP);
		}
	}
	if (CandidateSpeakers.length > 0)
	{
		TestP = CandidateSpeakers[Rand(CandidateSpeakers.length)];
		GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_IncomingEnemyMortarSpotted, TestP,, 0.5f);
	}
}

simulated protected function AnticipateImpact()
{
	local float TimeStep, SimTime, MaxTimeToSim;
	local vector NewPos, SimPos, SimVel;
	local ImpactInfo TestImpact;
	local bool bFullySim;

	if (IsZero(AnticipatedHitLoc))
	{
		bFullySim = true;
		MaxTimeToSim = 3.f;
		TimeStep = 0.2f;		// 5hz.  lower fidelity for first sim
	}
	else
	{
		MaxTimeToSim = AirBurstLeadTime;
		TimeStep = 0.125f;		// 8hz
	}

	if (MaxTimeToSim > 0.f && InstigatorWeapon != None)
	{
		SimPos = Location;
		SimVel = Velocity;

		for (SimTime=0; SimTime<MaxTimeToSim; SimTime+=TimeStep)
		{
			// integrate pos
			NewPos = SimPos + SimVel * TimeStep;

			// look for collisions
			TestImpact = InstigatorWeapon.CalcWeaponFire(SimPos, NewPos);
			if (TestImpact.HitActor != None)
			{
				// hit something, do airburst
				//`log(">>>>>"@GetFuncName()@TestImpact.HitActor@Location);
				if (bFullySim)
				{
					AnticipatedHitLoc = TestImpact.HitLocation;
					AnticipatedHitNorm = TestImpact.HitNormal;

					//DrawDebugSphere(AnticipatedHitLoc, 30.f, 12, 255, 255, 255, true);

					// delay further impact anticipation until almost there
					SetTimer(SimTime - (AirBurstLeadTime * 2.f), FALSE, nameof(DelayImpactAnticipation));

					TriggerMortarIncomingGUDS();
				}
				else
				{
					TriggerExplosion(Location, vect(0,0,1), TestImpact.HitActor);
				}
				break;
			}
			else
			{
				// actually advance to new pos
				SimPos = NewPos;

				// integrate vel
				SimVel += Acceleration * TimeStep;
			}
		}

		if (bFullySim)
		{
			// if we make it here, we didn't actually hit anything on the full sim.  wait a bit and let's try again
			SetTimer(0.5f, FALSE, nameof(DelayImpactAnticipation));
		}
	}
}


simulated function GearExplosionActor TriggerExplosion(vector HitLocation, vector HitNormal, Actor HitActor)
{
	local GearExplosionActor GEA;

	if (bMortarHasExploded)
	{
		return None;
	}

	GEA = super.TriggerExplosion(HitLocation, HitNormal, HitActor);

	bMortarHasExploded = true;

	StopInFlightAudio();

	if (IncomingSoundAC != None)
	{
		IncomingSoundAC.Stop();
		IncomingSoundAC = None;
	}

	// debug
	//FlushPersistentDebugLines();

	// now do extra stuff
	if (Role == ROLE_Authority)
	{
		// If we didn't hit someone directly, spawn bomblets
		SpawnLocation = HitLocation + (HitNormal * 8.f);

		RowCnt = 0;
		VelScale = 1.f;
		MaxBombletPerRow = 2;
		BombletPerRow = 0;
		DispersionAmt = 250.f;
		BombletSpawned = 0;

		// spawn the bomblets
		SpawnBomblet();
	}

	return GEA;
}



private function SpawnBomblet()
{
	local GearProjectile SpawnedBomblet;
	local rotator VelRot;
	local vector X, Y, Z, BombletInitVel;
	local vector2d DispersionRange;
	VelRot = rotator(InstigatorToProj);
	GetAxes(VelRot, X, Y, Z);
	// spawn the bomblets in a growing V formation
	DispersionRange.X = MaxBombletPerRow * (DispersionAmt * 0.5f) * -0.5f;
	DispersionRange.Y = -1.f * DispersionRange.X;
	SpawnedBomblet = Spawn(BombletClass, Instigator,, SpawnLocation + (X * RowCnt * DispersionAmt * RandRange(1.f,1.5f)) + Y * GetRangeValueByPct(DispersionRange,BombletPerRow/float(MaxBombletPerRow)));
	if (SpawnedBomblet != None)
	{
		if (InstigatorController != None)
		{
			SpawnedBomblet.InstigatorController = InstigatorController;
		}
		BombletInitVel = -Z * BombletMaxSprayVel * RandRange(0.2f,1.f);

		SpawnedBomblet.Init(Normal(BombletInitVel));
		SpawnedBomblet.Velocity = BombletInitVel;

		SpawnedBomblet.bSuppressAudio = bSuppressAudio;
	}
	//`log("spawned bomblet"@BombletSpawned$"/"$NumBombletsToSpawn);
	// check if we should continue spawning
	if (++BombletSpawned < NumBombletsToSpawn)
	{
		// check to see if we need to start a new row
		if (++BombletPerRow >= MaxBombletPerRow)
		{
			// increase the bomblets for this row
			MaxBombletPerRow = Min(MaxBombletPerRow+(RowCnt%2),NumBombletsToSpawn-BombletSpawned);
			//`log("new row"@RowCnt@"max per"@MaxBombletPerRow);
			BombletPerRow = 0;
			RowCnt++;
			// and delay the spawning of the next row
			SetTimer( RandRange(0.2,0.35f),FALSE,nameof(SpawnBomblet) );
		}
		else
		{
			// otherwise spawn more in this row
			if (FRand() < 0.65f)
			{
				SpawnBomblet();
			}
			else
			{
				SetTimer( RandRange(0.05,0.15f),FALSE,nameof(SpawnBomblet) );
			}
		}
	}
}

defaultproperties
{
	bNetTemporary=FALSE
//	Speed=3500			// defined in the weapons ini, see MortarLaunchSpeed variable
	MaxSpeed=20000

	GravityScale=2.f

	Physics=PHYS_Projectile

	Begin Object Class=StaticMeshComponent Name=StaticMeshComponent0
		HiddenGame=false
		CastShadow=false
		CollideActors=false
		BlockActors=false
		BlockZeroExtent=false
		BlockNonZeroExtent=false
		BlockRigidBody=false
		bDisableAllRigidBody=TRUE
		Scale=1.8
		Rotation=(Yaw=16384)
		LightEnvironment=MyLightEnvironment
    End Object
	Components.Add(StaticMeshComponent0)
	Mesh=StaticMeshComponent0

	// remove light environment
	Begin Object Name=MyLightEnvironment
	    bEnabled=FALSE
	End Object
	Components.Remove(MyLightEnvironment)
	ProjLightEnvironment=None

	RemoteRole=ROLE_SimulatedProxy

    Lifespan=10.0
	bNetInitialRotation=true
	bCollideComplex=TRUE	// Ignore simple collision on StaticMeshes, and collide per poly

	Bounciness=0.5f
	VelocityDampingFactor=0.5f

	bRotationFollowsVelocity=TRUE

	BombletMaxSprayVel=750
	BombletVelInheritScaleRange=(X=-0.25f,Y=1.25f)

	IncomingGUDSRadius=1500
	HitLocAdjustmentDistForGUDS=450
}


