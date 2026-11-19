class PKGFxUI_Menu_Options_Controls extends PKGFxUI_Menu_Options_Base
    config(UI);

const ADVANCED_BINDING_INDEX_OFFSET = 12;
const MESSAGES_BINDING_INDEX_OFFSET = 32;
const END_BINDING_INDEX = 42;

enum EControlsSettingsTab
{
    ECST_None,                      // 0
    ECST_General,                   // 1
    ECST_Advanced,                  // 2
    ECST_Weapons,                   // 3
    ECST_Messages,                  // 4
    ECST_MAX                        // 5
};

var PKGFxUI_Menu_Options_Controls.EControlsSettingsTab CurrentTab;
var transient array<BindingInfo> ActiveBindings;
var transient bool bMappingChanged;
var transient bool bCustomChanged;
var transient bool bMessagesChanged;
var bool bPrimaryBinding;
var transient array<byte> ActiveCustom1;
var transient array<byte> ActiveCustom2;
var transient array<byte> VisibleCustom1;
var transient array<byte> VisibleCustom2;
var transient array<byte> LockedCustom1;
var transient array<byte> LockedCustom2;
var transient array<string> ActiveMessages;
var GFxClikWidget InvertYCheckbox;
var GFxClikWidget SmoothingCheckbox;
var GFxClikWidget SensitivitySlider;
var GFxClikWidget Custom1List;
var GFxClikWidget Custom2List;
var GFxObject SensitivitySliderTF;
var GFxObject SensitivitySliderValue;
var transient int LastSelectedCustom1Index;
var transient int LastSelectedCustom2Index;
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
var const localized string InfoChangeTextDLC5Note;

