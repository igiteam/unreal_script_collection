class AdvPlayerControllerMP extends AdvPlayerController
    config(Game)
    hidecategories(Navigation);

struct MainMessage
{
    var string Message;
    var string IconPath;
    var SoundCue SoundMessage;

    structdefaultproperties
    {
        Message=""
        IconPath=""
        SoundMessage=none
    }
};

var config float EndScreenDuration;
var bool bFirstSpawn;
var bool WallSeeEnabled;
var bool bKilledByTrap;
var bool bDisplaySurvivalWaveEndMessage;
var bool bIsArmageddonActivator;
var transient bool bDisplayingTutorialMessage;
var bool bFiringDisabled;
var bool bFrozenCamera;
var bool bCanBeRescued;
var bool bLMSCameraTPPMode;
var bool bSecondChanceEnabled;
var bool bChoseCustomClassesOnly;
var bool bKillInfoTextDisplaying;
var bool bTrapInfoTextDisplaying;
var transient bool bBlockFire;
var array<byte> bAvaiblePerks;
var repnotify float SurvivalScoreModifier;
var SoundCue LevelUpSound;
var SoundCue UpgradeSound;
var SoundCue WayPointSuccess;
var SoundCue WayPointFailure;
var const localized string EndSurvivalWaveMessage;
var const localized string ClassChangedMessage;
var const localized string BonusTrapKillMsg;
var const localized string ComboKillMsg;
var float ComboKillMaxInterval;
var AdvPlayerControllerMP TrapKiller;
var array<AdvBlessing_Base> ActiveBlessings;
var class<EvilFamilyInfoBase> OldPlayerClass;
var array<AdvPlayerControllerMP> AssistingPlayers;
var export editinline AudioComponent ArmageddonHeartBeat;
var export editinline AudioComponent QuadAudioLoop;
var export editinline AudioComponent PerkActivationMusic;
var Vector KillerLocation;
var transient AdvGameHostMigrationManager GameHostMigrationManager;
var config float TimeToRescueLMS;
var config float TimeToRescueSurvival;
var int DeathTimerClicks;
var float SecondChanceBlessingTime;
var float RescueTime;
var string LastMenStandingTimer;
var class<EvilWeap_Base> InitialWeaponClass;
var config int SurvivalDevastatorModeTime;
var config int SurvivalMummyModeTime;
var int EnemyKilledByFireTrap;
var array<string> KilledPlayerNames;
var int CurrentKillInfoScore;
var int CurrentKillInfoTrapScore;
var array<MainMessage> MainMessagesQueue;
var AdvCharacterStore CharacterStore;
var transient AdvPuzzleHudComponent PuzzleHudComponent;
var transient AdvConsoleObjectMPDLC1_base ConsoleObject;
//var delegate<IsPawnInUsableAngle> __IsPawnInUsableAngle__Delegate;

