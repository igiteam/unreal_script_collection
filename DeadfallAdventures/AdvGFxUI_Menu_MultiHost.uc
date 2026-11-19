class AdvGFxUI_Menu_MultiHost extends AdvGFxUI_Menu_Base
    config(UI);

const GS_USERNAME_MAXLENGTH = 15;
const GS_PASSWORD_MAXLENGTH = 30;
const GS_MESSAGE_MAXLENGTH = 255;
const GS_EMAIL_MAXLENGTH = 50;
const GS_CDKEY_PART_MAXLENGTH = 4;
const CONTEXT_GAME_MODE = 0x0000800B;
const CONTEXT_BOTSKILL = 30;
const CONTEXT_MAPNAME = 31;
const CONTEXT_PURESERVER = 36;
const CONTEXT_LOCKEDSERVER = 37;
const CONTEXT_VSBOTS = 38;
const CONTEXT_CAMPAIGN = 39;
const CONTEXT_FORCERESPAWN = 40;
const CONTEXT_ALLOWKEYBOARD = 41;
const CONTEXT_FULLSERVER = 42;
const CONTEXT_EMPTYSERVER = 43;
const CONTEXT_DEDICATEDSERVER = 44;
const CONTEXT_MAPNAME_CUSTOM = 0;
const CONTEXT_BOTSKILL_NOVICE = 0;
const CONTEXT_BOTSKILL_AVERAGE = 1;
const CONTEXT_BOTSKILL_EXPERIENCED = 2;
const CONTEXT_BOTSKILL_SKILLED = 3;
const CONTEXT_BOTSKILL_ADEPT = 4;
const CONTEXT_BOTSKILL_MASTERFUL = 5;
const CONTEXT_BOTSKILL_INHUMAN = 6;
const CONTEXT_BOTSKILL_GODLIKE = 7;
const CONTEXT_GOALSCORE_5 = 0;
const CONTEXT_GOALSCORE_10 = 1;
const CONTEXT_GOALSCORE_15 = 2;
const CONTEXT_GOALSCORE_20 = 3;
const CONTEXT_GOALSCORE_30 = 4;
const CONTEXT_NUMBOTS = 0;
const CONTEXT_NUMBOTS_1 = 1;
const CONTEXT_NUMBOTS_2 = 2;
const CONTEXT_NUMBOTS_3 = 3;
const CONTEXT_NUMBOTS_4 = 4;
const CONTEXT_NUMBOTS_5 = 5;
const CONTEXT_NUMBOTS_6 = 6;
const CONTEXT_NUMBOTS_7 = 7;
const CONTEXT_NUMBOTS_8 = 8;
const CONTEXT_TIMELIMIT_5 = 0;
const CONTEXT_TIMELIMIT_10 = 1;
const CONTEXT_TIMELIMIT_15 = 2;
const CONTEXT_TIMELIMIT_20 = 3;
const CONTEXT_TIMELIMIT_30 = 4;
const CONTEXT_PURESERVER_NO = 0;
const CONTEXT_PURESERVER_YES = 1;
const CONTEXT_PURESERVER_ANY = 2;
const CONTEXT_QUICKSEARCH_NO = 0;
const CONTEXT_QUICKSEARCH_YES = 1;
const CONTEXT_QUICKSEARCH_ANY = 2;
const CONTEXT_LOCKEDSERVER_NO = 0;
const CONTEXT_LOCKEDSERVER_YES = 1;
const CONTEXT_CAMPAIGN_NO = 0;
const CONTEXT_CAMPAIGN_YES = 1;
const CONTEXT_FORCERESPAWN_NO = 0;
const CONTEXT_FORCERESPAWN_YES = 1;
const CONTEXT_ALLOWKEYBOARD_NO = 0;
const CONTEXT_ALLOWKEYBOARD_YES = 1;
const CONTEXT_ALLOWKEYBOARD_ANY = 2;
const CONTEXT_FULLSERVER_NO = 0;
const CONTEXT_FULLSERVER_YES = 1;
const CONTEXT_EMPTYSERVER_NO = 0;
const CONTEXT_EMPTYSERVER_YES = 1;
const CONTEXT_DEDICATEDSERVER_NO = 0;
const CONTEXT_DEDICATEDSERVER_YES = 1;
const CONTEXT_VSBOTS_NONE = 0;
const CONTEXT_VSBOTS_1_TO_2 = 1;
const CONTEXT_VSBOTS_1_TO_1 = 2;
const CONTEXT_VSBOTS_3_TO_2 = 3;
const CONTEXT_VSBOTS_2_TO_1 = 4;
const CONTEXT_VSBOTS_3_TO_1 = 5;
const CONTEXT_VSBOTS_4_TO_1 = 6;
const PROPERTY_NUMBOTS = 0x100000F7;
const PROPERTY_GOALSCORE = 0x100000F8;
const PROPERTY_TIMELIMIT = 0x100000F9;
const PROPERTY_ROUNDSTOWIN = 0x100000FA;
const PROPERTY_SCOREFORWIN = 0x100000FB;
const PROPERTY_XPFORWIN = 0x100000FC;
const PROPERTY_ADVERTISEDMAPNAME = 0x100000FD;
const PROPERTY_LEADERBOARDRATING = 0x20000004;
const PROPERTY_EPICMUTATORS = 0x10000105;
const PROPERTY_CUSTOMMAPNAME = 0x40000001;
const PROPERTY_CUSTOMGAMEMODE = 0x40000002;
const PROPERTY_SERVERDESCRIPTION = 0x40000003;
const PROPERTY_CUSTOMMUTATORS = 0x40000004;
const PROPERTY_JIP_ALLOWED = 0x40000005;
const QUERY_DM = 0;
const QUERY_TDM = 1;
const QUERY_CTF = 2;
const QUERY_SV = 3;
const QUERY_CUSTOM = 4;
const QUERY_QUICK = 5;
const STATS_VIEW_DM_PLAYER_ALLTIME = 1;
const STATS_VIEW_DM_RANKED_ALLTIME = 2;
const STATS_VIEW_DM_WEAPONS_ALLTIME = 3;
const STATS_VIEW_DM_VEHICLES_ALLTIME = 4;
const STATS_VIEW_DM_VEHICLEWEAPONS_ALLTIME = 5;
const STATS_VIEW_DM_VEHICLES_RANKED_ALLTIME = 6;
const STATS_VIEW_DM_VEHICLEWEAPONS_RANKED_ALLTIME = 7;
const STATS_VIEW_DM_WEAPONS_RANKED_ALLTIME = 8;
const PROPERTY_PLAYLISTID = 0x1000000B;
const PROPERTY_DATACENTERID = 0x1000001F;
const PROPERTY_PLAYLISTMANAGERVERSION = 0x10000020;
const PROPERTY_GAMERLOCALE = 0x1000009E;
const PROPERTY_MATCHXPLEVEL = 0x1000009F;
const CONTEXT_GAME_MODE_VERSUS_LOADBALANCE1 = 13;
const CONTEXT_GAME_MODE_VERSUS_LOADBALANCE2 = 14;
const CONTEXT_GAME_MODE_VERSUS_LOADBALANCE3 = 15;
const CONTEXT_GAME_MODE_VERSUS_LOADBALANCE4 = 16;
const CONTEXT_GAME_MODE_VERSUS_LOADBALANCE5 = 17;
const CONTEXT_GAME_MODE_VERSUS_LOADBALANCE6 = 18;
const CONTEXT_GAME_MODE_VERSUS_LOADBALANCE7 = 19;
const CONTEXT_GAME_MODE_VERSUS_LOADBALANCE8 = 20;
const CONTEXT_PARTYSLOT_BLOCKED = 0;
const CONTEXT_PARTYSLOT_WANTS = 1;
const CONTEXT_PARTYSLOT_NEEDS = 2;
const CONTEXT_PARTYSLOT_ANY = 3;
const CONTEXT_PARTYSLOT_1 = 2;
const CONTEXT_PARTYSLOT_2 = 3;
const CONTEXT_PARTYSLOT_3 = 4;
const CONTEXT_PARTYSLOT_4 = 5;
const CONTEXT_PARTYSLOT_5 = 6;
const CONTEXT_MODULOSTEP = 12;
const CONTEXT_MODULOSTEP_MODULOSTEP = 0;
const CONTEXT_MODULOSTEP_MODULOSTEP_1 = 1;
const CONTEXT_MODULOSTEP_MODULOSTEP_2 = 2;
const CONTEXT_MODULOSTEP_MODULOSTEP_3 = 3;
const CONTEXT_MODULOSTEP_MODULOSTEP_4 = 4;
const CONTEXT_MODULOSTEP_MODULOSTEP_5 = 5;
const CONTEXT_MODULOSTEP_MODULOSTEP_6 = 6;
const CONTEXT_MODULOSTEP_MODULOSTEP_7 = 7;
const CONTEXT_MODULOSTEP_MODULOSTEP_8 = 8;
const CONTEXT_MODULOSTEP_MODULOSTEP_9 = 9;
const CONTEXT_MODULOSTEP_MODULOSTEP_ANY = 10;
const SERVERTYPE_LAN = 0;
const SERVERTYPE_UNRANKED = 1;
const SERVERTYPE_RANKED = 2;
const MAXIMUM_PLAYER_COUNT = 16;

struct TGameTypeInfo
{
    var const localized string Typename;
    var string TypeClass;
    var string TypePrefix;
    var string TypeSettings;
    var AdvTypes.EMultiGameMode GameMode;

    structdefaultproperties
    {
        Typename=""
        TypeClass=""
        TypePrefix=""
        TypeSettings=""
        GameMode=EMultiGameMode.EMGM_Deathmatch
    }
};

