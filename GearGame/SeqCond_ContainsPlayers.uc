/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqCond_ContainsPlayers extends SequenceCondition
	native(Sequence);

/** The least amount of players that must be in the list before it will return true */
var() int MinNumPlayersToFind;

/** If true, 'Players' is considered to be all PCs and bots. If false, 'Players' is considered to be only all PCs */
var() bool bCountBotsAsPlayers;

/** If true, only members of the specified team will be counted */
var() bool bOnlyCountPlayersOnSpecifiedTeam;

/** If bOnlyCountPlayersOnSpecifiedTeam is true, then this variable denotes which team's players will be detected */
var() int TeamToDetect;


cpptext
{
	virtual void Activated();
}

defaultproperties
{
	ObjName="Contains Players"

	OutputLinks(0)=(LinkDesc="True")
	OutputLinks(1)=(LinkDesc="False")
	VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Potential Players")
	
	MinNumPlayersToFind=1
	TeamToDetect=0
}
