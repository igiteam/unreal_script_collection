class AdvGFxUI_Menu_PregameLobbyPrivateHost extends AdvGFxUI_Menu_Base
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
var GFxObject GametypeBG;
var GFxObject ListMC;
var GFxObject ChatMC;
var GFxClikWidget DeathmatchBtn;
var GFxClikWidget TeamDeathmatchBtn;
var GFxClikWidget CTFBtn;
var GFxClikWidget TreasureHuntBtn;
var GFxClikWidget TeamTreasureHuntBtn;
var GFxClikWidget LastManBtn;
var GFxObject TitleTF;
var GFxObject SubtitleTF;
var GFxObject SelectedTF;
var GFxObject GametypeDescTF;
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
var GFxClikWidget ClassBtn;
var GFxClikWidget SkinBtn;
var GFxClikWidget KickBtn;
var GFxClikWidget MuteBtn;
var GFxClikWidget BackBtn;
var GFxClikWidget MapMainGfx;
var GFxClikWidget MapList;
var GFxClikWidget MapListScrollbar;
var GFxObject MapListUpArrow;
var GFxObject MapListDownArrow;
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
var transient bool bPrivateGame;
var transient bool bInitialGameModeSetup;
var transient bool bStartupFinished;
var bool bRoundGameSelected;
var GFxClikWidget GameTypeDropdown;
var GFxObject GameTypeDataProvider;
var int LastSelectedGame;
var config array<config TScoreLimitsPerMode> ScoreLimitsPerMode;
var int LastSelectedScorePerModeIndex;
var array<UTUIDataProvider_MapInfo> Maps;
var array<string> DropMapNames;
var int SelectedMapIndex;
var int DefaultMapIndex;
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
var int RoundsToWin;
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
var EvilTypesNative.EDifficultyLevel DifficultyLevel;
var transient OnlineGameInterface GameInterface;
var transient OnlineLobbyInterfaceSteamworks LobbyInterface;
var AdvPreGameGRI GRI;
var AdvGameSettingsCommon VsSettings;
var AdvGFxTextChatComponent TextChatComponent;
var class<AdvGameSearchCommon> PlayerMatchSearchClass;
//var delegate<MapListSort> __MapListSort__Delegate;

