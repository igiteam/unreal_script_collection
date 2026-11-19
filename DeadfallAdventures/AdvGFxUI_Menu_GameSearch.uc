class AdvGFxUI_Menu_GameSearch extends AdvGFxUI_Menu_Base
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

enum ESearchStepCompleteStatus
{
    ESSCS_Wait,                     // 0
    ESSCS_InProgress,               // 1
    ESSCS_Done,                     // 2
    ESSCS_MAX                       // 3
};

struct TPlayerSlot
{
    var AdvPRI PRI;
    var GFxObject PlayerSlotMC;
    var GFxObject PlayerLevelMC;
    var GFxClikWidget PlayerBtn;
    var GFxObject PlayerLevelTF;
    var GFxObject PlayerIconTF;
    var GFxClikWidget Level;
    var GFxObject Speaker;
    var bool bMuted;

    structdefaultproperties
    {
        PRI=none
        PlayerSlotMC=none
        PlayerLevelMC=none
        PlayerBtn=none
        PlayerLevelTF=none
        PlayerIconTF=none
        Level=none
        Speaker=none
        bMuted=false
    }
};

var GFxObject ButtonsMC;
var GFxObject TitleMC;
var GFxObject MapInfoMC;
var GFxObject TitleTF;
var GFxClikWidget ClassBtn;
var GFxClikWidget SkipBtn;
var GFxClikWidget BackBtn;
var GFxObject MapNameTF;
var GFxObject TimeToStartTF;
var GFxObject PlayersNumberTF;
var GFxObject GameTypeTF;
var GFxObject VotesForSkipTF;
var GFxClikWidget MapGfx;
var TPlayerSlot PlayerSlots[16];
var const localized string TitleString;
var const localized string SkipString;
var transient AdvDataStore_GameSearch SearchDataStore;
var const transient name SearchDSName;
var transient array<OnlineGameSearchResult> ServerInfoList;
var transient OnlineGameInterface GameInterface;
var transient OnlineAuthInterface AuthInterface;
var array<UTUIDataProvider_MapInfo> ClientMapList;
var transient int LastSelectedIndex;
var int LatestSearchLenght;
var transient int DLCIndex;
var array<OnlineGameSearchResult> GameSearchResults;
var OnlineGameSearchResult GameTryToJoin;

