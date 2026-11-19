class TurokFEMultiplayerSelectWeaponSet extends TurokUISceneController
    native;

var bool bBlockInput;
var @NULL WeaponSetList;
var @NULL WeaponSetDescription;
var @NULL mOverlayEdges[2];
var @NULL TheMenu;

// Export UTurokFEMultiplayerSelectWeaponSet::execInitialize(FFrame&, void* const)
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

    SceneClient = none;
    I = 0;
    J0x0E:

    // End:0x4A [Loop If]
    if(I < 2)
    {
        mOverlayEdges[I].Stop();
        mOverlayEdges[I] = none;
        ++I;
        // [Loop Continue]
        goto J0x0E;
    }
    //return;    
}

// Export UTurokFEMultiplayerSelectWeaponSet::execOnSave(FFrame&, void* const)
native function OnSave();

// Export UTurokFEMultiplayerSelectWeaponSet::execOnCancel(FFrame&, void* const)
native function OnCancel();

defaultproperties
{
    SceneName="TurokFEMultiplayer.WeaponSet.SelectWeaponSet"
}