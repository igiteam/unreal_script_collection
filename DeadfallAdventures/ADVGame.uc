class ADVGame extends EvilGame
    native
    config(Game)
    hidecategories(Navigation,Movement,Collision);

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

var bool bURLDifficultyOverride;
var bool bRestoreDefaultWeapons;
var AdvPersistentPartyBeaconHost HostPersistentPartyBeacon;
var(PKPlayerPhysics) config float MaximalBunnyHopSpeed;
var int NumConnectingClients;
var array<float> timesToRemove;
//var delegate<OnStartupSessionSetupComplete> __OnStartupSessionSetupComplete__Delegate;
//var delegate<OnUpdateOnlineGameComplete> __OnUpdateOnlineGameComplete__Delegate;

delegate OnStartupSessionSetupComplete(bool bSucces)
{
    //return;    
}

function GenericPlayerInitialization(Controller C)
{
    local AdvPlayerController PC;

    PC = AdvPlayerController(C);
    // End:0x4B
    if(PC != none)
    {
        PC.ClientRegisterWithParty(true);
    }
    // End:0x6D
    if(!bUseClassicHUD)
    {
        HUDType = Class'AdvGFxHudWrapper';
    }
    super(GameInfo).GenericPlayerInitialization(C);
    //return;    
}

final function AdvGRI GetGRI()
{
    return AdvGRI(GameReplicationInfo);
    //return ReturnValue;    
}

event InitGame(string Options, out string ErrorMessage)
{
    local string InOpt;

    // End:0x3A
    if(WorldInfo.TimeSeconds == 0.0000000)
    {
        MapCycleIndex = -1;
        SaveConfig();
    }
    NumConnectingClients = 1;
    super(GameInfo).InitGame(Options, ErrorMessage);
    InOpt = ParseOption(Options, "ForceRespawn");
    // End:0xB2
    if(InOpt != "")
    {
        bForceRespawn = bool(InOpt);
    }
    InOpt = ParseOption(Options, "ClassicHUD");
    // End:0xF7
    if(InOpt != "")
    {
        bUseClassicHUD = true;
    }
    InOpt = ParseOption(Options, "CauseEvent");
    // End:0x15E
    if(InOpt ~= "FlyThrough")
    {
        bFixedPlayerStart = true;
        bForceRespawn = true;
        bQuickStart = true;
    }
    SetGameSpeed(GameSpeed);
    MaxLives = Max(0, GetIntOption(Options, "MaxLives", MaxLives));
    // End:0x1C2
    if(MaxLives > 0)
    {
        bTempForceRespawn = true;        
    }
    else
    {
        // End:0x1F0
        if(DefaultMaxLives > 0)
        {
            bTempForceRespawn = true;
            MaxLives = DefaultMaxLives;
        }
    }
    // End:0x20A
    if(DefaultMaxLives > 0)
    {
        TimeLimit = 0;
    }
    GoalScore = ((!IsAutomatedPerfTesting()) ? Max(0, GetIntOption(Options, "GoalScore", GoalScore)) : 0);
    InOpt = ParseOption(Options, "Console");
    // End:0x2EB
    if((InOpt != "") || WorldInfo.IsConsoleBuild())
    {
        WorldInfo.bUseConsoleInput = true;
        bConsoleServer = true;
        PlayerControllerClass = ConsolePlayerControllerClass;
    }
    // End:0x327
    if(WorldInfo.IsConsoleBuild())
    {
        bAllowKeyboardAndMouse = true;
        // End:0x327
        if(bAllowKeyboardAndMouse)
        {
        }
    }
    InOpt = ParseOption(Options, "DemoMode");
    // End:0x374
    if(InOpt != "")
    {
        bDemoMode = bool(InOpt);
    }
    InOpt = ParseOption(Options, "QuickStart");
    // End:0x3B9
    if(InOpt != "")
    {
        bQuickStart = true;
    }
    bQuickStart = bQuickStart || IsAutomatedPerfTesting();
    DemoPrefix = ParseOption(Options, "demo");
    //return;    
}

function InitGameReplicationInfo()
{
    local UTGameReplicationInfo GRI;
    local UTMutator M;

    super(GameInfo).InitGameReplicationInfo();
    GRI = UTGameReplicationInfo(GameReplicationInfo);
    // End:0x5F
    if(GRI != none)
    {
        GRI.bAllowKeyboardAndMouse = bAllowKeyboardAndMouse;
    }
    GRI.GoalScore = GoalScore;
    GRI.TimeLimit = TimeLimit;
    GameReplicationInfo.RemainingTime = 60 * TimeLimit;
    GRI.MinNetPlayers = MinNetPlayers;
    GRI.bConsoleServer = WorldInfo.bUseConsoleInput || WorldInfo.IsConsoleBuild();
    GRI.bAllowKeyboardAndMouse = bAllowKeyboardAndMouse;
    GRI.bRequireReady = bPlayersMustBeReady;
    M = GetBaseUTMutator();
    J0x1CF:

    // End:0x2B0 [Loop If]
    if(M != none)
    {        
        GRI.MutatorList $= ((GRI.MutatorList == "") ? PathName(M.Class) : "?" $ PathName(M.Class));
        M = M.GetNextUTMutator();
        // [Loop Continue]
        goto J0x1CF;
    }
    GRI.RulesString = "";
    GRI.AddGameRule(GetMapTypeRule());
    GRI.AddGameRule(GetEndGameConditionRule());
    GRI.AddGameRule(" ");
    AdvGRI(GRI).bCanIWriteStats = CanIWriteOnlineStats();
    //return;    
}

