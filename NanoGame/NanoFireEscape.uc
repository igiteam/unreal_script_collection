/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoFireEscape extends NanoFireEscapeBase;

defaultproperties
{
	Begin Object Class=StaticMeshComponent Name=LadderSpringMeshComponent
		StaticMesh=StaticMesh'HU_Decox.SM.Mesh.S_HU_Deco_SM_Ladder01_Dup'
		Materials(0)=MaterialInstanceConstant'Nano_Blockbuster.Materials.MI_BlockbusterSkin_FireEscape'
		Rotation=(Yaw=16384,Roll=-17294)
		Translation=(X=36.f,Y=142.f)
		Scale3D=(Z=2.f)
		BlockNonZeroExtent=TRUE
		BlockZeroExtent=TRUE
		BlockActors=TRUE
		CollideActors=TRUE
		bUsePrecomputedShadows=TRUE
	End Object
	Components.Add(LadderSpringMeshComponent)
	LadderSpringMesh=LadderSpringMeshComponent

	Begin Object Class=CylinderComponent Name=CylinderComponent0
		CollisionRadius=+0050.000000
		CollisionHeight=+0050.000000
		BlockZeroExtent=true
		CollideActors=true
	End Object
	CollisionComponent=CylinderComponent0
	Components.Add(CylinderComponent0)

	FloorMesh=StaticMesh'NYC_SetB_02.SM.Mesh.S_NYC_SetB_FireEscape_01c'
	LadderMesh=StaticMesh'HU_Decox.SM.Mesh.S_HU_Deco_SM_Ladder01_Dup'

	LadderStrainSound=SoundCue'Foley_Body.Player.Player_PerchDense_Creak_Cue'
	LadderLaunchSound=SoundCue'Foley_Body.Player.Player_PerchDense_Launch_Cue'

	ActiveMantleBeginSound=SoundCue'Foley_Body.Player.Player_TurbineRideMetal_Stereo_Cue'
	ActiveMantleSuccessSound=SoundCue'Character_Lyrik_Efforts.Lyrik_Efforts_ClimbUpSmall_Cue'
	ActiveMantleFlubSound=SoundCue'Character_Lyrik_Efforts.Lyrik_Efforts_ClimbUpSmall_Cue'

	ActiveMantleCameraShake=NanoCameraShake'Nano_Proto_CrowdCars.ElevatorCameraShakeThreshold'
}
