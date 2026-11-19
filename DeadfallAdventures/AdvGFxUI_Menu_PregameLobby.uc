class AdvGFxUI_Menu_PregameLobby extends AdvGFxUI_Menu_Base
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
const MAX_PLAYER_SLOTS = 12;

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
    var GFxObject PlayerReadyMC;

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
        PlayerReadyMC=none
    }
};

var GFxObject ButtonsMC;
var GFxObject TitleMC;
var GFxObject MapInfoMC;
var GFxObject HostStatusMC;
var GFxObject ReadyMC;
var GFxObject ChatMC;
var GFxObject TitleTF;
var GFxObject SubtitleTF;
var GFxClikWidget ClassBtn;
var GFxClikWidget SkipBtn;
var GFxClikWidget BackBtn;
var GFxClikWidget SkinBtn;
var GFxClikWidget MuteBtn;
var GFxClikWidget KickBtn;
var GFxClikWidget ReadyBtn;
var GFxObject MapNameTF;
var GFxObject TimeToStartTF;
var GFxObject PlayersNumberTF;
var GFxObject VotesForSkipTF;
var GFxObject VotesForSkipBG;
var GFxObject ServerNameTF;
var GFxClikWidget MapGfx;
var const localized string SkipGameString;
var const localized string PreparingGameString;
var const localized string StartingGameString;
var const localized string WaitingForPlayersString;
var const localized string SkipMapVotesString;
var const localized string NeededVotesString;
var const localized string NoMapAvailableString;
var const localized string SkipMapVoteString;
var const localized string PlayersString;
var const localized string PlayerReady;
var const localized string RlayerNotReady;
var AdvGFxVotingComponent VotingComponent;
var AdvGFxTextChatComponent TextChatComponent;
var TPlayerSlot PlayerSlots[12];
var transient bool bForceUpdatePlayerPanel;
var bool bInitialButtonFocus;
var transient int NumPlayers;
var const localized string TitleString;
var const localized string SkipString;
var int CurrentSelectedPlayerSlot;
var array<UTUIDataProvider_MapInfo> ClientMapList;
var transient int LastSelectedIndex;
var int LatestSearchLenght;
var transient int DLCIndex;
var transient AdvPreGameGRI GRI;
var GFxClikWidget DefaultSelectedButton;

