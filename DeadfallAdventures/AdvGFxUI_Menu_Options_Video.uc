class AdvGFxUI_Menu_Options_Video extends AdvGFxUI_Menu_Options_Base
    config(UI);

var array<string> ResolutionMap;
var int SelectedResolutionIndex;
var transient bool bResChanged;
var transient bool bChangingOverall;
var transient bool bVSyncChanged;
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
    Frontend.footer.FooterUpdate(ButtonAliases);
    //return;    
}

function OnBack(EventData ev)
{
    local bool bNeedRestart;
    local array<name> ButtonAliases;
    local int ppAA, tmpRes;

    ButtonAliases.AddItem('AcceptContinueAnyway');    
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
    // End:0x107
    if(bVSyncChanged)
    {
        tmpRes = SelectedResolutionIndex;
        SelectedResolutionIndex = 0;
        ApplyResolutionChange();
        SelectedResolutionIndex = tmpRes;
        ApplyResolutionChange();
        bVSyncChanged = false;
    }
    ppAA = EvilEngine(Class'Engine.Engine'.static.GetEngine()).GetAntialiasing();
    EvilEngine(Class'Engine.Engine'.static.GetEngine()).SetAA(EvilLocalPlayer(GetLP()), ppAA - 1);
    // End:0x223
    if(bNeedRestart)
    {
        Class'AdvUIManager'.static.ShowUIMessage('RestartWarning', RestartWarning_Title, RestartWarning_Msg, ButtonAliases, OnBackSelect, GetLP());        
    }
    else
    {
        // End:0x24E
        if(bHasChanges)
        {
            ShowSaveWarning(OnBackSelect);            
        }
        else
        {
            OnBackSelect(none, 'GenericNo', LocalPlayerOwnerIndex);
        }
    }
    //return;    
}

function bool OnBackSelect(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    switch(SelectedInputAlias)
    {
        // End:0x32
        case 'GenericYes':
            Action = "save";
            // End:0xAD
            break;
        // End:0x59
        case 'AcceptContinueAnyway':
            Action = "save_restart";
            // End:0xAD
            break;
        // End:0xFFFF
        default:
            Action = "back";
            EvilEngine(Class'Engine.Engine'.static.GetEngine()).RollbackVideoSettings();
            // End:0xAD
            break;
            break;
    }
    PlayCloseAnimation();
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
    AdvEngine(Class'Engine.Engine'.static.GetEngine()).SetLightingQuality(int(ev.Target.GetFloat("selectedIndex") + float(1)));
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
    EvilEngine(Class'Engine.Engine'.static.GetEngine()).SetVSync(bool(ev.Target.GetFloat("selectedIndex")));
    bVSyncChanged = true;
    bHasChanges = true;
    //return;    
}

function OnFramerateSmooth(EventData ev)
{
    EvilEngine(Class'Engine.Engine'.static.GetEngine()).SetFramerateSmoothing(bool(ev.Target.GetFloat("selectedIndex")));
    bHasChanges = true;
    //return;    
}

function OnAntialiasing(EventData ev)
{
    EvilEngine(Class'Engine.Engine'.static.GetEngine()).SetAntialiasing(int(ev.Target.GetFloat("selectedIndex") + float(1)));
    bHasChanges = true;
    //return;    
}

