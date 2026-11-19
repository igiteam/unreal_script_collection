/** 
 * A manager object for a single "patch" of fire.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearFireInfo_Circular extends GearFireInfo;


/** distance from wall/ground we hit to spawn fire */
var() protected const float FireOriginHeight;


/** in Unreal rotator units */
var() protected const int CircularSpreadPatternAngle;
var() protected const int CircularMaxStickyFires;
var() protected const int CircularNumBouncyFires;
var() protected const vector2d CircularDistBetweenSpawnsRange;
var() protected const float CircularSurfaceBias;
/** How much to bias velocity towards bouncy fires that are moving generally in the same direction as the grenade.  Lower numbers tends to skew the circle shape away from the thrower. */
var() protected const float CircularForwardVelocityBias;

simulated protected function vector GetFireSpawnDirCircular(vector BaseDir, vector HitNormal, float CirclePct)
{
	local rotator PitchRot, RollRot, BaseDirRot;
	local vector V;
	
	PitchRot.Pitch = CircularSpreadPatternAngle;
	RollRot.Roll = int(65536 * CirclePct);
	BaseDirRot = rotator(BaseDir);

	V = vector(PitchRot);
	V = V >> RollRot;
	return V >> BaseDirRot;
}

/** Overridden to set some additional properties on the spawner. */
protected function Emit_BouncyFire SpawnFireSpawner(vector Loc, rotator Rot, vector InitialVel, vector InitialSurfaceNormal)
{
	local Emit_BouncyFire BF;

	BF = super.SpawnFireSpawner(Loc, Rot, InitialVel, InitialSurfaceNormal);

	if (BF != None)
	{
		BF.SetSpawnFrequency(CircularDistBetweenSpawnsRange);
		BF.MaxStickyFires = CircularMaxStickyFires;
	}
	
	return BF;
}

simulated function SpawnFire(vector HitLocation, vector HitNormal, vector InitialVelocity)
{
	local vector SpawnOrigin, PrimVel;
	local float DotProd, InitialVelMag;
	local vector InitialVelInPlane, PrimVelInPlane;
	local int Idx;
	local Emit_BouncyFire BF;

	InitialVelMag = VSize(InitialVelocity);
	SpawnOrigin = HitLocation + HitNormal * FireOriginHeight;
	
	// spawn one going straight, for the middle
	PrimVel = -HitNormal * InitialVelMag;
	BF = SpawnFireSpawner(SpawnOrigin, rotator(HitLocation), PrimVel, HitNormal);
	if (BF != None)
	{
		BF.MaxStickyFires = 1;
		BF.SetSpawnFrequency(vect2d(0,0));
	}
		
	// spawn desired bouncyfires (circular pattern)
	for (Idx=0; Idx<CircularNumBouncyFires; ++Idx)
	{
		PrimVel = (Normal(InitialVelocity) * (1-CircularSurfaceBias)) + (CircularSurfaceBias * -HitNormal) * CircularSurfaceBias;     // bias spread into the surface
		PrimVel = GetFireSpawnDirCircular(PrimVel, HitNormal, float(Idx)/float(CircularNumBouncyFires));

		// scale the inherited velocity based on directional relation to the velocity
		InitialVelInPlane = InitialVelocity - ProjectOnTo(InitialVelocity, HitNormal);
		PrimVelInPlane = PrimVel - ProjectOnTo(PrimVel, HitNormal);
		DotProd = Normal(InitialVelInPlane) dot Normal(PrimVelInPlane);
		// get range -1..1 to range min..1
		DotProd = ( (DotProd + 1.f) * 0.5f * CircularForwardVelocityBias) + (1.f - CircularForwardVelocityBias);

		// final vel magnitude
		PrimVel *= InitialVelMag * DotProd;

		SpawnFireSpawner(SpawnOrigin, rotator(HitLocation), PrimVel, HitNormal);
	}


	Super.SpawnFire(HitLocation,HitNormal,InitialVelocity);
}

defaultproperties
{
	FireOriginHeight=40.f

	CircularSpreadPatternAngle=7000

	CircularMaxStickyFires=2
	CircularNumBouncyFires=15
	CircularDistBetweenSpawnsRange=(X=60,Y=120)
	CircularSurfaceBias=0.7f
	CircularForwardVelocityBias=0.7
}



