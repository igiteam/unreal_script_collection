/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 * replaces blood effects with flower effects 
 */
class GearFlowerEmitterPool extends GearEmitterPool;

/** does the replacement by name since there are so many blood effects from so many sources */
final function CheckEmitterTemplate(out ParticleSystem EmitterTemplate)
{
	if (EmitterTemplate.Name == 'P_Blood_HeadShot' || EmitterTemplate.Name == 'P_Blood_HeadShot_Lambent')
	{
		EmitterTemplate = ParticleSystem'Effects_Gameplay.Mutators.Happy.P_Mutator_Happy_Headshot';
	}
	else if (InStr(string(EmitterTemplate.Name), "blood",, true) != INDEX_NONE)
	{
		EmitterTemplate = ParticleSystem'Effects_Gameplay.Mutators.Happy.P_Mutator_Happy_Blood';
	}
}

function ParticleSystemComponent SpawnEmitterMeshAttachment( ParticleSystem EmitterTemplate, SkeletalMeshComponent Mesh, name AttachPointName,
								optional bool bAttachToSocket, optional vector RelativeLoc, optional rotator RelativeRot )
{
	CheckEmitterTemplate(EmitterTemplate);
	return Super.SpawnEmitterMeshAttachment(EmitterTemplate, Mesh, AttachPointName, bAttachToSocket, RelativeLoc, RelativeRot);
}

function ParticleSystemComponent SpawnEmitter(ParticleSystem EmitterTemplate, vector SpawnLocation, optional rotator SpawnRotation, optional Actor AttachToActor, optional bool bInheritScaleFromBase)
{
	CheckEmitterTemplate(EmitterTemplate);
	return Super.SpawnEmitter(EmitterTemplate, SpawnLocation, SpawnRotation, AttachToActor, bInheritScaleFromBase);
}
