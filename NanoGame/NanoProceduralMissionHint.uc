/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoProceduralMissionHint extends NanoTargetPoint
	AutoExpandCategories( NanoProceduralMissionHint )
	native
	placeable;


/** If we have a proc mission active from us then we don't want to keep spawning them from us. **/
var transient bool bProcMissionActive;

/** The last time a mission was on this MissionHint **/
var transient float LastMissionTime;



/** 
 *  Use this to choose which missions can spawn near this point.  Right now we don't have any meta data
 *  avail in the navmesh, so we need to hand place some actors around so we can use them to determine
 *  things like (this is the ground level so messengers can spawn here and such)
 *
 * If this is empty, then ALL missions will be able to spawn from here.
 *  
 **/
var() array<class<NanoProceduralMissionBase> > WhichMissionsCanSpawnNearHere;

/**
 *  Any mission types listed in this list will not spawn at this location.
 *
 *
 *
 **/
var() array<class<NanoProceduralMissionBase> > WhichMissionsCanNotSpawnNearHere;




defaultproperties
{
	Debug_Icon=None

	Begin Object Name=Sprite
		Sprite=Texture2D'UI_HUD.Minimap.MissionProc'
	End Object

    // TODO make our own awesome octree for random gameplay shizzles
	// We need to get put into the octree to allow fast querying of these guys
	// Perhaps our own special octree for them?
	bCollideActors=TRUE
	bBlockActors=TRUE

	Begin Object Class=CylinderComponent Name=CollisionCylinder
	   CollisionRadius=16.0
	   CollisionHeight=16.0
	   BlockNonZeroExtent=FALSE
	   BlockZeroExtent=FALSE
	   BlockActors=FALSE
	   CollideActors=TRUE
	   BlockRigidBody=FALSE
	End Object
	CollisionComponent=CollisionCylinder
	Components.Add(CollisionCylinder)

}







