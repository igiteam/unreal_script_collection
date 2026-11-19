class AdvGFxUI_Menu_Options_Controls extends AdvGFxUI_Menu_Options_Base
    config(UI);

const ADVANCED_BINDING_INDEX_OFFSET = 12;
const END_BINDING_INDEX = 31;

enum EControlsSettingsTab
{
    ECST_None,                      // 0
    ECST_General,                   // 1
    ECST_Advanced,                  // 2
    ECST_Weapons,                   // 3
    ECST_Messages,                  // 4
    ECST_MAX                        // 5
};

var AdvGFxUI_Menu_Options_Controls.EControlsSettingsTab CurrentTab;
var transient array<BindingInfo> ActiveBindings;
var transient bool bMappingChanged;
var bool bPrimaryBinding;
var GFxClikWidget InvertYCheckbox;
var GFxClikWidget SmoothingCheckbox;
var GFxClikWidget SensitivitySlider;
var GFxClikWidget ZoomCheckbox;
var GFxObject SensitivitySliderTF;
var GFxObject SensitivitySliderValue;
var GFxObject InfoDialog;
var GFxObject InfoDialogTF;
var GFxObject InfoDialogBG;
var GFxObject TabKontener;
var array<GFxObject> TabMenu;
var array<GFxObject> TabButtons;
var int ButtonToChange;
var name ChoosenBinding;
var const localized string Sensitivity;
var const localized string Smoothing;
var const localized string Invert;
var const localized string GeneralText;
var const localized string AdvancedText;
var const localized string WeaponsText;
var const localized string MessagesText;
var const localized string ActionText;
var const localized string PrimaryText;
var const localized string SecondaryText;
var const localized string SwitchText;
var const localized string Custom1Text;
var const localized string Custom2Text;
var const localized string InfoChangeText;
var GFxClikWidget SwitchGamepadBtn;

