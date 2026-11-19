/**
 * GearGameRing_Base
 * Gear Game Info for gametypes which use a resource location (ring) which needs to be aquired
 * for accumulating points (Annex, KOTH)
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearGameRing_Base extends GearGameMP_Base
	abstract
	native
	config(Game);

`include(GearPlayerPersistentDataConstants.uci)

/************************************************************************/
/* Struct, consts, enums, etc.                                          */
/************************************************************************/

struct native RingMapInfo
{
	/** Name of map this item gives info for */
	var() String		MapName;
	/** List of pickup classes to use for the map */
	var() array<Name>	PickupList;
	/** List of pickup classes to avoid first */
	var() array<Name>	AvoidFirstList;
};

/** Whether to allow rewards for capping a command point even though the same team is capping who previously had control */
var const bool bAllowRecapPoints;
/** Whether to wipe the progress of the command meter if an enemy is in the ring */
var const bool bNearbyEnemiesShouldWipeProgress;

/************************************************************************/
/* Member variables                                                     */
/************************************************************************/

/// TIMER VARIABLES ///
/** Amount of time between Award calculations */
var float AwardUpdateTime;

/// COMMAND POINT VARIABLES ///
/** List of super-weapon pickup factories */
var transient array<GearWeaponPickupFactory> FactoryList;
/** List of pickup locations to avoid selecting first */
var transient array<GearWeaponPickupFactory> AvoidFirstList;
/** List of used factories */
var transient array<GearWeaponPickupFactory> UsedList;
/** Current Command Point */
var transient GearWeaponPickupFactory CommandPoint;
/** Particle effect at the CP location */
var transient SpawnedGearEmitter CommandPointEffect;
/** Class of the CommandPointEffect */
var class<SpawnedGearEmitter> CommandPointEffectClass;
/** Currently controlling team */
var transient GearTeamInfo CommandTeam;
/** Command point control meter */
var transient float CommandMeter;
/** Max value for command meter (When CommandMeter is maxed == total control and team gets points) */
var float CommandMeterMax;
/** Max distance player can be from CP get points for team */
var float MaxPointDist, MaxPointDistZ;
/** Team index that last captured the CP */
var transient int LastCapturedByTeamIndex;

/// SCORING/OTHER VARIABLES ///
/** Number of points given to team each max controlled tick - depletes CP resources */
var config int NumAwardPoints;
/** Amount of resource points left in the CP */
var config int CommandPointResources;
/** Total resource points needed to win round */
var config int ResourceGoal;
/** if nonzero and this much time passes with no team gaining full control of the command point, it moves to a different location */
var config float CommandPointStalemateTime;

/** Array that keeps track of how many players on each team are in the ring */
var array<int> NearbyCount;
/** Array of the controllers of the players who are in the ring */
var transient array<Controller> NearbyPCs;
/** Number of teams who are currently in the circle */
var transient int NumTeamsInCircle;
/** The number of players that will count toward a teams' score (num players near ring - num enemies near ring) */
var array<int> SumTeamScore;


/// SOUND VARIABLES ///
/** Played when CP changes location */
var SoundCue		RingSound_CommandPointChanged;
/** Played when a new team starts to gain control */
var SoundCue		RingSound_CommandTeamChanged;
/** Played when CT control starts giving them points */
var SoundCue		RingSound_CommandMeterMaxed;
/** Played when max control has been challenged by other team */
var SoundCue		RingSound_CommandMeterBroken;

/** Number of points a player will receive for every tick of CP acquisition when in the CP area */
var() config int	PointsPerCPTick;
/** Number of points a player will receive if in the CP area when it's capped */
var() config int	PointsPerCap;
/** Number of points a player will receive if in the CP area when a cap is broke */
var() config int	PointsPerBreak;
/** Number of points that will be distributed to players in a KOTH ring when a point is earned */
var() config int	TeamPointsPerKOTHTick;

/** List of players to join the game while in progress */
var array<PlayerController>	JoinInProgressList;
/** List of configurable map data used by command point logic */
var() config array<RingMapInfo>	InfoList;


/************************************************************************/
/* Script functions                                                     */
/************************************************************************/

/**
 * Overloaded to allow join in progress
 */
event PlayerController Login(string Portal, string Options, const UniqueNetId UniqueId, out string ErrorMessage)
{
	local PlayerController NewPlayer;
	local GearPC PC;

	// Call the super class
	NewPlayer = Super.Login(Portal, Options, UniqueId, ErrorMessage);

	if (NewPlayer != None)
	{
		// Add the player to the join in progress list if a valid player controller exists after the game has begun
		if (GearGRI.GameStatus == GS_RoundInProgress)
		{
			JoinInProgressList[JoinInProgressList.length] = NewPlayer;
		}
		else
		{
			// Set the newly created player to the neutral team position.
			PC = GearPC(NewPlayer);
			if (PC != None &&
				PC.bDedicatedServerSpectator)
			{
				ChangeTeam(PC, 255, false);
			}
		}
	}
	return NewPlayer;
}

