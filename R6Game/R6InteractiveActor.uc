class R6InteractiveActor extends Actor
    native
    config(Game)
    notplaceable
    hidecategories(lighting);

enum EInteractiveActorType
{
    INTERACTIVEACTORTYPE_NONE,      // 0
    INTERACTIVEACTORTYPE_DOOR,      // 1
    INTERACTIVEACTORTYPE_SIMPLEOBJECT,// 2
    INTERACTIVEACTORTYPE_WINDOW,    // 3
    INTERACTIVEACTORTYPE_REPLENISH, // 4
    INTERACTIVEACTORTYPE_REFIT,     // 5
    INTERACTIVEACTORTYPE_MAX        // 6
};

enum EInteractiveActorState
{
    INTERACTIVEACTORSTATE_None,     // 0
    INTERACTIVEACTORSTATE_Usable,   // 1
    INTERACTIVEACTORSTATE_UnUsable, // 2
    INTERACTIVEACTORSTATE_MAX       // 3
};

enum EInteractionSound
{
    ISND_Start,                     // 0
    ISND_Success,                   // 1
    ISND_Interrupted,               // 2
    ISND_MAX                        // 3
};

struct InteractingSounds
{
    var() /*0x04000000-0x00000000*/ SoundCue Start;
    var() /*0x04000000-0x00000000*/ SoundCue Stop;
    var() /*0x04000000-0x00000000*/ SoundCue Interruption;

    structdefaultproperties
    {
        Start=none
        Stop=none
        Interruption=none
    }
};

struct InteractionInformation
{
    var Pawn m_pInteractPawn;
    var float m_fLastTimeUsed;
    var int m_iNumberOfTimesUsed;

    structdefaultproperties
    {
        m_pInteractPawn=none
        m_fLastTimeUsed=0.0000000
        m_iNumberOfTimesUsed=0
    }
};

var R6Pawn m_pUser;
var R6Pawn m_pLastUser;
var string m_ActorName;
var class<R6InteractingVolume> m_VolumeClass;
var R6InteractingVolume m_pVolume;
var bool m_bWalkAfterInteract;
var bool m_bCheckInteractRotation;
var bool m_bInteractRotPawnRot;
var(Interaction) bool m_bResetAfterRelease;
var(Interaction) bool m_bCanBeUsed;
var bool m_bCanBeUsedByTeam;
var bool m_bHasMakeNoiseBeenDone;
var bool m_bDisableForGameMode;
var bool m_bPathForwardPlaningUse;
var R6InteractiveActor.EInteractiveActorType m_eType;
var R6InteractiveActor.EInteractiveActorState m_eState;
var config R6EngineEnums.ER6InteractDesc m_eInteractDesc;
var int m_iHealth;
var(Interaction) int m_iInitialHealth;
var(Display) editconst export editinline MeshComponent m_Mesh;
var(AIInteraction) float m_fTimer;
var(AIInteraction) float m_fRadius;
var(AIInteraction) float m_fTimeBetweenUse;
var StaticMesh m_StaticMesh;
var SkeletalMesh m_SkeletalMesh;
var ENavMesh m_pNavMesh;
var(R6Sound) /*0x04000000-0x00000000*/ array<InteractingSounds> m_InteractingSounds;
var R6NavInformation m_pNavInformation;
var R6Pawn m_pProspectiveUser;
var array<InteractionInformation> m_arrInteractionHistory;
var transient bool m_bInvalidForSound;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority))
        m_SkeletalMesh, m_StaticMesh, 
        m_bDisableForGameMode, m_eState, 
        m_iHealth, m_pUser, 
        m_pVolume;
}

// Export UR6InteractiveActor::execGoPhysics(FFrame&, void* const)
native final function GoPhysics(bool bVal);

// Export UR6InteractiveActor::execCheckInteractionHistory(FFrame&, void* const)
native final function bool CheckInteractionHistory(R6Pawn pInteractPawn);

// Export UR6InteractiveActor::execUpdateInteractionHistory(FFrame&, void* const)
native final function UpdateInteractionHistory(R6Pawn pInteractPawn);

// Export UR6InteractiveActor::execHasSpaceToUse(FFrame&, void* const)
native function bool HasSpaceToUse(Pawn pPawn);

