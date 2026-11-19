class TurokFEPauseMenuMP extends TurokFEPauseMenuBase
    native;

const PAUSEMENU_MP_Resume = 0;
const PAUSEMENU_MP_OptionsController = 1;
const PAUSEMENU_MP_OptionsAdvanced = 2;
const PAUSEMENU_MP_Quit = 3;

event SCInitialized()
{
    super.SCInitialized();
    TheOptionsMenu.SetItemDelegate(0, PAUSEMENU_ResumeDelegate);
    TheOptionsMenu.SetItemDelegate(1, PAUSEMENU_Options_ControllerDelegate);
    TheOptionsMenu.SetItemDelegate(2, PAUSEMENU_Options_AdvancedDelegate);
    TheOptionsMenu.SetItemDelegate(3, PAUSEMENU_QuitDelegate);
    TheOptionsMenu.PostSetupInitialize();
    TheOptionsMenu.StartFadeIn();
    // End:0x154
    if(((GetEngine().GamePlayers[0] != none) && GetEngine().GamePlayers[0].Actor != none) && TurokPlayerController(GetEngine().GamePlayers[0].Actor).myHUD != none)
    {
        TurokHud(TurokPlayerController(GetEngine().GamePlayers[0].Actor).myHUD).bShowHUD = false;
    }
    //return;    
}

function Quit()
{
    super.Quit();
    // End:0x8A
    if((GetEngine().GamePlayers[0] != none) && GetEngine().GamePlayers[0].ViewportClient != none)
    {        
        GetEngine().GamePlayers[0].ViewportClient.ConsoleCommand("DEFER DISCONNECT");
    }
    //return;    
}

function PAUSEMENU_QuitDelegate()
{
    local @NULL dlg, Lobby;

    SetHasFocus(false);
    dlg = TurokUIDialog(SceneClient.SceneControllerMgr.FindSceneController("Dialog"));
    // DebugMode: 0
    assert(dlg != none);
    Lobby = Class'Engine.Engine'.static.GetTurokNet().GetLobby();
    // End:0xF0
    if(((Class'Engine.Engine'.static.IsPS3() != true) && Lobby != none) && Lobby.GetGameResults().IsRanked())
    {
        dlg.OpenPopup(SceneClient, 2, 0, 1677390535, 544201488, -1644903683, 0, Quit, TakeFocus, None, 1);        
    }
    else
    {
        dlg.OpenPopup(SceneClient, 2, 0, 1620569518, 544201488, -1644903683, 0, Quit, TakeFocus, None, 1);
    }
    //return;    
}

event CloseMenu(bool isResume)
{
    // End:0xB2
    if(((GetEngine().GamePlayers[0] != none) && GetEngine().GamePlayers[0].Actor != none) && TurokPlayerController(GetEngine().GamePlayers[0].Actor).myHUD != none)
    {
        TurokHud(TurokPlayerController(GetEngine().GamePlayers[0].Actor).myHUD).bShowHUD = true;
    }
    super.CloseMenu(isResume);
    //return;    
}

defaultproperties
{
    SceneName="TurokFEPauseMenuFlowMP.PauseMenu.PauseMenu"
}