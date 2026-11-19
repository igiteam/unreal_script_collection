/**
 * Activated when a player earns a kill
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqEvt_PlayerDied extends SequenceEvent
	native(Sequence);

enum EEarnedKillTypes
{
	eEARNKILL_AllKills,
	eEARNKILL_NotTeamkills,
	eEARNKILL_OnlyTeamkills,
};

/** What sort of kills to trigger for */
var() EEarnedKillTypes CountableKills;

cpptext
{
	UBOOL RegisterEvent();
	UBOOL CheckActivate(AActor *InOriginator, AActor *InInstigator, UBOOL bTest, TArray<INT>* ActivateIndices, UBOOL bPushTop);
}

defaultproperties
{
	ObjName="Player Earned a Kill"
	ObjCategory="Multiplayer"

	VariableLinks.Empty

	OutputLinks(0)=(LinkDesc="Team 1")
	OutputLinks(1)=(LinkDesc="Team 2")
	OutputLinks(2)=(LinkDesc="Team 3")
	OutputLinks(3)=(LinkDesc="Team 4")
	OutputLinks(4)=(LinkDesc="Team 5")

	bPlayerOnly=false
	MaxTriggerCount=0
	
	CountableKills=eEARNKILL_NotTeamkills
}