replication
{
    // Pos:0x000
    if(bNetDirty && bNetOwner
        KillerLocation, RescueTime, 
        SurvivalScoreModifier, bCanBeRescued, 
        bFirstSpawn, bSecondChanceEnabled;
}

simulated function FamilyInfoLoaded(class<AdvFamilyInfoBase> LoadedClass)
{
    //return;    
}

event InitInputSystem()
{
    super.InitInputSystem();
    // End:0x7C
    if((int(Role) < int(ROLE_Authority)) && int(NetPlayerIndex) == int(0))
    {
        CharacterStore = new (self) Class'AdvCharacterStore';
        CharacterStore.__LoadComplete__Delegate = FamilyInfoLoaded;
    }
    //return;    
}

reliable client simulated function ClientLoadMPCharacter(int characterIndex)
{
    //return;    
}

reliable client simulated function ClientUnloadMPCharacter(string CharacterPath)
{
    local AdvPRI PRI;
    local int I;

    PRI = AdvPRI(PlayerReplicationInfo);
    // End:0x16D
    if(PRI != none)
    {
        // End:0x3C
        if(CharacterStore == none)
        {
            return;
        }
        I = 0;
        J0x47:

        // End:0xBA [Loop If]
        if(I < CharacterStore.PendingClasses.Length)
        {
            // End:0xAC
            if(CharacterStore.PendingClasses[I] == CharacterPath)
            {
                return;
            }
            I++;
            // [Loop Continue]
            goto J0x47;
        }
        I = 0;
        J0xC5:

        // End:0x16D [Loop If]
        if(I < CharacterStore.LoadedClasses.Length)
        {
            // End:0x15F
            if(PathName(CharacterStore.LoadedClasses[I]) == CharacterPath)
            {
                CharacterStore.LoadedClasses.Remove(I, 1);                
                // [Explicit Break]
                goto J0x16D;
            }
            I++;
            // [Loop Continue]
            goto J0xC5;
        }
    }
    J0x16D:

    //return;    
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    UpdateTrapMaterials();
    // End:0xB1
    if(WorldInfo.GRI != none)
    {
        // End:0x96
        if(AdvGRI(WorldInfo.GRI).bTraps)
        {
            IterateOverFocusHighligths(EnableHighlights);            
        }
        else
        {
            IterateOverFocusHighligths(DisableHighlights);
        }
    }
    InitializePlayerXPInfo();
    //return;    
}

reliable client simulated function InitializePlayerXPInfo()
{
    local int BaseXP;

    // End:0x7E
    if((PlayerReplicationInfo != none) && ProfileSettings != none)
    {
        ProfileSettings.GetProfileSettingValueInt(36, BaseXP);
        AdvPRI(PlayerReplicationInfo).InitXP(BaseXP);        
    }
    else
    {
        SetTimer(0.1000000, false, 'InitializePlayerXPInfo');
    }
    //return;    
}

function SaveWeaponKillCountStat(class<Inventory> WeaponClass, int NewKillCount)
{
    local int I, J;
    local class<Inventory> InvClass;
    local array<int> WeaponKillCounts;
    local bool bAllWeaponsFullyUpgraded;

    ProfileSettings.GetWeaponLevels(42, WeaponKillCounts);
    // End:0xE0
    if(WeaponKillCounts[0] != Class'AdvClassInfo_MP_Base'.default.Version)
    {
        WeaponKillCounts[0] = Class'AdvClassInfo_MP_Base'.default.Version;
        I = 0;
        J0x8D:

        // End:0xE0 [Loop If]
        if(I < Class'AdvClassInfo_MP_Base'.default.Equipment.Length)
        {
            WeaponKillCounts[I + 1] = 0;
            I++;
            // [Loop Continue]
            goto J0x8D;
        }
    }
    // End:0x176
    foreach Class'AdvClassInfo_MP_Base'.default.Equipment(InvClass, I)
    {
        // End:0x175
        if(ClassIsChildOf(WeaponClass, InvClass) && NewKillCount > WeaponKillCounts[I + 1])
        {
            WeaponKillCounts[I + 1] = NewKillCount;            
        }
        else
        {            
        }
    }    
    bAllWeaponsFullyUpgraded = false;
    // End:0x1FC
    foreach WeaponKillCounts(I, J)
    {
        // End:0x1FB
        if(J > 0)
        {
            // End:0x1EC
            if(I >= Class'AdvWeap_Base'.default.KillsRequiredForUpgrade_BonusMagazines)
            {
                bAllWeaponsFullyUpgraded = true;                
            }
            else
            {
                bAllWeaponsFullyUpgraded = false;
                // [Explicit Continue]
                goto J0x1FC;
            }
        }        
    }
    J0x1FC:
    
    // End:0x264
    if(AdvGRI(WorldInfo.GRI).CanWriteStats())
    {
        // End:0x264
        if(bAllWeaponsFullyUpgraded)
        {
            self.ClientUnlockAchievement(43);
        }
    }
    ProfileSettings.SetWeaponLevels(42, WeaponKillCounts);
    //return;    
}

reliable client simulated function SetCTFParticles()
{
    local AdvCTFBasementBase Basement;

    // End:0x39
    foreach AllActors(Class'AdvCTFBasementBase', Basement)
    {
        Basement.SetParticles();        
    }    
    //return;    
}

reliable client simulated function SetOracleParticles(bool bEnabled)
{
    local AdvOracleBase Oracle;

    // End:0x43
    foreach AllActors(Class'AdvOracleBase', Oracle)
    {
        Oracle.SetPArticleActivation(bEnabled);        
    }    
    //return;    
}

simulated function ClientKillByEnemyFireTrap()
{
    EnemyKilledByFireTrap++;
    // End:0x28
    if(EnemyKilledByFireTrap == 5)
    {
        ClientUnlockAchievement(49);
    }
    //return;    
}

reliable client simulated function ReadAndInitWeaponStats(EvilWeap_Base NewWeapon)
{
    local int I;
    local class<Inventory> InvClass;
    local array<int> WeaponKillCounts;

    // End:0x11
    if(NewWeapon == none)
    {
        return;
    }
    // End:0x35
    if(Pawn == none)
    {
        SetTimer(0.1000000, false, 'InitAllWeaponStats');
        return;
    }
    ProfileSettings.GetWeaponLevels(42, WeaponKillCounts);
    // End:0xA1
    if((WeaponKillCounts.Length == 0) || WeaponKillCounts[0] != Class'AdvClassInfo_MP_Base'.default.Version)
    {
        return;
    }
    // End:0x182
    foreach Class'AdvClassInfo_MP_Base'.default.Equipment(InvClass, I)
    {
        // End:0x181
        if(ClassIsChildOf(NewWeapon.Class, InvClass))
        {
            AdvWeap_Base(NewWeapon).KillCount = WeaponKillCounts[I + 1];
            AdvWeap_Base(NewWeapon).InitializeWeaponStats(WeaponKillCounts[I + 1]);            
            return;
        }        
    }    
    //return;    
}

simulated function ReceivedGameClass(class<GameInfo> GameClass)
{
    super(PlayerController).ReceivedGameClass(GameClass);
    UpdateTrapMaterials();
    // End:0xBA
    if(WorldInfo.GRI != none)
    {
        // End:0x9F
        if(AdvGRI(WorldInfo.GRI).bTraps)
        {
            IterateOverFocusHighligths(EnableHighlights);            
        }
        else
        {
            IterateOverFocusHighligths(DisableHighlights);
        }
    }
    //return;    
}

reliable client simulated function NotifyFocusHighlightChanged(Actor A, bool bNewEnabled)
{
    // End:0x89
    if(bNewEnabled)
    {
        // End:0x86
        if((WorldInfo.GRI != none) && AdvGRI(WorldInfo.GRI).bTraps)
        {
            EnableHighlights(A);
        }        
    }
    else
    {
        DisableHighlights(A);
    }
    //return;    
}

reliable client simulated function ClientIterateOverFocusHighlights()
{
    // End:0x9D
    if(WorldInfo.GRI != none)
    {
        // End:0x82
        if(AdvGRI(WorldInfo.GRI).bTraps)
        {
            IterateOverFocusHighligths(EnableHighlights);            
        }
        else
        {
            IterateOverFocusHighligths(DisableHighlights);
        }
    }
    //return;    
}

simulated function UpdateTrapMaterials()
{
    local Sequence GameSeq;
    local array<SequenceObject> ExecutionEvents;
    local SequenceObject ExecutionEvent;
    local SeqEvent_TakeDamage FireEvent;
    local MaterialInstanceConstant MIC1, MIC2;
    local InterpActor TrapActor;

    GameSeq = WorldInfo.GetGameSequence();
    // End:0x376
    if(GameSeq != none)
    {
        GameSeq.FindSeqObjectsByClass(Class'Engine.SeqEvent_TakeDamage', true, ExecutionEvents);
        // End:0x375
        foreach ExecutionEvents(ExecutionEvent)
        {
            FireEvent = SeqEvent_TakeDamage(ExecutionEvent);
            // End:0x374
            if(InterpActor(FireEvent.Originator) != none)
            {
                TrapActor = InterpActor(FireEvent.Originator);
                // End:0x374
                if((TrapActor != none) && TrapActor.StaticMeshComponent != none)
                {
                    // End:0x252
                    if((TrapActor.StaticMeshComponent.GetMaterial(0) != none) && MaterialInstanceConstant(TrapActor.StaticMeshComponent.GetMaterial(0)) != none)
                    {
                        MIC1 = MaterialInstanceConstant(TrapActor.StaticMeshComponent.GetMaterial(0));
                        // End:0x252
                        if(MIC1.Parent == Material'adv_en_multi_levels_02.Materials.m_en_mayan_Base_WallDetail')
                        {
                            MIC1.SetScalarParameterValue('ifShow', 0.0000000);
                        }
                    }
                    // End:0x374
                    if((TrapActor.StaticMeshComponent.GetMaterial(1) != none) && MaterialInstanceConstant(TrapActor.StaticMeshComponent.GetMaterial(1)) != none)
                    {
                        MIC2 = MaterialInstanceConstant(TrapActor.StaticMeshComponent.GetMaterial(1));
                        // End:0x374
                        if(MIC2.Parent == Material'adv_en_multi_levels_02.Materials.m_en_mayan_Base_WallDetail')
                        {
                            MIC2.SetScalarParameterValue('ifShow', 0.0000000);
                        }
                    }
                }
            }            
        }        
    }
    //return;    
}

function InitAllWeaponStats()
{
    local int I;
    local class<Inventory> InvClass;
    local array<int> WeaponKillCounts;
    local AdvWeap_Base NewWeapon;

    // End:0x11
    if(Pawn == none)
    {
        return;
    }
    ProfileSettings.GetWeaponLevels(42, WeaponKillCounts);
    // End:0x7D
    if((WeaponKillCounts.Length == 0) || WeaponKillCounts[0] != Class'AdvClassInfo_MP_Base'.default.Version)
    {
        return;
    }
    // End:0x170
    foreach Class'AdvClassInfo_MP_Base'.default.Equipment(InvClass, I)
    {
        NewWeapon = AdvWeap_Base(AdvPlayerPawnMP(Pawn).FindInventoryType(InvClass, true));
        // End:0x16F
        if(NewWeapon != none)
        {
            NewWeapon.KillCount = WeaponKillCounts[I + 1];
            NewWeapon.InitializeWeaponStats(WeaponKillCounts[I + 1]);
        }        
    }    
    //return;    
}

function OnLoginStatusChange(OnlineSubsystem.ELoginStatus NewStatus, UniqueNetId NewId)
{
    super.OnLoginStatusChange(NewStatus, NewId);
    // End:0x45
    if(int(NewStatus) < int(2))
    {
        ShowOSSConnectionLostMessage();
        ReturnToMainMenu(true);
    }
    // End:0xB1
    if(AdvLocalPlayer(Player) != none)
    {
        AdvLocalPlayer(Player).bIsReturningFromMP = false;
        AdvLocalPlayer(Player).bIsReturningFromSurvival = false;
    }
    //return;    
}

function OnLoginChange(byte LocalUserNum)
{
    local UniqueNetId NetId;
    local Engine Eng;

    Eng = Class'Engine.Engine'.static.GetEngine();
    NetId = PlayerReplicationInfo.UniqueId;
    // End:0x13D
    if(Eng.ForceReturnToISAfterDLCRemoval && CheckIfSomeoneIsLogged())
    {
        super.OnLoginChange(LocalUserNum);
        ShowDLCRemovalError();
        // End:0x10F
        if(NetId != PlayerReplicationInfo.UniqueId && !WorldInfo.IsMenuLevel())
        {
            ProfileSettings = none;
            PersistentData = none;
        }
        Eng.ForceReturnToISAfterDLCRemoval = false;
        ReturnToMainMenu(true);
        return;
    }
    // End:0x190
    if((LocalPlayer(Player) != none) && LocalPlayer(Player).ControllerId != int(LocalUserNum))
    {
        return;
    }
    super.OnLoginChange(LocalUserNum);
    // End:0x213
    if(NetId != PlayerReplicationInfo.UniqueId && !WorldInfo.IsMenuLevel())
    {
        ProfileSettings = none;
        PersistentData = none;
    }
    ShowLoginChangeError();
    ReturnToMainMenu(true);
    // End:0x294
    if(AdvLocalPlayer(Player) != none)
    {
        AdvLocalPlayer(Player).bIsReturningFromMP = false;
        AdvLocalPlayer(Player).bIsReturningFromSurvival = false;
    }
    //return;    
}

simulated function NotifyHostMigrationStarted()
{
    local int PRIIndex;
    local OnlineGameSettings GameSettings;

    OpenReturnToMainMenuCogSpin();
    ClientWriteLeaderboardStats(WorldInfo.GRI.GameClass.default.OnlineStatsWriteClass, true, true);
    // End:0x162
    if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
    {
        GameSettings = OnlineSub.GameInterface.GetGameSettings('Game');
        // End:0x162
        if(GameSettings != none)
        {
            // End:0x162
            if(int(GameSettings.GameState) == int(3))
            {
                OnlineSub.GameInterface.EndOnlineGame('Game');
            }
        }
    }
    CloseReturnToMainMenuCogSpin();
    ClientShowHostMigrationMovie();
    // End:0x19D
    if(GameHostMigrationManager == none)
    {
        GameHostMigrationManager = new Class'AdvGameHostMigrationManager';
    }
    GameHostMigrationManager.AddGameData(AdvGRI(WorldInfo.GRI));
    PRIIndex = 0;
    J0x1EE:

    // End:0x2FB [Loop If]
    if(PRIIndex < WorldInfo.GRI.PRIArray.Length)
    {
        // End:0x2ED
        if(!WorldInfo.GRI.PRIArray[PRIIndex].bBot)
        {
            GameHostMigrationManager.AddPlayerData(AdvPRI(WorldInfo.GRI.PRIArray[PRIIndex]));
        }
        PRIIndex++;
        // [Loop Continue]
        goto J0x1EE;
    }
    //return;    
}

reliable client simulated function ClientShowEndStatisticsScreen()
{
    // End:0x53
    if(!Class'Engine.Engine'.static.IsEditor())
    {
        SetCinematicMode(true, true, true, true, true, true);
        AdvHudWrapper.ShowMPStatsScreen();
    }
    //return;    
}

reliable client simulated function PlayStartupMessage(byte StartupStage)
{
    // End:0x37
    if(int(StartupStage) == int(7))
    {
        ReceiveLocalizedMessage(Class'AdvTimerMessage', 17, PlayerReplicationInfo);        
    }
    else
    {
        ReceiveLocalizedMessage(Class'AdvStartupMessage', int(StartupStage), PlayerReplicationInfo);
    }
    //return;    
}

function SetWallSee()
{
    local Pawn P;

    // End:0x6D
    foreach WorldInfo.AllPawns(Class'Engine.Pawn', P)
    {
        // End:0x59
        if(WallSeeEnabled)
        {
            EnableWallSee(P);
            // End:0x6C
            continue;
        }
        DisableWallSee(P);        
    }    
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x31
    if(VarName == 'SurvivalScoreModifier')
    {
        // End:0x2E
        if(bDisplaySurvivalWaveEndMessage)
        {
            SetSurvivalWaveEndMessage();
        }        
    }
    else
    {
        super.ReplicatedEvent(VarName);
    }
    ServerUpdateWallSee();
    ServerUpdateAIWallSee();
    //return;    
}

reliable server function ServerUpdateWallSee()
{
    local PlayerController PC;

    // End:0x75
    foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
    {
        // End:0x74
        if(AdvPlayerControllerMP(PC) != none)
        {
            AdvPlayerControllerMP(PC).ClientCheckWallSee();
        }        
    }    
    //return;    
}

reliable client simulated function ClientDisableWallSeeFlag()
{
    WallSeeEnabled = false;
    SetWallSee();
    //return;    
}

reliable client simulated function ClientEnableWallSeeFlag()
{
    WallSeeEnabled = true;
    SetWallSee();
    //return;    
}

reliable client simulated function ClientCheckWallSee()
{
    // End:0x17
    if(WallSeeEnabled)
    {
        SetWallSee();
    }
    //return;    
}

function EnableWallSee(Pawn P)
{
    // End:0x6D
    if(P.IsSameTeam(Pawn))
    {
        AdvPlayerPawnMP(P).OccludedMesh.SetSkeletalMesh(none);        
    }
    else
    {
        // End:0x103
        if(P.IsAliveAndWell())
        {
            AdvPlayerPawnMP(P).OccludedMesh.SetSkeletalMesh(P.Mesh.SkeletalMesh);            
        }
        else
        {
            // End:0x166
            if(!P.IsAliveAndWell())
            {
                AdvPlayerPawnMP(P).OccludedMesh.SetSkeletalMesh(none);
            }
        }
    }
    //return;    
}

function DisableWallSee(Pawn P)
{
    // End:0x81
    if(AdvPlayerPawnMP(P).OccludedMesh.SkeletalMesh != none)
    {
        AdvPlayerPawnMP(P).OccludedMesh.SetSkeletalMesh(none);
    }
    //return;    
}

function SetAIWallSee()
{
    local Pawn P;

    // End:0x6D
    foreach WorldInfo.AllPawns(Class'Engine.Pawn', P)
    {
        // End:0x59
        if(WallSeeEnabled)
        {
            EnableAIWallSee(P);
            // End:0x6C
            continue;
        }
        DisableAIWallSee(P);        
    }    
    //return;    
}

reliable server function ServerUpdateAIWallSee()
{
    local AdvPlayerControllerMP PC;

    // End:0x54
    foreach WorldInfo.AllControllers(Class'AdvPlayerControllerMP', PC)
    {
        PC.ClientCheckAIWallSee();        
    }    
    //return;    
}

reliable client simulated function ClientDisableAIWallSeeFlag()
{
    WallSeeEnabled = false;
    SetAIWallSee();
    //return;    
}

reliable client simulated function ClientEnableAIWallSeeFlag()
{
    WallSeeEnabled = true;
    SetAIWallSee();
    //return;    
}

reliable client simulated function ClientCheckAIWallSee()
{
    // End:0x17
    if(WallSeeEnabled)
    {
        SetAIWallSee();
    }
    //return;    
}

function EnableAIWallSee(Pawn P)
{
    // End:0x49
    if((AdvPawn(P) == none) || !AdvPawn(P).bClientSpawnDone)
    {
        return;
    }
    AdvPawn(P).bVisibleThroughWalls = true;
    // End:0x14D
    if(P.IsAliveAndWell() && AdvPawn(P).WallseeMesh.SkeletalMesh == none)
    {
        AdvPawn(P).WallseeMesh.SetSkeletalMesh(P.Mesh.SkeletalMesh);        
    }
    else
    {
        // End:0x1F4
        if(!P.IsAliveAndWell() && AdvPawn(P).WallseeMesh.SkeletalMesh != none)
        {
            AdvPawn(P).WallseeMesh.SetSkeletalMesh(none);
        }
    }
    //return;    
}

function DisableAIWallSee(Pawn P)
{
    // End:0x49
    if((AdvPawn(P) == none) || !AdvPawn(P).bClientSpawnDone)
    {
        return;
    }
    AdvPawn(P).bVisibleThroughWalls = false;
    // End:0x123
    if((AdvPawn(P).WallseeMesh != none) && AdvPawn(P).WallseeMesh.SkeletalMesh != none)
    {
        AdvPawn(P).WallseeMesh.SetSkeletalMesh(none);
    }
    //return;    
}

reliable server function SetReadyStatus()
{
    // End:0xBA
    if((int(Role) == int(ROLE_Authority)) && !AdvPRI(PlayerReplicationInfo).bIsTournamentSpectator)
    {
        // End:0x90
        if(AdvGRI(WorldInfo.GRI).bMatchHasBegun)
        {
            ServerRestartPlayer();            
        }
        else
        {
            AdvPRI(PlayerReplicationInfo).bReadyToPlay = true;
        }
    }
    //return;    
}

function ProcessViewRotation(float DeltaTime, out Rotator out_ViewRotation, Rotator DeltaRot)
{
    // End:0xCC
    if(IsInState('Spectating') && (class<AdvGameSurvivalBase>(WorldInfo.GetGameClass()) != none) || (class<AdvGameLastMenStandingBase>(WorldInfo.GetGameClass()) != none) && bLMSCameraTPPMode)
    {
        out_ViewRotation = RInterpTo(Rotation, ViewTarget.Rotation, DeltaTime, 7.0000000);        
    }
    else
    {
        super(EvilPlayerController).ProcessViewRotation(DeltaTime, out_ViewRotation, DeltaRot);
    }
    //return;    
}

function IncreaseSurvivalScoreModifier()
{
    SurvivalScoreModifier += 1.0000000;
    bForceNetUpdate = true;
    //return;    
}

function ResetSurvivalScoreModifier()
{
    SurvivalScoreModifier = 1.0000000;
    bForceNetUpdate = true;
    //return;    
}

reliable client simulated function SetKillStrikeOnDead()
{
    // End:0x5E
    if(AdvGFxHudWrapper(myHUD) != none)
    {
        AdvGFxHud(AdvGFxHudWrapper(myHUD).HudMovie).PlayKillStreakDeadAnim();
    }
    //return;    
}

reliable client simulated function SetNormalKillStrikeMessage(int KillStrikeIndex, string PerkName, int ActivationMethodValue, SoundCue KillStreakSound)
{
    SetKillStrikeMessage(KillStrikeIndex, Repl(Repl(Class'AdvPerkManager_Base'.default.KillStrikeMessage, "`n", string(ActivationMethodValue)), "`w", PerkName), KillStreakSound);
    //return;    
}

reliable client simulated function SetSurvivalKillStrikeMessage(int KillStrikeIndex, string PerkName, SoundCue KillStreakSound)
{
    SetKillStrikeMessage(KillStrikeIndex, Repl(Class'AdvPerkManager_Base'.default.SurvivalKillStrikeMessage, "`w", PerkName), KillStreakSound);
    //return;    
}

reliable client simulated function AddMainMessage(string Message, optional string IconPath = "", optional SoundCue SoundMesage = none, optional bool bForceReplaceMainMessage = false)
{
    local MainMessage NewMessage;

    NewMessage.Message = Message;
    NewMessage.IconPath = IconPath;
    NewMessage.SoundMessage = SoundMesage;
    // End:0x1C1
    if(bForceReplaceMainMessage)
    {
        HideOldQueueMessages();
        MainMessagesQueue.Remove(0, MainMessagesQueue.Length);        
        // End:0xD1
        if(SoundMesage != none)
        {
            ClientPlaySound(SoundMesage);
        }
        // End:0x142
        if(AdvGFxHudWrapper(myHUD) != none)
        {
            AdvGFxHudMP(AdvGFxHudWrapper(myHUD).HudMovie).SetUpgradeInfoText(Message,, IconPath);
        }
        // End:0x16D
        if(IsTimerActive('DisplayNewQueueMessages'))
        {
            ClearTimer('DisplayNewQueueMessages');
        }
        // End:0x198
        if(IsTimerActive('HideOldQueueMessages'))
        {
            ClearTimer('HideOldQueueMessages');
        }
        SetTimer(3.4000000, false, 'DisplayNewQueueMessages');
        SetTimer(3.1000000, false, 'HideOldQueueMessages');        
    }
    else
    {
        // End:0x1ED
        if(!IsTimerActive('DisplayNewQueueMessages'))
        {
            SetTimer(3.4000000, false, 'DisplayNewQueueMessages');
        }
        // End:0x219
        if(!IsTimerActive('HideOldQueueMessages'))
        {
            SetTimer(3.1000000, false, 'HideOldQueueMessages');
        }
        // End:0x2BF
        if(MainMessagesQueue.Length == 0)
        {
            // End:0x24B
            if(SoundMesage != none)
            {
                ClientPlaySound(SoundMesage);
            }
            // End:0x2BC
            if(AdvGFxHudWrapper(myHUD) != none)
            {
                AdvGFxHudMP(AdvGFxHudWrapper(myHUD).HudMovie).SetUpgradeInfoText(Message,, IconPath);
            }            
        }
        else
        {
            // End:0x339
            if(MainMessagesQueue.Length == 1)
            {
                // End:0x336
                if(AdvGFxHudWrapper(myHUD) != none)
                {
                    AdvGFxHudMP(AdvGFxHudWrapper(myHUD).HudMovie).SetUpgrade2InfoText(Message);
                }                
            }
            else
            {
                // End:0x3B1
                if(MainMessagesQueue.Length == 2)
                {
                    // End:0x3B1
                    if(AdvGFxHudWrapper(myHUD) != none)
                    {
                        AdvGFxHudMP(AdvGFxHudWrapper(myHUD).HudMovie).SetUpgrade3InfoText(Message);
                    }
                }
            }
        }
    }
    MainMessagesQueue.AddItem(NewMessage);    
    //return;    
}

reliable client simulated function DisplayNewQueueMessages()
{
    // End:0x11D
    if(MainMessagesQueue.Length > 0)
    {
        SetTimer(3.4000000, false, 'DisplayNewQueueMessages');
        SetTimer(3.1000000, false, 'HideOldQueueMessages');
        // End:0x82
        if(MainMessagesQueue[0].SoundMessage != none)
        {
            ClientPlaySound(MainMessagesQueue[0].SoundMessage);
        }
        // End:0x11D
        if(AdvGFxHudWrapper(myHUD) != none)
        {
            AdvGFxHudMP(AdvGFxHudWrapper(myHUD).HudMovie).SetUpgradeInfoText(MainMessagesQueue[0].Message,, MainMessagesQueue[0].IconPath);
        }
    }
    // End:0x1A9
    if(MainMessagesQueue.Length > 1)
    {
        // End:0x1A9
        if(AdvGFxHudWrapper(myHUD) != none)
        {
            AdvGFxHudMP(AdvGFxHudWrapper(myHUD).HudMovie).SetUpgrade2InfoText(MainMessagesQueue[1].Message);
        }
    }
    // End:0x237
    if(MainMessagesQueue.Length > 2)
    {
        // End:0x237
        if(AdvGFxHudWrapper(myHUD) != none)
        {
            AdvGFxHudMP(AdvGFxHudWrapper(myHUD).HudMovie).SetUpgrade3InfoText(MainMessagesQueue[2].Message);
        }
    }
    //return;    
}

reliable client simulated function HideOldQueueMessages()
{
    // End:0x6E
    if(MainMessagesQueue.Length > 1)
    {
        // End:0x6E
        if(AdvGFxHudWrapper(myHUD) != none)
        {
            AdvGFxHudMP(AdvGFxHudWrapper(myHUD).HudMovie).HideUpgrades2InfoText();
        }
    }
    // End:0xDD
    if(MainMessagesQueue.Length > 2)
    {
        // End:0xDD
        if(AdvGFxHudWrapper(myHUD) != none)
        {
            AdvGFxHudMP(AdvGFxHudWrapper(myHUD).HudMovie).HideUpgrades3InfoText();
        }
    }
    // End:0xFA
    if(MainMessagesQueue.Length > 0)
    {
        MainMessagesQueue.Remove(0, 1);        
    }
    //return;    
}

reliable client simulated function SetKillStrikeMessage(int KillStrikeIndex, string Message, SoundCue KillStreakSound)
{
    AddMainMessage(Message,, KillStreakSound);
    PlayKillStreakActiveAnim(KillStrikeIndex);
    //return;    
}

reliable client simulated function PlayKillStreakActiveAnim(int KillStrikeIndex)
{
    // End:0x67
    if(AdvGFxHudWrapper(myHUD) != none)
    {
        AdvGFxHud(AdvGFxHudWrapper(myHUD).HudMovie).PlayKillStreakActiveAnim(KillStrikeIndex);
    }
    //return;    
}

reliable client simulated function SetKillStrikeUseMessage(int KillStrikeIndex, string Message)
{
    // End:0x67
    if(AdvGFxHudWrapper(myHUD) != none)
    {
        AdvGFxHud(AdvGFxHudWrapper(myHUD).HudMovie).PlayKillStreakUseAnim(KillStrikeIndex);
    }
    //return;    
}

reliable client simulated function ResetKillStrikesOnHud(int perkscount)
{
    local int I;

    // End:0xDE
    if(AdvGFxHudWrapper(myHUD) != none)
    {
        AdvGFxHud(AdvGFxHudWrapper(myHUD).HudMovie).SetKillStreakKillCount(0);
        I = 0;
        J0x6A:

        // End:0xDE [Loop If]
        if(I < perkscount)
        {
            AdvGFxHud(AdvGFxHudWrapper(myHUD).HudMovie).PlayKillStreakInactiveAnim(I);
            I++;
            // [Loop Continue]
            goto J0x6A;
        }
    }
    //return;    
}

reliable client simulated function PrepareSurvivalWaveEndMessage()
{
    // End:0x38
    if(int(WorldInfo.NetMode) == int(NM_Client))
    {
        bDisplaySurvivalWaveEndMessage = true;        
    }
    else
    {
        SetSurvivalWaveEndMessage();
    }
    //return;    
}

reliable client simulated function SetSurvivalWaveEndMessage()
{
    bDisplaySurvivalWaveEndMessage = false;
    AddMainMessage(Repl(EndSurvivalWaveMessage, "`s", string(int(SurvivalScoreModifier))));
    //return;    
}

reliable client simulated function SetClassChangedMessage()
{
    // End:0x2B
    if(AdvGFxHudWrapper(myHUD) != none)
    {
        SetTimer(0.8000000, false, 'ShowClassChangedMessage');
    }
    //return;    
}

reliable client simulated function ShowClassChangedMessage()
{
    // End:0x69
    if(AdvGFxHudWrapper(myHUD) != none)
    {
        AdvGFxHudMP(AdvGFxHudWrapper(myHUD).HudMovie).SetCenterMessageText(ClassChangedMessage);
    }
    //return;    
}

reliable client simulated function SetCountDownMessage(string Message, optional SoundCue CountDownSound = none)
{
    AddMainMessage(Message,, CountDownSound, true);
    //return;    
}

reliable client simulated function SetSurvivalCountDownMessage(optional bool bOnlyHide = false, optional int CountDown)
{
    // End:0xEA
    if(AdvGFxHudWrapper(myHUD) != none)
    {
        AdvGFxHudMP(AdvGFxHudWrapper(myHUD).HudMovie).HideTutorialMessage();
        // End:0xEA
        if(!bOnlyHide)
        {
            AdvGFxHudMP(AdvGFxHudWrapper(myHUD).HudMovie).ShowTutorialMessage(Repl(Class'AdvGameSurvivalBase'.default.CountDownMsg, "`t", string(CountDown)));
        }
    }
    //return;    
}

reliable client simulated function SetAnnouncerMessage(string Message, SoundCue AnnouncerSound, optional bool bForceReplaceMainMessage = false)
{
    AddMainMessage(Message,, AnnouncerSound, bForceReplaceMainMessage);
    //return;    
}

reliable client simulated function SetSecondaryAnnouncerMessage(string Message)
{
    // End:0x71
    if(AdvGFxHudWrapper(myHUD) != none)
    {
        AdvGFxHudMP(AdvGFxHudWrapper(myHUD).HudMovie).AddMessage("htmlText", Message);
    }
    //return;    
}

reliable client simulated function SetFirstBloodMessage()
{
    AddMainMessage(Class'AdvGameMP_Base'.default.FirstBloodMsg);
    //return;    
}

reliable client simulated function SetLevelUpMessage(int NewLevel)
{
    local string IconPath;

    // End:0x9F
    if(AdvGFxHudWrapper(myHUD) != none)
    {
        IconPath = Class'AdvClassInfo_MP_Base'.default.RankIconPath[NewLevel - 1];
        AddMainMessage(((Class'AdvPlayerController'.default.LevelUpMsg @ "[") $ string(NewLevel)) $ "]", IconPath, LevelUpSound);
    }
    //return;    
}

reliable client simulated function SetCTFMessage(string Message)
{
    AddMainMessage(Message);
    //return;    
}

reliable client simulated function SetRescueMessage(optional bool bHide = false)
{
    local string Message;

    // End:0x13F
    if((AdvGFxHudWrapper(myHUD) != none) && !bHide)
    {
        // End:0x7D
        if(WorldInfo.IsConsoleBuild(1))
        {
            Message = Class'AdvPlayerPawnMP'.default.LastMenStandingMessageXbox;            
        }
        else
        {
            Message = Class'AdvPlayerPawnMP'.default.LastMenStandingMessage;
        }
        AdvGFxHudMP(AdvGFxHudWrapper(myHUD).HudMovie).ShowTutorialMessage(AdvGFxHudMP(AdvGFxHudWrapper(myHUD).HudMovie).ParseString(Message, self), true);        
    }
    else
    {
        // End:0x192
        if(bHide)
        {
            AdvGFxHudMP(AdvGFxHudWrapper(myHUD).HudMovie).HideTutorialMessage();
        }
    }
    myHUD.bForceNetUpdate = true;
    //return;    
}

reliable client simulated function SetWeaponUpgradeMessage(string Message, string IconPath)
{
    AddMainMessage(Repl(Class'AdvWeap_Base'.default.WeaponUpgradeMessage, "`w", Message), IconPath, UpgradeSound);
    //return;    
}

reliable client simulated function SetNotEnoughBlessingMessage(int BlessingCost)
{
    SetBlessingMessage(Repl(Localize("AdvBlessings", "NotEnoughTreasuresMessage", "ADVGame"), "`t", string(BlessingCost)));
    //return;    
}

reliable client simulated function SetBlessingMessage(string Message, optional class<AdvBlessing_Base> Blessing = none)
{
    local string BlessingIconPath;

    // End:0xF9
    if((class<AdvGameTreasureHuntBase>(WorldInfo.GRI.GameClass) != none) || class<AdvGameTeamTreasureHuntBase>(WorldInfo.GRI.GameClass) != none)
    {
        // End:0xE3
        if(Blessing != none)
        {
            BlessingIconPath = Blessing.default.BlessingActivationIconPath;
            AddMainMessage(Message, BlessingIconPath);            
        }
        else
        {
            AddMainMessage(Message);
        }
    }
    //return;    
}

function AddBlessing(AdvBlessing_Base NewBlessing)
{
    local class<AdvBlessing_Base> BlessingClass;
    local int BlessingIndex;

    ActiveBlessings.AddItem(NewBlessing);    
    NewBlessing.SetOwningPlayer(self);
    // End:0x9A
    foreach Class'AdvBlessingManager'.default.AllBlessings(BlessingClass, BlessingIndex)
    {
        // End:0x99
        if(BlessingClass == NewBlessing.Class)
        {            
        }
        else
        {            
        }
    }    
    AdvPRI(PlayerReplicationInfo).ActiveBlessings[BlessingIndex] = 1;
    //return;    
}

function RemoveBlessing(AdvBlessing_Base BlessingToRemove)
{
    local class<AdvBlessing_Base> BlessingClass;
    local int BlessingIndex;

    ActiveBlessings.RemoveItem(BlessingToRemove);    
    BlessingIndex = 0;
    // End:0x88
    foreach Class'AdvBlessingManager'.default.AllBlessings(BlessingClass)
    {
        // End:0x7C
        if(BlessingClass == BlessingToRemove.Class)
        {            
        }
        else
        {
            BlessingIndex++;            
        }
    }    
    AdvPRI(PlayerReplicationInfo).ActiveBlessings[BlessingIndex] = 0;
    //return;    
}

event PlayerTick(float DeltaTime)
{
    super.PlayerTick(DeltaTime);
    // End:0x203
    if((((Pawn != none) && Pawn.Weapon != none) && EvilWeap_Base(Pawn.Weapon).MovementSpeedModifier > float(1)) && AdvPlayerPawnMP(Pawn).Bob != float(0))
    {
        AdvPlayerPawnMP(Pawn).Bob = AdvPlayerPawnMP(Pawn).default.Bob / EvilWeap_Base(Pawn.Weapon).MovementSpeedModifier;
        EvilWeap_Base(Pawn.Weapon).BobDamping = EvilWeap_Base(Pawn.Weapon).default.BobDamping / EvilWeap_Base(Pawn.Weapon).MovementSpeedModifier;
    }
    //return;    
}

function ServerStartWoundedSequence()
{
    // End:0x47
    if(AdvGameSurvivalBase(WorldInfo.Game) != none)
    {
        SetTimer(TimeToRescueSurvival, false, 'ForceKillDuringWounded');        
    }
    else
    {
        SetTimer(TimeToRescueLMS, false, 'ForceKillDuringWounded');
    }
    SetTimer(1.0000000, false, 'SetCanBeRescued');
    AdvPlayerPawnMP(Pawn).ServerDoPawnAction(38, true);
    //return;    
}

reliable client simulated function ClientStartRescueSequence(AdvPlayerPawnMP P)
{
    P.DoPawnAction(39, true);
    //return;    
}

function SetCanBeRescued()
{
    bCanBeRescued = true;
    AdvPRI(PlayerReplicationInfo).bCanBeRescued = true;
    //return;    
}

exec function DebugLMS()
{
    Pawn.Died(none, Class'Engine.DamageType', self.Location);
    //return;    
}

function ForceKillDuringWounded()
{
    // End:0x7A
    if(AdvGameSurvivalBase(WorldInfo.Game) != none)
    {
        // End:0x60
        if(RescueTime <= float(0))
        {
            MyAdvPlayerPawnMP.ForceKillPawn();            
        }
        else
        {
            SetTimer(RescueTime, false, 'ForceKillDuringWounded');
        }        
    }
    else
    {
        // End:0xF4
        if(AdvGameLastMenStandingBase(WorldInfo.Game) != none)
        {
            // End:0xDA
            if(RescueTime <= float(0))
            {
                MyAdvPlayerPawnMP.ForceKillPawn();                
            }
            else
            {
                SetTimer(RescueTime, false, 'ForceKillDuringWounded');
            }            
        }
        else
        {
            MyAdvPlayerPawnMP.ForceKillPawn();
        }
    }
    //return;    
}

function FinishRescue()
{
    ServerGoToState('PlayerWalking');
    //return;    
}

exec function DynamiteThrow()
{
    // End:0x2E
    if(!MyAdvPlayerPawnMP.bIsMummy)
    {
        super(EvilPlayerController).DynamiteThrow();
    }
    //return;    
}

exec function GrenadeThrow()
{
    // End:0x2E
    if(!MyAdvPlayerPawnMP.bIsMummy)
    {
        super(EvilPlayerController).GrenadeThrow();
    }
    //return;    
}

exec function GrenadeRelease()
{
    // End:0x2E
    if(!MyAdvPlayerPawnMP.bIsMummy)
    {
        super(EvilPlayerController).GrenadeRelease();
    }
    //return;    
}

exec function DynamiteRelease()
{
    // End:0x2E
    if(!MyAdvPlayerPawnMP.bIsMummy)
    {
        super(EvilPlayerController).DynamiteRelease();
    }
    //return;    
}

reliable client simulated function ClientSetHealHudIcon(Actor Target, bool Enable)
{
    // End:0x65
    if(Enable)
    {
        AdvGFxHud(AdvGFxHudWrapper(myHUD).HudMovie).AddObjectiveIcon(Target, "heal");        
    }
    else
    {
        AdvGFxHud(AdvGFxHudWrapper(myHUD).HudMovie).DeleteObjectiveIcon(Target);
    }
    //return;    
}

simulated function UpdateHealHudIcon()
{
    local AdvPlayerPawnMP Pmp;

    // End:0x60
    if((class<AdvGameSurvivalBase>(WorldInfo.GetGameClass()) == none) && class<AdvGameLastMenStandingBase>(WorldInfo.GetGameClass()) == none)
    {
        return;
    }
    // End:0xFA
    foreach WorldInfo.AllPawns(Class'AdvPlayerPawnMP', Pmp)
    {
        // End:0xF9
        if(Pmp.IsSameTeam(Pawn) && Pmp.bIsWounded)
        {
            ClientSetHealHudIcon(Pmp, true);
        }        
    }    
    //return;    
}

exec function IncreaseKillStrikeScore()
{
    ServerIncreaseKillStrikeScore();
    //return;    
}

reliable server function ServerIncreaseKillStrikeScore()
{
    // End:0x86
    if(AdvGameSurvivalBase(WorldInfo.Game) != none)
    {
        AdvGameMP_Base(WorldInfo.Game).PerkManager.IncreaseKillStrikeScore(1, self);        
    }
    else
    {
        AdvGameMP_Base(WorldInfo.Game).PerkManager.IncreaseKillStrikeScore(0, self);
    }
    //return;    
}

function bool IsThereOtherReasonToLetUseHold()
{
    local array<AdvPlayerPawnMP> PawnsInRange;

    // End:0x2C
    if(CanRescueSomeone(PawnsInRange, IsThisPawnInUsableAngle))
    {
        return true;        
    }
    else
    {
        // End:0xB3
        if(((class<AdvGameLastMenStandingBase>(WorldInfo.GetGameClass()) != none) || class<AdvGameSurvivalBase>(WorldInfo.GetGameClass()) != none) && MyAdvPlayerPawnMP.bIsTouchingLMSPawn)
        {
            return true;            
        }
        else
        {
            return super.IsThereOtherReasonToLetUseHold();
        }
    }
    //return ReturnValue;    
}

function SetDisableMovement(bool bDisabled)
{
    IgnoreMoveInput(bDisabled);
    PlayerInput.ResetInput();
    MyAdvPlayerPawnMP.ZeroMovementVariables();
    ClientSetDisableMovement(bDisabled);
    //return;    
}

reliable client simulated function ClientSetDisableMovement(bool bDisabled)
{
    IgnoreMoveInput(bDisabled);
    PlayerInput.ResetInput();
    MyAdvPlayerPawnMP.ZeroMovementVariables();
    //return;    
}

delegate bool IsPawnInUsableAngle(AdvPlayerPawnMP P, float AngleDegrees)
{
    //return ReturnValue;    
}

simulated function bool IsThisPawnInUsableAngle(AdvPlayerPawnMP P, float AngleDegrees)
{
    local Vector ViewDir, PawnLoc, OtherLoc;
    local float ComputedDot;

    ViewDir = Vector(Rotation) * vect(1.0000000, 1.0000000, 0.0000000);
    PawnLoc = Pawn.Location * vect(1.0000000, 1.0000000, 0.0000000);
    OtherLoc = P.Location * vect(1.0000000, 1.0000000, 0.0000000);
    ComputedDot = Normal(OtherLoc - PawnLoc) Dot Normal(ViewDir);
    return Acos(ComputedDot) < (AngleDegrees * 0.0174533);
    //return ReturnValue;    
}

simulated function bool CanRescueSomeone(out array<AdvPlayerPawnMP> PawnsInRange, delegate<IsPawnInUsableAngle> Callback)
{
    local AdvPlayerPawnMP P;
    local bool bResult;

    // End:0x1BF
    if((class<AdvGameLastMenStandingBase>(WorldInfo.GetGameClass()) != none) || class<AdvGameSurvivalBase>(WorldInfo.GetGameClass()) != none)
    {
        // End:0x1BF
        if(!IsInState('Wounded') && !IsInState('SurvivalWounded'))
        {
            // End:0x1BE
            foreach MyAdvPlayerPawnMP.CollidingActors(Class'AdvPlayerPawnMP', P, 125.0000000)
            {
                // End:0x1BD
                if((((((P != none) && P != Pawn) && IsPawnInUsableAngle(P, 75.0000000)) && P.IsSameTeam(Pawn)) && AdvPRI(P.PlayerReplicationInfo).bCanBeRescued) && P.bIsWounded)
                {
                    PawnsInRange.AddItem(P);                    
                    bResult = true;
                }                
            }            
        }
    }
    return bResult;
    //return ReturnValue;    
}

reliable server function ServerSetRescueMessage(AdvPlayerPawnMP P, bool bHide)
{
    P.bIsTouchingLMSPawn = !bHide;
    // End:0xE3
    if(P.Controller.IsInState('Wounded') || P.Controller.IsInState('SurvivalWounded'))
    {
        AdvPlayerControllerMP(P.Controller).SetRescueMessage(true);        
    }
    else
    {
        AdvPlayerControllerMP(P.Controller).SetRescueMessage(bHide);
    }
    //return;    
}

reliable server function ServerPreventDeath()
{
    //return;    
}

simulated function WoundedTimer()
{
    //return;    
}

function PlayWoundedSound()
{
    local AdvPlayerControllerMP PC;

    // End:0xAF
    foreach WorldInfo.AllControllers(Class'AdvPlayerControllerMP', PC)
    {
        // End:0xAE
        if(WorldInfo.GRI.OnSameTeam(self, PC) && PC != self)
        {
            PC.ClientPlayWoundedSound(MyAdvPlayerPawnMP);
        }        
    }    
    //return;    
}

reliable server function ServerStartSecondChanceSequence()
{
    SetTimer(SecondChanceBlessingTime, false, 'ServerFinishSecondChanceSequence');
    AdvPlayerPawnMP(Pawn).ServerDoPawnAction(38, true);
    //return;    
}

reliable server function ServerFinishSecondChanceSequence()
{
    local AdvBlessing_Base Blessing;

    // End:0x52
    foreach ActiveBlessings(Blessing)
    {
        // End:0x51
        if(AdvBlessing_SecondChance(Blessing) != none)
        {
            Blessing.Deactivate();            
        }
        else
        {            
        }
    }    
    AdvPlayerPawnMP(Pawn).ServerDoPawnAction(39, true);
    GotoState('PlayerWalking');
    //return;    
}

simulated function WriteSomeStatsToProfile()
{
    // End:0x9A
    if(class<AdvGameSurvivalBase>(WorldInfo.GetGameClass()) != none)
    {
        IncrementGlobalIntStat(137, WorldInfo.GRI.ElapsedTime - AdvPRI(PlayerReplicationInfo).StartTime);        
    }
    else
    {
        IncrementGlobalIntStat(152, WorldInfo.GRI.ElapsedTime - AdvPRI(PlayerReplicationInfo).StartTime);
    }
    // End:0x161
    if(class<AdvGameCTFBase>(WorldInfo.GetGameClass()) != none)
    {
        IncrementGlobalIntStat(127, int(PlayerReplicationInfo.Score));        
    }
    else
    {
        // End:0x1BF
        if(class<AdvGameTeamTreasureHuntBase>(WorldInfo.GetGameClass()) != none)
        {
            IncrementGlobalIntStat(130, int(PlayerReplicationInfo.Score));            
        }
        else
        {
            // End:0x21D
            if(class<AdvGameLastMenStandingBase>(WorldInfo.GetGameClass()) != none)
            {
                IncrementGlobalIntStat(128, int(PlayerReplicationInfo.Score));                
            }
            else
            {
                // End:0x27B
                if(class<AdvGameTeamDeathmatchBase>(WorldInfo.GetGameClass()) != none)
                {
                    IncrementGlobalIntStat(126, int(PlayerReplicationInfo.Score));                    
                }
                else
                {
                    // End:0x2D9
                    if(class<AdvGameTreasureHuntBase>(WorldInfo.GetGameClass()) != none)
                    {
                        IncrementGlobalIntStat(129, int(PlayerReplicationInfo.Score));                        
                    }
                    else
                    {
                        // End:0x337
                        if(class<AdvGameDeathmatchBase>(WorldInfo.GetGameClass()) != none)
                        {
                            IncrementGlobalIntStat(125, int(PlayerReplicationInfo.Score));                            
                        }
                        else
                        {
                            // End:0x392
                            if(class<AdvGameSurvivalBase>(WorldInfo.GetGameClass()) != none)
                            {
                                IncrementGlobalIntStat(138, int(PlayerReplicationInfo.Score));
                            }
                        }
                    }
                }
            }
        }
    }
    //return;    
}

reliable client simulated function ClientWriteLeaderboardStats(class<OnlineStatsWrite> OnlineStatsWriteClass, optional bool bIsIncomplete = false, optional bool bMigrating = false)
{
    super.ClientWriteLeaderboardStats(OnlineStatsWriteClass, bIsIncomplete, bMigrating);
    // End:0x7B
    if(AdvGRI(WorldInfo.GRI).CanWriteStats())
    {
        WriteSomeStatsToProfile();
    }
    //return;    
}

function StopObservePawn(Pawn KilledPawn)
{
    // End:0x2A
    if(ViewTarget == KilledPawn)
    {
        SetTimer(5.0000000, false, 'ServerViewNextPlayer');
    }
    //return;    
}

reliable server function ServerRescuePawn(AdvPlayerPawnMP P)
{
    local AdvPlayerControllerMP PC;
    local AdvPRI PRI;

    PC = AdvPlayerControllerMP(P.Controller);
    // End:0xBA
    if(((PC == none) || !PC.IsInState('Wounded_Base') && !PC.IsInState('SurvivalWounded')) || !PC.bCanBeRescued)
    {
        return;
    }
    // End:0x138
    if(AdvGRI(WorldInfo.GRI).CanWriteStats() && class<AdvGameSurvivalBase>(WorldInfo.GetGameClass()) == none)
    {
        IncrementGlobalIntStat(121);
    }
    PC.ClearTimer('ForceKillDuringWounded');
    PC.bCanBeRescued = false;
    P.bIsWounded = false;
    AdvPRI(PC.PlayerReplicationInfo).bCanBeRescued = false;
    P.bInitialPlayWoundedAnimation = false;
    P.bForceNetUpdate = true;
    P.ServerDoPawnAction(39, true);
    PRI = AdvPRI(PlayerReplicationInfo);
    // End:0x294
    if(PRI != none)
    {
        PRI.RescuesCount++;
    }
    //return;    
}

exec function Use()
{
    super(UTPlayerController).Use();
    ServerRescue();
    //return;    
}

reliable server function ServerRescue()
{
    local AdvPlayerPawnMP P;
    local array<AdvPlayerPawnMP> PawnsInRange;

    // End:0x53
    if(CanRescueSomeone(PawnsInRange, IsThisPawnInUsableAngle))
    {
        // End:0x52
        foreach PawnsInRange(P)
        {
            ServerRescuePawn(P);            
        }        
    }
    //return;    
}

simulated function TransformInMummy(optional bool bSetCharClassInfo, optional bool bTransformInPlayer = false)
{
    local AdvPRI PRI;
    local int I;

    // End:0x59
    if(bSetCharClassInfo)
    {
        SetCurrentCharClassInfo(AdvGRI(WorldInfo.GRI).MummyCharClassInfo);
    }
    // End:0x26F
    if(!MyAdvPlayerPawnMP.bIsMummy)
    {
        J0x7D:

        // End:0xF1 [Loop If]
        if(ActiveBlessings.Length > I)
        {
            // End:0xC5
            if(AdvBlessing_Mummy(ActiveBlessings[I]) != none)
            {
                I++;                
            }
            else
            {
                ActiveBlessings[I].Deactivate();
            }
            // [Loop Continue]
            goto J0x7D;
        }
        PRI = AdvPRI(PlayerReplicationInfo);
        // End:0x198
        if(PRI != none)
        {
            PRI.MummyCharClassInfo = AdvGRI(WorldInfo.GRI).MummyCharClassInfo;
            PRI.bForceNetUpdate = true;
        }
        MyAdvPlayerPawnMP.bIsDevastator = false;
        AdvPRI(PlayerReplicationInfo).bIsDevastator = false;
        MyAdvPlayerPawnMP.bIsMummy = true;
        AdvPRI(PlayerReplicationInfo).bIsMummy = true;
        MyAdvPlayerPawnMP.bForceNetUpdate = true;
        MyAdvPlayerPawnMP.TransformToMummy(true);
    }
    // End:0x295
    if(bTransformInPlayer)
    {
        SetTimer(float(SurvivalMummyModeTime), false, 'TransformInPlayer');
    }
    //return;    
}

simulated function TransformInPlayer()
{
    local EvilWeap_Base W, tempW;
    local int PistolAmmoTemp;
    local AdvInventoryManager InvManager;
    local class<AdvWeap_Base> WeapClass;

    MyAdvPlayerPawnMP.bUseJumpStamina = MyAdvPlayerPawnMP.default.bUseJumpStamina;
    MyAdvPlayerPawnMP.bUseStamina = MyAdvPlayerPawnMP.default.bUseStamina;
    MyAdvPlayerPawnMP.JumpZ = MyAdvPlayerPawnMP.default.JumpZ;
    MyAdvPlayerPawnMP.Health = int(MyAdvPlayerPawnMP.DefaultHealth);
    MyAdvPlayerPawnMP.GroundSpeed = MyAdvPlayerPawnMP.default.GroundSpeed;
    MyAdvPlayerPawnMP.AutoRecoveryHealthDivider = MyAdvPlayerPawnMP.default.AutoRecoveryHealthDivider;
    MyAdvPlayerPawnMP.AbsoluteDamageReductionFactor = MyAdvPlayerPawnMP.default.AbsoluteDamageReductionFactor;
    // End:0x668
    if(MyAdvPlayerPawnMP.bIsMummy)
    {
        InvManager = AdvInventoryManager(MyAdvPlayerPawnMP.InvManager);
        // End:0x267
        if(WorldInfo.Game != none)
        {
            AdvGameMP_Base(WorldInfo.Game).UpdateMummyMusic(true);
        }
        // End:0x2C4
        foreach InvManager.InventoryActors(Class'EvilGame.EvilWeap_Base', W)
        {
            InvManager.RemoveFromInventory(W);            
        }        
        // End:0x3F9
        foreach MyAdvPlayerPawnMP.OldWeapons(W)
        {
            // End:0x388
            if(W.BothHandWeapon || !W.BothHandWeapon && !W.UsesOffhand)
            {
                InvManager.AddInventory(W, true);
            }
            // End:0x3F8
            if(!W.BothHandWeapon && W.UsesOffhand)
            {
                PistolAmmoTemp = W.AmmoCount;
            }            
        }        
        // End:0x4BB
        if(AdvGRI(WorldInfo.GRI).IsSurvivalGame())
        {
            WeapClass = class<AdvWeap_Base>(FindObject("AdvGame.AdvInventoryItem_Torch", Class'Core.Class'));
            // End:0x4BB
            if(WeapClass != none)
            {
                InvManager.CreateInventory(WeapClass, true);                
            }
        }
        SetCurrentCharClassInfo(OldPlayerClass);
        MyAdvPlayerPawnMP.TransformToMummy(false);
        MyAdvPlayerPawnMP.bIsMummy = false;
        AdvPRI(PlayerReplicationInfo).bIsMummy = false;
        W = EvilWeap_Base(InvManager.GetBestWeapon());
        // End:0x5B2
        if(W == none)
        {
            W = EvilWeap_Base(InvManager.GetBestWeapon(false, false, true));
        }
        // End:0x5C1
        if(W == none)
        {
        }
        MyAdvPlayerPawnMP.SetCurrentWeaponClass(W.Class, true);
        // End:0x668
        if(!W.BothHandWeapon && W.OffHandWeaponClass != none)
        {
            InvManager.ClientTryChangeWeapon();
        }
    }
    // End:0x99D
    if(MyAdvPlayerPawnMP.bIsDevastator)
    {
        InvManager = AdvInventoryManager(MyAdvPlayerPawnMP.InvManager);
        // End:0x718
        foreach InvManager.InventoryActors(Class'EvilGame.EvilWeap_Base', W)
        {
            InvManager.RemoveFromInventory(W);            
        }        
        // End:0x7FD
        foreach MyAdvPlayerPawnMP.OldWeapons(W)
        {
            // End:0x7D3
            if((!W.BothHandWeapon && W.UsesOffhand) && !isInventory(W))
            {
                PistolAmmoTemp = W.AmmoCount;
                continue;                
            }
            else
            {
                InvManager.AddInventory(W, true);                
            }
        }        
        // End:0x8BF
        if(AdvGRI(WorldInfo.GRI).IsSurvivalGame())
        {
            WeapClass = class<AdvWeap_Base>(FindObject("AdvGame.AdvInventoryItem_Torch", Class'Core.Class'));
            // End:0x8BF
            if(WeapClass != none)
            {
                InvManager.CreateInventory(WeapClass, true);                
            }
        }
        W = EvilWeap_Base(InvManager.GetBestWeapon(false, false, true));
        MyAdvPlayerPawnMP.SetCurrentWeaponClass(W.Class);
        MyAdvPlayerPawnMP.TransformToDevastator(false);
        MyAdvPlayerPawnMP.bIsDevastator = false;
        AdvPRI(PlayerReplicationInfo).bIsDevastator = false;
    }
    // End:0xB8E
    if(AdvGRI(WorldInfo.GRI).IsSurvivalGame())
    {
        // End:0xB8D
        foreach MyAdvPlayerPawnMP.OldWeapons(W)
        {
            // End:0xB8C
            if(!W.BothHandWeapon && W.UsesOffhand)
            {
                tempW = EvilWeap_Base(MyAdvPlayerPawnMP.FindInventoryType(W.Class, true));
                // End:0xB8C
                if(tempW != none)
                {
                    tempW.Unloaded();
                    tempW.MagazineAmmoCount = ((PistolAmmoTemp > tempW.MagazineMaxAmmoCount) ? tempW.MagazineMaxAmmoCount : PistolAmmoTemp);
                    InvManager.AddAmmoToWeapon(0, PistolAmmoTemp, tempW.Class);
                }
            }            
        }        
    }
    MyAdvPlayerPawnMP.OldWeapons.Length = 0;
    MyAdvPlayerPawnMP.bForceNetUpdate = true;
    //return;    
}

simulated function TransformInDevastator(optional bool bTransformInPlayer = false)
{
    local AdvPRI PRI;

    PRI = AdvPRI(PlayerReplicationInfo);
    // End:0xAD
    if(PRI != none)
    {
        PRI.DevastatorCharClassInfo = AdvGameMP_Base(WorldInfo.Game).GetDevastatorCharClassInfo();
        PRI.bForceNetUpdate = true;
    }
    MyAdvPlayerPawnMP.TransformToDevastator(true);
    MyAdvPlayerPawnMP.bIsDevastator = true;
    AdvPRI(PlayerReplicationInfo).bIsDevastator = true;
    MyAdvPlayerPawnMP.bForceNetUpdate = true;
    Pawn.GroundSpeed *= 0.8000000;
    AdvPlayerPawnMP(Pawn).AutoRecoveryHealthDivider = 17;
    AdvPlayerPawnMP(Pawn).AbsoluteDamageReductionFactor = 0.5000000;
    // End:0x1DB
    if(bTransformInPlayer)
    {
        SetTimer(float(SurvivalDevastatorModeTime), false, 'TransformInPlayer');
    }
    //return;    
}

simulated function class<EvilFamilyInfoBase> GetCurrentCharClassInfo()
{
    return AdvPRI(PlayerReplicationInfo).GetCharClassInfo();
    //return ReturnValue;    
}

simulated function SetCurrentCharClassInfo(class<EvilFamilyInfoBase> NewClass)
{
    // End:0x73
    if(NewClass != none)
    {
        SaveCurrentCharClassInfo();
        AdvPRI(PlayerReplicationInfo).SetCharClassInfo(NewClass);
        MyAdvPlayerPawnMP.SetCharacterClassFromInfo(NewClass);
    }
    //return;    
}

simulated function SaveCurrentCharClassInfo()
{
    local class<AdvFamilyInfo_MP_Hero_Base> CurrCharClass;

    CurrCharClass = class<AdvFamilyInfo_MP_Hero_Base>(GetCurrentCharClassInfo());
    // End:0x5D
    if(CurrCharClass.default.SkinType != "Special")
    {
        OldPlayerClass = GetCurrentCharClassInfo();
    }
    //return;    
}

function ProcessGameOver()
{
    local AdvPlayerController PC;

    // End:0x54
    foreach WorldInfo.AllControllers(Class'AdvPlayerController', PC)
    {
        PC.ClientGameOver();        
    }    
    //return;    
}

reliable client simulated event ClientGameOver()
{
    ClearTimer('ProcessGameOver');
    // End:0x42
    if(AdvHudWrapper != none)
    {
        AdvHudWrapper.ShowGameOverMenu();
    }
    //return;    
}

reliable client simulated function ClosePauseMenu()
{
    AdvHudWrapper.UnPauseGame();
    //return;    
}

reliable client simulated function SetFinisherInfo(int KillScore, optional bool bTrapKill = false, optional int TrapBonusScore = 0)
{
    SetKillInfoMsg(Class'AdvGameMP_Base'.default.FinisherStr, KillScore, bTrapKill, TrapBonusScore);
    //return;    
}

reliable client simulated function SetAssistInfo(int KillScore, optional bool bTrapKill = false, optional int TrapBonusScore = 0)
{
    SetKillInfoMsg(Class'AdvGameMP_Base'.default.AssistStr, KillScore, bTrapKill, TrapBonusScore);
    //return;    
}

reliable client simulated function SetFlawlessInfo(int KillScore, optional bool bTrapKill = false, optional int TrapBonusScore = 0)
{
    SetKillInfoMsg(Class'AdvGameMP_Base'.default.FlawlessKillStr, KillScore, bTrapKill, TrapBonusScore);
    //return;    
}

reliable client simulated function SetKillInfoMsg(string KillText, int KillScore, optional bool bTrapKill = false, optional int TrapBonusScore = 0)
{
    local string KillString, TrapString;

    // End:0x1CD
    if(myHUD != none)
    {
        // End:0x3C
        if(bKillInfoTextDisplaying)
        {
            KillString = ComboKillMsg;            
        }
        else
        {
            bKillInfoTextDisplaying = true;
            KillString = KillText;
        }
        CurrentKillInfoScore += KillScore;
        CurrentKillInfoTrapScore += TrapBonusScore;
        // End:0xBD
        if(KillScore != 0)
        {            
            KillString @= (("(+" $ string(CurrentKillInfoScore)) $ ")");
        }
        // End:0x126
        if(bTrapKill)
        {
            bTrapInfoTextDisplaying = true;
            TrapString = BonusTrapKillMsg;
            // End:0x123
            if(TrapBonusScore != 0)
            {                
                TrapString @= (("(+" $ string(CurrentKillInfoTrapScore)) $ ")");
            }            
        }
        else
        {
            TrapString = "";
        }
        AdvGFxHud(AdvGFxHudWrapper(myHUD).HudMovie).SetKillInfoText(KillString, TrapString);
        // End:0x1B6
        if(IsTimerActive('ResetKillInfo'))
        {
            ClearTimer('ResetKillInfo');
        }
        SetTimer(ComboKillMaxInterval, false, 'ResetKillInfo');
    }
    //return;    
}

function ResetKillInfo()
{
    bKillInfoTextDisplaying = false;
    bTrapInfoTextDisplaying = false;
    CurrentKillInfoScore = 0;
    CurrentKillInfoTrapScore = 0;
    //return;    
}

reliable server function DebugUnlockPerk(int Index, AdvPlayerControllerMP PC)
{
    PC.bAvaiblePerks.Length = 4;
    PC.bAvaiblePerks[Index] = 1;
    //return;    
}

reliable client simulated function SetPerkBonusScoreMessage(int BonusScore)
{
    // End:0x8E
    if(myHUD != none)
    {
        AdvGFxHud(AdvGFxHudWrapper(myHUD).HudMovie).SetKillInfoText(((Class'AdvPerkManager_Base'.default.BonusScoreMessage @ "(+") $ string(BonusScore)) $ ")", "");
    }
    //return;    
}

reliable client simulated function ResetKillInfoMessage()
{
    // End:0x5A
    if(myHUD != none)
    {
        AdvGFxHud(AdvGFxHudWrapper(myHUD).HudMovie).SetKillInfoText("", "");
    }
    //return;    
}

reliable client simulated function OpenMutliplayerStartingScreen()
{
    // End:0xFC
    if((AdvPRI(PlayerReplicationInfo) == none) || !AdvPRI(PlayerReplicationInfo).bIsTournamentSpectator)
    {
        // End:0x92
        if((myHUD == none) || WorldInfo.GRI == none)
        {
            SetTimer(0.0100000, false, 'OpenMutliplayerStartingScreen');            
        }
        else
        {
            // End:0xFC
            if(class<AdvGameSurvivalBase>(WorldInfo.GRI.GameClass) == none)
            {
                AdvGFxHudWrapper(myHUD).OpenMutliplayerStartingScreen();
            }
        }
    }
    //return;    
}

reliable client simulated function TurnInTournamentSpectator()
{
    SetCinematicMode(false, false, true, true, true, true);
    ServerGoToState('Spectating');
    ResetCameraMode();
    ServerViewSelf();
    bLMSCameraTPPMode = false;
    //return;    
}

protected function BroadcastPowerupLoopSound(name PowerupID, bool bNewEnabled)
{
    //return;    
}

reliable server function SubtleChangeTeam()
{
    local bool bResult;

    bResult = AdvGameMP_Base(WorldInfo.Game).CanChangeTeam(AdvPRI(PlayerReplicationInfo));
    // End:0x91
    if(bResult)
    {
        AdvPRI(PlayerReplicationInfo).bWantToChangeTeam = true;
    }
    ClientShowChangeTeamMessage(bResult);
    //return;    
}

reliable client simulated function ClientShowChangeTeamMessage(bool bChangeSuccessful)
{
    // End:0x97
    if((myHUD != none) && AdvGFxUI_Menu_MultiPause(AdvGFxHudWrapperMP(myHUD).AdvPauseMenuMovie) != none)
    {
        AdvGFxUI_Menu_MultiPause(AdvGFxHudWrapperMP(myHUD).AdvPauseMenuMovie).ShowChangeTeamMessage(bChangeSuccessful);
    }
    //return;    
}

exec function ClientCreateWaypoint()
{
    local Vector HitLocation, HitNormal, TraceEnd;
    local TraceHitInfo HitInfo;
    local Actor TraceHit;

    // End:0x180
    if((AdvGRI(WorldInfo.GRI) != none) && AdvGRI(WorldInfo.GRI).IsTeamMultiPlayerGame() || AdvGRI(WorldInfo.GRI).IsSurvivalGame())
    {
        TraceEnd = PlayerCamera.Location + (Normal(Vector(PlayerCamera.Rotation)) * float(32768));
        TraceHit = Trace(HitLocation, HitNormal, TraceEnd, PlayerCamera.Location, true,, HitInfo);
        ServerCreateWayPoint(HitLocation, HitNormal, TraceHit == none);
    }
    //return;    
}

reliable server function ServerCreateWayPoint(Vector SpawnLocation, Vector HitNormal, optional bool bForceFail = false)
{
    local AdvWayPointMPBase WP;
    local AdvPlayerControllerMP PC;

    // End:0x248
    if((!bForceFail && PlayerReplicationInfo != none) && AdvTeamInfo(PlayerReplicationInfo.Team).TeamWayPoint == none)
    {
        WP = Spawn(AdvGameMP_Base(WorldInfo.Game).WayPointClass, PlayerReplicationInfo.Team,, SpawnLocation + (5.0000000 * HitNormal), Rotator(HitNormal));
        // End:0x232
        if(WP != none)
        {
            AdvTeamInfo(PlayerReplicationInfo.Team).TeamWayPoint = WP;
            // End:0x22E
            foreach WorldInfo.AllControllers(Class'AdvPlayerControllerMP', PC)
            {
                // End:0x22D
                if((PC.PlayerReplicationInfo != none) && PC.PlayerReplicationInfo.Team == PlayerReplicationInfo.Team)
                {
                    PC.ClientPlaySound(WayPointSuccess);
                }                
            }                        
        }
        else
        {
            ClientPlaySound(WayPointFailure);
        }        
    }
    else
    {
        ClientPlaySound(WayPointFailure);
    }
    //return;    
}

reliable client simulated function SpawnEnemyPlayerTrail(ImpactInfo Impact, ParticleSystem SmokeTracePS, AdvPlayerControllerMP PC)
{
    local editinline ParticleSystemComponent SmokeProj;

    // End:0xF6
    if(PC == none)
    {
        SmokeProj = WorldInfo.MyEmitterPool.SpawnEmitter(SmokeTracePS, Impact.StartTrace, Rotator(Impact.HitLocation - Impact.StartTrace));
        SmokeProj.SetVectorParameter('SnipeEnd', Impact.HitLocation);
    }
    //return;    
}

reliable client simulated function SetFiringDisableFlag(bool NewFlag)
{
    bFiringDisabled = NewFlag;
    //return;    
}

reliable client simulated function ClientPlayMummyDeath()
{
    GetPPManager().Reset();
    SetTimer(0.3000000, false, 'EnableDarkness', self);
    //return;    
}

reliable client simulated function EnableDarkness()
{
    AdvPostProcessManager(GetPPManager()).EnableFade(ColorToLinearColor(MakeColor(byte(0.3500000), byte(0.3500000), byte(0.3500000))), 2.5000000, false, 0.3000000, 0.0000000);
    AdvPostProcessManager(GetPPManager()).EnableBleachBypass(true, 0.5000000);
    //return;    
}

reliable client simulated function EnableLMSWoundedBlood(bool Enable)
{
    // End:0x39
    if(Enable)
    {
        AdvPostProcessManager(GetPPManager()).EnableDeath();        
    }
    else
    {
        AdvPostProcessManager(GetPPManager()).Reset();
    }
    //return;    
}

reliable client simulated function PlayArmageddonSound(bool Play)
{
    // End:0x31
    if(!Play)
    {
        ArmageddonHeartBeat.Stop();        
    }
    else
    {
        ArmageddonHeartBeat.Play();
    }
    //return;    
}

function bool CleanupOnlineSubsystemSession(bool bWasFromMenu)
{
    local OnlineLobbyInterfaceSteamworks LobbyInterface;

    LobbyInterface = OnlineSubsystemSteamworks(OnlineSub).LobbyInterface;
    LobbyInterface.LeaveLobby(LobbyUID);
    return super(UTPlayerController).CleanupOnlineSubsystemSession(bWasFromMenu);
    //return ReturnValue;    
}

function OnLinkStatusChanged(bool bIsConnected)
{
    local AdvUIManager UIManager;
    local array<name> ButtonAliases;

    // End:0x215
    if(!bIsConnected && !WorldInfo.IsConsoleBuild(1) || OnlineSub.GameInterface.GetGameSettings('Party') != none)
    {
        PunishPlayerForLeavingTheMatch();
        WriteSomeStatsToProfile();
        // End:0xF0
        if(int(WorldInfo.NetMode) == int(NM_ListenServer))
        {
            WorldInfo.Game.bHasNetworkError = true;
        }
        UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
        // End:0x20A
        if(UIManager != none)
        {
            ButtonAliases.AddItem('GenericAccept');            
            UIManager.ShowUIMessage('ConnectionError', Localize("MessageBoxErrorStrings", "LostLink_Title", "ADVGame"), Localize("MessageBoxErrorStrings", "LostLink_Message", "ADVGame"), ButtonAliases, None,,,,, false, false);
        }
        ReturnToMainMenu(true);
    }
    // End:0x281
    if(AdvLocalPlayer(Player) != none)
    {
        AdvLocalPlayer(Player).bIsReturningFromMP = false;
        AdvLocalPlayer(Player).bIsReturningFromSurvival = false;
    }
    //return;    
}

simulated function ReplaceNoPrimaryStorageDeviceMessage()
{
    local AdvUIManager UIMan;
    local AdvLocalPlayer LP;

    UIMan = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    LP = AdvLocalPlayer(Player);
    // End:0x1DA
    if((UIMan.IsUIMessageActive('StorageError', LP) && int(OnlineSub.PlayerInterface.GetLoginStatus(byte(LP.ControllerId))) > int(0)) && !OnlineSub.PlayerInterface.IsGuestLogin(byte(LP.ControllerId)))
    {
        UIMan.ClearUIMessage('StorageError', LP, true);
        LP.bHasSeenStartScreen = true;
        AdvDataProvider_PlayerStorage(OnlinePlayerData.StorageProvider).ShowNoPrimaryStorageMessageWithReselectOptions(LP, true);
    }
    //return;    
}

reliable client simulated function CloseAllMultiMenus()
{
    AdvGFxHudWrapper(myHUD).CloseAllMultiMenus();
    //return;    
}

simulated function ReturnToMainMenu(bool bReturnToStartScreen)
{
    AdvLocalPlayer(Player).bIsReturningFromMP = true;
    // End:0x82
    if(class<AdvGameSurvivalBase>(WorldInfo.GetGameClass()) != none)
    {
        AdvLocalPlayer(Player).bIsReturningFromSurvival = true;
    }
    super.ReturnToMainMenu(bReturnToStartScreen);
    Suicide();
    //return;    
}

simulated function EnableQuadDamage()
{
    // End:0xC1
    if(WorldInfo.GRI.IsMultiplayerGame() && !IsTimerActive('DisableQuadDamage'))
    {
        AdvPRI(PlayerReplicationInfo).bQuadDamage = true;
        EnableQuadDamageFX(true);
        BroadcastPowerupLoopSound('QuadDamage', true);
        // End:0xC1
        if(!IsInState('QuadDamage'))
        {
            PushState('QuadDamage');
        }
    }
    //return;    
}

simulated function DisableQuadDamage()
{
    AdvPRI(PlayerReplicationInfo).bQuadDamage = false;
    EnableQuadDamageFX(false);
    BroadcastPowerupLoopSound('QuadDamage', false);
    ClearTimer('DisableQuadDamage');
    // End:0x78
    if(IsInState('QuadDamage'))
    {
        PopState();
    }
    //return;    
}

private reliable client final simulated function EnableQuadDamageFX(bool bEnable)
{
    //return;    
}

private final simulated function SetQuadDamageVisionMaterialOnPawns(bool bEnable)
{
    //return;    
}

reliable client simulated function ShowTeamPanel(bool bShow)
{
    // End:0x2F
    if(bShow)
    {
        AdvHudWrapper.ShowScoreboardAndHud();        
    }
    else
    {
        AdvHudWrapper.HideAndCloseScoreboard();
    }
    //return;    
}

reliable server function ClientSwitchTeam()
{
    SwitchTeam();
    //return;    
}

reliable server function SwitchReadyStatus()
{
    // End:0x67
    if(int(Role) == int(ROLE_Authority))
    {
        AdvPRI(PlayerReplicationInfo).bReadyToPlay = !AdvPRI(PlayerReplicationInfo).bReadyToPlay;
    }
    //return;    
}

reliable client simulated function ShowEndRoundMessage()
{
    // End:0x0F
    if(myHUD != none)
    {
    }
    //return;    
}

function CleanupMessageBoxesForInvite()
{
    local AdvLocalPlayer LP;
    local AdvUIManager UIManager;

    LP = AdvLocalPlayer(Player);
    UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0x86
    if(UIManager != none)
    {
        UIManager.CloseAllUIMessageBoxes(LP);
    }
    //return;    
}

final function ShowInviteInfoMsg()
{
    local AdvUIManager UIManager;
    local array<name> ButtonAliases;

    UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0x10D
    if(UIManager != none)
    {
        ButtonAliases.AddItem('GenericContinue');        
        UIManager.ShowUIMessage('InviteInfo', Localize("AdvGFxUI_Info", "TitleString", "ADVGame"), Localize("MessageBoxStrings", "InactivePlayerInvite", "ADVGame"), ButtonAliases, MMenuReturn,,,, true, false, false);
    }
    //return;    
}

reliable client simulated function ClientUpdateAvaiblePerks(int PerkNumber, int Value)
{
    // End:0x24
    if(PerkNumber >= bAvaiblePerks.Length)
    {
        bAvaiblePerks.Add(1);        
    }
    bAvaiblePerks[PerkNumber] = byte(Value);
    //return;    
}

function NotifyPreDestroyPRI(PlayerReplicationInfo PRI)
{
    // End:0xC9
    if((int(WorldInfo.NetMode) == int(NM_Client)) && WorldInfo.bAllowHostMigration)
    {
        // End:0x74
        if(GameHostMigrationManager == none)
        {
            GameHostMigrationManager = new Class'AdvGameHostMigrationManager';
        }
        // End:0xC9
        if(!PRI.bBot)
        {
            GameHostMigrationManager.AddPlayerData(AdvPRI(PRI));
        }
    }
    //return;    
}

exec function StartMummy()
{
    local AdvPerk_Base P;

    P = Spawn(AdvGameMP_Base(WorldInfo.Game).PerkManager.Perks[3]);
    P.ActivatePerk(self);
    P.Destroy();
    //return;    
}

reliable client simulated function ClientPlayPerkMusic(optional SoundCue Sound, optional bool bPlay = true)
{
    // End:0x3D
    if(Sound != none)
    {
        PerkActivationMusic.SoundCue = Sound;
    }
    // End:0xDE
    if(!PerkActivationMusic.IsPlaying() && bPlay)
    {
        PerkActivationMusic.FadeIn(1.5000000, 1.0000000);
        SetTimer(PerkActivationMusic.SoundCue.GetCueDuration(), false, 'CleanPerkMusic');        
    }
    else
    {
        // End:0x15A
        if(PerkActivationMusic.IsPlaying() && !bPlay)
        {
            PerkActivationMusic.FadeOut(1.5000000, 1.0000000);
            PerkActivationMusic.SoundCue = none;
        }
    }
    //return;    
}

reliable client simulated function CleanPerkMusic()
{
    PerkActivationMusic.Stop();
    PerkActivationMusic.SoundCue = none;
    //return;    
}

exec function UpdateLocalCacheOfProfileSettings()
{
    // End:0x42
    if((int(WorldInfo.NetMode) == int(NM_Client)) && IsPrimaryPlayer())
    {
        UpdateHostMigrationScore();
    }
    super.UpdateLocalCacheOfProfileSettings();
    //return;    
}

function string GetNewPeerHostURL()
{
    return Class'AdvPreGameLobbyGame_Base'.static.GetTravelToPreGameLobbyUrl();
    //return ReturnValue;    
}

event PerformGameHostMigration()
{
    local int PRIIndex, PeerIdx, TeamIdx;
    local array<CurrentPlayerMet> Players;
    local CurrentPlayerMet CurrentPlayer;
    local AdvRecentPlayer GearCurrentPlayer;
    local AdvRecentPlayersList RecentPlayersList;
    local UniqueNetId ZeroId;
    local bool bMatchEnded, bTeamAchievedGoalScore;

    // End:0x638
    if(OnlineSub != none)
    {
        OnlineSub.SetNamedInterface('GameHostMigrationManager', GameHostMigrationManager);
        bMatchEnded = AdvGRI(WorldInfo.GRI) == none;
        TeamIdx = 0;
        J0x80:

        // End:0x1AB [Loop If]
        if(TeamIdx < GameHostMigrationManager.Teams.Length)
        {
            bTeamAchievedGoalScore = (GameHostMigrationManager.GameData.GoalScore > 0) && GameHostMigrationManager.Teams[TeamIdx].TeamScore >= GameHostMigrationManager.GameData.GoalScore;
            // End:0x19D
            if(bMatchEnded || bTeamAchievedGoalScore)
            {
                GameHostMigrationManager.ResetForNewMatch();
                // [Explicit Break]
                goto J0x1AB;
            }
            TeamIdx++;
            // [Loop Continue]
            goto J0x80;
        }
        J0x1AB:

        RecentPlayersList = AdvRecentPlayersList(OnlineSub.GetNamedInterface('RecentPlayersList'));
        // End:0x638
        if(RecentPlayersList != none)
        {
            RecentPlayersList.ClearAllPKParties();
            RecentPlayersList.ClearRecentPlayers();
            PRIIndex = 0;
            J0x23E:

            // End:0x610 [Loop If]
            if(PRIIndex < GameHostMigrationManager.Players.Length)
            {
                PeerIdx = FindConnectedPeerIndex(GameHostMigrationManager.Players[PRIIndex].UniqueId);
                // End:0x602
                if(GameHostMigrationManager.Players[PRIIndex].UniqueId == PlayerReplicationInfo.UniqueId || (PeerIdx != -1) && ConnectedPeers[PeerIdx].bLostConnectionToHost)
                {
                    CurrentPlayer.NetId = GameHostMigrationManager.Players[PRIIndex].UniqueId;
                    CurrentPlayer.Skill = GameHostMigrationManager.Players[PRIIndex].PlayerSkill;
                    CurrentPlayer.TeamNum = GameHostMigrationManager.Players[PRIIndex].TeamID;
                    Players.AddItem(CurrentPlayer);                    
                    GearCurrentPlayer = CurrentPlayer;
                    GearCurrentPlayer.Level = GameHostMigrationManager.Players[PRIIndex].PlayerLevel;
                    // End:0x59F
                    if(GameHostMigrationManager.Players[PRIIndex].PartyOwnerUniqueId != ZeroId)
                    {
                        RecentPlayersList.AddLastPKPartyPlayer(GameHostMigrationManager.Players[PRIIndex].PartyOwnerUniqueId, GearCurrentPlayer);                        
                    }
                    else
                    {
                        RecentPlayersList.AddLastPKPartyPlayer(GameHostMigrationManager.Players[PRIIndex].UniqueId, GearCurrentPlayer);
                    }
                }
                PRIIndex++;
                // [Loop Continue]
                goto J0x23E;
            }
            RecentPlayersList.SetCurrentPlayersList(Players);
        }
    }
    //return;    
}

reliable client simulated function ClientSetHudVisibility(bool NewVisibility)
{
    // End:0x41
    if(myHUD != none)
    {
        AdvGFxHudWrapper(myHUD).SetVisible(NewVisibility);
    }
    //return;    
}

exec function ToggleQuickMenu(optional AdvTypes.EInventoryItem SelectedIndex, optional bool bFromQuickMenu = false)
{
    // End:0x96
    if((!MyAdvPlayerPawnMP.bIsMummy && AdvGRI(WorldInfo.GRI).IsSurvivalGame()) && int(SelectedIndex) == int(4))
    {
        super.ToggleQuickMenu(SelectedIndex);
    }
    //return;    
}

reliable server function ServerGoToState(name NewStateName)
{
    GotoState(NewStateName);
    ClientGotoState(NewStateName);
    //return;    
}

function NotifyFocusModeChanged(bool bNewEnabled)
{
    //return;    
}

reliable client simulated function ClientShowSurvivalEndStatisticsScreen()
{
    // End:0xB3
    if(!Class'Engine.Engine'.static.IsEditor() && myHUD != none)
    {
        // End:0xA0
        if(AdvGRI(WorldInfo.GRI).bWinnerUpdated)
        {
            AdvGFxHudWrapper(myHUD).OpenSurvivalEndScreen();            
        }
        else
        {
            SetTimer(0.0100000, false, 'ClientShowSurvivalEndStatisticsScreen');
        }
    }
    //return;    
}

reliable client simulated function ClientShowRoundEndScreen()
{
    // End:0x8D
    if(myHUD != none)
    {
        // End:0x7A
        if(AdvGRI(WorldInfo.GRI).bRoundWinnerUpdated)
        {
            AdvGFxHudWrapper(myHUD).OpenMutliplayerRoundEndScreen();            
        }
        else
        {
            SetTimer(0.0100000, false, 'ClientShowRoundEndScreen');
        }
    }
    //return;    
}

reliable client simulated function ClientShowEndScreenMP()
{
    // End:0xA4
    if(myHUD != none)
    {
        // End:0x91
        if(AdvGRI(WorldInfo.GRI).bWinnerUpdated)
        {
            AdvGFxHudWrapper(myHUD).OpenMutliplayerEndScreen();
            SetTimer(EndScreenDuration, false, 'ShowScoreboard');            
        }
        else
        {
            SetTimer(0.0100000, false, 'ClientShowEndScreenMP');
        }
    }
    //return;    
}

function ClientPlayWoundedSound(AdvPlayerPawnMP P)
{
    P.PlaySoundFromArchetypeByChance(20,, false);
    //return;    
}

reliable client simulated function ClientAddBonusNoDeathScore(int Amt)
{
    AdvPRI(PlayerReplicationInfo).BonusScore += Amt;
    // End:0x8F
    if(int(WorldInfo.NetMode) == int(NM_Client))
    {
        AdvPRI(PlayerReplicationInfo).Score += float(Amt);
    }
    //return;    
}

reliable client simulated function ClientAddBonusMostKillsScore(int Amt)
{
    AdvPRI(PlayerReplicationInfo).BonusScore += Amt;
    // End:0x8F
    if(int(WorldInfo.NetMode) == int(NM_Client))
    {
        AdvPRI(PlayerReplicationInfo).Score += float(Amt);
    }
    //return;    
}

reliable client simulated function ClientAddBonusBestResultScore(int Amt)
{
    AdvPRI(PlayerReplicationInfo).BonusScore += Amt;
    // End:0x8F
    if(int(WorldInfo.NetMode) == int(NM_Client))
    {
        AdvPRI(PlayerReplicationInfo).Score += float(Amt);
    }
    //return;    
}

reliable client simulated function ClientAddBonusScoreForWin(int Amt)
{
    AdvPRI(PlayerReplicationInfo).BonusScore += Amt;
    // End:0x8F
    if(int(WorldInfo.NetMode) == int(NM_Client))
    {
        AdvPRI(PlayerReplicationInfo).Score += float(Amt);
    }
    //return;    
}

function StartButtonTracing()
{
    // End:0x20
    if(!IsInState('ButtonTracingMP'))
    {
        GotoState('ButtonTracingMP');
    }
    //return;    
}

function StopButtonTracing()
{
    // End:0xAA
    if(IsInState('ButtonTracingMP'))
    {
        GotoState('PlayerWalking');
        // End:0xAA
        if(((MyEvilPawn != none) && MyEvilPawn.WeaponLeft != none) && MyEvilPawn.WeaponLeft.Class == NotepadFocusTriggerItemClass)
        {
            PushState('NotepadFocus');
        }
    }
    //return;    
}

function Actor GetActorHit()
{
    return none;
    //return ReturnValue;    
}

reliable server function ServerAdvConsoleButtonClick(AdvConsoleObjectMPDLC1_base clientACO, Pawn clientP, Actor clientActorHit)
{
    clientACO.ButtonClick(clientP, clientActorHit);
    //return;    
}

reliable server function ServerAdvConsoleButtonUnclick(AdvConsoleObjectMPDLC1_base clientACO, Pawn clientP)
{
    clientACO.ButtonUnclick(clientP);
    //return;    
}

simulated event Destroyed()
{
    CharacterStore = none;
    super.Destroyed();
    //return;    
}

state PlayerWalking
{
    function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        // End:0x147
        if(self.IsChildState(PreviousStateName, 'Wounded_Base'))
        {
            MyAdvPlayerPawnMP.EndQuickHideCurrentWeapon(true,, true);
            MyAdvPlayerPawnMP.EndQuickHideCurrentWeapon(true,, false);
            // End:0xE5
            if(Pawn.Weapon != none)
            {
                AdvWeap_Base(MyAdvPlayerPawnMP.Weapon).SetHidden(false);
            }
            // End:0x147
            if(Pawn.WeaponLeft != none)
            {
                AdvWeap_Base(MyAdvPlayerPawnMP.WeaponLeft).SetHidden(false);
            }
        }
        //return;        
    }
    stop;    
}

