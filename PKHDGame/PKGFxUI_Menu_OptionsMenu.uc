class PKGFxUI_Menu_OptionsMenu extends PKGFxUI_Menu_Options_Base
    config(UI);

var GFxObject SoundTF;
var GFxObject GraphicTF;
var GFxClikWidget GameplayBtn;
var GFxClikWidget ControlsBtn;
var GFxClikWidget VideoBtn;
var GFxClikWidget CreditsBtn;
var const localized string SoundLabel;
var const localized string GraphicLabel;
var const localized string GameplayString;
var const localized string ControlsString;
var const localized string VideoString;
var const localized string CreditsString;
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
    GameplayBtn.SetString("label", GameplayString);
    ControlsBtn.SetString("label", ControlsString);
    CreditsBtn.SetString("label", CreditsString);
    SoundTF.SetText(SoundLabel);
    GraphicTF.SetText(GraphicLabel);
    // End:0x352
    if(GetPC().WorldInfo.IsConsoleBuild(0))
    {
        // End:0x326
        if(GetPC().WorldInfo.IsConsoleBuild(1) && FrontEnd != none)
        {
            VideoBtn.SetString("label", Storage);            
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
    // End:0x40C
    if(FrontEnd == none)
    {
        CreditsBtn.SetBool("visible", false);
        VideoBtn.SetBool("visible", false);
    }
    Parms.Length = 0;    
    MenuMC.Invoke("UpdateValuesTF", Parms);
    return true;
    //return ReturnValue;    
}

function UpdateFooter()
{
    local array<name> ButtonAliases;

    ButtonAliases.AddItem('GenericSelect');
    ButtonAliases.AddItem('GenericBack');
    FrontEnd.footer.FooterUpdate(ButtonAliases);
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
    bHasChanges = true;
    //return;    
}

function OnGamma(EventData ev)
{
    PKPlayerController(GetPC()).SetGamma(ev.Target.GetFloat("value"));
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

function OnBack(EventData ev)
{
    // End:0x2B
    if(bHasChanges)
    {
        ShowDiscardWarning(OnBackSelect);        
    }
    else
    {
        OnBackSelect(none, 'GenericYes', LocalPlayerOwnerIndex);
    }
    //return;    
}

function bool OnBackSelect(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    // End:0x31
    if(SelectedInputAlias == 'GenericYes')
    {
        Action = "back";
        PlayCloseAnimation();
    }
    return true;
    //return ReturnValue;    
}

function OnSaveBtn(EventData ev)
{
    Action = "save";
    PlayCloseAnimation();
    //return;    
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
            ShowDiscardWarning(OnVideoSelect);            
        }
        else
        {
            OnVideoSelect(none, 'GenericYes', LocalPlayerOwnerIndex);
        }
    }
    //return;    
}

function bool OnVideoSelect(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    // End:0x32
    if(SelectedInputAlias == 'GenericYes')
    {
        Action = "video";
        PlayCloseAnimation();
    }
    return true;
    //return ReturnValue;    
}

function OnGameplayBtn(EventData ev)
{
    // End:0x2B
    if(bHasChanges)
    {
        ShowDiscardWarning(OnGameplaySelect);        
    }
    else
    {
        OnGameplaySelect(none, 'GenericYes', LocalPlayerOwnerIndex);
    }
    //return;    
}

function bool OnGameplaySelect(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    // End:0x35
    if(SelectedInputAlias == 'GenericYes')
    {
        Action = "gameplay";
        PlayCloseAnimation();
    }
    return true;
    //return ReturnValue;    
}

function OnControlsBtn(EventData ev)
{
    // End:0x2B
    if(bHasChanges)
    {
        ShowDiscardWarning(OnControlsSelect);        
    }
    else
    {
        OnControlsSelect(none, 'GenericYes', LocalPlayerOwnerIndex);
    }
    //return;    
}

function bool OnControlsSelect(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    // End:0x35
    if(SelectedInputAlias == 'GenericYes')
    {
        Action = "controls";
        PlayCloseAnimation();
    }
    return true;
    //return ReturnValue;    
}

function OnSelectStorageDevice(EventData ev)
{
    local PKPlayerController PC;

    PC = PKPlayerController(GetPC());
    // End:0xFA
    if((((PC != none) && PC.IsPrimaryPlayer()) && PC.OnlinePlayerData != none) && PC.OnlinePlayerData.StorageProvider != none)
    {
        PC.OnlinePlayerData.StorageProvider.ShowDeviceSelection();
    }
    //return;    
}

function OnCreditsBtn(EventData ev)
{
    // End:0x2B
    if(bHasChanges)
    {
        ShowDiscardWarning(OnCreditsSelect);        
    }
    else
    {
        OnCreditsSelect(none, 'GenericYes', LocalPlayerOwnerIndex);
    }
    //return;    
}

function bool OnCreditsSelect(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    // End:0x34
    if(SelectedInputAlias == 'GenericYes')
    {
        Action = "credits";
        PlayCloseAnimation();
    }
    return true;
    //return ReturnValue;    
}

