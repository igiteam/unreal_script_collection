class R6InteractiveDoor extends R6InteractiveActor
    native
    config(Game)
    notplaceable
    hidecategories(lighting);

const kAngleMask = 65535;

enum EDoorMaterial
{
    DOORMAT_WOOD,                   // 0
    DOORMAT_METAL,                  // 1
    DOORMAT_REINFORCED,             // 2
    DOORMAT_GLASS,                  // 3
    DOORMAT_MAX                     // 4
};

enum EChangeState
{
    DOORSTATE_None,                 // 0
    DOORSTATE_Opening,              // 1
    DOORSTATE_Closing,              // 2
    DOORSTATE_MAX                   // 3
};

enum EUseDoor
{
    UD_Open,                        // 0
    UD_Close,                       // 1
    UD_MAX                          // 2
};

struct sDoorStackBorder
{
    var int m_iBorderIdx;
    var int m_iDoorVertexIdx;
    var bool m_bIsInvalid;
    var bool m_bIsUnusableForStack;

    structdefaultproperties
    {
        m_iBorderIdx=0
        m_iDoorVertexIdx=0
        m_bIsInvalid=false
        m_bIsUnusableForStack=false
    }
};

var(R6Door) bool m_bIsLocked;
var(R6Door) bool m_bBreakable;
var(R6Door) bool m_bBreachable;
var bool m_bIsDelayBreakHandleNeeded;
var bool m_bRepOpen;
var bool m_bIsBeingUsedForStack;
var bool m_bIsMeshPositive;
var bool m_bIsDepthPositive;
var bool m_bMasterDoor;
var bool m_bInvalidStack;
var bool sm_bIsLocked;
var bool sm_bIsBreakable;
var bool sm_bIsBreachable;
var bool m_bIsDoorAssaultActive;
var bool m_bBlocked;
var(R6Door) bool m_bSkipPortalAssociation;
var(R6Door) R6InteractiveDoor.EDoorMaterial m_eDoorMaterial;
var(R6Door) R6GameEnums.EDoorToken m_eDoorToken;
var(R6Door) R6GameEnums.EDoorGrenadeToken m_eGrenadeTokenInside;
var(R6Door) R6GameEnums.EDoorGrenadeToken m_eGrenadeTokenOutside;
var R6GameEnums.EDoorToken sm_eDoorToken;
var R6InteractiveDoor.EChangeState m_eDoorState;
var(R6Door) float m_fBumpImpulse;
var(R6Door) float m_fOpenImpulse;
var(R6Door) R6_BreakableActorTemplate m_pBreakTemplate;
var(R6Door) R6_BreakableActorTemplate m_pDoubleBreakTemplate;
var(R6Door) StaticMesh m_pDoubleDoorMesh;
var Controller m_pDelayBHInstigator;
var Vector m_vDelayBHMomentum;
var int m_iHandleHp;
var int sm_iHandleHp;
var name m_HandleTagName;
var Vector m_vHandleFront;
var Vector m_vHandleBack;
var Vector m_vImpactMomentum;
var float m_fDoorLength;
var float m_fDoorWidth;
var R6InteractiveDoor m_pDoubleDoor;
var Rotator m_rOriginalRotation;
var Vector m_vOriginalPosition;
var name m_IkHandleName;
var Vector m_vHitLoc;
var Vector m_vMomentum;
var Vector m_vLastImpulseEffect;
var float m_fSpeedCoef;
var float m_fBounceTimer;
var array<R6Pawn> m_aSnakeCaming;
var array<int> m_aDoorStackVerticeIdx;
var array<int> m_aDoorTrianglesIdx;
var array<int> m_aDoorPortalTrianglesIdx;
var array<int> m_aDoorPortalBordersIdx;
var array<sDoorStackBorder> m_aInsideDoorStackBorder;
var array<sDoorStackBorder> m_aOutsideDoorStackBorder;
var Vector m_vDoorTokenLocation;
var(R6Door) Vector m_vCustomRelativeInsideEntryA;
var(R6Door) Vector m_vCustomRelativeInsideEntryB;
var(R6Door) Vector m_vCustomRelativeOutsideEntryA;
var(R6Door) Vector m_vCustomRelativeOutsideEntryB;
var Vector m_vCustomActualInsideEntryA;
var Vector m_vCustomActualInsideEntryB;
var Vector m_vCustomActualOutsideEntryA;
var Vector m_vCustomActualOutsideEntryB;
var ENavMesh m_pInsideNavMesh;
var ENavMesh m_pOutsideNavMesh;
var int m_iEntryCount;
var Vector m_vOriginalMasterDoorHandleLocation;
var Vector m_vOriginalMasterDoorHingeLocation;
var Vector m_vOriginalDoubleDoorHingeLocation;
var array<Vector> m_vRainbowOutsideStackHandle;
var array<Vector> m_vRainbowOutsideStackHinge;
var array<Vector> m_vRainbowInsideStackHandle;
var array<Vector> m_vRainbowInsideStackHinge;
var array<Vector> m_vRainbowDoubleDoorInside;
var array<Vector> m_vRainbowMasterDoorInside;
var array<Vector> m_vRainbowDoubleDoorOutside;
var array<Vector> m_vRainbowMasterDoorOutside;
var array<Vector> m_vRainbowOpenDoubleDoorInside;
var array<Vector> m_vRainbowOpenMasterDoorInside;
var array<Vector> m_vRainbowInsideEntryLocation;
var array<Vector> m_vRainbowOutsideEntryLocation;
var array<Vector> m_vRainbowDoubleInsideEntry;
var array<Vector> m_vRainbowMasterInsideEntry;
var array<Vector> m_vRainbowDoubleOutsideEntry;
var array<Vector> m_vRainbowMasterOutsideEntry;
var Vector m_vAnimationTrigger;
var Vector m_vAnimationTriggerOnDoubleDoor;
var Vector m_vInsideRelativeForwardEntryLocation;
var Vector m_vOutsideRelativeForwardEntryLocation;
var Vector m_vInsideRelativeEntryLocationFirst;
var Vector m_vInsideRelativeEntryLocationSecond;
var Vector m_vOutsideRelativeEntryLocationFirst;
var Vector m_vOutsideRelativeEntryLocationSecond;
var array<Vector> m_vRainbowInsideFailSafeLocation;
var array<Vector> m_vRainbowOutsideFailSafeLocation;
var array<Vector> m_vRainbowDoubleInsideFailSafeLocation;
var array<Vector> m_vRainbowDoubleOutsideFailSafeLocation;
var array<Vector> m_vRainbowInsideTriggerLocation;
var array<Vector> m_vRainbowOutsideTriggerLocation;
var array<Vector> m_vRainbowDoubleInsideTriggerLocation;
var array<Vector> m_vRainbowDoubleOutsideTriggerLocation;
var Vector m_vLocationOfCenter;
var Vector m_vDoorFrameDirection;
var Vector m_vAmbushPoint;
var Vector m_vCoverLeftPoint;
var Vector m_vOpeningLeftPoint;
var Vector m_vOpeningRightPoint;
var Vector m_vCoverRightPoint;
var Vector m_vNonOpeningLeftPoint;
var Vector m_vNonOpeningRightPoint;
var R6Explosive m_aCharge[2];
var int m_iBorderLeftVert;
var int m_iBorderRightVert;
var int m_iBorderNonOpeningLeftVert;
var int m_iBorderNonOpeningRightVert;
var int m_iBorderHandleOpen;
var int m_iBorderHandleClose;
var int m_iBorderHingesOpen;
var int m_iBorderHingesClose;
var int m_iBorderBeforeHandleOpen;
var int m_iBorderAfterHandleClose;
var int m_iBorderBeforeHingesOpen;
var int m_iBorderAfterHingesClose;
var(R6Sound) /*0x04000000-0x00000000*/ SoundCue m_OpeningSound;
var(R6Sound) /*0x04000000-0x00000000*/ SoundCue m_OpeningSwivelSound;
var(R6Sound) /*0x04000000-0x00000000*/ SoundCue m_OpeningSwivelStopSound;
var(R6Sound) /*0x04000000-0x00000000*/ SoundCue m_ClosingSound;
var(R6Sound) /*0x04000000-0x00000000*/ SoundCue m_ClosingSwivelSound;
var(R6Sound) /*0x04000000-0x00000000*/ SoundCue m_ClosingSwivelStopSound;
var(R6Sound) /*0x04000000-0x00000000*/ SoundCue m_ExplosionSoundCue;
var(R6Sound) /*0x04000000-0x00000000*/ SoundCue m_LockedSound;
var(R6Sound) /*0x04000000-0x00000000*/ SoundCue m_LockPickingSound;
var(R6Sound) /*0x04000000-0x00000000*/ SoundCue m_LockPickingStopSound;
var(R6Sound) /*0x04000000-0x00000000*/ SoundCue m_UnlockSound;
var transient bool m_bSwivelSoundStopped;
var transient Vector m_vHingeSoundLocation;
var transient Vector m_vHandleSoundLocation;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority))
        m_aCharge, m_bBlocked, 
        m_bIsLocked, m_bRepOpen, 
        m_fBumpImpulse, m_fOpenImpulse, 
        m_fSpeedCoef, m_iHandleHp, 
        m_vHitLoc, m_vImpactMomentum, 
        m_vMomentum;

    // Pos:0x00D
    if((int(Role) == int(ROLE_Authority)) && bNetInitial)
        m_eDoorState;
}

