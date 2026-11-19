
class TPMultiPlayerGameTeamDMInfo extends TPMultiplayerGameInfo
	dependson(TPAchievements)
	config(Game);

var bool		teamSpawnMode;			// Which spawn points are used (changes during course of the game): Team collective spawns, or neutral spawn points.
var	string		CustomTeamName[2];		// Teamnames could be parsed through the .ini but this is quick and UT does it too	

state PreRound
{	
Begin:
		AllowAchievements = true;
		teamSpawnMode = true;
		//ChangeClientGameState(MPState_PreGame);
		TPGRI.SetGameStatus(GS_PreGame);
		;
		SetTimer(WorldInfo.TimeDilation, true);
		GameReplicationInfo.RemainingTime = -TIME_IN_PRE_GAME;
		SyncClientTime();
}

state MatchInProgress
{
begin:
	AllowAchievements = true;
	overtime = false;
	teamSpawnMode = false;
	;
	AssignTeamNames();
	SetTimer(WorldInfo.TimeDilation, true);
	SetGameSpeed(GameSpeed);
	//ChangeClientGameState(MPState_Game);	
	TPGRI.SetGameStatus(GS_GameInProgress);
}

function InitTeamMuteList(TPPlayerController PC)
{
	local TeamInfo Team;
	local TPPlayerController OtherPC;

	Team = PC.Pawn.PlayerReplicationInfo.Team;
	PC.VoiceChannel = Team.TeamIndex == 0 ? VC_Team1 : VC_Team2;
	// Check all players
	foreach WorldInfo.AllControllers(class'TPPlayerController',OtherPC)
	{
		if (OtherPC != PC)
		{
			OtherPC.VoiceChannel = OtherPC.Pawn.PlayerReplicationInfo.Team.TeamIndex == 0 ? VC_Team1 : VC_Team2;
			// If not on the same team and not in the list already, mute
			if (OtherPC.VoiceChannel != PC.VoiceChannel)
			{
				PC.GameplayMutePlayer(OtherPC.PlayerReplicationInfo.UniqueId);
				OtherPC.GameplayMutePlayer(PC.PlayerReplicationInfo.UniqueId);
			}
			else
			{
				PC.GameplayUnmutePlayer(OtherPC.PlayerReplicationInfo.UniqueId);
				OtherPC.GameplayUnmutePlayer(PC.PlayerReplicationInfo.UniqueId);
			}
		}
	}
}

// This is internal for now, We'll need to localize/soften it and provide an accessor for Ryan's UI code.
function AssignTeamNames()
{
	CustomTeamName[0] = "Partisan";
	CustomTeamName[1] = "Nazi";
}

// Ends a Multiplayer game, after someone has scored, causing his team's score to win the game.
function EndGame(PlayerReplicationInfo Winner, string Reason )
{
	local TPPlayerController PC;
	local TPPlayerReplicationInfo myPRI;

	if (Reason ~= "KilledEnough" || Reason ~= "TimeExpired" || Reason ~= "Overtime")
	{
		// The winner of a match is the team with the best score.  After a Win reason is declared and this function is called, we are guarenteed to
		// have a winner by virtue of higher score for all victory types.


		// If a higher level gametype has not already declared a winner (Team DM), declare the winner
		if ( GameReplicationInfo.Winner == none )
		{
			if ( Teams[1].Score > Teams[0].Score )
				GameReplicationInfo.Winner = Teams[1];
			else
				GameReplicationInfo.Winner = Teams[0];

			;
			;
			;
			;
			;
			;
			;
			;

		}
		
		// End the game properly through our base DM GameInfo
		Super.EndGame(Winner,Reason);

		// If we ended the game
		if ( bGameEnded )
		{
			if (AllowAchievements)
			{
				UnlockMVP();
			}

			// Tell all of the clients we ended the game.
			foreach WorldInfo.AllControllers(class'TPPlayerController', PC)
			{
				myPRI = TPPlayerReplicationInfo(PC.PlayerReplicationInfo);

				if (TeamInfo(GameReplicationInfo.Winner).TeamIndex == myPRI.Team.TeamIndex)
					myPRI.SetGameWinner();

				//// Update the number of RankedTeamGames
				//if (myPRI.GameWinner)
				//{
				//	PC.ClientIncrementGamesWon(true);
				//}
			}

			// And change our game mode on the server to allow smooth transition back to the lobby
			GotoState('PostGame');
		}
	}
}

