/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */

class TMSeqAct_AddNamedBot extends SequenceAction;

/** name of bot to spawn */
var() string BotName;
/** If true, force the bot to a given team */
var() bool bForceTeam;
/** The Team to add this bot to.  For DM leave at 0, otherwise Red=0, Blue=1 */
var() int TeamIndex;
/** NavigationPoint to spawn the bot at */
var() NavigationPoint StartSpot;

/** reference to bot controller so Kismet can work with it further */
var TMBot SpawnedBot;

event Activated()
{
	local TMGame Game;

	Game = TMGame(GetWorldInfo().Game);
	if (Game != None)
	{
		Game.ScriptedStartSpot = StartSpot;
		if (Game.SinglePlayerMissionID != INDEX_NONE)
		{
			if (Game.NumDivertedOpponents > 0 && bForceTeam && TeamIndex != 0)
			{
				Game.NumDivertedOpponents--;
			}
			else
			{
				SpawnedBot = Game.SinglePlayerAddBot(BotName, bForceTeam, TeamIndex);
			}
		}
		else
		{
			SpawnedBot = Game.AddBot(BotName, bForceTeam, TeamIndex);
		}
		if (SpawnedBot != None && SpawnedBot.Pawn == None)
		{
			Game.RestartPlayer(SpawnedBot);
		}
		Game.ScriptedStartSpot = None;
	}
}

/**
 * Return the version number for this class.  Child classes should increment this method by calling Super then adding
 * a individual class version to the result.  When a class is first created, the number should be 0; each time one of the
 * link arrays is modified (VariableLinks, OutputLinks, InputLinks, etc.), the number that is added to the result of
 * Super.GetObjClassVersion() should be incremented by 1.
 *
 * @return	the version number for this specific class.
 */
static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