function bool Start(optional bool StartPaused = false)
{
    local DataStoreClient DSClient;
    local UIDataStore_Registry Registry;
    local int I;
    local array<string> GenericNoYes;
    local GFxObject OptionListProvider;

    // End:0x68
    if(AdvLocalPlayer(GetLP()).bRestoreUsingGamepad)
    {
        GetPC().PlayerInput.bUsingGamepad = true;
    }
    bOnlySurvival = int(GetMenuGame().MultiGameModeSelected) == int(3);
    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    DSClient = Class'Engine.UIInteraction'.static.GetDataStoreClient();
    // End:0x186
    if(DSClient != none)
    {
        SettingsDataStore = UIDataStore_OnlineGameSettings(DSClient.FindDataStore('AdvGameSettings'));
        StringListDataStore = UTUIDataStore_StringList(DSClient.FindDataStore('UTStringList'));
    }
    SettingsDataStore.SetCurrentByName(name(DefaultGameModeSettings));
    Registry.SetData("SelectedGameModePrefix", DefaultGameModePrefixes);
    Registry.SetData("SelectedGameMode", DefaultGameMode);
    Registry.SetData("SelectedMapImage", DefaultMapImage);
    Registry.SetData("ServerPassword", "");
    super.Start(StartPaused);
    Advance(0.0000000);
    GenericNoYes[0] = Localize("Generic", "No", "ADVGame");
    GenericNoYes[1] = Localize("Generic", "Yes", "ADVGame");
    OptionListProvider = CreateArray();
    I = 0;
    J0x330:

    // End:0x3B0 [Loop If]
    if(I < GenericNoYes.Length)
    {
        OptionListProvider.SetElementString(I, Class'Engine.UIRoot'.static.SafeCaps(GenericNoYes[I]));
        I++;
        // [Loop Continue]
        goto J0x330;
    }
    bShowingAdvanced = false;
    bShowingGametypes = false;
    bShowingMaps = false;
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x465
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
    AdvancedBG = AdvancedMC.GetObject("bg");
    MapsMC = ButtonsMC.GetObject("mapsMC");
    GameTypesMC = ButtonsMC.GetObject("gametypeMC");
    ChatMC = ButtonsMC.GetObject("chatMC", Class'GFxUI.GFxClikWidget');
    GametypeBG = GameTypesMC.GetObject("ramkaMC");
    NewGameBtn = GFxClikWidget(ButtonsMC.GetObject("start_btn", Class'GFxUI.GFxClikWidget'));
    ShowAdvancedBtn = GFxClikWidget(ButtonsMC.GetObject("show_advanced", Class'GFxUI.GFxClikWidget'));
    HideAdvancedBtn = GFxClikWidget(AdvancedMC.GetObject("hide_btn", Class'GFxUI.GFxClikWidget'));
    ShowMapsBtn = GFxClikWidget(ButtonsMC.GetObject("show_maps", Class'GFxUI.GFxClikWidget'));
    HideMapsBtn = GFxClikWidget(MapsMC.GetObject("hidemaps_btn", Class'GFxUI.GFxClikWidget'));
    ShowGametypesBtn = GFxClikWidget(ButtonsMC.GetObject("show_gametype", Class'GFxUI.GFxClikWidget'));
    HideGametypesBtn = GFxClikWidget(GameTypesMC.GetObject("hidegametype_btn", Class'GFxUI.GFxClikWidget'));
    ClassBtn = GFxClikWidget(ButtonsMC.GetObject("class_btn", Class'GFxUI.GFxClikWidget'));
    SkinBtn = GFxClikWidget(ButtonsMC.GetObject("skin_btn", Class'GFxUI.GFxClikWidget'));
    KickBtn = GFxClikWidget(ButtonsMC.GetObject("kick_btn", Class'GFxUI.GFxClikWidget'));
    KickBtn.SetString("label", "<Strings:ADVGame.AdvGFxUI_Menu_PartyWindow.KickPlayer>");
    MuteBtn = GFxClikWidget(ButtonsMC.GetObject("mute_btn", Class'GFxUI.GFxClikWidget'));
    MuteBtn.SetVisible(false);
    BackBtn = GFxClikWidget(ButtonsMC.GetObject("back_btn", Class'GFxUI.GFxClikWidget'));
    BackBtn.SetString("label", back);
    // End:0xC58
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
    GametypeDescTF = GameTypesMC.GetObject("textField");
    ServerNameTF = ButtonsMC.GetObject("servnameTF");
    LanInternetTF = AdvancedMC.GetObject("internetLANTF");
    TimelimitTF = AdvancedMC.GetObject("timelimitTF");
    ScorelimitTF = AdvancedMC.GetObject("fraglimitTF");
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
    InternetLANDropdown = GFxClikWidget(AdvancedMC.GetObject("internetLAN", Class'GFxUI.GFxClikWidget'));
    ScoreLimitDropdown = GFxClikWidget(AdvancedMC.GetObject("fraglimit", Class'GFxUI.GFxClikWidget'));
    TimeLimitInp = GFxClikWidget(AdvancedMC.GetObject("timelimit", Class'GFxUI.GFxClikWidget'));
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
    MapListUpArrow = MapsMC.GetObject("list_up");
    MapListDownArrow = MapsMC.GetObject("list_down");
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
    ClassBtn.SetString("label", Class'AdvGFxUI_Menu_MultiMenu'.default.SettingsString);
    SkinBtn.SetString("label", Class'AdvGFxUI_Menu_MultiMenu'.default.SkinString);
    DeathmatchBtn.SetString("label", Class'AdvUIDataStore_GameResource'.static.GetGameTypeProvider(0).GameName);
    TeamDeathmatchBtn.SetString("label", Class'AdvUIDataStore_GameResource'.static.GetGameTypeProvider(1).GameName);
    CTFBtn.SetString("label", Class'AdvUIDataStore_GameResource'.static.GetGameTypeProvider(2).GameName);
    TreasureHuntBtn.SetString("label", Class'AdvUIDataStore_GameResource'.static.GetGameTypeProvider(4).GameName);
    TeamTreasureHuntBtn.SetString("label", Class'AdvUIDataStore_GameResource'.static.GetGameTypeProvider(6).GameName);
    LastManBtn.SetString("label", Class'AdvUIDataStore_GameResource'.static.GetGameTypeProvider(5).GameName);
    // End:0x1D52
    if(int(GetPC().WorldInfo.NetMode) == int(NM_Client))
    {
        MapList.SetVisible(false);
    }
    // End:0x1E24
    if(GetPC().WorldInfo.IsConsoleBuild(0))
    {
        InternetLANDropdown.SetBool("visible", false);
        LanInternetTF.SetText(" ");
        PasswordInp.SetBool("visible", false);
        PasswordTF.SetText(" ");
    }
    SpectatorsTF.SetText(" ");
    MaxSpectatorsInp.SetVisible(false);
    ShowGametypesBtn.SetBool("visible", false);
    ClassBtn.SetBool("visible", false);
    TimelimitTF.SetText(" ");
    ScorelimitTF.SetText(" ");
    ScoreLimitDropdown.SetBool("visible", false);
    TimeLimitInp.SetBool("visible", false);
    ShowAdvanced(false);
    ShowMaps(false);
    ShowGametypes(false);
    NewGameBtn.SetBool("focused", true);
    Frontend.GetPartyGame().RefreshPartySettings();
    bStartupFinished = true;
    return true;
    //return ReturnValue;    
}

function Tick(float DeltaTime)
{
    local UniqueNetId ZeroId;
    local AdvGameSettingsCommon GameSettings;

    super.Tick(DeltaTime);
    // End:0x2C
    if(GRI == none)
    {
        UpdateGRI();
    }
    // End:0x1E2
    if(AdvPlayerController(GetPC()).LobbyUID != ZeroId && !bInitialGameModeSetup)
    {
        // End:0xF0
        if(int(GetMenuGame().MultiGameModeSelected) == int(3))
        {
            AdvPlayerController(GetPC()).UpdateSteamLobbyGameMode("ADVGameContent.AdvGameSurvival");            
        }
        else
        {
            GameSettings = AdvGameSettingsCommon(OnlineSub.GameInterface.GetGameSettings('Game'));
            // End:0x1A4
            if(GameSettings != none)
            {
                AdvPlayerController(GetPC()).UpdateSteamLobbyGameMode(GameSettings.GetPropertyAsStringByName('CustomGameMode'));                
            }
            else
            {
                AdvPlayerController(GetPC()).UpdateSteamLobbyGameMode(DefaultGameMode);
            }
        }
        bInitialGameModeSetup = true;
    }
    //return;    
}

