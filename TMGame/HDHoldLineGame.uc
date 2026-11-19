class HDHoldLineGame extends HDTeamGame;

var array< Trigger_Flag > Flags;

function PostBeginPlay()
{
	local Trigger_Flag Flag;

	Super.PostBeginPlay();

	//register
	foreach DynamicActors( class'Trigger_Flag', Flag )
	{
		Flags.AddItem( Flag );
	}

	SetTimer( 1.0, true, 'CheckFlagScore' );

	;
}

event CheckFlagScore()
{
	local int 					ScoreTeam0, ScoreTeam1, HighestScore;
	local Trigger_Flag			Flag;
	local TeamInfo				Team, WinTeam, HighestScoreTeam;
	local PlayerReplicationInfo Player, WinPlayer;

	if( bGameEnded )
	{
		return;
	}

	ScoreTeam0 = 0;
	ScoreTeam1 = 0;
	HighestScore = 0;
	WinTeam = none;
	WinPlayer = none;

	foreach Flags( Flag )
	{
		ScoreTeam0 += Flag.ScoreList[ 0 ];
		ScoreTeam1 += Flag.ScoreList[ 1 ];
	}

	foreach GameReplicationInfo.Teams( Team )
	{
		if( Team.TeamIndex == 0 )
		{
			Team.Score = ScoreTeam0;
			Team.bNetDirty = true;

			if( Team.Score > HighestScore )
			{
				HighestScore = Team.Score;
				HighestScoreTeam = Team;
			}

			if( Team.Score >= GoalScore )
			{
				WinTeam = Team;
			}
		}
		else if( Team.TeamIndex == 1 )
		{
			Team.Score = ScoreTeam1;
			Team.bNetDirty = true;

			if( Team.Score > HighestScore )
			{
				HighestScore = Team.Score;
				HighestScoreTeam = Team;
			}

			if( Team.Score >= GoalScore )
			{
				WinTeam = Team;
			}
		}
	}

	if( GameReplicationInfo.RemainingTime <= 0 )
	{
		WinTeam = HighestScoreTeam;
	}

	if( WinTeam != none )
	{
		foreach GameReplicationInfo.PRIArray( Player )
		{
			if( Player.Team == WinTeam )
			{
				WinPlayer = Player;
				break;
			}
		}

		EndGame( WinPlayer, "TeamScoreLimit" );
	}
}

function bool CheckScore( PlayerReplicationInfo Scorer )
{
	return false;
}

function bool CheckMaxLives( PlayerReplicationInfo Scorer )
{
	return false;
}

function ScoreKill( Controller Killer, Controller Killed )
{
	if( Killer == None || Killer == Killed )
	{
		Killed.PlayerReplicationInfo.Score -= 30;
		Killed.PlayerReplicationInfo.bNetDirty = TRUE;
	}
	else if( Killer.PlayerReplicationInfo.Team != Killed.PlayerReplicationInfo.Team )
	{
		Killer.PlayerReplicationInfo.Score += 50;
		Killer.PlayerReplicationInfo.bNetDirty = TRUE;
	}

	Super.ScoreKill( Killer, Killed );
}