struct TScoreLimitsPerMode
{
    var name GameClassName;
    var array<int> ScoreLimits;

    structdefaultproperties
    {
        GameClassName="None"
        ScoreLimits=none
    }
};

var transient string DefaultMapName;
var transient string DefaultGameMode;
var transient string DefaultGameModeSettings;
var transient string DefaultMapImage;
var transient string DefaultGameModePrefixes;
var transient UIDataStore_OnlineGameSettings SettingsDataStore;
var transient UTUIDataStore_StringList StringListDataStore;
var GFxObject ButtonsMC;
var GFxObject TitleMC;
var GFxObject AdvancedMC;
var GFxObject GameTypesMC;
var GFxObject MapsMC;
var GFxObject AdvancedBG;
var GFxObject ListMC;
var GFxClikWidget DeathmatchBtn;
var GFxClikWidget TeamDeathmatchBtn;
var GFxClikWidget CTFBtn;
var GFxClikWidget TreasureHuntBtn;
var GFxClikWidget TeamTreasureHuntBtn;
var GFxClikWidget LastManBtn;
var GFxObject TitleTF;
var GFxObject SubtitleTF;
var GFxObject SelectedTF;
var GFxObject Tile0;
var GFxObject Tile1;
var GFxObject Tile2;
var GFxObject Tile3;
var GFxObject Tile4;
var GFxClikWidget NewGameBtn;
var GFxClikWidget ShowAdvancedBtn;
var GFxClikWidget HideAdvancedBtn;
var GFxClikWidget ShowMapsBtn;
var GFxClikWidget HideMapsBtn;
var GFxClikWidget ShowGametypesBtn;
var GFxClikWidget HideGametypesBtn;
var GFxClikWidget BackBtn;
var GFxClikWidget MapMainGfx;
var GFxClikWidget MapList;
var GFxClikWidget MapListScrollbar;
var GFxObject MapListDataProvider;
var GFxClikWidget InternetLANDropdown;
var bool bLANSelected;
var bool bPublicGame;
var transient bool bShowingAdvanced;
var transient bool bShowingMaps;
var transient bool bShowingGametypes;
var bool bTeamDamage;
var bool bTraps;
var bool bKillingSpree;
var bool bOracle;
var bool bRealism;
var transient bool bOnlySurvival;
var GFxClikWidget GameTypeDropdown;
var GFxObject GameTypeDataProvider;
var int LastSelectedGame;
var config array<config TScoreLimitsPerMode> ScoreLimitsPerMode;
var int LastSelectedScorePerModeIndex;
var array<UTUIDataProvider_MapInfo> Maps;
var array<string> DropMapNames;
var string SelectedMapName;
var int SelectedMapIndex;
var GFxClikWidget ServerNameInp;
var GFxClikWidget PasswordInp;
var GFxClikWidget ScoreLimitDropdown;
var GFxClikWidget TimeLimitInp;
var GFxClikWidget MaxPlayersInp;
var GFxClikWidget MapGfx;
var string ServerName;
var string Password;
var int ScoreLimit;
var int TimeLimit;
var int MaxPlayers;
var GFxClikWidget TeamDamageDropdown;
var GFxClikWidget RespawnInp;
var GFxClikWidget TrapsDropdown;
var GFxClikWidget KillingSpreeDropdown;
var GFxClikWidget OracleDropdown;
var GFxClikWidget RealismDropdown;
var GFxClikWidget MaxSpectatorsInp;
var int RespawnTime;
var int MaxSpectators;
var GFxObject MapsTF;
var GFxObject MapDescriptionTF;
var GFxObject GametypesTF;
var GFxObject AdvancedTF;
var GFxObject GameTypeTF;
var GFxObject ServerMapsTF;
var GFxObject LanInternetTF;
var GFxObject ServerNameTF;
var GFxObject PasswordTF;
var GFxObject TimelimitTF;
var GFxObject ScorelimitTF;
var GFxObject SpectatorsTF;
var GFxObject MaxPlayersTF;
var GFxObject TeamDamageTF;
var GFxObject RespawnTF;
var GFxObject TrapsTF;
var GFxObject KillingSpreeTF;
var GFxObject OracleTF;
var GFxObject RealismTF;
var const localized string TitleString;
var const localized string NewGameString;
var const localized string GameTypeString;
var const localized string LanInternetString;
var const localized string PublicGameString;
var const localized string ServerNameString;
var const localized string ServerNameLabelString;
var const localized string ServerPasswordString;
var const localized string TimeLimitString;
var const localized string ScoreLimitString;
var const localized string MaxSpectatorsString;
var const localized string MaxPlayersString;
var const localized string ResTimeString;
var const localized string TeamDamageString;
var const localized string TrapString;
var const localized string KillingSpreeString;
var const localized string OracleString;
var const localized string RealismString;
var const localized string AdvancedOptionsString;
var const localized string HideAdvancedOptionsString;
var const localized string MapsOptionsString;
var const localized string HideMapsOptionsString;
var const localized string GametypesOptionsString;
var const localized string HideGametypesOptionsString;
var const localized string MapListString;
var const localized string ServerMapListString;
var const localized string AdvancedString;
var const localized string GametypesString;
var transient OnlineGameInterface GameInterface;
var transient OnlineLobbyInterfaceSteamworks LobbyInterface;
//var delegate<MapListSort> __MapListSort__Delegate;

