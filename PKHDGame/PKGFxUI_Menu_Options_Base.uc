class PKGFxUI_Menu_Options_Base extends PKGFxUI_Menu_Base
    config(UI);

enum EOptionSelectorType
{
    OST_Slider,                     // 0
    OST_OptionList,                 // 1
    OST_Check,                      // 2
    OST_Default,                    // 3
    OST_MAX                         // 4
};

struct OptionInfo
{
    var int ProfileSettingId;
    var const localized string SettingDescription;
    var PKGFxUI_Menu_Options_Base.EOptionSelectorType Type;
    var string GfxName;
    var string GfxDescName;
    var GFxClikWidget GFx;
    var bool bIsGlobalValue;
    var bool bIsIdMappedValue;
    var float Minimum;
    var float Maximum;
    var float Increment;
    var bool bIsNotStoredInProfile;

    structdefaultproperties
    {
        ProfileSettingId=0
        SettingDescription=""
        Type=EOptionSelectorType.OST_Slider
        GfxName=""
        GfxDescName=""
        GFx=none
        bIsGlobalValue=false
        bIsIdMappedValue=false
        Minimum=0.0000000
        Maximum=0.0000000
        Increment=0.0000000
        bIsNotStoredInProfile=false
    }
};

var GFxObject ButtonsMC;
var PainGFxUI_PauseMenu ParentMenu;
var bool bIsMenuPPOverrideOn;
var transient bool bHasChanges;
var transient bool bDiscarding;
var array<OptionInfo> Options;
var GFxClikWidget SaveBtn;
var GFxClikWidget BackBtn;
var GFxClikWidget ResetBtn;
var GFxObject HeaderTitleTF;
var const localized string HeaderTitleString;
var const localized string SaveString;
var const localized string DefaultString;
var const localized string DiscardWarning_Title;
var const localized string DiscardWarning_Msg;
var array<string> GenericNoYes;

function bool Start(optional bool StartPaused = false)
{
    super.Start(StartPaused);
    Advance(0.0000000);
    ButtonsMC = MenuMC.GetObject("buttons");
    SaveBtn = GFxClikWidget(ButtonsMC.GetObject("save", Class'GFxUI.GFxClikWidget'));
    SaveBtn.SetString("label", SaveString);
    BackBtn = GFxClikWidget(ButtonsMC.GetObject("back_btn", Class'GFxUI.GFxClikWidget'));
    BackBtn.SetString("label", back);
    // End:0x1A4
    if(GetPC().WorldInfo.IsConsoleBuild(0))
    {
        BackBtn.SetBool("visible", false);
    }
    HeaderTitleTF = MenuMC.GetObject("title").GetObject("textField");
    HeaderTitleTF.SetText(HeaderTitleString);
    GenericNoYes[0] = Localize("Generic", "No", "PKHDGame");
    GenericNoYes[1] = Localize("Generic", "Yes", "PKHDGame");
    SetupOptions();
    return true;
    //return ReturnValue;    
}