state Wounded_Base extends PlayerWalking
{
    local float mummyOrDevastatorTimeRemaining;

    ignores Use, StartFire, SetSprint, PrevWeapon, NextWeapon, Melee, 
	    MeleeKick, DynamiteThrow, GrenadeThrow, DynamiteRelease, GrenadeRelease, 
	    Reload, FocusFlashlight;

    function BeginState(name PreviousStateName)
    {
        local AdvPlayerControllerMP PCmp;

        Pawn.SetPhysics(2);
        // End:0x6F
        if(myHUD != none)
        {
            AdvGFxHud(AdvGFxHudWrapper(myHUD).HudMovie).ShowDeathTimer();
        }
        MyAdvPlayerPawnMP.bInitialPlayWoundedAnimation = true;
        SetTimer(0.1000000, true, 'WoundedTimer');
        EnableLMSWoundedBlood(true);
        SetBehindView(true);
        bNoCrosshair = true;
        MyAdvPlayerPawnMP.bIsWounded = true;
        ServerStartWoundedSequence();
        bForceNetUpdate = true;
        MyAdvPlayerPawnMP.bForceNetUpdate = true;
        // End:0x1D0
        if(int(Role) == int(ROLE_Authority))
        {
            // End:0x1CF
            foreach WorldInfo.AllControllers(Class'AdvPlayerControllerMP', PCmp)
            {
                // End:0x1CE
                if(PCmp.MyAdvPlayerPawnMP.IsSameTeam(MyAdvPlayerPawnMP))
                {
                    PCmp.ClientSetHealHudIcon(MyAdvPlayerPawnMP, true);
                }                
            }            
        }
        // End:0x229
        if(MyAdvPlayerPawnMP.MyTorch != none)
        {
            MyAdvPlayerPawnMP.MyTorch.DeactivateFlightBeam();
        }
        StopFire(0);
        // End:0x2C4
        if(MyAdvPlayerPawnMP.bIsMummy || MyAdvPlayerPawnMP.bIsDevastator)
        {
            // End:0x2C4
            if(IsTimerActive('TransformInPlayer'))
            {
                mummyOrDevastatorTimeRemaining = GetTimerCount('TransformInPlayer');
                ClearTimer('TransformInPlayer');
            }
        }
        //return;        
    }

    function EndState(name NextStateName)
    {
        local AdvPlayerControllerMP PCmp;

        Pawn.SetPhysics(1);
        EnableLMSWoundedBlood(false);
        ClearTimer('WoundedTimer');
        // End:0x8E
        if(myHUD != none)
        {
            AdvGFxHud(AdvGFxHudWrapper(myHUD).HudMovie).HideDeathTimer();
        }
        // End:0x101
        if(int(Role) == int(ROLE_Authority))
        {
            // End:0x100
            foreach WorldInfo.AllControllers(Class'AdvPlayerControllerMP', PCmp)
            {
                PCmp.ClientSetHealHudIcon(MyAdvPlayerPawnMP, false);                
            }            
        }
        SetBehindView(false);
        bNoCrosshair = false;
        SetDisableMovement(false);
        MyAdvPlayerPawnMP.bIsWounded = false;
        MyAdvPlayerPawnMP.Health = MyAdvPlayerPawnMP.HealthMax;
        bForceNetUpdate = true;
        MyAdvPlayerPawnMP.bForceNetUpdate = true;
        // End:0x1D9
        if(IsTimerActive('ForceKillDuringWounded'))
        {
            ClearTimer('ForceKillDuringWounded');
        }
        // End:0x24F
        if(MyAdvPlayerPawnMP.bIsMummy || MyAdvPlayerPawnMP.bIsDevastator)
        {
            // End:0x24F
            if(!IsTimerActive('TransformInPlayer'))
            {
                SetTimer(mummyOrDevastatorTimeRemaining, false, 'TransformInPlayer');
            }
        }
        //return;        
    }

    simulated event bool NotifyBump(Actor Other, Vector HitNormal)
    {
        local Vector TraceEnd;
        local bool bResult;

        bResult = super(Controller).NotifyBump(Other, HitNormal);
        TraceEnd = Pawn.Location;
        TraceEnd.Z -= float(80);
        // End:0xBA
        if(FastTrace(TraceEnd, Pawn.Location,, true))
        {
            Pawn.SetPhysics(2);
        }
        return bResult;
        //return ReturnValue;        
    }

    function PreventDeath()
    {
        // End:0x21
        if(IsTimerActive('WoundedTimer'))
        {
            ServerPreventDeath();
        }
        //return;        
    }

    reliable server function ServerPreventDeath()
    {
        DeathTimerClicks++;
        //return;        
    }

    simulated function WoundedTimer()
    {
        // End:0x22
        if(DeathTimerClicks == 0)
        {
            RescueTime -= 0.1000000;            
        }
        else
        {
            // End:0x41
            if(DeathTimerClicks >= 1)
            {
                RescueTime -= 0.0500000;
            }
        }
        DeathTimerClicks = 0;
        // End:0x12B
        if(myHUD != none)
        {
            // End:0xD1
            if(RescueTime > float(0))
            {
                AdvGFxHud(AdvGFxHudWrapper(myHUD).HudMovie).UpdateDeathTimer(int((RescueTime / TimeToRescueSurvival) * float(100)));                
            }
            else
            {
                ClearTimer('WoundedTimer');
                AdvGFxHud(AdvGFxHudWrapper(myHUD).HudMovie).HideDeathTimer();
            }
        }
        //return;        
    }

    function CheckForUsableTrigger()
    {
        UsableTrigger = none;
        ForceNetRelevant();
        //return;        
    }
    stop;    
}

