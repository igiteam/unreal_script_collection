class AdvGameSettingsCommon extends UDKGameSettingsCommon;

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
const CONTEXT_PARTYSLOT_1_INDEX = 2;
const CONTEXT_PARTYSLOT_2_INDEX = 3;
const CONTEXT_PARTYSLOT_3_INDEX = 4;
const CONTEXT_PARTYSLOT_4_INDEX = 5;
const CONTEXT_PARTYSLOT_5_INDEX = 6;
const CONTEXT_MODULOSTEP_INDEX = 7;
const CONTEXT_LOCKEDSERVER_INDEX = 8;
const CONTEXT_DEDICATEDSERVER_INDEX = 9;
const CONTEXT_FULLSERVER_INDEX = 10;
const CONTEXT_EMPTYSERVER_INDEX = 11;

var databinding int MaxPlayers;
var databinding int MinNetPlayers;
var databinding string SteamServerId;

function SetOfficialMutatorBitmask(int MutatorBitmask)
{
    SetIntProperty(268435717, MutatorBitmask);
    //return;    
}

function BuildURL(out string OutURL)
{
    local int SettingIdx;
    local name SettingName, PropertyName;

    OutURL = "";    
    OutURL $= ("?NumPublicConnections=" $ string(NumPublicConnections));    
    OutURL $= ("?MaxPlayers=" $ string(MaxPlayers));
    SettingIdx = 0;
    J0x81:

    // End:0x221 [Loop If]
    if(SettingIdx < LocalizedSettings.Length)
    {
        SettingName = GetStringSettingName(LocalizedSettings[SettingIdx].Id);
        // End:0x213
        if(SettingName != 'None')
        {
            switch(LocalizedSettings[SettingIdx].Id)
            {
                // End:0x122
                case 38:
                    // End:0x213
                    break;
                // End:0x127
                case 31:
                // End:0x12C
                case 42:
                // End:0x131
                case 43:
                // End:0x139
                case 44:
                    // End:0x213
                    break;
                // End:0x1B9
                case 41:
                    // End:0x1B6
                    if(Class'Engine.WorldInfo'.static.IsConsoleBuild(2))
                    {                        
                        OutURL $= ((("?" $ string(SettingName)) $ "=") $ string(LocalizedSettings[SettingIdx].ValueIndex));
                    }
                    // End:0x213
                    break;
                // End:0xFFFF
                default:                    
                    OutURL $= ((("?" $ string(SettingName)) $ "=") $ string(LocalizedSettings[SettingIdx].ValueIndex));
                    // End:0x213
                    break;
                    break;
            }
        }
        SettingIdx++;
        // [Loop Continue]
        goto J0x81;
    }
    SettingIdx = 0;
    J0x22C:

    // End:0x348 [Loop If]
    if(SettingIdx < Properties.Length)
    {
        PropertyName = GetPropertyName(Properties[SettingIdx].PropertyId);
        // End:0x33A
        if(PropertyName != 'None')
        {
            switch(Properties[SettingIdx].PropertyId)
            {
                // End:0x2CD
                case 268435717:
                // End:0x2D8
                case 1073741828:
                    // End:0x33A
                    break;
                // End:0xFFFF
                default:                    
                    OutURL $= ((("?" $ string(PropertyName)) $ "=") $ (GetPropertyAsString(Properties[SettingIdx].PropertyId)));
                    // End:0x33A
                    break;
                    break;
            }
        }
        SettingIdx++;
        // [Loop Continue]
        goto J0x22C;
    }
    //return;    
}

