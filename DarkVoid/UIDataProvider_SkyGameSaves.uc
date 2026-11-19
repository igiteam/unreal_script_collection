class UIDataProvider_SkyGameSaves extends UIDataProvider_OnlinePlayerDataBase
    transient
    native;

struct native SkyGameSave
{
    var const string SaveFileName;
    var const string FriendlyName;
    var const string LevelName;
    var const string Description;

    structdefaultproperties
    {
        SaveFileName=""
        FriendlyName=""
        LevelName=""
        Description=""
    }
};

var private native const noexport Pointer VfTable_IUIListElementCellProvider;
var array<SkyGameSave> SaveGameList;
var int DeviceID;

// Export UUIDataProvider_SkyGameSaves::execGetSaveGames(FFrame&, void* const)
native final function bool GetSaveGames(int InDeviceID, int InPlayerID);

// Export UUIDataProvider_SkyGameSaves::execGetCurrentDeviceID(FFrame&, void* const)
native final function int GetCurrentDeviceID(int InPlayerID);

event UpdateCurrentDeviceID(int InPlayerID)
{
    local string DeviceName;
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterfaceEx PlayerInterfaceEx;
    local int SpaceAvail;

    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x86
    if(OnlineSub != none)
    {
        PlayerInterfaceEx = OnlineSub.PlayerInterfaceEx;
        // End:0x83
        if(NotEqual_InterfaceInterface(PlayerInterfaceEx, OnlinePlayerInterfaceEx(none)))
        {
            DeviceID = PlayerInterfaceEx.GetDeviceSelectionResults(byte(Player.ControllerId), DeviceName, SpaceAvail);            
        }        
    }
    //return;    
}

event OnRegister(LocalPlayer InPlayer)
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;

    super.OnRegister(InPlayer);
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x79
    if(OnlineSub != none)
    {
        PlayerInterface = OnlineSub.PlayerInterface;
        // End:0x76
        if(NotEqual_InterfaceInterface(PlayerInterface, OnlinePlayerInterface(none)))
        {
            PlayerInterface.AddLoginChangeDelegate(OnLoginChange);            
        }        
    }
    //return;    
}

event OnUnregister()
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;

    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x68
    if(OnlineSub != none)
    {
        PlayerInterface = OnlineSub.PlayerInterface;
        // End:0x68
        if(NotEqual_InterfaceInterface(PlayerInterface, OnlinePlayerInterface(none)))
        {
            PlayerInterface.ClearLoginChangeDelegate(OnLoginChange);
        }
    }
    super.OnUnregister();
    //return;    
}

event RefreshSaveGamesList(int InDeviceID, int InPlayerID)
{
    // End:0x16
    if(GetSaveGames(InDeviceID, InPlayerID) == false)
    {
    }
    NotifyPropertyChanged();
    //return;    
}

function OnLoginChange(byte LocalPlayerNum, OnlineSubsystem.ELoginChangeType Type)
{
    UpdateCurrentDeviceID(Player.ControllerId);
    SaveGameList.Length = 0;
    // End:0x41
    if(GetSaveGames(DeviceID, Player.ControllerId) == false)
    {
    }
    //return;    
}
