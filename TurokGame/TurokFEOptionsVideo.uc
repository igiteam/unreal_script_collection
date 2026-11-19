class TurokFEOptionsVideo extends TurokFEPauseOptionsOverlay
    native;

const NumVideoOptions = 7;

enum eOptionsVideoSelections
{
    OVS_RESOLUTION,                 // 0
    OVS_FULLSCREEN,                 // 1
    OVS_GAMMA,                      // 2
    OVS_VSYNC,                      // 3
    OVS_FILTERING,                  // 4
    OVS_TEXTUREQUALITY,             // 5
    OVS_WORLDDETAIL,                // 6
    OVS_SAVE,                       // 7
    OVS_CANCEL,                     // 8
    OVS_MAX                         // 9
};

var bool bBlockInput;
var bool bAutoSaveEnabled;
var bool PrevFullScreen;
var bool PrevVSync;
var @NULL GammaSlider;
var @NULL ResolutionOptionsList;
var @NULL FullscreenOptionsList;
var @NULL VSyncOptionsList;
var @NULL FilteringOptionsList;
var @NULL TextureQualityOptionsList;
var @NULL WorldDetailOptionsList;
var @NULL OptionsMenu;
var @NULL mOverlayEdges[2];
var @NULL mGamertag;
var int PrevResolution;
var float PrevGamma;
var byte PrevFiltering;
var byte PrevTextureQuality;
var byte PrevWorldDetail;

// Export UTurokFEOptionsVideo::execInitialize(FFrame&, void* const)
native function Initialize(@NULL newScene, @NULL curSceneClient);

// Export UTurokFEOptionsVideo::execGoBackScene(FFrame&, void* const)
native function GoBackScene();

event SCInitialized()
{
    bBlockInput = true;
    InitData();
    GammaSlider = TurokUISlider(Scene.FindChild(name("GammaSlider")));
    // DebugMode: 0
    assert(GammaSlider != none);
    ResolutionOptionsList = TurokUIList(Scene.FindChild(name("ResolutionOptionsList")));
    // DebugMode: 0
    assert(ResolutionOptionsList != none);
    FullscreenOptionsList = TurokUIList(Scene.FindChild(name("FullscreenOptionsList")));
    // DebugMode: 0
    assert(FullscreenOptionsList != none);
    VSyncOptionsList = TurokUIList(Scene.FindChild(name("VSyncOptionsList")));
    // DebugMode: 0
    assert(VSyncOptionsList != none);
    FilteringOptionsList = TurokUIList(Scene.FindChild(name("FilteringOptionsList")));
    // DebugMode: 0
    assert(FilteringOptionsList != none);
    TextureQualityOptionsList = TurokUIList(Scene.FindChild(name("TextureQualityOptionsList")));
    // DebugMode: 0
    assert(TextureQualityOptionsList != none);
    WorldDetailOptionsList = TurokUIList(Scene.FindChild(name("WorldDetailOptionsList")));
    // DebugMode: 0
    assert(WorldDetailOptionsList != none);
    OptionsMenu = TurokUIMenu(Scene.FindChild(name("VideoOptionsMenu")));
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
    OptionsMenu.SetItemHighlightDelegate(8, OnHighlightMain);
    OptionsMenu.SetItemUnhighlightDelegate(0, OnUnHighlightMain);
    OptionsMenu.SetItemUnhighlightDelegate(1, OnUnHighlightMain);
    OptionsMenu.SetItemUnhighlightDelegate(2, OnUnHighlightMain);
    OptionsMenu.SetItemUnhighlightDelegate(3, OnUnHighlightMain);
    OptionsMenu.SetItemUnhighlightDelegate(4, OnUnHighlightMain);
    OptionsMenu.SetItemUnhighlightDelegate(5, OnUnHighlightMain);
    OptionsMenu.SetItemUnhighlightDelegate(6, OnUnHighlightMain);
    OptionsMenu.SetItemUnhighlightDelegate(7, OnUnHighlightMain);
    OptionsMenu.SetItemUnhighlightDelegate(8, OnUnHighlightMain);
    OptionsMenu.SetItemDelegate(7, Menu_Save);
    OptionsMenu.SetItemDelegate(8, Menu_Cancel);
    GammaSlider.SetNumNotches(24);
    GammaSlider.PostSetupInitialize(0.0000000, 100.0000000, PrevGamma);
    PrevGamma = GammaSlider.GetValue();
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
    assert(GammaSlider != none);
    GammaSlider.Deinitialize();
    GammaSlider = none;
    // DebugMode: 0
    assert(OptionsMenu != none);
    OptionsMenu.ScriptCtrl = none;
    OptionsMenu = none;
    SceneClient = none;
    I = 0;
    J0x57:

    // End:0x93 [Loop If]
    if(I < 2)
    {
        mOverlayEdges[I].Stop();
        mOverlayEdges[I] = none;
        ++I;
        // [Loop Continue]
        goto J0x57;
    }
    mGamertag = none;
    //return;    
}

