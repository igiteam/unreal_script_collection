////////////////////////////////////////////////////////////////////////////////
// SASSSquadGameInfo.uc
//
// SAS Sabre Squad game info
////////////////////////////////////////////////////////////////////////////////

class SASSSquadGameInfo extends SASMPGameInfoCommon
	config(user);

var bool mbFragLimitReached;

var PlayerReplicationInfo KillerTemp1, Killedtemp1;
var bool	mbMatchStartedWithSinglePlayer;


function StartMatch()
{
	local int			playerCount;
	local Controller	C;

	Super.StartMatch();

	mbMatchStartedWithSinglePlayer = true;
	for ( C = Level.ControllerList; C != None; C = C.nextController )
	{
		if ( C.IsA( 'PlayerController' ) )
		{
			if ( C.Pawn != None && C.Pawn.Health > 0 )
			{
				playerCount++;
				if ( playerCount > 1 )
				{
					mbMatchStartedWithSinglePlayer = false;
					break;
				}
			}
		}
	}
}

// Increases the restart wait time to accomodate the increase in animation time for saber squad.
event IncWaitRestartTime()
{
	RestartWait	= 10.0 + SASGRI( GameReplicationInfo ).mSabreSquadNumTeamSwaps * 4.0;
}

function ScoreKill(Controller Killer, Controller Killed)
{
	local SASPRI	killed_ri, 
					killer_ri;

	// give score, and decide who'll be terrorist and who'll be SAS next go.
	killed_ri = SASPRI( Killed.PlayerReplicationInfo );
	killer_ri = SASPRI( Killer.PlayerReplicationInfo );
	killed_ri.mSSquadPromoteDemoteStatus = PDSTATUS_None;
	killer_ri.mSSquadPromoteDemoteStatus = PDSTATUS_None;

	killed_ri.bOutOfLives = true;
	
	if (killed_ri.Team != None && killer_ri.Team != None)
	{
		if (killed_ri.Team == killer_ri.Team)
		{
			// team kill.
			killer_ri.ScoreDaggers -= 2;
			killer_ri.TeamIndexForNextGame = 1; // demoted to terrorist

			if ( killer_ri.Team.TeamIndex == 0 )
			{
				// Demote a SAS which team kills.
				killer_ri.mSSquadPromoteDemoteStatus = PDSTATUS_DemotedTeamKiller;
			}
			
			// team kill message
			if ( killed_ri == killer_ri )
			{
				// Suicide
				BroadcastLocalized(self, class'SASMPMessage', 2, killer_ri, killed_ri);
			}
			else
			{
				// Normal team kill.
				BroadcastLocalized(self, class'SASMPMessage', 0, killer_ri, killed_ri);
			}
		}
		else
		{
			// kill of opposing teams.
			if (killed_ri.Team.TeamIndex == 0)
			{
				// SAS was killed by terrorist.
				
				// if this is the first sas killed by this terrorist, they swap teams.
							
				// we test if he's been promoted yet.
				if (killer_ri.TeamIndexForNextGame != 0)
				{
					// no, so promote
					killer_ri.TeamIndexForNextGame = 0;
					killer_ri.mSSquadPromoteDemoteStatus  = PDSTATUS_PromotedKiller;
					killer_ri.mSSquadPromoteDemoteOtherPRI = killed_ri;
					
					// demote
					killed_ri.TeamIndexForNextGame = 1;
					killed_ri.mSSquadPromoteDemoteStatus  = PDSTATUS_DemotedKilled;
					killed_ri.mSSquadPromoteDemoteOtherPRI = killer_ri;
					SASGRI( GameReplicationInfo ).mSabreSquadNumTeamSwaps++;
					
					BroadcastLocalized(self, class'SASMPMessage', 1, killer_ri, killed_ri);
					IncWaitRestartTime();
				}
			}
			else
			{
				// the killed dude was a terrorist. No team changes, but scoring.
				
				// the sas gets a dagger
				killer_ri.ScoreDaggers++;
			}
			
			// and normal kill score.
			killer_ri.ScoreKills++;
		}
	}
//// change everyone's team as dictated by their performance
//	for ( P = Level.ControllerList; P != None; P = P.NextController )
//	{
//		Player = PlayerController ( P );
//		if ( Player != None )
//		{
//			// Let's change the player to the correct team based on what happened this turn.
//			if ((Player.PlayerReplicationInfo.TeamIndexForNextGame == 0 || Player.PlayerReplicationInfo.TeamIndexForNextGame == 1) &&
//				Player.PlayerReplicationInfo.TeamIndexForNextGame != Player.PlayerReplicationInfo.Team.TeamIndex)
//			{
//				// This player has a new team to change to.
//				ChangeTeam(Player, Player.PlayerReplicationInfo.TeamIndexForNextGame, true);
//			}
//		}
//	}	
}