function SetupOptions()
{
    local int I, J;
    local delegate<EventListener> OnChangeCallback;
    local GFxObject OptionListProvider;
    local float OptionValue;
    local int OptionValueInt;
    local array<string> OptionValues;
    local int OptionList_Index, OptionList_IndexIdMapped;
    local PainProfileSettings MyProfile;

    MyProfile = PKPlayerController(GetPC()).ProfileSettings;
    I = 0;
    J0x3D:

    // End:0xA86 [Loop If]
    if(I < Options.Length)
    {
        Options[I].GFx = GFxClikWidget(ButtonsMC.GetObject(Options[I].GfxName, Class'GFxUI.GFxClikWidget'));
        GetCallbackForOptionPSID(Options[I].ProfileSettingId, OnChangeCallback);
        switch(Options[I].Type)
        {
            // End:0x45F
            case 0:
                // End:0x1A8
                if(Options[I].bIsNotStoredInProfile)
                {
                    OptionValue = GetNotProfileValueForOptionPSID(Options[I].ProfileSettingId);                    
                }
                else
                {
                    MyProfile.GetProfileSettingValueFloat(Options[I].ProfileSettingId, OptionValue);
                }
                Options[I].GFx.SetFloat("minimum", Options[I].Minimum);
                Options[I].GFx.SetFloat("maximum", Options[I].Maximum);
                Options[I].GFx.SetFloat("snapInterval", Options[I].Increment);
                Options[I].GFx.SetFloat("value", OptionValue);
                Options[I].GFx.AddEventListener('CLIK_change', OnChangeCallback);
                ButtonsMC.GetObject(Options[I].GfxDescName).SetText(Options[I].SettingDescription);
                // End:0xA78
                break;
            // End:0x8A7
            case 1:
                OptionValues.Length = 0;
                GetProfileSettingValuesForOptionsList(Options[I].ProfileSettingId, OptionValues);
                // End:0x5D1
                if(Options[I].bIsIdMappedValue)
                {
                    // End:0x53C
                    if(Options[I].bIsNotStoredInProfile)
                    {
                        OptionList_IndexIdMapped = int(GetNotProfileValueForOptionPSID(Options[I].ProfileSettingId));                        
                    }
                    else
                    {
                        MyProfile.GetProfileSettingValueId(Options[I].ProfileSettingId, OptionList_IndexIdMapped);
                    }
                    OptionList_Index = ConvertIdMappedToIndexValue(Options[I].ProfileSettingId, OptionList_IndexIdMapped);                    
                }
                else
                {
                    // End:0x63A
                    if(Options[I].bIsNotStoredInProfile)
                    {
                        OptionList_Index = int(GetNotProfileValueForOptionPSID(Options[I].ProfileSettingId));                        
                    }
                    else
                    {
                        MyProfile.GetProfileSettingValueInt(Options[I].ProfileSettingId, OptionList_Index);
                    }
                }
                OptionListProvider = CreateArray();
                J = 0;
                J0x6A7:

                // End:0x727 [Loop If]
                if(J < OptionValues.Length)
                {
                    OptionListProvider.SetElementString(J, Class'Engine.UIRoot'.static.SafeCaps(OptionValues[J]));
                    J++;
                    // [Loop Continue]
                    goto J0x6A7;
                }
                Options[I].GFx.SetObject("dataProvider", OptionListProvider);
                Options[I].GFx.SetFloat("selectedIndex", float(OptionList_Index));
                Options[I].GFx.AddEventListener('CLIK_change', OnChangeCallback);
                ButtonsMC.GetObject(Options[I].GfxDescName).SetText(Options[I].SettingDescription);
                // End:0xA78
                break;
            // End:0xA72
            case 2:
                // End:0x915
                if(Options[I].bIsNotStoredInProfile)
                {
                    OptionValueInt = int(GetNotProfileValueForOptionPSID(Options[I].ProfileSettingId));                    
                }
                else
                {
                    MyProfile.GetProfileSettingValueInt(Options[I].ProfileSettingId, OptionValueInt);
                }
                Options[I].GFx.SetBool("selected", bool(OptionValueInt));
                Options[I].GFx.AddEventListener('CLIK_select', OnChangeCallback);
                Options[I].GFx.SetString("label", Options[I].SettingDescription);
                // End:0xA78
                break;
            // End:0xFFFF
            default:
                // End:0xA78
                break;
                break;
        }
        I++;
        // [Loop Continue]
        goto J0x3D;
    }
    //return;    
}

