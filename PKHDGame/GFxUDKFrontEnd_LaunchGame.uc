class GFxUDKFrontEnd_LaunchGame extends GFxUDKFrontEnd_Screen within GFxMoviePlayer
    abstract
    config(UI);

const MarkupForNoMapImage = "UDKFrontEnd.gm_map_none";

struct Option
{
    var string OptionName;
    var string OptionLabel;
    var string OptionDesc;

    structdefaultproperties
    {
        OptionName=""
        OptionLabel=""
        OptionDesc=""
    }
};

var transient UIDataStore_OnlineGameSettings SettingsDataStore;
var transient UTUIDataStore_StringList StringListDataStore;
var transient string DefaultMapName;
var transient string DefaultGameMode;
var transient string DefaultGameModeSettings;
var transient string DefaultMapImage;
var transient string DefaultGameModePrefixes;
var config array<config Option> ListOptions;
var GFxClikWidget ListMC;
var GFxObject ListDataProvider;
var GFxObject MenuMC;
var GFxObject MapImageMC;
var GFxObject MapNameTxt;
var GFxObject GameTitleTxt;
var GFxObject BotLvlTxt;
var GFxObject OpponentsTxt;
var GFxObject ScoreTxt;
var GFxObject TimeTxt;
var GFxObject MapTxt;
var GFxObject RespawnTxt;
var GFxObject MutatorsTxt;
var GFxObject MapLabelTxt;
var GFxObject BotLvlLabelTxt;
var GFxObject OpponentsLabelTxt;
var GFxObject ScoreLabelTxt;
var GFxObject TimeLabelTxt;
var GFxObject RespawnLabelTxt;
var GFxObject MutatorsLabelTxt;

function OnViewLoaded()
{
    local DataStoreClient DSClient;

    super(GFxUDKFrontEnd_View).OnViewLoaded();
    DSClient = Class'Engine.UIInteraction'.static.GetDataStoreClient();
    SettingsDataStore = UIDataStore_OnlineGameSettings(DSClient.FindDataStore('UTGameSettings'));
    StringListDataStore = UTUIDataStore_StringList(DSClient.FindDataStore('UTStringList'));
    //return;    
}

function OnViewActivated()
{
    local bool bFoundDefaultMap;
    local array<UDKUIResourceDataProvider> ProviderList;
    local int I;
    local UIDataStore_Registry Registry;

    Class'UTUIDataStore_MenuItems'.static.GetAllResourceDataProviders(Class'UTUIDataProvider_MapInfo', ProviderList);
    I = 0;
    J0x3C:

    // End:0xB0 [Loop If]
    if(I < ProviderList.Length)
    {
        // End:0xA2
        if(UDKUIDataProvider_MapInfo(ProviderList[I]).MapName ~= DefaultMapName)
        {
            bFoundDefaultMap = true;
            // [Explicit Break]
            goto J0xB0;
        }
        I++;
        // [Loop Continue]
        goto J0x3C;
    }
    J0xB0:

    // End:0x106
    if(!bFoundDefaultMap)
    {
        DefaultMapName = ((ProviderList.Length > 0) ? UDKUIDataProvider_MapInfo(ProviderList[0]).MapName : "");
    }
    SettingsDataStore.SetCurrentByName(name(DefaultGameModeSettings));
    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    Registry.SetData("SelectedGameModePrefix", DefaultGameModePrefixes);
    Registry.SetData("SelectedGameMode", DefaultGameMode);
    Registry.SetData("SelectedMap", DefaultMapName);
    Registry.SetData("SelectedMapImage", DefaultMapImage);
    //return;    
}

function DisableSubComponents(bool bDisableComponents)
{
    ListMC.SetBool("disabled", bDisableComponents);
    BackBtn.SetBool("disabled", bDisableComponents);
    //return;    
}

function OnTopMostView(optional bool bPlayOpenAnimation = false)
{
    super(GFxUDKFrontEnd_View).OnTopMostView(bPlayOpenAnimation);
    MenuManager.SetSelectionFocus(ListMC);
    UpdateDescription();
    UpdateGameSettingsPanel();
    //return;    
}