state Wounded extends Wounded_Base
{
    function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        RescueTime = TimeToRescueLMS;
        SetTimer(5.0000000, true, 'PlayWoundedSound');
        MyAdvPlayerPawnMP.Health = MyAdvPlayerPawnMP.WoundedHealth;
        // End:0xE2
        if(AdvGameLastMenStandingBase(WorldInfo.Game) != none)
        {
            AdvGameLastMenStandingBase(WorldInfo.Game).bCheckScore = true;
        }
        //return;        
    }

    function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        ClearTimer('PlayWoundedSound');
        //return;        
    }
    stop;    
}

state SurvivalWounded extends Wounded_Base
{
    function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        // End:0x7F
        if(int(WorldInfo.NetMode) < int(NM_Client))
        {
            // End:0x7F
            if(!MyEvilPawn.bNavMeshRegistered)
            {
                MyEvilPawn.RegisterNavMeshObstacle();
            }
        }
        RescueTime = TimeToRescueSurvival;
        MyAdvPlayerPawnMP.Health = MyAdvPlayerPawnMP.SurvivalWoundedHealth;
        ClientDisableAIWallSeeFlag();
        // End:0x144
        if(AdvGameSurvivalBase(WorldInfo.Game) != none)
        {
            AdvGameSurvivalBase(WorldInfo.Game).CheckLastInTeam(self);
        }
        //return;        
    }

    function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        // End:0x7D
        if(int(WorldInfo.NetMode) < int(NM_Client))
        {
            // End:0x7D
            if(MyEvilPawn.bNavMeshRegistered)
            {
                MyEvilPawn.UnregisterNavmeshObstacle();
            }
        }
        ServerUpdateAIWallSee();
        //return;        
    }
    stop;    
}