/**
 * Initializes the game settings from the URL
 */
event InitGame(string Options, out string ErrorMessage)
{
	Super.InitGame(Options, ErrorMessage);

	// Parse the round score off of the URL
	if ( HasOption(Options,"RoundScore") )
	{
		ResourceGoal = int(ParseOption(Options,"RoundScore"));
	}

	// Clear the last team to capture a ring
	LastCapturedByTeamIndex = -1;
}

/**
 * Need to set some ring specific values
 */
function InitGameReplicationInfo()
{
	Super.InitGameReplicationInfo();
	GearGRI_Annex(GearGRI).AnnexResourceGoal = ResourceGoal;
}

/** Start match overridden to clear award counters */
function StartMatch()
{
	local int i;
	local GearMPPRI MPPRI;

	for (i=0;i<WorldInfo.GRI.PRIArray.Length;i++)
	{
		MPPRI = GearMPPRI(WorldInfo.GRI.PRIArray[i]);
		if (MPPRI != None)
		{
			MPPRI.NumRingBreaksThisRound = 0;
			MPPRI.NumRingCapturesThisRound = 0;
			MPPRI.NumKillsInRingThisRound = 0;
		}
	}

	Super.StartMatch();
}

/**
 * Team always has respawns
 */
function bool TeamHasRespawn(int TeamIdx)
{
	return TRUE;
}

/**
 * Whether this is a weapon spawner we should consider in this gametype
 */
function bool WeaponSpawnerIsUsable(GearWeaponPickupFactory Factory);

/**
 * Pick a super weapon pickup factory to be the command point
 */
