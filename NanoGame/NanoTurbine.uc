/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoTurbine extends NanoTurbineBase;


defaultproperties
{
	Begin Object Class=SkeletalMeshComponent Name=TurbineMesh_0
		SkeletalMesh=SkeletalMesh'GEN_Turbine.SK_GEN_Turbine'
		Materials(0)=MaterialInstanceConstant'Nano_Blockbuster.Materials.MI_BlockbusterSkin_BigTurbine'
		PhysicsAsset=PhysicsAsset'GEN_Turbine.SK_GEN_Turbine_Physics'
		AnimTreeTemplate=AnimTree'GEN_Turbine.AT_Turbine'
		AnimSets.Add(AnimSet'GEN_Turbine.AS_GEN_Turbine');
		CollideActors=TRUE
		BlockZeroExtent=TRUE
		BlockNonZeroExtent=TRUE
	End Object
	Mesh=TurbineMesh_0
	CollisionComponent=TurbineMesh_0
	Components.Add(TurbineMesh_0)

	bIsActive=TRUE

	BladeTips(0)=(BoneName=b_Wind_Turbine_Blade_01,AnimPositionOffset=0.33333f)
	BladeTips(1)=(BoneName=b_Wind_Turbine_Blade_02,AnimPositionOffset=0.f)
	BladeTips(2)=(BoneName=b_Wind_Turbine_Blade_03,AnimPositionOffset=0.66666f)

	// .7 sec, 1.433 sec

	bCollideActors=TRUE

	LaunchVelocity=(X=4096,Z=8192)

	PlayerGrabbedCue=SoundCue'Foley_Body.Player.Player_TurbineRideGrab_Stereo_Cue' 
	PlayerGrabbedSoundMode=TurbineRide

	SupportedEvents.Add(class'SeqEvt_NanoTurbine')
}