function bool Start(optional bool StartPaused = false)
{
    local AdvPlayerController PC;
    local int DummyHash, I;
    local array<BindingInfo> DefaultBindings;

    super.Start(StartPaused);
    Advance(0.0000000);
    PC = AdvPlayerController(GetPC());
    TabKontener = MenuMC.GetObject("kontener");
    TabButtons[1] = ButtonsMC.GetObject("general_btn");
    TabMenu[1] = TabKontener.GetObject("general");
    TabButtons[2] = ButtonsMC.GetObject("advenced_btn");
    TabMenu[2] = TabKontener.GetObject("advanced");
    TabButtons[3] = ButtonsMC.GetObject("weapons_btn");
    TabMenu[3] = TabKontener.GetObject("weapons");
    TabButtons[4] = ButtonsMC.GetObject("Messages_btn");
    TabMenu[4] = TabKontener.GetObject("messages");
    SensitivitySlider = GFxClikWidget(TabMenu[1].GetObject("sensitivityM", Class'GFxUI.GFxClikWidget'));
    InvertYCheckbox = GFxClikWidget(TabMenu[1].GetObject("invertMouse", Class'GFxUI.GFxClikWidget'));
    SmoothingCheckbox = GFxClikWidget(TabMenu[1].GetObject("MouseSmoothing", Class'GFxUI.GFxClikWidget'));
    ZoomCheckbox = GFxClikWidget(TabMenu[1].GetObject("zoom", Class'GFxUI.GFxClikWidget'));
    SensitivitySliderTF = TabMenu[1].GetObject("sensitivityMText");
    SensitivitySliderValue = TabMenu[1].GetObject("sensitivityMValue");
    InfoDialog = RootMC.GetObject("info_dialog");
    InfoDialogTF = InfoDialog.GetObject("textField");
    InfoDialogBG = InfoDialog.GetObject("bg");
    ButtonToChange = -1;
    // End:0x630
    if(!Class'Engine.WorldInfo'.static.IsConsoleBuild(0))
    {
        ActiveBindings.Remove(0, ActiveBindings.Length);        
        PC.ProfileSettings.GetKeyBindings(76, ActiveBindings, DummyHash);
        // End:0x560
        if(ActiveBindings.Length == 0)
        {
            AdvPlayerInput(PC.PlayerInput).GetDefaultBindingsForPC(ActiveBindings);
        }
        AdvPlayerInput(PC.PlayerInput).GetDefaultBindingsForPC(DefaultBindings);
        // End:0x624
        if(ActiveBindings.Length < DefaultBindings.Length)
        {
            I = ActiveBindings.Length;
            J0x5D3:

            // End:0x619 [Loop If]
            if(I < DefaultBindings.Length)
            {
                ActiveBindings.AddItem(DefaultBindings[I]);                
                I++;
                // [Loop Continue]
                goto J0x5D3;
            }
            SaveSettingsToProfile(true);
        }
        bMappingChanged = false;
    }
    SensitivitySlider.SetFloat("minimum", 5.0000000);
    SensitivitySlider.SetFloat("maximum", 100.0000000);
    SensitivitySlider.SetFloat("snapInterval", 5.0000000);
    SensitivitySlider.SetFloat("value", PC.ProfileSettings.GetMouseSensitivity());
    SensitivitySliderValue.SetText(string(int(PC.ProfileSettings.GetMouseSensitivity())));
    InvertYCheckbox.SetBool("selected", PC.ProfileSettings.GetInvertY());
    SmoothingCheckbox.SetBool("selected", PC.ProfileSettings.GetMouseSmoothing());
    ZoomCheckbox.SetBool("selected", PC.ProfileSettings.GetAimZoomToggle());
    SensitivitySliderTF.SetText(Sensitivity);
    InvertYCheckbox.SetString("label", Invert);
    SmoothingCheckbox.SetString("label", Smoothing);
    ZoomCheckbox.SetString("label", Class'AdvGFxUI_Menu_Options_ControlsXbox'.default.Options[4].SettingDescription);
    TabButtons[1].SetString("label", GeneralText);
    TabButtons[2].SetString("label", AdvancedText);
    TabButtons[3].SetString("label", WeaponsText);
    TabButtons[4].SetString("label", MessagesText);
    ShowInfoDialog(false);
    SetAndUpdateTab(1);
    TabButtons[3].SetBool("visible", false);
    TabButtons[4].SetBool("visible", false);
    SwitchGamepadBtn = GFxClikWidget(ButtonsMC.GetObject("switch_btn", Class'GFxUI.GFxClikWidget'));
    SwitchGamepadBtn.SetString("label", Localize("AdvGFxUI_Menu_OptionsMenu", "SwitchToGamepadUI", "ADVGame"));
    // End:0xBAC
    if(AdvPlayerController(GetPC()).IsPCGamepadConnected())
    {
        SwitchGamepadBtn.SetBool("visible", true);        
    }
    else
    {
        SwitchGamepadBtn.SetBool("visible", false);
    }
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

function SetAndUpdateTab(AdvGFxUI_Menu_Options_Controls.EControlsSettingsTab TabToSet)
{
    local int I;

    switch(TabToSet)
    {
        // End:0x3DB
        case 1:
            TabKontener.GotoAndStop("general");
            TabMenu[1].SetVisible(true);
            TabMenu[2].SetVisible(false);
            TabMenu[3].SetVisible(false);
            TabMenu[4].SetVisible(false);
            I = 0;
            J0xD6:

            // End:0x2E8 [Loop If]
            if(I < 12)
            {
                TabMenu[1].GetObject("general" $ string(I + 1)).GetObject("textField").SetText(GetLocalizedTextForCommand(ActiveBindings[I].Command));
                TabMenu[1].GetObject("general" $ string(I + 1)).GetObject("baton1").SetString("label", GetLocalizedTextForKeyName(ActiveBindings[I].PrimaryBind));
                TabMenu[1].GetObject("general" $ string(I + 1)).GetObject("baton2").SetString("label", GetLocalizedTextForKeyName(ActiveBindings[I].SecondaryBind));
                I++;
                // [Loop Continue]
                goto J0xD6;
            }
            TabMenu[1].GetObject("actionText").SetText(ActionText);
            TabMenu[1].GetObject("primaryText").SetText(PrimaryText);
            TabMenu[1].GetObject("alternativeText").SetText(SecondaryText);
            // End:0xC81
            break;
        // End:0xA6B
        case 2:
            TabKontener.GotoAndStop("advanced");
            TabMenu[1].SetVisible(false);
            TabMenu[2].SetVisible(true);
            TabMenu[3].SetVisible(false);
            TabMenu[4].SetVisible(false);
            I = 12;
            J0x4A0:

            // End:0x87F [Loop If]
            if(I < 31)
            {
                // End:0x66B
                if(ActiveBindings[I].Command ~= "DONT_DISPLAY")
                {
                    TabMenu[2].GetObject("advanced" $ string((I - 12) + 1)).GetObject("textField").SetText(" ");
                    TabMenu[2].GetObject("advanced" $ string((I - 12) + 1)).GetObject("baton1").SetString("label", " ");
                    TabMenu[2].GetObject("advanced" $ string((I - 12) + 1)).GetObject("baton2").SetString("label", " ");                    
                }
                else
                {
                    TabMenu[2].GetObject("advanced" $ string((I - 12) + 1)).GetObject("textField").SetText(GetLocalizedTextForCommand(ActiveBindings[I].Command));
                    TabMenu[2].GetObject("advanced" $ string((I - 12) + 1)).GetObject("baton1").SetString("label", GetLocalizedTextForKeyName(ActiveBindings[I].PrimaryBind));
                    TabMenu[2].GetObject("advanced" $ string((I - 12) + 1)).GetObject("baton2").SetString("label", GetLocalizedTextForKeyName(ActiveBindings[I].SecondaryBind));
                }
                I++;
                // [Loop Continue]
                goto J0x4A0;
            }
            TabMenu[2].GetObject("actionText").SetText(ActionText);
            TabMenu[2].GetObject("primaryText").SetText(PrimaryText);
            TabMenu[2].GetObject("alternativeText").SetText(SecondaryText);
            TabMenu[2].GetObject("actionText2").SetText(ActionText);
            TabMenu[2].GetObject("primaryText2").SetText(PrimaryText);
            TabMenu[2].GetObject("alternativeText2").SetText(SecondaryText);
            // End:0xC81
            break;
        // End:0xBC2
        case 3:
            TabKontener.GotoAndStop("weapons");
            TabMenu[1].SetVisible(false);
            TabMenu[2].SetVisible(false);
            TabMenu[3].SetVisible(true);
            TabMenu[4].SetVisible(false);
            TabMenu[3].GetObject("custom1TF").SetText(Custom1Text);
            TabMenu[3].GetObject("custom2TF").SetText(Custom2Text);
            // End:0xC81
            break;
        // End:0xC7E
        case 4:
            TabKontener.GotoAndStop("messages");
            TabMenu[1].SetVisible(false);
            TabMenu[2].SetVisible(false);
            TabMenu[3].SetVisible(false);
            TabMenu[4].SetVisible(true);
            // End:0xC81
            break;
        // End:0xFFFF
        default:
            break;
    }
    CurrentTab = TabToSet;
    //return;    
}

function NewBindChosen(int BindToChange, bool bPrimary, name NewButtonName)
{
    SetBindingForCommand(BindToChange, bPrimary, NewButtonName);
    bHasChanges = true;
    //return;    
}

function SetBindingForCommand(int BindToChange, bool bPrimary, name NewBinding)
{
    local int Idx;

    Idx = 0;
    J0x0B:

    // End:0xF9 [Loop If]
    if(Idx < ActiveBindings.Length)
    {
        // End:0x87
        if(ActiveBindings[Idx].PrimaryBind == NewBinding)
        {
            ActiveBindings[Idx].PrimaryBind = 'None';
        }
        // End:0xEB
        if(ActiveBindings[Idx].SecondaryBind == NewBinding)
        {
            ActiveBindings[Idx].SecondaryBind = 'None';
        }
        Idx++;
        // [Loop Continue]
        goto J0x0B;
    }
    // End:0x139
    if(bPrimary)
    {
        ActiveBindings[BindToChange].PrimaryBind = NewBinding;        
    }
    else
    {
        ActiveBindings[BindToChange].SecondaryBind = NewBinding;
    }
    bMappingChanged = true;
    SetAndUpdateTab(CurrentTab);
    //return;    
}

function OnGeneralTab(EventData ev)
{
    SetAndUpdateTab(1);
    //return;    
}

function OnAdvencedTab(EventData ev)
{
    SetAndUpdateTab(2);
    //return;    
}

function OnWeaponsTab(EventData ev)
{
    SetAndUpdateTab(3);
    //return;    
}

function OnMessagesTab(EventData ev)
{
    SetAndUpdateTab(4);
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
    // End:0x2E
    if(SelectedInputAlias == 'GenericYes')
    {
        SaveSettingsToProfile(bMappingChanged);        
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
    // End:0x34
    if(SelectedInputAlias == 'GenericYes')
    {
        ResetToDefaults();
        SetAndUpdateTab(CurrentTab);
    }
    ResetBtn.SetBool("focused", false);
    ResetBtn.SetBool("focused", true);
    return true;
    //return ReturnValue;    
}

function OnSwitch(EventData ev)
{
    AdvLocalPlayer(GetLP()).bForceNoGamepadUI = false;
    AdvLocalPlayer(GetLP()).SaveConfig();
    // End:0x88
    if(Frontend != none)
    {
        AdvPlayerController(GetPC()).RestartFrontEnd();        
    }
    else
    {
        AdvLocalPlayer(GetLP()).bPCGamepadMode = true;
        OnBack(ev);
        // End:0x139
        if((ParentMenu != none) && ParentMenu.footer == none)
        {
            ParentMenu.InitializeFooter();
            ParentMenu.UpdateFooter();
        }
    }
    //return;    
}

function OnSensitivity(float Value)
{
    GetPC().PlayerInput.SetSensitivity(Value);
    SensitivitySliderValue.SetText(string(int(Value)));
    bHasChanges = true;
    //return;    
}

function OnInvertY(bool bSelected)
{
    GetPC().PlayerInput.bInvertMouse = bSelected;
    bHasChanges = true;
    //return;    
}

function OnSmoothing(bool bSelected)
{
    // End:0x50
    if(GetPC().PlayerInput.bEnableMouseSmoothing != bSelected)
    {
        bHasChanges = true;
    }
    GetPC().PlayerInput.bEnableMouseSmoothing = bSelected;
    //return;    
}

function OnZoom(bool bSelected)
{
    // End:0x59
    if(AdvPlayerInput(GetPC().PlayerInput).bHoldZoom == bSelected)
    {
        bHasChanges = true;
    }
    AdvPlayerInput(GetPC().PlayerInput).bHoldZoom = !bSelected;
    //return;    
}

function OnGeneral(int Index, bool bPrimary)
{
    ButtonToChange = Index;
    bPrimaryBinding = bPrimary;
    ShowInfoDialog(true);
    //return;    
}

function OnAdvanced(int Index, bool bPrimary)
{
    ButtonToChange = Index + 12;
    bPrimaryBinding = bPrimary;
    ShowInfoDialog(true);
    //return;    
}

function ShowInfoDialog(bool bShow)
{
    // End:0x59
    if(bShow)
    {
        InfoDialogTF.SetText(InfoChangeText);
        InfoDialogBG.SetVisible(true);        
    }
    else
    {
        InfoDialogTF.SetText(" ");
        InfoDialogBG.SetVisible(false);
    }
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
            Frontend.CloseOptionsControlsScreen();
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

event bool FilterButtonInput(int ControllerId, name ButtonName, Object.EInputEvent InputEvent)
{
    // End:0xE5
    if(int(InputEvent) == int(0))
    {
        // End:0x9B
        if(((ButtonToChange > -1) && !Class'AdvFrontEnd'.static.IsGamepadKey(ButtonName)) && !IsForbiddenKey(ButtonName))
        {
            NewBindChosen(ButtonToChange, bPrimaryBinding, ButtonName);
            return true;            
        }
        else
        {
            // End:0xE2
            if((ButtonToChange > -1) && IsForbiddenKey(ButtonName))
            {
                ButtonToChange = -1;
                ShowInfoDialog(false);
                return true;
            }
        }        
    }
    else
    {
        // End:0x157
        if((int(InputEvent) == int(1)) && !Class'AdvFrontEnd'.static.IsGamepadKey(ButtonName))
        {
            // End:0x157
            if(ButtonToChange > -1)
            {
                ButtonToChange = -1;
                ShowInfoDialog(false);
                return true;
            }
        }
    }
    return super.FilterButtonInput(ControllerId, ButtonName, InputEvent);
    //return ReturnValue;    
}

function bool IsForbiddenKey(name ButtonName)
{
    switch(ButtonName)
    {
        // End:0x1F
        case 'Escape':
        // End:0x2D
        case 'Pause':
            return true;
        // End:0xFFFF
        default:
            return false;
            break;
    }
    //return ReturnValue;    
}

function SaveSettingsToProfile(optional bool InForceSave = false)
{
    local AdvPlayerController PC;
    local bool OptionValueBool;
    local float OptionValue, OptionProfileValue_Float;
    local int OptionProfileValue_Int;
    local bool bProfileChanged;

    PC = AdvPlayerController(GetPC());
    bProfileChanged = InForceSave;
    OptionValue = SensitivitySlider.GetFloat("value");
    PC.ProfileSettings.GetProfileSettingValueFloat(53, OptionProfileValue_Float);
    // End:0x108
    if(OptionProfileValue_Float != OptionValue)
    {
        bProfileChanged = true;
        PC.ProfileSettings.SetProfileSettingValueFloat(53, OptionValue);
    }
    OptionValueBool = InvertYCheckbox.GetBool("selected");
    PC.ProfileSettings.GetProfileSettingValueInt(54, OptionProfileValue_Int);
    // End:0x1E3
    if(OptionProfileValue_Int != int(OptionValueBool))
    {
        bProfileChanged = true;
        PC.ProfileSettings.SetProfileSettingValueInt(54, int(OptionValueBool));
    }
    OptionValueBool = SmoothingCheckbox.GetBool("selected");
    PC.ProfileSettings.GetProfileSettingValueInt(51, OptionProfileValue_Int);
    // End:0x2BE
    if(OptionProfileValue_Int != int(OptionValueBool))
    {
        bProfileChanged = true;
        PC.ProfileSettings.SetProfileSettingValueInt(51, int(OptionValueBool));
    }
    OptionValueBool = ZoomCheckbox.GetBool("selected");
    PC.ProfileSettings.GetProfileSettingValueInt(49, OptionProfileValue_Int);
    // End:0x399
    if(OptionProfileValue_Int != int(OptionValueBool))
    {
        bProfileChanged = true;
        PC.ProfileSettings.SetProfileSettingValueInt(49, int(OptionValueBool));
    }
    // End:0x3FE
    if(!Class'Engine.WorldInfo'.static.IsConsoleBuild(0))
    {
        PC.ProfileSettings.SetKeyBindings(76, ActiveBindings);
    }
    // End:0x42C
    if(bProfileChanged)
    {
        PC.ClientSaveAllPlayerData(true);
    }
    //return;    
}

function DiscardChanges()
{
    local AdvPlayerController PC;

    PC = AdvPlayerController(GetPC());
    OnSensitivity(PC.ProfileSettings.GetMouseSensitivity());
    OnInvertY(PC.ProfileSettings.GetInvertY());
    OnSmoothing(PC.ProfileSettings.GetMouseSmoothing());
    //return;    
}

function ResetToDefaults()
{
    local AdvPlayerController PC;
    local float OptionProfileValue_Float;
    local int OptionProfileValue_Int;

    PC = AdvPlayerController(GetPC());
    PC.ProfileSettings.GetProfileSettingDefaultFloat(53, OptionProfileValue_Float);
    PC.ProfileSettings.SetProfileSettingValueFloat(53, OptionProfileValue_Float);
    SensitivitySlider.SetFloat("value", OptionProfileValue_Float);
    PC.ProfileSettings.GetProfileSettingDefaultInt(54, OptionProfileValue_Int);
    PC.ProfileSettings.SetProfileSettingValueInt(54, OptionProfileValue_Int);
    InvertYCheckbox.SetBool("selected", bool(OptionProfileValue_Int));
    PC.ProfileSettings.GetProfileSettingDefaultInt(51, OptionProfileValue_Int);
    PC.ProfileSettings.SetProfileSettingValueInt(51, OptionProfileValue_Int);
    SmoothingCheckbox.SetBool("selected", bool(OptionProfileValue_Int));
    PC.ProfileSettings.GetProfileSettingDefaultInt(49, OptionProfileValue_Int);
    PC.ProfileSettings.SetProfileSettingValueInt(49, OptionProfileValue_Int);
    ZoomCheckbox.SetBool("selected", bool(OptionProfileValue_Int));
    // End:0x3A1
    if(!Class'Engine.WorldInfo'.static.IsConsoleBuild(0))
    {
        ActiveBindings.Remove(0, ActiveBindings.Length);        
        AdvPlayerInput(PC.PlayerInput).GetDefaultBindingsForPC(ActiveBindings);
        PC.ProfileSettings.SetKeyBindings(76, ActiveBindings);
    }
    DiscardChanges();
    PC.ClientSaveAllPlayerData(true);
    bHasChanges = false;
    //return;    
}

function string GetLocalizedTextForCommand(string Cmd)
{
    return Localize("AdvGFxUI_Menu_Options_Controls", Cmd, "ADVGame");
    //return ReturnValue;    
}

static function string GetLocalizedTextForKeyName(name KeyName)
{
    // End:0x3D
    if(KeyName == 'None')
    {
        return Localize("Generic", "NoneMSG", "ADVGame");
    }
    return Localize("GameMappedStrings", "GMS_" $ string(KeyName), "ADVGame");
    //return ReturnValue;    
}

defaultproperties
{
    Sensitivity="Mouse Sensitivity"
    Smoothing="Mouse Smoothing"
    Invert="Look Inversion"
    GeneralText="General"
    AdvancedText="Advanced"
    WeaponsText="Weapons"
    MessagesText="Messages"
    ActionText="Action"
    PrimaryText="Primary"
    SecondaryText="Alternative"
    SwitchText="Switch"
    Custom1Text="Custom 1"
    Custom2Text="Custom 2"
    InfoChangeText="Press new key to bind"
    HeaderTitleString="Controls Settings"
    MovieInfo=SwfMovie'UI_AdvCommon.AdvControls'
}