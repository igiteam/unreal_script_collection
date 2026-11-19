class PKGame extends EvilGame
    native
    config(Game)
    hidecategories(Navigation,Movement,Collision);

const PK_TITLEID_PAINKILLER_HELL___DAMNATION = 0x354807D1;
const PK_CONTEXT_CHAPTERBEINGPLAYED = 3;
const PK_CONTEXT_MULTIPLAYERMODE = 7;
const PK_CONTEXT_MULTIMAPS = 9;
const PK_CONTEXT_COOPCHARACTER = 10;
const PK_CONTEXT_CHAPTERBEINGPLAYED_LID_INVALID = 0;
const PK_CONTEXT_CHAPTERBEINGPLAYED_LID_CEMETERY = 1;
const PK_CONTEXT_CHAPTERBEINGPLAYED_LID_CATHEDRAL = 2;
const PK_CONTEXT_CHAPTERBEINGPLAYED_LID_ATRIUMCOMPLEX = 3;
const PK_CONTEXT_CHAPTERBEINGPLAYED_LID_ENCLAVE = 4;
const PK_CONTEXT_CHAPTERBEINGPLAYED_LID_OPERA = 5;
const PK_CONTEXT_CHAPTERBEINGPLAYED_LID_TRAINSTATION = 6;
const PK_CONTEXT_CHAPTERBEINGPLAYED_LID_ALASTOR = 7;
const PK_CONTEXT_CHAPTERBEINGPLAYED_LID_ORIENTALCASTLE = 8;
const PK_CONTEXT_CHAPTERBEINGPLAYED_LID_ORPHANAGE = 9;
const PK_CONTEXT_CHAPTERBEINGPLAYED_LID_SWAMP = 10;
const PK_CONTEXT_CHAPTERBEINGPLAYED_LID_LOONYPARK = 11;
const PK_CONTEXT_CHAPTERBEINGPLAYED_LID_COLLOSEUM = 12;
const PK_CONTEXT_CHAPTERBEINGPLAYED_LID_SHADOWLAND = 13;
const PK_CONTEXT_CHAPTERBEINGPLAYED_LID_CITYONWATER = 14;
const PK_CONTEXT_CHAPTERBEINGPLAYED_LID_LAB = 15;
const PK_CONTEXT_CHAPTERBEINGPLAYED_LID_FACTORY = 16;
const PK_CONTEXT_CHAPTERBEINGPLAYED_LID_TUTORIAL = 17;
const PK_CONTEXT_CHAPTERBEINGPLAYED_LID_HOSPITAL = 18;
const PK_CONTEXT_CHAPTERBEINGPLAYED_LID_TUTORIAL1 = 19;
const PK_CONTEXT_CHAPTERBEINGPLAYED_LID_DLC1 = 20;
const PK_CONTEXT_CHAPTERBEINGPLAYED_LID_DLC2 = 21;
const PK_CONTEXT_CHAPTERBEINGPLAYED_LID_DLC3 = 22;
const PK_CONTEXT_CHAPTERBEINGPLAYED_LID_DLC4 = 23;
const PK_CONTEXT_CHAPTERBEINGPLAYED_LID_DLC5 = 24;
const PK_CONTEXT_CHAPTERBEINGPLAYED_LID_DLC6 = 25;
const PK_CONTEXT_CHAPTERBEINGPLAYED_LID_DLC7 = 26;
const PK_CONTEXT_CHAPTERBEINGPLAYED_LID_DLC8 = 27;
const PK_CONTEXT_CHAPTERBEINGPLAYED_LID_DLC9 = 28;
const PK_CONTEXT_CHAPTERBEINGPLAYED_LID_DLC10 = 29;
const PK_CONTEXT_MULTIPLAYERMODE_DEATHMATCH = 0;
const PK_CONTEXT_MULTIPLAYERMODE_TEAMDEATHMATCH = 1;
const PK_CONTEXT_MULTIPLAYERMODE_CTF = 2;
const PK_CONTEXT_MULTIPLAYERMODE_SURVIVAL = 3;
const PK_CONTEXT_MULTIMAPS_E_MM_CURSED = 0;
const PK_CONTEXT_MULTIMAPS_E_MM_CURSED_HD = 1;
const PK_CONTEXT_MULTIMAPS_E_MM_FORBIDDEN = 2;
const PK_CONTEXT_MULTIMAPS_E_MM_FORBIDDEN_HD = 3;
const PK_CONTEXT_MULTIMAPS_E_MM_FALLEN_ONE = 4;
const PK_CONTEXT_MULTIMAPS_E_MM_FALLEN_ONE_HD = 5;
const PK_CONTEXT_MULTIMAPS_E_MM_SACRED = 6;
const PK_CONTEXT_MULTIMAPS_E_MM_SACRED_HD = 7;
const PK_CONTEXT_MULTIMAPS_E_MM_UNSEEN = 8;
const PK_CONTEXT_MULTIMAPS_E_MM_UNSEEN_HD = 9;
const PK_CONTEXT_MULTIMAPS_E_MN_ATRIUM_COMPLEX = 10;
const PK_CONTEXT_MULTIMAPS_E_MN_CITYONWATER = 11;
const PK_CONTEXT_MULTIMAPS_E_MN_OPERA = 12;
const PK_CONTEXT_MULTIMAPS_E_MN_TRAINSTATION = 13;
const PK_CONTEXT_MULTIMAPS_E_MN_DLC1 = 14;
const PK_CONTEXT_MULTIMAPS_E_MN_DLC2 = 15;
const PK_CONTEXT_MULTIMAPS_E_MN_DLC3 = 16;
const PK_CONTEXT_MULTIMAPS_E_MN_DLC4 = 17;
const PK_CONTEXT_MULTIMAPS_E_MN_DLC5 = 18;
const PK_CONTEXT_MULTIMAPS_E_MN_DLC6 = 19;
const PK_CONTEXT_MULTIMAPS_E_MN_DLC7 = 20;
const PK_CONTEXT_MULTIMAPS_E_MN_DLC8 = 21;
const PK_CONTEXT_MULTIMAPS_E_MN_DLC9 = 22;
const PK_CONTEXT_MULTIMAPS_E_MN_DLC10 = 23;
const PK_CONTEXT_COOPCHARACTER_DANIEL = 0;
const PK_CONTEXT_COOPCHARACTER_EVE = 1;
const PK_CONTEXT_PRESENCE_IDLE = 0;
const PK_CONTEXT_PRESENCE_PARTY_PUBLIC_SEARCH = 1;
const PK_CONTEXT_PRESENCE_PARTY_PUBLIC_WAIT = 2;
const PK_CONTEXT_PRESENCE_PARTY_PRIVATE = 3;
const PK_CONTEXT_PRESENCE_MENU = 4;
const PK_CONTEXT_PRESENCE_SINGLE = 5;
const PK_CONTEXT_PRESENCE_COOP = 6;
const PK_CONTEXT_PRESENCE_COOP_PRIVATE = 7;
const PK_CONTEXT_PRESENCE_MULTI = 8;
const PK_CONTEXT_GAME_MODE_SINGLE = 0;
const PK_CONTEXT_GAME_MODE_COOP = 1;
const PK_CONTEXT_GAME_MODE_DEATHMATCH = 2;
const PK_CONTEXT_GAME_MODE_TEAMDEATHMATCH = 3;
const PK_CONTEXT_GAME_MODE_CTF = 4;
const PK_CONTEXT_GAME_MODE_SURVIVAL = 5;
const PK_PROPERTY_TIMELIMIT = 0x10000002;
const PK_PROPERTY_GOALSCORE = 0x10000003;
const PK_PROPERTY_LEADERBOARDS_SINGLE_KILLS = 0x10000013;
const PK_PROPERTY_LEADERBOARDS_SINGLE_GIBBEDENEMIES = 0x10000014;
const PK_PROPERTY_LEADERBOARDS_SINGLE_COLLECTEDGOLD = 0x10000015;
const PK_PROPERTY_LEADERBOARDS_DM_KILLS = 0x10000016;
const PK_PROPERTY_LEADERBOARDS_DM_DEATHS = 0x10000017;
const PK_PROPERTY_LEADERBOARDS_DM_MATCHESWON = 0x10000018;
const PK_PROPERTY_LEADERBOARDS_MULTI_SV_SCORE = 0x10000019;
const PK_PROPERTY_LEADERBOARDS_MULTI_SV_ENEMIESKILLED = 0x1000001A;
const PK_PROPERTY_LEADERBOARDS_MULTI_SV_MATCHES = 0x1000001B;
const PK_PROPERTY_LEADERBOARDS_MULTI_CTF_SCORE = 0x1000001C;
const PK_PROPERTY_LEADERBOARDS_MULTI_CTF_FLAGSCAPTURED = 0x1000001D;
const PK_PROPERTY_LEADERBOARDS_MULTI_CTF_FLAGRETURNED = 0x1000001E;
const PK_PROPERTY_LEADERBOARDS_POINTSRATED = 0x2000001F;
const PK_ACHIEVEMENT_EPKA_UNLOCKED_CARD_G_ENDURANCE = 1;
const PK_ACHIEVEMENT_EPKA_UNLOCKED_CARD_G_HASTE = 2;
const PK_ACHIEVEMENT_EPKA_UNLOCKED_CARD_G_TIMEBONUS = 3;
const PK_ACHIEVEMENT_EPKA_UNLOCKED_CARD_G_SPEED = 4;
const PK_ACHIEVEMENT_EPKA_UNLOCKED_CARD_G_FURY = 5;
const PK_ACHIEVEMENT_EPKA_UNLOCKED_CARD_G_DOUBLEHASTE = 6;
const PK_ACHIEVEMENT_EPKA_UNLOCKED_CARD_G_DEXTERITY = 7;
const PK_ACHIEVEMENT_EPKA_UNLOCKED_CARD_G_IRONWILL = 8;
const PK_ACHIEVEMENT_EPKA_UNLOCKED_CARD_G_RAGE = 9;
const PK_ACHIEVEMENT_EPKA_UNLOCKED_CARD_G_DOUBLETIMEBONUS = 10;
const PK_ACHIEVEMENT_EPKA_UNLOCKED_CARD_G_TRIPLEHASTE = 11;
const PK_ACHIEVEMENT_EPKA_UNLOCKED_CARD_G_CONFUSION = 12;
const PK_ACHIEVEMENT_EPKA_UNLOCKED_CARD_S_SOULKEEPER = 13;
const PK_ACHIEVEMENT_EPKA_UNLOCKED_CARD_S_BLESSING = 14;
const PK_ACHIEVEMENT_EPKA_UNLOCKED_CARD_S_REPLENISH = 15;
const PK_ACHIEVEMENT_EPKA_UNLOCKED_CARD_S_DARKSOUL = 16;
const PK_ACHIEVEMENT_EPKA_UNLOCKED_CARD_S_SOULCATCHER = 17;
const PK_ACHIEVEMENT_EPKA_UNLOCKED_CARD_S_FORGIVENESS = 18;
const PK_ACHIEVEMENT_EPKA_UNLOCKED_CARD_S_GREED = 19;
const PK_ACHIEVEMENT_EPKA_UNLOCKED_CARD_S_VITALITY = 20;
const PK_ACHIEVEMENT_EPKA_UNLOCKED_CARD_S_DIVINEINTERVENTION = 21;
const PK_ACHIEVEMENT_EPKA_UNLOCKED_CARD_S_LASTBREATH = 22;
const PK_ACHIEVEMENT_EPKA_UNLOCKED_CARD_S_SOULREDEEMER = 23;
const PK_ACHIEVEMENT_EPKA_UNLOCKED_CARD_S_MERCY = 24;
const PK_ACHIEVEMENT_EPKA_KILL_666_ENEMIES = 25;
const PK_ACHIEVEMENT_EPKA_KILL_999_ENEMIES = 26;
const PK_ACHIEVEMENT_EPKA_COLLECT_2012_GOLD = 27;
const PK_ACHIEVEMENT_EPKA_FIND_25_SECRET_AREAS = 28;
const PK_ACHIEVEMENT_EPKA_FINISH_FIRST_CHAPTER = 29;
const PK_ACHIEVEMENT_EPKA_FINISH_SECOND_CHAPTER = 30;
const PK_ACHIEVEMENT_EPKA_FINISH_THIRDCHAPTER = 31;
const PK_ACHIEVEMENT_EPKA_COLLECT_667_SOULS = 32;
const PK_ACHIEVEMENT_EPKA_SHOOT_50000_TIMES = 33;
const PK_ACHIEVEMENT_EPKA_PLAY_10_LEVELS_IN_COOP = 34;
const PK_ACHIEVEMENT_EPKA_COLLECT_500_AMMO_CRATES = 35;
const PK_ACHIEVEMENT_EPKA_DESTROY_300_EXPLO_BARRELS = 36;
const PK_ACHIEVEMENT_EPKA_KILL_333_ENEMIES_WITH_EXPLOSIVES = 37;
const PK_ACHIEVEMENT_EPKA_KILL_5_ENEMIES_WITH_ONE_ROCKET = 38;
const PK_ACHIEVEMENT_EPKA_SPEND_666_SEC_BUNNY_HOP = 39;
const PK_ACHIEVEMENT_EPKA_GIB_100_ENEMIES = 40;
const PK_ACHIEVEMENT_EPKA_FINISH_GAME_ON_NIGHTMARE = 41;
const PK_ACHIEVEMENT_EPKA_FINISH_GAME_ON_TRAUMA = 42;
const PK_ACHIEVEMENT_EPKA_COLLECT_40_ARMORS = 43;
const PK_ACHIEVEMENT_EPKA_FINISH_LEVEL_WITH_STAKEGUN_ONLY = 44;
const PK_ACHIEVEMENT_EPKA_KILL_10000_ENEMIES = 45;
const PK_ACHIEVEMENT_EPKA_KILL_500_ENEMIES_WITH_ENV_DAMAGE = 46;
const PK_ACHIEVEMENT_EPKA_KILL_123_ENEMIES_WITH_COMBO_DMG = 47;
const PK_ACHIEVEMENT_EPKA_CAPTURE_3_FLAGS_AS_EVE = 48;
const PK_ACHIEVEMENT_EPKA_KILL_1000_ENEMIES_IN_SV = 49;
const PK_ACHIEVEMENT_EPKA_30KILLSIN3MIN_INDEATHMATCH = 50;
const PK_STATS_VIEW_SKILL_RANKED_SINGLE = 0xFFFF0000;
const PK_STATS_VIEW_SKILL_RANKED_COOP = 0xFFFF0001;
const PK_STATS_VIEW_SKILL_RANKED_DEATHMATCH = 0xFFFF0002;
const PK_STATS_VIEW_SKILL_RANKED_TEAMDEATHMATCH = 0xFFFF0003;
const PK_STATS_VIEW_SKILL_RANKED_CTF = 0xFFFF0004;
const PK_STATS_VIEW_SKILL_RANKED_SURVIVAL = 0xFFFF0005;
const PK_STATS_VIEW_SKILL_STANDARD_SINGLE = 0xFFFE0000;
const PK_STATS_VIEW_SKILL_STANDARD_COOP = 0xFFFE0001;
const PK_STATS_VIEW_SKILL_STANDARD_DEATHMATCH = 0xFFFE0002;
const PK_STATS_VIEW_SKILL_STANDARD_TEAMDEATHMATCH = 0xFFFE0003;
const PK_STATS_VIEW_SKILL_STANDARD_CTF = 0xFFFE0004;
const PK_STATS_VIEW_SKILL_STANDARD_SURVIVAL = 0xFFFE0005;
const PK_STATS_VIEW_MUTLIPLAYER_CTF = 14;
const PK_STATS_VIEW_MULTIPLAYER_SV = 15;
const PK_STATS_VIEW_CAMPAIGN = 17;
const PK_STATS_VIEW_MULTIPLAYER_DM = 18;
const PK_STATS_VIEW_MULTIPLAYER_TDM = 19;
const PK_STATS_COLUMN_MUTLIPLAYER_CTF_SCORE = 4;
const PK_STATS_COLUMN_MUTLIPLAYER_CTF_FLAGSCORE = 2;
const PK_STATS_COLUMN_MUTLIPLAYER_CTF_FLAGSRETURNED = 3;
const PK_STATS_COLUMN_MULTIPLAYER_SV_SCORE = 4;
const PK_STATS_COLUMN_MULTIPLAYER_SV_ENEMIESKILLED = 1;
const PK_STATS_COLUMN_MULTIPLAYER_SV_MATCHES = 2;
const PK_STATS_COLUMN_CAMPAIGN_KILLS = 4;
const PK_STATS_COLUMN_CAMPAIGN_ENEMIESGIBBED = 1;
const PK_STATS_COLUMN_CAMPAIGN_GOLDSCORE = 2;
const PK_STATS_COLUMN_MULTIPLAYER_DM_KILLS = 4;
const PK_STATS_COLUMN_MULTIPLAYER_DM_DEATHS = 1;
const PK_STATS_COLUMN_MULTIPLAYER_DM_MATCHES = 2;
const PK_STATS_COLUMN_MULTIPLAYER_TDM_KILLS = 4;
const PK_STATS_COLUMN_MULTIPLAYER_TDM_DEATHS = 1;
const PK_STATS_COLUMN_MULTIPLAYER_TDM_MATCHES = 2;
const PK_SESSION_MATCH_QUERY_DEATCHMATCH = 0;
const PK_SESSION_MATCH_QUERY_TEAMDEATCHMATCH = 1;
const PK_SESSION_MATCH_QUERY_CTF = 2;
const PK_SESSION_MATCH_QUERY_SURVIVAL = 3;
const PK_SESSION_MATCH_QUERY_COOP = 4;
const PK_SESSION_MATCH_QUERY_CUSTOM = 5;

