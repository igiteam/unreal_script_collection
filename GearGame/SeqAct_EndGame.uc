/**
 * ends the game and returns to the menu
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class SeqAct_EndGame extends SequenceAction;

event Activated()
{
	local WorldInfo WI;
	local GearPC_SP PC;

	// Have everyone return to the party
	WI = GetWorldInfo();
	if (WI != None && WI.Game != None)
	{
		WI.Game.TellClientsToReturnToPartyHost();
	}

	// Have everyone prepare for rolling credits and saving their data
	foreach WI.AllControllers(class'GearPC_SP', PC)
	{
		if (PC.IsPrimaryPlayer())
		{
			PC.ClientPrepareEndOfGameFrontEnd();
		}
	}
}

defaultproperties
{
	ObjName="End Game"
	ObjCategory="Gear"
	bCallHandler=false

	VariableLinks.Empty
}