function OnProfileWriteCompleteForceRestart(byte LocalUserNum, bool bWasSuccessful)
{
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
            // End:0x153
            break;
        // End:0x40
        case "save":
            SaveSettingsToProfile();
            // End:0x153
            break;
        // End:0x14D
        case "save_restart":
            // End:0x140
            if((GetPC().OnlineSub != none) && NotEqual_InterfaceInterface(GetPC().OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
            {
                GetPC().OnlineSub.PlayerInterface.AddWriteProfileSettingsCompleteDelegate(byte(GetLP().ControllerId), OnProfileWriteCompleteForceRestart);
            }
            SaveSettingsToProfile(true);
            return;
        // End:0xFFFF
        default:
            // End:0x153
            break;
            break;
    }
    // End:0x1A6
    if(Frontend != none)
    {
        // End:0x1A3
        if(Frontend.OpenOptionsScreen())
        {
            Frontend.CloseOptionsVideoScreen();
        }        
    }
    else
    {
        // End:0x3DA
        if(ParentMenu != none)
        {
            ParentMenu.OptionsMenu = new Class'AdvGFxUI_Menu_OptionsMenu';
            ParentMenu.OptionsMenu.SetPriority(69);
            // End:0x2C8
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
        case 60:
            DelegateToCall = OnResolution;
            // End:0x19C
            break;
        // End:0x59
        case 61:
            DelegateToCall = OnDynLight;
            // End:0x19C
            break;
        // End:0x7C
        case 90:
            DelegateToCall = OnOverallGraphic;
            // End:0x19C
            break;
        // End:0x9F
        case 91:
            DelegateToCall = OnTexture;
            // End:0x19C
            break;
        // End:0xC2
        case 92:
            DelegateToCall = OnShadow;
            // End:0x19C
            break;
        // End:0xE5
        case 93:
            DelegateToCall = OnGeometry;
            // End:0x19C
            break;
        // End:0x108
        case 94:
            DelegateToCall = OnEffects;
            // End:0x19C
            break;
        // End:0x12B
        case 95:
            DelegateToCall = OnPostprocess;
            // End:0x19C
            break;
        // End:0x14E
        case 96:
            DelegateToCall = OnVSync;
            // End:0x19C
            break;
        // End:0x171
        case 97:
            DelegateToCall = OnFramerateSmooth;
            // End:0x19C
            break;
        // End:0x194
        case 106:
            DelegateToCall = OnAntialiasing;
            // End:0x19C
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
    // 1 & Type:Switch Position:0x19C
    return true;
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x19C
    //return ReturnValue;
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x19C    
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x19C
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x19C
}

function float GetNotProfileValueForOptionPSID(int OptionPSID)
{
    switch(OptionPSID)
    {
        // End:0x27
        case 60:
            return float(SelectedResolutionIndex);
            // End:0x314
            break;
        // End:0x70
        case 90:
            return float(EvilEngine(Class'Engine.Engine'.static.GetEngine()).GetGraphicsQuality());
            // End:0x314
            break;
        // End:0xBA
        case 91:
            return float(EvilEngine(Class'Engine.Engine'.static.GetEngine()).GetTextureQuality());
            // End:0x314
            break;
        // End:0x104
        case 92:
            return float(EvilEngine(Class'Engine.Engine'.static.GetEngine()).GetShadowQuality());
            // End:0x314
            break;
        // End:0x14E
        case 93:
            return float(EvilEngine(Class'Engine.Engine'.static.GetEngine()).GetGeometryQuality());
            // End:0x314
            break;
        // End:0x198
        case 61:
            return float(EvilEngine(Class'Engine.Engine'.static.GetEngine()).GetLightingQuality());
            // End:0x314
            break;
        // End:0x1E2
        case 94:
            return float(EvilEngine(Class'Engine.Engine'.static.GetEngine()).GetEffectsQuality());
            // End:0x314
            break;
        // End:0x22C
        case 95:
            return float(EvilEngine(Class'Engine.Engine'.static.GetEngine()).GetPostprocessQuality());
            // End:0x314
            break;
        // End:0x275
        case 96:
            return float(EvilEngine(Class'Engine.Engine'.static.GetEngine()).GetVSync());
            // End:0x314
            break;
        // End:0x2BE
        case 97:
            return float(EvilEngine(Class'Engine.Engine'.static.GetEngine()).GetFramerateSmoothing());
            // End:0x314
            break;
        // End:0x308
        case 106:
            return float(EvilEngine(Class'Engine.Engine'.static.GetEngine()).GetAntialiasing());
            // End:0x314
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
    // 1 & Type:Switch Position:0x314
    return 0.0000000;
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x314
    //return ReturnValue;
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x314    
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x314
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x314
}

function GetProfileSettingValuesForOptionsList(int OptionPSID, out array<string> OptionValues)
{
    local int I, ResX, ResY;
    local float AspRatio;
    local array<string> ResParsed;
    local string AspRatioStr;

    switch(OptionPSID)
    {
        // End:0x270
        case 60:
            I = 0;
            J0x23:

            // End:0x26D [Loop If]
            if(I < ResolutionMap.Length)
            {
                ParseStringIntoArray(ResolutionMap[I], ResParsed, " ", false);
                // End:0x238
                if(ResParsed.Length == 2)
                {
                    ResX = int(ResParsed[0]);
                    ResY = int(ResParsed[1]);
                    AspRatio = float(ResX) / float(ResY);
                    AspRatio = float(int(AspRatio * float(100))) / 100.0000000;
                    // End:0x112
                    if(AspRatio == 1.7700000)
                    {
                        AspRatioStr = "(16:9)";                        
                    }
                    else
                    {
                        // End:0x13A
                        if(AspRatio == 1.6600000)
                        {
                            AspRatioStr = "(15:9)";                            
                        }
                        else
                        {
                            // End:0x178
                            if((AspRatio == 1.6000000) || AspRatio == 1.5600000)
                            {
                                AspRatioStr = "(16:10)";                                
                            }
                            else
                            {
                                // End:0x19F
                                if(AspRatio == 1.5000000)
                                {
                                    AspRatioStr = "(3:2)";                                    
                                }
                                else
                                {
                                    // End:0x1C6
                                    if(AspRatio == 1.3300000)
                                    {
                                        AspRatioStr = "(4:3)";                                        
                                    }
                                    else
                                    {
                                        // End:0x1ED
                                        if(AspRatio == 1.2500000)
                                        {
                                            AspRatioStr = "(5:4)";                                            
                                        }
                                        else
                                        {
                                            AspRatioStr = "";
                                        }
                                    }
                                }
                            }
                        }
                    }
                    OptionValues[I] = ((ResParsed[0] $ "x") $ ResParsed[1]) @ AspRatioStr;                    
                }
                else
                {
                    OptionValues[I] = ResolutionMap[I];
                }
                I++;
                // [Loop Continue]
                goto J0x23;
            }
            // End:0x5CF
            break;
        // End:0x3EE
        case 90:
            OptionValues[0] = Localize("AdvGFxUI_Menu_Base", "CustomTxt", "ADVGame");
            OptionValues[1] = Localize("AdvGFxUI_Menu_Base", "VeryLowTxt", "ADVGame");
            OptionValues[2] = Localize("AdvGFxUI_Menu_Base", "LowTxt", "ADVGame");
            OptionValues[3] = Localize("AdvGFxUI_Menu_Base", "MediumTxt", "ADVGame");
            OptionValues[4] = Localize("AdvGFxUI_Menu_Base", "HighTxt", "ADVGame");
            OptionValues[5] = Localize("AdvGFxUI_Menu_Base", "VeryHighTxt", "ADVGame");
            // End:0x5CF
            break;
        // End:0x3F3
        case 61:
        // End:0x3F8
        case 91:
        // End:0x3FD
        case 92:
        // End:0x402
        case 93:
        // End:0x407
        case 94:
        // End:0x546
        case 95:
            OptionValues[0] = Localize("AdvGFxUI_Menu_Base", "VeryLowTxt", "ADVGame");
            OptionValues[1] = Localize("AdvGFxUI_Menu_Base", "LowTxt", "ADVGame");
            OptionValues[2] = Localize("AdvGFxUI_Menu_Base", "MediumTxt", "ADVGame");
            OptionValues[3] = Localize("AdvGFxUI_Menu_Base", "HighTxt", "ADVGame");
            OptionValues[4] = Localize("AdvGFxUI_Menu_Base", "VeryHighTxt", "ADVGame");
            // End:0x5CF
            break;
        // End:0x54B
        case 96:
        // End:0x566
        case 97:
            OptionValues = GenericNoYes;
            // End:0x5CF
            break;
        // End:0x5C9
        case 106:
            OptionValues[0] = GenericNoYes[0];
            OptionValues[1] = "x2";
            OptionValues[2] = "x4";
            OptionValues[3] = "x8";
            OptionValues[4] = "x16";
            // End:0x5CF
            break;
        // End:0xFFFF
        default:
            // End:0x5CF
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
        // End:0x31
        case 95:
        // End:0x46
        case 106:
            return OptionValue + 1;
            // End:0x4E
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
    // 1 & Type:Switch Position:0x04E
    //return ReturnValue;
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x04E    
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x04E
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x04E
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
        // End:0x31
        case 95:
        // End:0x46
        case 106:
            return IdMappedIndex - 1;
            // End:0x4E
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
    // 1 & Type:Switch Position:0x04E
    //return ReturnValue;
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x04E    
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x04E
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x04E
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
    Options[8]=(ProfileSettingId=96,SettingDescription="Vertical Sync",Type=EOptionSelectorType.OST_OptionList,GfxName="vsync",GfxDescName="vsync_tf",GFx=none,bIsGlobalValue=true,bIsIdMappedValue=false,Minimum=0.0000000,Maximum=0.0000000,Increment=0.0000000,bIsNotStoredInProfile=true)
    Options[9]=(ProfileSettingId=97,SettingDescription="Framerate Smoothing",Type=EOptionSelectorType.OST_OptionList,GfxName="framerate",GfxDescName="framerate_tf",GFx=none,bIsGlobalValue=true,bIsIdMappedValue=false,Minimum=0.0000000,Maximum=0.0000000,Increment=0.0000000,bIsNotStoredInProfile=true)
    Options[10]=(ProfileSettingId=106,SettingDescription="Anti-aliasing",Type=EOptionSelectorType.OST_OptionList,GfxName="antialiasing",GfxDescName="antialiasing_tf",GFx=none,bIsGlobalValue=true,bIsIdMappedValue=true,Minimum=0.0000000,Maximum=0.0000000,Increment=0.0000000,bIsNotStoredInProfile=true)
    HeaderTitleString="Advanced Video Options"
    MovieInfo=SwfMovie'UI_AdvCommon.AdvVideoSettings'
}