function SaveSettingsToProfile(optional bool InForceSave = false)
{
    local int I, CurrentOptionPSID;
    local OptionInfo CurrentOptionInfo;
    local bool OptionValueBool;
    local float OptionValue, OptionProfileValue_Float;
    local int OptionValueConverted, OptionProfileValue_Int;
    local PainProfileSettings MyProfile;
    local bool bProfileChanged;

    MyProfile = PKPlayerController(GetPC()).ProfileSettings;
    bProfileChanged = InForceSave;
    I = 0;
    J0x57:

    // End:0x466 [Loop If]
    if(I < Options.Length)
    {
        CurrentOptionInfo = Options[I];
        CurrentOptionPSID = CurrentOptionInfo.ProfileSettingId;
        // End:0xD5
        if(CurrentOptionInfo.bIsNotStoredInProfile)
        {            
        }
        else
        {
            switch(CurrentOptionInfo.Type)
            {
                // End:0x1CB
                case 0:
                    OptionValue = CurrentOptionInfo.GFx.GetFloat("value");
                    MyProfile.GetProfileSettingValueFloat(CurrentOptionPSID, OptionProfileValue_Float);
                    // End:0x1C8
                    if(OptionProfileValue_Float != OptionValue)
                    {
                        bProfileChanged = true;
                        MyProfile.SetProfileSettingValueFloat(CurrentOptionPSID, OptionValue);
                    }
                    // End:0x458
                    break;
                // End:0x378
                case 1:
                    OptionValue = CurrentOptionInfo.GFx.GetFloat("selectedIndex");
                    // End:0x2EC
                    if(CurrentOptionInfo.bIsIdMappedValue)
                    {
                        MyProfile.GetProfileSettingValueId(CurrentOptionPSID, OptionProfileValue_Int);
                        OptionValueConverted = ConvertIndexValueToIdMapped(CurrentOptionPSID, int(OptionValue));
                        // End:0x2E9
                        if(OptionProfileValue_Int != OptionValueConverted)
                        {
                            bProfileChanged = true;
                            MyProfile.SetProfileSettingValueId(CurrentOptionPSID, OptionValueConverted);
                        }                        
                    }
                    else
                    {
                        MyProfile.GetProfileSettingValueInt(CurrentOptionPSID, OptionProfileValue_Int);
                        // End:0x375
                        if(OptionProfileValue_Int != int(OptionValue))
                        {
                            bProfileChanged = true;
                            MyProfile.SetProfileSettingValueInt(CurrentOptionPSID, int(OptionValue));
                        }
                    }
                    // End:0x458
                    break;
                // End:0x452
                case 2:
                    OptionValueBool = CurrentOptionInfo.GFx.GetBool("selected");
                    MyProfile.GetProfileSettingValueInt(CurrentOptionPSID, OptionProfileValue_Int);
                    // End:0x44F
                    if(OptionProfileValue_Int != int(OptionValueBool))
                    {
                        bProfileChanged = true;
                        MyProfile.SetProfileSettingValueInt(CurrentOptionPSID, int(OptionValueBool));
                    }
                    // End:0x458
                    break;
                // End:0xFFFF
                default:
                    // End:0x458
                    break;
                    break;
            }
        }
        I++;
        // [Loop Continue]
        goto J0x57;
    }
    // End:0x49E
    if(bProfileChanged)
    {
        PKPlayerController(GetPC()).ClientSaveAllPlayerData(true);
    }
    bHasChanges = false;
    bDiscarding = false;
    //return;    
}

