////////////////////////////////////////////////////////////////////////////////
// SASDMGameInfo.uc
//
// SAS Deathmatch game info
////////////////////////////////////////////////////////////////////////////////

class SASDMGameInfo extends SASSSquadGameInfo
	config(user);


////////////////////////////////////////////////////////////////////////////////
// RatePlayerStart
//
// Rate whether player should choose this NavigationPoint as its start
function float RatePlayerStart ( NavigationPoint N, byte Team, Controller Player )
{
	if ( ( N == None ) || ( SASSpawnPoint ( N ) == None ) || !SASSpawnPoint ( N ).bDMStart )
	{
		return -10000000;
	}

	return Super.RatePlayerStart ( N, Team, Player );
}


// Decompiled with UE Explorer.
defaultproperties
{
    bStartPointSelectsPawnType=false
    ScoreBoardType="SASMPGame.SASDMScoreboard"
    MapPrefix="DM"
    BeaconName="DM"
    MaxPlayers=32
    GameName="DeathMatch"
    TimeLimit=3
}