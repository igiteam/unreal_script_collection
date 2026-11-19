class UIScene_PauseMenu extends UIScene_BaseFrontEnd
    config(Game);

var config bool bHidePauseMenuBG;
var transient bool bOverrideEmulateButtonPress;
var int DatafileSize;
var transient int IsDone;
var transient int GameExists;
var transient int DataCorrupt;
var transient string ExitGameTitle;
var transient string ExitGameWarning_Message;
var transient string LoadCheckpointTitle;
var transient string LoadCheckpoint_Message;
var transient string NoSaveGameTitle;
var transient string NoSaveGameErr;
var transient string NoDeviceLoadErr;
var transient string NoDeviceLoadTitle;
var transient string CheckpointCorruptErr;
var transient string CheckpointCorruptTitle;
var transient string ExitMatchTitle;
var transient string ClientExitPlayerMatch_Message;
var transient string ServerExitPlayerMatch_Message;
var transient string ClientExitRankedMatch_Message;
var transient string ServerExitRankedMatch_Message;
var UILabel TitleLabel;

event InitScene()
{
    super.InitScene();
    // End:0x53
    if(int(GetWorldInfo().NetMode) != int(NM_Standalone))
    {
        GetPC().bIgnoreMoveInput = 1;
        GetPC().bIgnoreLookInput = 1;
    }
    bOverrideEmulateButtonPress = GameUISceneClient(SceneClient).bOverrideEmulateButtonPress;
    GameUISceneClient(SceneClient).bOverrideEmulateButtonPress = false;
    // End:0x15B
    if((myGameInfo != none) && myGameInfo.IsInCinematic())
    {
        // End:0x126
        if(MenuItems[MenuIndexByName("btnLoadLastCheckpoint")].MenuItemUIObject != none)
        {
            MenuItems[MenuIndexByName("btnLoadLastCheckpoint")].MenuItemUIObject.ActivateStateByClass(Class'Engine.UIState_Disabled', 0);
        }
        MenuItems[MenuIndexByName("btnLoadLastCheckpoint")].bDisabled = true;
    }
    // End:0x17B
    if(bHidePauseMenuBG)
    {
        HideBGImage();
        bHideMenuBG = bHidePauseMenuBG;
    }
    // End:0x1D0
    if(int(GetWorldInfo().NetMode) != int(NM_Standalone))
    {
        bPauseGameWhileActive = false;
        TitleLabel = UILabel(FindChild('lblTitle', true));
        TitleLabel.SetDataStoreBinding("");
    }
    ExitGameTitle = "<strings:PandoraGame.ErrorMessages.ExitGameWarning_Title>";
    // End:0x27A
    if(int(GetWorldInfo().NetMode) == int(NM_ListenServer))
    {
        ExitGameWarning_Message = "<Strings:PandoraGame.UIScene_PandoraLobbyMP.PromptQuitSrvrGame>";        
    }
    else
    {
        // End:0x2E1
        if(int(GetWorldInfo().NetMode) == int(NM_Client))
        {
            ExitGameWarning_Message = "<strings:PandoraGame.ErrorMessages.MPExitGameWarning_Message>";            
        }
        else
        {
            // End:0x33C
            if(Class'Engine.Engine'.static.IsSPDemoBuild())
            {
                ExitGameWarning_Message = "<strings:PandoraGame.ErrorMessages.MPExitGameWarning_Message>";                
            }
            else
            {
                ExitGameWarning_Message = "<strings:PandoraGame.ErrorMessages.ExitGameWarning_Message>";
            }
        }
    }
    NoSaveGameErr = PlatformStrings $ "ErrorMessages.NoSaveGame_Message>";
    //return;    
}

function OnClick(UIScene OpenedScene, int MenuIndex)
{
    local PandoraPlayerController PC;

    super.OnClick(OpenedScene, MenuIndex);
    PC = GetPC();
    // End:0x2B
    if(PC == none)
    {
    }
    // End:0x8B
    if(MenuIndex == (MenuIndexByName("btnResume")))
    {
        PlayUISound('SceneClosed');
        SceneClient.CloseScene(self);
        GameUISceneClient(SceneClient).bOverrideEmulateButtonPress = bOverrideEmulateButtonPress;        
    }
    else
    {
        // End:0xDB
        if(MenuIndex == (MenuIndexByName("btnLoadLastCheckpoint")))
        {
            ShowMsgBox(LoadCheckpoint_Message, LoadCheckpointTitle, 1, OnLoadCheckpointMsgResults);            
        }
        else
        {
            // End:0x102
            if(MenuIndex == (MenuIndexByName("btnExit")))
            {
                ExitGame();
            }
        }
    }
    //return;    
}

