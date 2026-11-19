class TurokFEOptionsAudio extends TurokFEPauseOptionsOverlay
    native;

const NumAudioOptions = 3;

enum eOptionsAudioSelections
{
    OAUS_MUSIC,                     // 0
    OAUS_SFX,                       // 1
    OAUS_SPEECH,                    // 2
    OAUS_SAVE,                      // 3
    OAUS_CANCEL,                    // 4
    OAUS_MAX                        // 5
};

var bool bBlockInput;
var bool bAutoSaveEnabled;
var float PrevVolumes[3];
var float CurVolumes[3];
var @NULL Sliders[3];
var @NULL OptionsMenu;
var @NULL mOverlayEdges[2];
var @NULL mGamertag;

// Export UTurokFEOptionsAudio::execInitialize(FFrame&, void* const)
native function Initialize(@NULL newScene, @NULL curSceneClient);

// Export UTurokFEOptionsAudio::execGoBackScene(FFrame&, void* const)
native function GoBackScene();

event SCInitialized()
{
    bBlockInput = true;
    InitData();
    Sliders[0] = TurokUISlider(Scene.FindChild(name("MusicSlider")));
    // DebugMode: 0
    assert(Sliders[0] != none);
    Sliders[0].PostSetupInitialize(0.0000000, 1.0000000, CurVolumes[0]);
    Sliders[1] = TurokUISlider(Scene.FindChild(name("SfxSlider")));
    // DebugMode: 0
    assert(Sliders[1] != none);
    Sliders[1].PostSetupInitialize(0.0000000, 1.0000000, CurVolumes[1]);
    Sliders[2] = TurokUISlider(Scene.FindChild(name("SpeechSlider")));
    // DebugMode: 0
    assert(Sliders[2] != none);
    Sliders[2].PostSetupInitialize(0.0000000, 1.0000000, CurVolumes[2]);
    OptionsMenu = TurokUIMenu(Scene.FindChild(name("AudioOptionsMenu")));
    // DebugMode: 0
    assert(OptionsMenu != none);
    OptionsMenu.SetItemHighlightDelegate(3, OnHighlightMain);
    OptionsMenu.SetItemHighlightDelegate(4, OnHighlightMain);
    OptionsMenu.SetItemUnhighlightDelegate(3, OnUnHighlightMain);
    OptionsMenu.SetItemUnhighlightDelegate(4, OnUnHighlightMain);
    OptionsMenu.SetItemDelegate(3, Menu_Save);
    OptionsMenu.SetItemDelegate(4, Menu_Cancel);
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
    assert(Sliders[0] != none);
    // DebugMode: 0
    assert(Sliders[1] != none);
    // DebugMode: 0
    assert(Sliders[2] != none);
    Sliders[0].Deinitialize();
    Sliders[0] = none;
    Sliders[1].Deinitialize();
    Sliders[1] = none;
    Sliders[2].Deinitialize();
    Sliders[2] = none;
    // DebugMode: 0
    assert(OptionsMenu != none);
    OptionsMenu.ScriptCtrl = none;
    OptionsMenu = none;
    SceneClient = none;
    I = 0;
    J0xB8:

    // End:0xF4 [Loop If]
    if(I < 2)
    {
        mOverlayEdges[I].Stop();
        mOverlayEdges[I] = none;
        ++I;
        // [Loop Continue]
        goto J0xB8;
    }
    mGamertag = none;
    //return;    
}