exec function SelectCommandPoint(optional bool bInitialCP)
{
	local GearWeaponPickupFactory Factory;
	local int Idx, InfoIdx, i, j;
	local array<int> List;
	local array<GearTeamPlayerStart> Starts;
	local float Diff, BestDiff, Dist, LargestDist, SmallestDist;
	local GearTeamPlayerStart P;

	// If factory list is exhausted and we've used some
	if (FactoryList.Length == 0 &&
		UsedList.Length > 0)
	{
		// Move all the used back into the main list for reuse
		while (UsedList.Length > 0)
		{
			FactoryList[FactoryList.Length] = UsedList[0];
			UsedList.Remove(0, 1);
		}
	}

	// If factory list is empty
	if (FactoryList.Length == 0)
	{
		// Try to find current map in map info list
		InfoIdx = -1;
		for (Idx = 0; Idx < InfoList.length; Idx++)
		{
			if (InfoList[Idx].MapName ~= GetMapFilename())
			{
				InfoIdx = Idx;
				break;
			}
		}

		// If we found the map (and it has a valid list of pickup classes)
		if (InfoIdx >= 0 && InfoList[InfoIdx].PickupList.Length > 0)
		{
			// Loop through each factory
			foreach DynamicActors(class'GearWeaponPickupFactory', Factory)
			{
				// Make sure the factory is usable by this gametype
				if (WeaponSpawnerIsUsable(Factory))
				{
					// Check each pickup class in the map's list
					for (Idx = 0; Idx < InfoList[InfoIdx].PickupList.Length; Idx++)
					{
						// If factory pickup class matches one in the map info
						if (Factory.Name == InfoList[InfoIdx].PickupList[Idx])
						{
							// Add the factory to valid list of CP locations
							FactoryList[FactoryList.Length] = Factory;
							break;
						}
					}

					// Make a list of factories to avoid picking at the start of a round
					for (Idx = 0; Idx < InfoList[InfoIdx].AvoidFirstList.Length; Idx++)
					{
						if (Factory.Name == InfoList[InfoIdx].AvoidFirstList[Idx])
						{
							AvoidFirstList[AvoidFirstList.Length] = Factory;
						}
					}
				}
			}
		}

		// If no valid CPs were found through info list
		if (FactoryList.Length == 0)
		{
			// Build the list (only accept super weapon pickups)
			foreach DynamicActors(class'GearWeaponPickupFactory', Factory)
			{
				// Make sure the factory is usable by this gametype
				if (WeaponSpawnerIsUsable(Factory))
				{
					// Add the factory to valid list of CP locations
					FactoryList[FactoryList.Length] = Factory;
				}
			}
		}
	}

	// If factories exist
	if (FactoryList.Length > 0)
	{
		// Build a list of available ones (exclude the one currently selected)
		for (Idx = 0; Idx < FactoryList.Length; Idx++)
		{
			// If factory is not current CP AND
			// not selecting the first CP or don't need to avoid this factory
			if (FactoryList[Idx] != CommandPoint &&
				(CommandPoint != None || AvoidFirstList.Find(FactoryList[Idx]) < 0))
			{
				// Add it to the list to choose from
				List[List.Length] = Idx;
			}
		}

		if (bInitialCP)
		{
			// put initial command point of the round in the center every time
			foreach WorldInfo.AllNavigationPoints(class'GearTeamPlayerStart', P)
			{
				if (P.TeamIndex < Teams.length && P.Class == GearPlayerStartClass)
				{
					Starts[P.TeamIndex] = P;
				}
			}
			BestDiff = 10000000.0;
			for (i = 0; i < List.length; i++)
			{
				LargestDist = 0.0;
				SmallestDist = 10000000.0;
				for (j = 0; j < Starts.length; j++)
				{
					Dist = VSize(FactoryList[List[i]].Location - Starts[j].Location);
					LargestDist = FMax(LargestDist, Dist);
					SmallestDist = FMin(SmallestDist, Dist);
				}
				Diff = Abs(LargestDist - SmallestDist);
				if (Diff < BestDiff)
				{
					Idx = i;
					BestDiff = Diff;
				}
			}
		}
		else
		{
			// Select new CP randomly
			Idx = Rand(List.Length);
		}
		Factory = FactoryList[List[Idx]];
		if (Factory != None)
		{
			// Put new CP in the used list
			UsedList[UsedList.Length] = Factory;
			FactoryList.Remove(Idx, 1);
			// Set the new CP
			SetCommandPoint(Factory);
		}
	}
	else
	{
		`Warn( "No GearWeaponPickupFactory in this level, unable to select Command Point" );
	}
}

/**
 * Send a sound to all player controllers
 */
function BroadcastSound(SoundCue ASound)
{
	local PlayerController PC;

	foreach WorldInfo.AllControllers(class'PlayerController', PC)
	{
		PC.ClientPlaySound(ASound);
	}
}

/**
 * Send a warning to players about the end of the game coming
 *
 * @param TeamIndex - The team to potentially send the warning about
 */
function BroadcastEndGameWarning(int TeamIndex)
{
	local GearPC_MP PC;
	local bool bSendWarning;
	local int ScoreDiff;

	// Calculate how far away the team is from winning
	ScoreDiff = ResourceGoal - int(GearGRI.GameScore[TeamIndex]);

	// Send the warning if a team has 10 or less points remaining
	if (ScoreDiff <= 10 &&
		ScoreDiff >= 0)
	{
		bSendWarning = true;
	}
	// Send the warning if the team is in the 10-20 range points from winning
	else if (ScoreDiff <= 20 &&
		     ScoreDiff > 10)
	{
		// Only send the warning every other point (second)
		if (ScoreDiff % 2 == 0)
		{
			bSendWarning = true;
		}
	}

	// If we determined we need to send the warning do so
	if (bSendWarning)
	{
		// Loop through all controllers and send the warning
		foreach WorldInfo.AllControllers(class'GearPC_MP', PC)
		{
			// Send the warning
			PC.ClientEndOfGameWarning(ScoreDiff, TeamIndex);
		}
	}
}

/**
 * Set new command point and do any bookkeeping that needs to be done
 *
 * @param NewCP - The new command point to set to
 */
function SetCommandPoint(GearWeaponPickupFactory NewCP)
{
	local GearAI_TDM Bot;
	local AICmd_MoveToGoal_Mesh MoveCmd;

	// Interrupt any bots that were moving towards the old command point
	// so that if they were only doing so because it was the game objective, they'll re-evaluate their target
	if (CommandPoint != None)
	{
		// Loop through all bots
		foreach WorldInfo.AllControllers(class'GearAI_TDM', Bot)
		{
			// If they were moving to the old command point
			if (Bot.MoveGoal == CommandPoint)
			{
				// Grab the command and abort it
				MoveCmd = Bot.FindCommandOfClass(class'AICmd_MoveToGoal_Mesh');
				if (MoveCmd != None)
				{
					`AILog_Ext("Aborting move command to" @ CommandPoint @ "because it's no longer the command point",, Bot);
					Bot.AbortCommand(MoveCmd);
				}
			}
		}
	}

	// Set new command point
	CommandPoint = NewCP;
	if( CommandPoint != None )
	{
		// If we haven't spawned the ring, do so
		if (CommandPointEffect == None)
		{
			CommandPointEffect = Spawn( CommandPointEffectClass,,, CommandPoint.Location, CommandPoint.Rotation );
			CommandPointEffect.ParticleSystemComponent.ActivateSystem();
		}
		// Else just relocate it to the new position
		else
		{
			CommandPointEffect.SetLocation(CommandPoint.Location);
		}
	}

	// Reset resource count
	SetCommandPointResources(default.CommandPointResources);
	// Reset command meter
	SetCommandMeter(0.0f);
	// start stalemate countdown
	SetTimer(CommandPointStalemateTime, false, nameof(SelectCommandPoint));

	// Copy the command point to the GRI
	if (GearGRI != None)
	{
		GearGRI.CommandPoint = CommandPoint;
	}

	// Clear command team
	SetCommandTeam(None);

	// If there is a command point change play sound for all to hear
	if (CommandPoint != None && IsInState('MatchInProgress'))
	{
		BroadcastSound(RingSound_CommandPointChanged);
	}
}

