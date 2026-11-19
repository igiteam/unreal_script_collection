class PKGameSP extends PKGame
    config(Game)
    hidecategories(Navigation,Movement,Collision);

var() float DemonTime;
var private bool bInDeamonMode;
var private bool bDemonModeWarningFlash;
var bool bStartupLoadCheckpoint;
var bool bStartupSaveCheckpoint;
var bool CoopPlayersAreAliveAndWell;
var bool bPlayingBattleMusic;
var int CurrentChapter;
var PKPlayerController CurrentPlayerController;
var Controller PlayerKiller;
var float PlayerDeathTime;
var float LastSeenEnemyTime;
var array<MusicTrackStruct> BattleMusic;
var array<MusicTrackStruct> AmbientMusic;

event InitGame(string Options, out string ErrorMessage)
{
    local int ChapterOption;

    super.InitGame(Options, ErrorMessage);
    // End:0x7B
    if((HasOption(Options, "loadcheckpoint")) && (ParseOption(Options, "loadcheckpoint")) != "0")
    {
        bStartupLoadCheckpoint = true;
    }
    ChapterOption = GetIntOption(Options, "chapter", -1);
    // End:0xCB
    if(ChapterOption > 0)
    {
        CurrentChapter = ChapterOption;        
    }
    CoopPlayersAreAliveAndWell = true;
    // End:0xF0
    if(bStartupLoadCheckpoint)
    {
        CoopPlayersAreAliveAndWell = false;
    }
    //return;    
}

function StartMatch()
{
    local PKPlayerController PC;

    super.StartMatch();
    // End:0x67
    if(bStartupLoadCheckpoint)
    {
        // End:0x5A
        foreach LocalPlayerControllers(Class'PKPlayerController', PC)
        {
            PC.LoadCheckpoint();
            // End:0x5A
            break;            
        }        
        bStartupLoadCheckpoint = false;
    }
    // End:0xC5
    foreach LocalPlayerControllers(Class'PKPlayerController', PC)
    {
        PC.UpdateDifficultySetting();
        PC.CheckForProfileForSlitscreenPlayer();        
    }    
    //return;    
}

function InitGameReplicationInfo()
{
    super.InitGameReplicationInfo();
    PainGRI_SP(GameReplicationInfo).ChapterNum = CurrentChapter;
    PainGRI_SP(GameReplicationInfo).InitializeTarotUnlockingSystem();
    //return;    
}

event int GetChapterNum()
{
    return CurrentChapter;
    //return ReturnValue;    
}

event byte GetDifficultyIdx()
{
    local PlayerController PC;

    // End:0xA0
    foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
    {
        // End:0x9F
        if(PainPRI(PC.PlayerReplicationInfo) != none)
        {            
            return PainPRI(PC.PlayerReplicationInfo).Difficulty.default.DifficultyLevel;
        }        
    }    
    return 0;
    //return ReturnValue;    
}

function ModifyScoreKill(Controller Killer, Controller Other)
{
    local float ScoreMultiplier;

    super(GameInfo).ModifyScoreKill(Killer, Other);
    // End:0xB4
    if((Killer == Other) || Killer == none)
    {
        // End:0xB1
        if((Other != none) && Other.PlayerReplicationInfo != none)
        {
            Other.PlayerReplicationInfo.Score += float(1);
        }        
    }
    else
    {
        // End:0x152
        if(Killer.PlayerReplicationInfo != none)
        {
            Killer.PlayerReplicationInfo.Score += ((float(Other.Pawn.HealthMax) * ScoreMultiplier) - float(1));
        }
    }
    //return;    
}

function ScoreHit(Controller HitInstigator, Controller Other, optional float Score = 1.0000000, optional int Priority, optional string ComboName)
{
    local float ScoreMultiplier;

    // End:0x146
    if(((HitInstigator != Other) && HitInstigator != none) && HitInstigator.PlayerReplicationInfo != none)
    {
        ScoreMultiplier = EvilPlayerReplicationInfo(HitInstigator.PlayerReplicationInfo).ScoreMultiplier;
        HitInstigator.PlayerReplicationInfo.Score += (Score * ScoreMultiplier);
        HitInstigator.PlayerReplicationInfo.bForceNetUpdate = true;
        CheckScore(HitInstigator.PlayerReplicationInfo);
    }
    //return;    
}

