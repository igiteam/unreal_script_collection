class GFxUDKFrontEnd_HostGame extends GFxUDKFrontEnd_LaunchGame within GFxMoviePlayer
    config(UI);

const SERVERTYPE_LAN = 0;
const SERVERTYPE_UNRANKED = 1;
const SERVERTYPE_RANKED = 2;
const MAXIMUM_PLAYER_COUNT = 24;

function OnViewActivated()
{
    local UIDataStore_Registry Registry;
    local UTGameSettingsCommon GameSettings;
    local string TempString;

    super.OnViewActivated();
    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    Registry.SetData("StandaloneGame", "0");
    SettingsDataStore = UIDataStore_OnlineGameSettings(Class'Engine.UIRoot'.static.StaticResolveDataStore('UTGameSettings'));
    GameSettings = UTGameSettingsCommon(SettingsDataStore.GetCurrentGameSettings());
    TempString = "0";
    GameSettings.SetPropertyFromStringByName('NumBots', TempString);
    Registry.SetData("ServerMOTD", Class'UTGameReplicationInfo'.default.MessageOfTheDay);
    Registry.SetData("ServerPassword", "");
    ValidateServerType();
    //return;    
}

function OnTopMostView(optional bool bPlayOpenAnimation = false)
{
    super.OnTopMostView(bPlayOpenAnimation);
    //return;    
}

static function string StripInvalidPasswordCharacters(string PasswordString, optional string InvalidChars = " \"/:?,=")
{
    local int I;

    I = 0;
    J0x18:

    // End:0x6C [Loop If]
    if(I < Len(InvalidChars))
    {
        PasswordString = Repl(PasswordString, Mid(InvalidChars, I, 1), "");
        I++;
        // [Loop Continue]
        goto J0x18;
    }
    return PasswordString;
    //return ReturnValue;    
}

function ValidateServerType()
{
    local int PlayerIndex, ValueIndex, PlayerControllerId;
    local name MatchTypeName;

    MatchTypeName = ((Class'Engine.WorldInfo'.static.IsConsoleBuild(1)) ? 'ServerType360' : 'ServerType');
    PlayerIndex = GetPlayerIndex();
    PlayerControllerId = GetPlayerControllerId(PlayerIndex);
    // End:0x11C
    if(!IsLoggedIn(PlayerControllerId, true) || Class'Engine.WorldInfo'.static.IsConsoleBuild(2))
    {
        ValueIndex = StringListDataStore.GetCurrentValueIndex(MatchTypeName);
        // End:0x11C
        if(ValueIndex != 0)
        {
            StringListDataStore.SetCurrentValueIndex(MatchTypeName, 0);
        }
    }
    //return;    
}

function string GenerateMutatorURLString()
{
    local DataStoreClient DSClient;
    local int Idx, MutatorIdx;
    local string GameModeString, MutatorURLString;
    local UIDataStore_Registry Registry;
    local array<UIResourceDataProvider> Providers;
    local UTUIDataProvider_Mutator Provider;
    local UTUIDataStore_MenuItems MenuDataStore;

    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    DSClient = Class'Engine.UIInteraction'.static.GetDataStoreClient();
    // End:0x2C6
    if(DSClient != none)
    {
        MenuDataStore = UTUIDataStore_MenuItems(DSClient.FindDataStore('UTMenuItems'));
        // End:0x2C6
        if(MenuDataStore != none)
        {
            Registry.GetData("SelectedGameMode", GameModeString);
            Registry.SetData("SelectedGameMode", "");
            MenuDataStore.GetResourceProviders('Mutators', Providers);
            Idx = 0;
            J0x168:

            // End:0x28C [Loop If]
            if(Idx < MenuDataStore.EnabledMutators.Length)
            {
                MutatorIdx = MenuDataStore.EnabledMutators[Idx];
                Provider = UTUIDataProvider_Mutator(Providers[MutatorIdx]);
                // End:0x27E
                if((Provider != none) && Provider.ClassName != "")
                {
                    // End:0x24B
                    if(MutatorURLString != "")
                    {                        
                        MutatorURLString $= ",";
                    }                    
                    MutatorURLString $= Provider.ClassName;
                }
                Idx++;
                // [Loop Continue]
                goto J0x168;
            }
            Registry.SetData("SelectedGameMode", GameModeString);
        }
    }
    // End:0x2F6
    if(MutatorURLString != "")
    {
        MutatorURLString = "?Mutator=" $ MutatorURLString;
    }
    return MutatorURLString;
    //return ReturnValue;    
}