function bool Start(optional bool StartPaused = false)
{
    local DataStoreClient DSClient;
    local UIDataStore_Registry Registry;
    local int I;
    local array<string> GenericNoYes;
    local GFxObject OptionListProvider;

    // End:0x3B
    if(int(GetMenuGame().MultiGameModeSelected) == int(3))
    {
        bOnlySurvival = true;
    }
    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    DSClient = Class'Engine.UIInteraction'.static.GetDataStoreClient();
    // End:0x127
    if(DSClient != none)
    {
        SettingsDataStore = UIDataStore_OnlineGameSettings(DSClient.FindDataStore('AdvGameSettings'));
        StringListDataStore = UTUIDataStore_StringList(DSClient.FindDataStore('UTStringList'));
    }
    SettingsDataStore.SetCurrentByName(name(DefaultGameModeSettings));
    Registry.SetData("SelectedGameModePrefix", DefaultGameModePrefixes);
    Registry.SetData("SelectedGameMode", DefaultGameMode);
    Registry.SetData("SelectedMap", DefaultMapName);
    Registry.SetData("SelectedMapImage", DefaultMapImage);
    Registry.SetData("ServerPassword", "");
    super.Start(StartPaused);
    Advance(0.0000000);
    GenericNoYes[0] = Localize("Generic", "No", "ADVGame");
    GenericNoYes[1] = Localize("Generic", "Yes", "ADVGame");
    OptionListProvider = CreateArray();
    I = 0;
    J0x306:

    // End:0x386 [Loop If]
    if(I < GenericNoYes.Length)
    {
        OptionListProvider.SetElementString(I, Class'Engine.UIRoot'.static.SafeCaps(GenericNoYes[I]));
        I++;
        // [Loop Continue]
        goto J0x306;
    }
    bShowingAdvanced = false;
    bShowingGametypes = false;
    bShowingMaps = false;
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x43B
    if(OnlineSub != none)
    {
        GameInterface = OnlineSub.GameInterface;
        LobbyInterface = OnlineSubsystemSteamworks(OnlineSub).LobbyInterface;
    }
    ButtonsMC = MenuMC.GetObject("buttons");
    TitleMC = MenuMC.GetObject("title");
    ListMC = ButtonsMC.GetObject("list");
    TitleTF = TitleMC.GetObject("textField");
    SubtitleTF = TitleMC.GetObject("subtitle");
    SelectedTF = ListMC.GetObject("textField");
    Tile0 = ListMC.GetObject("tile0");
    Tile1 = ListMC.GetObject("tile1");
    Tile2 = ListMC.GetObject("tile2");
    Tile3 = ListMC.GetObject("tile3");
    Tile4 = ListMC.GetObject("tile4");
    AdvancedMC = ButtonsMC.GetObject("Advanced");
    AdvancedBG = AdvancedMC.GetObject("AdvancedBG");
    MapsMC = ButtonsMC.GetObject("mapsMC");
    GameTypesMC = ButtonsMC.GetObject("gametypeMC");
    NewGameBtn = GFxClikWidget(ButtonsMC.GetObject("start_btn", Class'GFxUI.GFxClikWidget'));
    ShowAdvancedBtn = GFxClikWidget(ButtonsMC.GetObject("show_advanced", Class'GFxUI.GFxClikWidget'));
    HideAdvancedBtn = GFxClikWidget(AdvancedMC.GetObject("hide_btn", Class'GFxUI.GFxClikWidget'));
    ShowMapsBtn = GFxClikWidget(ButtonsMC.GetObject("show_maps", Class'GFxUI.GFxClikWidget'));
    HideMapsBtn = GFxClikWidget(MapsMC.GetObject("hidemaps_btn", Class'GFxUI.GFxClikWidget'));
    ShowGametypesBtn = GFxClikWidget(ButtonsMC.GetObject("show_gametype", Class'GFxUI.GFxClikWidget'));
    HideGametypesBtn = GFxClikWidget(GameTypesMC.GetObject("hidegametype_btn", Class'GFxUI.GFxClikWidget'));
    BackBtn = GFxClikWidget(ButtonsMC.GetObject("back_btn", Class'GFxUI.GFxClikWidget'));
    BackBtn.SetString("label", back);
    // End:0xA35
    if(GetPC().WorldInfo.IsConsoleBuild(0) || AdvPlayerController(GetPC()).IsPCGamepadMode())
    {
        BackBtn.SetBool("visible", false);
    }
    DeathmatchBtn = GFxClikWidget(GameTypesMC.GetObject("deathmatch_btn", Class'GFxUI.GFxClikWidget'));
    TeamDeathmatchBtn = GFxClikWidget(GameTypesMC.GetObject("teamdeathmatch_btn", Class'GFxUI.GFxClikWidget'));
    CTFBtn = GFxClikWidget(GameTypesMC.GetObject("capture_btn", Class'GFxUI.GFxClikWidget'));
    TreasureHuntBtn = GFxClikWidget(GameTypesMC.GetObject("treasurehunt_btn", Class'GFxUI.GFxClikWidget'));
    TeamTreasureHuntBtn = GFxClikWidget(GameTypesMC.GetObject("teamtreasurehunt_btn", Class'GFxUI.GFxClikWidget'));
    LastManBtn = GFxClikWidget(GameTypesMC.GetObject("lastman_btn", Class'GFxUI.GFxClikWidget'));
    MapsTF = MapsMC.GetObject("mapsTF");
    GametypesTF = GameTypesMC.GetObject("gametypesTF");
    AdvancedTF = AdvancedMC.GetObject("advancedTF");
    ServerNameTF = ButtonsMC.GetObject("servnameTF");
    LanInternetTF = ButtonsMC.GetObject("internetLANTF");
    TimelimitTF = ButtonsMC.GetObject("timelimitTF");
    ScorelimitTF = ButtonsMC.GetObject("fraglimitTF");
    MaxPlayersTF = ButtonsMC.GetObject("maxplayersTF");
    GameTypeTF = AdvancedMC.GetObject("gametypeTF");
    ServerMapsTF = AdvancedMC.GetObject("maplistTF");
    PasswordTF = AdvancedMC.GetObject("servpaswordTF");
    SpectatorsTF = AdvancedMC.GetObject("maxspectTF");
    RespawnTF = AdvancedMC.GetObject("respawntimeTF");
    TeamDamageTF = AdvancedMC.GetObject("teamdamageTF");
    TrapsTF = AdvancedMC.GetObject("trapsTF");
    KillingSpreeTF = AdvancedMC.GetObject("killingspreeTF");
    OracleTF = AdvancedMC.GetObject("oracleTF");
    RealismTF = AdvancedMC.GetObject("realismTF");
    InternetLANDropdown = GFxClikWidget(ButtonsMC.GetObject("internetLAN", Class'GFxUI.GFxClikWidget'));
    ScoreLimitDropdown = GFxClikWidget(ButtonsMC.GetObject("fraglimit", Class'GFxUI.GFxClikWidget'));
    TimeLimitInp = GFxClikWidget(ButtonsMC.GetObject("timelimit", Class'GFxUI.GFxClikWidget'));
    MaxPlayersInp = GFxClikWidget(ButtonsMC.GetObject("maxplayers", Class'GFxUI.GFxClikWidget'));
    ServerNameInp = GFxClikWidget(AdvancedMC.GetObject("servername", Class'GFxUI.GFxClikWidget'));
    PasswordInp = GFxClikWidget(AdvancedMC.GetObject("password", Class'GFxUI.GFxClikWidget'));
    MaxSpectatorsInp = GFxClikWidget(AdvancedMC.GetObject("maxspectators", Class'GFxUI.GFxClikWidget'));
    TeamDamageDropdown = GFxClikWidget(AdvancedMC.GetObject("teamdamage", Class'GFxUI.GFxClikWidget'));
    RespawnInp = GFxClikWidget(AdvancedMC.GetObject("respawntime", Class'GFxUI.GFxClikWidget'));
    TrapsDropdown = GFxClikWidget(AdvancedMC.GetObject("traps", Class'GFxUI.GFxClikWidget'));
    KillingSpreeDropdown = GFxClikWidget(AdvancedMC.GetObject("killingspree", Class'GFxUI.GFxClikWidget'));
    OracleDropdown = GFxClikWidget(AdvancedMC.GetObject("oracle", Class'GFxUI.GFxClikWidget'));
    RealismDropdown = GFxClikWidget(AdvancedMC.GetObject("realism", Class'GFxUI.GFxClikWidget'));
    GameTypeDropdown = GFxClikWidget(AdvancedMC.GetObject("gametype", Class'GFxUI.GFxClikWidget'));
    MapList = GFxClikWidget(MapsMC.GetObject("list_helper", Class'GFxUI.GFxClikWidget'));
    MapListScrollbar = GFxClikWidget(MapsMC.GetObject("scroll1", Class'GFxUI.GFxClikWidget'));
    MapDescriptionTF = MapsMC.GetObject("mapdescriptionTF");
    MapGfx = GFxClikWidget(MapsMC.GetObject("UILoader", Class'GFxUI.GFxClikWidget'));
    MapMainGfx = GFxClikWidget(ButtonsMC.GetObject("UILoaderMain", Class'GFxUI.GFxClikWidget'));
    InternetLANDropdown.SetObject("dataProvider", OptionListProvider);
    TeamDamageDropdown.SetObject("dataProvider", OptionListProvider);
    TrapsDropdown.SetObject("dataProvider", OptionListProvider);
    KillingSpreeDropdown.SetObject("dataProvider", OptionListProvider);
    OracleDropdown.SetObject("dataProvider", OptionListProvider);
    RealismDropdown.SetObject("dataProvider", OptionListProvider);
    InitDefaultOptions();
    RealismDropdown.SetBool("disabled", true);
    ValidateServerType();
    TitleTF.SetText(TitleString);
    NewGameBtn.SetString("label", NewGameString);
    ShowAdvancedBtn.SetString("label", AdvancedOptionsString);
    HideAdvancedBtn.SetString("label", HideAdvancedOptionsString);
    ShowMapsBtn.SetString("label", MapsOptionsString);
    HideMapsBtn.SetString("label", HideMapsOptionsString);
    ShowGametypesBtn.SetString("label", GametypesOptionsString);
    HideGametypesBtn.SetString("label", HideGametypesOptionsString);
    DeathmatchBtn.SetString("label", Class'AdvUIDataStore_GameResource'.static.GetGameTypeProvider(0).GameName);
    TeamDeathmatchBtn.SetString("label", Class'AdvUIDataStore_GameResource'.static.GetGameTypeProvider(1).GameName);
    CTFBtn.SetString("label", Class'AdvUIDataStore_GameResource'.static.GetGameTypeProvider(2).GameName);
    TreasureHuntBtn.SetString("label", Class'AdvUIDataStore_GameResource'.static.GetGameTypeProvider(4).GameName);
    TeamTreasureHuntBtn.SetString("label", Class'AdvUIDataStore_GameResource'.static.GetGameTypeProvider(6).GameName);
    LastManBtn.SetString("label", Class'AdvUIDataStore_GameResource'.static.GetGameTypeProvider(5).GameName);
    // End:0x1A87
    if(int(GetPC().WorldInfo.NetMode) == int(NM_Client))
    {
        MapList.SetVisible(false);
    }
    // End:0x1B9C
    if(GetPC().WorldInfo.IsConsoleBuild(0))
    {
        InternetLANDropdown.SetBool("visible", false);
        LanInternetTF.SetText(" ");
        PasswordInp.SetBool("visible", false);
        PasswordTF.SetText(" ");
        SpectatorsTF.SetText(" ");
        MaxSpectatorsInp.SetVisible(false);
    }
    // End:0x1BD2
    if(bOnlySurvival)
    {
        ShowGametypesBtn.SetBool("visible", false);
    }
    // End:0x1C28
    if(int(GetMenuGame().MultiGameModeSelected) != int(7))
    {
        SetGameType(GetMenuGame().MultiGameModeSelected);        
    }
    else
    {
        SetGameType(0);
    }
    ShowAdvanced(false);
    ShowMaps(false);
    ShowGametypes(false);
    NewGameBtn.SetBool("focused", true);
    Frontend.GetPartyGame().RefreshPartySettings();
    return true;
    //return ReturnValue;    
}

function UpdateFooter()
{
    local array<name> ButtonAliases;

    ButtonAliases.AddItem('GenericSelect');    
    ButtonAliases.AddItem('GenericBack');    
    // End:0x7C
    if(GetPC().WorldInfo.IsConsoleBuild(0))
    {
        ButtonAliases.AddItem('PartyDetails');        
    }
    Frontend.footer.FooterUpdate(ButtonAliases);
    //return;    
}

function InitDefaultOptions()
{
    local int Id;
    local AdvGameSettingsCommon GameSettings;

    GameSettings = AdvGameSettingsCommon(SettingsDataStore.GetCurrentGameSettings());
    InternetLANDropdown.SetFloat("selectedIndex", float(((bLANSelected) ? 1 : 0)));
    // End:0xD8
    if(GameSettings.GetPropertyId('TimeLimit', Id))
    {
        GameSettings.GetIntProperty(Id, TimeLimit);
    }
    LoadProfileData();
    ScoreLimitDropdown.SetFloat("selectedIndex", 0.0000000);
    TimeLimitInp.SetInt("value", TimeLimit);
    MaxPlayersInp.SetInt("value", MaxPlayers);
    MaxSpectatorsInp.SetInt("value", MaxSpectators);
    RespawnInp.SetInt("value", RespawnTime);
    TeamDamageDropdown.SetFloat("selectedIndex", float(((bTeamDamage) ? 1 : 0)));
    TrapsDropdown.SetFloat("selectedIndex", float(((bTraps) ? 1 : 0)));
    KillingSpreeDropdown.SetFloat("selectedIndex", float(((bKillingSpree) ? 1 : 0)));
    OracleDropdown.SetFloat("selectedIndex", float(((bOracle) ? 1 : 0)));
    RealismDropdown.SetFloat("selectedIndex", float(((bRealism) ? 1 : 0)));
    //return;    
}

