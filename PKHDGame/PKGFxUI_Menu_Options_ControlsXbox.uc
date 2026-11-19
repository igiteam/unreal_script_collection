class PKGFxUI_Menu_Options_ControlsXbox extends PKGFxUI_Menu_Options_Base
    config(UI);

var GFxClikWidget ControllerScheme;
var GFxObject ControllerSchemeTF;
var GFxClikWidget CustomWeaponsBtn;
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
var GFxObject ControllerDpad;
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
var PainProfileSettings.EStickConfigOpts CurrentStickScheme;

function bool Start(optional bool StartPaused = false)
{
    super.Start(StartPaused);
    Advance(0.0000000);
    CustomWeaponsBtn = GFxClikWidget(ButtonsMC.GetObject("special_btn", Class'GFxUI.GFxClikWidget'));
    ControllerScheme = GFxClikWidget(ButtonsMC.GetObject("controlscheme", Class'GFxUI.GFxClikWidget'));
    ControllerSchemeTF = ButtonsMC.GetObject("scheme_tf");
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
    ControllerDpad = ControllerMC.GetObject("dpad");
    ControllerStickLeft = ControllerMC.GetObject("lpad");
    ControllerStickRight = ControllerMC.GetObject("rpad");
    ControllerScheme.SetBool("visible", false);
    ControllerSchemeTF.SetText(" ");
    CustomWeaponsBtn.SetString("label", CustomWeapString);
    CurrentStickScheme = PKPlayerController(GetPC()).ProfileSettings.GetStickConfigOption();
    UpdateControllerLabels();
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

function UpdateControllerLabels()
{
    ControllerA.SetText(DescJump);
    ControllerB.SetText(DescCustom1);
    ControllerX.SetText(DescTarot);
    ControllerY.SetText(DescCustom2);
    ControllerRT.SetText(DescFire);
    ControllerLT.SetText(DescAltFire);
    ControllerRB.SetText(DescSwitchWeapons);
    ControllerLB.SetText(DescJump);
    ControllerStart.SetText(DescMenu);
    ControllerBack.SetText(DescStats);
    ControllerDpad.SetText(DescSwitchWeapons);
    switch(CurrentStickScheme)
    {
        // End:0x230
        case 0:
            ControllerStickLeft.SetText(DescMovement);
            ControllerStickRight.SetText(DescCamera);
            // End:0x290
            break;
        // End:0x28A
        case 2:
            ControllerStickLeft.SetText(DescCamera);
            ControllerStickRight.SetText(DescMovement);
            // End:0x290
            break;
        // End:0xFFFF
        default:
            // End:0x290
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

function OnSpecialBtn(EventData ev)
{
    // End:0x2B
    if(bHasChanges)
    {
        ShowDiscardWarning(OnSpecialBtnSelect);        
    }
    else
    {
        OnSpecialBtnSelect(none, 'GenericYes', LocalPlayerOwnerIndex);
    }
    //return;    
}

function bool OnSpecialBtnSelect(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    // End:0x33
    if(SelectedInputAlias == 'GenericYes')
    {
        Action = "custom";
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

function OnStickConfig(EventData ev)
{
    CurrentStickScheme = byte(ConvertIndexValueToIdMapped(67, int(ev.Target.GetFloat("selectedIndex"))));
    UpdateControllerLabels();
    bHasChanges = true;
    //return;    
}

function OnSensitivity(EventData ev)
{
    PKPlayerInput(GetPC().PlayerInput).SensitivityMultiplier = ev.Target.GetFloat("value");
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
    GetPC().ForceFeedbackManager.bAllowsForceFeedback = bool(ev.Target.GetFloat("selectedIndex"));
    bHasChanges = true;
    //return;    
}

function OnCloseAnimationComplete()
{
    local float X, Y;

    switch(Action)
    {
        // End:0x29
        case "back":
            DiscardChanges();
            // End:0x38C
            break;
        // End:0x40
        case "save":
            SaveSettingsToProfile();
            // End:0x38C
            break;
        // End:0x386
        case "custom":
            DiscardChanges();
            // End:0xA8
            if(FrontEnd != none)
            {
                // End:0xA5
                if(FrontEnd.OpenOptionsControlsXboxCustomScreen())
                {
                    FrontEnd.CloseOptionsControlsXboxScreen();
                }                
            }
            else
            {
                // End:0x375
                if(ParentMenu != none)
                {
                    ParentMenu.OptionsMenu = new Class'PKGFxUI_Menu_Options_ControlsXboxCustom';
                    ParentMenu.OptionsMenu.SetPriority(69);
                    // End:0x263
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
            Action = "";
            return;
            // End:0x38C
            break;
        // End:0xFFFF
        default:
            // End:0x38C
            break;
            break;
    }
    // End:0x3DF
    if(FrontEnd != none)
    {
        // End:0x3DC
        if(FrontEnd.OpenOptionsScreen())
        {
            FrontEnd.CloseOptionsControlsXboxScreen();
        }        
    }
    else
    {
        // End:0x6AC
        if(ParentMenu != none)
        {
            ParentMenu.OptionsMenu = new Class'PKGFxUI_Menu_OptionsMenu';
            ParentMenu.OptionsMenu.SetPriority(69);
            // End:0x59A
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
            // End:0xA6
            break;
        // End:0x59
        case 66:
            DelegateToCall = OnSensitivity;
            // End:0xA6
            break;
        // End:0x7C
        case 2:
            DelegateToCall = OnYInvert;
            // End:0xA6
            break;
        // End:0x9E
        case 1:
            DelegateToCall = OnVibration;
            // End:0xA6
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
    // 1 & Type:Switch Position:0x0A6
    return true;
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x0A6
    //return ReturnValue;
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x0A6    
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x0A6
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x0A6
}

function GetProfileSettingValuesForOptionsList(int OptionPSID, out array<string> OptionValues)
{
    switch(OptionPSID)
    {
        // End:0x4A
        case 67:
            OptionValues[0] = StickScheme[0];
            OptionValues[1] = StickScheme[2];
            // End:0x85
            break;
        // End:0x65
        case 2:
            OptionValues = GenericNoYes;
            // End:0x85
            break;
        // End:0x7F
        case 1:
            OptionValues = GenericNoYes;
            // End:0x85
            break;
        // End:0xFFFF
        default:
            // End:0x85
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
    DescFire="Fire"
    DescAltFire="Alternative Fire"
    DescJump="Jump"
    DescMovement="Movement (Press to jump)"
    DescSwitchWeapons="Switch Weapons"
    DescStats="Stats"
    DescMenu="Menu"
    DescCamera="Rotate Camera (Press to zoom)"
    DescTarot="Tarot"
    DescCustom1="Custom Fire 1"
    DescCustom2="Custom Fire 2"
    Options[0]=(ProfileSettingId=67,SettingDescription="Controller Button Layout",Type=EOptionSelectorType.OST_OptionList,GfxName="sticks",GfxDescName="sticks_tf",GFx=none,bIsGlobalValue=false,bIsIdMappedValue=true,Minimum=0.0000000,Maximum=0.0000000,Increment=0.0000000,bIsNotStoredInProfile=false)
    Options[1]=(ProfileSettingId=66,SettingDescription="Controller Sensitivity",Type=EOptionSelectorType.OST_Slider,GfxName="vol_master",GfxDescName="vol_master_tf",GFx=none,bIsGlobalValue=false,bIsIdMappedValue=false,Minimum=0.3000000,Maximum=3.0000000,Increment=0.1000000,bIsNotStoredInProfile=false)
    Options[2]=(ProfileSettingId=2,SettingDescription="Look Inversion",Type=EOptionSelectorType.OST_OptionList,GfxName="inverty",GfxDescName="invert_tf",GFx=none,bIsGlobalValue=false,bIsIdMappedValue=true,Minimum=0.0000000,Maximum=0.0000000,Increment=0.0000000,bIsNotStoredInProfile=false)
    Options[3]=(ProfileSettingId=1,SettingDescription="Vibration",Type=EOptionSelectorType.OST_OptionList,GfxName="vibration",GfxDescName="vibration_tf",GFx=none,bIsGlobalValue=false,bIsIdMappedValue=true,Minimum=0.0000000,Maximum=0.0000000,Increment=0.0000000,bIsNotStoredInProfile=false)
    HeaderTitleString="Controller Settings"
    MovieInfo=SwfMovie'PKHD_UI.PKControlsXbox'
}