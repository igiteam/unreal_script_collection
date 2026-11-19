class TurokFEPauseMenu extends TurokFEPauseMenuBase
    native;

const PAUSEMENU_Resume = 0;
const PAUSEMENU_Restart = 1;
const PAUSEMENU_OptionsAudio = 2;
const PAUSEMENU_OptionsAdvanced = 3;
const PAUSEMENU_OptionsController = 4;
const PAUSEMENU_SaveProgress = 5;
const PAUSEMENU_Quit = 6;

enum eSaveProgressCaller
{
    CALLER_UNDEFINED,               // 0
    CALLER_PAUSEMENU,               // 1
    CALLER_CHECKPOINT,              // 2
    CALLER_CHAPTERPOINT,            // 3
    CALLER_MAX                      // 4
};

var byte mSaveProgressCaller;

// Export UTurokFEPauseMenu::execIsCheckpointValid(FFrame&, void* const)
native function bool IsCheckpointValid();

// Export UTurokFEPauseMenu::execSaveProgress(FFrame&, void* const)
native function SaveProgress(byte caller);

// Export UTurokFEPauseMenu::execSaveProgress_OnAccept(FFrame&, void* const)
native function SaveProgress_OnAccept();

// Export UTurokFEPauseMenu::execSaveProgress_OnWriteProfileComplete(FFrame&, void* const)
native function SaveProgress_OnWriteProfileComplete(byte ControllerId, bool bSuccessful);

// Export UTurokFEPauseMenu::execSaveProgress_OnSaveCheckpointComplete(FFrame&, void* const)
native function SaveProgress_OnSaveCheckpointComplete(int Status);

// Export UTurokFEPauseMenu::execSaveProgress_OnFinished(FFrame&, void* const)
native function SaveProgress_OnFinished();

event SCInitialized()
{
    local @NULL Profile;

    super.SCInitialized();
    TheOptionsMenu.SetItemDelegate(0, PAUSEMENU_ResumeDelegate);
    TheOptionsMenu.SetItemDelegate(1, PAUSEMENU_RestartDelegate);
    TheOptionsMenu.SetItemDelegate(4, PAUSEMENU_Options_ControllerDelegate);
    TheOptionsMenu.SetItemDelegate(2, PAUSEMENU_Options_AudioDelegate);
    TheOptionsMenu.SetItemDelegate(3, PAUSEMENU_Options_AdvancedDelegate);
    TheOptionsMenu.SetItemDelegate(5, PAUSEMENU_SaveProgressDelegate);
    TheOptionsMenu.SetItemDelegate(6, PAUSEMENU_QuitDelegate);
    TheOptionsMenu.PostSetupInitialize();
    Profile = TurokOnlineProfile(Class'Engine.TurokOnlineDashboard'.static.Instance().GetSignedInProfile());
    // End:0x13F
    if((Profile == none) || !IsCheckpointValid())
    {
        TheOptionsMenu.DisableItem(5, true);
    }
    TheOptionsMenu.StartFadeIn();
    TurokHud(TurokPlayerController(GetEngine().GamePlayers[0].Actor).myHUD).EnableColorCube();
    //return;    
}

function Restart()
{
    local @NULL lHud;

    lHud = TurokHud(TurokPlayerController(GetEngine().GamePlayers[0].Actor).myHUD);
    lHud.ShowScreenBlackout(1);
    SetHasFocus(true);
    // End:0xA1
    if(!RestartFromCheckpointOrChapterpoint())
    {
        SceneClient.Outer.Outer.ViewportConsole.ConsoleCommand("restartlevel");
    }
    CloseMenu(false);
    //return;    
}

function PAUSEMENU_RestartDelegate()
{
    local @NULL dlg;

    SetHasFocus(false);
    dlg = TurokUIDialog(SceneClient.SceneControllerMgr.FindSceneController("Dialog"));
    // DebugMode: 0
    assert(dlg != none);
    dlg.OpenPopup(SceneClient, 2, 0, -797428700, 544201488, -1644903683, 0, Restart, TakeFocus, None, 1);
    //return;    
}

function PAUSEMENU_SaveProgressDelegate()
{
    SaveProgress(1);
    //return;    
}

function PAUSEMENU_QuitDelegate()
{
    local @NULL dlg;

    SetHasFocus(false);
    dlg = TurokUIDialog(SceneClient.SceneControllerMgr.FindSceneController("Dialog"));
    // DebugMode: 0
    assert(dlg != none);
    dlg.OpenPopup(SceneClient, 2, 0, -69557803, 544201488, -1644903683, 0, Quit, TakeFocus, None, 1);
    //return;    
}

function Quit()
{
    super.Quit();
    SceneClient.SetFEInitialSceneStack(SceneClient.SceneControllerMgr.kPostSPGameScreenStack);
    SceneClient.Outer.Outer.ViewportConsole.ConsoleCommand("open fe_main");
    //return;    
}

event CloseMenu(bool isResume)
{
    TurokHud(TurokPlayerController(GetEngine().GamePlayers[0].Actor).myHUD).RestoreColorCube();
    super.CloseMenu(isResume);
    //return;    
}

defaultproperties
{
    SceneName="TurokFEPauseMenuFlow.PauseMenu.PauseMenu"
}