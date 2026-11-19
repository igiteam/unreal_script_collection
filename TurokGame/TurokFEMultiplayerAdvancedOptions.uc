class TurokFEMultiplayerAdvancedOptions extends TurokUISceneController
    native;

var @NULL mList;
var float fOptionHighlightScale;
var float fOptionUnHighlightScale;
var @NULL mOverlayEdges[2];
var @NULL TheMenu;

// Export UTurokFEMultiplayerAdvancedOptions::execInitialize(FFrame&, void* const)
native function Initialize(@NULL newScene, @NULL curSceneClient);

event SCInitialized()
{
    TheMenu = TurokUIMenu(Scene.FindChild(name("PCOptionsMenu"), true));
    TheMenu.SetItemDelegate(0, OnSave);
    TheMenu.SetItemDelegate(1, OnCancel);
    TheMenu.PostSetupInitialize();
    TheMenu.StartFadeIn();
    //return;    
}

event MultiAdvanced_CloseMenu()
{
    SetGameSettings();
    Class'Engine.Engine'.static.GetTurokNet().GetLobby().ModifyGameSettings();
    SceneClient.GoBackSceneController(1);
    //return;    
}

event HasFocus()
{
    super.HasFocus();
    Class'TurokEngine.TurokUIHelpBar'.static.Instance().Reset();
    Class'TurokEngine.TurokUIHelpBar'.static.Instance().Hide();
    Class'TurokEngine.TurokUIHelpBar'.static.Instance().Show(false);
    Class'TurokEngine.TurokUIHelpBar'.static.Instance().SetButton(1, -102177158);
    Class'TurokEngine.TurokUIHelpBar'.static.Instance().SetButton(2, 675426377);
    //return;    
}

event SCCleanUpOnExit()
{
    local int I;

    super.SCCleanUpOnExit();
    I = 0;
    J0x0D:

    // End:0x49 [Loop If]
    if(I < 2)
    {
        mOverlayEdges[I].Stop();
        mOverlayEdges[I] = none;
        ++I;
        // [Loop Continue]
        goto J0x0D;
    }
    //return;    
}

// Export UTurokFEMultiplayerAdvancedOptions::execInitOptionsList(FFrame&, void* const)
protected native final function InitOptionsList();

// Export UTurokFEMultiplayerAdvancedOptions::execSetGameSettings(FFrame&, void* const)
protected native final function SetGameSettings();

// Export UTurokFEMultiplayerAdvancedOptions::execOnSave(FFrame&, void* const)
native function OnSave();

// Export UTurokFEMultiplayerAdvancedOptions::execOnCancel(FFrame&, void* const)
native function OnCancel();

defaultproperties
{
    fOptionHighlightScale=0.4375000
    fOptionUnHighlightScale=0.3500000
    SceneName="TurokFEMultiplayer.AdvancedOptions.AdvancedOptions"
}