class UIAction_LoadSaveGame extends UIAction
    native;

enum ELoadGameState
{
    ELGS_Running,                   // 0
    ELGS_Cancelled,                 // 1
    ELGS_Loaded,                    // 2
    ELGS_Failed,                    // 3
    ELGS_MAX                        // 4
};

var() string Filename;
var string MapName;
var transient UIAction_LoadSaveGame.ELoadGameState LoadState;

event bool CheckDevice(int DeviceID)
{
    local OnlineSubsystem OnlineSub;
    local GameUISceneClient GSC;
    local UIScene S;

    // End:0x15
    if(Class'Engine.GameEngine'.static.IsConsumerDemo())
    {
        return true;
    }
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0xED
    if(OnlineSub != none)
    {
        // End:0xED
        if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterfaceEx, OnlinePlayerInterfaceEx(none)))
        {
            // End:0x81
            if(OnlineSub.PlayerInterfaceEx.IsDeviceValid(DeviceID))
            {
                return true;                
            }
            else
            {
                GSC = Class'Engine.UIRoot'.static.GetSceneClient();
                // End:0xED
                if(GSC != none)
                {
                    GSC.MessageBoxOpenByPath("UI.DefaultNotifyScene_devicemissing", S, none, DeviceSelectNotifyCallback);
                    return false;
                }
            }
        }
    }
    return true;
    //return ReturnValue;    
}

function bool DeviceSelectNotifyCallback(UIScreenObject EventObject, int iPlayer)
{
    LoadState = 1;
    return false;
    //return ReturnValue;    
}
