class PKGFxUI_Menu_Options_Gameplay extends PKGFxUI_Menu_Options_Base
    config(UI);

var GFxClikWidget UIL;

function bool Start(optional bool StartPaused = false)
{
    local array<ASValue> Parms;
    local int CrosshairIndex;

    super.Start(StartPaused);
    Advance(0.0000000);
    UIL = GFxClikWidget(ButtonsMC.GetObject("UIL", Class'GFxUI.GFxClikWidget'));
    CrosshairIndex = PKPlayerController(GetPC()).CrosshairIndex;
    // End:0xD2
    if(Class'PainWeap_Base'.default.AvailableCrosshairs.Length <= CrosshairIndex)
    {
        CrosshairIndex = 0;
    }
    UIL.SetString("source", "img://" $ PathName(Class'PainWeap_Base'.default.AvailableCrosshairs[CrosshairIndex].DotTex));
    ResetBtn = GFxClikWidget(ButtonsMC.GetObject("reset_btn", Class'GFxUI.GFxClikWidget'));
    ResetBtn.SetString("label", DefaultString);
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

function OnReset(EventData ev)
{
    ShowResetWarning(OnResetSelect);
    //return;    
}

function bool OnResetSelect(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    local array<ASValue> Parms;

    // End:0x6E
    if(SelectedInputAlias == 'GenericYes')
    {
        ResetToDefaults();
        Parms.Length = 0;        
        MenuMC.Invoke("UpdateValuesTF", Parms);
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

function OnSubtitles(EventData ev)
{
    GetPC().SetShowSubtitles(bool(ev.Target.GetFloat("selectedIndex")));
    bHasChanges = true;
    //return;    
}

function OnCrosshair(EventData ev)
{
    local int CrosshairIndex;

    CrosshairIndex = int(ev.Target.GetFloat("selectedIndex"));
    // End:0x85
    if(Class'PainWeap_Base'.default.AvailableCrosshairs.Length <= CrosshairIndex)
    {
        CrosshairIndex = 0;
    }
    UIL.SetString("source", "img://" $ PathName(Class'PainWeap_Base'.default.AvailableCrosshairs[CrosshairIndex].DotTex));
    PKPlayerController(GetPC()).CrosshairIndex = CrosshairIndex;
    bHasChanges = true;
    //return;    
}

function OnHUD(EventData ev)
{
    PKPlayerController(GetPC()).SetHUDScale(ev.Target.GetFloat("value"));
    bHasChanges = true;
    //return;    
}

function OnHeadBob(EventData ev)
{
    PKPlayerController(GetPC()).GlobalHeadBob = ev.Target.GetFloat("value");
    PKPlayerController(GetPC()).RefreshPawnParamsFromPC();
    bHasChanges = true;
    //return;    
}

function OnWeaponBob(EventData ev)
{
    PKPlayerController(GetPC()).GlobalWeaponBobDamping = ev.Target.GetFloat("value");
    // End:0x129
    if((GetPC().Pawn != none) && GetPC().Pawn.Weapon != none)
    {
        PainWeap_Base(GetPC().Pawn.Weapon).RefreshWeaponParamsFromPC(PKPlayerController(GetPC()));
    }
    bHasChanges = true;
    //return;    
}

function OnFOV(EventData ev)
{
    GetPC().FOV(ev.Target.GetFloat("value"));
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
            // End:0x46
            break;
        // End:0x40
        case "save":
            SaveSettingsToProfile();
            // End:0x46
            break;
        // End:0xFFFF
        default:
            // End:0x46
            break;
            break;
    }
    // End:0x99
    if(FrontEnd != none)
    {
        // End:0x96
        if(FrontEnd.OpenOptionsScreen())
        {
            FrontEnd.CloseOptionsGameplayScreen();
        }        
    }
    else
    {
        // End:0x366
        if(ParentMenu != none)
        {
            ParentMenu.OptionsMenu = new Class'PKGFxUI_Menu_OptionsMenu';
            ParentMenu.OptionsMenu.SetPriority(69);
            // End:0x254
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
        case 55:
            DelegateToCall = OnSubtitles;
            // End:0xED
            break;
        // End:0x59
        case 56:
            DelegateToCall = OnCrosshair;
            // End:0xED
            break;
        // End:0x7C
        case 89:
            DelegateToCall = OnHUD;
            // End:0xED
            break;
        // End:0x9F
        case 81:
            DelegateToCall = OnHeadBob;
            // End:0xED
            break;
        // End:0xC2
        case 82:
            DelegateToCall = OnWeaponBob;
            // End:0xED
            break;
        // End:0xE5
        case 83:
            DelegateToCall = OnFOV;
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

function GetProfileSettingValuesForOptionsList(int OptionPSID, out array<string> OptionValues)
{
    local int I;

    switch(OptionPSID)
    {
        // End:0x2E
        case 55:
            OptionValues = GenericNoYes;
            // End:0x99
            break;
        // End:0x93
        case 56:
            I = 0;
            J0x3E:

            // End:0x90 [Loop If]
            if(I < Class'PainWeap_Base'.default.AvailableCrosshairs.Length)
            {
                OptionValues[I] = " ";
                I++;
                // [Loop Continue]
                goto J0x3E;
            }
            // End:0x99
            break;
        // End:0xFFFF
        default:
            // End:0x99
            break;
            break;
    }
    //return;    
}

defaultproperties
{
    Options[0]=(ProfileSettingId=55,SettingDescription="Show Subtitles",Type=EOptionSelectorType.OST_OptionList,GfxName="subtitles",GfxDescName="subtitles_tf",GFx=none,bIsGlobalValue=true,bIsIdMappedValue=false,Minimum=0.0000000,Maximum=0.0000000,Increment=0.0000000,bIsNotStoredInProfile=false)
    Options[1]=(ProfileSettingId=56,SettingDescription="Crosshair Type",Type=EOptionSelectorType.OST_OptionList,GfxName="crosshair",GfxDescName="crosshair_tf",GFx=none,bIsGlobalValue=false,bIsIdMappedValue=false,Minimum=0.0000000,Maximum=0.0000000,Increment=0.0000000,bIsNotStoredInProfile=false)
    Options[2]=(ProfileSettingId=89,SettingDescription="HUD Scale",Type=EOptionSelectorType.OST_Slider,GfxName="hudscale",GfxDescName="hudscale_tf",GFx=none,bIsGlobalValue=false,bIsIdMappedValue=false,Minimum=0.5000000,Maximum=1.1000000,Increment=0.0500000,bIsNotStoredInProfile=false)
    Options[3]=(ProfileSettingId=81,SettingDescription="HeadBob Scale",Type=EOptionSelectorType.OST_Slider,GfxName="headbob",GfxDescName="headbob_tf",GFx=none,bIsGlobalValue=false,bIsIdMappedValue=false,Minimum=0.0000000,Maximum=0.0200000,Increment=0.0010000,bIsNotStoredInProfile=false)
    Options[4]=(ProfileSettingId=82,SettingDescription="WeaponBob Scale",Type=EOptionSelectorType.OST_Slider,GfxName="weaponbob",GfxDescName="weaponbob_tf",GFx=none,bIsGlobalValue=false,bIsIdMappedValue=false,Minimum=1.0000000,Maximum=1.3000000,Increment=0.0100000,bIsNotStoredInProfile=false)
    Options[5]=(ProfileSettingId=83,SettingDescription="FOV Value",Type=EOptionSelectorType.OST_Slider,GfxName="fov",GfxDescName="fov_tf",GFx=none,bIsGlobalValue=false,bIsIdMappedValue=false,Minimum=60.0000000,Maximum=120.0000000,Increment=5.0000000,bIsNotStoredInProfile=false)
    HeaderTitleString="Gameplay Settings"
    MovieInfo=SwfMovie'PKHD_UI.PKGameplayOptions'
}