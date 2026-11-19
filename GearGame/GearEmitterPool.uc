/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearEmitterPool extends EmitterPool;

/** tracer pool */
var protected array<GearProj_BulletTracer> PoolTracers;
var array<GearProj_BulletTracer> ActiveTracers;
var int MaxActiveTracers;
/** array mapping tracer type ID to its details */
var array<GearTracerEffect> TracerDataList;

function ParticleSystemComponent SpawnEmitterMeshAttachment( ParticleSystem EmitterTemplate, SkeletalMeshComponent Mesh, name AttachPointName,
								optional bool bAttachToSocket, optional vector RelativeLoc, optional rotator RelativeRot )
{
	local ParticleSystemComponent Result;

	Result = Super.SpawnEmitterMeshAttachment(EmitterTemplate, Mesh, AttachPointName, bAttachToSocket, RelativeLoc, RelativeRot);
	// our meshes usually have a lot of animation and physics going on, so we need to update attached effects at the end
	Result.SetTickGroup(TG_PostUpdateWork);
	return Result;
}

/** spawns and initializes a tracer from the pool of the specified type at the specified location */
function GearProj_BulletTracer SpawnTracer(EWeaponTracerType Type, vector SpawnLocation, rotator SpawnRotation, vector TargetLoc, bool bLocallyOwned,optional vector HitLocation)
{
	local GearProj_BulletTracer Result;
	local int i;

	// try to grab one from the pool
	while (PoolTracers.length > 0)
	{
		i = PoolTracers.length - 1;
		Result = PoolTracers[i];
		PoolTracers.Remove(i, 1);
		if (Result != None && !Result.bDeleteMe)
		{
			break;
		}
		else
		{
			Result = None;
		}
	}

	if (Result == None)
	{
		// clear out old entries
		i = 0;
		while (i < ActiveTracers.length)
		{
			if (ActiveTracers[i] != None && !ActiveTracers[i].bDeleteMe)
			{
				i++;
			}
			else
			{
				ActiveTracers.Remove(i, 1);
			}
		}

		if (ActiveTracers.length >= MaxActiveTracers)
		{
			if (bLogPoolOverflow)
			{
				`Warn("Exceeded max active tracers!");
			}
			// overwrite oldest tracer
			Result = ActiveTracers[0];
			ActiveTracers[0].Recycle();
			PoolTracers.Remove(0, 1);
		}
		else
		{
			Result = Spawn(class'GearProj_BulletTracer',,,,,, true);
		}
	}

	// initialize the tracer to one of the desired type
	Result.SetLocation(SpawnLocation);
	Result.SetRotation(SpawnRotation);
	Result.Mesh.SetStaticMesh(TracerDataList[Type].Mesh);
	if (bLocallyOwned && !IsZero(TracerDataList[Type].LocallyOwnedDrawScale3D))
	{
		Result.TracerDrawScale3D = TracerDataList[Type].LocallyOwnedDrawScale3D;
	}
	else
	{
		Result.TracerDrawScale3D = TracerDataList[Type].BaseDrawScale3D;
	}
	Result.AccelRate = TracerDataList[Type].AccelRate;
	Result.Speed = TracerDataList[Type].Speed;
	Result.MaxSpeed = TracerDataList[Type].MaxSpeed;
	Result.InitTracer(SpawnLocation, TargetLoc);
	ActiveTracers.AddItem(Result);

	// Attach an emitter if desired
	if (TracerDataList[Type].bShouldAttachToProjectile)
	{
		Result.AttachedPSC = SpawnTracerSmoke(Type,SpawnLocation,SpawnRotation,bLocallyOwned,HitLocation,Result);
		Result.ExtraKeepAliveTime = TracerDataList[Type].ParticleKeepAliveTime;
	}

	return Result;
}

/**
 * Spawns a smoke trail emitter if it is not to be attached to a projectile
 *
 * @param Type the tracer type that is being fired
 * @param SpawnLocation the starting location for the particle effect
 * @param SpawnRotation the rotation for the effect
 * @param bLocallyOwned - whether this is for a local player
 * @param HitLocation the end point to attach to if needed
 * @param AttachToActor the actor to attach it to
 *
 * @return the particle system component to use
 */
final function ParticleSystemComponent SpawnTracerSmoke(EWeaponTracerType Type, vector SpawnLocation, rotator SpawnRotation, bool bLocallyOwned, vector HitLocation, optional Actor AttachToActor)
{
	local ParticleSystemComponent SpawnedTracerEmitter;

	if ((TracerDataList[Type].ParticleSystemTemplate != None || (bLocallyOwned && TracerDataList[Type].LocallyOwnedParticleSystemTemplate != None)) &&
		(AttachToActor == None || (AttachToActor != None && TracerDataList[Type].bShouldAttachToProjectile)) &&
		// If it is not going to be attached to an actor OR it passes the random number test, then spawn it
		(AttachToActor != None || FRand() < TracerDataList[Type].SmokeTrailFrequency) )
	{
		// Spawn the effect that they've specified
		if (bLocallyOwned && TracerDataList[Type].LocallyOwnedParticleSystemTemplate != None)
		{
			SpawnedTracerEmitter = WorldInfo.MyEmitterPool.SpawnEmitter(TracerDataList[Type].LocallyOwnedParticleSystemTemplate, SpawnLocation, SpawnRotation, AttachToActor);
		}
		else
		{
			SpawnedTracerEmitter = WorldInfo.MyEmitterPool.SpawnEmitter(TracerDataList[Type].ParticleSystemTemplate, SpawnLocation, SpawnRotation, AttachToActor);
		}

		if (SpawnedTracerEmitter != None && TracerDataList[Type].EndPointVectorParamName != 'None')
		{
			SpawnedTracerEmitter.SetVectorParameter(TracerDataList[Type].EndPointVectorParamName, HitLocation);
		}
	}
	return SpawnedTracerEmitter;
}

/** returns a tracer to the pool */
function ReturnTracer(GearProj_BulletTracer Tracer)
{
	local int i;

	// remove from active arrays
	i = ActiveTracers.Find(Tracer);
	if (i != INDEX_NONE)
	{
		ActiveTracers.Remove(i, 1);
		PoolTracers.AddItem(Tracer);
	}
}

/** removes everything from the pool - does not touch currently active tracers 
 *  
 *  @param  bClearActive    If TRUE also clear the active pool
 *  */
final function ClearPoolTracers(optional bool bClearActive)
{
	local int i;
	local GearProj_BulletTracer Result;

	if (bClearActive)
	{
		i = 0;
		while (i < ActiveTracers.length)
		{
			if (ActiveTracers[i] != None && !ActiveTracers[i].bDeleteMe)
			{
				Result = ActiveTracers[i];
				ActiveTracers[i].Recycle();
				// If it failed to recycle, continue so we don't infinite loop
				if (i < ActiveTracers.length && ActiveTracers[i] == Result)			
				{
					i++;
				}
			}
			else
			{
				ActiveTracers.Remove(i, 1);
			}
		}
	}

	for (i = 0; i < PoolTracers.length; i++)
	{
		PoolTracers[i].Destroy();
	}
	PoolTracers.length = 0;
}

defaultproperties
{
	MaxActiveEffects=150
	MaxActiveTracers=60

	TracerDataList[WTT_LongSkinny]=GearTracerEffect'GearTracerEffects.LongSkinny'
	TracerDataList[WTT_LongSkinnyAR]=GearTracerEffect'GearTracerEffects.LongSkinnyActiveReload'
	TracerDataList[WTT_ShortBullet]=GearTracerEffect'GearTracerEffects.ShortBullet'
	TracerDataList[WTT_MinigunFastFiring]=GearTracerEffect'GearTracerEffects.MinigunFastFiring'
	TracerDataList[WTT_Boltok]=GearTracerEffect'GearTracerEffects.Weapon.Tracer_Boltok'
	TracerDataList[WTT_Boltok_AR]=GearTracerEffect'GearTracerEffects.Weapon.Tracer_Boltok_AR'
	TracerDataList[WTT_Brumak]=GearTracerEffect'GearTracerEffects.Weapon.Tracer_Brumak'
	TracerDataList[WTT_Coop_Minigun]=GearTracerEffect'GearTracerEffects.Weapon.Tracer_Coop_Minigun'
	TracerDataList[WTT_Gnasher]=GearTracerEffect'GearTracerEffects.Weapon.Tracer_Gnasher'
	TracerDataList[WTT_Gnasher_AR]=GearTracerEffect'GearTracerEffects.Weapon.Tracer_Gnasher_AR'
	TracerDataList[WTT_Gorgon]=GearTracerEffect'GearTracerEffects.Weapon.Tracer_Gorgon'
	TracerDataList[WTT_Gorgon_AR]=GearTracerEffect'GearTracerEffects.Weapon.Tracer_Gorgon_AR'
	TracerDataList[WTT_Hammerburst]=GearTracerEffect'GearTracerEffects.Weapon.Tracer_Hammerburst'
	TracerDataList[WTT_HammerburstAR]=GearTracerEffect'GearTracerEffects.Weapon.Tracer_Hammerburst_AR'
	TracerDataList[WTT_Lancer]=GearTracerEffect'GearTracerEffects.Weapon.Tracer_Lancer'
	TracerDataList[WTT_Lancer_AR]=GearTracerEffect'GearTracerEffects.Weapon.Tracer_Lancer_AR'
	TracerDataList[WTT_Longshot]=GearTracerEffect'GearTracerEffects.Weapon.Tracer_Longshot'
	TracerDataList[WTT_Mulcher]=GearTracerEffect'GearTracerEffects.Weapon.Tracer_Mulcher'
	TracerDataList[WTT_Oneshot]=GearTracerEffect'GearTracerEffects.Weapon.Tracer_Oneshot'
	TracerDataList[WTT_Reaver]=GearTracerEffect'GearTracerEffects.Weapon.Tracer_Reaver'
	TracerDataList[WTT_RetroLancer]=GearTracerEffect'GearTracerEffects.Weapon.Tracer_RetroLancer'
	TracerDataList[WTT_RetroLancer_AR]=GearTracerEffect'GearTracerEffects.Weapon.Tracer_RetroLancer_AR'
	TracerDataList[WTT_SawedOff]=GearTracerEffect'GearTracerEffects.Weapon.Tracer_SawedOff'
	TracerDataList[WTT_SawedOff_AR]=GearTracerEffect'GearTracerEffects.Weapon.Tracer_SawedOff_AR'
	TracerDataList[WTT_SnubPistol]=GearTracerEffect'GearTracerEffects.Weapon.Tracer_SnubPistol'
	TracerDataList[WTT_SnubPistol_AR]=GearTracerEffect'GearTracerEffects.Weapon.Tracer_SnubPistol_AR'
	TracerDataList[WTT_HammerburstLambent]=GearTracerEffect'GearTracerEffects.Weapon.Tracer_LambentHammerburst'
	TracerDataList[WTT_Hammerburst_Reaver]=GearTracerEffect'GearTracerEffects.Weapon.Tracer_Hammerburst_Reaver'
	TracerDataList[WTT_MultiTurret_Hammerburst]=GearTracerEffect'GearTracerEffects.Weapon.Tracer_MultiTurret_Hammerburst'
	TracerDataList[WTT_MultiTurret_Lancer]=GearTracerEffect'GearTracerEffects.Weapon.Tracer_MultiTurret_Lancer'
	TracerDataList[WTT_MultiTurret_RetroLancer]=GearTracerEffect'GearTracerEffects.Weapon.Tracer_MultiTurret_RetroLancer'
	TracerDataList[WTT_Tempest]=GearTracerEffect'GearTracerEffects.Weapon.Tracer_Tempest'
	TracerDataList[WTT_LancerOnyxGuard]=GearTracerEffect'GearTracerEffects.Onyx_Guard_Tracer'
	TracerDataList[WTT_TorqueMaxSpeed]=GearTracerEffect'GearTracerEffects.Weapon.Tracer_Torquebow_Full'
}