function LoadProfileData()
{
    // End:0x288
    if((AdvPlayerController(GetPC()) != none) && AdvPlayerController(GetPC()).CanReadProfileMP())
    {
        ServerName = AdvPlayerController(GetPC()).GetStringValueMP(75);
        TimeLimit = AdvPlayerController(GetPC()).GetIntValueMP(70);
        MaxPlayers = AdvPlayerController(GetPC()).GetIntValueMP(71);
        MaxSpectators = AdvPlayerController(GetPC()).GetIntValueMP(72);
        RespawnTime = AdvPlayerController(GetPC()).GetIntValueMP(73);
        bPublicGame = AdvPlayerController(GetPC()).GetPublicGameMP();
        bTeamDamage = AdvPlayerController(GetPC()).GetTeamDamageMP();
        bTraps = AdvPlayerController(GetPC()).GetTrapsMP();
        bKillingSpree = AdvPlayerController(GetPC()).GetKillingSpreeMP();
        bOracle = AdvPlayerController(GetPC()).GetOracleMP();
        bRealism = AdvPlayerController(GetPC()).GetRealismMP();
    }
    //return;    
}

function SaveProfileData()
{
    AdvPlayerController(GetPC()).SetStringValueMP(75, ServerName);
    AdvPlayerController(GetPC()).SetIntValueMP(70, TimeLimit);
    AdvPlayerController(GetPC()).SetIntValueMP(71, MaxPlayers);
    AdvPlayerController(GetPC()).SetIntValueMP(72, MaxSpectators);
    AdvPlayerController(GetPC()).SetIntValueMP(73, RespawnTime);
    AdvPlayerController(GetPC()).SetFlagsMP(bPublicGame, bTeamDamage, bTraps, bKillingSpree, bOracle, bRealism);
    //return;    
}

function ValidateServerType()
{
    local int PlayerIndex, ValueIndex, PlayerControllerId;
    local name MatchTypeName;

    MatchTypeName = ((Class'Engine.WorldInfo'.static.IsConsoleBuild(1)) ? 'ServerType360' : 'ServerType');
    PlayerIndex = Class'Engine.UIInteraction'.static.GetPlayerIndex(GetLP().ControllerId);
    PlayerControllerId = Class'Engine.UIInteraction'.static.GetPlayerControllerId(PlayerIndex);
    // End:0x154
    if(!Class'Engine.UIInteraction'.static.IsLoggedIn(PlayerControllerId, true))
    {
        ValueIndex = StringListDataStore.GetCurrentValueIndex(MatchTypeName);
        // End:0x154
        if(ValueIndex != 0)
        {
            StringListDataStore.SetCurrentValueIndex(MatchTypeName, 0);
        }
    }
    //return;    
}

function SetupGameSettings()
{
    local int ValueIndex, propId;
    local AdvGameSettingsCommon GameSettings;
    local string SelectedMap, SelectedGameMode;
    local UIDataStore_Registry Registry;

    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    GameSettings = AdvGameSettingsCommon(SettingsDataStore.GetCurrentGameSettings());
    // End:0xC7
    if(Class'Engine.WorldInfo'.static.IsConsoleBuild(1))
    {
        ValueIndex = StringListDataStore.GetCurrentValueIndex('ServerType360');        
    }
    else
    {
        ValueIndex = StringListDataStore.GetCurrentValueIndex('ServerType');
    }
    ValueIndex = ((bLANSelected) ? 0 : 1);
    switch(ValueIndex)
    {
        // End:0x170
        case 0:
            GameSettings.bIsLanMatch = true;
            GameSettings.bUsesArbitration = false;
            // End:0x226
            break;
        // End:0x1B9
        case 1:
            GameSettings.bIsLanMatch = false;
            GameSettings.bUsesArbitration = false;
            // End:0x226
            break;
        // End:0x223
        case 2:
            GameSettings.bIsLanMatch = false;
            GameSettings.bUsesArbitration = true;
            GameSettings.NumPrivateConnections = 0;
            // End:0x226
            break;
        // End:0xFFFF
        default:
            break;
    }
    GameSettings.MaxPlayers = MaxPlayers;
    GameSettings.NumPrivateConnections = 0;
    GameSettings.NumPublicConnections = MaxPlayers;
    GameSettings.NumOpenPublicConnections = GameSettings.NumPublicConnections - 1;
    GameSettings.NumOpenPrivateConnections = GameSettings.NumPrivateConnections;
    Registry.GetData("SelectedMap", SelectedMap);
    Registry.GetData("SelectedGameMode", SelectedGameMode);
    GameSettings.SetPropertyFromStringByName('CustomMapName', SelectedMap);
    GameSettings.SetPropertyFromStringByName('CustomGameMode', SelectedGameMode);
    Registry.GetData("ServerMOTD", Class'EvilGame.EvilGameReplicationInfo'.default.MessageOfTheDay);
    GameSettings.bShouldAdvertise = true;
    // End:0x4B3
    if(GameSettings.GetPropertyId('GoalScore', propId))
    {
        GameSettings.SetIntProperty(propId, ScoreLimit);
    }
    // End:0x518
    if(GameSettings.GetPropertyId('TimeLimit', propId))
    {
        GameSettings.SetIntProperty(propId, TimeLimit);
    }
    SaveProfileData();
    //return;    
}

function OnGameCreated(name SessionName, bool bWasSuccessful)
{
    local OnlineGameSettings LocalGameSettings;
    local string TravelURL, OutStringValue, GameClass;
    local UIDataStore_Registry Registry;
    local byte PlatformInfo[80];

    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    // End:0xB28
    if(OnlineSub != none)
    {
        // End:0xB25
        if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
        {
            GameInterface.ClearCreateOnlineGameCompleteDelegate(OnGameCreated);
            // End:0xB22
            if(GameInterface.ReadPlatformSpecificSessionInfoBySessionName('Game', PlatformInfo) || true)
            {
                LocalGameSettings = SettingsDataStore.GetCurrentGameSettings();
                LocalGameSettings.bIsDedicated = StringListDataStore.GetCurrentValueIndex('DedicatedServer') == 1;
                LocalGameSettings.BuildURL(TravelURL);
                // End:0x217
                if(Registry.GetData("ServerPassword", OutStringValue) && Len(OutStringValue) > 0)
                {                    
                    TravelURL $= ("?GamePassword=" $ OutStringValue);
                    LocalGameSettings.SetStringSettingValue(37, 1, false);                    
                }
                else
                {
                    LocalGameSettings.SetStringSettingValue(37, 0, false);
                }
                Registry.GetData("SelectedGameMode", OutStringValue);                
                TravelURL $= ("?game=" $ OutStringValue);
                GameClass = Right(OutStringValue, Len(OutStringValue) - 15);                
                TravelURL $= ("?TeamDamage=" $ string(bTeamDamage));                
                TravelURL $= ("?RespawnTime=" $ string(RespawnTime));                
                TravelURL $= ("?Traps=" $ string(bTraps));                
                TravelURL $= ("?KillingSpree=" $ string(bKillingSpree));                
                TravelURL $= ("?Oracle=" $ string(bOracle));                
                TravelURL $= ("?Realism=" $ string(bRealism));
                Registry.GetData("SelectedMap", OutStringValue);
                Frontend.GetPartyGame().RegisterPartyMembers();
                Frontend.GetPartyGame().BuildCurrentPlayerList();
                switch(GameClass)
                {
                    // End:0x54C
                    case "AdvGameDeathmatch":
                        Frontend.GetPartyGame().SetCurrentMatchMode(0);
                        LocalGameSettings.SetIntProperty(268435457, 11);
                        LocalGameSettings.SetStringSettingValue(0, 0);
                        LocalGameSettings.SetStringSettingValue(32779, 1);
                        // End:0x9D0
                        break;
                    // End:0x60E
                    case "AdvGameTeamDeathmatch":
                        Frontend.GetPartyGame().SetCurrentMatchMode(1);
                        LocalGameSettings.SetIntProperty(268435457, 12);
                        LocalGameSettings.SetStringSettingValue(0, 1);
                        LocalGameSettings.SetStringSettingValue(32779, 1);
                        // End:0x9D0
                        break;
                    // End:0x6C6
                    case "AdvGameCTF":
                        Frontend.GetPartyGame().SetCurrentMatchMode(2);
                        LocalGameSettings.SetIntProperty(268435457, 13);
                        LocalGameSettings.SetStringSettingValue(0, 2);
                        LocalGameSettings.SetStringSettingValue(32779, 1);
                        // End:0x9D0
                        break;
                    // End:0x787
                    case "AdvGameTreasureHunt":
                        Frontend.GetPartyGame().SetCurrentMatchMode(4);
                        LocalGameSettings.SetIntProperty(268435457, 14);
                        LocalGameSettings.SetStringSettingValue(0, 4);
                        LocalGameSettings.SetStringSettingValue(32779, 1);
                        // End:0x9D0
                        break;
                    // End:0x84C
                    case "AdvGameTeamTreasureHunt":
                        Frontend.GetPartyGame().SetCurrentMatchMode(6);
                        LocalGameSettings.SetIntProperty(268435457, 15);
                        LocalGameSettings.SetStringSettingValue(0, 5);
                        LocalGameSettings.SetStringSettingValue(32779, 1);
                        // End:0x9D0
                        break;
                    // End:0x910
                    case "AdvGameLastMenStanding":
                        Frontend.GetPartyGame().SetCurrentMatchMode(5);
                        LocalGameSettings.SetIntProperty(268435457, 16);
                        LocalGameSettings.SetStringSettingValue(0, 3);
                        LocalGameSettings.SetStringSettingValue(32779, 1);
                        // End:0x9D0
                        break;
                    // End:0x9CD
                    case "AdvGameSurvival":
                        Frontend.GetPartyGame().SetCurrentMatchMode(3);
                        LocalGameSettings.SetIntProperty(268435457, 17);
                        LocalGameSettings.SetStringSettingValue(0, 3);
                        LocalGameSettings.SetStringSettingValue(32779, 1);
                        // End:0x9D0
                        break;
                    // End:0xFFFF
                    default:
                        break;
                }
                // End:0xA2C
                if(!bLANSelected)
                {                    
                    TravelURL $= "?steamsockets";
                    AdvPlayerController(GetPC()).SetupSteamLobby();
                }
                TravelURL = (("" $ SelectedMapName) $ TravelURL) $ "?listen";
                Frontend.GetPartyGame().bIsTraveling = true;
                Class'Engine.WorldInfo'.static.GetWorldInfo().ServerTravel(Class'AdvPreGameLobbyGame_Base'.static.GetTravelToPreGameLobbyUrl(), true, false);
                Frontend.GetPartyGame().bHasCreateOutstanding = false;
                return;                
            }            
        }        
    }
    // End:0xB97
    if(!bWasSuccessful)
    {
        GetAdvPC().RestartFrontEnd();
        GetAdvPC().ClientStopLevelLoadingMovie();
        GetAdvPC().ShowOSSConnectionLostMessage();
    }
    //return;    
}