// Export UR6InteractiveDoor::execSetExplosiveSide(FFrame&, void* const)
native final function SetExplosiveSide(bool bSide, R6Explosive pExplosive);

// Export UR6InteractiveDoor::execIsSnakeCaming(FFrame&, void* const)
native final function bool IsSnakeCaming(R6Pawn pPawn);

// Export UR6InteractiveDoor::execGetLocationSide(FFrame&, void* const)
native final function bool GetLocationSide(Vector vPos);

// Export UR6InteractiveDoor::execGetBreachPosRot(FFrame&, void* const)
native final function GetBreachPosRot(Pawn pPawn, out Vector vPos, out Rotator rRot);

// Export UR6InteractiveDoor::execGetSnakeCamPosRot(FFrame&, void* const)
native final function GetSnakeCamPosRot(Pawn pPawn, out Vector vPos, out Rotator rRot);

// Export UR6InteractiveDoor::execHasSpaceToSnakeCam(FFrame&, void* const)
native final function bool HasSpaceToSnakeCam(Pawn pPawn);

// Export UR6InteractiveDoor::execHasSpaceToPlaceBreachCharge(FFrame&, void* const)
native final function bool HasSpaceToPlaceBreachCharge(Pawn pPawn);

// Export UR6InteractiveDoor::execIsActorLeftFromDoor(FFrame&, void* const)
native final function bool IsActorLeftFromDoor(Actor pActor);

