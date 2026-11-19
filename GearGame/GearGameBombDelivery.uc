/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearGameBombDelivery extends GearGameMP_Base
	abstract;

/** the main objective - the bomb */
var GearTrackBomb Bomb;
/** the class of bomb to spawn */
var class<GearTrackBomb> BombClass;
/** how many "lives" the bomb has; if > 0 and the bomb explodes this many times the defenders win */
var config int StartingBombLives;
/** how many points are awarded for each checkpoint the attacking team reaches */
var config int ScorePerCheckpointAttack;
/** how many points are awarded for each checkpoint successfully defended */
var config int ScorePerCheckpointDefense;
/** how many points are awarded when the attackers make it to the end */
var config int ScoreForCompletion;
/** how many points are awarded for bomb protection (attackers) or bomb destruction (defenders) */
var config int ScoreForBomb;

/** list of players who don't get to respawn until the spawn cycle following the current one */
var array<Controller> DelayedRespawnList;
/** whether to allow weapon cycling, so we can disable the code every other round for the attack/defend cycle */
var bool bAllowWeaponCycling;

event InitGame(string Options, out string ErrorMessage)
{
	Super.InitGame(Options, ErrorMessage);

	StartingBombLives = GetIntOption(Options, "BombLives", StartingBombLives);
}

function StartMatch()
{
	// initialize the bomb
	if (Bomb != None)
	{
		Bomb.TeamNum = 1 - Bomb.TeamNum;
		Bomb.TrackMatinee.SetPosition(0.0);
		Bomb.ReturnToCheckpoint();
	}
	else
	{
		Bomb = Spawn(BombClass);
		Bomb.TeamNum = 0;
	}
	GearBombDeliveryGRI(GameReplicationInfo).BombLivesRemaining = StartingBombLives;

	// only cycle weapons every 2 rounds so that the teams can do a full attack/defend cycle with each set
	bAllowWeaponCycling = !bAllowWeaponCycling;

	Super.StartMatch();
}

function RandomizeWeaponPickupFactories()
{
	if (bAllowWeaponCycling)
	{
		Super.RandomizeWeaponPickupFactories();
	}
}

function bool TeamHasRespawn(int TeamIdx)
{
	return true;
}

/** ignored, attacking team always uses execution rules */
function CheckForExecutionRules(string Options);

function bool AutoReviveOnBleedOut( Pawn TestPawn )
{
	// attacking team has execution rules
	return (TestPawn.GetTeamNum() == Bomb.TeamNum);
}

function bool CanBeShotFromAfarAndKilledWhileDownButNotOut(Pawn TestPawn, Pawn InstPawn, class<GearDamageType> TheDamageType)
{
	// attacking team has execution rules
	if ( TestPawn != None && TestPawn.GetTeamNum() == Bomb.TeamNum &&
		(TheDamageType == None || !TheDamageType.static.ShouldIgnoreExecutionRules(TestPawn,InstPawn)) )
	{
		return false;
	}
	else
	{
		return Super.CanBeShotFromAfarAndKilledWhileDownButNotOut( TestPawn, InstPawn, TheDamageType );
	}
}

function bool ShouldRespawnPC(int TeamIdx, Controller PCToRespawn)
{
	return (DelayedRespawnList.Find(PCToRespawn) == INDEX_NONE && Super.ShouldRespawnPC(TeamIdx, PCToRespawn));
}

function Actor GetObjectivePointForAI(GearAI AI)
{
	return Bomb;
}

/** notification that the bomb has exploded (for decrementing lives, etc) */
function NotifyBombExploded();
/** notification that the bomb has just passed a new checkpoint - @note: not called for the end of the path */
function NotifyBombCheckpoint();
/** notification that the bomb has completed its path (i.e. attackers win) */
function NotifyBombPathComplete();

/** only allow the game to end at the completion of a full attacker/defender cycle */
function bool CheckEndGame(PlayerReplicationInfo Winner, string Reason)
{
	local bool bResult;

	if (Teams[0].Score != Teams[1].Score)
	{
		if (Bomb.TeamNum == 1)
		{
			bResult = true;
		}
		else if (Teams[0].Score - Teams[1].Score > (Bomb.NumCheckpoints - 1) * ScorePerCheckpointDefense + (ScoreForBomb * StartingBombLives))
		{
			bResult = true;
		}
		else if (Teams[1].Score - Teams[0].Score > (Bomb.NumCheckpoints - 1) * ScorePerCheckpointAttack + ScoreForCompletion + (ScoreForBomb * StartingBombLives))
		{
			bResult = true;
		}
	}
	return (bResult && Super.CheckEndGame(Winner, Reason));
}

