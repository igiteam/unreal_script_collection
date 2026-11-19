class TurokTeamDMGame extends TurokTeamGame
    native
    config(Game)
    hidecategories(Navigation,Movement,Collision);

function ScoreKill(@NULL Killer, @NULL Victim)
{
    local @NULL TeamInfo;

    // DebugMode: 0
    assert(Victim != none);
    // End:0xB3
    if((Killer == none) || Victim == Killer)
    {
        // End:0xB0
        if(Victim.bIsPlayer && Victim.PlayerReplicationInfo != none)
        {
            TeamInfo = Victim.PlayerReplicationInfo.Team;
            // DebugMode: 0
            assert(TeamInfo != none);
            TeamInfo.Score -= FriendlyFireScorePenalty;
            TeamInfo.NetUpdateTime = WorldInfo.TimeSeconds - float(1);
        }        
    }
    else
    {
        // End:0x172
        if(Victim.bIsPlayer && GameReplicationInfo.OnSameTeam(Killer, Victim))
        {
            // End:0x16F
            if(Victim.bIsPlayer && Killer.PlayerReplicationInfo != none)
            {
                TeamInfo = Killer.PlayerReplicationInfo.Team;
                // DebugMode: 0
                assert(TeamInfo != none);
                TeamInfo.Score -= FriendlyFireScorePenalty;
                TeamInfo.NetUpdateTime = WorldInfo.TimeSeconds - float(1);
            }            
        }
        else
        {
            // End:0x21C
            if(Victim.bIsPlayer && !GameReplicationInfo.OnSameTeam(Killer, Victim))
            {
                // End:0x21C
                if(Killer.PlayerReplicationInfo != none)
                {
                    TeamInfo = Killer.PlayerReplicationInfo.Team;
                    // DebugMode: 0
                    assert(TeamInfo != none);
                    TeamInfo.Score += 1.0000000;
                    TeamInfo.NetUpdateTime = WorldInfo.TimeSeconds - float(1);
                }
            }
        }
    }
    super(TurokMPGame).ScoreKill(Killer, Victim);
    //return;    
}

defaultproperties
{
    HUDType=Class'TurokTeamDMHud'
}