/**
 * Set new command team and do any bookkeeping that is necessary
 *
 * @param NewCT - The team info of the team who is now in control of the command point
 */
function SetCommandTeam(GearTeamInfo NewCT)
{
	// Set new command team
	CommandTeam = NewCT;
	if (CommandTeam != None)
	{
		// Play sound for all to hear
		BroadcastSound(RingSound_CommandTeamChanged);
	}

	// Update CP effect with team color
	if (CommandPointEffect != None)
	{
		SetRingColor(GetCommandTeamColor());
	}

	// Set the new command team on the GRI
	if (GearGRI != None)
	{
		GearGRI.CPControlTeam = (CommandTeam == None) ? -1 : CommandTeam.TeamIndex;
	}
}

/**
 * Set amount of control the command team has over the command point
 *
 * @param Amt - Amount of control the team has on the command point
 */
function SetCommandMeter(float Amt)
{
	// Play sound for all to hear if going from not full control to full control
	if (CommandMeter < CommandMeterMax &&
		Amt >= CommandMeterMax)
	{
		BroadcastSound(RingSound_CommandMeterMaxed);
	}
	// Otherwise, see if we should play sound of command meter being broken
	else if(CommandMeter >= CommandMeterMax &&
		    Amt < CommandMeterMax &&
			Amt > 0)
	{
		BroadcastSound(RingSound_CommandMeterBroken);
	}

	// Set the meter
	CommandMeter = Amt;
	// Set the progression on the effect
	SetRingProgression(CommandMeter / CommandMeterMax);
	// Set the command point control percentage on the GRI
	GearGRI.CPControlPct = int(100.f * (CommandMeter / CommandMeterMax));
}

/**
 * Set the ring progression for capturing
 *
 * @param Progression - Value from 0.0f-1.0f representing how much control a team has
 */
function SetRingProgression(float Progression);

/**
 * Set the annex ring's color
 *
 * @param RingColor - The color the ring should draw
 */
function SetRingColor( Color RingColor );

/**
 * Set amount of resources left before the command point is dry
 *
 * @param Amt - The amount of resources the command point should give out total
 */
function SetCommandPointResources(int Amt)
{
	// Set both locally and on the GRI
	CommandPointResources = Amt;
	GearGRI_Annex(GearGRI).CPResourceLeft = Amt;
}

/**
 * Returns the Color (RGB) that the ring should be based on
 * the team and whether there even is a team in control
 */
function Color GetCommandTeamColor()
{
	// Neutral
	if (CommandTeam == None)
	{
		return MakeColor(80,80,70,255);
	}
	// COG
	else if (CommandTeam.TeamIndex == 0)
	{
		return MakeColor(0,90,120,255);
	}
	// Locust
	else
	{
		return MakeColor(140,0,0,255);
	}
}

/**
 * Handles switching to a new command point if the resource points have been depleted
 *
 * @return - Whether the command point changed or not
 */
function bool CheckResourcePoints()
{
	// If resources have been depleted
	if (CommandPointResources <= 0)
	{
		// Select a new command point
		SelectCommandPoint();
		return TRUE;
	}
	return FALSE;
}

/**
 * Calculate points to award the controlling team
 */
function UpdateRingGame()
{
	local bool bCPIsCurrentlyOwned;
	local int BestTeamIndex;

	// First wipe the variables associated with teams/players being near the ring
	NearbyCount.length = 0;
	NearbyPCs.length = 0;
	NumTeamsInCircle = 0;
	SumTeamScore.length = 0;

	// See if we need to perform an early out of this update or not
	if (HandleUpdateGameEarlyOut())
	{
		return;
	}

	// Update the variables associated with teams/players being near the ring
	UpdateTeamProximityVariables();

	// Get the team index of the team who is most in control of the ring
	BestTeamIndex = CalculateBestTeamIndexForRingGame();

	// If someone is in the ring
	if (BestTeamIndex >= 0)
	{
		// Determine if a team currently has control of the command point
		if (CommandTeam != None &&
			CommandMeter >= CommandMeterMax)
		{
			bCPIsCurrentlyOwned = true;
		}

		// There are an uneven number of players from each team in the ring so handle the game logic associated with it
		HandleOwnedRingRules(BestTeamIndex, bCPIsCurrentlyOwned);
	}
	else
	{
		// the same number of people from each team (possibly zero) are in the ring
		HandleNeutralRingRules();
	}

	// If there is a team with a claim (scoring and awarding)
	if (CommandTeam != None)
	{
		// Handle extremes of the command meter and how it effects the team in control (awarding points)
		HandleCommandPointPossession();
	}
}

/**
 * Determines whether the game update should perform an early out or not and handles
 * any necessary cleanup for the situation that caused it to early out
 *
 * @return - TRUE if we have to early out of the game update
 */