state MatchInProgress
{
	function EndState(name NextStateName)
	{
		Super.EndState(NextStateName);

		DelayedRespawnList.length = 0;
	}

	function RestartPlayer(Controller NewPlayer)
	{
		GearPRI(NewPlayer.PlayerReplicationInfo).ClearDeathVariables();
		Super(GearGame).RestartPlayer(NewPlayer);
	}

	function NotifyBombExploded()
	{
		local int WinningTeamNum;

		if (StartingBombLives > 0)
		{
			// award defending team points for blowing up a bomb
			Teams[1 - Bomb.TeamNum].Score += ScoreForBomb;
			// if the bomb is out of lives, the defenders win the round
			GearBombDeliveryGRI(GameReplicationInfo).BombLivesRemaining--;
			if (GearBombDeliveryGRI(GameReplicationInfo).BombLivesRemaining <= 0)
			{
				WinningTeamNum = 1 - Bomb.TeamNum;
				WinningTeamNum = HandleWinningTeamOverride(WinningTeamNum);

				if (WinningTeamNum != -1)
				{
					HandleTeamWin(WinningTeamNum);
				}
			}
		}
	}

	function NotifyBombCheckpoint()
	{
		// give the attacking team points for reaching a checkpoint
		Teams[Bomb.TeamNum].Score += ScorePerCheckpointAttack;
	}

	function NotifyBombPathComplete()
	{
		// give the attacking team points for reaching the end, then finish the round
		Teams[Bomb.TeamNum].Score += ScorePerCheckpointAttack + ScoreForCompletion;
		HandleTeamWin(Bomb.TeamNum);
	}

	function bool HandleRoundTimerExpired()
	{
		local int WinningTeamNum;

		// defending team wins if time expires
		WinningTeamNum = 1 - Bomb.TeamNum;
		WinningTeamNum = HandleWinningTeamOverride(WinningTeamNum);

		if (WinningTeamNum != -1)
		{
			return HandleTeamWin(WinningTeamNum);
		}
		else
		{
			GameReplicationInfo.Winner = None;
			GearGRI_MP(GameReplicationInfo).FinalKiller = None;
			GotoState('PreRound');
			return true;
		}
	}

	function bool HandleTeamWin(int WinningTeamIdx)
	{
		local int CheckpointsReached;

		// award defending team points for checkpoints not reached
		CheckpointsReached = int(Bomb.TrackMatinee.Position / (Bomb.TrackMatinee.InterpData.InterpLength / Bomb.NumCheckpoints));
		Teams[1 - Bomb.TeamNum].Score += (Bomb.NumCheckpoints - CheckpointsReached) * ScorePerCheckpointDefense;
		// award attacking team points for any bombs that survived
		Teams[Bomb.TeamNum].Score += GearBombDeliveryGRI(GameReplicationInfo).BombLivesRemaining * ScoreForBomb;

		return Super.HandleTeamWin(WinningTeamIdx);
	}

	function ScoreKill(Controller Killer, Controller Other)
	{
		// force defenders to have a long spawn timer if the bomb isn't moving
		if ( WorldInfo.TimeSeconds - Bomb.LastAdvanceTime > 1.0 && Other.GetTeamNum() != Bomb.TeamNum &&
			GearGRI.RespawnTime < RespawnTimeInterval / 2 )
		{
			DelayedRespawnList.AddItem(Other);
		}

		Super.ScoreKill(Killer, Other);
	}

	function BroadcastRespawnMessage()
	{
		local int i;
		local GearPC PC;

		Super.BroadcastRespawnMessage();

		for (i = 0; i < DelayedRespawnList.length; i++)
		{
			PC = GearPC(DelayedRespawnList[i]);
			if (PC != None && (PC.IsDead() || PC.IsSpectating()))
			{
				PC.WaitForRespawn();
			}
		}
		DelayedRespawnList.length = 0;
	}
}

defaultproperties
{
	bScoreRoundWin=false
	GameReplicationInfoClass=class'GearBombDeliveryGRI'
}
