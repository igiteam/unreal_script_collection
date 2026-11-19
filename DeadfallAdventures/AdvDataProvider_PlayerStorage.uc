class AdvDataProvider_PlayerStorage extends UIDataProvider_OnlinePlayerStorage
    transient
    config(Game)
    hidecategories(Object,UIRoot);

var AdvLocalPlayer LocPlayer;
var bool bIsShowingDeviceSelection;
var bool StorageDeviceChangeWithLoggedProfileOccured;

event OnRegister(LocalPlayer InPlayer)
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;

    LocPlayer = AdvLocalPlayer(InPlayer);
    super.OnRegister(InPlayer);
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    PlayerInterface = OnlineSub.PlayerInterface;
    // End:0xF1
    if(NotEqual_InterfaceInterface(PlayerInterface, OnlinePlayerInterface(none)))
    {
        PlayerInterface.AddWriteProfileSettingsCompleteDelegate(byte(LocPlayer.ControllerId), OnProfileWriteComplete);
    }
    //return;    
}

event OnUnregister()
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;

    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    PlayerInterface = OnlineSub.PlayerInterface;
    // End:0xC2
    if(NotEqual_InterfaceInterface(PlayerInterface, OnlinePlayerInterface(none)))
    {
        PlayerInterface.ClearWriteProfileSettingsCompleteDelegate(byte(LocPlayer.ControllerId), OnProfileWriteComplete);
    }
    super.OnUnregister();
    //return;    
}

function OnProfileWriteComplete(byte LocalUserNum, bool bWasSuccessful)
{
    local AdvUIManager UIManager;
    local array<name> ButtonAliases;

    UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0x17A
    if(!bWasSuccessful)
    {
        // End:0x177
        if(!UIManager.IsUIMessageActive('StorageDeviceRemovalWithLoggedProfile', LocPlayer))
        {
            ButtonAliases.AddItem('GenericAccept');            
            UIManager.ShowUIMessage('StorageDeviceRemovalWithLoggedProfile', Localize("MessageBoxErrorStrings", "StorageDeviceLost_Title", "ADVGame"), Localize("MessageBoxErrorStrings", "StorageDeviceRemovalWithLoggedProfile", "ADVGame"), ButtonAliases, None, LocPlayer,, 80, false, false, false,, true);
        }        
    }
    else
    {
        UIManager.ClearUIMessage('StorageDeviceRemovalWithLoggedProfile', LocPlayer);
    }
    Class'AdvUIManager'.static.CloseUpdatingScene();
    //return;    
}

function bool IsControllerReturningToMainMenu()
{
    return AdvPlayerController(LocPlayer.Actor).bIsReturningToMainMenu;
    //return ReturnValue;    
}

function bool IsControllerAtMenu()
{
    local bool bResult;

    bResult = ClassIsChildOf(LocPlayer.Actor.Class, Class'ADVMenuPC');
    return bResult;
    //return ReturnValue;    
}

function bool IsMenuLevelLoading()
{
    local bool bResult;

    bResult = LocPlayer.Actor.WorldInfo.IsMenuLevel();
    return bResult;
    //return ReturnValue;    
}

function bool IsInStartupSequence()
{
    local AdvFrontEnd Frontend;

    Frontend = Class'AdvFrontEnd'.static.GetFrontEnd();
    return (Frontend != none) && Frontend.bIsInStartupProcess;
    //return ReturnValue;    
}

function bool IsInMainMenu()
{
    local AdvFrontEnd Frontend;

    Frontend = Class'AdvFrontEnd'.static.GetFrontEnd();
    return (Frontend != none) && Frontend.CurrentScene == Frontend.MainMenu;
    //return ReturnValue;    
}