function bool Start(optional bool StartPaused = false)
{
    local int I;

    super.Start(StartPaused);
    Advance(0.0000000);
    ButtonsMC = MenuMC.GetObject("buttons");
    TitleMC = MenuMC.GetObject("title");
    MapInfoMC = ButtonsMC.GetObject("mapInfoMC");
    TitleTF = TitleMC.GetObject("textField");
    ClassBtn = GFxClikWidget(ButtonsMC.GetObject("class_btn", Class'GFxUI.GFxClikWidget'));
    SkipBtn = GFxClikWidget(ButtonsMC.GetObject("skip_btn", Class'GFxUI.GFxClikWidget'));
    BackBtn = GFxClikWidget(ButtonsMC.GetObject("back_btn", Class'GFxUI.GFxClikWidget'));
    BackBtn.SetString("label", back);
    // End:0x287
    if(GetPC().WorldInfo.IsConsoleBuild(0) || AdvPlayerController(GetPC()).IsPCGamepadMode())
    {
        BackBtn.SetBool("visible", false);
    }
    I = 0;
    J0x292:

    // End:0x5E2 [Loop If]
    if(I < 16)
    {
        PlayerSlots[I].PlayerSlotMC = ButtonsMC.GetObject("playersMC").GetObject("player" $ string(I + 1));
        PlayerSlots[I].PlayerBtn = GFxClikWidget(PlayerSlots[I].PlayerSlotMC.GetObject("playerbtn", Class'GFxUI.GFxClikWidget'));
        PlayerSlots[I].Speaker = PlayerSlots[I].PlayerSlotMC.GetObject("speaker");
        PlayerSlots[I].PlayerIconTF = PlayerSlots[I].PlayerSlotMC.GetObject("icons");
        PlayerSlots[I].PlayerLevelMC = PlayerSlots[I].PlayerSlotMC.GetObject("level");
        PlayerSlots[I].PlayerLevelTF = PlayerSlots[I].PlayerLevelMC.GetObject("textField");
        PlayerSlots[I].Level = GFxClikWidget(PlayerSlots[I].PlayerLevelMC.GetObject("UILoader", Class'GFxUI.GFxClikWidget'));
        I++;
        // [Loop Continue]
        goto J0x292;
    }
    MapNameTF = MapInfoMC.GetObject("mapname").GetObject("textField");
    GameTypeTF = MapInfoMC.GetObject("gametype").GetObject("textField");
    VotesForSkipTF = MapInfoMC.GetObject("votesTF");
    TimeToStartTF = ButtonsMC.GetObject("timetostart").GetObject("textField");
    PlayersNumberTF = ButtonsMC.GetObject("playersnumber").GetObject("textField");
    TitleTF.SetText(TitleString);
    ClassBtn.SetString("label", Class'AdvGFxUI_Menu_MultiMenu'.default.SettingsString);
    SkipBtn.SetString("label", SkipString);
    InitSearchSubs();
    SearchAnotherServer();
    UpdateListDataProvider();
    Frontend.GetPartyGame().RefreshPartySettings();
    MapGfx = GFxClikWidget(MapInfoMC.GetObject("mapgfx", Class'GFxUI.GFxClikWidget'));
    Class'AdvFrontEnd'.static.SetMapTexture("map_unknown", MapGfx);
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

function OnBack(EventData ev)
{
    Action = "back";
    PlayCloseAnimation();
    //return;    
}

function OnJoinBtn(EventData ev)
{
    local AdvUIManager UIManager;
    local array<name> ButtonAliases;
    local AdvLocalPlayer LP;

    // End:0x1C
    if(GameSearchResults.Length <= 0)
    {
        ShowNoGamesFoundMsg();
        return;
    }
    UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0x174
    if(DLCIndex != -1)
    {
        LP = AdvLocalPlayer(GetLP());
        ButtonAliases.AddItem('GenericAccept');        
        ButtonAliases.AddItem('GenericMarketplace');        
        UIManager.ShowUIMessage('NoDLCMap', "<Strings:ADVGame.AdvGFxUI_Menu_MainMenu.DLC>", Localize("MessageBoxErrorStrings", "DLCNeeded_Message", "ADVGame"), ButtonAliases, OnIgnoreOrShowMarketPlaceOffer, LP,,,,,,,, Class'UIScene_MarketplaceMessageBox');        
    }
    else
    {
        // End:0x22E
        if(LastSelectedIndex >= 0)
        {
            // End:0x1B7
            if(UIManager != none)
            {
                UIManager.OpenUpdatingScene();
            }
            GameTryToJoin = GameSearchResults[LastSelectedIndex];
            GameInterface.AddQosStatusChangedDelegate(OnQosStatusChanged);
            GameInterface.GameSearchResultQoSCheck(GameTryToJoin);
        }
    }
    //return;    
}

function bool OnIgnoreOrShowMarketPlaceOffer(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    local AdvPlayerController PC;
    local int OfferId;
    local AdvEngine Engine;

    PC = AdvPlayerController(GetPC());
    Engine = AdvEngine(Class'AdvEngine'.static.GetEngine());
    // End:0x69
    if(SelectedInputAlias == 'GenericAccept')
    {        
    }
    else
    {
        // End:0xDF
        if(SelectedInputAlias == 'GenericMarketplace')
        {
            OfferId = Engine.GetXboxOfferIDForDLCID(DLCIndex);
            PC.ShowMarketPlace2(-1, OfferId);
        }
    }
    ClearResultsWindow();
    DLCIndex = -1;
    return true;
    //return ReturnValue;    
}

function OnSearchBtn(EventData ev)
{
    SearchAnotherServer();
    //return;    
}

function OnSkipBtn(EventData ev)
{
    //return;    
}

function OnClassBtn(EventData ev)
{
    Action = "settings";
    PlayCloseAnimation();
    //return;    
}

function UpdateListDataProvider()
{
    local int I;
    local array<UDKUIResourceDataProvider> ProviderList;

    ClientMapList.Length = 0;
    Class'EvilGame.UTUIDataStore_MenuItems'.static.GetAllResourceDataProviders(Class'EvilGame.UTUIDataProvider_MapInfo', ProviderList);
    I = 0;
    J0x48:

    // End:0x97 [Loop If]
    if(I < ProviderList.Length)
    {
        ClientMapList.AddItem(UTUIDataProvider_MapInfo(ProviderList[I]));        
        I++;
        // [Loop Continue]
        goto J0x48;
    }
    //return;    
}

final function ShowJoinErrorMsg(optional bool goToMultiMenu = false)
{
    local AdvUIManager UIManager;
    local array<name> ButtonAliases;

    UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0x139
    if(UIManager != none)
    {
        ButtonAliases.AddItem('GenericAccept');        
        UIManager.ShowUIMessage('ConnectionError', Localize("MessageBoxErrorStrings", "InviteJoinFailed_Title", "ADVGame"), Localize("AdvGFxUI_Menu_PregameLobby", "UnableToJoinGameString", "ADVGame"), ButtonAliases, ((goToMultiMenu) ?  : none),,,,, false, false);
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
    // End:0x12A
    if(UIManager != none)
    {
        ButtonAliases.AddItem('GenericAccept');        
        UIManager.ShowUIMessage('ConnectionError', Localize("AdvGFxUI_Menu_PregameLobby", "ContentMismatchTitle", "ADVGame"), Localize("AdvGFxUI_Menu_PregameLobby", "JIPContentMismatch", "ADVGame"), ButtonAliases, None,,,,, false, false);
    }
    //return;    
}

function TryToJoin()
{
    local byte PlatformInfo[80];
    local string CustomMapName;

    // End:0x301
    if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
    {
        // End:0x2F3
        if(LastSelectedIndex >= 0)
        {
            // End:0x2DC
            if(GameTryToJoin.GameSettings != none)
            {
                GameInterface.DestroyOnlineGame('Game');
                OnlineSub.DumpGameSettings(GameTryToJoin.GameSettings);
                // End:0x13A
                if(GameInterface.ReadPlatformSpecificSessionInfo(GameTryToJoin, PlatformInfo))
                {
                    Frontend.GetPartyGame().TellClientsToTravelToSession('Game', Class'AdvGameSearchQuick', PlatformInfo);
                }
                GameInterface.AddJoinOnlineGameCompleteDelegate(OnJoinGameComplete);
                // End:0x201
                if(!GameInterface.JoinOnlineGame(byte(GetLP().ControllerId), 'Game', GameTryToJoin))
                {
                    GameInterface.ClearJoinOnlineGameCompleteDelegate(OnJoinGameComplete);
                    ShowConnectionErrorMsg();                    
                }
                else
                {
                    GetAdvPC().ClientSetPartyInviteFlags(false, false, false, 8, false);
                    GameTryToJoin.GameSettings.GetStringProperty(1073741825, CustomMapName);
                    // End:0x2B7
                    if(Class'AdvPlayerController'.static.IsMenuMap(CustomMapName))
                    {
                        GetAdvPC().ClientShowJoinGameMovie(9);                        
                    }
                    else
                    {
                        GetAdvPC().ClientShowJoinGameMovie(8);
                    }
                }                
            }
            else
            {
                OnJoinGameComplete('Game', false);
            }            
        }
        else
        {
            ShowJoinErrorMsg();
        }        
    }
    //return;    
}

function bool ReturnToMultiMenu(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    Frontend.OpenMultiMenuGametypeScreen();
    Frontend.CloseGameSearchScreen();
    return true;
    //return ReturnValue;    
}

function SearchAnotherServer()
{
    SetGameSearch();
    RefreshServerList();
    //return;    
}

function OnCloseAnimationComplete()
{
    local bool bTransitionResult;

    switch(Action)
    {
        // End:0xDC
        case "back":
            switch(GetMenuGame().MultiGameModeSelected)
            {
                // End:0x77
                case 7:
                    bTransitionResult = Frontend.OpenMultiMenuScreen();
                    // End:0xD9
                    break;
                // End:0xA9
                case 3:
                    bTransitionResult = Frontend.OpenMultiSurvivalScreen();
                    // End:0xD9
                    break;
                // End:0xFFFF
                default:
                    bTransitionResult = Frontend.OpenMultiMenuGametypeScreen();
                    // End:0xD9
                    break;
                    break;
            }
            // End:0x11C
            break;
        // End:0x116
        case "settings":
            bTransitionResult = Frontend.OpenMultiPlayerSettingsScreen();
            // End:0x11C
            break;
        // End:0xFFFF
        default:
            // End:0x11C
            break;
            break;
    }
    // End:0x148
    if(bTransitionResult)
    {
        Frontend.CloseGameSearchScreen();
    }
    Action = "";
    //return;    
}

function InitSearchSubs()
{
    local DataStoreClient DSClient;

    DSClient = Class'Engine.UIInteraction'.static.GetDataStoreClient();
    // End:0x74
    if(DSClient != none)
    {
        SearchDataStore = AdvDataStore_GameSearch(DSClient.FindDataStore(SearchDSName));
    }
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0xFC
    if(OnlineSub != none)
    {
        GameInterface = OnlineSub.GameInterface;
        AuthInterface = OnlineSub.AuthInterface;
    }
    //return;    
}

event OnClose()
{
    Cleanup();
    super.OnClose();
    //return;    
}

function Cleanup()
{
    local AdvGameMenu MenuGame;
    local AdvUIManager UIManager;

    // End:0x82
    if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
    {
        GameInterface.ClearFindOnlineGamesCompleteDelegate(OnFindOnlineGamesCompleteDelegate);
        GameInterface.ClearQosStatusChangedDelegate(OnQosStatusChanged);
    }
    // End:0xB0
    if(SearchDataStore != none)
    {
        SearchDataStore.ClearAllSearchResults();
    }
    MenuGame = AdvGameMenu(Class'Engine.WorldInfo'.static.GetWorldInfo().Game);
    // End:0x125
    if(MenuGame != none)
    {
        MenuGame.CleanupGameSearchRefreshing();
    }
    UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0x186
    if(UIManager != none)
    {
        UIManager.CloseUpdatingScene();
    }
    //return;    
}

function RefreshServerList(optional int MaxResults = 25)
{
    local OnlineGameSearch GameSearch;
    local int ValueIndex;

    // End:0x18B
    if(!SearchDataStore.HasOutstandingQueries())
    {
        GameSearch = SearchDataStore.GetCurrentGameSearch();
        GameSearch.MaxSearchResults = MaxResults;
        ValueIndex = 1;
        switch(ValueIndex)
        {
            // End:0xE4
            case 2:
                GameSearch.bIsLanQuery = false;
                GameSearch.bUsesArbitration = true;
                // End:0x130
                break;
            // End:0x12D
            case 1:
                GameSearch.bIsLanQuery = false;
                GameSearch.bUsesArbitration = false;
                // End:0x130
                break;
            // End:0xFFFF
            default:
                break;
        }
        DumpGameSearchData(GameSearch);
        SubmitServerListQuery(Class'Engine.UIInteraction'.static.GetPlayerIndex(GetLP().ControllerId));
    }
    //return;    
}

function ClearResultsWindow()
{
    GameSearchResults.Length = 0;
    MapNameTF.SetText(" ");
    PlayersNumberTF.SetText(" ");
    TimeToStartTF.SetText(" ");
    Class'AdvFrontEnd'.static.SetMapTexture("map_unknown", MapGfx);
    //return;    
}

function SubmitServerListQuery(int PlayerIndex)
{
    local OnlineGameSearch GameSearch;
    local AdvUIManager UIManager;

    ClearResultsWindow();
    GameInterface.AddFindOnlineGamesCompleteDelegate(OnFindOnlineGamesCompleteDelegate);
    GameSearch = SearchDataStore.GetCurrentGameSearch();
    SearchDataStore.InvalidateCurrentSearchResults();
    UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0xED
    if(UIManager != none)
    {
        UIManager.OpenUpdatingScene(,,, false, 1.0000000);
    }
    // End:0x176
    if(!GameInterface.FindOnlineGames(byte(Class'Engine.UIInteraction'.static.GetPlayerControllerId(PlayerIndex)), GameSearch))
    {
        GameInterface.ClearFindOnlineGamesCompleteDelegate(OnFindOnlineGamesCompleteDelegate);
    }
    //return;    
}

function OnFindOnlineGamesCompleteDelegate(bool bWasSuccessful)
{
    local AdvUIManager UIManager;
    local bool bSearchCompleted;

    bSearchCompleted = !SearchDataStore.HasOutstandingQueries();
    // End:0xE0
    if(bSearchCompleted)
    {
        GameInterface.ClearFindOnlineGamesCompleteDelegate(OnFindOnlineGamesCompleteDelegate);
        BuildResults();
        UpdateServerData();
        UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
        // End:0xE0
        if(UIManager != none)
        {
            UIManager.CloseUpdatingScene(false);
        }
    }
    //return;    
}

function BuildAndWriteResults()
{
    //return;    
}

function BuildResults()
{
    local int I;
    local OnlineGameSearch LatestGameSearch;
    local AdvGameSearchCommon theSearch;

    LatestGameSearch = SearchDataStore.GetCurrentGameSearch();
    theSearch = AdvGameSearchCommon(LatestGameSearch);
    GameSearchResults.Remove(0, GameSearchResults.Length);    
    GameSearchResults.Length = 0;
    I = 0;
    J0x72:

    // End:0x15E [Loop If]
    if(I < theSearch.Results.Length)
    {
        // End:0x150
        if(theSearch.IsResultValid(theSearch.Results[I]))
        {
            DumpSearchResult(theSearch.Results[I]);
            GameSearchResults.AddItem(theSearch.Results[I]);            
        }
        I++;
        // [Loop Continue]
        goto J0x72;
    }
    //return;    
}

function DumpSearchResult(OnlineGameSearchResult SearchResult)
{
    local string sMapName, sGameType, sPlayers, sHostname;
    local int playersNum, MaxPlayers, GameID;

    playersNum = AdvGameSettingsCommon(SearchResult.GameSettings).NumPublicConnections - AdvGameSettingsCommon(SearchResult.GameSettings).NumOpenPublicConnections;
    MaxPlayers = AdvGameSettingsCommon(SearchResult.GameSettings).NumPublicConnections;
    sMapName = GetMapFriendlyName(GameSearchResults[LastSelectedIndex].GameSettings.GetPropertyAsString(1073741825));
    sPlayers = (string(playersNum) $ "/") $ string(MaxPlayers);
    sGameType = AdvGameSettingsCommon(SearchResult.GameSettings).GetPropertyAsString(1073741826);
    sHostname = AdvGameSettingsCommon(SearchResult.GameSettings).OwningPlayerName;
    AdvGameSettingsCommon(SearchResult.GameSettings).GetStringSettingValue(0, GameID);
    Class'Engine.OnlineSubsystem'.static.DumpGameSettings(AdvGameSettingsCommon(SearchResult.GameSettings));
    //return;    
}

static function string GetLocalizedGameType(string GameTypeName)
{
    // End:0x3B
    if(InStr(GameTypeName, "CTF") >= 0)
    {
        return Class'AdvGFxUI_Menu_Leaderboard'.default.TitleCTF;        
    }
    else
    {
        // End:0x81
        if(InStr(GameTypeName, "TeamDeathmatch") >= 0)
        {
            return Class'AdvGFxUI_Menu_Leaderboard'.default.TitleTDM;            
        }
        else
        {
            // End:0xC1
            if(InStr(GameTypeName, "Survival") >= 0)
            {
                return Class'AdvGFxUI_Menu_Leaderboard'.default.TitleSV;                
            }
            else
            {
                // End:0x100
                if(InStr(GameTypeName, "Deathmatch") >= 0)
                {
                    return Class'AdvGFxUI_Menu_Leaderboard'.default.TitleDM;
                }
            }
        }
    }
    return "Game";
    //return ReturnValue;    
}

function OnQosStatusChanged(int NumComplete, int NumTotal)
{
    local QWord DummyNonce;
    local UniqueNetId ZeroId;
    local AdvUIManager UIManager;
    local OnlineGameSearch LatestGameSearch;
    local AdvGameSearchCommon theSearch;

    // End:0x280
    if(NumTotal == NumComplete)
    {
        UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
        // End:0x78
        if(UIManager != none)
        {
            UIManager.CloseUpdatingScene();
        }
        // End:0x24F
        if(LastSelectedIndex >= 0)
        {
            LatestGameSearch = SearchDataStore.GetCurrentGameSearch();
            theSearch = AdvGameSearchCommon(LatestGameSearch);
            // End:0x245
            if(((((GameTryToJoin.GameSettings.ServerNonce == DummyNonce && GameTryToJoin.GameSettings.bUsesArbitration) || GameTryToJoin.GameSettings.OwningPlayerName == "") || GameTryToJoin.GameSettings.OwningPlayerId == ZeroId) || GameTryToJoin.GameSettings.PingInMs == -1) || !theSearch.IsResultValid(GameTryToJoin))
            {
                ShowJoinErrorMsg();                
            }
            else
            {
                TryToJoin();
            }
        }
        GameInterface.ClearQosStatusChangedDelegate(OnQosStatusChanged);
    }
    //return;    
}

function OnJoinGameComplete(name SessionName, bool bSuccessful)
{
    GameInterface.ClearJoinOnlineGameCompleteDelegate(OnJoinGameComplete);
    // End:0x60
    if(!bSuccessful)
    {
        GetAdvPC().ClientStopLevelLoadingMovie();
    }
    // End:0xDD
    if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
    {
        // End:0xD0
        if(bSuccessful)
        {
            Cleanup();
            Frontend.GetPartyGame().DelayedFinalizeJoin(self);            
        }
        else
        {
            ShowConnectionErrorMsg();
        }        
    }
    else
    {
        ShowJoinErrorMsg();
    }
    //return;    
}

final function ShowNoGamesFoundMsg()
{
    local AdvUIManager UIManager;
    local array<name> ButtonAliases;
    local string sTitle;

    // End:0x6F
    if(int(GetMenuGame().MultiGameModeSelected) == int(7))
    {
        sTitle = Localize("AdvGFxUI_Menu_PregameLobby", "PlayNow", "ADVGame");        
    }
    else
    {
        sTitle = Class'AdvUIDataStore_GameResource'.static.GetGameTypeProvider(GetMenuGame().MultiGameModeSelected).GameName;
    }
    UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0x1B3
    if(UIManager != none)
    {
        ButtonAliases.AddItem('GenericAccept');        
        UIManager.ShowUIMessage('NoGamesFound', sTitle, Localize("AdvGFxUI_Menu_PregameLobby", "NoGamesFoundString", "ADVGame"), ButtonAliases,, GetLP());
    }
    //return;    
}

function UpdateServerData()
{
    local string sMapName, sPlayers;
    local int playersNum, MaxPlayers;
    local string localizedMapName, sDLCIndex;
    local AdvEngine Engine;

    Engine = AdvEngine(Class'AdvEngine'.static.GetEngine());
    // End:0x4E
    if(GameSearchResults.Length <= 0)
    {
        ShowNoGamesFoundMsg();
        return;
    }
    // End:0x91
    if(int(GetMenuGame().MultiGameModeSelected) == int(0))
    {
        LastSelectedIndex = Rand(GameSearchResults.Length);        
    }
    else
    {
        LastSelectedIndex++;
        // End:0xBF
        if(LastSelectedIndex >= GameSearchResults.Length)
        {
            LastSelectedIndex = 0;
        }
    }
    playersNum = GameSearchResults[LastSelectedIndex].GameSettings.NumPublicConnections - GameSearchResults[LastSelectedIndex].GameSettings.NumOpenPublicConnections;
    MaxPlayers = GameSearchResults[LastSelectedIndex].GameSettings.NumPublicConnections;
    sMapName = GetMapFriendlyName(GameSearchResults[LastSelectedIndex].GameSettings.GetPropertyAsString(1073741825));
    sPlayers = (string(playersNum) $ "/") $ string(MaxPlayers);
    DLCIndex = -1;
    // End:0x260
    if(InStr(sMapName, "DLC") != -1)
    {
        sDLCIndex = GetRightMost(sMapName);
        DLCIndex = int(sDLCIndex);
    }
    // End:0x2B9
    if((DLCIndex != -1) && Engine.UserHasDLC(DLCIndex, GetAdvPC()))
    {
        DLCIndex = -1;
    }
    // End:0x309
    if(DLCIndex != -1)
    {
        localizedMapName = Localize("AdvGFxUI_Menu_MainMenu", "DLC", "ADVGame");        
    }
    else
    {
        localizedMapName = Localize("FriendlyMapNames", sMapName, "ADVGame");
    }
    MapNameTF.SetText(localizedMapName);
    PlayersNumberTF.SetText(sPlayers);
    Class'AdvFrontEnd'.static.SetMapTexture(((DLCIndex == -1) ? sMapName : "map_unknown"), MapGfx);
    //return;    
}

function string GetMapFriendlyName(string Map)
{
    local int I, P, StartIndex, EndIndex;
    local array<string> LocPieces;

    I = 0;
    J0x0B:

    // End:0x1CB [Loop If]
    if(I < ClientMapList.Length)
    {
        // End:0x1BD
        if(ClientMapList[I].MapName ~= Map)
        {
            StartIndex = InStr(Caps(ClientMapList[I].FriendlyName), "<STRINGS:");
            // End:0xB3
            if(StartIndex == -1)
            {
                // [Explicit Break]
                goto J0x1CB;
            }
            Map = Right(ClientMapList[I].FriendlyName, (Len(ClientMapList[I].FriendlyName) - StartIndex) - 9);
            EndIndex = InStr(Map, ">");
            // End:0x1B3
            if(EndIndex != -1)
            {
                Map = Left(Map, EndIndex);
                ParseStringIntoArray(Map, LocPieces, ".", true);
                // End:0x1B3
                if(LocPieces.Length >= 3)
                {
                    Map = LocPieces[2];
                }
            }
            return Map;
        }
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    J0x1CB:

    P = InStr(Map, "-");
    // End:0x227
    if(P > -1)
    {
        Map = Right(Map, (Len(Map) - P) - 1);
    }
    P = InStr(Map, "-");
    // End:0x283
    if(P > -1)
    {
        Map = Right(Map, (Len(Map) - P) - 1);
    }
    // End:0x2C3
    if(InStr(Map, "_P") != -1)
    {
        Map = Left(Map, Len(Map) - 2);
    }
    return Map;
    //return ReturnValue;    
}

function SetGameSearch(optional int ForceSelectedIndex = -1)
{
    local int I, SelectedIndex;

    // End:0x2E
    if(ForceSelectedIndex >= 0)
    {
        SelectedIndex = ForceSelectedIndex;        
    }
    else
    {
        SelectedIndex = int(GetMenuGame().MultiGameModeSelected);
    }
    switch(SelectedIndex)
    {
        // End:0xA5
        case 0:
            I = SearchDataStore.FindSearchConfigurationIndex('AdvGameSearchQuick');
            // End:0x23D
            break;
        // End:0xDE
        case 1:
            I = SearchDataStore.FindSearchConfigurationIndex('AdvGameSearchDeathmatch');
            // End:0x23D
            break;
        // End:0x118
        case 2:
            I = SearchDataStore.FindSearchConfigurationIndex('AdvGameSearchTeamDeathmatch');
            // End:0x23D
            break;
        // End:0x152
        case 3:
            I = SearchDataStore.FindSearchConfigurationIndex('AdvGameSearchCTF');
            // End:0x23D
            break;
        // End:0x18C
        case 4:
            I = SearchDataStore.FindSearchConfigurationIndex('AdvGameSearchTreasureHunt');
            // End:0x23D
            break;
        // End:0x1C6
        case 5:
            I = SearchDataStore.FindSearchConfigurationIndex('AdvGameSearchTeamTreasureHunt');
            // End:0x23D
            break;
        // End:0x200
        case 6:
            I = SearchDataStore.FindSearchConfigurationIndex('AdvGameSearchLastMenStanding');
            // End:0x23D
            break;
        // End:0x23A
        case 7:
            I = SearchDataStore.FindSearchConfigurationIndex('AdvGameSearchSurvival');
            // End:0x23D
            break;
        // End:0xFFFF
        default:
            break;
    }
    // End:0x27C
    if(I != -1)
    {
        SearchDataStore.SetCurrentByIndex(I, true);        
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

defaultproperties
{
    TitleString="Matchmaking"
    SkipString="Skip Map"
    SearchDSName="AdvGameSearch_Base"
    LastSelectedIndex=-1
    MovieInfoPath="UI_AdvUI.AdvGameSearch"
}