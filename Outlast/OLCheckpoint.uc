//=============================================================================
// Player Checkpoint
// Copyright 2012 Red Barrels, Inc. All Rights Reserved.
//=============================================================================
class OLCheckpoint extends PlayerStart
	placeable
	native;

var() name CheckpointName;
var() bool bKillAllEnemies;

var() name PersistentLevelName;

native function OnPlayerSpawn();
native function ResetCheckpointDeaths();

function SetEnabled(bool bEnable)
{
	local OLGame CurrentGame;

	bEnabled = bEnable;

	if (bEnabled)
	{
		CurrentGame = OLGame(WorldInfo.Game);

		if (CurrentGame.CurrentCheckpointName != CheckpointName)
		{
			ResetCheckpointDeaths();
			CurrentGame.CurrentCheckpointName = CheckpointName;
		}
	}
}

simulated function OnToggle(SeqAct_Toggle action)
{
	local OLGame CurrentGame;

	Super.OnToggle(action);

	if (bEnabled)
	{
		CurrentGame = OLGame(WorldInfo.Game);

		if (CurrentGame.CurrentCheckpointName != CheckpointName)
		{
			ResetCheckpointDeaths();
			CurrentGame.CurrentCheckpointName = CheckpointName;
		}
	}
}

defaultproperties
{
	bNotBased=true
	bKillAllEnemies=true
}
