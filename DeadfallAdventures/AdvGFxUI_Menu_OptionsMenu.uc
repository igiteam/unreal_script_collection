class AdvGFxUI_Menu_OptionsMenu extends AdvGFxUI_Menu_Options_Base
    config(UI);

var GFxObject SoundTF;
var GFxObject GraphicTF;
var GFxClikWidget GameplayBtn;
var GFxClikWidget ControlsBtn;
var GFxClikWidget VideoBtn;
var GFxClikWidget CreditsBtn;
var GFxClikWidget SaveSlotBtn;
var const localized string SoundLabel;
var const localized string GraphicLabel;
var const localized string GameplayString;
var const localized string ControlsString;
var const localized string VideoString;
var const localized string CreditsString;
var const localized string SaveSlotString;
var const localized string Storage;

function bool Start(optional bool StartPaused = false)
{
    local array<ASValue> Parms;

    super.Start(StartPaused);
    SoundTF = ButtonsMC.GetObject("sounds");
    GraphicTF = ButtonsMC.GetObject("graph");
    GameplayBtn = GFxClikWidget(ButtonsMC.GetObject("gameplay", Class'GFxUI.GFxClikWidget'));
    ControlsBtn = GFxClikWidget(ButtonsMC.GetObject("controls", Class'GFxUI.GFxClikWidget'));
    VideoBtn = GFxClikWidget(ButtonsMC.GetObject("video", Class'GFxUI.GFxClikWidget'));
    CreditsBtn = GFxClikWidget(ButtonsMC.GetObject("credits", Class'GFxUI.GFxClikWidget'));
    // End:0x1F9
    if(GetPC().WorldInfo.IsConsoleBuild(0))
    {
        ControlsBtn.SetString("label", ControlsString);        
    }
    else
    {
        ControlsBtn.SetString("label", Localize("AdvGFxUI_Menu_Options_Controls", "HeaderTitleString", "ADVGame"));
    }
    SoundTF.SetText(SoundLabel);
    GraphicTF.SetText(GraphicLabel);
    // End:0x45A
    if(GetPC().WorldInfo.IsConsoleBuild(0))
    {
        // End:0x42E
        if(GetPC().WorldInfo.IsConsoleBuild(1) && Frontend != none)
        {
            VideoBtn.SetString("label", Storage);
            // End:0x401
            if(int(Class'Engine.UIInteraction'.static.GetLoginStatus(LocalPlayer(GetPC().Player).ControllerId)) <= int(0))
            {
                VideoBtn.SetBool("disabled", true);                
            }
            else
            {
                VideoBtn.SetBool("disabled", false);
            }            
        }
        else
        {
            VideoBtn.SetBool("visible", false);
        }        
    }
    else
    {
        VideoBtn.SetBool("visible", true);
        VideoBtn.SetString("label", VideoString);
    }
    // End:0x4EB
    if(Frontend == none)
    {
        VideoBtn.SetBool("visible", false);
    }
    Parms.Length = 0;    
    MenuMC.Invoke("UpdateValuesTF", Parms);
    // End:0x74F
    if((AdvGRI(GetPC().WorldInfo.GRI) != none) && AdvGRI(GetPC().WorldInfo.GRI).IsMultiplayerGame() || AdvGRI(GetPC().WorldInfo.GRI).IsSurvivalGame())
    {
        ButtonsMC.GetObject("tutorials").SetBool("visible", false);
        ButtonsMC.GetObject("tutorials_tf").SetText("");
        ButtonsMC.GetObject("subtitles").SetBool("visible", false);
        ButtonsMC.GetObject("subtitles_tf").SetText("");
    }
    // End:0x851
    if(GetPC().WorldInfo.IsConsoleBuild(0))
    {
        ButtonsMC.GetObject("fov").SetBool("visible", false);
        ButtonsMC.GetObject("fov_tf").SetText("");
        ButtonsMC.GetObject("fov_val").SetText("");
    }
    return true;
    //return ReturnValue;    
}

