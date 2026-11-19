class AdvGFxUI_Menu_MultiServers extends AdvGFxUI_Menu_Base
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
const ADV_TITLEID_DEADFALL_ADVENTURES = 0x354807D5;
const ADV_CONTEXT_MULTIPLAYERMODE = 0;
const ADV_CONTEXT_MULTIMAPS = 1;
const ADV_CONTEXT_QUICKSEARCH = 2;
const ADV_CONTEXT_PARTYSLOT_1 = 3;
const ADV_CONTEXT_PARTYSLOT_2 = 4;
const ADV_CONTEXT_PARTYSLOT_3 = 5;
const ADV_CONTEXT_PARTYSLOT_4 = 6;
const ADV_CONTEXT_PARTYSLOT_5 = 7;
const ADV_CONTEXT_MODULOSTEP = 8;
const ADV_CONTEXT_MULTIPLAYERMODE_DEATHMATCH = 0;
const ADV_CONTEXT_MULTIPLAYERMODE_TEAMDEATHMATCH = 1;
const ADV_CONTEXT_MULTIPLAYERMODE_CTF = 2;
const ADV_CONTEXT_MULTIPLAYERMODE_SURVIVAL = 3;
const ADV_CONTEXT_MULTIPLAYERMODE_TREASUREHUNT = 4;
const ADV_CONTEXT_MULTIPLAYERMODE_LASTMENSTANDING = 5;
const ADV_CONTEXT_MULTIPLAYERMODE_TEAMTREASUREHUNT = 6;
const ADV_CONTEXT_MULTIPLAYERMODE_ANY = 7;
const ADV_CONTEXT_MULTIMAPS_E_MM_TEST = 0;
const ADV_CONTEXT_QUICKSEARCH_NO = 0;
const ADV_CONTEXT_QUICKSEARCH_YES = 1;
const ADV_CONTEXT_PARTYSLOT_1_PARTYSLOT_BLOCKED = 0;
const ADV_CONTEXT_PARTYSLOT_1_PARTYSLOT_WANTS = 1;
const ADV_CONTEXT_PARTYSLOT_1_PARTYSLOT_NEEDS = 2;
const ADV_CONTEXT_PARTYSLOT_2_PARTYSLOT_BLOCKED = 0;
const ADV_CONTEXT_PARTYSLOT_2_PARTYSLOT_WANTS = 1;
const ADV_CONTEXT_PARTYSLOT_2_PARTYSLOT_NEEDS = 2;
const ADV_CONTEXT_PARTYSLOT_3_PARTYSLOT_BLOCKED = 0;
const ADV_CONTEXT_PARTYSLOT_3_PARTYSLOT_WANTS = 1;
const ADV_CONTEXT_PARTYSLOT_3_PARTYSLOT_NEEDS = 2;
const ADV_CONTEXT_PARTYSLOT_4_PARTYSLOT_BLOCKED = 0;
const ADV_CONTEXT_PARTYSLOT_4_PARTYSLOT_WANTS = 1;
const ADV_CONTEXT_PARTYSLOT_4_PARTYSLOT_NEEDS = 2;
const ADV_CONTEXT_PARTYSLOT_5_PARTYSLOT_BLOCKED = 0;
const ADV_CONTEXT_PARTYSLOT_5_PARTYSLOT_WANTS = 1;
const ADV_CONTEXT_PARTYSLOT_5_PARTYSLOT_NEEDS = 2;
const ADV_CONTEXT_MODULOSTEP_MODULOSTEP = 0;
const ADV_CONTEXT_MODULOSTEP_MODULOSTEP_1 = 1;
const ADV_CONTEXT_MODULOSTEP_MODULOSTEP_2 = 2;
const ADV_CONTEXT_MODULOSTEP_MODULOSTEP_3 = 3;
const ADV_CONTEXT_MODULOSTEP_MODULOSTEP_4 = 4;
const ADV_CONTEXT_MODULOSTEP_MODULOSTEP_5 = 5;
const ADV_CONTEXT_MODULOSTEP_MODULOSTEP_6 = 6;
const ADV_CONTEXT_MODULOSTEP_MODULOSTEP_7 = 7;
const ADV_CONTEXT_MODULOSTEP_MODULOSTEP_8 = 8;
const ADV_CONTEXT_MODULOSTEP_MODULOSTEP_9 = 9;
const ADV_CONTEXT_MODULOSTEP_MODULOSTEP_ANY = 10;
const ADV_CONTEXT_PRESENCE_IDLE = 0;
const ADV_CONTEXT_PRESENCE_PARTY_PUBLIC_SEARCH = 1;
const ADV_CONTEXT_PRESENCE_PARTY_PUBLIC_WAIT = 2;
const ADV_CONTEXT_PRESENCE_PARTY_PRIVATE = 3;
const ADV_CONTEXT_PRESENCE_MENU = 4;
const ADV_CONTEXT_PRESENCE_SINGLE = 5;
const ADV_CONTEXT_PRESENCE_MULTI = 6;
const ADV_CONTEXT_GAME_MODE_SINGLE = 0;
const ADV_CONTEXT_GAME_MODE_MULTI = 1;
const ADV_CONTEXT_GAME_MODE_PARTY = 2;
const ADV_CONTEXT_GAME_MODE_DEATHMATCH = 3;
const ADV_CONTEXT_GAME_MODE_ANY = 4;
const ADV_PROPERTY_PLAYLISTID = 0x10000001;
const ADV_PROPERTY_PLAYLISTMANAGERVERSION = 0x10000002;
const ADV_PROPERTY_DATACENTERID = 0x10000003;
const ADV_PROPERTY_MATCHXPLEVEL = 0x10000004;
const ADV_PROPERTY_L_KILLS = 0x10000006;
const ADV_PROPERTY_L_ASSISTS = 0x10000007;
const ADV_PROPERTY_L_DEATHS = 0x10000008;
const ADV_PROPERTY_L_SCORE = 0x1000000B;
const ADV_PROPERTY_L_FLAGSCAPTURED = 0x1000000C;
const ADV_PROPERTY_L_FLAGSRETURNED = 0x1000000D;
const ADV_PROPERTY_L_RESCUES = 0x1000000E;
const ADV_PROPERTY_L_TREASURES = 0x1000000F;
const ADV_PROPERTY_L_WAVES = 0x10000010;
const ADV_PROPERTY_L_POINTSRATED = 0x20000005;
const ADV_PROPERTY_L_EXPERIENCE = 0x20000011;
const ADV_ACHIEVEMENT_EADVA_FINISH_CAMPAIGN = 1;
const ADV_ACHIEVEMENT_EADVA_SAHARAOUTDOOR_FIND_ENTRANCE_TO_PYRAMID = 2;
const ADV_ACHIEVEMENT_EADVA_SAHARAINDOOR_FINISHLEVEL = 3;
const ADV_ACHIEVEMENT_EADVA_ARCTICBASE_FINISHLEVEL = 4;
const ADV_ACHIEVEMENT_EADVA_ARCTICBASE2_FINISHLEVEL = 5;
const ADV_ACHIEVEMENT_EADVA_ARCTICTEMPLE_FINISHLEVEL = 6;
const ADV_ACHIEVEMENT_EADVA_ARCTICMINES_FINISHLEVEL = 7;
const ADV_ACHIEVEMENT_EADVA_MAYANJUNGLE_FINISHLEVEL = 8;
const ADV_ACHIEVEMENT_EADVA_MAYANUNDERGROUND_FINISHLEVEL = 9;
const ADV_ACHIEVEMENT_EADVA_MAYANCITY_FINISHLEVEL = 10;
const ADV_ACHIEVEMENT_EADVA_XIXALBA_BEAT_GUARDIAN = 11;
const ADV_ACHIEVEMENT_EADVA_XIBALBA_KILL_HAGEN = 12;
const ADV_ACHIEVEMENT_EADVA_COLLECT_5_POWER_OF_LIGHT = 13;
const ADV_ACHIEVEMENT_EADVA_COLLECT_10_POWER_OF_LIFE = 14;
const ADV_ACHIEVEMENT_EADVA_COLLECT_15_POWER_OF_WARRIOR = 15;
const ADV_ACHIEVEMENT_EADVA_COLLECT_50_TREASURES = 16;
const ADV_ACHIEVEMENT_EADVA_KILL_50_ENEMIES_USING_TRAPS = 17;
const ADV_ACHIEVEMENT_EADVA_KILL_100_MUMMIES = 18;
const ADV_ACHIEVEMENT_EADVA_COLLECT_7_TREASURE_MAPS = 19;
const ADV_ACHIEVEMENT_EADVA_KILL_25_ENEMIES_USING_DYNAMITE = 20;
const ADV_ACHIEVEMENT_EADVA_SAHARAOUTDOOR_FIND_FIRST_SECRET = 21;
const ADV_ACHIEVEMENT_EADVA_SAHARAINDOOR_ESCAPE_FROM_GAS_TRAP = 22;
const ADV_ACHIEVEMENT_EADVA_ARCTICBASE_DISABLE_CRUSHING_TRAP = 23;
const ADV_ACHIEVEMENT_EADVA_ARCTICBASE2_SOLVE_FINAL_PUZZLE_COLLECT_SPECIAL_TREASURE = 24;
const ADV_ACHIEVEMENT_EADVA_ARCTICMINES_SOLVE_CARTS_PUZZLE = 25;
const ADV_ACHIEVEMENT_EADVA_MAYANJUNGLE_EXPLORE_SECRET_CAVE = 26;
const ADV_ACHIEVEMENT_EADVA_MAYANUNDERGROUND_SOLVE_ELEVATOR_PUZZLE = 27;
const ADV_ACHIEVEMENT_EADVA_MAYANCITY_DRAG_TREASURE_FROM_MUMMY_HAND = 28;
const ADV_ACHIEVEMENT_EADVA_MAYANTEMPLE_OPEN_LOCKER_WITH_TREASURE = 29;
const ADV_ACHIEVEMENT_EADVA_XIBALBA_ESCAPE_FROM_CRUSHER_TRAP = 30;
const ADV_ACHIEVEMENT_EADVA_ARCTIC_TEMPLE_SOLVE_SLIDING_PUZZLE = 31;
const ADV_ACHIEVEMENT_EADVA_MP_FIRST_KILL = 32;
const ADV_ACHIEVEMENT_EADVA_MP_ACHIEVE_BEST_SCORE = 33;
const ADV_ACHIEVEMENT_EADVA_MP_ACHIEVE_BEST_KD = 34;
const ADV_ACHIEVEMENT_EADVA_MP_FINISH_MATCH_WITHOUT_DYING = 35;
const ADV_ACHIEVEMENT_EADVA_MPTH_COLLECT_100_GOLD_STATUES = 36;
const ADV_ACHIEVEMENT_EADVA_MPTH_COLLECT_50_SILVER_STATUES = 37;
const ADV_ACHIEVEMENT_EADVA_MP_KILL_100_PLAYER_USING_TRAPS = 38;
const ADV_ACHIEVEMENT_EADVA_MP_UNLOCK_ALL_WEAPONS = 39;
const ADV_ACHIEVEMENT_EADVA_MP_UNLOCK_ALL_CHARACTERS = 40;
const ADV_ACHIEVEMENT_EADVA_MPTH_EARN_200_BLESSINGS = 41;
const ADV_ACHIEVEMENT_EADVA_MP_OBTAIN_ALL_KILLING_SPREES = 42;
const ADV_ACHIEVEMENT_EADVA_MP_UNLOCK_ALL_AUTOMATIC_UPGRADES = 43;
const ADV_ACHIEVEMENT_EADVA_MP_ACHIEVE_HIGHEST_MULTIPLAYER_RANK = 44;
const ADV_ACHIEVEMENT_EADVA_MPLMS_WIN_10_MATCHES = 45;
const ADV_ACHIEVEMENT_EADVA_MPDM_KILL_ALL_OPPONENTS = 46;
const ADV_ACHIEVEMENT_EADVA_MP_FINISH_MATCH_USING_CUSTOM_CLASS = 47;
const ADV_ACHIEVEMENT_EADVA_MPSV_SURVIVE_100_WAVES = 48;
const ADV_ACHIEVEMENT_EADVA_MPSV_KILL_3_ENEMIES_BY_FIRE_TRAP = 49;
const ADV_ACHIEVEMENT_EADVA_MPSV_KILL_500_TREETERS = 50;
const ADV_STATS_VIEW_SKILL_RANKED_SINGLE = 0xFFFF0000;
const ADV_STATS_VIEW_SKILL_RANKED_MULTI = 0xFFFF0001;
const ADV_STATS_VIEW_SKILL_RANKED_PARTY = 0xFFFF0002;
const ADV_STATS_VIEW_SKILL_RANKED_DEATHMATCH = 0xFFFF0003;
const ADV_STATS_VIEW_SKILL_RANKED_ANY = 0xFFFF0004;
const ADV_STATS_VIEW_SKILL_STANDARD_SINGLE = 0xFFFE0000;
const ADV_STATS_VIEW_SKILL_STANDARD_MULTI = 0xFFFE0001;
const ADV_STATS_VIEW_SKILL_STANDARD_PARTY = 0xFFFE0002;
const ADV_STATS_VIEW_SKILL_STANDARD_DEATHMATCH = 0xFFFE0003;
const ADV_STATS_VIEW_SKILL_STANDARD_ANY = 0xFFFE0004;
const ADV_STATS_VIEW_MP_TDM = 2;
const ADV_STATS_VIEW_MP_CTF = 3;
const ADV_STATS_VIEW_MP_LMS = 4;
const ADV_STATS_VIEW_MP_TH = 5;
const ADV_STATS_VIEW_MP_SV = 6;
const ADV_STATS_VIEW_PLAYERLEVELS = 7;
const ADV_STATS_VIEW_MP_DM = 8;
const ADV_STATS_VIEW_MP_TTH = 9;
const ADV_STATS_COLUMN_MP_TDM_SCORE = 4;
const ADV_STATS_COLUMN_MP_TDM_KILLS = 1;
const ADV_STATS_COLUMN_MP_TDM_ASSISTS = 2;
const ADV_STATS_COLUMN_MP_TDM_DEATHS = 3;
const ADV_STATS_COLUMN_MP_CTF_SCORE = 2;
const ADV_STATS_COLUMN_MP_CTF_FLAGSCAPTURED = 1;
const ADV_STATS_COLUMN_MP_CTF_FLAGSRETURNED = 3;
const ADV_STATS_COLUMN_MP_LMS_SCORE = 1;
const ADV_STATS_COLUMN_MP_LMS_KILLS = 2;
const ADV_STATS_COLUMN_MP_LMS_DEATHS = 3;
const ADV_STATS_COLUMN_MP_LMS_RESCUES = 4;
const ADV_STATS_COLUMN_MP_TH_SCORE = 1;
const ADV_STATS_COLUMN_MP_TH_KILLS = 2;
const ADV_STATS_COLUMN_MP_TH_DEATHS = 3;
const ADV_STATS_COLUMN_MP_TH_TREASURES = 4;
const ADV_STATS_COLUMN_MP_SV_SCORE = 1;
const ADV_STATS_COLUMN_MP_SV_ENEMIESKILLS = 2;
const ADV_STATS_COLUMN_MP_SV_WAVES = 3;
const ADV_STATS_COLUMN_MP_DM_SCORE = 4;
const ADV_STATS_COLUMN_MP_DM_KILLS = 1;
const ADV_STATS_COLUMN_MP_DM_ASSISTS = 2;
const ADV_STATS_COLUMN_MP_DM_DEATHS = 3;
const ADV_STATS_COLUMN_MP_TTH_SCORE = 1;
const ADV_STATS_COLUMN_MP_TTH_KILLS = 2;
const ADV_STATS_COLUMN_MP_TTH_DEATHS = 3;
const ADV_STATS_COLUMN_MP_TTH_TREASURES = 4;
const ADV_SESSION_MATCH_QUERY_DEATHMATCH = 0;
const ADV_SESSION_MATCH_QUERY_TEAMDEATHMATCH = 1;
const ADV_SESSION_MATCH_QUERY_CTF = 2;
const ADV_SESSION_MATCH_QUERY_SURVIVAL = 3;
const ADV_SESSION_MATCH_QUERY_TREASUREHUNT = 4;
const ADV_SESSION_MATCH_QUERY_TEAMTREASUREHUNT = 5;
const ADV_SESSION_MATCH_QUERY_LASTMENSTANDING = 6;
const ADV_SESSION_MATCH_QUERY_QUICK = 7;
const ADV_SESSION_MATCH_QUERY_PLAYLISTSEARCH = 8;
const SERVERBROWSER_SERVERTYPE_LAN = 0;
const SERVERBROWSER_SERVERTYPE_UNRANKED = 1;
const SERVERBROWSER_SERVERTYPE_RANKED = 2;
const SERVER_LIST_COUNT = 11;

