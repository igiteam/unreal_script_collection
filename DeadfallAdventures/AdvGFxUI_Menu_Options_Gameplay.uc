class AdvGFxUI_Menu_Options_Gameplay extends AdvGFxUI_Menu_Options_Base
    config(UI);

var GFxClikWidget UIL;

function bool Start(optional bool StartPaused = false)
{
    super.Start(StartPaused);
    Advance(0.0000000);
    UIL = GFxClikWidget(ButtonsMC.GetObject("UIL", Class'GFxUI.GFxClikWidget'));
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
    CrosshairIndex = 0;
    AdvPlayerController(GetPC()).CrosshairIndex = CrosshairIndex;
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
            // End:0x25
            break;
        // End:0xFFFF
        default:
            // End:0x25
            break;
            break;
    }
    // End:0x78
    if(Frontend != none)
    {
        // End:0x75
        if(Frontend.OpenOptionsScreen())
        {
            Frontend.CloseOptionsGameplayScreen();
        }        
    }
    else
    {
        // End:0x2AC
        if(ParentMenu != none)
        {
            ParentMenu.OptionsMenu = new Class'AdvGFxUI_Menu_OptionsMenu';
            ParentMenu.OptionsMenu.SetPriority(69);
            // End:0x19A
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
        case 55:
            DelegateToCall = OnSubtitles;
            // End:0x61
            break;
        // End:0x59
        case 56:
            DelegateToCall = OnCrosshair;
            // End:0x61
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
    // 1 & Type:Switch Position:0x061
    return true;
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x061
    //return ReturnValue;
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x061    
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x061
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x061
}

function GetProfileSettingValuesForOptionsList(int OptionPSID, out array<string> OptionValues)
{
    switch(OptionPSID)
    {
        // End:0x2E
        case 55:
            OptionValues = GenericNoYes;
            // End:0x34
            break;
        // End:0xFFFF
        default:
            // End:0x34
            break;
            break;
    }
    //return;    
}

defaultproperties
{
    Options[0]=(ProfileSettingId=55,SettingDescription="Show Subtitles",Type=EOptionSelectorType.OST_OptionList,GfxName="subtitles",GfxDescName="subtitles_tf",GFx=none,bIsGlobalValue=true,bIsIdMappedValue=false,Minimum=0.0000000,Maximum=0.0000000,Increment=0.0000000,bIsNotStoredInProfile=false)
    Options[1]=(ProfileSettingId=56,SettingDescription="Crosshair Type",Type=EOptionSelectorType.OST_OptionList,GfxName="crosshair",GfxDescName="crosshair_tf",GFx=none,bIsGlobalValue=false,bIsIdMappedValue=false,Minimum=0.0000000,Maximum=0.0000000,Increment=0.0000000,bIsNotStoredInProfile=false)
    HeaderTitleString="Gameplay Settings"
    MovieInfo=SwfMovie'UI_AdvCommon.AdvGameplayOptions'
}