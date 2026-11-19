/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class UIScene_EndOfRound_Siege extends UIScene_EndOfRound_Wave;

/** Immediately starts the next wave with the appropriate gametype */
function ImmediateStartNextWave(GearGameMP_Base Game)
{
	local GearGameSiege_Base SiegeGame;

	SiegeGame = GearGameSiege_Base(Game);
	if (SiegeGame != None && SiegeGame.IsTimerActive(nameof(SiegeGame.StartNextWave)))
	{
		SiegeGame.ClearTimer(nameof(SiegeGame.StartNextWave));
		SiegeGame.StartNextWave();
	}
}

/** 
 * Hook for marking profile data related to wave completion
 * @param WaveIndex - wave to mark completed (0-based)
 */
function MarkWaveAsCompleted(int WaveIndex)
{
	local PlayerController PC;
	local GearPRI PRI;
	local GearPC GPC;

	// Go through all local players
	foreach GRI.LocalPlayerControllers(class'PlayerController', PC)
	{
		PRI = GearPRI(PC.PlayerReplicationInfo);
		if (PRI != None)
		{
			GPC = GearPC(PC);
			if (GPC != None && GPC.ProfileSettings != None)
			{
				GPC.ProfileSettings.MarkSiegeWaveAsCompleted(WaveIndex, GPC);
			}
		}
	}
}

//==============================================================
// Spinup Callbacks
//==============================================================
function BeginSpin_LocalPlayerInfo()
{
	Super.BeginSpin_LocalPlayerInfo();

	// Spin up the tokens, which are specific to Siege
	BeginSpin_TokensEarned();
}

function BeginSpin_TokensEarned()
{
	lbl_TokensEarned.SetString("PrependString", TokensEarnedText $ " ");
	lbl_TokensEarned.SetFloat("GoalValue", GetTokensEarnedThisRound());
}

//==============================================================
// Scoring Functions
//==============================================================
/** Sets up the game-specific info for the floating scoreboard widget with the local player's score */
function SetLocalPlayerFloatingScoreInfo()
{
	local GearPRI_Siege SiegePRI;

	SiegePRI = GearPRI_Siege(LocalPRI);
	mc_FloatingPlayerScore.SetPlayerData(SiegePRI.PlayerName, (SiegePRI.WavePointsRemaining <= 0), SiegePRI.GetGameScore1(), SiegePRI.GetGameScore2(), true, true);
}

function PopulateScoreboardData(array<GearPRI> SortedPRIs)
{
	local array<PlayerScoreboardData> PlayerData;
	local PlayerScoreboardData CurrData;
	local GearPRI_Siege SiegePRI;
	local int i;

	for( i = 0; i < SortedPRIs.Length; i++ )
	{
		SiegePRI = GearPRI_Siege(SortedPRIs[i]);

		// For each PRI, fill in the appropriate data for Siege, and add it to the array
		CurrData.PlayerName = SiegePRI.PlayerName;
		CurrData.bShouldStrikeout = (SiegePRI.WavePointsRemaining <= 0);
		CurrData.Kills = SiegePRI.GetGameScore1();
		CurrData.TotalScore = SiegePRI.GetGameScore2();

		PlayerData.AddItem(CurrData);
	}

	ScoreboardWidget.PopulateScoreboardData(PlayerData);
}

/** If TRUE, this EOR board needs to have the tokens earned label visible */
function bool ShouldShowTokensEarned()
{
	return TRUE;
}

function int GetTokensEarnedThisRound()
{
	local GearPRI_Siege PRI;

	PRI = GearPRI_Siege(GetPC().PlayerReplicationInfo);
	return PRI.WavePointsEarnedThisRound;
}

function string GetSurvivalBonusQualifier()
{
	// In siege, the survival bonus is based on the number of seconds in the round
	return FormatTime(GRI.RoundEndTime);
}

defaultproperties
{
	PlayerTeamNum=1
}
