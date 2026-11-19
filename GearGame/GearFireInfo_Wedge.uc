/** 
 * A manager object for a single "patch" of fire.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearFireInfo_Wedge extends GearFireInfo
	native(Weapon);


/** distance from wall/ground we hit to spawn fire */
var() protected const float FireOriginHeight;


struct native BouncyFireSpawnData
{
	var() int YawDelta;
	var() vector2d DistBetweenSpawnsRange;
	var() vector SpawnOffset;
	var() int MaxStickyFires;
};
var() protected const array<BouncyFireSpawnData> BouncyFireSpawnParams;

simulated protected function native vector GetFireSpawnDir(vector BaseDir, vector SurfaceNormal, int YawOffset) const;
simulated protected function native vector GetFireSpawnLoc(vector BaseDir, vector BaseLoc, vector SurfaceNormal, vector LocOffset);


// spawn desired bouncyfires (wedge pattern)
simulated function SpawnFire(vector HitLocation, vector HitNormal, vector InitialVelocity)
{
	local vector FireOrigin, SpawnOrigin, PrimVel;
	local int Idx;
	local Emit_BouncyFire BF;
	local float InitialVelMag;

	InitialVelMag = VSize(InitialVelocity);
	FireOrigin = HitLocation + HitNormal * FireOriginHeight;

	// spawn one going straight, for the impact point
	PrimVel = -HitNormal * InitialVelMag;
	BF = SpawnFireSpawner(FireOrigin, rotator(HitLocation), PrimVel, HitNormal);
	if (BF != None)
	{
		BF.MaxStickyFires = 1;
		BF.SetSpawnFrequency(vect2d(0,0));
	}

	// spawn rest in fan shape
	for (Idx=0; Idx<BouncyFireSpawnParams.length; ++Idx)
	{
		SpawnOrigin = GetFireSpawnLoc(InitialVelocity, FireOrigin, HitNormal, BouncyFireSpawnParams[Idx].SpawnOffset);

		PrimVel = GetFireSpawnDir(InitialVelocity, HitNormal, BouncyFireSpawnParams[Idx].YawDelta);
		PrimVel *= InitialVelMag;

		BF = SpawnFireSpawner(SpawnOrigin, rotator(HitNormal), PrimVel, HitNormal);
		BF.MaxStickyFires = BouncyFireSpawnParams[Idx].MaxStickyFires;
		BF.SetSpawnFrequency(BouncyFireSpawnParams[Idx].DistBetweenSpawnsRange);
	}

	Super.SpawnFire(HitLocation,HitNormal,InitialVelocity);
}

defaultproperties
{
	FireOriginHeight=40.f

	BouncyFireSpawnParams(0)=(MaxStickyFires=4,YawDelta=0,DistBetweenSpawnsRange=(X=75,Y=100))
	BouncyFireSpawnParams(1)=(MaxStickyFires=4,YawDelta=-1500,DistBetweenSpawnsRange=(X=60,Y=100),SpawnOffset=(Y=-15))
	BouncyFireSpawnParams(2)=(MaxStickyFires=4,YawDelta=1500,DistBetweenSpawnsRange=(X=60,Y=100),SpawnOffset=(Y=15))
	BouncyFireSpawnParams(3)=(MaxStickyFires=4,YawDelta=-3000,DistBetweenSpawnsRange=(X=70,Y=120),SpawnOffset=(Y=-30))
	BouncyFireSpawnParams(4)=(MaxStickyFires=4,YawDelta=3000,DistBetweenSpawnsRange=(X=80,Y=130),SpawnOffset=(Y=30))
	BouncyFireSpawnParams(5)=(MaxStickyFires=4,YawDelta=-4500,DistBetweenSpawnsRange=(X=80,Y=130),SpawnOffset=(Y=-45))
	BouncyFireSpawnParams(6)=(MaxStickyFires=4,YawDelta=4500,DistBetweenSpawnsRange=(X=70,Y=120),SpawnOffset=(Y=45))


}



