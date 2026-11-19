class PandoraCheckpoint extends PathNode
    native;

enum ELevelLoadOverride
{
    LLO_NoChange,                   // 0
    LLO_ForceLoaded,                // 1
    LLO_ForceUnloaded,              // 2
    LLO_MAX                         // 3
};

enum ELevelVisibilityOverride
{
    LVO_NoChange,                   // 0
    LVO_ForceVisible,               // 1
    LVO_ForceNonVisible,            // 2
    LVO_MAX                         // 3
};

enum EStreamingVolumeOverride
{
    SVO_NoChange,                   // 0
    SVO_ForceEnabled,               // 1
    SVO_ForceDisabled,              // 2
    SVO_MAX                         // 3
};

struct native CheckpointOverride
{
    /** Name of level to override values for */
    var() name LevelName;
    /** Level load control */
    var() PandoraCheckpoint.ELevelLoadOverride LevelLoadOverride;
    /** Level load control */
    var() PandoraCheckpoint.ELevelVisibilityOverride LevelVisibilityOverride;
    /** Level load control */
    var() PandoraCheckpoint.EStreamingVolumeOverride StreamingVolumeOverride;

    structdefaultproperties
    {
        LevelName="None"
        LevelLoadOverride=LLO_ForceLoaded
        LevelVisibilityOverride=LVO_ForceVisible
        StreamingVolumeOverride=SVO_NoChange
    }
};

var string MapName;
/** This is the name of the checkpoint.  This must be unique across all checkpoints */
var() string CheckpointName;
/**  
 *Should be marked to true for the first checkpoint in the map, this will be the ChapterPoint. When this checkpoint is loaded,
 *it will trigger the LevelBeginning event, but not for other checkpoints
 */
var() bool bIsLevelBeginning;
/** If this is a ChapterPoint (bIsLevelBeginning checked above) this will be the save filename.  This must be unique across all ChapterPoints! */
var() string ChapterPointFileName;
var() float TeleportDistance;
var() float TeleportZDistance;
/** List of all LD-assigned overrides */
var() array<CheckpointOverride> Overrides;
var() array<NavigationPoint> DeckardTeleportSpots;
/** Amount of time to pause game (behind movie) when loading chapter to get textures streamed in. */
var() float ChapterLoadTextureWarmupPause;
/** Amount of time to pause game (behind movie) when loading checkpoint to get textures streamed in. */
var() float CheckpointLoadTextureWarmupPause;

function bool ShouldDoCheckpoint()
{
    local PandoraPlayerController SPPC;

    // End:0xB1
    foreach WorldInfo.AllControllers(Class'PandoraPlayerController', SPPC)
    {
        // End:0x3A
        if(SPPC.IsInState('Dead'))
        {            
            return false;
        }
        // End:0x5A
        if(SPPC.SPCM.bLoadingCheckpoint)
        {            
            return false;
        }
        // End:0xB0
        if(SPPC.Pawn != none)
        {
            // End:0xB0
            if(SPPC.Pawn.bTearOff || SPPC.Pawn.Health <= 0)
            {                
                return false;
            }
        }        
    }    
    return true;
    //return ReturnValue;    
}

function OnPandoraCheckpoint(SeqAct_PandoraCheckPoint inAction)
{
    local PlayerController PC;
    local PandoraPlayerController SPPC;
    local PandoraCheckpointManager SPCM;
    local Pawn Pawn;
    local SPPawn SPP;
    local bool bNeedsTeleport;
    local Vehicle Vehicle;

    // End:0x404
    if(inAction.InputLinks[0].bHasImpulse == true)
    {
        // End:0x34
        if(!ShouldDoCheckpoint())
        {
            return;
        }
        // End:0x7A
        foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
        {
            SPCM = PandoraPlayerController(PC).SPCM;
            Pawn = PC.Pawn;
            // End:0x7A
            break;            
        }        
        // End:0x92
        if(SPCM.CurrCheckpoint == self)
        {
            return;
        }
        // End:0x152
        foreach WorldInfo.AllControllers(Class'PandoraPlayerController', SPPC)
        {
            SPP = SPPawn(SPPC.Pawn);
            // End:0x113
            if(SPP == none)
            {
                Vehicle = Vehicle(SPPC.Pawn);
                // End:0x113
                if(Vehicle != none)
                {
                    SPP = SPPawn(Vehicle.Driver);
                }
            }
            // End:0x151
            if(SPP != none)
            {
                // End:0x151
                if(SPP.InvManager.InventoryChain == none)
                {
                    SPP.AddDefaultInventory();
                }
            }            
        }        
        SPCM.SetNewCheckpoint(self, !inAction.bShouldSave);
        NotifyStreamingLevelChanged();
        // End:0x1B1
        if(inAction.bFireCheckPointActivedEvent == true)
        {
            TriggerEventClass(Class'SeqEvt_CheckpointActivated', Pawn);
        }
        // End:0x1FB
        if(inAction.bFireToggleHUDOn == true)
        {
            // End:0x1FA
            foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
            {
                PC.myHUD.bShowHUD = true;
                // End:0x1FA
                break;                
            }            
        }
        // End:0x23F
        if(inAction.bDisplayCheckpointingText)
        {
            // End:0x23E
            foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
            {
                PandoraPlayerController(PC).ClientDisplayCheckpointText();
                // End:0x23E
                break;                
            }            
        }
        // End:0x401
        if(int(Role) == int(ROLE_Authority))
        {
            // End:0x29E
            foreach WorldInfo.AllControllers(Class'PandoraPlayerController', SPPC)
            {
                // End:0x29A
                if(SPPC.IsInState('PlayerWaiting'))
                {
                    SPPC.ServerRestartPlayer();
                }
                // End:0x29E
                break;                
            }            
            // End:0x401
            if((TeleportDistance > 0.0000000) || TeleportZDistance > 0.0000000)
            {
                // End:0x400
                foreach WorldInfo.AllControllers(Class'PandoraPlayerController', SPPC)
                {
                    bNeedsTeleport = ((TeleportDistance > 0.0000000) && VSize2D(SPPC.Pawn.Location - Location) > TeleportDistance) || (TeleportZDistance > 0.0000000) && Abs(Location.Z - SPPC.Pawn.Location.Z) > TeleportZDistance;
                    // End:0x3B9
                    if(bNeedsTeleport)
                    {
                        Vehicle = Vehicle(SPPC.Pawn);
                        // End:0x3B9
                        if(Vehicle != none)
                        {
                            Vehicle.DriverLeave(true);
                        }
                    }
                    SPP = SPPawn(SPPC.Pawn);
                    // End:0x3E2
                    if(SPP == none)
                    {
                        continue;                        
                    }
                    // End:0x3FF
                    if(bNeedsTeleport)
                    {
                        HandlePawnTeleport(SPP, SPPC);
                    }                    
                }                
            }
        }        
    }
    //return;    
}

// Export UPandoraCheckpoint::execNotifyStreamingLevelChanged(FFrame&, void* const)
native function NotifyStreamingLevelChanged();

simulated event HandlePawnTeleport(SPPawn SPP, PandoraPlayerController SPPC)
{
    SPP.SetPhysics(2);
    //return;    
}
