/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_CurrencyHasEnough extends SequenceAction;

/** Amount of currency to see if the player has at least this much **/
var() int Amount;


static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}


defaultproperties
{
	ObjName="Nanite Resource Has Enough"
	ObjCategory="Nano Skill Resources"

	bAutoActivateOutputLinks=FALSE

	OutputLinks(0)=(LinkDesc="Yes")
	OutputLinks(1)=(LinkDesc="No")
}