class TurokFEOptionsControlsPC extends TurokFEPauseOptionsOverlay
    native;

const NumControlsOptions = 3;

enum eOptionsControlsSelections
{
    OCS_DEFAULTS,                   // 0
    OCS_SAVE,                       // 1
    OCS_CANCEL,                     // 2
    OCS_MAX                         // 3
};

struct native ControlsPCKeyStatus
{
    var native transient name Command;
    var native transient name PrevKey;
    var native transient name PrevAlternateKey;
    var native transient name CurKey;
    var native transient name CurAlternateKey;
};

var bool bBlockInput;
var bool bAutoSaveEnabled;
var protected @NULL mBindingsList;
var @NULL OptionsMenu;
var @NULL mOverlayEdges[2];
var @NULL mGamertag;
var transient int CurrentCommand;
var transient bool Alternate;
var init native array CurrentKeys;

// Export UTurokFEOptionsControlsPC::execInitialize(FFrame&, void* const)
native function Initialize(@NULL newScene, @NULL curSceneClient);

// Export UTurokFEOptionsControlsPC::execUpdateKeys(FFrame&, void* const)
native function UpdateKeys();

// Export UTurokFEOptionsControlsPC::execGoBackScene(FFrame&, void* const)
native function GoBackScene();

// Export UTurokFEOptionsControlsPC::execOnSettingItemHighlighted(FFrame&, void* const)
native function OnSettingItemHighlighted(int RowIndex, int ColumnIndex);

event SCInitialized()
{
    bBlockInput = true;
    InitData();
    OptionsMenu = TurokUIMenu(Scene.FindChild(name("ControlsOptionsMenu")));
    // DebugMode: 0
    assert(OptionsMenu != none);
    OptionsMenu.SetItemHighlightDelegate(0, OnHighlightMain);
    OptionsMenu.SetItemHighlightDelegate(1, OnHighlightMain);
    OptionsMenu.SetItemHighlightDelegate(2, OnHighlightMain);
    OptionsMenu.SetItemUnhighlightDelegate(0, OnUnHighlightMain);
    OptionsMenu.SetItemUnhighlightDelegate(1, OnUnHighlightMain);
    OptionsMenu.SetItemUnhighlightDelegate(2, OnUnHighlightMain);
    OptionsMenu.SetItemDelegate(0, Menu_Defaults);
    OptionsMenu.SetItemDelegate(1, Menu_Save);
    OptionsMenu.SetItemDelegate(2, Menu_Cancel);
    mBindingsList = TurokUIHighlightableTable(Scene.FindChild(name("KeyBindingsTable")));
    // DebugMode: 0
    assert(mBindingsList != none);
    OptionsMenu.PostSetupInitialize();
    mBindingsList.PostSetupInitialize();
    OptionsMenu.StartFadeIn();
    mBindingsList.StartFadeIn();
    //return;    
}

event SCTick(float DeltaTime)
{
    super(TurokUISceneController).SCTick(DeltaTime);
    mBindingsList.Tick();
    mGamertag.Tick();
    // DebugMode: 0
    assert(OptionsMenu != none);
    OptionsMenu.ScriptCtrl = none;
    OptionsMenu = none;
    //return;    
}

event SCCleanUpOnExit()
{
    //return;    
}

event bool SCInputKey_OptionsControlsPC(int ControllerId, name Key, byte Event, float AmountDepressed)
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
                GoBackScene();
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

// Export UTurokFEOptionsControlsPC::execOnKeyBindingEntered(FFrame&, void* const)
native function OnKeyBindingEntered(name Key);

event OnSettingItemClicked()
{
    local @NULL dlg;
    local string LocBindingPrompt;

    CurrentCommand = mBindingsList.GetSelectedRowIndex();
    Alternate = mBindingsList.GetSelectedColumnIndex() == 2;
    dlg = TurokUIKeyBindingDialog(SceneClient.SceneControllerMgr.FindSceneController("KeyBindingDialog"));
    LocBindingPrompt = Localize("PMStrings", "M_SelectBindingText", "TurokGame");
    dlg.OpenKeyBindingPopupStr(SceneClient, "Key Binding", LocBindingPrompt, OnKeyBindingEntered);
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

    // End:0x62
    if(OptionsMenu != none)
    {
        the_tex = Texture(DynamicLoadObject("TurokFonts.FontMaskTexture1a", Class'Engine.Texture'));
        OptionsMenu.GetSelectedItem().mMaskBackground = the_tex;
    }
    //return;    
}

function OnUnHighlightMain()
{
    local @NULL the_tex;

    // End:0x83
    if(OptionsMenu != none)
    {
        the_tex = Texture(DynamicLoadObject("TurokFonts.FontMaskTexture1b", Class'Engine.Texture'));
        OptionsMenu.GetSelectedItem().mMaskBackground = the_tex;
        OptionsMenu.GetSelectedItem().SetBlur();
    }
    //return;    
}

function DontResetToDefault()
{
    //return;    
}

function Menu_Defaults()
{
    local @NULL dlg;

    dlg = TurokUIDialog(SceneClient.SceneControllerMgr.FindSceneController("Dialog"));
    dlg.OpenPopup(SceneClient, 2, 0, -571800117, -1009468167, 423868988, 0, ResetToDefault, DontResetToDefault, None, 1);
    //return;    
}

function Menu_Save()
{
    SaveData();
    CloseMenu();
    //return;    
}

function Menu_Cancel()
{
    CloseMenu();
    //return;    
}

// Export UTurokFEOptionsControlsPC::execSettingsChanged(FFrame&, void* const)
native function bool SettingsChanged();

// Export UTurokFEOptionsControlsPC::execResetToDefault(FFrame&, void* const)
native function ResetToDefault();

// Export UTurokFEOptionsControlsPC::execSaveData(FFrame&, void* const)
native function SaveData(optional bool isMultiplayer);

// Export UTurokFEOptionsControlsPC::execInitData(FFrame&, void* const)
native function InitData();

defaultproperties
{
    SceneName="TurokFEOptions.ControllerGroup.ControlsPC"
}