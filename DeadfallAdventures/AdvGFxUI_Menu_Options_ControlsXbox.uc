class AdvGFxUI_Menu_Options_ControlsXbox extends AdvGFxUI_Menu_Options_Base
    config(UI);

var GFxObject ControllerMC;
var GFxObject ControllerA;
var GFxObject ControllerB;
var GFxObject ControllerX;
var GFxObject ControllerY;
var GFxObject ControllerRT;
var GFxObject ControllerLT;
var GFxObject ControllerRB;
var GFxObject ControllerLB;
var GFxObject ControllerStart;
var GFxObject ControllerBack;
var GFxObject ControllerDpadLeft;
var GFxObject ControllerDpadRight;
var GFxObject ControllerDpadUp;
var GFxObject ControllerDpadDown;
var GFxObject ControllerStickLeft;
var GFxObject ControllerStickRight;
var const localized array<localized string> StickScheme;
var const localized string CustomWeapString;
var const localized string DescFire;
var const localized string DescAltFire;
var const localized string DescJump;
var const localized string DescMovement;
var const localized string DescSwitchWeapons;
var const localized string DescStats;
var const localized string DescMenu;
var const localized string DescCamera;
var const localized string DescTarot;
var const localized string DescCustom1;
var const localized string DescCustom2;
var const localized string DescLB;
var const localized string DescDpadLeft;
var const localized string DescDpadRight;
var const localized string DescDpadUp;
var const localized string DescDpadDown;
var const localized string DescDpad;
var AdvProfileSettings.EStickConfigOpts CurrentStickScheme;
var GFxClikWidget SwitchGamepadBtn;

