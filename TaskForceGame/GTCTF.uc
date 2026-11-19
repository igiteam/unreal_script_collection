class GTCTF extends SFRMMultiplayer;

var int CapLimit;


function Logout( Controller Exiting )
{
	if (Exiting.PlayerReplicationInfo.HasFlag!=None && GTCTFFlag(Exiting.PlayerReplicationInfo.HasFlag)!=None)
	{
		GTCTFFlag(Exiting.PlayerReplicationInfo.HasFlag).Drop(vect(0,0,0));
	}
	
	super.Logout(Exiting);
}


function bool ChangeTeam(Controller Other, int N, bool bNewTeam)
{
	local bool bActuallyChangingTeam;
	
	if ((Other.PlayerReplicationInfo.bTerrorist && N == 1) ||
		( Other.PlayerReplicationInfo.Team.TeamIndex == N))
		bActuallyChangingTeam=false;
	else
		bActuallyChangingTeam=true;
	
	if (bActuallyChangingTeam)
	{
		Other.PlayerReplicationInfo.Kills=0;
		Other.PlayerReplicationInfo.Score=0;
		Other.PlayerReplicationInfo.Deaths=0;
	}
	
	Super.ChangeTeam(Other,N,bNewTeam);
		
	return true;
}

function SuspendMatch()
{
	local GTCTFFlag flag;

	// flags go home
	foreach DynamicActors( class'GTCTFFlag', flag )
	{
		flag.GoHome();
	}

	super.SuspendMatch();
}

/* CheckScore()
see if this score means the game ends
*/
function CheckScore(PlayerReplicationInfo Scorer)
{
	super.CheckScore(Scorer);

	if (Scorer.Team.Score >= CapLimit)
	{
		//end game...
		EndGame(Scorer, "");
	}
}

event ScoreObjective(PlayerReplicationInfo Scorer, float Score)
{
	if ( Scorer != None )
	{
		Scorer.Score += Score;
 
 		if ( Scorer.Team != None )
			Scorer.Team.Score += Score;
 	}

	CheckScore(Scorer);
}

function bool CanSpectate( PlayerController Viewer, bool bOnlySpectator, actor ViewTarget )
{
	local int sfElim,tElim;
	local Controller		C;
	local PlayerController	PC;

	// quick accessors
	C = Controller ( ViewTarget );
	PC = PlayerController ( ViewTarget );

	// can't spectate none
	if ( C == None ) 
		return false;
	
	// can't spectate a spectator
	if ( PC != None )
	{
		if ( PC.IsSpectating() || PC.PlayerReplicationInfo.bIsSpectator ) 
		{
			return false;
		}
	}

	// can't spectate dead people
	if ( C.GetStateName ( ) == 'Dead' )
	{
		return false;
	}

	// can't spectate someone who doesn't have a pawn
	if ( C.Pawn == None )
		return false;
	
	// find out if game is over
	CheckTeamElim ( sfElim,tElim );

	// anyone can spectate anyone after the terrorists are dead
	if ( tElim != 0 )
	{
		// oh, but they can't spectate themselves
		if ( Viewer != ViewTarget && ViewTarget != Viewer.Pawn )
			return true;
		else
			return false;
	}
	
	// can spectate people on the same team that aren't you
	if ( Viewer != ViewTarget && ViewTarget != Viewer.Pawn && Viewer.PlayerReplicationInfo.Team.TeamIndex == C.PlayerReplicationInfo.Team.TeamIndex )
		return true;
	else
		return false;
}

event InitGame( string Options, out string Error )
{
	super.InitGame(Options, Error);
	
	CapLimit = GetIntOption(Options, "ScoreLimit", CapLimit);
//	log("KillLimit: " $ KillLimit);
}

function InitGameReplicationInfo()
{
	super.InitGameReplicationInfo();
	GameReplicationInfo.Teams[0] = spawn(class'ZombieGame.TeamSF');
	GameReplicationInfo.Teams[1] = spawn(class'ZombieGame.TeamTerrorist');
	GameReplicationinfo.GoalScore = CapLimit;
}

function DiscardInventory( Pawn Other )
{
	if (Other.PlayerReplicationInfo.bHasFlag)
	{
		GTCTFFlag(Other.PlayerReplicationInfo.HasFlag).Drop(Other.Velocity);
	}
	
	super.DiscardInventory(Other);
}


// Decompiled with UE Explorer.
defaultproperties
{
    CapLimit=20
    Respawns=0
    bTeamGame=true
    GameName="CTF"
    GameTypeID=6
}