function SetupGameSettings()
{
    local int ValueIndex;
    local UTGameSettingsCommon GameSettings;
    local string SelectedMap, SelectedGameMode, MutatorURLString;
    local UIDataStore_Registry Registry;

    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    GameSettings = UTGameSettingsCommon(SettingsDataStore.GetCurrentGameSettings());
    // End:0xC7
    if(Class'Engine.WorldInfo'.static.IsConsoleBuild(1))
    {
        ValueIndex = StringListDataStore.GetCurrentValueIndex('ServerType360');        
    }
    else
    {
        ValueIndex = StringListDataStore.GetCurrentValueIndex('ServerType');
    }
    switch(ValueIndex)
    {
        // End:0x155
        case 0:
            GameSettings.bIsLanMatch = true;
            GameSettings.bUsesArbitration = false;
            // End:0x20B
            break;
        // End:0x19E
        case 1:
            GameSettings.bIsLanMatch = false;
            GameSettings.bUsesArbitration = false;
            // End:0x20B
            break;
        // End:0x208
        case 2:
            GameSettings.bIsLanMatch = false;
            GameSettings.bUsesArbitration = true;
            GameSettings.NumPrivateConnections = 0;
            // End:0x20B
            break;
        // End:0xFFFF
        default:
            break;
    }
    GameSettings.NumPrivateConnections = Clamp(GameSettings.NumPrivateConnections, 0, GameSettings.MaxPlayers - 1);
    GameSettings.NumPublicConnections = GameSettings.MaxPlayers - GameSettings.NumPrivateConnections;
    GameSettings.NumOpenPublicConnections = GameSettings.NumPublicConnections;
    GameSettings.NumOpenPrivateConnections = GameSettings.NumPrivateConnections;
    MutatorURLString = GenerateMutatorURLString();
    GameSettings.SetMutators(MutatorURLString);
    Registry.GetData("SelectedMap", SelectedMap);
    Registry.GetData("SelectedGameMode", SelectedGameMode);
    GameSettings.SetPropertyFromStringByName('CustomMapName', SelectedMap);
    GameSettings.SetPropertyFromStringByName('CustomGameMode', SelectedGameMode);
    Registry.SetData("ServerMOTD", Class'UTGameReplicationInfo'.default.MessageOfTheDay);
    //return;    
}

function CreateOnlineGame(int PlayerIndex)
{
    local OnlineSubsystem OnlineSub;
    local OnlineGameInterface GameInterface;

    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x12C
    if(OnlineSub != none)
    {
        GameInterface = OnlineSub.GameInterface;
        // End:0x129
        if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
        {
            SetupGameSettings();
            GameInterface.AddCreateOnlineGameCompleteDelegate(OnGameCreated);
            // End:0x126
            if(SettingsDataStore.CreateGame(byte(GetPlayerControllerId(PlayerIndex))) == false)
            {
                GameInterface.ClearCreateOnlineGameCompleteDelegate(OnGameCreated);
            }            
        }        
    }
    //return;    
}

