/**
 * Version of SkeletalMeshActor intended to be used in cinematics, when SkeletalMeshActorMAT is too heavyweight.
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class Gear_SkeletalMeshCinematicActor extends SkeletalMeshCinematicActor
	placeable;

/** This is temporary anim notifier to support arm breaking **/
simulated function ANIMNOTIFY_BreakLeftArm()
{
	// switch to gore LOD
	SkeletalMeshComponent.ForcedLodModel = 2;

	// material internal section
	SkeletalMeshComponent.ShowMaterialSection(1,TRUE,SkeletalMeshComponent.ForcedLodModel-1);

	// TODO: we might have to update material
	SkeletalMeshComponent.SetMaterial(1, MaterialInstanceConstant'COG_Gore.MI_Gears3_COG_Gore');

	// weight change for these bones
	SkeletalMeshComponent.BreakConstraint(vect(0, 0, 1),SkeletalMeshComponent.GetBoneLocation('b_MF_UpperArm_L'),'b_MF_UpperArm_L');
}

defaultproperties
{
}
