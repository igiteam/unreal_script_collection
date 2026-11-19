class GTKOH extends SFRMMultiplayer;

var float ScoreLimit;

function bool ChangeTeam(Controller Other, int N, bool bNewTeam)
{
	local bool bActuallyChangingTeam;

	if( Other.PlayerReplicationInfo.Team == None || Other.PlayerReplicationInfo.Team.TeamIndex == N )
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

/* CheckScore()
see if this score means the game ends
*/
function CheckScore(PlayerReplicationInfo Scorer)
{
	local float scoreToCheck;

	super.CheckScore(Scorer);

	if (bTeamGame)
	{
		scoreToCheck = Scorer.Team.Score;
		
//		log("Scoring now (Team): " $ Scorer.PlayerName @ Scorer.Score @ scoreToCheck);
	}
	else
	{
		scoreToCheck = Scorer.Score;
		
//		log("Scoring now (No Team): " $ Scorer.PlayerName @ Scorer.Score @ scoreToCheck @ ScoreLimit);
	}

	if (scoreToCheck >= ScoreLimit && ScoreLimit > 0)
	{
		//end game...
		EndGame(Scorer, "");
	}
}

event ScoreObjective(PlayerReplicationInfo Scorer, float Score)
{
	local int intPreScore;
	local int intPostScore;
	if ( Scorer != None )
	{
		intPreScore = int(Scorer.Score);
		
		Scorer.Score += Score;
		
		intPostScore = int(Scorer.Score);

		//all this oddness is to ensure the team score is based on the sum of the floor of the players scores, not the sum of the raw scores
		//(because the non-displayed fractions make the scoring look wrong
 
  		if ( bTeamGame && Scorer.Team != None && (intPostScore > intPreScore))
 		{
			Scorer.Team.Score += (intPostScore - intPreScore);
		}
 	}

	CheckScore(Scorer);
}

event InitGame( string Options, out string Error )
{
	super.InitGame(Options, Error);
	
	ScoreLimit = GetIntOption(Options, "ScoreLimit", ScoreLimit);
}

function InitGameReplicationInfo()
{
	super.InitGameReplicationInfo();
	
	if (bTeamGame)
	{
		GameReplicationInfo.Teams[0] = spawn(class'ZombieGame.TeamSF');
		GameReplicationInfo.Teams[1] = spawn(class'ZombieGame.TeamTerrorist');
	}
	
	GameReplicationinfo.GoalScore = ScoreLimit;
}


// Decompiled with UE Explorer.
defaultproperties
{
    ScoreLimit=10.0000000
    ZombieMessageClass=Class'ZombieMPMessageNoTeams'
    GameName="KOH"
    GameTypeID=4
}