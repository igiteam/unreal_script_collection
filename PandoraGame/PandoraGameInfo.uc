class PandoraGameInfo extends GameInfo
    abstract
    native
    config(Game);

enum EGameDifficulty
{
    EDifficulty_Easy,               // 0
    EDifficulty_Normal,             // 1
    EDifficulty_Hard,               // 2
    EDifficulty_MAX                 // 3
};

enum EMessage_Type
{
    EMessage_UnKnown,               // 0
    EMessage_Objective,             // 1
    EMessage_Creature,              // 2
    EMessage_Equip,                 // 3
    EMessage_Contact,               // 4
    EMessage_Weapon,                // 5
    EMessage_Critical,              // 6
    EMessage_New,                   // 7
    EMessage_Pickup,                // 8
    EMessage_All,                   // 9
    EMessage_Max                    // 10
};

enum ESPMultiplayerTeam
{
    MPTEAM_UNKNOWN,                 // 0
    MPTEAM_TEAM1,                   // 1
    MPTEAM_TEAM2,                   // 2
    MPTEAM_WEREWOLF,                // 3
    MPTEAM_MAXIMUS,                 // 4
    MPTEAM_MAX                      // 5
};

struct native TeamSpawnInfo
{
    var class<SPTeamInfo> teamClass;

    structdefaultproperties
    {
        teamClass=none
    }
};

struct native ThirdPersonWeaponSounds
{
    var SoundCue FireSound;
    var SoundCue FireEndSound;

    structdefaultproperties
    {
        FireSound=none
        FireEndSound=none
    }
};

struct native SeekfreeWeaponInfo
{
    var string WeaponName;
    var string PackageName;
    var string SFPackageName;

    structdefaultproperties
    {
        WeaponName=""
        PackageName=""
        SFPackageName=""
    }
};

struct native PDAMessage
{
    var const localized string Subject;
    var string UISceneName;
    var PandoraGameInfo.EMessage_Type eMsgType;
    var bool bUnlocked;
    var bool bViewed;
    var bool bCritical;
    var int EpisodeNo;
    var int MsgId;

    structdefaultproperties
    {
        Subject=""
        UISceneName=""
        eMsgType=EMessage_UnKnown
        bUnlocked=false
        bViewed=false
        bCritical=false
        EpisodeNo=0
        MsgId=-1
    }
};

struct native ScreenShakeScaling
{
    var() float LocAmplitudeScale;
    var() float LocFrequencyScale;
    var() float RotAmplitudeScale;
    var() float RotFrequencyScale;
    var() float FOVAmplitudeScale;
    var() float FOVFrequencyScale;

    structdefaultproperties
    {
        LocAmplitudeScale=1.0000000
        LocFrequencyScale=1.0000000
        RotAmplitudeScale=1.0000000
        RotFrequencyScale=1.0000000
        FOVAmplitudeScale=1.0000000
        FOVFrequencyScale=1.0000000
    }
};

struct native PDAAsyncPackageCBData
{
    var int Id;
    var Object PackageOwner;
    var string UISceneName;
    var UIScene LoadedScene;
    var delegate<OnPDAPackageLoadAsync> OnPackageLoadCBDelegate;

    structdefaultproperties
    {
        Id=-1
        PackageOwner=none
        UISceneName=""
        LoadedScene=none
        OnPackageLoadCBDelegate=None
    }
};

struct native DroppedWeaponLimit
{
    var name m_WeapId;
    var int m_max;
    var array<DroppedPickup> m_pickup;

    structdefaultproperties
    {
        m_WeapId="None"
        m_max=0
        m_pickup=none
    }
};

var array<SPTeamInfo> m_teams;
var SeqAct_SpBarphFactory ActiveBarph;
var SPTackleMinigameManager ActiveSPTackleMinigameManager;
var SPBloodTickManager ActiveSPBloodTickManager;
var SPFireManager ActiveFireManager;
var SPFoodManager ActiveFoodManager;
var SPSlomoManager ActiveSlomoManager;
var SPTuneManager ActiveTuneManager;
var deprecated SPWeaponTuneManager ActiveWeaponTuneManager;
var SPMiniGameManager ActiveMiniGameManager;
var SPGriffonAttackPointManager ActiveAttackPointManager;
var const float HitUnitsPerVelocityUnit;
var transient SPVolumePathNodeDestructibleSpawner SPVolumePathNodeDestructibleSpawnerList;
var int nDeadBodies;
var AnimusManager AnimusMgr;
var PlayerReplicationInfo winningPlayerReplicationInfo;
var config bool bUseMPTuneData;
var bool bLanMatch;
var bool bUsesArbitration;
var config bool bUseConsoleController;
var bool bIsReadyToEnd;
var transient bool bWeaponThrowInProgress;
var config PandoraGameInfo.EGameDifficulty currGameDifficulty;
var array<PDAAsyncPackageCBData> PDAAsyncPackageCBList;
var int UnlockedObjectiveMsgIndex;
var int UnlockedCreatureMsgIndex;
var int UnlockedEquipmentMsgIndex;
var int UnlockedPeopleMsgIndex;
var int UnlockedPickupMsgIndex;
var globalconfig array<config PDAMessage> PDAObjectiveMessages;
var globalconfig array<config PDAMessage> PDACreatureMessages;
var globalconfig array<config PDAMessage> PDAEquipmentMessages;
var globalconfig array<config PDAMessage> PDAPeopleMessages;
var globalconfig array<config PDAMessage> PDAPickupMessages;
var globalconfig array<config SeekfreeWeaponInfo> SFWeaponPackageInfo;
var native transient array<PDAMessage> UnlockedPDAMessages;
var int PDACreatureMessageUnlockedCount;
var int PDAEquipmentMessageUnlockedCount;
var int PDAObjectiveMessageUnlockedCount;
var int PDAPeopleMessageUnlockedCount;
var int PDAPickedupMessageCount;
var transient int MP_MapId;
var int MinRankedPlayers;
var int MinPlayers;
var class<PlayerController> ConsolePlayerControllerClass;
var SPAIVisibilityManager AIVisibilityManager;
var UIScene TutorialScene;
var transient ScreenShakeScaling globalScreenShakeScaling;
var array<PlayerController> ClientMovieCompleteArray;
var transient int TotalPDAPickupMessages;
var init transient array<init DroppedWeaponLimit> m_droppedWeaponPickups;
var config int amBXAmbientFadeTime;
var config int amBXAmbientLightUpdateIntervalMS;
var config float amBXAmbientLightUpdateRatio;
var config float amBXShadowColorRangeMin;
var config float amBXShadowColorRangeMax;
var config float amBXShadowColorScaleFactor;
//var delegate<OnPDAPackageLoadAsync> __OnPDAPackageLoadAsync__Delegate;