function OnGameCreated(name SessionName, bool bWasSuccessful)
{
    local OnlineGameSettings LocalGameSettings;
    local string TravelURL;
    local OnlineSubsystem OnlineSub;
    local OnlineGameInterface GameInterface;
    local string Mutators;
    local int OutValue;
    local string OutStringValue;
    local UIDataStore_Registry Registry;

    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x4CB
    if(OnlineSub != none)
    {
        GameInterface = OnlineSub.GameInterface;
        // End:0x4C8
        if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
        {
            GameInterface.ClearCreateOnlineGameCompleteDelegate(OnGameCreated);
            // End:0x4C5
            if(bWasSuccessful)
            {
                LocalGameSettings = SettingsDataStore.GetCurrentGameSettings();
                LocalGameSettings.bIsDedicated = StringListDataStore.GetCurrentValueIndex('DedicatedServer') == 1;
                LocalGameSettings.BuildURL(TravelURL);
                // End:0x22F
                if(Class'Engine.WorldInfo'.static.IsConsoleBuild(2) && LocalGameSettings.bIsDedicated || StringListDataStore.GetCurrentValueIndex('DedicatedServer') == 1)
                {                    
                    TravelURL $= "?Dedicated";
                }
                // End:0x2DE
                if(Registry.GetData("ServerPassword", OutStringValue) && Len(OutStringValue) > 0)
                {                    
                    TravelURL $= ("?GamePassword=" $ (StripInvalidPasswordCharacters(OutStringValue)));
                    LocalGameSettings.SetStringSettingValue(7, 1, false);                    
                }
                else
                {
                    LocalGameSettings.SetStringSettingValue(7, 0, false);
                }
                // End:0x361
                if(LocalGameSettings.GetIntProperty(268435703, OutValue))
                {                    
                    TravelURL $= ("?NumPlay=" $ string(OutValue + 1));
                }
                Registry.GetData("SelectedGameMode", OutStringValue);                
                TravelURL $= ("?game=" $ OutStringValue);
                Mutators = Class'GFxUDKFrontEnd_Mutators'.static.GetEnabledMutators();
                // End:0x428
                if(Len(Mutators) > 0)
                {                    
                    TravelURL $= ("?mutator=" $ Mutators);
                }                
                TravelURL $= (GetCommonOptionsURL());
                Registry.GetData("SelectedMap", OutStringValue);
                TravelURL = (("open " $ OutStringValue) $ TravelURL) $ "?listen";
                ConsoleCommand(TravelURL);                
            }            
        }        
    }
    //return;    
}

function FinishStartDedicated()
{
    local OnlineGameSettings LocalGameSettings;
    local string TravelURL, Mutators;
    local int OutValue;
    local string Password, GameMode;
    local UIDataStore_Registry Registry;

    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    LocalGameSettings = SettingsDataStore.GetCurrentGameSettings();
    SetupGameSettings();
    LocalGameSettings.BuildURL(TravelURL);
    // End:0x146
    if(Registry.GetData("ServerPassword", Password) && Len(Password) > 0)
    {        
        TravelURL $= ("?GamePassword=" $ (StripInvalidPasswordCharacters(Password)));
        LocalGameSettings.SetStringSettingValue(7, 1, false);        
    }
    else
    {
        LocalGameSettings.SetStringSettingValue(7, 0, false);
    }
    // End:0x1C9
    if(LocalGameSettings.GetIntProperty(268435703, OutValue))
    {        
        TravelURL $= ("?NumPlay=" $ string(OutValue + 1));
    }
    Registry.GetData("SelectedGameMode", GameMode);    
    TravelURL $= ("?game=" $ GameMode);
    Mutators = Class'GFxUDKFrontEnd_Mutators'.static.GetEnabledMutators();
    // End:0x290
    if(Len(Mutators) > 0)
    {        
        TravelURL $= ("?mutator=" $ Mutators);
    }    
    TravelURL $= (GetCommonOptionsURL());
    //return;    
}

function OnStartGame_Confirm()
{
    local OnlineGameSettings LocalGameSettings;

    LocalGameSettings = SettingsDataStore.GetCurrentGameSettings();
    // End:0x7F
    if(LocalGameSettings.bIsDedicated && !Class'Engine.WorldInfo'.static.IsConsoleBuild())
    {
        FinishStartDedicated();        
    }
    else
    {
        CreateOnlineGame(0);
    }
    //return;    
}

defaultproperties
{
    bRequiresNetwork=true
}