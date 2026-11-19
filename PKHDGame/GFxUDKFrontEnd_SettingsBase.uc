class GFxUDKFrontEnd_SettingsBase extends GFxUDKFrontEnd_Screen within GFxMoviePlayer
    config(UI);

var GFxClikWidget ListMC;
var string SelectedOptionSet;
var GFxObject ListDataProvider;
var GFxObject MenuMC;
var array<UTUIDataProvider_MenuOption> SettingsList;
var transient UIDataStore_OnlineGameSettings SettingsDataStore;

function OnViewLoaded()
{
    super(GFxUDKFrontEnd_View).OnViewLoaded();
    SettingsDataStore = UIDataStore_OnlineGameSettings(Class'Engine.UIRoot'.static.StaticResolveDataStore('UTGameSettings'));
    //return;    
}

function OnViewActivated()
{
    super(GFxUDKFrontEnd_View).OnViewActivated();
    LoadDataFromStore();
    //return;    
}

function OnTopMostView(optional bool bPlayOpenAnimation = false)
{
    super(GFxUDKFrontEnd_View).OnTopMostView(bPlayOpenAnimation);
    UpdateListDataProvider();
    // End:0x8D
    if(ListMC != none)
    {
        MenuManager.SetSelectionFocus(ListMC);
        ListMC.SetFloat("selectedIndex", 0.0000000);
    }
    UpdateDescription();
    //return;    
}

function DisableSubComponents(bool bDisableComponents)
{
    ListMC.SetBool("disabled", bDisableComponents);
    BackBtn.SetBool("disabled", bDisableComponents);
    //return;    
}

function SetSelectedOptionSet()
{
    //return;    
}

function LoadDataFromStore()
{
    local int I, J, K;
    local bool bIsRelevant, bIsDuplicate;
    local string CurrentOptionSet;
    local UTUIDataProvider_MenuOption CurrentOption;
    local array<UDKUIResourceDataProvider> ProviderList;

    SettingsList.Length = 0;
    SetSelectedOptionSet();
    Class'UTUIDataStore_MenuItems'.static.GetAllResourceDataProviders(Class'UTUIDataProvider_MenuOption', ProviderList);
    I = ProviderList.Length - 1;
    J0x5E:

    // End:0x240 [Loop If]
    if(I > -1)
    {
        bIsRelevant = false;
        CurrentOption = UTUIDataProvider_MenuOption(ProviderList[I]);
        J = 0;
        J0xAE:

        // End:0x143 [Loop If]
        if(J < CurrentOption.OptionSet.Length)
        {
            CurrentOptionSet = string(CurrentOption.OptionSet[J]);
            // End:0x135
            if(CurrentOptionSet == SelectedOptionSet)
            {
                bIsRelevant = true;
                // [Explicit Break]
                goto J0x143;
            }
            J++;
            // [Loop Continue]
            goto J0xAE;
        }
        J0x143:

        // End:0x232
        if(bIsRelevant)
        {
            bIsDuplicate = false;
            K = 0;
            J0x167:

            // End:0x1E7 [Loop If]
            if(K < SettingsList.Length)
            {
                // End:0x1D9
                if(SettingsList[K].DataStoreMarkup == CurrentOption.DataStoreMarkup)
                {
                    bIsDuplicate = true;
                    // [Explicit Break]
                    goto J0x1E7;
                }
                K++;
                // [Loop Continue]
                goto J0x167;
            }
            J0x1E7:

            // End:0x232
            if(!bIsDuplicate && !CurrentOption.ShouldBeFiltered())
            {
                SettingsList.AddItem(CurrentOption);
            }
        }
        I--;
        // [Loop Continue]
        goto J0x5E;
    }
    //return;    
}

function Select_Back(EventData ev)
{
    Select_BackImpl();
    //return;    
}