function OnCloseAnimationComplete()
{
    local float X, Y;
    local bool bTransitionResult;

    switch(Action)
    {
        // End:0x13F
        case "back":
            DiscardChanges();
            // End:0x62
            if(FrontEnd != none)
            {
                bTransitionResult = FrontEnd.OpenMainMenu();                
            }
            else
            {
                // End:0x13C
                if(ParentMenu != none)
                {
                    ParentMenu.ActivatePauseScene(GetLP());
                    KursorMC.GetPosition(X, Y);
                    ParentMenu.KursorMC.SetPosition(X, Y);
                    ParentMenu.OptionsMenu = none;
                    Close();
                }
            }
            // End:0xF6B
            break;
        // End:0x26C
        case "save":
            SaveSettingsToProfile();
            // End:0x18F
            if(FrontEnd != none)
            {
                bTransitionResult = FrontEnd.OpenMainMenu();                
            }
            else
            {
                // End:0x269
                if(ParentMenu != none)
                {
                    ParentMenu.ActivatePauseScene(GetLP());
                    KursorMC.GetPosition(X, Y);
                    ParentMenu.KursorMC.SetPosition(X, Y);
                    ParentMenu.OptionsMenu = none;
                    Close();
                }
            }
            // End:0xF6B
            break;
        // End:0x58C
        case "video":
            DiscardChanges();
            // End:0x2BC
            if(FrontEnd != none)
            {
                bTransitionResult = FrontEnd.OpenOptionsVideoScreen();                
            }
            else
            {
                // End:0x589
                if(ParentMenu != none)
                {
                    ParentMenu.OptionsMenu = new Class'PKGFxUI_Menu_Options_Video';
                    ParentMenu.OptionsMenu.SetPriority(69);
                    // End:0x477
                    if((PainGRI(GetPC().WorldInfo.GRI).IsPureSinglePlayerGame() || Class'Engine.Engine'.static.IsSplitScreen()) || PainGRI(GetPC().WorldInfo.GRI).IsCoopMultiplayerGame() && int(GetPC().WorldInfo.NetMode) == int(NM_ListenServer))
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
            // End:0xF6B
            break;
        // End:0x8AF
        case "gameplay":
            DiscardChanges();
            // End:0x5DF
            if(FrontEnd != none)
            {
                bTransitionResult = FrontEnd.OpenOptionsGameplayScreen();                
            }
            else
            {
                // End:0x8AC
                if(ParentMenu != none)
                {
                    ParentMenu.OptionsMenu = new Class'PKGFxUI_Menu_Options_Gameplay';
                    ParentMenu.OptionsMenu.SetPriority(69);
                    // End:0x79A
                    if((PainGRI(GetPC().WorldInfo.GRI).IsPureSinglePlayerGame() || Class'Engine.Engine'.static.IsSplitScreen()) || PainGRI(GetPC().WorldInfo.GRI).IsCoopMultiplayerGame() && int(GetPC().WorldInfo.NetMode) == int(NM_ListenServer))
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
            // End:0xF6B
            break;
        // End:0xF22
        case "controls":
            // End:0xC0C
            if(GetPC().WorldInfo.IsConsoleBuild(0))
            {
                DiscardChanges();
                // End:0x93C
                if(FrontEnd != none)
                {
                    bTransitionResult = FrontEnd.OpenOptionsControlsXboxScreen();                    
                }
                else
                {
                    // End:0xC09
                    if(ParentMenu != none)
                    {
                        ParentMenu.OptionsMenu = new Class'PKGFxUI_Menu_Options_ControlsXbox';
                        ParentMenu.OptionsMenu.SetPriority(69);
                        // End:0xAF7
                        if((PainGRI(GetPC().WorldInfo.GRI).IsPureSinglePlayerGame() || Class'Engine.Engine'.static.IsSplitScreen()) || PainGRI(GetPC().WorldInfo.GRI).IsCoopMultiplayerGame() && int(GetPC().WorldInfo.NetMode) == int(NM_ListenServer))
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
                DiscardChanges();
                // End:0xC52
                if(FrontEnd != none)
                {
                    bTransitionResult = FrontEnd.OpenOptionsControlsScreen();                    
                }
                else
                {
                    // End:0xF1F
                    if(ParentMenu != none)
                    {
                        ParentMenu.OptionsMenu = new Class'PKGFxUI_Menu_Options_Controls';
                        ParentMenu.OptionsMenu.SetPriority(69);
                        // End:0xE0D
                        if((PainGRI(GetPC().WorldInfo.GRI).IsPureSinglePlayerGame() || Class'Engine.Engine'.static.IsSplitScreen()) || PainGRI(GetPC().WorldInfo.GRI).IsCoopMultiplayerGame() && int(GetPC().WorldInfo.NetMode) == int(NM_ListenServer))
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
            // End:0xF6B
            break;
        // End:0xF65
        case "credits":
            DiscardChanges();
            bTransitionResult = FrontEnd.OpenCreditsScreen();
            // End:0xF6B
            break;
        // End:0xFFFF
        default:
            // End:0xF6B
            break;
            break;
    }
    // End:0xFA8
    if(bTransitionResult && FrontEnd != none)
    {
        FrontEnd.CloseOptionsScreen();
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
            // End:0xED
            break;
        // End:0x59
        case 58:
            DelegateToCall = OnVolumeMusic;
            // End:0xED
            break;
        // End:0x7C
        case 59:
            DelegateToCall = OnVolumeFx;
            // End:0xED
            break;
        // End:0x9F
        case 63:
            DelegateToCall = OnGamma;
            // End:0xED
            break;
        // End:0xC2
        case 64:
            DelegateToCall = OnBrightness;
            // End:0xED
            break;
        // End:0xE5
        case 65:
            DelegateToCall = OnContrast;
            // End:0xED
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
    // 1 & Type:Switch Position:0x0ED
    return true;
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x0ED
    //return ReturnValue;
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x0ED    
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x0ED
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x0ED
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
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterfaceEx PlayerIntEx;
    local int ControllerId;

    ControllerId = PKPlayerController(GetPC()).GetControllerId();
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x121
    if(OnlineSub != none)
    {
        PlayerIntEx = OnlineSub.PlayerInterfaceEx;
        // End:0x121
        if(NotEqual_InterfaceInterface(PlayerIntEx, OnlinePlayerInterfaceEx(none)))
        {
            PlayerIntEx.AddDeviceSelectionDoneDelegate(byte(ControllerId), OnDeviceSelectionComplete);
            // End:0x121
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

function OnDeviceSelectionComplete(bool bUserSelectedDevice)
{
    local OnlinePlayerInterfaceEx PlayerIntEx;
    local bool bStorageDeviceValid;
    local string DummyDeviceName;
    local int DeviceID;

    PlayerIntEx = PKPlayerController(GetPC()).OnlineSub.PlayerInterfaceEx;
    // End:0x1C5
    if(NotEqual_InterfaceInterface(PlayerIntEx, OnlinePlayerInterfaceEx(none)))
    {
        PlayerIntEx.ClearDeviceSelectionDoneDelegate(byte(PKPlayerController(GetPC()).GetControllerId()), OnDeviceSelectionComplete);
        DeviceID = PlayerIntEx.GetDeviceSelectionResults(byte(PKPlayerController(GetPC()).GetControllerId()), DummyDeviceName);
        bStorageDeviceValid = PlayerIntEx.IsDeviceValid(DeviceID, PKEngine(Class'Engine.Engine'.static.GetEngine()).GetRequiredFreeSpace(DeviceID, PKPlayerController(GetPC()).GetControllerId()));
    }
    // End:0x263
    if((DeviceID > 0) && !bStorageDeviceValid)
    {
        PainGFxHudWrapper(PKPlayerController(GetPC()).myHUD).ShowMessageBox(0, "LoginChangeError", "Hej nie mam miejsca, na dysku!");
    }
    // End:0x306
    if(((DeviceID > 0) && bStorageDeviceValid) && !PKEngine(Class'Engine.Engine'.static.GetEngine()).bShouldWriteCheckpointToDisk)
    {
        PKEngine(Class'Engine.Engine'.static.GetEngine()).bShouldWriteCheckpointToDisk = true;
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
    Storage="Select Storage Device"
    Options[0]=(ProfileSettingId=57,SettingDescription="Master Volume",Type=EOptionSelectorType.OST_Slider,GfxName="vol_master",GfxDescName="vol_master_tf",GFx=none,bIsGlobalValue=true,bIsIdMappedValue=false,Minimum=0.0000000,Maximum=1.0000000,Increment=0.1000000,bIsNotStoredInProfile=false)
    Options[1]=(ProfileSettingId=58,SettingDescription="Music Volume",Type=EOptionSelectorType.OST_Slider,GfxName="vol_music",GfxDescName="vol_music_tf",GFx=none,bIsGlobalValue=true,bIsIdMappedValue=false,Minimum=0.0000000,Maximum=1.0000000,Increment=0.1000000,bIsNotStoredInProfile=false)
    Options[2]=(ProfileSettingId=59,SettingDescription="Effects Volume",Type=EOptionSelectorType.OST_Slider,GfxName="vol_sound",GfxDescName="vol_sound_tf",GFx=none,bIsGlobalValue=true,bIsIdMappedValue=false,Minimum=0.0000000,Maximum=1.0000000,Increment=0.1000000,bIsNotStoredInProfile=false)
    Options[3]=(ProfileSettingId=63,SettingDescription="Gamma",Type=EOptionSelectorType.OST_Slider,GfxName="gamma",GfxDescName="gamma_tf",GFx=none,bIsGlobalValue=true,bIsIdMappedValue=false,Minimum=0.0000000,Maximum=1.0000000,Increment=0.0500000,bIsNotStoredInProfile=false)
    HeaderTitleString="Options"
    MovieInfo=SwfMovie'PKHD_UI.PKOptionsMenu'
}