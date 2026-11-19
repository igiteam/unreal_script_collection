class MOHAGameInfo extends GameInfo
    native
    config(Game)
    hidecategories(Navigation,Movement,Collision);

struct native KillAssistStruct
{
    var Controller Shooter;
    var Controller Target;
    var int Timer;

    structdefaultproperties
    {
        Shooter=none
        Target=none
        Timer=0
    }
};

struct native WeaponExperienceInfo
{
    var class<EALAWeapon> WeaponClass;
    var int ExperiencePoints;

    structdefaultproperties
    {
        WeaponClass=none
        ExperiencePoints=0
    }
};

var array< class<StimuliTableRegistrant> > StimuliTableRegistrants;
var MOHAWhizManager GlobalWhizManager;
var MOHAGlassManager GlobalGlassManager;
var MOHAObjectiveManager GlobalObjectiveManager;
var array<KillAssistStruct> KillAssistList;
var bool bAirborneGame;
var bool bKillNewlySpawnedPawns;
var bool bFirstPlayerSpawn;
var config float TeamPointsForDistance;
var config float TeamPointsForAssist;
var config float TeamPointsForHealing;
var config float TeamAssitKillTimeout;
var const float TeamKillDist;
var config int SecondsBetweenRespawn;
var int RespawnTimer;
var class<CCDirectorNative> CCDirectorClass;
var CCDirectorNative GlobalCCDirector;
var Controller PendingPlayer;
var name PreRespawnStateName;

// Export UMOHAGameInfo::execPreUnloadWorkNative(FFrame&, void* const)
private native final function PreUnloadWorkNative();

// Export UMOHAGameInfo::execForceUnload(FFrame&, void* const)
private native final function ForceUnload();

// Export UMOHAGameInfo::execPostUnloadWorkNative(FFrame&, void* const)
private native final function PostUnloadWorkNative();

// Export UMOHAGameInfo::execInitialLoadCompleteKismetActionPresent(FFrame&, void* const)
private native final function bool InitialLoadCompleteKismetActionPresent();

function RestartPlayer(Controller NewPlayer)
{
    // End:0x26
    if(int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        super.RestartPlayer(NewPlayer);
        return;
    }
    // End:0x44
    if(!bFirstPlayerSpawn)
    {
        GlobalObjectiveManager.Reset();
    }
    PrePlayerSpawn(NewPlayer);
    PendingPlayer = NewPlayer;
    PreRespawnStateName = GetStateName();
    GotoState('WaitForKismetToTrigger');
    //return;    
}

function SuperRestartPlayer(Controller NewPlayer)
{
    RestartPlayer(NewPlayer);
    //return;    
}

function PrePlayerSpawn(Controller NewPlayer)
{
    Class'MOHAUtilities'.static.ActivateSequenceEventsOfType(WorldInfo, Class'SeqEvent_PrePlayerSpawned', NewPlayer, NewPlayer);
    //return;    
}

function bool ShouldFireGameRestoredEvents()
{
    return !Class'Engine.SaveLoadSystem'.static.AtLevelStartCheckpoint();
    //return ReturnValue;    
}

function TriggerSaveLoadRestoreEvent()
{
    local array<SequenceObject> Events;
    local SeqEvent_GameRestored RestoredEvent;
    local int idx;

    Class'Engine.SaveLoadSystem'.static.Load("", !bFirstPlayerSpawn);
    // End:0xBD
    if(ShouldFireGameRestoredEvents())
    {
        // End:0xBD
        if(WorldInfo.GetGameSequence() != none)
        {
            WorldInfo.GetGameSequence().FindSeqObjectsByClass(Class'SeqEvent_GameRestored', true, Events);
            idx = 0;
            J0x66:

            // End:0xBD [Loop If]
            if(idx < Events.Length)
            {
                RestoredEvent = SeqEvent_GameRestored(Events[idx]);
                // End:0xB3
                if(RestoredEvent != none)
                {
                    RestoredEvent.CheckActivate(WorldInfo, WorldInfo);
                }
                idx++;
                // [Loop Continue]
                goto J0x66;
            }
        }
    }
    //return;    
}

