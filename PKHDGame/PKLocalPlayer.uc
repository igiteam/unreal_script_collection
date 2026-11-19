class PKLocalPlayer extends EvilLocalPlayer within Engine
    transient
    config(Engine);

var bool bAchievementsMasksResetComplete;
var bool bPrimaryDeviceEjected;
var bool bWantsToSkipSaves;
var bool bHasSeenStartScreen;
var transient bool bPartyTypeUpdated;
var bool bIsFirstFrontEndLoad;
//var delegate<OnDestroySessionComplete> __OnDestroySessionComplete__Delegate;

delegate OnDestroySessionComplete(name SessionName, bool bWasSuccessful)
{
    //return;    
}

function DeleteSession(name SessionName, delegate<OnDestroySessionComplete> DestroyCompleteDelegate)
{
    local OnlineSubsystem OnlineSub;
    local OnlineGameSettings GameSettings;

    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x144
    if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
    {
        GameSettings = OnlineSub.GameInterface.GetGameSettings(SessionName);
        // End:0x144
        if(GameSettings != none)
        {
            OnlineSub.GameInterface.AddDestroyOnlineGameCompleteDelegate(DestroyCompleteDelegate);
            OnlineSub.GameInterface.DestroyOnlineGame(SessionName);
            return;
        }
    }
    OnDestroySessionComplete(SessionName, true);
    //return;    
}

defaultproperties
{
    bIsFirstFrontEndLoad=true
}