// Export UR6InteractiveDoor::execCanPCSnakeCam(FFrame&, void* const)
native final function bool CanPCSnakeCam(R6PlayerController pController, Vector vHitLocation);

// Export UR6InteractiveDoor::execOpenBy(FFrame&, void* const)
native final function OpenBy(Actor pLocker);

// Export UR6InteractiveDoor::execCloseBy(FFrame&, void* const)
native final function CloseBy(Actor pLocker);

// Export UR6InteractiveDoor::execCanUseSnakeCam(FFrame&, void* const)
native final function bool CanUseSnakeCam();

// Export UR6InteractiveDoor::execIsOpened(FFrame&, void* const)
native function bool IsOpened();

// Export UR6InteractiveDoor::execIsFullyOpened(FFrame&, void* const)
native function bool IsFullyOpened();

// Export UR6InteractiveDoor::execIsBroken(FFrame&, void* const)
native final function bool IsBroken();

// Export UR6InteractiveDoor::execCloseToHandle(FFrame&, void* const)
native final function bool CloseToHandle(Vector vPos);

// Export UR6InteractiveDoor::execImpulseOpensDoor(FFrame&, void* const)
native function bool ImpulseOpensDoor(Vector vImpulse);

// Export UR6InteractiveDoor::execBreakHandle(FFrame&, void* const)
native function BreakHandle(Vector vMomentum, Controller pInstigator, optional bool bSwitchMesh);

// Export UR6InteractiveDoor::execBreakDoor(FFrame&, void* const)
native function BreakDoor(Vector vHitLocation, Vector vMomentum, Controller pInstigator);