enum EQueryCompletionAction
{
    QUERYACTION_None,               // 0
    QUERYACTION_Default,            // 1
    QUERYACTION_CloseScene,         // 2
    QUERYACTION_JoinServer,         // 3
    QUERYACTION_RefreshAll,         // 4
    QUERYACTION_MAX                 // 5
};

struct ServerListItem
{
    var GFxObject ServerListRow;
    var GFxClikWidget ServerListBtn;
    var GFxObject ServerListLockMC;
    var GFxObject ServerListGametypeTF;
    var GFxObject ServerListMapTF;
    var GFxObject ServerListPlayersTF;
    var GFxObject ServerListPingTF;
    var int GameSearchIndex;

    structdefaultproperties
    {
        ServerListRow=none
        ServerListBtn=none
        ServerListLockMC=none
        ServerListGametypeTF=none
        ServerListMapTF=none
        ServerListPlayersTF=none
        ServerListPingTF=none
        GameSearchIndex=0
    }
};

var GFxObject ButtonsMC;
var GFxObject TitleMC;
var GFxObject TitleTF;
var GFxObject ServersTF;
var GFxObject GameTypeTF;
var GFxObject LanTF;
var GFxObject SpectateTF;
var GFxClikWidget JoinBtn;
var GFxClikWidget RefreshBtn;
var GFxClikWidget BackBtn;
var GFxClikWidget GameTypeDropdown;
var GFxObject GameTypeDataProvider;
var GFxClikWidget InternetLANDropdown;
var bool bLANSelected;
var bool bSpectateSelected;
var bool bBackToCampaignMenu;
var bool bSearch1;
var bool bSearch2;
var bool bPingSort;
var bool bServerSort;
var bool bGameSort;
var bool bMapSort;
var bool bPlayersSort;
var bool bAutoShiftUp;
var bool bAutoShiftDown;
var bool bInitFinished;
var GFxClikWidget SpectateDropdown;
var GFxClikWidget PasswordInp;
var string Password;
var transient AdvDataStore_GameSearch SearchDataStore;
var const transient name SearchDSName;
var transient array<OnlineGameSearchResult> ServerInfoList;
var transient UTUIDataStore_StringList StringListDataStore;
var transient OnlineGameInterface GameInterface;
var transient OnlineLobbyInterfaceSteamworks LobbyInterface;
var transient OnlineAuthInterface AuthInterface;
var transient int LastSelectedIndex;
var const localized string TitleString;
var const localized string GameTypeString;
var const localized string ServersString;
var const localized string JoinString;
var const localized string RefreshString;
var const localized string LanInternetString;
var const localized string SpectateString;
var const localized string AllGamesString;
var const localized string ServerNameTxt;
var const localized string PlayersTxt;
var const localized string MapNameTxt;
var const localized string GameTxt;
var const localized string PingTxt;
var int LatestSearchLenght;
var int LatestDedicatedSearchLenght;
var int LatestLanSearchLenght;
var int TotalMaxLobbiesSearch;
var int CurrentMaxLobbiesSearch;
var array<LobbyFilter> LastLobbySearchFilters;
var array<BasicLobbyInfo> Lobbies;
var string JoinSteamID;
var OnlineGameSearchResult GameToJoin;
var int ForceSelectedIndex;
var array<SteamServerData> SteamServerList;
var private transient AdvGFxUI_Menu_MultiServers.EQueryCompletionAction QueryCompletionAction;
var GFxObject ServerListMC;
var GFxObject ServerNameHeaderTF;
var GFxObject GametypeHeaderTF;
var GFxObject MapHeaderTF;
var GFxObject PlayersHeaderTF;
var GFxObject PingHeaderTF;
var int CurrentRowShift;
var int LastSelectedSlot;
var float AutoShiftSlowDelay;
var float AutoShiftFastDelay;
var float AutoShiftSlowToFastDelay;
var transient float AutoShiftTimeElapsed;
var transient float AutoShiftLastTime;
var AdvGameSearchCommon DedicatedPlayerMatchSearch;
var ServerListItem ServersList[11];
var transient float LastClickTime;
var transient int LastClickIndex;
var array<Playlist> Playlists;
var array<string> GameTypeNames;
var int UnofficialDedicatedPlaylistId;
//var delegate<SortByServer> __SortByServer__Delegate;
//var delegate<SortByGame> __SortByGame__Delegate;
//var delegate<SortByMap> __SortByMap__Delegate;
//var delegate<SortByPlayers> __SortByPlayers__Delegate;
//var delegate<SortByPing> __SortByPing__Delegate;