delegate OnPDAPackageLoadAsync(PDAAsyncPackageCBData CBData)
{
    //return;    
}

// Export UPandoraGameInfo::execLoadCurrPDAUIScene(FFrame&, void* const)
native function bool LoadCurrPDAUIScene(Object PackageOwner, string UISceneName, delegate<OnPDAPackageLoadAsync> OnPackageLoadCBDelegate);

// Export UPandoraGameInfo::execGetGameDifficulty(FFrame&, void* const)
native static function PandoraGameInfo.EGameDifficulty GetGameDifficulty();

// Export UPandoraGameInfo::execGetPersistentLevelName(FFrame&, void* const)
native function string GetPersistentLevelName();

// Export UPandoraGameInfo::execGetLastURL(FFrame&, void* const)
native function URL GetLastURL();

// Export UPandoraGameInfo::execLoadSeekFreeWeaponClass(FFrame&, void* const)
native function Class LoadSeekFreeWeaponClass(string WeaponName, optional bool SkipGC);

// Export UPandoraGameInfo::execTryCreateSlotForTossedWeapon(FFrame&, void* const)
native function bool TryCreateSlotForTossedWeapon(name m_WeapId, Vector NewLocation);

// Export UPandoraGameInfo::execNotifyDroppedPickupCreated(FFrame&, void* const)
native function NotifyDroppedPickupCreated(DroppedPickup Pickup);

// Export UPandoraGameInfo::execNotifyDroppedPickupDestroyed(FFrame&, void* const)
native function NotifyDroppedPickupDestroyed(DroppedPickup Pickup);

// Export UPandoraGameInfo::execClearDroppedWeaponRefs(FFrame&, void* const)
native function ClearDroppedWeaponRefs();

// Export UPandoraGameInfo::execCloseSPAILog(FFrame&, void* const)
native function CloseSPAILog();

// Export UPandoraGameInfo::execInitializeKynapse(FFrame&, void* const)
native function InitializeKynapse();

// Export UPandoraGameInfo::execInitGlobals(FFrame&, void* const)
native function InitGlobals();

// Export UPandoraGameInfo::execGetPDAObjectiveMessageUnlockState(FFrame&, void* const)
native function bool GetPDAObjectiveMessageUnlockState(int MsgId);

// Export UPandoraGameInfo::execGetPDAEquipmentMessageUnlockState(FFrame&, void* const)
native function bool GetPDAEquipmentMessageUnlockState(int MsgId);

// Export UPandoraGameInfo::execGetPDACreatureMessageUnlockState(FFrame&, void* const)
native function bool GetPDACreatureMessageUnlockState(int MsgId);

// Export UPandoraGameInfo::execGetPDAPeopleMessageUnlockState(FFrame&, void* const)
native function bool GetPDAPeopleMessageUnlockState(int MsgId);

// Export UPandoraGameInfo::execGetPDAPickupMessageUnlockState(FFrame&, void* const)
native function bool GetPDAPickupMessageUnlockState(int MsgId);

// Export UPandoraGameInfo::execGetComputerName(FFrame&, void* const)
native static final simulated function string GetComputerName();

// Export UPandoraGameInfo::execamBXSetAllFadeTime(FFrame&, void* const)
native function amBXSetAllFadeTime(int ms);

// Export UPandoraGameInfo::execamBXSetAllLightUpdateProperties(FFrame&, void* const)
native function amBXSetAllLightUpdateProperties(int LightUpdateIntervalMS, float LightUpdateRatio);

// Export UPandoraGameInfo::execamBXSetShadowColorRange(FFrame&, void* const)
native function amBXSetShadowColorRange(float ShadowColorRangeMin, float ShadowColorRangeMax);

// Export UPandoraGameInfo::execamBXSetShadowColorScaleFactor(FFrame&, void* const)
native function amBXSetShadowColorScaleFactor(float ShadowColorScaleFactor);

function bool AllowCheats(PlayerController P)
{
    return int(WorldInfo.NetMode) == int(NM_Standalone);
    //return ReturnValue;    
}

function SetMaxForTossedWeapons()
{
    ClearDroppedWeaponRefs();
    m_droppedWeaponPickups.Length = 0;
    m_droppedWeaponPickups.Add(5);
    m_droppedWeaponPickups[0].m_max = Class'SPTuneManager'.default.Difficulty.GameplayGD.MaxDroppedShotgun;
    m_droppedWeaponPickups[0].m_WeapId = 'shotgun';
    m_droppedWeaponPickups[0].m_pickup.Length = 0;
    m_droppedWeaponPickups[1].m_max = Class'SPTuneManager'.default.Difficulty.GameplayGD.MaxDroppedSMG;
    m_droppedWeaponPickups[1].m_WeapId = 'HK_UMP';
    m_droppedWeaponPickups[1].m_pickup.Length = 0;
    m_droppedWeaponPickups[2].m_max = Class'SPTuneManager'.default.Difficulty.GameplayGD.MaxDroppedAssaultRifle;
    m_droppedWeaponPickups[2].m_WeapId = 'AssaultRifle';
    m_droppedWeaponPickups[2].m_pickup.Length = 0;
    m_droppedWeaponPickups[3].m_max = Class'SPTuneManager'.default.Difficulty.GameplayGD.MaxDroppedSAW;
    m_droppedWeaponPickups[3].m_WeapId = 'Saw';
    m_droppedWeaponPickups[3].m_pickup.Length = 0;
    m_droppedWeaponPickups[4].m_max = Class'SPTuneManager'.default.Difficulty.GameplayGD.MaxDroppedFlamethrower;
    m_droppedWeaponPickups[4].m_WeapId = 'Flame';
    m_droppedWeaponPickups[4].m_pickup.Length = 0;
    //return;    
}

function int GetServerControllerId()
{
    local PandoraPlayerController PC;

    // End:0x34
    foreach LocalPlayerControllers(Class'PandoraPlayerController', PC)
    {        
        return LocalPlayer(PC.Player).ControllerId;        
    }    
    //return ReturnValue;    
}

event PreCommitMapChange(string PreviousMapName, string NextMapName)
{
    local PandoraPlayerController PC;

    // End:0xD8
    foreach LocalPlayerControllers(Class'PandoraPlayerController', PC)
    {
        PC.UnifiedPreTransitionCleanup();
        // End:0xC2
        if(PC.Pawn.IsInState('Dying') || PC.Pawn.Health <= 1)
        {
            PC.GotoState('Idle');
            PC.Pawn.GotoState('Idle');
            PC.Pawn.Health = 50;
        }
        PC.bGodMode = true;
        // End:0xD8
        break;        
    }    
    ClearDroppedWeaponRefs();
    super.PreCommitMapChange(PreviousMapName, NextMapName);
    //return;    
}