function UpdateGameTypeDropdownDataProvider()
{
    local UIDataStore_Registry Registry;

    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    Registry.SetData("SelectedGameModePrefix", Class'AdvUIDataStore_GameResource'.static.GetGameTypeProviderUsingProviderIndex(0).MapPrefix);
    Registry.SetData("SelectedGameMode", Class'AdvUIDataStore_GameResource'.static.GetGameTypeProviderUsingProviderIndex(0).ClassName);
    //return;    
}

function UpdateListDataProvider()
{
    local int I, ListCounter;
    local GFxObject DataProvider, TempObj;
    local array<UDKUIResourceDataProvider> ProviderList;
    local array<UTUIDataProvider_MapInfo> LocalMapList;
    local string FriendlyName;
    local bool bFriendlyFound;
    local UIDataStore_Registry Registry;

    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    Maps.Length = 0;
    LocalMapList.Length = 0;
    Class'EvilGame.UTUIDataStore_MenuItems'.static.GetAllResourceDataProviders(Class'EvilGame.UTUIDataProvider_MapInfo', ProviderList);
    I = 0;
    J0x90:

    // End:0x12A [Loop If]
    if(I < ProviderList.Length)
    {
        // End:0xF3
        if(DropMapNames.Find(UTUIDataProvider_MapInfo(ProviderList[I]).MapName) != )
        {                        
        }
        else
        {
            LocalMapList.AddItem(UTUIDataProvider_MapInfo(ProviderList[I]));            
        }
        I++;
        // [Loop Continue]
        goto J0x90;
    }
    // End:0x13C
    if(LocalMapList.Length == 0)
    {
        return;
    }
    LocalMapList.Sort(MapListSort);    
    ListCounter = 0;
    DataProvider = CreateArray();
    I = 0;
    J0x184:

    // End:0x419 [Loop If]
    if(I < LocalMapList.Length)
    {
        // End:0x40B
        if(!LocalMapList[I].ShouldBeFiltered())
        {
            Maps.AddItem(LocalMapList[I]);            
            bFriendlyFound = GetMapFriendlyName(LocalMapList[I].MapName, FriendlyName);
            // End:0x262
            if(!bFriendlyFound)
            {
                Maps.RemoveItem(LocalMapList[I]);                                
            }
            else
            {
                TempObj = CreateObject("Object");
                TempObj.SetString("label", Caps(FriendlyName));
                TempObj.SetString("players", LocalMapList[I].NumPlayers);
                // End:0x38E
                if(LocalMapList[I].PreviewImageMarkup != "")
                {
                    TempObj.SetString("image", "img://" $ LocalMapList[I].PreviewImageMarkup);                    
                }
                else
                {
                    TempObj.SetString("image", "img://" $ "UDKFrontEnd.gm_map_none");
                }
                DataProvider.SetElementObject(ListCounter++, TempObj);
            }
        }
        I++;
        // [Loop Continue]
        goto J0x184;
    }
    MapList.SetObject("dataProvider", DataProvider);
    MapListDataProvider = MapList.GetObject("dataProvider");
    MapList.SetFloat("selectedIndex", 0.0000000);
    SelectedMapIndex = 0;
    SelectedMapName = Maps[0].MapName;
    Registry.SetData("SelectedMap", Maps[0].MapName);
    MapMainGfx.SetString("source", GetMapTextureURL(0));
    //return;    
}

delegate int MapListSort(UTUIDataProvider_MapInfo A, UTUIDataProvider_MapInfo B)
{
    return ((A.MapName > B.MapName) ? -1 : 0);
    //return ReturnValue;    
}

function OnInternetLANSelect(EventData ev)
{
    local name MatchTypeName;
    local DataStoreClient DSClient;

    bLANSelected = bool(InternetLANDropdown.GetFloat("selectedIndex"));
    MatchTypeName = ((Class'Engine.WorldInfo'.static.IsConsoleBuild(1)) ? 'ServerType360' : 'ServerType');
    DSClient = Class'Engine.UIInteraction'.static.GetDataStoreClient();
    StringListDataStore = UTUIDataStore_StringList(DSClient.FindDataStore('UTStringList'));
    StringListDataStore.SetCurrentValueIndex(MatchTypeName, ((bLANSelected) ? 0 : 1));
    //return;    
}

function SetGameType(AdvTypes.EMultiGameMode eMultiMode)
{
    local int Id, I, J;
    local GFxObject OptionListProvider;
    local AdvGameSettingsCommon GameSettings;
    local UIDataStore_Registry Registry;
    local AdvGameInfoSummary GameSummaryInfo;

    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    GameSummaryInfo = Class'AdvUIDataStore_GameResource'.static.GetGameTypeProvider(eMultiMode);
    SettingsDataStore.SetCurrentByName(name(GameSummaryInfo.SettingsName));
    Registry.SetData("SelectedGameModePrefix", GameSummaryInfo.MapPrefix);
    Registry.SetData("SelectedGameMode", GameSummaryInfo.ClassName);
    UpdateListDataProvider();
    GameSettings = AdvGameSettingsCommon(SettingsDataStore.GetCurrentGameSettings());
    OptionListProvider = CreateArray();
    I = 0;
    J0x1AC:

    // End:0x2DB [Loop If]
    if(I < ScoreLimitsPerMode.Length)
    {
        // End:0x2CD
        if(ScoreLimitsPerMode[I].GameClassName == name(GameSummaryInfo.ClassName))
        {
            LastSelectedScorePerModeIndex = I;
            J = 0;
            J0x22D:

            // End:0x2CA [Loop If]
            if(J < ScoreLimitsPerMode[I].ScoreLimits.Length)
            {
                OptionListProvider.SetElementString(J, string(ScoreLimitsPerMode[I].ScoreLimits[J]));
                J++;
                // [Loop Continue]
                goto J0x22D;
            }
            // [Explicit Break]
            goto J0x2DB;
        }
        I++;
        // [Loop Continue]
        goto J0x1AC;
    }
    J0x2DB:

    ScoreLimitDropdown.SetObject("dataProvider", OptionListProvider);
    ScoreLimitDropdown.SetFloat("selectedIndex", 0.0000000);
    // End:0x3A9
    if(GameSettings.GetPropertyId('TimeLimit', Id))
    {
        GameSettings.GetIntProperty(Id, TimeLimit);
    }
    TimeLimitInp.SetInt("value", TimeLimit);
    MaxPlayersInp.SetInt("maximum", GameSettings.MaxPlayers);
    MaxPlayersInp.SetInt("value", GameSettings.MaxPlayers);
    MaxSpectatorsInp.SetInt("value", MaxSpectators);
    GetMenuGame().MultiGameModeSelected = eMultiMode;
    SubtitleTF.SetText(GameSummaryInfo.GameName);
    //return;    
}

