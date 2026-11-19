class UIAction_SkyCreateOnlineGame extends UIAction
    native;

var() name DataStoreName;
var() string MapName;
var() string Parameters;
var() bool bCoopGame;
var bool bIsDone;
var bool bSuccess;
var array<string> WeaponAliases;
var transient string ExecCmd;

function OnGameCreated(name SessionName, bool bWasSuccessful)
{
    bIsDone = true;
    bSuccess = bWasSuccessful;
    ClearCreateDelegate();
    //return;    
}

event SetCreateDelegate()
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
            GameInterface.AddCreateOnlineGameCompleteDelegate(OnGameCreated);
        }
    }
    //return;    
}

event ClearCreateDelegate()
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
            GameInterface.ClearCreateOnlineGameCompleteDelegate(OnGameCreated);
        }
    }
    //return;    
}

event string GetPlayerNameParam()
{
    return "";
    //return ReturnValue;    
}
