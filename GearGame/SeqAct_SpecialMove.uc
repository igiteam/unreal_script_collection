/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_SpecialMove extends SeqAct_Latent
	native(Sequence);

cpptext
{
	UBOOL UpdateOp(FLOAT DeltaTime);
	virtual FString GetAutoComment() const;
}

/** Which special move to play for this execution */
var() class<GearSpecialMove> SpecialMove;
/** Interaction pawn */
var() Actor InteractionPawn;
/** Special Move flags */
var() int SpecialMoveFlags;
/** Actor to align to */
var() Actor AlignActor; 
/** Offset to align actor */
var() vector AlignOffset;

var transient bool bSpecialMoveStarted;

/**
* Return the version number for this class.  Child classes should increment this method by calling Super then adding
* a individual class version to the result.  When a class is first created, the number should be 0; each time one of the
* link arrays is modified (VariableLinks, OutputLinks, InputLinks, etc.), the number that is added to the result of
* Super.GetObjClassVersion() should be incremented by 1.
*
* @return	the version number for this specific class.
*/
static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 2;
}

defaultproperties
{
	ObjName="Special Move"
	ObjCategory="Gear"

	bSuppressAutoComment=false

	VariableLinks(1)=(ExpectedType=class'SeqVar_Object',LinkDesc="Interaction Pawn",PropertyName=InteractionPawn,MaxVars=1)
	VariableLinks(2)=(ExpectedType=class'SeqVar_Object',LinkDesc="Align Actor",PropertyName=AlignActor,MaxVars=1)

	OutputLinks(0)=(LinkDesc="Finished")
	OutputLinks(1)=(LinkDesc="Started")
}