function OnGameTypeDropdownChange(EventData ev)
{
    local int SelectedIndex, Id, I, J;
    local GFxObject OptionListProvider;
    local AdvGameSettingsCommon GameSettings;
    local UIDataStore_Registry Registry;
    local AdvGameInfoSummary GameSummaryInfo;

    SelectedIndex = int(GameTypeDropdown.GetFloat("selectedIndex"));
    GameSummaryInfo = Class'AdvUIDataStore_GameResource'.static.GetGameTypeProvider(0);
    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    SettingsDataStore.SetCurrentByName(name(GameSummaryInfo.SettingsName));
    Registry.SetData("SelectedGameModePrefix", GameSummaryInfo.MapPrefix);
    Registry.SetData("SelectedGameMode", GameSummaryInfo.ClassName);
    UpdateListDataProvider();
    GameSettings = AdvGameSettingsCommon(SettingsDataStore.GetCurrentGameSettings());
    OptionListProvider = CreateArray();
    I = 0;
    J0x1DF:

    // End:0x30E [Loop If]
    if(I < ScoreLimitsPerMode.Length)
    {
        // End:0x300
        if(ScoreLimitsPerMode[I].GameClassName == name(GameSummaryInfo.ClassName))
        {
            LastSelectedScorePerModeIndex = I;
            J = 0;
            J0x260:

            // End:0x2FD [Loop If]
            if(J < ScoreLimitsPerMode[I].ScoreLimits.Length)
            {
                OptionListProvider.SetElementString(J, string(ScoreLimitsPerMode[I].ScoreLimits[J]));
                J++;
                // [Loop Continue]
                goto J0x260;
            }
            // [Explicit Break]
            goto J0x30E;
        }
        I++;
        // [Loop Continue]
        goto J0x1DF;
    }
    J0x30E:

    ScoreLimitDropdown.SetObject("dataProvider", OptionListProvider);
    ScoreLimitDropdown.SetFloat("selectedIndex", 0.0000000);
    // End:0x3DC
    if(GameSettings.GetPropertyId('TimeLimit', Id))
    {
        GameSettings.GetIntProperty(Id, TimeLimit);
    }
    TimeLimitInp.SetInt("value", TimeLimit);
    MaxPlayersInp.SetInt("maximum", GameSettings.MaxPlayers);
    MaxPlayersInp.SetInt("value", GameSettings.MaxPlayers);
    MaxSpectatorsInp.SetInt("value", MaxSpectators);
    LastSelectedGame = SelectedIndex;
    //return;    
}

function OnListSelect(int Index)
{
    local EventData ev;
    local UIDataStore_Registry Registry;

    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    // End:0x56
    if(Index >= Maps.Length)
    {
        return;
    }
    SelectedMapName = Maps[Index].MapName;
    SelectedMapIndex = Index;
    Registry.SetData("SelectedMap", SelectedMapName);
    MapMainGfx.SetString("source", GetMapTextureURL(SelectedMapIndex));
    OnBack(ev);
    //return;    
}

function OnListChange(int Index)
{
    OnListOver(Index);
    //return;    
}

function OnListOver(int Index)
{
    // End:0x2B
    if(!bShowingMaps || Index >= Maps.Length)
    {
        return;
    }
    MapDescriptionTF.SetText(Maps[Index].Description);
    MapGfx.SetString("source", GetMapTextureURL(Index));
    //return;    
}

function OnServerNameChanged(EventData ev)
{
    ServerName = ServerNameInp.GetString("text");
    //return;    
}

function OnPasswordChanged(EventData ev)
{
    local UIDataStore_Registry Registry;

    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    Password = PasswordInp.GetString("text");
    Registry.SetData("ServerPassword", Password);
    //return;    
}

function OnFragLimitChanged(EventData ev)
{
    ScoreLimit = ScoreLimitsPerMode[LastSelectedScorePerModeIndex].ScoreLimits[int(ScoreLimitDropdown.GetFloat("selectedIndex"))];
    //return;    
}

function OnTimeLimitChanged(EventData ev)
{
    TimeLimit = TimeLimitInp.GetInt("value");
    //return;    
}

function OnMaxPlayersChanged(EventData ev)
{
    MaxPlayers = MaxPlayersInp.GetInt("value");
    //return;    
}

function OnMaxSpectatorsChanged(EventData ev)
{
    MaxSpectators = MaxSpectatorsInp.GetInt("value");
    //return;    
}

function OnTeamDamageChanged(EventData ev)
{
    bTeamDamage = bool(TeamDamageDropdown.GetFloat("selectedIndex"));
    //return;    
}

function OnTrapsChanged(EventData ev)
{
    bTraps = bool(TrapsDropdown.GetFloat("selectedIndex"));
    //return;    
}

function OnKillingSpreeChanged(EventData ev)
{
    bKillingSpree = bool(KillingSpreeDropdown.GetFloat("selectedIndex"));
    //return;    
}

function OnOracleChanged(EventData ev)
{
    bOracle = bool(OracleDropdown.GetFloat("selectedIndex"));
    //return;    
}

function OnRealismChanged(EventData ev)
{
    bRealism = bool(RealismDropdown.GetFloat("selectedIndex"));
    //return;    
}

function OnRespawnLimitChanged(EventData ev)
{
    RespawnTime = RespawnInp.GetInt("value");
    //return;    
}

function OnBack(EventData ev)
{
    // End:0x1A
    if(bShowingAdvanced)
    {
        ShowAdvanced(false);
        return;
    }
    // End:0x34
    if(bShowingGametypes)
    {
        ShowGametypes(false);
        return;
    }
    // End:0x4E
    if(bShowingMaps)
    {
        ShowMaps(false);
        return;
    }
    OnLeaveParty();
    //return;    
}

function OnLeaveParty()
{
    local AdvUIManager UIManager;
    local array<name> ButtonAliases;
    local bool bHasParty, bIsLeader;

    bHasParty = AdvPlayerController(GetPC()).HasParty();
    bIsLeader = GetPC().IsPartyLeader();
    // End:0x1B2
    if(bIsLeader && bHasParty)
    {
        ButtonAliases.AddItem('AcceptLeave');        
        ButtonAliases.AddItem('CancelStay');        
        UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
        UIManager.ShowUIMessage('ConfirmQuit', "<Strings:ADVGame.MessageBoxStrings.LeavePregameLobby_Title>", "<Strings:ADVGame.MessageBoxStrings.LeavePregameLobby_MemberMessage>", ButtonAliases, OnLeaveParty_Confirmed, GetLP());        
    }
    else
    {
        Action = "back";
        PlayCloseAnimation();
    }
    //return;    
}

function bool OnLeaveParty_Confirmed(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    // End:0xB1
    if(SelectedInputAlias == 'AcceptLeave')
    {
        Frontend.GetPartyGame().DestroyParty();
        AdvPlayerController(GetPC()).DisbandParty();
        Frontend.bStartPartySession = true;
        Action = "back";
        PlayCloseAnimation();
    }
    return true;
    //return ReturnValue;    
}

function OnShowAdvancedOptions(EventData ev)
{
    // End:0x1A
    if(!bShowingAdvanced)
    {
        ShowAdvanced(true);
    }
    //return;    
}

function OnShowMaps(EventData ev)
{
    // End:0x1A
    if(!bShowingMaps)
    {
        ShowMaps(true);
    }
    //return;    
}

function OnShowGameType(EventData ev)
{
    // End:0x1A
    if(!bShowingGametypes)
    {
        ShowGametypes(true);
    }
    //return;    
}

function OnHideMaps(EventData ev)
{
    // End:0x18
    if(bShowingMaps)
    {
        ShowMaps(false);
    }
    //return;    
}

function OnHidegametypeBtn(EventData ev)
{
    // End:0x18
    if(bShowingGametypes)
    {
        ShowGametypes(false);
    }
    //return;    
}

function OnDeathBtn(EventData ev)
{
    // End:0x36
    if(int(GetMenuGame().MultiGameModeSelected) != int(0))
    {
        SetGameType(0);
    }
    OnBack(ev);
    //return;    
}

function OnTeamDeathBtn(EventData ev)
{
    // End:0x36
    if(int(GetMenuGame().MultiGameModeSelected) != int(1))
    {
        SetGameType(1);
    }
    OnBack(ev);
    //return;    
}

function OnCaptureBtn(EventData ev)
{
    // End:0x36
    if(int(GetMenuGame().MultiGameModeSelected) != int(2))
    {
        SetGameType(2);
    }
    OnBack(ev);
    //return;    
}

function OnTreasureBtn(EventData ev)
{
    // End:0x36
    if(int(GetMenuGame().MultiGameModeSelected) != int(4))
    {
        SetGameType(4);
    }
    OnBack(ev);
    //return;    
}

function OnTeamTreasureBtn(EventData ev)
{
    // End:0x36
    if(int(GetMenuGame().MultiGameModeSelected) != int(6))
    {
        SetGameType(6);
    }
    OnBack(ev);
    //return;    
}

function OnLastManBtn(EventData ev)
{
    // End:0x36
    if(int(GetMenuGame().MultiGameModeSelected) != int(5))
    {
        SetGameType(5);
    }
    OnBack(ev);
    //return;    
}

function OnNewGameBtn(EventData ev)
{
    // End:0x33
    if(SelectedMapIndex != -1)
    {
        Action = "newgame";
        PlayCloseAnimation();        
    }
    else
    {
        ShowNoMapWarning();
    }
    //return;    
}

function ShowNoMapWarning()
{
    local AdvUIManager UIManager;
    local array<name> ButtonAliases;

    UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0x12F
    if(UIManager != none)
    {
        ButtonAliases.AddItem('GenericAccept');        
        UIManager.ShowUIMessage('ConnectionError', Localize("MessageBoxErrorStrings", "CannotStartMatch_Title", "ADVGame"), Localize("MessageBoxErrorStrings", "CannotStartMatch_NoMapMessage", "ADVGame"), ButtonAliases, None,,,,, false, false);
    }
    //return;    
}

