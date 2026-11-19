class UIAction_SkyLeaveOnlineGame extends UIAction;

event Activated()
{
    local OnlineSubsystem OnlineSub;
    local OnlineGameInterface GameInterface;

    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x68
    if(OnlineSub != none)
    {
        GameInterface = OnlineSub.GameInterface;
        // End:0x68
        if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
        {
            GameInterface.DestroyOnlineGame('None');
        }
    }
    //return;    
}