function bool HandleUpdateGameEarlyOut()
{
	// Can't award points if there is no command point
	if (CommandPoint == None ||
		GearGRI == None)
	{
		// Clear the command team and return
		SetCommandTeam(None);
		return TRUE;
	}

	// Check to see if we need to switch command points
	if (CheckResourcePoints())
	{
		// Bail since the command point switched
		return TRUE;
	}

	return FALSE;
}

/**
 * Update the variables associated with teams/players being near the ring
 */
function UpdateTeamProximityVariables()
{
	local int TeamIdx;
	local GearTeamInfo T;
	local GearPawn P;
	local int Idx;

	// Find all the PCs inside the ring
	NearbyCount.Length  = Teams.Length;
	// Loop through all teams
	for (TeamIdx = 0; TeamIdx < Teams.Length; TeamIdx++)
	{
		// Loop through all players on each team
		T = Teams[TeamIdx];
		for (Idx = 0; Idx < T.TeamMembers.Length; Idx++)
		{
			// See if this player is near the command point
			if (T.TeamMembers[Idx] != None)
			{
				P = GearPawn(T.TeamMembers[Idx].Pawn);
				if (IsNearCommandPoint(P))
				{
					// Increment how many players on the team are near
					NearbyCount[TeamIdx]++;
					// Keep track of the controllers nearby
					NearbyPCs[NearbyPCs.Length] = P.Controller;
				}
			}
		}

		// Keep track of how many teams are in the circle and who the last one was
		if (NearbyCount[TeamIdx] > 0)
		{
			NumTeamsInCircle++;
		}
	}

	// Go through each team and compute the ring advantage
	SumTeamScore.Length = Teams.Length;
	for (TeamIdx = 0; TeamIdx < SumTeamScore.Length; TeamIdx++)
	{
		// Base score is how many people this team has nearby
		SumTeamScore[TeamIdx] = NearbyCount[TeamIdx];

		// Subtract the count of enemies nearby
		for (Idx = 0; Idx < SumTeamScore.Length; Idx++)
		{
			if (TeamIdx != Idx)
			{
				SumTeamScore[TeamIdx] -= NearbyCount[Idx];
			}
		}
	}
}

/**
 * Get the team index of the team who is most in control of the ring
 *
 * @return - Returns the index of the team who is most in control of the command point
 */
function int CalculateBestTeamIndexForRingGame()
{
	local int BestTeamIndex;
	local int TeamIdx;

	// Default to neutral
	BestTeamIndex = -1;
	// Go through each team and pick the top score
	for (TeamIdx = 0; TeamIdx < SumTeamScore.Length; TeamIdx++)
	{
		// If this team has no positive claim skip to next team
		if (SumTeamScore[TeamIdx] <= 0)
		{
			continue;
		}
		// If there is not a best team yet or this one is better than the previous (score)
		if (BestTeamIndex < 0 ||
			SumTeamScore[TeamIdx] > SumTeamScore[BestTeamIndex])
		{
			BestTeamIndex = TeamIdx;
		}
	}

	return BestTeamIndex;
}

/**
 * Handle the game logic which deals with one team having an advantage in the ring
 *
 * @param BestTeamIndex - The team most in control of the ring
 * @param bCPIsCurrenltyOwned - Whether the command point was owned prior to this update or not
 */
function HandleOwnedRingRules(int BestTeamIndex, bool bCPIsCurrentlyOwned)
{
	// If there is not currenlty a team in command
	if (CommandTeam == None)
	{
		// Give the best team claim
		SetCommandTeam(Teams[BestTeamIndex]);
	}

	// If strongest team has the claim
	if (CommandTeam == Teams[BestTeamIndex])
	{
		// Increase their meter toward the max
		SetCommandMeter(FMin(CommandMeter + SumTeamScore[BestTeamIndex], CommandMeterMax));
		// See if we're still trying to cap
		if (!bCPIsCurrentlyOwned)
		{
			// See if this team just took the CP or not
			if (CommandMeter >= CommandMeterMax)
			{
				// If we are allowing recap points or the best team is not the last team to capture the command point
				if (!bAllowRecapPoints ||
					LastCapturedByTeamIndex != BestTeamIndex)
				{
					// Score cap points
					ScoreTeamCapture(BestTeamIndex);
					// Mark best team as the last who capped the command point
					LastCapturedByTeamIndex = BestTeamIndex;
				}
				// Pulse the HUD display
				PulseHUDPlayerCPIndicators( 2, 1.f );
			}
		}
	}
	// Otherwise, the strongest team is trying to take the claim
	else
	{
		// If we want to wipe the progress meter when enemies are in the ring, wipe it
		if (bNearbyEnemiesShouldWipeProgress)
		{
			SetCommandMeter(0);
		}
		// Decrease the meter
		else
		{
			// Decrease current teams meter toward 0 (take away control twice as fast)
			SetCommandMeter(FMax(CommandMeter - (SumTeamScore[BestTeamIndex] * 2), 0));
		}

		// See if this team just stopped total control of the CP
		if (bCPIsCurrentlyOwned &&
			CommandMeter < CommandMeterMax)
		{
			// Score break
			ScoreTeamBreak(BestTeamIndex);
			// Pulse the HUD
			PulseHUDPlayerCPIndicators(5, 0.2f);
			BroadcastSound(RingSound_CommandMeterBroken);
		}
	}
}