// Kill all the players on the server.
function KillRemainingPlayers()
{
	local int idx;

	// Reset the team scores since this is a team game
	for (idx = 0; idx < NumTeams; idx++)
	{
		Teams[idx].Score = 0;
	}

	// Kill/Clean all players and reset their INDIVIDUAL scores
	Super.KillRemainingPlayers();
}

// Returns the player's PRI with the highest score that also is on the winning team [MVP].
function PlayerReplicationInfo GetTeamMVP(int winningTeamIdx)
{
	local TPPlayerReplicationInfo	mvp;		// The top scorer on the best team
	local TPPlayerReplicationInfo	pri;
	local TPPlayerController		tPC;

	// For all Player's in the game, extract their PRIs which contain how much they scored
	foreach WorldInfo.AllControllers(class'TPPlayerController', tPC )
	{
		// Get this Player's Replication Info
		pri = TPPlayerReplicationInfo(tPC.PlayerReplicationInfo);

		// Is this player on the winning team?
		if ( winningTeamIdx == pri.Team.TeamIndex)
		{
			// Is this the first player on the team, or is it the best scoring team member we've searched so far?
			if ( pri == none || pri.Score > mvp.Score )
			{
				// This player is the MVP so far...
				mvp = pri;
			}
		}
	}

	// Can return none in the event that the winning team had all of its players leave before the match ended, yet still had highest score.
	return mvp;

}

// Check to see if time has expired for the game.  End it if it has, and if there is a sole victor
function bool CheckTime()
{
	local int WinnerTeamID;

	// Don't check time expiration in Overtime.  Time has expired if there is no RemainingTime left
	if ( TimeLimit > 0 && GameReplicationInfo.RemainingTime <= 0  && !overtime )
	{
		WinnerTeamID = GetTeamDMLeader();

		// If a team has won the game
		if ( WinnerTeamID != -1 )
		{
			// End the game and declare our winner.  The player with the highest score of the winning team [MVP] is the PRI that should be passed in.
			EndGame( GetTeamMVP( WorldInfo.GRI.Teams[WinnerTeamID].TeamIndex ) ,"TimeExpired" );
			return true;
		}	

		// Both teams are tied, GetTeamDMLeader() has set overtime mode and the game must continue.
		return false;
	}

	return false;

}

// Called when time expires.  
// Gets the Team ID of the team that is currently leading the match when time expires.  
// Overtime is initialized if the teams are tied.
simulated function int GetTeamDMLeader()
{
	// If team 0 [Partisan] has a higher score, than they are the current leader
	if ( Teams[0].Score > Teams[1].Score)
		return 0;

	// If team 1 [Nazi] has a higher score, than they are the current leader
	if ( Teams[0].Score < Teams[1].Score )
		return 1;

	// Tie game, there is no leader and OT should be instigated since we are at the end of the game.
	OvertimeInit( Teams[0].Score );
	return -1;
}

function PopulatePlayerStart(out array<PlayerStart> PlayerStarts, byte Team  )
{
	local AlliedPlayerStart		alliedSpawn;
	local AxisPlayerStart		axisSpawn;

	// If we are not using any teamDM spawn logic, simply use the standard DM spawn logic.
	if ( teamSpawnMode == false )
	{
		Super.PopulatePlayerStart(PlayerStarts, Team);
		return;
	}
	
	// If the requester is on the allied team 
	if ( Team == 0 )
	{
		foreach WorldInfo.AllNavigationPoints(class'AlliedPlayerStart', alliedSpawn)
		{
			if ( alliedSpawn.bEnabled )
				PlayerStarts[PlayerStarts.Length] = alliedSpawn;
		}
	}
	else
	{
		foreach WorldInfo.AllNavigationPoints(class'AxisPlayerStart', axisSpawn)
		{
			if ( axisSpawn.bEnabled )
				PlayerStarts[PlayerStarts.Length] = axisSpawn;
		}
	}

}

function bool CheckScore(PlayerReplicationInfo Scorer)
{
	if ( Scorer != None )
	{
		if ( (GameReplicationInfo.GoalScore > 0) && (Scorer.Team.Score >= GameReplicationInfo.GoalScore) )
		{
			;
			;
			;
			EndGame(Scorer,"KilledEnough");
		}
	}
	return true;
}