function UpdateFromURL(const out string URL, GameInfo Game)
{
    local string Description, CustomMapName, RealDescription, BotSkillString, BotCountString, PlaylistIdString;

    local int Playlist;

    super(Settings).UpdateFromURL(URL, Game);
    Description = GetPropertyAsString(1073741827);
    NumPublicConnections = Clamp(NumPublicConnections, 0, Game.MaxPlayers);
    NumPrivateConnections = Clamp(NumPrivateConnections, 0, Game.MaxPlayers - NumPublicConnections);
    // End:0xDF
    if(StringToBlob(Description, RealDescription))
    {
        SetStringProperty(1073741827, RealDescription);
    }
    CustomMapName = Class'Engine.GameInfo'.static.ParseOption(URL, "CustomMapName");
    // End:0x14C
    if(CustomMapName != "")
    {
        SetPropertyFromStringByName('CustomMapName', CustomMapName);
    }
    BotSkillString = Class'Engine.GameInfo'.static.ParseOption(URL, "Difficulty");
    // End:0x1B9
    if(BotSkillString != "")
    {
        SetStringSettingValueByName('BotSkill', int(BotSkillString), true);
    }
    BotCountString = Class'Engine.GameInfo'.static.ParseOption(URL, "NumPlay");
    // End:0x221
    if(BotCountString != "")
    {
        SetIntProperty(268435703, int(BotCountString) - 1);
    }
    // End:0x2A3
    if((int(Game.WorldInfo.NetMode) == int(NM_DedicatedServer)) || Class'Engine.GameInfo'.static.HasOption(URL, "Dedicated"))
    {
        bIsDedicated = true;
    }
    // End:0x339
    if(bIsDedicated)
    {
        SetStringSettingValue(44, 1, true);
        PlaylistIdString = Class'Engine.GameInfo'.static.ParseOption(URL, "PlaylistId");
        // End:0x339
        if(PlaylistIdString != "")
        {
            Playlist = int(PlaylistIdString);
            SetIntProperty(268435457, Playlist);
        }
    }
    //return;    
}

function SetMutators(const out string URL)
{
    local DataStoreClient DSClient;
    local UTUIDataStore_MenuItems MenuDataStore;
    local string MutatorURLValue;
    local array<string> MutatorClassNames;

    DSClient = Class'Engine.UIInteraction'.static.GetDataStoreClient();
    // End:0xEE
    if(DSClient != none)
    {
        MenuDataStore = UTUIDataStore_MenuItems(DSClient.FindDataStore('UTMenuItems'));
        // End:0xEE
        if(MenuDataStore != none)
        {
            MutatorURLValue = Class'Engine.GameInfo'.static.ParseOption(URL, "Mutator");
            // End:0xEE
            if(MutatorURLValue != "")
            {
                ParseStringIntoArray(MutatorURLValue, MutatorClassNames, ",", true);
            }
        }
    }
    SetOfficialMutatorBitmask(GenerateMutatorBitmaskFromURL(MenuDataStore, MutatorClassNames));
    SetCustomMutators(MenuDataStore, MutatorClassNames);
    //return;    
}

function int GenerateMutatorBitmaskFromURL(UTUIDataStore_MenuItems MenuDataStore, out array<string> MutatorClassNames)
{
    local int Idx, EnabledMutatorBitmask;
    local string GameModeString;
    local UIDataStore_Registry Registry;
    local array<UIResourceDataProvider> Providers;
    local int I;
    local UTUIDataProvider_Mutator MutatorProvider;

    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    Registry.GetData("SelectedGameMode", GameModeString);
    Registry.SetData("SelectedGameMode", "");
    Idx = 0;
    J0xB4:

    // End:0x1E1 [Loop If]
    if(Idx < MutatorClassNames.Length)
    {
        MenuDataStore.GetResourceProviders('OfficialMutators', Providers);
        I = 0;
        J0x108:

        // End:0x1D3 [Loop If]
        if(I < Providers.Length)
        {
            MutatorProvider = UTUIDataProvider_Mutator(Providers[I]);
            // End:0x1C5
            if((MutatorProvider != none) && MutatorProvider.ClassName == MutatorClassNames[Idx])
            {
                EnabledMutatorBitmask = EnabledMutatorBitmask | (1 << I);
                MutatorClassNames.Remove(Idx--, 1);                
            }
            I++;
            // [Loop Continue]
            goto J0x108;
        }
        Idx++;
        // [Loop Continue]
        goto J0xB4;
    }
    Registry.SetData("SelectedGameMode", GameModeString);
    return EnabledMutatorBitmask;
    //return ReturnValue;    
}

