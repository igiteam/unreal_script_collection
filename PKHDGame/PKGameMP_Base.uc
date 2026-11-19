class PKGameMP_Base extends PKGame
    abstract
    config(Game)
    hidecategories(Navigation,Movement,Collision);

const GS_USERNAME_MAXLENGTH = 15;
const GS_PASSWORD_MAXLENGTH = 30;
const GS_MESSAGE_MAXLENGTH = 255;
const GS_EMAIL_MAXLENGTH = 50;
const GS_CDKEY_PART_MAXLENGTH = 4;
const CONTEXT_PRESENCE_IDLE = 0;
const CONTEXT_PRESENCE_PARTY_PUBLIC_SEARCH = 1;
const CONTEXT_PRESENCE_PARTY_PUBLIC_WAIT = 2;
const CONTEXT_PRESENCE_PARTY_PRIVATE = 3;
const CONTEXT_PRESENCE_MENU = 4;
const CONTEXT_PRESENCE_SINGLE = 5;
const CONTEXT_PRESENCE_COOP = 6;
const CONTEXT_PRESENCE_COOP_PRIVATE = 7;
const CONTEXT_PRESENCE_MULTI = 8;
const CONTEXT_GAME_MODE = 0x0000800B;
const CONTEXT_GAME_MODE_DM = 0;
const CONTEXT_GAME_MODE_CAPTURETHEFLAG = 1;
const CONTEXT_GAME_MODE_WAR = 2;
const CONTEXT_GAME_MODE_VCTF = 3;
const CONTEXT_GAME_MODE_TDM = 4;
const CONTEXT_GAME_MODE_SURVIVAL = 5;
const CONTEXT_GAME_MODE_CUSTOM = 6;
const CONTEXT_GAME_MODE_CAMPAIGN = 7;
const CONTEXT_GAME_MODE_SV = 8;
const CONTEXT_GAME_MODE_PARTY = 9;
const CONTEXT_GAME_MODE_COOP = 10;
const CONTEXT_BOTSKILL = 0;
const CONTEXT_MAPNAME = 1;
const CONTEXT_PURESERVER = 6;
const CONTEXT_LOCKEDSERVER = 7;
const CONTEXT_VSBOTS = 8;
const CONTEXT_CAMPAIGN = 9;
const CONTEXT_FORCERESPAWN = 10;
const CONTEXT_ALLOWKEYBOARD = 11;
const CONTEXT_FULLSERVER = 12;
const CONTEXT_EMPTYSERVER = 13;
const CONTEXT_DEDICATEDSERVER = 14;
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
const PROPERTY_LEADERBOARDRATING = 0x20000004;
const PROPERTY_EPICMUTATORS = 0x10000105;
const PROPERTY_CUSTOMMAPNAME = 0x40000001;
const PROPERTY_CUSTOMGAMEMODE = 0x40000002;
const PROPERTY_SERVERDESCRIPTION = 0x40000003;
const PROPERTY_CUSTOMMUTATORS = 0x40000004;
const PROPERTY_SERVEROWNERID = 0x40000005;
const QUERY_DM = 0;
const QUERY_TDM = 1;
const QUERY_CTF = 2;
const QUERY_SV = 3;
const QUERY_WAR = 4;
const QUERY_DUEL = 5;
const QUERY_CAMPAIGN = 6;
const QUERY_VCTF = 7;
const STATS_VIEW_DM_PLAYER_ALLTIME = 1;
const STATS_VIEW_DM_RANKED_ALLTIME = 2;
const STATS_VIEW_DM_WEAPONS_ALLTIME = 3;
const STATS_VIEW_DM_VEHICLES_ALLTIME = 4;
const STATS_VIEW_DM_VEHICLEWEAPONS_ALLTIME = 5;
const STATS_VIEW_DM_VEHICLES_RANKED_ALLTIME = 6;
const STATS_VIEW_DM_VEHICLEWEAPONS_RANKED_ALLTIME = 7;
const STATS_VIEW_DM_WEAPONS_RANKED_ALLTIME = 8;

var bool bTeamDamage;
var bool bWeaponsStay;
var bool bPowerUps;
var bool bPowerUpDrop;
var bool bBunnyhopping;
var bool bBrightSkin;
var bool bForwardRocketJump;
var float WeaponRespawnTime;
var float QuadDamageDuration;
var float QuadDamageModifier;
var float PentagramDuration;
var int InitialCountdown;
var const localized string SecondsToStart;
var const localized string MinutesRemaining;
var const localized string PlayerIsReady;
var const localized string PlayerIsUnready;
var array<SoundCue> LuciferTimeSound;
var array<SoundCue> LuciferVeryBadSound;
var array<SoundCue> LuciferBadSound;
var array<SoundCue> LuciferGoodSound;
var array<SoundCue> LuciferExcellentSound;
var array<SoundCue> LuciferCTFLooserSound;
var array<SoundCue> LuciferCTFWinnerSound;
var SoundCue LuciferFightSound;
var SoundCue LuciferComeSound;
var SoundCue ClockTick;
var NavigationPoint LastPlayerStartSpot;
var NavigationPoint LastStartSpot;
var array<GameMapCycle> PKMapCycles;
var array<byte> PKMapBlob;
var int PKMapIndex;
var globalconfig array<config string> DeathmatchRotationMaps;
var globalconfig array<config string> TeamDeathmatchRotationMaps;
var globalconfig array<config string> CtfRorationMaps;
var globalconfig array<config string> SurvivalRotationMaps;
//var delegate<MapListSort> __MapListSort__Delegate;

function PreBeginPlay()
{
    super(EvilGame).PreBeginPlay();
    GetGRI().bBunnyhopping = bBunnyhopping;
    GetGRI().bForwardRocketJump = bForwardRocketJump;
    GetGRI().bBrightSkin = bBrightSkin;
    //return;    
}