simulated function bool Start(optional bool StartPaused = false)
{
    local int I;

    // End:0x68
    if(AdvLocalPlayer(GetLP()).bRestoreUsingGamepad)
    {
        GetPC().PlayerInput.bUsingGamepad = true;
    }
    CurrentSelectedPlayerSlot = -1;
    super.Start(StartPaused);
    Advance(0.0000000);
    ButtonsMC = MenuMC.GetObject("buttons");
    TitleMC = MenuMC.GetObject("title");
    MapInfoMC = ButtonsMC.GetObject("mapInfoMC");
    HostStatusMC = ButtonsMC.GetObject("hostStatusMC");
    TitleTF = TitleMC.GetObject("textField");
    SubtitleTF = ButtonsMC.GetObject("subtitleTF");
    ClassBtn = GFxClikWidget(ButtonsMC.GetObject("class_btn", Class'GFxUI.GFxClikWidget'));
    SkipBtn = GFxClikWidget(ButtonsMC.GetObject("skip_btn", Class'GFxUI.GFxClikWidget'));
    SkinBtn = GFxClikWidget(ButtonsMC.GetObject("skin_btn", Class'GFxUI.GFxClikWidget'));
    MuteBtn = GFxClikWidget(ButtonsMC.GetObject("mute_btn", Class'GFxUI.GFxClikWidget'));
    KickBtn = GFxClikWidget(ButtonsMC.GetObject("kick_btn", Class'GFxUI.GFxClikWidget'));
    ReadyBtn = GFxClikWidget(ButtonsMC.GetObject("ready_btn", Class'GFxUI.GFxClikWidget'));
    ReadyMC = GFxClikWidget(ButtonsMC.GetObject("readyMC", Class'GFxUI.GFxClikWidget'));
    ChatMC = GFxClikWidget(ButtonsMC.GetObject("chatMC", Class'GFxUI.GFxClikWidget'));
    BackBtn = GFxClikWidget(ButtonsMC.GetObject("back_btn", Class'GFxUI.GFxClikWidget'));
    BackBtn.SetString("label", back);
    // End:0x503
    if(GetPC().WorldInfo.IsConsoleBuild(0) || AdvPlayerController(GetPC()).IsPCGamepadMode())
    {
        BackBtn.SetBool("visible", false);
    }
    KickBtn.SetBool("visible", false);
    MuteBtn.SetBool("visible", false);
    ReadyBtn.SetBool("visible", false);
    ReadyMC.SetBool("visible", false);
    ReadyMC.SetVisible(false);
    I = 0;
    J0x5D2:

    // End:0xB32 [Loop If]
    if(I < 16)
    {
        // End:0x702
        if(I >= 12)
        {
            ButtonsMC.GetObject("playersMC").GetObject("player" $ string(I + 1)).GetObject("playerbtn").SetBool("visible", false);
            ButtonsMC.GetObject("playersMC").GetObject("player" $ string(I + 1)).SetVisible(false);            
        }
        else
        {
            PlayerSlots[I].PlayerSlotMC = ButtonsMC.GetObject("playersMC").GetObject("player" $ string(I + 1));
            PlayerSlots[I].PlayerBtn = GFxClikWidget(PlayerSlots[I].PlayerSlotMC.GetObject("playerbtn", Class'GFxUI.GFxClikWidget'));
            PlayerSlots[I].Speaker = PlayerSlots[I].PlayerSlotMC.GetObject("speaker");
            PlayerSlots[I].PlayerIconTF = PlayerSlots[I].PlayerSlotMC.GetObject("icons");
            PlayerSlots[I].PlayerLevelMC = PlayerSlots[I].PlayerSlotMC.GetObject("level");
            PlayerSlots[I].PlayerLevelTF = PlayerSlots[I].PlayerLevelMC.GetObject("textField");
            PlayerSlots[I].Level = GFxClikWidget(PlayerSlots[I].PlayerLevelMC.GetObject("UILoader", Class'GFxUI.GFxClikWidget'));
            PlayerSlots[I].PlayerReadyMC = PlayerSlots[I].PlayerSlotMC.GetObject("readyMC");
            PlayerSlots[I].PlayerReadyMC.SetBool("visible", false);
            PlayerSlots[I].PlayerReadyMC.SetVisible(false);
        }
        I++;
        // [Loop Continue]
        goto J0x5D2;
    }
    MapNameTF = MapInfoMC.GetObject("mapname").GetObject("textField");
    VotesForSkipTF = MapInfoMC.GetObject("votesTF");
    VotesForSkipBG = MapInfoMC.GetObject("voteMapBgMC");
    PlayersNumberTF = ButtonsMC.GetObject("timetostart").GetObject("textField");
    TimeToStartTF = HostStatusMC.GetObject("playersnumber").GetObject("textField");
    ServerNameTF = ButtonsMC.GetObject("servernameTF");
    // End:0xE06
    if(Class'Core.Object'.static.GetLanguage() ~= "JPN")
    {
        VotesForSkipTF.SetInt("_width", VotesForSkipTF.GetInt("_width") + 150);
        VotesForSkipTF.SetFloat("_xscale", VotesForSkipTF.GetFloat("_xscale") * 0.8000000);
        VotesForSkipTF.SetFloat("_yscale", VotesForSkipTF.GetFloat("_yscale") * 0.8000000);
    }
    TitleTF.SetText(TitleString);
    SubtitleTF.SetText(" ");
    PlayersNumberTF.SetText(" ");
    VotesForSkipBG.SetVisible(false);
    // End:0xF2D
    if(ServerNameTF != none)
    {
        ServerNameTF.SetText(Class'Engine.GameEngine'.static.GetOnlineSubsystem().GameInterface.GetGameSettings('Game').OwningPlayerName);
    }
    ClassBtn.SetString("label", Class'AdvGFxUI_Menu_MultiMenu'.default.SettingsString);
    SkinBtn.SetString("label", Class'AdvGFxUI_Menu_MultiMenu'.default.SkinString);
    SkipBtn.SetString("label", SkipGameString);
    DisableSkipMap(true);
    UpdateListDataProvider();
    UpdatePlayersPanel();
    ClassBtn.SetBool("visible", false);
    ClassBtn.SetVisible(false);
    ClassBtn.SetBool("disabled", true);
    DefaultSelectedButton = SkinBtn;
    bInitialButtonFocus = true;
    // End:0x10F2
    if(Frontend.GetPartyGame() != none)
    {
        Frontend.GetPartyGame().RefreshPartySettings();
    }
    MapGfx = GFxClikWidget(MapInfoMC.GetObject("mapgfx", Class'GFxUI.GFxClikWidget'));
    Class'AdvFrontEnd'.static.SetMapTexture("map_unknown", MapGfx);
    InitXP();
    return true;
    //return ReturnValue;    
}

reliable client simulated function InitXP()
{
    local int PlayerXP;

    // End:0xEF
    if(GetPC().PlayerReplicationInfo != none)
    {
        AdvPlayerController(GetPC()).ProfileSettings.GetProfileSettingValueInt(36, PlayerXP);
        AdvPRI(GetPC().PlayerReplicationInfo).InitXP(PlayerXP);
        GetPC().PlayerReplicationInfo.bForceNetUpdate = true;        
    }
    else
    {
        GetPC().SetTimer(0.0100000, false, 'InitXP', self);
    }
    //return;    
}

function DisableSkipMap(bool bDisable)
{
    local AdvPreGameLobbyPRI PRI;

    PRI = AdvPreGameLobbyPRI(GetPC().PlayerReplicationInfo);
    bDisable = (((bDisable || PRI == none) || PRI.bSubmittedGameVote) || GRI == none) || int(GRI.PreGameLobbyState) != int(4);
    SkipBtn.SetBool("disabled", bDisable);
    //return;    
}

