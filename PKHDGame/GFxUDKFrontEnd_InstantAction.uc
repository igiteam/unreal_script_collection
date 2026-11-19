class GFxUDKFrontEnd_InstantAction extends GFxUDKFrontEnd_LaunchGame within GFxMoviePlayer
    config(UI);

function OnViewActivated()
{
    local UIDataStore_Registry Registry;

    super.OnViewActivated();
    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    Registry.SetData("StandaloneGame", "1");
    //return;    
}

function OnStartGame_Confirm()
{
    local Settings GameSettings;
    local string URL, GameExec, Mutators;
    local int OutValue;
    local UIDataStore_Registry Registry;
    local string Map, Mode;

    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    GameSettings = SettingsDataStore.GetCurrentGameSettings();
    GameSettings.SetStringSettingValue(8, 0, false);
    GameSettings.BuildURL(URL);
    // End:0x110
    if(GameSettings.GetIntProperty(268435703, OutValue))
    {        
        URL $= ("?NumPlay=" $ string(OutValue + 1));
    }
    Mutators = Class'GFxUDKFrontEnd_Mutators'.static.GetEnabledMutators();
    // End:0x175
    if(Len(Mutators) > 0)
    {
        URL = (URL $ "?mutator=") $ Mutators;
    }
    URL = URL $ (GetCommonOptionsURL());
    Registry.GetData("SelectedMap", Map);
    Registry.GetData("SelectedGameMode", Mode);
    GameExec = ((("open " $ Map) $ "?game=") $ Mode) $ URL;
    ConsoleCommand(GameExec);
    //return;    
}