function bool GetValidSpawnLocationNearPawn(out Vector outPos, Pawn inPawn, float MinSpawnDist, float MaxSpawnDist, optional Vector TraceExtent = vect(0.0000000, 0.0000000, 0.0000000))
{
    local array<Vector> ValidSpawnPositions;
    local Vector HitLoc, HitNorm;
    local int Idx;

    // End:0x22
    if(inPawn == none)
    {
        return false;
    }
    Class'Engine.NavigationHandle'.static.GetValidPositionsForBox(inPawn.Location, MaxSpawnDist, inPawn.GetCollisionExtent(), false, ValidSpawnPositions, 20, MinSpawnDist);
    Idx = 0;
    J0xA8:

    // End:0x222 [Loop If]
    if(Idx < ValidSpawnPositions.Length)
    {
        // End:0x214
        if(inPawn.Trace(HitLoc, HitNorm, ValidSpawnPositions[Idx], inPawn.Location, true, TraceExtent) == none)
        {
            // End:0x214
            if(inPawn.Trace(HitLoc, HitNorm, ValidSpawnPositions[Idx] - (inPawn.GetCollisionExtent() * vect(0.0000000, 0.0000000, 0.5000000)), ValidSpawnPositions[Idx] + (inPawn.GetCollisionExtent() * vect(0.0000000, 0.0000000, 0.5000000)), true, vect(5.0000000, 5.0000000, 5.0000000)) == none)
            {
                outPos = ValidSpawnPositions[Idx];
                return true;
            }
        }
        ++Idx;
        // [Loop Continue]
        goto J0xA8;
    }
    return false;
    //return ReturnValue;    
}