event StagedCommitMapChangePostGC()
{
    local PandoraPlayerController PC;

    // End:0x57
    foreach LocalPlayerControllers(Class'PandoraPlayerController', PC)
    {
        SPPawn(PC.Pawn).DoToggleTargettable(true);
        PC.Pawn.bDeleteOnDetach = false;
        // End:0x57
        break;        
    }    
    Class'SeqAct_SPAniformControlDeviceClearAll'.static.ClearAll();
    CleanupTeams();
    super.StagedCommitMapChangePostGC();
    //return;    
}

function PostCommitMapChange()
{
    local PandoraPlayerController PC;

    // End:0x148
    foreach WorldInfo.AllControllers(Class'PandoraPlayerController', PC)
    {
        ApplyCheckpointLoadout(PC);
        // End:0xC7
        if(PC.Pawn.IsInState('Dying') || PC.Pawn.Health <= 1)
        {
            PC.GotoState('Idle');
            PC.Pawn.GotoState('Idle');
            PC.Pawn.Health = 50;
        }
        PC.bGodMode = false;
        PC.m_bOKToSaveCheckpoints = true;
        PC.PostCommitConditionalSave();
        PC.UnifiedPostTransitionCleanup();
        PC.ProfileSettings.SetProfileDirty(true);
        PC.WriteProfile();        
    }    
    super.PostCommitMapChange();
    //return;    
}