function PlayOpenAnimation()
{
    MenuMC.GotoAndPlay("open");
    FooterMC.GotoAndPlay("next");
    //return;    
}

function PlayCloseAnimation()
{
    MenuMC.GotoAndPlay("close");
    //return;    
}

function OnStartGame_Confirm()
{
    //return;    
}

final function UpdateGameSettingsPanel()
{
    local ASValue asval;
    local array<ASValue> args;
    local int EnabledMutatorCount;
    local string SelectedMapImage;
    local UIDataStore_Registry Registry;
    local string Map, Mode, MapImage;
    local UTGameSettingsCommon GameSettings;
    local string TempString;
    local int I, StringIndex;

    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    Registry.GetData("SelectedGameMode", Mode);
    Registry.GetData("SelectedMap", Map);
    Registry.GetData("SelectedMapImage", MapImage);
    GameTitleTxt.SetText(Caps(GetGameModeFriendlyString(Mode)));
    MapNameTxt.SetText(Map);
    SelectedMapImage = MapImage;
    SelectedMapImage = ((SelectedMapImage != "") ? SelectedMapImage : "UDKFrontEnd.gm_map_none");
    asval.Type = 4;
    asval.S = "img://" $ SelectedMapImage;
    args[0] = asval;    
    MapImageMC.Invoke("loadMovie", args);
    GameSettings = UTGameSettingsCommon(SettingsDataStore.GetCurrentGameSettings());
    TempString = GameSettings.GetPropertyAsStringByName('NumBots');
    OpponentsTxt.SetText(TempString);
    TempString = GameSettings.GetPropertyAsStringByName('GoalScore');
    ScoreTxt.SetText(TempString);
    TempString = GameSettings.GetPropertyAsStringByName('TimeLimit');
    TimeTxt.SetText(TempString);
    I = 0;
    J0x382:

    // End:0x611 [Loop If]
    if(I < GameSettings.LocalizedSettingsMappings.Length)
    {
        StringIndex = InStr("BotSkill", string(GameSettings.LocalizedSettingsMappings[I].Name));
        // End:0x4D7
        if(StringIndex > -1)
        {
            TempString = string(GameSettings.LocalizedSettingsMappings[I].ValueMappings[GameSettings.LocalizedSettings[I].ValueIndex].Name);
            BotLvlTxt.SetText(TempString);
        }
        StringIndex = InStr("ForceRespawn", string(GameSettings.LocalizedSettingsMappings[I].Name));
        // End:0x603
        if(StringIndex > -1)
        {
            TempString = string(GameSettings.LocalizedSettingsMappings[I].ValueMappings[GameSettings.LocalizedSettings[I].ValueIndex].Name);
            RespawnTxt.SetText(TempString);
        }
        I++;
        // [Loop Continue]
        goto J0x382;
    }
    EnabledMutatorCount = Class'GFxUDKFrontEnd_Mutators'.static.GetNumEnabledMutators();
    MutatorsTxt.SetText(string(EnabledMutatorCount));
    //return;    
}

function OnListItemPress(EventData ev)
{
    local int SelectedIndex;
    local name Selection;

    SelectedIndex = ev.Index;
    Selection = name(ListOptions[SelectedIndex].OptionName);
    switch(Selection)
    {
        // End:0xA3
        case 'GameMode':
            MenuManager.PushViewByName('GameMode');
            // End:0x1A2
            break;
        // End:0xDB
        case 'MapSelect':
            MenuManager.PushViewByName('MapSelect');
            // End:0x1A2
            break;
        // End:0x113
        case 'Settings':
            MenuManager.PushViewByName('Settings');
            // End:0x1A2
            break;
        // End:0x14B
        case 'ServerSettings':
            MenuManager.PushViewByName('ServerSettings');
            // End:0x1A2
            break;
        // End:0x183
        case 'Mutators':
            MenuManager.PushViewByName('Mutators');
            // End:0x1A2
            break;
        // End:0x19C
        case 'StartGame':
            OnStartGame_Confirm();
            // End:0x1A2
            break;
        // End:0xFFFF
        default:
            // End:0x1A2
            break;
            break;
    }
    //return;    
}