function ShowAdvanced(bool bShow)
{
    bShowingAdvanced = bShow;
    // End:0x5C9
    if(bShow)
    {
        ShowAdvancedBtn.SetBool("focused", false);
        ShowAdvancedBtn.SetBool("disabled", true);
        ShowMapsBtn.SetBool("disabled", true);
        ShowGametypesBtn.SetBool("disabled", true);
        NewGameBtn.SetBool("disabled", true);
        BackBtn.SetBool("disabled", true);
        InternetLANDropdown.SetBool("visible", false);
        ScoreLimitDropdown.SetBool("visible", false);
        TimeLimitInp.SetBool("visible", false);
        MaxPlayersInp.SetBool("visible", false);
        LanInternetTF.SetText(" ");
        TimelimitTF.SetText(" ");
        ScorelimitTF.SetText(" ");
        MaxPlayersTF.SetText(" ");
        // End:0x285
        if(!bOnlySurvival)
        {
            RespawnInp.SetBool("visible", true);
        }
        TeamDamageDropdown.SetBool("visible", true);
        TrapsDropdown.SetBool("visible", true);
        KillingSpreeDropdown.SetBool("visible", true);
        OracleDropdown.SetBool("visible", true);
        RealismDropdown.SetBool("visible", true);
        AdvancedTF.SetText(AdvancedString);
        TeamDamageTF.SetText(TeamDamageString);
        TrapsTF.SetText(TrapString);
        KillingSpreeTF.SetText(KillingSpreeString);
        OracleTF.SetText(OracleString);
        RealismTF.SetText(RealismString);
        // End:0x480
        if(!bOnlySurvival)
        {
            RespawnTF.SetText(ResTimeString);
        }
        // End:0x576
        if(!GetPC().WorldInfo.IsConsoleBuild(0) && !AdvPlayerController(GetPC()).IsPCGamepadMode())
        {
            // End:0x54D
            if(!bOnlySurvival)
            {
                SpectatorsTF.SetText(MaxSpectatorsString);
                MaxSpectatorsInp.SetBool("visible", true);
            }
            HideAdvancedBtn.SetBool("visible", true);
        }
        TrapsDropdown.SetBool("focused", true);
        AdvancedBG.GotoAndPlay("fadein");        
    }
    else
    {
        ShowAdvancedBtn.SetBool("disabled", false);
        ShowMapsBtn.SetBool("disabled", false);
        ShowGametypesBtn.SetBool("disabled", false);
        NewGameBtn.SetBool("disabled", false);
        BackBtn.SetBool("disabled", false);
        MaxSpectatorsInp.SetBool("visible", false);
        TeamDamageDropdown.SetBool("visible", false);
        RespawnInp.SetBool("visible", false);
        TrapsDropdown.SetBool("visible", false);
        KillingSpreeDropdown.SetBool("visible", false);
        OracleDropdown.SetBool("visible", false);
        RealismDropdown.SetBool("visible", false);
        AdvancedTF.SetText(" ");
        TeamDamageTF.SetText(" ");
        RespawnTF.SetText(" ");
        TrapsTF.SetText(" ");
        KillingSpreeTF.SetText(" ");
        OracleTF.SetText(" ");
        RealismTF.SetText(" ");
        SpectatorsTF.SetText(" ");
        HideAdvancedBtn.SetBool("visible", false);
        // End:0xA00
        if(!bOnlySurvival)
        {
            ScoreLimitDropdown.SetBool("visible", true);
            TimeLimitInp.SetBool("visible", true);
            MaxPlayersInp.SetBool("visible", true);
            TimelimitTF.SetText(TimeLimitString);
            ScorelimitTF.SetText(ScoreLimitString);
            MaxPlayersTF.SetText(MaxPlayersString);
        }
        // End:0xA8E
        if(!GetPC().WorldInfo.IsConsoleBuild(0))
        {
            LanInternetTF.SetText(LanInternetString);
            InternetLANDropdown.SetBool("visible", true);
        }
        ShowAdvancedBtn.SetBool("focused", true);
        AdvancedBG.GotoAndPlay("fadeout");
    }
    // End:0xB0D
    if(Frontend.footer != none)
    {
        UpdateFooter();
    }
    //return;    
}

function ShowMaps(bool bShow)
{
    bShowingMaps = bShow;
    // End:0x414
    if(bShow)
    {
        ShowMapsBtn.SetBool("focused", false);
        ShowAdvancedBtn.SetBool("disabled", true);
        ShowMapsBtn.SetBool("disabled", true);
        ShowGametypesBtn.SetBool("disabled", true);
        NewGameBtn.SetBool("disabled", true);
        BackBtn.SetBool("disabled", true);
        InternetLANDropdown.SetBool("visible", false);
        ScoreLimitDropdown.SetBool("visible", false);
        TimeLimitInp.SetBool("visible", false);
        MaxPlayersInp.SetBool("visible", false);
        LanInternetTF.SetText(" ");
        TimelimitTF.SetText(" ");
        ScorelimitTF.SetText(" ");
        MaxPlayersTF.SetText(" ");
        MapGfx.SetBool("visible", true);
        MapList.SetBool("visible", true);
        MapListScrollbar.SetBool("visible", true);
        MapGfx.SetString("source", GetMapTextureURL(int(MapList.GetFloat("selectedIndex"))));
        MapsTF.SetText(MapListString);
        // End:0x3E8
        if(!GetPC().WorldInfo.IsConsoleBuild(0) && !AdvPlayerController(GetPC()).IsPCGamepadMode())
        {
            HideMapsBtn.SetBool("visible", true);
        }
        MapList.SetBool("focused", true);        
    }
    else
    {
        ShowAdvancedBtn.SetBool("disabled", false);
        ShowMapsBtn.SetBool("disabled", false);
        ShowGametypesBtn.SetBool("disabled", false);
        NewGameBtn.SetBool("disabled", false);
        BackBtn.SetBool("disabled", false);
        MapList.SetBool("visible", false);
        MapListScrollbar.SetBool("visible", false);
        MapGfx.SetBool("visible", false);
        MapsTF.SetText(" ");
        MapDescriptionTF.SetText(" ");
        HideMapsBtn.SetBool("visible", false);
        // End:0x6D5
        if(!bOnlySurvival)
        {
            ScoreLimitDropdown.SetBool("visible", true);
            TimeLimitInp.SetBool("visible", true);
            MaxPlayersInp.SetBool("visible", true);
            TimelimitTF.SetText(TimeLimitString);
            ScorelimitTF.SetText(ScoreLimitString);
            MaxPlayersTF.SetText(MaxPlayersString);
        }
        // End:0x763
        if(!GetPC().WorldInfo.IsConsoleBuild(0))
        {
            LanInternetTF.SetText(LanInternetString);
            InternetLANDropdown.SetBool("visible", true);
        }
        ShowMapsBtn.SetBool("focused", true);
    }
    // End:0x7BA
    if(Frontend.footer != none)
    {
        UpdateFooter();
    }
    //return;    
}

function ShowGametypes(bool bShow)
{
    bShowingGametypes = bShow;
    // End:0x551
    if(bShow)
    {
        ShowGametypesBtn.SetBool("focused", false);
        ShowAdvancedBtn.SetBool("disabled", true);
        ShowMapsBtn.SetBool("disabled", true);
        ShowGametypesBtn.SetBool("disabled", true);
        NewGameBtn.SetBool("disabled", true);
        BackBtn.SetBool("disabled", true);
        InternetLANDropdown.SetBool("visible", false);
        ScoreLimitDropdown.SetBool("visible", false);
        TimeLimitInp.SetBool("visible", false);
        MaxPlayersInp.SetBool("visible", false);
        LanInternetTF.SetText(" ");
        TimelimitTF.SetText(" ");
        ScorelimitTF.SetText(" ");
        MaxPlayersTF.SetText(" ");
        DeathmatchBtn.SetBool("visible", true);
        TeamDeathmatchBtn.SetBool("visible", true);
        CTFBtn.SetBool("visible", true);
        TreasureHuntBtn.SetBool("visible", true);
        TeamTreasureHuntBtn.SetBool("visible", true);
        LastManBtn.SetBool("visible", true);
        GametypesTF.SetText(GametypesString);
        // End:0x401
        if(!GetPC().WorldInfo.IsConsoleBuild(0) && !AdvPlayerController(GetPC()).IsPCGamepadMode())
        {
            HideGametypesBtn.SetBool("visible", true);
        }
        switch(GetMenuGame().MultiGameModeSelected)
        {
            // End:0x45B
            case 1:
                TeamDeathmatchBtn.SetBool("focused", true);
                // End:0x54E
                break;
            // End:0x48C
            case 2:
                CTFBtn.SetBool("focused", true);
                // End:0x54E
                break;
            // End:0x4BD
            case 4:
                TreasureHuntBtn.SetBool("focused", true);
                // End:0x54E
                break;
            // End:0x4EE
            case 6:
                TeamTreasureHuntBtn.SetBool("focused", true);
                // End:0x54E
                break;
            // End:0x51F
            case 5:
                LastManBtn.SetBool("focused", true);
                // End:0x54E
                break;
            // End:0xFFFF
            default:
                DeathmatchBtn.SetBool("focused", true);
                // End:0x54E
                break;
                break;
        }        
    }
    else
    {
        ShowAdvancedBtn.SetBool("disabled", false);
        ShowMapsBtn.SetBool("disabled", false);
        ShowGametypesBtn.SetBool("disabled", false);
        NewGameBtn.SetBool("disabled", false);
        BackBtn.SetBool("disabled", false);
        DeathmatchBtn.SetBool("visible", false);
        TeamDeathmatchBtn.SetBool("visible", false);
        CTFBtn.SetBool("visible", false);
        TreasureHuntBtn.SetBool("visible", false);
        TeamTreasureHuntBtn.SetBool("visible", false);
        LastManBtn.SetBool("visible", false);
        GametypesTF.SetText(" ");
        HideGametypesBtn.SetBool("visible", false);
        // End:0x86A
        if(!bOnlySurvival)
        {
            ScoreLimitDropdown.SetBool("visible", true);
            TimeLimitInp.SetBool("visible", true);
            MaxPlayersInp.SetBool("visible", true);
            TimelimitTF.SetText(TimeLimitString);
            ScorelimitTF.SetText(ScoreLimitString);
            MaxPlayersTF.SetText(MaxPlayersString);
        }
        // End:0x8F8
        if(!GetPC().WorldInfo.IsConsoleBuild(0))
        {
            LanInternetTF.SetText(LanInternetString);
            InternetLANDropdown.SetBool("visible", true);
        }
        ShowGametypesBtn.SetBool("focused", true);
    }
    // End:0x94F
    if(Frontend.footer != none)
    {
        UpdateFooter();
    }
    //return;    
}

