/**
 * Semi-persistent bits of fire stuck to the world.  Deposited by flamethrower, etc.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class Emit_BerserkerImulsionTrail extends SpawnedGearEmitter
	config(Weapon);


/** Amount of time to fade the decal in and out */
var() protected const float DecalFadeInTime;
var() protected const float DecalFadeOutTime;

/** The berserker who instanced this emitter */
var transient GearPawn_LocustBerserkerLambentBase BerserkerPawn;

/** The last starting and ending locations we used to trace to the ground while updating */
var transient Vector LastGroundTraceLocationStart;
var transient Vector LastGroundTraceLocationEnd;

/** Amount of time to fade out the particles */
var transient float TotalParticleFadeTime;

/** The location of the last place this emitter dropped a decal */
var transient Vector LastDroppedDecalLocation;

/** The total time this emitter should live */
var float TotalLifeSpan;

struct TrailDecalData
{
	/** Instance of the decal material */
	var MaterialInstanceConstant DecalInstance;

	/** The time this decal was dropped */
	var transient float DecalStartTime;
};

/** List of all decals that were dropped */
var transient array<TrailDecalData> TrailDecalDatas;


/** Initializes the emitter */
simulated function InitializeImulsionEmitter(GearPawn_LocustBerserkerLambentBase BerserkerGP)
{
	BerserkerPawn = BerserkerGP;

	TotalLifeSpan = BerserkerPawn.PhaseInfo[BerserkerPawn.CurrentPhase].ImulsionTrailLifeSpan + 1.0f;

	// Set the lifespan for the particle
	ParticleSystemComponent.SetFloatParameter('Lifetime', TotalLifeSpan);
	UpdateImulsion();
}

/** Called when the berserker no longer wants to update the emitter */
simulated function BreakOffImulsionEmitter()
{
	ParticleSystemComponent.DeactivateSystem();
	BerserkerPawn = None;
}

/** Updates the location of the imulsion effect */
simulated function UpdateImulsion()
{
	local vector HitLocation;
	local vector HitNormal;

	if (BerserkerPawn != None)
	{
		BerserkerPawn.Mesh.GetSocketWorldLocationAndRotation('Gas', LastGroundTraceLocationStart);
		LastGroundTraceLocationEnd = LastGroundTraceLocationStart + vect(0,0,-1) * 256.0f;
		if (Trace(HitLocation, HitNormal, LastGroundTraceLocationEnd, LastGroundTraceLocationStart, FALSE) != None)
		{
			SetLocation(HitLocation);
			SetRotation(Rotator(HitNormal));

			// Drop a decal every 100 units
			if (LastDroppedDecalLocation == vect(0,0,0) ||
				VSizeSq(LastDroppedDecalLocation-HitLocation) >= 10000)
			{
				LeaveImulsionDecal();
				LastDroppedDecalLocation = HitLocation;
			}
		}
	}
}

simulated function Tick(float DeltaTime)
{
	local float Alpha;
	local float StartFadeTime;
	local int DecalIdx;
	local float DecalStartTime;

	super.Tick(DeltaTime);

	// Fade out the decals
	for (DecalIdx = TrailDecalDatas.Length - 1; DecalIdx >= 0; DecalIdx--)
	{
		DecalStartTime = TrailDecalDatas[DecalIdx].DecalStartTime;
		StartFadeTime = DecalStartTime + TotalLifeSpan - TotalParticleFadeTime;

		if (WorldInfo.TimeSeconds >= DecalStartTime + TotalLifeSpan)
		{
			TrailDecalDatas[DecalIdx].DecalInstance.SetScalarParameterValue('Fade', 0.0f);
			TrailDecalDatas.Remove(DecalIdx, 1);
		}
		else if (WorldInfo.TimeSeconds > StartFadeTime)
		{
			Alpha = 1.0f - ((WorldInfo.TimeSeconds - StartFadeTime) / TotalParticleFadeTime);
			TrailDecalDatas[DecalIdx].DecalInstance.SetScalarParameterValue('Fade', Alpha);
		}
	}

	UpdateImulsion();
}

/** Sets the tracing parameters for laying down the decal */
simulated protected function ImulsionDecalTraceFunc(out vector out_TraceStart, out vector out_TraceDest, const float RandomOffsetRadius, optional vector ForceStartLocation)
{
	out_TraceStart = LastGroundTraceLocationStart;
	out_TraceDest = LastGroundTraceLocationEnd;
}

/** Gets the decal info and randomizes the rotation */
simulated protected function ImulsionDecalChoiceFunc( const out TraceHitInfo HitInfo, out float out_DecalRotation, out DecalData out_DecalData )
{
	out_DecalData = class'GearPhysicalMaterialProperty'.static.GetBloodDecalData(class'GearPhysicalMaterialProperty'.static.GetImpactPhysicalMaterialHitInfo(Hitinfo), GDDT_BerserkerImulsionTrail, WorldInfo);

	if (out_DecalData.bRandomizeRotation)
	{
		out_DecalRotation = FRand() * 360.0f;
	}

	out_DecalData.LifeSpan = TotalLifeSpan;
}

/** Called every 100 units to drop a decal */
simulated protected function LeaveImulsionDecal()
{
	local GearGRI GRI;
	local Material Mat;
	local GearDecal TrailDecal;
	local MaterialInstanceConstant DecalInstance;
	local TrailDecalData TrailData;

	GRI = GearGRI(WorldInfo.GRI);
	if (GRI != None)
	{
		TrailDecal = GRI.LeaveADecal(ImulsionDecalTraceFunc, ImulsionDecalChoiceFunc);
		if (TrailDecal != None)
		{
			Mat = TrailDecal.GetDecalMaterial().GetMaterial();
			if (Mat != None)
			{
				DecalInstance = new(self) class'MaterialInstanceConstant';
				DecalInstance.SetParent(Mat);
				TrailDecal.SetDecalMaterial(DecalInstance);

				TrailData.DecalInstance = DecalInstance;
				TrailData.DecalStartTime = WorldInfo.TimeSeconds;
				TrailDecalDatas.AddItem(TrailData);
			}
		}
	}
}

defaultproperties
{
	Sound=None
	LifeSpan=30.0f

	bDestroyOnSystemFinish=false
	bReplicateInstigator=FALSE
	bNetTemporary=FALSE
	RemoteRole=ROLE_Authority

	DecalFadeInTime=0.25f
	DecalFadeOutTime=2.0f

	bAlwaysRelevant=TRUE
	TotalParticleFadeTime=2.0f
}