function UpdateGRI()
{
    local AdvTypes.EMultiGameMode MultiMode;

    GRI = AdvPreGameGRI(GetPC().WorldInfo.GRI);
    // End:0x2E6
    if(GRI != none)
    {
        GRI.SetCurrentPartyType(0, AdvPlayerController(GetPC()));
        GRI.__OnPlayersCountUpdate__Delegate = UpdateSubtitle;
        MultiMode = Class'AdvUIDataStore_GameResource'.static.GetGameTypeProvider(GRI.WinningGameMode).MPGameMode;
        MultiMode = GetMenuGame().MultiGameModeSelected;
        // End:0x169
        if(int(MultiMode) != int(7))
        {
            SetGameType(MultiMode);            
        }
        else
        {
            SetGameType(0);
        }
        UpdateListDataProvider();
        bOnlySurvival = int(MultiMode) == int(3);
        bPrivateGame = GRI.PlaylistId == -1;
        // End:0x22C
        if(!bOnlySurvival)
        {
            ShowGametypesBtn.SetBool("visible", true);
            ClassBtn.SetBool("visible", true);
        }
        UpdateSubtitle();
        GetMenuGame().SetPresenceByPartyType();
        GRI.StartArbitration();
        TextChatComponent = new Class'AdvGFxTextChatComponent';
        TextChatComponent.Initialize(ChatMC, AdvPreGameLobbyPRI(GetPC().PlayerReplicationInfo), GRI);
    }
    //return;    
}

function OnChatDown(EventData ev)
{
    // End:0x2E
    if(TextChatComponent != none)
    {
        TextChatComponent.OnChatDown();
    }
    //return;    
}

function OnChatUp(EventData ev)
{
    // End:0x2E
    if(TextChatComponent != none)
    {
        TextChatComponent.OnChatUp();
    }
    //return;    
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
    AddNATStatus(ButtonAliases);
    Frontend.footer.FooterUpdate(ButtonAliases);
    //return;    
}