function UpdateFooter()
{
    local array<name> ButtonAliases;

    ButtonAliases.AddItem('GenericSelect');    
    ButtonAliases.AddItem('GenericBack');    
    Frontend.footer.FooterUpdate(ButtonAliases);
    //return;    
}

function OnVolumeMaster(EventData ev)
{
    GetPC().SetAudioGroupVolume('Master', ev.Target.GetFloat("value"));
    bHasChanges = true;
    //return;    
}

function OnVolumeMusic(EventData ev)
{
    GetPC().SetAudioGroupVolume('Music', ev.Target.GetFloat("value"));
    bHasChanges = true;
    //return;    
}

function OnVolumeFx(EventData ev)
{
    GetPC().SetAudioGroupVolume('SFX', ev.Target.GetFloat("value"));
    GetPC().SetAudioGroupVolume('Special', ev.Target.GetFloat("value"));
    bHasChanges = true;
    //return;    
}

function OnVolumeVoice(EventData ev)
{
    GetPC().SetAudioGroupVolume('Voice', ev.Target.GetFloat("value"));
    bHasChanges = true;
    //return;    
}

function OnGamma(EventData ev)
{
    AdvPlayerController(GetPC()).SetGamma(ev.Target.GetFloat("value"));
    bHasChanges = true;
    //return;    
}

function OnFov(EventData ev)
{
    // End:0xA1
    if(!GetPC().WorldInfo.IsConsoleBuild(0))
    {
        GetPC().FOV(ev.Target.GetFloat("value"));
        bHasChanges = true;
    }
    //return;    
}

function OnSubtitles(EventData ev)
{
    GetPC().SetShowSubtitles(bool(ev.Target.GetFloat("selectedIndex")));
    bHasChanges = true;
    //return;    
}

function OnBrightness(EventData ev)
{
    //return;    
}

function OnContrast(EventData ev)
{
    //return;    
}

function OnTutorials(EventData ev)
{
    AdvPlayerController(GetPC()).SetShowTutorials(bool(ev.Target.GetFloat("selectedIndex")));
    bHasChanges = true;
    //return;    
}

function OnBack(EventData ev)
{
    // End:0x2B
    if(bHasChanges)
    {
        ShowSaveWarning(OnBackSelect);        
    }
    else
    {
        OnBackSelect(none, 'GenericNo', LocalPlayerOwnerIndex);
    }
    //return;    
}

function bool OnBackSelect(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    // End:0x25
    if(SelectedInputAlias == 'GenericYes')
    {
        SaveSettingsToProfile();        
    }
    else
    {
        DiscardChanges();
    }
    Action = "back";
    PlayCloseAnimation();
    return true;
    //return ReturnValue;    
}

function OnReset(EventData ev)
{
    ShowResetWarning(OnResetSelect);
    //return;    
}

function bool OnResetSelect(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    local array<ASValue> Parms;

    // End:0xEA
    if(SelectedInputAlias == 'GenericYes')
    {
        ResetToDefaults();
        Parms.Length = 0;        
        MenuMC.Invoke("UpdateValuesTF", Parms);
        // End:0xEA
        if(GetPC().WorldInfo.IsConsoleBuild(0))
        {
            ButtonsMC.GetObject("fov_val").SetText("");
        }
    }
    ResetBtn.SetBool("focused", false);
    ResetBtn.SetBool("focused", true);
    return true;
    //return ReturnValue;    
}

function OnVideoBtn(EventData ev)
{
    // End:0x50
    if(GetPC().WorldInfo.IsConsoleBuild(1))
    {
        OnSelectStorageDevice(ev);        
    }
    else
    {
        // End:0x7B
        if(bHasChanges)
        {
            ShowSaveWarning(OnVideoSelect);            
        }
        else
        {
            OnVideoSelect(none, 'GenericNo', LocalPlayerOwnerIndex);
        }
    }
    //return;    
}