function ScoreLevel(PlayerController PC)
{
    // End:0x84
    if(PC != none)
    {
        PC.PlayerReplicationInfo.Score += float(10000 + (PC.Pawn.Health * 100));
    }
    //return;    
}

function RestartPlayer(Controller aPlayer)
{
    // End:0x25
    if(Class'Engine.WorldInfo'.static.IsMenuLevel())
    {
        return;
    }
    super.RestartPlayer(aPlayer);
    //return;    
}

function bool ShouldSpawnAtStartSpot(Controller Player)
{
    return (((int(WorldInfo.NetMode) == int(NM_Standalone)) && Player != none) && Player.StartSpot != none) && bWaitingToStartMatch || (Player.PlayerReplicationInfo != none) && Player.PlayerReplicationInfo.bWaitingPlayer;
    //return ReturnValue;    
}

function byte PickTeam(byte Num, Controller C)
{
    // End:0x12
    if(C == none)
    {
        return 255;
    }
    // End:0xC7
    if(C.IsA('EvilPlayerController') || ((EvilAIController(C) != none) && EvilAIController(C).Master != none) && EvilAIController(C).Master.IsA('EvilPlayerController'))
    {
        return 0;        
    }
    else
    {
        return 1;
    }
    //return ReturnValue;    
}

function bool ChangeTeam(Controller Other, int Num, bool bNewTeam)
{
    // End:0x61
    if((Num == 255) || !Other.IsA('EvilAIController'))
    {
        Num = int(PickTeam(byte(Num), Other));
    }
    SetTeam(Other, Teams[Num], false);
    return true;
    //return ReturnValue;    
}

function bool IsDeamonMode()
{
    return bInDeamonMode;
    //return ReturnValue;    
}

function StartDaemonMode(optional float InDemonTime, optional bool bIsWarningFlash = false)
{
    local float DemonT;
    local PKPlayerController PC;
    local PainGRI_SP PKGRI_SP;

    // End:0x26
    if((IsDeamonMode()) && !bDemonModeWarningFlash)
    {
        return;
    }
    // End:0x3D
    if(bDemonModeWarningFlash)
    {
        StopDaemonMode();
    }
    // End:0x91
    foreach WorldInfo.AllControllers(Class'PKPlayerController', PC)
    {
        PC.ToggleDemon();        
    }    
    PKGRI_SP = PainGRI_SP(WorldInfo.GRI);
    // End:0x102
    if((PKGRI_SP != none) && !bIsWarningFlash)
    {
        PKGRI_SP.IncrementDemonModeStarts();
    }
    DemonT = DemonTime;
    // End:0x139
    if(InDemonTime != float(0))
    {
        DemonT = InDemonTime;
    }
    DemonT *= Class'PKPlayerController'.default.DemonBulletTimeMultiplier;
    // End:0x18D
    if(DemonT > float(0))
    {
        SetTimer(DemonT, false, 'StopDaemonMode');        
    }
    else
    {
        ClearTimer('StopDaemonMode');
    }
    bInDeamonMode = true;
    bDemonModeWarningFlash = bIsWarningFlash;
    // End:0x21F
    if(WorldInfo.MusicComp != none)
    {
        WorldInfo.MusicComp.VolumeMultiplier = 0.0000000;
    }
    PainGRI_SP(GameReplicationInfo).bMusicTrackMuted = true;
    //return;    
}

function StopDaemonMode()
{
    local PKPlayerController PC;

    // End:0x79
    foreach WorldInfo.AllControllers(Class'PKPlayerController', PC)
    {
        // End:0x78
        if(PC.IsInState('Demon'))
        {
            PC.ToggleDemon();
        }        
    }    
    ClearTimer('StopDaemonMode');
    bInDeamonMode = false;
    bDemonModeWarningFlash = false;
    // End:0x103
    if(WorldInfo.MusicComp != none)
    {
        WorldInfo.MusicComp.VolumeMultiplier = 1.0000000;
    }
    PainGRI_SP(GameReplicationInfo).bMusicTrackMuted = false;
    //return;    
}

function float GetRemainingDemonModeTime()
{
    // End:0x1F
    if(!IsTimerActive('StopDaemonMode'))
    {
        return 0.0000000;
    }
    return (GetTimerRate('StopDaemonMode') - GetTimerCount('StopDaemonMode')) / Class'PKPlayerController'.default.DemonBulletTimeMultiplier;
    //return ReturnValue;    
}

