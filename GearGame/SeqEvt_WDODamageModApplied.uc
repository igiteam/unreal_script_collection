/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/
class SeqEvt_WDODamageModApplied extends SequenceEvent
	native(Sequence);

/** Only fire this event if the subobject damaged matches */
var() Name SubObjectName;

/** Only fire this event if the particular specified damage mod matches */
var() Name DamageModName;

cpptext
{
	void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);
};

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

defaultproperties
{
	ObjName="Destruction Applied"
	ObjCategory="Gear"
	bPlayerOnly=FALSE

	OutputLinks(0)=(LinkDesc="Out")
}