function RefreshStorageData()
{
    local OnlineSubsystem OnlineSub;
    local bool bFoundCachedData;
    local string CurrentMovieName;
    local AdvPlayerController PC;

    PC = AdvPlayerController(LocPlayer.Actor);
    // End:0x281
    if(LocPlayer.bHasSeenStartScreen)
    {
        // End:0x275
        if(!bIsExternalUIOpen)
        {
            OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
            // End:0x272
            if(((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none))) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterfaceEx, OnlinePlayerInterfaceEx(none)))
            {
                // End:0x231
                if((LocPlayer != none) && !LocPlayer.bWantsToSkipSaves)
                {
                    bFoundCachedData = GetData(OnlineSub.PlayerInterface, byte(PlayerControllerId));
                    // End:0x22E
                    if(!bFoundCachedData || bFoundCachedData && !OnlineSub.PlayerInterfaceEx.IsDeviceValid(Profile.DeviceID, DeviceStorageSizeNeeded))
                    {
                        PC.GetCurrentMovie(CurrentMovieName);
                        ShowDeviceSelection();
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
    local AdvUIManager UIManager;
    local array<name> ButtonAliases;
    local string MessageString;
    local AdvPRI LocalPRI1, LocalPRI2;
    local AdvPlayerController GPC;
    local bool bHasEnoughSpace;
    local AdvFrontEnd Frontend;

    bNeedsDeferredRefresh = false;
    bIsShowingDeviceSelection = false;
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    OnlineSub.PlayerInterfaceEx.ClearDeviceSelectionDoneDelegate(byte(PlayerControllerId), OnDeviceSelectionComplete);
    Profile.DeviceID = OnlineSub.PlayerInterfaceEx.GetDeviceSelectionResults(byte(PlayerControllerId), Ignored);
    // End:0x4A1
    if((bWasSuccessful && !OnlineSub.PlayerInterface.IsGuestLogin(byte(PlayerControllerId))) && Profile.DeviceID != -1)
    {
        LocPlayer.bWantsToSkipSaves = false;
        LocPlayer.bPrimaryDeviceEjected = false;
        bHasEnoughSpace = OnlineSub.PlayerInterfaceEx.IsDeviceValid(Profile.DeviceID, DeviceStorageSizeNeeded);
        // End:0x294
        if(bHasEnoughSpace)
        {
            // End:0x291
            if((ReadData(OnlineSub.PlayerInterface, byte(PlayerControllerId), Profile.DeviceID, Profile)) == false)
            {                
            }            
        }
        else
        {
            UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
            Class'AdvGfxMoviePlayer'.static.GetLocalPRIs(LocalPRI1, LocalPRI2);
            GPC = AdvPlayerController(LocPlayer.Actor);
            MessageString = (Class'AdvGfxMoviePlayer'.static.GetFormattedPlayerName(AdvPRI(GPC.PlayerReplicationInfo), LocalPRI1, LocalPRI2, true) $ "\n\n") $ "<Strings:ADVGame.MessageBoxErrorStrings.NotEnoughSpace_Message>";
            ButtonAliases.AddItem('AcceptSelectDevice');            
            ButtonAliases.AddItem('CancelContinueAnyway');            
            UIManager.ShowUIMessage('StorageError', Localize("MessageBoxErrorStrings", "NotEnoughSpace_Title", "ADVGame"), MessageString, ButtonAliases, OnSelectDeviceChosen, LocPlayer,, 110, false, false, false,, true);
        }        
    }
    else
    {
        UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
        // End:0x7B2
        if(((UIManager != none) && int(OnlineSub.PlayerInterface.GetLoginStatus(byte(PlayerControllerId))) > int(0)) && !OnlineSub.PlayerInterface.IsGuestLogin(byte(PlayerControllerId)))
        {
            // End:0x5E3
            if(IsInMainMenu())
            {
                Frontend = Class'AdvFrontEnd'.static.GetFrontEnd();
                Frontend.MainMenu.TryTransitionToSaveSlotMenu();                
            }
            else
            {
                Class'AdvGfxMoviePlayer'.static.GetLocalPRIs(LocalPRI1, LocalPRI2);
                GPC = AdvPlayerController(LocPlayer.Actor);
                MessageString = (Class'AdvGfxMoviePlayer'.static.GetFormattedPlayerName(AdvPRI(GPC.PlayerReplicationInfo), LocalPRI1, LocalPRI2, true) $ "\n\n") $ "<Strings:ADVGame.MessageBoxErrorStrings.NoDevice_Message>";
                ButtonAliases.AddItem('AcceptSelectDevice');                
                ButtonAliases.AddItem('CancelContinueAnyway');                
                UIManager.ShowUIMessage('StorageError', Localize("MessageBoxErrorStrings", "NoDevice_Title", "ADVGame"), MessageString, ButtonAliases, OnSelectDeviceChosen, LocPlayer,, 110, false, false, false,, true);
            }            
        }
        else
        {
            LocPlayer.bWantsToSkipSaves = true;
            Profile.DeviceID = -1;
        }
    }
    //return;    
}

function bool OnSelectDeviceChosen(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    local OnlineSubsystem OnlineSub;
    local AdvUIManager UIManager;

    LocPlayer.bPrimaryDeviceEjected = false;
    // End:0x45
    if(SelectedInputAlias == 'AcceptSelectDevice')
    {
        ShowDeviceSelection();        
    }
    else
    {
        // End:0x1C1
        if(SelectedInputAlias == 'CancelContinueAnyway')
        {
            // End:0x1C1
            if(LocPlayer != none)
            {
                UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
                // End:0x103
                if(UIManager.IsUIMessageActive('StorageOverWrite', LocPlayer))
                {
                    UIManager.ClearUIMessage('StorageOverWrite', LocPlayer, true);
                }
                LocPlayer.bWantsToSkipSaves = true;
                Profile.DeviceID = -1;
                OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
                // End:0x1C1
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
    // End:0x206
    if(((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none))) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterfaceEx, OnlinePlayerInterfaceEx(none)))
    {
        // End:0x1FB
        if((int(OnlineSub.PlayerInterface.GetLoginStatus(byte(PlayerControllerId))) > int(0)) && !OnlineSub.PlayerInterface.IsGuestLogin(byte(PlayerControllerId)))
        {
            bIsShowingDeviceSelection = true;
            OnlineSub.PlayerInterfaceEx.AddDeviceSelectionDoneDelegate(byte(PlayerControllerId), OnDeviceSelectionComplete);
            OnlineSub.PlayerInterfaceEx.ShowDeviceSelectionUI(byte(PlayerControllerId), 0, true);
            LocPlayer.bPrimaryDeviceEjected = false;            
        }
        else
        {
            OnDeviceSelectionComplete(false);
        }
    }
    //return;    
}

function OnStorageDeviceChange()
{
    local OnlineSubsystem OnlineSub;
    local AdvUIManager UIManager;
    local AdvEngine Eng;
    local AdvPlayerController PC;

    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x5A8
    if(((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none))) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterfaceEx, OnlinePlayerInterfaceEx(none)))
    {
        // End:0x476
        if((((!bIsShowingDeviceSelection && LocPlayer.bHasSeenStartScreen) && !LocPlayer.bWantsToSkipSaves) && LocPlayer.bCanShowStorageDeviceWarning) && !OnlineSub.PlayerInterfaceEx.IsDeviceValid(Profile.DeviceID, DeviceStorageSizeNeeded))
        {
            Eng = AdvEngine(Class'Engine.Engine'.static.GetEngine());
            UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
            // End:0x476
            if(((UIManager != none) && int(OnlineSub.PlayerInterface.GetLoginStatus(byte(PlayerControllerId))) > int(0)) && !OnlineSub.PlayerInterface.IsGuestLogin(byte(PlayerControllerId)))
            {
                Profile.DeviceID = -1;
                PC = AdvPlayerController(LocPlayer.Actor);
                // End:0x476
                if((PC != none) && PC.IsPrimaryPlayer())
                {
                    // End:0x41A
                    if((IsControllerAtMenu()) && int(Eng.GetEngineState()) != int(3))
                    {
                        // End:0x393
                        if(!LocPlayer.bPrimaryDeviceEjected)
                        {
                            LocPlayer.bPrimaryDeviceEjectedAtMenu = true;
                        }
                        // End:0x417
                        if(!IsInStartupSequence() && !Eng.IsInputBlockingSceneInList(0))
                        {
                            // End:0x417
                            if(!UIManager.IsUIMessageActive('StorageError'))
                            {
                                LocPlayer.OnIllegalPrimaryDeviceRemove();
                            }
                        }                        
                    }
                    else
                    {
                        // End:0x462
                        if(Eng.IsInputBlockingSceneInList(5))
                        {
                            LocPlayer.bPrimaryDeviceEjectedAtMenu = true;                            
                        }
                        else
                        {
                            ShowNoPrimaryStorageMessageWithReselectOptions(LocPlayer, false);
                        }
                    }
                }
            }
        }
        // End:0x5A8
        if((int(OnlineSub.PlayerInterface.GetLoginStatus(byte(PlayerControllerId))) > int(0)) && !OnlineSub.PlayerInterface.IsGuestLogin(byte(PlayerControllerId)))
        {
            UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
            UIManager.OpenUpdatingScene(,,,, 1.0000000,, Class'UIScene_BusyWithoutCaptureInput');
            AdvPlayerController(LocPlayer.Actor).SaveProfile();
        }
    }
    //return;    
}

simulated function ShowNoPrimaryStorageMessageWithReselectOptions(AdvLocalPlayer LP, bool bCalledFromGame)
{
    local array<name> ButtonAliases;
    local AdvUIManager UIManager;
    local string MessageString;
    local AdvPRI LocalPRI1, LocalPRI2;
    local AdvPlayerController GPC;

    Class'AdvGfxMoviePlayer'.static.GetLocalPRIs(LocalPRI1, LocalPRI2);
    GPC = AdvPlayerController(LP.Actor);
    MessageString = (Class'AdvGfxMoviePlayer'.static.GetFormattedPlayerName(AdvPRI(GPC.PlayerReplicationInfo), LocalPRI1, LocalPRI2, true) $ "\n") $ "<Strings:ADVGame.MessageBoxErrorStrings.NoPrimaryDevice_Message>";
    // End:0x13E
    if(!bCalledFromGame)
    {
        LP.bPrimaryDeviceEjected = true;
    }
    UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0x1D6
    if(UIManager.IsUIMessageActive('StorageOverWrite', LP))
    {
        UIManager.ClearUIMessage('StorageOverWrite', LP, true);
    }
    ButtonAliases.AddItem('AcceptSelectDevice');    
    ButtonAliases.AddItem('CancelContinueAnyway');    
    UIManager.ShowUIMessage('StorageError', Localize("MessageBoxErrorStrings", "NoPrimaryDevice", "ADVGame"), MessageString, ButtonAliases, OnRemovedDeviceChosen, LocPlayer,, 110, false, false, false,, true);
    //return;    
}

function bool OnRemovedDeviceChosen(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    LocPlayer.bPrimaryDeviceEjected = false;
    // End:0x45
    if(SelectedInputAlias == 'AcceptSelectDevice')
    {
        ShowDeviceSelection();        
    }
    else
    {
        // End:0xB0
        if(SelectedInputAlias == 'CancelContinueAnyway')
        {
            // End:0xB0
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
