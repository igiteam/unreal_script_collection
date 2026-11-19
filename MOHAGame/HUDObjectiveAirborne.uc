class HUDObjectiveAirborne extends HUDObjective
    transient
    config(Game)
    hidecategories(Navigation);

var bool InMenuPrompt;

function DrawHUD()
{
    super.DrawHUD();
    //return;    
}

function DrawHUDSpectator()
{
    local MOHAPlayerController PC;

    PC = MOHAPlayerController(PlayerOwner);
    SetSupertitleText(SpectatorModeMsg, true);
    // End:0xE0
    if(PC.PlayerCamera != none)
    {
        // End:0xE0
        if((Pawn(PC.PlayerCamera.ViewTarget.Target) != none) && Pawn(PC.PlayerCamera.ViewTarget.Target).PlayerReplicationInfo != none)
        {
            SetExtraText(FollowingMsg @ Pawn(PC.PlayerCamera.ViewTarget.Target).PlayerReplicationInfo.PlayerName);
        }
    }
    //return;    
}
