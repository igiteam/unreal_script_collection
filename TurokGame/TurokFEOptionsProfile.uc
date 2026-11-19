class TurokFEOptionsProfile extends TurokFEPauseOptionsOverlay
    native;

const NumProfileOptions = 8;

enum eOptionsProfileSelections
{
    OPRS_NAME,                      // 0
    OPRS_ONLINEACCOUNT,             // 1
    OPRS_USERNAME,                  // 2
    OPRS_EMAIL,                     // 3
    OPRS_PASSWORD,                  // 4
    OPRS_VERIFYPASSWORD,            // 5
    OPRS_SAVE,                      // 6
    OPRS_CANCEL,                    // 7
    OPRS_MAX                        // 8
};

enum eOptionsProfileOnlineAccount
{
    OPOA_NONE,                      // 0
    OPOA_EXISTING,                  // 1
    OPOA_CREATE,                    // 2
    OPOA_MAX                        // 3
};

var bool bBlockInput;
var bool bAutoSaveEnabled;
var bool CreatingProfile;
var bool CurAccountExists;
var bool OnlineAccountOptionsListFocused;
var int PreviousProfile;
var init string PrevName;
var init string PrevUsername;
var init string PrevEmail;
var init string PrevPassword;
var init string CurName;
var init string CurUsername;
var init string CurEmail;
var init string CurPassword;
var init string CurVerifyPassword;
var init @NULL EditboxSuccessColor;
var init @NULL EditboxErrorColor;
var @NULL OptionsMenu;
var @NULL OnlineAccountOptionsList;
var @NULL ProfileNameEditBox;
var @NULL QuazalUserNameEditBox;
var @NULL QuazalEmailEditBox;
var @NULL QuazalPasswordEditBox;
var @NULL QuazalVerifyPasswordEditBox;
var @NULL mOverlayEdges[2];
var @NULL mGamertag;

// Export UTurokFEOptionsProfile::execInitialize(FFrame&, void* const)
native function Initialize(@NULL newScene, @NULL curSceneClient);

// Export UTurokFEOptionsProfile::execGoBackScene(FFrame&, void* const)
native function GoBackScene();

// Export UTurokFEOptionsProfile::execSetCreatingProfile(FFrame&, void* const)
native function SetCreatingProfile(bool IsCreating);

// Export UTurokFEOptionsProfile::execSetPreviousProfile(FFrame&, void* const)
native function SetPreviousProfile(int Previous);

event SCInitialized()
{
    bBlockInput = true;
    InitData();
    OnlineAccountOptionsList = TurokUIList(Scene.FindChild(name("OnlineAccountOptionsList"), true));
    // DebugMode: 0
    assert(OnlineAccountOptionsList != none);
    ProfileNameEditBox = UIEditBox(Scene.FindChild(name("ProfileNameEditBox"), true));
    // DebugMode: 0
    assert(ProfileNameEditBox != none);
    ProfileNameEditBox.SetValue(CurName);
    QuazalUserNameEditBox = UIEditBox(Scene.FindChild(name("QuazalUserNameEditBox"), true));
    // DebugMode: 0
    assert(QuazalUserNameEditBox != none);
    QuazalUserNameEditBox.SetValue(CurUsername);
    QuazalEmailEditBox = UIEditBox(Scene.FindChild(name("QuazalEmailEditBox"), true));
    // DebugMode: 0
    assert(QuazalEmailEditBox != none);
    QuazalEmailEditBox.SetValue(CurEmail);
    QuazalPasswordEditBox = UIEditBox(Scene.FindChild(name("QuazalPasswordEditBox"), true));
    // DebugMode: 0
    assert(QuazalPasswordEditBox != none);
    QuazalPasswordEditBox.SetValue("");
    QuazalVerifyPasswordEditBox = UIEditBox(Scene.FindChild(name("QuazalVerifyPasswordEditBox"), true));
    // DebugMode: 0
    assert(QuazalVerifyPasswordEditBox != none);
    QuazalVerifyPasswordEditBox.SetValue("");
    OptionsMenu = TurokUIMenu(Scene.FindChild(name("ProfileOptionsMenu")));
    // DebugMode: 0
    assert(OptionsMenu != none);
    OptionsMenu.SetItemHighlightDelegate(0, OnHighlightMain);
    OptionsMenu.SetItemHighlightDelegate(1, OnHighlightMain);
    OptionsMenu.SetItemHighlightDelegate(2, OnHighlightMain);
    OptionsMenu.SetItemHighlightDelegate(3, OnHighlightMain);
    OptionsMenu.SetItemHighlightDelegate(4, OnHighlightMain);
    OptionsMenu.SetItemHighlightDelegate(5, OnHighlightMain);
    OptionsMenu.SetItemHighlightDelegate(6, OnHighlightMain);
    OptionsMenu.SetItemHighlightDelegate(7, OnHighlightMain);
    OptionsMenu.SetItemUnhighlightDelegate(0, OnUnHighlightMain);
    OptionsMenu.SetItemUnhighlightDelegate(1, OnUnHighlightMain);
    OptionsMenu.SetItemUnhighlightDelegate(2, OnUnHighlightMain);
    OptionsMenu.SetItemUnhighlightDelegate(3, OnUnHighlightMain);
    OptionsMenu.SetItemUnhighlightDelegate(4, OnUnHighlightMain);
    OptionsMenu.SetItemUnhighlightDelegate(5, OnUnHighlightMain);
    OptionsMenu.SetItemUnhighlightDelegate(6, OnUnHighlightMain);
    OptionsMenu.SetItemUnhighlightDelegate(7, OnUnHighlightMain);
    OptionsMenu.SetItemDelegate(6, Menu_Save);
    OptionsMenu.SetItemDelegate(7, Menu_Cancel);
    OptionsMenu.PostSetupInitialize();
    OptionsMenu.StartFadeIn();
    //return;    
}