State MatchInProgress
{
	// Detect for frag count being reached.
	function ScoreKill(Controller Killer, Controller Killed)
	{
		Global.ScoreKill( Killer, Killed );

		// Check for mission end on kill.
		CheckScoreKillMissionEnd( Killer, Killed );
	}


	function Timer()
	{
		Super.Timer();

		// Check for last man standing.
		// But only if match didnt start with single player.
		if ( !mbMatchStartedWithSinglePlayer )
		{
			CheckTeamWin();
		}
	}
}

// Check for last man standing and trigger end game.
function CheckTeamWin()
{
	local Controller			P;
	local SASPlayerController	Player;
	local PlayerReplicationInfo Team0PRI,
								Team1PRI;
	local int					num_left_team0;
	local int					num_left_team1;

	for ( P = Level.ControllerList; P != None; P = P.nextController )
	{
		Player = SASPlayerController(P);
		
		if (Player == None)
			continue;
			
		if (Player.Pawn != None && !Player.Pawn.IsDead())
		{
			// Aha, this player is still alive.
			if (Player.PlayerReplicationInfo.Team != None)
			{
				if (Player.PlayerReplicationInfo.Team.TeamIndex == 0)
				{
					num_left_team0++;
					
					// Store a PRI on this team - we might need it for the match win message.
					Team0PRI = Player.PlayerReplicationInfo;
				}
				else
				{
					num_left_team1++;

					// Store a PRI on this team - we might need it for the match win message.
					Team1PRI = Player.PlayerReplicationInfo;
				}
			}
		}
	}
	
	// So, has one of the teams won?
	if (num_left_team0 == 0)
	{
		if (num_left_team1 == 0)
		{
			// oh dear, everyone's dead somehow simultaneously.
			EndGame(None, "NoWinner");
		}
		else
		{
			// Team 1 still has someone!
			EndGame(Team1PRI, "LastTeam");
		}
	}
	else
	{
		if (num_left_team1 == 0)
		{
			// Team 0 still has someone!
			EndGame(Team0PRI, "LastTeam");
		}
		else
		{
			// both teams still have people. Play on.
		}
	}
}

function CheckScoreKillMissionEnd(
	Controller	Killer,
	Controller	Killed )
{
	local PlayerReplicationInfo	KillerPRI;

	// Check for kill limit being reached.
	if ( KillLimit > 0 )
	{
		killerPRI = Killer.PlayerReplicationInfo;
		if ( killerPRI.ScoreKills >= KillLimit )
		{
			EndGame( killerPRI, "ScoreLimit" );
			return;
		}
	}
	// Check for dagger limit being reached.
	if ( DaggerLimit > 0 )
	{
		killerPRI = Killer.PlayerReplicationInfo;
		if ( killerPRI.ScoreDaggers >= DaggerLimit )
		{
			EndGame( killerPRI, "DaggerLimit" );
			return;
		}
	}

	// Check for last team standing.
	CheckTeamWin();
}

// No PlayerDied notification in Sabre-squad. Game end it dealt with in ScoreKill.
function PlayerDied( PlayerController	Which );

// Broadcast the end game outcome to all clients.
function BroadcastEndGameMessage( PlayerReplicationInfo Winner, string Reason )
{
	local int	type;

	type = -1;

	// Team win?
	if ( Reason ~= "LastTeam" )
	{
		type = 0;
	}
	// Frag limit win?
	else if ( Reason ~= "FragLimit" )
	{
		type = 1;
	}
	// Time limit up?
	else if ( Reason ~= "TimeLimit" )
	{
		// Do we have a winner or is match drawn?
		if ( Winner != None )
		{
			type = 2;
		}
		else
		{
			type = 3;
		}
	}
	// Match drawn?
	else if ( Reason ~= "NoWinner" )
	{
		type = 4;
	}

	if ( type != -1 )
	{
		BroadcastLocalized( self, class'SASMPMatchOverMessage', type, Winner );
	}
}