function bool OnVideoSelect(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    // End:0x25
    if(SelectedInputAlias == 'GenericYes')
    {
        SaveSettingsToProfile();        
    }
    else
    {
        DiscardChanges();
    }
    Action = "video";
    PlayCloseAnimation();
    return true;
    //return ReturnValue;    
}

function OnGameplayBtn(EventData ev)
{
    // End:0x2B
    if(bHasChanges)
    {
        ShowSaveWarning(OnGameplaySelect);        
    }
    else
    {
        OnGameplaySelect(none, 'GenericNo', LocalPlayerOwnerIndex);
    }
    //return;    
}

function bool OnGameplaySelect(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    // End:0x25
    if(SelectedInputAlias == 'GenericYes')
    {
        SaveSettingsToProfile();        
    }
    else
    {
        DiscardChanges();
    }
    Action = "gameplay";
    PlayCloseAnimation();
    return true;
    //return ReturnValue;    
}

function OnControlsBtn(EventData ev)
{
    // End:0x2B
    if(bHasChanges)
    {
        ShowSaveWarning(OnControlsSelect);        
    }
    else
    {
        OnControlsSelect(none, 'GenericNo', LocalPlayerOwnerIndex);
    }
    //return;    
}

function bool OnControlsSelect(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    // End:0x25
    if(SelectedInputAlias == 'GenericYes')
    {
        SaveSettingsToProfile();        
    }
    else
    {
        DiscardChanges();
    }
    Action = "controls";
    PlayCloseAnimation();
    return true;
    //return ReturnValue;    
}

function OnSelectStorageDevice(EventData ev)
{
    local AdvPlayerController PC;

    PC = AdvPlayerController(GetPC());
    // End:0xFA
    if((((PC != none) && PC.IsPrimaryPlayer()) && PC.OnlinePlayerData != none) && PC.OnlinePlayerData.StorageProvider != none)
    {
        PC.OnlinePlayerData.StorageProvider.ShowDeviceSelection();
    }
    //return;    
}

function OnSaveSlotBtn(EventData ev)
{
    // End:0x2B
    if(bHasChanges)
    {
        ShowSaveWarning(OnSaveSlotSelect);        
    }
    else
    {
        OnSaveSlotSelect(none, 'GenericNo', LocalPlayerOwnerIndex);
    }
    //return;    
}

function bool OnSaveSlotSelect(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    // End:0x25
    if(SelectedInputAlias == 'GenericYes')
    {
        SaveSettingsToProfile();        
    }
    else
    {
        DiscardChanges();
    }
    Action = "saveslot";
    PlayCloseAnimation();
    return true;
    //return ReturnValue;    
}

function OnCreditsBtn(EventData ev)
{
    // End:0x2B
    if(bHasChanges)
    {
        ShowSaveWarning(OnCreditsSelect);        
    }
    else
    {
        OnCreditsSelect(none, 'GenericNo', LocalPlayerOwnerIndex);
    }
    //return;    
}

function bool OnCreditsSelect(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    // End:0x25
    if(SelectedInputAlias == 'GenericYes')
    {
        SaveSettingsToProfile();        
    }
    else
    {
        DiscardChanges();
    }
    Action = "credits";
    PlayCloseAnimation();
    return true;
    //return ReturnValue;    
}