final event CleanupTeams()
{
    local SPSquad defaultSquad, currentSquad;
    local int defaultSquadIndex;
    local SPTeamInfo currentTeam;
    local int I, Idx;

    Idx = 0;
    J0x07:

    // End:0x109 [Loop If]
    if(Idx < m_teams.Length)
    {
        currentTeam = m_teams[Idx];
        // End:0xFF
        if((currentTeam != none) && !currentTeam.bDeleteMe)
        {
            currentTeam.ClearFriendlyTeams();
            defaultSquad = currentTeam.GetSquadByName('Default', defaultSquadIndex, true);
            I = 0;
            J0x8A:

            // End:0xFF [Loop If]
            if(I < currentTeam.m_squads.Length)
            {
                currentSquad = currentTeam.m_squads[I];
                // End:0xF5
                if((currentSquad != none) && currentSquad != defaultSquad)
                {
                    currentTeam.RemoveSquad(currentSquad, false);
                }
                I++;
                // [Loop Continue]
                goto J0x8A;
            }
        }
        Idx++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function ResetScreenShakeScaling()
{
    globalScreenShakeScaling.LocAmplitudeScale = 1.0000000;
    globalScreenShakeScaling.LocFrequencyScale = 1.0000000;
    globalScreenShakeScaling.RotAmplitudeScale = 1.0000000;
    globalScreenShakeScaling.RotFrequencyScale = 1.0000000;
    globalScreenShakeScaling.FOVAmplitudeScale = 1.0000000;
    globalScreenShakeScaling.FOVFrequencyScale = 1.0000000;
    //return;    
}

function SetScreenShakeScaling(ScreenShakeScaling inScales)
{
    globalScreenShakeScaling = inScales;
    //return;    
}

function GetScreenShakeScaling(out ScreenShakeScaling outScales)
{
    outScales = globalScreenShakeScaling;
    //return;    
}

function NotifyKilled(Controller Killer, Controller Killed, Pawn KilledPawn)
{
    local int Idx;

    super.NotifyKilled(Killer, Killed, KilledPawn);
    Idx = 0;
    J0x1C:

    // End:0x70 [Loop If]
    if(Idx < m_teams.Length)
    {
        // End:0x66
        if(m_teams[Idx] != none)
        {
            m_teams[Idx].NotifyKilled(Killer, Killed, KilledPawn);
        }
        Idx++;
        // [Loop Continue]
        goto J0x1C;
    }
    //return;    
}

function LocalPlayerDeath(PandoraPlayerController Controller)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x1D [Loop If]
    if(I < 30)
    {
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    // DebugMode: 0
    assert(false);
    //return;    
}

static simulated event class<DamageType> GetRigidBodyDamageType()
{
    return Class'SPDamageTypeRigidBody';
    //return ReturnValue;    
}

exec function SpawnTestPlayers()
{
    local int I, RedTeamSize, BlueTeamSize;

    RedTeamSize = m_teams[1].Size;
    BlueTeamSize = m_teams[2].Size;
    I = 0;
    J0x36:

    // End:0x5E [Loop If]
    if(I < (4 - RedTeamSize))
    {
        AddTestPlayer(1);
        I++;
        // [Loop Continue]
        goto J0x36;
    }
    I = 0;
    J0x65:

    // End:0x8E [Loop If]
    if(I < (4 - BlueTeamSize))
    {
        AddTestPlayer(2);
        I++;
        // [Loop Continue]
        goto J0x65;
    }
    //return;    
}

function PandoraPlayerController AddTestPlayer(int TeamIndex)
{
    local PandoraPlayerController NewTestPlayer;

    NewTestPlayer = SpawnTestPlayer(TeamIndex);
    // End:0x22
    if(NewTestPlayer == none)
    {
        return none;
    }
    NewTestPlayer.PlayerReplicationInfo.PlayerID = CurrentID++;
    // End:0xCB
    if(((NewTestPlayer.PlayerReplicationInfo.PlayerID * 10) / 2) == ((NewTestPlayer.PlayerReplicationInfo.PlayerID / 2) * 10))
    {
        ChangeName(NewTestPlayer, string(NewTestPlayer.PlayerReplicationInfo.PlayerID) $ "WWWWWWWWWWWWWWW", false);        
    }
    else
    {
        ChangeName(NewTestPlayer, string(NewTestPlayer.PlayerReplicationInfo.PlayerID) $ "W123456789012345", false);
    }
    ChangeTeam(NewTestPlayer, TeamIndex, false);
    NewTestPlayer.PlayerReplicationInfo.bReadyToPlay = true;
    return NewTestPlayer;
    //return ReturnValue;    
}

function PandoraPlayerController SpawnTestPlayer(int TeamIndex)
{
    local NavigationPoint StartSpot;
    local TestPlayerController NewTestPlayer;
    local Rotator SpawnRotation;

    StartSpot = FindPlayerStart(none, byte(TeamIndex), "Yo");
    // End:0x29
    if(StartSpot == none)
    {
        return none;
    }
    SpawnRotation.Yaw = StartSpot.Rotation.Yaw;
    NewTestPlayer = Spawn(Class'TestPlayerController',,, StartSpot.Location, SpawnRotation);
    // End:0x8C
    if(NewTestPlayer == none)
    {
        return none;
    }
    NewTestPlayer.StartSpot = StartSpot;
    return NewTestPlayer;
    //return ReturnValue;    
}

event GameEnding()
{
    KillTestPlayers();
    super.GameEnding();
    //return;    
}

exec function KillTestPlayers()
{
    local TestPlayerController PC;

    // End:0x2D
    foreach WorldInfo.AllControllers(Class'TestPlayerController', PC)
    {
        KillTestPlayer(PC);        
    }    
    //return;    
}

function KillTestPlayer(TestPlayerController PC)
{
    // End:0x0D
    if(PC == none)
    {
        return;
    }
    // End:0x4F
    if(PC.Pawn != none)
    {
        PC.Pawn.KilledBy(PC.Pawn);
    }
    // End:0x67
    if(PC != none)
    {
        PC.Destroy();
    }
    //return;    
}

event InitGame(string Options, out string ErrorMessage)
{
    CloseSPAILog();
    // End:0x1E
    if(bUseConsoleController)
    {
        PlayerControllerClass = ConsolePlayerControllerClass;
    }
    InitializeKynapse();
    InitGlobals();
    amBXSetAllFadeTime(amBXAmbientFadeTime);
    amBXSetAllLightUpdateProperties(amBXAmbientLightUpdateIntervalMS, amBXAmbientLightUpdateRatio);
    amBXSetShadowColorRange(amBXShadowColorRangeMin, amBXShadowColorRangeMax);
    amBXSetShadowColorScaleFactor(amBXShadowColorScaleFactor);
    super.InitGame(Options, ErrorMessage);
    UnlockedPDAMessages[0] = PDAObjectiveMessages[0];
    //return;    
}

event PreBeginPlay()
{
    super.PreBeginPlay();
    AnimusMgr = Spawn(Class'AnimusManager', self);
    AIVisibilityManager = new (self) Class'SPAIVisibilityManager';
    InitGlobals();
    //return;    
}

function PlayerStart ChoosePlayerStart(Controller Player, optional byte InTeam)
{
    local PlayerStart thePlayerStart;

    thePlayerStart = super.ChoosePlayerStart(Player, InTeam);
    return thePlayerStart;
    //return ReturnValue;    
}

function bool IsMPGameMode()
{
    return false;
    //return ReturnValue;    
}

function float RatePlayerStart(PlayerStart P, byte Team, Controller Player)
{
    local float Result;

    // End:0x1F
    if(!IsValidStartSpot(P, Result))
    {
        return -1.0000000;
    }
    Result += super.RatePlayerStart(P, Team, Player);
    Result = float(Rand(int(Result)));
    return Result;
    //return ReturnValue;    
}

function bool IsValidStartSpot(NavigationPoint Nav, out float Value)
{
    local Controller checkPlayer;
    local float Dist, bestDist;

    bestDist = 100000.0000000;
    Dist = 0.0000000;
    Value = 0.0000000;
    // End:0x123
    foreach WorldInfo.AllControllers(Class'Engine.Controller', checkPlayer)
    {
        // End:0x65
        if(bWaitingToStartMatch && checkPlayer.StartSpot == Nav)
        {            
            return false;
        }
        // End:0x122
        if(checkPlayer.Pawn != none)
        {
            Dist = VSize(checkPlayer.Pawn.Location - Nav.Location);
            // End:0x108
            if(Dist < (2.0000000 * (checkPlayer.Pawn.CylinderComponent.CollisionRadius + checkPlayer.Pawn.CylinderComponent.CollisionHeight)))
            {                
                return false;
            }
            // End:0x122
            if(Dist < bestDist)
            {
                bestDist = Dist;
            }
        }        
    }    
    // End:0x141
    if(bestDist < 100000.0000000)
    {
        Value = bestDist;        
    }
    return true;
    //return ReturnValue;    
}

static event class<GameInfo> SetGameType(string MapName, string Options, string Portal)
{
    return super.SetGameType(MapName, Options, Portal);
    //return ReturnValue;    
}

exec function GameRestart()
{
    RestartGame();
    //return;    
}

function RestartPlayer(Controller NewPlayer)
{
    super.RestartPlayer(NewPlayer);
    //return;    
}

event RestartFromCheckpoint(PandoraPlayerController NewPlayer)
{
    local LocalPlayer LocPlayer;

    // End:0x27
    if(NewPlayer.Pawn == none)
    {
        RestartPlayer(NewPlayer);        
    }
    else
    {
        NewPlayer.Restart(false);
    }
    ApplyCheckpointLoadout(NewPlayer);
    LocPlayer = LocalPlayer(NewPlayer.Player);
    // End:0x84
    if(LocPlayer != none)
    {
        LocPlayer.ClearPostProcessSettingsOverride();
    }
    //return;    
}

function ApplyCheckpointLoadout(PandoraPlayerController PC)
{
    local int Idx;
    local class<Inventory> InvClass;
    local Inventory Inv;
    local PlayerPawn PP;
    local SPWeapon spw;
    local SPInventoryManager spInvManager;
    local string WeaponName;

    // End:0x3D5
    if(PC.CKP_Loadout.bIsValid)
    {
        PP = PlayerPawn(PC.Pawn);
        // End:0x88
        if((PP == none) && Vehicle(PC.Pawn) != none)
        {
            PP = PlayerPawn(Vehicle(PC.Pawn).Driver);
        }
        // End:0x3D5
        if(PP != none)
        {
            spInvManager = SPInventoryManager(PP.InvManager);
            PP.InvManager.DiscardInventory();
            Idx = 0;
            J0xD2:

            // End:0x25B [Loop If]
            if(Idx < PC.CKP_Loadout.WeaponNames.Length)
            {
                InvClass = class<Inventory>(FindObject(PC.CKP_Loadout.WeaponNames[Idx], Class'Core.Class'));
                // End:0x193
                if(InvClass == none)
                {
                    WeaponName = Repl(PC.CKP_Loadout.WeaponNames[Idx], "PandoraGameContent.", "");
                    InvClass = class<Inventory>(LoadSeekFreeWeaponClass(WeaponName));
                }
                // End:0x1E6
                if(InvClass != none)
                {
                    Inv = PP.InvManager.CreateInventory(InvClass);
                    // End:0x1E3
                    if(Inv != none)
                    {
                        spw = SPWeapon(Inv);
                    }                    
                }
                // End:0x251
                if(spw != none)
                {
                    spw.AmmoCount = PC.CKP_Loadout.WeaponAmmoSpares[Idx];
                    spw.ammoInMagazine = PC.CKP_Loadout.WeaponAmmoUsed[Idx];
                }
                Idx++;
                // [Loop Continue]
                goto J0xD2;
            }
            // End:0x3B8
            if(spInvManager != none)
            {
                Idx = 0;
                J0x26D:

                // End:0x3B8 [Loop If]
                if(Idx < PC.CKP_Loadout.GrenadeAmmos.Length)
                {
                    spInvManager.SetGrenadeAmmo(Idx, PC.CKP_Loadout.GrenadeAmmos[Idx]);
                    // End:0x3AE
                    if(int(spInvManager.curGrenadeType) == int(spInvManager.4))
                    {
                        // End:0x3AE
                        if(PC.CKP_Loadout.GrenadeAmmos[Idx] > 0)
                        {
                            switch(Idx)
                            {
                                // End:0x340
                                case 0:
                                    spInvManager.curGrenadeType = spInvManager.0;
                                    // End:0x3AE
                                    break;
                                // End:0x363
                                case 1:
                                    spInvManager.curGrenadeType = spInvManager.1;
                                    // End:0x3AE
                                    break;
                                // End:0x387
                                case 2:
                                    spInvManager.curGrenadeType = spInvManager.2;
                                    // End:0x3AE
                                    break;
                                // End:0x3AB
                                case 4:
                                    spInvManager.curGrenadeType = spInvManager.3;
                                    // End:0x3AE
                                    break;
                                // End:0xFFFF
                                default:
                                    break;
                            }
                        }
                        else
                        {
                        }/* !MISMATCHING REMOVE, tried If got Type:Else Position:0x3AE! */
                        Idx++;
                        // [Loop Continue]
                        goto J0x26D;
                    }/* !MISMATCHING REMOVE, tried Loop got Type:If Position:0x2CB! */
                }/* !MISMATCHING REMOVE, tried If got Type:Loop Position:0x26D! */
                PC.CKP_Loadout.bIsValid = false;
            }
        }
        //return;        
    }/* !MISMATCHING REMOVE, tried Else got Type:If Position:0x000! */
}

function LoadWeaponPacks(PandoraPlayerController PC)
{
    local int Idx;
    local string WeaponName;

    Idx = 0;
    J0x07:

    // End:0x123 [Loop If]
    if(Idx < PC.CKP_Loadout.WeaponNames.Length)
    {
        PC.CKP_Loadout.WeaponInvClass[Idx] = class<Inventory>(FindObject(PC.CKP_Loadout.WeaponNames[Idx], Class'Core.Class'));
        // End:0x119
        if(PC.CKP_Loadout.WeaponInvClass[Idx] == none)
        {
            WeaponName = Repl(PC.CKP_Loadout.WeaponNames[Idx], "PandoraGameContent.", "");
            PC.CKP_Loadout.WeaponInvClass[Idx] = class<Inventory>(LoadSeekFreeWeaponClass(WeaponName, true));
        }
        Idx++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function CleanupBeforeCheckpointTransition()
{
    local PandoraPlayerController PC;
    local SPPawn P;
    local bool bHasKilledAI;

    // End:0x45
    foreach WorldInfo.AllControllers(Class'PandoraPlayerController', PC)
    {
        // End:0x30
        if(!bHasKilledAI)
        {
            bHasKilledAI = true;
        }
        PC.PlayerCleanupBeforeCheckpointOrTransition();        
    }    
    // End:0x73
    foreach WorldInfo.AllPawns(Class'SPPawn', P)
    {
        P.Destroy();        
    }    
    // End:0xF2
    foreach WorldInfo.AllControllers(Class'PandoraPlayerController', PC)
    {
        // End:0xCE
        if(PC.Pawn != none)
        {
            PC.Pawn.Destroy();
            PC.Pawn = none;
        }
        PandoraPlayerCamera(PC.PlayerCamera).Reset();        
    }    
    // End:0x111
    foreach WorldInfo.AllControllers(Class'PandoraPlayerController', PC)
    {        
    }    
    StartHumans();
    //return;    
}

function PostBeginPlay()
{
    local int I;

    super.PostBeginPlay();
    TotalPDAPickupMessages = 0;
    I = 0;
    J0x14:

    // End:0x4A [Loop If]
    if(I < PDAObjectiveMessages.Length)
    {
        PDAObjectiveMessages[I].MsgId = I;
        I++;
        // [Loop Continue]
        goto J0x14;
    }
    I = 0;
    J0x51:

    // End:0x87 [Loop If]
    if(I < PDACreatureMessages.Length)
    {
        PDACreatureMessages[I].MsgId = I;
        I++;
        // [Loop Continue]
        goto J0x51;
    }
    I = 0;
    J0x8E:

    // End:0xC4 [Loop If]
    if(I < PDAEquipmentMessages.Length)
    {
        PDAEquipmentMessages[I].MsgId = I;
        I++;
        // [Loop Continue]
        goto J0x8E;
    }
    I = 0;
    J0xCB:

    // End:0x101 [Loop If]
    if(I < PDAPeopleMessages.Length)
    {
        PDAPeopleMessages[I].MsgId = I;
        I++;
        // [Loop Continue]
        goto J0xCB;
    }
    I = 0;
    J0x108:

    // End:0x13E [Loop If]
    if(I < PDAPickupMessages.Length)
    {
        PDAPickupMessages[I].MsgId = I;
        I++;
        // [Loop Continue]
        goto J0x108;
    }
    TotalPDAPickupMessages += PDAPickupMessages.Length;
    SetMaxForTossedWeapons();
    //return;    
}

function SetPlayerDefaults(Pawn thePawn)
{
    local PlayerPawn thePlayerPawn;

    super.SetPlayerDefaults(thePawn);
    thePlayerPawn = PlayerPawn(thePawn);
    // End:0x3A
    if(thePlayerPawn != none)
    {
        thePlayerPawn.UseTuneData();
    }
    //return;    
}

event NewPDAMsgReceived()
{
    local PlayerPawn P;
    local SPHud HUD;

    // End:0x60
    if(WorldInfo != none)
    {
        // End:0x5F
        foreach WorldInfo.AllPawns(Class'PlayerPawn', P)
        {
            HUD = P.playerHud;
            // End:0x5E
            if(HUD != none)
            {
                HUD.PDAMessageReceived();
            }            
        }        
    }
    //return;    
}

function bool DoTeamChange(Controller Other, int teamIdx)
{
    // End:0xB9
    if((Other.PlayerReplicationInfo.Team == none) || Other.PlayerReplicationInfo.Team != m_teams[teamIdx])
    {
        // End:0x96
        if(Other.PlayerReplicationInfo.Team != none)
        {
            Other.PlayerReplicationInfo.Team.RemoveFromTeam(Other);
        }
        return m_teams[teamIdx].AddToTeam(Other);        
    }
    else
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

event ReadPDAMessageUnlockedData()
{
    local PandoraPlayerController PC;

    // End:0x2C
    foreach WorldInfo.AllControllers(Class'PandoraPlayerController', PC)
    {
        // End:0x2B
        if(PC != none)
        {
            // End:0x2C
            break;
        }        
    }    
    // End:0xEC
    if(PC != none)
    {
        PDACreatureMessageUnlockedCount = PC.ProfileSettings.GetUnlockedPDACreatureMessageCount();
        PDAEquipmentMessageUnlockedCount = PC.ProfileSettings.GetUnlockedPDAEquipmentMessageCount();
        PDAObjectiveMessageUnlockedCount = PC.ProfileSettings.GetUnlockedPDAObjectiveMessageCount();
        PDAPeopleMessageUnlockedCount = PC.ProfileSettings.GetUnlockedPDAPeopleMessageCount();
        PDAPickedupMessageCount = PC.ProfileSettings.GetPickedUpPDAMessageCount();
    }
    //return;    
}

event WritePDAMessageUnlockedData()
{
    local PandoraPlayerController PC;

    // End:0x2C
    foreach WorldInfo.AllControllers(Class'PandoraPlayerController', PC)
    {
        // End:0x2B
        if(PC != none)
        {
            // End:0x2C
            break;
        }        
    }    
    // End:0xB1
    if((PC != none) && OnlineSub != none)
    {
        // End:0x7D
        if(!PC.ProfileSettings.OkToWriteProfile())
        {
            PC.bDelayedProfileWrite = true;            
        }
        else
        {
            PC.ProfileSettings.SetProfileDirty(true);
            PC.WriteProfile();
        }
    }
    //return;    
}

exec function CreateGameSession(optional int nPrivateSlots, optional int nCreatureDensity)
{
    // End:0x24
    if(!bLanMatch)
    {
        CreateOnlineSession(nPrivateSlots, nCreatureDensity);        
    }
    else
    {
        CreateLanSession(nCreatureDensity);
    }
    //return;    
}

exec function JoinFirstGameSession()
{
    // End:0x18
    if(!bLanMatch)
    {
        JoinFirstOnlineSession();        
    }
    else
    {
        JoinFirstLanSession();
    }
    //return;    
}

exec function CreateOnlineSession(optional int nPrivateSlots, optional int nCreatureDensity)
{
    // End:0x10
    if(nPrivateSlots > 8)
    {
        return;
    }
    // End:0x73
    if(OnlineSub != none)
    {
        // End:0x3D
        if(GameSettings == none)
        {
            InitOnlineGameSettings(nPrivateSlots, nCreatureDensity);            
        }
        // End:0x73
        if(OnlineSub.GameInterface.CreateOnlineGame(byte(GetServerControllerId()), GameSettings) == false)
        {
        }
    }
    //return;    
}

exec function CreateLanSession(optional int nCreatureDensity)
{
    // End:0x71
    if(OnlineSub != none)
    {
        // End:0x29
        if(GameSettings == none)
        {
            InitLanGameSettings(nCreatureDensity);            
        }
        GameSettings.bUsesArbitration = false;
        // End:0x71
        if(OnlineSub.GameInterface.CreateOnlineGame(byte(GetServerControllerId()), GameSettings) == false)
        {
        }
    }
    //return;    
}

exec function JoinFirstOnlineSession()
{
    local OnlineGameSearch GameSearch;

    // End:0x67
    if(OnlineSub != none)
    {
        GameSearch = new (OnlineSub) Class'PandoraDMOnlineGameSearch';
        GameSearch.bIsLanQuery = false;
        // End:0x67
        if(OnlineSub.GameInterface.FindOnlineGames(byte(GetServerControllerId()), GameSearch) == false)
        {
        }
    }
    //return;    
}

exec function JoinFirstLanSession()
{
    local OnlineGameSearch GameSearch;

    // End:0x67
    if(OnlineSub != none)
    {
        GameSearch = new (OnlineSub) Class'PandoraDMOnlineGameSearch';
        GameSearch.bIsLanQuery = true;
        // End:0x67
        if(OnlineSub.GameInterface.FindOnlineGames(byte(GetServerControllerId()), GameSearch) == false)
        {
        }
    }
    //return;    
}

function ContentChanged()
{
    //return;    
}

exec function CheckLinkStatus()
{
    // End:0x30
    if(OnlineSub != none)
    {
        // End:0x30
        if(OnlineSub.SystemInterface.HasLinkConnection())
        {            
        }
    }
    //return;    
}

function GameSearchDone(bool bWasSuccessful)
{
    local OnlineGameSearch Search;
    local OnlineGameSearchResult SearchResult;

    // End:0x90
    if(OnlineSub != none)
    {
        Search = OnlineSub.GameInterface.GetGameSearch();
        // End:0x90
        if(Search.Results.Length > 0)
        {
            SearchResult = Search.Results[0];
            OnlineSub.GameInterface.JoinOnlineGame(byte(GetServerControllerId()), SearchResult);            
        }
    }
    //return;    
}

function GameJoinDone(bool bWasSuccessful)
{
    local string URL;
    local int ColIndex;

    // End:0x1B
    if(!bWasSuccessful && OnlineSub != none)
    {        
    }
    else
    {
        // End:0xD1
        if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
        {
            // End:0xD1
            if(OnlineSub.GameInterface.GetResolvedConnectString(URL))
            {
                // End:0xA6
                if(!WorldInfo.IsConsoleBuild())
                {
                    ColIndex = InStr(URL, ":");
                    URL = Left(URL, ColIndex);
                }                
                ConsoleCommand(("open " $ URL) $ "?Team=255");
            }
        }
    }
    OnlineSub.GameInterface.FreeSearchResults();
    //return;    
}

exec function ReadFriends()
{
    // End:0x38
    if(OnlineSub != none)
    {
        OnlineSub.PlayerInterface.ReadFriendsList(byte(GetServerControllerId()));
    }
    //return;    
}

exec function QueryDownloableContent()
{
    // End:0x56
    if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.ContentInterface, OnlineContentInterface(none)))
    {
        OnlineSub.ContentInterface.QueryAvailableDownloads(byte(GetServerControllerId()));
    }
    //return;    
}

function ResetRadar()
{
    local PandoraPlayerController PC;
    local SPHud theHud;

    // End:0x42
    foreach LocalPlayerControllers(Class'PandoraPlayerController', PC)
    {
        theHud = SPHud(PC.myHUD);
        theHud.InitTargetManager();        
    }    
    //return;    
}

function CloseLobby()
{
    local PandoraPlayerController PPC;

    // End:0x69
    foreach WorldInfo.AllControllers(Class'PandoraPlayerController', PPC)
    {
        PPC.CloseSceneType(Class'UIScene_WeaponConfig');
        PPC.CloseSceneType(Class'UIScene_ConfirmationDialog');
        PPC.CloseSceneType(Class'UIScene_PandoraLobbyMPXenon');        
    }    
    //return;    
}

static simulated function GetThirdPersonWeaponSounds(class<SPWeapon> WeaponClass, out ThirdPersonWeaponSounds Sounds)
{
    //return;    
}

function string GetURLParam(URL theURL, string ScanName)
{
    local int I, EqPos;
    local string OptionName, OptionValue, lcScanName;

    lcScanName = Locs(ScanName);
    I = 0;
    J0x14:

    // End:0xCB [Loop If]
    if(I < theURL.Op.Length)
    {
        EqPos = InStr(theURL.Op[I], "=");
        // End:0xC1
        if(EqPos != -1)
        {
            OptionName = Left(theURL.Op[I], EqPos);
            OptionValue = Mid(theURL.Op[I], EqPos + 1);
            // End:0xC1
            if(Locs(OptionName) == lcScanName)
            {
                return OptionValue;
            }
        }
        I++;
        // [Loop Continue]
        goto J0x14;
    }
    return "";
    //return ReturnValue;    
}

function bool URLHasParam(URL theURL, string ScanName)
{
    local int I;
    local string lcScanName;

    lcScanName = Locs(ScanName);
    I = 0;
    J0x14:

    // End:0x5D [Loop If]
    if(I < theURL.Op.Length)
    {
        // End:0x53
        if(Locs(theURL.Op[I]) == lcScanName)
        {
            return true;
        }
        I++;
        // [Loop Continue]
        goto J0x14;
    }
    return false;
    //return ReturnValue;    
}

function PandoraDMOnlineGameSettings InitOnlineGameSettings(optional int nPrivateSlots, optional int nCreatureDensity)
{
    GameSettings = new (OnlineSub) Class'PandoraDMOnlineGameSettings';
    GameSettings.NumPublicConnections = 8 - nPrivateSlots;
    GameSettings.NumPrivateConnections = nPrivateSlots;
    GameSettings.bIsLanMatch = false;
    GameSettings.bUsesArbitration = bUsesArbitration;
    PandoraDMOnlineGameSettings(GameSettings).CreatureDensity = nCreatureDensity;
    // End:0xCC
    if(WorldInfo.IsConsoleBuild(1))
    {
        PandoraDMOnlineGameSettings(GameSettings).LocalizedSettingsMappings.Remove(4, 1);
        PandoraDMOnlineGameSettings(GameSettings).LocalizedSettings.Remove(4, 1);
    }
    return PandoraDMOnlineGameSettings(GameSettings);
    //return ReturnValue;    
}

function PandoraDMOnlineGameSettings InitLanGameSettings(optional int nCreatureDensity)
{
    GameSettings = new (OnlineSub) Class'PandoraDMOnlineGameSettings';
    GameSettings.NumPublicConnections = 8;
    GameSettings.bIsLanMatch = true;
    PandoraDMOnlineGameSettings(GameSettings).CreatureDensity = nCreatureDensity;
    return PandoraDMOnlineGameSettings(GameSettings);
    //return ReturnValue;    
}

function RegisterPointEvent(SPPointEvent theEvent)
{
    //return;    
}

function NotifyEnteredPostGame()
{
    //return;    
}

event bool IsInShellLevel(optional out string LevelName)
{
    LevelName = "";
    LevelName = GetPersistentLevelName();
    // End:0x37
    if(Caps(LevelName) == Caps("PandoraStart"))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool IsInCinematic()
{
    local Sequence GameSequence;
    local array<SequenceObject> AllInterpActions;
    local SeqAct_Interp InterpAction;
    local int I, J;
    local bool bIsInCinematic;
    local PandoraPlayerController PC;

    // End:0x22
    foreach LocalPlayerControllers(Class'PandoraPlayerController', PC)
    {
        // End:0x21
        if(PC != none)
        {
            // End:0x22
            break;
        }        
    }    
    bIsInCinematic = false;
    // End:0x47
    if(PC.ControllingDirTrackInst == none)
    {
        return bIsInCinematic;
    }
    GameSequence = WorldInfo.GetGameSequence();
    // End:0x18D
    if(GameSequence != none)
    {
        GameSequence.FindSeqObjectsByClass(Class'Engine.SeqAct_Interp', true, AllInterpActions);
        I = 0;
        J0x8A:

        // End:0x18D [Loop If]
        if((I < AllInterpActions.Length) && !bIsInCinematic)
        {
            InterpAction = SeqAct_Interp(AllInterpActions[I]);
            // End:0xEC
            if(!InterpAction.bActive && !InterpAction.bIsPlaying)
            {
                // [Explicit Continue]
                goto J0x183;
            }
            // End:0x183
            if((InterpAction.InterpData != none) && InterpAction.GroupInst.Length > 0)
            {
                J = 0;
                J0x120:

                // End:0x183 [Loop If]
                if(J < InterpAction.InterpData.InterpGroups.Length)
                {
                    // End:0x179
                    if(InterpGroupDirector(InterpAction.InterpData.InterpGroups[J]) != none)
                    {
                        bIsInCinematic = true;
                        // [Explicit Break]
                        goto J0x183;
                    }
                    J++;
                    // [Loop Continue]
                    goto J0x120;
                }
            }
            J0x183:

            I++;
            // [Loop Continue]
            goto J0x8A;
        }
    }
    return bIsInCinematic;
    //return ReturnValue;    
}

function UnlockPDAMessage(PandoraGameInfo.EMessage_Type MsgType, string UnlockUISceneName)
{
    local int I;
    local bool bFound;
    local PandoraPlayerController PC;
    local PandoraPDAManager PDAManager;
    local PDAMessage msg;
    local array<PDAMessage> PDAMsgs;

    // End:0x2C
    foreach WorldInfo.AllControllers(Class'PandoraPlayerController', PC)
    {
        // End:0x2B
        if(PC != none)
        {
            // End:0x2C
            break;
        }        
    }    
    // End:0x50
    if(PC != none)
    {
        PDAManager = PC.PDAManager;        
    }
    else
    {
        return;
    }
    bFound = false;
    // End:0x156
    if(PDAManager != none)
    {
        switch(MsgType)
        {
            // End:0x80
            case 1:
                PDAMsgs = PDAObjectiveMessages;
                // End:0xD1
                break;
            // End:0x93
            case 2:
                PDAMsgs = PDACreatureMessages;
                // End:0xD1
                break;
            // End:0xA6
            case 3:
                PDAMsgs = PDAEquipmentMessages;
                // End:0xD1
                break;
            // End:0xB9
            case 4:
                PDAMsgs = PDAPeopleMessages;
                // End:0xD1
                break;
            // End:0xCC
            case 8:
                PDAMsgs = PDAPickupMessages;
                // End:0xD1
                break;
            // End:0xFFFF
            default:
                return;
                break;
        }
        I = 0;
        J0xD8:

        // End:0x12E [Loop If]
        if(I < PDAMsgs.Length)
        {
            // End:0x124
            if(PDAMsgs[I].UISceneName == UnlockUISceneName)
            {
                bFound = true;
                msg = PDAMsgs[I];
                // [Explicit Break]
                goto J0x12E;
            }
            I++;
            // [Loop Continue]
            goto J0xD8;
        }
        J0x12E:

        // End:0x156
        if(bFound)
        {
            PDAManager.UnlockPDAMessage(self, msg, UnlockUISceneName);
        }
    }
    //return;    
}

function ShowWereWolfTutorial()
{
    local PandoraPlayerController PC;
    local int Value;
    local GameUISceneClient mySceneClient;
    local UIScene_OnScreenText OpenedScene;
    local UIInteraction UIController;

    // End:0x2C
    foreach WorldInfo.AllControllers(Class'PandoraPlayerController', PC)
    {
        // End:0x2B
        if(PC != none)
        {
            // End:0x2C
            break;
        }        
    }    
    // End:0x2CB
    if(PC.ProfileSettings != none)
    {
        Value = PC.ProfileSettings.GetUnlockedWWTutorial();
        // End:0x2CB
        if(Value == 0)
        {
            // End:0x12B
            if(PC.currOnScreenText.DialogDuration != 0.0000000)
            {
                PC.CloseScene(PC.currOnScreenText.Scene, false);
                PC.currOnScreenText.DialogDuration = 0.0000000;
                PC.currOnScreenText.DialogDurationLeft = 0.0000000;
                PC.currOnScreenText.Action.bIsCompleted = true;
            }
            PC.currOnScreenText.Action = none;
            PC.currOnScreenText.DialogDuration = 5.0000000;
            PC.currOnScreenText.DialogDurationLeft = 5.0000000;
            OpenedScene = UIScene_OnScreenText(PC.OpenScene(TutorialScene, true));
            // End:0x2CB
            if(OpenedScene != none)
            {
                UIController = PC.GetUIController();
                // End:0x20A
                if(UIController != none)
                {
                    mySceneClient = UIController.SceneClient;
                    // End:0x20A
                    if(mySceneClient != none)
                    {
                        mySceneClient.bOverrideEmulateButtonPress = true;
                    }
                }
                OpenedScene.StringBackup = "<Strings:PandoraGame.helpertxt.WWdecap>";
                OpenedScene.SetOnScreenText("<Strings:PandoraGame.helpertxt.WWdecap>");
                PC.currOnScreenText.Scene = OpenedScene;
                Value = 1;
                PC.ProfileSettings.SetUnlockedWWTutorial(Value);
            }
        }
    }
    //return;    
}

function Logout(Controller Exiting)
{
    local PlayerController PC;
    local PlayerReplicationInfo PRI;

    PC = PlayerController(Exiting);
    // End:0x6E
    if(int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        // End:0x6E
        if(PC != none)
        {
            PRI = PC.PlayerReplicationInfo;
            // End:0x6E
            if(PRI != none)
            {
                HandleDisconnect(PRI.PlayerID);
            }
        }
    }
    super.Logout(Exiting);
    //return;    
}

function HandleDisconnect(int disconnectedPlayerID)
{
    local int I, team1NumPlayers, team2NumPlayers;
    local PlayerReplicationInfo PRI, WinnerPRI;
    local PandoraGRI PGRI;
    local PandoraPlayerController PPC;
    local bool bHostDisconnected;

    bHostDisconnected = false;
    PGRI = PandoraGRI(WorldInfo.GRI);
    // End:0x15D
    foreach WorldInfo.AllControllers(Class'PandoraPlayerController', PPC)
    {
        // End:0x15C
        if(PPC.IsLocalPlayerController())
        {
            // End:0x15C
            if(((PPC.PlayerReplicationInfo.PlayerID == disconnectedPlayerID) || (int(PPC.OnlineSub.PlayerInterface.GetLoginStatus(byte(LocalPlayer(PPC.Player).ControllerId))) < int(1)) && GameSettings.bIsLanMatch) || (int(PPC.OnlineSub.PlayerInterface.GetLoginStatus(byte(LocalPlayer(PPC.Player).ControllerId))) < int(2)) && !GameSettings.bIsLanMatch)
            {
                bHostDisconnected = true;
                // End:0x15D
                break;
            }
        }        
    }    
    // End:0x16B
    if(PGRI == none)
    {
        return;
    }
    // End:0x17F
    if(!IsInState('MatchInProgress'))
    {
        return;
    }
    I = 0;
    J0x186:

    // End:0x261 [Loop If]
    if(I < PGRI.PRIArray.Length)
    {
        PRI = PGRI.PRIArray[I];
        // End:0x1F1
        if((PRI == none) || (PRI != none) && disconnectedPlayerID == PRI.PlayerID)
        {
            // [Explicit Continue]
            goto J0x257;
        }
        // End:0x225
        if(PRI.Team.TeamIndex == 1)
        {
            team1NumPlayers++;
            WinnerPRI = PRI;
            // [Explicit Continue]
            goto J0x257;
        }
        // End:0x257
        if(PRI.Team.TeamIndex == 2)
        {
            team2NumPlayers++;
            WinnerPRI = PRI;
        }
        J0x257:

        I++;
        // [Loop Continue]
        goto J0x186;
    }
    // End:0x27B
    if((team1NumPlayers > 0) && team2NumPlayers > 0)
    {
        return;
    }
    winningPlayerReplicationInfo = WinnerPRI;
    // End:0x2A6
    if(!bHostDisconnected)
    {
        PGRI.SetIsInPostGame(true);
    }
    GotoState('PostMatch');
    //return;    
}

function ProcessClientMovieCompletion(PlayerController PC)
{
    //return;    
}

function KillPlayers(optional bool bResetScores = false)
{
    //return;    
}

function NotifyStartOfThrowWeapon()
{
    bWeaponThrowInProgress = true;
    //return;    
}

function NotifyEndOfThrowWeapon()
{
    bWeaponThrowInProgress = false;
    //return;    
}

auto state PendingMatch
{Begin:

    StartMatch();
    stop;        
}
