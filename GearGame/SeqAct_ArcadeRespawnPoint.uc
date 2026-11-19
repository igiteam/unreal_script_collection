/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_ArcadeRespawnPoint extends SequenceAction;

event Activated()
{
	if (GearGameSP_Arcade(GetWorldInfo().Game) != None)
	{
		GearGameSP_Arcade(GetWorldInfo().Game).ResurrectDeadPlayers();
	}
}

defaultproperties
{
	ObjCategory="Gear"
	ObjName="Arcade Respawn Players"
	VariableLinks.Empty
}