function bool Start(optional bool StartPaused = false)
{
    local PKPlayerController PC;
    local int DummyHash, I;

    super.Start(StartPaused);
    Advance(0.0000000);
    PC = PKPlayerController(GetPC());
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
    SensitivitySliderTF = TabMenu[1].GetObject("sensitivityMText");
    SensitivitySliderValue = TabMenu[1].GetObject("sensitivityMValue");
    Custom1List = GFxClikWidget(TabMenu[3].GetObject("custom1", Class'GFxUI.GFxClikWidget'));
    Custom2List = GFxClikWidget(TabMenu[3].GetObject("custom2", Class'GFxUI.GFxClikWidget'));
    InfoDialog = RootMC.GetObject("info_dialog");
    InfoDialogTF = InfoDialog.GetObject("textField");
    InfoDialogBG = InfoDialog.GetObject("bg");
    ButtonToChange = -1;
    // End:0x650
    if(!Class'Engine.WorldInfo'.static.IsConsoleBuild(0))
    {
        ActiveBindings.Remove(0, ActiveBindings.Length);
        PC.ProfileSettings.GetKeyBindings(76, ActiveBindings, DummyHash);
        // End:0x5AB
        if(ActiveBindings.Length == 0)
        {
            PKPlayerInput(PC.PlayerInput).GetDefaultBindingsForPC(ActiveBindings);
        }
        bMappingChanged = false;
        ActiveMessages.Remove(0, ActiveMessages.Length);
        PC.ProfileSettings.GetCustomMessages(79, ActiveMessages);
        // End:0x644
        if(ActiveMessages.Length == 0)
        {
            PC.GetDefaultCustomMessages(ActiveMessages);
        }
        bMessagesChanged = false;
    }
    ActiveCustom1.Remove(0, ActiveCustom1.Length);
    ActiveCustom2.Remove(0, ActiveCustom2.Length);
    PC.ProfileSettings.GetProfileSettingValueBlob(77, ActiveCustom1);
    PC.ProfileSettings.GetProfileSettingValueBlob(78, ActiveCustom2);
    // End:0x751
    if(ActiveCustom1.Length < 36)
    {
        PKPlayerInput(PC.PlayerInput).GetDefaultCustom1Weapons(ActiveCustom1);
    }
    // End:0x7A8
    if(ActiveCustom2.Length < 36)
    {
        PKPlayerInput(PC.PlayerInput).GetDefaultCustom2Weapons(ActiveCustom2);
    }
    bCustomChanged = false;
    VisibleCustom1.Remove(0, VisibleCustom1.Length);
    LockedCustom1.Remove(0, LockedCustom1.Length);
    I = 0;
    J0x7EB:

    // End:0x8BD [Loop If]
    if(I < ActiveCustom1.Length)
    {
        // End:0x88F
        if(class<PainWeap_Base>(Class'PKPlayerController'.default.CustomWeaponMapping[int(ActiveCustom1[I])].WeaponClass).default.bPurchasedWeaponDLC)
        {
            VisibleCustom1.AddItem(ActiveCustom1[I]);            
        }
        else
        {
            LockedCustom1.AddItem(ActiveCustom1[I]);
        }
        I++;
        // [Loop Continue]
        goto J0x7EB;
    }
    VisibleCustom2.Remove(0, VisibleCustom2.Length);
    LockedCustom2.Remove(0, LockedCustom2.Length);
    I = 0;
    J0x8F4:

    // End:0x9C6 [Loop If]
    if(I < ActiveCustom2.Length)
    {
        // End:0x998
        if(class<PainWeap_Base>(Class'PKPlayerController'.default.CustomWeaponMapping[int(ActiveCustom2[I])].WeaponClass).default.bPurchasedWeaponDLC)
        {
            VisibleCustom2.AddItem(ActiveCustom2[I]);            
        }
        else
        {
            LockedCustom2.AddItem(ActiveCustom2[I]);
        }
        I++;
        // [Loop Continue]
        goto J0x8F4;
    }
    SensitivitySlider.SetFloat("minimum", 5.0000000);
    SensitivitySlider.SetFloat("maximum", 100.0000000);
    SensitivitySlider.SetFloat("snapInterval", 5.0000000);
    SensitivitySlider.SetFloat("value", PC.ProfileSettings.GetMouseSensitivity());
    SensitivitySliderValue.SetText(string(int(PC.ProfileSettings.GetMouseSensitivity())));
    InvertYCheckbox.SetBool("selected", PC.ProfileSettings.GetInvertY());
    SmoothingCheckbox.SetBool("selected", PC.ProfileSettings.GetMouseSmoothing());
    SensitivitySliderTF.SetText(Sensitivity);
    InvertYCheckbox.SetString("label", Invert);
    SmoothingCheckbox.SetString("label", Smoothing);
    TabButtons[1].SetString("label", GeneralText);
    TabButtons[2].SetString("label", AdvancedText);
    TabButtons[3].SetString("label", WeaponsText);
    TabButtons[4].SetString("label", MessagesText);
    ResetBtn = GFxClikWidget(ButtonsMC.GetObject("reset_btn", Class'GFxUI.GFxClikWidget'));
    ResetBtn.SetString("label", DefaultString);
    ShowInfoDialog(false);
    SetAndUpdateTab(1);
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

function SetAndUpdateTab(PKGFxUI_Menu_Options_Controls.EControlsSettingsTab TabToSet)
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
            // End:0xC4C
            break;
        // End:0x8B0
        case 2:
            TabKontener.GotoAndStop("advanced");
            TabMenu[1].SetVisible(false);
            TabMenu[2].SetVisible(true);
            TabMenu[3].SetVisible(false);
            TabMenu[4].SetVisible(false);
            I = 12;
            J0x4A0:

            // End:0x6C4 [Loop If]
            if(I < 32)
            {
                TabMenu[2].GetObject("advanced" $ string((I - 12) + 1)).GetObject("textField").SetText(GetLocalizedTextForCommand(ActiveBindings[I].Command));
                TabMenu[2].GetObject("advanced" $ string((I - 12) + 1)).GetObject("baton1").SetString("label", GetLocalizedTextForKeyName(ActiveBindings[I].PrimaryBind));
                TabMenu[2].GetObject("advanced" $ string((I - 12) + 1)).GetObject("baton2").SetString("label", GetLocalizedTextForKeyName(ActiveBindings[I].SecondaryBind));
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
            // End:0xC4C
            break;
        // End:0xA1B
        case 3:
            TabKontener.GotoAndStop("weapons");
            TabMenu[1].SetVisible(false);
            TabMenu[2].SetVisible(false);
            TabMenu[3].SetVisible(true);
            TabMenu[4].SetVisible(false);
            TabMenu[3].GetObject("custom1TF").SetText(Custom1Text);
            TabMenu[3].GetObject("custom2TF").SetText(Custom2Text);
            UpdateCustom1WeaponDataProvider();
            UpdateCustom2WeaponDataProvider();
            // End:0xC4C
            break;
        // End:0xC49
        case 4:
            TabKontener.GotoAndStop("messages");
            TabMenu[1].SetVisible(false);
            TabMenu[2].SetVisible(false);
            TabMenu[3].SetVisible(false);
            TabMenu[4].SetVisible(true);
            I = 32;
            J0xAE0:

            // End:0xC46 [Loop If]
            if(I < 42)
            {
                TabMenu[4].GetObject("message" $ string((I - 32) + 1)).GetObject("messageInp").SetString("text", ActiveMessages[I - 32]);
                TabMenu[4].GetObject("message" $ string((I - 32) + 1)).GetObject("messageBtn").SetString("label", GetLocalizedTextForKeyName(ActiveBindings[I].PrimaryBind));
                I++;
                // [Loop Continue]
                goto J0xAE0;
            }
            // End:0xC4C
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
    // End:0x34
    if(SelectedInputAlias == 'GenericYes')
    {
        ResetToDefaults();
        SetAndUpdateTab(CurrentTab);
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

function OnSensitivity(float Value)
{
    GetPC().PlayerInput.SetSensitivity(Value);
    SensitivitySliderValue.SetText(string(int(Value)));
    bHasChanges = true;
    //return;    
}

function OnInvertY(bool bSelected)
{
    // End:0x50
    if(GetPC().PlayerInput.bInvertMouse != bSelected)
    {
        bHasChanges = true;
    }
    GetPC().PlayerInput.bInvertMouse = bSelected;
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

function UpdateCustom1WeaponDataProvider()
{
    local int I, ListCounter;
    local GFxObject DataProvider, TempObj;

    ListCounter = 0;
    DataProvider = CreateArray();
    I = 0;
    J0x2A:

    // End:0xE5 [Loop If]
    if(I < VisibleCustom1.Length)
    {
        TempObj = CreateObject("Object");
        TempObj.SetString("label", GetLocalizedTextForEWeaponFireMode(VisibleCustom1[I]));
        DataProvider.SetElementObject(ListCounter++, TempObj);
        I++;
        // [Loop Continue]
        goto J0x2A;
    }
    Custom1List.SetObject("dataProvider", DataProvider);
    LastSelectedCustom1Index = -1;
    //return;    
}

function UpdateCustom2WeaponDataProvider()
{
    local int I, ListCounter;
    local GFxObject DataProvider, TempObj;

    ListCounter = 0;
    DataProvider = CreateArray();
    I = 0;
    J0x2A:

    // End:0xE5 [Loop If]
    if(I < VisibleCustom2.Length)
    {
        TempObj = CreateObject("Object");
        TempObj.SetString("label", GetLocalizedTextForEWeaponFireMode(VisibleCustom2[I]));
        DataProvider.SetElementObject(ListCounter++, TempObj);
        I++;
        // [Loop Continue]
        goto J0x2A;
    }
    Custom2List.SetObject("dataProvider", DataProvider);
    LastSelectedCustom2Index = -1;
    //return;    
}

function OnWeaponSwitch(int Index)
{
    //return;    
}

function OnCustom1Select(EventData ev)
{
    local int SelectedIndex;
    local byte EWFM;

    LastSelectedCustom2Index = -1;
    SelectedIndex = int(Custom1List.GetFloat("selectedIndex"));
    // End:0x15C
    if((LastSelectedCustom1Index > -1) && LastSelectedCustom1Index != SelectedIndex)
    {
        // End:0xE3
        if(LastSelectedCustom1Index > SelectedIndex)
        {
            EWFM = VisibleCustom1[LastSelectedCustom1Index];
            VisibleCustom1.InsertItem(SelectedIndex, EWFM);
            VisibleCustom1.Remove(LastSelectedCustom1Index + 1, 1);            
        }
        else
        {
            EWFM = VisibleCustom1[LastSelectedCustom1Index];
            VisibleCustom1.InsertItem(SelectedIndex + 1, EWFM);
            VisibleCustom1.Remove(LastSelectedCustom1Index, 1);
        }
        bCustomChanged = true;
        UpdateCustom1WeaponDataProvider();
        bHasChanges = true;        
    }
    else
    {
        LastSelectedCustom1Index = SelectedIndex;
    }
    //return;    
}

function OnCustom2Select(EventData ev)
{
    local int SelectedIndex;
    local byte EWFM;

    LastSelectedCustom1Index = -1;
    SelectedIndex = int(Custom2List.GetFloat("selectedIndex"));
    // End:0x15C
    if((LastSelectedCustom2Index > -1) && LastSelectedCustom2Index != SelectedIndex)
    {
        // End:0xE3
        if(LastSelectedCustom2Index > SelectedIndex)
        {
            EWFM = VisibleCustom2[LastSelectedCustom2Index];
            VisibleCustom2.InsertItem(SelectedIndex, EWFM);
            VisibleCustom2.Remove(LastSelectedCustom2Index + 1, 1);            
        }
        else
        {
            EWFM = VisibleCustom2[LastSelectedCustom2Index];
            VisibleCustom2.InsertItem(SelectedIndex + 1, EWFM);
            VisibleCustom2.Remove(LastSelectedCustom2Index, 1);
        }
        bCustomChanged = true;
        UpdateCustom2WeaponDataProvider();
        bHasChanges = true;        
    }
    else
    {
        LastSelectedCustom2Index = SelectedIndex;
    }
    //return;    
}

function OnMessage(int Index)
{
    ButtonToChange = Index + 32;
    bPrimaryBinding = true;
    ShowInfoDialog(true);
    //return;    
}

function OnMessageInp(int Index)
{
    // End:0xE9
    if(TabMenu[4].GetObject("message" $ string(Index + 1)) != none)
    {
        ActiveMessages[Index] = TabMenu[4].GetObject("message" $ string(Index + 1)).GetObject("messageInp").GetString("text");
        bHasChanges = true;
        bMessagesChanged = true;
    }
    //return;    
}

function ShowInfoDialog(bool bShow)
{
    // End:0x169
    if(bShow)
    {
        // End:0x11D
        if((ButtonToChange < ActiveBindings.Length) && (ActiveBindings[ButtonToChange].Command == "GBA_FireCustom1") || ActiveBindings[ButtonToChange].Command == "GBA_Jump")
        {
            InfoDialogTF.SetText((((((InfoChangeTextDLC5Note $ " ''") $ (GetLocalizedTextForCommand("GBA_FireCustom1"))) $ "'', ''") $ (GetLocalizedTextForCommand("GBA_Jump"))) $ "''\n\n") @ InfoChangeText);            
        }
        else
        {
            InfoDialogTF.SetText(InfoChangeText);
        }
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
        // End:0x29
        case "back":
            DiscardChanges();
            // End:0x6D
            break;
        // End:0x67
        case "save":
            SaveSettingsToProfile((bMappingChanged || bCustomChanged) || bMessagesChanged);
            // End:0x6D
            break;
        // End:0xFFFF
        default:
            // End:0x6D
            break;
            break;
    }
    // End:0xC0
    if(FrontEnd != none)
    {
        // End:0xBD
        if(FrontEnd.OpenOptionsScreen())
        {
            FrontEnd.CloseOptionsControlsScreen();
        }        
    }
    else
    {
        // End:0x38D
        if(ParentMenu != none)
        {
            ParentMenu.OptionsMenu = new Class'PKGFxUI_Menu_OptionsMenu';
            ParentMenu.OptionsMenu.SetPriority(69);
            // End:0x27B
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

event bool FilterButtonInput(int ControllerId, name ButtonName, Object.EInputEvent InputEvent)
{
    // End:0xE5
    if(int(InputEvent) == int(0))
    {
        // End:0x9B
        if(((ButtonToChange > -1) && !Class'PKFrontEnd'.static.IsGamepadKey(ButtonName)) && !IsForbiddenKey(ButtonName))
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
        if((int(InputEvent) == int(1)) && !Class'PKFrontEnd'.static.IsGamepadKey(ButtonName))
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
    return super(PKGFxUI_Menu_Base).FilterButtonInput(ControllerId, ButtonName, InputEvent);
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
    local PKPlayerController PC;
    local bool OptionValueBool;
    local float OptionValue, OptionProfileValue_Float;
    local int OptionProfileValue_Int;
    local bool bProfileChanged;
    local int I;

    PC = PKPlayerController(GetPC());
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
    // End:0x362
    if(!Class'Engine.WorldInfo'.static.IsConsoleBuild(0))
    {
        PC.ProfileSettings.SetKeyBindings(76, ActiveBindings);
        PC.ProfileSettings.SetCustomMessages(79, ActiveMessages);
    }
    ActiveCustom1.Remove(0, ActiveCustom1.Length);
    I = 0;
    J0x383:

    // End:0x3C9 [Loop If]
    if(I < VisibleCustom1.Length)
    {
        ActiveCustom1.AddItem(VisibleCustom1[I]);
        I++;
        // [Loop Continue]
        goto J0x383;
    }
    I = 0;
    J0x3D4:

    // End:0x41A [Loop If]
    if(I < LockedCustom1.Length)
    {
        ActiveCustom1.AddItem(LockedCustom1[I]);
        I++;
        // [Loop Continue]
        goto J0x3D4;
    }
    ActiveCustom2.Remove(0, ActiveCustom2.Length);
    I = 0;
    J0x43B:

    // End:0x481 [Loop If]
    if(I < VisibleCustom2.Length)
    {
        ActiveCustom2.AddItem(VisibleCustom2[I]);
        I++;
        // [Loop Continue]
        goto J0x43B;
    }
    I = 0;
    J0x48C:

    // End:0x4D2 [Loop If]
    if(I < LockedCustom2.Length)
    {
        ActiveCustom2.AddItem(LockedCustom2[I]);
        I++;
        // [Loop Continue]
        goto J0x48C;
    }
    PC.ProfileSettings.SetProfileSettingValueBlob(77, ActiveCustom1);
    PC.ProfileSettings.SetProfileSettingValueBlob(78, ActiveCustom2);
    // End:0x57E
    if(bProfileChanged)
    {
        PC.ClientSaveAllPlayerData(true);
    }
    //return;    
}

function DiscardChanges()
{
    local PKPlayerController PC;

    PC = PKPlayerController(GetPC());
    OnSensitivity(PC.ProfileSettings.GetMouseSensitivity());
    OnInvertY(PC.ProfileSettings.GetInvertY());
    OnSmoothing(PC.ProfileSettings.GetMouseSmoothing());
    //return;    
}

function ResetToDefaults()
{
    local PKPlayerController PC;
    local float OptionProfileValue_Float;
    local int OptionProfileValue_Int;

    PC = PKPlayerController(GetPC());
    PC.ProfileSettings.GetProfileSettingDefaultFloat(53, OptionProfileValue_Float);
    PC.ProfileSettings.SetProfileSettingValueFloat(53, OptionProfileValue_Float);
    SensitivitySlider.SetFloat("value", OptionProfileValue_Float);
    PC.ProfileSettings.GetProfileSettingDefaultInt(54, OptionProfileValue_Int);
    PC.ProfileSettings.SetProfileSettingValueInt(54, OptionProfileValue_Int);
    InvertYCheckbox.SetBool("selected", bool(OptionProfileValue_Int));
    PC.ProfileSettings.GetProfileSettingDefaultInt(51, OptionProfileValue_Int);
    PC.ProfileSettings.SetProfileSettingValueInt(51, OptionProfileValue_Int);
    SmoothingCheckbox.SetBool("selected", bool(OptionProfileValue_Int));
    // End:0x36C
    if(!Class'Engine.WorldInfo'.static.IsConsoleBuild(0))
    {
        ActiveBindings.Remove(0, ActiveBindings.Length);
        PKPlayerInput(PC.PlayerInput).GetDefaultBindingsForPC(ActiveBindings);
        PC.ProfileSettings.SetKeyBindings(76, ActiveBindings);
        ActiveMessages.Remove(0, ActiveMessages.Length);
        PC.GetDefaultCustomMessages(ActiveMessages);
        PC.ProfileSettings.SetCustomMessages(79, ActiveMessages);
    }
    ActiveCustom1.Remove(0, ActiveCustom1.Length);
    PKPlayerInput(PC.PlayerInput).GetDefaultCustom1Weapons(ActiveCustom1);
    PC.ProfileSettings.SetProfileSettingValueBlob(77, ActiveCustom1);
    ActiveCustom2.Remove(0, ActiveCustom2.Length);
    PKPlayerInput(PC.PlayerInput).GetDefaultCustom2Weapons(ActiveCustom2);
    PC.ProfileSettings.SetProfileSettingValueBlob(78, ActiveCustom2);
    DiscardChanges();
    PC.ClientSaveAllPlayerData(true);
    bHasChanges = false;
    //return;    
}

function string GetLocalizedTextForCommand(string Cmd)
{
    return Localize("PKGFxUI_Menu_Options_Controls", Cmd, "PKHDGame");
    //return ReturnValue;    
}

static function string GetLocalizedTextForKeyName(name KeyName)
{
    // End:0x3E
    if(KeyName == 'None')
    {
        return Localize("Generic", "NoneMSG", "PKHDGame");
    }
    return Localize("GameMappedStrings", "GMS_" $ string(KeyName), "PKHDGame");
    //return ReturnValue;    
}

static function string GetLocalizedTextForEWeaponFireMode(PKTypes.EWeaponFireMode WeapFireMode)
{
    return Localize("FriendlyWeaponNames", string(GetEnum(Enum'PKTypes.EWeaponFireMode', int(WeapFireMode))), "PKHDGame");
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
    InfoChangeTextDLC5Note="In TPP game mode jump is disabled, in addition those commands bindings will be swapped:"
    HeaderTitleString="Controls Settings"
    MovieInfo=SwfMovie'PKHD_UI.PKControls'
}