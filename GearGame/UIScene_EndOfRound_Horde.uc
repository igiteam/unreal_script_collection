/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class UIScene_EndOfRound_Horde extends UIScene_EndOfRound_Wave;

/** Immediately starts the next wave with the appropriate gametype */
function ImmediateStartNextWave(GearGameMP_Base Game)
{
	local GearGameHorde_Base HordeGame;

	HordeGame = GearGameHorde_Base(Game);
	if (HordeGame != None && HordeGame.IsTimerActive(nameof(HordeGame.StartNextWave)))
	{
		HordeGame.ClearTimer(nameof(HordeGame.StartNextWave));
		HordeGame.StartNextWave();
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
				GPC.ProfileSettings.MarkHordeWaveAsCompleted(WaveIndex, GPC);
			}
		}
	}
}

//==============================================================
// Scoring Functions
//==============================================================
/** Sets up the game-specific info for the floating scoreboard widget with the local player's score */
function SetLocalPlayerFloatingScoreInfo()
{
	mc_FloatingPlayerScore.SetPlayerData(LocalPRI.PlayerName, LocalPRI.bIsDead, LocalPRI.GetGameScore1(), LocalPRI.GetGameScore2(), true, true);
}

function PopulateScoreboardData(array<GearPRI> SortedPRIs)
{
	local array<PlayerScoreboardData> PlayerData;
	local PlayerScoreboardData CurrData;
	local GearHordePRI HordePRI;
	local int i;

	for( i = 0; i < SortedPRIs.Length; i++ )
	{
		HordePRI = GearHordePRI(SortedPRIs[i]);

		// For each PRI, fill in the appropriate data for Horde, and add it to the array
		CurrData.PlayerName = HordePRI.PlayerName;
		CurrData.bShouldStrikeout = HordePRI.bIsDead;
		CurrData.Kills = HordePRI.GetGameScore1();
		CurrData.TotalScore = HordePRI.GetGameScore2();

		PlayerData.AddItem(CurrData);
	}

	ScoreboardWidget.PopulateScoreboardData(PlayerData);
}

/** Returns the Survival Bonus earned this wave */
function int GetSurvivalBonus()
{
	return float(NumPlayersAlive) / NumPlayersInGame * GearGRI_Horde(GRI).InvasionCurrentWaveIndex *
		(class'GearGameHorde_Base'.default.PointsPerWave / class'GearGameHorde_Base'.default.ScoringBaselineWavePoints) *
		class'GearGameHorde_Base'.default.PointsFor_DamagePct * class'GearGameHorde_Base'.default.SurvivalBonusPct;
}

function string GetSurvivalBonusQualifier()
{
	// In horde, the survival bonus is the number of players left alive
	return string(NumPlayersAlive);
}


defaultproperties
{
	PlayerTeamNum=0
	bUseCogGameLogo=TRUE
}
