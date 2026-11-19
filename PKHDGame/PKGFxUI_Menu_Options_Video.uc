class PKGFxUI_Menu_Options_Video extends PKGFxUI_Menu_Options_Base
    config(UI);

var array<string> ResolutionMap;
var int SelectedResolutionIndex;
var transient bool bResChanged;
var transient bool bChangingOverall;
var const localized string RestartWarning_Title;
var const localized string RestartWarning_Msg;

function bool Start(optional bool StartPaused = false)
{
    EvilEngine(Class'Engine.Engine'.static.GetEngine()).InitializeNewSystemSettings();
    ResolutionMap = EvilEngine(Class'Engine.Engine'.static.GetEngine()).GetScreenResolutions(SelectedResolutionIndex);
    super.Start(StartPaused);
    Advance(0.0000000);
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

function OnSaveBtn(EventData ev)
{
    local bool bNeedRestart;
    local array<name> ButtonAliases;

    ButtonAliases.AddItem('GenericAccept');
    ButtonAliases.AddItem('GenericCancel');
    // End:0x51
    if(bResChanged)
    {
        bNeedRestart = ApplyResolutionChange();        
    }
    else
    {
        // End:0xA9
        if(bHasChanges)
        {
            bNeedRestart = !EvilEngine(Class'Engine.Engine'.static.GetEngine()).UpdateVideoSettings();
        }
    }
    // End:0x11E
    if(bNeedRestart)
    {
        Class'PKUIManager'.static.ShowUIMessage('RestartWarning', RestartWarning_Title, RestartWarning_Msg, ButtonAliases, OnSaveSelect, GetLP());        
    }
    else
    {
        OnSaveSelect(none, 'GenericContinue', LocalPlayerOwnerIndex);
    }
    //return;    
}

function bool OnSaveSelect(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    switch(SelectedInputAlias)
    {
        // End:0x3C
        case 'GenericContinue':
            Action = "save";
            PlayCloseAnimation();
            // End:0xB1
            break;
        // End:0x6D
        case 'GenericAccept':
            Action = "save_restart";
            PlayCloseAnimation();
            // End:0xB1
            break;
        // End:0xFFFF
        default:
            EvilEngine(Class'Engine.Engine'.static.GetEngine()).RollbackVideoSettings();
            // End:0xB1
            break;
            break;
    }
    return true;
    //return ReturnValue;    
}

function OnResolution(EventData ev)
{
    // End:0x5D
    if(ev.Target.GetFloat("selectedIndex") != float(SelectedResolutionIndex))
    {
        bResChanged = true;
    }
    SelectedResolutionIndex = int(ev.Target.GetFloat("selectedIndex"));
    bHasChanges = true;
    //return;    
}

function FallbackToCustom()
{
    // End:0x89
    if(!bChangingOverall)
    {
        GFxClikWidget(ButtonsMC.GetObject(Options[2].GfxName, Class'GFxUI.GFxClikWidget')).SetFloat("selectedIndex", 0.0000000);
    }
    //return;    
}

function OnDynLight(EventData ev)
{
    PKEngine(Class'Engine.Engine'.static.GetEngine()).SetLightingQuality(int(ev.Target.GetFloat("selectedIndex") + float(1)));
    FallbackToCustom();
    bHasChanges = true;
    //return;    
}

function OnOverallGraphic(EventData ev)
{
    local int I;

    bChangingOverall = true;
    // End:0x1D4
    if(ev.Target.GetFloat("selectedIndex") > float(0))
    {
        I = 1;
        J0x60:

        // End:0x153 [Loop If]
        if(I < 8)
        {
            // End:0x83
            if(I == 2)
            {                
            }
            else
            {
                GFxClikWidget(ButtonsMC.GetObject(Options[I].GfxName, Class'GFxUI.GFxClikWidget')).SetFloat("selectedIndex", ev.Target.GetFloat("selectedIndex") - float(1));
            }
            I++;
            // [Loop Continue]
            goto J0x60;
        }
        EvilEngine(Class'Engine.Engine'.static.GetEngine()).SetGraphicsQuality(int(ev.Target.GetFloat("selectedIndex")));
    }
    bHasChanges = true;
    bChangingOverall = false;
    //return;    
}

function OnTexture(EventData ev)
{
    EvilEngine(Class'Engine.Engine'.static.GetEngine()).SetTextureQuality(int(ev.Target.GetFloat("selectedIndex") + float(1)));
    FallbackToCustom();
    bHasChanges = true;
    //return;    
}

function OnShadow(EventData ev)
{
    EvilEngine(Class'Engine.Engine'.static.GetEngine()).SetShadowQuality(int(ev.Target.GetFloat("selectedIndex") + float(1)));
    FallbackToCustom();
    bHasChanges = true;
    //return;    
}

function OnGeometry(EventData ev)
{
    EvilEngine(Class'Engine.Engine'.static.GetEngine()).SetGeometryQuality(int(ev.Target.GetFloat("selectedIndex") + float(1)));
    FallbackToCustom();
    bHasChanges = true;
    //return;    
}

function OnEffects(EventData ev)
{
    EvilEngine(Class'Engine.Engine'.static.GetEngine()).SetEffectsQuality(int(ev.Target.GetFloat("selectedIndex") + float(1)));
    FallbackToCustom();
    bHasChanges = true;
    //return;    
}

function OnPostprocess(EventData ev)
{
    EvilEngine(Class'Engine.Engine'.static.GetEngine()).SetPostprocessQuality(int(ev.Target.GetFloat("selectedIndex") + float(1)));
    FallbackToCustom();
    bHasChanges = true;
    //return;    
}

function OnVSync(EventData ev)
{
    EvilEngine(Class'Engine.Engine'.static.GetEngine()).SetVSync(ev.Target.GetBool("selected"));
    bHasChanges = true;
    //return;    
}

function OnFramerateSmooth(EventData ev)
{
    EvilEngine(Class'Engine.Engine'.static.GetEngine()).SetFramerateSmoothing(ev.Target.GetBool("selected"));
    bHasChanges = true;
    //return;    
}

function OnProfileWriteCompleteForceRestart(byte LocalUserNum, bool bWasSuccessful)
{
    Class'PKEngine'.static.CloseInputBlockingScene(11);
    EvilEngine(Class'Engine.Engine'.static.GetEngine()).RestartGame();
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
            // End:0x177
            break;
        // End:0x40
        case "save":
            SaveSettingsToProfile();
            // End:0x177
            break;
        // End:0x171
        case "save_restart":
            Class'PKEngine'.static.OpenInputBlockingScene(11);
            // End:0x163
            if((GetPC().OnlineSub != none) && NotEqual_InterfaceInterface(GetPC().OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
            {
                GetPC().OnlineSub.PlayerInterface.AddWriteProfileSettingsCompleteDelegate(byte(GetLP().ControllerId), OnProfileWriteCompleteForceRestart);
            }
            SaveSettingsToProfile(true);
            // End:0x177
            break;
        // End:0xFFFF
        default:
            // End:0x177
            break;
            break;
    }
    // End:0x1CA
    if(FrontEnd != none)
    {
        // End:0x1C7
        if(FrontEnd.OpenOptionsScreen())
        {
            FrontEnd.CloseOptionsVideoScreen();
        }        
    }
    else
    {
        // End:0x497
        if(ParentMenu != none)
        {
            ParentMenu.OptionsMenu = new Class'PKGFxUI_Menu_OptionsMenu';
            ParentMenu.OptionsMenu.SetPriority(69);
            // End:0x385
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
        case 60:
            DelegateToCall = OnResolution;
            // End:0x179
            break;
        // End:0x59
        case 61:
            DelegateToCall = OnDynLight;
            // End:0x179
            break;
        // End:0x7C
        case 90:
            DelegateToCall = OnOverallGraphic;
            // End:0x179
            break;
        // End:0x9F
        case 91:
            DelegateToCall = OnTexture;
            // End:0x179
            break;
        // End:0xC2
        case 92:
            DelegateToCall = OnShadow;
            // End:0x179
            break;
        // End:0xE5
        case 93:
            DelegateToCall = OnGeometry;
            // End:0x179
            break;
        // End:0x108
        case 94:
            DelegateToCall = OnEffects;
            // End:0x179
            break;
        // End:0x12B
        case 95:
            DelegateToCall = OnPostprocess;
            // End:0x179
            break;
        // End:0x14E
        case 96:
            DelegateToCall = OnVSync;
            // End:0x179
            break;
        // End:0x171
        case 97:
            DelegateToCall = OnFramerateSmooth;
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

function float GetNotProfileValueForOptionPSID(int OptionPSID)
{
    switch(OptionPSID)
    {
        // End:0x27
        case 60:
            return float(SelectedResolutionIndex);
            // End:0x2C4
            break;
        // End:0x70
        case 90:
            return float(EvilEngine(Class'Engine.Engine'.static.GetEngine()).GetGraphicsQuality());
            // End:0x2C4
            break;
        // End:0xB9
        case 91:
            return float(EvilEngine(Class'Engine.Engine'.static.GetEngine()).GetTextureQuality());
            // End:0x2C4
            break;
        // End:0x102
        case 92:
            return float(EvilEngine(Class'Engine.Engine'.static.GetEngine()).GetShadowQuality());
            // End:0x2C4
            break;
        // End:0x14B
        case 93:
            return float(EvilEngine(Class'Engine.Engine'.static.GetEngine()).GetGeometryQuality());
            // End:0x2C4
            break;
        // End:0x194
        case 61:
            return float(EvilEngine(Class'Engine.Engine'.static.GetEngine()).GetLightingQuality());
            // End:0x2C4
            break;
        // End:0x1DD
        case 94:
            return float(EvilEngine(Class'Engine.Engine'.static.GetEngine()).GetEffectsQuality());
            // End:0x2C4
            break;
        // End:0x226
        case 95:
            return float(EvilEngine(Class'Engine.Engine'.static.GetEngine()).GetPostprocessQuality());
            // End:0x2C4
            break;
        // End:0x26F
        case 96:
            return float(EvilEngine(Class'Engine.Engine'.static.GetEngine()).GetVSync());
            // End:0x2C4
            break;
        // End:0x2B8
        case 97:
            return float(EvilEngine(Class'Engine.Engine'.static.GetEngine()).GetFramerateSmoothing());
            // End:0x2C4
            break;
        // End:0xFFFF
        default:
            return 0.0000000;
            break;
    }    
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x2C4
    return 0.0000000;
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x2C4
    //return ReturnValue;
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x2C4    
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x2C4
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x2C4
}

function GetProfileSettingValuesForOptionsList(int OptionPSID, out array<string> OptionValues)
{
    local int I;

    switch(OptionPSID)
    {
        // End:0x73
        case 60:
            I = 0;
            J0x23:

            // End:0x70 [Loop If]
            if(I < ResolutionMap.Length)
            {
                OptionValues[I] = ResolutionMap[I];
                I++;
                // [Loop Continue]
                goto J0x23;
            }
            // End:0x34F
            break;
        // End:0x1F1
        case 90:
            OptionValues[0] = Localize("PKGFxUI_Menu_Base", "CustomTxt", "PKHDGame");
            OptionValues[1] = Localize("PKGFxUI_Menu_Base", "VeryLowTxt", "PKHDGame");
            OptionValues[2] = Localize("PKGFxUI_Menu_Base", "LowTxt", "PKHDGame");
            OptionValues[3] = Localize("PKGFxUI_Menu_Base", "MediumTxt", "PKHDGame");
            OptionValues[4] = Localize("PKGFxUI_Menu_Base", "HighTxt", "PKHDGame");
            OptionValues[5] = Localize("PKGFxUI_Menu_Base", "VeryHighTxt", "PKHDGame");
            // End:0x34F
            break;
        // End:0x1F6
        case 61:
        // End:0x1FB
        case 91:
        // End:0x200
        case 92:
        // End:0x205
        case 93:
        // End:0x20A
        case 94:
        // End:0x349
        case 95:
            OptionValues[0] = Localize("PKGFxUI_Menu_Base", "VeryLowTxt", "PKHDGame");
            OptionValues[1] = Localize("PKGFxUI_Menu_Base", "LowTxt", "PKHDGame");
            OptionValues[2] = Localize("PKGFxUI_Menu_Base", "MediumTxt", "PKHDGame");
            OptionValues[3] = Localize("PKGFxUI_Menu_Base", "HighTxt", "PKHDGame");
            OptionValues[4] = Localize("PKGFxUI_Menu_Base", "VeryHighTxt", "PKHDGame");
            // End:0x34F
            break;
        // End:0xFFFF
        default:
            // End:0x34F
            break;
            break;
    }
    //return;    
}

function int ConvertIndexValueToIdMapped(int OptionPSID, int OptionValue)
{
    switch(OptionPSID)
    {
        // End:0x18
        case 61:
        // End:0x1D
        case 91:
        // End:0x22
        case 92:
        // End:0x27
        case 93:
        // End:0x2C
        case 94:
        // End:0x41
        case 95:
            return OptionValue + 1;
            // End:0x49
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
    // 1 & Type:Switch Position:0x049
    //return ReturnValue;
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x049    
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x049
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x049
}

function int ConvertIdMappedToIndexValue(int OptionPSID, int IdMappedIndex)
{
    switch(OptionPSID)
    {
        // End:0x18
        case 61:
        // End:0x1D
        case 91:
        // End:0x22
        case 92:
        // End:0x27
        case 93:
        // End:0x2C
        case 94:
        // End:0x41
        case 95:
            return IdMappedIndex - 1;
            // End:0x49
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
    // 1 & Type:Switch Position:0x049
    //return ReturnValue;
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x049    
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x049
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x049
}

function bool ApplyResolutionChange()
{
    EvilEngine(Class'Engine.Engine'.static.GetEngine()).SetScreenResolution(ResolutionMap[SelectedResolutionIndex]);
    bResChanged = false;
    return !EvilEngine(Class'Engine.Engine'.static.GetEngine()).UpdateVideoSettings();
    //return ReturnValue;    
}

defaultproperties
{
    RestartWarning_Title="Restart Needed"
    RestartWarning_Msg="Game needs to be restarted for the changes to take effect"
    Options[0]=(ProfileSettingId=60,SettingDescription="Resolution",Type=EOptionSelectorType.OST_OptionList,GfxName="resolution",GfxDescName="resolution_tf",GFx=none,bIsGlobalValue=true,bIsIdMappedValue=false,Minimum=0.0000000,Maximum=0.0000000,Increment=0.0000000,bIsNotStoredInProfile=true)
    Options[1]=(ProfileSettingId=61,SettingDescription="Lighting Quality",Type=EOptionSelectorType.OST_OptionList,GfxName="dynamic_lights",GfxDescName="dynamic_lights_tf",GFx=none,bIsGlobalValue=true,bIsIdMappedValue=true,Minimum=0.0000000,Maximum=0.0000000,Increment=0.0000000,bIsNotStoredInProfile=true)
    Options[2]=(ProfileSettingId=90,SettingDescription="Graphics Quality",Type=EOptionSelectorType.OST_OptionList,GfxName="graphics",GfxDescName="graphics_tf",GFx=none,bIsGlobalValue=true,bIsIdMappedValue=false,Minimum=0.0000000,Maximum=0.0000000,Increment=0.0000000,bIsNotStoredInProfile=true)
    Options[3]=(ProfileSettingId=91,SettingDescription="Texture Quality",Type=EOptionSelectorType.OST_OptionList,GfxName="texture",GfxDescName="texture_tf",GFx=none,bIsGlobalValue=true,bIsIdMappedValue=true,Minimum=0.0000000,Maximum=0.0000000,Increment=0.0000000,bIsNotStoredInProfile=true)
    Options[4]=(ProfileSettingId=92,SettingDescription="Shadow Quality",Type=EOptionSelectorType.OST_OptionList,GfxName="shadows",GfxDescName="shadows_tf",GFx=none,bIsGlobalValue=true,bIsIdMappedValue=true,Minimum=0.0000000,Maximum=0.0000000,Increment=0.0000000,bIsNotStoredInProfile=true)
    Options[5]=(ProfileSettingId=93,SettingDescription="Geometry Quality",Type=EOptionSelectorType.OST_OptionList,GfxName="geometry",GfxDescName="geometry_tf",GFx=none,bIsGlobalValue=true,bIsIdMappedValue=true,Minimum=0.0000000,Maximum=0.0000000,Increment=0.0000000,bIsNotStoredInProfile=true)
    Options[6]=(ProfileSettingId=94,SettingDescription="Effects Quality",Type=EOptionSelectorType.OST_OptionList,GfxName="effects",GfxDescName="effects_tf",GFx=none,bIsGlobalValue=true,bIsIdMappedValue=true,Minimum=0.0000000,Maximum=0.0000000,Increment=0.0000000,bIsNotStoredInProfile=true)
    Options[7]=(ProfileSettingId=95,SettingDescription="Postprocessing Quality",Type=EOptionSelectorType.OST_OptionList,GfxName="post_process",GfxDescName="postprocess_tf",GFx=none,bIsGlobalValue=true,bIsIdMappedValue=true,Minimum=0.0000000,Maximum=0.0000000,Increment=0.0000000,bIsNotStoredInProfile=true)
    Options[8]=(ProfileSettingId=96,SettingDescription="Vertical Sync",Type=EOptionSelectorType.OST_Check,GfxName="vsync",GfxDescName="",GFx=none,bIsGlobalValue=true,bIsIdMappedValue=false,Minimum=0.0000000,Maximum=0.0000000,Increment=0.0000000,bIsNotStoredInProfile=true)
    Options[9]=(ProfileSettingId=97,SettingDescription="Framerate Smoothing",Type=EOptionSelectorType.OST_Check,GfxName="framerate",GfxDescName="",GFx=none,bIsGlobalValue=true,bIsIdMappedValue=false,Minimum=0.0000000,Maximum=0.0000000,Increment=0.0000000,bIsNotStoredInProfile=true)
    HeaderTitleString="Advanced Video Options"
    MovieInfo=SwfMovie'PKHD_UI.PKVideoSettings'
}