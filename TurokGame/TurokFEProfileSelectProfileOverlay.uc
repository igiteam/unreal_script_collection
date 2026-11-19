class TurokFEProfileSelectProfileOverlay extends TurokFEOptionsOverlay
    native;

var @NULL mOverlayEdges[2];

// Export UTurokFEProfileSelectProfileOverlay::execInitialize(FFrame&, void* const)
native function Initialize(@NULL newScene, @NULL curSceneClient);

// Export UTurokFEProfileSelectProfileOverlay::execOnSettingItemHighlighted(FFrame&, void* const)
native function OnSettingItemHighlighted(int dataIndex);

event SCInitialized()
{
    super.SCInitialized();
    //return;    
}

event SCTick(float DeltaTime)
{
    super.SCTick(DeltaTime);
    //return;    
}

event bool SCInputKey_OptionsSelectProfileOverlay(int ControllerId, name Key, byte Event, float AmountDepressed)
{
    // End:0x77
    if(int(Event) == int(0))
    {
        switch(Key)
        {
            // End:0x38
            case 'XboxTypeS_Back':
                // End:0x38
                if(Class'Engine.Engine'.static.IsPS3())
                {
                    // End:0x77
                    break;
                }
            // End:0x44
            case 'XboxTypeS_B':
            // End:0x50
            case 'MouseXButton1':
            // End:0x5C
            case 'BackSpace':
            // End:0x74
            case 'Escape':
                GoBackScreen();
                return true;
            // End:0xFFFF
            default:
                break;
        }
    }
    else
    {
        return false;
        //return ReturnValue;        
    }
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

protected function InitList()
{
    local int I, SelectedIndex;
    local @NULL ProfileManager, Localization;

    ProfileManager = Class'TurokProfileManager'.static.Instance();
    Localization = Class'TurokEngine.TurokUI'.static.GetEngine().GetLocalization();
    mList = TurokUIList(Scene.FindChild('List'));
    // DebugMode: 0
    assert(mList != none);
    SelectedIndex = 0;
    I = 0;
    J0x7A:

    // End:0x14D [Loop If]
    if(I < ProfileManager.NumProfiles())
    {
        mList.AddDataString(ProfileManager.ProfileName(I), I);
        // End:0x107
        if(ProfileManager.NumProfiles() > 1)
        {
            mDescriptionText[I] = Localization.GetLocalizedString(-131318956);            
        }
        else
        {
            mDescriptionText[I] = Localization.GetLocalizedString(1149478259);
        }
        mList.SetDataActive(I);
        I++;
        // [Loop Continue]
        goto J0x7A;
    }
    I = ProfileManager.NumProfiles();
    mList.AddDataString(Localization.GetLocalizedString(1033452631), I);
    mDescriptionText[I] = Localization.GetLocalizedString(1286874219);
    mList.SetDataActive(I);
    SelectedIndex = ProfileManager.ActiveProfile();
    // End:0x221
    if(ProfileManager.IsValidProfile(SelectedIndex))
    {
        mList.PostSetupInitialize(SelectedIndex);        
    }
    else
    {
        mList.PostSetupInitialize();
    }
    RefreshList();
    ChangeDescriptionLabel();
    //return;    
}

// Export UTurokFEProfileSelectProfileOverlay::execActivate(FFrame&, void* const)
protected native function Activate();

// Export UTurokFEProfileSelectProfileOverlay::execOnSettingItemClicked(FFrame&, void* const)
native function OnSettingItemClicked();

// Export UTurokFEProfileSelectProfileOverlay::execDoDelete(FFrame&, void* const)
native function DoDelete();

function DontDelete()
{
    //return;    
}

event AskDeleteProfile()
{
    local @NULL dlg;

    dlg = TurokUIDialog(SceneClient.SceneControllerMgr.FindSceneController("Dialog"));
    SetHasFocus(false);
    dlg.OpenPopup(SceneClient, 2, 0, -38367041, -1009468167, 423868988, 0, DoDelete, DontDelete, None, 1);
    //return;    
}

defaultproperties
{
    SceneName="TurokFEOptions.selectProfileOverlay"
}