function EndGame(PlayerReplicationInfo Winner, string Reason )
{
	if ( (Reason ~= "triggered") ||
		(Reason ~= "LastMan")   ||
		(Reason ~= "LastTeam")   ||
		(Reason ~= "TimeLimit") ||
		(Reason ~= "DaggerLimit") ||
		(Reason ~= "ScoreLimit") ||
		(Reason ~= "NoWinner") ||
		(Reason ~= "TeamScoreLimit") )
	{
		// Flag frag limit reached - this ends the whole game.
		if ( Reason ~= "DaggerLimit" || Reason ~= "ScoreLimit" )
		{
			mbFragLimitReached = true;
		}

		Super.EndGame(Winner,Reason);
		if ( bGameEnded )
		{
			BroadcastEndGameMessage( Winner, Reason );
			GotoState('MatchOver');
		}
	}
}

State MatchOver
{
	function Timer()
	{
		local Controller C;

		Global.Timer();

		if ( !bGameRestarted && (Level.TimeSeconds > EndTime + RestartWait) )
		{
			// Let's go on to the next level, which may be a repeat of the current one.
			GoToNextLevel();
		}

		if ( EndGameFocus != None )
		{
			EndGameFocus.bAlwaysRelevant = true;
			for ( C = Level.ControllerList; C != None; C = C.NextController )
			{
				if ( PlayerController(C) != None )
				{
					PlayerController(C).ClientSetViewtarget(EndGameFocus);
				}
			}
		}

		// play end-of-match message for winner/losers (for single and muli-player)
		EndMessageCounter++;
		if ( EndMessageCounter == EndMessageWait )
		{
			PlayEndOfMatchMessage();
		}
	}


	function BeginState()
	{
		RemainingTime = 0;
		GameReplicationInfo.RemainingTime = 0;
		GameReplicationInfo.RemainingMinute = 0;

		GameReplicationInfo.bStopCountDown = true;
		
		// Get ready to wait for respawn
		EndTime = Level.TimeSeconds;

		// Deal with team swapping.
		DoMatchEndTeamChanging();
	}
}

function GoToNextLevel()
{
	local string	nextMap;

	// If reached frag limit then move to next level in the map if there is one else quit to frontend.
	if ( mbFragLimitReached )
	{
		nextMap = SASPlayerController( Level.GetLocalPlayerController() ).CycleMPMapList();
		if ( nextMap != "" )
		{
			Level.GetLocalPlayerController().SwitchLevel( nextMap );
		}
		else
		{
			ConsoleCommand( "start frontend" );
		}
		return;
	}

	// Do we go to the next level, or repeat this one for a while?
	if (mRepeatLevel > 0)
	{
		mRepeatLevel--;
	}
	
	if (mRepeatLevel != 0)
	{
		// we're still repeating the current level.
		RestartGame();
	}
	else
	{
		// We're starting a new one.
		Level.GetLocalPlayerController().SwitchLevel(SASPlayerController( Level.GetLocalPlayerController() ).CycleMPMapList());
	}
}


function CheckLevelEndConditions();

// how balanced are the teams?
// negative = more goodies needed, 0 = ok, positive = more baddies
// you can pass in a playercontroller that i will ignore
function int NumExtraTerroristsNeeded(
	bool bUseNextRoundTeams,
	optional Controller ignore)
{
	// 0 == sas, 1 == terrorist.
	local		Controller C;
	local		PlayerController	Player;
	local int	num_terrorists_needed;

	num_terrorists_needed = 0;
	
	// balance so that there's twice the terrorists of SAS.
	for ( C = Level.ControllerList; C != None; C = C.nextController )
	{
		// don't get confused with myself.
		if (C == ignore)
			continue;

		Player = PlayerController( C );
		if ( Player != None )
		{
			if (	(bUseNextRoundTeams && Player.PlayerReplicationInfo.TeamIndexForNextGame == 0) ||
					(!bUseNextRoundTeams && Player.PlayerReplicationInfo.Team.TeamIndex == 0) )
			{
				num_terrorists_needed += 2; // 2 terrorists needed to balance this SAS
			}
			else
			{
				num_terrorists_needed--;  // we've got one
			}
		}
	}
	
	return num_terrorists_needed;
}