event InitGame(string Options, out string ErrorMessage)
{
    local string InOpt, tmpOptions;
    local PKGameSettingsCommon gSettings;

    InOpt = ParseOption(Options, "dedicatedmapslist");
    // End:0x53
    if(InOpt != "")
    {
        PrepareDedicatedMapList(InOpt);
    }
    // End:0x9C
    if(WorldInfo.TimeSeconds == 0.0000000)
    {
        MapCycleIndex = -1;
        PKMapIndex = -1;
        SaveConfig();
    }
    super.InitGame(Options, ErrorMessage);
    InOpt = ParseOption(Options, "ForceRespawn");
    // End:0x109
    if(InOpt != "")
    {
        bForceRespawn = bool(InOpt);
    }
    InOpt = ParseOption(Options, "ClassicHUD");
    // End:0x14E
    if(InOpt != "")
    {
        bUseClassicHUD = true;
    }
    InOpt = ParseOption(Options, "CauseEvent");
    // End:0x1B5
    if(InOpt ~= "FlyThrough")
    {
        bFixedPlayerStart = true;
        bForceRespawn = true;
        bQuickStart = true;
    }
    SetGameSpeed(GameSpeed);
    MaxLives = Max(0, GetIntOption(Options, "MaxLives", MaxLives));
    // End:0x219
    if(MaxLives > 0)
    {
        bTempForceRespawn = true;        
    }
    else
    {
        // End:0x247
        if(DefaultMaxLives > 0)
        {
            bTempForceRespawn = true;
            MaxLives = DefaultMaxLives;
        }
    }
    // End:0x261
    if(DefaultMaxLives > 0)
    {
        TimeLimit = 0;
    }
    GoalScore = ((!IsAutomatedPerfTesting()) ? Max(0, GetIntOption(Options, "GoalScore", GoalScore)) : 0);
    InOpt = ParseOption(Options, "DemoMode");
    // End:0x2F4
    if(InOpt != "")
    {
        bDemoMode = bool(InOpt);
    }
    InOpt = ParseOption(Options, "QuickStart");
    // End:0x339
    if(InOpt != "")
    {
        bQuickStart = true;
    }
    bQuickStart = bQuickStart || IsAutomatedPerfTesting();
    DemoPrefix = ParseOption(Options, "demo");
    tmpOptions = Options;
    InOpt = ParseOption(Options, "GamePassword");
    gSettings = PKGameSettingsCommon(OnlineSub.GameInterface.GetGameSettings('Game'));
    // End:0x45C
    if((InOpt != "") && gSettings != none)
    {
        gSettings.SetStringProperty(1073741827, "PWD");        
    }
    else
    {
        gSettings.SetStringProperty(1073741827, "");
    }
    Options = tmpOptions;
    DesiredPlayerCount = ((HasOption(Options, "NumPlay")) ? Clamp(GetIntOption(Options, "NumPlay", 1), 1, 32) : LevelRecommendedPlayers());
    InOpt = ParseOption(Options, "PlayersMustBeReady");
    // End:0x543
    if(InOpt != "")
    {
        bPlayersMustBeReady = bool(InOpt);
    }
    InOpt = ParseOption(Options, "MinNetPlayers");
    // End:0x594
    if(InOpt != "")
    {
        MinNetPlayers = int(InOpt);
    }
    InOpt = ParseOption(Options, "TeamDamage");
    // End:0x5E3
    if(InOpt != "")
    {
        bTeamDamage = bool(InOpt);
    }
    InOpt = ParseOption(Options, "WeaponStay");
    // End:0x632
    if(InOpt != "")
    {
        bWeaponsStay = bool(InOpt);
    }
    InOpt = ParseOption(Options, "WeaponRespawnTime");
    // End:0x687
    if(InOpt != "")
    {
        WeaponRespawnTime = float(InOpt);
    }
    InOpt = ParseOption(Options, "PowerUps");
    // End:0x6D4
    if(InOpt != "")
    {
        bPowerUps = bool(InOpt);
    }
    InOpt = ParseOption(Options, "PowerupsDrop");
    // End:0x725
    if(InOpt != "")
    {
        bPowerUpDrop = bool(InOpt);
    }
    InOpt = ParseOption(Options, "AllowBunny");
    // End:0x774
    if(InOpt != "")
    {
        bBunnyhopping = bool(InOpt);
    }
    InOpt = ParseOption(Options, "BrightSkin");
    // End:0x7C3
    if(InOpt != "")
    {
        bBrightSkin = bool(InOpt);
    }
    InOpt = ParseOption(Options, "RocketJump");
    // End:0x812
    if(InOpt != "")
    {
        bForwardRocketJump = bool(InOpt);
    }
    bShouldWaitForNetPlayers = bWaitForNetPlayers && int(WorldInfo.NetMode) != int(NM_Standalone);
    // End:0x8F6
    if(int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        InOpt = ParseOption(Options, "WarmupTime");
        // End:0x8F3
        if(InOpt != "")
        {
            WarmupTime = int(InOpt);
            WarmupRemaining = WarmupTime;
            bWarmupRound = WarmupTime > 0;
        }        
    }
    else
    {
        bWarmupRound = false;
    }
    //return;    
}

function PrepareDedicatedMapList(string strList)
{
    local PKEngine GEngine;

    GEngine = PKEngine(Class'Engine.Engine'.static.GetEngine());
    // End:0xAC
    if(GEngine.PKDMaps.Length <= 0)
    {
        ParseStringIntoArray(strList, GEngine.PKDMaps, ",", true);
        GEngine.PKDMapIndex = 1;
    }
    //return;    
}