/** there are an equal number of players for each team (possibly zero) in the ring so handle the game logic associated with it */
function HandleNeutralRingRules()
{
	// If there is a controlling team and they haven't gained complete control
	if (CommandTeam != None &&
		CommandMeter < CommandMeterMax)
	{
		// Bleed off control toward 0
		SetCommandMeter(FMax(CommandMeter - 1, 0));
	}
}

/**
 * Handle extremes of the command meter and how it effects the team in control (awarding points)
 */
function HandleCommandPointPossession()
{
	local int Pts, NumPointsActuallyAdded;

	// If meter is neutral
	if (CommandMeter <= 0.f)
	{
		// Clear command team
		SetCommandTeam(None);
	}
	// Otherwise, if meter is maxed, award points to the team
	else if (CommandMeter >= CommandMeterMax)
	{
		// reset stalemate timer whenever any team has full control
		SetTimer(CommandPointStalemateTime, false, nameof(SelectCommandPoint));
		// Get number of points to give to the team
		Pts = NumAwardPoints;
		// Don't allow excess drain of CP resources)
		if (CommandPointResources > 0)
		{
			Pts = Min(NumAwardPoints, CommandPointResources);
			// Deplete CP resources
			SetCommandPointResources(CommandPointResources - Pts);
		}

		// See how many points we can actually give out (takes reaching the goal score into consideration)
		NumPointsActuallyAdded = FMin(GearGRI.GameScore[CommandTeam.TeamIndex] + Pts, ResourceGoal) - GearGRI.GameScore[CommandTeam.TeamIndex];
		// Give the points to the command team
		GearGRI.GameScore[CommandTeam.TeamIndex] += NumPointsActuallyAdded;

		// Potentially warn players of the end of the game due to this last point adjustment
		BroadcastEndGameWarning(CommandTeam.TeamIndex);

		// Allow subclasses to handle special scoring for different gametypes here
		HandleSpecialGametypeScoring(NumPointsActuallyAdded);
	}
}

/**
 * Allow subclasses to handle special scoring for different gametypes here
 *
 * @param NumPointsAdded - The number of resource points a team actually earned this update
 */
function HandleSpecialGametypeScoring(int NumPointsAdded);

/**
 * Give a capture bonus to all nearby players on the team and give accumulation points for those who helped cap it
 *
 * @param ControlTeamId - The team in control of the command point
 */
function ScoreTeamCapture(int ControlTeamId)
{
	local int Idx;
	local GearPC GPC;
	local GearMPPRI MPPRI;

	// Loop through all players near the ring
	for (Idx = 0; Idx < NearbyPCs.Length; Idx++)
	{
		// See if they're on the controlling team
		if (NearbyPCs[Idx].PlayerReplicationInfo != None)
		{
			MPPRI = GearMPPRI(NearbyPCs[Idx].PlayerReplicationInfo);
			if (MPPRI != None && MPPRI.Team.TeamIndex == ControlTeamId)
			{
				// @STATS - Give them capping points
				MPPRI.ScoreGameSpecific1(`StatId(SCORE_RING_CAPS),PointsPerCap);
				MPPRI.NumRingCapturesThisRound++;

				GPC = GearPC(MPPRI.Owner);
				if (GPC != None && MPPRI.NumRingCapturesThisRound == 3)
				{
					// @AWARD - Ring Capture
					GPC.NotifyEarnedAward('Ringmaster');
				}
			}
		}
	}
}

/**
 * Give a break bonus to all nearby players on the team
 *
 * @param BreakTeamId - The team who is responsible for breaking the other team's cap
 */
function ScoreTeamBreak(int BreakTeamId)
{
	local int Idx;
	local GearPC GPC;
	local GearMPPRI MPPRI;

	// Loop through all players near the ring
	for (Idx = 0; Idx < NearbyPCs.Length; Idx++)
	{
		// See if they're on the team who broke the cap
		if (NearbyPCs[Idx].PlayerReplicationInfo != None)
		{
			MPPRI = GearMPPRI(NearbyPCs[Idx].PlayerReplicationInfo);
			if (MPPRI != None && MPPRI.Team.TeamIndex == BreakTeamId)
			{
				// @STATS - Give them breaking points
				MPPRI.ScoreGameSpecific2(`StatId(SCORE_RING_BREAKS),PointsPerBreak);
				MPPRI.NumRingBreaksThisRound++;

				GPC = GearPC(MPPRI.Owner);
				if (GPC != None && MPPRI.NumRingBreaksThisRound == 3)
				{
					// @AWARD - Ring Break
					GearPC(MPPRI.Owner).NotifyEarnedAward('RingBreak');
				}
			}
		}
	}
}

