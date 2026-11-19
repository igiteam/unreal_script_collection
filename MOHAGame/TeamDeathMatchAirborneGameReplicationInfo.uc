class TeamDeathMatchAirborneGameReplicationInfo extends AirborneModeGameReplicationInfo
    native
    config(Game)
    hidecategories(Navigation,Movement,Collision);

simulated function PostBeginPlay()
{
    local MPObjective_FLAG mpFObj;
    local MOHAMP_FLAG_TriggerVolume mpFtrigger;
    local MOHATeamPlayerStart mpTPstart;
    local MOHATeamPlayerStart_ADM mpADMTeamPlayerStart;

    super.PostBeginPlay();
    // End:0x2A
    foreach DynamicActors(Class'MPObjective_FLAG', mpFObj)
    {
        mpFObj.ShutDown();        
    }    
    // End:0x4F
    foreach AllActors(Class'MOHAMP_FLAG_TriggerVolume', mpFtrigger)
    {
        mpFtrigger.ShutDown();        
    }    
    // End:0xA4
    foreach AllActors(Class'MOHATeamPlayerStart', mpTPstart)
    {
        mpADMTeamPlayerStart = MOHATeamPlayerStart_ADM(mpTPstart);
        // End:0xA3
        if((mpTPstart.bLegacyPlayerStart == false) && mpADMTeamPlayerStart == none)
        {
            mpTPstart.bEnabled = false;
        }        
    }    
    //return;    
}

simulated function string GetModeAbbr()
{
    return "ADM";
    //return ReturnValue;    
}

defaultproperties
{
    PostGameScoreBoardType=Class'MOHAScoreboard_DM'
    InGameScoreBoardType=Class'MOHAScoreboard_DM'
    GameClass=Class'TeamDeathMatchAirborneGameInfo'
}