event PlayerController Login(string Portal, string Options, const UniqueNetId UniqueId, out string ErrorMessage)
{
    local PlayerController NewPlayer;
    local Controller C;
    local bool bDedicatedServerSpectator;
    local int DifficultyIdx;

    // End:0x90
    if(((NumPlayers == 0) && int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && HasOption(Options, "dedicated"))
    {
        bDedicatedServerSpectator = true;        
        Options $= "?SpectatorOnly=1";
    }
    // End:0x166
    if(MaxLives > 0)
    {
        // End:0x165
        foreach WorldInfo.AllControllers(Class'Engine.Controller', C)
        {
            // End:0x164
            if((C.PlayerReplicationInfo != none) && C.PlayerReplicationInfo.NumLives > LateEntryLives)
            {
                Options = "?SpectatorOnly=1" $ Options;
                // End:0x165
                break;
            }            
        }        
    }
    NewPlayer = super(GameInfo).Login(Portal, Options, UniqueId, ErrorMessage);
    // End:0x300
    if(UTPlayerController(NewPlayer) != none)
    {
        // End:0x211
        if(bMustJoinBeforeStart && GameReplicationInfo.bMatchHasBegun)
        {
            UTPlayerController(NewPlayer).bLateComer = true;
        }
        // End:0x248
        if(bDedicatedServerSpectator)
        {
            UTPlayerController(NewPlayer).bDedicatedServerSpectator = true;
        }
        // End:0x300
        if(NewPlayer.PlayerReplicationInfo != none)
        {
            // End:0x2CA
            if(HasOption(Options, "SpectatorOnly"))
            {
                NewPlayer.PlayerReplicationInfo.bOnlySpectator = true;                
            }
            else
            {
                NewPlayer.PlayerReplicationInfo.bOnlySpectator = false;
            }
        }
    }
    // End:0x4C8
    if(AdvPlayerController(NewPlayer) != none)
    {
        // End:0x3F1
        if(HasOption(Options, "PuzzleDifficultyLevel"))
        {
            DifficultyIdx = GetIntOption(Options, "PuzzleDifficultyLevel", -1);
            // End:0x3C7
            if(DifficultyIdx != -1)
            {
                AdvPlayerController(NewPlayer).SetPuzzleDifficultyLevel(byte(DifficultyIdx));                
            }
            else
            {
                AdvPlayerController(NewPlayer).SetPuzzleDifficultyLevel(1);
            }
        }
        // End:0x4C8
        if(HasOption(Options, "FightDifficultyLevel"))
        {
            DifficultyIdx = GetIntOption(Options, "FightDifficultyLevel", -1);
            // End:0x49E
            if(DifficultyIdx != -1)
            {
                AdvPlayerController(NewPlayer).SetFightDifficultyLevel(byte(DifficultyIdx));                
            }
            else
            {
                AdvPlayerController(NewPlayer).SetFightDifficultyLevel(1);
            }
        }
    }
    // End:0x50C
    if((!bUseClassicHUD && NewPlayer != none) && Class'Engine.Engine'.static.IsSplitScreen())
    {
    }
    return NewPlayer;
    //return ReturnValue;    
}

event PostLogin(PlayerController NewPlayer)
{
    super(GameInfo).PostLogin(NewPlayer);
    DoPostLogin(NewPlayer);
    //return;    
}

function DoPostLogin(PlayerController NewPlayer)
{
    local UTPlayerController PC;
    local UTGameReplicationInfo GRI;
    local AdvPlayerController NewPC;
    local int InTeam;

    NewPC = AdvPlayerController(NewPlayer);
    // End:0x97
    if((AdvGRI(GameReplicationInfo) != none) && AdvGRI(GameReplicationInfo).IsMultiplayerGame())
    {
        InTeam = int(PickTeam(255, none));
        ChangeTeam(NewPlayer, InTeam, false);
    }
    // End:0x104
    if(NewPC != none)
    {
        NewPC.ClientLoginPersistentParty();
        NewPC.ClientRegisterWithParty(false);
        NewPC.UpdateLocalPlayersDLCValues();
    }
    PC = UTPlayerController(NewPlayer);
    // End:0x24F
    if(PC != none)
    {
        PC.PlayStartupMessage(StartupStage);
        PC.ClientSetSpeechRecognitionObject(SpeechRecognitionData);
        GRI = UTGameReplicationInfo(GameReplicationInfo);
        // End:0x24F
        if(((bForceMidGameMenuAtStart && !GRI.bStoryMode) && !GRI.bMatchHasBegun) && (NetWait - PendingMatchElapsedTime) > 5)
        {
            EvilPlayerReplicationInfo(PC.PlayerReplicationInfo).ShowMidGameMenu(true);
        }
    }
    Pausers.Length = 0;
    WorldInfo.Pauser = none;
    //return;    
}

event byte GetDifficultyIdx()
{
    local AdvPlayerController PC;

    // End:0x41
    foreach LocalPlayerControllers(Class'AdvPlayerController', PC)
    {        
        return PC.GetPuzzleDifficultyLevel();        
    }    
    return 0;
    //return ReturnValue;    
}

event byte GetDifficultyOtherIdx()
{
    local AdvPlayerController PC;

    // End:0x41
    foreach LocalPlayerControllers(Class'AdvPlayerController', PC)
    {        
        return PC.GetFightDifficultyLevel();        
    }    
    return 0;
    //return ReturnValue;    
}

event int GetTreasuresCollectedInfoA()
{
    local AdvPlayerController PC;

    // End:0x41
    foreach LocalPlayerControllers(Class'AdvPlayerController', PC)
    {        
        return PC.StoreTreasuresInfoAToINT();        
    }    
    return 0;
    //return ReturnValue;    
}

event int GetTreasuresCollectedInfoB()
{
    local AdvPlayerController PC;

    // End:0x41
    foreach LocalPlayerControllers(Class'AdvPlayerController', PC)
    {        
        return PC.StoreTreasuresInfoBToINT();        
    }    
    return 0;
    //return ReturnValue;    
}

event int GetUpgradesInfoA()
{
    local AdvPlayerController PC;

    // End:0x41
    foreach LocalPlayerControllers(Class'AdvPlayerController', PC)
    {        
        return PC.StoreUpgradesInfoAToINT();        
    }    
    return 0;
    //return ReturnValue;    
}

event int GetUpgradesInfoB()
{
    local AdvPlayerController PC;

    // End:0x41
    foreach LocalPlayerControllers(Class'AdvPlayerController', PC)
    {        
        return PC.StoreUpgradesInfoBToINT();        
    }    
    return 0;
    //return ReturnValue;    
}

event array<string> GetInventoryElements()
{
    local AdvPlayerController PC;
    local array<string> inventoryToSave;

    // End:0x53
    foreach LocalPlayerControllers(Class'AdvPlayerController', PC)
    {
        PC.GetPawnInventoryElements(inventoryToSave);        
        return inventoryToSave;        
    }    
    return inventoryToSave;
    //return ReturnValue;    
}

event array<int> GetInventoryElementsAmmo()
{
    local AdvPlayerController PC;
    local array<int> inventoryAmmoToSave;

    // End:0x53
    foreach LocalPlayerControllers(Class'AdvPlayerController', PC)
    {
        PC.GetPawnInventoryElementsAmmo(inventoryAmmoToSave);        
        return inventoryAmmoToSave;        
    }    
    return inventoryAmmoToSave;
    //return ReturnValue;    
}

event bool IsSPGame()
{
    return ClassIsChildOf(self.Class, Class'AdvGameSP');
    //return ReturnValue;    
}

function RestartPlayer(Controller aPlayer)
{
    local EvilVehicle_Base V, Best;
    local Vector ViewDir;
    local float bestDist, Dist;
    local EvilPlayerController PC;

    PC = EvilPlayerController(aPlayer);
    // End:0x6F
    if(PC != none)
    {
        // End:0x6F
        if((bMustJoinBeforeStart && PC != none) && PC.bLateComer)
        {
            return;
        }
    }
    // End:0xA8
    if(aPlayer.PlayerReplicationInfo.bOutOfLives)
    {
        return;
    }
    super(GameInfo).RestartPlayer(aPlayer);
    // End:0x116
    if(aPlayer.Pawn != none)
    {
        aPlayer.Pawn.ClientRestart();        
    }
    else
    {
        return;
    }
    // End:0x14C
    if(PlayerController(aPlayer) != none)
    {
        UpdateGameplayMuteList(PlayerController(aPlayer));
    }
    // End:0x172
    if(aPlayer.Pawn == none)
    {
        return;
    }
    AssignHoverboard(UTPawn(aPlayer.Pawn));
    // End:0x4A5
    if((int(WorldInfo.NetMode) == int(NM_Standalone)) && PlayerController(aPlayer) != none)
    {
        bestDist = 2000.0000000;
        ViewDir = Vector(aPlayer.Pawn.Rotation);
        V = VehicleList;
        J0x247:

        // End:0x453 [Loop If]
        if(V != none)
        {
            // End:0x2AA
            if(!bTeamGame && V.bTeamLocked)
            {
                V.bTeamLocked = false;
            }
            // End:0x428
            if(V.bTeamLocked && WorldInfo.GRI.OnSameTeam(aPlayer, V))
            {
                Dist = VSize(V.Location - aPlayer.Pawn.Location);
                // End:0x3EB
                if((ViewDir Dot (V.Location - aPlayer.Pawn.Location)) < float(0))
                {
                    Dist *= float(2);
                }
                // End:0x428
                if(Dist < bestDist)
                {
                    Best = V;
                    bestDist = Dist;
                }
            }
            V = V.NextVehicle;
            // [Loop Continue]
            goto J0x247;
        }
        // End:0x4A5
        if(Best != none)
        {
            Best.PlayerStartTime = WorldInfo.TimeSeconds + float(8);
        }
    }
    // End:0x4C8
    if(PC != none)
    {
        SetupPlayerMuteList(PC, false);
    }
    SetGameSpeed(default.GameSpeed);
    //return;    
}

function Logout(Controller Exiting)
{
    local AdvPlayerController PC;
    local bool bIsReturningFromMatch;
    local int tmpIndex;

    // End:0x2AC
    if(AdvPlayerController(Exiting) != none)
    {
        AdvPlayerController(Exiting).CleanupSteamLobby();
        // End:0x11E
        foreach WorldInfo.AllControllers(Class'AdvPlayerController', PC)
        {
            tmpIndex = 0;
            J0x7F:

            // End:0xC8 [Loop If]
            if(tmpIndex < 6)
            {
                PC.ClearAlienFx(byte(tmpIndex));
                ++tmpIndex;
                // [Loop Continue]
                goto J0x7F;
            }
            // End:0x11D
            if(PC.IsLocalPlayerController() && PC.bIsReturningFromMatch)
            {
                bIsReturningFromMatch = true;
                // End:0x11E
                break;
            }            
        }        
        // End:0x278
        foreach WorldInfo.AllControllers(Class'AdvPlayerController', PC)
        {
            // End:0x277
            if(PC != Exiting)
            {
                // End:0x277
                if((!bIsReturningFromMatch && AdvPRI(PC.PlayerReplicationInfo) != none) && AdvPRI(PC.PlayerReplicationInfo).PartyOwnerUniqueId == Exiting.PlayerReplicationInfo.UniqueId)
                {
                    PC.ClientLogoutPartyHost(Exiting.PlayerReplicationInfo.UniqueId);
                }
            }            
        }        
        AdvPlayerController(Exiting).ClientLogoutPersistentParty();
        NumConnectingClients--;
    }
    super.Logout(Exiting);
    //return;    
}

function CheckPartyConsistency(AdvPlayerController PC)
{
    local AdvPRI Leader;
    local int I;

    // End:0x7D
    if(AdvPRI(PC.PlayerReplicationInfo).PartyOwnerUniqueId == PC.PlayerReplicationInfo.UniqueId)
    {
        return;
    }
    I = 0;
    J0x88:

    // End:0x190 [Loop If]
    if(I < WorldInfo.GRI.PRIArray.Length)
    {
        Leader = AdvPRI(WorldInfo.GRI.PRIArray[I]);
        // End:0x182
        if(AdvPRI(PC.PlayerReplicationInfo).PartyOwnerUniqueId == Leader.UniqueId)
        {
            return;
        }
        ++I;
        // [Loop Continue]
        goto J0x88;
    }
    PC.ClientLogoutPartyHost(AdvPRI(PC.PlayerReplicationInfo).PartyOwnerUniqueId);
    //return;    
}

function CheckPartyConsistencyForAll()
{
    local AdvPlayerController PC;

    // End:0x48
    foreach WorldInfo.AllControllers(Class'AdvPlayerController', PC)
    {
        CheckPartyConsistency(PC);        
    }    
    //return;    
}

function bool ForceRespawn()
{
    return false;
    //return ReturnValue;    
}

function bool PreventDeath(Pawn KilledPawn, Controller Killer, class<DamageType> DamageType, Vector HitLocation)
{
    return false;
    //return ReturnValue;    
}

function ReduceDamage(out int Damage, Pawn injured, Controller InstigatedBy, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType, Actor DamageCauser)
{
    super.ReduceDamage(Damage, injured, InstigatedBy, HitLocation, Momentum, DamageType, DamageCauser);
    //return;    
}

function ApplyBulletTimeToPlayers(float desiredDilation)
{
    local AdvPlayerController aPlayer;

    // End:0x86
    foreach WorldInfo.AllControllers(Class'AdvPlayerController', aPlayer)
    {
        // End:0x85
        if(aPlayer.bIsPlayer)
        {
            aPlayer.ClientSetAllPlayerPawnsCustomTimeDilation(1.0000000 / desiredDilation);
        }        
    }    
    //return;    
}

function EnableBulletTime(float desiredDilation)
{
    BulletTimeBlendIn(desiredDilation, 0.0000000);
    CustomTimeDilation = 1.0000000 / desiredDilation;
    //return;    
}

function DisableBulletTime()
{
    BulletTimeBlendOut(0.0000000);
    ApplyBulletTimeToPlayers(1.0000000);
    CustomTimeDilation = 1.0000000;
    //return;    
}

protected function BulletTimeBlend(float dd, float bt)
{
    local AdvPlayerController PC;

    // End:0x2E
    if((dd > DesiredTimeDilation) && dd != 1.0000000)
    {
        return;
    }
    // End:0xD3
    foreach WorldInfo.AllControllers(Class'AdvPlayerController', PC)
    {
        PC.ClientSetSoundMode(((dd == 1.0000000) ? 'Default' : PC.default.BulletTimeSoundMode.Name));        
    }    
    ApplyBulletTimeToPlayers(dd);
    super.BulletTimeBlend(dd, bt);
    //return;    
}

static final function AdvDataStore_GameSettings GetGameSettingsDataStore()
{
    local DataStoreClient DSClient;

    DSClient = Class'Engine.UIInteraction'.static.GetDataStoreClient();
    // End:0x6B
    if(DSClient != none)
    {
        return AdvDataStore_GameSettings(DSClient.FindDataStore('AdvGameSettings'));
    }
    return none;
    //return ReturnValue;    
}

function OnlineGameSettings GetCurrentGameSettings(optional bool bCreateIfNecessary)
{
    local AdvDataStore_GameSettings SettingsDS;
    local OnlineGameSettings Result;

    SettingsDS = GetGameSettingsDataStore();
    // End:0x4D
    if(SettingsDS != none)
    {
        Result = SettingsDS.GetCurrentGameSettings();
    }
    return Result;
    //return ReturnValue;    
}

function StartMatch()
{
    local bool bTemp;
    local UTPlayerController PC;

    // End:0x80
    if(((GameplayEventsWriter != none) && !GameplayEventsWriter.IsSessionInProgress()) && !Class'Engine.WorldInfo'.static.IsMenuLevel())
    {
        GameplayEventsWriter.StartLogging(0.5000000);
    }
    // End:0x8F
    if(CheckForSentinelRun())
    {
        return;
    }
    GotoState('MatchInProgress');
    GameReplicationInfo.RemainingMinute = GameReplicationInfo.RemainingTime;
    super(GameInfo).StartMatch();
    bTemp = bMustJoinBeforeStart;
    bMustJoinBeforeStart = false;
    bMustJoinBeforeStart = bTemp;
    // End:0x163
    foreach WorldInfo.AllControllers(Class'EvilGame.UTPlayerController', PC)
    {
        SetupPlayerMuteList(PC, false);        
    }    
    // End:0x1E6
    if(CauseEventCommand != "")
    {
        // End:0x1E5
        foreach WorldInfo.AllControllers(Class'EvilGame.UTPlayerController', PC)
        {            
            PC.ConsoleCommand("ce " $ CauseEventCommand);
            // End:0x1E5
            break;            
        }        
    }
    // End:0x25D
    if((BugLocString != "") || BugRotString != "")
    {
        // End:0x25D
        if(PC.CheatManager != none)
        {
            PC.BugItGoString(BugLocString, BugRotString);
        }
    }
    //return;    
}

function bool MatchIsInProgress()
{
    return false;
    //return ReturnValue;    
}

function bool AllowCheats(PlayerController P)
{
    return false;
    //return ReturnValue;    
}

function DestroyPersistentParty()
{
    // End:0xAC
    if(OnlineSub != none)
    {
        HostPersistentPartyBeacon = AdvPersistentPartyBeaconHost(OnlineSub.GetNamedInterface('PersistentPartyHostBeacon'));
        // End:0x83
        if(HostPersistentPartyBeacon != none)
        {
            HostPersistentPartyBeacon.DestroyBeacon();
            HostPersistentPartyBeacon = none;
        }
        OnlineSub.SetNamedInterface('PersistentPartyHostBeacon', none);
    }
    //return;    
}

function GameEnding()
{
    local AdvPlayerController PC;

    // End:0x63
    foreach WorldInfo.AllControllers(Class'AdvPlayerController', PC)
    {
        // End:0x62
        if(PC != none)
        {
            PC.CleanupSteamLobby();
        }        
    }    
    // End:0x10E
    if(HostPersistentPartyBeacon != none)
    {
        HostPersistentPartyBeacon.__OnReservationChange__Delegate = None;
        HostPersistentPartyBeacon.__OnReservationsFull__Delegate = None;
        HostPersistentPartyBeacon.__OnClientCancellationReceived__Delegate = None;
        HostPersistentPartyBeacon = none;
    }
    super(GameInfo).GameEnding();
    //return;    
}

function SetClientsRichPresenceStrings(int StringId)
{
    local AdvPlayerController PC;

    // End:0x5D
    foreach WorldInfo.AllControllers(Class'AdvPlayerController', PC)
    {
        PC.ClientSetRichPresenceString(StringId);        
    }    
    //return;    
}

function TellClientsToSetPartyInviteFlags(bool bAllowInvites, bool bAllowJoinViaPresence, bool bAllowJoinViaPresenceFriendsOnly, int NumPublicConnections, optional bool bAllowJoinInProgress = true)
{
    local AdvPlayerController PC;

    // End:0x2B
    if(bAllowJoinViaPresence && bAllowJoinViaPresenceFriendsOnly)
    {
        ScriptTrace();
    }
    // End:0xB0
    foreach WorldInfo.AllControllers(Class'AdvPlayerController', PC)
    {
        PC.ClientSetPartyInviteFlags(bAllowInvites, bAllowJoinViaPresence, bAllowJoinViaPresenceFriendsOnly, NumPublicConnections, bAllowJoinInProgress);        
    }    
    //return;    
}

function AddConnectingClient()
{
    NumConnectingClients++;
    timesToRemove.AddItem(Class'Engine.WorldInfo'.static.GetWorldInfo().RealTimeSeconds + float(20));    
    // End:0x7E
    if(!IsTimerActive('RemoveConnectingClient'))
    {
        SetTimer(1.0000000, true, 'RemoveConnectingClient');
    }
    //return;    
}

function RemoveConnectingClient()
{
    local int I;
    local float CurTime;

    CurTime = Class'Engine.WorldInfo'.static.GetWorldInfo().RealTimeSeconds;
    I = 0;
    J0x49:

    // End:0xBB [Loop If]
    if(I < timesToRemove.Length)
    {
        // End:0xAD
        if(CurTime > timesToRemove[I])
        {
            NumConnectingClients--;
            timesToRemove.Remove(I, 1);            
            I--;
        }
        ++I;
        // [Loop Continue]
        goto J0x49;
    }
    // End:0xDF
    if(timesToRemove.Length == 0)
    {
        ClearTimer('RemoveConnectingClient');
    }
    //return;    
}

function RemoveMissingPlayersFromSession(name SessionName)
{
    local array<UniqueNetId> RegisteredPlayers;
    local int PRIIdx, PlayerIdx;

    // End:0x1ED
    if((OnlineSubsystemCommonImpl(OnlineSub) != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
    {
        OnlineSubsystemCommonImpl(OnlineSub).GetRegisteredPlayers(SessionName, RegisteredPlayers);
        PRIIdx = 0;
        J0x94:

        // End:0x1A6 [Loop If]
        if(PRIIdx < WorldInfo.GRI.PRIArray.Length)
        {
            PlayerIdx = 0;
            J0xE1:

            // End:0x198 [Loop If]
            if(PlayerIdx < RegisteredPlayers.Length)
            {
                // End:0x18A
                if(RegisteredPlayers[PlayerIdx] == WorldInfo.GRI.PRIArray[PRIIdx].UniqueId)
                {
                    RegisteredPlayers.Remove(PlayerIdx, 1);                    
                    PlayerIdx--;
                }
                PlayerIdx++;
                // [Loop Continue]
                goto J0xE1;
            }
            PRIIdx++;
            // [Loop Continue]
            goto J0x94;
        }
        OnlineSub.GameInterface.UnregisterPlayers(SessionName, RegisteredPlayers);
    }
    //return;    
}

function bool ShouldWaitForStartupSession()
{
    return false;
    //return ReturnValue;    
}

function bool AtCapacity(bool bSpectator)
{
    local OnlineGameSettings GameSettings;

    // End:0xA8
    if(int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        GameSettings = GameInterface.GetGameSettings(PlayerReplicationInfoClass.default.SessionName);
        // End:0xA8
        if((GameSettings != none) && GameSettings.NumOpenPublicConnections <= 0)
        {
            return true;
        }
    }
    return super(GameInfo).AtCapacity(bSpectator);
    //return ReturnValue;    
}

function UpdateGameSettingsCounts()
{
    local AdvPlayerController PC;
    local int TotalOpenConnections, TotalConnections;
    local OnlineGameSettings GameSettings;

    // End:0x3FA
    if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
    {
        GameSettings = GameInterface.GetGameSettings(PlayerReplicationInfoClass.default.SessionName);
        // End:0x3FA
        if(GameSettings != none)
        {
            GameSettings.NumPublicConnections = Clamp(GameSettings.NumPublicConnections, 0, MaxPlayers);
            GameSettings.NumPrivateConnections = Clamp(GameSettings.NumPrivateConnections, 0, MaxPlayers - GameSettings.NumPublicConnections);
            GameSettings.NumOpenPublicConnections = GameSettings.NumPublicConnections - (GetNumPlayers());
            // End:0x1B6
            if(GameSettings.NumOpenPublicConnections < 0)
            {
                GameSettings.NumOpenPublicConnections = 0;
            }
            TotalOpenConnections = GameSettings.NumOpenPublicConnections + GameSettings.NumOpenPrivateConnections;
            TotalConnections = GameSettings.NumPublicConnections + GameSettings.NumPrivateConnections;
            GameSettings.SetStringSettingValue(42, ((TotalOpenConnections == 0) ? 1 : 0), false);
            GameSettings.SetStringSettingValue(43, ((TotalOpenConnections == TotalConnections) ? 1 : 0), false);
            GameInterface.UpdateOnlineGame(PlayerReplicationInfoClass.default.SessionName, GameSettings, true);
            // End:0x3F9
            foreach LocalPlayerControllers(Class'AdvPlayerController', PC)
            {
                // End:0x3F8
                if((PC != none) && PC.IsPrimaryPlayer())
                {
                    PC.UpdateSteamLobbyNumPlayers((string(GameSettings.NumPublicConnections - GameSettings.NumOpenPublicConnections) $ " / ") $ string(GameSettings.NumPublicConnections), GameSettings.NumOpenPublicConnections);
                }                
            }            
        }
    }
    //return;    
}

function UpdateGameSettings()
{
    local string MapName, plNum;
    local OnlineGameSettings GameSettings;
    local AdvPlayerController PC;

    // End:0x68
    if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
    {
        GameSettings = GameInterface.GetGameSettings(PlayerReplicationInfoClass.default.SessionName);
    }
    // End:0x1BF
    if((GameSettings != none) && NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
    {
        MapName = WorldInfo.GetMapName(true);
        plNum = (("" @ string(GameSettings.NumPublicConnections - GameSettings.NumOpenPublicConnections)) @ " / ") @ string(GameSettings.NumPublicConnections);
        // End:0x1BE
        foreach WorldInfo.AllControllers(Class'AdvPlayerController', PC)
        {
            PC.UpdateSteamLobby(MapName, plNum, GameSettings.NumOpenPublicConnections);            
        }        
    }
    super.UpdateGameSettings();
    //return;    
}

function SetStartupSessionSetupCompleteDelegate(delegate<OnStartupSessionSetupComplete> dlg)
{
    //return;    
}

function bool ArePlayersNeeded()
{
    //return ReturnValue;    
}

final function int GetGameSettingsNeedsSize(OnlineGameSettings GameSettings)
{
    local int CurrentNeedSize, PartySlotVal;

    CurrentNeedSize = -1;
    // End:0x1EC
    if(GameSettings != none)
    {
        // End:0x6C
        if(GameSettings.GetStringSettingValue(7, PartySlotVal) && PartySlotVal == 2)
        {
            CurrentNeedSize = 5;            
        }
        else
        {
            // End:0xBA
            if(GameSettings.GetStringSettingValue(6, PartySlotVal) && PartySlotVal == 2)
            {
                CurrentNeedSize = 4;                
            }
            else
            {
                // End:0x108
                if(GameSettings.GetStringSettingValue(5, PartySlotVal) && PartySlotVal == 2)
                {
                    CurrentNeedSize = 3;                    
                }
                else
                {
                    // End:0x156
                    if(GameSettings.GetStringSettingValue(4, PartySlotVal) && PartySlotVal == 2)
                    {
                        CurrentNeedSize = 2;                        
                    }
                    else
                    {
                        // End:0x1A3
                        if(GameSettings.GetStringSettingValue(3, PartySlotVal) && PartySlotVal == 2)
                        {
                            CurrentNeedSize = 1;                            
                        }
                        else
                        {
                            // End:0x1EC
                            if(GameSettings.GetStringSettingValue(3, PartySlotVal) && PartySlotVal == 0)
                            {
                                CurrentNeedSize = 0;
                            }
                        }
                    }
                }
            }
        }
    }
    return CurrentNeedSize;
    //return ReturnValue;    
}

delegate OnUpdateOnlineGameComplete(name SessionName, bool bWasSuccessful)
{
    //return;    
}

final function SetGameSettingNeedsSize(name SessionName, int NeedSize, optional bool bUpdateSession = true, optional bool bForceUpdate = false, optional delegate<OnUpdateOnlineGameComplete> UpdateOnlineGameCompleteDelegate = None)
{
    local OnlineGameSettings GameSettings;

    // End:0x4C7
    if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
    {
        GameSettings = GameInterface.GetGameSettings(SessionName);
        // End:0x4C7
        if(GameSettings != none)
        {
            // End:0x48C
            if(bForceUpdate || GetGameSettingsNeedsSize(GameSettings) != NeedSize)
            {
                GameSettings.SetStringSettingValue(3, 0, true);
                GameSettings.SetStringSettingValue(4, 0, true);
                GameSettings.SetStringSettingValue(5, 0, true);
                GameSettings.SetStringSettingValue(6, 0, true);
                GameSettings.SetStringSettingValue(7, 0, true);
                OnlineSub.DumpGameSettings(GameSettings);
                switch(NeedSize)
                {
                    // End:0x253
                    case 5:
                        GameSettings.SetStringSettingValue(7, 2);
                        GameSettings.SetStringSettingValue(6, 1);
                        GameSettings.SetStringSettingValue(5, 1);
                        GameSettings.SetStringSettingValue(4, 1);
                        GameSettings.SetStringSettingValue(3, 1);
                        // End:0x3DE
                        break;
                    // End:0x2E8
                    case 4:
                        GameSettings.SetStringSettingValue(6, 2);
                        GameSettings.SetStringSettingValue(5, 1);
                        GameSettings.SetStringSettingValue(4, 1);
                        GameSettings.SetStringSettingValue(3, 1);
                        // End:0x3DE
                        break;
                    // End:0x35A
                    case 3:
                        GameSettings.SetStringSettingValue(5, 2);
                        GameSettings.SetStringSettingValue(4, 1);
                        GameSettings.SetStringSettingValue(3, 1);
                        // End:0x3DE
                        break;
                    // End:0x3A9
                    case 2:
                        GameSettings.SetStringSettingValue(4, 2);
                        GameSettings.SetStringSettingValue(3, 1);
                        // End:0x3DE
                        break;
                    // End:0x3D4
                    case 1:
                        GameSettings.SetStringSettingValue(3, 2);
                        // End:0x3DE
                        break;
                    // End:0x3DB
                    case 0:
                        // End:0x3DE
                        break;
                    // End:0xFFFF
                    default:
                        break;
                }
                OnlineSub.DumpGameSettings(GameSettings);
                // End:0x44D
                if(bUpdateSession && UpdateOnlineGameCompleteDelegate != none)
                {
                    GameInterface.AddUpdateOnlineGameCompleteDelegate(UpdateOnlineGameCompleteDelegate);
                }
                GameInterface.UpdateOnlineGame(SessionName, GameSettings, bUpdateSession);                
            }
            else
            {
                // End:0x4C7
                if(bUpdateSession && UpdateOnlineGameCompleteDelegate != none)
                {
                    OnUpdateOnlineGameComplete(SessionName, true);
                }
            }
        }
    }
    //return;    
}

final function UpdatePlayerMatchNeedWantsStatus()
{
    local int NeedSize;
    local AdvGameSettingsCommon GameSettings;

    GameSettings = AdvGameSettingsCommon(OnlineSub.GameInterface.GetGameSettings('Game'));
    // End:0xE6
    if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)) && GameSettings != none)
    {
        NeedSize = Clamp(GameSettings.NumOpenPublicConnections, 0, 5);
        // End:0xC7
        if(bHasStandbyCheatTriggered)
        {
            NeedSize = 0;
        }
        SetGameSettingNeedsSize('Game', NeedSize, true, true);
    }
    //return;    
}

static function string ConvertToLocalizedString(string Section, string Message, string Package)
{
    local string Converted;

    Converted = "<Strings:";    
    Converted $= Package;    
    Converted $= ".";    
    Converted $= Section;    
    Converted $= ".";    
    Converted $= Message;    
    Converted $= ">";
    return Converted;
    //return ReturnValue;    
}

auto state PendingMatch
{Begin:

    // End:0x6D
    if((int(WorldInfo.NetMode) == int(NM_Standalone)) || (int(WorldInfo.NetMode) == int(NM_ListenServer)) && !IsConsoleDedicatedServer())
    {
        Sleep(0.0000000);
    }
    // End:0xB3
    if((DesiredPlayerCount <= 1) && int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        bQuickStart = true;
    }
    // End:0xCA
    if(bQuickStart)
    {
        StartMatch();
    }
    stop;        
}

state MatchInProgress
{
    function bool MatchIsInProgress()
    {
        return true;
        //return ReturnValue;        
    }
    stop;    
}

defaultproperties
{
    bGivePhysicsGun=false
    ComboSetArchetype=EvilComboSet'ar_ComboParameters.ComboSets.ar_ComboSet_SP'
    ConsolePlayerControllerClass=Class'AdvPlayerController'
    bPauseable=true
    bUseSeamlessTravel=false
    bRequiresPushToTalk=false
    DefaultPawnClass=Class'AdvPlayerPawn'
    DeathMessageClass=none
    PlayerControllerClass=Class'AdvPlayerController'
    PlayerReplicationInfoClass=Class'AdvPRI'
    GameReplicationInfoClass=Class'AdvGRI'
    StreamingPauseIcon=Material'UI_AdvUI.M_StreamingPause'
}