function SetDelegates()
{
    local AdvPreGamePC PreGamePC;

    GRI = AdvPreGameGRI(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI);
    // End:0x703
    if(GRI != none)
    {
        GRI.__OnGameVoteSubmitted__Delegate = ReceivedGameVote;
        GRI.__OnHostSelectedMapChanged__Delegate = SelectedMapChangedByHost;
        GRI.__OnLobbyStateChanged__Delegate = LobbyStateChanged;
        GRI.__OnSelectionCountdownTick__Delegate = SelectionCountdownTick;
        GRI.__OnHostStartedPregameCountdown__Delegate = BeginPregameCountdown;
        GRI.__OnMapSelectionUpdate__Delegate = UpdateMapSelectionImageAndTitle;
        GRI.__OnGameModeSelectionUpdate__Delegate = UpdateSubtitle;
        GRI.__OnPlayersCountUpdate__Delegate = UpdateSubtitle;
        SelectedMapChangedByHost();
        ReceivedGameVote();
        LobbyStateChanged();
        SelectionCountdownTick();
        UpdateSubtitle();
        // End:0x283
        foreach Class'Engine.WorldInfo'.static.GetWorldInfo().LocalPlayerControllers(Class'AdvPreGamePC', PreGamePC)
        {
            PreGamePC.SetTimer(1.0000000, true, 'NotifyLobbySceneOpened', PreGamePC);            
        }        
        TrackChat(true);
        OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
        // End:0x3E2
        if(((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none))) && NotEqual_InterfaceInterface(OnlineSub.PartyChatInterface, OnlinePartyChatInterface(none)))
        {
            OnlineSub.PlayerInterface.AddMutingChangeDelegate(OnMutingChange);
            OnlineSub.PartyChatInterface.AddPartyMemberListChangedDelegate(byte(GetLP().ControllerId), OnPartyMemberListChanged);
        }
        // End:0x4C5
        if(int(Class'AdvUIDataStore_GameResource'.static.GetGameTypeProvider(GRI.WinningGameMode).MPGameMode) != int(3))
        {
            DefaultSelectedButton = ClassBtn;
            ClassBtn.SetBool("disabled", false);
            ClassBtn.SetBool("visible", true);
            ClassBtn.SetVisible(true);
        }
        // End:0x617
        if(!GRI.IsPrivateCustomGame())
        {
            MuteBtn.SetBool("visible", true);
            MuteBtn.SetString("label", "<Strings:ADVGame.AdvGFxUI_Menu_PartyWindow.VoteKickPlayer>");
            ReadyBtn.SetBool("visible", true);
            ReadyBtn.SetString("label", PlayerReady);
            ReadyMC.SetBool("visible", true);
            ReadyMC.SetVisible(true);
        }
        VotingComponent = new Class'AdvGFxVotingComponent';
        VotingComponent.Initialize(ButtonsMC, AdvPlayerController(GetPC()));
        VotingComponent.SetGRI(GRI);
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

function OnReadyBtn(EventData ev)
{
    local AdvPreGameLobbyPRI PRI;
    local bool bPlayerReady;

    PRI = AdvPreGameLobbyPRI(GetPC().PlayerReplicationInfo);
    // End:0x14D
    if(PRI != none)
    {
        bPlayerReady = !PRI.bReady;
        // End:0xD0
        if(bPlayerReady)
        {
            ReadyBtn.SetString("label", RlayerNotReady);
            ReadyMC.GotoAndStop("on");            
        }
        else
        {
            ReadyBtn.SetString("label", PlayerReady);
            ReadyMC.GotoAndStop("off");
        }
        PRI.SetReadyToStartMatch(bPlayerReady);
    }
    //return;    
}

function Tick(float DeltaTime)
{
    local int I;

    super.Tick(DeltaTime);
    // End:0x2C
    if(GRI == none)
    {
        SetDelegates();
    }
    // End:0x4F
    if(bForceUpdatePlayerPanel)
    {
        bForceUpdatePlayerPanel = false;
        UpdatePlayersPanel();
    }
    // End:0x43B
    if(GRI != none)
    {
        // End:0x95
        if(NumPlayers != GRI.PRIArray.Length)
        {
            UpdatePlayersPanel();
        }
        I = 0;
        J0xA0:

        // End:0x43B [Loop If]
        if(I < 12)
        {
            // End:0x186
            if(!PlayerSlots[I].bMuted)
            {
                // End:0x171
                if((PlayerSlots[I].PRI != none) && Class'AdvUIManager'.static.GetChatIconOpacity(PlayerSlots[I].PRI) > 0.5000000)
                {
                    SetSlotSpeaker(I, true);                    
                }
                else
                {
                    SetSlotSpeaker(I, false);
                }
            }
            // End:0x1FD
            if((CurrentSelectedPlayerSlot != I) && PlayerSlots[I].PlayerBtn.GetInt("focused") > 0)
            {
                CurrentSelectedPlayerSlot = I;
            }
            // End:0x3AA
            if((AdvPreGameLobbyPRI(PlayerSlots[I].PRI) != none) && !GRI.IsPrivateCustomGame())
            {
                PlayerSlots[I].PlayerReadyMC.SetBool("visible", true);
                PlayerSlots[I].PlayerReadyMC.SetVisible(true);
                // End:0x366
                if(AdvPreGameLobbyPRI(PlayerSlots[I].PRI).bReady)
                {
                    PlayerSlots[I].PlayerReadyMC.GotoAndStop("on");                    
                }
                else
                {
                    PlayerSlots[I].PlayerReadyMC.GotoAndStop("off");
                }                
            }
            else
            {
                PlayerSlots[I].PlayerReadyMC.SetBool("visible", false);
                PlayerSlots[I].PlayerReadyMC.SetVisible(false);
            }
            I++;
            // [Loop Continue]
            goto J0xA0;
        }
    }
    // End:0x4AD
    if(GetPC().WorldInfo.IsConsoleBuild(0) || AdvPlayerController(GetPC()).IsPCGamepadMode())
    {
        UpdateFooter();
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
    // End:0x2C1
    if((CurrentSelectedPlayerSlot > -1) && PlayerSlots[CurrentSelectedPlayerSlot].PlayerBtn.GetInt("focused") > 0)
    {
        // End:0x2C1
        if(((GetPC().WorldInfo.IsConsoleBuild(0) || AdvPlayerController(GetPC()).IsPCGamepadMode()) && PlayerSlots[CurrentSelectedPlayerSlot].PRI != none) && Class'Engine.UIInteraction'.static.IsLoggedIn(GetLP().ControllerId))
        {
            // End:0x263
            if(Class'AdvGFxUI_Menu_PartyMenu'.static.CanVoteKickPlayer(PlayerSlots[CurrentSelectedPlayerSlot].PRI) && GetPC().PlayerReplicationInfo != PlayerSlots[CurrentSelectedPlayerSlot].PRI)
            {
                ButtonAliases.AddItem('VoteKickPlayer');                                
            }
            else
            {
                // End:0x2C1
                if(Class'AdvGFxUI_Menu_PartyMenu'.static.CanKickPlayer(PlayerSlots[CurrentSelectedPlayerSlot].PRI))
                {
                    ButtonAliases.AddItem('KickPlayer');                    
                }
            }
        }
    }
    AddNATStatus(ButtonAliases);
    Frontend.footer.FooterUpdate(ButtonAliases);
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

function OnMute(EventData ev)
{
    MuteBtn.SetBool("focused", false);
    MuteBtn.SetBool("focused", true);
    Frontend.OpenPartyMenuWindow(0, 1);
    //return;    
}

function OnKick(EventData ev)
{
    //return;    
}

function OnBack(EventData ev)
{
    local AdvPreGameGRI PreGRI;
    local array<name> ButtonAliases;

    PreGRI = AdvPreGameGRI(GetPC().WorldInfo.GRI);
    // End:0x7E
    if((PreGRI != none) && PreGRI.ConnectingPlayerCount > 0)
    {
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

function OnSkipBtn(EventData ev)
{
    // End:0x35
    if(int(GRI.PreGameLobbyState) == int(4))
    {
        MapVoteSelected(0);
    }
    //return;    
}

function OnClassBtn(EventData ev)
{
    Action = "settings";
    PlayCloseAnimation();
    //return;    
}

function OnPlayerOver(int Index)
{
    //return;    
}

function OnSkin(EventData ev)
{
    Action = "skin";
    PlayCloseAnimation();
    //return;    
}

function OnPlayerBtn(int Index)
{
    // End:0x117
    if(PlayerSlots[Index].PRI != none)
    {
        // End:0x117
        if(Class'Engine.UIInteraction'.static.IsLoggedIn(GetLP().ControllerId) && !AdvUIManager(Class'Engine.UIManager'.static.GetUIManager()).IsAnyUIMessageActive())
        {
            Class'AdvGFxUI_Menu_PartyMenu'.static.ShowGamerCardFor(PlayerSlots[Index].PRI, GetLP().ControllerId);
        }
    }
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

function OnCloseAnimationComplete()
{
    local bool bTransitionResult;

    switch(Action)
    {
        // End:0x29
        case "back":
            LeaveMatch();
            // End:0x129
            break;
        // End:0x63
        case "settings":
            bTransitionResult = Frontend.OpenMultiPlayerSettingsScreen();
            // End:0x129
            break;
        // End:0x123
        case "skin":
            // End:0xF6
            if(int(Class'AdvUIDataStore_GameResource'.static.GetGameTypeProvider(GRI.WinningGameMode).MPGameMode) == int(3))
            {
                bTransitionResult = Frontend.OpenSurvivalSkinScreen();                
            }
            else
            {
                bTransitionResult = Frontend.OpenMultiPlayerSkinScreen();
            }
            // End:0x129
            break;
        // End:0xFFFF
        default:
            // End:0x129
            break;
            break;
    }
    // End:0x15E
    if(bTransitionResult)
    {
        AdvFrontEndParty(Frontend).ClosePregameLobbyScreen();
    }
    Action = "";
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

    MenuGame = AdvGameMenu(Class'Engine.WorldInfo'.static.GetWorldInfo().Game);
    // End:0x75
    if(MenuGame != none)
    {
        MenuGame.CleanupGameSearchRefreshing();
    }
    UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0xD6
    if(UIManager != none)
    {
        UIManager.CloseUpdatingScene();
    }
    TrackChat(false);
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x234
    if(((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none))) && NotEqual_InterfaceInterface(OnlineSub.PartyChatInterface, OnlinePartyChatInterface(none)))
    {
        OnlineSub.PlayerInterface.ClearMutingChangeDelegate(OnMutingChange);
        OnlineSub.PartyChatInterface.ClearPartyMemberListChangedDelegate(byte(GetLP().ControllerId), OnPartyMemberListChanged);
    }
    //return;    
}

function ClearResultsWindow()
{
    MapNameTF.SetText(" ");
    PlayersNumberTF.SetText(" ");
    TimeToStartTF.SetText(" ");
    VotesForSkipTF.SetText(" ");
    VotesForSkipBG.SetVisible(false);
    Class'AdvFrontEnd'.static.SetMapTexture("map_unknown", MapGfx);
    //return;    
}

function LeaveMatch()
{
    GetAdvPC().ExitFromMPGame();
    //return;    
}

function MapVoteSelected(AdvPreGameGRI.EVoteLobby Vote)
{
    local AdvPreGameLobbyPRI PRI;

    PRI = AdvPreGameLobbyPRI(GetPC().PlayerReplicationInfo);
    // End:0x145
    if((PRI != none) && !PRI.bSubmittedGameVote)
    {
        SkipBtn.SetBool("focused", false);
        SkipBtn.SetBool("focused", true);
        DisableSkipMap(true);
        PRI.SubmitGameVote(Vote);
        // End:0x13A
        if(PRI.bSubmittedGameVote)
        {
            DefaultSelectedButton.SetBool("focused", true);            
        }
        else
        {
            DisableSkipMap(false);
        }
    }
    //return;    
}

simulated function ReceivedGameVote()
{
    local string Votes;

    // End:0x59
    if(int(GRI.NextGameVoteCount) == int(0))
    {
        Votes = " ";
        VotesForSkipBG.SetVisible(false);        
    }
    else
    {
        // End:0x118
        if(int(GRI.NextGameVoteCount) == int(1))
        {
            Votes = (((((SkipMapVoteString $ " ") $ string(GRI.NextGameVoteCount)) $ " - ") $ NeededVotesString) $ " ") $ string(GRI.MinRequiredVotesToSkip);
            VotesForSkipBG.SetVisible(true);            
        }
        else
        {
            Votes = (((((SkipMapVotesString $ " ") $ string(GRI.NextGameVoteCount)) $ " - ") $ NeededVotesString) $ " ") $ string(GRI.MinRequiredVotesToSkip);
            VotesForSkipBG.SetVisible(true);
        }
    }
    VotesForSkipTF.SetText(Votes);
    //return;    
}

simulated function SelectedMapChangedByHost()
{
    local string Map, MapImage;
    local int I, StartIndex, EndIndex;
    local array<string> LocPieces;

    Map = GRI.SelectedMapName;
    I = 0;
    J0x33:

    // End:0x23B [Loop If]
    if(I < ClientMapList.Length)
    {
        // End:0x22D
        if(ClientMapList[I].MapName ~= Map)
        {
            StartIndex = InStr(Caps(ClientMapList[I].FriendlyName), "<STRINGS:");
            // End:0xDB
            if(StartIndex == -1)
            {
                // [Explicit Break]
                goto J0x23B;
            }
            Map = Right(ClientMapList[I].FriendlyName, (Len(ClientMapList[I].FriendlyName) - StartIndex) - 9);
            EndIndex = InStr(Map, ">");
            // End:0x1FB
            if(EndIndex != -1)
            {
                Map = Left(Map, EndIndex);
                ParseStringIntoArray(Map, LocPieces, ".", true);
                // End:0x1FB
                if(LocPieces.Length >= 3)
                {
                    Map = Localize(LocPieces[1], LocPieces[2], LocPieces[0]);
                }
            }
            MapImage = ClientMapList[I].PreviewImageMarkup;
        }
        I++;
        // [Loop Continue]
        goto J0x33;
    }
    J0x23B:

    // End:0x277
    if(Map != "")
    {
        MapNameTF.SetText(Map);        
    }
    else
    {
        MapNameTF.SetText(NoMapAvailableString);
    }
    MapImage = "img://" $ MapImage;
    MapGfx.SetString("source", MapImage);
    //return;    
}

function UpdateSubtitle()
{
    local string GameType;

    GameType = Class'AdvUIDataStore_GameResource'.static.GetGameTypeProvider(GRI.WinningGameMode).GameName;
    SubtitleTF.SetText(((((((GameType $ " (") $ PlayersString) $ " ") $ string(GRI.ConnectedPlayers)) $ "/") $ string(GRI.MaxPlayers)) $ ")");
    //return;    
}

simulated function LobbyStateChanged()
{
    local AdvPreGameLobbyPRI PRI;

    switch(GRI.PreGameLobbyState)
    {
        // End:0x2D
        case 0:
        // End:0xC0
        case 1:
            TimeToStartTF.SetText(PreparingGameString);
            DisableSkipMap(true);
            // End:0xBD
            if(SkipBtn.GetInt("focused") > 0)
            {
                DefaultSelectedButton.SetBool("focused", true);
            }
            // End:0x3E6
            break;
        // End:0x153
        case 2:
            TimeToStartTF.SetText(WaitingForPlayersString);
            DisableSkipMap(true);
            // End:0x150
            if(SkipBtn.GetInt("focused") > 0)
            {
                DefaultSelectedButton.SetBool("focused", true);
            }
            // End:0x3E6
            break;
        // End:0x20D
        case 3:
            PRI = AdvPreGameLobbyPRI(GetPC().PlayerReplicationInfo);
            PRI.bSubmittedGameVote = false;
            DisableSkipMap(true);
            // End:0x20D
            if(SkipBtn.GetInt("focused") > 0)
            {
                DefaultSelectedButton.SetBool("focused", true);
            }
        // End:0x2BD
        case 4:
            DisableSkipMap(!GRI.bSkipAvailable);
            // End:0x2BA
            if((SkipBtn.GetInt("focused") > 0) && !GRI.bSkipAvailable)
            {
                DefaultSelectedButton.SetBool("focused", true);
            }
            // End:0x3E6
            break;
        // End:0x2C2
        case 5:
        // End:0x355
        case 6:
            TimeToStartTF.SetText(StartingGameString);
            DisableSkipMap(true);
            // End:0x352
            if(SkipBtn.GetInt("focused") > 0)
            {
                DefaultSelectedButton.SetBool("focused", true);
            }
            // End:0x3E6
            break;
        // End:0xFFFF
        default:
            TimeToStartTF.SetText(PreparingGameString);
            DisableSkipMap(true);
            // End:0x3E3
            if(SkipBtn.GetInt("focused") > 0)
            {
                DefaultSelectedButton.SetBool("focused", true);
            }
            // End:0x3E6
            break;
            break;
    }
    //return;    
}

simulated function SelectionCountdownTick()
{
    local string Time;

    // End:0xBB
    if(int(GRI.PreGameLobbyState) == int(4))
    {
        // End:0x7F
        if(int(GRI.RemainingGameVoteSeconds) > int(0))
        {
            Time = string(GRI.RemainingGameVoteSeconds);            
        }
        else
        {
            Time = StartingGameString;
        }
        TimeToStartTF.SetText(Time);
    }
    //return;    
}

function BeginPregameCountdown()
{
    //return;    
}

function UpdateMapSelectionImageAndTitle(bool bMapSelectSuspended)
{
    //return;    
}

function UpdatePlayersPanel()
{
    local int I;

    I = 0;
    J0x0B:

    // End:0xC2 [Loop If]
    if(I < 12)
    {
        SetSlotPRI(I, none);
        SetSlotActive(I, false);
        SetSlotText(I, Class'AdvGFxUI_Menu_PartyWindow'.default.PlayerSlotAvail);
        SetSlotSpeaker(I, false);
        SetSlotIconTF(I, " ");
        SetSlotLevel(I, false);
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    // End:0x53C
    if(GRI != none)
    {
        NumPlayers = 0;
        I = 0;
        J0xE7:

        // End:0x539 [Loop If]
        if(I < GRI.PRIArray.Length)
        {
            // End:0x52B
            if((AdvPRI(GRI.PRIArray[I]) != none) && !AdvPRI(GRI.PRIArray[I]).bIsInactive)
            {
                SetSlotPRI(NumPlayers, AdvPRI(GRI.PRIArray[I]));
                SetSlotActive(NumPlayers, true);
                SetSlotText(NumPlayers, Class'AdvGFxUI_Menu_PartyWindow'.static.GetPartyFormattedPlayerName(AdvPRI(GRI.PRIArray[I])));
                SetSlotLevel(NumPlayers, true, AdvPRI(GRI.PRIArray[I]).PlayerLevel);
                // End:0x36D
                if(Class'AdvGFxUI_Menu_PartyWindow'.static.PlayerIsMuted(GRI.PRIArray[I].UniqueId, GetLP().ControllerId))
                {
                    SetSlotSpeaker(NumPlayers, true, true);
                    PlayerSlots[NumPlayers].bMuted = true;                    
                }
                else
                {
                    PlayerSlots[NumPlayers].bMuted = false;
                }
                // End:0x520
                if((GetPC().WorldInfo.IsConsoleBuild(1) && PlayerController(GRI.PRIArray[I].Owner) != none) && LocalPlayer(PlayerController(GRI.PRIArray[I].Owner).Player) != none)
                {
                    SetSlotIconTF(NumPlayers, GetControllerIcon(LocalPlayer(PlayerController(GRI.PRIArray[I].Owner).Player).ControllerId));
                }
                NumPlayers++;
            }
            I++;
            // [Loop Continue]
            goto J0xE7;
        }        
    }
    else
    {
        bForceUpdatePlayerPanel = true;
    }
    //return;    
}

function SetSlotPRI(int SlotIdx, AdvPRI PRI)
{
    // End:0x236
    if(SlotIdx < 12)
    {
        PlayerSlots[SlotIdx].PRI = PRI;
        // End:0x1B3
        if((AdvPreGameLobbyPRI(PRI) != none) && !GRI.IsPrivateCustomGame())
        {
            PlayerSlots[SlotIdx].PlayerReadyMC.SetBool("visible", true);
            PlayerSlots[SlotIdx].PlayerReadyMC.SetVisible(true);
            // End:0x16F
            if(AdvPreGameLobbyPRI(PRI).bReady)
            {
                PlayerSlots[SlotIdx].PlayerReadyMC.GotoAndStop("on");                
            }
            else
            {
                PlayerSlots[SlotIdx].PlayerReadyMC.GotoAndStop("off");
            }            
        }
        else
        {
            PlayerSlots[SlotIdx].PlayerReadyMC.SetBool("visible", false);
            PlayerSlots[SlotIdx].PlayerReadyMC.SetVisible(false);
        }
    }
    //return;    
}

function SetSlotActive(int SlotIdx, bool bIsActive)
{
    // End:0x3D9
    if(SlotIdx < 12)
    {
        // End:0x212
        if(bIsActive)
        {
            PlayerSlots[SlotIdx].PlayerSlotMC.GotoAndStop("active");
            PlayerSlots[SlotIdx].PlayerBtn.SetBool("visible", true);
            PlayerSlots[SlotIdx].PlayerBtn.SetBool("disabled", false);
            PlayerSlots[SlotIdx].PlayerReadyMC.SetBool("visible", true);
            // End:0x195
            if(!GRI.IsPrivateCustomGame())
            {
                PlayerSlots[SlotIdx].PlayerReadyMC.SetVisible(true);
            }
            // End:0x20F
            if((PlayerSlots[SlotIdx].PlayerBtn == DefaultSelectedButton) && !bInitialButtonFocus)
            {
                DefaultSelectedButton.SetBool("focused", true);
                bInitialButtonFocus = true;
            }            
        }
        else
        {
            // End:0x286
            if(PlayerSlots[SlotIdx].PlayerBtn.GetInt("focused") > 0)
            {
                DefaultSelectedButton.SetBool("focused", true);
            }
            PlayerSlots[SlotIdx].PlayerSlotMC.GotoAndStop("empty");
            PlayerSlots[SlotIdx].PlayerBtn.SetBool("disabled", true);
            PlayerSlots[SlotIdx].PlayerBtn.SetBool("visible", false);
            PlayerSlots[SlotIdx].PlayerReadyMC.SetBool("visible", false);
            PlayerSlots[SlotIdx].PlayerReadyMC.SetVisible(false);
        }
    }
    //return;    
}

function SetSlotText(int SlotIdx, string Text)
{
    // End:0x5D
    if(SlotIdx < 12)
    {
        PlayerSlots[SlotIdx].PlayerBtn.SetString("label", Text);
    }
    //return;    
}

function SetSlotIconTF(int SlotIdx, string IconButtonAlias)
{
    // End:0xA3
    if(SlotIdx < 12)
    {
        PlayerSlots[SlotIdx].PlayerIconTF.SetBool("html", true);
        PlayerSlots[SlotIdx].PlayerIconTF.SetString("htmlText", IconButtonAlias);
    }
    //return;    
}

function SetSlotSpeaker(int SlotIdx, bool bVisible, optional bool bMuted = false)
{
    // End:0xF1
    if(SlotIdx < 12)
    {
        // End:0x67
        if(bMuted)
        {
            PlayerSlots[SlotIdx].Speaker.GotoAndStop("mute");            
        }
        else
        {
            PlayerSlots[SlotIdx].Speaker.GotoAndStop("active");
        }
        PlayerSlots[SlotIdx].Speaker.SetVisible(bVisible);
    }
    //return;    
}

function SetSlotLevel(int SlotIdx, bool bVisible, optional int Level = 0)
{
    // End:0x211
    if(SlotIdx < 12)
    {
        // End:0x1CB
        if(bVisible)
        {
            // End:0xE7
            if(Level == 0)
            {
                bForceUpdatePlayerPanel = true;
                PlayerSlots[SlotIdx].PlayerLevelTF.SetText("");
                PlayerSlots[SlotIdx].Level.SetString("source", "img://UI_AdvCommon.Textures.Blank");                
            }
            else
            {
                PlayerSlots[SlotIdx].PlayerLevelTF.SetText(string(Level));
                PlayerSlots[SlotIdx].Level.SetString("source", "img://" $ Class'AdvClassInfo_MP_Base'.default.RankIconPath[Clamp(Level - 1, 0, Class'AdvClassInfo_MP_Base'.default.RankIconPath.Length)]);
            }
        }
        PlayerSlots[SlotIdx].PlayerLevelMC.SetVisible(bVisible);
    }
    //return;    
}

function TrackChat(bool bTrack)
{
    // End:0x13A
    if((GetPC().OnlineSub != none) && NotEqual_InterfaceInterface(GetPC().OnlineSub.VoiceInterface, OnlineVoiceInterface(none)))
    {
        // End:0xDE
        if(bTrack)
        {
            GetPC().OnlineSub.VoiceInterface.AddPlayerTalkingDelegate(OnPlayerTalking);            
        }
        else
        {
            GetPC().OnlineSub.VoiceInterface.ClearPlayerTalkingDelegate(OnPlayerTalking);
        }
    }
    //return;    
}

function OnPlayerTalking(UniqueNetId TalkingPlayer, bool bIsTalking)
{
    local AdvPRI TalkerPRI;

    TalkerPRI = Class'AdvGFxUI_Menu_PartyWindow'.static.ResolveUniqueNetID(TalkingPlayer);
    // End:0xBE
    if(TalkerPRI != none)
    {
        TalkerPRI.bIsTalking = bIsTalking;
        TalkerPRI.LastTalkTime = Class'Engine.WorldInfo'.static.GetWorldInfo().RealTimeSeconds;
    }
    //return;    
}

function OnMutingChange()
{
    bForceUpdatePlayerPanel = true;
    //return;    
}

function OnPartyMemberListChanged(bool bJoinedOrLeft, string PlayerName, UniqueNetId PlayerID)
{
    bForceUpdatePlayerPanel = true;
    //return;    
}

event bool FilterButtonInput(int ControllerId, name ButtonName, Object.EInputEvent InputEvent)
{
    local AdvPRI PRI;

    // End:0x341
    if((CurrentSelectedPlayerSlot > -1) && PlayerSlots[CurrentSelectedPlayerSlot].PlayerBtn.GetInt("focused") > 0)
    {
        // End:0x341
        if((GetPC().WorldInfo.IsConsoleBuild(0) || GetPC().PlayerInput.bUsingGamepad) && PlayerSlots[CurrentSelectedPlayerSlot].PRI != none)
        {
            // End:0x341
            if(((int(InputEvent) == int(0)) && ControllerId == GetLP().ControllerId) && Class'Engine.UIInteraction'.static.IsLoggedIn(GetLP().ControllerId))
            {
                // End:0x341
                if(ButtonName == 'XboxTypeS_RightShoulder')
                {
                    // End:0x297
                    if(Class'AdvGFxUI_Menu_PartyMenu'.static.CanVoteKickPlayer(PlayerSlots[CurrentSelectedPlayerSlot].PRI) && GetPC().PlayerReplicationInfo != PlayerSlots[CurrentSelectedPlayerSlot].PRI)
                    {
                        Class'AdvGFxUI_Menu_PartyMenu'.static.VoteKickPlayer(PlayerSlots[CurrentSelectedPlayerSlot].PRI, GetLP(), OnVoteKick_Confirmed);                        
                    }
                    else
                    {
                        // End:0x33F
                        if(Class'AdvGFxUI_Menu_PartyMenu'.static.CanKickPlayer(PlayerSlots[CurrentSelectedPlayerSlot].PRI))
                        {
                            Class'AdvGFxUI_Menu_PartyMenu'.static.KickPlayer(PlayerSlots[CurrentSelectedPlayerSlot].PRI, GetLP(), OnKick_Confirmed);
                        }
                    }
                    return true;
                }
            }
        }
    }
    PRI = AdvPRI(GetPC().PlayerReplicationInfo);
    // End:0x493
    if((int(GRI.LastVotingState) == int(1)) && !PRI.bSubmittedVote)
    {
        // End:0x42C
        if((ButtonName == 'XboxTypeS_Start') || string(ButtonName) == Class'AdvGFxVotingComponent'.default.YesPCKey)
        {
            PRI.SubmitVote(true);            
        }
        else
        {
            // End:0x493
            if((ButtonName == 'XboxTypeS_Back') || string(ButtonName) == Class'AdvGFxVotingComponent'.default.NoPCKey)
            {
                PRI.SubmitVote(false);
            }
        }
    }
    // End:0x4F0
    if(((TextChatComponent != none) && int(InputEvent) == int(0)) && ButtonName == 'Enter')
    {
        TextChatComponent.SendMessage();
    }
    return super.FilterButtonInput(ControllerId, ButtonName, InputEvent);
    //return ReturnValue;    
}

function bool OnVoteKick_Confirmed(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    // End:0xB2
    if((PlayerSlots[CurrentSelectedPlayerSlot].PRI != none) && SelectedInputAlias == 'AcceptKick')
    {
        Class'AdvGFxUI_Menu_PartyMenu'.static.VoteKickPlayerSubmit(PlayerSlots[CurrentSelectedPlayerSlot].PRI, AdvPRI(GetPC().PlayerReplicationInfo));
    }
    return true;
    //return ReturnValue;    
}

function bool OnKick_Confirmed(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    // End:0x8A
    if((PlayerSlots[CurrentSelectedPlayerSlot].PRI != none) && SelectedInputAlias == 'AcceptKick')
    {
        Class'AdvGFxUI_Menu_PartyMenu'.static.KickPlayerSubmit(PlayerSlots[CurrentSelectedPlayerSlot].PRI);
    }
    return true;
    //return ReturnValue;    
}

defaultproperties
{
    SkipGameString="Skip map"
    PreparingGameString="Preparing game..."
    StartingGameString="Starting game..."
    WaitingForPlayersString="Waiting for players..."
    SkipMapVotesString="Votes to skip"
    NeededVotesString="needed"
    NoMapAvailableString="No map available"
    SkipMapVoteString="Vote to skip"
    PlayersString="Players"
    PlayerReady="Ready"
    RlayerNotReady="Unready"
    TitleString="Game Lobby"
    LastSelectedIndex=-1
    MovieInfoPath="UI_AdvUI.AdvGameSearch"
}