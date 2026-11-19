/**
 * GearGameKOTH_Base
 * Gear Game Info for KOTH Gametype
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearGameKOTH_Base extends GearGameRing_Base
	abstract
	native
	config(Game);

/** if set, prioritize wingman playerstarts when respawning players in the middle of the round */
var config bool bAllowWingmanStartsDuringRound;
/** game time in seconds that we start increasing the ring update rate (i.e. control and scoring) */
var config int UpdateTimeSpeedupStart;
/** amount to decrease update interval each second after UpdateTimeSpeedupStart */
var config float UpdateTimeSpeedupRate;
/** minimum value for AwardUpdateTime */
var config float MinAwardUpdateTime;
/** if >= 0, deplete command point resources even when ring is not controlled every this many seconds */
var config float ConstantResourceDecayInterval;
/** game time in seconds that the decay starts ramping up */
var config int ResourceDecaySpeedupStart;
/** amount to decrease decay interval each second after ResourceDecaySpeedupStart */
var config float ResourceDecaySpeedupRate;
/** minimum value for ConstantResourceDecayInterval */
var config float MinConstantResourceDecayInterval;

/** Game options in use recorded by stats */
function SetGameOptionsForStats()
{
	Super.SetGameOptionsForStats();

	// @STATS - KOTH RoundScore
	`RecordGameIntStat(ROUNDSCORE_KOTH, ResourceGoal);
}

/**
 * Set the game rules via the online game settings
 * @return - whether the game was able to set the rules via the gamesettings object
 */
function bool SetGameRules()
{
	local int IntValue;
	local GearVersusGameSettings MyGameSettings;

	MyGameSettings = GetGameSettingsObject();
	if (MyGameSettings != None)
	{
		// Resource Goal
		if (MyGameSettings.GetStringSettingValue(MyGameSettings.const.CONTEXT_ROUNDSCORE_KOTH, IntValue))
		{
			ResourceGoal = 50 + (IntValue * 30);
		}
		return Super.SetGameRules();
	}
	return FALSE;
}

/**
 * Whether this is a weapon spawner we should consider in this gametype
 */
function bool WeaponSpawnerIsUsable(GearWeaponPickupFactory Factory)
{
	return !Factory.bMP_ExcludeKOTH;
}

/**
 * Get the team index of the team who is most in control of the ring
 * Overloaded so we can enforce that no team is in control if a member of the other
 * team is in the ring
 *
 * @return - Returns the index of the team who is most in control of the command point
 */
function int CalculateBestTeamIndexForRingGame()
{
	local int TeamIdx;

	// Only look for a team in the nearby list if there is exactly 1 team in the ring
	if (NumTeamsInCircle == 1)
	{
		// Figure which team is in the circle and return that index
		for (TeamIdx = 0; TeamIdx < Teams.Length; TeamIdx++)
		{
			// If the nearby count of the team is more than 0, than this is the team to return
			if (NearbyCount[TeamIdx] > 0)
			{
				return TeamIdx;
			}
		}
	}
	return -1;
}

/** there are an equal number of players for each team (possibly zero) in the ring so handle the game logic associated with it */
function HandleNeutralRingRules()
{
	local bool bDoInstaClear;
	local int TeamIdx;
	local int Idx;

	bDoInstaClear = false;

	// A team has control
	if (CommandTeam != None)
	{
		// Loop through all players in the nearby PC list
		for (Idx = 0; Idx < NearbyPCs.length; Idx++)
		{
			// If the player is not on the command team he gets credit for the break
			TeamIdx = NearbyPCs[Idx].GetTeamNum();
			if (CommandTeam != Teams[TeamIdx])
			{
				// Mark the InstantClear flag
				bDoInstaClear = true;
				break;
			}
		}
	}

	// See if we need to insta clear the CP (other team broke the CP)
	if (bDoInstaClear)
	{
		SetCommandMeter(0);
	}
	// The commanding team left the ring unattended so drain it
	else if (CommandMeter < CommandMeterMax)
	{
		SetCommandMeter(FMax(CommandMeter-1, 0));
	}

	// If there is more than one team in the CP
	if (NumTeamsInCircle > 0)
	{
		if (LastCapturedByTeamIndex != -1)
		{
			// Score the break
			ScoreTeamBreak(TeamIdx);
			// Pulse the HUD
			PulseHUDPlayerCPIndicators(5, 0.2f);
			// Play sound for all to hear
			BroadcastSound(RingSound_CommandMeterBroken);
		}
		else if (bDoInstaClear)
		{
			// Pulse the HUD
			PulseHUDPlayerCPIndicators(5, 0.2f);
			// Play sound for all to hear
			BroadcastSound(RingSound_CommandMeterBroken);
		}
		// Clear the last captured index
		LastCapturedByTeamIndex = -1;
	}

	if (CommandTeam == None)
	{
		if (!IsTimerActive(nameof(DecayNeutralRingResources)))
		{
			SetNeutralRingDecayTimer();
		}
	}
	else
	{
		ClearTimer(nameof(DecayNeutralRingResources));
	}
}

function HandleCommandPointPossession()
{
	Super.HandleCommandPointPossession();

	if (CommandMeter < CommandMeterMax)
	{
		if (!IsTimerActive(nameof(DecayNeutralRingResources)))
		{
			SetNeutralRingDecayTimer();
		}
	}
	else
	{
		ClearTimer(nameof(DecayNeutralRingResources));
	}
}

/** sets timer for DecayNeutralRingResources based on the game options and current round time */
final function SetNeutralRingDecayTimer()
{
	if (ConstantResourceDecayInterval > 0.0)
	{
		SetTimer(FMax(MinConstantResourceDecayInterval, ConstantResourceDecayInterval - ResourceDecaySpeedupRate * Max(0, (bInfiniteRoundDuration ? GearGRI.RoundTime : GearGRI.RoundEndTime) - ResourceDecaySpeedupStart)), false, nameof(DecayNeutralRingResources));
	}
}

/** reduce ring resources if the ring is not fully controlled by a team */
function DecayNeutralRingResources()
{
	if (CommandTeam == None || CommandMeter < CommandMeterMax)
	{
		SetCommandPointResources(CommandPointResources - 1);
		SetNeutralRingDecayTimer();
	}
}

function UpdateRingGame()
{
	Super.UpdateRingGame();

	// increase scoring and control rate if necessary
	if (UpdateTimeSpeedupStart > 0 && (bInfiniteRoundDuration ? GearGRI.RoundTime : GearGRI.RoundEndTime) > UpdateTimeSpeedupStart)
	{
		SetTimer(FMax(MinAwardUpdateTime, AwardUpdateTime - UpdateTimeSpeedupRate * Max(0, (bInfiniteRoundDuration ? GearGRI.RoundTime : GearGRI.RoundEndTime) - UpdateTimeSpeedupStart)), false, nameof(UpdateRingGame));
	}
}

state MatchInProgress
{
	event BeginState(name PreviousStateName)
	{
		Super.BeginState(PreviousStateName);

		SetNeutralRingDecayTimer();
	}

	event EndState(name NextStateName)
	{
		Super.EndState(NextStateName);

		ClearTimer(nameof(DecayNeutralRingResources));
	}

	function Timer()
	{
		Super.Timer();

		if ((bInfiniteRoundDuration ? GearGRI.RoundTime : GearGRI.RoundEndTime) > Min(UpdateTimeSpeedupStart, ResourceDecaySpeedupStart))
		{
			SendToOvertime();
		}
	}

	// don't try to cycle because we aren't using team specific spawn areas
	function CycleTeamPlayerStarts()
	{
		if (!bAllowWingmanStartsDuringRound)
		{
			Super.CycleTeamPlayerStarts();
		}
	}
	function bool SpawnPointsAreEncroached(bool bTestCycle)
	{
		if (bAllowWingmanStartsDuringRound)
		{
			return false;
		}
		else
		{
			return Super.SpawnPointsAreEncroached(bTestCycle);
		}
	}

	function float RatePlayerStart(PlayerStart P, byte Team, Controller Player)
	{
		local float Score, NextDist;
		local Controller OtherPlayer;

		if (!bAllowWingmanStartsDuringRound)
		{
			return Global.RatePlayerStart(P, Team, Player);
		}

		if (P == None || !P.bEnabled || P.PhysicsVolume.bWaterVolume || !P.IsA('GearTeamPlayerStart'))
		{
			return -10000000;
		}

		//assess candidate
		if (P.bPrimaryStart && P.IsA('GearTeamPlayerStart_Wingman'))
		{
			Score = 10000000;
		}
		else
		{
			Score = 9000000;
		}

		if (bFixedPlayerStart)
		{
			return Score;
		}

		// avoid spawning too close to control point
		if (VSize(P.Location - CommandPoint.Location) < 1500.0)
		{
			return 1;
		}

		Score += 100.0 * FRand();

		foreach WorldInfo.AllControllers(class'Controller', OtherPlayer)
		{
			if ( OtherPlayer.bIsPlayer && (OtherPlayer.Pawn != None) )
			{
				NextDist = VSize(OtherPlayer.Pawn.Location - P.Location);
				if ( VSize2D(OtherPlayer.Pawn.Location - P.Location) < 2.0 * OtherPlayer.Pawn.CylinderComponent.CollisionRadius &&
					Abs(OtherPlayer.Pawn.Location.Z - P.Location.Z) < 2.0 * OtherPlayer.Pawn.CylinderComponent.CollisionHeight )
				{
					Score -= (1000000.0 - NextDist);
				}
				else if (NextDist < 256.0 && OtherPlayer.GetTeamNum() == Team)
				{
					Score += 10000.0;
				}
				else if (NextDist < 3000.0 && OtherPlayer.GetTeamNum() != Team)
				{
					if (FastTrace(P.Location, OtherPlayer.Pawn.Location))
					{
						Score -= (NextDist < 1000.0) ? (Score -= 50000.0 - NextDist) : (10000.0 - NextDist);
					}
					else
					{
						Score -= 2000.0 - NextDist;
					}
				}
			}
		}
		return FMax(Score, 5);
	}
}

defaultproperties
{
	bAllowRecapPoints=FALSE
	bNearbyEnemiesShouldWipeProgress=TRUE
	OnlineStatsWriteClass=class'GearLeaderboardWriteKoth'
	OnlineStatsWriteClassPlayer=class'GearLeaderboardWriteKothPlayer'
}