function bool Start(optional bool StartPaused = false)
{
    local DataStoreClient DSClient;
    local UIDataStore_Registry Registry;
    local AdvGameSearchCommon CommonSearch;
    local int I;
    local array<string> GenericNoYes;
    local GFxObject OptionListProvider;

    super.Start(StartPaused);
    Advance(0.0000000);
    GenericNoYes[0] = Localize("Generic", "No", "ADVGame");
    GenericNoYes[1] = Localize("Generic", "Yes", "ADVGame");
    OptionListProvider = CreateArray();
    I = 0;
    J0xA0:

    // End:0x120 [Loop If]
    if(I < GenericNoYes.Length)
    {
        OptionListProvider.SetElementString(I, Class'Engine.UIRoot'.static.SafeCaps(GenericNoYes[I]));
        I++;
        // [Loop Continue]
        goto J0xA0;
    }
    DSClient = Class'Engine.UIInteraction'.static.GetDataStoreClient();
    // End:0x1D3
    if(DSClient != none)
    {
        SearchDataStore = AdvDataStore_GameSearch(DSClient.FindDataStore(SearchDSName));
        StringListDataStore = UTUIDataStore_StringList(DSClient.FindDataStore('UTStringList'));        
    }
    LatestSearchLenght = 0;
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x297
    if(OnlineSub != none)
    {
        GameInterface = OnlineSub.GameInterface;
        AuthInterface = OnlineSub.AuthInterface;
        LobbyInterface = OnlineSubsystemSteamworks(OnlineSub).LobbyInterface;
    }
    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    Registry.SetData("LanClient", "1");
    ButtonsMC = MenuMC.GetObject("buttons");
    TitleMC = MenuMC.GetObject("title");
    TitleTF = TitleMC.GetObject("textField");
    ServersTF = ButtonsMC.GetObject("servernameTF");
    GameTypeTF = ButtonsMC.GetObject("gametypeTF");
    LanTF = ButtonsMC.GetObject("LanTF");
    SpectateTF = ButtonsMC.GetObject("spectateTF");
    ServerListMC = ButtonsMC.GetObject("serverlist");
    ServerNameHeaderTF = ServerListMC.GetObject("labels").GetObject("server");
    GametypeHeaderTF = ServerListMC.GetObject("labels").GetObject("gametype");
    MapHeaderTF = ServerListMC.GetObject("labels").GetObject("map");
    PlayersHeaderTF = ServerListMC.GetObject("labels").GetObject("players");
    PingHeaderTF = ServerListMC.GetObject("labels").GetObject("ping");
    I = 0;
    J0x642:

    // End:0x962 [Loop If]
    if(I < 11)
    {
        ServersList[I].ServerListRow = ServerListMC.GetObject("row" $ string(I));
        ServersList[I].ServerListBtn = GFxClikWidget(ServersList[I].ServerListRow.GetObject("server", Class'GFxUI.GFxClikWidget'));
        ServersList[I].ServerListLockMC = ServersList[I].ServerListRow.GetObject("lock");
        ServersList[I].ServerListGametypeTF = ServersList[I].ServerListRow.GetObject("gametype");
        ServersList[I].ServerListMapTF = ServersList[I].ServerListRow.GetObject("map");
        ServersList[I].ServerListPlayersTF = ServersList[I].ServerListRow.GetObject("players");
        ServersList[I].ServerListPingTF = ServersList[I].ServerListRow.GetObject("ping");
        SetRowActive(I, false);
        I++;
        // [Loop Continue]
        goto J0x642;
    }
    JoinBtn = GFxClikWidget(ButtonsMC.GetObject("join_btn", Class'GFxUI.GFxClikWidget'));
    RefreshBtn = GFxClikWidget(ButtonsMC.GetObject("refresh_btn", Class'GFxUI.GFxClikWidget'));
    BackBtn = GFxClikWidget(ButtonsMC.GetObject("back_btn", Class'GFxUI.GFxClikWidget'));
    BackBtn.SetString("label", back);
    // End:0xAF5
    if(GetPC().WorldInfo.IsConsoleBuild(0) || AdvPlayerController(GetPC()).IsPCGamepadMode())
    {
        BackBtn.SetBool("visible", false);
    }
    InternetLANDropdown = GFxClikWidget(ButtonsMC.GetObject("internetLAN", Class'GFxUI.GFxClikWidget'));
    InternetLANDropdown.SetObject("dataProvider", OptionListProvider);
    InternetLANDropdown.SetFloat("selectedIndex", float(((bLANSelected) ? 1 : 0)));
    SpectateDropdown = GFxClikWidget(ButtonsMC.GetObject("spectate", Class'GFxUI.GFxClikWidget'));
    SpectateDropdown.SetObject("dataProvider", OptionListProvider);
    SpectateDropdown.SetBool("visible", false);
    GameTypeTF.SetText(" ");
    GameTypeDropdown = GFxClikWidget(ButtonsMC.GetObject("gametype", Class'GFxUI.GFxClikWidget'));
    GameTypeDropdown.SetBool("visible", true);
    GameTypeTF.SetText(GameTypeString);
    // End:0xD49
    if(int(GetMenuGame().MultiGameModeSelected) != int(3))
    {
        UpdateGameTypeDropdownDataProvider();        
    }
    else
    {
        UpdateGameTypeDropdownDataProviderSV();
    }
    TitleTF.SetText(TitleString);
    ServersTF.SetText(ServersString);
    LanTF.SetText(LanInternetString);
    SpectateTF.SetText("");
    JoinBtn.SetString("label", JoinString);
    RefreshBtn.SetString("label", RefreshString);
    ServerNameHeaderTF.SetText(ServerNameTxt);
    GametypeHeaderTF.SetText(GameTxt);
    MapHeaderTF.SetText(MapNameTxt);
    PlayersHeaderTF.SetText(PlayersTxt);
    PingHeaderTF.SetText(PingTxt);
    GetPlaylistList();
    ValidateServerType();
    bSearch1 = true;
    bSearch2 = true;
    CommonSearch = AdvGameSearchCommon(SearchDataStore.GetCurrentGameSearch());
    // End:0xFA9
    if(CommonSearch != none)
    {
        CommonSearch.InitFilters();
    }
    DedicatedPlayerMatchSearch = new Class'AdvGameSearchDeathmatch';
    bBackToCampaignMenu = false;
    SearchAllGames();
    GameTypeDropdown.SetFloat("selectedIndex", 0.0000000);
    bInitFinished = true;
    RefreshServerList();
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

function GetPlaylistList()
{
    local int I;
    local name ProviderTag;
    local UIDataStore_OnlinePlaylists PlaylistDS;
    local array<UIResourceDataProvider> Providers;

    // End:0x4C
    if(int(GetMenuGame().MultiGameModeSelected) == int(3))
    {
        ProviderTag = name("PlaylistsSurvival");        
    }
    else
    {
        ProviderTag = name("PlaylistsUnranked");
    }
    PlaylistDS = UIDataStore_OnlinePlaylists(Class'Engine.UIRoot'.static.StaticResolveDataStore(Class'IpDrv.UIDataStore_OnlinePlaylists'.default.Tag));
    // End:0xFC
    if(PlaylistDS != none)
    {
        PlaylistDS.GetResourceProviders(ProviderTag, Providers);
    }
    Playlists.Add(Providers.Length);    
    I = 0;
    J0x11C:

    // End:0x1F2 [Loop If]
    if(I < Providers.Length)
    {
        Playlists[I].Name = OnlinePlaylistProvider(Providers[I]).DisplayName;
        Playlists[I].PlaylistId = OnlinePlaylistProvider(Providers[I]).PlaylistId;
        I++;
        // [Loop Continue]
        goto J0x11C;
    }
    //return;    
}

function string GetPLNameById(int plId)
{
    local int Idx;

    Idx = Playlists.Find('PlaylistId', plId);    
    // End:0x5F
    if(Idx >= 0)
    {
        return Playlists[Idx].Name;
    }
    return "";
    //return ReturnValue;    
}

function ValidateServerType()
{
    local int PlayerIndex, PlayerControllerId;

    PlayerIndex = GetPlayerIndex();
    PlayerControllerId = GetPlayerControllerId(PlayerIndex);
    // End:0x72
    if(!Class'Engine.UIInteraction'.static.IsLoggedIn(PlayerControllerId, true))
    {
        ForceLANOption(PlayerIndex);
    }
    //return;    
}

final function ForceLANOption(int PlayerIndex)
{
    local int I, ValueIndex;
    local name MatchTypeName;
    local AdvGameSearchCustom CustomSearch;
    local array<UDKUIResourceDataProvider> Providers;
    local UTUIDataProvider_GameModeInfo Provider;

    MatchTypeName = ((Class'Engine.WorldInfo'.static.IsConsoleBuild(1)) ? 'MatchType360' : 'MatchType');
    ValueIndex = StringListDataStore.GetCurrentValueIndex(MatchTypeName);
    // End:0xAC
    if(ValueIndex != 0)
    {
        StringListDataStore.SetCurrentValueIndex(MatchTypeName, 0);
    }
    Class'EvilGame.UTUIDataStore_MenuItems'.static.GetAllResourceDataProviders(Class'EvilGame.UTUIDataProvider_GameModeInfo', Providers);
    ValueIndex = -1;
    I = 0;
    J0xF7:

    // End:0x1A2 [Loop If]
    if(I < Providers.Length)
    {
        Provider = UTUIDataProvider_GameModeInfo(Providers[I]);
        // End:0x194
        if((Provider != none) && Provider.GameSearchClass == "AdvGameSearchCustom")
        {
            ValueIndex = I;
            // [Explicit Break]
            goto J0x1A2;
        }
        ++I;
        // [Loop Continue]
        goto J0xF7;
    }
    J0x1A2:

    // End:0x290
    if(ValueIndex != -1)
    {
        ValueIndex = SearchDataStore.FindSearchConfigurationIndex('AdvGameSearchCustom');
        // End:0x290
        if(ValueIndex != -1)
        {
            CustomSearch = AdvGameSearchCustom(SearchDataStore.GameSearchCfgList[ValueIndex].Search);
            CustomSearch.ResetFilters();
            SearchDataStore.SetCurrentByName('AdvGameSearchCustom', true);
        }
    }
    //return;    
}

function AdvGameSearchCommon GetGameSearchSettings()
{
    // End:0x39
    if(bLANSelected)
    {
        return AdvGameSearchCommon(SearchDataStore.GetCurrentGameSearch());        
    }
    else
    {
        return DedicatedPlayerMatchSearch;
    }
    //return ReturnValue;    
}

function RefreshServerList(optional int MaxResults = 50)
{
    local AdvGameSearchCommon GameSearch;
    local AdvUIManager UIManager;
    local int ValueIndex;

    ScriptTrace();
    // End:0x309
    if(!SearchDataStore.HasOutstandingQueries())
    {
        GameSearch = GetGameSearchSettings();
        GameSearch.MaxSearchResults = MaxResults;
        ValueIndex = ((bLANSelected) ? 0 : 1);
        switch(ValueIndex)
        {
            // End:0xE8
            case 0:
                GameSearch.bIsLanQuery = true;
                GameSearch.bUsesArbitration = false;
                // End:0x1A2
                break;
            // End:0x156
            case 2:
                // End:0x156
                if(Class'Engine.WorldInfo'.static.IsConsoleBuild(1))
                {
                    GameSearch.bIsLanQuery = false;
                    GameSearch.bUsesArbitration = true;
                    // End:0x1A2
                    break;
                }
            // End:0x19F
            case 1:
                GameSearch.bIsLanQuery = false;
                GameSearch.bUsesArbitration = false;
                // End:0x1A2
                break;
            // End:0xFFFF
            default:
                break;
        }
        SteamServerList.Length = 0;
        RebuildServerList();
        bSearch1 = false;
        bSearch2 = false;
        UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
        // End:0x236
        if(UIManager != none)
        {
            UIManager.OpenUpdatingScene(,,, false);
        }
        // End:0x2B4
        if(Class'Engine.WorldInfo'.static.IsConsoleBuild(1) || bLANSelected)
        {
            SubmitServerListQuery(Class'Engine.UIInteraction'.static.GetPlayerIndex(GetLP().ControllerId));            
        }
        else
        {
            SubmitServerListQuery(Class'Engine.UIInteraction'.static.GetPlayerIndex(GetLP().ControllerId));
            LookForLoobbies();
        }        
    }
    else
    {
        CancelQuery(4);
    }
    //return;    
}

function SetPartialSearch(int NeedOrWant, AdvGameSearchCommon PartialSearch)
{
    local int PlaylistManagerVersion;
    local OnlinePlaylistManager PlaylistMan;

    // End:0x166
    if(PartialSearch != none)
    {
        PlaylistMan = OnlinePlaylistManager(OnlineSub.GetNamedInterface('PlaylistManager'));
        // End:0x84
        if(PlaylistMan != none)
        {
            PlaylistManagerVersion = PlaylistMan.VersionNumber;            
        }
        else
        {
            PlaylistManagerVersion = 1;
        }
        PartialSearch.SetIntProperty(268435458, PlaylistManagerVersion);
        PartialSearch.SetIntProperty(268435457, UnofficialDedicatedPlaylistId);
        PartialSearch.SetStringSettingValue(32779, 1);
        PartialSearch.SetStringSettingValue(0, 7);
        PartialSearch.Query.ValueIndex = 8;
    }
    PartialSearch.bUsesArbitration = false;
    PartialSearch.SetStringSettingValue(3, 3);
    PartialSearch.SetStringSettingValue(4, 3);
    PartialSearch.SetStringSettingValue(5, 3);
    PartialSearch.SetStringSettingValue(6, 3);
    PartialSearch.SetStringSettingValue(7, 3);
    DumpGameSearchData(PartialSearch);
    OnlineSub.DumpGameSearch(PartialSearch);
    //return;    
}

function SubmitServerListQuery(int PlayerIndex)
{
    local AdvGameSearchCommon GameSearch;

    // End:0x11
    if(!bInitFinished)
    {
        return;
    }
    LatestDedicatedSearchLenght = 0;
    LatestLanSearchLenght = 0;
    GameSearch = GetGameSearchSettings();
    // End:0x5E
    if(!bLANSelected)
    {
        SetPartialSearch(0, GameSearch);
    }
    DumpGameSearchData(GameSearch);
    GameInterface.AddFindOnlineGamesCompleteDelegate(OnFindOnlineGamesCompleteDelegate);
    // End:0x12B
    if(!GameInterface.FindOnlineGames(byte(Class'Engine.UIInteraction'.static.GetPlayerControllerId(PlayerIndex)), GameSearch))
    {
        GameInterface.ClearFindOnlineGamesCompleteDelegate(OnFindOnlineGamesCompleteDelegate);
    }
    //return;    
}

function UpdateGameTypeDropdownDataProvider()
{
    local int I, ListCounter, TypesCount, idxSV;
    local GFxObject DataProvider, TempObj;
    local UIDataStore_Registry Registry;

    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    ListCounter = 0;
    DataProvider = CreateArray();
    TempObj = CreateObject("Object");
    TempObj.SetString("label", AllGamesString);
    DataProvider.SetElementObject(ListCounter++, TempObj);
    idxSV = Class'AdvUIDataStore_GameResource'.static.GetGameTypeProviderIndex(3);
    TypesCount = Class'AdvUIDataStore_GameResource'.static.GetGameTypeProvidersCount();
    I = 0;
    J0x13B:

    // End:0x276 [Loop If]
    if(I < TypesCount)
    {
        // End:0x268
        if(I != idxSV)
        {
            TempObj = CreateObject("Object");
            TempObj.SetString("label", Class'AdvUIDataStore_GameResource'.static.GetGameTypeProviderUsingProviderIndex(I).GameName);
            GameTypeNames.AddItem(Class'AdvUIDataStore_GameResource'.static.GetGameTypeProviderUsingProviderIndex(I).ClassName);            
            DataProvider.SetElementObject(ListCounter++, TempObj);
        }
        ++I;
        // [Loop Continue]
        goto J0x13B;
    }
    GameTypeDropdown.SetObject("dataProvider", DataProvider);
    GameTypeDataProvider = GameTypeDropdown.GetObject("dataProvider");
    Registry.SetData("SelectedGameModePrefix", Class'AdvUIDataStore_GameResource'.static.GetGameTypeProviderUsingProviderIndex(0).MapPrefix);
    Registry.SetData("SelectedGameMode", Class'AdvUIDataStore_GameResource'.static.GetGameTypeProviderUsingProviderIndex(0).ClassName);
    //return;    
}

function UpdateGameTypeDropdownDataProviderSV()
{
    local int ListCounter, idxSV;
    local GFxObject DataProvider, TempObj;
    local UIDataStore_Registry Registry;

    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    ListCounter = 0;
    DataProvider = CreateArray();
    idxSV = Class'AdvUIDataStore_GameResource'.static.GetGameTypeProviderIndex(3);
    // End:0x198
    if(idxSV != -1)
    {
        TempObj = CreateObject("Object");
        TempObj.SetString("label", Class'AdvUIDataStore_GameResource'.static.GetGameTypeProviderUsingProviderIndex(idxSV).GameName);
        GameTypeNames.AddItem(Class'AdvUIDataStore_GameResource'.static.GetGameTypeProviderUsingProviderIndex(idxSV).ClassName);        
        DataProvider.SetElementObject(ListCounter++, TempObj);
    }
    GameTypeDropdown.SetObject("dataProvider", DataProvider);
    GameTypeDataProvider = GameTypeDropdown.GetObject("dataProvider");
    Registry.SetData("SelectedGameModePrefix", Class'AdvUIDataStore_GameResource'.static.GetGameTypeProviderUsingProviderIndex(0).MapPrefix);
    Registry.SetData("SelectedGameMode", Class'AdvUIDataStore_GameResource'.static.GetGameTypeProviderUsingProviderIndex(0).ClassName);
    //return;    
}

function UpdateListDataProvider()
{
    // End:0x40
    if(Class'Engine.WorldInfo'.static.IsConsoleBuild(1) || bLANSelected)
    {
        UpdateListDataProviderLAN();        
    }
    else
    {
        UpdateListDataProviderDedicated();
    }
    //return;    
}

static function string GetLocalizedGameType(string GameType)
{
    // End:0x3B
    if(InStr(GameType, "CTF") >= 0)
    {
        return Class'AdvGFxUI_Menu_Leaderboard'.default.TitleCTF;        
    }
    else
    {
        // End:0x81
        if(InStr(GameType, "TeamDeathmatch") >= 0)
        {
            return Class'AdvGFxUI_Menu_Leaderboard'.default.TitleTDM;            
        }
        else
        {
            // End:0xC1
            if(InStr(GameType, "Survival") >= 0)
            {
                return Class'AdvGFxUI_Menu_Leaderboard'.default.TitleSV;                
            }
            else
            {
                // End:0x103
                if(InStr(GameType, "Deathmatch") >= 0)
                {
                    return Class'AdvGFxUI_Menu_Leaderboard'.default.TitleDM;                    
                }
                else
                {
                    // End:0x14B
                    if(InStr(GameType, "TeamTreasureHunt") >= 0)
                    {
                        return Class'AdvGFxUI_Menu_Leaderboard'.default.TitleTTH;                        
                    }
                    else
                    {
                        // End:0x18F
                        if(InStr(GameType, "TreasureHunt") >= 0)
                        {
                            return Class'AdvGFxUI_Menu_Leaderboard'.default.TitleTH;                            
                        }
                        else
                        {
                            // End:0x1CC
                            if(InStr(GameType, "Standing") >= 0)
                            {
                                return Class'AdvGFxUI_Menu_Leaderboard'.default.TitleLMS;
                            }
                        }
                    }
                }
            }
        }
    }
    return "none";
    //return ReturnValue;    
}

function string GetMapFriendlyName(string Map)
{
    local int I, P, StartIndex, EndIndex;
    local array<string> LocPieces;
    local array<UDKUIResourceDataProvider> LocalMapList;

    Class'EvilGame.UTUIDataStore_MenuItems'.static.GetAllResourceDataProviders(Class'EvilGame.UTUIDataProvider_MapInfo', LocalMapList);
    I = 0;
    J0x3C:

    // End:0x240 [Loop If]
    if(I < LocalMapList.Length)
    {
        // End:0x232
        if(UTUIDataProvider_MapInfo(LocalMapList[I]).MapName ~= Map)
        {
            StartIndex = InStr(Caps(UTUIDataProvider_MapInfo(LocalMapList[I]).FriendlyName), "<STRINGS:");
            // End:0xF6
            if(StartIndex == -1)
            {
                // [Explicit Break]
                goto J0x240;
            }
            Map = Right(UTUIDataProvider_MapInfo(LocalMapList[I]).FriendlyName, (Len(UTUIDataProvider_MapInfo(LocalMapList[I]).FriendlyName) - StartIndex) - 9);
            EndIndex = InStr(Map, ">");
            // End:0x228
            if(EndIndex != -1)
            {
                Map = Left(Map, EndIndex);
                ParseStringIntoArray(Map, LocPieces, ".", true);
                // End:0x228
                if(LocPieces.Length >= 3)
                {
                    Map = Localize(LocPieces[1], LocPieces[2], LocPieces[0]);
                }
            }
            return Map;
        }
        I++;
        // [Loop Continue]
        goto J0x3C;
    }
    J0x240:

    P = InStr(Map, "-");
    // End:0x29C
    if(P > -1)
    {
        Map = Right(Map, (Len(Map) - P) - 1);
    }
    P = InStr(Map, "-");
    // End:0x2F8
    if(P > -1)
    {
        Map = Right(Map, (Len(Map) - P) - 1);
    }
    Map = Left(Map, Len(Map) - 2);
    return Map;
    //return ReturnValue;    
}

function string GetGame2Search(int SelectedIndex)
{
    local string game2search;

    // End:0x3C
    if(int(GetMenuGame().MultiGameModeSelected) == int(3))
    {
        return "AdvGameSurvival";
    }
    switch(SelectedIndex - 1)
    {
        // End:0x76
        case 0:
            game2search = "AdvGameDeathmatch";
            // End:0x159
            break;
        // End:0x9E
        case 1:
            game2search = "AdvGameTeamDeathmatch";
            // End:0x159
            break;
        // End:0xBC
        case 2:
            game2search = "AdvGameCTF";
            // End:0x159
            break;
        // End:0xE3
        case 3:
            game2search = "AdvGameTreasureHunt";
            // End:0x159
            break;
        // End:0x10E
        case 4:
            game2search = "AdvGameTeamTreasureHunt";
            // End:0x159
            break;
        // End:0x138
        case 5:
            game2search = "AdvGameLastMenStanding";
            // End:0x159
            break;
        // End:0x13D
        case 7:
        // End:0xFFFF
        default:
            game2search = "AdvGameAll";
            // End:0x159
            break;
            break;
    }
    return game2search;
    //return ReturnValue;    
}

function UpdateListDataProviderLAN()
{
    local byte I;
    local OnlineGameSearch LatestGameSearch;
    local int Index, passwd, SelectedIndex;
    local string txt, GameType, game2search, PropertyValue;

    ServerInfoList.Length = 0;
    LatestGameSearch = SearchDataStore.GetCurrentGameSearch();
    // End:0xC64
    if(LatestGameSearch != none)
    {
        // End:0x6D
        if(ForceSelectedIndex > -1)
        {
            SelectedIndex = ForceSelectedIndex;            
        }
        else
        {
            SelectedIndex = int(GameTypeDropdown.GetFloat("selectedIndex")) - 1;
        }
        game2search = GetGame2Search(SelectedIndex);
        LatestSearchLenght = LatestGameSearch.Results.Length;
        Index = 0;
        I = byte(LatestLanSearchLenght);
        J0x110:

        // End:0xC22 [Loop If]
        if(int(I) < LatestGameSearch.Results.Length)
        {
            GameType = LatestGameSearch.Results[int(I)].GameSettings.GetPropertyAsStringByName('CustomGameMode');
            // End:0x1F2
            if((int(GetMenuGame().MultiGameModeSelected) != int(3)) && InStr(GameType, "Survival") >= 0)
            {                
            }
            else
            {
                // End:0xC14
                if(LatestGameSearch.Results[int(I)].GameSettings.bIsLanMatch && (game2search == "AdvGameAll") || InStr(GameType, game2search) >= 0)
                {
                    OnlineSub.DumpGameSettings(LatestGameSearch.Results[int(I)].GameSettings);
                    Index = SteamServerList.Find('ServerName', AdvGameSettingsCommon(LatestGameSearch.Results[int(I)].GameSettings).OwningPlayerName);                    
                    // End:0x37E
                    if(Index >= 0)
                    {
                        SteamServerList.Remove(Index, 1);                        
                    }
                    GameType = GetLocalizedGameType(GameType);
                    LatestGameSearch.Results[int(I)].GameSettings.GetStringProperty(1073741825, PropertyValue);
                    txt = ((LatestGameSearch.Results[int(I)].GameSettings.OwningPlayerName != "") ? LatestGameSearch.Results[int(I)].GameSettings.OwningPlayerName : Localize("AdvGFxUI_Menu_MultiHost", "ServerNameLabelString", "ADVGame"));                    
                    txt $= ((("    " $ GameType) $ "    ") $ PropertyValue);                    
                    txt $= ((("    " $ string(LatestGameSearch.Results[int(I)].GameSettings.PingInMs)) $ "    ") $ string(LatestGameSearch.Results[int(I)].GameSettings.NumPublicConnections - LatestGameSearch.Results[int(I)].GameSettings.NumOpenPublicConnections));                    
                    txt $= ("/" $ string(LatestGameSearch.Results[int(I)].GameSettings.NumPublicConnections));
                    SteamServerList.Add(1);                    
                    Index = SteamServerList.Length - 1;
                    SteamServerList[Index].Label = txt;
                    SteamServerList[Index].ServerName = ((LatestGameSearch.Results[int(I)].GameSettings.OwningPlayerName != "") ? LatestGameSearch.Results[int(I)].GameSettings.OwningPlayerName : Localize("AdvGFxUI_Menu_MultiHost", "ServerNameLabelString", "ADVGame"));
                    SteamServerList[Index].Players = (("    " $ string(LatestGameSearch.Results[int(I)].GameSettings.NumPublicConnections - LatestGameSearch.Results[int(I)].GameSettings.NumOpenPublicConnections)) $ "/") $ string(LatestGameSearch.Results[int(I)].GameSettings.NumPublicConnections);
                    SteamServerList[Index].SteamServerId = AdvGameSettingsCommon(LatestGameSearch.Results[int(I)].GameSettings).SteamServerId;
                    SteamServerList[Index].GameType = GameType;
                    SteamServerList[Index].Ping = LatestGameSearch.Results[int(I)].GameSettings.PingInMs;
                    SteamServerList[Index].MapName = PropertyValue;
                    SteamServerList[Index].FriendlyMapName = GetMapFriendlyName(PropertyValue);
                    SteamServerList[Index].GameToJoin = LatestGameSearch.Results[int(I)];
                    // End:0xBEB
                    if(!AdvGameSettingsCommon(LatestGameSearch.Results[int(I)].GameSettings).GetStringSettingValue(37, passwd) || passwd == 1)
                    {
                        SteamServerList[Index].bUsePassword = true;                        
                    }
                    else
                    {
                        SteamServerList[Index].bUsePassword = false;
                    }
                }
            }
            I++;
            // [Loop Continue]
            goto J0x110;
        }
        bSearch2 = true;
        RebuildServerList();
        LatestLanSearchLenght = LatestGameSearch.Results.Length;        
    }
    //return;    
}

function UpdateListDataProviderLobby()
{
    local byte I;
    local int Index, SelectedIndex;
    local string txt, SteamId, GameType, game2search, PlayerNick, locGameType;

    ServerInfoList.Length = 0;
    PlayerNick = OnlineSubsystemSteamworks(OnlineSub).GetPlayerNickname(byte(GetLP().ControllerId));
    LatestSearchLenght = Lobbies.Length;
    // End:0x9C
    if(ForceSelectedIndex > -1)
    {
        SelectedIndex = ForceSelectedIndex;        
    }
    else
    {
        SelectedIndex = int(GameTypeDropdown.GetFloat("selectedIndex")) - 1;
    }
    game2search = GetGame2Search(SelectedIndex);
    I = 0;
    J0x102:

    // End:0x901 [Loop If]
    if(int(I) < Lobbies.Length)
    {
        GameType = Class'AdvPlayerController'.static.GetLobbyData(Lobbies[int(I)], "GAMEMODE");
        // End:0x1B1
        if((int(GetMenuGame().MultiGameModeSelected) != int(3)) && InStr(GameType, "Survival") >= 0)
        {            
        }
        else
        {
            // End:0x8F3
            if((Class'AdvPlayerController'.static.GetLobbyData(Lobbies[int(I)], "GAMETYPE") ~= "-2") && (game2search == "AdvGameAll") || InStr(GameType, game2search) >= 0)
            {
                locGameType = GetLocalizedGameType(Class'AdvPlayerController'.static.GetLobbyData(Lobbies[int(I)], "GAMEMODE"));
                // End:0x2EC
                if((locGameType == "none") || Class'AdvPlayerController'.static.GetLobbyData(Lobbies[int(I)], "SERVERNAME") == PlayerNick)
                {                    
                }
                else
                {
                    SteamId = Class'AdvPlayerController'.static.GetLobbyData(Lobbies[int(I)], "STEAMID");
                    // End:0x8F0
                    if(SteamServerList.Find('SteamServerId', SteamId) < )
                    {                        
                        txt = OnlineSub.UniqueNetIdToStringDEC(AdvPlayerController(GetPC()).LobbyUID);
                        // End:0x3F7
                        if(Class'AdvPlayerController'.static.GetLobbyData(Lobbies[int(I)], "STEAMID") == txt)
                        {
                            // [Explicit Continue]
                            goto J0x8F3;
                        }
                        txt = Class'AdvPlayerController'.static.GetLobbyData(Lobbies[int(I)], "SERVERNAME");
                        txt = ((txt != "") ? txt : Localize("AdvGFxUI_Menu_MultiHost", "ServerNameLabelString", "ADVGame"));                        
                        txt $= ((("     " $ locGameType) $ "     ") $ (GetMapFriendlyName(Class'AdvPlayerController'.static.GetLobbyData(Lobbies[int(I)], "MAPNAME"))));                        
                        txt $= ("     N/A     " $ Class'AdvPlayerController'.static.GetLobbyData(Lobbies[int(I)], "PLAYERS"));                        
                        txt $= ((Class'AdvPlayerController'.static.GetLobbyData(Lobbies[int(I)], "USEPASSWORD") == "1") ? "  (*)" : "");
                        SteamServerList.Add(1);                        
                        Index = SteamServerList.Length - 1;
                        SteamServerList[Index].Label = txt;
                        SteamServerList[Index].ServerName = Class'AdvPlayerController'.static.GetLobbyData(Lobbies[int(I)], "SERVERNAME");
                        SteamServerList[Index].Players = Class'AdvPlayerController'.static.GetLobbyData(Lobbies[int(I)], "PLAYERS");
                        SteamServerList[Index].GameType = locGameType;
                        SteamServerList[Index].SteamServerId = SteamId;
                        SteamServerList[Index].Ping = 0;
                        SteamServerList[Index].MapName = Class'AdvPlayerController'.static.GetLobbyData(Lobbies[int(I)], "MAPNAME");
                        SteamServerList[Index].FriendlyMapName = GetMapFriendlyName(SteamServerList[Index].MapName);
                        // End:0x8C4
                        if(Class'AdvPlayerController'.static.GetLobbyData(Lobbies[int(I)], "USEPASSWORD") == "1")
                        {
                            SteamServerList[Index].bUsePassword = true;                            
                        }
                        else
                        {
                            SteamServerList[Index].bUsePassword = false;
                        }                        
                    }                    
                }
            }
        }
        J0x8F3:

        I++;
        // [Loop Continue]
        goto J0x102;
    }
    bSearch1 = true;
    RebuildServerList();
    //return;    
}

function UpdateListDataProviderDedicated()
{
    local int I;
    local OnlineGameSearch LatestGameSearch;
    local int Index, passwd, SelectedIndex;
    local string txt, GameType, locGameType, game2search, PlayerNick, PropertyValue;

    local int AdvertisedMapId;

    ServerInfoList.Length = 0;
    LatestGameSearch = GetGameSearchSettings();
    // End:0xC9C
    if(LatestGameSearch != none)
    {
        // End:0x58
        if(ForceSelectedIndex > -1)
        {
            SelectedIndex = ForceSelectedIndex;            
        }
        else
        {
            SelectedIndex = int(GameTypeDropdown.GetFloat("selectedIndex"));
        }
        game2search = GetGame2Search(SelectedIndex);
        PlayerNick = OnlineSubsystemSteamworks(OnlineSub).GetPlayerNickname(byte(GetLP().ControllerId));
        LatestSearchLenght = LatestGameSearch.Results.Length;
        Index = 0;
        I = LatestDedicatedSearchLenght;
        J0x149:

        // End:0xC5A [Loop If]
        if(I < LatestGameSearch.Results.Length)
        {
            GameType = LatestGameSearch.Results[I].GameSettings.GetPropertyAsStringByName('CustomGameMode');
            locGameType = GetLocalizedGameType(GameType);
            // End:0x26E
            if(LatestGameSearch.Results[I].GameSettings.GetStringProperty(268435709, PropertyValue))
            {
                AdvertisedMapId = int(PropertyValue);
            }
            // End:0x2FE
            if(((locGameType == "none") || LatestGameSearch.Results[I].GameSettings.OwningPlayerName == PlayerNick) || AdvertisedMapId != UnofficialDedicatedPlaylistId)
            {                
            }
            else
            {
                // End:0xC4C
                if((game2search == "AdvGameAll") || InStr(GameType, game2search) >= 0)
                {
                    Index = SteamServerList.Find('SteamServerId', AdvGameSettingsCommon(LatestGameSearch.Results[I].GameSettings).SteamServerId);                    
                    // End:0x3D4
                    if(Index >= 0)
                    {
                        SteamServerList.Remove(Index, 1);                        
                    }
                    GameType = GetLocalizedGameType(GameType);
                    LatestGameSearch.Results[I].GameSettings.GetStringProperty(1073741825, PropertyValue);
                    txt = ((LatestGameSearch.Results[I].GameSettings.OwningPlayerName != "") ? LatestGameSearch.Results[I].GameSettings.OwningPlayerName : Localize("AdvGFxUI_Menu_MultiHost", "ServerNameLabelString", "ADVGame"));                    
                    txt $= ((("    " $ GameType) $ "    ") $ PropertyValue);                    
                    txt $= ((("    " $ string(LatestGameSearch.Results[I].GameSettings.PingInMs)) $ "    ") $ string(LatestGameSearch.Results[I].GameSettings.NumPublicConnections - LatestGameSearch.Results[I].GameSettings.NumOpenPublicConnections));                    
                    txt $= (" / " $ string(LatestGameSearch.Results[I].GameSettings.NumPublicConnections));
                    SteamServerList.Add(1);                    
                    Index = SteamServerList.Length - 1;
                    SteamServerList[Index].Label = txt;
                    SteamServerList[Index].ServerName = ((LatestGameSearch.Results[I].GameSettings.OwningPlayerName != "") ? LatestGameSearch.Results[I].GameSettings.OwningPlayerName : Localize("AdvGFxUI_Menu_MultiHost", "ServerNameLabelString", "ADVGame"));
                    SteamServerList[Index].Players = (("    " $ string(LatestGameSearch.Results[I].GameSettings.NumPublicConnections - LatestGameSearch.Results[I].GameSettings.NumOpenPublicConnections)) $ "/") $ string(LatestGameSearch.Results[I].GameSettings.NumPublicConnections);
                    SteamServerList[Index].SteamServerId = AdvGameSettingsCommon(LatestGameSearch.Results[I].GameSettings).SteamServerId;
                    SteamServerList[Index].GameType = GameType;
                    SteamServerList[Index].Ping = LatestGameSearch.Results[I].GameSettings.PingInMs;
                    SteamServerList[Index].MapName = PropertyValue;
                    SteamServerList[Index].FriendlyMapName = GetMapFriendlyName(PropertyValue);
                    SteamServerList[Index].GameToJoin = LatestGameSearch.Results[I];
                    // End:0xC23
                    if(!AdvGameSettingsCommon(LatestGameSearch.Results[I].GameSettings).GetStringSettingValue(37, passwd) || passwd == 1)
                    {
                        SteamServerList[Index].bUsePassword = true;                        
                    }
                    else
                    {
                        SteamServerList[Index].bUsePassword = false;
                    }
                }
            }
            I++;
            // [Loop Continue]
            goto J0x149;
        }
        bSearch2 = true;
        RebuildServerList();
        LatestDedicatedSearchLenght = LatestGameSearch.Results.Length;        
    }
    //return;    
}

function SetRowActive(int I, bool bActive)
{
    // End:0xA8
    if(I < 11)
    {
        ServersList[I].ServerListBtn.SetBool("disabled", !bActive);
        ServersList[I].ServerListRow.SetVisible(bActive);
    }
    //return;    
}

function RebuildServerList()
{
    local byte I;
    local AdvUIManager UIManager;

    ServerInfoList.Length = 0;
    I = 0;
    J0x18:

    // End:0x380 [Loop If]
    if(int(I) < 11)
    {
        // End:0x35C
        if(int(I) < (SteamServerList.Length - CurrentRowShift))
        {
            SetRowActive(int(I), true);
            ServersList[int(I)].GameSearchIndex = int(I) + CurrentRowShift;
            ServersList[int(I)].ServerListBtn.SetString("label", SteamServerList[int(I) + CurrentRowShift].ServerName);
            ServersList[int(I)].ServerListLockMC.SetVisible(SteamServerList[int(I) + CurrentRowShift].bUsePassword);
            ServersList[int(I)].ServerListGametypeTF.SetText(SteamServerList[int(I) + CurrentRowShift].GameType);
            ServersList[int(I)].ServerListMapTF.SetText(SteamServerList[int(I) + CurrentRowShift].FriendlyMapName);
            ServersList[int(I)].ServerListPlayersTF.SetText(SteamServerList[int(I) + CurrentRowShift].Players);
            ServersList[int(I)].ServerListPingTF.SetText(string(SteamServerList[int(I) + CurrentRowShift].Ping));            
        }
        else
        {
            SetRowActive(int(I), false);
        }
        I++;
        // [Loop Continue]
        goto J0x18;
    }
    // End:0x419
    if(LastSelectedSlot < (SteamServerList.Length - CurrentRowShift))
    {
        ServersList[LastSelectedSlot].ServerListBtn.SetBool("focused", true);
        LastSelectedIndex = ServersList[LastSelectedSlot].GameSearchIndex;
    }
    UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0x47A
    if(UIManager != none)
    {
        UIManager.CloseUpdatingScene(false);
    }
    //return;    
}

function int GetPlayerIndex()
{
    local int PlayerIndex;
    local LocalPlayer LP;

    LP = GetLP();
    // End:0x6A
    if(LP != none)
    {
        PlayerIndex = Class'Engine.UIInteraction'.static.GetPlayerIndex(LP.ControllerId);
    }
    return PlayerIndex;
    //return ReturnValue;    
}

function int GetPlayerControllerId(int PlayerIndex)
{
    return Class'Engine.UIInteraction'.static.GetPlayerControllerId(PlayerIndex);
    //return ReturnValue;    
}

function Cleanup()
{
    local AdvGameMenu MenuGame;
    local AdvUIManager UIManager;

    UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0x61
    if(UIManager != none)
    {
        UIManager.CloseUpdatingScene(false);
    }
    // End:0x134
    if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
    {
        GameInterface.AddCancelFindOnlineGamesCompleteDelegate(OnCancelSearchComplete);
        GameInterface.CancelFindOnlineGames();
        GameInterface.ClearJoinOnlineGameCompleteDelegate(OnJoinGameComplete);
        GameInterface.ClearFindOnlineGamesCompleteDelegate(OnFindOnlineGamesCompleteDelegate);
    }
    // End:0x173
    if(LobbyInterface != none)
    {
        LobbyInterface.ClearFindLobbiesCompleteDelegate(OnFindLobbiesComplete);
    }
    // End:0x1A1
    if(SearchDataStore != none)
    {
        SearchDataStore.ClearAllSearchResults();
    }
    MenuGame = AdvGameMenu(Class'Engine.WorldInfo'.static.GetWorldInfo().Game);
    // End:0x216
    if(MenuGame != none)
    {
        MenuGame.CleanupGameSearchRefreshing();
    }
    //return;    
}

function CancelQuery(optional AdvGFxUI_Menu_MultiServers.EQueryCompletionAction DesiredCancelAction = 1)
{
    // End:0xF4
    if(int(QueryCompletionAction) == int(0))
    {
        QueryCompletionAction = DesiredCancelAction;
        // End:0xB5
        if((SearchDataStore == none) || SearchDataStore.HasOutstandingQueries())
        {
            GameInterface.AddCancelFindOnlineGamesCompleteDelegate(OnCancelSearchComplete);
            GameInterface.CancelFindOnlineGames();            
        }
        else
        {
            // End:0xE5
            if(SearchDataStore.HasExistingSearchResults())
            {
                OnCancelSearchComplete(true);                
            }
            else
            {
                QueryCompletionAction = 0;
            }
        }        
    }
    //return;    
}

function OnCancelSearchComplete(bool bWasSuccessful)
{
    local AdvGFxUI_Menu_MultiServers.EQueryCompletionAction CurrentAction;

    GameInterface.ClearCancelFindOnlineGamesCompleteDelegate(OnCancelSearchComplete);
    // End:0x99
    if(bWasSuccessful)
    {
        CurrentAction = QueryCompletionAction;
        QueryCompletionAction = 0;
        switch(CurrentAction)
        {
            // End:0x78
            case 2:
                // End:0x99
                break;
            // End:0x80
            case 3:
                // End:0x99
                break;
            // End:0x93
            case 4:
                RefreshServerList();
                // End:0x99
                break;
            // End:0xFFFF
            default:
                // End:0x99
                break;
                break;
        }
    }
    //return;    
}

function OnFindOnlineGamesCompleteDelegate(bool bWasSuccessful)
{
    local bool bSearchCompleted;

    bSearchCompleted = !GetGameSearchSettings().bIsSearchInProgress;
    // End:0x81
    if(bSearchCompleted)
    {
        GameInterface.ClearFindOnlineGamesCompleteDelegate(OnFindOnlineGamesCompleteDelegate);
        LastSelectedSlot = 0;
        CurrentRowShift = 0;
    }
    UpdateListDataProvider();
    //return;    
}

function OnServerConnectionClose(Player ServerConnection)
{
    AuthInterface.ClearServerConnectionCloseDelegate(OnServerConnectionClose);
    //return;    
}

function OnJoinGameComplete(name SessionName, bool bSuccessful)
{
    local OnlineGameSettings gSettings;
    local string URL, pwd;

    // End:0x1EF
    if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
    {
        GameInterface.ClearJoinOnlineGameCompleteDelegate(OnJoinGameComplete);
        // End:0x1B9
        if(bSuccessful)
        {
            CloseOnJoin();
            Cleanup();
            // End:0x1B6
            if(GameInterface.GetResolvedConnectString('Game', URL))
            {
                gSettings = GameInterface.GetGameSettings('Game');
                // End:0x117
                if(gSettings != none)
                {
                    pwd = gSettings.GetPropertyAsString(1073741827);
                }
                // End:0x153
                if(pwd != "")
                {                    
                    URL $= ("?Password=" $ pwd);
                }
                URL = "open " $ URL;
                // End:0x1A3
                if(bSpectateSelected)
                {                    
                    URL $= "?SpectatorOnly=1";
                }
                ConsoleCommand(URL);
            }            
        }
        else
        {
            GameInterface.DestroyOnlineGame('Game');
            ShowContentErrorMsg();
        }        
    }
    else
    {
        ShowContentErrorMsg();
    }
    //return;    
}

function SetGameSearch()
{
    local int I, SelectedIndex;

    // End:0x29
    if(ForceSelectedIndex > -1)
    {
        SelectedIndex = ForceSelectedIndex;        
    }
    else
    {
        SelectedIndex = 7;
    }
    switch(SelectedIndex)
    {
        // End:0x59
        case 7:
            SearchAllGames();
            return;
        // End:0x92
        case 0:
            I = SearchDataStore.FindSearchConfigurationIndex('AdvGameSearchDeathmatch');
            // End:0x1F0
            break;
        // End:0xCB
        case 1:
            I = SearchDataStore.FindSearchConfigurationIndex('AdvGameSearchTeamDeathmatch');
            // End:0x1F0
            break;
        // End:0x105
        case 2:
            I = SearchDataStore.FindSearchConfigurationIndex('AdvGameSearchCTF');
            // End:0x1F0
            break;
        // End:0x13F
        case 4:
            I = SearchDataStore.FindSearchConfigurationIndex('AdvGameSearchTreasureHunt');
            // End:0x1F0
            break;
        // End:0x179
        case 6:
            I = SearchDataStore.FindSearchConfigurationIndex('AdvGameSearchTeamTreasureHunt');
            // End:0x1F0
            break;
        // End:0x1B3
        case 5:
            I = SearchDataStore.FindSearchConfigurationIndex('AdvGameSearchLastManStanding');
            // End:0x1F0
            break;
        // End:0x1ED
        case 3:
            I = SearchDataStore.FindSearchConfigurationIndex('AdvGameSearchSurvival');
            // End:0x1F0
            break;
        // End:0xFFFF
        default:
            break;
    }
    // End:0x22F
    if(I != -1)
    {
        SearchDataStore.SetCurrentByIndex(I, true);        
    }
    //return;    
}

function OnGameTypeDropdownChange(EventData ev)
{
    SetGameSearch();
    RefreshServerList();
    //return;    
}

function OnLANInternetSelect(EventData ev)
{
    local name MatchTypeName;
    local DataStoreClient DSClient;

    bLANSelected = bool(InternetLANDropdown.GetFloat("selectedIndex"));
    MatchTypeName = ((Class'Engine.WorldInfo'.static.IsConsoleBuild(1)) ? 'ServerType360' : 'ServerType');
    DSClient = Class'Engine.UIInteraction'.static.GetDataStoreClient();
    StringListDataStore = UTUIDataStore_StringList(DSClient.FindDataStore('UTStringList'));
    StringListDataStore.SetCurrentValueIndex(MatchTypeName, ((bLANSelected) ? 0 : 1));
    SetGameSearch();
    RefreshServerList();
    //return;    
}

function OnSpectateSelect(EventData ev)
{
    //return;    
}

function OnServerFocus(int Index)
{
    LastSelectedSlot = Index;
    LastSelectedIndex = ServersList[Index].GameSearchIndex;
    //return;    
}

function OnServerSelect(int Index)
{
    // End:0x15A
    if((LatestSearchLenght > 0) && LatestSearchLenght > LastSelectedIndex)
    {
        // End:0x9D
        if(GetPC().WorldInfo.IsConsoleBuild(0) || AdvPlayerController(GetPC()).IsPCGamepadMode())
        {
            TryToJoin();            
        }
        else
        {
            // End:0x109
            if((LastClickIndex == Index) && (GetPC().WorldInfo.RealTimeSeconds - LastClickTime) < 0.3000000)
            {
                TryToJoin();
            }
            LastClickIndex = Index;
            LastClickTime = GetPC().WorldInfo.RealTimeSeconds;
        }
    }
    //return;    
}

function ButtonLabelOn1(EventData ev)
{
    SteamServerList.Sort(SortByServer);    
    RebuildServerList();
    bServerSort = !bServerSort;
    //return;    
}

function ButtonLabelOn2(EventData ev)
{
    SteamServerList.Sort(SortByGame);    
    RebuildServerList();
    bGameSort = !bGameSort;
    //return;    
}

function ButtonLabelOn3(EventData ev)
{
    SteamServerList.Sort(SortByMap);    
    RebuildServerList();
    bMapSort = !bMapSort;
    //return;    
}

function ButtonLabelOn4(EventData ev)
{
    SteamServerList.Sort(SortByPlayers);    
    RebuildServerList();
    bPlayersSort = !bPlayersSort;
    //return;    
}

function ButtonLabelOn5(EventData ev)
{
    SteamServerList.Sort(SortByPing);    
    RebuildServerList();
    bPingSort = !bPingSort;
    //return;    
}

delegate int SortByServer(SteamServerData A, SteamServerData B)
{
    return ((bServerSort) ? ((A.ServerName > B.ServerName) ? -1 : 0) : ((A.ServerName < B.ServerName) ? -1 : 0));
    //return ReturnValue;    
}

delegate int SortByGame(SteamServerData A, SteamServerData B)
{
    return ((bGameSort) ? ((A.GameType > B.GameType) ? -1 : 0) : ((A.GameType < B.GameType) ? -1 : 0));
    //return ReturnValue;    
}

delegate int SortByMap(SteamServerData A, SteamServerData B)
{
    return ((bMapSort) ? ((A.MapName > B.MapName) ? -1 : 0) : ((A.MapName < B.MapName) ? -1 : 0));
    //return ReturnValue;    
}

delegate int SortByPlayers(SteamServerData A, SteamServerData B)
{
    return ((bPlayersSort) ? ((A.Players > B.Players) ? -1 : 0) : ((A.Players < B.Players) ? -1 : 0));
    //return ReturnValue;    
}

delegate int SortByPing(SteamServerData A, SteamServerData B)
{
    return ((bPingSort) ? ((A.Ping > B.Ping) ? -1 : 0) : ((A.Ping < B.Ping) ? -1 : 0));
    //return ReturnValue;    
}

function ArrowUpOn(EventData ev)
{
    bAutoShiftUp = true;
    //return;    
}

function ArrowUpOut(EventData ev)
{
    bAutoShiftUp = false;
    //return;    
}

function ArrowDownOn(EventData ev)
{
    bAutoShiftDown = true;
    //return;    
}

function ArrowDownOut(EventData ev)
{
    bAutoShiftDown = false;
    //return;    
}

function OnBack(EventData ev)
{
    Action = "back";
    PlayCloseAnimation();
    //return;    
}

function OnJoinBtn(EventData ev)
{
    // End:0x34
    if((SteamServerList.Length > 0) && SteamServerList.Length > LastSelectedIndex)
    {
        TryToJoin();
    }
    //return;    
}

function OnRefreshBtn(EventData ev)
{
    RefreshServerList();
    //return;    
}

function CloseOnJoin()
{
    Action = "join";
    PlayCloseAnimation();
    //return;    
}

final function ShowJoinErrorMsg()
{
    local AdvUIManager UIManager;
    local array<name> ButtonAliases;

    UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0x11C
    if(UIManager != none)
    {
        ButtonAliases.AddItem('GenericAccept');        
        UIManager.ShowUIMessage('ConnectionError', Localize("MessageBoxErrorStrings", "InviteJoinFailed_Title", "ADVGame"), Localize("AdvGFxUI_Menu_PregameLobby", "UnableToJoinGameString", "ADVGame"), ButtonAliases,,,,,, false, false);
    }
    //return;    
}

final function ShowConnectionErrorMsg()
{
    local AdvUIManager UIManager;
    local array<name> ButtonAliases;

    UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0x119
    if(UIManager != none)
    {
        ButtonAliases.AddItem('GenericAccept');        
        UIManager.ShowUIMessage('ConnectionError', Localize("AdvGFxUI_MPLobbyMsg", "ErrorTitle", "ADVGame"), Localize("AdvGFxUI_MPLobbyMsg", "ServerUnableToJoinMessage", "ADVGame"), ButtonAliases, None,,,,, false, false);
    }
    //return;    
}

final function ShowContentErrorMsg()
{
    local AdvUIManager UIManager;
    local array<name> ButtonAliases;

    UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0x120
    if(UIManager != none)
    {
        ButtonAliases.AddItem('GenericAccept');        
        UIManager.ShowUIMessage('ConnectionError', Localize("AdvGFxUI_PreGameLobby", "ContentMismatchTitle", "ADVGame"), Localize("AdvGFxUI_PreGameLobby", "JIPContentMismatch", "ADVGame"), ButtonAliases, None,,,,, false, false);
    }
    //return;    
}

function SearchAllGames()
{
    local int I;
    local AdvGameSearchCustom CustomSearch;

    I = SearchDataStore.FindSearchConfigurationIndex('AdvGameSearchCustom');
    // End:0xDE
    if(I != -1)
    {
        CustomSearch = AdvGameSearchCustom(SearchDataStore.GameSearchCfgList[I].Search);
        CustomSearch.ResetFilters();
        SearchDataStore.SetCurrentByName('AdvGameSearchCustom', true);        
    }
    //return;    
}

function OnCloseAnimationComplete()
{
    local bool bTransitionResult;

    switch(Action)
    {
        // End:0xA0
        case "back":
            // End:0x73
            if(int(GetMenuGame().MultiGameModeSelected) == int(3))
            {
                bTransitionResult = Frontend.OpenMultiSurvivalScreen();                
            }
            else
            {
                bTransitionResult = Frontend.OpenMultiMenuScreen();
            }
            // End:0xBD
            break;
        // End:0xB7
        case "join":
            Close(true);
            // End:0xBD
            break;
        // End:0xFFFF
        default:
            // End:0xBD
            break;
            break;
    }
    Cleanup();
    // End:0xF3
    if(bTransitionResult)
    {
        Frontend.CloseGameSearchScreen();
    }
    Action = "";
    //return;    
}

function TryToJoin()
{
    local AdvUIManager UIManager;
    local array<name> ButtonAliases;
    local string pwd;

    JoinBtn.SetBool("disabled", true);
    // End:0x46
    if(!bLANSelected)
    {
        JoinByLobby();        
    }
    else
    {
        // End:0x1F6
        if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
        {
            // End:0x1E9
            if(LastSelectedIndex >= 0)
            {
                GameToJoin = SteamServerList[LastSelectedIndex].GameToJoin;
                // End:0x1D2
                if(GameToJoin.GameSettings != none)
                {
                    pwd = GameToJoin.GameSettings.GetPropertyAsString(1073741827);
                    // End:0x1C4
                    if(pwd == "PWD")
                    {
                        UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
                        ButtonAliases.AddItem('GenericAccept');                        
                        UIManager.ShowPasswordBox('PasswordWindow', "Password", "", ButtonAliases, OnPasswordEnteredLAN, GetLP(),,,, false, false);
                        return;
                    }
                    JoinLanWorker();                    
                }
                else
                {
                    OnJoinGameComplete('Game', false);
                }                
            }
            else
            {
                ShowConnectionErrorMsg();
            }            
        }
        else
        {
            ShowConnectionErrorMsg();
        }
    }
    JoinBtn.SetBool("disabled", false);
    //return;    
}

function JoinLanWorker(optional string InServerPassword = "")
{
    GameInterface.AddDestroyOnlineGameCompleteDelegate(OnDestroyGameF51);
    GameInterface.DestroyOnlineGame(GetPC().PlayerReplicationInfo.SessionName);
    //return;    
}

function OnDestroyGameF51(name SessionName, bool bWasSuccessful)
{
    local string CustomMapName;

    GameInterface.ClearDestroyOnlineGameCompleteDelegate(OnDestroyGameF51);
    GameToJoin.GameSettings.SetStringProperty(1073741827, "");
    GameInterface.AddJoinOnlineGameCompleteDelegate(OnJoinGameComplete);
    GameToJoin.GameSettings.GetStringProperty(1073741825, CustomMapName);
    // End:0x12B
    if(Class'AdvPlayerController'.static.IsMenuMap(CustomMapName))
    {
        GetAdvPC().ClientShowJoinGameMovie(9);        
    }
    else
    {
        GetAdvPC().ClientShowJoinGameMovie(8);
    }
    AdvEngine(Class'AdvEngine'.static.GetEngine()).SetCheckMapLoading(true);
    // End:0x1CF
    if(!GameInterface.JoinOnlineGame(0, 'Game', GameToJoin))
    {
        ShowJoinErrorMsg();
    }
    //return;    
}

function bool AllowJoinServer()
{
    local bool bResult;

    bResult = true;
    // End:0x6C
    if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
    {
        // End:0x6C
        if((SearchDataStore != none) && SearchDataStore.HasOutstandingQueries())
        {
            bResult = false;
        }
    }
    return bResult;
    //return ReturnValue;    
}

function JoinByLobby()
{
    local bool bNeedPassword;
    local AdvUIManager UIManager;
    local array<name> ButtonAliases;

    // End:0x2B
    if((LastSelectedIndex >= SteamServerList.Length) || LastSelectedIndex < 0)
    {
        return;
    }
    GameInterface.DestroyOnlineGame('Game');
    JoinSteamID = SteamServerList[LastSelectedIndex].SteamServerId;
    bNeedPassword = SteamServerList[LastSelectedIndex].bUsePassword;
    // End:0x1A5
    if(bNeedPassword)
    {
        UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
        ButtonAliases.AddItem('GenericAccept');        
        UIManager.ShowPasswordBox('PasswordWindow', Localize("AdvGFxUI_Menu_MultiHost", "ServerPasswordString", "ADVGame"), "", ButtonAliases, OnPasswordEntered, GetLP(),,,, false, false);        
    }
    else
    {
        JoinLobbyWorker();
    }
    //return;    
}

function JoinLobbyWorker(optional string InServerPassword = "")
{
    local string URL;

    GetAdvPC().ClientShowJoinGameMovie(9);
    URL = "open steam." $ JoinSteamID;
    // End:0x86
    if(InServerPassword != "")
    {        
        URL $= ("?Password=" $ InServerPassword);
    }
    AdvEngine(Class'AdvEngine'.static.GetEngine()).SetCheckMapLoading(true);
    ConsoleCommand(URL);
    Cleanup();
    JoinSteamID = "";
    //return;    
}

function bool OnPasswordEntered(UIScene_PasswordBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    JoinLobbyWorker(Sender.GetPasswordText());
    return true;
    //return ReturnValue;    
}

function bool OnPasswordEnteredLAN(UIScene_PasswordBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    JoinLanWorker(Sender.GetPasswordText());
    return true;
    //return ReturnValue;    
}

exec function LookForLoobbies()
{
    local int SelectedIndex;
    local string GameType;

    // End:0x11
    if(!bInitFinished)
    {
        return;
    }
    SetGameSearch();
    LastLobbySearchFilters.Length = 0;
    Lobbies.Length = 0;
    LobbyInterface.AddFindLobbiesCompleteDelegate(OnFindLobbiesComplete);
    SelectedIndex = int(GameTypeDropdown.GetFloat("selectedIndex"));
    GameType = GameTypeNames[SelectedIndex - 1];
    // End:0x1B8
    if(SelectedIndex > 0)
    {
        LastLobbySearchFilters.Add(2);        
        LastLobbySearchFilters[0].Key = "GAMETYPE";
        LastLobbySearchFilters[0].Value = "-2";
        LastLobbySearchFilters[0].Operator = 0;
        LastLobbySearchFilters[1].Key = "GAMEMODE";
        LastLobbySearchFilters[1].Value = GameType;
        LastLobbySearchFilters[1].Operator = 0;
    }
    CurrentMaxLobbiesSearch = 1;
    LobbyInterface.FindLobbies(CurrentMaxLobbiesSearch, LastLobbySearchFilters);
    //return;    
}

function OnFindLobbiesComplete(bool bWasSuccessful, const out array<BasicLobbyInfo> LobbyList)
{
    local BasicLobbyInfo LobbyInfo;

    // End:0x2E
    foreach LobbyList(LobbyInfo)
    {
        Lobbies.AddItem(LobbyInfo);                
    }    
    UpdateListDataProviderLobby();
    // End:0x64
    if(LobbyList.Length < CurrentMaxLobbiesSearch)
    {
        CurrentMaxLobbiesSearch = TotalMaxLobbiesSearch;
    }
    // End:0xFF
    if(CurrentMaxLobbiesSearch < TotalMaxLobbiesSearch)
    {
        CurrentMaxLobbiesSearch = CurrentMaxLobbiesSearch * 3;
        // End:0xBC
        if(CurrentMaxLobbiesSearch > TotalMaxLobbiesSearch)
        {
            CurrentMaxLobbiesSearch = TotalMaxLobbiesSearch;
        }
        Lobbies.Length = 0;
        LobbyInterface.FindLobbies(CurrentMaxLobbiesSearch, LastLobbySearchFilters);        
    }
    else
    {
        LobbyInterface.ClearFindLobbiesCompleteDelegate(OnFindLobbiesComplete);
        LastSelectedSlot = 0;
        CurrentRowShift = 0;
    }
    //return;    
}

final function DumpGameSearchData(OnlineGameSearch GameSearch)
{
    local int I, J, OutVal;
    local string LogStr;

    I = 0;
    J0x0B:

    // End:0x46 [Loop If]
    if(I < GameSearch.NamedProperties.Length)
    {
        ++I;
        // [Loop Continue]
        goto J0x0B;
    }
    I = 0;
    J0x51:

    // End:0x99A [Loop If]
    if(I < GameSearch.FilterQuery.OrClauses.Length)
    {
        J = 0;
        J0x9C:

        // End:0x98C [Loop If]
        if(J < GameSearch.FilterQuery.OrClauses[I].OrParams.Length)
        {
            LogStr = ("----" @ string(J)) $ ": Name";
            // End:0x431
            if(int(GameSearch.FilterQuery.OrClauses[I].OrParams[J].EntryType) == int(0))
            {                
                LogStr @= ("(property):" @ string(GameSearch.GetPropertyName(GameSearch.FilterQuery.OrClauses[I].OrParams[J].EntryId)));                
                LogStr @= (("(p" $ string(GameSearch.FilterQuery.OrClauses[I].OrParams[J].EntryId)) $ ")");                
                LogStr $= (", ColumnName:" @ GameSearch.GetPropertyColumnHeader(GameSearch.FilterQuery.OrClauses[I].OrParams[J].EntryId));                
                LogStr $= (", Value:" @ GameSearch.GetPropertyAsString(GameSearch.FilterQuery.OrClauses[I].OrParams[J].EntryId));                
            }
            else
            {
                // End:0x79F
                if(int(GameSearch.FilterQuery.OrClauses[I].OrParams[J].EntryType) == int(1))
                {                    
                    LogStr @= ("(localized):" @ string(GameSearch.GetStringSettingName(GameSearch.FilterQuery.OrClauses[I].OrParams[J].EntryId)));                    
                    LogStr @= (("(s" $ string(GameSearch.FilterQuery.OrClauses[I].OrParams[J].EntryId)) $ ")");                    
                    LogStr $= (", ColumnName:" @ GameSearch.GetStringSettingColumnHeader(GameSearch.FilterQuery.OrClauses[I].OrParams[J].EntryId));
                    // End:0x75A
                    if(GameSearch.GetStringSettingValue(GameSearch.FilterQuery.OrClauses[I].OrParams[J].EntryId, OutVal))
                    {                        
                        LogStr $= (", Value:" @ string(OutVal));                        
                    }
                    else
                    {                        
                        LogStr $= ", Value: Unknown (failed to retrieve value)";
                    }                    
                }
                else
                {                    
                    LogStr @= ("(object)" @ string(GameSearch.FilterQuery.OrClauses[I].OrParams[J].ObjectPropertyName));                    
                    LogStr $= (", Value:" @ GameSearch.GetPropertyAsStringByName(GameSearch.FilterQuery.OrClauses[I].OrParams[J].ObjectPropertyName));
                }
            }            
            LogStr $= (", SortType:" @ string(GetEnum(Enum'Engine.OnlineGameSearch.EOnlineGameSearchComparisonType', int(GameSearch.FilterQuery.OrClauses[I].OrParams[J].ComparisonType))));
            ++J;
            // [Loop Continue]
            goto J0x9C;
        }
        ++I;
        // [Loop Continue]
        goto J0x51;
    }
    I = 0;
    J0x9A5:

    // End:0x10FE [Loop If]
    if(I < GameSearch.FilterQuery.SortClauses.Length)
    {
        LogStr = ("---" @ string(J)) $ ": Name";
        // End:0xC8B
        if(int(GameSearch.FilterQuery.SortClauses[I].EntryType) == int(0))
        {            
            LogStr @= ("(property):" @ string(GameSearch.GetPropertyName(GameSearch.FilterQuery.SortClauses[I].EntryId)));            
            LogStr @= (("(p" $ string(GameSearch.FilterQuery.SortClauses[I].EntryId)) $ ")");            
            LogStr $= (", ColumnName:" @ GameSearch.GetPropertyColumnHeader(GameSearch.FilterQuery.SortClauses[I].EntryId));            
            LogStr $= (", Value:" @ GameSearch.GetPropertyAsString(GameSearch.FilterQuery.SortClauses[I].EntryId));            
        }
        else
        {
            // End:0xF68
            if(int(GameSearch.FilterQuery.SortClauses[I].EntryType) == int(1))
            {                
                LogStr @= ("(localized):" @ string(GameSearch.GetStringSettingName(GameSearch.FilterQuery.SortClauses[I].EntryId)));                
                LogStr @= (("(s" $ string(GameSearch.FilterQuery.SortClauses[I].EntryId)) $ ")");                
                LogStr $= (", ColumnName:" @ GameSearch.GetStringSettingColumnHeader(GameSearch.FilterQuery.SortClauses[I].EntryId));
                // End:0xF23
                if(GameSearch.GetStringSettingValue(GameSearch.FilterQuery.SortClauses[I].EntryId, OutVal))
                {                    
                    LogStr $= (", Value:" @ string(OutVal));                    
                }
                else
                {                    
                    LogStr $= ", Value: Unknown (failed to retrieve value)";
                }                
            }
            else
            {                
                LogStr @= ("(object)" @ string(GameSearch.FilterQuery.SortClauses[I].ObjectPropertyName));                
                LogStr $= (", Value:" @ GameSearch.GetPropertyAsStringByName(GameSearch.FilterQuery.SortClauses[I].ObjectPropertyName));
            }
        }        
        LogStr $= (", SortType:" @ string(GetEnum(Enum'Engine.OnlineGameSearch.EOnlineGameSearchSortType', int(GameSearch.FilterQuery.SortClauses[I].SortType))));
        ++I;
        // [Loop Continue]
        goto J0x9A5;
    }
    //return;    
}

function ShiftServerListUp()
{
    // End:0x1C
    if(--CurrentRowShift < 0)
    {
        CurrentRowShift = 0;
    }
    RebuildServerList();
    //return;    
}

function ShiftServerListDown()
{
    // End:0x36
    if(++CurrentRowShift > (SteamServerList.Length - 11))
    {
        CurrentRowShift = SteamServerList.Length - 11;
    }
    RebuildServerList();
    //return;    
}

function SetServerListFocus(int CurrentSelectedSlot)
{
    ServersList[CurrentSelectedSlot].ServerListBtn.SetBool("focused", true);
    LastSelectedIndex = ServersList[CurrentSelectedSlot].GameSearchIndex;
    LastSelectedSlot = CurrentSelectedSlot;
    //return;    
}

event bool FilterButtonInput(int ControllerId, name ButtonName, Object.EInputEvent InputEvent)
{
    local int CurrentSelectedSlot;
    local AdvUIManager UIManager;

    CurrentSelectedSlot = LastSelectedSlot;
    // End:0x158
    if(((int(InputEvent) == int(0)) && !bAutoShiftUp) && !bAutoShiftDown)
    {
        // End:0xF9
        if(ButtonName == 'MouseScrollDown')
        {
            // End:0xC6
            if((++CurrentSelectedSlot >= 11) || CurrentSelectedSlot >= SteamServerList.Length)
            {
                // End:0xB7
                if(SteamServerList.Length <= 11)
                {
                    CurrentSelectedSlot = SteamServerList.Length - 1;                    
                }
                else
                {
                    CurrentSelectedSlot = 11 - 1;
                }
            }
            // End:0xE3
            if(LastSelectedSlot == (11 - 1))
            {
                ShiftServerListDown();
            }
            SetServerListFocus(CurrentSelectedSlot);            
        }
        else
        {
            // End:0x158
            if(ButtonName == 'MouseScrollUp')
            {
                // End:0x12C
                if(--CurrentSelectedSlot < 0)
                {
                    CurrentSelectedSlot = 0;
                }
                // End:0x145
                if(LastSelectedSlot == 0)
                {
                    ShiftServerListUp();
                }
                SetServerListFocus(CurrentSelectedSlot);
            }
        }
    }
    // End:0x2CC
    if((((int(InputEvent) == int(0)) || int(InputEvent) == int(2)) && !bAutoShiftUp) && !bAutoShiftDown)
    {
        // End:0x242
        if(((((ButtonName == 'XboxTypeS_DPad_Down') || ButtonName == 'Gamepad_LeftStick_Down') || ButtonName == 'Down') && CurrentSelectedSlot == (11 - 1)) && CurrentRowShift < (SteamServerList.Length - 11))
        {
            ShiftServerListDown();
            SetServerListFocus(CurrentSelectedSlot);
            return true;            
        }
        else
        {
            // End:0x2CC
            if(((((ButtonName == 'XboxTypeS_DPad_Up') || ButtonName == 'Gamepad_LeftStick_Up') || ButtonName == 'Up') && CurrentSelectedSlot == 0) && CurrentRowShift > 0)
            {
                ShiftServerListUp();
                SetServerListFocus(CurrentSelectedSlot);
                return true;
            }
        }
    }
    // End:0x38A
    if((int(InputEvent) == int(0)) && SearchDataStore.HasOutstandingQueries())
    {
        // End:0x38A
        if(ButtonName == 'Escape')
        {
            UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
            // End:0x37D
            if(UIManager != none)
            {
                UIManager.CloseUpdatingScene(false);
            }
            CancelQuery();
            return true;
        }
    }
    return super.FilterButtonInput(ControllerId, ButtonName, InputEvent);
    //return ReturnValue;    
}

function Tick(float DeltaTime)
{
    local float AutoShiftCurrentDelay;

    // End:0x2D
    if(AutoShiftTimeElapsed > AutoShiftSlowToFastDelay)
    {
        AutoShiftCurrentDelay = AutoShiftFastDelay;        
    }
    else
    {
        AutoShiftCurrentDelay = AutoShiftSlowDelay;
    }
    // End:0x10C
    if(bAutoShiftUp)
    {
        // End:0xF5
        if((Class'Engine.WorldInfo'.static.GetWorldInfo().RealTimeSeconds - AutoShiftLastTime) > AutoShiftCurrentDelay)
        {
            ShiftServerListUp();
            SetServerListFocus(LastSelectedSlot);
            AutoShiftLastTime = Class'Engine.WorldInfo'.static.GetWorldInfo().RealTimeSeconds;
        }
        AutoShiftTimeElapsed += DeltaTime;        
    }
    else
    {
        // End:0x1F6
        if(bAutoShiftDown)
        {
            // End:0x1DF
            if(((Class'Engine.WorldInfo'.static.GetWorldInfo().RealTimeSeconds - AutoShiftLastTime) > AutoShiftCurrentDelay) && CurrentRowShift < (SteamServerList.Length - 11))
            {
                ShiftServerListDown();
                SetServerListFocus(LastSelectedSlot);
                AutoShiftLastTime = Class'Engine.WorldInfo'.static.GetWorldInfo().RealTimeSeconds;
            }
            AutoShiftTimeElapsed += DeltaTime;            
        }
        else
        {
            AutoShiftTimeElapsed = 0.0000000;
        }
    }
    super.Tick(DeltaTime);
    //return;    
}

defaultproperties
{
    SearchDSName="AdvGameSearch_Base"
    LastSelectedIndex=-1
    TitleString="Public Game Browser"
    GameTypeString="Game Type"
    ServersString="Server list"
    JoinString="Join server"
    RefreshString="Refresh list"
    LanInternetString="LAN Games"
    SpectateString="Join As Spectator"
    AllGamesString="All games"
    ServerNameTxt="Server Name"
    PlayersTxt="Players"
    MapNameTxt="Map"
    GameTxt="Game"
    PingTxt="Ping"
    LatestSearchLenght=-1
    TotalMaxLobbiesSearch=32
    ForceSelectedIndex=-1
    AutoShiftSlowDelay=0.0500000
    AutoShiftFastDelay=0.0100000
    AutoShiftSlowToFastDelay=2.0000000
    LastClickTime=-1.0000000
    LastClickIndex=-1
    UnofficialDedicatedPlaylistId=-3
    MovieInfoPath="UI_AdvUI.AdvMultiServers"
}