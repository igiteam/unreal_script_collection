/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqEvt_AIStateChanged extends SequenceEvent;

enum EAIMoods
{
	AIMood_Unaware,
	AIMood_Alert,
	AIMood_Scared,
	AIMood_Aggressive,
	AIMood_Killed,
	AIMood_DefendingLocation,
};


static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}


//scared, aggressive, killed, unaware
defaultproperties
{
	ObjName="Mood Changed"
	ObjCategory="AI"

	OutputLinks(AIMood_Scared)=(LinkDesc="Scared")
	OutputLinks(AIMood_Aggressive)=(LinkDesc="Aggressive")
	OutputLinks(AIMood_Killed)=(LinkDesc="Killed")
	OutputLinks(AIMood_Unaware)=(LinkDesc="Unaware")
	OutputLinks(AIMood_Alert)=(LinkDesc="Alert")
	OutputLinks(AIMood_DefendingLocation)=(LinkDesc="DefendingLocation")

	bPlayerOnly=false
}
