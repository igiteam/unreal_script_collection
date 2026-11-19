/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class SeqEvt_SpokeWithNPC extends SeqEvent_Used
	native(Sequence);

/** Icon to show above head when they can be spoken to */
var() EHeadIconType HeadIcon;

/** If we should show this on the minimap */
var() bool bShowOnMinimap;

/** Dialog track to play, based on how the pawn triggered the briefing */
var int     Track;

cpptext
{
	virtual UBOOL CheckActivate(AActor *InOriginator, AActor *InInstigator, UBOOL bTest=FALSE, TArray<INT>* ActivateIndices = NULL, UBOOL bPushTop = FALSE);
};

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 3;
}

defaultproperties
{
	ObjCategory="Nano Briefing"
	ObjName="Spoke With NPC"

	OutputLinks(0)=(LinkDesc="Spoke With NPC")

	VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Instigator",bWriteable=true,PropertyName=Instigator,MaxVars=1)
	VariableLinks(1)=(ExpectedType=class'SeqVar_Object',LinkDesc="Mission Giver",bWriteable=true,PropertyName=Originator)
	VariableLinks(2)=(ExpectedType=class'SeqVar_Int',LinkDesc="Track",bWriteable=true,PropertyName=Track)

	HeadIcon=EHIT_Exclamation
	bShowOnMinimap=TRUE
}