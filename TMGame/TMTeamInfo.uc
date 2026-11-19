/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */
//=============================================================================
// TMTeamInfo.
// includes list of bots on team for multiplayer games
//
//=============================================================================

class TMTeamInfo extends TeamInfo
	native;

var int DesiredTeamSize;
var TMTeamAI AI;
var string TeamSymbolName;
var RepNotify Material TeamIcon;
var TMGameObjective HomeBase;			// key objective associated with this team
var TMCarriedObject TeamFlag;
/** only bot characters in this faction will be used */
var string Faction;

var color BaseTeamColor[4];
var color TextColor[4];
var localized string TeamColorNames[4];

replication
{
	// Variables the server should send to the client.
	if (bNetInitial)
		TeamIcon;

	if (bNetDirty)
		HomeBase, TeamFlag;

}

simulated function string GetHumanReadableName()
{
	if ( TeamName == Default.TeamName )
	{
		if ( TeamIndex < 4 )
			return TeamColorNames[TeamIndex];
		return TeamName@TeamIndex;
	}
	return TeamName;
}

simulated function color GetHUDColor()
{
	return BaseTeamColor[TeamIndex];
}

simulated function color GetTextColor()
{
	return TextColor[TeamIndex];
}

/* Reset()
reset actor to initial state - used when restarting level without reloading.
*/
function Reset()
{
	Super.Reset();
	if ( !TMGame(WorldInfo.Game).bTeamScoreRounds )
		Score = 0;
}

function bool AllBotsSpawned()
{
	return false;
}

/**
 * Initializes the team index and grabs any associated BotTeamRosters
 */
function Initialize(int NewTeamIndex)
{
	TeamIndex = NewTeamIndex;
}

function bool NeedsBotMoreThan(TMTeamInfo T)
{
	return ( (DesiredTeamSize - Size) > (T.DesiredTeamSize - T.Size) );
}

function SetBotOrders(TMBot NewBot)
{
	if (AI != None)
	{
		AI.SetBotOrders(NewBot);
	}
}

function RemoveFromTeam(Controller Other)
{
	Super.RemoveFromTeam(Other);
	if (AI != None)
	{
		AI.RemoveFromTeam(Other);
	}
}

function bool BotNameTaken(string BotName)
{
	local int i;
	local TMPlayerReplicationInfo PRI;
	local TMGameReplicationInfo GRI;

	GRI = TMGameReplicationInfo(WorldInfo.GRI);
	for (i=0;i<GRI.PRIArray.Length;i++)
	{
		PRI = TMPlayerReplicationInfo(WorldInfo.GRI.PRIArray[i]);
		if (PRI.PlayerName == BotName)
		{
			return true;
		}

		// Since players might not have the same name in game as the character,
		// we need to check the references.
		if (PRI.SinglePlayerCharacterIndex != INDEX_NONE)
		{
			if ( BotName == GRI.SinglePlayerBotNames[PRI.SinglePlayerCharacterIndex])
			{
				return true;
			}
		}
	}
	return false;
}

function bool FamilyIsMale(string FamilyID)
{
	if(FamilyID == "IRNF" || FamilyID == "TWIF" || FamilyID == "NECF")
	{
		return FALSE;
	}
	else
	{
		return TRUE;
	}
}

function GetAvailableBotList(out array<int> AvailableBots, optional string FactionFilter, optional bool bMalesOnly)
{
	local int i;

	AvailableBots.length = 0;
	for (i=0;i<class'TMCharInfo'.default.PLACharacters.length;i++)
	{
		if(	(FactionFilter == "" || class'TMCharInfo'.default.PLACharacters[i].Faction ~= FactionFilter) &&
			(!bMalesOnly || FamilyIsMale(class'TMCharInfo'.default.PLACharacters[i].FamilyID)) &&
			!BotNameTaken(class'TMCharInfo'.default.PLACharacters[i].CharName) )
		{
			AvailableBots[AvailableBots.Length] = i;
		}
	}
}


/** retrieves bot info, for the named bot if a valid name is specified, otherwise from a random bot */
function CharacterInfo GetBotInfo(string BotName)
{
	local int Index;
	local array<int> AvailableBots;
	local bool bMalesOnly;

	// Only allow male chars once game is in progress..
	bMalesOnly = WorldInfo.Game.IsInState('MatchInProgress');

	Index = class'TMCharInfo'.default.PLACharacters.Find('CharName', BotName);
	if (Index == INDEX_NONE)
	{
		// First attempt to add a bot from the Faction
		if (Faction != "")
		{
			GetAvailableBotList(AvailableBots,Faction,bMalesOnly);
			if (AvailableBots.Length > 0)
			{
				Index = AvailableBots[0];
			}
		}

		// If we still haven't found a good match, take a bot from any faction
		if (Index == INDEX_None)
		{
			GetAvailableBotList(AvailableBots,,bMalesOnly);
			if (AvailableBots.Length > 0)
			{
				Index = AvailableBots[Rand(AvailableBots.Length)];
			}
		}

		// If we still haven't found a good match looking for men, take a female
		if (bMalesOnly && Index == INDEX_None)
		{
			GetAvailableBotList(AvailableBots);
			if (AvailableBots.Length > 0)
			{
				Index = AvailableBots[Rand(AvailableBots.Length)];
			}
		}

		// At this point, if we haven't found a bot, just take any bot
		if ( Index == INDEX_None )
		{
			Index = Rand(class'TMCharInfo'.default.PLACharacters.length);
		}
	}

	return class'TMCharInfo'.default.PLACharacters[Index];
}

simulated event Destroyed()
{
	Super.Destroyed();

	if (AI != None)
	{
		AI.Destroy();
	}
}