// give an incoming player a team.
function byte PickTeam ( byte Current, Controller Cin )
{
	local Controller		C;
	local PlayerController	P;
	local bool				bOtherPlayersInLevel;

	if (Current != 255)
	{
		// He's already picked a team, most likely as a result of the last level played.
		return Current;
	}

	// Check if there are other players already in level - if not then make me SAS.
	for ( C = Level.ControllerList; C != None; C = C.nextController )
	{
		if ( C != Cin )
		{
			P = PlayerController( C );
			if ( P != None )
			{
				bOtherPlayersInLevel = true;
				break;
			}
		}
	}
	if ( !bOtherPlayersInLevel )
	{
		// Make first person in SAS.
		return 0;
	}
	else
	{
		// Otherwise, balance so that there's always at least twice the terrorists of SAS.
		if (NumExtraTerroristsNeeded(false, Cin) < 0)
		{
			return 0;
		}
		else
		{
			return 1;
		}
	}
}

// direction allows us to check for max and min
function PlayerController GetExtremeScorer(int team, int direction, bool bUseNextRoundTeams)
{
	local int current_extreme_score;
	local int pc_score;
	local int num_found;
	local PlayerController current_extreme_player;
	local Controller P;
	local PlayerController PC;
	
	current_extreme_score = -99999;
	
	for ( P = Level.ControllerList; P != None; P = P.NextController )
	{
		PC = PlayerController(P);
		
		if (PC == None)
			continue;

		if (	(bUseNextRoundTeams && PC.PlayerReplicationInfo.TeamIndexForNextGame != team) ||
				(!bUseNextRoundTeams && PC.PlayerReplicationInfo.Team.TeamIndex != team ) )
		{
			continue;
		}
			
		pc_score = PC.PlayerReplicationInfo.ScoreDaggers * direction;
		
		if (pc_score < current_extreme_score)
		{
			// never mind, this guy's not interesting
			continue;
		}
		
		if (pc_score == current_extreme_score)
		{
			// ooh he's close!
			if (PC.PlayerReplicationInfo.ScoreKills * direction < current_extreme_player.PlayerReplicationInfo.ScoreKills * direction)
			{
				// but not that close
				continue;
			}
			
			if (PC.PlayerReplicationInfo.ScoreKills == current_extreme_player.PlayerReplicationInfo.ScoreKills)
			{
				// a tie. How many at this score?
				num_found++;
				
				if (rand(num_found) == 1)
				{
					// statistically worth replacing
					current_extreme_player = PC;
				}
				
				continue;
			}			
		}			
		
		// if we get here, a new winner
		num_found = 1;
		current_extreme_player = PC;
		current_extreme_score = pc_score;
	}
	
	// found someone?
	return current_extreme_player;
}

function RestartGame ()
{
	local SASPawn				tPawn;
	local SASPickup				tPickup;
	local Controller			P;
	local PlayerController		Player;
	local SASPickupWeapon		Pickup;

	Reset ();
	
	// Tidyup/reset everything in the level.

	// Destroy all pawns.
	foreach AllActors( class 'SASPawn', tPawn )
	{
		tPawn.Destroy();
	}
	// Destroy weapon pickups.
	foreach DynamicActors ( class 'SASPickup', tPickup )
	{
		tPickup.Destroy ();
	}

	// And the rest - do on server and client side.
	SASPlayerController(Owner).ClientResetLevel();
	for ( P = Level.ControllerList; P != None; P = P.NextController )
	{
		if (	P != Owner &&
				SASPlayerController( P ) != None )
		{
			SASPlayerController( P ).ClientResetLevel();
		}
	}

	// Change everyone's team.
	for ( P = Level.ControllerList; P != None; P = P.NextController )
	{
		Player = PlayerController ( P );
		if ( Player != None )
		{
			// Let's change the player to the correct team based on what happened this turn.
			if (	(Player.PlayerReplicationInfo.TeamIndexForNextGame == 0 || Player.PlayerReplicationInfo.TeamIndexForNextGame == 1) &&
					Player.PlayerReplicationInfo.TeamIndexForNextGame != Player.PlayerReplicationInfo.Team.TeamIndex )
			{
				// This player has a new team to change to.
				ChangeTeam( Player, Player.PlayerReplicationInfo.TeamIndexForNextGame, true );
			}
		}
	}

	// Reset scoreboard team swapping data.
	SASGRI( GameReplicationInfo ).mSabreSquadNumTeamSwaps = 0;
	
	// Tell all the guys that the game is restarting.
	for ( P = Level.ControllerList; P != None; P = P.NextController )
	{
		Player = PlayerController ( P );
		if ( Player != None )
		{
			Player.PlayerReplicationInfo.bOutOfLives = false;
			Player.PlayerReplicationInfo.bLatecomer = false;

			// Put them into a waiting state.
			//Player.GotoState( 'SpectatingStationary' );
			//Player.ClientGotoState( 'SpectatingStationary', '' );

			Player.Reset();
			RestartPlayer( Player );
			Player.GotoState( 'WaitingForPawn' );
			Player.ClientGotoState( 'WaitingForPawn', '' );
			SASPRI( Player.PlayerReplicationInfo ).mSSquadPromoteDemoteStatus = PDSTATUS_None;
			SASPRI( Player.PlayerReplicationInfo ).mSSquadPromoteDemoteOtherPRI = None;
		}
	}

	// Respawn the level placed weapon pickups
	foreach AllActors ( class 'SASPickupWeapon', Pickup )
	{
		Pickup.Respawn ();
	}
	
	GotoState('PendingMatch');
}


