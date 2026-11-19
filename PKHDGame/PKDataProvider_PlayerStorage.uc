class PKDataProvider_PlayerStorage extends UIDataProvider_OnlinePlayerStorage
    transient
    config(Game)
    hidecategories(Object,UIRoot);

var PKLocalPlayer LocPlayer;
var bool bIsShowingDeviceSelection;

event OnRegister(LocalPlayer InPlayer)
{
    LocPlayer = PKLocalPlayer(InPlayer);
    super.OnRegister(InPlayer);
    //return;    
}

function RefreshStorageData()
{
    local OnlineSubsystem OnlineSub;
    local bool bFoundCachedData;
    local string CurrentMovieName;
    local PKPlayerController PC;

    PC = PKPlayerController(LocPlayer.Actor);
    // End:0x2B6
    if(LocPlayer.bHasSeenStartScreen)
    {
        // End:0x2AA
        if(!bIsExternalUIOpen)
        {
            OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
            // End:0x2A7
            if(((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none))) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterfaceEx, OnlinePlayerInterfaceEx(none)))
            {
                // End:0x266
                if((LocPlayer != none) && !LocPlayer.bWantsToSkipSaves)
                {
                    bFoundCachedData = GetData(OnlineSub.PlayerInterface, byte(PlayerControllerId));
                    // End:0x263
                    if(!bFoundCachedData || bFoundCachedData && !OnlineSub.PlayerInterfaceEx.IsDeviceValid(Profile.DeviceID, DeviceStorageSizeNeeded))
                    {
                        PC.GetCurrentMovie(CurrentMovieName);
                        // End:0x263
                        if(Class'Engine.WorldInfo'.static.IsMenuLevel() && CurrentMovieName == "")
                        {
                            ShowDeviceSelection();
                        }
                    }                    
                }
                else
                {
                    ReadData(OnlineSub.PlayerInterface, byte(PlayerControllerId), -1, Profile);
                }
            }            
        }
        else
        {
            bNeedsDeferredRefresh = true;
        }
    }
    //return;    
}

function OnDeviceSelectionComplete(bool bWasSuccessful)
{
    local OnlineSubsystem OnlineSub;
    local string Ignored;
    local PKUIManager UIManager;
    local array<name> ButtonAliases;
    local string MessageString;
    local PainPRI LocalPRI1, LocalPRI2;
    local PKPlayerController GPC;
    local bool bHasEnoughSpace;

    bNeedsDeferredRefresh = false;
    bIsShowingDeviceSelection = false;
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    OnlineSub.PlayerInterfaceEx.ClearDeviceSelectionDoneDelegate(byte(PlayerControllerId), OnDeviceSelectionComplete);
    // End:0x40C
    if(bWasSuccessful)
    {
        LocPlayer.bWantsToSkipSaves = false;
        Profile.DeviceID = OnlineSub.PlayerInterfaceEx.GetDeviceSelectionResults(byte(PlayerControllerId), Ignored);
        bHasEnoughSpace = OnlineSub.PlayerInterfaceEx.IsDeviceValid(Profile.DeviceID, DeviceStorageSizeNeeded);
        // End:0x1FF
        if(bHasEnoughSpace)
        {
            // End:0x1FC
            if((ReadData(OnlineSub.PlayerInterface, byte(PlayerControllerId), Profile.DeviceID, Profile)) == false)
            {
            }            
        }
        else
        {
            UIManager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
            Class'PKGfxMoviePlayer'.static.GetLocalPRIs(LocalPRI1, LocalPRI2);
            GPC = PKPlayerController(LocPlayer.Actor);
            MessageString = (Class'PKGfxMoviePlayer'.static.GetFormattedPlayerName(PainPRI(GPC.PlayerReplicationInfo), LocalPRI1, LocalPRI2, true) $ "\n") $ "<Strings:PKHDGame.MessageBoxErrorStrings.NotEnoughSpace_Message>";
            ButtonAliases.AddItem('AcceptSelectDevice');
            ButtonAliases.AddItem('CancelContinueAnyway');
            UIManager.ShowUIMessage('StorageError', Localize("MessageBoxErrorStrings", "NotEnoughSpace_Title", "PKHDGame"), MessageString, ButtonAliases, OnSelectDeviceChosen, LocPlayer,, 110, false, false, true,, true);
        }        
    }
    else
    {
        UIManager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
        // End:0x6B0
        if(((UIManager != none) && int(OnlineSub.PlayerInterface.GetLoginStatus(byte(PlayerControllerId))) > int(0)) && !OnlineSub.PlayerInterface.IsGuestLogin(byte(PlayerControllerId)))
        {
            Class'PKGfxMoviePlayer'.static.GetLocalPRIs(LocalPRI1, LocalPRI2);
            GPC = PKPlayerController(LocPlayer.Actor);
            MessageString = (Class'PKGfxMoviePlayer'.static.GetFormattedPlayerName(PainPRI(GPC.PlayerReplicationInfo), LocalPRI1, LocalPRI2, true) $ "\n") $ "<Strings:PKHDGame.MessageBoxErrorStrings.NoDevice_Message>";
            ButtonAliases.AddItem('AcceptSelectDevice');
            ButtonAliases.AddItem('CancelContinueAnyway');
            UIManager.ShowUIMessage('StorageError', Localize("MessageBoxErrorStrings", "NoDevice_Title", "PKHDGame"), MessageString, ButtonAliases, OnSelectDeviceChosen, LocPlayer,, 110, false, false, true,, true);            
        }
        else
        {
            LocPlayer.bWantsToSkipSaves = true;
        }
    }
    //return;    
}

