class UIAction_GetLoginStatus extends UIAction
    native;

/** Player to get online status for. */
var() int PlayerID;

event OnlineSubsystem.ELoginStatus GetLoginStatus(int ControllerId)
{
    local OnlineSubsystem.ELoginStatus Result;
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;

    Result = 0;
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x74
    if(OnlineSub != none)
    {
        PlayerInterface = OnlineSub.PlayerInterface;
        // End:0x74
        if(NotEqual_InterfaceInterface(PlayerInterface, OnlinePlayerInterface(none)))
        {
            Result = PlayerInterface.GetLoginStatus(byte(ControllerId));
        }
    }
    return Result;
    //return ReturnValue;    
}
