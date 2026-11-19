class PKGFxUI_Menu_Options_Brightness extends PKGFxUI_Menu_Options_Base
    config(UI);

function bool Start(optional bool StartPaused = false)
{
    super.Start(StartPaused);
    return true;
    //return ReturnValue;    
}

function UpdateFooter()
{
    local array<name> ButtonAliases;

    ButtonAliases.AddItem('GenericSelect');
    FrontEnd.footer.FooterUpdate(ButtonAliases);
    //return;    
}

function OnGamma(EventData ev)
{
    PKPlayerController(GetPC()).SetGamma(ev.Target.GetFloat("value"));
    bHasChanges = true;
    //return;    
}

function OnBack(EventData ev)
{
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
            // End:0x272
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
            // End:0x272
            break;
        // End:0xFFFF
        default:
            // End:0x272
            break;
            break;
    }
    // End:0x2AF
    if(bTransitionResult && FrontEnd != none)
    {
        FrontEnd.CloseOptionsBrightnessScreen();
    }
    Action = "";
    //return;    
}

function bool GetCallbackForOptionPSID(int OptionPSID, out delegate<EventListener> DelegateToCall)
{
    switch(OptionPSID)
    {
        // End:0x36
        case 63:
            DelegateToCall = OnGamma;
            // End:0x3E
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
    // 1 & Type:Switch Position:0x03E
    return true;
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x03E
    //return ReturnValue;
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x03E    
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x03E
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x03E
}

defaultproperties
{
    Options[0]=(ProfileSettingId=63,SettingDescription="Change the brightness of the game",Type=EOptionSelectorType.OST_Slider,GfxName="slider",GfxDescName="slider_tf",GFx=none,bIsGlobalValue=true,bIsIdMappedValue=false,Minimum=0.0000000,Maximum=1.0000000,Increment=0.0500000,bIsNotStoredInProfile=false)
    HeaderTitleString="Set Brightness"
    SaveString="Apply"
    MovieInfo=SwfMovie'PKHD_UI.PKBrightness'
    bEnableGammaCorrection=true
}