state SecondChance extends Wounded_Base
{
    function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        MyAdvPlayerPawnMP.bIsSecondChance = true;
        Pawn.Health = MyAdvPlayerPawnMP.SecondChanceHealth;
        ServerStartSecondChanceSequence();
        //return;        
    }

    function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        MyAdvPlayerPawnMP.bIsSecondChance = false;
        ServerFinishSecondChanceSequence();
        //return;        
    }

    function PlayerMove(float DeltaTime)
    {
        UpdateRotation(DeltaTime);
        //return;        
    }
    stop;    
}

state Spectating
{
    simulated event BeginState(name PreviousStateName)
    {
        local string LocKeyString;

        // End:0x3A
        if(MyAdvPlayerPawnMP != none)
        {
            SetLocation(MyAdvPlayerPawnMP.Location);
            UnPossess();
        }
        bCollideWorld = true;
        // End:0x286
        if((class<AdvGameSurvivalBase>(WorldInfo.GetGameClass()) != none) || class<AdvGameLastMenStandingBase>(WorldInfo.GetGameClass()) != none)
        {
            GetPPManager().Reset();
            // End:0xFC
            if(class<AdvGameSurvivalBase>(WorldInfo.GetGameClass()) != none)
            {
                ClientDisableAIWallSeeFlag();
            }
            LocKeyString = "ChangeViewSVString";
            // End:0x15C
            if(WorldInfo.IsConsoleBuild(1))
            {
                LocKeyString = LocKeyString $ "XBOX";                
            }
            else
            {
                // End:0x19A
                if(WorldInfo.IsConsoleBuild(2))
                {
                    LocKeyString = LocKeyString $ "PS3";
                }
            }
            // End:0x253
            if((AdvHudWrapper != none) && !AdvPRI(PlayerReplicationInfo).bIsTournamentSpectator)
            {
                AdvGFxHud(AdvHudWrapper.HudMovie).ShowTutorialMessage(Localize("AdvPlayerController", LocKeyString, "ADVGame"), true);
                bDisplayingTutorialMessage = true;
            }
            // End:0x283
            if(ForceFeedbackManager != none)
            {
                ForceFeedbackManager.bAllowsForceFeedback = false;
            }            
        }
        else
        {
            super.BeginState(PreviousStateName);
        }
        //return;        
    }

    exec function StartFire(optional byte FireModeNum)
    {
        // End:0x18
        if(bLMSCameraTPPMode)
        {
            ServerViewNextPlayer();
        }
        //return;        
    }

    exec function StartAltFire(optional byte FireModeNum)
    {
        // End:0x18
        if(bLMSCameraTPPMode)
        {
            ServerViewPrevPlayer();
        }
        //return;        
    }

    simulated function SwitchView()
    {
        // End:0x31
        if(bLMSCameraTPPMode)
        {
            ResetCameraMode();
            ServerViewSelf();
            bLMSCameraTPPMode = false;            
        }
        else
        {
            ServerViewNextPlayer();
            bLMSCameraTPPMode = true;
        }
        //return;        
    }

    simulated event EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        // End:0x94
        if(((AdvHudWrapper != none) && AdvHudWrapper.HudMovie != none) && bDisplayingTutorialMessage)
        {
            AdvGFxHud(AdvHudWrapper.HudMovie).HideTutorialMessage();
        }
        // End:0xF4
        if((ForceFeedbackManager != none) && ProfileSettings != none)
        {
            ForceFeedbackManager.bAllowsForceFeedback = ProfileSettings.GetControllerVibrationOption();
        }
        // End:0x10B
        if(NextStateName == 'PlayerWalking')
        {
        }
        SetBehindView(false);
        //return;        
    }
    stop;    
}