var bool bURLDifficultyOverride;
var bool bSpawnSkeletons;
var bool bAttractSouls;
var bool bGreedCardEnabled;
var bool bLastBreathCardEnabled;
var bool bGoldenCardsActive;
var bool bPlayerNoDamage;
var bool bConfuseEnemies;
var bool bStealHealth;
var bool bArmorRegenEnabled;
var bool bHealthRegenEnabled;
var PKTypes.EDifficultyLevel SplitCoopPlayerDifficulty;
var PKTarotManager.EGoldenTarrotCard SelectedGoldCards[3];
var PKTarotManager.ESilverTarrotCard SelectedSilverCards[2];
var config float SoulAutoCatchDistance;
var float SoulHealthFactor;
var config float SoulHealthFactorWithRedeemer;
var float SoulStayFactor;
var config float SoulStayFactorWithKeeper;
var float AmmoFoundFactor;
var config float AmmoFoundFactorWithReplenish;
var config int SoulsToEnableDemon;
var config int SoulsToEnableDemonWithDarkSoul;
var config int InitialPlayerHealth;
var config int InitialPlayerHealthWithBlessing;
var config int PlayerHealthCapacity;
var config int InitialPlayerHealthWithVitality;
var config int PlayerHealthCapacityWithVitality;
var config int PlayerHealthLastBreath;
var int GoldenCardsUseLeft;
var int GoldenCardTimeout;
var int GoldenCardWarnBeforeEndTime;
var float PlayerDamageFactor;
var float MonsterDamageFactor;
var float PlayerSpeedFactor;
var float ReloadSpeedFactor;
var config float MonsterInitialHealthModifierCard;
var float MonsterInitialHealthModifier;
var config float StealHealthPctCard;
var float StealHealthPct;
var config float ArmorRegenSpeedCard;
var float ArmorRegenSpeed;
var config float HealthRegenSpeedCard;
var float HealthRegenSpeed;
var(PKPlayerPhysics) config float PlayerAccelRate;
var(PKPlayerPhysics) config float PlayerSpeed;
var(PKPlayerPhysics) config float MaximalBunnyHopSpeed;
var(PKPlayerPhysics) config float BunnyHopAcceleration;
var(PKPlayerPhysics) config float JumpStrength;
var(PKPlayerPhysics) config float PlayerGravity;
var(PKPlayerPhysics) config float SecondsWhenYouCanBunnyHopAfterLanding;
var(PKPlayerPhysics) config float SecondsWhenYouCanBunnyHopBeforeLanding;
var(PKPlayerPhysics) config float SecondsWhenYouCanJumpBeforeLanding;
var(PKPlayerPhysics) config float UnderwaterSpeed;
var(PKPlayerPhysics) config float PlayerSlowdownDuringJump;
var(PKPlayerPhysics) config float StrongAirControl;
var(PKPlayerPhysics) config float WeakAirControl;
var(PKPlayerPhysics) config float CollisionMinSpeed;
var(PKPlayerPhysics) config float CollisionMaxSpeed;

