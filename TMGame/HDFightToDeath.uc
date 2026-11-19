//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDFightToDeath extends HDTeamGame;


/** Whether starting the match. */
var         bool            bShouldStartMatch;

/** Hint message on server's HUD to prompt 'click to start'. */
var config localized string     ServerMessage;

/** Hint message on clients' HUD to prompt 'wait for server'. */
var config localized string     ClientMessage;


function RestartPlayer( Controller InPlayer )
{
	if( !InPlayer.PlayerReplicationInfo.bOutOfLives )
	{
		Super.RestartPlayer( InPlayer );
		InPlayer.PlayerReplicationInfo.bOutOfLives = true;
	}
}


//
// Log a player in.
// Fails login if you set the Error string.
// PreLogin is called before Login, but significant game time may pass before
// Login is called, especially if content is downloaded.
//
event PlayerController Login( string Portal,
		string Options,
		const UniqueNetID UniqueID,
		out string ErrorMessage )
{
	local PlayerController PC;
	local HDTeamFixedPlayerStart PS;

	PC = Super.Login( Portal, Options, UniqueID, ErrorMessage );

	if( PC != none )
	{
		PS = HDTeamFixedPlayerStart( PC.StartSpot );
		if( PS != none )
		{
			PS.OwningController = PC;
		}
	}

	return PC;
}

function NavigationPoint FindPlayerStart(
	Controller InPlayer,
	optional byte InTeam,
	optional string IncomingName )
{
	local HDTeamFixedPlayerStart BestPS, P;
	local int   BestIndex;

	if( InPlayer != none && InPlayer.StartSpot != none )
	{
		// For seamless travel, just return assigned start spot.
		return InPlayer.StartSpot;
	}

	foreach WorldInfo.AllNavigationPoints( class'HDTeamFixedPlayerStart', P )
	{
		if( P.TeamNumber != InTeam || P.OwningController != none )
		{
			continue;
		}

		if( BestPS == none )
		{
			BestPS = P;
			BestIndex = P.PlayerIndex;
		}
		else if( P.PlayerIndex < BestIndex )
		{
			BestPS = P;
			BestIndex = P.PlayerIndex;
		}
	}

	if( BestPS != none && InPlayer != none )
	{
		BestPS.OwningController = InPlayer;
	}

	return BestPS;
}


function bool CheckScore( PlayerReplicationInfo InScorer )
{
	local PlayerController PC;
	local PlayerReplicationInfo Winner;
	local TeamInfo WinTeam;

	foreach WorldInfo.AllControllers( class'PlayerController', PC )
	{
		if( PC.PlayerReplicationInfo != none
		&& PC.PlayerReplicationInfo.Team != none
		&& PC.Pawn != none
		&& PC.Pawn.Health > 0 )
		{
			if( WinTeam == none )
			{
				WinTeam = PC.PlayerReplicationInfo.Team;
				Winner = PC.PlayerReplicationInfo;
			}
			else if( PC.PlayerReplicationInfo.Team != WinTeam )
			{
				return false;
			}
		}
	}

	if( Winner == none )
	{
		foreach WorldInfo.AllControllers( class'PlayerController', PC )
		{
			if( PC.PlayerReplicationInfo != none )
			{
				Winner = PC.PlayerReplicationInfo;
				break;
			}
		}
	}

	EndGame( Winner, "teamscorelimit" );

	return true;
}

function Logout( Controller InExiting )
{
	local PlayerController  PC, LastPC;
	local TeamInfo          LastTeam;

	Super.Logout( InExiting );

	if( WorldInfo.IsInSeamlessTravel() )
	{
		return;
	}

	foreach WorldInfo.AllControllers( class'PlayerController', PC )
	{
		if( LastTeam == none )
		{
			LastTeam = PC.PlayerReplicationInfo.Team;
			LastPC = PC;
			continue;
		}
		else if( PC.PlayerReplicationInfo.Team != LastTeam )
		{
			return;
		}
	}

	EndGame( LastPC.PlayerReplicationInfo, "teamscorelimit" );
	return;
}


function ScoreKill( Controller Killer, Controller Killed )
{
	if( Killer == None || Killer == Killed )
	{
		Killed.PlayerReplicationInfo.Score -= 30;
		Killed.PlayerReplicationInfo.bNetDirty = TRUE;
		CheckScore( none );
	}
	else if( Killer.PlayerReplicationInfo.Team != Killed.PlayerReplicationInfo.Team )
	{
		Killer.PlayerReplicationInfo.Score += 50;
		Killer.PlayerReplicationInfo.bNetDirty = TRUE;
		Killer.PlayerReplicationInfo.Team.Score ++;
		Killer.PlayerReplicationInfo.Team.bNetDirty = TRUE;

		CheckScore( Killer.PlayerReplicationInfo );
	}

	Super.ScoreKill( Killer, Killed );
}


exec function Kickoff()
{
	bShouldStartMatch = true;
}


auto State PendingMatch
{
	function Timer()
	{
		if( bShouldStartMatch )
		{
			StartMatch();
		}
	}

//  event BeginState(name NextStateName)
//  {
//  }
//
//  event EndState(name NextStateName)
//  {
//  }
}


