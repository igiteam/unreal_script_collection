// [TJJ FIXME: We need to move the deathmacth game rule from HDTeamGame to HDTeamDeathMatch.]
class HDTeamDeathMatch extends HDTeamGame;


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
		Killer.PlayerReplicationInfo.Team.Score ++;
		Killer.PlayerReplicationInfo.Team.bNetDirty = TRUE;

		CheckScore( Killer.PlayerReplicationInfo );
	}

	Super.ScoreKill( Killer, Killed );
}