function bool ProcessCancelInput(const out InputEventParameters EventParms)
{
    // End:0x75
    if((IsInputCancel(EventParms)) || IsInputStart(EventParms))
    {
        PlayUISound('SceneClosed');
        ActivateRemoteEvent(OnExitRemoteEventName);
        SceneClient.CloseScene(self);
        GameUISceneClient(SceneClient).bOverrideEmulateButtonPress = bOverrideEmulateButtonPress;
        return true;
    }
    return false;
    //return ReturnValue;    
}

function OnLoadCheckpointMsgResults(int PlayerIndex, PandoraGRI.eMsgBoxResult eReturnValue)
{
    // End:0x76
    if((int(eReturnValue) == int(1)) || int(eReturnValue) == int(0))
    {
        // End:0x76
        if((myPC != none) && int(GetWorldInfo().NetMode) == int(NM_Standalone))
        {
            PlayUISound('SceneClosed');
            SceneClient.CloseScene(self);
            BaseLoadSavedGame();
        }
    }
    //return;    
}

function OnExitGameMsgResults(int PlayerIndex, PandoraGRI.eMsgBoxResult eReturnValue)
{
    // End:0xE7
    if((int(eReturnValue) == int(1)) || int(eReturnValue) == int(0))
    {
        PlayUISound('SceneClosed');
        // End:0x8E
        if(int(GetWorldInfo().NetMode) != int(NM_Standalone))
        {
            myPC.DestroySession();
            myPC.ClientTravel("pandorastart", 0);            
        }
        else
        {
            // End:0xE7
            if((LocPlayer != none) && LocPlayer.Actor != none)
            {                
                LocPlayer.Actor.ConsoleCommand("open PandoraStart");
            }
        }
    }
    //return;    
}

function CheckSavedGame()
{
    local PandoraPlayerController.EDeviceValidErrorCode CheckDeviceResult;
    local OnlineSubsystem.ELoginStatus LoginStatus;

    // End:0x12D
    if(myPC != none)
    {
        myPC.CheckStorageDevice(CheckDeviceResult);
        switch(CheckDeviceResult)
        {
            // End:0x76
            case 0:
                // End:0x73
                if(myPC.SPCM != none)
                {
                    myPC.SPCM.SavedGameExists(IsDone, GameExists, DataCorrupt);
                }
                // End:0x12D
                break;
            // End:0x7B
            case 2:
            // End:0x12A
            case 1:
                // End:0x127
                if(CurrMenuItemIdx == (MenuIndexByName("btnLoadLastCheckpoint")))
                {
                    LoginStatus = GetLoginStatus(LocPlayer.ControllerId);
                    // End:0xFF
                    if(int(LoginStatus) != int(0))
                    {
                        ShowMsgBox(NoDeviceLoadErr, NoDeviceLoadTitle, 1, OnNoDeviceSelectedMsgResults);                        
                    }
                    else
                    {
                        PlayUISound('SceneClosed');
                        SceneClient.CloseScene(self);
                        BaseLoadSavedGame();
                    }
                }
                // End:0x12D
                break;
            // End:0xFFFF
            default:
                break;
        }
    }
    else
    {
        //return;        
    }
}

event UpdateScene(float DeltaTime, WorldInfo WorldInfo)
{
    super.UpdateScene(DeltaTime, WorldInfo);
    // End:0xFE
    if(IsDone > 0)
    {
        IsDone = 0;
        // End:0xB9
        if(GameExists > 0)
        {
            GameExists = 0;
            // End:0xB6
            if(CurrMenuItemIdx == (MenuIndexByName("btnLoadLastCheckpoint")))
            {
                // End:0x8E
                if(DataCorrupt > 0)
                {
                    ShowMsgBox(CheckpointCorruptErr, CheckpointCorruptTitle, 0);
                    DataCorrupt = 0;                    
                }
                else
                {
                    PlayUISound('SceneClosed');
                    SceneClient.CloseScene(self);
                    BaseLoadSavedGame();
                }
            }            
        }
        else
        {
            // End:0xFE
            if(CurrMenuItemIdx == (MenuIndexByName("btnLoadLastCheckpoint")))
            {
                ShowMsgBox(NoSaveGameErr, NoSaveGameTitle, 0);
            }
        }
    }
    //return;    
}

