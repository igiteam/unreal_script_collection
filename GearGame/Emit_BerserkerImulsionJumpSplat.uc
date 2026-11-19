/**
 * Semi-persistent bits of fire stuck to the world.  Deposited by flamethrower, etc.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class Emit_BerserkerImulsionJumpSplat extends SpawnedGearEmitter
	config(Weapon);


/** The berserker who instanced this emitter */
var transient GearPawn_LocustBerserkerLambentBase BerserkerPawn;

/** Trace locations used to determine where the effects should draw */
var vector LastGroundTraceLocationEnd;
var vector LastGroundTraceLocationStart;

/** Hit location and normal of the trace used to determine where the effects should draw */
var vector TraceLocation;
var vector TraceNormal;

/** Jump explosion template */
var GearExplosion JumpExplosionTemplate;
/** Config damage values for the jump explosion */
var float JumpExplosionDamage;
var float JumpExplosionDamageRadius;

/** Min and max damage and explosion radius (jump height determines what we use between these values) */
var config float JumpExplosionDamageMin;
var config float JumpExplosionDamageMax;
var config float JumpExplosionDamageRadiusMin;
var config float JumpExplosionDamageRadiusMax;
/** Length of time we need to jump to get max values for explosion */
var config float JumpTimeMax;
/** Typically the shortest amount of time that goes by in a jump */
var float JumpTimeMin;

/** Instance of the decal material */
var MaterialInstanceConstant DecalInstance;

/** The time this decal was dropped */
var transient float DecalStartTime;

/** The total time this emitter should live */
var float TotalLifeSpan;

/** Amount of time to fade out the particles */
var transient float TotalParticleFadeTime;


/** Initializes the emitter */
simulated function InitializeImulsionEmitter(GearPawn_LocustBerserkerLambentBase BerserkerGP)
{
	local float PercentOfMax;

	BerserkerPawn = BerserkerGP;
	if (BerserkerPawn != None)
	{
		TotalLifeSpan = BerserkerPawn.PhaseInfo[BerserkerPawn.CurrentPhase].ImulsionTrailLifeSpan + 1.0f;

		PercentOfMax = (WorldInfo.TimeSeconds - BerserkerPawn.FallingStartTime - JumpTimeMin) / (JumpTimeMax - JumpTimeMin);
		PercentOfMax = FClamp(PercentOfMax, 0.0f, 1.0f);
		JumpExplosionDamage = JumpExplosionDamageMin + ((JumpExplosionDamageMax - JumpExplosionDamageMin) * PercentOfMax);
		JumpExplosionDamageRadius = JumpExplosionDamageRadiusMin + ((JumpExplosionDamageRadiusMax - JumpExplosionDamageRadiusMin) * PercentOfMax);

		// Set the lifespan for the particle
		ParticleSystemComponent.SetFloatParameter('Lifetime', TotalLifeSpan);

		LeaveImulsionSplat();
	}
}

/** Called when the berserker no longer wants to update the emitter */
simulated function BreakOffImulsionEmitter()
{
	ParticleSystemComponent.DeactivateSystem();
	BerserkerPawn = None;
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
	out_DecalData = class'GearPhysicalMaterialProperty'.static.GetBloodDecalData(class'GearPhysicalMaterialProperty'.static.GetImpactPhysicalMaterialHitInfo(Hitinfo), GDDT_BerserkerJumpSplat, WorldInfo);
	out_DecalData.Width = JumpExplosionDamageRadius * 2;
	out_DecalData.Height = JumpExplosionDamageRadius * 2;

	if (out_DecalData.bRandomizeRotation)
	{
		out_DecalRotation = FRand() * 360.0f;
	}
}

