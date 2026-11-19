class TurokFEPauseOptionsAdvanced extends TurokFEPauseOptionsOverlay
    native;

const NumAdvancedOptions = 5;

enum eOptionsAdvancedSelections
{
    OAS_SENSITIVITY,                // 0
    OAS_INVERT_AIM,                 // 1
    OAS_VIBRATION,                  // 2
    OAS_SELECT_STORAGE,             // 3
    OAS_SAVE,                       // 4
    OAS_CANCEL,                     // 5
    OAS_MAX                         // 6
};

var bool bBlockInput;
var bool bAutoSaveEnabled;
var bool bCurInvertAim;
var bool bPrevInvertAim;
var bool bCurVibration;
var bool bPrevVibration;
var float CurSensitivity;
var float PrevSensitivity;
var @NULL SensitivitySlider;
var @NULL OptionsMenu;

// Export UTurokFEPauseOptionsAdvanced::execInitialize(FFrame&, void* const)
native function Initialize(@NULL newScene, @NULL curSceneClient);

// Export UTurokFEPauseOptionsAdvanced::execGoBackScene(FFrame&, void* const)
native function GoBackScene();

event SCInitialized()
{
    local @NULL SubMenu;

    bBlockInput = true;
    InitData();
    SensitivitySlider = TurokUISlider(Scene.FindChild(name("SensitivitySlider")));
    // DebugMode: 0
    assert(SensitivitySlider != none);
    SensitivitySlider.PostSetupInitialize(0.0000000, 100.0000000, CurSensitivity);
    OptionsMenu = TurokUIMenu(Scene.FindChild(name("AdvancedOptionsMenu")));
    // DebugMode: 0
    assert(OptionsMenu != none);
    // End:0x10E
    if(!Class'Engine.Engine'.static.IsPC())
    {
        OptionsMenu.SetItemHighlightDelegate(0, SensitivitySlider.Focus);
        OptionsMenu.SetItemUnhighlightDelegate(0, SensitivitySlider.UnFocus);
    }
    SubMenu = OptionsMenu.GetSubMenu(1);
    // DebugMode: 0
    assert(SubMenu != none);
    SubMenu.SetItemHighlightDelegate(0, InvertAimOn);
    SubMenu.SetItemHighlightDelegate(1, InvertAimOff);
    SubMenu.SetSelection(((bCurInvertAim) ? 0 : 1));
    SubMenu = OptionsMenu.GetSubMenu(2);
    // End:0x226
    if(!Class'Engine.Engine'.static.IsPS3())
    {
        // DebugMode: 0
        assert(SubMenu != none);
        SubMenu.SetItemHighlightDelegate(0, VibrationOn);
        SubMenu.SetItemHighlightDelegate(1, VibrationOff);
        SubMenu.SetSelection(((bCurVibration) ? 0 : 1));        
    }
    else
    {
        OptionsMenu.DisableItem(2, false);
    }
    OptionsMenu.SetItemHighlightDelegate(4, OnHighlightMain);
    OptionsMenu.SetItemHighlightDelegate(5, OnHighlightMain);
    OptionsMenu.SetItemUnhighlightDelegate(4, OnUnHighlightMain);
    OptionsMenu.SetItemUnhighlightDelegate(5, OnUnHighlightMain);
    OptionsMenu.SetItemDelegate(4, Menu_Save);
    OptionsMenu.SetItemDelegate(5, Menu_Cancel);
    OptionsMenu.PostSetupInitialize();
    OptionsMenu.StartFadeIn();
    //return;    
}

event SCCleanUpOnExit()
{
    // DebugMode: 0
    assert(SensitivitySlider != none);
    SensitivitySlider.Deinitialize();
    SensitivitySlider = none;
    // DebugMode: 0
    assert(OptionsMenu != none);
    OptionsMenu.ScriptCtrl = none;
    OptionsMenu = none;
    SceneClient = none;
    //return;    
}