function string GetNextMap()
{
    local int GameIndex, GameClassIdx, MapToPlay;
    local array<string> MapList;
    local PKPlayerController PC;
    local PKEngine GEngine;

    // End:0x137
    if(int(WorldInfo.NetMode) == int(NM_DedicatedServer))
    {
        GEngine = PKEngine(Class'Engine.Engine'.static.GetEngine());
        MapToPlay = GEngine.PKDMapIndex;
        GEngine.PKDMapIndex = (((GEngine.PKDMapIndex + 1) < GEngine.PKDMaps.Length) ? GEngine.PKDMapIndex + 1 : 0);
        return GEngine.PKDMaps[MapToPlay];        
    }
    else
    {
        PC = PKPlayerController(GetALocalPlayerController());
        PKMapIndex = PC.GetIntValueMP(86);
        GameClassIdx = PC.GetIntValueMP(87);
        PKMapCycles.Length = 0;
        PKMapCycles.Add(1);
        switch(GameClassIdx)
        {
            // End:0x217
            case 1:
                PKMapCycles[0].GameClassName = 'PKGameDeathmatch_Content';
                MapList = default.DeathmatchRotationMaps;
                // End:0x313
                break;
            // End:0x25A
            case 2:
                PKMapCycles[0].GameClassName = 'PKGameTeamDeathmatch_Content';
                MapList = default.TeamDeathmatchRotationMaps;
                // End:0x313
                break;
            // End:0x29D
            case 3:
                PKMapCycles[0].GameClassName = 'PKGameCTF_Content';
                MapList = default.CtfRorationMaps;
                // End:0x313
                break;
            // End:0x2E0
            case 4:
                PKMapCycles[0].GameClassName = 'PKGameSurvival_Content';
                MapList = default.SurvivalRotationMaps;
                // End:0x313
                break;
            // End:0x310
            case 5:
                PKMapCycles[0].GameClassName = 'PKGameCooperative';
                // End:0x313
                break;
            // End:0xFFFF
            default:
                break;
        }
        PC.ProfileSettings.GetProfileSettingValueBlob(85, PKMapBlob);
        GameIndex = PKMapCycles.Find('GameClassName', Class.Name);
        // End:0x476
        if(GameIndex != -1)
        {
            // End:0x3F1
            if(PKMapIndex == -1)
            {
                PKMapIndex = GetCurrentMapCycleIndex(MapList);
                // End:0x3F1
                if(PKMapIndex == -1)
                {
                    PKMapIndex = 0;
                }
            }
            MapToPlay = PKMapIndex;
            PKMapIndex = (((PKMapIndex + 1) < MapList.Length) ? PKMapIndex + 1 : 0);
            PC.SetIntValueMP(86, PKMapIndex);
            return MapList[MapToPlay];
        }
    }
    return "";
    //return ReturnValue;    
}

function CreateCycleMapList()
{
    local int I;
    local array<UDKUIResourceDataProvider> ProviderList;
    local array<UTUIDataProvider_MapInfo> LocalMapList;
    local array<string> LocalMapNames;

    Class'EvilGame.UTUIDataStore_MenuItems'.static.GetAllResourceDataProviders(Class'EvilGame.UTUIDataProvider_MapInfo', ProviderList);
    I = 0;
    J0x3C:

    // End:0xEB [Loop If]
    if(I < ProviderList.Length)
    {
        // End:0xB4
        if(Class'PKGFxUI_Menu_MultiHost'.default.DropMapNames.Find(UTUIDataProvider_MapInfo(ProviderList[I]).MapName) != -1)
        {            
        }
        else
        {
            LocalMapList.AddItem(UTUIDataProvider_MapInfo(ProviderList[I]));
        }
        I++;
        // [Loop Continue]
        goto J0x3C;
    }
    LocalMapList.Sort(MapListSort);
    I = 0;
    J0x114:

    // End:0x19D [Loop If]
    if(I < LocalMapList.Length)
    {
        // End:0x18F
        if(!LocalMapList[I].ShouldBeFiltered())
        {
            LocalMapNames.AddItem(LocalMapList[I].MapName);
        }
        I++;
        // [Loop Continue]
        goto J0x114;
    }
    I = 0;
    J0x1A8:

    // End:0x20F [Loop If]
    if(I < PKMapBlob.Length)
    {
        PKMapCycles[0].Maps.AddItem(LocalMapNames[int(PKMapBlob[I])]);
        I++;
        // [Loop Continue]
        goto J0x1A8;
    }
    // End:0x221
    if(PKMapCycles.Length == 0)
    {
        return;
    }
    //return;    
}

delegate int MapListSort(UTUIDataProvider_MapInfo A, UTUIDataProvider_MapInfo B)
{
    return ((A.MapName > B.MapName) ? -1 : 0);
    //return ReturnValue;    
}

function InitGameReplicationInfo()
{
    local UTGameReplicationInfo GRI;
    local UTMutator M;

    super.InitGameReplicationInfo();
    GRI = UTGameReplicationInfo(GameReplicationInfo);
    GRI.GoalScore = GoalScore;
    GRI.TimeLimit = TimeLimit;
    GameReplicationInfo.RemainingTime = 60 * TimeLimit;
    GRI.MinNetPlayers = MinNetPlayers;
    GRI.bConsoleServer = WorldInfo.bUseConsoleInput || WorldInfo.IsConsoleBuild();
    GRI.bAllowKeyboardAndMouse = bAllowKeyboardAndMouse;
    GRI.bRequireReady = bPlayersMustBeReady;
    M = GetBaseUTMutator();
    J0x196:

    // End:0x277 [Loop If]
    if(M != none)
    {        
        GRI.MutatorList $= ((GRI.MutatorList == "") ? PathName(M.Class) : "?" $ PathName(M.Class));
        M = M.GetNextUTMutator();
        // [Loop Continue]
        goto J0x196;
    }
    GRI.RulesString = "";
    GRI.AddGameRule(GetMapTypeRule());
    GRI.AddGameRule(GetEndGameConditionRule());
    GRI.AddGameRule(" ");
    //return;    
}

function NotifySpree(EvilPlayerReplicationInfo Other, int Num)
{
    //return;    
}

function EndSpree(EvilPlayerReplicationInfo Killer, EvilPlayerReplicationInfo Other)
{
    //return;    
}

event PostLogin(PlayerController NewPlayer)
{
    local PKPlayerController PC;
    local UTGameReplicationInfo GRI;

    super.PostLogin(NewPlayer);
    PC = PKPlayerController(NewPlayer);
    // End:0x15E
    if(PC != none)
    {
        PC.PlayStartupMessage(StartupStage);
        PC.ClientSetSpeechRecognitionObject(SpeechRecognitionData);
        GRI = UTGameReplicationInfo(GameReplicationInfo);
        // End:0x15E
        if(((bForceMidGameMenuAtStart && !GRI.bStoryMode) && !GRI.bMatchHasBegun) && (NetWait - PendingMatchElapsedTime) > 5)
        {
            EvilPlayerReplicationInfo(PC.PlayerReplicationInfo).ShowMidGameMenu(true);
        }
    }
    Pausers.Length = 0;
    WorldInfo.Pauser = none;
    PC = PKPlayerController(NewPlayer);
    // End:0x1C8
    if(PC != none)
    {
        SetMPRichPresenceString(PC);
    }
    //return;    
}

function RestartGame()
{
    // End:0x0F
    if(bGameRestarted)
    {
        return;
    }
    super(GameInfo).RestartGame();
    //return;    
}