/** Lays a decal, starts an effect and creates an explosion */
simulated protected function LeaveImulsionSplat()
{
	local GearGRI GRI;
	local GearExplosionActor ExplosionActor;
	local SoundCue SoundToUse;
	local GearDecal TrailDecal;
	local Material Mat;

	GRI = GearGRI(WorldInfo.GRI);

	if (BerserkerPawn != None &&
		GRI != None)
	{
		// Trace down to the ground
		BerserkerPawn.Mesh.GetSocketWorldLocationAndRotation('Heart', LastGroundTraceLocationStart);
		LastGroundTraceLocationEnd = LastGroundTraceLocationStart + (vect(0.25,0,-0.75) >> BerserkerPawn.Rotation) * 512.0f;
		if (Trace(TraceLocation, TraceNormal, LastGroundTraceLocationEnd, LastGroundTraceLocationStart, FALSE) != None)
		{
			// Leave a decal
			SetLocation(TraceLocation);
			SetRotation(Rotator(TraceNormal));
			TrailDecal = GRI.LeaveADecal(ImulsionDecalTraceFunc, ImulsionDecalChoiceFunc);
			if (TrailDecal != None)
			{
				Mat = TrailDecal.GetDecalMaterial().GetMaterial();
				if (Mat != None)
				{
					DecalInstance = new(self) class'MaterialInstanceConstant';
					DecalInstance.SetParent(Mat);
					TrailDecal.SetDecalMaterial(DecalInstance);
					DecalStartTime = WorldInfo.TimeSeconds;
				}
			}

			// Create an explosion
			JumpExplosionTemplate.InitFromContentTemplate();
			JumpExplosionTemplate.Damage = JumpExplosionDamage;
			JumpExplosionTemplate.DamageRadius = JumpExplosionDamageRadius;
			JumpExplosionTemplate.FractureMeshRadius = JumpExplosionDamageRadius;
			ExplosionActor = Spawn(class'GearExplosionActor',,, TraceLocation/*+vect(0,0,100)*/, Rotator(TraceNormal));
			ExplosionActor.InstigatorController = BerserkerPawn.Controller;
			if (ExplosionActor.InstigatorController != None)
			{
				ExplosionActor.Instigator = ExplosionActor.InstigatorController.Pawn;
			}
			ExplosionActor.Explode(JumpExplosionTemplate);

			if (Role == ROLE_Authority)
			{
				// Spawn a damage actor so enemies get hurt when walking here
				BerserkerPawn.SpawnBerserkerEffectsDamageActor(TraceLocation, FALSE, TRUE, JumpExplosionDamageRadius*0.5f, 100.0f);
			}

			// Play the sound based on how big the explosion was
			if (JumpExplosionDamageRadius > (JumpExplosionDamageRadiusMax - JumpExplosionDamageRadiusMin) / 2.0f)
			{
				SoundToUse = BerserkerPawn.LargeLandSound;
			}
			else
			{
				SoundToUse = BerserkerPawn.SmallLandSound;
			}
			PlaySound(SoundToUse, true);
		}
	}
}

simulated function Tick(float DeltaTime)
{
	local float Alpha;
	local float StartFadeTime;

	super.Tick(DeltaTime);

	// Fade out the decals
	if (DecalInstance != None)
	{
		StartFadeTime = DecalStartTime + TotalLifeSpan - TotalParticleFadeTime;

		if (WorldInfo.TimeSeconds >= DecalStartTime + TotalLifeSpan)
		{
			DecalInstance.SetScalarParameterValue('Fade', 0.0f);
		}
		else if (WorldInfo.TimeSeconds > StartFadeTime)
		{
			Alpha = 1.0f - ((WorldInfo.TimeSeconds - StartFadeTime) / TotalParticleFadeTime);
			DecalInstance.SetScalarParameterValue('Fade', Alpha);
		}
	}
}

defaultproperties
{
	LifeSpan=30.0f
	bDestroyOnSystemFinish=false
	bReplicateInstigator=FALSE
	bNetTemporary=FALSE
	RemoteRole=ROLE_Authority
	JumpTimeMin=0.2f
	TotalParticleFadeTime=2.0f
}

