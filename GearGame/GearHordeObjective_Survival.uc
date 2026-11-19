/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearHordeObjective_Survival extends GearHordeBonusObjective;

static function bool CanBeSelected(GearGameHorde_Base InGame)
{
	// require at least three players so it's not practically a guarantee if you win at all
	return (InGame.NumPlayers + InGame.NumBots >= 3);
}

function ProcessKill(Controller Killer, Controller KilledPlayer, Pawn KilledPawn, class<DamageType> DamageType)
{
	if (KilledPlayer != None && KilledPlayer.GetTeamNum() == 0)
	{
		FailObjective();
	}
}

function NotifyWaveEnded()
{
	CompleteObjective();
}