function bool GetMapFriendlyName(string Map, out string FriendlyName)
{
    local int I, P;

    I = 0;
    J0x0B:

    // End:0xB8 [Loop If]
    if(I < Maps.Length)
    {
        // End:0xAA
        if(Maps[I].MapName ~= Map)
        {
            FriendlyName = ConvertFriendlyNameToReadable(Maps[I].FriendlyName);
            // End:0xA8
            if(FriendlyName == "")
            {
                // [Explicit Break]
                goto J0xB8;
            }
            return true;
        }
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    J0xB8:

    P = InStr(Map, "-");
    // End:0x114
    if(P > -1)
    {
        Map = Right(Map, (Len(Map) - P) - 1);
    }
    P = InStr(Map, "-");
    // End:0x170
    if(P > -1)
    {
        Map = Right(Map, (Len(Map) - P) - 1);
    }
    Map = Left(Map, Len(Map) - 2);
    FriendlyName = Map;
    return false;
    //return ReturnValue;    
}

static function string ConvertFriendlyNameToReadable(string MapFriendlyNameString)
{
    local int StartIndex, EndIndex;
    local array<string> LocPieces;
    local string MapReadableName;

    StartIndex = InStr(Caps(MapFriendlyNameString), "<STRINGS:");
    // End:0x3B
    if(StartIndex == -1)
    {
        return "";
    }
    MapReadableName = Right(MapFriendlyNameString, (Len(MapFriendlyNameString) - StartIndex) - 9);
    EndIndex = InStr(MapReadableName, ">");
    // End:0x9B
    if(EndIndex == -1)
    {
        return "";
    }
    MapReadableName = Left(MapReadableName, EndIndex);
    ParseStringIntoArray(MapReadableName, LocPieces, ".", true);
    // End:0x12D
    if(LocPieces.Length >= 3)
    {
        MapReadableName = Localize(LocPieces[1], LocPieces[2], LocPieces[0]);
        return MapReadableName;        
    }
    else
    {
        return "";
    }
    //return ReturnValue;    
}

static function string GetStringFromMarkup(string MarkupString)
{
    local UIDataStore_Registry Registry;
    local string Retval;

    Retval = "";
    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    Registry.GetData(MarkupString, Retval);
    return Retval;
    //return ReturnValue;    
}

function WaitForPlayers()
{
    local float timeStart, timeCurr;

    timeStart = Class'Engine.WorldInfo'.static.GetWorldInfo().RealTimeSeconds;
    timeCurr = timeStart;
    J0x51:

    // End:0xAF [Loop If]
    if(timeCurr < (timeStart + float(10)))
    {
        timeCurr = Class'Engine.WorldInfo'.static.GetWorldInfo().RealTimeSeconds;
        // [Loop Continue]
        goto J0x51;
    }
    //return;    
}

function OnCloseAnimationComplete()
{
    local bool bTransitionResult;
    local AdvPartyGRI GRI;

    GRI = AdvPartyGRI(GetMenuGRI());
    switch(Action)
    {
        // End:0xE4
        case "back":
            GRI.SetCurrentPartyType(2, none);
            // End:0x95
            if(bOnlySurvival)
            {
                bTransitionResult = Frontend.OpenMultiSurvivalScreen();                
            }
            else
            {
                GetMenuGame().MultiGameModeSelected = 7;
                bTransitionResult = Frontend.OpenMultiMenuScreen();
            }
            // End:0x124
            break;
        // End:0x11E
        case "newgame":
            Class'AdvEngine'.static.SetEngineState(3);
            CreateHostGame();
            // End:0x124
            break;
        // End:0xFFFF
        default:
            // End:0x124
            break;
            break;
    }
    // End:0x150
    if(bTransitionResult)
    {
        Frontend.CloseMultiHostScreen();
    }
    Action = "";
    //return;    
}

function CreateHostGame()
{
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x16E
    if(OnlineSub != none)
    {
        // End:0x16B
        if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
        {
            GameInterface.DestroyOnlineGame('Party');
            SetupGameSettings();
            GameInterface.AddCreateOnlineGameCompleteDelegate(OnGameCreated);
            // End:0x106
            if(SettingsDataStore.CreateGame(byte(Class'Engine.UIInteraction'.static.GetPlayerControllerId(0))) == false)
            {                
            }
            else
            {
                GetAdvPC().ClientShowMPLevelLoadingMovie(SelectedMapName, "");
                Frontend.GetPartyGame().bHasCreateOutstanding = true;
            }            
        }        
    }
    //return;    
}

function OnConnectionStatusChange(OnlineSubsystem.EOnlineServerConnectionStatus ConnectionStatus)
{
    //return;    
}

function CreateLobby(int NumPlayers, string SteamId)
{
    local array<LobbyMetaData> InitialSettings;

    InitialSettings.Add(1);    
    InitialSettings[0].Key = "STEAMID";
    InitialSettings[0].Value = SteamId;
    LobbyInterface.AddCreateLobbyCompleteDelegate(OnCreateLobbyComplete);
    // End:0xC2
    if(LobbyInterface.CreateLobby(NumPlayers, 0, InitialSettings))
    {
    }
    //return;    
}

function OnCreateLobbyComplete(bool bWasSuccessful, UniqueNetId LobbyId, string Error)
{
    LobbyInterface.ClearCreateLobbyCompleteDelegate(OnCreateLobbyComplete);
    //return;    
}

function string GetMapTextureURL(int MapIndex)
{
    local GFxObject tmpObject;

    tmpObject = MapListDataProvider.GetElementObject(MapIndex);
    // End:0x69
    if(tmpObject != none)
    {
        return tmpObject.GetString("image");
    }
    return "img://" $ "UDKFrontEnd.gm_map_none";
    //return ReturnValue;    
}

defaultproperties
{
    DefaultMapName="MP-Anubis_01"
    DefaultGameMode="ADVGameContent.AdvGameDeathmatch"
    DefaultGameModeSettings="AdvGameSettingsDeathMatch"
    DefaultMapImage="UI_FrontEnd_Art.MapPics.___map-pic-dm-deck"
    DefaultGameModePrefixes="MP"
    bPublicGame=true
    bTraps=true
    bKillingSpree=true
    bOracle=true
    ScoreLimitsPerMode[0]=(GameClassName="ADVGameContent.AdvGameDeathmatch",ScoreLimits=ScoreLimits[0]=2000
    ScoreLimits[1]=3000
    ScoreLimits[2]=4000
    ScoreLimits[3]=6000)
    ScoreLimitsPerMode[1]=(GameClassName="ADVGameContent.AdvGameTeamDeathmatch",ScoreLimits=ScoreLimits[0]=3000
    ScoreLimits[1]=5000
    ScoreLimits[2]=7000
    ScoreLimits[3]=10000)
    ScoreLimitsPerMode[2]=(GameClassName="ADVGameContent.AdvGameCTF",ScoreLimits=ScoreLimits[0]=2
    ScoreLimits[1]=3
    ScoreLimits[2]=4
    ScoreLimits[3]=6)
    ScoreLimitsPerMode[3]=(GameClassName="ADVGameContent.AdvGameTreasureHunt",ScoreLimits=ScoreLimits[0]=15000
    ScoreLimits[1]=22500
    ScoreLimits[2]=30000
    ScoreLimits[3]=45000)
    ScoreLimitsPerMode[4]=(GameClassName="ADVGameContent.AdvGameTeamTreasureHunt",ScoreLimits=ScoreLimits[0]=30000
    ScoreLimits[1]=45000
    ScoreLimits[2]=60000
    ScoreLimits[3]=90000)
    ScoreLimitsPerMode[5]=(GameClassName="ADVGameContent.AdvGameLastMenStanding",ScoreLimits=ScoreLimits[0]=0)
    ScoreLimitsPerMode[6]=(GameClassName="ADVGameContent.AdvGameSurvival",ScoreLimits=ScoreLimits[0]=0)
    TimeLimit=20
    MaxPlayers=16
    RespawnTime=5
    MaxSpectators=4
    TitleString="Host setup"
    NewGameString="Start Game"
    GameTypeString="Game Type"
    LanInternetString="LAN Game"
    PublicGameString="Public Server"
    ServerNameString="Server Name"
    ServerNameLabelString="Unknown Server"
    ServerPasswordString="Server Password"
    TimeLimitString="Time Limit (minutes)"
    ScoreLimitString="Score Limit"
    MaxSpectatorsString="Max Spectators"
    MaxPlayersString="Max Players"
    ResTimeString="Respawn Time"
    TeamDamageString="Team Damage"
    TrapString="Traps"
    KillingSpreeString="Killing Spree"
    OracleString="Oracle"
    RealismString="Realism"
    AdvancedOptionsString="Show Advanced"
    HideAdvancedOptionsString="Hide Advanced"
    MapsOptionsString="Change Map"
    HideMapsOptionsString="Hide Maps"
    GametypesOptionsString="Change Game Mode"
    HideGametypesOptionsString="Hide Game Modes"
    MapListString="Maps"
    ServerMapListString="Server Map List"
    AdvancedString="Advanced"
    GametypesString="Game Modes"
    MovieInfoPath="UI_AdvUI.AdvMultiHost"
}