function SaveState()
{
    local int I, SelectedIndex, SettingIndex;
    local string ControlType;
    local GFxObject Data;
    local UTGameSettingsCommon LocalGameSettings;
    local SettingsData SettingsDat;

    LocalGameSettings = UTGameSettingsCommon(SettingsDataStore.GetCurrentGameSettings());
    I = 0;
    J0x3D:

    // End:0x3C3 [Loop If]
    if(I < SettingsList.Length)
    {
        Data = ListDataProvider.GetElementObject(I);
        ControlType = Data.GetString("control");
        switch(ControlType)
        {
            // End:0x3AF
            case "stepper":
                SelectedIndex = int(Data.GetFloat("optIndex"));
                SettingIndex = FindLocalizedSettingIndexByName(string(SettingsList[I].Name));
                // End:0x209
                if(SettingIndex > -1)
                {
                    SelectedIndex = LocalGameSettings.LocalizedSettingsMappings[SettingIndex].ValueMappings[SelectedIndex].Id;
                    LocalGameSettings.LocalizedSettings[SettingIndex].ValueIndex = SelectedIndex;                    
                }
                else
                {
                    SelectedIndex = int(Data.GetFloat("optIndex"));
                    SettingIndex = FindPropertyIndexByName(string(SettingsList[I].Name));
                    // End:0x3AC
                    if(SettingIndex > -1)
                    {
                        SelectedIndex = LocalGameSettings.PropertyMappings[SettingIndex].PredefinedValues[SelectedIndex].Value1;
                        SettingsDat = LocalGameSettings.Properties[SettingIndex].Data;
                        Class'Engine.Settings'.static.SetSettingsDataInt(SettingsDat, SelectedIndex);
                        LocalGameSettings.Properties[SettingIndex].Data = SettingsDat;
                    }
                }
                // End:0x3B5
                break;
            // End:0xFFFF
            default:
                // End:0x3B5
                break;
                break;
        }
        I++;
        // [Loop Continue]
        goto J0x3D;
    }
    //return;    
}

function SetList(GFxObject List)
{
    ActionScriptVoid("setList");
    //return;    
}

function OnListChange(EventData ev)
{
    UpdateDescription();
    //return;    
}

function OnOptionChanged(EventData ev)
{
    //return;    
}

function UpdateDescription()
{
    local int SelectedIndex;
    local string Description;

    // End:0xD8
    if(ListMC != none)
    {
        SelectedIndex = int(ListMC.GetFloat("selectedIndex"));
        // End:0xB6
        if(SelectedIndex >= 0)
        {
            Description = SettingsList[SelectedIndex].Description;
            InfoTxt.SetText(Description);            
        }
        else
        {
            InfoTxt.SetText("");
        }
    }
    //return;    
}

function UpdateListDataProvider()
{
    //return;    
}

function int FindLocalizedSettingIndexByName(coerce string InSettingName)
{
    local byte I;
    local int StringIndex;
    local UTGameSettingsCommon GameSettings;

    GameSettings = UTGameSettingsCommon(SettingsDataStore.GetCurrentGameSettings());
    I = 0;
    J0x3E:

    // End:0xF1 [Loop If]
    if(int(I) < GameSettings.LocalizedSettingsMappings.Length)
    {
        StringIndex = InStr(InSettingName, string(GameSettings.LocalizedSettingsMappings[int(I)].Name));
        // End:0xE3
        if(StringIndex > -1)
        {
            return int(I);
        }
        I++;
        // [Loop Continue]
        goto J0x3E;
    }
    return -1;
    //return ReturnValue;    
}

function OnEscapeKeyPress()
{
    Select_BackImpl();
    //return;    
}

function Select_BackImpl()
{
    SaveState();
    // End:0x42
    if(MenuManager != none)
    {
        PlayCloseAnimation();
        MenuManager.PopView();
    }
    //return;    
}

function int FindPropertyIndexByName(coerce string InPropertyName)
{
    local byte I;
    local int StringIndex;
    local UTGameSettingsCommon GameSettings;

    GameSettings = UTGameSettingsCommon(SettingsDataStore.GetCurrentGameSettings());
    I = 0;
    J0x3E:

    // End:0xF1 [Loop If]
    if(int(I) < GameSettings.PropertyMappings.Length)
    {
        StringIndex = InStr(InPropertyName, string(GameSettings.PropertyMappings[int(I)].Name));
        // End:0xE3
        if(StringIndex > -1)
        {
            return int(I);
        }
        I++;
        // [Loop Continue]
        goto J0x3E;
    }
    return -1;
    //return ReturnValue;    
}

event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
    local bool bWasHandled;

    bWasHandled = false;
    switch(WidgetName)
    {
        // End:0x169
        case 'List':
            // End:0x166
            if(ListMC == none)
            {
                ListMC = GFxClikWidget(Widget);
                SetList(ListMC);
                UpdateListDataProvider();
                ListMC.SetFloat("selectedIndex", 0.0000000);
                ListMC.AddEventListener('CLIK_change', OnListChange);
                ListMC.AddEventListener('CLIK_focusIn', OnListChange);
                ListMC.AddEventListener('CLIK_itemChange', OnOptionChanged);
                bWasHandled = true;
            }
            // End:0x1AC
            break;
        // End:0x1A6
        case 'menu':
            // End:0x1A3
            if(MenuMC == none)
            {
                MenuMC = Widget;
                bWasHandled = true;
            }
            // End:0x1AC
            break;
        // End:0xFFFF
        default:
            // End:0x1AC
            break;
            break;
    }
    // End:0x1EB
    if(!bWasHandled)
    {
        bWasHandled = super.WidgetInitialized(WidgetName, WidgetPath, Widget);
    }
    return bWasHandled;
    //return ReturnValue;    
}