event bool SCInputKey_OptionsAudio(int ControllerId, name Key, byte Event, float AmountDepressed)
{
    local bool EatInput;
    local @NULL dlg;

    EatInput = true;
    // End:0xA3
    if(int(Event) == int(0))
    {
        switch(Key)
        {
            // End:0x40
            case 'XboxTypeS_Back':
                // End:0x40
                if(Class'Engine.Engine'.static.IsPS3())
                {
                    // End:0xA3
                    break;
                }
            // End:0x4C
            case 'XboxTypeS_B':
            // End:0x58
            case 'MouseXButton1':
            // End:0x64
            case 'BackSpace':
            // End:0xA0
            case 'Escape':
                Class'TurokEngine.TurokUI'.static.GetFEAudio().PlayFESound(4);
                CloseMenu();
                // End:0xA3
                break;
            // End:0xFFFF
            default:
                break;
        }
    }
    else
    {
        // End:0x1A8
        if(OptionsMenu != none)
        {
            // End:0xDA
            if(OptionsMenu.ProcessInput(ControllerId, Key, Event, AmountDepressed))
            {
                return true;
            }
            // End:0x11F
            if(OptionsMenu.SelectedItemIndex == 0)
            {
                // End:0x11C
                if(Sliders[0].ProcessInput(ControllerId, Key, Event, AmountDepressed))
                {
                    return true;
                }                
            }
            else
            {
                // End:0x164
                if(OptionsMenu.SelectedItemIndex == 1)
                {
                    // End:0x161
                    if(Sliders[1].ProcessInput(ControllerId, Key, Event, AmountDepressed))
                    {
                        return true;
                    }                    
                }
                else
                {
                    // End:0x1A8
                    if(OptionsMenu.SelectedItemIndex == 2)
                    {
                        // End:0x1A8
                        if(Sliders[2].ProcessInput(ControllerId, Key, Event, AmountDepressed))
                        {
                            return true;
                        }
                    }
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
    CloseMenu();
    //return;    
}

function SaveCancelled()
{
    Class'TurokEngine.TurokUI'.static.GetFEAudio().PlayFESound(4);
    CloseMenu();
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
    // End:0x2A
    if(Sliders[0] != none)
    {
        CurVolumes[0] = Sliders[0].GetValue();
    }
    // End:0x54
    if(Sliders[1] != none)
    {
        CurVolumes[1] = Sliders[1].GetValue();
    }
    // End:0x81
    if(Sliders[2] != none)
    {
        CurVolumes[2] = Sliders[2].GetValue();
    }
    // End:0x96
    if(CurVolumes[0] != PrevVolumes[0])
    {
        return true;
    }
    // End:0xAB
    if(CurVolumes[1] != PrevVolumes[1])
    {
        return true;
    }
    // End:0xC2
    if(CurVolumes[2] != PrevVolumes[2])
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function ResetToDefault()
{
    InitData();
    Sliders[0].SetValue(CurVolumes[0]);
    Sliders[1].SetValue(CurVolumes[1]);
    Sliders[2].SetValue(CurVolumes[2]);
    Sliders[0].RefreshPosition();
    Sliders[1].RefreshPosition();
    Sliders[2].RefreshPosition();
    //return;    
}

function SaveData(optional bool isMultiplayer = false)
{
    Class'TurokEngine.TurokUI'.static.GetFEAudio().SetGlobalMusicVolume(Sliders[0].GetValue());
    Class'TurokEngine.TurokUI'.static.GetFEAudio().SetGlobalSFXVolume(Sliders[1].GetValue());
    Class'TurokEngine.TurokUI'.static.GetFEAudio().SetGlobalSpeechVolume(Sliders[2].GetValue());
    Class'TurokProfileManager'.static.Save(Class'TurokOnlineProfile'.static.CurrentProfile());
    //return;    
}

function InitData()
{
    local @NULL db, Profile;
    local int temp_int;

    db = Class'Engine.TurokOnlineDashboard'.static.Instance();
    Profile = TurokOnlineProfile(db.GetSignedInProfile());
    // End:0x65
    if(Profile != none)
    {
        Profile.GetProfileSettingValueId(60, temp_int);
        bAutoSaveEnabled = bool(temp_int);        
    }
    else
    {
        bAutoSaveEnabled = true;
    }
    PrevVolumes[0] = Class'TurokEngine.TurokUI'.static.GetFEAudio().GetGlobalMusicVolume();
    PrevVolumes[1] = Class'TurokEngine.TurokUI'.static.GetFEAudio().GetGlobalSFXVolume();
    PrevVolumes[2] = Class'TurokEngine.TurokUI'.static.GetFEAudio().GetGlobalSpeechVolume();
    CurVolumes[0] = PrevVolumes[0];
    CurVolumes[1] = PrevVolumes[1];
    CurVolumes[2] = PrevVolumes[2];
    //return;    
}

defaultproperties
{
    SceneName="TurokFEOptions.AudioGroup.Audio"
}