function OnCloseAnimationComplete()
{
    local float X, Y;
    local bool bTransitionResult;

    switch(Action)
    {
        // End:0x135
        case "back":
            // End:0x58
            if(Frontend != none)
            {
                bTransitionResult = Frontend.OpenMainMenu();                
            }
            else
            {
                // End:0x132
                if(ParentMenu != none)
                {
                    ParentMenu.ActivatePauseScene(GetLP());
                    KursorMC.GetPosition(X, Y);
                    ParentMenu.KursorMC.SetPosition(X, Y);
                    ParentMenu.OptionsMenu = none;
                    Close();
                }
            }
            // End:0xBCC
            break;
        // End:0x3B2
        case "video":
            // End:0x17B
            if(Frontend != none)
            {
                bTransitionResult = Frontend.OpenOptionsVideoScreen();                
            }
            else
            {
                // End:0x3AF
                if(ParentMenu != none)
                {
                    ParentMenu.OptionsMenu = new Class'AdvGFxUI_Menu_Options_Video';
                    ParentMenu.OptionsMenu.SetPriority(69);
                    // End:0x29D
                    if(AdvGRI(GetPC().WorldInfo.GRI).IsPureSinglePlayerGame() || Class'Engine.Engine'.static.IsSplitScreen())
                    {
                        ParentMenu.OptionsMenu.bPauseGameWhileActive = true;
                    }
                    ParentMenu.OptionsMenu.ParentMenu = ParentMenu;
                    ParentMenu.OptionsMenu.Init(GetLP());
                    KursorMC.GetPosition(X, Y);
                    ParentMenu.OptionsMenu.KursorMC.SetPosition(X, Y);
                    Close();
                }
            }
            // End:0xBCC
            break;
        // End:0x632
        case "gameplay":
            // End:0x3FB
            if(Frontend != none)
            {
                bTransitionResult = Frontend.OpenOptionsGameplayScreen();                
            }
            else
            {
                // End:0x62F
                if(ParentMenu != none)
                {
                    ParentMenu.OptionsMenu = new Class'AdvGFxUI_Menu_Options_Gameplay';
                    ParentMenu.OptionsMenu.SetPriority(69);
                    // End:0x51D
                    if(AdvGRI(GetPC().WorldInfo.GRI).IsPureSinglePlayerGame() || Class'Engine.Engine'.static.IsSplitScreen())
                    {
                        ParentMenu.OptionsMenu.bPauseGameWhileActive = true;
                    }
                    ParentMenu.OptionsMenu.ParentMenu = ParentMenu;
                    ParentMenu.OptionsMenu.Init(GetLP());
                    KursorMC.GetPosition(X, Y);
                    ParentMenu.OptionsMenu.KursorMC.SetPosition(X, Y);
                    Close();
                }
            }
            // End:0xBCC
            break;
        // End:0xB8D
        case "controls":
            // End:0x91A
            if(AdvPlayerController(GetPC()).IsPCGamepadMode() || GetPC().WorldInfo.IsConsoleBuild(0))
            {
                // End:0x6E3
                if(Frontend != none)
                {
                    bTransitionResult = Frontend.OpenOptionsControlsXboxScreen();                    
                }
                else
                {
                    // End:0x917
                    if(ParentMenu != none)
                    {
                        ParentMenu.OptionsMenu = new Class'AdvGFxUI_Menu_Options_ControlsXbox';
                        ParentMenu.OptionsMenu.SetPriority(69);
                        // End:0x805
                        if(AdvGRI(GetPC().WorldInfo.GRI).IsPureSinglePlayerGame() || Class'Engine.Engine'.static.IsSplitScreen())
                        {
                            ParentMenu.OptionsMenu.bPauseGameWhileActive = true;
                        }
                        ParentMenu.OptionsMenu.ParentMenu = ParentMenu;
                        ParentMenu.OptionsMenu.Init(GetLP());
                        KursorMC.GetPosition(X, Y);
                        ParentMenu.OptionsMenu.KursorMC.SetPosition(X, Y);
                        Close();
                    }
                }                
            }
            else
            {
                // End:0x956
                if(Frontend != none)
                {
                    bTransitionResult = Frontend.OpenOptionsControlsScreen();                    
                }
                else
                {
                    // End:0xB8A
                    if(ParentMenu != none)
                    {
                        ParentMenu.OptionsMenu = new Class'AdvGFxUI_Menu_Options_Controls';
                        ParentMenu.OptionsMenu.SetPriority(69);
                        // End:0xA78
                        if(AdvGRI(GetPC().WorldInfo.GRI).IsPureSinglePlayerGame() || Class'Engine.Engine'.static.IsSplitScreen())
                        {
                            ParentMenu.OptionsMenu.bPauseGameWhileActive = true;
                        }
                        ParentMenu.OptionsMenu.ParentMenu = ParentMenu;
                        ParentMenu.OptionsMenu.Init(GetLP());
                        KursorMC.GetPosition(X, Y);
                        ParentMenu.OptionsMenu.KursorMC.SetPosition(X, Y);
                        Close();
                    }
                }
            }
            // End:0xBCC
            break;
        // End:0xBC6
        case "credits":
            bTransitionResult = Frontend.OpenCreditsScreen();
            // End:0xBCC
            break;
        // End:0xFFFF
        default:
            // End:0xBCC
            break;
            break;
    }
    // End:0xC09
    if(bTransitionResult && Frontend != none)
    {
        Frontend.CloseOptionsScreen();
    }
    Action = "";
    //return;    
}