function PostBeginPlay()
{
    super.PostBeginPlay();
    // End:0x37
    if(int(WorldInfo.NetMode) != int(NM_Client))
    {
        GameReplicationInfo.RemainingTime = 60 * TimeLimit;
    }
    //return;    
}

function Tick(float Time)
{
    Class'EAKynapse.StimuliWorld'.static.Update(Time);
    // End:0x3B
    if(GlobalWhizManager != none)
    {
        GlobalWhizManager.Update(Time);
    }
    // End:0x5E
    if(GlobalGlassManager != none)
    {
        GlobalGlassManager.Update(Time);
    }
    //return;    
}

event InitGame(string Options, out string ErrorMessage)
{
    Class'Engine.JuiceSubsystem'.static.LevelStart();
    Class'EAKynapse.StimuliWorld'.static.Reset();
    super.InitGame(Options, ErrorMessage);
    //return;    
}

exec function Slap()
{
    WorldInfo.Game.Broadcast(none, "Hello!");
    //return;    
}

exec function DrawStimulus(name Channel)
{
    Class'EAKynapse.StimuliWorld'.static.ToggleDebugChannel(Channel);
    //return;    
}

function DropTableEntry GetDropTable(MOHAAIPawn P)
{
    local DropTableEntry blankTable;
    local int TeamIndex;

    // End:0x84
    if((P != none) && MOHAAIController(P.Controller) != none)
    {
        TeamIndex = MOHAAIController(P.Controller).GetTeamIndex();
        // End:0x6A
        if(TeamIndex == 0)
        {
            return WorldInfo.AllyWeaponDropTable;            
        }
        else
        {
            // End:0x84
            if(TeamIndex == 1)
            {
                return WorldInfo.AxisWeaponDropTable;
            }
        }
    }
    return blankTable;
    //return ReturnValue;    
}

event PreBeginPlay()
{
    super.PreBeginPlay();
    GlobalWhizManager = new Class'MOHAWhizManager';
    GlobalGlassManager = new Class'MOHAGlassManager';
    GlobalObjectiveManager = __NFUN_278__(Class'MOHAObjectiveManager');
    GlobalCCDirector = __NFUN_278__(CCDirectorClass);
    RegisterStimuliTables();
    FixupDropTable();
    //return;    
}

function FixupDropTable()
{
    WorldInfo.AllyWeaponDropTable.AmmoFrequency += WorldInfo.AllyWeaponDropTable.WeaponFrequency;
    WorldInfo.AllyWeaponDropTable.AmmoSpecific.SecondaryAmmoFrequency += WorldInfo.AllyWeaponDropTable.AmmoSpecific.PrimaryAmmoFrequency;
    WorldInfo.AllyWeaponDropTable.AmmoSpecific.PistolAmmoFrequency += WorldInfo.AllyWeaponDropTable.AmmoSpecific.SecondaryAmmoFrequency;
    WorldInfo.AllyWeaponDropTable.AmmoSpecific.GrenadeAmmoFrequency += WorldInfo.AllyWeaponDropTable.AmmoSpecific.PistolAmmoFrequency;
    WorldInfo.AllyWeaponDropTable.GrenadeSpecific.StickGrenadeFrequency += WorldInfo.AllyWeaponDropTable.GrenadeSpecific.FragGrenadeFrequency;
    WorldInfo.AxisWeaponDropTable.AmmoFrequency += WorldInfo.AxisWeaponDropTable.WeaponFrequency;
    WorldInfo.AxisWeaponDropTable.AmmoSpecific.SecondaryAmmoFrequency += WorldInfo.AxisWeaponDropTable.AmmoSpecific.PrimaryAmmoFrequency;
    WorldInfo.AxisWeaponDropTable.AmmoSpecific.PistolAmmoFrequency += WorldInfo.AxisWeaponDropTable.AmmoSpecific.SecondaryAmmoFrequency;
    WorldInfo.AxisWeaponDropTable.AmmoSpecific.GrenadeAmmoFrequency += WorldInfo.AxisWeaponDropTable.AmmoSpecific.PistolAmmoFrequency;
    WorldInfo.AxisWeaponDropTable.GrenadeSpecific.StickGrenadeFrequency += WorldInfo.AxisWeaponDropTable.GrenadeSpecific.FragGrenadeFrequency;
    //return;    
}