// Export UR6InteractiveDoor::execTriggerDelayedBreakHandle(FFrame&, void* const)
native function TriggerDelayedBreakHandle();

// Export UR6InteractiveDoor::execSetDoorState(FFrame&, void* const)
native final function SetDoorState(R6InteractiveDoor.EChangeState eState);

// Export UR6InteractiveDoor::execSetupSoundLocations(FFrame&, void* const)
native final function SetupSoundLocations();

// Export UR6InteractiveDoor::execPlayDoorSound(FFrame&, void* const)
native final function PlayDoorSound(R6InteractiveDoor.EChangeState eState, R6GameEnums.EPawnInteractionType eInteraction);

// Export UR6InteractiveDoor::execSendAISoundEvent(FFrame&, void* const)
native final function SendAISoundEvent();

// Export UR6InteractiveDoor::execTriggerNextEntry(FFrame&, void* const)
native final function TriggerNextEntry();

// Export UR6InteractiveDoor::execGetEntryTriggerTimer(FFrame&, void* const)
native final function float GetEntryTriggerTimer(R6Pawn pPawn);

// Export UR6InteractiveDoor::execSpawnBrokenPieces(FFrame&, void* const)
native final function SpawnBrokenPieces(Vector vHitLocation, Vector vMomentum);

// Export UR6InteractiveDoor::execSetLock(FFrame&, void* const)
native final function SetLock(bool bLock);

simulated function PostBeginPlay()
{
    local editinline StaticMeshComponent pMesh;
    local Vector vPos;
    local Rotator rRot;

    switch(m_eDoorMaterial)
    {
        // End:0x39
        case 0:
            m_iInitialHealth = GetHealthConfig().m_iWoodHealth;
            m_iHandleHp = GetHealthConfig().m_iWoodHandleLockHealth;
            // End:0xE8
            break;
        // End:0x6B
        case 1:
            m_iInitialHealth = GetHealthConfig().m_iMetalHealth;
            m_iHandleHp = GetHealthConfig().m_iMetalHandleLockHealth;
            // End:0xE8
            break;
        // End:0x9D
        case 2:
            m_iInitialHealth = GetHealthConfig().m_iReinforcedHealth;
            m_iHandleHp = GetHealthConfig().m_iReinforcedHandleLockHealth;
            // End:0xE8
            break;
        // End:0xCF
        case 3:
            m_iInitialHealth = GetHealthConfig().m_iGlassHealth;
            m_iHandleHp = GetHealthConfig().m_iGlassHandleLockHealth;
            // End:0xE8
            break;
        // End:0xFFFF
        default:
            m_iInitialHealth = 500;
            m_iHandleHp = 100;
            // End:0xE8
            break;
            break;
    }
    sm_iHandleHp = m_iHandleHp;
    // End:0x1AB
    if(int(WorldInfo.NetMode) != int(NM_Client))
    {
        pMesh = StaticMeshComponent(m_Mesh);
        // End:0x195
        if(pMesh != none)
        {
            // End:0x15E
            if(pMesh.GetTag('Handle_F', vPos, rRot))
            {
                m_vHandleFront = vPos;
                m_HandleTagName = 'Handle_F';
            }
            // End:0x195
            if(pMesh.GetTag('Handle_B', vPos, rRot))
            {
                m_vHandleBack = vPos;
                m_HandleTagName = 'Handle_B';
            }
        }
        m_rOriginalRotation = Rotation;
        m_vOriginalPosition = Location;
    }
    SetupSoundLocations();
    // End:0x1D5
    if(m_R6Sound != none)
    {
        m_R6Sound.m_bDontActivate = !IsOpened();
    }
    PostBeginPlay();
    return;
}

function SaveOriginalData()
{
    sm_bIsLocked = m_bIsLocked;
    sm_bIsBreakable = m_bBreakable;
    sm_bIsBreachable = m_bBreachable;
    sm_iHandleHp = m_iHandleHp;
    sm_eDoorToken = m_eDoorToken;
    SaveOriginalData();
    return;
}

