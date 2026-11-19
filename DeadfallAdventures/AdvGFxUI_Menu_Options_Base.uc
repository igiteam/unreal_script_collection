class AdvGFxUI_Menu_Options_Base extends AdvGFxUI_Menu_Base
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
    var AdvGFxUI_Menu_Options_Base.EOptionSelectorType Type;
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
var AdvGFxUI_PauseMenu ParentMenu;
var bool bIsMenuPPOverrideOn;
var transient bool bHasChanges;
var transient bool bDiscarding;
var array<OptionInfo> Options;
var GFxClikWidget BackBtn;
var GFxClikWidget ResetBtn;
var GFxObject HeaderTitleTF;
var const localized string HeaderTitleString;
var const localized string SaveString;
var const localized string DefaultString;
var const localized string SaveWarning_Title;
var const localized string SaveWarning_Msg;
var array<string> GenericNoYes;

function Init(optional LocalPlayer Player)
{
    super(AdvGfxMoviePlayer).Init(Player);
    // End:0x3E
    if(Frontend != none)
    {
        bHideLesserMovies = false;
        LesserHideFadeDuration = 0.0000000;
    }
    //return;    
}

function bool Start(optional bool StartPaused = false)
{
    super.Start(StartPaused);
    Advance(0.0000000);
    ButtonsMC = MenuMC.GetObject("buttons");
    ResetBtn = GFxClikWidget(ButtonsMC.GetObject("reset_btn", Class'GFxUI.GFxClikWidget'));
    ResetBtn.SetString("label", DefaultString);
    BackBtn = GFxClikWidget(ButtonsMC.GetObject("back_btn", Class'GFxUI.GFxClikWidget'));
    BackBtn.SetString("label", back);
    // End:0x1D7
    if(GetPC().WorldInfo.IsConsoleBuild(0) || AdvPlayerController(GetPC()).IsPCGamepadMode())
    {
        BackBtn.SetBool("visible", false);
    }
    HeaderTitleTF = MenuMC.GetObject("title").GetObject("textField");
    HeaderTitleTF.SetText(HeaderTitleString);
    GenericNoYes[0] = Localize("Generic", "No", "ADVGame");
    GenericNoYes[1] = Localize("Generic", "Yes", "ADVGame");
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
    local AdvProfileSettings MyProfile;
    local AdvLocalPlayer LP;
    local AdvEngine Eng;
    local bool bPrimaryPlayerIsLogged;

    MyProfile = AdvPlayerController(GetPC()).ProfileSettings;
    Eng = AdvEngine(Class'Engine.Engine'.static.GetEngine());
    LP = ((Eng == none) ? none : Eng.GetLocalPlayerByIndex(0));
    bPrimaryPlayerIsLogged = (Eng != none) && int(OnlineSub.PlayerInterface.GetLoginStatus(byte(LP.ControllerId))) > int(0);
    I = 0;
    J0x124:

    // End:0x1154 [Loop If]
    if(I < Options.Length)
    {
        Options[I].GFx = GFxClikWidget(ButtonsMC.GetObject(Options[I].GfxName, Class'GFxUI.GFxClikWidget'));
        GetCallbackForOptionPSID(Options[I].ProfileSettingId, OnChangeCallback);
        switch(Options[I].Type)
        {
            // End:0x7C2
            case 0:
                // End:0x28F
                if(Options[I].bIsNotStoredInProfile)
                {
                    OptionValue = GetNotProfileValueForOptionPSID(Options[I].ProfileSettingId);                    
                }
                else
                {
                    // End:0x50B
                    if(!bPrimaryPlayerIsLogged)
                    {
                        // End:0x2F8
                        if(Options[I].ProfileSettingId == 57)
                        {
                            OptionValue = MyProfile.GetMasterVolume();                            
                        }
                        else
                        {
                            // End:0x352
                            if(Options[I].ProfileSettingId == 58)
                            {
                                OptionValue = MyProfile.GetMusicVolume();                                
                            }
                            else
                            {
                                // End:0x3AC
                                if(Options[I].ProfileSettingId == 59)
                                {
                                    OptionValue = MyProfile.GetSFXVolume();                                    
                                }
                                else
                                {
                                    // End:0x406
                                    if(Options[I].ProfileSettingId == 68)
                                    {
                                        OptionValue = MyProfile.GetVoiceVolume();                                        
                                    }
                                    else
                                    {
                                        // End:0x460
                                        if(Options[I].ProfileSettingId == 63)
                                        {
                                            OptionValue = MyProfile.GetGamma();                                            
                                        }
                                        else
                                        {
                                            // End:0x4BA
                                            if(Options[I].ProfileSettingId == 66)
                                            {
                                                OptionValue = MyProfile.GetSensitivity();                                                
                                            }
                                            else
                                            {
                                                MyProfile.GetProfileSettingValueFloat(Options[I].ProfileSettingId, OptionValue);
                                            }
                                        }
                                    }
                                }
                            }
                        }                        
                    }
                    else
                    {
                        MyProfile.GetProfileSettingValueFloat(Options[I].ProfileSettingId, OptionValue);
                    }
                }
                Options[I].GFx.SetFloat("minimum", Options[I].Minimum);
                Options[I].GFx.SetFloat("maximum", Options[I].Maximum);
                Options[I].GFx.SetFloat("snapInterval", Options[I].Increment);
                Options[I].GFx.SetFloat("value", OptionValue);
                Options[I].GFx.AddEventListener('CLIK_change', OnChangeCallback);
                ButtonsMC.GetObject(Options[I].GfxDescName).SetText(Options[I].SettingDescription);
                // End:0x1146
                break;
            // End:0xF75
            case 1:
                OptionValues.Length = 0;
                GetProfileSettingValuesForOptionsList(Options[I].ProfileSettingId, OptionValues);
                // End:0xAD1
                if(Options[I].bIsIdMappedValue)
                {
                    // End:0x89F
                    if(Options[I].bIsNotStoredInProfile)
                    {
                        OptionList_IndexIdMapped = int(GetNotProfileValueForOptionPSID(Options[I].ProfileSettingId));                        
                    }
                    else
                    {
                        // End:0xA3C
                        if(!bPrimaryPlayerIsLogged)
                        {
                            // End:0x932
                            if(Options[I].ProfileSettingId == 1)
                            {
                                OptionList_IndexIdMapped = int(MyProfile.GetControllerVibrationOption());
                                // End:0x924
                                if(OptionList_IndexIdMapped == 1)
                                {
                                    OptionList_IndexIdMapped = 3;                                    
                                }
                                else
                                {
                                    OptionList_IndexIdMapped = 0;
                                }                                
                            }
                            else
                            {
                                // End:0x98E
                                if(Options[I].ProfileSettingId == 2)
                                {
                                    OptionList_IndexIdMapped = int(MyProfile.GetInvertY());                                    
                                }
                                else
                                {
                                    // End:0x9EA
                                    if(Options[I].ProfileSettingId == 67)
                                    {
                                        OptionList_IndexIdMapped = int(MyProfile.GetStickConfigOption());                                        
                                    }
                                    else
                                    {
                                        MyProfile.GetProfileSettingValueId(Options[I].ProfileSettingId, OptionList_IndexIdMapped);
                                    }
                                }
                            }                            
                        }
                        else
                        {
                            MyProfile.GetProfileSettingValueId(Options[I].ProfileSettingId, OptionList_IndexIdMapped);
                        }
                    }
                    OptionList_Index = ConvertIdMappedToIndexValue(Options[I].ProfileSettingId, OptionList_IndexIdMapped);                    
                }
                else
                {
                    // End:0xB3A
                    if(Options[I].bIsNotStoredInProfile)
                    {
                        OptionList_Index = int(GetNotProfileValueForOptionPSID(Options[I].ProfileSettingId));                        
                    }
                    else
                    {
                        // End:0xD08
                        if(!bPrimaryPlayerIsLogged)
                        {
                            // End:0xBA5
                            if(Options[I].ProfileSettingId == 55)
                            {
                                OptionList_Index = int(MyProfile.GetShowSubtitles());                                
                            }
                            else
                            {
                                // End:0xBFF
                                if(Options[I].ProfileSettingId == 56)
                                {
                                    OptionList_Index = MyProfile.GetCrosshairType();                                    
                                }
                                else
                                {
                                    // End:0xC5B
                                    if(Options[I].ProfileSettingId == 82)
                                    {
                                        OptionList_Index = int(MyProfile.GetShowTutorials());                                        
                                    }
                                    else
                                    {
                                        // End:0xCB7
                                        if(Options[I].ProfileSettingId == 49)
                                        {
                                            OptionList_Index = int(MyProfile.GetAimZoomToggle());                                            
                                        }
                                        else
                                        {
                                            MyProfile.GetProfileSettingValueInt(Options[I].ProfileSettingId, OptionList_Index);
                                        }
                                    }
                                }
                            }                            
                        }
                        else
                        {
                            MyProfile.GetProfileSettingValueInt(Options[I].ProfileSettingId, OptionList_Index);
                        }
                    }
                }
                OptionListProvider = CreateArray();
                J = 0;
                J0xD75:

                // End:0xDF5 [Loop If]
                if(J < OptionValues.Length)
                {
                    OptionListProvider.SetElementString(J, Class'Engine.UIRoot'.static.SafeCaps(OptionValues[J]));
                    J++;
                    // [Loop Continue]
                    goto J0xD75;
                }
                Options[I].GFx.SetObject("dataProvider", OptionListProvider);
                Options[I].GFx.SetFloat("selectedIndex", float(OptionList_Index));
                Options[I].GFx.AddEventListener('CLIK_change', OnChangeCallback);
                ButtonsMC.GetObject(Options[I].GfxDescName).SetText(Options[I].SettingDescription);
                // End:0x1146
                break;
            // End:0x1140
            case 2:
                // End:0xFE3
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
                // End:0x1146
                break;
            // End:0xFFFF
            default:
                // End:0x1146
                break;
                break;
        }
        I++;
        // [Loop Continue]
        goto J0x124;
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
    local AdvProfileSettings MyProfile;
    local bool bProfileChanged;
    local AdvEngine Eng;
    local AdvLocalPlayer LP;
    local bool bPrimaryPlayerIsLogged;

    MyProfile = AdvPlayerController(GetPC()).ProfileSettings;
    Eng = AdvEngine(Class'Engine.Engine'.static.GetEngine());
    LP = ((Eng == none) ? none : Eng.GetLocalPlayerByIndex(0));
    bPrimaryPlayerIsLogged = (Eng != none) && int(OnlineSub.PlayerInterface.GetLoginStatus(byte(LP.ControllerId))) > int(0);
    bProfileChanged = InForceSave;
    I = 0;
    J0x13E:

    // End:0x54D [Loop If]
    if(I < Options.Length)
    {
        CurrentOptionInfo = Options[I];
        CurrentOptionPSID = CurrentOptionInfo.ProfileSettingId;
        // End:0x1BC
        if(CurrentOptionInfo.bIsNotStoredInProfile)
        {            
        }
        else
        {
            switch(CurrentOptionInfo.Type)
            {
                // End:0x2B2
                case 0:
                    OptionValue = CurrentOptionInfo.GFx.GetFloat("value");
                    MyProfile.GetProfileSettingValueFloat(CurrentOptionPSID, OptionProfileValue_Float);
                    // End:0x2AF
                    if(OptionProfileValue_Float != OptionValue)
                    {
                        bProfileChanged = true;
                        MyProfile.SetProfileSettingValueFloat(CurrentOptionPSID, OptionValue);
                    }
                    // End:0x53F
                    break;
                // End:0x45F
                case 1:
                    OptionValue = CurrentOptionInfo.GFx.GetFloat("selectedIndex");
                    // End:0x3D3
                    if(CurrentOptionInfo.bIsIdMappedValue)
                    {
                        MyProfile.GetProfileSettingValueId(CurrentOptionPSID, OptionProfileValue_Int);
                        OptionValueConverted = ConvertIndexValueToIdMapped(CurrentOptionPSID, int(OptionValue));
                        // End:0x3D0
                        if(OptionProfileValue_Int != OptionValueConverted)
                        {
                            bProfileChanged = true;
                            MyProfile.SetProfileSettingValueId(CurrentOptionPSID, OptionValueConverted);
                        }                        
                    }
                    else
                    {
                        MyProfile.GetProfileSettingValueInt(CurrentOptionPSID, OptionProfileValue_Int);
                        // End:0x45C
                        if(OptionProfileValue_Int != int(OptionValue))
                        {
                            bProfileChanged = true;
                            MyProfile.SetProfileSettingValueInt(CurrentOptionPSID, int(OptionValue));
                        }
                    }
                    // End:0x53F
                    break;
                // End:0x539
                case 2:
                    OptionValueBool = CurrentOptionInfo.GFx.GetBool("selected");
                    MyProfile.GetProfileSettingValueInt(CurrentOptionPSID, OptionProfileValue_Int);
                    // End:0x536
                    if(OptionProfileValue_Int != int(OptionValueBool))
                    {
                        bProfileChanged = true;
                        MyProfile.SetProfileSettingValueInt(CurrentOptionPSID, int(OptionValueBool));
                    }
                    // End:0x53F
                    break;
                // End:0xFFFF
                default:
                    // End:0x53F
                    break;
                    break;
            }
        }
        I++;
        // [Loop Continue]
        goto J0x13E;
    }
    // End:0x677
    if(bProfileChanged)
    {
        // End:0x5F5
        if(((Frontend == none) && OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
        {
            Class'AdvUIManager'.static.OpenUpdatingScene("SavingContent_ShortMessage",,, 1.0000000);
        }
        AdvPlayerController(GetPC()).ClientSaveAllPlayerData(true);
        Eng.FillTemporarySettingsFromProfile();
        // End:0x677
        if(!bPrimaryPlayerIsLogged)
        {
            AdvPlayerController(GetPC()).UpdateControllerConfig();
        }
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
    local AdvProfileSettings MyProfile;
    local EventData ev;
    local AdvEngine Eng;
    local bool bPrimaryPlayerIsLogged;
    local AdvLocalPlayer LP;

    Eng = AdvEngine(Class'Engine.Engine'.static.GetEngine());
    LP = ((Eng == none) ? none : Eng.GetLocalPlayerByIndex(0));
    bPrimaryPlayerIsLogged = (Eng != none) && int(OnlineSub.PlayerInterface.GetLoginStatus(byte(LP.ControllerId))) > int(0);
    MyProfile = AdvPlayerController(GetPC()).ProfileSettings;
    bDiscarding = true;
    I = 0;
    J0x130:

    // End:0x842 [Loop If]
    if(I < Options.Length)
    {
        CurrentOptionInfo = Options[I];
        CurrentOptionPSID = CurrentOptionInfo.ProfileSettingId;
        // End:0x1AE
        if(CurrentOptionInfo.bIsNotStoredInProfile)
        {            
        }
        else
        {
            GetCallbackForOptionPSID(CurrentOptionPSID, OnChangeCallback);
            ev.Target = CurrentOptionInfo.GFx;
            switch(CurrentOptionInfo.Type)
            {
                // End:0x455
                case 0:
                    // End:0x3DF
                    if(!bPrimaryPlayerIsLogged)
                    {
                        // End:0x27A
                        if(CurrentOptionPSID == 57)
                        {
                            OptionProfileValue_Float = MyProfile.GetMasterVolume();                            
                        }
                        else
                        {
                            // End:0x2B7
                            if(CurrentOptionPSID == 58)
                            {
                                OptionProfileValue_Float = MyProfile.GetMusicVolume();                                
                            }
                            else
                            {
                                // End:0x2F4
                                if(CurrentOptionPSID == 59)
                                {
                                    OptionProfileValue_Float = MyProfile.GetSFXVolume();                                    
                                }
                                else
                                {
                                    // End:0x331
                                    if(CurrentOptionPSID == 68)
                                    {
                                        OptionProfileValue_Float = MyProfile.GetVoiceVolume();                                        
                                    }
                                    else
                                    {
                                        // End:0x36E
                                        if(CurrentOptionPSID == 63)
                                        {
                                            OptionProfileValue_Float = MyProfile.GetGamma();                                            
                                        }
                                        else
                                        {
                                            // End:0x3AB
                                            if(CurrentOptionPSID == 66)
                                            {
                                                OptionProfileValue_Float = MyProfile.GetSensitivity();                                                
                                            }
                                            else
                                            {
                                                MyProfile.GetProfileSettingValueFloat(CurrentOptionPSID, OptionProfileValue_Float);
                                            }
                                        }
                                    }
                                }
                            }
                        }                        
                    }
                    else
                    {
                        MyProfile.GetProfileSettingValueFloat(CurrentOptionPSID, OptionProfileValue_Float);
                    }
                    CurrentOptionInfo.GFx.SetFloat("value", OptionProfileValue_Float);
                    // End:0x818
                    break;
                // End:0x792
                case 1:
                    // End:0x5D5
                    if(CurrentOptionInfo.bIsIdMappedValue)
                    {
                        // End:0x57A
                        if(!bPrimaryPlayerIsLogged)
                        {
                            // End:0x4C7
                            if(CurrentOptionPSID == 1)
                            {
                                OptionProfileValue_IndexIdMapped = int(MyProfile.GetControllerVibrationOption());                                
                            }
                            else
                            {
                                // End:0x506
                                if(CurrentOptionPSID == 2)
                                {
                                    OptionProfileValue_IndexIdMapped = int(MyProfile.GetInvertY());                                    
                                }
                                else
                                {
                                    // End:0x545
                                    if(CurrentOptionPSID == 67)
                                    {
                                        OptionProfileValue_IndexIdMapped = int(MyProfile.GetStickConfigOption());                                        
                                    }
                                    else
                                    {
                                        MyProfile.GetProfileSettingValueId(CurrentOptionPSID, OptionProfileValue_IndexIdMapped);
                                    }
                                }
                            }                            
                        }
                        else
                        {
                            MyProfile.GetProfileSettingValueId(CurrentOptionPSID, OptionProfileValue_IndexIdMapped);
                        }
                        OptionProfileValue_Int = ConvertIdMappedToIndexValue(CurrentOptionPSID, OptionProfileValue_IndexIdMapped);                        
                    }
                    else
                    {
                        // End:0x712
                        if(!bPrimaryPlayerIsLogged)
                        {
                            // End:0x623
                            if(CurrentOptionPSID == 55)
                            {
                                OptionProfileValue_Int = int(MyProfile.GetShowSubtitles());                                
                            }
                            else
                            {
                                // End:0x660
                                if(CurrentOptionPSID == 56)
                                {
                                    OptionProfileValue_Int = MyProfile.GetCrosshairType();                                    
                                }
                                else
                                {
                                    // End:0x69F
                                    if(CurrentOptionPSID == 82)
                                    {
                                        OptionProfileValue_Int = int(MyProfile.GetShowTutorials());                                        
                                    }
                                    else
                                    {
                                        // End:0x6DE
                                        if(CurrentOptionPSID == 49)
                                        {
                                            OptionProfileValue_Int = int(MyProfile.GetAimZoomToggle());                                            
                                        }
                                        else
                                        {
                                            MyProfile.GetProfileSettingValueInt(CurrentOptionPSID, OptionProfileValue_Int);
                                        }
                                    }
                                }
                            }                            
                        }
                        else
                        {
                            MyProfile.GetProfileSettingValueInt(CurrentOptionPSID, OptionProfileValue_Int);
                        }
                    }
                    CurrentOptionInfo.GFx.SetFloat("selectedIndex", float(OptionProfileValue_Int));
                    // End:0x818
                    break;
                // End:0x812
                case 2:
                    MyProfile.GetProfileSettingValueInt(CurrentOptionPSID, OptionProfileValue_Int);
                    CurrentOptionInfo.GFx.SetBool("selected", bool(OptionProfileValue_Int));
                    // End:0x818
                    break;
                // End:0xFFFF
                default:
                    // End:0x818
                    break;
                    break;
            }
            EventListener(ev);
        }
        I++;
        // [Loop Continue]
        goto J0x130;
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
    local AdvProfileSettings MyProfile;
    local EventData ev;

    MyProfile = AdvPlayerController(GetPC()).ProfileSettings;
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
    // End:0x4D4
    if(((Frontend == none) && OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
    {
        Class'AdvUIManager'.static.OpenUpdatingScene("SavingContent_ShortMessage",,, 1.0000000);
    }
    AdvPlayerController(GetPC()).ClientSaveAllPlayerData(true);
    bHasChanges = false;
    bDiscarding = false;
    //return;    
}

function ShowSaveWarning(delegate<OnOptionSelected> SelectionCallback)
{
    local array<name> ButtonAliases;

    ButtonAliases.AddItem('GenericYes');    
    ButtonAliases.AddItem('GenericNo');    
    Class'AdvUIManager'.static.ShowUIMessage('DiscardWarning', SaveWarning_Title, SaveWarning_Msg, ButtonAliases, SelectionCallback, GetLP(),,,, false,,, true);
    //return;    
}

function ShowResetWarning(delegate<OnOptionSelected> SelectionCallback)
{
    local array<name> ButtonAliases;

    ButtonAliases.AddItem('GenericYes');    
    ButtonAliases.AddItem('GenericNo');    
    Class'AdvUIManager'.static.ShowUIMessage('DiscardWarning', Localize("MessageBoxStrings", "ResetToDefaults_Title", "ADVGame"), Localize("MessageBoxStrings", "ResetToDefaults_Body", "ADVGame"), ButtonAliases, SelectionCallback, GetLP());
    //return;    
}

function PlayOpenAnimation()
{
    local EvilLocalPlayer ELP;
    local WorldInfo WI;

    super.PlayOpenAnimation();
    // End:0x10F
    if(Frontend == none)
    {
        ELP = EvilPlayerController(GetPC()).GetELP();
        WI = Class'Engine.WorldInfo'.static.GetWorldInfo();
        // End:0x10F
        if(ELP != none)
        {
            ELP.SetMenuOverride(true, 0.4000000, (WI.Game != none) && WI.Game.bPauseable);
            bIsMenuPPOverrideOn = true;
        }
    }
    //return;    
}

function PlayCloseAnimation()
{
    local EvilLocalPlayer ELP;
    local WorldInfo WI;

    // End:0x0F
    if(bIsPlayingCloseAnimation)
    {
        return;
    }
    super.PlayCloseAnimation();
    // End:0x12B
    if(Frontend == none)
    {
        // End:0x12B
        if(bIsMenuPPOverrideOn)
        {
            ELP = EvilPlayerController(GetPC()).GetELP();
            WI = Class'Engine.WorldInfo'.static.GetWorldInfo();
            // End:0x12B
            if(ELP != none)
            {
                ELP.SetMenuOverride(false, 0.4000000, (WI.Game != none) && WI.Game.bPauseable);
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

event bool FilterButtonInput(int ControllerId, name ButtonName, Object.EInputEvent InputEvent)
{
    // End:0x9D
    if(GetLP().ControllerId == ControllerId)
    {
        // End:0x77
        if(ParentMenu != none)
        {
            return ParentMenu.FilterButtonInput(ControllerId, ButtonName, InputEvent);
        }
        return super.FilterButtonInput(ControllerId, ButtonName, InputEvent);
    }
    // End:0x108
    if(GetPC().WorldInfo.IsConsoleBuild(1) && !Class'AdvFrontEnd'.static.IsGamepadKey(ButtonName))
    {
        return true;
    }
    return true;
    //return ReturnValue;    
}

defaultproperties
{
    SaveString="Save Settings"
    DefaultString="Reset to defaults"
    SaveWarning_Title="SAVE SETTINGS"
    SaveWarning_Msg="YOU HAVE MADE SOME CHANGES. DO YOU WANT TO SAVE CURRENT SETTINGS?"
    bDiscardNonOwnerInput=true
    bHideLesserMovies=true
}