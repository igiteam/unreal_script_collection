/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * Archetype for controlling a GearPawn's gore settings
 */
class GearPawnGoreSettings extends Object
	native(Pawn)
	hidecategories(Object);

/** Array of Breakable bone names to use when gibbing a GoreMesh. */
var() const array<GoreBreakableJoint> GoreBreakableJoints;

/** This specified how to apply force to the "leftover" part of the mesh, after the gore bits have been removed. */
var() const GoreBreakableJoint GoreRootJoint;

/** List of joints that have dependencies that need to be respected when breaking the mesh */
var() const array<DependantBreakInfo> JointsWithDependantBreaks;

/** The LOD to use as the gore mesh */
var() const int GoreMeshLOD;

/** The gore material ID to unhide */
var() const int GoreMeshMaterialID;

/** The set of materials to use for gore */
var() const array<MaterialInterface> GoreMeshMaterials;

/** The phys asset to swap to for gore */
var() const PhysicsAsset GoreMeshPhysAsset;

/** The list of bones to break off when a hostage */
var() const array<Name> HostageBones;

/** The spine bone to break when being chainsawed */
var() const Name ChainsawSpineBone;

/** The arm bone to break when being chainsawed */
var() const Name ChainsawArmBone;

defaultproperties
{
	GoreMeshLOD=-1
	GoreMeshMaterialID=-1
	ChainsawSpineBone="b_MF_Spine_03"
	ChainsawArmBone="b_MF_UpperArm_R"
}
