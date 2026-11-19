class SFRMTeamDeathmatch extends SFRMMultiPlayer;

var int KillLimit;

function bool ChangeTeam(Controller Other, int N, bool bNewTeam)
{
	local PlayerController PC;
	local bool bNewTeamTerr,bOldTeamTerr;
	bNewTeamTerr = N ==1;
	bOldTeamTerr = Other.PlayerReplicationInfo.bTerrorist;
	if ( Other.PlayerReplicationInfo.Team != None && Other.PlayerReplicationInfo.Team.TeamIndex == 1 )
		bOldTeamTerr = true;
		
	if (Other!=None && Other.PlayerReplicationInfo!= None)
	{
		if (bNewTeamTerr != bOldTeamTerr)
		{
			//remove him from the old team
			Other.PlayerReplicationInfo.Score=0;
			Other.PlayerReplicationInfo.Kills=0;
			Other.PlayerReplicationInfo.Deaths=0;
		}
	
		if (Other.PlayerReplicationInfo.Team !=None)
			Other.PlayerReplicationInfo.Team.RemoveFromTeam(Other);
	}
	
	if (N == 1)
		GameReplicationInfo.Teams[1].AddToTeam(Other);
	else
		GameReplicationInfo.Teams[0].AddToTeam(Other);

	if( bNewTeamTerr != bOldTeamTerr )
	{
		ForEach DynamicActors(class'PlayerController', PC)
			PC.ReceiveLocalizedMessage( class'ZombieMPMessage', 14, Other.PlayerReplicationInfo,None,Other.PlayerReplicationInfo.Team);
	}

	return true;
}

function InitGameReplicationInfo()
{
	super.InitGameReplicationInfo();
	GameReplicationInfo.Teams[0] = spawn(class'ZombieGame.TeamSF');
	GameReplicationInfo.Teams[1] = spawn(class'ZombieGame.TeamTerrorist');
	GameReplicationInfo.GoalScore = KillLimit;
}

/* CheckScore()
see if this score means the game ends
*/
function CheckScore(PlayerReplicationInfo Scorer)
{
	super.CheckScore(Scorer);
	
	if ((KillLimit != -1) && (Scorer.Team.Score >= KillLimit))
	{
		//end game...
		EndGame(Scorer, "");
	}
}

function ScoreKill(Controller Killer, Controller Other)
{
	log("SFRMMP: ScoreKill");
	if( (killer == Other) || (killer == None) )
	{
		if (bScoreKills)
		{
			Other.PlayerReplicationInfo.Score -= 1;
			Other.PlayerReplicationInfo.Kills -= 1;
			Other.PlayerReplicationInfo.Team.Score -= 1;
		}
		if (GameStats!=None)
			GameStats.ScoreEvent(Other.PlayerReplicationInfo,-1,"self_frag");
	}
	else if ( killer.PlayerReplicationInfo != None && other.PlayerReplicationInfo!=None &&
				killer.PlayerReplicationInfo.Team.TeamIndex != other.PlayerReplicationInfo.Team.TeamIndex)
	{
		if (bScoreKills)
		{
			Killer.PlayerReplicationInfo.Score += 1;
			Killer.PlayerReplicationInfo.Team.Score += 1;
		}
		Killer.PlayerReplicationInfo.Kills++;
		if (GameStats!=None)
			GameStats.ScoreEvent(Killer.PlayerReplicationInfo,1,"frag");
	}
	else if ( killer.PlayerReplicationInfo != None && other.PlayerReplicationInfo!=None &&
				killer.PlayerReplicationInfo.Team.TeamIndex == other.PlayerReplicationInfo.Team.TeamIndex)
	{
		if (bScoreKills)
		{
			Killer.PlayerReplicationInfo.Score -= 1;
			Killer.PlayerReplicationInfo.Team.Score -= 1;
		}
		Killer.PlayerReplicationInfo.Kills--;
		if (GameStats!=None)
			GameStats.ScoreEvent(Killer.PlayerReplicationInfo,1,"team_frag");
	}

	if ( GameRulesModifiers != None )
		GameRulesModifiers.ScoreKill(Killer, Other);

	CheckScore(Killer.PlayerReplicationInfo);
}

event InitGame( string Options, out string Error )
{
	super.InitGame(Options, Error);
	
	KillLimit = GetIntOption(Options, "ScoreLimit", KillLimit);
//	log("KillLimit: " $ KillLimit);
}


// Decompiled with UE Explorer.
defaultproperties
{
    KillLimit=20
    bScoreKills=true
    bTeamGame=true
    GameName="TDM"
    GameTypeID=3
}