function InteractSuccesful(Pawn pInteractor)
{
    local R6Pawn pPawn;

    pPawn = R6Pawn(pInteractor);
    // End:0x37
    if(pPawn != none)
    {
        PlayDoorSound(m_eDoorState, pPawn.m_ePawnInteraction);        
    }
    else
    {
        PlayDoorSound(m_eDoorState, 0);
    }
    InteractSuccesful(pInteractor);
    // End:0xBF
    if(pPawn != none)
    {
        pPawn.m_ePawnInteraction = 0;
        EnableBlockingVolume(false, pInteractor);
        // End:0xA6
        if((m_pDoubleDoor != none) && !m_bMasterDoor)
        {
            m_pDoubleDoor.TriggerInteractSuccessEvent(pInteractor);
        }
        pInteractor.Controller.PropagateReturnFromInteractState();
    }
    return;
}

simulated function R6Explosive GetExplosiveSide(bool bSide)
{
    // End:0x14
    if(bSide)
    {
        return m_aCharge[1];        
    }
    else
    {
        return m_aCharge[0];
    }
    return;
}

simulated function bool CanBreach(bool bSide)
{
    return (((m_bBreachable && (GetExplosiveSide(bSide)) == none) && !IsOpened()) && m_iHealth > 0) && int(m_eDoorState) == int(0);
    return;
}

simulated event bool IsBreached()
{
    return m_bBreachable && ((GetExplosiveSide(false)) != none) || (GetExplosiveSide(true)) != none;
    return;
}

simulated event bool GetInteractDesc(out R6EngineEnums.ER6InteractDesc eDesc, optional PlayerController PC)
{
    local R6PlayerController pR6PC;

    // End:0x16
    if(IsOpened())
    {
        eDesc = 2;        
    }
    else
    {
        pR6PC = R6PlayerController(PC);
        // End:0x5F
        if((pR6PC != none) && CanPCSnakeCam(pR6PC, pR6PC.m_InteractionInfo.m_vCollision))
        {
            eDesc = 4;            
        }
        else
        {
            // End:0x75
            if(m_bIsLocked)
            {
                eDesc = 2;
                return false;                
            }
            else
            {
                // End:0xB0
                if((int(m_eDoorState) != int(1)) && !IsOpened() || int(m_eDoorState) == int(2))
                {
                    eDesc = 3;                    
                }
                else
                {
                    eDesc = 2;
                }
            }
        }
    }
    return !m_bInteractDisabled && !m_bDisableForGameMode;
    return;
}

// Export UR6InteractiveDoor::execIsDoubleCloser(FFrame&, void* const)
native final simulated function bool IsDoubleCloser(Pawn pPawn);

simulated event bool GetBusyInteractDesc(out R6EngineEnums.ER6InteractDesc eDesc, PlayerController PC)
{
    // End:0x30
    if((((m_iHealth == 0) || m_iHandleHp == 0) || m_bIsLocked) || m_bDisableForGameMode)
    {
        return false;
    }
    // End:0x94
    if(((PC != none) && PC.Pawn != none) && PC.Pawn.IsInTakeCover())
    {
        // End:0x7B
        if(IsOpened())
        {
            return false;
        }
        // End:0x94
        if(IsDoubleCloser(PC.Pawn))
        {
            return false;
        }
    }
    GetInteractDesc(eDesc, PC);
    return true;
    return;
}