final function PainGRI GetGRI()
{
    return PainGRI(GameReplicationInfo);
    //return ReturnValue;    
}

function PostBeginPlay()
{
    super.PostBeginPlay();
    //return;    
}

function bool AllowCheats(PlayerController P)
{
    return false;
    //return ReturnValue;    
}

event InitGame(string Options, out string ErrorMessage)
{
    local string InOpt;

    super(GameInfo).InitGame(Options, ErrorMessage);
    InOpt = ParseOption(Options, "Console");
    // End:0xB7
    if((InOpt != "") || WorldInfo.IsConsoleBuild())
    {
        WorldInfo.bUseConsoleInput = true;
        bConsoleServer = true;
        PlayerControllerClass = ConsolePlayerControllerClass;
    }
    // End:0xE6
    if(WorldInfo.IsConsoleBuild())
    {
        bAllowKeyboardAndMouse = true;
    }
    //return;    
}

function InitGameReplicationInfo()
{
    local PainGRI GRI;

    super(GameInfo).InitGameReplicationInfo();
    GRI = GetGRI();
    // End:0x57
    if(GRI != none)
    {
        GRI.bAllowKeyboardAndMouse = bAllowKeyboardAndMouse;
    }
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
    local bool bDedicatedServerSpectator;
    local PainPRI PRI;

    // End:0x90
    if(((NumPlayers == 0) && int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && HasOption(Options, "dedicated"))
    {
        bDedicatedServerSpectator = true;        
        Options $= "?SpectatorOnly=1";
    }
    NewPlayer = super(GameInfo).Login(Portal, Options, UniqueId, ErrorMessage);
    // End:0x155
    if((HasOption(Options, "coopdifficulty")) && (GetIntOption(Options, "coopdifficulty", -1)) >= 0)
    {
        SplitCoopPlayerDifficulty = byte(GetIntOption(Options, "coopdifficulty", -1));        
    }
    else
    {
        SplitCoopPlayerDifficulty = 255;
    }
    // End:0x1B0
    if(UTPlayerController(NewPlayer) != none)
    {
        // End:0x1B0
        if(bDedicatedServerSpectator)
        {
            UTPlayerController(NewPlayer).bDedicatedServerSpectator = true;
        }
    }
    // End:0x37F
    if(NewPlayer != none)
    {
        PRI = PainPRI(NewPlayer.PlayerReplicationInfo);
        // End:0x357
        if(PRI != none)
        {
            // End:0x256
            if(HasOption(Options, "Daydream"))
            {
                bURLDifficultyOverride = true;
                PRI.Difficulty = Class'PainDifficultySettings_Daydream';                
            }
            else
            {
                // End:0x2AD
                if(HasOption(Options, "Insomnia"))
                {
                    bURLDifficultyOverride = true;
                    PRI.Difficulty = Class'PainDifficultySettings_Insomnia';                    
                }
                else
                {
                    // End:0x305
                    if(HasOption(Options, "Nightmare"))
                    {
                        bURLDifficultyOverride = true;
                        PRI.Difficulty = Class'PainDifficultySettings_Nightmare';                        
                    }
                    else
                    {
                        // End:0x357
                        if(HasOption(Options, "Trauma"))
                        {
                            bURLDifficultyOverride = true;
                            PRI.Difficulty = Class'PainDifficultySettings_Trauma';
                        }
                    }
                }
            }
        }
        PKPlayerController(NewPlayer).UpdateDifficultySetting();
    }
    return NewPlayer;
    //return ReturnValue;    
}

function RestartPlayer(Controller aPlayer)
{
    super(GameInfo).RestartPlayer(aPlayer);
    // End:0x6B
    if(aPlayer.Pawn != none)
    {
        aPlayer.Pawn.ClientRestart();
    }
    // End:0x9F
    if(PlayerController(aPlayer) != none)
    {
        UpdateGameplayMuteList(PlayerController(aPlayer));
    }
    //return;    
}

event bool IsSPGame()
{
    return ClassIsChildOf(self.Class, Class'PKGameSP');
    //return ReturnValue;    
}

function GenericPlayerInitialization(Controller C)
{
    // End:0x22
    if(!bUseClassicHUD)
    {
        HUDType = Class'PainGFxHudWrapper';
    }
    super(GameInfo).GenericPlayerInitialization(C);
    //return;    
}

event PostLogin(PlayerController NewPlayer)
{
    local PainGRI_SP GRISP;

    super(GameInfo).PostLogin(NewPlayer);
    // End:0x3F
    if(!IsTimerActive('DelayedUpdateSettings'))
    {
        SetTimer(0.5000000, false, 'DelayedUpdateSettings');
    }
    GRISP = PainGRI_SP(WorldInfo.GRI);
    // End:0xDF
    if((PKPlayerController(NewPlayer) != none) && GRISP != none)
    {
        PKPlayerController(NewPlayer).ClientCheckIfIsJanuaryWeekendSubscribed(GRISP.ChapterNum);
    }
    //return;    
}

function Logout(Controller Exiting)
{
    local PKPlayerController PC;

    PC = PKPlayerController(Exiting);
    // End:0x4A
    if(PC != none)
    {
        PC.CleanupSteamLobby();
    }
    UpdateGameSettingsCounts();
    UpdateGameSettings();
    super.Logout(Exiting);
    //return;    
}

function DelayedUpdateSettings()
{
    // End:0x98
    if((int(WorldInfo.NetMode) != int(NM_Client)) && GameReplicationInfo.IsCoopMultiplayerGame() || GameReplicationInfo.IsMultiplayerGame())
    {
        UpdateGameSettingsCounts();
        UpdateGameSettings();
        SetTimer(15.0000000, false, 'DelayedUpdateSettings');
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
    // End:0x146
    if(((PKPlayerPawn(KilledPawn) != none) && bLastBreathCardEnabled) && !DamageType.default.bCausedByWorld)
    {
        bLastBreathCardEnabled = false;
        KilledPawn.Health = PKGame(WorldInfo.Game).PlayerHealthLastBreath;
        // End:0x144
        if((KilledPawn.Controller != none) && PKPlayerController(KilledPawn.Controller) != none)
        {
            PKPlayerController(KilledPawn.Controller).ClientPlayResurrectEfect();
        }
        return true;
    }
    return false;
    //return ReturnValue;    
}

function ReduceDamage(out int Damage, Pawn injured, Controller InstigatedBy, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType, Actor DamageCauser)
{
    super.ReduceDamage(Damage, injured, InstigatedBy, HitLocation, Momentum, DamageType, DamageCauser);
    // End:0xBD
    if((PKPlayerController(injured.Controller) != none) && injured.Controller.IsInState('Demon'))
    {
        Damage = 0;
    }
    //return;    
}

function OnGoldenCardUnlocked(PKPlayerController PKPC, PKTarotManager.EGoldenTarrotCard InCardId)
{
    //return;    
}

function OnSilverCardUnlocked(PKPlayerController PKPC, PKTarotManager.ESilverTarrotCard InCardId)
{
    //return;    
}

function ApplyCards()
{
    //return;    
}

function EnableConfuseEnemies()
{
    local PKAIController PKAI;

    // End:0x0F
    if(bConfuseEnemies)
    {
        return;
    }
    bConfuseEnemies = true;
    // End:0x6F
    foreach WorldInfo.AllControllers(Class'PKAIController', PKAI)
    {
        PKAI.NotifyConfused();        
    }    
    //return;    
}

function DisableConfuseEnemies()
{
    local PKAIController PKAI;

    // End:0x11
    if(!bConfuseEnemies)
    {
        return;
    }
    bConfuseEnemies = false;
    // End:0x71
    foreach WorldInfo.AllControllers(Class'PKAIController', PKAI)
    {
        PKAI.NotifyUnconfused();        
    }    
    //return;    
}

function DeactivateGoldenCards()
{
    local PKPlayerController aPlayer;

    bGoldenCardsActive = false;
    DisableBulletTime();
    PlayerDamageFactor = 1.0000000;
    PlayerDamageFactor = 1.0000000;
    MonsterDamageFactor = 1.0000000;
    bPlayerNoDamage = false;
    bConfuseEnemies = false;
    PlayerSpeedFactor = 1.0000000;
    ReloadSpeedFactor = 1.0000000;
    GoldenCardTimeout = default.GoldenCardTimeout;
    DisableConfuseEnemies();
    RestorePlayersSpeed();
    // End:0xCB
    if(IsTimerActive('DeactivateGoldenCards'))
    {
        ClearTimer('DeactivateGoldenCards');
    }
    // End:0xF6
    if(IsTimerActive('GoldenCardsDeactivateWarning'))
    {
        ClearTimer('GoldenCardsDeactivateWarning');
    }
    // End:0x14A
    foreach WorldInfo.AllControllers(Class'PKPlayerController', aPlayer)
    {
        aPlayer.ClientPlayGoldenCardsDeactivateEffects();        
    }    
    //return;    
}

function GoldenCardsDeactivateWarning()
{
    local PKPlayerController aPlayer;

    // End:0x54
    foreach WorldInfo.AllControllers(Class'PKPlayerController', aPlayer)
    {
        aPlayer.ClientPlayGoldenCardsDeactivateWarningEffects();        
    }    
    //return;    
}

function UseGoldenCards()
{
    //return;    
}

function RestorePlayersSpeed()
{
    local PlayerController aPlayer;

    // End:0xA9
    foreach WorldInfo.AllControllers(Class'Engine.PlayerController', aPlayer)
    {
        // End:0xA8
        if(aPlayer.bIsPlayer)
        {
            aPlayer.Pawn.GroundSpeed = Class'PKPlayerPawn'.default.GroundSpeed;
        }        
    }    
    //return;    
}

function ChangePlayersSpeed(float speedFactor)
{
    local PlayerController aPlayer;

    // End:0x95
    foreach WorldInfo.AllControllers(Class'Engine.PlayerController', aPlayer)
    {
        // End:0x94
        if(aPlayer.bIsPlayer)
        {
            aPlayer.Pawn.GroundSpeed *= speedFactor;
        }        
    }    
    //return;    
}

function ApplyBulletTimeToPlayers(float desiredDilation)
{
    local PKPlayerController aPlayer;

    // End:0x86
    foreach WorldInfo.AllControllers(Class'PKPlayerController', aPlayer)
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
    local PKPlayerController PC;

    // End:0x2E
    if((dd > DesiredTimeDilation) && dd != 1.0000000)
    {
        return;
    }
    // End:0xD3
    foreach WorldInfo.AllControllers(Class'PKPlayerController', PC)
    {
        PC.ClientSetSoundMode(((dd == 1.0000000) ? 'Default' : PC.default.BulletTimeSoundMode.Name));        
    }    
    ApplyBulletTimeToPlayers(dd);
    super.BulletTimeBlend(dd, bt);
    //return;    
}

function bool IsDeamonMode()
{
    return false;
    //return ReturnValue;    
}

function StartDaemonMode(optional float InDemonTime, optional bool bIsWarningFlash = false)
{
    //return;    
}

function StopDaemonMode()
{
    //return;    
}

function SetPlayerDefaults(Pawn PlayerPawn)
{
    super(GameInfo).SetPlayerDefaults(PlayerPawn);
    // End:0xAA
    if(PlayerPawn.IsA('PKPlayerPawn'))
    {
        PKPlayerPawn(PlayerPawn).SetupPlayerPhysics();
        // End:0xAA
        if(!PlayerPawn.IsLocallyControlled())
        {
            PKPlayerPawn(PlayerPawn).ClientSetupPlayerPhysics();
        }
    }
    //return;    
}

function StartMatch()
{
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
    super(GameInfo).StartMatch();
    //return;    
}

function int GetVoiceChannel(PKPlayerController PC)
{
    return ((PC.IsSpectating()) ? 0 : 1);
    //return ReturnValue;    
}

function UpdateGameSettings()
{
    local string MapName, plNum;
    local OnlineGameSettings GameSettings;
    local PKPlayerController PC;

    // End:0x68
    if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
    {
        GameSettings = GameInterface.GetGameSettings(PlayerReplicationInfoClass.default.SessionName);
    }
    // End:0x1A1
    if((GameSettings != none) && NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
    {
        MapName = WorldInfo.GetMapName(true);
        plNum = (("" @ string(GameSettings.NumPublicConnections - GameSettings.NumOpenPublicConnections)) @ " / ") @ string(GameSettings.NumPublicConnections);
        // End:0x1A0
        foreach WorldInfo.AllControllers(Class'PKPlayerController', PC)
        {
            PC.UpdateSteamLobby(MapName, plNum);            
        }        
    }
    super.UpdateGameSettings();
    //return;    
}

function UpdateGameSettingsCounts()
{
    local int TotalOpenConnections, TotalConnections;
    local OnlineGameSettings GameSettings;

    // End:0x68
    if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
    {
        GameSettings = GameInterface.GetGameSettings(PlayerReplicationInfoClass.default.SessionName);
    }
    // End:0x322
    if((GameSettings != none) && NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
    {
        GameSettings.NumPublicConnections = Clamp(GameSettings.NumPublicConnections, 0, MaxPlayers);
        GameSettings.NumPrivateConnections = Clamp(GameSettings.NumPrivateConnections, 0, MaxPlayers - GameSettings.NumPublicConnections);
        GameSettings.NumOpenPublicConnections = GameSettings.NumPublicConnections - (GetNumPlayers());
        // End:0x1D8
        if(GameSettings.NumOpenPublicConnections < 0)
        {
            GameSettings.NumOpenPublicConnections = 0;
        }
        TotalOpenConnections = GameSettings.NumOpenPublicConnections + GameSettings.NumOpenPrivateConnections;
        TotalConnections = GameSettings.NumPublicConnections + GameSettings.NumPrivateConnections;
        GameSettings.SetStringSettingValue(12, ((TotalOpenConnections == 0) ? 1 : 0), false);
        GameSettings.SetStringSettingValue(13, ((TotalOpenConnections == TotalConnections) ? 1 : 0), false);
        GameInterface.UpdateOnlineGame(PlayerReplicationInfoClass.default.SessionName, GameSettings);
    }
    //return;    
}

state MatchInProgress
{
    ignores BeginState;
Begin:

    stop;                
}

auto state PendingMatch
{
    function CheckStartMatch()
    {
        StartMatch();
        //return;        
    }
Begin:

    CheckStartMatch();
    Sleep(1.0000000);
    goto 'Begin';
    stop;                
}

defaultproperties
{
    SoulAutoCatchDistance=400.0000000
    SoulHealthFactor=1.0000000
    SoulHealthFactorWithRedeemer=2.0000000
    SoulStayFactor=1.0000000
    SoulStayFactorWithKeeper=1.5000000
    AmmoFoundFactor=1.0000000
    AmmoFoundFactorWithReplenish=2.0000000
    SoulsToEnableDemon=66
    SoulsToEnableDemonWithDarkSoul=50
    InitialPlayerHealth=100
    InitialPlayerHealthWithBlessing=150
    PlayerHealthCapacity=100
    InitialPlayerHealthWithVitality=150
    PlayerHealthCapacityWithVitality=150
    PlayerHealthLastBreath=33
    GoldenCardsUseLeft=1
    GoldenCardTimeout=30
    GoldenCardWarnBeforeEndTime=2
    PlayerDamageFactor=1.0000000
    MonsterDamageFactor=1.0000000
    PlayerSpeedFactor=1.0000000
    ReloadSpeedFactor=1.0000000
    MonsterInitialHealthModifierCard=0.9000000
    MonsterInitialHealthModifier=1.0000000
    StealHealthPctCard=0.0250000
    ArmorRegenSpeedCard=1.0000000
    HealthRegenSpeedCard=1.0000000
    PlayerAccelRate=2048.0000000
    PlayerSpeed=448.0000000
    MaximalBunnyHopSpeed=840.0000000
    BunnyHopAcceleration=0.3000000
    JumpStrength=1.0900000
    PlayerGravity=800.0000000
    SecondsWhenYouCanBunnyHopAfterLanding=0.2000000
    SecondsWhenYouCanBunnyHopBeforeLanding=0.2000000
    SecondsWhenYouCanJumpBeforeLanding=0.0500000
    UnderwaterSpeed=280.0000000
    PlayerSlowdownDuringJump=1120.0000000
    StrongAirControl=0.2000000
    WeakAirControl=0.0020000
    CollisionMinSpeed=1940.0000000
    CollisionMaxSpeed=5450.0000000
    ConsolePlayerControllerClass=Class'PKPlayerController'
    bPauseable=true
    bUseSeamlessTravel=false
    bRequiresPushToTalk=false
    DefaultPawnClass=Class'PKPlayerPawn'
    DeathMessageClass=none
    PlayerControllerClass=Class'PKPlayerController'
    PlayerReplicationInfoClass=Class'PainPRI'
    GameReplicationInfoClass=Class'PainGRI'
    StreamingPauseIcon=Material'PKHD_UI.M_StreamingPause'
}