event bool SCInputKey_OptionsAdvanced(int ControllerId, name Key, byte Event, float AmountDepressed)
{
    local bool EatInput;
    local @NULL dlg;

    EatInput = true;
    // End:0x18A
    if(int(Event) == int(0))
    {
        switch(Key)
        {
            // End:0x106
            case 'XboxTypeS_A':
                // End:0x103
                if(true)
                {
                    // End:0xF9
                    if(SettingsChanged())
                    {
                        // End:0x5C
                        if(Class'TurokUtil'.static.IsMultiplayerGame())
                        {
                            SaveData(true);                            
                        }
                        else
                        {
                            // End:0x73
                            if(bAutoSaveEnabled)
                            {
                                SaveData();                                
                            }
                            else
                            {
                                dlg = TurokUIDialog(SceneClient.SceneControllerMgr.FindSceneController("Dialog"));
                                // DebugMode: 0
                                assert(dlg != none);
                                dlg.OpenPopup(SceneClient, 2, 0, 1191994056, 544201488, -1644903683, 0, SaveConfirmed, CloseMenu, None, 1);
                            }
                        }                        
                    }
                    else
                    {
                        CloseMenu();
                    }
                }
                // End:0x18A
                break;
            // End:0x127
            case 'XboxTypeS_Back':
                // End:0x127
                if(Class'Engine.Engine'.static.IsPS3())
                {
                    // End:0x18A
                    break;
                }
            // End:0x133
            case 'XboxTypeS_B':
            // End:0x13F
            case 'MouseXButton1':
            // End:0x14B
            case 'Escape':
            // End:0x187
            case 'BackSpace':
                Class'TurokEngine.TurokUI'.static.GetFEAudio().PlayFESound(4);
                CloseMenu();
                // End:0x18A
                break;
            // End:0xFFFF
            default:
                break;
        }
    }
    else
    {
        // End:0x201
        if(OptionsMenu != none)
        {
            // End:0x1C1
            if(OptionsMenu.ProcessInput(ControllerId, Key, Event, AmountDepressed))
            {
                return true;
            }
            // End:0x201
            if(OptionsMenu.SelectedItemIndex == 0)
            {
                // End:0x201
                if(SensitivitySlider.ProcessInput(ControllerId, Key, Event, AmountDepressed))
                {
                    return true;
                }
            }
        }
        return EatInput;
        //return ReturnValue;        
    }
}

function SaveConfirmed()
{
    SaveData();
    //return;    
}

protected function SignIn()
{
    local @NULL db;

    db = Class'Engine.TurokOnlineDashboard'.static.Instance();
    db.super(TurokFEPauseOptionsAdvanced).SignIn(0, false, None);
    //return;    
}

function IntroComplete()
{
    bBlockInput = false;
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

    // End:0x62
    if(OptionsMenu != none)
    {
        the_tex = Texture(DynamicLoadObject("TurokFonts.FontMaskTexture1b", Class'Engine.Texture'));
        OptionsMenu.GetSelectedItem().mMaskBackground = the_tex;
    }
    //return;    
}

function Menu_Save()
{
    // End:0x18
    if(SettingsChanged())
    {
        SaveData();
    }
    CloseMenu();
    //return;    
}

function Menu_Cancel()
{
    CloseMenu();
    //return;    
}

function bool SettingsChanged()
{
    // End:0x24
    if(SensitivitySlider != none)
    {
        CurSensitivity = SensitivitySlider.GetValue();
    }
    // End:0x37
    if(bCurInvertAim != bPrevInvertAim)
    {
        return true;
    }
    // End:0x4A
    if(bCurVibration != bPrevVibration)
    {
        return true;
    }
    // End:0x5B
    if(CurSensitivity != PrevSensitivity)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function InvertAimOn()
{
    bCurInvertAim = true;
    //return;    
}

function InvertAimOff()
{
    bCurInvertAim = false;
    //return;    
}

function VibrationOn()
{
    bCurVibration = true;
    //return;    
}

function VibrationOff()
{
    bCurVibration = false;
    //return;    
}

function ResetToDefault()
{
    InitData();
    SensitivitySlider.SetValue(CurSensitivity);
    SensitivitySlider.RefreshPosition();
    //return;    
}

// Export UTurokFEPauseOptionsAdvanced::execSaveData(FFrame&, void* const)
native function SaveData(optional bool isMultiplayer);

function SaveData_OnProfileWriteComplete(byte ControllerId, bool bSuccessful)
{
    //return;    
}

// Export UTurokFEPauseOptionsAdvanced::execInitData(FFrame&, void* const)
native function InitData();

defaultproperties
{
    SceneName="TurokFEPauseMenuFlow.AdvancedMenu.PauseAdvanced"
}