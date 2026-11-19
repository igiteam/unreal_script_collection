class R6InteractiveDoorRotating extends R6InteractiveDoor
    native
    config(Game)
    placeable
    hidecategories(lighting);

enum ERotateOpeningDirection
{
    ROTATE_AXIS_YAW,                // 0
    ROTATE_AXIS_ROLL,               // 1
    ROTATE_AXIS_MAX                 // 2
};

enum EOpeningRotation
{
    DOR_Clockwise,                  // 0
    DOR_CounterClockwise,           // 1
    DOR_MAX                         // 2
};

var(R6Door) R6InteractiveDoorRotating.ERotateOpeningDirection m_eOpeningDirection;
var(R6Door) R6InteractiveDoorRotating.EOpeningRotation m_eOpeningRotation;
var(R6Door) /*0x20000000-0x00000000*/ int m_iStartOpening;
var(R6Door) /*0x20000000-0x00000000*/ int m_iMaxOpening;
var(R6Door) /*0x20000000-0x00000000*/ int m_iMaxOpeningForDD;
var int m_iCurrentOpening;
var bool m_bBrokenHandleMesh;
var bool m_bRenderDebug;

replication
{
    // Pos:0x000
    if((int(Role) == int(ROLE_Authority)) && bNetInitial)
        m_iCurrentOpening;
}

// Export UR6InteractiveDoorRotating::execUpdateOpening(FFrame&, void* const)
native final function UpdateOpening(int iDeg, optional bool bNoCollision);

// Export UR6InteractiveDoorRotating::execImpulseOpensDoor(FFrame&, void* const)
native function bool ImpulseOpensDoor(Vector vImpulse);

// Export UR6InteractiveDoorRotating::execBreakHandle(FFrame&, void* const)
native function BreakHandle(Vector vMomentum, Controller pInstigator, optional bool bSwitchMesh);

// Export UR6InteractiveDoorRotating::execBreakDoor(FFrame&, void* const)
native function BreakDoor(Vector vHitLocation, Vector vMomentum, Controller pInstigator);

simulated function PostBeginPlay()
{
    PostBeginPlay();
    // End:0x21
    if(m_iStartOpening != 0)
    {
        UpdateOpening(m_iStartOpening);        
    }
    else
    {
        // End:0x3C
        if(m_pVolume != none)
        {
            m_pVolume.EnableCollide(false);
        }
    }
    return;
}

simulated event bool EncroachingOn(Actor other)
{
    local R6Pawn pPawn;
    local EAIEvent AIEvent;
    local R6PlayerController pController;

    pPawn = R6Pawn(other);
    // End:0x111
    if(pPawn != none)
    {
        // End:0x91
        if((!pPawn.m_bIsNPCPawn && pPawn.IsInTakeCover()) && !pPawn.IsPlayingExitingCover())
        {
            pController = R6PlayerController(pPawn.Controller);
            // End:0x8E
            if(pController != none)
            {
                pController.InvalidateTakeCoverButton();
            }            
        }
        else
        {
            // End:0xFF
            if((pPawn.m_pAI != none) && pPawn.m_pTeamManager != none)
            {
                AIEvent.m_eEventType = 96;
                AIEvent.m_pEventTarget = self;
                pPawn.m_pTeamManager.NotifyTeamManager(pPawn.m_pAI, AIEvent);
            }
        }
        pPawn.UnFreezeRagdoll();        
    }
    else
    {
        // End:0x135
        if(R6DroppedPickup(other) != none)
        {
            R6DroppedPickup(other).InitPhysics();
        }
    }
    // End:0x159
    if((R6Projectile(other) != none) || R6DroppedPickup(other) != none)
    {
        return false;
    }
    return true;
    return;
}

defaultproperties
{
    m_iMaxOpening=20000
    m_iMaxOpeningForDD=20000
    m_ActorName="Rotating Door"
}