function ScoreKill(Controller Killer, Controller Other)
{
	if( (killer == Other) || (killer == None) )
	{
    	if ( (Other!=None) && (Other.PlayerReplicationInfo != None) )
		{
			Other.PlayerReplicationInfo.Score -= 1;
			Other.PlayerReplicationInfo.Team.Score -= 1;
			//SPARK OCT CODEDROP
			//Other.PlayerReplicationInfo.NetUpdateTime = WorldInfo.TimeSeconds - 1;
		}
	}
	else if ( killer.PlayerReplicationInfo.Team.TeamIndex == Other.PlayerReplicationInfo.Team.TeamIndex )
	{
		Killer.PlayerReplicationInfo.Score -= 1;
		Killer.PlayerReplicationInfo.Team.Score -= 1;
		//SPARK OCT CODEDROP
		//Killer.PlayerReplicationInfo.NetUpdateTime = WorldInfo.TimeSeconds - 1;

	}
	else if ( killer.PlayerReplicationInfo != None )
	{
		Killer.PlayerReplicationInfo.Score += 10;
		Killer.PlayerReplicationInfo.Team.Score += 1;
		//SPARK OCT CODEDROP
		//Killer.PlayerReplicationInfo.NetUpdateTime = WorldInfo.TimeSeconds - 1;
		Killer.PlayerReplicationInfo.Kills++;
	}

    if ( (Killer != None) || (MaxLives > 0) )
	{
		CheckScore(Killer.PlayerReplicationInfo);
	}
}

function ReduceDamage( out int Damage, pawn injured, Controller instigatedBy, vector HitLocation, out vector Momentum, class<DamageType> DamageType )
{
	local int idx;
	
	for (idx = 0; idx < Teams.Length; idx++)
	{
		Teams[idx].NotifyTakeDamage(injured.Controller,instigatedBy);
	}

	Super.ReduceDamage(Damage,injured,instigatedBy,HitLocation,Momentum,damageType);
}

// If a player has disconnected, are there two manned teams so that one can win?
function HandleDisconnect( int disconnectID )
{
	local PlayerReplicationInfo PRI, naziPRI, partisanPRI;
	local bool					partisanTeamHasPlayers;	// Team Idx 0 (bool arrays invalid in UC, gotta make seperate vars)
	local bool					naziTeamHasPlayers;		// Team Idx 1 
	local int					WinnerTeamID, naziTeamID, partisanTeamID, i;

	if ( TPGRI.GameStatus == GS_Lobby )
	{
		return;
	}

	WinnerTeamID			= -1;
	partisanTeamHasPlayers	= false;
	naziTeamHasPlayers		= false;
	partisanTeamID			= 0;
	naziTeamID				= 1;

	// Determine if there are enough elliglbe players to win the match to continue.
	// For this game mode [ Deathmatch ] , having more than 1 player is simply enough to keep the match going.
	for ( i = 0; i < TPGRI.PRIArray.Length; i++ )
	{
		PRI = TPPlayerReplicationInfo( TPGRI.PRIArray[i] );
		if ( PRI != None && disconnectID != PRI.PlayerID )
		{
			if ( partisanTeamID == PRI.Team.TeamIndex )
			{
				partisanTeamHasPlayers = true;
				partisanPRI = PRI;
			}		
			else
			{
				naziTeamHasPlayers = true;
				naziPRI = PRI;
			}	
		}
	}

	// If both teams have players that are not disconnecting, the match may continue.
	if ( partisanTeamHasPlayers && naziTeamHasPlayers )
		return;

	// Otherwise, the team that has players wins the match.
	if ( partisanTeamHasPlayers )
	{
		WinnerTeamID	= partisanTeamID;
		PRI				= partisanPRI;
	}	
	else
	{
		WinnerTeamID	= naziTeamID;
		PRI				= naziPRI;
	}
		
	// The best player on this team gets credit for the player winner, and his team is credited with the win.
	GameReplicationInfo.Winner = Teams[WinnerTeamID];

	;
	AllowAchievements = false;

	EndGame( PRI ,"TimeExpired" );

}