// Export UR6InteractiveActor::execGetInteractTime(FFrame&, void* const)
native function float GetInteractTime(R6Pawn pPawn);

// Export UR6InteractiveActor::execPlayInteractionSound(FFrame&, void* const)
native function PlayInteractionSound(R6InteractiveActor.EInteractionSound eSoundInteraction);

// Export UR6InteractiveActor::execAbortInteraction(FFrame&, void* const)
native function AbortInteraction();

simulated function PostBeginPlay()
{
    local editinline StaticMeshComponent pStaticMeshTest;
    local editinline SkeletalMeshComponent pSkeletalMeshTest;

    SetTimer(m_fTimer, true);
    // End:0x25
    if(m_Mesh != none)
    {
        m_Mesh.WakeRigidBody();
    }
    // End:0x40
    if(m_pVolume != none)
    {
        m_pVolume.m_pInteract = self;
    }
    pStaticMeshTest = StaticMeshComponent(m_Mesh);
    // End:0x72
    if(pStaticMeshTest != none)
    {
        m_StaticMesh = pStaticMeshTest.StaticMesh;        
    }
    else
    {
        pSkeletalMeshTest = SkeletalMeshComponent(m_Mesh);
        // End:0xA1
        if(pSkeletalMeshTest != none)
        {
            m_SkeletalMesh = pSkeletalMeshTest.SkeletalMesh;
        }
    }
    m_iHealth = m_iInitialHealth;
    m_eState = ((m_bCanBeUsed) ? 1 : 2);
    PostBeginPlay();
    return;
}

function ResetOriginalData()
{
    m_pUser = none;
    m_arrInteractionHistory.Length = 0;
    m_iHealth = m_iInitialHealth;
    m_eState = ((m_bCanBeUsed) ? 1 : 2);
    m_bHasMakeNoiseBeenDone = false;
    ResetOriginalData();
    return;
}

simulated event bool GetInteractDesc(out R6EngineEnums.ER6InteractDesc eDesc, optional PlayerController PC)
{
    eDesc = m_eInteractDesc;
    return !m_bInteractDisabled && !m_bDisableForGameMode;
    return;
}

simulated event bool GetBusyInteractDesc(out R6EngineEnums.ER6InteractDesc eDesc, PlayerController PC)
{
    // End:0x0B
    if(m_bDisableForGameMode)
    {
        return false;
    }
    // End:0x21
    if(m_bInteractDisabled || m_bShutdown)
    {
        return false;
    }
    // End:0x62
    if(((PC != none) && PC.Pawn != none) && PC.Pawn.IsInTakeCover())
    {
        return false;
    }
    GetInteractDesc(eDesc, PC);
    return true;
    return;
}

simulated function OnToggle(SeqAct_Toggle Action)
{
    // End:0x36
    if((m_Mesh != none) && Action.InputLinks[0].bHasImpulse)
    {
        m_Mesh.WakeRigidBody();
    }
    return;
}

simulated function OnTeleport(SeqAct_Teleport inAction)
{
    local array<Object> objVars;
    local int idx;
    local Actor destActor;

    inAction.GetObjectVars(objVars, "Destination");
    idx = 0;
    J0x28:

    // End:0x65 [Loop If]
    if((idx < objVars.Length) && destActor == none)
    {
        destActor = Actor(objVars[idx]);
        idx++;
        // [Loop Continue]
        goto J0x28;
    }
    // End:0xB1
    if((m_Mesh != none) && destActor != none)
    {
        m_Mesh.SetRBPosition(destActor.Location, destActor.Rotation);
        PlayTeleportEffect(false, true);
    }
    return;
}

function bool IsInterestingForPC(R6PlayerController Controller)
{
    return true;
    return;
}

function Timer()
{
    local R6Pawn InteractPawn;
    local R6AIController aController;

    // End:0xCC
    if((m_pUser == none) && int(m_eState) != int(1))
    {
        // End:0xCB
        foreach CollidingActors(Class'R6Pawn', InteractPawn, m_fRadius)
        {
            // End:0x41
            if(m_pUser != none)
            {
                // End:0xCB
                break;
            }
            aController = R6AIController(InteractPawn.Controller);
            // End:0xCA
            if(((aController != none) && CheckRestrictedActorList(InteractPawn)) && CheckInteractionHistory(InteractPawn))
            {
                // End:0xCA
                if(aController.ChooseToInteract(self))
                {
                    m_pUser = InteractPawn;
                    NetUpdateTime = WorldInfo.TimeSeconds - 1.0000000;
                    UpdateInteractionHistory(InteractPawn);
                }
            }            
        }        
    }
    return;
}