simulated function OnR6ToggleDoorParams(SeqAct_R6ToggleDoorParams inAction)
{
    // End:0xB8
    if(inAction.InputLinks[0].bHasImpulse)
    {
        // End:0x33
        if(inAction.bToggleCanBeUsed)
        {
            m_eState = 1;
        }
        // End:0x4D
        if(inAction.bToggleBreakable)
        {
            m_bBreakable = true;
        }
        // End:0x67
        if(inAction.bToggleBreachable)
        {
            m_bBreachable = true;
        }
        // End:0x80
        if(inAction.bToggleLocked)
        {
            SetLock(true);
        }
        // End:0x9A
        if(inAction.bToggleDisableForGameMode)
        {
            m_bDisableForGameMode = true;
        }
        NetUpdateTime = WorldInfo.TimeSeconds - 1.0000000;        
    }
    else
    {
        // End:0x170
        if(inAction.InputLinks[1].bHasImpulse)
        {
            // End:0xEB
            if(inAction.bToggleCanBeUsed)
            {
                m_eState = 2;
            }
            // End:0x105
            if(inAction.bToggleBreakable)
            {
                m_bBreakable = false;
            }
            // End:0x11F
            if(inAction.bToggleBreachable)
            {
                m_bBreachable = false;
            }
            // End:0x138
            if(inAction.bToggleLocked)
            {
                SetLock(false);
            }
            // End:0x152
            if(inAction.bToggleDisableForGameMode)
            {
                m_bDisableForGameMode = false;
            }
            NetUpdateTime = WorldInfo.TimeSeconds - 1.0000000;            
        }
        else
        {
            // End:0x256
            if(inAction.InputLinks[2].bHasImpulse)
            {
                // End:0x1B8
                if(inAction.bToggleCanBeUsed)
                {
                    m_eState = ((int(m_eState) != int(1)) ? 1 : 2);
                }
                // End:0x1D9
                if(inAction.bToggleBreakable)
                {
                    m_bBreakable = !m_bBreakable;
                }
                // End:0x1FA
                if(inAction.bToggleBreachable)
                {
                    m_bBreachable = !m_bBreachable;
                }
                // End:0x21A
                if(inAction.bToggleLocked)
                {
                    SetLock(!m_bIsLocked);
                }
                // End:0x23B
                if(inAction.bToggleDisableForGameMode)
                {
                    m_bDisableForGameMode = !m_bDisableForGameMode;
                }
                NetUpdateTime = WorldInfo.TimeSeconds - 1.0000000;
            }
        }
    }
    return;
}

event StartInteractTimer(R6GameEnums.EPawnInteractionType EType)
{
    local float fTime;

    // End:0x6C
    if((((int(EType) == int(1)) || int(EType) == int(2)) || int(EType) == int(4)) || int(EType) == int(3))
    {
        fTime = GetInteractLengthsConfig().m_fTcOpenDoorClose;
        SetTimer(fTime, false, 'InteractTimerOpen');        
    }
    else
    {
        // End:0xD5
        if((((int(EType) == int(5)) || int(EType) == int(6)) || int(EType) == int(8)) || int(EType) == int(7))
        {
            fTime = GetInteractLengthsConfig().m_fTcOpenDoorFar;
            SetTimer(fTime, false, 'InteractTimerOpen');
        }
    }
    return;
}

function InteractTimerOpen()
{
    SetDoorState(1);
    return;
}

event ResetEntryCount()
{
    m_iEntryCount = 0;
    return;
}

event StartDoorEntryTriggerTimer(R6Pawn pPawn)
{
    local float fTime;

    fTime = GetEntryTriggerTimer(pPawn);
    SetTimer(fTime, false, 'TriggerNextEntry');
    return;
}

event StartAISoundEventTimer()
{
    local float fTime;

    fTime = 0.5000000;
    SetTimer(fTime, false, 'SendAISoundEvent');
    return;
}

event StartDelayedBreakHandleTimer()
{
    local float fTime;

    fTime = 1.7000000;
    SetTimer(fTime, false, 'TriggerDelayedBreakHandle');
    return;
}

event ActivateBreachedEvent(Actor pInstigator)
{
    TriggerEventClass(Class'SeqEvent_R6DoorBreached', pInstigator);
    return;
}

defaultproperties
{
    m_bBreakable=true
    m_bBreachable=true
    m_fBumpImpulse=100.0000000
    m_fOpenImpulse=1000.0000000
    m_iHandleHp=-1
    m_fSpeedCoef=1.0000000
    m_eType=1
    m_fRadius=100.0000000
    m_bIsDynamicObstacle=true
    UseCharacterLights=true
    m_bIsDoor=true
    m_bIgnoreForNavMesh=true
    // Reference: SpriteComponent'Default__R6InteractiveDoor.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__R6InteractiveActor.Sprite'
    begin object name="Sprite"
        Sprite=Texture2D'EngineResources.Door'
        HiddenEditor=true
    end object
    Components[0]=Sprite
    // Reference: StaticMeshComponent'Default__R6InteractiveDoor.InteractiveActorMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6InteractiveActor.InteractiveActorMesh'
    begin object name="InteractiveActorMesh"
    end object
    Components[1]=InteractiveActorMesh
    Physics=12
    TickGroup=1
    SupportedEvents=/* Array type was not detected. */
}