function DoMatchEndTeamChanging()
{
	local Controller		P;
	local PlayerController	Player;

	// Make sure everyone has a TeamIndexForNextGame setup correctly.
	for ( P = Level.ControllerList; P != None; P = P.nextController )
	{
		Player = PlayerController ( P );
		if ( Player != None )
		{
			if ( Player.PlayerReplicationInfo.TeamIndexForNextGame == -1 )
			{
				// Stay in same team.
				Player.PlayerReplicationInfo.TeamIndexForNextGame = Player.PlayerReplicationInfo.Team.TeamIndex;
			}
		}
	}

	// Now everyone has a team index for next game, balance the teams.

	// If there's only 1 excess SAS or terrorist, that's ok.
	while( NumExtraTerroristsNeeded(true) > 1 )
	{
		// We've got 1 SAS too many.
		
		// Find the lowest scoring SAS
		Player = GetExtremeScorer( 0, -1, true );
		if ( Player == None )
		{
			// no-one, give up.
			break;
		}
		
		Player.PlayerReplicationInfo.TeamIndexForNextGame = 1;
		SASPRI( Player.PlayerReplicationInfo ).mSSquadPromoteDemoteStatus = PDSTATUS_DemotedBalance;
		//ChangeTeam( Player, 1, true );
		SASGRI( GameReplicationInfo ).mSabreSquadNumTeamSwaps++;
	}
	while( NumExtraTerroristsNeeded(true) < -1 )
	{
		// We've got 1 terrorist too many.
		
		// find the highest scoring terrorist
		Player = GetExtremeScorer( 1, 1, true );
		
		if ( Player == None )
		{
			// no-one, give up.
			break;
		}
		
		// promoted right now, not later, otherwise num terrorists needed code gets confused
		Player.PlayerReplicationInfo.TeamIndexForNextGame = 0;
		//ChangeTeam( Player, 0, true );
		SASPRI( Player.PlayerReplicationInfo ).mSSquadPromoteDemoteStatus = PDSTATUS_PromotedBalance;
		SASGRI ( GameReplicationInfo ).mSabreSquadNumTeamSwaps++;
	}	
}


////////////////////////////////////////////////////////////////////////////////
// RatePlayerStart
//
// Rate whether player should choose this NavigationPoint as its start
function float RatePlayerStart ( NavigationPoint N, byte Team, Controller Player )
{
	if ( ( N == None ) || ( SASSpawnPoint ( N ) == None ) || !SASSpawnPoint ( N ).bSSquadStart )
	{
		return -10000000;
	}

	return Super.RatePlayerStart ( N, Team, Player );
}

////////////////////////////////////////////////////////////////////////////////
// 
//
// check if all other players are out
function InitObjectiveManager ()
{
}


// Decompiled with UE Explorer.
defaultproperties
{
    NetWait=20
    RestartWait=10
    MinStartingHumanPlayers=1
    mRepeatLevel=-1
    mSquadManagerClassName="SASMPGame.SASDMSquadManager"
    mGameTypeId=1
    ScoreBoardType="SASMPGame.SASSSquadScoreboard"
    HUDType="SASMPGame.SASDMHUD"
    MapPrefix="SS"
    BeaconName="1"
    MaxSpectators=0
    MaxPlayers=128
    GameName="Sabre Squad"
    PlayerControllerClassName="SASMPGame.SASDMPlayerController"
}