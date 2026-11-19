/**
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoLadder extends NanoLadderBase;


defaultproperties
{
	ClassVersion=2

	Begin Object Class=SpriteComponent NAME=Sprite
		Sprite=Texture2D'EditorResources.S_Ladder'
		AlwaysLoadOnClient=FALSE
		AlwaysLoadOnServer=FALSE
		HiddenGame=TRUE
	End Object
	Components.Add(Sprite)

	bMovable=FALSE
	bEdShouldSnap=TRUE

	TopMesh=StaticMesh'Nano_Proto_Ladders.SM.Mesh.S_Proto_Ladder_Top01'
	LoopingMesh=StaticMesh'Nano_Proto_Ladders.SM.Mesh.S_Proto_Ladder_0128'
	BottomMesh=StaticMesh'Nano_Proto_Ladders.SM.Mesh.S_Proto_Ladder_0128'
	LadderInterval=128

	Begin Object Class=StaticMeshComponent Name=TopMeshComp_0
		StaticMesh=StaticMesh'Nano_Proto_Ladders.SM.Mesh.S_Proto_Ladder_Top01'
		Rotation=(Yaw=-16384)
		AlwaysLoadOnClient=TRUE
		AlwaysLoadOnServer=TRUE
		CollideActors=TRUE
		BlockActors=TRUE
		bCastDynamicShadow=FALSE
		bUsePrecomputedShadows=TRUE
	End Object
	Components.Add(TopMeshComp_0)
	TopMeshComp=TopMeshComp_0

	Begin Object Class=CylinderComponent Name=CylinderComp_0
		AlwaysLoadOnClient=TRUE
		AlwaysLoadOnServer=TRUE
		CollideActors=TRUE
		CollisionRadius=64
		BlockNonZeroExtent=TRUE
	End Object
	Components.Add(CylinderComp_0)
	CollisionCylinder=CylinderComp_0
	CollisionComponent=CylinderComp_0

	bCollideActors=TRUE
	bBlockActors=TRUE
}