event SCTick(float DeltaTime)
{
    super(TurokUISceneController).SCTick(DeltaTime);
    mGamertag.Tick();
    //return;    
}

event SCCleanUpOnExit()
{
    local int I;

    // DebugMode: 0
    assert(OptionsMenu != none);
    OptionsMenu.ScriptCtrl = none;
    OptionsMenu = none;
    SceneClient = none;
    I = 0;
    J0x31:

    // End:0x6D [Loop If]
    if(I < 2)
    {
        mOverlayEdges[I].Stop();
        mOverlayEdges[I] = none;
        ++I;
        // [Loop Continue]
        goto J0x31;
    }
    mGamertag = none;
    //return;    
}

event bool SCInputKey_OptionsProfile(int ControllerId, name Key, byte Event, float AmountDepressed)
{
    local bool EatInput;
    local @NULL dlg;

    EatInput = true;
    // End:0x113
    if(int(Event) == int(0))
    {
        switch(Key)
        {
            // End:0x40
            case 'XboxTypeS_Back':
                // End:0x40
                if(Class'Engine.Engine'.static.IsPS3())
                {
                    // End:0x113
                    break;
                }
            // End:0x4C
            case 'XboxTypeS_B':
            // End:0x58
            case 'MouseXButton1':
            // End:0x64
            case 'BackSpace':
            // End:0x110
            case 'Escape':
                // End:0x103
                if(SettingsChanged())
                {
                    dlg = TurokUIDialog(SceneClient.SceneControllerMgr.FindSceneController("Dialog"));
                    // DebugMode: 0
                    assert(dlg != none);
                    dlg.OpenPopup(SceneClient, 2, 0, 1191994056, 544201488, -1644903683, 0, Menu_Save, SaveCancelled, None, 1);                    
                }
                else
                {
                    SaveCancelled();
                }
                // End:0x113
                break;
            // End:0xFFFF
            default:
                break;
        }
    }
    else
    {
        // End:0x14A
        if(OptionsMenu != none)
        {
            // End:0x14A
            if(OptionsMenu.ProcessInput(ControllerId, Key, Event, AmountDepressed))
            {
                return true;
            }
        }
        return EatInput;
        //return ReturnValue;        
    }
}

function SaveConfirmed()
{
    SaveData();
    CloseMenu();
    //return;    
}

function SaveCancelled()
{
    Class'TurokEngine.TurokUI'.static.GetFEAudio().PlayFESound(4);
    Menu_Cancel();
    //return;    
}

function IntroComplete()
{
    bBlockInput = false;
    //return;    
}

function ExitComplete()
{
    SceneClient.GoBackSceneController(1);
    //return;    
}

function OnHighlightMain()
{
    local @NULL the_tex;

    // End:0x91
    if(OptionsMenu != none)
    {
        the_tex = Texture(DynamicLoadObject("TurokFonts.FontMaskTexture1a", Class'Engine.Texture'));
        OptionsMenu.GetSelectedItem().mMaskBackground = the_tex;
        // End:0x91
        if(OptionsMenu.SelectedItemIndex == 1)
        {
            OnlineAccountOptionsList.Focus();
            OnlineAccountOptionsListFocused = true;
        }
    }
    //return;    
}

function OnUnHighlightMain()
{
    local @NULL the_tex;

    // End:0x91
    if(OptionsMenu != none)
    {
        the_tex = Texture(DynamicLoadObject("TurokFonts.FontMaskTexture1b", Class'Engine.Texture'));
        OptionsMenu.GetSelectedItem().mMaskBackground = the_tex;
        // End:0x91
        if(OptionsMenu.SelectedItemIndex == 1)
        {
            OnlineAccountOptionsList.UnFocus();
            OnlineAccountOptionsListFocused = false;
        }
    }
    //return;    
}

// Export UTurokFEOptionsProfile::execOnOnlineAccountChanged(FFrame&, void* const)
native function OnOnlineAccountChanged();

function Menu_Save()
{
    local @NULL dlg;

    // End:0x83
    if(SaveData())
    {
        dlg = TurokUIDialog(SceneClient.SceneControllerMgr.FindSceneController("Dialog"));
        dlg.OpenPopup(SceneClient, 1, 0, 1633063741, 2027339173, 0, 0, CloseMenu, None, None);        
    }
    else
    {
        dlg = TurokUIDialog(SceneClient.SceneControllerMgr.FindSceneController("Dialog"));
        dlg.OpenPopup(SceneClient, 1, 0, 880489539, 2027339173, 0, 0, Menu_Cancel, None, None);
    }
    //return;    
}

// Export UTurokFEOptionsProfile::execMenu_Cancel(FFrame&, void* const)
native function Menu_Cancel();

// Export UTurokFEOptionsProfile::execValidateInputs(FFrame&, void* const)
native function bool ValidateInputs();

// Export UTurokFEOptionsProfile::execTryEnableSaveButton(FFrame&, void* const)
native function TryEnableSaveButton();

// Export UTurokFEOptionsProfile::execSettingsChanged(FFrame&, void* const)
native function bool SettingsChanged();

function ResetToDefault()
{
    InitData();
    ProfileNameEditBox.SetValue(PrevName);
    //return;    
}

// Export UTurokFEOptionsProfile::execSaveData(FFrame&, void* const)
native function bool SaveData(optional bool isMultiplayer);

// Export UTurokFEOptionsProfile::execInitData(FFrame&, void* const)
native function InitData();

defaultproperties
{
    SceneName="TurokFEOptions.EditProfile"
}