function InitDefaultOptions()
{
    local int Id;
    local AdvGameSettingsCommon GameSettings;
    local string svName;

    GameSettings = AdvGameSettingsCommon(OnlineSub.GameInterface.GetGameSettings('Game'));
    // End:0x95
    if(GameSettings == none)
    {
        GameSettings = AdvGameSettingsCommon(SettingsDataStore.GetCurrentGameSettings());        
    }
    else
    {
        // End:0x11D
        if(int(GetMenuGame().MultiGameModeSelected) == int(3))
        {
            svName = "ADVGameContent.AdvGameSurvival";
            GameSettings.SetPropertyFromStringByName('CustomGameMode', svName);            
        }
        else
        {
            GameSettings.SetPropertyFromStringByName('CustomGameMode', DefaultGameMode);
        }
        OnlineSub.GameInterface.UpdateOnlineGame('Game', GameSettings, true);
    }
    InternetLANDropdown.SetFloat("selectedIndex", float(((GameSettings.bIsLanMatch) ? 1 : 0)));
    // End:0x251
    if(GameSettings.GetPropertyId('TimeLimit', Id))
    {
        GameSettings.GetIntProperty(Id, TimeLimit);
    }
    LoadProfileData();
    ScoreLimitDropdown.SetFloat("selectedIndex", 0.0000000);
    TimeLimitInp.SetInt("value", TimeLimit);
    MaxSpectatorsInp.SetInt("value", RoundsToWin);
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

    Maps.Length = 0;
    LocalMapList.Length = 0;
    Class'EvilGame.UTUIDataStore_MenuItems'.static.GetAllResourceDataProviders(Class'EvilGame.UTUIDataProvider_MapInfo', ProviderList);
    I = 0;
    J0x54:

    // End:0xEE [Loop If]
    if(I < ProviderList.Length)
    {
        // End:0xB7
        if(DropMapNames.Find(UTUIDataProvider_MapInfo(ProviderList[I]).MapName) != )
        {                        
        }
        else
        {
            LocalMapList.AddItem(UTUIDataProvider_MapInfo(ProviderList[I]));            
        }
        I++;
        // [Loop Continue]
        goto J0x54;
    }
    // End:0x100
    if(LocalMapList.Length == 0)
    {
        return;
    }
    LocalMapList.Sort(MapListSort);    
    ListCounter = 0;
    DataProvider = CreateArray();
    I = 0;
    J0x148:

    // End:0x3DB [Loop If]
    if(I < LocalMapList.Length)
    {
        // End:0x3CD
        if(!LocalMapList[I].ShouldBeFiltered())
        {
            Maps.AddItem(LocalMapList[I]);            
            bFriendlyFound = GetMapFriendlyName(LocalMapList[I].MapName, FriendlyName);
            // End:0x226
            if(!bFriendlyFound)
            {
                Maps.RemoveItem(LocalMapList[I]);                                
            }
            else
            {
                TempObj = CreateObject("Object");
                TempObj.SetString("label", FriendlyName);
                TempObj.SetString("players", LocalMapList[I].NumPlayers);
                // End:0x350
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
        goto J0x148;
    }
    MapList.SetObject("dataProvider", DataProvider);
    MapListDataProvider = MapList.GetObject("dataProvider");
    SelectedMapIndex = 0;
    J0x454:

    // End:0x4CA [Loop If]
    if(SelectedMapIndex < Maps.Length)
    {
        // End:0x4BC
        if(Class'AdvPlayerController'.static.GetContentDLC(Maps[SelectedMapIndex].MapName) == 0)
        {
            // [Explicit Break]
            goto J0x4CA;
        }
        ++SelectedMapIndex;
        // [Loop Continue]
        goto J0x454;
    }
    J0x4CA:

    DefaultMapIndex = SelectedMapIndex;
    MapList.SetFloat("selectedIndex", float(SelectedMapIndex));
    AdvPreGameGRI(GetMenuGRI()).OverrideMapName(Maps[SelectedMapIndex].MapName);
    MapMainGfx.SetString("source", GetMapTextureURL(SelectedMapIndex));
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
    // End:0x12C
    if(!bStartupFinished)
    {
        return;
    }
    OnlineSub.DumpSessionState();
    OnlineSub.GameInterface.AddDestroyOnlineGameCompleteDelegate(OnFinishDestroyOnlineGamePC);
    // End:0x2B9
    if(OnlineSub.GameInterface.GetGameSettings('Game') != none)
    {
        VsSettings = AdvGameSettingsCommon(OnlineSub.GameInterface.GetGameSettings('Game'));
        VsSettings.bIsLanMatch = bLANSelected;
        OnlineSub.DumpGameSettings(VsSettings);
        OnlineSub.GameInterface.DestroyOnlineGame('Game');        
    }
    else
    {
        OnFinishDestroyOnlineGamePC('Game', false);
    }
    //return;    
}

function OnFinishDestroyOnlineGamePC(name SessionName, bool bWasSuccessful)
{
    OnlineSub.GameInterface.ClearDestroyOnlineGameCompleteDelegate(OnFinishDestroyOnlineGamePC);
    // End:0x123
    if((OnlineSub != none) && NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
    {
        OnlineSub.DumpGameSettings(VsSettings);
        GameInterface.AddCreateOnlineGameCompleteDelegate(OnCreatePlayerVersusMatchComplete);
        GameInterface.CreateOnlineGame(byte(GetLP().ControllerId), 'Game', VsSettings);
    }
    //return;    
}

function OnCreatePlayerVersusMatchComplete(name SessionName, bool bWasSuccessful)
{
    local byte PlatformInfo[80];
    local AdvPlayerController PC;

    GameInterface.ClearCreateOnlineGameCompleteDelegate(OnCreatePlayerVersusMatchComplete);
    // End:0x1F2
    if(bWasSuccessful)
    {
        // End:0x1EF
        if(GameInterface.ReadPlatformSpecificSessionInfoBySessionName('Game', PlatformInfo) || true)
        {
            // End:0xF4
            foreach GetPC().WorldInfo.AllControllers(Class'AdvPlayerController', PC)
            {
                // End:0xF3
                if(PC != none)
                {
                    PC.ClientShowJoinGameMovie(9);
                }                
            }            
            // End:0x15B
            if(bLANSelected)
            {
                GetPC().WorldInfo.ServerTravel(Class'AdvPreGameLobbyGame_Base'.static.GetTravelToPreGameLobbyUrlNoSS(), true, true);                
            }
            else
            {
                GetPC().WorldInfo.ServerTravel(Class'AdvPreGameLobbyGame_Base'.static.GetTravelToPreGameLobbyUrl(), true, true);
            }
            GetMenuGame().TellClientsToTravelToSession('Game', PlayerMatchSearchClass, PlatformInfo);            
        }        
    }
    else
    {
        GetPC().WorldInfo.ServerTravel("?closed", true, true);
    }
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
    AdvPlayerController(GetPC()).UpdateSteamLobbyGameMode(GameSummaryInfo.ClassName);
    GameSettings = AdvGameSettingsCommon(OnlineSub.GameInterface.GetGameSettings('Game'));
    // End:0x286
    if(GameSettings != none)
    {
        GameSettings.SetPropertyFromStringByName('CustomGameMode', GameSummaryInfo.ClassName);
        OnlineSub.GameInterface.UpdateOnlineGame('Game', GameSettings, true);
    }
    GameSettings = AdvGameSettingsCommon(SettingsDataStore.GetCurrentGameSettings());
    OptionListProvider = CreateArray();
    // End:0x3E6
    if(int(eMultiMode) == int(3))
    {
        OptionListProvider.SetElementString(0, Class'EvilGame.EvilDifficultySettings'.static.GetClassByID(0).default.DifficultyName);
        OptionListProvider.SetElementString(1, Class'EvilGame.EvilDifficultySettings'.static.GetClassByID(1).default.DifficultyName);
        OptionListProvider.SetElementString(2, Class'EvilGame.EvilDifficultySettings'.static.GetClassByID(2).default.DifficultyName);        
    }
    else
    {
        I = 0;
        J0x3F1:

        // End:0x520 [Loop If]
        if(I < ScoreLimitsPerMode.Length)
        {
            // End:0x512
            if(ScoreLimitsPerMode[I].GameClassName == name(GameSummaryInfo.ClassName))
            {
                LastSelectedScorePerModeIndex = I;
                J = 0;
                J0x472:

                // End:0x50F [Loop If]
                if(J < ScoreLimitsPerMode[I].ScoreLimits.Length)
                {
                    OptionListProvider.SetElementString(J, string(ScoreLimitsPerMode[I].ScoreLimits[J]));
                    J++;
                    // [Loop Continue]
                    goto J0x472;
                }
                // [Explicit Break]
                goto J0x520;
            }
            I++;
            // [Loop Continue]
            goto J0x3F1;
        }
    }
    J0x520:

    // End:0x559
    if((int(eMultiMode) == int(5)) || int(eMultiMode) == int(2))
    {
        bRoundGameSelected = true;        
    }
    else
    {
        bRoundGameSelected = false;
    }
    ScoreLimitDropdown.SetObject("dataProvider", OptionListProvider);
    ScoreLimitDropdown.SetFloat("selectedIndex", 0.0000000);
    // End:0x633
    if(GameSettings.GetPropertyId('TimeLimit', Id))
    {
        GameSettings.GetIntProperty(Id, TimeLimit);
    }
    TimeLimitInp.SetInt("value", TimeLimit);
    GetMenuGame().MultiGameModeSelected = eMultiMode;
    UpdateSubtitle();
    AdvPreGameGRI(GetMenuGRI()).OverrideGameMode(eMultiMode);
    //return;    
}

function UpdateSubtitle()
{
    local AdvGameInfoSummary GameSummaryInfo;

    GameSummaryInfo = Class'AdvUIDataStore_GameResource'.static.GetGameTypeProvider(GetMenuGame().MultiGameModeSelected);
    SubtitleTF.SetText(((((((GameSummaryInfo.GameName $ " (") $ (Localize("AdvGFxUI_Menu_PregameLobby", "PlayersString", "ADVGame"))) $ " ") $ string(GRI.ConnectedPlayers)) $ "/") $ string(GRI.MaxPlayers)) $ ")");
    //return;    
}

function UpdateLobbyMapWithPriDLCFlags()
{
    // End:0xF5
    if(!AdvPlayerController(GetPC()).CheckMapAndDisplayError(Maps[SelectedMapIndex].MapName))
    {
        SelectedMapIndex = DefaultMapIndex;
        AdvPreGameGRI(GetMenuGRI()).OverrideMapName(Maps[SelectedMapIndex].MapName);
        MapMainGfx.SetString("source", GetMapTextureURL(SelectedMapIndex));
    }
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
    GameSettings = AdvGameSettingsCommon(SettingsDataStore.GetCurrentGameSettings());
    OptionListProvider = CreateArray();
    // End:0x2F9
    if(int(GameSummaryInfo.MPGameMode) == int(3))
    {
        OptionListProvider.SetElementString(0, Class'EvilGame.EvilDifficultySettings'.static.GetClassByID(0).default.DifficultyName);
        OptionListProvider.SetElementString(1, Class'EvilGame.EvilDifficultySettings'.static.GetClassByID(1).default.DifficultyName);
        OptionListProvider.SetElementString(2, Class'EvilGame.EvilDifficultySettings'.static.GetClassByID(2).default.DifficultyName);        
    }
    else
    {
        I = 0;
        J0x304:

        // End:0x433 [Loop If]
        if(I < ScoreLimitsPerMode.Length)
        {
            // End:0x425
            if(ScoreLimitsPerMode[I].GameClassName == name(GameSummaryInfo.ClassName))
            {
                LastSelectedScorePerModeIndex = I;
                J = 0;
                J0x385:

                // End:0x422 [Loop If]
                if(J < ScoreLimitsPerMode[I].ScoreLimits.Length)
                {
                    OptionListProvider.SetElementString(J, string(ScoreLimitsPerMode[I].ScoreLimits[J]));
                    J++;
                    // [Loop Continue]
                    goto J0x385;
                }
                // [Explicit Break]
                goto J0x433;
            }
            I++;
            // [Loop Continue]
            goto J0x304;
        }
    }
    J0x433:

    ScoreLimitDropdown.SetObject("dataProvider", OptionListProvider);
    ScoreLimitDropdown.SetFloat("selectedIndex", 0.0000000);
    // End:0x501
    if(GameSettings.GetPropertyId('TimeLimit', Id))
    {
        GameSettings.GetIntProperty(Id, TimeLimit);
    }
    TimeLimitInp.SetInt("value", TimeLimit);
    MaxSpectatorsInp.SetInt("value", RoundsToWin);
    LastSelectedGame = SelectedIndex;
    //return;    
}

function OnListSelect(int Index)
{
    local EventData ev;

    // End:0x1A
    if(Index >= Maps.Length)
    {
        return;
    }
    // End:0x120
    if(AdvPlayerController(GetPC()).CheckMapAndDisplayError(Maps[Index].MapName))
    {
        SelectedMapIndex = Index;
        AdvPreGameGRI(GetMenuGRI()).OverrideMapName(Maps[SelectedMapIndex].MapName);
        MapMainGfx.SetString("source", GetMapTextureURL(SelectedMapIndex));
        OnBack(ev);
    }
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
    // End:0x4A
    if(bOnlySurvival)
    {
        DifficultyLevel = byte(ScoreLimitDropdown.GetFloat("selectedIndex"));        
    }
    else
    {
        ScoreLimit = ScoreLimitsPerMode[LastSelectedScorePerModeIndex].ScoreLimits[int(ScoreLimitDropdown.GetFloat("selectedIndex"))];
    }
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
    RoundsToWin = MaxSpectatorsInp.GetInt("value");
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
    local array<name> ButtonAliases;

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
    ButtonAliases.AddItem('GenericYes');    
    ButtonAliases.AddItem('GenericNo');    
    Class'AdvUIManager'.static.ShowUIMessage('PauseOptionConfirm', Localize("MessageBoxStrings", "LeavePregameLobby_Title", "ADVGame"), Localize("MessageBoxStrings", "LeavePregameLobby_MemberMessage", "ADVGame"), ButtonAliases, Exit, GetLP(),,,, false,,, true);
    //return;    
}

function bool Exit(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
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

function OverDeathBtn(EventData ev)
{
    GametypeDescTF.SetText(Localize("DefaultDeathmatch AdvOnlinePlaylistProvider", "PlaylistDescription", "ADVGame"));
    //return;    
}

function OverTeamDeathBtn(EventData ev)
{
    GametypeDescTF.SetText(Localize("DefaultTeamDeathmatch AdvOnlinePlaylistProvider", "PlaylistDescription", "ADVGame"));
    //return;    
}

function OverCaptureBtn(EventData ev)
{
    GametypeDescTF.SetText(Localize("DefaultCaptureTheArtifact AdvOnlinePlaylistProvider", "PlaylistDescription", "ADVGame"));
    //return;    
}

function OverTreasureBtn(EventData ev)
{
    GametypeDescTF.SetText(Localize("DefaultTreasureHunt AdvOnlinePlaylistProvider", "PlaylistDescription", "ADVGame"));
    //return;    
}

function OverTeamTreasureBtn(EventData ev)
{
    GametypeDescTF.SetText(Localize("DefaultTeamTreasureHunt AdvOnlinePlaylistProvider", "PlaylistDescription", "ADVGame"));
    //return;    
}

function OverLastManBtn(EventData ev)
{
    GametypeDescTF.SetText(Localize("DefaultLastManStanding AdvOnlinePlaylistProvider", "PlaylistDescription", "ADVGame"));
    //return;    
}

function OnNewGameBtn(EventData ev)
{
    // End:0x129
    if(SelectedMapIndex != -1)
    {
        // End:0x87
        if(AdvPlayerController(GetPC()).CheckMapAndDisplayError(Maps[SelectedMapIndex].MapName))
        {
            Action = "newgame";
            PlayCloseAnimation();            
        }
        else
        {
            SelectedMapIndex = DefaultMapIndex;
            AdvPreGameGRI(GetMenuGRI()).OverrideMapName(Maps[SelectedMapIndex].MapName);
            MapMainGfx.SetString("source", GetMapTextureURL(SelectedMapIndex));
        }        
    }
    else
    {
        ShowNoMapWarning();
    }
    //return;    
}

function OnClassBtn(EventData ev)
{
    Action = "settings";
    PlayCloseAnimation();
    //return;    
}

function OnSkin(EventData ev)
{
    Action = "skin";
    PlayCloseAnimation();
    //return;    
}

function OnKick(EventData ev)
{
    KickBtn.SetBool("focused", false);
    KickBtn.SetBool("focused", true);
    Frontend.OpenPartyMenuWindow(0, 2);
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
    bDisplayPartyWindow = !bShow;
    // End:0x748
    if(bShow)
    {
        ShowAdvancedBtn.SetBool("focused", false);
        ShowAdvancedBtn.SetBool("disabled", true);
        ShowMapsBtn.SetBool("disabled", true);
        ShowGametypesBtn.SetBool("disabled", true);
        NewGameBtn.SetBool("disabled", true);
        BackBtn.SetBool("disabled", true);
        ClassBtn.SetBool("disabled", true);
        SkinBtn.SetBool("disabled", true);
        KickBtn.SetBool("disabled", true);
        // End:0x292
        if(!bOnlySurvival)
        {
            // End:0x23D
            if(int(GetMenuGame().MultiGameModeSelected) != int(5))
            {
                ScoreLimitDropdown.SetBool("visible", true);
                ScorelimitTF.SetText(ScoreLimitString);
            }
            TimeLimitInp.SetBool("visible", true);
            TimelimitTF.SetText(TimeLimitString);            
        }
        else
        {
            ScorelimitTF.SetText(Class'AdvGFxUI_Menu_DifficultyMenu'.default.FightString);
            ScoreLimitDropdown.SetBool("visible", true);
        }
        // End:0x396
        if(!GetPC().WorldInfo.IsConsoleBuild(0))
        {
            // End:0x396
            if(!bPrivateGame)
            {
                LanInternetTF.SetText(LanInternetString);
                InternetLANDropdown.SetBool("visible", true);
            }
        }
        // End:0x449
        if(!bOnlySurvival)
        {
            RespawnInp.SetBool("visible", true);
            TrapsDropdown.SetBool("visible", true);
            KillingSpreeDropdown.SetBool("visible", true);
            OracleDropdown.SetBool("visible", true);
        }
        TeamDamageDropdown.SetBool("visible", true);
        AdvancedTF.SetText(AdvancedString);
        TeamDamageTF.SetText(TeamDamageString);
        // End:0x577
        if(!bOnlySurvival)
        {
            RespawnTF.SetText(ResTimeString);
            TrapsTF.SetText(TrapString);
            KillingSpreeTF.SetText(KillingSpreeString);
            OracleTF.SetText(OracleString);
        }
        // End:0x60C
        if(!GetPC().WorldInfo.IsConsoleBuild(0) && !AdvPlayerController(GetPC()).IsPCGamepadMode())
        {
            HideAdvancedBtn.SetBool("visible", true);
        }
        // End:0x647
        if(!bOnlySurvival)
        {
            TrapsDropdown.SetBool("focused", true);            
        }
        else
        {
            TeamDamageDropdown.SetBool("focused", true);
        }
        AdvancedBG.SetVisible(true);
        // End:0x745
        if(bRoundGameSelected)
        {
            MaxSpectatorsInp.SetVisible(true);
            MaxSpectatorsInp.SetInt("value", RoundsToWin);
            SpectatorsTF.SetText(Localize("AdvGFxUI_Scoreboard", "MaxRoundsString", "AdvGame"));
        }        
    }
    else
    {
        ShowAdvancedBtn.SetBool("disabled", false);
        ShowMapsBtn.SetBool("disabled", false);
        ShowGametypesBtn.SetBool("disabled", false);
        NewGameBtn.SetBool("disabled", false);
        BackBtn.SetBool("disabled", false);
        ClassBtn.SetBool("disabled", false);
        SkinBtn.SetBool("disabled", false);
        KickBtn.SetBool("disabled", false);
        MaxSpectatorsInp.SetBool("visible", false);
        TeamDamageDropdown.SetBool("visible", false);
        RespawnInp.SetBool("visible", false);
        TrapsDropdown.SetBool("visible", false);
        KillingSpreeDropdown.SetBool("visible", false);
        OracleDropdown.SetBool("visible", false);
        RealismDropdown.SetBool("visible", false);
        InternetLANDropdown.SetBool("visible", false);
        ScoreLimitDropdown.SetBool("visible", false);
        TimeLimitInp.SetBool("visible", false);
        LanInternetTF.SetText(" ");
        TimelimitTF.SetText(" ");
        ScorelimitTF.SetText(" ");
        AdvancedTF.SetText(" ");
        TeamDamageTF.SetText(" ");
        RespawnTF.SetText(" ");
        TrapsTF.SetText(" ");
        KillingSpreeTF.SetText(" ");
        OracleTF.SetText(" ");
        RealismTF.SetText(" ");
        SpectatorsTF.SetText(" ");
        HideAdvancedBtn.SetBool("visible", false);
        // End:0xC2C
        if(bRoundGameSelected)
        {
            MaxSpectatorsInp.SetVisible(false);
            SpectatorsTF.SetText(" ");
        }
        ShowAdvancedBtn.SetBool("focused", true);
        AdvancedBG.SetVisible(false);
    }
    // End:0xCE7
    if(GetPC().WorldInfo.IsConsoleBuild(0) || AdvPlayerController(GetPC()).IsPCGamepadMode())
    {
        UpdateFooter();
    }
    //return;    
}

function ShowMaps(bool bShow)
{
    bShowingMaps = bShow;
    bDisplayPartyWindow = !bShow;
    // End:0x3B9
    if(bShow)
    {
        ShowMapsBtn.SetBool("focused", false);
        ShowAdvancedBtn.SetBool("disabled", true);
        ShowMapsBtn.SetBool("disabled", true);
        ShowGametypesBtn.SetBool("disabled", true);
        NewGameBtn.SetBool("disabled", true);
        BackBtn.SetBool("disabled", true);
        ClassBtn.SetBool("disabled", true);
        SkinBtn.SetBool("disabled", true);
        KickBtn.SetBool("disabled", true);
        MapGfx.SetBool("visible", true);
        MapList.SetBool("visible", true);
        MapListScrollbar.SetBool("visible", false);
        MapListUpArrow.SetVisible(true);
        MapListDownArrow.SetVisible(true);
        MapGfx.SetString("source", GetMapTextureURL(int(MapList.GetFloat("selectedIndex"))));
        MapsTF.SetText(MapListString);
        // End:0x38D
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
        ClassBtn.SetBool("disabled", false);
        SkinBtn.SetBool("disabled", false);
        KickBtn.SetBool("disabled", false);
        MapList.SetBool("visible", false);
        MapListScrollbar.SetBool("visible", false);
        MapGfx.SetBool("visible", false);
        MapListUpArrow.SetVisible(false);
        MapListDownArrow.SetVisible(false);
        MapsTF.SetText(" ");
        MapDescriptionTF.SetText(" ");
        HideMapsBtn.SetBool("visible", false);
        ShowMapsBtn.SetBool("focused", true);
    }
    // End:0x6CE
    if(GetPC().WorldInfo.IsConsoleBuild(0) || AdvPlayerController(GetPC()).IsPCGamepadMode())
    {
        UpdateFooter();
    }
    //return;    
}

function ShowGametypes(bool bShow)
{
    bShowingGametypes = bShow;
    bDisplayPartyWindow = !bShow;
    // End:0x4D6
    if(bShow)
    {
        ShowGametypesBtn.SetBool("focused", false);
        ShowAdvancedBtn.SetBool("disabled", true);
        ShowMapsBtn.SetBool("disabled", true);
        ShowGametypesBtn.SetBool("disabled", true);
        NewGameBtn.SetBool("disabled", true);
        BackBtn.SetBool("disabled", true);
        ClassBtn.SetBool("disabled", true);
        SkinBtn.SetBool("disabled", true);
        KickBtn.SetBool("disabled", true);
        DeathmatchBtn.SetBool("visible", true);
        TeamDeathmatchBtn.SetBool("visible", true);
        CTFBtn.SetBool("visible", true);
        TreasureHuntBtn.SetBool("visible", true);
        TeamTreasureHuntBtn.SetBool("visible", true);
        LastManBtn.SetBool("visible", true);
        GametypeBG.SetVisible(true);
        GametypesTF.SetText(GametypesString);
        // End:0x386
        if(!GetPC().WorldInfo.IsConsoleBuild(0) && !AdvPlayerController(GetPC()).IsPCGamepadMode())
        {
            HideGametypesBtn.SetBool("visible", true);
        }
        switch(GetMenuGame().MultiGameModeSelected)
        {
            // End:0x3E0
            case 1:
                TeamDeathmatchBtn.SetBool("focused", true);
                // End:0x4D3
                break;
            // End:0x411
            case 2:
                CTFBtn.SetBool("focused", true);
                // End:0x4D3
                break;
            // End:0x442
            case 4:
                TreasureHuntBtn.SetBool("focused", true);
                // End:0x4D3
                break;
            // End:0x473
            case 6:
                TeamTreasureHuntBtn.SetBool("focused", true);
                // End:0x4D3
                break;
            // End:0x4A4
            case 5:
                LastManBtn.SetBool("focused", true);
                // End:0x4D3
                break;
            // End:0xFFFF
            default:
                DeathmatchBtn.SetBool("focused", true);
                // End:0x4D3
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
        ClassBtn.SetBool("disabled", false);
        SkinBtn.SetBool("disabled", false);
        KickBtn.SetBool("disabled", false);
        DeathmatchBtn.SetBool("visible", false);
        TeamDeathmatchBtn.SetBool("visible", false);
        CTFBtn.SetBool("visible", false);
        TreasureHuntBtn.SetBool("visible", false);
        TeamTreasureHuntBtn.SetBool("visible", false);
        LastManBtn.SetBool("visible", false);
        GametypeBG.SetVisible(false);
        GametypesTF.SetText(" ");
        GametypeDescTF.SetText(" ");
        HideGametypesBtn.SetBool("visible", false);
        ShowGametypesBtn.SetBool("focused", true);
    }
    // End:0x846
    if(GetPC().WorldInfo.IsConsoleBuild(0) || AdvPlayerController(GetPC()).IsPCGamepadMode())
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

function OnCloseAnimationComplete()
{
    local bool bTransitionResult;

    switch(Action)
    {
        // End:0x8E
        case "back":
            // End:0x5F
            if(GRI != none)
            {
                GRI.SetCurrentPartyType(1, AdvPlayerController(GetPC()));
            }
            GetAdvPC().ExitFromMPGame();
            bTransitionResult = true;
            // End:0x1AB
            break;
        // End:0xFB
        case "newgame":
            SetupGameSettings();
            GRI.NoPlaylistTravelURL = GetTravelURL();
            GRI.BeginMatch();
            bTransitionResult = true;
            // End:0x1AB
            break;
        // End:0x135
        case "settings":
            bTransitionResult = Frontend.OpenMultiPlayerSettingsScreen();
            // End:0x1AB
            break;
        // End:0x1A5
        case "skin":
            // End:0x178
            if(bOnlySurvival)
            {
                bTransitionResult = Frontend.OpenSurvivalSkinScreen();                
            }
            else
            {
                bTransitionResult = Frontend.OpenMultiPlayerSkinScreen();
            }
            // End:0x1AB
            break;
        // End:0xFFFF
        default:
            // End:0x1AB
            break;
            break;
    }
    // End:0x1E0
    if(bTransitionResult)
    {
        AdvFrontEndParty(Frontend).ClosePregameLobbyScreen();
    }
    Action = "";
    //return;    
}

function SetupGameSettings()
{
    local int propId;
    local AdvGameSettingsCommon GameSettings;
    local string SelectedGameMode;
    local UIDataStore_Registry Registry;

    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    GameSettings = AdvGameSettingsCommon(SettingsDataStore.GetCurrentGameSettings());
    GameSettings.bIsLanMatch = bLANSelected;
    // End:0xFA
    if(AdvPreGameLobbyGame_Base(GetMenuGame()) != none)
    {
        AdvPreGameLobbyGame_Base(GetMenuGame()).PreGameGameSettings.bIsLanMatch = bLANSelected;
    }
    GameSettings.bUsesArbitration = false;
    Registry.GetData("SelectedGameMode", SelectedGameMode);
    GameSettings.SetPropertyFromStringByName('CustomMapName', AdvPreGameGRI(GetMenuGRI()).WinningMapName);
    GameSettings.SetPropertyFromStringByName('CustomGameMode', SelectedGameMode);
    GameSettings.bShouldAdvertise = true;
    // End:0x25C
    if(GameSettings.GetPropertyId('GoalScore', propId))
    {
        GameSettings.SetIntProperty(propId, ScoreLimit);
    }
    // End:0x2C1
    if(GameSettings.GetPropertyId('TimeLimit', propId))
    {
        GameSettings.SetIntProperty(propId, TimeLimit);
    }
    // End:0x336
    if(GameSettings.GetPropertyId('RoundsToWin', propId))
    {
        GameSettings.SetIntProperty(propId, ((bRoundGameSelected) ? RoundsToWin : 1));
    }
    SaveProfileData();
    //return;    
}

function string GetTravelURL()
{
    local OnlineGameSettings LocalGameSettings;
    local string TravelURL, OutStringValue;
    local UIDataStore_Registry Registry;

    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    LocalGameSettings = SettingsDataStore.GetCurrentGameSettings();
    LocalGameSettings.bIsDedicated = StringListDataStore.GetCurrentValueIndex('DedicatedServer') == 1;
    // End:0x154
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
    TravelURL $= ("?CustomGameMode=" $ OutStringValue);    
    TravelURL $= ("?MultiplayerMode=" $ string(int(GetMenuGame().MultiGameModeSelected)));    
    TravelURL $= ("?TimeLimit=" $ string(TimeLimit));    
    TravelURL $= ("?GoalScore=" $ string(ScoreLimit));    
    TravelURL $= ("?CustomMapName=" $ AdvPreGameGRI(GetMenuGRI()).WinningMapName);    
    TravelURL $= ("?TeamDamage=" $ string(bTeamDamage));    
    TravelURL $= ("?RespawnTime=" $ string(RespawnTime));    
    TravelURL $= ("?RoundsToWin=" $ string(((bRoundGameSelected) ? RoundsToWin : 1)));    
    TravelURL $= ("?Traps=" $ string(bTraps));    
    TravelURL $= ("?KillingSpree=" $ string(bKillingSpree));    
    TravelURL $= ("?Oracle=" $ string(bOracle));    
    TravelURL $= ("?Realism=" $ string(bRealism));    
    TravelURL $= ("?FightDifficultyLevel=" $ string(int(DifficultyLevel)));
    // End:0x4FE
    if(!bLANSelected)
    {        
        TravelURL $= "?steamsockets";
        AdvPlayerController(GetPC()).SetupSteamLobby();        
    }
    else
    {        
        TravelURL $= "?bIsLanMatch=true";
    }
    TravelURL = (("" $ AdvPreGameGRI(GetMenuGRI()).WinningMapName) $ TravelURL) $ "?listen";
    return TravelURL;
    //return ReturnValue;    
}

event bool FilterButtonInput(int ControllerId, name ButtonName, Object.EInputEvent InputEvent)
{
    // End:0x5D
    if(((TextChatComponent != none) && int(InputEvent) == int(0)) && ButtonName == 'Enter')
    {
        TextChatComponent.SendMessage();
    }
    return super.FilterButtonInput(ControllerId, ButtonName, InputEvent);
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
    MaxPlayers=12
    RespawnTime=5
    MaxSpectators=4
    RoundsToWin=3
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