auto state PlayerWaiting
{
    ignores SwitchWeapon, Use;

    simulated event BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        bDisplayingTutorialMessage = false;
        // End:0x78
        if(AdvGRI(WorldInfo.GRI).bFirstRound || bFirstSpawn)
        {
            OpenMutliplayerStartingScreen();
        }
        //return;        
    }

    simulated event FellOutOfWorld(class<DamageType> dmgType)
    {
        bCameraOutOfWorld = true;
        //return;        
    }

    function ProcessMove(float DeltaTime, Vector newAccel, Actor.EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
    {
        local Vector OldLocation;

        OldLocation = Location;
        super.ProcessMove(DeltaTime, newAccel, DoubleClickMove, DeltaRot);
        // End:0x66
        if(bCameraOutOfWorld)
        {
            bCameraOutOfWorld = false;
            SetLocation(OldLocation);
        }
        //return;        
    }

    exec function StartAltFire(optional byte FireModeNum)
    {
        // End:0x70
        if((AdvGRI(WorldInfo.GRI) != none) && AdvGRI(WorldInfo.GRI).IsTeamMultiPlayerGame())
        {
        }
        //return;        
    }

    reliable server function ServerRestartPlayer()
    {
        super.ServerRestartPlayer();
        // End:0x102
        if((WorldInfo.Game.bWaitingToStartMatch && EvilGame(WorldInfo.Game).bWarmupRound) && float(EvilGame(WorldInfo.Game).WarmupTime) > 1.0000000)
        {
            WorldInfo.Game.RestartPlayer(self);
        }
        //return;        
    }

    event PlayerTick(float DeltaTime)
    {
        global.PlayerTick(DeltaTime);
        // End:0xCA
        if(((((AdvGRI(WorldInfo.GRI) != none) && AdvGRI(WorldInfo.GRI).bMatchHasBegun) && !bDisplayingTutorialMessage) && AdvHudWrapper != none) && AdvHudWrapper.HudMovie != none)
        {
        }
        //return;        
    }

    simulated event EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        // End:0x48
        if((AdvHudWrapper != none) && AdvHudWrapper.HudMovie != none)
        {
        }
        //return;        
    }
    stop;    
}