function bool Start(optional bool StartPaused = false)
{
    super.Start(StartPaused);
    Advance(0.0000000);
    ControllerMC = ButtonsMC.GetObject("controller");
    ControllerA = ControllerMC.GetObject("abutton");
    ControllerB = ControllerMC.GetObject("bbutton");
    ControllerX = ControllerMC.GetObject("xbutton");
    ControllerY = ControllerMC.GetObject("ybutton");
    ControllerRT = ControllerMC.GetObject("rt");
    ControllerLT = ControllerMC.GetObject("leftt");
    ControllerRB = ControllerMC.GetObject("rb");
    ControllerLB = ControllerMC.GetObject("lb");
    ControllerStart = ControllerMC.GetObject("start");
    ControllerBack = ControllerMC.GetObject("back");
    ControllerDpadLeft = ControllerMC.GetObject("dpad");
    ControllerDpadRight = ControllerMC.GetObject("dpadright");
    ControllerDpadUp = ControllerMC.GetObject("dpadup");
    ControllerDpadDown = ControllerMC.GetObject("dpaddown");
    ControllerStickLeft = ControllerMC.GetObject("lpad");
    ControllerStickRight = ControllerMC.GetObject("rpad");
    SwitchGamepadBtn = GFxClikWidget(ButtonsMC.GetObject("switch_btn", Class'GFxUI.GFxClikWidget'));
    SwitchGamepadBtn.SetString("label", Localize("AdvGFxUI_Menu_OptionsMenu", "DisableGamepadUI", "ADVGame"));
    SwitchGamepadBtn.SetBool("visible", true);
    CurrentStickScheme = AdvPlayerController(GetPC()).ProfileSettings.GetStickConfigOption();
    UpdateControllerLabels();
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

function UpdateControllerLabels()
{
    ControllerA.SetText(DescJump);
    ControllerB.SetText(DescCustom1);
    ControllerX.SetText(DescTarot);
    ControllerY.SetText(DescCustom2);
    ControllerRT.SetText(DescFire);
    ControllerLT.SetText(DescAltFire);
    ControllerRB.SetText(DescSwitchWeapons);
    ControllerLB.SetText(DescLB);
    ControllerStart.SetText(DescMenu);
    ControllerBack.SetText(DescStats);
    ControllerDpadLeft.SetText((((DescDpadLeft @ "/") @ DescDpadRight) @ "/") @ DescDpadDown);
    switch(CurrentStickScheme)
    {
        // End:0x250
        case 0:
            ControllerStickLeft.SetText(DescMovement);
            ControllerStickRight.SetText(DescCamera);
            // End:0x2B0
            break;
        // End:0x2AA
        case 2:
            ControllerStickLeft.SetText(DescCamera);
            ControllerStickRight.SetText(DescMovement);
            // End:0x2B0
            break;
        // End:0xFFFF
        default:
            // End:0x2B0
            break;
            break;
    }
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

function OnSpecialBtn(EventData ev)
{
    // End:0x2B
    if(bHasChanges)
    {
        ShowSaveWarning(OnSpecialBtnSelect);        
    }
    else
    {
        OnSpecialBtnSelect(none, 'GenericNo', LocalPlayerOwnerIndex);
    }
    //return;    
}

function bool OnSpecialBtnSelect(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
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
    Action = "custom";
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
    // End:0x21
    if(SelectedInputAlias == 'GenericYes')
    {
        ResetToDefaults();
    }
    ResetBtn.SetBool("focused", false);
    ResetBtn.SetBool("focused", true);
    return true;
    //return ReturnValue;    
}

function OnSwitch(EventData ev)
{
    AdvLocalPlayer(GetLP()).bForceNoGamepadUI = true;
    AdvLocalPlayer(GetLP()).SaveConfig();
    // End:0x88
    if(Frontend != none)
    {
        AdvPlayerController(GetPC()).RestartFrontEnd();        
    }
    else
    {
        AdvLocalPlayer(GetLP()).bPCGamepadMode = false;
        OnBack(ev);
        // End:0x150
        if((ParentMenu != none) && ParentMenu.footer != none)
        {
            ParentMenu.footer.Close();
            ParentMenu.footer = none;
        }
    }
    //return;    
}

function OnStickConfig(EventData ev)
{
    CurrentStickScheme = byte(ConvertIndexValueToIdMapped(67, int(ev.Target.GetFloat("selectedIndex"))));
    UpdateControllerLabels();
    bHasChanges = true;
    //return;    
}

function OnSensitivity(EventData ev)
{
    AdvPlayerInput(GetPC().PlayerInput).SensitivityMultiplier = ev.Target.GetFloat("value");
    bHasChanges = true;
    //return;    
}

function OnYInvert(EventData ev)
{
    GetPC().PlayerInput.bInvertMouse = bool(ev.Target.GetFloat("selectedIndex"));
    bHasChanges = true;
    //return;    
}

function OnVibration(EventData ev)
{
    bHasChanges = true;
    // End:0x4C
    if((AdvPlayerControllerMP(GetPC()) != none) && GetPC().IsSpectating())
    {
        return;
    }
    GetPC().ForceFeedbackManager.bAllowsForceFeedback = bool(ev.Target.GetFloat("selectedIndex"));
    //return;    
}

function OnAimZoomToggle(EventData ev)
{
    AdvPlayerInput(GetPC().PlayerInput).bHoldZoom = !bool(ev.Target.GetFloat("selectedIndex"));
    bHasChanges = true;
    //return;    
}

function OnCloseAnimationComplete()
{
    local float X, Y;

    switch(Action)
    {
        // End:0x1F
        case "back":
            // End:0x2C8
            break;
        // End:0x2C2
        case "custom":
            // End:0x7D
            if(Frontend != none)
            {
                // End:0x7A
                if(Frontend.OpenOptionsControlsXboxCustomScreen())
                {
                    Frontend.CloseOptionsControlsXboxScreen();
                }                
            }
            else
            {
                // End:0x2B1
                if(ParentMenu != none)
                {
                    ParentMenu.OptionsMenu = new Class'AdvGFxUI_Menu_Options_ControlsXboxCustom';
                    ParentMenu.OptionsMenu.SetPriority(69);
                    // End:0x19F
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
            Action = "";
            return;
            // End:0x2C8
            break;
        // End:0xFFFF
        default:
            // End:0x2C8
            break;
            break;
    }
    // End:0x31B
    if(Frontend != none)
    {
        // End:0x318
        if(Frontend.OpenOptionsScreen())
        {
            Frontend.CloseOptionsControlsXboxScreen();
        }        
    }
    else
    {
        // End:0x54F
        if(ParentMenu != none)
        {
            ParentMenu.OptionsMenu = new Class'AdvGFxUI_Menu_OptionsMenu';
            ParentMenu.OptionsMenu.SetPriority(69);
            // End:0x43D
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
    Action = "";
    //return;    
}

function bool GetCallbackForOptionPSID(int OptionPSID, out delegate<EventListener> DelegateToCall)
{
    switch(OptionPSID)
    {
        // End:0x36
        case 67:
            DelegateToCall = OnStickConfig;
            // End:0xEC
            break;
        // End:0x59
        case 66:
            DelegateToCall = OnSensitivity;
            // End:0xEC
            break;
        // End:0x7C
        case 2:
            DelegateToCall = OnYInvert;
            // End:0xEC
            break;
        // End:0x9F
        case 54:
            DelegateToCall = OnYInvert;
            // End:0xEC
            break;
        // End:0xC1
        case 1:
            DelegateToCall = OnVibration;
            // End:0xEC
            break;
        // End:0xE4
        case 49:
            DelegateToCall = OnAimZoomToggle;
            // End:0xEC
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
    // 1 & Type:Switch Position:0x0EC
    return true;
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x0EC
    //return ReturnValue;
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x0EC    
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x0EC
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x0EC
}

function GetProfileSettingValuesForOptionsList(int OptionPSID, out array<string> OptionValues)
{
    switch(OptionPSID)
    {
        // End:0x4A
        case 67:
            OptionValues[0] = StickScheme[0];
            OptionValues[1] = StickScheme[2];
            // End:0xBB
            break;
        // End:0x65
        case 2:
            OptionValues = GenericNoYes;
            // End:0xBB
            break;
        // End:0x80
        case 54:
            OptionValues = GenericNoYes;
            // End:0xBB
            break;
        // End:0x9A
        case 1:
            OptionValues = GenericNoYes;
            // End:0xBB
            break;
        // End:0xB5
        case 49:
            OptionValues = GenericNoYes;
            // End:0xBB
            break;
        // End:0xFFFF
        default:
            // End:0xBB
            break;
            break;
    }
    //return;    
}

function int ConvertIndexValueToIdMapped(int OptionPSID, int OptionValue)
{
    switch(OptionPSID)
    {
        // End:0x3E
        case 67:
            // End:0x29
            if(OptionValue == 0)
            {
                return 0;
            }
            // End:0x3B
            if(OptionValue == 1)
            {
                return 2;
            }
            // End:0x82
            break;
        // End:0x50
        case 2:
            return OptionValue;
            // End:0x82
            break;
        // End:0x7A
        case 1:
            // End:0x65
            if(OptionValue == 0)
            {
                return 0;
            }
            // End:0x77
            if(OptionValue == 1)
            {
                return 3;
            }
            // End:0x82
            break;
        // End:0xFFFF
        default:
            return 0;
            break;
    }    
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x082
    //return ReturnValue;
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x082    
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x082
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x082
}

function int ConvertIdMappedToIndexValue(int OptionPSID, int IdMappedIndex)
{
    switch(OptionPSID)
    {
        // End:0x3E
        case 67:
            // End:0x29
            if(IdMappedIndex == 0)
            {
                return 0;
            }
            // End:0x3B
            if(IdMappedIndex == 2)
            {
                return 1;
            }
            // End:0x82
            break;
        // End:0x50
        case 2:
            return IdMappedIndex;
            // End:0x82
            break;
        // End:0x7A
        case 1:
            // End:0x65
            if(IdMappedIndex == 0)
            {
                return 0;
            }
            // End:0x77
            if(IdMappedIndex == 3)
            {
                return 1;
            }
            // End:0x82
            break;
        // End:0xFFFF
        default:
            return 0;
            break;
    }    
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x082
    //return ReturnValue;
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x082    
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x082
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x082
}

defaultproperties
{
    StickScheme[0]="Default"
    StickScheme[1]="Legacy"
    StickScheme[2]="South Paw"
    StickScheme[3]="Legacy South Paw"
    CustomWeapString="Custom Weapons"
    DescFire="Fire Weapon"
    DescAltFire="Zoom weapon"
    DescJump="Jump / Context action"
    DescMovement="Movement (Press to sprint)"
    DescSwitchWeapons="Throw Grenade"
    DescStats="Map / Multiplayer stats"
    DescMenu="Menu"
    DescCamera="Rotate Camera (Press to crouch)"
    DescTarot="Reload"
    DescCustom1="Melee"
    DescCustom2="Change Weapon"
    DescLB="Flashlight / Flashlight attack"
    DescDpadLeft="Notepad previous page"
    DescDpadRight="Notepad next page"
    DescDpadUp="Weapon"
    DescDpadDown="Compass"
    Options[0]=(ProfileSettingId=67,SettingDescription="Controller Button Layout",Type=EOptionSelectorType.OST_OptionList,GfxName="sticks",GfxDescName="sticks_tf",GFx=none,bIsGlobalValue=false,bIsIdMappedValue=true,Minimum=0.0000000,Maximum=0.0000000,Increment=0.0000000,bIsNotStoredInProfile=false)
    Options[1]=(ProfileSettingId=66,SettingDescription="Controller Sensitivity",Type=EOptionSelectorType.OST_Slider,GfxName="vol_master",GfxDescName="vol_master_tf",GFx=none,bIsGlobalValue=false,bIsIdMappedValue=false,Minimum=0.3000000,Maximum=3.0000000,Increment=0.1000000,bIsNotStoredInProfile=false)
    Options[2]=(ProfileSettingId=54,SettingDescription="Look Inversion",Type=EOptionSelectorType.OST_OptionList,GfxName="inverty",GfxDescName="invert_tf",GFx=none,bIsGlobalValue=false,bIsIdMappedValue=false,Minimum=0.0000000,Maximum=0.0000000,Increment=0.0000000,bIsNotStoredInProfile=false)
    Options[3]=(ProfileSettingId=1,SettingDescription="Vibration",Type=EOptionSelectorType.OST_OptionList,GfxName="vibration",GfxDescName="vibration_tf",GFx=none,bIsGlobalValue=false,bIsIdMappedValue=true,Minimum=0.0000000,Maximum=0.0000000,Increment=0.0000000,bIsNotStoredInProfile=false)
    Options[4]=(ProfileSettingId=49,SettingDescription="Toggle zoom",Type=EOptionSelectorType.OST_OptionList,GfxName="controlscheme",GfxDescName="scheme_tf",GFx=none,bIsGlobalValue=false,bIsIdMappedValue=false,Minimum=0.0000000,Maximum=0.0000000,Increment=0.0000000,bIsNotStoredInProfile=false)
    HeaderTitleString="Controller Settings"
    MovieInfo=SwfMovie'UI_AdvCommon.AdvControlsXbox'
}