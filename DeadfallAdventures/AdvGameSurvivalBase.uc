class AdvGameSurvivalBase extends AdvGameMP_Base
    config(Game)
    hidecategories(Navigation,Movement,Collision);

var config float SurvivalDamageModifier;
var int ScoreForWeakEnemy;
var int ScoreForMediumEnemy;
var int ScoreForHardEnemy;
var int ScoreForTreeter;
var int ScoreForBossEnemy;
var int BonusScoreForLeuchpistol;
var int BonusScoreForDevastator;
var int BonusScoreForMummy;
var float TrapBonusScoreModifier;
var float FinisherScoreModifier;
var float AssistScoreModifier;
var const localized string CountDownMsg;
var string CountDownStringKey[3];
var bool bMatchWon;
var EvilTypesNative.EDifficultyLevel DifficultyLevel;

function ReduceDamage(out int Damage, Pawn injured, Controller InstigatedBy, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType, Actor DamageCauser)
{
    super(ADVGame).ReduceDamage(Damage, injured, InstigatedBy, HitLocation, Momentum, DamageType, DamageCauser);
    // End:0x8F
    if(!injured.IsPlayerOwned())
    {
        Damage = int(float(Damage) * SurvivalDamageModifier);
    }
    //return;    
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

function GenericPlayerInitialization(Controller C)
{
    // End:0x22
    if(!bUseClassicHUD)
    {
        HUDType = Class'AdvGFxHudWrapperMP_Survival';
    }
    super(GameInfo).GenericPlayerInitialization(C);
    // End:0x69
    if(PlayerController(C) != none)
    {
        RestartPlayer(PlayerController(C));
    }
    CommonForGenericPlayerInitialization(C);
    //return;    
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

static function string GetAITypePawnClassName(AdvTypes.EAITypes AIType)
{
    local string Result;
    local int DotIndex;

    Result = Class'SeqAct_AdvAIFactory'.default.SpawnInfo[int(AIType)].PawnClassNameArray[0];
    DotIndex = InStr(Result, ".");
    Result = Right(Result, (Len(Result) - DotIndex) - 1);
    return Result;
    //return ReturnValue;    
}

function ScoreKill(Controller Killer, Controller Other)
{
    local AdvPlayerControllerMP AssistingPlayer;
    local AdvMapInfo MyMapInfo;
    local int BaseCreatureScore, KillScore, TrapScore;
    local string OtherPawnClassName;
    local AdvTypes.EAITypes AIType;

    // End:0xD6
    if((Killer == Other) || Killer == none)
    {
        // End:0xD3
        if((Other != none) && Other.PlayerReplicationInfo != none)
        {
            Other.PlayerReplicationInfo.Score -= float(ScoreForSuicide);
            Other.PlayerReplicationInfo.bForceNetUpdate = true;
        }        
    }
    else
    {
        // End:0xFF5
        if(Killer.PlayerReplicationInfo != none)
        {
            // End:0x1DA
            if((Other.PlayerReplicationInfo != none) && Killer.PlayerReplicationInfo != Other.PlayerReplicationInfo)
            {
                Killer.PlayerReplicationInfo.Score -= float(ScoreForSuicide);
                Killer.PlayerReplicationInfo.bForceNetUpdate = true;                
            }
            else
            {
                // End:0xFF5
                if(AdvAIController(Other) != none)
                {
                    MyMapInfo = AdvMapInfo(WorldInfo.GetMapInfo());
                    OtherPawnClassName = string(Other.Pawn.Class);
                    // End:0x371
                    foreach MyMapInfo.WeakEnemiesTypes(AIType)
                    {
                        // End:0x370
                        if((GetAITypePawnClassName(AIType)) == OtherPawnClassName)
                        {
                            BaseCreatureScore = ScoreForWeakEnemy;
                            AdvPRI(Killer.PlayerReplicationInfo).SurvivalMummiesKilledStat++;
                            // End:0x36D
                            if(AdvGRI(WorldInfo.GRI).CanWriteStats())
                            {
                                AdvPlayerControllerMP(Killer).IncrementGlobalIntStat(140);
                            }                            
                        }
                        else
                        {                            
                        }
                    }                    
                    // End:0x490
                    if(BaseCreatureScore == 0)
                    {
                        // End:0x48F
                        foreach MyMapInfo.MediumEnemiesTypes(AIType)
                        {
                            // End:0x48E
                            if((GetAITypePawnClassName(AIType)) == OtherPawnClassName)
                            {
                                BaseCreatureScore = ScoreForMediumEnemy;
                                AdvPRI(Killer.PlayerReplicationInfo).SurvivalMummiesKilledStat++;
                                // End:0x48B
                                if(AdvGRI(WorldInfo.GRI).CanWriteStats())
                                {
                                    AdvPlayerControllerMP(Killer).IncrementGlobalIntStat(140);
                                }                                
                            }
                            else
                            {                                
                            }
                        }                        
                    }
                    // End:0x5AE
                    if(BaseCreatureScore == 0)
                    {
                        // End:0x5AD
                        foreach MyMapInfo.HardEnemiesTypes(AIType)
                        {
                            // End:0x5AC
                            if((GetAITypePawnClassName(AIType)) == OtherPawnClassName)
                            {
                                BaseCreatureScore = ScoreForHardEnemy;
                                AdvPRI(Killer.PlayerReplicationInfo).SurvivalMummiesKilledStat++;
                                // End:0x5A9
                                if(AdvGRI(WorldInfo.GRI).CanWriteStats())
                                {
                                    AdvPlayerControllerMP(Killer).IncrementGlobalIntStat(140);
                                }                                
                            }
                            else
                            {                                
                            }
                        }                        
                    }
                    // End:0x6CC
                    if(BaseCreatureScore == 0)
                    {
                        // End:0x6CB
                        foreach MyMapInfo.BossEnemiesTypes(AIType)
                        {
                            // End:0x6CA
                            if((GetAITypePawnClassName(AIType)) == OtherPawnClassName)
                            {
                                BaseCreatureScore = ScoreForBossEnemy;
                                AdvPRI(Killer.PlayerReplicationInfo).SurvivalBossesKilledStat++;
                                // End:0x6C7
                                if(AdvGRI(WorldInfo.GRI).CanWriteStats())
                                {
                                    AdvPlayerControllerMP(Killer).IncrementGlobalIntStat(142);
                                }                                
                            }
                            else
                            {                                
                            }
                        }                        
                    }
                    // End:0x7B0
                    if(BaseCreatureScore == 0)
                    {
                        // End:0x7B0
                        if(AdvAI_Treeter(Other) != none)
                        {
                            BaseCreatureScore = ScoreForTreeter;
                            AdvPRI(Killer.PlayerReplicationInfo).SurvivalTreetersKilledStat++;
                            // End:0x7B0
                            if(AdvGRI(WorldInfo.GRI).CanWriteStats())
                            {
                                AdvPlayerControllerMP(Killer).IncrementGlobalIntStat(141);
                            }
                        }
                    }
                    // End:0x9B6
                    if(AdvAIController(Other).bKilledByTrap)
                    {
                        // End:0x81B
                        if(Killer == none)
                        {
                            Killer = AdvPlayerControllerMP(Other).TrapKiller;
                        }
                        TrapScore = int((float(BaseCreatureScore) * AdvPlayerControllerMP(Killer).SurvivalScoreModifier) * TrapBonusScoreModifier);
                        Class'EvilGame.EvilDifficultySettings'.static.GetClassByID(AdvPlayerController(Killer).GetFightDifficultyLevel()).ModifySurvivalScore(TrapScore);
                        AdvPRI(Killer.PlayerReplicationInfo).SurvivalTrapKillsStat++;
                        Killer.PlayerReplicationInfo.Score += float(TrapScore);
                        // End:0x9B6
                        if(AdvGRI(WorldInfo.GRI).CanWriteStats())
                        {
                            AdvPlayerControllerMP(Killer).IncrementGlobalIntStat(143);
                        }
                    }
                    // End:0xE08
                    if(AdvAIController(Other).AssistingPlayers.Length > 1)
                    {
                        // End:0xE04
                        foreach AdvAIController(Other).AssistingPlayers(AssistingPlayer)
                        {
                            // End:0xE03
                            if(((AssistingPlayer != none) && AssistingPlayer.PlayerReplicationInfo != none) && AssistingPlayer.Pawn != none)
                            {
                                // End:0xC1D
                                if(AssistingPlayer != Killer)
                                {
                                    KillScore = int((float(BaseCreatureScore) * AdvPlayerControllerMP(Killer).SurvivalScoreModifier) * AssistScoreModifier);
                                    Class'EvilGame.EvilDifficultySettings'.static.GetClassByID(AdvPlayerController(Killer).GetFightDifficultyLevel()).ModifySurvivalScore(KillScore);
                                    AssistingPlayer.SetAssistInfo(KillScore);
                                    AdvPRI(AssistingPlayer.PlayerReplicationInfo).Assists++;
                                    AssistingPlayer.PlayerReplicationInfo.Score += float(KillScore);
                                    AssistingPlayer.PlayerReplicationInfo.bForceNetUpdate = true;                                    
                                }
                                else
                                {
                                    KillScore = int((float(BaseCreatureScore) * AdvPlayerControllerMP(Killer).SurvivalScoreModifier) * FinisherScoreModifier);
                                    Class'EvilGame.EvilDifficultySettings'.static.GetClassByID(AdvPlayerController(Killer).GetFightDifficultyLevel()).ModifySurvivalScore(KillScore);
                                    // End:0xD2E
                                    if(AdvAIController(Other).bKilledByTrap)
                                    {
                                        AssistingPlayer.SetFinisherInfo(KillScore, true, TrapScore);                                        
                                    }
                                    else
                                    {
                                        AssistingPlayer.SetFinisherInfo(KillScore);
                                    }
                                    AssistingPlayer.PlayerReplicationInfo.Score += float(KillScore);
                                    AssistingPlayer.PlayerReplicationInfo.Kills++;
                                    AssistingPlayer.PlayerReplicationInfo.bForceNetUpdate = true;
                                }
                            }                            
                        }                                                
                    }
                    else
                    {
                        KillScore = int(float(BaseCreatureScore) * AdvPlayerControllerMP(Killer).SurvivalScoreModifier);
                        Class'EvilGame.EvilDifficultySettings'.static.GetClassByID(AdvPlayerController(Killer).GetFightDifficultyLevel()).ModifySurvivalScore(KillScore);
                        // End:0xF17
                        if(AdvAIController(Other).bKilledByTrap)
                        {
                            AdvPlayerControllerMP(Killer).SetFlawlessInfo(KillScore, true, TrapScore);                            
                        }
                        else
                        {
                            AdvPlayerControllerMP(Killer).SetFlawlessInfo(KillScore);
                        }
                        Killer.PlayerReplicationInfo.Score += float(KillScore);
                        Killer.PlayerReplicationInfo.Kills++;
                        Killer.PlayerReplicationInfo.bForceNetUpdate = true;
                    }
                }
            }
        }
    }
    ModifyScoreKill(Killer, Other);
    // End:0x10A4
    if(((Other != none) && Other.PlayerReplicationInfo != none) && AdvPlayerControllerMP(Other) != none)
    {
        AdvPlayerControllerMP(Other).ResetSurvivalScoreModifier();
        CheckLastInTeam(AdvPlayerControllerMP(Other));
    }
    // End:0x10EC
    if((Killer != none) || MaxLives > 0)
    {
        CheckScore(Killer.PlayerReplicationInfo);
    }
    //return;    
}

function bool CheckScore(PlayerReplicationInfo Scorer)
{
    return false;
    //return ReturnValue;    
}

function NotifyKilled(Controller Killer, Controller Killed, Pawn KilledPawn, class<DamageType> DamageType)
{
    local bool bAllPlayersDied;
    local AdvPlayerController PC;

    super.NotifyKilled(Killer, Killed, KilledPawn, DamageType);
    bAllPlayersDied = true;
    // End:0xDB
    foreach WorldInfo.AllControllers(Class'AdvPlayerController', PC)
    {
        // End:0xDA
        if((PC.Pawn != none) && PC.Pawn.IsAliveAndWell())
        {
            bAllPlayersDied = false;
            // End:0xDB
            break;
        }        
    }    
    // End:0x11F
    if(bAllPlayersDied)
    {
        EndGame(Killed.PlayerReplicationInfo, "SurvivalLose");
    }
    //return;    
}

function EndGame(PlayerReplicationInfo Winner, string Reason)
{
    // End:0x1B
    if(Reason ~= "TimeLimit")
    {
        return;
    }
    // End:0x45
    if(Reason ~= "SurvivalWin")
    {
        bMatchWon = true;        
    }
    else
    {
        bMatchWon = false;
    }
    super.EndGame(Winner, Reason);
    //return;    
}

function bool CheckEndGame(PlayerReplicationInfo Winner, string Reason)
{
    local bool bResult;

    bResult = super.CheckEndGame(Winner, Reason);
    // End:0x62
    if((Reason ~= "SurvivalWin") || Reason ~= "SurvivalLose")
    {
        return true;
    }
    return bResult;
    //return ReturnValue;    
}

function ShowEndScreen()
{
    SetTimer(2.0000000, false, 'ServerShowSurvivalEndStatisticsScreen', GameReplicationInfo);
    //return;    
}

function PlayEndMatchSound()
{
    local AdvPlayerControllerMP PC;
    local int I;

    // End:0x18B
    foreach WorldInfo.AllControllers(Class'AdvPlayerControllerMP', PC)
    {
        // End:0xE7
        if(bMatchWon)
        {
            I = Rand(EndMatchSoundWin.Length);
            PC.ClientPlaySound(EndMatchSoundWin[I]);
            PC.SetSecondaryAnnouncerMessage(ConvertToLocalizedString("MultiplayerAnnouncer", EndMatchWinStringKey[I], "AdvGame"));
            // End:0x18A
            continue;
        }
        I = Rand(EndMatchSoundLose.Length);
        PC.ClientPlaySound(EndMatchSoundLose[I]);
        PC.SetSecondaryAnnouncerMessage(ConvertToLocalizedString("MultiplayerAnnouncer", EndMatchLoseStringKey[I], "AdvGame"));        
    }    
    //return;    
}

function SpawnPlayerBaseInventory(AdvPlayerControllerMP PC)
{
    local int WeaponIndex, I;
    local class<EvilWeap_Base> WeaponClass;

    I = 1;
    J0x0B:

    // End:0x15F [Loop If]
    if(I < MultiplayerClassInfoClass.default.ClassInfo[0].EquipmentIndices.Length)
    {
        WeaponIndex = MultiplayerClassInfoClass.default.ClassInfo[0].EquipmentIndices[I];
        WeaponClass = class<EvilWeap_Base>(MultiplayerClassInfoClass.default.Equipment[WeaponIndex]);
        // End:0x151
        if(PC.Pawn.FindInventoryType(WeaponClass, false) == none)
        {
            PC.Pawn.CreateInventory(WeaponClass, true);
        }
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    WeaponIndex = MultiplayerClassInfoClass.default.ClassInfo[0].EquipmentIndices[0];
    WeaponClass = class<EvilWeap_Base>(MultiplayerClassInfoClass.default.Equipment[WeaponIndex]);
    // End:0x25B
    if(PC.Pawn.FindInventoryType(WeaponClass, false) == none)
    {
        PC.Pawn.CreateInventory(WeaponClass, false);
    }
    AdvPlayerPawn(PC.Pawn).SetCurrentWeaponClass(WeaponClass);
    //return;    
}

function DoPostLogin(PlayerController NewPlayer)
{
    super.DoPostLogin(NewPlayer);
    // End:0x84
    if(AdvPlayerControllerMP(NewPlayer) != none)
    {
        AdvPlayerController(NewPlayer).SetFightDifficultyLevel(DifficultyLevel);
        AdvPlayerControllerMP(NewPlayer).ServerRestartPlayer();
    }
    //return;    
}

function SetGameRulesFromUrl(string Options)
{
    local int DifficultyIdx;

    super.SetGameRulesFromUrl(Options);
    // End:0xAE
    if(HasOption(Options, "FightDifficultyLevel"))
    {
        DifficultyIdx = GetIntOption(Options, "FightDifficultyLevel", -1);
        // End:0xA2
        if(DifficultyIdx != -1)
        {
            DifficultyLevel = byte(DifficultyIdx);            
        }
        else
        {
            DifficultyLevel = 1;
        }
    }
    //return;    
}

event Timer()
{
    local AdvPlayerControllerMP PC;

    super(GameInfo).Timer();
    // End:0x13F
    if(CountDown > 0)
    {
        // End:0x130
        foreach WorldInfo.AllControllers(Class'AdvPlayerControllerMP', PC)
        {
            // End:0x89
            if(CountDown > 3)
            {
                PC.SetSurvivalCountDownMessage(,, CountDown);                
            }
            else
            {
                PC.SetAnnouncerMessage(ConvertToLocalizedString("MultiplayerAnnouncer", CountDownStringKey[CountDown - 1], "AdvGame"), CountdownSounds[CountDown - 1], true);
            }
            // End:0x12F
            if(CountDown == 3)
            {
                PC.SetSurvivalCountDownMessage(true);
            }            
        }        
        CountDown--;        
    }
    else
    {
        // End:0x1BB
        if(CountDown == 0)
        {
            TriggerGlobalEventClass(Class'SeqEvent_StartFirstSurvivalWave', none);
            CountDown = -1;
            // End:0x1BA
            foreach WorldInfo.AllControllers(Class'AdvPlayerControllerMP', PC)
            {
                PlayStartMessage(PC);                
            }            
        }
    }
    //return;    
}

function PlayStartMessage(AdvPlayerControllerMP PC)
{
    local int I;

    I = Rand(StartMatchSound.Length);
    // End:0xB5
    if(CountDown <= 0)
    {
        PC.SetSurvivalCountDownMessage(true);
        PC.SetAnnouncerMessage(ConvertToLocalizedString("MultiplayerAnnouncer", StartMatchStringKey[I], "AdvGame"), StartMatchSound[I], true);
    }
    //return;    
}

function CheckLastInTeam(AdvPlayerControllerMP Killed)
{
    local AdvPlayerControllerMP PC;
    local bool bIsLastInTeam;

    bIsLastInTeam = true;
    // End:0x191
    foreach WorldInfo.AllControllers(Class'AdvPlayerControllerMP', PC)
    {
        // End:0x190
        if(((((((PC != Killed) && WorldInfo.GRI.OnSameTeam(PC, Killed)) && !PC.IsInState('Dead')) && !PC.IsInState('Spectating')) && !PC.IsInState('Wounded')) && !PC.IsInState('SurvivalWounded')) && !PC.MyAdvPlayerPawnMP.bIsWounded)
        {
            bIsLastInTeam = false;            
            return;
        }        
    }    
    // End:0x1B8
    if(bIsLastInTeam)
    {
        EndGame(none, "SurvivalLose");
    }
    //return;    
}

static function SetDefaultTeamInfo(out int TeamSize, out int TeamCount, out int MaxPartySize)
{
    TeamSize = Class'AdvGameSurvivalSettings'.default.MaxPlayers;
    TeamCount = 1;
    MaxPartySize = Class'AdvGameSurvivalSettings'.default.MaxPlayers;
    //return;    
}

defaultproperties
{
    SurvivalDamageModifier=1.2000000
    ScoreForWeakEnemy=50
    ScoreForMediumEnemy=100
    ScoreForHardEnemy=150
    ScoreForTreeter=400
    ScoreForBossEnemy=1000
    BonusScoreForLeuchpistol=100
    BonusScoreForDevastator=125
    BonusScoreForMummy=200
    TrapBonusScoreModifier=1.0000000
    FinisherScoreModifier=0.6700000
    AssistScoreModifier=0.3300000
    CountDownMsg="First wave starts in: `t"
    CountDownStringKey[0]="a_Countdown_01"
    CountDownStringKey[1]="a_Countdown_02"
    CountDownStringKey[2]="a_Countdown_03"
    DifficultyLevel=EDifficultyLevel.DL_Normal
    bPlayCloseToEndSounds=false
    BonusScoreForTrapKill=0
    EndTimeDelay=2.5000000
    RestartWait=6
    CountDown=10
    bDelayedStart=false
    OnlineStatsWriteClass=Class'AdvLeaderboard_Write_SV'
}