function bool GetCallbackForOptionPSID(int OptionPSID, out delegate<EventListener> DelegateToCall)
{
    switch(OptionPSID)
    {
        // End:0x36
        case 57:
            DelegateToCall = OnVolumeMaster;
            // End:0x179
            break;
        // End:0x59
        case 58:
            DelegateToCall = OnVolumeMusic;
            // End:0x179
            break;
        // End:0x7C
        case 59:
            DelegateToCall = OnVolumeFx;
            // End:0x179
            break;
        // End:0x9F
        case 68:
            DelegateToCall = OnVolumeVoice;
            // End:0x179
            break;
        // End:0xC2
        case 63:
            DelegateToCall = OnGamma;
            // End:0x179
            break;
        // End:0xE5
        case 64:
            DelegateToCall = OnBrightness;
            // End:0x179
            break;
        // End:0x108
        case 65:
            DelegateToCall = OnContrast;
            // End:0x179
            break;
        // End:0x12B
        case 82:
            DelegateToCall = OnTutorials;
            // End:0x179
            break;
        // End:0x14E
        case 50:
            DelegateToCall = OnFov;
            // End:0x179
            break;
        // End:0x171
        case 55:
            DelegateToCall = OnSubtitles;
            // End:0x179
            break;
        // End:0xFFFF
        default:
            return false;
            break;
    }    
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x179
    return true;
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x179
    //return ReturnValue;
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x179    
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x179
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x179
}

function GetProfileSettingValuesForOptionsList(int OptionPSID, out array<string> OptionValues)
{
    switch(OptionPSID)
    {
        // End:0x2E
        case 82:
            OptionValues = GenericNoYes;
            // End:0x4F
            break;
        // End:0x49
        case 55:
            OptionValues = GenericNoYes;
            // End:0x4F
            break;
        // End:0xFFFF
        default:
            // End:0x4F
            break;
            break;
    }
    //return;    
}

function TryToShowDeviceSelector()
{
    // End:0x3B
    if(!IsPlayerLoggedIn())
    {
        // End:0x38
        if(Class'Engine.WorldInfo'.static.IsConsoleBuild(2))
        {            
        }        
    }
    else
    {
        LaunchStorageDeviceUI();
    }
    //return;    
}

private final function LaunchStorageDeviceUI()
{
    local OnlinePlayerInterfaceEx PlayerIntEx;
    local int ControllerId;

    ControllerId = AdvPlayerController(GetPC()).GetControllerId();
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0xE5
    if(OnlineSub != none)
    {
        PlayerIntEx = OnlineSub.PlayerInterfaceEx;
        // End:0xE5
        if(NotEqual_InterfaceInterface(PlayerIntEx, OnlinePlayerInterfaceEx(none)))
        {
            // End:0xE5
            if(!PlayerIntEx.ShowDeviceSelectionUI(byte(ControllerId), 0, true))
            {
            }
        }
    }
    //return;    
}