function OnListChange(EventData ev)
{
    UpdateDescription();
    //return;    
}

function UpdateDescription()
{
    local int SelectedIndex;
    local string Description;

    // End:0xB1
    if(ListMC != none)
    {
        SelectedIndex = int(ListMC.GetFloat("selectedIndex"));
        // End:0xB1
        if(SelectedIndex >= 0)
        {
            Description = ListOptions[SelectedIndex].OptionDesc;
            InfoTxt.SetText(Description);
        }
    }
    //return;    
}

function UpdateListDataProvider()
{
    local byte I;
    local GFxObject DataProvider, TempObj;

    DataProvider = Outer.CreateArray();
    I = 0;
    J0x35:

    // End:0x160 [Loop If]
    if(int(I) < ListOptions.Length)
    {
        TempObj = Outer.CreateObject("Object");
        TempObj.SetString("name", ListOptions[int(I)].OptionName);
        TempObj.SetString("label", ListOptions[int(I)].OptionLabel);
        DataProvider.SetElementObject(int(I), TempObj);
        I++;
        // [Loop Continue]
        goto J0x35;
    }
    ListMC.SetObject("dataProvider", DataProvider);
    ListDataProvider = ListMC.GetObject("dataProvider");
    //return;    
}

static function string GetGameModeFriendlyString(string InGameMode)
{
    local string RetString;

    switch(InGameMode)
    {
        // End:0x44
        case "UTGame.UTDeathmatch":
            RetString = "Deathmatch";
            // End:0xDB
            break;
        // End:0x78
        case "UTGame.UTTeamGame":
            RetString = "Team Deathmatch";
            // End:0xDB
            break;
        // End:0xC2
        case "UTGameContent.UTVehicleCTFGame_Content":
            RetString = "Capture the Flag";
            // End:0xDB
            break;
        // End:0xFFFF
        default:
            RetString = InGameMode;
            // End:0xDB
            break;
            break;
    }
    return RetString;
    //return ReturnValue;    
}

