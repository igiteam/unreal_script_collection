class TurokMPTeamFlagIndicator extends TurokActorIndicator
    native
    config(Game)
    hidecategories(Navigation,Movement,Collision);

simulated function bool CanDraw(@NULL HUD)
{
    // DebugMode: 0
    assert(HUD != none);
    // DebugMode: 0
    assert(HUD.PlayerOwner != none);
    // DebugMode: 0
    assert(HUD.PlayerOwner.PlayerReplicationInfo != none);
    // DebugMode: 0
    assert(HUD.PlayerOwner.PlayerReplicationInfo.Team != none);
    return int(GetTeamNum()) == int(HUD.PlayerOwner.GetTeamNum());
    //return ReturnValue;    
}