function OnLoginWarningMsg(bool bAccepted)
{
    // End:0x1A
    if(bAccepted)
    {
        TriggerLoginMsg();        
    }
    else
    {
        DisableSaving();
    }
    //return;    
}

defaultproperties
{
    SoundLabel="Sound Options"
    GraphicLabel="Video Options"
    GameplayString="Gameplay Settings"
    ControlsString="Controller Settings"
    VideoString="Advanced Video"
    CreditsString="Credits"
    SaveSlotString="Change Save Slot"
    Storage="Select Storage Device"
    Options[0]=(ProfileSettingId=57,SettingDescription="Master Volume",Type=EOptionSelectorType.OST_Slider,GfxName="vol_master",GfxDescName="vol_master_tf",GFx=none,bIsGlobalValue=true,bIsIdMappedValue=false,Minimum=0.0000000,Maximum=1.0000000,Increment=0.1000000,bIsNotStoredInProfile=false)
    Options[1]=(ProfileSettingId=58,SettingDescription="Music Volume",Type=EOptionSelectorType.OST_Slider,GfxName="vol_music",GfxDescName="vol_music_tf",GFx=none,bIsGlobalValue=true,bIsIdMappedValue=false,Minimum=0.0000000,Maximum=1.0000000,Increment=0.1000000,bIsNotStoredInProfile=false)
    Options[2]=(ProfileSettingId=59,SettingDescription="Effects Volume",Type=EOptionSelectorType.OST_Slider,GfxName="vol_sound",GfxDescName="vol_sound_tf",GFx=none,bIsGlobalValue=true,bIsIdMappedValue=false,Minimum=0.0000000,Maximum=1.0000000,Increment=0.1000000,bIsNotStoredInProfile=false)
    Options[3]=(ProfileSettingId=68,SettingDescription="Dialogs Volume",Type=EOptionSelectorType.OST_Slider,GfxName="vol_voice",GfxDescName="vol_voice_tf",GFx=none,bIsGlobalValue=true,bIsIdMappedValue=false,Minimum=0.0000000,Maximum=1.0000000,Increment=0.1000000,bIsNotStoredInProfile=false)
    Options[4]=(ProfileSettingId=63,SettingDescription="Gamma",Type=EOptionSelectorType.OST_Slider,GfxName="gamma",GfxDescName="gamma_tf",GFx=none,bIsGlobalValue=true,bIsIdMappedValue=false,Minimum=0.0000000,Maximum=1.0000000,Increment=0.0500000,bIsNotStoredInProfile=false)
    Options[5]=(ProfileSettingId=82,SettingDescription="Tutorial Messages",Type=EOptionSelectorType.OST_OptionList,GfxName="tutorials",GfxDescName="tutorials_tf",GFx=none,bIsGlobalValue=true,bIsIdMappedValue=false,Minimum=0.0000000,Maximum=0.0000000,Increment=0.0000000,bIsNotStoredInProfile=false)
    Options[6]=(ProfileSettingId=50,SettingDescription="FOV Value",Type=EOptionSelectorType.OST_Slider,GfxName="fov",GfxDescName="fov_tf",GFx=none,bIsGlobalValue=false,bIsIdMappedValue=false,Minimum=65.0000000,Maximum=140.0000000,Increment=1.0000000,bIsNotStoredInProfile=false)
    Options[7]=(ProfileSettingId=55,SettingDescription="Show Subtitles",Type=EOptionSelectorType.OST_OptionList,GfxName="subtitles",GfxDescName="subtitles_tf",GFx=none,bIsGlobalValue=true,bIsIdMappedValue=false,Minimum=0.0000000,Maximum=0.0000000,Increment=0.0000000,bIsNotStoredInProfile=false)
    HeaderTitleString="Options"
    MovieInfo=SwfMovie'UI_AdvCommon.AdvOptionsMenu'
}