function NavigationPoint FindPlayerStart(Controller Player, optional byte InTeam, optional string IncomingName)
{
    local NavigationPoint Best;

    // End:0x32
    if(ScriptedStartSpot != none)
    {
        Best = ScriptedStartSpot;
        ScriptedStartSpot = none;        
    }
    else
    {
        // End:0x8F
        if((Player != none) && Player.StartSpot != none)
        {
            LastPlayerStartSpot = Player.StartSpot;
        }
        Best = super(GameInfo).FindPlayerStart(Player, InTeam, IncomingName);
        // End:0xE0
        if(Best != none)
        {
            LastStartSpot = Best;
        }
    }
    return Best;
    //return ReturnValue;    
}

function float RatePlayerStart(PlayerStart P, byte Team, Controller Player)
{
    local float Score, NextDist;
    local Controller OtherPlayer;
    local bool bTwoPlayerGame;

    Score = float(((P.bPrimaryStart) ? 30 : 20));
    // End:0x74
    if((P == LastStartSpot) || P == LastPlayerStartSpot)
    {
        Score -= 15.0000000;
    }
    bTwoPlayerGame = (NumPlayers + NumBots) == 2;
    // End:0x67B
    if(Player != none)
    {
        // End:0x67A
        foreach WorldInfo.AllControllers(Class'Engine.Controller', OtherPlayer)
        {
            // End:0x679
            if(OtherPlayer.bIsPlayer && OtherPlayer.Pawn != none)
            {
                // End:0x307
                if((Abs(P.Location.Z - OtherPlayer.Pawn.Location.Z) < (P.CylinderComponent.CollisionHeight + OtherPlayer.Pawn.CylinderComponent.CollisionHeight)) && VSize2D(P.Location - OtherPlayer.Pawn.Location) < (P.CylinderComponent.CollisionRadius + OtherPlayer.Pawn.CylinderComponent.CollisionRadius))
                {                    
                    return -10.0000000;
                }
                NextDist = VSize(OtherPlayer.Pawn.Location - P.Location);
                // End:0x534
                if(((NextDist < float(3000)) && !WorldInfo.GRI.OnSameTeam(Player, OtherPlayer)) && FastTrace(P.Location, OtherPlayer.Pawn.Location + (vect(0.0000000, 0.0000000, 1.0000000) * OtherPlayer.Pawn.CylinderComponent.CollisionHeight)))
                {
                    // End:0x510
                    if((OtherPlayer.PlayerReplicationInfo != none) && EvilPlayerReplicationInfo(Player.PlayerReplicationInfo).LastKillerPRI == OtherPlayer.PlayerReplicationInfo)
                    {
                        Score -= float(7);
                    }
                    Score -= (float(5) - (0.0010000 * NextDist));
                    // End:0x679
                    continue;
                }
                // End:0x5E2
                if(((NextDist < float(1500)) && OtherPlayer.PlayerReplicationInfo != none) && EvilPlayerReplicationInfo(Player.PlayerReplicationInfo).LastKillerPRI == OtherPlayer.PlayerReplicationInfo)
                {
                    Score -= float(7);
                    // End:0x679
                    continue;
                }
                // End:0x679
                if(bTwoPlayerGame)
                {
                    Score += FMin(2.0000000, 0.0010000 * NextDist);
                    // End:0x679
                    if(FastTrace(P.Location, OtherPlayer.Pawn.Location))
                    {
                        Score -= float(5);
                    }
                }
            }            
        }        
    }
    return FMax(Score, 0.2000000);
    //return ReturnValue;    
}

function ClientsLeaveLobby()
{
    local PKPlayerController PC;

    // End:0x54
    foreach WorldInfo.AllControllers(Class'PKPlayerController', PC)
    {
        PC.CleanupSteamLobby();        
    }    
    //return;    
}

function PlayEndOfMatchMessage()
{
    local UTPlayerController PC;

    // End:0xB5
    if(DominatingVictory())
    {
        // End:0xB1
        foreach WorldInfo.AllControllers(Class'EvilGame.UTPlayerController', PC)
        {
            // End:0x85
            if(IsAWinner(PC))
            {
                PC.ClientPlayAnnouncement(VictoryMessageClass, 0);
                // End:0xB0
                continue;
            }
            PC.ClientPlayAnnouncement(VictoryMessageClass, 1);            
        }                
    }
    else
    {
        PlayRegularEndOfMatchMessage();
    }
    //return;    
}

function PlayRegularEndOfMatchMessage()
{
    local UTPlayerController PC;

    // End:0x105
    foreach WorldInfo.AllControllers(Class'EvilGame.UTPlayerController', PC)
    {
        // End:0x104
        if((PC.PlayerReplicationInfo != none) && !PC.PlayerReplicationInfo.bOnlySpectator)
        {
            // End:0xD8
            if(IsAWinner(PC))
            {
                PC.ClientPlayAnnouncement(VictoryMessageClass, 2);
                // End:0x104
                continue;
            }
            PC.ClientPlayAnnouncement(VictoryMessageClass, 3);
        }        
    }    
    //return;    
}

function ScoreKill(Controller Killer, Controller Other)
{
    super(EvilGame).ScoreKill(Killer, Other);
    // End:0xCA
    if((PKPlayerController(Killer) != none) && PKPlayerController(Other) != none)
    {
        PKPlayerController(Killer).IncrementGlobalIntStat(113);
        PKPlayerController(Killer).NotifyGotKill();
        PKPlayerController(Other).NotifyWasKilled();
    }
    // End:0x15F
    if(((Killer != none) && PKPlayerPawn(Killer.Pawn) != none) && Killer != Other)
    {
        PKPlayerPawn(Killer.Pawn).CommentKill();
    }
    //return;    
}

function bool AtCapacity(bool bSpectator)
{
    local Controller C;
    local bool bForcedSpectator;

    // End:0x2B
    if(int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        return false;
    }
    // End:0x4F
    if(MaxLives <= 0)
    {
        return super(GameInfo).AtCapacity(bSpectator);
    }
    // End:0xFA
    foreach WorldInfo.AllControllers(Class'Engine.Controller', C)
    {
        // End:0xF9
        if((C.PlayerReplicationInfo != none) && C.PlayerReplicationInfo.NumLives > LateEntryLives)
        {
            bForcedSpectator = true;
            // End:0xFA
            break;
        }        
    }    
    // End:0x11F
    if(!bForcedSpectator)
    {
        return super(GameInfo).AtCapacity(bSpectator);
    }
    return ((GetNumPlayers()) + NumSpectators) >= (MaxPlayers + MaxSpectators);
    //return ReturnValue;    
}

