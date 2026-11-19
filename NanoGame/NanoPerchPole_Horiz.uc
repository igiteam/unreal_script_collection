/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoPerchPole_Horiz extends NanoPerchPole_Base
	placeable;

/** Control used for flexing pole */
var transient SkelControlSingleBone PoleRot1Control;
/** Control used for flexing pole */
var transient SkelControlSingleBone PoleRot2Control;

/** Max amount pole can flex (input for control) */
var float                           MaxPoleRot;

simulated event PostBeginPlay()
{
	// Grab the control for changing the pole
// 	PoleRot1Control = SkelControlSingleBone(SkeletalMeshComponent.FindSkelControl('PoleRot1'));
// 	PoleRot2Control = SkelControlSingleBone(SkeletalMeshComponent.FindSkelControl('PoleRot2'));
	super.PostBeginPlay();
}

/** Called from base class to update pole bending */
simulated function SetBendAmount(float Bend)
{
// 	PoleRot2Control.BoneRotation.Roll = (Bend * MaxPoleRot);
// 	PoleRot1Control.BoneRotation.Roll = (Bend * MaxPoleRot * 0.5);
}

defaultproperties
{
	PerchType=PT_HorzPole
	PerchSocketName=Tip

	MaxPoleRot=5461

	Begin Object Name=SkeletalMeshComponent0
		SkeletalMesh=SkeletalMesh'MET_Flagpole.SK_MET_Deco_Exterior01_Flagpole'
		Materials(0)=MaterialInstanceConstant'Nano_Blockbuster.Materials.MI_BlockbusterSkin_SimpleChrome'
		PhysicsAsset=PhysicsAsset'MET_Flagpole.SK_MET_Deco_Exterior01_Flagpole_Physics'
		AnimTreeTemplate=AnimTree'MET_Flagpole.FlagPole_AT'
		AnimSets(0)=AnimSet'MET_Flagpole.AS_GEN_FlagPole'
		CollideActors=FALSE // we use a CylinderComponent attacked to this actor for determining whether or not a pawn has touched
	End Object

	BendingCue=SoundCue'Foley_Body.Player.Player_PerchDense_Creak_Cue'
	DenseBendingCue=SoundCue'Foley_Body.Player.Player_PerchDense_Creak_Cue' 
	UnbendCue=SoundCue'Foley_Body.Player.Player_PerchDense_Launch_Cue'
}