/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_CurrencyTake extends SequenceAction;

/** Amount of currency to take **/
var() int Amount;


static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}


defaultproperties
{
	ObjName="Nanite Resource Take"
	ObjCategory="Nano Skill Resources"
}