function OnNoDeviceSelectedMsgResults(int PlayerIndex, PandoraGRI.eMsgBoxResult eReturnValue)
{
    // End:0x52
    if(((int(eReturnValue) == int(1)) || int(eReturnValue) == int(0)) && myPC != none)
    {
        myPC.SelectDevice(DatafileSize, NotifyDeviceSelectComplete);
    }
    //return;    
}

function NotifyDeviceSelectComplete(bool bWasSuccessful)
{
    local OnlinePlayerInterfaceEx PlayerInterfaceEx;

    // End:0x73
    if((myPC != none) && myPC.OnlineSub != none)
    {
        PlayerInterfaceEx = myPC.OnlineSub.PlayerInterfaceEx;
        PlayerInterfaceEx.ClearDeviceSelectionDoneDelegate(byte(LocPlayer.ControllerId), NotifyDeviceSelectComplete);        
    }
    super.NotifyDeviceSelectComplete(bWasSuccessful);
    // End:0x92
    if(bWasSuccessful)
    {
        CheckSavedGame();
    }
    //return;    
}

function ExitGame()
{
    local WorldInfo WI;
    local OnlineGameSettings Settings;
    local PandoraGRI PGRI;

    WI = GetWorldInfo();
    myPC.PlayerForceDelayedCheckpointSave();
    // End:0x31
    if(WI == none)
    {
        return;
    }
    Settings = WI.Game.GameSettings;
    PGRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0x7C
    if(PGRI == none)
    {
        return;
    }
    // End:0xA1
    if(Settings == none)
    {
        Settings = PGRI.GetPandoraGameSettings();
    }
    // End:0xE0
    if(int(WI.NetMode) == int(NM_Standalone))
    {
        ShowMsgBox(ExitGameWarning_Message, ExitGameTitle, 1, OnExitGameMsgResults);        
    }
    else
    {
        // End:0x176
        if(int(WI.NetMode) == int(NM_ListenServer))
        {
            // End:0x151
            if(WI.Game.bUsingArbitration || Settings.bUsesArbitration)
            {
                ShowMsgBox(ServerExitRankedMatch_Message, ExitMatchTitle, 1, OnExitGameMsgResults);                
            }
            else
            {
                ShowMsgBox(ServerExitPlayerMatch_Message, ExitMatchTitle, 1, OnExitGameMsgResults);
            }            
        }
        else
        {
            // End:0x1CD
            if(WI.Game.bUsingArbitration || Settings.bUsesArbitration)
            {
                ShowMsgBox(ClientExitRankedMatch_Message, ExitMatchTitle, 1, OnExitGameMsgResults);                
            }
            else
            {
                ShowMsgBox(ClientExitPlayerMatch_Message, ExitMatchTitle, 1, OnExitGameMsgResults);
            }
        }
    }
    //return;    
}

event SceneActivated(bool bInitialActivation)
{
    super.SceneActivated(bInitialActivation);
    myPC.PauseAmBxAmbientLighting();
    myPC.SetInPauseMenu();
    myPC.StopAllAmBxScripts();
    myPC.OnAmBxPauseAllWindEffects(true);
    myPC.StopAmbientRumble();
    //return;    
}

event SceneDeactivated()
{
    super.SceneDeactivated();
    // End:0x53
    if(int(GetWorldInfo().NetMode) != int(NM_Standalone))
    {
        GetPC().bIgnoreMoveInput = 0;
        GetPC().bIgnoreLookInput = 0;
    }
    myPC.OnAmBxPauseAllWindEffects(false);
    myPC.SetNOT_InPauseMenu();
    //return;    
}

function amBXPulseMenuItemChange()
{
    // End:0x31
    if(bSceneUsesAmBxEffects)
    {
        myPC.PlayAmBxScript("menu_pause_pulse", 100);
    }
    //return;    
}