function BroadcastDeathMessage(Controller Killer, Controller Other, class<DamageType> DamageType)
{
    // End:0x68
    if((Killer == none) || Killer == Other)
    {
        BroadcastLocalized(self, DeathMessageClass, 1, none, Other.PlayerReplicationInfo, DamageType);        
    }
    else
    {
        BroadcastLocalized(self, DeathMessageClass, 0, Killer.PlayerReplicationInfo, Other.PlayerReplicationInfo, DamageType);
        // End:0x20C
        if(PlayerController(Other) != none)
        {
            // End:0x20C
            if(((((UTPlayerController(Killer) == none) || UTPlayerController(Killer).bAutoTaunt) && Other.PlayerReplicationInfo != none) && EvilPlayerReplicationInfo(Killer.PlayerReplicationInfo) != none) && EvilPlayerReplicationInfo(Killer.PlayerReplicationInfo).VoiceClass != none)
            {
                Killer.SendMessage(Other.PlayerReplicationInfo, 'Taunt', 10.0000000, DamageType);
            }
        }
    }
    //return;    
}

function int CalculatedNetSpeed()
{
    local int ModifiedNetBandwidth;

    ModifiedNetBandwidth = TotalNetBandwidth;
    // End:0x2F
    if(IsConsoleDedicatedServer())
    {
        ModifiedNetBandwidth *= float(2);
    }
    return Clamp(ModifiedNetBandwidth / Max(NumPlayers, 1), MinDynamicBandwidth, MaxDynamicBandwidth);
    //return ReturnValue;    
}

function WriteOnlinePlayerScores()
{
    local int Index, Count;
    local PlayerReplicationInfo PRI;
    local array<OnlinePlayerScore> PlayerScores;
    local UniqueNetId ZeroId;

    // End:0x25A
    if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.StatsInterface, OnlineStatsInterface(none)))
    {
        Index = 0;
        J0x51:

        // End:0x1DF [Loop If]
        if(Index < GameReplicationInfo.PRIArray.Length)
        {
            PRI = GameReplicationInfo.PRIArray[Index];
            // End:0x1D1
            if((PRI != none) && PRI.UniqueId != ZeroId)
            {
                Count++;
                PlayerScores.Length = Count;
                PlayerScores[Count - 1].PlayerID = PRI.UniqueId;
                PlayerScores[Count - 1].Score = int(PRI.Score);
                PlayerScores[Count - 1].TeamID = 255;
            }
            Index++;
            // [Loop Continue]
            goto J0x51;
        }
        // End:0x25A
        if(PlayerScores.Length > 0)
        {
            OnlineSub.StatsInterface.WriteOnlinePlayerScores('Game', ((bUsingArbitration) ? ArbitratedLeaderboardId : LeaderboardId), PlayerScores);            
        }
    }
    //return;    
}

function float GetItemRespawnTime(PainItemBase Item)
{
    // End:0x65
    if((PainWeaponPickup_Base(Item) != none) && !PainWeaponPickup_Base(Item).bIsPowerUpMP)
    {
        return ((bWeaponsStay) ? 0.0000000 : WeaponRespawnTime);
    }
    return Item.RespawnItemTime;
    //return ReturnValue;    
}

function StartMatch()
{
    local bool bTemp;
    local UTPlayerController PC;

    super.StartMatch();
    bTemp = bMustJoinBeforeStart;
    bMustJoinBeforeStart = false;
    bMustJoinBeforeStart = bTemp;
    // End:0x89
    foreach WorldInfo.AllControllers(Class'EvilGame.UTPlayerController', PC)
    {
        SetupPlayerMuteList(PC, false);        
    }    
    // End:0x10C
    if(CauseEventCommand != "")
    {
        // End:0x10B
        foreach WorldInfo.AllControllers(Class'EvilGame.UTPlayerController', PC)
        {            
            PC.ConsoleCommand("ce " $ CauseEventCommand);
            // End:0x10B
            break;            
        }        
    }
    // End:0x183
    if((BugLocString != "") || BugRotString != "")
    {
        // End:0x183
        if(PC.CheatManager != none)
        {
            PC.BugItGoString(BugLocString, BugRotString);
        }
    }
    //return;    
}

function SetControllersWinnerFlag(PlayerReplicationInfo Winner)
{
    //return;    
}

function PlayerReplicationInfo GetWinner()
{
    local Controller P;
    local PlayerReplicationInfo PRI;
    local PainGRI GRI;
    local float maxscore;
    local int BestTeamIndex;
    local TeamInfo Team;
    local int MaxScorers;

    maxscore = -100000000.0000000;
    MaxScorers = 0;
    // End:0x2E2
    if(ClassIsChildOf(self.Class, Class'PKGameTeamDeathmatch'))
    {
        GRI = PainGRI(WorldInfo.GRI);
        // End:0x119
        foreach GRI.Teams(Team)
        {
            // End:0x118
            if(Team.Score > maxscore)
            {
                BestTeamIndex = Team.TeamIndex;
                maxscore = Team.Score;
            }            
        }        
        // End:0x17E
        foreach GRI.Teams(Team)
        {
            // End:0x17D
            if(Team.Score == maxscore)
            {
                MaxScorers++;
            }            
        }        
        // End:0x2D4
        if(MaxScorers == 1)
        {
            maxscore = -100000000.0000000;
            // End:0x2D0
            foreach WorldInfo.AllControllers(Class'Engine.Controller', P)
            {
                // End:0x2CF
                if((P.PlayerReplicationInfo.Score > maxscore) && P.PlayerReplicationInfo.Team.TeamIndex == BestTeamIndex)
                {
                    PRI = P.PlayerReplicationInfo;
                    maxscore = P.PlayerReplicationInfo.Score;
                }                
            }                        
        }
        else
        {
            PRI = none;
        }        
    }
    else
    {
        // End:0x47F
        if(ClassIsChildOf(self.Class, Class'PKGameDeathmatch'))
        {
            // End:0x3E2
            foreach WorldInfo.AllControllers(Class'Engine.Controller', P)
            {
                // End:0x3E1
                if(P.PlayerReplicationInfo.Score > maxscore)
                {
                    PRI = P.PlayerReplicationInfo;
                    maxscore = P.PlayerReplicationInfo.Score;
                }                
            }            
            // End:0x464
            foreach WorldInfo.AllControllers(Class'Engine.Controller', P)
            {
                // End:0x463
                if(P.PlayerReplicationInfo.Score == maxscore)
                {
                    MaxScorers++;
                }                
            }            
            // End:0x47F
            if(MaxScorers > 1)
            {
                PRI = none;
            }
        }
    }
    return PRI;
    //return ReturnValue;    
}