function RegisterStimuliTables()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x53 [Loop If]
    if(I < StimuliTableRegistrants.Length)
    {
        StimuliTableRegistrants[I].static.AddListenerTemplates();
        StimuliTableRegistrants[I].static.AddSenderTemplates();
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function AddDefaultInventory(Pawn MOHAPawn)
{
    MOHAPawn.AddDefaultInventory();
    SetPlayerDefaults(MOHAPawn);
    //return;    
}

event NotifyGarbageCollectionComplete()
{
    //return;    
}

event UnloadDynamicLevelsTriggered()
{
    //return;    
}

event NotifyIntialLoadComplete()
{
    //return;    
}

function bool ShouldRespawn(PickupFactory Other)
{
    return true;
    //return ReturnValue;    
}

auto state PendingMatch
{Begin:

    StartMatch();
    stop;        
}

state BaseRespawnState
{    stop;    
}

state WaitForKismetToTrigger extends BaseRespawnState
{
    function BeginState(name PreviousStateName)
    {
        PreUnloadWorkNative();
        // End:0x1D
        if(bFirstPlayerSpawn)
        {
            GotoState('WaitForLevelUnload');
        }
        //return;        
    }

    event UnloadDynamicLevelsTriggered()
    {
        GotoState('WaitForLevelUnload');
        //return;        
    }
    stop;    
}

state WaitForLevelUnload extends BaseRespawnState
{
    function BeginState(name PreviousStateName)
    {
        ClearTimer('WaitForUnload');
        ForceUnload();
        //return;        
    }

    event NotifyGarbageCollectionComplete()
    {
        GotoState('PostUnloadWork');
        //return;        
    }
    stop;    
}

state PostUnloadWork extends BaseRespawnState
{
    function BeginState(name PreviousStateName)
    {
        PostUnloadWorkNative();
        GotoState('FinalGC');
        //return;        
    }
    stop;    
}

state FinalGC extends BaseRespawnState
{
    function BeginState(name PreviousStateName)
    {
        WorldInfo.ForceFullPurgeGarbageCollection();
        //return;        
    }

    event NotifyGarbageCollectionComplete()
    {
        GotoState('ActualRespawn');
        //return;        
    }
    stop;    
}

state ActualRespawn
{
    function BeginState(name PreviousStateName)
    {
        SuperRestartPlayer(PendingPlayer);
        bFirstPlayerSpawn = false;
        // End:0x4A
        if((MOHAPlayerController(PendingPlayer) != none) && InitialLoadCompleteKismetActionPresent())
        {
            MOHAPlayerController(PendingPlayer).GotoWaitForLoad();
        }
        GotoState('WaitForLoad');
        //return;        
    }

    function PostPawnCreation()
    {
        TriggerSaveLoadRestoreEvent();
        //return;        
    }
    stop;    
}

state WaitForLoad
{
    event NotifyIntialLoadComplete()
    {
        // End:0x28
        if(MOHAPlayerController(PendingPlayer) != none)
        {
            MOHAPlayerController(PendingPlayer).LevelsLoaded();
        }
        GotoState('None');
        //return;        
    }
    stop;    
}

defaultproperties
{
    StimuliTableRegistrants[0]=Class'EAKynapse.AxonStimuliTableRegistrant'
    bFirstPlayerSpawn=true
    TeamPointsForDistance=1.0000000
    TeamPointsForAssist=1.0000000
    TeamPointsForHealing=1.0000000
    TeamAssitKillTimeout=5.0000000
    TeamKillDist=1000.0000000
    CCDirectorClass=Class'CCDirector'
    bRestartLevel=false
    DefaultPawnClass=Class'MOHASingleplayerPawn'
    HUDType=Class'MOHAHUD_SP'
    PlayerControllerClass=Class'MOHAPlayerController'
    PlayerReplicationInfoClass=Class'MOHAPlayerReplicationInfo'
    GameReplicationInfoClass=Class'MOHAGameReplicationInfo'
}