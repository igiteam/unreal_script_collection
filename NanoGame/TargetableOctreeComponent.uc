/**
 *
 *
 * To use this just add the following code to the default properties to the object
 * you want to be targetable.
 *
 * Begin Object Class=TargetableOctreeComponent Name=TargetableOctreeComp0
 * End Object
 * Components.Add(TargetableOctreeComp0)
 *
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class TargetableOctreeComponent extends ActorComponent
    native;


/** This is the Octree ID which is used to remove items from the octree.  This is set in the OctreeSemantics**/
var	transient native OctreeElementId TargetableOctreeID{FOctreeElementId};

/** 
 * We might want to cache the bounds on the TargetableOctreeComponent.  For now we will do GetComponentsBoundingBox 
 * in static FBoxCenterAndExtent GetBoundingBox in the FOctreeSemantics
 **/
//var transient BoxSphereBounds Bounds;


// these need to be per EnemyType probably
// having turrets not be NanoPawnBase derived is a bit insane

var transient array<NanoAIBase> MeleeEngageList;

var transient array<NanoAIBase> MeleeStandByList;

var transient array<NanoAIBase> MeleeSpectatorList;

var transient array<NanoAIBase> RangedShooterList;

/** How many AI are actually firing bullets at the Player **/
var transient int NumCurrentlyShooting;

/** How many AI are actually meleeing at the Player **/
var transient int NumCurrentlyMeleeing;


var bool bHasOverridesForMeleeListRanges;
var array<MeleeListDatum> MeleeListRanges;


cpptext
{
	virtual void BeginDestroy();

	/** If the component is moving around then we will need to remove and re-add it to the octree. **/
	virtual void UpdateTransform();
}



DefaultProperties
{
	bHasOverridesForMeleeListRanges=FALSE
}