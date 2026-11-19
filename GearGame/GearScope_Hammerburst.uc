/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearScope_Hammerburst extends GearScope_Sniper;

function PostBeginPlay()
{
	local GearPawn GP;

	Super.PostBeginPlay();

	GP = GearPawn(Instigator);
	if (GP != None)
	{
		GP.UpdateWeaponSkinForMesh(class<GearWeapon>(Owner.Class), Mesh);
	}
}

defaultproperties
{
	Components.Empty

	PostProcessName=""

	Begin Object Class=SkeletalMeshComponent Name=SkeletalMeshComponent0
		SkeletalMesh=SkeletalMesh'Locust_Hammerburst.Locust_Hammerburst'
		CollideActors=false
		BlockActors=false
		BlockZeroExtent=false
		BlockNonZeroExtent=false
		BlockRigidBody=false
		bDisableAllRigidBody=true
		bAllowAmbientOcclusion=false
		DepthPriorityGroup=SDPG_Foreground
		bOnlyOwnerSee=true
		bForceUpdateAttachmentsInTick=TRUE
	End Object
	Components.Add(SkeletalMeshComponent0)
	Mesh=SkeletalMeshComponent0
}