event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
    local bool bWasHandled;

    bWasHandled = false;
    switch(WidgetName)
    {
        // End:0x160
        case 'List':
            // End:0x15D
            if(ListMC == none)
            {
                ListMC = GFxClikWidget(Widget);
                UpdateListDataProvider();
                ListMC.SetFloat("selectedIndex", float(ListOptions.Length - 1));
                ListMC.AddEventListener('CLIK_itemPress', OnListItemPress);
                ListMC.AddEventListener('CLIK_change', OnListChange);
                ListMC.AddEventListener('CLIK_focusIn', OnListChange);
                bWasHandled = true;
            }
            // End:0x71A
            break;
        // End:0x19D
        case 'menu':
            // End:0x19A
            if(MenuMC == none)
            {
                MenuMC = Widget;
                bWasHandled = true;
            }
            // End:0x71A
            break;
        // End:0x1DA
        case 'Map':
            // End:0x1D7
            if(MapNameTxt == none)
            {
                MapNameTxt = Widget;
                bWasHandled = true;
            }
            // End:0x71A
            break;
        // End:0x238
        case 'gamestats_gamemode':
            // End:0x235
            if(GameTitleTxt == none)
            {
                GameTitleTxt = Widget.GetObject("gamemode");
                bWasHandled = true;
            }
            // End:0x71A
            break;
        // End:0x291
        case 'rightside':
            // End:0x28E
            if(MapImageMC == none)
            {
                MapImageMC = Widget.GetObject("map");
                bWasHandled = true;
            }
            // End:0x71A
            break;
        // End:0x2CE
        case 'bot_lvl':
            // End:0x2CB
            if(BotLvlTxt == none)
            {
                BotLvlTxt = Widget;
                bWasHandled = true;
            }
            // End:0x71A
            break;
        // End:0x30B
        case 'opponents':
            // End:0x308
            if(OpponentsTxt == none)
            {
                OpponentsTxt = Widget;
                bWasHandled = true;
            }
            // End:0x71A
            break;
        // End:0x348
        case 'Score':
            // End:0x345
            if(ScoreTxt == none)
            {
                ScoreTxt = Widget;
                bWasHandled = true;
            }
            // End:0x71A
            break;
        // End:0x385
        case 'Time':
            // End:0x382
            if(TimeTxt == none)
            {
                TimeTxt = Widget;
                bWasHandled = true;
            }
            // End:0x71A
            break;
        // End:0x3C2
        case 'Respawn':
            // End:0x3BF
            if(RespawnTxt == none)
            {
                RespawnTxt = Widget;
                bWasHandled = true;
            }
            // End:0x71A
            break;
        // End:0x3FF
        case 'Mutators':
            // End:0x3FC
            if(MutatorsTxt == none)
            {
                MutatorsTxt = Widget;
                bWasHandled = true;
            }
            // End:0x71A
            break;
        // End:0x43C
        case 'Map':
            // End:0x439
            if(MapTxt == none)
            {
                MapTxt = Widget;
                bWasHandled = true;
            }
            // End:0x71A
            break;
        // End:0x49E
        case 'label1':
            // End:0x49B
            if(MapLabelTxt == none)
            {
                MapLabelTxt = Widget;
                Widget.SetText("MAP");
                bWasHandled = true;
            }
            // End:0x71A
            break;
        // End:0x50A
        case 'label2':
            // End:0x507
            if(BotLvlLabelTxt == none)
            {
                BotLvlLabelTxt = Widget;
                Widget.SetText("BOT SKILL LVL");
                bWasHandled = true;
            }
            // End:0x71A
            break;
        // End:0x572
        case 'label3':
            // End:0x56F
            if(OpponentsLabelTxt == none)
            {
                OpponentsLabelTxt = Widget;
                Widget.SetText("OPPONENTS");
                bWasHandled = true;
            }
            // End:0x71A
            break;
        // End:0x5D6
        case 'label4':
            // End:0x5D3
            if(ScoreLabelTxt == none)
            {
                ScoreLabelTxt = Widget;
                Widget.SetText("SCORE");
                bWasHandled = true;
            }
            // End:0x71A
            break;
        // End:0x63F
        case 'label5':
            // End:0x63C
            if(TimeLabelTxt == none)
            {
                TimeLabelTxt = Widget;
                Widget.SetText("TIME LIMIT");
                bWasHandled = true;
            }
            // End:0x71A
            break;
        // End:0x6A5
        case 'label6':
            // End:0x6A2
            if(RespawnLabelTxt == none)
            {
                RespawnLabelTxt = Widget;
                Widget.SetText("RESPAWN");
                bWasHandled = true;
            }
            // End:0x71A
            break;
        // End:0x714
        case 'label7':
            // End:0x711
            if(MutatorsLabelTxt == none)
            {
                MutatorsLabelTxt = Widget;
                Widget.SetText("ENABLED MUTATORS");
                bWasHandled = true;
            }
            // End:0x71A
            break;
        // End:0xFFFF
        default:
            // End:0x71A
            break;
            break;
    }
    // End:0x759
    if(!bWasHandled)
    {
        bWasHandled = super.WidgetInitialized(WidgetName, WidgetPath, Widget);
    }
    return bWasHandled;
    //return ReturnValue;    
}

defaultproperties
{
    DefaultMapName="DM-Deck"
    DefaultGameMode="UTGame.UTDeathmatch"
    DefaultGameModeSettings="UTgameSettingsDM"
    DefaultMapImage="UI_FrontEnd_Art.MapPics.___map-pic-dm-deck"
    DefaultGameModePrefixes="DM"
}