function StartAchievementCheck(PKPlayerController PC, Controller Killer)
{
    // End:0x2D
    if(PainGRI(GameReplicationInfo).IsCoopMultiplayerGame())
    {
        return;
    }
    CurrentPlayerController = PC;
    PlayerDeathTime = WorldInfo.TimeSeconds + 1.0000000;
    PlayerKiller = Killer;
    //return;    
}

function NotifyKilled(Controller Killer, Controller Killed, Pawn KilledPawn, class<DamageType> DamageType)
{
    super(GameInfo).NotifyKilled(Killer, Killed, KilledPawn, DamageType);
    // End:0xA6
    if(((CurrentPlayerController != none) && PlayerKiller == Killed) && WorldInfo.TimeSeconds < PlayerDeathTime)
    {
        CurrentPlayerController.ClientUnlockAchievement(54);
    }
    // End:0xDB
    if(NotEqual_InterfaceInterface(EvilPlayer_interface(KilledPawn), EvilPlayer_interface(none)))
    {
        CoopPlayersAreAliveAndWell = false;
    }
    //return;    
}

function bool IsMusicControllerEnabled()
{
    return IsTimerActive('TryChangingMusic_T');
    //return ReturnValue;    
}

function SetMusicController(bool bEnabled, optional bool bForce = false)
{
    local MusicTrackStruct FakeEmptyMusicStruct;

    // End:0xCA
    if(bEnabled)
    {
        // End:0xC7
        if(!IsMusicControllerEnabled() || bForce)
        {
            // End:0xBD
            if((AmbientMusic.Length > 0) && AmbientMusic[0].TheSoundCue != none)
            {
                SetTimer(1.0000000, true, 'TryChangingMusic_T');
                bPlayingBattleMusic = false;
                WorldInfo.UpdateMusicTrack(AmbientMusic[Rand(AmbientMusic.Length)]);                
            }
            else
            {
                ScriptTrace();
            }
        }        
    }
    else
    {
        // End:0x11F
        if(IsMusicControllerEnabled())
        {
            ClearTimer('TryChangingMusic_T');
            bPlayingBattleMusic = false;
            WorldInfo.UpdateMusicTrack(FakeEmptyMusicStruct);
        }
    }
    //return;    
}

simulated function bool IsPlayingMusic()
{
    return IsTimerActive('TryChangingMusic_T');
    //return ReturnValue;    
}

protected function TryChangingMusic_T()
{
    local PlayerController PC;
    local PainGFxHudWrapper HUDWrapper;
    local PKPawn CompassFocus;
    local bool bAnyAIAlive;
    local array<SequenceObject> AIFactories;
    local SequenceObject AIFactory;
    local Sequence GameSeq;

    PC = GetALocalPlayerController();
    // End:0x25
    if(PC == none)
    {
        return;
    }
    // End:0xFB
    if(PC.bCinematicMode)
    {
        // End:0xF9
        if(bPlayingBattleMusic)
        {
            bPlayingBattleMusic = false;
            WorldInfo.UpdateMusicTrack(AmbientMusic[Rand(AmbientMusic.Length)]);
            // End:0xF9
            if(PainGRI_SP(GameReplicationInfo).bMusicTrackMuted)
            {
                WorldInfo.MusicComp.VolumeMultiplier = 0.0000000;
            }
        }
        return;
    }
    HUDWrapper = PainGFxHudWrapper(PC.myHUD);
    // End:0x13D
    if(HUDWrapper == none)
    {
        return;
    }
    CompassFocus = PKPawn(PainGFxHud(HUDWrapper.HudMovie).CurrentArrowTarget);
    // End:0x1EE
    if(CompassFocus != none)
    {
        bAnyAIAlive = !CompassFocus.bAmbientCreature && !CompassFocus.IsA('PKPawn_Raven_Base');
    }
    // End:0x2D2
    if(!bAnyAIAlive && bPlayingBattleMusic)
    {
        GameSeq = WorldInfo.GetGameSequence();
        // End:0x2D2
        if(GameSeq != none)
        {
            GameSeq.FindSeqObjectsByClass(Class'EvilGame.SeqAct_AIFactory', true, AIFactories);
            // End:0x2D1
            foreach AIFactories(AIFactory)
            {
                bAnyAIAlive = SeqAct_AIFactory(AIFactory).bSpawning;
                // End:0x2D0
                if(bAnyAIAlive)
                {                    
                }
                else
                {                    
                }
            }            
        }
    }
    // End:0x3F2
    if(bPlayingBattleMusic)
    {
        // End:0x317
        if(bAnyAIAlive)
        {
            LastSeenEnemyTime = WorldInfo.TimeSeconds;            
        }
        else
        {
            // End:0x3EF
            if((WorldInfo.TimeSeconds - LastSeenEnemyTime) > 5.0000000)
            {
                bPlayingBattleMusic = false;
                WorldInfo.UpdateMusicTrack(AmbientMusic[Rand(AmbientMusic.Length)]);
                // End:0x3EF
                if(PainGRI_SP(GameReplicationInfo).bMusicTrackMuted)
                {
                    WorldInfo.MusicComp.VolumeMultiplier = 0.0000000;
                }
            }
        }        
    }
    else
    {
        // End:0x4CC
        if(bAnyAIAlive)
        {
            LastSeenEnemyTime = WorldInfo.TimeSeconds;
            bPlayingBattleMusic = true;
            WorldInfo.UpdateMusicTrack(BattleMusic[Rand(BattleMusic.Length)]);
            // End:0x4CC
            if(PainGRI_SP(GameReplicationInfo).bMusicTrackMuted)
            {
                WorldInfo.MusicComp.VolumeMultiplier = 0.0000000;
            }
        }
    }
    //return;    
}

