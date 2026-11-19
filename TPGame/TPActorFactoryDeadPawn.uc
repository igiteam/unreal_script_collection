/**
 * Copyright ? 2004-2005 Epic Games, Inc. All Rights Reserved.
 */
class TPActorFactoryDeadPawn extends ActorFactory
    dependson(TPDeadPawn)
	native;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

var() SkeletalMesh            SkeletalMesh;
var() PhysicsAsset            PhysicsAsset;

var() float                   FreezeTime;
var() float                   NewLifeSpan;

var() array<FixedBoneType>	  FixedBoneNames;

var() name                    AnimPose;
var() array<AnimSet>          AnimSets;

var() bool                    bWakeOnLevelStart;

