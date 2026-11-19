/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_CurrencyGive extends SequenceAction;

/** Amount of currency to give **/
var() int Amount;


static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

defaultproperties
{
	ObjName="Nanite Resource Give"
	ObjCategory="Nano Skill Resources"
}