event PostLogin(PlayerController NewPlayer)
{
    local PKPlayerController PC;

    super.PostLogin(NewPlayer);
    PC = PKPlayerController(NewPlayer);
    // End:0xF7
    if(PC != none)
    {
        PC.ClientSetCampaignRichPresence(int(PainPRI(PC.PlayerReplicationInfo).CharClassInfo == Class'PainPRI'.default.SecondPlayerCharClassInfo), PainGRI_SP(WorldInfo.GRI).ChapterNum);
    }
    //return;    
}

event Broadcast(Actor Sender, coerce string msg, optional name Type)
{
    //return;    
}

function BroadcastTeam(Controller Sender, coerce string msg, optional name Type)
{
    //return;    
}

function UseGoldenCards()
{
    local PKPlayerController aPlayer;
    local PainGRI GRI;
    local int Idx;

    GRI = PainGRI(GameReplicationInfo);
    // End:0x40
    if(GRI.IsMultiplayerGame())
    {
        return;
    }
    // End:0x4F
    if(bGoldenCardsActive)
    {
        return;
    }
    Idx = 0;
    J0x5A:

    // End:0xDD [Loop If]
    if(Idx < 3)
    {
        // End:0xCF
        if(int(GRI.SelectedGoldCards[Idx]) != int(0))
        {
            ApplyGoldenCard(GRI.SelectedGoldCards[Idx]);
        }
        ++Idx;
        // [Loop Continue]
        goto J0x5A;
    }
    SetTimer(float(GoldenCardTimeout), false, 'DeactivateGoldenCards');
    SetTimer(float(GoldenCardTimeout - GoldenCardWarnBeforeEndTime), false, 'GoldenCardsDeactivateWarning');
    bGoldenCardsActive = true;
    // End:0x17A
    foreach WorldInfo.AllControllers(Class'PKPlayerController', aPlayer)
    {
        aPlayer.ClientPlayGoldenCardsUseEffects();        
    }    
    //return;    
}