function bool OnSelectDeviceChosen(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    local OnlineSubsystem OnlineSub;

    // End:0x24
    if(SelectedInputAlias == 'AcceptSelectDevice')
    {
        ShowDeviceSelection();        
    }
    else
    {
        // End:0xC3
        if(SelectedInputAlias == 'CancelContinueAnyway')
        {
            // End:0xC3
            if(LocPlayer != none)
            {
                OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
                // End:0xC3
                if(OnlineSub != none)
                {
                    ReadData(OnlineSub.PlayerInterface, byte(PlayerControllerId), -1, Profile);
                }
            }
        }
    }
    return true;
    //return ReturnValue;    
}

function OnLoginChange(byte LocalUserNum)
{
    local OnlineSubsystem OnlineSub;
    local OnlineSubsystem.ELoginStatus LoginStatus;

    // End:0x178
    if(int(LocalUserNum) == PlayerControllerId)
    {
        // End:0x6A
        if(LocPlayer != none)
        {
            LocPlayer.bWantsToSkipSaves = false;
            LocPlayer.bHasSeenStartScreen = false;
        }
        OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
        // End:0x178
        if(OnlineSub != none)
        {
            // End:0x178
            if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
            {
                LoginStatus = OnlineSub.PlayerInterface.GetLoginStatus(byte(PlayerControllerId));
                // End:0x178
                if(int(LoginStatus) == int(0))
                {
                    Profile.SetToDefaults();
                    Profile.DeviceID = -1;
                }
            }
        }
    }
    //return;    
}

function ShowDeviceSelection()
{
    local OnlineSubsystem OnlineSub;

    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0xB1
    if(((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none))) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterfaceEx, OnlinePlayerInterfaceEx(none)))
    {
        OnDeviceSelectionComplete(true);
    }
    //return;    
}

function OnStorageDeviceChange()
{
    local OnlineSubsystem OnlineSub;
    local PKUIManager UIManager;
    local array<name> ButtonAliases;
    local string MessageString;
    local PainPRI LocalPRI1, LocalPRI2;
    local PKPlayerController GPC;

    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x40B
    if(((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none))) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterfaceEx, OnlinePlayerInterfaceEx(none)))
    {
        // End:0x40B
        if(((!bIsShowingDeviceSelection && LocPlayer.bHasSeenStartScreen) && !LocPlayer.bWantsToSkipSaves) && !OnlineSub.PlayerInterfaceEx.IsDeviceValid(Profile.DeviceID, DeviceStorageSizeNeeded))
        {
            UIManager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
            // End:0x40B
            if(((UIManager != none) && int(OnlineSub.PlayerInterface.GetLoginStatus(byte(PlayerControllerId))) > int(0)) && !OnlineSub.PlayerInterface.IsGuestLogin(byte(PlayerControllerId)))
            {
                Class'PKGfxMoviePlayer'.static.GetLocalPRIs(LocalPRI1, LocalPRI2);
                GPC = PKPlayerController(LocPlayer.Actor);
                MessageString = (Class'PKGfxMoviePlayer'.static.GetFormattedPlayerName(PainPRI(GPC.PlayerReplicationInfo), LocalPRI1, LocalPRI2, true) $ "\n") $ "<Strings:PKHDGame.MessageBoxErrorStrings.NoPrimaryDevice_Message>";
                ButtonAliases.AddItem('AcceptSelectDevice');
                ButtonAliases.AddItem('CancelContinueAnyway');
                UIManager.ShowUIMessage('StorageError', Localize("MessageBoxErrorStrings", "NoPrimaryDevice", "PKHDGame"), MessageString, ButtonAliases, OnRemovedDeviceChosen, LocPlayer,, 110, false, false, true,, true);
            }
        }
    }
    //return;    
}

function bool OnRemovedDeviceChosen(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    // End:0x24
    if(SelectedInputAlias == 'AcceptSelectDevice')
    {
        ShowDeviceSelection();        
    }
    else
    {
        // End:0x8F
        if(SelectedInputAlias == 'CancelContinueAnyway')
        {
            // End:0x8F
            if(LocPlayer != none)
            {
                LocPlayer.bWantsToSkipSaves = true;
                Profile.DeviceID = -1;
            }
        }
    }
    return true;
    //return ReturnValue;    
}
