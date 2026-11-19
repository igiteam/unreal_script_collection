/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqEvt_NanoDefensivePointDefeated extends SequenceEvent;

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

defaultproperties
{
	ObjName="Nano DefensivePoint Defeated"
	ObjCategory="Nano Procedural"

	bPlayerOnly=FALSE
	MaxTriggerCount=0


	OutputLinks(0)=(LinkDesc="All AI Within Defense Radius Dead")
	OutputLinks(1)=(LinkDesc="All NDP Spawned AI Dead")

}