function ApplyGoldenCard(PKTarotManager.EGoldenTarrotCard InCard)
{
    DebugMsg("Golden card activated: " @ Class'PKTarotManager'.default.GoldenCardsList[int(InCard)].CardName);
    switch(InCard)
    {
        // End:0x8D
        case 1:
            PlayerDamageFactor = 0.5000000;
            // End:0x1AC
            break;
        // End:0xAB
        case 2:
            EnableBulletTime(1.0000000 / 2.0000000);
            // End:0x1AC
            break;
        // End:0xCA
        case 3:
            GoldenCardTimeout = GoldenCardTimeout + 10;
            // End:0x1AC
            break;
        // End:0xE1
        case 4:
            ChangePlayersSpeed(1.5000000);
            // End:0x1AC
            break;
        // End:0xF8
        case 5:
            MonsterDamageFactor = 2.0000000;
            // End:0x1AC
            break;
        // End:0x116
        case 6:
            EnableBulletTime(1.0000000 / 4.0000000);
            // End:0x1AC
            break;
        // End:0x12D
        case 7:
            ReloadSpeedFactor = 0.5000000;
            // End:0x1AC
            break;
        // End:0x141
        case 8:
            bPlayerNoDamage = true;
            // End:0x1AC
            break;
        // End:0x158
        case 9:
            MonsterDamageFactor = 4.0000000;
            // End:0x1AC
            break;
        // End:0x177
        case 10:
            GoldenCardTimeout = GoldenCardTimeout + 20;
            // End:0x1AC
            break;
        // End:0x195
        case 11:
            EnableBulletTime(1.0000000 / 8.0000000);
            // End:0x1AC
            break;
        // End:0x1A9
        case 12:
            bConfuseEnemies = true;
            // End:0x1AC
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}

function ApplyCards()
{
    local PainGRI GRI;
    local int Idx;

    GRI = PainGRI(GameReplicationInfo);
    Idx = 0;
    J0x27:

    // End:0xAA [Loop If]
    if(Idx < 2)
    {
        // End:0x9C
        if(int(GRI.SelectedSilverCards[Idx]) != int(0))
        {
            ApplySilverCard(GRI.SelectedSilverCards[Idx]);
        }
        ++Idx;
        // [Loop Continue]
        goto J0x27;
    }
    //return;    
}

function ApplySilverCard(PKTarotManager.ESilverTarrotCard InCard)
{
    switch(InCard)
    {
        // End:0x2E
        case 1:
            SoulStayFactor = SoulStayFactorWithKeeper;
            // End:0x1F9
            break;
        // End:0x49
        case 2:
            InitialPlayerHealth = InitialPlayerHealthWithBlessing;
            // End:0x1F9
            break;
        // End:0x64
        case 3:
            AmmoFoundFactor = AmmoFoundFactorWithReplenish;
            // End:0x1F9
            break;
        // End:0x7F
        case 4:
            SoulsToEnableDemon = SoulsToEnableDemonWithDarkSoul;
            // End:0x1F9
            break;
        // End:0x93
        case 5:
            bAttractSouls = true;
            // End:0x1F9
            break;
        // End:0xA7
        case 6:
            GoldenCardsUseLeft = 2;
            // End:0x1F9
            break;
        // End:0xBB
        case 7:
            bGreedCardEnabled = true;
            // End:0x1F9
            break;
        // End:0xE9
        case 8:
            PlayerHealthCapacity = PlayerHealthCapacityWithVitality;
            InitialPlayerHealth = InitialPlayerHealthWithVitality;
            // End:0x1F9
            break;
        // End:0xF1
        case 9:
            // End:0x1F9
            break;
        // End:0x105
        case 10:
            bLastBreathCardEnabled = true;
            // End:0x1F9
            break;
        // End:0x120
        case 11:
            SoulHealthFactor = SoulHealthFactorWithRedeemer;
            // End:0x1F9
            break;
        // End:0x134
        case 12:
            GoldenCardsUseLeft = 3;
            // End:0x1F9
            break;
        // End:0x14F
        case 13:
            MonsterInitialHealthModifier = MonsterInitialHealthModifierCard;
            // End:0x1F9
            break;
        // End:0x176
        case 14:
            bStealHealth = true;
            StealHealthPct = StealHealthPctCard;
            // End:0x1F9
            break;
        // End:0x19D
        case 15:
            ArmorRegenSpeed = ArmorRegenSpeedCard;
            bArmorRegenEnabled = true;
            // End:0x1F9
            break;
        // End:0x1CF
        case 16:
            PainGRI_SP(GameReplicationInfo).b666AmmoCardEnabled = true;
            // End:0x1F9
            break;
        // End:0x1F6
        case 17:
            bHealthRegenEnabled = true;
            HealthRegenSpeed = HealthRegenSpeedCard;
            // End:0x1F9
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}

defaultproperties
{
    DemonTime=20.0000000
    Acronym="SP"
    SpawnProtectionTime=0.0000000
    MapPrefixes=/* Array type was not detected. */
    ConsolePlayerControllerClass=Class'PKPlayerController_SP'
    PlayerControllerClass=Class'PKPlayerController_SP'
    PlayerReplicationInfoClass=Class'PainPRI_SP'
    GameReplicationInfoClass=Class'PainGRI_SP'
    OnlineGameSettingsClass=Class'PKGameCampaignSettings'
}