/**
 * Have players pulse their command point indicators
 *
 * @param NumPulses - The number of times the indicator should pulse
 * @param LengthOfPulse - Length in seconds of how long a pulse should last
 */
function PulseHUDPlayerCPIndicators(int NumPulses, float LengthOfPulse = 1.f)
{
	local GearPC_MP PC;

	foreach WorldInfo.AllControllers(class'GearPC_MP', PC)
	{
		PC.ClientSetCommandPointIndicatorGlow(NumPulses, LengthOfPulse);
	}
}

/**
 * Determines if a pawn is valid and close enough to the command point to get points, break, cap etc
 *
 *@param P - The pawn in question for being close enough to the ring
 */
function bool IsNearCommandPoint(GearPawn P)
{
	local float DistSq, DistZ;

	// Make sure the command point is valid and that the pawn is valid and alive
	if (CommandPoint != None &&
		P != None &&
		(P.Health > 0 || P.IsDBNO()))
	{
		// Gather both the horizontal and vertical distance the pawn is from the ring
		DistSq = VSizeSq2D(P.Location - CommandPoint.Location);
		DistZ = Abs(P.Location.Z-CommandPoint.Location.Z);

		// See if the pawn is close enough to the ring
		if (DistSq <= MaxPointDist*MaxPointDist &&
			DistZ <= MaxPointDistZ)
		{
			return TRUE;
		}
	}
	return FALSE;
}

/**
 * Hook for AI to get the objective point for the gametype
 */
function Actor GetObjectivePointForAI(GearAI AI)
{
	// Always take and guard command point
	return CommandPoint;
}

/**
 * Hook for AI to know if it needs to stand in the ring for control or not
 */
function bool MustStandOnObjective(GearAI AI)
{
	// If this AI's team is NOT in complete control of the command point
	return (CommandTeam != AI.PlayerReplicationInfo.Team ||
			CommandMeter < CommandMeterMax);
}

/**
 * Hook for AI to know how aggressive it should be
 */
function SetAICombatMoodFor(GearAI AI)
{
	local ECombatMood NewCombatMood;

	// If someone else owns it, attack it
	if (CommandTeam != AI.PlayerReplicationInfo.Team)
	{
		NewCombatMood = AICM_Aggressive;
	}
	else
	{
		NewCombatMood = AICM_Normal;
	}

	// Make the combat mood change if one occured
	if (AI.CombatMood != NewCombatMood)
	{
		AI.SetCombatMood(NewCombatMood);
	}
}

/**
 * Hook for AI to adjust who it's enemy should be
 */
function AdjustEnemyRating(GearAI AI, out float out_Rating, Pawn EnemyPawn)
{
	local GearPawn P;

	// If it's enemy is in the ring, increase the rating
	P = GearPawn(EnemyPawn);
	if (P != None &&
		IsNearCommandPoint(P))
	{
		out_Rating += 0.5;
	}
}

