class TDMGameReplicationInfo extends MOHAGameReplicationInfo
    native
    config(Game)
    hidecategories(Navigation,Movement,Collision);

simulated function PostBeginPlay()
{
    local MPObjective_FLAG mpFObj;
    local MOHAMP_FLAG_TriggerVolume mpFtrigger;
    local MultiplayerCinematicActor mpCinActor;
    local MOHAPlayerPlane_MP mpPlane;
    local MOHATeamPlayerStart_DM mpDMTeamPlayerStart;
    local MOHATeamPlayerStart mpTPstart;

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
    // End:0x74
    foreach DynamicActors(Class'MultiplayerCinematicActor', mpCinActor)
    {
        mpCinActor.ShutDown();        
    }    
    // End:0x99
    foreach DynamicActors(Class'MOHAPlayerPlane_MP', mpPlane)
    {
        mpPlane.ShutDown();        
    }    
    // End:0xEE
    foreach AllActors(Class'MOHATeamPlayerStart', mpTPstart)
    {
        mpDMTeamPlayerStart = MOHATeamPlayerStart_DM(mpTPstart);
        // End:0xED
        if((mpTPstart.bLegacyPlayerStart == false) && mpDMTeamPlayerStart == none)
        {
            mpTPstart.bEnabled = false;
        }        
    }    
    //return;    
}

simulated function string GetModeAbbr()
{
    return "DM";
    //return ReturnValue;    
}

defaultproperties
{
    PostGameScoreBoardType=Class'MOHAScoreboard_DM'
    InGameScoreBoardType=Class'MOHAScoreboard_DM'
    GameClass=Class'TeamDeathMatchGameInfo'
}