function DiscardChanges()
{
    local int I, CurrentOptionPSID;
    local OptionInfo CurrentOptionInfo;
    local delegate<EventListener> OnChangeCallback;
    local float OptionProfileValue_Float;
    local int OptionProfileValue_Int, OptionProfileValue_IndexIdMapped;
    local PainProfileSettings MyProfile;
    local EventData ev;

    MyProfile = PKPlayerController(GetPC()).ProfileSettings;
    bDiscarding = true;
    I = 0;
    J0x49:

    // End:0x36D [Loop If]
    if(I < Options.Length)
    {
        CurrentOptionInfo = Options[I];
        CurrentOptionPSID = CurrentOptionInfo.ProfileSettingId;
        // End:0xC7
        if(CurrentOptionInfo.bIsNotStoredInProfile)
        {            
        }
        else
        {
            GetCallbackForOptionPSID(CurrentOptionPSID, OnChangeCallback);
            ev.Target = CurrentOptionInfo.GFx;
            switch(CurrentOptionInfo.Type)
            {
                // End:0x1BD
                case 0:
                    MyProfile.GetProfileSettingValueFloat(CurrentOptionPSID, OptionProfileValue_Float);
                    CurrentOptionInfo.GFx.SetFloat("value", OptionProfileValue_Float);
                    // End:0x343
                    break;
                // End:0x2BD
                case 1:
                    // End:0x23D
                    if(CurrentOptionInfo.bIsIdMappedValue)
                    {
                        MyProfile.GetProfileSettingValueId(CurrentOptionPSID, OptionProfileValue_IndexIdMapped);
                        OptionProfileValue_Int = ConvertIdMappedToIndexValue(CurrentOptionPSID, OptionProfileValue_IndexIdMapped);                        
                    }
                    else
                    {
                        MyProfile.GetProfileSettingValueInt(CurrentOptionPSID, OptionProfileValue_Int);
                    }
                    CurrentOptionInfo.GFx.SetFloat("selectedIndex", float(OptionProfileValue_Int));
                    // End:0x343
                    break;
                // End:0x33D
                case 2:
                    MyProfile.GetProfileSettingValueInt(CurrentOptionPSID, OptionProfileValue_Int);
                    CurrentOptionInfo.GFx.SetBool("selected", bool(OptionProfileValue_Int));
                    // End:0x343
                    break;
                // End:0xFFFF
                default:
                    // End:0x343
                    break;
                    break;
            }
            EventListener(ev);
        }
        I++;
        // [Loop Continue]
        goto J0x49;
    }
    bHasChanges = false;
    bDiscarding = false;
    //return;    
}

function ResetToDefaults()
{
    local int I, CurrentOptionPSID;
    local OptionInfo CurrentOptionInfo;
    local delegate<EventListener> OnChangeCallback;
    local float OptionProfileValue_Float;
    local int OptionProfileValue_Int, OptionProfileValue_IndexIdMapped, Option_IdxVal;
    local PainProfileSettings MyProfile;
    local EventData ev;

    MyProfile = PKPlayerController(GetPC()).ProfileSettings;
    bDiscarding = true;
    I = 0;
    J0x49:

    // End:0x439 [Loop If]
    if(I < Options.Length)
    {
        CurrentOptionInfo = Options[I];
        CurrentOptionPSID = CurrentOptionInfo.ProfileSettingId;
        // End:0xC7
        if(CurrentOptionInfo.bIsNotStoredInProfile)
        {            
        }
        else
        {
            GetCallbackForOptionPSID(CurrentOptionPSID, OnChangeCallback);
            ev.Target = CurrentOptionInfo.GFx;
            switch(CurrentOptionInfo.Type)
            {
                // End:0x1EE
                case 0:
                    MyProfile.GetProfileSettingDefaultFloat(CurrentOptionPSID, OptionProfileValue_Float);
                    CurrentOptionInfo.GFx.SetFloat("value", OptionProfileValue_Float);
                    MyProfile.SetProfileSettingValueFloat(CurrentOptionPSID, OptionProfileValue_Float);
                    // End:0x40F
                    break;
                // End:0x358
                case 1:
                    // End:0x2A7
                    if(CurrentOptionInfo.bIsIdMappedValue)
                    {
                        MyProfile.GetProfileSettingDefaultId(CurrentOptionPSID, OptionProfileValue_IndexIdMapped, Option_IdxVal);
                        OptionProfileValue_Int = ConvertIdMappedToIndexValue(CurrentOptionPSID, OptionProfileValue_IndexIdMapped);
                        MyProfile.SetProfileSettingValueId(CurrentOptionPSID, OptionProfileValue_IndexIdMapped);                        
                    }
                    else
                    {
                        MyProfile.GetProfileSettingDefaultInt(CurrentOptionPSID, OptionProfileValue_Int);
                        MyProfile.SetProfileSettingValueInt(CurrentOptionPSID, OptionProfileValue_Int);
                    }
                    CurrentOptionInfo.GFx.SetFloat("selectedIndex", float(OptionProfileValue_Int));
                    // End:0x40F
                    break;
                // End:0x409
                case 2:
                    MyProfile.GetProfileSettingDefaultInt(CurrentOptionPSID, OptionProfileValue_Int);
                    CurrentOptionInfo.GFx.SetBool("selected", bool(OptionProfileValue_Int));
                    MyProfile.SetProfileSettingValueInt(CurrentOptionPSID, OptionProfileValue_Int);
                    // End:0x40F
                    break;
                // End:0xFFFF
                default:
                    // End:0x40F
                    break;
                    break;
            }
            EventListener(ev);
        }
        I++;
        // [Loop Continue]
        goto J0x49;
    }
    PKPlayerController(GetPC()).ClientSaveAllPlayerData(true);
    bHasChanges = false;
    bDiscarding = false;
    //return;    
}