state RoundEnded
{
    ignores SeePlayer, HearNoise, KilledBy, NotifyBump, HitWall, NotifyHeadVolumeChange, 
	    NotifyPhysicsVolumeChange, Falling, TakeDamage, Suicide, DrawHUD, 
	    Jump, PrevWeapon, NextWeapon, SwitchWeapon, ToggleMelee, 
	    StartFire, StartAltFire;

    function AutoContinueToNextRound()
    {
        // End:0x59
        if((int(Role) == int(ROLE_Authority)) && WorldInfo.Game.ShouldAutoContinueToNextRound())
        {
            StartFire(0);
        }
        //return;        
    }

    event Rotator LimitViewRotation(Rotator ViewRotation, float ViewPitchMin, float ViewPitchMax)
    {
        ViewRotation.Pitch = ViewRotation.Pitch & 65535;
        // End:0x119
        if((ViewRotation.Pitch > 8192) && float(ViewRotation.Pitch) < (float(65535) + ViewPitchMin))
        {
            // End:0xE8
            if(ViewRotation.Pitch < 32768)
            {
                ViewRotation.Pitch = 8192;                
            }
            else
            {
                ViewRotation.Pitch = int(float(65535) + ViewPitchMin);
            }
        }
        return ViewRotation;
        //return ReturnValue;        
    }

    unreliable client simulated function LongClientAdjustPosition(float TimeStamp, name NewState, Actor.EPhysics newPhysics, float NewLocX, float NewLocY, float NewLocZ, float NewVelX, float NewVelY, float NewVelZ, Actor NewBase, float NewFloorX, float NewFloorY, float NewFloorZ)
    {
        // End:0x25
        if(NewState == 'PlayerWaiting')
        {
            GotoState(NewState);
        }
        //return;        
    }

    function PlayerMove(float DeltaTime)
    {
        local Vector X, Y, Z;
        local Rotator DeltaRot, ViewRotation;

        GetAxes(Rotation, X, Y, Z);
        ViewRotation = Rotation;
        DeltaRot.Yaw = int(PlayerInput.aTurn);
        DeltaRot.Pitch = int(PlayerInput.aLookUp);
        ProcessViewRotation(DeltaTime, ViewRotation, DeltaRot);
        SetRotation(ViewRotation);
        ViewShake(DeltaTime);
        // End:0x13A
        if(int(Role) < int(ROLE_Authority))
        {
            ReplicateMove(DeltaTime, vect(0.0000000, 0.0000000, 0.0000000), 0, rot(0, 0, 0));
        }
        bPressedJump = false;
        //return;        
    }

    function ShowScoreboard()
    {
        local UTGameReplicationInfo GRI;

        GRI = UTGameReplicationInfo(WorldInfo.GRI);
        // End:0xA1
        if(((GRI != none) && GRI.bMatchIsOver) && !GRI.bStoryMode)
        {
            ShowMidGameMenu('ScoreTab', true);            
        }
        else
        {
            // End:0xD0
            if(myHUD != none)
            {
                myHUD.SetShowScores(true);
            }
        }
        AutoContinueToNextRound();
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        local Pawn P;

        FOVAngle = DesiredFOV;
        bFire = 0;
        // End:0x57
        if(Pawn != none)
        {
            Pawn.TurnOff();
            StopFiring();
        }
        bFrozen = true;
        FindGoodView();
        SetTimer(5.0000000, false);
        // End:0xB1
        foreach DynamicActors(Class'Engine.Pawn', P)
        {
            P.TurnOff();            
        }        
        SetOnlyUseControllerTiltInput(false);
        SetUseTiltForwardAndBack(true);
        SetControllerTiltActive(false);
        // End:0x152
        if(EvilGame(WorldInfo.Game) != none)
        {
            SetTimer(FMax(GetTimerRate(), float(EvilGame(WorldInfo.Game).ResetTimeDelay)), false);
        }
        bAlreadyReset = false;
        // End:0x18E
        if(AdvHudWrapper != none)
        {
            AdvHudWrapper.bBlockScoreboard = true;
        }
        //return;        
    }

    function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        SetBehindView(false);
        StopViewShaking();
        StopCameraAnim(true);
        // End:0x83
        if(AdvHudWrapper != none)
        {
            AdvHudWrapper.bBlockScoreboard = false;
            myHUD.SetShowScores(false);
        }
        //return;        
    }
    stop;    
}

