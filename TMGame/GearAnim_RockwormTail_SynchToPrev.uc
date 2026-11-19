
/**
* Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
*/

class GearAnim_RockwormTail_SynchToPrev extends AnimNodeBlendBase
	native(TGAnim);

// cached ref to tailsegment I belong to
//var RockWorm_TailSegment MyTailSeg;

/** cached ref to the node in prev seg we're synching to */
var AnimNodeSequence MasterNodeToSyncTo;
/** cached ref to the local node that needs to be synched (or is going to be the master)*/
var AnimNodeSequence MySynchNode;

/** name of the group to synch to previous tailseg */
var() name SynchGroupName;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)