function SetCustomMutators(UTUIDataStore_MenuItems MenuDataStore, const out array<string> MutatorClassNames)
{
    local int Idx;
    local string CustomMutators, CustomMutatorDelimiter;
    local array<UIResourceDataProvider> Providers;
    local int I;
    local UTUIDataProvider_Mutator MutatorProvider;

    CustomMutatorDelimiter = Chr(28);
    Idx = 0;
    J0x19:

    // End:0x16F [Loop If]
    if(Idx < MutatorClassNames.Length)
    {
        MenuDataStore.GetResourceProviders('Mutators', Providers);
        I = 0;
        J0x6D:

        // End:0x161 [Loop If]
        if(I < Providers.Length)
        {
            MutatorProvider = UTUIDataProvider_Mutator(Providers[I]);
            // End:0x153
            if((MutatorProvider != none) && MutatorProvider.ClassName == MutatorClassNames[Idx])
            {
                // End:0x120
                if(CustomMutators != "")
                {                    
                    CustomMutators $= CustomMutatorDelimiter;
                }                
                CustomMutators $= MutatorProvider.FriendlyName;
            }
            I++;
            // [Loop Continue]
            goto J0x6D;
        }
        Idx++;
        // [Loop Continue]
        goto J0x19;
    }
    SetStringProperty(1073741828, CustomMutators);
    //return;    
}

function string GetSettingOptionName(int OptionId)
{
    local string KeyName;
    local int Index;

    Index = LocalizedSettingsMappings.Find('Id', OptionId);    
    // End:0xA1
    if(Index != -1)
    {
        KeyName = string(LocalizedSettingsMappings[Index].Name);
        return Localize("GameSettingsOptions", KeyName, "GearGame");
    }
    return "";
    //return ReturnValue;    
}

static function int GetGameModeFromPlaylistId(OnlinePlaylistManager PlaylistMan, int PlaylistId)
{
    local int LoadBalanceId;

    // End:0x40
    if(PlaylistMan != none)
    {
        PlaylistMan.GetLoadBalanceIdFromPlaylist(PlaylistId, LoadBalanceId);
    }
    switch(LoadBalanceId)
    {
        // End:0x5A
        case 1:
            return 13;
        // End:0x62
        case 2:
            return 14;
        // End:0x6A
        case 3:
            return 15;
        // End:0x72
        case 4:
            return 16;
        // End:0x7A
        case 5:
            return 17;
        // End:0x82
        case 6:
            return 18;
        // End:0x8A
        case 7:
            return 19;
        // End:0x92
        case 8:
            return 20;
        // End:0xFFFF
        default:
            return 1;
            break;
    }
    //return ReturnValue;    
}

static function bool IsVersusGameMode(int GameModeIdx)
{
    return ((((((((GameModeIdx == 1) || GameModeIdx == 13) || GameModeIdx == 14) || GameModeIdx == 15) || GameModeIdx == 16) || GameModeIdx == 17) || GameModeIdx == 18) || GameModeIdx == 19) || GameModeIdx == 20;
    //return ReturnValue;    
}

defaultproperties
{
    MaxPlayers=12
    NumPublicConnections=12
    bAllowInvites=false
    bUsesPresence=false
    bAllowJoinViaPresence=false
    LocalizedSettings=/* Array type was not detected. */
    Properties=/* Array type was not detected. */
    LocalizedSettingsMappings=/* Array type was not detected. */
    PropertyMappings=/* Array type was not detected. */
}