event bool SCInputKey_OptionsVideo(int ControllerId, name Key, byte Event, float AmountDepressed)
{
    local bool EatInput;
    local @NULL dlg;

    EatInput = true;
    // End:0x196
    if(int(Event) == int(0))
    {
        switch(Key)
        {
            // End:0x2B
            case 'XboxTypeS_A':
            // End:0x112
            case 'Enter':
                // End:0x10F
                if(true)
                {
                    // End:0x105
                    if(SettingsChanged())
                    {
                        // End:0x68
                        if(Class'TurokUtil'.static.IsMultiplayerGame())
                        {
                            SaveData(true);                            
                        }
                        else
                        {
                            // End:0x7F
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
                // End:0x196
                break;
            // End:0x133
            case 'XboxTypeS_Back':
                // End:0x133
                if(Class'Engine.Engine'.static.IsPS3())
                {
                    // End:0x196
                    break;
                }
            // End:0x13F
            case 'XboxTypeS_B':
            // End:0x14B
            case 'MouseXButton1':
            // End:0x157
            case 'BackSpace':
            // End:0x193
            case 'Escape':
                Class'TurokEngine.TurokUI'.static.GetFEAudio().PlayFESound(4);
                CloseMenu();
                // End:0x196
                break;
            // End:0xFFFF
            default:
                break;
        }
    }
    else
    {
        // End:0x34D
        if(OptionsMenu != none)
        {
            // End:0x1CD
            if(OptionsMenu.ProcessInput(ControllerId, Key, Event, AmountDepressed))
            {
                return true;
            }
            switch(OptionsMenu.SelectedItemIndex)
            {
                // End:0x210
                case 0:
                    // End:0x20D
                    if(ResolutionOptionsList.ProcessInput(ControllerId, Key, Event, AmountDepressed))
                    {
                        return true;
                    }
                    // End:0x34D
                    break;
                // End:0x243
                case 1:
                    // End:0x240
                    if(FullscreenOptionsList.ProcessInput(ControllerId, Key, Event, AmountDepressed))
                    {
                        return true;
                    }
                    // End:0x34D
                    break;
                // End:0x277
                case 2:
                    // End:0x274
                    if(GammaSlider.ProcessInput(ControllerId, Key, Event, AmountDepressed))
                    {
                        return true;
                    }
                    // End:0x34D
                    break;
                // End:0x2AB
                case 3:
                    // End:0x2A8
                    if(VSyncOptionsList.ProcessInput(ControllerId, Key, Event, AmountDepressed))
                    {
                        return true;
                    }
                    // End:0x34D
                    break;
                // End:0x2DF
                case 4:
                    // End:0x2DC
                    if(FilteringOptionsList.ProcessInput(ControllerId, Key, Event, AmountDepressed))
                    {
                        return true;
                    }
                    // End:0x34D
                    break;
                // End:0x313
                case 5:
                    // End:0x310
                    if(TextureQualityOptionsList.ProcessInput(ControllerId, Key, Event, AmountDepressed))
                    {
                        return true;
                    }
                    // End:0x34D
                    break;
                // End:0x347
                case 6:
                    // End:0x344
                    if(WorldDetailOptionsList.ProcessInput(ControllerId, Key, Event, AmountDepressed))
                    {
                        return true;
                    }
                    // End:0x34D
                    break;
                // End:0xFFFF
                default:
                    // End:0x34D
                    break;
                    break;
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

function IntroComplete()
{
    bBlockInput = false;
    //return;    
}

function ExitComplete()
{
    SceneClient.GoBackSceneController(0);
    //return;    
}

// Export UTurokFEOptionsVideo::execSettingsChanged(FFrame&, void* const)
native function bool SettingsChanged();

function OnHighlightMain()
{
    local @NULL the_tex, slot_label;

    // End:0x1EF
    if(OptionsMenu != none)
    {
        the_tex = Texture(DynamicLoadObject("TurokFonts.FontMaskTexture1a", Class'Engine.Texture'));
        OptionsMenu.GetSelectedItem().mMaskBackground = the_tex;
        slot_label = none;
        switch(OptionsMenu.SelectedItemIndex)
        {
            // End:0xAD
            case 0:
                slot_label = ResolutionOptionsList.GetSlotLabel(0);
                ResolutionOptionsList.Focus();
                // End:0x1C3
                break;
            // End:0xE1
            case 1:
                slot_label = FullscreenOptionsList.GetSlotLabel(0);
                FullscreenOptionsList.Focus();
                // End:0x1C3
                break;
            // End:0xE9
            case 2:
                // End:0x1C3
                break;
            // End:0x11E
            case 3:
                slot_label = VSyncOptionsList.GetSlotLabel(0);
                VSyncOptionsList.Focus();
                // End:0x1C3
                break;
            // End:0x153
            case 4:
                slot_label = FilteringOptionsList.GetSlotLabel(0);
                FilteringOptionsList.Focus();
                // End:0x1C3
                break;
            // End:0x188
            case 5:
                slot_label = TextureQualityOptionsList.GetSlotLabel(0);
                TextureQualityOptionsList.Focus();
                // End:0x1C3
                break;
            // End:0x1BD
            case 6:
                slot_label = WorldDetailOptionsList.GetSlotLabel(0);
                WorldDetailOptionsList.Focus();
                // End:0x1C3
                break;
            // End:0xFFFF
            default:
                // End:0x1C3
                break;
                break;
        }
        // End:0x1EF
        if(slot_label != none)
        {
            slot_label.mFontColor = MakeColor(byte(255), 161, 0, byte(255));
        }
    }
    //return;    
}

function OnUnHighlightMain()
{
    local @NULL the_tex, slot_label;

    // End:0x1ED
    if(OptionsMenu != none)
    {
        the_tex = Texture(DynamicLoadObject("TurokFonts.FontMaskTexture1b", Class'Engine.Texture'));
        OptionsMenu.GetSelectedItem().mMaskBackground = the_tex;
        slot_label = none;
        switch(OptionsMenu.SelectedItemIndex)
        {
            // End:0xAD
            case 0:
                slot_label = ResolutionOptionsList.GetSlotLabel(0);
                ResolutionOptionsList.UnFocus();
                // End:0x1C3
                break;
            // End:0xE1
            case 1:
                slot_label = FullscreenOptionsList.GetSlotLabel(0);
                FullscreenOptionsList.UnFocus();
                // End:0x1C3
                break;
            // End:0xE9
            case 2:
                // End:0x1C3
                break;
            // End:0x11E
            case 3:
                slot_label = VSyncOptionsList.GetSlotLabel(0);
                VSyncOptionsList.UnFocus();
                // End:0x1C3
                break;
            // End:0x153
            case 4:
                slot_label = FilteringOptionsList.GetSlotLabel(0);
                FilteringOptionsList.UnFocus();
                // End:0x1C3
                break;
            // End:0x188
            case 5:
                slot_label = TextureQualityOptionsList.GetSlotLabel(0);
                TextureQualityOptionsList.UnFocus();
                // End:0x1C3
                break;
            // End:0x1BD
            case 6:
                slot_label = WorldDetailOptionsList.GetSlotLabel(0);
                WorldDetailOptionsList.UnFocus();
                // End:0x1C3
                break;
            // End:0xFFFF
            default:
                // End:0x1C3
                break;
                break;
        }
        // End:0x1ED
        if(slot_label != none)
        {
            slot_label.mFontColor = MakeColor(93, 52, 24, byte(255));
        }
    }
    //return;    
}

function Menu_Save()
{
    local @NULL dlg;

    SaveData();
    dlg = TurokUIDialog(SceneClient.SceneControllerMgr.FindSceneController("Dialog"));
    dlg.OpenPopup(SceneClient, 1, 0, 5064210, 2027339173, 0, 0, CloseMenu, None, None, 0);
    //return;    
}

function Menu_Cancel()
{
    CloseMenu();
    //return;    
}

function ResetToDefault()
{
    InitData();
    GammaSlider.SetValue(PrevGamma);
    GammaSlider.RefreshPosition();
    //return;    
}

// Export UTurokFEOptionsVideo::execSaveData(FFrame&, void* const)
native function SaveData(optional bool isMultiplayer);

function SaveData_OnProfileWriteComplete(byte ControllerId, bool bSuccessful)
{
    //return;    
}

function InitData()
{
    PrevResolution = Class'TurokEngine.TurokUI'.static.GetFEVideo().GetResolution();
    PrevFullScreen = Class'TurokEngine.TurokUI'.static.GetFEVideo().GetFullScreen();
    PrevGamma = Class'TurokEngine.TurokUI'.static.GetFEVideo().GetGamma();
    PrevVSync = Class'TurokEngine.TurokUI'.static.GetFEVideo().GetVSync();
    PrevFiltering = Class'TurokEngine.TurokUI'.static.GetFEVideo().GetFiltering();
    PrevTextureQuality = Class'TurokEngine.TurokUI'.static.GetFEVideo().GetTextureQuality();
    PrevWorldDetail = Class'TurokEngine.TurokUI'.static.GetFEVideo().GetWorldDetail();
    bAutoSaveEnabled = true;
    //return;    
}

defaultproperties
{
    SceneName="TurokFEOptions.VideoGroup.Video"
}