function ShowDiscardWarning(delegate<OnOptionSelected> SelectionCallback)
{
    local array<name> ButtonAliases;

    ButtonAliases.AddItem('GenericYes');
    ButtonAliases.AddItem('GenericNo');
    Class'PKUIManager'.static.ShowUIMessage('DiscardWarning', DiscardWarning_Title, DiscardWarning_Msg, ButtonAliases, SelectionCallback, GetLP());
    //return;    
}

function ShowResetWarning(delegate<OnOptionSelected> SelectionCallback)
{
    local array<name> ButtonAliases;

    ButtonAliases.AddItem('GenericYes');
    ButtonAliases.AddItem('GenericNo');
    Class'PKUIManager'.static.ShowUIMessage('DiscardWarning', Localize("MessageBoxStrings", "ResetToDefaults_Title", "PKHDGame"), Localize("MessageBoxStrings", "ResetToDefaults_Body", "PKHDGame"), ButtonAliases, SelectionCallback, GetLP());
    //return;    
}

function PlayOpenAnimation()
{
    local PKPostProcessManager PP;
    local WorldInfo WI;

    super.PlayOpenAnimation();
    // End:0x118
    if(FrontEnd == none)
    {
        PP = PKPostProcessManager(PKPlayerController(GetPC()).GetPPManager());
        WI = Class'Engine.WorldInfo'.static.GetWorldInfo();
        // End:0x118
        if(PP != none)
        {
            PP.SetMenuOverride(true, 0.4000000, (WI.Game != none) && WI.Game.bPauseable);
            bIsMenuPPOverrideOn = true;
        }
    }
    //return;    
}

function PlayCloseAnimation()
{
    local PKPostProcessManager PP;
    local WorldInfo WI;

    // End:0x0F
    if(bIsPlayingCloseAnimation)
    {
        return;
    }
    super.PlayCloseAnimation();
    // End:0x134
    if(FrontEnd == none)
    {
        // End:0x134
        if(bIsMenuPPOverrideOn)
        {
            PP = PKPostProcessManager(PKPlayerController(GetPC()).GetPPManager());
            WI = Class'Engine.WorldInfo'.static.GetWorldInfo();
            // End:0x134
            if(PP != none)
            {
                PP.SetMenuOverride(false, 0.4000000, (WI.Game != none) && WI.Game.bPauseable);
                bIsMenuPPOverrideOn = false;
            }
        }
    }
    //return;    
}

function bool GetCallbackForOptionPSID(int OptionPSID, out delegate<EventListener> DelegateToCall)
{
    return false;
    //return ReturnValue;    
}

function float GetNotProfileValueForOptionPSID(int OptionPSID)
{
    return 0.0000000;
    //return ReturnValue;    
}

function GetProfileSettingValuesForOptionsList(int OptionPSID, out array<string> OptionValues)
{
    //return;    
}

function int ConvertIndexValueToIdMapped(int OptionPSID, int OptionValue)
{
    return OptionValue;
    //return ReturnValue;    
}

function int ConvertIdMappedToIndexValue(int OptionPSID, int IdMappedIndex)
{
    return IdMappedIndex;
    //return ReturnValue;    
}

defaultproperties
{
    SaveString="Save Settings"
    DefaultString="Reset to defaults"
    DiscardWarning_Title="Discard Changes"
    DiscardWarning_Msg="All your unsaved changes will be lost. Do you want to continue?"
    bHideLesserMovies=true
}