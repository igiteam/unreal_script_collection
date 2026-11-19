/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_NotifyCoopSplit extends SequenceAction
	native(Sequence);

/** whether this is a solo split (i.e. it's game over if the player goes DBNO because there's no one to revive them) */
var() bool bSoloSplit;
/** Whether seperate squads can reach each other, if TRUE they cannot reach eachother */
var() bool bGapSquadSplit;

cpptext
{
	void Activated();
};


defaultproperties
{
	bCallHandler=FALSE
	bGapSquadSplit=TRUE

	ObjName="Notify Co-op Split"
	ObjCategory="Gear"

	InputLinks(0)=(LinkDesc="Split Started")
	InputLinks(1)=(LinkDesc="Split Ended")

	VariableLinks.Empty
}