function EndGame(PlayerReplicationInfo Winner, string Reason)
{
    local PlayerController PC;
    local PKPlayerController PKPC;
    local PKQuadDamage qdmg;
    local Controller qcp;
    local int playersCount;
    local bool has4morekills;
    local array<Controller> quadCollectors;
    local string MapName;

    super(EvilGame).EndGame(Winner, Reason);
    // End:0x3F
    if(Winner == none)
    {
        Winner = GetWinner();
    }
    // End:0xC6
    if(ClassIsChildOf(self.Class, Class'PKGameTeamDeathmatch'))
    {
        PKPC = PKPlayerController(Winner.Owner);
        // End:0xC6
        if(PKPC != none)
        {
            PKPC.ClientUnlockAchievement(61);
        }
    }
    // End:0x150
    if(bGameEnded)
    {
        // End:0x14F
        foreach WorldInfo.AllControllers(Class'PKPlayerController', PKPC)
        {
            // End:0x14E
            if(PKPC.PlayerReplicationInfo != none)
            {
                PKPC.IncrementGlobalIntStat(127, 1);
            }            
        }        
    }
    // End:0x68B
    if((Winner != none) && bGameEnded)
    {
        SetControllersWinnerFlag(Winner);
        has4morekills = true;
        // End:0x289
        foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
        {
            playersCount++;
            // End:0x288
            if(((PC.PlayerReplicationInfo != none) && PC.PlayerReplicationInfo != Winner) && (float(4) + PC.PlayerReplicationInfo.Score) > Winner.Score)
            {
                has4morekills = false;
            }            
        }        
        // End:0x30B
        if((playersCount >= 4) && has4morekills)
        {
            PKPC = PKPlayerController(Winner.Owner);
            // End:0x30B
            if(PKPC != none)
            {
                PKPC.ClientUnlockAchievement(60);
            }
        }
        // End:0x3A2
        if((Winner.Deaths == 0) && playersCount > 1)
        {
            PKPC = PKPlayerController(Winner.Owner);
            // End:0x3A2
            if(PKPC != none)
            {
                PKPC.ClientUnlockAchievement(58);
            }
        }
        // End:0x431
        foreach WorldInfo.AllActors(Class'PKQuadDamage', qdmg)
        {
            // End:0x42F
            foreach qdmg.quadCollectors(qcp)
            {
                // End:0x42E
                if(quadCollectors.Find(qcp) < 0)
                {
                    quadCollectors.AddItem(qcp);
                }                
            }                        
        }        
        // End:0x491
        if(quadCollectors.Length == 1)
        {
            PKPC = PKPlayerController(quadCollectors[0]);
            // End:0x491
            if(PKPC != none)
            {
                PKPC.ClientUnlockAchievement(59);
            }
        }
        MapName = Caps(WorldInfo.GetMapName(true));
        // End:0x68B
        if(MapName != "")
        {
            PKPC = PKPlayerController(Winner.Owner);
            // End:0x68B
            if((PKPC != none) && playersCount > 1)
            {
                // End:0x68B
                if((default.Acronym == "DM") || default.Acronym == "SV")
                {
                    // End:0x5AC
                    if((MapName == "DM-PSYCHO_DLC_1") || MapName == "DM-PSYCHO_HD_DLC_1")
                    {
                        PKPC.ClientUnlockAchievement(69);                        
                    }
                    else
                    {
                        // End:0x61C
                        if((MapName == "SV-ILLUMINATI_HD_DLC_1") || MapName == "SV-ILLUMINATI_DLC_1")
                        {
                            PKPC.ClientUnlockAchievement(70);                            
                        }
                        else
                        {
                            // End:0x68B
                            if((MapName == "DM-FRAGENSTEIN_DLC_3") || MapName == "DM-FRAGENSTEIN_HD_DLC_3")
                            {
                                PKPC.ClientUnlockAchievement(74);
                            }
                        }
                    }
                }
            }
        }
    }
    //return;    
}

simulated function byte GetMPMapNameID(string MapName)
{
    switch(Locs(MapName))
    {
        // End:0x23
        case "cursed":
            return 0;
        // End:0x34
        case "cursed_hd":
            return 1;
        // End:0x45
        case "forbidden":
            return 2;
        // End:0x59
        case "forbidden_hd":
            return 3;
        // End:0x6A
        case "fallenone":
            return 4;
        // End:0x7E
        case "fallenone_hd":
            return 5;
        // End:0x8C
        case "sacred":
            return 6;
        // End:0x9D
        case "sacred_hd":
            return 7;
        // End:0xAB
        case "unseen":
            return 8;
        // End:0xBC
        case "unseen_hd":
            return 9;
        // End:0xD1
        case "atriumcomplex":
            return 10;
        // End:0xE4
        case "cityonwater":
            return 11;
        // End:0xF1
        case "opera":
            return 12;
        // End:0x105
        case "trainstation":
            return 13;
        // End:0xFFFF
        default:
            return 0;
            break;
    }
    //return ReturnValue;    
}

function SetMPRichPresenceString(PKPlayerController PC)
{
    local PainGRI GRI;
    local byte MapNameId;
    local PKTypes.EMultiGameMode MPType;
    local string MapName;

    // End:0xE3
    if(OnlineSub != none)
    {
        GRI = PainGRI(WorldInfo.GRI);
        MapName = WorldInfo.GetMapName();
        MapNameId = GetMPMapNameID(MapName);
        MPType = GRI.GetMultiGameMode();
        PC.ClientSetMPRichPresenceString(8, MPType, MapNameId);
    }
    //return;    
}

function UpdateGameplayMuteList(PlayerController PC)
{
    local PKPlayerController_MP PKPC;

    PKPC = PKPlayerController_MP(PC);
    // End:0x3E
    if(PKPC != none)
    {
        InitTeamMuteList(PKPC);
    }
    super(EvilGame).UpdateGameplayMuteList(PC);
    //return;    
}

