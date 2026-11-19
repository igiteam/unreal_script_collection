/**
 * "Untargeted" flavor of the Mortar Projectile, for mortar shots
 * from the hip.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearProj_MortarUntargetedBase extends GearProj_ClusterMortarBase
	abstract
	config(Weapon);

var() protected const config float		TimeBeforeMortarCanExplode;

var() protected const config vector2d	ExplosionDelayRange;
var protected transient vector			LastHitNormal;

simulated function DelayedExplosion()
{
	if (!bHasExploded)
	{
		TriggerExplosion(Location, LastHitNormal, None);
	}
}

simulated protected function StopSimulating()
{
	super.StopSimulating();
	SetTimer(RandRange(ExplosionDelayRange.X, ExplosionDelayRange.Y), FALSE, nameof(DelayedExplosion));
}

simulated function GearExplosionActor TriggerExplosion(vector HitLocation, vector HitNormal, Actor HitActor)
{
	local int Idx;
	local GearProjectile SpawnedBomblet;
	local vector NudgedHitLoc, BombletInitDir;
	local GearExplosionActor GEA;

	if (bMortarHasExploded)
	{
		return None;
	}

	// skipping the ClusterMortar.Explode(), so we can skip the special bomblet spawning in there.
	GEA = Super(GearProj_ExplosiveBase).TriggerExplosion(HitLocation, HitNormal, HitActor);

	bMortarHasExploded = true;

	// different bomblet code here than for the regular mortar.  just toss them randomly, most will explode nearby
	if (Role == ROLE_Authority)
	{
//		FlushPersistentDebugLines();
		NudgedHitLoc = HitLocation + HitNormal * 16;

		for (Idx=0; Idx<NumBombletsToSpawn; ++Idx)
		{
			SpawnedBomblet = Spawn(BombletClass, Instigator,, NudgedHitLoc);
			if (SpawnedBomblet != None)
			{
				// random, but skewed in the dir of the normal
				BombletInitDir = Normal(VRand() + HitNormal);

				SpawnedBomblet.Init(BombletInitDir);
				SpawnedBomblet.Velocity = BombletInitDir * BombletMaxSprayVel * RandRange(0.2f, 1.f);

//				DrawDebugLine(NudgedHitLoc, NudgedHitLoc + BombletInitDir * 256, 255, 255, 0, TRUE);

				SpawnedBomblet.bSuppressAudio = bSuppressAudio;
			}
		}
	}

	return GEA;
}

simulated protected function AnticipateImpact()
{
	// do nothing
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	// use a different bounce timer
	ClearTimer(nameof(ForceBounce));
	SetTimer( TimeBeforeMortarCanExplode, FALSE, nameof(EnableMortarExplosion) );
}

simulated function EnableMortarExplosion()
{
	if (!bHasExploded && (Physics == PHYS_None || VSize(Velocity) < 1.0))
	{
		TriggerExplosion(Location, vect(0,0,1), WorldInfo);
	}
}

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
	local Pawn P;
	P = Pawn(Other);

	// bounce off friendly players for the initial launch
	if (P != None && P.GetTeamNum() == Instigator.GetTeamNum() && IsTimerActive('EnableMortarExplosion'))
	{
		// don't allow explosion for first bounce or N seconds
		Bounce(Location, HitNormal);

		if (Physics == PHYS_None)
		{
			// stopped simulation during bounce, go ahead and explode
			TriggerExplosion(HitLocation, HitNormal, Other);
		}
	}
	else
	{
		super.ProcessTouch(Other, HitLocation, HitNormal);
	}

	LastHitNormal = HitNormal;
}


simulated function HitWall(vector HitNormal, actor Wall, PrimitiveComponent WallComp)
{
	if (IsTimerActive('EnableMortarExplosion'))
	{
		// don't allow explosion for first bounce or N seconds
		Bounce(Location, HitNormal);

		if (Physics == PHYS_None)
		{
			// stopped simulation during bounce, go ahead and explode
			TriggerExplosion(Location, HitNormal, Wall);
		}
	}
	else
	{
		super.HitWall(HitNormal, Wall, WallComp);
	}

	LastHitNormal = HitNormal;
}

defaultproperties
{
//	bUpdateSimulatedPosition=TRUE
//	Speed=1400			// defined in the weapons ini, see MortarLaunchSpeed variable
//	TrailTemplate=None
//	Lifespan=10.f

 	Bounciness=0.7f
	VelocityDampingFactor=0.7f

	BombletMaxSprayVel=1500

//	RandSpinRange=(X=300000,Y=500000)
//	BounceRandomness=0.9f

	bStoppedByGrenadeBlockingVolume=TRUE
}
