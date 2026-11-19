/**
 * TODO: this need to be in Engine.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class SeqAct_AddAnimSet extends SequenceAction;

/** List of AnimSets to add to GearPawn Target */
var()	Array<AnimSet>	AnimSets;
/** Optional AnimTree to put on the Pawn */
var()	AnimTree	AnimTree;

defaultproperties
{
	ObjName="Add AnimSets to GearPawn"
	ObjCategory="Gear"

	InputLinks(0)=(LinkDesc="Add AnimSets")
	InputLinks(1)=(LinkDesc="Remove AnimSets")

	// define the base output link that this action generates (always assumed to generate at least a single output)
	OutputLinks(0)=(LinkDesc="Out")
}