function InitTeamMuteList(PKPlayerController_MP PC)
{
    local PKPlayerController_MP OtherPC;

    PC.VoiceChannel = GetVoiceChannel(PC);
    // End:0x23C
    foreach WorldInfo.AllControllers(Class'PKPlayerController_MP', OtherPC)
    {
        // End:0x23B
        if(OtherPC != PC)
        {
            OtherPC.VoiceChannel = GetVoiceChannel(OtherPC);
            // End:0x197
            if(OtherPC.VoiceChannel != PC.VoiceChannel)
            {
                PC.GameplayMutePlayer(OtherPC.PlayerReplicationInfo.UniqueId);
                OtherPC.GameplayMutePlayer(PC.PlayerReplicationInfo.UniqueId);
                // End:0x23B
                continue;
            }
            PC.GameplayUnmutePlayer(OtherPC.PlayerReplicationInfo.UniqueId);
            OtherPC.GameplayUnmutePlayer(PC.PlayerReplicationInfo.UniqueId);
        }        
    }    
    //return;    
}

auto state PendingMatch
{
    ignores CheckLives, CheckScore, ScoreKill;

    function RestartPlayer(Controller aPlayer)
    {
        // End:0x3E
        if(UTGameReplicationInfo(GameReplicationInfo).bWarmupRound)
        {
            global.RestartPlayer(aPlayer);
        }
        //return;        
    }

    function Timer()
    {
        local PlayerController P;
        local bool bReady;

        global.Timer();
        bReady = true;
        // End:0x180
        if(PainGRI(GameReplicationInfo).IsTeamMultiPlayerGame())
        {
            // End:0x17F
            foreach WorldInfo.AllControllers(Class'Engine.PlayerController', P)
            {
                // End:0x17E
                if(((P.PlayerReplicationInfo != none) && P.bIsPlayer) && !P.PlayerReplicationInfo.bReadyToPlay)
                {
                    // End:0x13D
                    if(!P.PlayerReplicationInfo.bOnlySpectator)
                    {
                        bReady = false;
                    }
                    // End:0x17E
                    if(PKPlayerController_MP(P) != none)
                    {
                        PKPlayerController_MP(P).ShowTeamPanel(true);
                    }
                }                
            }            
        }
        // End:0x2CB
        if(bReady)
        {
            // End:0x1D1
            if(PainGRI(GameReplicationInfo).CountdownTimer == 0)
            {
                PlayStartupMessage();
                StartMatch();                
            }
            else
            {
                // End:0x2CB
                if(PainGRI(GameReplicationInfo).CountdownTimer > 0)
                {
                    // End:0x2A2
                    if(!PainGRI(GameReplicationInfo).IsTeamMultiPlayerGame())
                    {
                        // End:0x2A1
                        foreach WorldInfo.AllControllers(Class'Engine.PlayerController', P)
                        {
                            // End:0x2A0
                            if(PKPlayerController_MP(P) != none)
                            {
                                PKPlayerController_MP(P).ShowTeamPanel(true);
                            }                            
                        }                        
                    }
                    PainGRI(GameReplicationInfo).CountdownTimer--;
                }
            }
        }
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        PainGRI(GameReplicationInfo).CountdownTimer = InitialCountdown;
        bWaitingToStartMatch = true;
        StartupStage = 0;
        //return;        
    }

    function EndState(name NextStateName)
    {
        local PlayerController P;

        // End:0x76
        foreach WorldInfo.AllControllers(Class'Engine.PlayerController', P)
        {
            // End:0x75
            if(PKPlayerController_MP(P) != none)
            {
                PKPlayerController_MP(P).ShowTeamPanel(false);
            }            
        }        
        //return;        
    }
Begin:

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
    // End:0x10A
    if(bQuickStart)
    {
        // End:0x100
        if(DemoPrefix != "")
        {            
            ConsoleCommand(("demorec" @ DemoPrefix) $ "-%td");
        }
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

    function bool ChangeTeam(Controller Other, int Num, bool bNewTeam)
    {
        local bool bSuccess;
        local UTPlayerController UTPC;

        bSuccess = global.ChangeTeam(Other, Num, bNewTeam);
        UTPC = UTPlayerController(Other);
        // End:0x70
        if(UTPC != none)
        {
            SetupPlayerMuteList(UTPC, false);
        }
        return bSuccess;
        //return ReturnValue;        
    }

    function Timer()
    {
        local PlayerController P;

        global.Timer();
        // End:0x2F
        if(!bFinalStartup)
        {
            bFinalStartup = true;
            PlayStartupMessage();
        }
        // End:0x120
        if(ForceRespawn())
        {
            // End:0x11F
            foreach WorldInfo.AllControllers(Class'Engine.PlayerController', P)
            {
                // End:0x11E
                if(((P.Pawn == none) && !P.PlayerReplicationInfo.bOnlySpectator) && !P.IsTimerActive('DoForcedRespawn'))
                {
                    P.ServerRestartPlayer();
                }                
            }            
        }
        // End:0x146
        if(bOverTime)
        {
            EndGame(none, "TimeLimit");            
        }
        else
        {
            // End:0x1B3
            if(TimeLimit > 0)
            {
                GameReplicationInfo.bStopCountDown = false;
                // End:0x1B0
                if(GameReplicationInfo.RemainingTime <= 0)
                {
                    EndGame(none, "TimeLimit");
                }                
            }
            else
            {
                // End:0x1E9
                if((MaxLives > 0) && (NumPlayers + NumBots) != 1)
                {
                    CheckMaxLives(none);
                }
            }
        }
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        local PlayerReplicationInfo PRI;

        // End:0xA0
        if(PreviousStateName != 'RoundOver')
        {
            // End:0x51
            foreach DynamicActors(Class'Engine.PlayerReplicationInfo', PRI)
            {
                PRI.StartTime = 0;                
            }            
            GameReplicationInfo.ElapsedTime = 0;
            bWaitingToStartMatch = false;
            StartupStage = 5;
            PlayStartupMessage();
            StartupStage = 6;
        }
        //return;        
    }
    stop;    
}

state MatchOver
{
    ignores RestartPlayer, ScoreKill;

    function ReduceDamage(out int Damage, Pawn injured, Controller InstigatedBy, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType, Actor DamageCauser)
    {
        Damage = 0;
        Momentum = vect(0.0000000, 0.0000000, 0.0000000);
        //return;        
    }

    function bool ChangeTeam(Controller Other, int Num, bool bNewTeam)
    {
        // End:0x5A
        if(Other.PlayerReplicationInfo != none)
        {
            Other.PlayerReplicationInfo.bOutOfLives = true;
        }
        return true;
        //return ReturnValue;        
    }

    event PostLogin(PlayerController NewPlayer)
    {
        global.PostLogin(NewPlayer);
        NewPlayer.GameHasEnded(EndGameFocus);
        //return;        
    }

    function Timer()
    {
        local PlayerController PC;
        local Sequence GameSequence;
        local array<SequenceObject> AllInterpActions;
        local SeqAct_Interp InterpAction;
        local int I, J;
        local bool bIsInCinematic;

        global.Timer();
        // End:0x5E
        if(!bGameRestarted && WorldInfo.RealTimeSeconds > (EndTime + float(RestartWait)))
        {
            RestartGame();
        }
        // End:0x2CF
        if(EndGameFocus != none)
        {
            EndGameFocus.bAlwaysRelevant = true;
            GameSequence = WorldInfo.GetGameSequence();
            // End:0x261
            if(GameSequence != none)
            {
                GameSequence.FindSeqObjectsByClass(Class'Engine.SeqAct_Interp', true, AllInterpActions);
                I = 0;
                J0x103:

                // End:0x261 [Loop If]
                if((I < AllInterpActions.Length) && !bIsInCinematic)
                {
                    InterpAction = SeqAct_Interp(AllInterpActions[I]);
                    // End:0x253
                    if((InterpAction.InterpData != none) && InterpAction.GroupInst.Length > 0)
                    {
                        J = 0;
                        J0x1A8:

                        // End:0x253 [Loop If]
                        if(J < InterpAction.InterpData.InterpGroups.Length)
                        {
                            // End:0x245
                            if(InterpGroupDirector(InterpAction.InterpData.InterpGroups[J]) != none)
                            {
                                bIsInCinematic = true;
                                // [Explicit Break]
                                goto J0x253;
                            }
                            J++;
                            // [Loop Continue]
                            goto J0x1A8;
                        }
                    }
                    J0x253:

                    I++;
                    // [Loop Continue]
                    goto J0x103;
                }
            }
            // End:0x2CF
            if(!bIsInCinematic)
            {
                // End:0x2CE
                foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
                {
                    PC.ClientSetViewTarget(EndGameFocus);                    
                }                
            }
        }
        EndMessageCounter++;
        // End:0x2FB
        if(EndMessageCounter == EndMessageWait)
        {
            PlayEndOfMatchMessage();
        }
        //return;        
    }

    function bool NeedPlayers()
    {
        return false;
        //return ReturnValue;        
    }

    function BeginState(name PreviousStateName)
    {
        local Pawn P;
        local array<SequenceObject> AIFactories;
        local SequenceObject AIFactory;
        local Sequence GameSeq;

        ResetAllPlayerMuteListsToSpectatorChannel();
        GameReplicationInfo.bStopCountDown = true;
        // End:0x81
        foreach WorldInfo.AllPawns(Class'Engine.Pawn', P)
        {
            P.TurnOff();            
        }        
        GameSeq = WorldInfo.GetGameSequence();
        // End:0x12E
        if(GameSeq != none)
        {
            GameSeq.FindSeqObjectsByClass(Class'EvilGame.SeqAct_AIFactory', true, AIFactories);
            // End:0x12D
            foreach AIFactories(AIFactory)
            {
                SeqAct_AIFactory(AIFactory).Deactivate();                
            }            
        }
        //return;        
    }

    function ResetLevel()
    {
        RestartGame();
        //return;        
    }
    stop;    
}

defaultproperties
{
    bBunnyhopping=true
    WeaponRespawnTime=15.0000000
    QuadDamageDuration=30.0000000
    QuadDamageModifier=4.0000000
    PentagramDuration=30.0000000
    InitialCountdown=10
    SecondsToStart="Seconds to start: "
    MinutesRemaining="Minutes remaining: "
    PlayerIsReady="Player `p is READY"
    PlayerIsUnready="Player `p is UNREADY"
    LuciferTimeSound[0]=SoundCue'a_LuciferMP.Cue.Lucifer_time01'
    LuciferTimeSound[1]=SoundCue'a_LuciferMP.Cue.Lucifer_time02'
    LuciferTimeSound[2]=SoundCue'a_LuciferMP.Cue.Lucifer_time03'
    LuciferTimeSound[3]=SoundCue'a_LuciferMP.Cue.Lucifer_time04'
    LuciferTimeSound[4]=SoundCue'a_LuciferMP.Cue.Lucifer_time05'
    LuciferTimeSound[5]=SoundCue'a_LuciferMP.Cue.Lucifer_time06'
    LuciferTimeSound[6]=SoundCue'a_LuciferMP.Cue.Lucifer_time07'
    LuciferTimeSound[7]=SoundCue'a_LuciferMP.Cue.Lucifer_time08'
    LuciferTimeSound[8]=SoundCue'a_LuciferMP.Cue.Lucifer_time09'
    LuciferVeryBadSound[0]=SoundCue'a_LuciferMP.Cue.Lucifer_verybad'
    LuciferBadSound[0]=SoundCue'a_LuciferMP.Cue.Lucifer_bad'
    LuciferGoodSound[0]=SoundCue'a_LuciferMP.Cue.Lucifer_good'
    LuciferExcellentSound[0]=SoundCue'a_LuciferMP.Cue.Lucifer_excellent'
    ClockTick=SoundCue'a_MiscMP.Cue.clock-tick'
    PlayerAccelRate=8192.0000000
    PlayerSpeed=600.0000000
    MaximalBunnyHopSpeed=1200.0000000
    BunnyHopAcceleration=0.2000000
    JumpStrength=0.8000000
    PlayerGravity=795.0000000
    SecondsWhenYouCanBunnyHopAfterLanding=0.1000000
    SecondsWhenYouCanBunnyHopBeforeLanding=0.3000000
    PlayerSlowdownDuringJump=1200.0000000
    CollisionMinSpeed=1000.0000000
    CollisionMaxSpeed=10150.0000000
    ConsolePlayerControllerClass=Class'PKPlayerController_MP'
    bPauseable=false
    DefaultPawnClass=Class'PKPlayerPawnMP'
    MaxPlayersAllowed=8
    DeathMessageClass=Class'PKDeathMessage'
    PlayerControllerClass=Class'PKPlayerController_MP'
}