/************************************************************************/
/* MatchInProgress State Begin                                          */
/************************************************************************/
state MatchInProgress
{
	/**
	 * Overloaded to allow spawning and to clear death variables
	 */
	function RestartPlayer(Controller NewPlayer)
	{
		GearPRI(NewPlayer.PlayerReplicationInfo).ClearDeathVariables();
		Super(GearGame).RestartPlayer(NewPlayer);
	}

	/** Overloaded to initialize variables at the beginning of each round */
	event BeginState(name PreviousStateName)
	{
		local int Idx;

		Super.BeginState(PreviousStateName);

		// Clear the teams' points
		for (Idx = 0; Idx < NumTeams; Idx++)
		{
			GearGRI.GameScore[Idx] = 0;
		}
		// Select the first Command Point
		SelectCommandPoint(true);
		// Set timer to pick a new one every update cycle
		SetTimer(AwardUpdateTime, TRUE, nameof(UpdateRingGame));
		// Reset the last captured team
		LastCapturedByTeamIndex = -1;
	}

	/** Overloaded to cleanup some variables and do some record keeping at the end of each round */
	event EndState(name NextStateName)
	{
		// Stop timer updates
		ClearTimer(nameof(UpdateRingGame));
		// Clear the command point at the end of each round
		SetCommandPoint( None );
		// Destroy and clear the ring effect
		if (CommandPointEffect != None)
		{
			CommandPointEffect.Destroy();
			CommandPointEffect = None;
		}

		// Clear this list just in case
		JoinInProgressList.length = 0;

		Super.EndState(NextStateName);
	}

	function ScoreKill(Controller Killer, Controller Other)
	{
		local Controller C;
		local GearPC PC;
		local GearMPPRI MPPRI;
		Super.ScoreKill(Killer, Other);

		if (CommandTeam != None && CommandMeter >= CommandMeterMax)
		{
			foreach NearbyPCs(C)
			{
				if (Killer == C && C.PlayerReplicationInfo != None && C.PlayerReplicationInfo.Team == CommandTeam)
				{
					PC = GearPC(C);
					if (PC != None)
					{
						MPPRI = GearMPPRI(PC.PlayerReplicationInfo);
						if (MPPRI != None)
						{
							MPPRI.NumKillsInRingThisRound++;
							if (MPPRI.NumKillsInRingThisRound == 5)
							{
								// @AWARD - Ringmaster (5 kills defending ring)
								PC.NotifyEarnedAward('RingKing'); 
							}
						}
					}
					break;
				}
			}
		}
	}

	/**
	 * Overloaded to handle join in progress
	 */
	event Tick( float DeltaTime )
	{
		local int Idx;

		// If there are any players waiting to join in progress, allow them to join
		for (Idx = 0; Idx < JoinInProgressList.length; Idx++)
		{
			if (JoinInProgressList[Idx] != None &&
				JoinInProgressList[Idx].IsInState('PlayerWaiting'))
			{
				GearPC(JoinInProgressList[Idx]).TransitionFromDeadState();
				JoinInProgressList.Remove(Idx--, 1);
			}
		}
	}

	/**
	 * Overloaded so we can take the team with the most resource points as the winner
	 */
	function bool HandleRoundTimerExpired()
	{
		local int WinningTeamIdx, Idx;
		local float HighScore;

		WinningTeamIdx = -1;
		HighScore = -1;

		// See who the winner was and what their score was
		for (Idx = 0; Idx < Teams.length; Idx++)
		{
			if (GearGRI.GameScore[Idx] > HighScore)
			{
				HighScore = GearGRI.GameScore[Idx];
				WinningTeamIdx = Idx;
			}
		}

		// If there was actually a winner handle it
		if (WinningTeamIdx >= 0)
		{
			return HandleTeamWin(WinningTeamIdx);
		}

		// Else let the super class deal with it
		return super.HandleRoundTimerExpired();
	}

	/**
	 * Overloaded to check to see if one team has reached the total goal
	 */
	function bool CheckEndMatch(optional Controller Killed)
	{
		local bool bResult;
		local int TeamIdx;
		local int WinningTeamIdx, NumNonZeroScoreTeams;
		local Controller C;

		// Let super class have first shot
		bResult = Super.CheckEndMatch(Killed);

		// If the match hasn't been stopped see if a team has reached the goal
		if (!bResult)
		{
			WinningTeamIdx = -1;
			// Loop through each team and see if they reached the goal
			for (TeamIdx = 0; TeamIdx < Teams.Length; TeamIdx++)
			{
				if (GearGRI.GameScore[TeamIdx] > 0)
				{
					NumNonZeroScoreTeams++;
					if (GearGRI.GameScore[TeamIdx] >= ResourceGoal)
					{
						WinningTeamIdx = TeamIdx;
					}
				}
			}

			if (WinningTeamIdx != -1)
			{
				if (NumNonZeroScoreTeams == 1)
				{
					// @AWARD - RING SKUNK
					foreach Teams[WinningTeamIdx].TeamMembers(C)
					{
						if (GearPC(C) != None)
						{
							GearPC(C).NotifyEarnedAward('RingSkunk');
						}
					}
				}

				// This team reached the goal so handle the win
				return HandleTeamWin(WinningTeamIdx);
			}
		}
		return bResult;
	}

	/**
	 * Make the playerstarts shuffle before broadcasting the respawn message
	 */
	function BroadcastRespawnMessage()
	{
		if ( GetTotalRespawningPlayers() > 0 &&
			(WorldInfo.TimeSeconds - LastTeamPlayerStartCycleTime >= MaxTeamStartCycleInterval || SpawnPointsAreEncroached(false)) )
		{
			CycleTeamPlayerStarts();
		}
		Super.BroadcastRespawnMessage();
	}
}
/************************************************************************/
/* MatchInProgress State End                                            */
/************************************************************************/

/*
 *   Poll of any game stats to record
 * Ring games record the position of the ring at all times
 */
function GameEventsPoll()
{
	if (CommandPoint != None)
	{
		// @STATS - record ring position
		`RecordGamePositionStat(RING_POSITION, CommandPoint.Location, CommandPointResources);
	}

	Super.GameEventsPoll();
}

defaultproperties
{
	AwardUpdateTime=1.f
	CommandMeterMax=8
	MaxPointDist=256.f
	MaxPointDistZ=128.f
	bAllowRecapPoints=TRUE
	OnlineStatsWriteClass=class'GearLeaderboardWriteKOTH'  //annex is removed, only KOTH remains
	OnlineStatsWriteClassPlayer=class'GearLeaderboardWriteKOTHPlayer'
}
