class GTTeamLastManStanding extends SFRMTeamDeathmatch;

event InitGame( string Options, out string Error )
{
	super.InitGame(Options, Error);
	
	KillLimit = -1; //make sure we don't have a kill limit
}

function SetDeferredTeamAndClass( Controller aPlayer )
{
	// we do this elsewhere at the start of the round
	local SFRMPlayerController PC;

	if( IsInState('PendingMatch') )
	{
		super.SetDeferredTeamAndClass( aPlayer );
	}
	else
	{
		PC = SFRMPlayerController ( aPlayer );

		//kinda hacky... force players who joined late into spectating mode
		if( aPlayer.PlayerReplicationInfo.ClassIdx == 0 )
		{		
			if ( PC != None && !PC.IsInState( 'Spectating' ) )
			{
				PC.ChangeTeam ( int(PC.PlayerReplicationInfo.bNextTerrorist) );
				PC.GotoState ('Spectating');
				PC.PlayerReplicationInfo.bIsSpectator = true;
				PC.ShowSpectating();
			}
			else
			{
				//ChangeTeam ( aPlayer, int ( aPlayer.PlayerReplicationInfo.bNextTerrorist ), true );
				super.SetDeferredTeamAndClass( aPlayer );
			}
		}
		else
		{
			super.SetDeferredTeamAndClass( aPlayer );
		}
	}
}


// Decompiled with UE Explorer.
defaultproperties
{
    Respawns=0
    UsesRespawns=true
    GameName="TLMS"
    GameTypeID=9
}