class SFRMDeathmatch extends SFRMMultiPlayer;

var int KillLimit;

function InitGameReplicationInfo()
{
	super.InitGameReplicationInfo();
	GameReplicationInfo.GoalScore = KillLimit;
}
/* CheckScore()
see if this score means the game ends
*/
function CheckScore(PlayerReplicationInfo Scorer)
{
	super.CheckScore(Scorer);

	if ( (KillLimit != -1) && (Scorer.Score >= KillLimit) )
	{
		//end game...
		EndGame(Scorer, "");
	}
}

event InitGame( string Options, out string Error )
{
	super.InitGame(Options, Error);
	
	KillLimit = GetIntOption(Options, "ScoreLimit", KillLimit);
//	log("KillLimit: " $ KillLimit);
}

function ScoreKill(Controller Killer, Controller Other)
{
	log("SFRMDM: ScoreKill"@Other@Killer);
	if( (killer == Other) || (killer == None) )
	{
		if (bScoreKills)
		{
			Other.PlayerReplicationInfo.Score -= 1;
			Other.PlayerReplicationInfo.Kills-= 1;
		}
		if (GameStats!=None)
			GameStats.ScoreEvent(Other.PlayerReplicationInfo,-1,"self_frag");
	}
	else if ( killer.PlayerReplicationInfo != None )
	{
		if (bScoreKills)
		{
			Killer.PlayerReplicationInfo.Score += 1;
		}
		Killer.PlayerReplicationInfo.Kills++;
		if (GameStats!=None)
			GameStats.ScoreEvent(Killer.PlayerReplicationInfo,1,"frag");
	}

	if ( GameRulesModifiers != None )
		GameRulesModifiers.ScoreKill(Killer, Other);

    //if ( (Killer != None) || (MaxLives > 0) )
	CheckScore(Killer.PlayerReplicationInfo);
}



// Decompiled with UE Explorer.
defaultproperties
{
    KillLimit=20
    bScoreKills=true
    ZombieMessageClass=Class'ZombieMPMessageNoTeams'
    GameName="DM"
    GameTypeID=2
}