state Dead
{
    ignores Use, Jump;

    function BeginState(name PreviousStateName)
    {
        local UTWeaponLocker WL;
        local EvilWeaponPickupFactory WF;

        MinRespawnDelay = AdvGRI(WorldInfo.GRI).RespawnTime;
        super.BeginState(PreviousStateName);
        bFrozenCamera = true;
        // End:0xED
        if((class<AdvGameLastMenStandingBase>(WorldInfo.GetGameClass()) != none) && AdvGRI(WorldInfo.GRI).bMatchHasBegun)
        {
            ServerGoToState('Spectating');
            return;            
        }
        else
        {
            // End:0x18B
            if(((class<AdvGameSurvivalBase>(WorldInfo.GetGameClass()) != none) && AdvGRI(WorldInfo.GRI).bMatchHasBegun) && PreviousStateName != 'Spectating')
            {
                ServerGoToState('Spectating');
                return;
            }
        }
        bDisplayingTutorialMessage = false;
        LastAutoObjective = none;
        // End:0x1C5
        if(Pawn(ViewTarget) != none)
        {
            SetBehindView(true);
        }
        // End:0x29A
        if((Player != none) && LocalPlayer(Player) != none)
        {
            // End:0x243
            foreach WorldInfo.AllNavigationPoints(Class'EvilGame.UTWeaponLocker', WL)
            {
                WL.NotifyLocalPlayerDead(self);                
            }            
            // End:0x299
            foreach WorldInfo.AllNavigationPoints(Class'EvilGame.EvilWeaponPickupFactory', WF)
            {
                WF.NotifyLocalPlayerDead(self);                
            }            
        }
        // End:0x37C
        if(((int(Role) == int(ROLE_Authority)) && AdvGameMP_Base(WorldInfo.Game) != none) && AdvGameMP_Base(WorldInfo.Game).ForceRespawn() || PreviousStateName == 'Spectating')
        {
            // End:0x365
            if(PreviousStateName == 'Spectating')
            {
                SetTimer(0.1000000, false, 'DoForcedRespawn');                
            }
            else
            {
                SetTimer(MinRespawnDelay, false, 'DoForcedRespawn');
            }
        }
        RotationRate.Pitch = 0;
        RotationRate.Yaw = 0;
        RotationRate.Roll = 0;
        // End:0x45E
        if(AdvGRI(WorldInfo.GRI).bMatchHasBegun)
        {
            SetTimer(1.0000000, true, 'ShowRespawnCounter');
            SetTimer(MinRespawnDelay, false, 'ShowRespawnString');
            SetTimer(MinRespawnDelay + 10.0000000, false, 'ServerRestartPlayer');
        }
        GetPlayerHitEffects().StopPulseEffects();
        StopViewShaking();
        StopCameraAnim();
        //return;        
    }

    function FindGoodView()
    {
        local Vector CameraLoc;
        local Rotator CameraRot, ViewRotation, RealRotation;
        local int tries, besttry;
        local float bestDist, newdist, RealCameraScale;
        local int startYaw;
        local EvilPawn P;

        // End:0x61
        if(EvilVehicle_Base(ViewTarget) != none)
        {
            // End:0x53
            if(Pawn != none)
            {
                Pawn.SetDesiredRotation(Rotation);
            }
            bUsePhysicsRotation = true;
            return;
        }
        ViewRotation = Rotation;
        RealRotation = ViewRotation;
        ViewRotation.Pitch = 56000;
        SetRotation(ViewRotation);
        P = EvilPawn(ViewTarget);
        // End:0x145
        if(P != none)
        {
            RealCameraScale = P.CurrentCameraScale;
            P.CurrentCameraScale = P.CameraScale;
        }
        CalcViewActor = none;
        CameraLoc = ViewTarget.Location;
        GetPlayerViewPoint(CameraLoc, CameraRot);
        // End:0x412
        if(P != none)
        {
            newdist = VSize(CameraLoc - ViewTarget.Location);
            // End:0x3EA
            if(newdist < (P.CylinderComponent.CollisionRadius + P.CylinderComponent.CollisionHeight))
            {
                tries = 0;
                besttry = 0;
                bestDist = 0.0000000;
                startYaw = ViewRotation.Yaw;
                tries = 1;
                J0x2A4:

                // End:0x3B2 [Loop If]
                if(tries < 16)
                {
                    CalcViewActor = none;
                    CameraLoc = ViewTarget.Location;
                    ViewRotation.Yaw += 4096;
                    SetRotation(ViewRotation);
                    GetPlayerViewPoint(CameraLoc, CameraRot);
                    newdist = VSize(CameraLoc - ViewTarget.Location);
                    // End:0x3A4
                    if(newdist > bestDist)
                    {
                        bestDist = newdist;
                        besttry = tries;
                    }
                    tries++;
                    // [Loop Continue]
                    goto J0x2A4;
                }
                ViewRotation.Yaw = startYaw + (besttry * 4096);
            }
            P.CurrentCameraScale = RealCameraScale;
        }
        SetRotation(RealRotation);
        // End:0x493
        if(Pawn != none)
        {
            Pawn.SetDesiredRotation(MakeRotator(ViewRotation.Pitch, ViewRotation.Yaw, 0));
        }
        bUsePhysicsRotation = true;
        //return;        
    }

    exec function StartFire(optional byte FireModeNum)
    {
        // End:0x17
        if(int(FireModeNum) > int(0))
        {
            return;
        }
        // End:0x5F
        if(bFrozen)
        {
            // End:0x5D
            if(!IsTimerActive() || GetTimerCount() > MinRespawnDelay)
            {
                bFrozen = false;
            }
            return;
        }
        ServerRestartPlayer();
        //return;        
    }

    function ShowRespawnCounter()
    {
        // End:0xF3
        if(((!bDisplayingTutorialMessage && AdvHudWrapper != none) && AdvHudWrapper.HudMovie != none) && !AdvGRI(WorldInfo.GRI).bIsArmageddonTime)
        {
            AdvGFxHud(AdvHudWrapper.HudMovie).ShowTutorialMessage(string(FCeil(MinRespawnDelay - GetTimerCount('ShowRespawnString'))));
        }
        // End:0x10C
        if(bFrozenCamera)
        {
            bFrozenCamera = false;
        }
        //return;        
    }

    function ShowRespawnString()
    {
        local string LocKeyString;

        // End:0x2B
        if(IsTimerActive('ShowRespawnCounter'))
        {
            ClearTimer('ShowRespawnCounter');
        }
        // End:0x1C9
        if(((!bDisplayingTutorialMessage && AdvHudWrapper != none) && AdvHudWrapper.HudMovie != none) && !AdvGRI(WorldInfo.GRI).bIsArmageddonTime)
        {
            LocKeyString = "RespawnString";
            // End:0x110
            if(WorldInfo.IsConsoleBuild(1))
            {
                LocKeyString = LocKeyString $ "XBOX";                
            }
            else
            {
                // End:0x14E
                if(WorldInfo.IsConsoleBuild(2))
                {
                    LocKeyString = LocKeyString $ "PS3";
                }
            }
            AdvGFxHud(AdvHudWrapper.HudMovie).ShowTutorialMessage(Localize("AdvPlayerController", LocKeyString, "ADVGame"), true);
            bDisplayingTutorialMessage = true;
        }
        //return;        
    }

    simulated event EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        // End:0x2A
        if(IsTimerActive('ServerRestartPlayer'))
        {
        }
        ClearTimer('ServerRestartPlayer');
        // End:0xB0
        if((AdvHudWrapper != none) && AdvHudWrapper.HudMovie != none)
        {
            AdvGFxHud(AdvHudWrapper.HudMovie).HideTutorialMessage();
        }
        RotationRate = default.RotationRate;
        //return;        
    }

    function PlayerMove(float DeltaTime)
    {
        local Vector X, Y, Z;
        local Rotator DesiredRotation, DeltaRot, ViewRotation;

        // End:0xB8
        if(bFrozenCamera)
        {
            // End:0x52
            if(!IsZero(KillerLocation) && ViewTarget != none)
            {
                DesiredRotation = Rotator(KillerLocation - CalcViewLocation);                
            }
            else
            {
                DesiredRotation = Rotation;
                DesiredRotation.Pitch = -12000;
            }
            SetRotation(RInterpTo(Rotation, DesiredRotation, DeltaTime, 5.0000000));            
        }
        else
        {
            GetAxes(Rotation, X, Y, Z);
            ViewRotation = Rotation;
            DeltaRot.Yaw = int(PlayerInput.aTurn);
            DeltaRot.Pitch = int(PlayerInput.aLookUp);
            ProcessViewRotation(DeltaTime, ViewRotation, DeltaRot);
            SetRotation(ViewRotation);
            // End:0x1DF
            if(int(Role) < int(ROLE_Authority))
            {
                ReplicateMove(DeltaTime, vect(0.0000000, 0.0000000, 0.0000000), 0, rot(0, 0, 0));
            }
        }
        // End:0x227
        if(bFrozen && !IsTimerActive() || GetTimerCount() > MinRespawnDelay)
        {
            bFrozen = false;
        }
        ViewShake(DeltaTime);
        //return;        
    }
    stop;    
}

state QuadDamage extends PlayerWalking
{
    function PawnDied(Pawn inPawn)
    {
        global.PawnDied(inPawn);
        DisableQuadDamage();
        //return;        
    }
    stop;    
}

state ButtonTracingMP extends DefaultFOVOverride
{
    simulated function DrawHUD(HUD H)
    {
        super(AdvPlayerController).DrawHUD(H);
        PuzzleHudComponent.DrawHUD(H);
        //return;        
    }

    event BeginState(name PreviousStateName)
    {
        // End:0x2F
        if(PuzzleHudComponent == none)
        {
            PuzzleHudComponent = new (PuzzleHudComponent) Class'AdvPuzzleHudComponent';
        }
        PuzzleHudComponent.Init(myHUD, "_root.HUD.mc_cursor", true);
        PuzzleHudComponent.Cursor.SetVisible(false);
        bBlockFire = false;
        //return;        
    }

    function PlayerMove(float DeltaTime)
    {
        super(PlayerWalking).PlayerMove(DeltaTime);
        PuzzleHudComponent.PlayerMove(DeltaTime, PlayerInput, 0);
        //return;        
    }

    function Actor GetActorHit()
    {
        local Vector HitLocation, HitNormal, projStart, TraceEnd;
        local Rotator CameraRot;

        GetPlayerViewPoint(projStart, CameraRot);
        TraceEnd = projStart + (Normal(Vector(CameraRot)) * 200.0000000);
        return Pawn.Trace(HitLocation, HitNormal, TraceEnd, projStart, true, PuzzleHudComponent.Extent,, 1);
        //return ReturnValue;        
    }

    event PlayerTick(float DeltaTime)
    {
        local Actor ActorHit;

        global.PlayerTick(DeltaTime);
        ActorHit = GetActorHit();
        // End:0x82
        if(AdvConsoleObjectMPDLC1_base(ActorHit) != none)
        {
            PuzzleHudComponent.Cursor.GotoAndStopI(2);
            HideWeapons();            
        }
        else
        {
            // End:0xDD
            if(AdvConsoleObjectButtonMPDLC1_base(ActorHit) != none)
            {
                PuzzleHudComponent.Cursor.GotoAndStopI(4);
                HideWeapons();                
            }
            else
            {
                RestoreWeapons();
            }
        }
        //return;        
    }

    function HideWeapons()
    {
        local float HideTime;

        HideTime = 0.3000000;
        PuzzleHudComponent.Cursor.SetVisible(true);
        // End:0x179
        if(AdvWeap_Base(AdvPlayerPawn(Pawn).GetWeapon()) != none)
        {
            AdvWeap_Base(AdvPlayerPawn(Pawn).GetWeapon()).bDisplayCrosshair = false;
            // End:0x179
            if(!AdvWeap_Base(AdvPlayerPawn(Pawn).GetWeapon()).IsInState('QuickHide'))
            {
                AdvPlayerPawn(Pawn).QuickHideCurrentWeapon(false, HideTime, true);
                AdvPlayerPawn(Pawn).QuickHideCurrentWeapon(false, HideTime, false);
            }
        }
        bBlockFire = true;
        //return;        
    }

    function RestoreWeapons()
    {
        local float RestoreTime;

        RestoreTime = 0.1000000;
        PuzzleHudComponent.Cursor.SetVisible(false);
        // End:0x177
        if(AdvWeap_Base(AdvPlayerPawn(Pawn).GetWeapon()) != none)
        {
            AdvWeap_Base(AdvPlayerPawn(Pawn).GetWeapon()).bDisplayCrosshair = true;
            // End:0x177
            if(AdvWeap_Base(AdvPlayerPawn(Pawn).GetWeapon()).IsInState('QuickHide'))
            {
                AdvPlayerPawn(Pawn).EndQuickHideCurrentWeapon(false, RestoreTime, true);
                AdvPlayerPawn(Pawn).EndQuickHideCurrentWeapon(false, RestoreTime, false);
            }
        }
        bBlockFire = false;
        // End:0x1C5
        if(ConsoleObject != none)
        {
            ConsoleObject.ButtonUnclick(Pawn);
            ConsoleObject = none;
        }
        //return;        
    }

    exec function StartFire(optional byte FireModeNum)
    {
        local Actor ActorHit;

        // End:0x26
        if(!bBlockFire)
        {
            super(EvilPlayerController).StartFire(FireModeNum);            
        }
        else
        {
            ActorHit = GetActorHit();
            // End:0x129
            if(((int(FireModeNum) == int(0)) && AdvConsoleObjectButtonMPDLC1_base(ActorHit) != none) && !PlayerInput.bUsingGamepad)
            {
                ConsoleObject = AdvConsoleObjectButtonMPDLC1_base(ActorHit).ParentConsole;
                ConsoleObject.ButtonClick(Pawn, ActorHit);
                // End:0x129
                if(int(Role) < int(ROLE_Authority))
                {
                    ServerAdvConsoleButtonClick(ConsoleObject, Pawn, ActorHit);
                }
            }
        }
        //return;        
    }

    exec function StopFire(optional byte FireModeNum)
    {
        super(PlayerController).StopFire(FireModeNum);
        // End:0x43
        if((int(FireModeNum) == int(0)) && ConsoleObject != none)
        {
            ReleaseButton();
        }
        //return;        
    }

    function ReleaseButton()
    {
        // End:0x72
        if(ConsoleObject != none)
        {
            ConsoleObject.ButtonUnclick(Pawn);
            // End:0x67
            if(int(Role) < int(ROLE_Authority))
            {
                ServerAdvConsoleButtonUnclick(ConsoleObject, Pawn);
            }
            ConsoleObject = none;
        }
        //return;        
    }

    exec function Use()
    {
        local Actor ActorHit;

        // End:0xF9
        if(PlayerInput.bUsingGamepad)
        {
            ActorHit = GetActorHit();
            // End:0xEC
            if(AdvConsoleObjectButtonMPDLC1_base(ActorHit) != none)
            {
                ConsoleObject = AdvConsoleObjectButtonMPDLC1_base(ActorHit).ParentConsole;
                ConsoleObject.ButtonClick(Pawn, ActorHit);
                // End:0xE9
                if(int(Role) < int(ROLE_Authority))
                {
                    ServerAdvConsoleButtonClick(ConsoleObject, Pawn, ActorHit);
                }                
            }
            else
            {
                super(UTPlayerController).Use();
            }            
        }
        else
        {
            super(UTPlayerController).Use();
        }
        //return;        
    }

    exec function Input_A_Released()
    {
        // End:0x19
        if(ConsoleObject != none)
        {
            ReleaseButton();
        }
        //return;        
    }

    event EndState(name NextStateName)
    {
        AdvWeap_Base(AdvPlayerPawn(Pawn).GetWeapon()).ClearTimer('DoneQuickHide');
        // End:0xD0
        if(AdvPlayerPawn(Pawn).GetWeaponLeft() != none)
        {
            AdvWeap_Base(AdvPlayerPawn(Pawn).GetWeaponLeft()).ClearTimer('DoneQuickHide');
        }
        RestoreWeapons();
        super(PlayerWalking).EndState(NextStateName);
        //return;        
    }

    function bool IsThereOtherReasonToLetUseHold()
    {
        local Actor ActorHit;
        local bool Result;

        Result = global.IsThereOtherReasonToLetUseHold();
        ActorHit = GetActorHit();
        // End:0x4D
        if(AdvConsoleObjectButtonMPDLC1_base(ActorHit) != none)
        {
            Result = true;
        }
        return Result;
        //return ReturnValue;        
    }
    stop;    
}

defaultproperties
{
    EndScreenDuration=13.0000000
    bFirstSpawn=true
    bLMSCameraTPPMode=true
    bChoseCustomClassesOnly=true
    SurvivalScoreModifier=1.0000000
    LevelUpSound=SoundCue'a_Accents.Cue.a_BossFightAccentIn'
    UpgradeSound=SoundCue'a_Accents.Cue.a_WeaponLevelUp'
    WayPointSuccess=SoundCue'a_Accents.Cue.a_MPSignal_01'
    WayPointFailure=SoundCue'a_Accents.Cue.a_MPSignal_02'
    EndSurvivalWaveMessage="Wave survived! (*`s)"
    ClassChangedMessage="Your class will be changed after next spawn"
    BonusTrapKillMsg="Trap Bonus!"
    ComboKillMsg="Combo Kill!"
    ComboKillMaxInterval=1.5000000
    // Reference: AudioComponent'Default__AdvPlayerControllerMP.Music01Comp'
    begin object name=Music01Comp class=Class'Engine.AudioComponent'
        SoundCue=SoundCue'a_Accents.Cue.a_PlayerStunLoop'
    end object
    ArmageddonHeartBeat=Music01Comp
    // Reference: AudioComponent'Default__AdvPlayerControllerMP.Music02Comp'
    begin object name=Music02Comp class=Class'Engine.AudioComponent'
    end object
    PerkActivationMusic=Music02Comp
    TimeToRescueLMS=30.0000000
    TimeToRescueSurvival=30.0000000
    SecondChanceBlessingTime=7.0000000
    LastMenStandingTimer="LastMenStandingTimer"
    SurvivalDevastatorModeTime=30
    SurvivalMummyModeTime=45
    HighlightComponentClass=Class'AdvFocusHighlightComponent_Survival'
    // Reference: EvilSceneCaptureHighlightComponent'Default__AdvPlayerControllerMP.HighlightComponent'
    begin object name=HighlightComponent
    end object
    HighlightSceneCaptureComponent=HighlightComponent
    // Reference: ForceFeedbackWaveform'Default__AdvPlayerControllerMP.ForceFeedbackWaveform7'
    begin object name=ForceFeedbackWaveform7
    end object
    CameraShakeShortWaveForm=ForceFeedbackWaveform7
    // Reference: ForceFeedbackWaveform'Default__AdvPlayerControllerMP.ForceFeedbackWaveform8'
    begin object name=ForceFeedbackWaveform8
    end object
    CameraShakeLongWaveForm=ForceFeedbackWaveform8
    OnFootDefaultFOV=85.0000000
    FOVAngle=85.0000000
    DesiredFOV=85.0000000
    DefaultFOV=85.0000000
    // Reference: CylinderComponent'Default__AdvPlayerControllerMP.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Components[1]=HighlightComponent
    CollisionComponent=CollisionCylinder
}