function bool CheckRestrictedActorList(R6Pawn User)
{
    local int idx;
    local SeqEvent_R6AIInteract usedEvent;

    idx = 0;
    J0x07:

    // End:0x6F [Loop If]
    if(idx < GeneratedEvents.Length)
    {
        usedEvent = SeqEvent_R6AIInteract(GeneratedEvents[idx]);
        // End:0x65
        if((usedEvent != none) && usedEvent.bEnabled)
        {
            return usedEvent.CheckActivate(self, User, true);
        }
        idx++;
        // [Loop Continue]
        goto J0x07;
    }
    return false;
    return;
}

event bool InteractWith(R6Pawn User)
{
    local int idx;
    local SeqEvent_R6AIInteract usedEvent;

    idx = 0;
    J0x07:

    // End:0x67 [Loop If]
    if(idx < GeneratedEvents.Length)
    {
        usedEvent = SeqEvent_R6AIInteract(GeneratedEvents[idx]);
        // End:0x5D
        if((usedEvent != none) && usedEvent.bEnabled)
        {
            return ActivateEvent(usedEvent, User);
        }
        idx++;
        // [Loop Continue]
        goto J0x07;
    }
    return false;
    return;
}

function InteractFailure(Pawn pInteractor)
{
    local R6Pawn pR6Pawn;

    pR6Pawn = R6Pawn(pInteractor);
    InteractFailure(pR6Pawn);
    // End:0x55
    if(WorldInfo.Game != none)
    {
        R6GameInfo(WorldInfo.Game).Interacted(self, pInteractor, false);
    }
    m_pUser = none;
    NetUpdateTime = WorldInfo.TimeSeconds - 1.0000000;
    // End:0x99
    if(m_bWalkAfterInteract)
    {
        pInteractor.Controller.ReturnFromInteractState();
    }
    return;
}

function InteractSuccesful(Pawn pInteractor)
{
    InteractSuccesful(pInteractor);
    PlayInteractionSound(1);
    // End:0x4E
    if(WorldInfo.Game != none)
    {
        R6GameInfo(WorldInfo.Game).Interacted(self, pInteractor, true);
    }
    ResetInteraction();
    // End:0x84
    if(m_bWalkAfterInteract && pInteractor != none)
    {
        pInteractor.Controller.PropagateReturnFromInteractState();
    }
    return;
}

// Export UR6InteractiveActor::execResetInteraction(FFrame&, void* const)
native function ResetInteraction();

defaultproperties
{
    m_ActorName="Interactive Actor"
    m_bWalkAfterInteract=true
    m_bInteractRotPawnRot=true
    m_bResetAfterRelease=true
    m_bCanBeUsed=true
    m_bCanBeUsedByTeam=true
    m_eInteractDesc=1
    m_iHealth=-1
    m_iInitialHealth=1
    // Reference: StaticMeshComponent'Default__R6InteractiveActor.InteractiveActorMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="InteractiveActorMesh" class=Class'Engine.StaticMeshComponent'
    end object
    m_Mesh=InteractiveActorMesh
    m_fTimer=1.0000000
    m_fRadius=350.0000000
    bNoDelete=true
    bAlwaysRelevant=true
    bReplicateMovement=false
    bNetInitialRotation=true
    bCollideActors=true
    bBlockActors=true
    bEdShouldSnap=true
    m_bSnakeCamRelevant=true
    // Reference: SpriteComponent'Default__R6InteractiveActor.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Engine.Default__Actor.Sprite'
    begin object name="Sprite"
        Sprite=Texture2D'KellerEditorMaterials.Interaction_64'
    end object
    Components[0]=Sprite
    Components[1]=InteractiveActorMesh
    RemoteRole=1
    m_supportedExplosionEffects=/* Array type was not detected. */
    NetUpdateFrequency=0.1000000
    CollisionComponent=InteractiveActorMesh
    SupportedEvents=/* Array type was not detected. */
}