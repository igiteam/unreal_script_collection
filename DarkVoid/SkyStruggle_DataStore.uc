class SkyStruggle_DataStore extends UIDataStore_OnlineGameSettings
    transient
    native;

event bool CreateGame(byte ControllerIndex)
{
    local OnlineSubsystem OnlineSub;
    local bool bSuccess;

    bSuccess = super.CreateGame(ControllerIndex);
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x53
    if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterfaceEx, OnlinePlayerInterfaceEx(none)))
    {
    }
    return bSuccess;
    //return ReturnValue;    
}
