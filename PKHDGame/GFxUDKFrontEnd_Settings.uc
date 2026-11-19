class GFxUDKFrontEnd_Settings extends GFxUDKFrontEnd_SettingsBase within GFxMoviePlayer
    config(UI);

function SetSelectedOptionSet()
{
    local UIDataStore_Registry Registry;

    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    SelectedOptionSet = "";
    Registry.GetData("SelectedGameModePrefix", SelectedOptionSet);
    // End:0xA6
    if(SelectedOptionSet == "")
    {
        SelectedOptionSet = "DM";
    }
    //return;    
}

function UpdateListDataProvider()
{
    local byte I;
    local string DefaultValue;
    local int DefaultIndex;
    local GFxObject RendererDataProvider, DataProvider, TempObj;

    DataProvider = Outer.CreateArray();
    I = 0;
    J0x35:

    // End:0x34E [Loop If]
    if(int(I) < SettingsList.Length)
    {
        TempObj = Outer.CreateObject("Object");
        TempObj.SetString("label", Caps(SettingsList[int(I)].FriendlyName));
        TempObj.SetString("control", "stepper");
        RendererDataProvider = Outer.CreateArray();
        PopulateOptionDataProviderForIndex(int(I), RendererDataProvider, DefaultValue, DefaultIndex);
        TempObj.SetBool("bUpdateFromUnreal", true);
        TempObj.SetObject("dataProvider", RendererDataProvider);
        TempObj.SetFloat("optIndex", float(DefaultIndex));
        TempObj.SetBool("bNumericCombo", SettingsList[int(I)].bNumericCombo);
        TempObj.SetBool("bEditableCombo", SettingsList[int(I)].bEditableCombo);
        TempObj.SetFloat("editBoxMaxLength", float(SettingsList[int(I)].EditBoxMaxLength));
        DataProvider.SetElementObject(int(I), TempObj);
        I++;
        // [Loop Continue]
        goto J0x35;
    }
    ListMC.SetObject("dataProvider", DataProvider);
    ListDataProvider = ListMC.GetObject("dataProvider");
    //return;    
}

function PopulateOptionDataProviderForIndex(const int Index, out GFxObject OutDataProvider, out string OutDefaultValue, out int OutDefaultIndex)
{
    local int I;
    local UTGameSettingsCommon GameSettings;
    local int SettingIndex;

    GameSettings = UTGameSettingsCommon(SettingsDataStore.GetCurrentGameSettings());
    OutDefaultIndex = 0;
    SettingIndex = FindLocalizedSettingIndexByName(string(SettingsList[Index].Name));
    // End:0x1BB
    if(SettingIndex > -1)
    {
        I = 0;
        J0x99:

        // End:0x173 [Loop If]
        if(I < GameSettings.LocalizedSettingsMappings[SettingIndex].ValueMappings.Length)
        {
            OutDataProvider.SetElementString(I, string(GameSettings.LocalizedSettingsMappings[SettingIndex].ValueMappings[I].Name));
            I++;
            // [Loop Continue]
            goto J0x99;
        }
        OutDefaultIndex = GameSettings.LocalizedSettings[SettingIndex].ValueIndex;        
    }
    else
    {
        SettingIndex = FindPropertyIndexByName(string(SettingsList[Index].Name));
        OutDefaultValue = string(GameSettings.Properties[SettingIndex].Data.Value1);
        I = 0;
        J0x25E:

        // End:0x3B3 [Loop If]
        if(I < GameSettings.PropertyMappings[SettingIndex].PredefinedValues.Length)
        {
            // End:0x323
            if(OutDefaultValue == string(GameSettings.PropertyMappings[SettingIndex].PredefinedValues[I].Value1))
            {
                OutDefaultIndex = I;
            }
            OutDataProvider.SetElementString(I, string(GameSettings.PropertyMappings[SettingIndex].PredefinedValues[I].Value1));
            I++;
            // [Loop Continue]
            goto J0x25E;
        }
    }
    //return;    
}
