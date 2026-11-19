class R6PlayerController extends PlayerController
    native
    config(Game)
    hidecategories(lighting);

enum EHideReticle
{
    HideReticle_Menu,               // 0
    HideReticle_Scoping,            // 1
    HideReticle_SnakeCam,           // 2
    HideReticle_FadeScreen,         // 3
    HideReticle_TacticalMap,        // 4
    HideReticle_MAX                 // 5
};

struct RayCastInfo
{
    var Vector m_vDir;
    var Vector m_vCollision;
    var Vector m_vNormal;
    var Actor m_ActorCollision;
    var bool m_bCollided;
    var float m_fDist;
    var Level m_pLevel;

    structdefaultproperties
    {
        m_vDir=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_vCollision=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_vNormal=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_ActorCollision=none
        m_bCollided=false
        m_fDist=0.0000000
        m_pLevel=none
    }
};

struct SVisualEffect
{
    var Actor m_instigator;
    var R6PCVisualEffect m_effect;

    structdefaultproperties
    {
        m_instigator=none
        m_effect=none
    }
};

struct CustomHeadDataChunk
{
    var int m_Size;
    var int m_Offset;
    var byte m_Data[12];

    structdefaultproperties
    {
        m_Size=0
        m_Offset=0
        m_Data[0]=0
        m_Data[1]=0
        m_Data[2]=0
        m_Data[3]=0
        m_Data[4]=0
        m_Data[5]=0
        m_Data[6]=0
        m_Data[7]=0
        m_Data[8]=0
        m_Data[9]=0
        m_Data[10]=0
        m_Data[11]=0
    }
};

struct CustomHeadNetState
{
    var int m_PlayerID;
    var int m_Offset;
    var byte m_NetState;
    var int m_Stack;

    structdefaultproperties
    {
        m_PlayerID=0
        m_Offset=0
        m_NetState=0
        m_Stack=0
    }
};

struct WalkingPosition
{
    var Vector m_vLocation;
    var Rotator m_rRotation;

    structdefaultproperties
    {
        m_vLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_rRotation=(Pitch=0,Yaw=0,Roll=0)
    }
};

struct SAutoAimInfo
{
    var string m_szName;
    var Vector m_vPosition;
    var float m_fStrength;

    structdefaultproperties
    {
        m_szName=""
        m_vPosition=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_fStrength=0.0000000
    }
};

struct HitSource
{
    var bool m_bAll;
    var Pawn m_pPawn;
    var float m_fRemainingTime;

    structdefaultproperties
    {
        m_bAll=false
        m_pPawn=none
        m_fRemainingTime=0.0000000
    }
};

struct SPawnReticuleDistance
{
    var R6Pawn m_pPawn;
    var float m_fDistance;

    structdefaultproperties
    {
        m_pPawn=none
        m_fDistance=0.0000000
    }
};

var bool m_bLastFireButton;
var bool m_bAllowVisionMode;
var bool m_bVisionModeEnable;
var bool m_bApplySwitchCoverRot;
var bool m_bLookAtMyPawn;
var bool m_bWaitingForInteractionReplication;
var bool m_bHasRainbowAITeammates;
var bool m_bTagEnemyButton;
var bool m_bTagEnemyButtonHeld;
var bool m_bReloadButton;
var bool m_bReloadButtonHeld;
var bool m_bVisionButton;
var bool m_bVisionButtonHeld;
var bool m_bSwitchWeaponButton;
var bool m_bSwitchWeaponButtonHeld;
var bool m_bGiveOrderButton;
var bool m_bFiringInputEnabled;
var bool m_bPendingJump;
var bool m_bPendingShoot;
var bool m_bWantsToCrouch;
var bool m_bFPMove;
var bool m_bTakeCoverButtonPress;
var bool m_bTakeCoverButtonInvalidated;
var bool m_bCanMoveInTakeCover;
var bool m_bUseDeltaCameraRot;
var bool m_bDisableCameraInput;
var bool m_bCenteringCamera;
var bool m_bDisableUpdatePawnRotation;
var bool m_bZoomOnPawnCycle;
var bool m_bReverseVertical;
var bool m_bInsideVehicle;
var bool m_bIsSnakeCam;
var bool m_bHasBeenWarned;
var bool m_bSendCustomHead;
var R6Pawn m_R6Pawn;
var R6Camera m_R6PlayerCamera;
var R6PlayerInput m_R6PlayerInput;
var repnotify R6CheatManager m_R6CheatManager;
var R6CheatInput m_R6CheatInput;
var R6ProfileInput m_R6ProfileInput;
var R6KellerCheats m_R6Cheats;
var float m_fLastVisionModeOrder;
var R6EngineEnums.EVisionMode m_eLastVisionMode;
var R6InventoryManager.EGadgetNum m_eSelectedGadgetNum;
var R6GameEnums.ESOLSelection m_eSOLChosen;
var R6Gadget m_SelectedGadget;
var float m_fLockGadgetButtonTimer;
var array<SVisualEffect> m_gaussianBlurEffects;
var R6PCVisualEffect m_fireMotionBlurEffect;
var array<SVisualEffect> m_motionBlurEffects;
var array<SVisualEffect> m_flashEffects;
var native const Pointer m_pSceneContext;
var int m_iSceneContextTick;
var RayCastInfo m_LookAtInfo;
var RayCastInfo m_OrderAtInfo;
var RayCastInfo m_InteractionInfo;
var Vector m_vFixedLookAt;
var R6OrderController m_OrdersController;
var R6TeamStateMgr m_TeamStateMgr;
var Actor m_pInteractingObject;
var Actor m_pInsideInteractionRadius;
var R6PIPController m_PIPController;
var R6Radar m_Radar;
var Actor m_pWaypointActor;
var Actor m_pObjectiveWaypoint;
var Vector m_vWaypointLoc;
var R6RadarReplicationManager m_RadarReplicationManager;
var float m_fOldPawnWalkingPct;
var float m_fOldPawnCrouchedPct;
var WalkingPosition m_LastWalkingPos;
var R6MagmaInteractionInGameBase m_MagmaInteraction;
var Vector m_vDestination;
var Actor m_pInteractionActor;
var R6Gadget m_pPendingGadget;
var R6Gadget m_pGadgetToUse;
var array<SAutoAimInfo> m_autoAimInfos;
var SoundCue m_rejectSound;
var array<HitSource> m_arrHitSources;
var Double m_fAINormalRadiusOverrideTime;
var array<Pointer> m_aNearCoverLocations;
var Rotator m_rDeltaCameraRot;
var Rotator m_rRotationWithoutBase;
var float m_fPitchLookSpeed;
var float m_fYawLookSpeed;
var Rotator m_rFPMeshLook;
var transient Vector m_vExplosionLocation;
var transient R6BulletFlyby m_BulletFlyby;
var SoundCue m_VisionActivationSound;
var SoundCue m_VisionLoopingSound;
var SoundCue m_VisionDeactivationSound;
var SoundCue m_VisionLoopingStopSound;
var SoundCue m_MotionSensorSound;
var float m_fScopeDOFStrength;
var float m_fScopeDOFFocus;
var float m_fTakeCoverDOFStrength;
var R6PickupableActor m_pNearestPickupable;
var float m_fFastRopeDampSpeed;
var R6Pawn m_Tags[2];
var transient array<SPawnReticuleDistance> m_TagRequestSortedPawns;
var transient bool m_bPendingTagRequest;
var transient bool m_bPendingTagProcessed;
var transient bool m_bPendingTagRequestReady;
var int m_ReticleHidingFlags;
var int m_iScopeBeforeInteraction;
var array<CustomHeadNetState> m_aCustomHeadNetState;
var int m_CurrentCustomHeadID;
var R6ComputedCoverData_Ptr m_pComputedCoverData;
var R6ComputedCornerData_Ptr m_pComputedCornerData;
var R6ComputedFindPath_Ptr m_pComputedSafePathData;
var R6ComputedSearchData_Ptr m_pComputedSearchData;
var R6ComputedAmbushData_Ptr m_pComputedAmbushData;
var R6ComputedAdvanceData_Ptr m_pComputedAdvanceData;
var string m_szPendingObjectiveText;

replication
{
    // Pos:0x000
    if((int(Role) == int(ROLE_Authority)) && bNetOwner)
        m_R6CheatManager, m_bAllowVisionMode, 
        m_bDisableCameraInput, m_bDisableUpdatePawnRotation, 
        m_bVisionModeEnable, m_pNearestPickupable, 
        m_rRotationWithoutBase;

    // Pos:0x018
    if(((int(Role) == int(ROLE_Authority)) && bNetOwner) && bNetInitial)
        m_RadarReplicationManager;
}

// Export UR6PlayerController::execUpdateR6Pawn(FFrame&, void* const)
native final function UpdateR6Pawn();

// Export UR6PlayerController::execDoBlockFirstPersonView(FFrame&, void* const)
native final function DoBlockFirstPersonView(bool bBlock, bool bFixCamera);

// Export UR6PlayerController::execHasLineOfSight(FFrame&, void* const)
native final function bool HasLineOfSight(Actor pActorA, Actor pActorB);

// Export UR6PlayerController::execUpdateAimRotationToLookat(FFrame&, void* const)
native final function UpdateAimRotationToLookat();

// Export UR6PlayerController::execCanMoveInTakeCover(FFrame&, void* const)
native final function bool CanMoveInTakeCover();

// Export UR6PlayerController::execCheckRopeAttach(FFrame&, void* const)
native final function bool CheckRopeAttach(Actor pActor, Vector vPosition);

// Export UR6PlayerController::execUpdateLookAtInfo(FFrame&, void* const)
native final function UpdateLookAtInfo();

// Export UR6PlayerController::execFixLookAtPoint(FFrame&, void* const)
native final function FixLookAtPoint();

// Export UR6PlayerController::execResetFixLookAt(FFrame&, void* const)
native final function ResetFixLookAt();

// Export UR6PlayerController::execPawnSwitchCover(FFrame&, void* const)
native final function PawnSwitchCover();

// Export UR6PlayerController::execUpdateLookAtFriendly(FFrame&, void* const)
native final function UpdateLookAtFriendly();

// Export UR6PlayerController::execApplyRotationAdhesion(FFrame&, void* const)
native final function ApplyRotationAdhesion(Rotator rViewRotation, out Rotator rDeltaRot, float fDeltaTime);

// Export UR6PlayerController::execWaitCenterController(FFrame&, void* const)
native final latent function WaitCenterController();

// Export UR6PlayerController::execPlayHitEffect(FFrame&, void* const)
native final function PlayHitEffect(Pawn InstigatedBy, Vector HitLoc, Vector Momentum);

// Export UR6PlayerController::execDoInteract(FFrame&, void* const)
native final function DoInteract();

// Export UR6PlayerController::execLockGadgetButton(FFrame&, void* const)
native final function LockGadgetButton();

// Export UR6PlayerController::execChangePlayerView(FFrame&, void* const)
native final function ChangePlayerView(bool bNext);

// Export UR6PlayerController::execGetActivePlayerView(FFrame&, void* const)
native final function Actor GetActivePlayerView();

// Export UR6PlayerController::execOnPlayerUpdateSpectating(FFrame&, void* const)
native function OnPlayerUpdateSpectating(float fDeltaTime);

// Export UR6PlayerController::execApplyBaseRotation(FFrame&, void* const)
native final function ApplyBaseRotation(out Rotator rViewRotation);

// Export UR6PlayerController::execGetForcedViewRotation(FFrame&, void* const)
native final function Rotator GetForcedViewRotation();

// Export UR6PlayerController::execForceViewRotation(FFrame&, void* const)
native final function ForceViewRotation(Rotator rNewRotation);

// Export UR6PlayerController::execBaseAffectsView(FFrame&, void* const)
native final function bool BaseAffectsView(Actor pBase);

// Export UR6PlayerController::execProcessVisualEffects(FFrame&, void* const)
native function ProcessVisualEffects(float fDelta);

// Export UR6PlayerController::execFlushVisualEffects(FFrame&, void* const)
native function FlushVisualEffects();

// Export UR6PlayerController::execShowWhiteFlash(FFrame&, void* const)
native function ShowWhiteFlash();

// Export UR6PlayerController::execInteractWithActor(FFrame&, void* const)
native final function InteractWithActor();

// Export UR6PlayerController::execUseGadgetWithActor(FFrame&, void* const)
native final function UseGadgetWithActor();

// Export UR6PlayerController::execFadeInSounds(FFrame&, void* const)
native final function FadeInSounds();

// Export UR6PlayerController::execIsImpactRelevant(FFrame&, void* const)
native final function bool IsImpactRelevant(Vector vHitLocation, Vector vSourceLocation);

// Export UR6PlayerController::execClientProcessInstantHitNative(FFrame&, void* const)
native final function ClientProcessInstantHitNative(Vector vSourceLocation, Vector vHitLocation, R6Pawn pPawn, bool bIsRainbow, bool bDamaged, bool bBulletTracers);

// Export UR6PlayerController::execResetVisionMode(FFrame&, void* const)
native final function ResetVisionMode();

// Export UR6PlayerController::execCommunicateVisionModeActivation(FFrame&, void* const)
native function CommunicateVisionModeActivation();

// Export UR6PlayerController::execActivateFlashNative(FFrame&, void* const)
native function ActivateFlashNative(Actor pEffectInstigator, float fRetinaImprintOpacity, float fInterpolationSpeed, float fFullStrengthDuration, float fFadeDuration, int iGrabFrameNbIteration, float fGrabFrameBlurWidth, bool bNegate, bool bDesaturate);

// Export UR6PlayerController::execActivateDizzinessNative(FFrame&, void* const)
native function ActivateDizzinessNative(Actor pEffectInstigator, float fMotionBlurOpacity, float fInterpolationSpeed, float fFullStrengthDuration, float fFadeDuration);

// Export UR6PlayerController::execActivateVisionBlurNative(FFrame&, void* const)
native function ActivateVisionBlurNative(Actor pEffectInstigator, float fGaussianBlurOpacity, float fInterpolationSpeed, float fFullStrengthDuration, float fFadeDuration);

// Export UR6PlayerController::execDoDeafeningEffect(FFrame&, void* const)
reliable client native simulated event DoDeafeningEffect(Actor pEffectInstigator, Vector vOrigin);

// Export UR6PlayerController::execIsWaitingDelayExpired(FFrame&, void* const)
native final function bool IsWaitingDelayExpired();

// Export UR6PlayerController::execCanRestart(FFrame&, void* const)
native final function bool CanRestart();

// Export UR6PlayerController::execOnRestart(FFrame&, void* const)
native function OnRestart(bool bVehicleTransition);

// Export UR6PlayerController::execOnClientRestart(FFrame&, void* const)
native function OnClientRestart(Pawn NewPawn);

// Export UR6PlayerController::execCalculateFireDirectionWithReticle(FFrame&, void* const)
native final function CalculateFireDirectionWithReticle(out Vector vAimLoc, out Vector vAimDir, bool bApplyAutoAim, optional bool bSetCollideLoc, optional Vector vCollideLoc);

// Export UR6PlayerController::execUpdateCenterCamera(FFrame&, void* const)
native final function UpdateCenterCamera(float fDeltaTime);

// Export UR6PlayerController::execGetPlayerInfo(FFrame&, void* const)
native function R6PlayerReplicationInfo GetPlayerInfo();

// Export UR6PlayerController::execGetTeamInfo(FFrame&, void* const)
native function R6TeamInfo GetTeamInfo();

// Export UR6PlayerController::execUpdateRotation(FFrame&, void* const)
native function UpdateRotation(float fDeltaTime);

// Export UR6PlayerController::execUpdateAimRotation(FFrame&, void* const)
native function UpdateAimRotation(Rotator rViewRotation);

// Export UR6PlayerController::execGetCameraDeltaRotation(FFrame&, void* const)
native function Rotator GetCameraDeltaRotation(float fDeltaTime);

// Export UR6PlayerController::execSetBaseRotation(FFrame&, void* const)
native function SetBaseRotation();

// Export UR6PlayerController::execUpdateFPMeshLook(FFrame&, void* const)
native function UpdateFPMeshLook(Rotator rDeltaRot, float fDeltaTime);

// Export UR6PlayerController::execGetNearestPickupableItem(FFrame&, void* const)
native function R6PickupableActor GetNearestPickupableItem();

// Export UR6PlayerController::execUpdateNearestPickupableItem(FFrame&, void* const)
native function UpdateNearestPickupableItem();

// Export UR6PlayerController::execNotifyPickupAmmo(FFrame&, void* const)
native function NotifyPickupAmmo(class<R6Weapon> pWeaponClass, int iNbAmmo);

// Export UR6PlayerController::execNotifyPickupNoAmmoTaken(FFrame&, void* const)
native function NotifyPickupNoAmmoTaken(class<R6Weapon> pWeaponClass);

// Export UR6PlayerController::execNativeTagEnemy(FFrame&, void* const)
native final function NativeTagEnemy();

// Export UR6PlayerController::execHideReticle(FFrame&, void* const)
native final function HideReticle(byte eReason, bool bHide);

// Export UR6PlayerController::execForceShowReticle(FFrame&, void* const)
native final function ForceShowReticle();

// Export UR6PlayerController::execHandlePECMatchEnded(FFrame&, void* const)
native simulated function HandlePECMatchEnded(float fTimePlayed, bool bWon);

// Export UR6PlayerController::execFadeScreen(FFrame&, void* const)
native final function FadeScreen(out FadeParams FadeParams);

// Export UR6PlayerController::execSetMainMenuParameters(FFrame&, void* const)
native final function SetMainMenuParameters(bool PlayerBanned, bool TeamKillerBanned, bool PunkBusterBanned, optional bool RankedMatchFinished);

// Export UR6PlayerController::execOnMissionComplete(FFrame&, void* const)
native final function OnMissionComplete();

// Export UR6PlayerController::execOnRoundEnded(FFrame&, void* const)
native final function OnRoundEnded();

// Export UR6PlayerController::execOnGadgetUsed(FFrame&, void* const)
native final function OnGadgetUsed(R6Gadget pGadget);

// Export UR6PlayerController::execClientGiveAward(FFrame&, void* const)
reliable client native final simulated function ClientGiveAward(R6EngineEnums.EAward EAward);

// Export UR6PlayerController::execClientOnKilledCanisterCarrier(FFrame&, void* const)
reliable client native final simulated function ClientOnKilledCanisterCarrier();

// Export UR6PlayerController::execClientOnCanisterReturned(FFrame&, void* const)
reliable client native final simulated function ClientOnCanisterReturned();

// Export UR6PlayerController::execClientOnKilledPlayer(FFrame&, void* const)
reliable client native final simulated function ClientOnKilledPlayer(R6EngineEnums.EAwardKillDetail eDetail);

// Export UR6PlayerController::execClientOnDied(FFrame&, void* const)
reliable client native final simulated function ClientOnDied();

// Export UR6PlayerController::execClientOnHostageRescued(FFrame&, void* const)
reliable client native final simulated function ClientOnHostageRescued(int iHostagesTotal);

// Export UR6PlayerController::execClientOnClanMatchWon(FFrame&, void* const)
reliable client native final simulated function ClientOnClanMatchWon();

// Export UR6PlayerController::execSwitchGadget(FFrame&, void* const)
native function SwitchGadget();

// Export UR6PlayerController::execClearPickupableItems(FFrame&, void* const)
native function ClearPickupableItems();

// Export UR6PlayerController::execDampSpeedOnPickup(FFrame&, void* const)
native function DampSpeedOnPickup(float fDeltaTime);

// Export UR6PlayerController::execPlayFiringForceFeedback(FFrame&, void* const)
native function PlayFiringForceFeedback();

// Export UR6PlayerController::execStopFiringForceFeedback(FFrame&, void* const)
native function StopFiringForceFeedback();

// Export UR6PlayerController::execClientSpawnExplosion(FFrame&, void* const)
reliable client native simulated event ClientSpawnExplosion(Vector vExplosionLocation, R6ExplosionParams pExplosionParams);

function NotifyAddInventory(Inventory NewItem)
{
    local R6Gadget pGadget;
    local int iGadget;

    NotifyAddInventory(NewItem);
    // End:0xF6
    if(m_SelectedGadget == none)
    {
        pGadget = R6Gadget(NewItem);
        // End:0xF6
        if((pGadget != none) && pGadget.m_bSelectable)
        {
            m_SelectedGadget = pGadget;
            iGadget = m_R6Pawn.m_R6InvManager.m_iGadgetIndex;
            J0x6E:

            // End:0xF6 [Loop If]
            if(iGadget < m_R6Pawn.m_R6InvManager.m_inventorySlots.Length)
            {
                // End:0xEC
                if(m_R6Pawn.m_R6InvManager.m_inventorySlots[iGadget].m_item == pGadget)
                {
                    m_eSelectedGadgetNum = byte((iGadget - m_R6Pawn.m_R6InvManager.m_iGadgetIndex) + 1);
                    // [Explicit Break]
                    goto J0xF6;
                }
                iGadget++;
                // [Loop Continue]
                goto J0x6E;
            }
        }
    }
    J0xF6:

    return;
}

simulated event RemovePawnFromTag(R6Pawn pPawn)
{
    // End:0x2C
    if(m_Tags[0] == pPawn)
    {
        m_Tags[0] = m_Tags[1];
        m_Tags[1] = none;        
    }
    else
    {
        // End:0x46
        if(m_Tags[1] == pPawn)
        {
            m_Tags[1] = none;
        }
    }
    return;
}

unreliable server function ServerViewNextPlayer()
{
    return;
}

unreliable server function ServerViewPrevPlayer()
{
    return;
}

simulated event PostBeginPlay()
{
    PostBeginPlay();
    m_R6PlayerCamera = R6Camera(PlayerCamera);
    // End:0x83
    if(!GetGameManager().IsMultiplayer())
    {
        // End:0x4C
        if(m_TeamStateMgr == none)
        {
            m_TeamStateMgr = __NFUN_278__(Class'R6TeamStateMgr');
        }
        m_TeamStateMgr.Init(self);
        m_OrdersController = new (self) Class'R6OrderController';        
        m_OrdersController.Init(self, m_TeamStateMgr);
    }
    m_PIPController = new (self) Class'R6PIPController';    
    m_PIPController.Init(self);
    m_Radar = new (self) Class'R6Radar';    
    m_Radar.Init(self);
    m_fireMotionBlurEffect = new (self) Class'R6PCVisualEffect';    
    // End:0xF2
    if(m_PawnRepInfo != none)
    {
        m_PawnRepInfo.Destroy();
        m_PawnRepInfo = none;
    }
    // End:0x150
    if(int(WorldInfo.NetMode) != int(NM_Client))
    {
        m_PawnRepInfo = __NFUN_278__(Class'R6PawnReplicationInfo');
        // End:0x150
        if(m_PawnRepInfo != none)
        {
            R6PawnReplicationInfo(m_PawnRepInfo).m_ControllerOwner = self;
            m_PawnRepInfo.SetDeleteOnReset(false);
        }
    }
    // End:0x1B1
    if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        m_BulletFlyby = __NFUN_278__(Class'Engine.R6BulletFlyby',,, vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0));
        // End:0x1B1
        if(!m_bSpawned)
        {
            m_BulletFlyby.SetDeleteOnReset(false);
        }
    }
    // End:0x205
    if(GetGameManager().IsMultiplayer() && int(WorldInfo.NetMode) != int(NM_Client))
    {
        m_RadarReplicationManager = __NFUN_278__(Class'R6RadarReplicationManager');
        m_RadarReplicationManager.Init(self);
    }
    return;
}

simulated event Destroyed()
{
    // End:0x34
    if((WorldInfo.Game != none) && PlayerReplicationInfo != none)
    {
        PlayerReplicationInfo.GotoState('s_Leaving');
    }
    // End:0x46
    if(m_PIPController != none)
    {
        m_PIPController = none;
    }
    // End:0x68
    if(m_MagmaInteraction != none)
    {
        m_MagmaInteraction.Player = none;
        m_MagmaInteraction = none;
    }
    // End:0x98
    if(m_R6Pawn != none)
    {
        // End:0x98
        if(m_R6Pawn.m_operatedTurret != none)
        {
            m_R6Pawn.StartLeavingTurret(true);
        }
    }
    // End:0xB6
    if(m_BulletFlyby != none)
    {
        m_BulletFlyby.Destroy();
        m_BulletFlyby = none;
    }
    // End:0xD4
    if(m_RadarReplicationManager != none)
    {
        m_RadarReplicationManager.Destroy();
        m_RadarReplicationManager = none;
    }
    m_R6PlayerCamera = none;
    Destroyed();
    return;
}

simulated event SetDeleteOnReset(bool bVal)
{
    // End:0x21
    if(PlayerReplicationInfo != none)
    {
        PlayerReplicationInfo.SetDeleteOnReset(bVal);
    }
    // End:0x42
    if(PlayerCamera != none)
    {
        PlayerCamera.SetDeleteOnReset(bVal);
    }
    // End:0x63
    if(myHUD != none)
    {
        myHUD.SetDeleteOnReset(bVal);
    }
    SetDeleteOnReset(bVal);
    return;
}

event PreResetCleanup()
{
    // End:0x1B
    if(GetGameManager().IsMultiplayer())
    {
        UnPossess();
    }
    PreResetCleanup();
    return;
}

reliable client simulated event ClientResetGameLevel()
{
    // End:0x1D
    if(GetGameManager() != none)
    {
        GetGameManager().ResetGameLevel();
    }
    return;
}

function ResetOriginalData()
{
    ResetOriginalData();
    ClearTimer();
    ResetVisionMode();
    m_bAllowVisionMode = true;
    m_bVisionModeEnable = false;
    m_eLastVisionMode = 0;
    m_SelectedVisionMode = 2;
    m_bVisionButton = false;
    bForceDesiredRotation = false;
    m_rRotationWithoutBase = Rotation;
    // End:0x70
    if(m_OrdersController != none)
    {
        m_OrdersController.Init(self, m_TeamStateMgr);
    }
    m_PIPController.Reset();
    m_Radar.Init(self);
    // End:0xAA
    if(PlayerReplicationInfo != none)
    {
        PlayerReplicationInfo.Reset();
    }
    // End:0xC5
    if(m_MagmaInteraction != none)
    {
        m_MagmaInteraction.Reset();
    }
    // End:0xE0
    if(m_RadarReplicationManager != none)
    {
        m_RadarReplicationManager.Reset();
    }
    m_vFixedLookAt = vect(0.0000000, 0.0000000, 0.0000000);
    m_Tags[0] = none;
    m_Tags[1] = none;
    m_TagRequestSortedPawns.Length = 0;
    m_bPendingTagRequest = false;
    m_bPendingTagProcessed = false;
    m_bPendingTagRequestReady = false;
    // End:0x147
    if(m_bIsSnakeCam)
    {
        m_MagmaInteraction.ShowSnakeCam(false);
        m_bIsSnakeCam = false;
    }
    m_arrHitSources.Length = 0;
    GotoState('PlayerWalking');
    m_bLastFireButton = false;
    m_bTagEnemyButton = false;
    m_bTagEnemyButtonHeld = false;
    m_bReloadButton = false;
    m_bReloadButtonHeld = false;
    m_bVisionButton = false;
    m_bVisionButtonHeld = false;
    m_bSwitchWeaponButton = false;
    m_bSwitchWeaponButtonHeld = false;
    m_bTakeCoverButtonPress = false;
    m_bTakeCoverButtonInvalidated = false;
    m_bDisableCameraInput = false;
    m_bDisableUpdatePawnRotation = false;
    m_iScopeBeforeInteraction = -1;
    m_bUseDeltaCameraRot = false;
    m_rDeltaCameraRot.Yaw = 0;
    m_rDeltaCameraRot.Pitch = 0;
    m_rDeltaCameraRot.Roll = 0;
    m_bCenteringCamera = false;
    bPreciseDestination = false;
    m_pGadgetToUse = none;
    m_pInteractingObject = none;
    m_pInteractionActor = none;
    m_pPendingGadget = none;
    m_bPendingJump = false;
    return;
}

event ResetCameraMode()
{
    ResetCameraMode();
    // End:0x22
    if(m_R6PlayerCamera != none)
    {
        m_R6PlayerCamera.ResetCameraMode();
    }
    return;
}

function Restart(bool bVehicleTransition)
{
    Restart(bVehicleTransition);
    OnRestart(bVehicleTransition);
    return;
}

reliable client simulated event ClientRestart(Pawn NewPawn)
{
    ClientRestart(NewPawn);
    OnClientRestart(NewPawn);
    return;
}

function bool CanRestartPlayer()
{
    return CanRestart();
    return;
}

// Export UR6PlayerController::execPlayerUpdate(FFrame&, void* const)
native function PlayerUpdate(float fDeltaTime);

// Export UR6PlayerController::execPlayerUpdateOnRope(FFrame&, void* const)
native final function PlayerUpdateOnRope(float fDeltaTime);

// Export UR6PlayerController::execPlayerUpdateTakeCover(FFrame&, void* const)
native final function PlayerUpdateTakeCover(float fDeltaTime);

// Export UR6PlayerController::execUpdateUsePendingGadget(FFrame&, void* const)
native simulated function UpdateUsePendingGadget();

// Export UR6PlayerController::execServerPlayerUpdate(FFrame&, void* const)
native function ServerPlayerUpdate(float fDeltaTime);

simulated event PrepareOpenMenu()
{
    // End:0x31
    if((m_R6CheatManager != none) && m_R6CheatManager.m_pFreeCamController != none)
    {
        m_R6CheatManager.FreeCam();
    }
    return;
}

exec function OpenMenu()
{
    PrepareOpenMenu();
    // End:0x22
    if(m_MagmaInteraction != none)
    {
        m_MagmaInteraction.TogglePauseMenu();
    }
    return;
}

event ShowMissionFailed(out R6MissionFailedInfo FailureInfo)
{
    PrepareOpenMenu();
    // End:0x27
    if(m_MagmaInteraction != none)
    {
        m_MagmaInteraction.ShowMissionFailed(FailureInfo);
    }
    return;
}

event ShowTextInformationBox(string strText, float fTimeShown, Color TextColor)
{
    PrepareOpenMenu();
    // End:0x31
    if(m_MagmaInteraction != none)
    {
        m_MagmaInteraction.ShowTextInformationBox(strText, fTimeShown, TextColor);
    }
    return;
}

reliable client simulated event ClientShowTextInformationBox(SeqAct_R6ShowTextInformationBox textInfoAction)
{
    PrepareOpenMenu();
    // End:0x54
    if(m_MagmaInteraction != none)
    {
        m_MagmaInteraction.ShowTextInformationBox(textInfoAction.m_strText, textInfoAction.fTimeShown, MakeColor(byte(255), byte(255), byte(255), byte(255)));
    }
    return;
}

// Export UR6PlayerController::execClientShowTextInformationBoxObjective(FFrame&, void* const)
reliable client native simulated event ClientShowTextInformationBoxObjective(string strNoLocText, float fTimeShown, Color TextColor);

reliable client simulated event ClientShowTeamBasedTextInformationBox(SeqAct_R6ShowTeamBasedTextInformationBox textInfoAction, R6PlayerReplicationInfo interactor)
{
    PrepareOpenMenu();
    // End:0x118
    if(m_MagmaInteraction != none)
    {
        // End:0x6B
        if(interactor == self.PlayerReplicationInfo)
        {
            m_MagmaInteraction.ShowTextInformationBox(textInfoAction.m_strInteractorText, textInfoAction.fTimeShown, MakeColor(byte(255), byte(255), byte(255), byte(255)));            
        }
        else
        {
            // End:0xD6
            if(interactor.Team == self.PlayerReplicationInfo.Team)
            {
                m_MagmaInteraction.ShowTextInformationBox(textInfoAction.m_strInteractorTeammateText, textInfoAction.fTimeShown, MakeColor(byte(255), byte(255), byte(255), byte(255)));                
            }
            else
            {
                m_MagmaInteraction.ShowTextInformationBox(textInfoAction.m_strAdversaryTeamText, textInfoAction.fTimeShown, MakeColor(byte(255), byte(255), byte(255), byte(255)));
            }
        }
    }
    return;
}

event ShowSOLMenu(bool bShow)
{
    PrepareOpenMenu();
    // End:0x28
    if(m_MagmaInteraction != none)
    {
        m_MagmaInteraction.ShowSOLMenu(bShow);
    }
    return;
}

exec function ShowAI()
{
    // End:0x2B
    if(!myHUD.bShowDebugInfo)
    {
        myHUD.ShowDebug("AI");        
    }
    else
    {
        myHUD.ShowDebug("");
    }
    return;
}

function PossessNewPawnClass(class<R6Character> PawnClass)
{
    local Vector vPos;
    local Rotator rRot;
    local R6Character pPawn;
    local R6TeamManager pOldTeamManager;

    pOldTeamManager = m_R6Pawn.m_pTeamManager;
    pPawn = R6Character(m_R6Pawn);
    vPos = pPawn.Location;
    rRot = pPawn.Rotation;
    UnPossess();
    pPawn.Mesh.DeleteAnimTree();
    pPawn.m_FPMesh.DeleteAnimTree();
    pPawn.Destroy();
    pPawn = __NFUN_278__(PawnClass,,, vPos, rRot);
    // End:0xE4
    if(pPawn.Controller != none)
    {
        pPawn.Controller.Destroy();
        pPawn.Controller = none;
    }
    // End:0x117
    if(pPawn.m_pTeamManager != none)
    {
        pPawn.m_pTeamManager.RemovePawnFromTeam(pPawn);
    }
    pPawn.m_pTeamManager = pOldTeamManager;
    Possess(pPawn, false);
    pPawn.AddDefaultInventory();
    return;
}

function Possess(Pawn aPawn, bool bVehicleTransition)
{
    Possess(aPawn, bVehicleTransition);
    // End:0x9E
    if(Pawn != none)
    {
        m_fOldPawnWalkingPct = Pawn.WalkingPct;
        Pawn.WalkingPct = 1.0000000;
        m_fOldPawnCrouchedPct = Pawn.CrouchedPct;
        Pawn.CrouchedPct = 1.0000000;
        // End:0x9E
        if((Region.Zone == WorldInfo) && LocalPlayerController())
        {
            WorldInfo.ActorEntered(self);
        }
    }
    return;
}

function InitPlayerLocAndRot()
{
    local R6PlayerStart R6StartSpot;
    local Vector vDeltaLoc;
    local Rotator rInitialRot;
    local Vector vInitialLoc;

    R6StartSpot = R6PlayerStart(StartSpot);
    // End:0x11A
    if(R6StartSpot != none)
    {
        // End:0x117
        if(!R6StartSpot.m_bPlayerStartInHelicopter || R6StartSpot.m_Helicopter == none)
        {
            rInitialRot.Yaw = StartSpot.Rotation.Yaw;
            vInitialLoc = StartSpot.Location;
            // End:0xF2
            if(m_R6Pawn != none)
            {
                vDeltaLoc = m_R6Pawn.Location - StartSpot.Location;
                // End:0xCE
                if(!IsZero(vDeltaLoc))
                {
                    m_R6Pawn.SetLocation(StartSpot.Location);
                }
                vInitialLoc = m_R6Pawn.Location;
                SetPawnRotation(rInitialRot, 0.0000000);
            }
            SetRotation(rInitialRot);
            m_rRotationWithoutBase = rInitialRot;
            ClientInitPlayerLocAndRot(vInitialLoc, rInitialRot);
        }        
    }
    else
    {
        // End:0x182
        if(m_R6Pawn != none)
        {
            vInitialLoc = m_R6Pawn.Location;
            rInitialRot = m_R6Pawn.Rotation;
            SetPawnRotation(rInitialRot, 0.0000000);
            SetRotation(rInitialRot);
            m_rRotationWithoutBase = rInitialRot;
            ClientInitPlayerLocAndRot(vInitialLoc, rInitialRot);
        }
    }
    return;
}

reliable client simulated function ClientInitPlayerLocAndRot(Vector vInitialLoc, Rotator rInitialRot)
{
    m_rRotationWithoutBase = rInitialRot;
    SetRotation(rInitialRot);
    // End:0x43
    if(m_R6Pawn != none)
    {
        m_R6Pawn.SetRotation(rInitialRot, true);
        m_R6Pawn.SetLocation(vInitialLoc);
    }
    return;
}

function UnPossess()
{
    // End:0x33
    if(Pawn != none)
    {
        Pawn.WalkingPct = m_fOldPawnWalkingPct;
        Pawn.CrouchedPct = m_fOldPawnCrouchedPct;
    }
    m_R6Pawn = none;
    UnPossess();
    return;
}

function PawnDied(Pawn DiedPawn)
{
    // End:0x11
    if(DiedPawn != Pawn)
    {
        return;
    }
    ClientPawnDied(DiedPawn);
    ClearPickupableItems();
    m_R6Pawn = none;
    PawnDied(DiedPawn);
    return;
}

reliable client simulated function ClientPawnDied(Pawn DiedPawn)
{
    // End:0x12
    if(int(Role) == int(ROLE_Authority))
    {
        return;
    }
    // End:0x24
    if(DiedPawn != none)
    {
        ClearPickupableItems();
    }
    return;
}

// Export UR6PlayerController::execClientJustDied(FFrame&, void* const)
reliable client native simulated event ClientJustDied();

reliable client simulated event ClientPlayTakeHit(Pawn InstigatedBy, Vector HitLocation, byte Damage, class<DamageType> DamageType, Vector Momentum)
{
    // End:0x63
    if((int(Damage) > 0) || bGodMode)
    {
        HitLocation += Pawn.Location;
        Pawn.PlayTakeHit(HitLocation, int(Damage), DamageType);
        PlayHitEffect(InstigatedBy, HitLocation, Momentum);
    }
    return;
}

reliable client simulated event ClientDoRepChopperToggle(R6HelicopterBase pChopper, bool bNewHidden)
{
    // End:0x46
    if(pChopper != none)
    {
        pChopper.bHidden = bNewHidden;
        pChopper.m_bDeactivated = bNewHidden;
        pChopper.DoEnableLights();
    }
    return;
}

function DrawStateInfo(HUD H)
{
    return;
}

function DrawHUD(HUD H)
{
    local string szText;
    local R6GameInfo pR6GameInfo;

    H.Canvas.Font = Class'Engine.Engine'.default.TinyFont;
    // End:0xBD
    if(m_SelectedGadget != none)
    {
        szText = "Selected Gadget: " $ m_SelectedGadget.ItemName;
        H.Canvas.SetPos(10.0000000, 100.0000000);
        H.Canvas.DrawColor = H.WhiteColor;
        H.Canvas.__NFUN_465__(szText);
    }
    pR6GameInfo = R6GameInfo(WorldInfo.Game);
    // End:0xF6
    if(pR6GameInfo != none)
    {
        pR6GameInfo.DrawHUD(H);
    }
    DrawStateInfo(H);
    DrawHUD(H);
    return;
}

reliable server event ServerToggleTakeCoverButton()
{
    ToggleTakeCoverButton();
    return;
}

reliable server event ServerPressTakeCoverButton()
{
    m_bTakeCoverButtonPress = true;
    PressTakeCoverButton();
    return;
}

reliable server event ServerReleaseTakeCoverButton()
{
    m_bTakeCoverButtonPress = false;
    ReleaseTakeCoverButton();
    return;
}

// Export UR6PlayerController::execToggleTakeCoverButton(FFrame&, void* const)
native function ToggleTakeCoverButton();

// Export UR6PlayerController::execPressTakeCoverButton(FFrame&, void* const)
native function PressTakeCoverButton();

// Export UR6PlayerController::execReleaseTakeCoverButton(FFrame&, void* const)
native function ReleaseTakeCoverButton();

exec function TakeCoverToggle()
{
    ToggleTakeCoverButton();
    // End:0x1E
    if(int(Role) < int(ROLE_Authority))
    {
        ServerToggleTakeCoverButton();
    }
    return;
}

event InvalidateTakeCoverButton()
{
    // End:0x18
    if(m_bTakeCoverButtonPress)
    {
        ClientInvalidateTakeCoverButton();
        m_bTakeCoverButtonPress = false;
    }
    return;
}

reliable client simulated event ClientInvalidateTakeCoverButton()
{
    // End:0x19
    if(m_bTakeCoverButtonPress)
    {
        m_bTakeCoverButtonPress = false;
        m_bTakeCoverButtonInvalidated = true;
    }
    return;
}

reliable client simulated event ClientSetCoverSeg(R6Pawn PawnInCover, int iCoverSegIdx, int iInfo, byte u8ExtraInfo)
{
    // End:0x48
    if((PawnInCover != none) && PawnInCover.m_CoverManager != none)
    {
        PawnInCover.m_CoverManager.SetCoverSeg(iCoverSegIdx, iInfo, u8ExtraInfo);
    }
    return;
}

reliable client simulated event ClientSetPawnCoverSeg(int iCoverSegIdx, int iInfo, byte u8ExtraInfo)
{
    // End:0x48
    if((m_R6Pawn != none) && m_R6Pawn.m_CoverManager != none)
    {
        m_R6Pawn.m_CoverManager.SetCoverSeg(iCoverSegIdx, iInfo, u8ExtraInfo);
    }
    return;
}

reliable client simulated event ClientSetCoverSegInfos(R6Pawn PawnInCover, Vector vLeftPoint, Vector vRightPoint, float fHeight, int iInfo, byte u8ExtraInfo)
{
    // End:0x52
    if((PawnInCover != none) && PawnInCover.m_CoverManager != none)
    {
        PawnInCover.m_CoverManager.SetCoverSegInfos(vLeftPoint, vRightPoint, fHeight, iInfo, u8ExtraInfo);
    }
    return;
}

reliable client simulated event ClientSetPawnCoverSegInfos(Vector vLeftPoint, Vector vRightPoint, float fHeight, int iInfo, byte u8ExtraInfo)
{
    // End:0x52
    if((m_R6Pawn != none) && m_R6Pawn.m_CoverManager != none)
    {
        m_R6Pawn.m_CoverManager.SetCoverSegInfos(vLeftPoint, vRightPoint, fHeight, iInfo, u8ExtraInfo);
    }
    return;
}

reliable client simulated event ClientSetCoverSegInfo(R6Pawn PawnInCover, int iInfo)
{
    // End:0x3E
    if((PawnInCover != none) && PawnInCover.m_CoverManager != none)
    {
        PawnInCover.m_CoverManager.SetCoverSegInfo(iInfo);
    }
    return;
}

reliable client simulated event ClientSetPawnCoverSegInfo(int iInfo)
{
    // End:0x3E
    if((m_R6Pawn != none) && m_R6Pawn.m_CoverManager != none)
    {
        m_R6Pawn.m_CoverManager.SetCoverSegInfo(iInfo);
    }
    return;
}

reliable client simulated event ClientSetCoverSegInfoAndHeight(R6Pawn PawnInCover, int iInfo, float fHeight)
{
    // End:0x43
    if((PawnInCover != none) && PawnInCover.m_CoverManager != none)
    {
        PawnInCover.m_CoverManager.SetCoverSegInfoAndHeight(iInfo, fHeight);
    }
    return;
}

reliable client simulated event ClientSetPawnCoverSegInfoAndHeight(int iInfo, float fHeight)
{
    // End:0x43
    if((m_R6Pawn != none) && m_R6Pawn.m_CoverManager != none)
    {
        m_R6Pawn.m_CoverManager.SetCoverSegInfoAndHeight(iInfo, fHeight);
    }
    return;
}

reliable client simulated event ClientSetCoverSegExtraInfo(R6Pawn PawnInCover, byte u8ExtraInfo)
{
    // End:0x3E
    if((PawnInCover != none) && PawnInCover.m_CoverManager != none)
    {
        PawnInCover.m_CoverManager.SetCoverSegExtraInfo(u8ExtraInfo);
    }
    return;
}

reliable client simulated event ClientSetPawnCoverSegExtraInfo(byte u8ExtraInfo)
{
    // End:0x3E
    if((m_R6Pawn != none) && m_R6Pawn.m_CoverManager != none)
    {
        m_R6Pawn.m_CoverManager.SetCoverSegExtraInfo(u8ExtraInfo);
    }
    return;
}

reliable client simulated event ClientSetCoverSegInfoAndExtraInfo(R6Pawn PawnInCover, int iInfo, byte u8ExtraInfo)
{
    // End:0x43
    if((PawnInCover != none) && PawnInCover.m_CoverManager != none)
    {
        PawnInCover.m_CoverManager.SetCoverSegInfoAndExtraInfo(iInfo, u8ExtraInfo);
    }
    return;
}

reliable client simulated event ClientSetPawnCoverSegInfoAndExtraInfo(int iInfo, byte u8ExtraInfo)
{
    // End:0x43
    if((m_R6Pawn != none) && m_R6Pawn.m_CoverManager != none)
    {
        m_R6Pawn.m_CoverManager.SetCoverSegInfoAndExtraInfo(iInfo, u8ExtraInfo);
    }
    return;
}

reliable client simulated event ClientSetCoverSegInfoHeightAndExtraInfo(R6Pawn PawnInCover, int iInfo, float fHeight, byte u8ExtraInfo)
{
    // End:0x4C
    if((PawnInCover != none) && PawnInCover.m_CoverManager != none)
    {
        PawnInCover.m_CoverManager.SetCoverSegInfoHeightAndExtraInfo(iInfo, byte(fHeight), float(u8ExtraInfo));
    }
    return;
}

reliable client simulated event ClientSetPawnCoverSegInfoHeightAndExtraInfo(int iInfo, float fHeight, byte u8ExtraInfo)
{
    // End:0x4C
    if((m_R6Pawn != none) && m_R6Pawn.m_CoverManager != none)
    {
        m_R6Pawn.m_CoverManager.SetCoverSegInfoHeightAndExtraInfo(iInfo, byte(fHeight), float(u8ExtraInfo));
    }
    return;
}

reliable client simulated event ClientClearPawnCoverSegInfos()
{
    // End:0x5D
    if((m_R6Pawn != none) && m_R6Pawn.m_CoverManager != none)
    {
        m_R6Pawn.m_CoverManager.ClearCoverSegInfos();
        // End:0x5D
        if(m_R6Pawn.IsInTakeCover())
        {
            m_R6Pawn.ExitTakeCover(0);
        }
    }
    return;
}

reliable client simulated event ClientStreamKismetData(string sStreamId)
{
    DoStreamKismet(sStreamId);
    return;
}

reliable client simulated event ClientDeleteStreamKismetData(string sStreamId)
{
    DoDeleteStreamKismet(sStreamId);
    return;
}

// Export UR6PlayerController::execDoStreamKismet(FFrame&, void* const)
native final function DoStreamKismet(string sStreamId);

// Export UR6PlayerController::execDoDeleteStreamKismet(FFrame&, void* const)
native final function DoDeleteStreamKismet(string sStreamId);

reliable server event ServerRequestTakeCoverPeekUpAction(bool bTryAim)
{
    RequestTakeCoverPeekAction(3, bTryAim);
    return;
}

reliable server event ServerRequestTakeCoverPeekLeftAction(bool bTryAim)
{
    RequestTakeCoverPeekAction(4, bTryAim);
    return;
}

reliable server event ServerRequestTakeCoverPeekRightAction(bool bTryAim)
{
    RequestTakeCoverPeekAction(5, bTryAim);
    return;
}

function RequestTakeCoverPeekAction(R6EngineEnums.ETakeCover ePeekMode, bool bTryAim)
{
    // End:0x33
    if(!m_R6Pawn.SetTakeCoverAction(ePeekMode))
    {
        // End:0x2C
        if(bTryAim)
        {
            ServerRequestTakeCoverAimAction();            
        }
        else
        {
            ServerRequestTakeCoverReadyAction();
        }
    }
    return;
}

reliable server event ServerRequestTakeCoverAimAction()
{
    // End:0x1D
    if(!m_R6Pawn.SetTakeCoverAction(2))
    {
        ServerRequestTakeCoverReadyAction();
    }
    return;
}

reliable server event ServerRequestTakeCoverReadyAction()
{
    m_R6Pawn.SetTakeCoverAction(1);
    return;
}

reliable server event ServerSetTakeCoverMoveLeft()
{
    m_R6Pawn.m_eTakeCoverMoveDir = 0;
    return;
}

reliable server event ServerSetTakeCoverMoveRight()
{
    m_R6Pawn.m_eTakeCoverMoveDir = 1;
    return;
}

reliable server event ServerSwitchColumnViewSide(R6EngineEnums.EActionSide eNewBlindFireSide)
{
    m_R6Pawn.m_eBlindFireSide = eNewBlindFireSide;
    return;
}

// Export UR6PlayerController::execShootOneBullet(FFrame&, void* const)
native function ShootOneBullet();

reliable server event ServerEnterCover()
{
    PawnEnterCover(m_R6Pawn);
    GotoState('s_TakeCover');
    return;
}

reliable server event ServerExitCover()
{
    PawnExitCover(m_R6Pawn);
    GotoState('PlayerWalking');
    return;
}

reliable client simulated event ClientPawnEnterCover(R6Pawn PawnInCover)
{
    PawnEnterCover(PawnInCover);
    return;
}

reliable client simulated event ClientPawnExitCover(R6Pawn PawnInCover)
{
    PawnExitCover(PawnInCover);
    return;
}

// Export UR6PlayerController::execPawnEnterCover(FFrame&, void* const)
native simulated function PawnEnterCover(R6Pawn PawnInCover);

// Export UR6PlayerController::execPawnExitCover(FFrame&, void* const)
native simulated function PawnExitCover(R6Pawn PawnInCover);

exec function ChangePosture()
{
    ProcessChangePosture();
    return;
}

function ProcessChangePosture()
{
    return;
}

// Export UR6PlayerController::execServerTogglePosture(FFrame&, void* const)
reliable server native function ServerTogglePosture();

reliable client simulated event ClientCrouch()
{
    m_R6Pawn.ShouldCrouch(true);
    return;
}

reliable client simulated event ClientStand()
{
    m_R6Pawn.ShouldCrouch(false);
    return;
}

function bool EnterObserverMode()
{
    // End:0x1B
    if(int(WorldInfo.NetMode) == int(NM_Client))
    {
        return false;
    }
    GotoState('Spectating');
    // End:0x48
    if(!LocalPlayerController())
    {
        ClientGotoState('Spectating');
        ClientShowRespawnScreen();        
    }
    else
    {
        ShowRespawnScreen(true);
    }
    return true;
    return;
}

event ChangeClientState(name NewState, optional name NewLabel)
{
    ClientGotoState(NewState, NewLabel);
    return;
}

event TogglePlayerTeam()
{
    SwitchTeam();
    return;
}

exec function SwitchTeam()
{
    local R6GameReplicationInfo pGameInfo;

    pGameInfo = R6GameReplicationInfo(WorldInfo.GRI);
    // End:0x26
    if(pGameInfo == none)
    {
        return;
    }
    // End:0x3C
    if(!pGameInfo.m_bTeamGame)
    {
        return;
    }
    // End:0x57
    if(int(pGameInfo.m_eCurrentGameType) != int(4))
    {
        return;
    }
    SwitchTeam();
    return;
}

event SetPlayerReady(bool bReady)
{
    R6PlayerReplicationInfo(PlayerReplicationInfo).ServerSetPlayerReady(bReady);
    return;
}

event TogglePlayerReady()
{
    SetPlayerReady(!PlayerReplicationInfo.bReadyToPlay);
    return;
}

event SetPlayerSpawnZone(R6TeamSpawnZone PZone)
{
    R6PlayerReplicationInfo(PlayerReplicationInfo).ServerSetPlayerSpawnZone(PZone);
    return;
}

event SetPlayerClass(R6GameEnums.EPlayerClass eClass)
{
    R6PlayerReplicationInfo(PlayerReplicationInfo).ServerSetPlayerClass(eClass);
    return;
}

reliable client simulated event ClientOnMissionComplete()
{
    OnMissionComplete();
    return;
}

event SetPlayerRank(int iRank)
{
    // End:0x25
    if(iRank >= 0)
    {
        R6PlayerReplicationInfo(PlayerReplicationInfo).ServerSetRank(iRank);
    }
    return;
}

event SetPecInformation(byte byShoulderArmorStyle, byte byArmArmorStyle, byte byLegArmorStyle, byte byGender)
{
    R6PlayerReplicationInfo(PlayerReplicationInfo).ServerSetPecInformation(byShoulderArmorStyle, byArmArmorStyle, byLegArmorStyle, byGender);
    return;
}

// Export UR6PlayerController::execUpdatePecInformation(FFrame&, void* const)
native simulated function UpdatePecInformation();

// Export UR6PlayerController::execClientOnLogIn(FFrame&, void* const)
reliable client native simulated function ClientOnLogIn();

// Export UR6PlayerController::execHandlePotentialCamoPooling(FFrame&, void* const)
native function HandlePotentialCamoPooling(int iPlayerID, int iCamoID);

// Export UR6PlayerController::execStartPoolVolatilePECAssets(FFrame&, void* const)
native function StartPoolVolatilePECAssets();

// Export UR6PlayerController::execStartPoolPermanentPECAssets(FFrame&, void* const)
native function StartPoolPermanentPECAssets();

// Export UR6PlayerController::execPoolPermanentPECAssets(FFrame&, void* const)
native function PoolPermanentPECAssets(int iPlayerID, int iHeadModel, int iHairModel, int iTorsoModel, int iLegsModel, int iHeadGearModel, int iFaceGearModel, int iEyewearModel, int iFacialHairTexture, int iFacialFeatureTexture, int iLegsCamo, int iTorsoCamo, int iHeadGearCamo, int iFaceGearCamo, int iEyewearCamo);

// Export UR6PlayerController::execPoolVolatilePECAssets(FFrame&, void* const)
native function PoolVolatilePECAssets(int iPlayerID, int iArmorShoulderModel, int iArmorArmModel, int iArmorShinModel, int iArmorBodyModel, int iShinCamo, int iArmCamo, int iTorsoCamo, int iShoulderCamo);

function PoolCharacterTemplate(int iPlayerID, R6EngineEnums.EPlayerCharacterType eTemplate)
{
    R6GameManager(GetGameManager()).m_PECAssetManager.PoolAsset(int(eTemplate), 0, iPlayerID);
    return;
}

function PoolCustomCamo(int iPlayerID, byte byIndex, byte byPattern, Color color1, Color color2, Color Color3, Color Color4)
{
    R6GameManager(GetGameManager()).m_PECAssetManager.PoolCustomCamo(iPlayerID, byIndex, byPattern, color1, color2, Color3, Color4);
    return;
}

reliable server event ServerSkipVolatilePooling(int iPlayerID)
{
    local R6MultiPlayerGame MP;

    MP = R6MultiPlayerGame(WorldInfo.Game);
    // End:0x35
    if(MP != none)
    {
        MP.SychronizeClient(self);
    }
    return;
}

reliable server event ServerPoolCustomCamo(byte byIndex, byte byPattern, Color color1, Color color2, Color Color3, Color Color4)
{
    local R6PlayerController PC;

    PoolCustomCamo(PlayerReplicationInfo.PlayerID, byIndex, byPattern, color1, color2, Color3, Color4);
    // End:0xAE
    foreach WorldInfo.AllControllers(Class'R6PlayerController', PC)
    {
        // End:0xAD
        if((PC != none) && !PC.LocalPlayerController())
        {
            PC.ClientPoolCustomCamo(PlayerReplicationInfo.PlayerID, byIndex, byPattern, color1, color2, Color3, Color4);
        }        
    }    
    return;
}

reliable server event ServerPoolCharacterTemplate(R6EngineEnums.EPlayerCharacterType eTemplate)
{
    local R6PlayerController PC;

    PoolCharacterTemplate(PlayerReplicationInfo.PlayerID, eTemplate);
    // End:0x7C
    foreach WorldInfo.AllControllers(Class'R6PlayerController', PC)
    {
        // End:0x7B
        if((PC != none) && !PC.LocalPlayerController())
        {
            PC.ClientPoolCharacterTemplate(PlayerReplicationInfo.PlayerID, eTemplate);
        }        
    }    
    return;
}

reliable server event ServerPoolPermanentPECAssets(int iHeadModel, int iHairModel, int iTorsoModel, int iLegsModel, int iHeadGearModel, int iFaceGearModel, int iEyewearModel, int iFacialHairTexture, int iFacialFeatureTexture, int iLegsCamo, int iTorsoCamo, int iHeadGearCamo, int iFaceGearCamo, int iEyewearCamo)
{
    local R6PlayerController PC;

    PoolPermanentPECAssets(PlayerReplicationInfo.PlayerID, iHeadModel, iHairModel, iTorsoModel, iLegsModel, iHeadGearModel, iFaceGearModel, iEyewearModel, iFacialHairTexture, iFacialFeatureTexture, iLegsCamo, iTorsoCamo, iHeadGearCamo, iFaceGearCamo, iEyewearCamo);
    // End:0xFE
    foreach WorldInfo.AllControllers(Class'R6PlayerController', PC)
    {
        // End:0xFD
        if((PC != none) && !PC.LocalPlayerController())
        {
            PC.ClientPoolPermanentPECAssets(PlayerReplicationInfo.PlayerID, iHeadModel, iHairModel, iTorsoModel, iLegsModel, iHeadGearModel, iFaceGearModel, iEyewearModel, iFacialHairTexture, iFacialFeatureTexture, iLegsCamo, iTorsoCamo, iHeadGearCamo, iFaceGearCamo, iEyewearCamo);
        }        
    }    
    return;
}

reliable server event ServerPoolVolatilePECAssets(int iArmorShoulderModel, int iArmorArmModel, int iArmorShinModel, int iArmorBodyModel, int iShinCamo, int iArmCamo, int iTorsoCamo, int iShoulderCamo)
{
    local R6PlayerController PC;
    local R6MultiPlayerGame MP;

    PoolVolatilePECAssets(PlayerReplicationInfo.PlayerID, iArmorShoulderModel, iArmorArmModel, iArmorShinModel, iArmorBodyModel, iShinCamo, iArmCamo, iTorsoCamo, iShoulderCamo);
    // End:0xC2
    foreach WorldInfo.AllControllers(Class'R6PlayerController', PC)
    {
        // End:0xC1
        if((PC != none) && !PC.LocalPlayerController())
        {
            PC.ClientPoolVolatilePECAssets(PlayerReplicationInfo.PlayerID, iArmorShoulderModel, iArmorArmModel, iArmorShinModel, iArmorBodyModel, iShinCamo, iArmCamo, iTorsoCamo, iShoulderCamo);
        }        
    }    
    MP = R6MultiPlayerGame(WorldInfo.Game);
    // End:0xF8
    if(MP != none)
    {
        MP.SychronizeClient(self);
    }
    return;
}

reliable client simulated function ClientPoolPermanentPECAssets(int iPlayerID, int iHeadModel, int iHairModel, int iTorsoModel, int iLegsModel, int iHeadGearModel, int iFaceGearModel, int iEyewearModel, int iFacialHairTexture, int iFacialFeatureTexture, int iLegsCamo, int iTorsoCamo, int iHeadGearCamo, int iFaceGearCamo, int iEyewearCamo)
{
    PoolPermanentPECAssets(iPlayerID, iHeadModel, iHairModel, iTorsoModel, iLegsModel, iHeadGearModel, iFaceGearModel, iEyewearModel, iFacialHairTexture, iFacialFeatureTexture, iLegsCamo, iTorsoCamo, iHeadGearCamo, iFaceGearCamo, iEyewearCamo);
    return;
}

reliable client simulated function ClientPoolVolatilePECAssets(int iPlayerID, int iArmorShoulderModel, int iArmorArmModel, int iArmorShinModel, int iArmorBodyModel, int iShinCamo, int iArmCamo, int iTorsoCamo, int iShoulderCamo)
{
    PoolVolatilePECAssets(iPlayerID, iArmorShoulderModel, iArmorArmModel, iArmorShinModel, iArmorBodyModel, iShinCamo, iArmCamo, iTorsoCamo, iShoulderCamo);
    return;
}

reliable client simulated function ClientPoolCharacterTemplate(int iPlayerID, R6EngineEnums.EPlayerCharacterType eTemplate)
{
    PoolCharacterTemplate(iPlayerID, eTemplate);
    return;
}

reliable client simulated function ClientSyncPooledAssets()
{
    StartPoolVolatilePECAssets();
    return;
}

reliable server function ServerNotifyPoolLoadingComplete()
{
    local R6MultiPlayerGame MP;

    MP = R6MultiPlayerGame(WorldInfo.Game);
    // End:0x35
    if(MP != none)
    {
        MP.SychronizeClient(self);
    }
    return;
}

function BeginPoolLoading()
{
    R6GameManager(GetGameManager()).m_PECAssetManager.LoadInGameAssets();
    ServerNotifyPoolLoadingComplete();
    return;
}

reliable client simulated function ClientBeginPoolLoading()
{
    BeginPoolLoading();
    return;
}

reliable client simulated event ClientPoolStaticMeshes(int iID1, byte iPlayerID1, byte byAsset1, int iID2, byte iPlayerID2, byte byAsset2, int iID3, byte iPlayerID3, byte byAsset3, int iID4, byte iPlayerID4, byte byAsset4, int iID5, byte iPlayerID5, byte byAsset5)
{
    local R6PECAssetManager AssMan;

    AssMan = R6GameManager(GetGameManager()).m_PECAssetManager;
    AssMan.PoolAsset(iID1, 4, int(iPlayerID1), byAsset1);
    AssMan.PoolAsset(iID2, 4, int(iPlayerID2), byAsset2);
    AssMan.PoolAsset(iID3, 4, int(iPlayerID3), byAsset3);
    AssMan.PoolAsset(iID4, 4, int(iPlayerID4), byAsset4);
    AssMan.PoolAsset(iID5, 4, int(iPlayerID5), byAsset5);
    return;
}

reliable client simulated event ClientPoolTextures(int iID1, byte iPlayerID1, byte byAsset1, int iID2, byte iPlayerID2, byte byAsset2, int iID3, byte iPlayerID3, byte byAsset3, int iID4, byte iPlayerID4, byte byAsset4, int iID5, byte iPlayerID5, byte byAsset5)
{
    local R6PECAssetManager AssMan;

    AssMan = R6GameManager(GetGameManager()).m_PECAssetManager;
    AssMan.PoolAsset(iID1, 2, int(iPlayerID1), byAsset1);
    AssMan.PoolAsset(iID2, 2, int(iPlayerID2), byAsset2);
    AssMan.PoolAsset(iID3, 2, int(iPlayerID3), byAsset3);
    AssMan.PoolAsset(iID4, 2, int(iPlayerID4), byAsset4);
    AssMan.PoolAsset(iID5, 2, int(iPlayerID5), byAsset5);
    return;
}

reliable client simulated event ClientPoolSkeletalMeshes(int iID1, byte iPlayerID1, byte byAsset1, int iID2, byte iPlayerID2, byte byAsset2, int iID3, byte iPlayerID3, byte byAsset3, int iID4, byte iPlayerID4, byte byAsset4, int iID5, byte iPlayerID5, byte byAsset5)
{
    local R6PECAssetManager AssMan;

    AssMan = R6GameManager(GetGameManager()).m_PECAssetManager;
    AssMan.PoolAsset(iID1, 3, int(iPlayerID1), byAsset1);
    AssMan.PoolAsset(iID2, 3, int(iPlayerID2), byAsset2);
    AssMan.PoolAsset(iID3, 3, int(iPlayerID3), byAsset3);
    AssMan.PoolAsset(iID4, 3, int(iPlayerID4), byAsset4);
    AssMan.PoolAsset(iID5, 3, int(iPlayerID5), byAsset5);
    return;
}

reliable client simulated event ClientPoolCamos(int iID1, byte iPlayerID1, byte byAsset1, int iID2, byte iPlayerID2, byte byAsset2, int iID3, byte iPlayerID3, byte byAsset3, int iID4, byte iPlayerID4, byte byAsset4, int iID5, byte iPlayerID5, byte byAsset5)
{
    local R6PECAssetManager AssMan;

    AssMan = R6GameManager(GetGameManager()).m_PECAssetManager;
    AssMan.PoolAsset(iID1, 1, int(iPlayerID1), byAsset1);
    AssMan.PoolAsset(iID2, 1, int(iPlayerID2), byAsset2);
    AssMan.PoolAsset(iID3, 1, int(iPlayerID3), byAsset3);
    AssMan.PoolAsset(iID4, 1, int(iPlayerID4), byAsset4);
    AssMan.PoolAsset(iID5, 1, int(iPlayerID5), byAsset5);
    return;
}

reliable client simulated event ClientPoolCharacterTemplates(int iID1, byte iPlayerID1, int iID2, byte iPlayerID2, int iID3, byte iPlayerID3)
{
    local R6PECAssetManager AssMan;

    AssMan = R6GameManager(GetGameManager()).m_PECAssetManager;
    AssMan.PoolAsset(iID1, 0, int(iPlayerID1));
    AssMan.PoolAsset(iID2, 0, int(iPlayerID2));
    AssMan.PoolAsset(iID3, 0, int(iPlayerID3));
    return;
}

reliable client simulated event ClientPoolCustomCamo(int iPlayerID, byte byIndex, byte byPattern, Color color1, Color color2, Color Color3, Color Color4)
{
    R6GameManager(GetGameManager()).m_PECAssetManager.PoolCustomCamo(iPlayerID, byIndex, byPattern, color1, color2, Color3, Color4);
    return;
}

reliable client simulated function ClientClearAssetPool()
{
    R6GameManager(GetGameManager()).m_PECAssetManager.Reset();
    return;
}

reliable client simulated function ClientRemovePlayerAssetPool(int iPlayerID)
{
    R6GameManager(GetGameManager()).m_PECAssetManager.UnreferencePlayer(iPlayerID);
    return;
}

reliable client simulated function ClientLoadPooledAssets()
{
    local R6PECAssetManager AssMan;

    AssMan = R6GameManager(GetGameManager()).m_PECAssetManager;
    AssMan.BeginSynchronization();
    AssMan.LoadInGameAssets();
    AssMan.EndSynchronization();
    return;
}

// Export UR6PlayerController::execGetRelevantCharacterType(FFrame&, void* const)
native function R6EngineEnums.EPlayerCharacterType GetRelevantCharacterType();

exec function Jump()
{
    return;
}

reliable server function ServerWantsGunUp(bool bVal)
{
    DoWantsGunUp(bVal);
    return;
}

reliable server event ServerSetGunUpForced(bool bVal)
{
    DoSetGunUpForced(bVal);
    return;
}

simulated event WantsGunUp(bool bVal)
{
    // End:0x5A
    if((m_R6Pawn != none) && m_R6Pawn.m_bWantsGunUp != bVal)
    {
        DoWantsGunUp(bVal);
        // End:0x5A
        if(int(WorldInfo.NetMode) == int(NM_Client))
        {
            ServerWantsGunUp(bVal);
        }
    }
    return;
}

// Export UR6PlayerController::execSetGunUpForced(FFrame&, void* const)
native simulated function SetGunUpForced(bool bVal);

// Export UR6PlayerController::execDoWantsGunUp(FFrame&, void* const)
native simulated function DoWantsGunUp(bool bVal);

// Export UR6PlayerController::execDoSetGunUpForced(FFrame&, void* const)
native simulated function DoSetGunUpForced(bool bVal);

// Export UR6PlayerController::execCanFireWeapon(FFrame&, void* const)
native simulated function bool CanFireWeapon();

reliable client simulated event ClientProcessInstantHitRainbow(Vector vSourceLocation, Vector vHitLocation, R6Pawn pPawn)
{
    ClientProcessInstantHitNative(vSourceLocation, vHitLocation, pPawn, true, false, false);
    return;
}

reliable client simulated event ClientProcessInstantHitRainbowWithDamage(Vector vSourceLocation, Vector vHitLocation, R6Pawn pPawn)
{
    ClientProcessInstantHitNative(vSourceLocation, vHitLocation, pPawn, true, true, false);
    return;
}

reliable client simulated event ClientProcessInstantHitRainbowWithTracers(Vector vSourceLocation, Vector vHitLocation, R6Pawn pPawn)
{
    ClientProcessInstantHitNative(vSourceLocation, vHitLocation, pPawn, true, false, true);
    return;
}

reliable client simulated event ClientProcessInstantHitRainbowWithDamageAndTracers(Vector vSourceLocation, Vector vHitLocation, R6Pawn pPawn)
{
    ClientProcessInstantHitNative(vSourceLocation, vHitLocation, pPawn, true, true, true);
    return;
}

reliable client simulated event ClientProcessInstantHitTerrorist(Vector vSourceLocation, Vector vHitLocation, R6Pawn pPawn)
{
    ClientProcessInstantHitNative(vSourceLocation, vHitLocation, pPawn, false, false, false);
    return;
}

reliable client simulated event ClientProcessInstantHitTerroristWithDamage(Vector vSourceLocation, Vector vHitLocation, R6Pawn pPawn)
{
    ClientProcessInstantHitNative(vSourceLocation, vHitLocation, pPawn, false, true, false);
    return;
}

reliable client simulated event ClientProcessInstantHitTerroristWithTracers(Vector vSourceLocation, Vector vHitLocation, R6Pawn pPawn)
{
    ClientProcessInstantHitNative(vSourceLocation, vHitLocation, pPawn, false, false, true);
    return;
}

reliable client simulated event ClientProcessInstantHitTerroristWithDamageAndTracers(Vector vSourceLocation, Vector vHitLocation, R6Pawn pPawn)
{
    ClientProcessInstantHitNative(vSourceLocation, vHitLocation, pPawn, false, true, true);
    return;
}

reliable client simulated event ClientProcessBloodImpact(Vector vHitLocation, Rotator rHitNormal)
{
    // End:0x41
    if(int(Role) < int(ROLE_Authority))
    {
        WorldInfo.AddImpactUnlitMod(vHitLocation, -Vector(rHitNormal), GetImpactConfig().GetBloodImpact(), none, none, none);
    }
    return;
}

simulated exec function PrevWeapon()
{
    ProcessPrevWeapon();
    return;
}

simulated function ProcessPrevWeapon()
{
    // End:0x15
    if(!CanSwitchWeapon())
    {
        ClientPlayRejectSound();
        return;
    }
    // End:0x2F
    if(m_R6Pawn.IsScoping())
    {
        ResetScope();
    }
    SwitchToPrevWeapon();
    return;
}

exec function SelectPrimary()
{
    SetActiveWeapon(0);
    return;
}

exec function SelectSecondary()
{
    SetActiveWeapon(1);
    return;
}

exec function SelectPistol()
{
    SetActiveWeapon(2);
    return;
}

exec function SelectGadget1()
{
    GadgetSelect(1);
    return;
}

exec function SelectGadget2()
{
    GadgetSelect(2);
    return;
}

reliable server function ServerSwitchToPrevWeapon()
{
    SwitchToPrevWeapon();
    return;
}

simulated function SwitchToPrevWeapon()
{
    local R6InventoryManager pInvManager;
    local int iSelectedWeapon;
    local R6Shield pPrevShield;

    pInvManager = m_R6Pawn.m_R6InvManager;
    iSelectedWeapon = pInvManager.GetPrevAvailableWeapon();
    // End:0x8F
    if(int(Role) < int(ROLE_Authority))
    {
        pPrevShield = R6Shield(pInvManager.GetItemFromSlot(iSelectedWeapon));
        // End:0x75
        if(pPrevShield != none)
        {
            m_R6Pawn.m_bClientSwitchingToShield = true;
        }
        m_R6Pawn.m_bClientSwitchingWeapon = true;
        ServerSwitchToPrevWeapon();
        return;
    }
    // End:0xCD
    if((int(m_R6Pawn.Physics) == int(13)) && m_R6Pawn.m_pOnRope != none)
    {
        ServerSetRememberWeapon(iSelectedWeapon);        
    }
    else
    {
        pInvManager.SetCurrentWeaponIndex(iSelectedWeapon);
    }
    return;
}

reliable server function ServerSetRememberWeapon(int iIndex)
{
    // End:0x28
    if(m_R6Pawn != none)
    {
        m_R6Pawn.m_R6InvManager.m_iWeaponRemembered = iIndex;
    }
    return;
}

simulated exec function NextWeapon()
{
    ProcessNextWeapon();
    return;
}

simulated event ProcessNextWeapon()
{
    // End:0x15
    if(!CanSwitchWeapon())
    {
        ClientPlayRejectSound();
        return;
    }
    // End:0x2F
    if(m_R6Pawn.IsScoping())
    {
        ResetScope();
    }
    SwitchToNextWeapon();
    return;
}

reliable server function ServerSwitchToNextWeapon()
{
    SwitchToNextWeapon();
    return;
}

simulated function SwitchToNextWeapon()
{
    local R6InventoryManager pInvManager;
    local int iSelectedWeapon;
    local R6Shield pNextShield;

    pInvManager = m_R6Pawn.m_R6InvManager;
    iSelectedWeapon = pInvManager.GetNextAvailableWeapon();
    // End:0x8F
    if(int(Role) < int(ROLE_Authority))
    {
        pNextShield = R6Shield(pInvManager.GetItemFromSlot(iSelectedWeapon));
        // End:0x75
        if(pNextShield != none)
        {
            m_R6Pawn.m_bClientSwitchingToShield = true;
        }
        m_R6Pawn.m_bClientSwitchingWeapon = true;
        ServerSwitchToNextWeapon();
        return;
    }
    // End:0xCD
    if((int(m_R6Pawn.Physics) == int(13)) && m_R6Pawn.m_pOnRope != none)
    {
        ServerSetRememberWeapon(iSelectedWeapon);        
    }
    else
    {
        pInvManager.SetCurrentWeaponIndex(iSelectedWeapon);
    }
    return;
}

simulated event SwitchWeapon(bool bNextWeaponWithAmmo, optional bool bIgnorePistols)
{
    local R6InventoryManager InvManager;
    local R6Weapon primaryWeapon, secondaryWeapon, pistolWeapon;
    local int iSelectedWeapon;

    // End:0x16
    if(!CanSwitchWeapon())
    {
        ClientPlayRejectSound();
        return;
    }
    // End:0x30
    if(m_R6Pawn.IsScoping())
    {
        ResetScope();
    }
    InvManager = m_R6Pawn.m_R6InvManager;
    iSelectedWeapon = -1;
    // End:0x15B
    if(InvManager.m_iActiveWeapon == m_R6Pawn.0)
    {
        secondaryWeapon = R6Weapon(InvManager.GetItemFromSlot(m_R6Pawn.1));
        // End:0xEA
        if(((secondaryWeapon != none) && InvManager.CanPawnEquipWeapon(secondaryWeapon)) && !bNextWeaponWithAmmo || secondaryWeapon.HasAnyAmmo())
        {
            iSelectedWeapon = m_R6Pawn.1;            
        }
        else
        {
            // End:0x158
            if(!bIgnorePistols)
            {
                pistolWeapon = R6Weapon(InvManager.GetItemFromSlot(m_R6Pawn.2));
                // End:0x158
                if((pistolWeapon != none) && !bNextWeaponWithAmmo || pistolWeapon.HasAnyAmmo())
                {
                    iSelectedWeapon = m_R6Pawn.2;
                }
            }
        }        
    }
    else
    {
        primaryWeapon = R6Weapon(InvManager.GetItemFromSlot(m_R6Pawn.0));
        // End:0x1D9
        if(((primaryWeapon != none) && InvManager.CanPawnEquipWeapon(primaryWeapon)) && !bNextWeaponWithAmmo || primaryWeapon.HasAnyAmmo())
        {
            iSelectedWeapon = m_R6Pawn.0;            
        }
        else
        {
            secondaryWeapon = R6Weapon(InvManager.GetItemFromSlot(m_R6Pawn.1));
            // End:0x276
            if((((InvManager.m_iActiveWeapon != m_R6Pawn.1) && secondaryWeapon != none) && InvManager.CanPawnEquipWeapon(secondaryWeapon)) && !bNextWeaponWithAmmo || secondaryWeapon.HasAnyAmmo())
            {
                iSelectedWeapon = m_R6Pawn.1;                
            }
            else
            {
                // End:0x304
                if(!bIgnorePistols)
                {
                    pistolWeapon = R6Weapon(InvManager.GetItemFromSlot(m_R6Pawn.2));
                    // End:0x304
                    if(((InvManager.m_iActiveWeapon != m_R6Pawn.2) && pistolWeapon != none) && !bNextWeaponWithAmmo || pistolWeapon.HasAnyAmmo())
                    {
                        iSelectedWeapon = m_R6Pawn.2;
                    }
                }
            }
        }
    }
    // End:0x369
    if(iSelectedWeapon != -1)
    {
        // End:0x351
        if((int(m_R6Pawn.Physics) == int(13)) && m_R6Pawn.m_pOnRope != none)
        {
            ServerSetRememberWeapon(iSelectedWeapon);            
        }
        else
        {
            InvManager.SetCurrentWeaponIndex(iSelectedWeapon);
        }
    }
    return;
}

simulated event SetActiveWeapon(int iWeaponIndex)
{
    // End:0x3A
    if(!CanSwitchWeapon() || !m_R6Pawn.m_R6InvManager.CanPawnEquipWeaponIndex(iWeaponIndex))
    {
        ClientPlayRejectSound();
        return;
    }
    // End:0x54
    if(m_R6Pawn.IsScoping())
    {
        ResetScope();
    }
    // End:0x72
    if(int(Role) < int(ROLE_Authority))
    {
        ServerSetActiveWeapon(iWeaponIndex);
        return;
    }
    m_R6Pawn.m_R6InvManager.SetCurrentWeaponIndex(iWeaponIndex);
    return;
}

reliable server function ServerSetActiveWeapon(int iWeaponIndex)
{
    SetActiveWeapon(iWeaponIndex);
    return;
}

simulated function bool CanSwitchWeapon()
{
    return m_R6Pawn.CanSwitchWeapon();
    return;
}

exec function ReloadWeapon()
{
    ProcessReload();
    return;
}

// Export UR6PlayerController::execProcessReload(FFrame&, void* const)
native simulated function ProcessReload();

// Export UR6PlayerController::execCanReload(FFrame&, void* const)
native simulated function bool CanReload();

simulated event bool TryToPickupItem()
{
    local R6PickupableActor pPickup;

    pPickup = GetNearestPickupableItem();
    // End:0x92
    if((pPickup == none) || (int(Role) == int(ROLE_Authority)) && ((pPickup.Inventory == none) || !pPickup.CanBePickedUp()) || int(m_R6Pawn.CanPickup(pPickup)) != int(0))
    {
        // End:0x90
        if(int(Role) == int(ROLE_Authority))
        {
            ClientTryToPickupFailed();
        }
        return false;
    }
    // End:0xAB
    if(int(Role) < int(ROLE_Authority))
    {
        ServerTryToPickupItem();
        return true;
    }
    PickupItem(pPickup);
    return true;
    return;
}

reliable server function ServerTryToPickupItem()
{
    TryToPickupItem();
    return;
}

reliable client simulated function ClientTryToPickupFailed()
{
    // End:0x1F
    if((int(Role) == int(ROLE_Authority)) || !m_bReloadButtonHeld)
    {
        return;
    }
    m_MagmaInteraction.ShowWeaponMenu(true);
    return;
}

function PickupItem(R6PickupableActor pPickup)
{
    m_R6Pawn.StartPickup(pPickup);
    GotoState('PlayerPickingUpWeapon');
    return;
}

event bool AllowPickup()
{
    return false;
    return;
}

reliable client simulated event ActivateFlash(Actor pEffectInstigator, float fRetinaImprintOpacity, float fInterpolationSpeed, float fFullStrengthDuration, float fFadeDuration, int iGrabFrameNbIteration, float fGrabFrameBlurWidth, bool bNegate, bool bDesaturate)
{
    ActivateFlashNative(pEffectInstigator, fRetinaImprintOpacity, fInterpolationSpeed, fFullStrengthDuration, fFadeDuration, iGrabFrameNbIteration, fGrabFrameBlurWidth, bNegate, bDesaturate);
    return;
}

reliable client simulated event ActivateDizziness(Actor pEffectInstigator, float fMotionBlurOpacity, float fInterpolationSpeed, float fFullStrengthDuration, float fFadeDuration)
{
    ActivateDizzinessNative(pEffectInstigator, fMotionBlurOpacity, fInterpolationSpeed, fFullStrengthDuration, fFadeDuration);
    return;
}

reliable client simulated event ActivateVisionBlur(Actor pEffectInstigator, float fGaussianBlurOpacity, float fInterpolationSpeed, float fFullStrengthDuration, float fFadeDuration)
{
    ActivateVisionBlurNative(pEffectInstigator, fGaussianBlurOpacity, fInterpolationSpeed, fFullStrengthDuration, fFadeDuration);
    return;
}

function SetNightVision()
{
    m_MagmaInteraction.SetVisionModeTexture(1);
    return;
}

function SetHeatVision()
{
    m_MagmaInteraction.SetVisionModeTexture(2);
    return;
}

function SetGasMaskVision()
{
    m_MagmaInteraction.SetVisionModeTexture(3);
    return;
}

event SetAllowVisionMode(bool bAllow)
{
    // End:0x99
    if(m_bAllowVisionMode != bAllow)
    {
        m_bAllowVisionMode = bAllow;
        // End:0x53
        if(int(WorldInfo.NetMode) == int(NM_Standalone))
        {
            // End:0x53
            if(m_R6Pawn != none)
            {
                m_R6Pawn.m_bForceHelmetUpdate = true;
            }
        }
        // End:0x99
        if((!m_bAllowVisionMode && int(m_SelectedVisionMode) != int(0)) && int(m_SelectedVisionMode) != int(3))
        {
            m_SelectedVisionMode = 0;
            m_bVisionModeEnable = false;
            DoUpdateVisionMode();
        }
    }
    return;
}

function bool ShouldUpdateVisionModeNow()
{
    return m_R6Pawn.IsFirstPerson() && LocalPlayerController();
    return;
}

reliable server function ServerInstantVisionModeChange(R6EngineEnums.EVisionMode eMode)
{
    // End:0x20
    if(m_R6Pawn != none)
    {
        m_R6Pawn.InstantVisionModeChange(eMode);
    }
    return;
}

reliable server function ServerUpdateVisionMode(R6EngineEnums.EVisionMode eMode, R6EngineEnums.EVisionModeAction eAction)
{
    local R6PlayerReplicationInfo PRepInfo;

    m_SelectedVisionMode = eMode;
    // End:0x69
    if(PlayerReplicationInfo != none)
    {
        PRepInfo = R6PlayerReplicationInfo(PlayerReplicationInfo);
        // End:0x69
        if(PRepInfo != none)
        {
            // End:0x58
            if(int(eAction) == int(1))
            {
                PRepInfo.m_eCurrentVisionMode = m_SelectedVisionMode;                
            }
            else
            {
                PRepInfo.m_eCurrentVisionMode = 0;
            }
        }
    }
    return;
}

event SelectVisionMode(R6EngineEnums.EVisionMode EVisionMode, optional R6EngineEnums.EVisionModeAction eAction)
{
    // End:0x80
    if((int(WorldInfo.NetMode) != int(NM_Standalone)) || int(GetGameManager().GetGameMode()) == int())
    {
        m_SelectedVisionMode = EVisionMode;
        UpdateVisionMode(m_SelectedVisionMode, eAction);
        // End:0x7E
        if(int(WorldInfo.NetMode) == int(NM_Client))
        {
            ServerUpdateVisionMode(EVisionMode, eAction);
        }
        return;
    }
    // End:0xBE
    if((LocalPlayerController()) && (WorldInfo.TimeSeconds - m_fLastVisionModeOrder) < GetGadgetsConfig().m_fMinDelayBetweenVisionChange)
    {
        ClientPlayRejectSound();
        return;
    }
    // End:0x196
    if(int(EVisionMode) != int(m_SelectedVisionMode))
    {
        // End:0x17A
        if(m_R6Pawn != none)
        {
            // End:0x170
            if(m_R6Pawn.CanChangeVisionMode() || !LocalPlayerController())
            {
                m_fLastVisionModeOrder = WorldInfo.TimeSeconds;
                m_SelectedVisionMode = EVisionMode;
                // End:0x134
                if(int(eAction) == int(1))
                {
                    m_bVisionModeEnable = true;
                }
                // End:0x152
                if(m_bVisionModeEnable)
                {
                    m_R6Pawn.SelectVisionMode(m_SelectedVisionMode);
                }
                // End:0x16D
                if(ShouldUpdateVisionModeNow())
                {
                    UpdateVisionMode(m_SelectedVisionMode, eAction);
                }                
            }
            else
            {
                ClientPlayRejectSound();
            }            
        }
        else
        {
            m_SelectedVisionMode = EVisionMode;
            UpdateVisionMode(m_SelectedVisionMode, eAction);
        }
    }
    return;
}

event EnableVisionMode(bool bEnable)
{
    // End:0x88
    if((int(WorldInfo.NetMode) != int(NM_Standalone)) || int(GetGameManager().GetGameMode()) == int())
    {
        UpdateVisionMode(m_SelectedVisionMode, ((bEnable) ? 1 : 2));
        // End:0x86
        if(int(WorldInfo.NetMode) == int(NM_Client))
        {
            ServerUpdateVisionMode(m_SelectedVisionMode, ((bEnable) ? 1 : 2));
        }
        return;
    }
    // End:0xBA
    if((WorldInfo.TimeSeconds - m_fLastVisionModeOrder) < GetGadgetsConfig().m_fMinDelayBetweenVisionChange)
    {
        ClientPlayRejectSound();
        return;
    }
    // End:0x18D
    if(m_bVisionModeEnable != bEnable)
    {
        // End:0x165
        if(m_R6Pawn != none)
        {
            // End:0x15B
            if(m_R6Pawn.CanChangeVisionMode() || !LocalPlayerController())
            {
                m_fLastVisionModeOrder = WorldInfo.TimeSeconds;
                m_bVisionModeEnable = bEnable;
                m_R6Pawn.EnableVisionMode(bEnable, m_SelectedVisionMode);
                // End:0x158
                if(ShouldUpdateVisionModeNow())
                {
                    UpdateVisionMode(m_SelectedVisionMode, ((bEnable) ? 1 : 2));
                }                
            }
            else
            {
                ClientPlayRejectSound();
            }            
        }
        else
        {
            m_bVisionModeEnable = bEnable;
            UpdateVisionMode(m_SelectedVisionMode, ((bEnable) ? 1 : 2));
        }
    }
    return;
}

// Export UR6PlayerController::execGetVisionMode(FFrame&, void* const)
native simulated function R6EngineEnums.EVisionMode GetVisionMode();

// Export UR6PlayerController::execPreRender(FFrame&, void* const)
native function PreRender(Canvas Canvas);

event ToggleVisionMode()
{
    EnableVisionMode(!m_bVisionModeEnable);
    return;
}

// Export UR6PlayerController::execPlayVisionModeSounds(FFrame&, void* const)
native final function PlayVisionModeSounds();

// Export UR6PlayerController::execStopVisionModeSounds(FFrame&, void* const)
native final function StopVisionModeSounds();

event UpdateVisionMode(R6EngineEnums.EVisionMode EVisionMode, optional R6EngineEnums.EVisionModeAction eAction)
{
    local R6PlayerReplicationInfo PRepInfo;

    m_SelectedVisionMode = EVisionMode;
    // End:0x37
    if(int(eAction) != int(0))
    {
        m_bVisionModeEnable = ((int(eAction) == int(1)) ? true : false);
    }
    DoUpdateVisionMode();
    // End:0x78
    if(PlayerReplicationInfo != none)
    {
        PRepInfo = R6PlayerReplicationInfo(PlayerReplicationInfo);
        // End:0x78
        if(PRepInfo != none)
        {
            PRepInfo.m_eCurrentVisionMode = m_eLastVisionMode;
        }
    }
    return;
}

simulated function DoUpdateVisionMode()
{
    ResetVisionMode();
    PlayVisionModeSounds();
    m_eLastVisionMode = 0;
    // End:0x79
    if(m_bVisionModeEnable)
    {
        // End:0x38
        if(int(m_SelectedVisionMode) != int(0))
        {
            m_eLastVisionMode = m_SelectedVisionMode;
        }
        // End:0x79
        if(LocalPlayerController())
        {
            switch(m_SelectedVisionMode)
            {
                // End:0x58
                case 1:
                    SetNightVision();
                    // End:0x79
                    break;
                // End:0x67
                case 2:
                    SetHeatVision();
                    // End:0x79
                    break;
                // End:0x76
                case 3:
                    SetGasMaskVision();
                    // End:0x79
                    break;
                // End:0xFFFF
                default:
                    break;
            }
        }
        else
        {
        }/* !MISMATCHING REMOVE, tried If got Type:Else Position:0x079! */
        return;
    }/* !MISMATCHING REMOVE, tried Else got Type:If Position:0x014! */
}

function NextRoF()
{
    // End:0x2D
    if(m_R6Pawn.m_R6Weapon != none)
    {
        m_R6Pawn.m_R6Weapon.CycleFireMode();
    }
    return;
}

unreliable server event LeaveTurretPC(R6Gadget pGadget, Actor pDest)
{
    return;
}

unreliable client simulated function ClientShowEmptyGadget()
{
    // End:0x1C
    if(m_MagmaInteraction != none)
    {
        m_MagmaInteraction.ShowNoAmmo(true);
    }
    ClientPlayRejectSound();
    return;
}

unreliable server event UseGadgetPC(R6Gadget pGadget, Actor pDest)
{
    local bool bPlayRejectSound;

    bPlayRejectSound = true;
    // End:0x2D
    if(pGadget.GetCount() <= 0)
    {
        ClientShowEmptyGadget();
        bPlayRejectSound = false;
    }
    // End:0x62
    if((pGadget == none) || !CanUseGadgetPC(pGadget, pDest))
    {
        // End:0x60
        if(bPlayRejectSound)
        {
            ClientPlayRejectSound();
        }
        return;
    }
    // End:0xCE
    if(m_R6Pawn != none)
    {
        m_pInteractingObject = pDest;
        m_pInteractionActor = none;
        m_pPendingGadget = pGadget;
        // End:0xC7
        if(m_R6Pawn.IsScoping())
        {
            ResetScope();
            // End:0xC4
            if(int(WorldInfo.NetMode) != int(NM_Standalone))
            {
                ClientResetScope();
            }            
        }
        else
        {
            UpdateUsePendingGadget();
        }
    }
    return;
}

// Export UR6PlayerController::execCanUseWeapon(FFrame&, void* const)
native simulated function bool CanUseWeapon();

event bool CanUseGadgetPC(R6Gadget GadgetToUse, Actor pDestActor)
{
    local bool bCan;

    // End:0x75
    if(m_R6Pawn != none)
    {
        // End:0x45
        if((m_R6Pawn.m_R6Weapon != none) && int(m_R6Pawn.m_R6Weapon.m_eWeaponAnimType) == int(3))
        {
            return false;
        }
        GadgetToUse.SetDestActor(pDestActor);
        bCan = m_R6Pawn.PawnCanUseGadget(GadgetToUse);
    }
    return bCan;
    return;
}

event GadgetSelect(R6InventoryManager.EGadgetNum Enum)
{
    local R6Gadget pGadget;

    // End:0x90
    if(((m_R6Pawn.m_R6InvManager != none) && int(Enum) >= int(1)) && int(Enum) <= int(2))
    {
        pGadget = m_R6Pawn.m_R6InvManager.GetGadgetAtSlot(Enum);
        // End:0x90
        if((pGadget != none) && pGadget.m_bSelectable)
        {
            m_eSelectedGadgetNum = Enum;
            m_SelectedGadget = pGadget;
        }
    }
    return;
}

event GadgetExhausted(R6Gadget pGadget)
{
    return;
}

function DoAction()
{
    // End:0x11
    if(m_pInteractingObject != none)
    {
        DoInteract();
    }
    return;
}

exec event SendOrderTeam()
{
    // End:0x19
    if(CanSendOrder())
    {
        m_OrdersController.SendOrder();
    }
    return;
}

event bool CanSendOrder()
{
    return (((m_OrdersController != none) && m_TeamStateMgr != none) && m_bHasRainbowAITeammates) && m_TeamStateMgr.CanSendMoveTo();
    return;
}

exec function PlayerAction()
{
    // End:0x2E
    if(((CanPlayerAction()) && !m_bSwitchWeaponButton) && !m_bSwitchWeaponButtonHeld)
    {
        DoAction();        
    }
    else
    {
        SendOrderTeam();
    }
    return;
}

exec function PlayerActionOff()
{
    // End:0x60
    if(((m_R6Pawn != none) && m_R6Pawn.m_pInteracting != none) && int(m_R6Pawn.m_pInteracting.m_eType) == int(2))
    {
        // End:0x60
        if(GetGameManager().IsMultiplayer())
        {
            AbortInteraction();
        }
    }
    return;
}

event bool CanPlayerAction()
{
    return ((m_R6Pawn != none) && m_pInteractingObject != none) && !m_pInteractingObject.m_bInteractDisabled;
    return;
}

event bool CanPlayerBackAction()
{
    return false;
    return;
}

simulated event bool GetInteractDesc(out R6EngineEnums.ER6InteractDesc eDesc, optional PlayerController PC)
{
    // End:0x2F
    if((CanPlayerAction()) && m_pInteractingObject != none)
    {
        return m_pInteractingObject.GetInteractDesc(eDesc, self);
    }
    return false;
    return;
}

simulated event bool GetBusyInteractDesc(out R6EngineEnums.ER6InteractDesc eDesc, PlayerController PC)
{
    // End:0x40
    if((m_pInsideInteractionRadius != none) && m_pInsideInteractionRadius.IsInteractRotationGood(m_R6Pawn))
    {
        return m_pInsideInteractionRadius.GetBusyInteractDesc(eDesc, PC);
    }
    return false;
    return;
}

// Export UR6PlayerController::execGetSOLInteractDesc(FFrame&, void* const)
native final function GetSOLInteractDesc(out string strDesc, bool bTeamInteract);

exec function GiveOrderUp(int iEvent)
{
    // End:0x1D
    if(iEvent == 0)
    {
        m_MagmaInteraction.OrderUp(0);
    }
    return;
}

exec function GiveOrderLeft(int iEvent)
{
    // End:0x1D
    if(iEvent == 0)
    {
        m_MagmaInteraction.OrderLeft(0);
    }
    return;
}

exec function GiveOrderRight(int iEvent)
{
    // End:0x1D
    if(iEvent == 0)
    {
        m_MagmaInteraction.OrderRight(0);
    }
    return;
}

exec function GiveOrderDown(int iEvent)
{
    // End:0x1D
    if(iEvent == 0)
    {
        m_MagmaInteraction.OrderDown(0);
    }
    return;
}

exec function GiveItem(string InvClassName)
{
    ServerGiveItem(InvClassName);
    return;
}

reliable server function ServerGiveItem(string InvClassName)
{
    local class<Inventory> IClass;
    local Inventory Item;

    // End:0x2A
    if(InStr(InvClassName, ".") == -1)
    {
        InvClassName = "R6Game." $ InvClassName;
    }
    // End:0x37
    if(Pawn == none)
    {
        return;
    }
    IClass = class<Inventory>(DynamicLoadObject(InvClassName, Class'Core.Class'));
    // End:0x9E
    if(IClass != none)
    {
        Item = __NFUN_278__(IClass,,, Pawn.Location);
        // End:0x9E
        if(Item != none)
        {
            Item.GiveTo(Pawn);
        }
    }
    return;
}

simulated function bool CanShowWeaponSwitch()
{
    // End:0x57
    if(((m_R6Pawn.m_R6Weapon != none) && m_R6Pawn.m_R6Weapon.IsIdle()) && !m_R6Pawn.m_R6Weapon.IsInShootSequence())
    {
        return true;        
    }
    else
    {
        return false;
    }
    return;
}

simulated function bool TryWeaponMenuLater()
{
    return m_R6Pawn.m_R6Weapon != none;
    return;
}

simulated function bool CanShowWeaponOptions()
{
    // End:0x57
    if(((m_R6Pawn.m_R6Weapon != none) && m_R6Pawn.m_R6Weapon.IsIdle()) && !m_R6Pawn.m_R6Weapon.IsInShootSequence())
    {
        return true;        
    }
    else
    {
        return false;
    }
    return;
}

simulated function bool TryWeaponOptionMenuLater()
{
    return m_R6Pawn.m_R6Weapon != none;
    return;
}

exec function ROEBut()
{
    // End:0x49
    if((CanSendOrder()) && m_bHasRainbowAITeammates)
    {
        m_OrdersController.ChangeROE();
        m_MagmaInteraction.UpdateROE();
        GetGameManager().TutorialCaseDone(18, true);
    }
    return;
}

event SetROE(R6EngineEnums.ERulesOfEngagement eROE)
{
    // End:0x30
    if(m_OrdersController != none)
    {
        m_OrdersController.SetROE(eROE);
        m_MagmaInteraction.UpdateROE();
    }
    return;
}

exec function SwitchWeaponBut()
{
    m_bSwitchWeaponButton = true;
    return;
}

exec function SwitchWeaponButHeld()
{
    m_bSwitchWeaponButton = false;
    m_bSwitchWeaponButtonHeld = true;
    // End:0x52
    if(!TryToPickupItem())
    {
        // End:0x3A
        if(CanShowWeaponSwitch())
        {
            m_MagmaInteraction.ShowWeaponMenu(true);            
        }
        else
        {
            // End:0x52
            if(TryWeaponMenuLater())
            {
                SetTimer(0.5000000, false, 'RetryShowWeaponMenu');
            }
        }
    }
    return;
}

function RetryShowWeaponMenu()
{
    // End:0x4C
    if(m_bSwitchWeaponButtonHeld && !m_bSwitchWeaponButton)
    {
        // End:0x34
        if(CanShowWeaponSwitch())
        {
            m_MagmaInteraction.ShowWeaponMenu(true);            
        }
        else
        {
            // End:0x4C
            if(TryWeaponMenuLater())
            {
                SetTimer(0.5000000, false, 'RetryShowWeaponMenu');
            }
        }
    }
    return;
}

exec function SwitchWeaponButOff()
{
    m_bSwitchWeaponButtonHeld = false;
    // End:0x23
    if(m_bSwitchWeaponButton)
    {
        NextWeapon();
        m_bSwitchWeaponButton = false;        
    }
    else
    {
        m_MagmaInteraction.ShowWeaponMenu(false);
    }
    return;
}

exec function ReloadBut()
{
    m_bReloadButton = true;
    return;
}

exec function ReloadButHeld()
{
    m_bReloadButton = false;
    m_bReloadButtonHeld = true;
    // End:0x2E
    if(CanShowWeaponOptions())
    {
        m_MagmaInteraction.ShowWeaponOptionsMenu(true);        
    }
    else
    {
        // End:0x46
        if(TryWeaponOptionMenuLater())
        {
            SetTimer(0.5000000, false, 'RetryShowWeaponOptionsMenu');
        }
    }
    return;
}

function RetryShowWeaponOptionsMenu()
{
    // End:0x4C
    if(m_bReloadButtonHeld && !m_bReloadButton)
    {
        // End:0x34
        if(CanShowWeaponOptions())
        {
            m_MagmaInteraction.ShowWeaponOptionsMenu(true);            
        }
        else
        {
            // End:0x4C
            if(TryWeaponOptionMenuLater())
            {
                SetTimer(0.5000000, false, 'RetryShowWeaponOptionsMenu');
            }
        }
    }
    return;
}

exec function ReloadButOff()
{
    m_bReloadButtonHeld = false;
    // End:0x32
    if((m_bSwitchWeaponButton || m_bSwitchWeaponButtonHeld) || m_R6Pawn.m_bClientSwitchingWeapon)
    {
        return;
    }
    // End:0x45
    if(m_bReloadButton)
    {
        ReloadWeapon();        
    }
    else
    {
        m_MagmaInteraction.ShowWeaponOptionsMenu(false);
    }
    return;
}

exec function RateOfFireButton()
{
    // End:0x3A
    if((m_R6Pawn != none) && m_R6Pawn.m_R6Weapon != none)
    {
        m_R6Pawn.m_R6Weapon.CycleFireMode();
    }
    return;
}

exec function NightVisionButton()
{
    // End:0x6C
    if((!m_bVisionButton && !m_bVisionButtonHeld) && R6VIPPawn(m_R6Pawn) == none)
    {
        GetGameManager().TutorialCaseDone(45, true);
        // End:0x6C
        if(m_bAllowVisionMode)
        {
            // End:0x61
            if(int(m_SelectedVisionMode) == int(1))
            {
                ToggleVisionMode();                
            }
            else
            {
                SelectVisionMode(1, 1);
            }
        }
    }
    return;
}

exec function HeatVisionButton()
{
    // End:0x6C
    if((!m_bVisionButton && !m_bVisionButtonHeld) && R6VIPPawn(m_R6Pawn) == none)
    {
        GetGameManager().TutorialCaseDone(45, true);
        // End:0x6C
        if(m_bAllowVisionMode)
        {
            // End:0x61
            if(int(m_SelectedVisionMode) == int(2))
            {
                ToggleVisionMode();                
            }
            else
            {
                SelectVisionMode(2, 1);
            }
        }
    }
    return;
}

exec function SetVisionModeBut()
{
    // End:0x18
    if(R6VIPPawn(m_R6Pawn) == none)
    {
        m_bVisionButton = true;
    }
    return;
}

exec function VisionModeButHeld()
{
    // End:0x45
    if(R6VIPPawn(m_R6Pawn) == none)
    {
        GetGameManager().TutorialCaseDone(45, true);
        m_MagmaInteraction.ShowVisionModesSelector(true);
        m_bVisionButton = false;
        m_bVisionButtonHeld = true;
    }
    return;
}

exec function SetVisionModeButOff()
{
    // End:0x61
    if(R6VIPPawn(m_R6Pawn) == none)
    {
        // End:0x40
        if(m_bVisionButton)
        {
            GetGameManager().TutorialCaseDone(45, false);
            // End:0x3D
            if(m_bAllowVisionMode)
            {
                ToggleVisionMode();
            }            
        }
        else
        {
            m_MagmaInteraction.ShowVisionModesSelector(false);
        }
        m_bVisionButtonHeld = false;
        m_bVisionButton = false;
    }
    return;
}

exec function TagEnemyBut()
{
    m_bTagEnemyButton = true;
    // End:0x2C
    if(GetGameManager().IsSplitscreen())
    {
        m_MagmaInteraction.ToggleMinimap();
    }
    return;
}

exec function TagEnemyButHeld()
{
    // End:0x1C
    if(GetGameManager().IsUsingGamePad())
    {
        m_bTagEnemyButton = false;
    }
    m_bTagEnemyButtonHeld = true;
    m_MagmaInteraction.ShowTacticalMap(true);
    return;
}

exec function TagEnemyButOff()
{
    // End:0x17
    if(m_bTagEnemyButton)
    {
        NativeTagEnemy();
        m_bTagEnemyButton = false;
    }
    // End:0x4D
    if(GetGameManager().IsUsingGamePad())
    {
        // End:0x4D
        if(m_bTagEnemyButtonHeld)
        {
            m_MagmaInteraction.ShowTacticalMap(false);
            m_bTagEnemyButtonHeld = false;
        }
    }
    return;
}

exec function TagEnemyButHeldOff()
{
    // End:0x22
    if(m_bTagEnemyButtonHeld)
    {
        m_MagmaInteraction.ShowTacticalMap(false);
        m_bTagEnemyButtonHeld = false;
    }
    return;
}

exec function UseGadgetButOff()
{
    // End:0x20
    if(m_fLockGadgetButtonTimer == 0.0000000)
    {
        UseGadgetPC(m_SelectedGadget, m_pInteractingObject);
    }
    return;
}

exec function NextScope()
{
    // End:0x23
    if(CanChangeScope())
    {
        m_R6Pawn.m_R6Weapon.NextScope();
    }
    return;
}

simulated function bool CanChangeScope()
{
    return (((m_R6Pawn != none) && m_R6Pawn.m_R6Weapon != none) && m_R6Pawn.m_R6Weapon.CanChangeScope()) && m_R6Pawn.m_pUsedGadget == none;
    return;
}

// Export UR6PlayerController::execResetScope(FFrame&, void* const)
native simulated function ResetScope();

reliable client simulated function ClientResetScope()
{
    ResetScope();
    return;
}

reliable server event UseCameraDeltaRot(bool bValue, optional bool bResetDisableFPMovement)
{
    DoSetCameraDeltaRot(bValue, bResetDisableFPMovement);
    // End:0x40
    if(int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        ClientSetCameraDeltaRot(bValue, bResetDisableFPMovement);
    }
    return;
}

reliable client simulated function ClientSetCameraDeltaRot(bool bValue, bool bResetDisableFPMovement)
{
    DoSetCameraDeltaRot(bValue, bResetDisableFPMovement);
    return;
}

simulated function DoSetCameraDeltaRot(bool bValue, bool bResetDisableFPMovement)
{
    // End:0x38
    if(bValue)
    {
        m_bUseDeltaCameraRot = true;
        m_rDeltaCameraRot.Yaw = 0;
        m_rDeltaCameraRot.Pitch = 0;
        m_rDeltaCameraRot.Roll = 0;        
    }
    else
    {
        m_bUseDeltaCameraRot = false;
    }
    // End:0x67
    if(bResetDisableFPMovement && m_R6Pawn != none)
    {
        m_R6Pawn.m_bDisableFPMovement = false;
    }
    return;
}

// Export UR6PlayerController::execGetMoveVelocity(FFrame&, void* const)
native function float GetMoveVelocity();

// Export UR6PlayerController::execGetMoveAcceleration(FFrame&, void* const)
native function Vector GetMoveAcceleration();

reliable server event ServerSetAimRotationPitch(int iNewAimRotationPitch)
{
    // End:0x24
    if(m_R6Pawn != none)
    {
        m_R6Pawn.m_rAimRotation.Pitch = iNewAimRotationPitch;
    }
    return;
}

reliable server event ServerSetAimRotationYaw(int iNewAimRotationYaw)
{
    // End:0x24
    if(m_R6Pawn != none)
    {
        m_R6Pawn.m_rAimRotation.Yaw = iNewAimRotationYaw;
    }
    return;
}

reliable server event ServerSetAimRotationRoll(int iNewAimRotationRoll)
{
    // End:0x24
    if(m_R6Pawn != none)
    {
        m_R6Pawn.m_rAimRotation.Roll = iNewAimRotationRoll;
    }
    return;
}

reliable server event ServerSetAimRotationPitchAndYaw(int iNewAimRotationPitch, int iNewAimRotationYaw)
{
    // End:0x3D
    if(m_R6Pawn != none)
    {
        m_R6Pawn.m_rAimRotation.Pitch = iNewAimRotationPitch;
        m_R6Pawn.m_rAimRotation.Yaw = iNewAimRotationYaw;
    }
    return;
}

reliable server event ServerSetAimRotationPitchAndRoll(int iNewAimRotationPitch, int iNewAimRotationRoll)
{
    // End:0x3D
    if(m_R6Pawn != none)
    {
        m_R6Pawn.m_rAimRotation.Pitch = iNewAimRotationPitch;
        m_R6Pawn.m_rAimRotation.Roll = iNewAimRotationRoll;
    }
    return;
}

reliable server event ServerSetAimRotationYawAndRoll(int iNewAimRotationYaw, int iNewAimRotationRoll)
{
    // End:0x3D
    if(m_R6Pawn != none)
    {
        m_R6Pawn.m_rAimRotation.Yaw = iNewAimRotationYaw;
        m_R6Pawn.m_rAimRotation.Roll = iNewAimRotationRoll;
    }
    return;
}

reliable server event ServerSetAimRotation(int iNewAimRotationPitch, int iNewAimRotationYaw, int iNewAimRotationRoll)
{
    // End:0x56
    if(m_R6Pawn != none)
    {
        m_R6Pawn.m_rAimRotation.Pitch = iNewAimRotationPitch;
        m_R6Pawn.m_rAimRotation.Yaw = iNewAimRotationYaw;
        m_R6Pawn.m_rAimRotation.Roll = iNewAimRotationRoll;
    }
    return;
}

simulated event Rotator GetBaseRotation()
{
    return m_R6Pawn.Rotation;
    return;
}

// Export UR6PlayerController::execDoPlayerMove(FFrame&, void* const)
native final function DoPlayerMove(float fDeltaTime);

unreliable client simulated event ClientPlayRejectSound()
{
    CreateAudioComponent(m_rejectSound, true, false, 4);
    return;
}

unreliable client simulated event ClientPlayPickupAmmoSound()
{
    // End:0x6A
    if(((m_R6Pawn != none) && m_R6Pawn.m_R6Weapon != none) && m_R6Pawn.m_R6Weapon.m_weaponSetup != none)
    {
        CreateAudioComponent(m_R6Pawn.m_R6Weapon.m_weaponSetup.m_AmmoPickupSound, true, false, 4);
    }
    return;
}

unreliable client simulated event ClientPlaySoundFlyby(const out Vector vStart, const out Vector vEnd)
{
    // End:0x24
    if(m_BulletFlyby != none)
    {
        m_BulletFlyby.PlaySoundFlyby(vStart, vEnd);
    }
    return;
}

function GotoInteractState()
{
    DoGotoInteractState();
    // End:0x27
    if(int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        ClientGotoInteractState();
    }
    return;
}

unreliable client simulated function ClientGotoInteractState()
{
    DoGotoInteractState();
    return;
}

simulated function DoGotoInteractState()
{
    GotoState('PlayerOnTransition');
    return;
}

simulated event ReturnFromInteractState()
{
    // End:0x69
    if(((m_R6Pawn.m_pUsedGadget != none) && int(m_R6Pawn.m_pUsedGadget.m_eGadgetType) == int(3)) && !R6GadgetSnakeCam(m_R6Pawn.m_pUsedGadget).m_bCamOut)
    {
        GotoState('PlayerOnSnakeCam');        
    }
    else
    {
        // End:0x89
        if(m_R6Pawn.IsInTakeCover())
        {
            GotoState('s_TakeCover');            
        }
        else
        {
            // End:0xAA
            if(m_R6Pawn.m_pOnLadder != none)
            {
                GotoState('PlayerOnLadder');                
            }
            else
            {
                // End:0xCB
                if(m_R6Pawn.m_pOnRope != none)
                {
                    GotoState('PlayerOnRope');                    
                }
                else
                {
                    // End:0xEC
                    if(m_R6Pawn.m_operatedTurret != none)
                    {
                        GotoState('PlayerTurreting');                        
                    }
                    else
                    {
                        // End:0x10D
                        if(m_R6Pawn.m_pOnClimb != none)
                        {
                            GotoState('PlayerClimbing');                            
                        }
                        else
                        {
                            GotoState('PlayerWalking');
                        }
                    }
                }
            }
        }
    }
    return;
}

function PropagateReturnFromInteractState()
{
    ReturnFromInteractState();
    // End:0x27
    if(int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        ClientReturnFromInteractState();
    }
    return;
}

reliable client simulated function ClientReturnFromInteractState()
{
    ReturnFromInteractState();
    return;
}

simulated event ProcessInteractWithActor()
{
    // End:0x18
    if(int(Role) < int(ROLE_Authority))
    {
        m_bWaitingForInteractionReplication = true;
    }
    ServerInteractWithActor();
    return;
}

reliable server function ServerInteractWithActor()
{
    InteractWithActor();
    return;
}

reliable client simulated event ClientInteractWithActor(name strState, Actor pInteractingObject, bool bFPMove, Vector vLoc, Rotator rRot)
{
    m_bWaitingForInteractionReplication = false;
    DoInteractWithActor(strState, pInteractingObject, bFPMove, vLoc, rRot);
    return;
}

reliable client simulated event ClientNoInteractWithActor()
{
    m_bWaitingForInteractionReplication = false;
    return;
}

simulated event DoInteractWithActor(name strState, Actor pInteractingObject, bool bFPMove, Vector vLoc, Rotator rRot)
{
    // End:0xC5
    if(!IsInState('PlayerOnMoveTransition') && !IsInState('PlayerOnTransition'))
    {
        // End:0x93
        if(strState != 'None')
        {
            m_pInteractionActor = pInteractingObject;
            m_pInteractingObject = pInteractingObject;
            m_pInteractingObject.PreInteract(m_R6Pawn);
            m_pGadgetToUse = none;
            m_bFPMove = bFPMove;
            m_vDestination = vLoc;
            DesiredRotation = rRot;
            GotoState(strState, 'Start');            
        }
        else
        {
            // End:0xC5
            if((int(Role) == int(ROLE_Authority)) && pInteractingObject != none)
            {
                pInteractingObject.Interact(m_R6Pawn);
            }
        }
    }
    return;
}

reliable client simulated event ClientUseGadgetWithActor(name strState, R6Gadget pGadget, Actor pInteractingObject, Vector vLoc, Rotator rRot)
{
    DoUseGadgetWithActor(strState, pGadget, pInteractingObject, vLoc, rRot);
    return;
}

simulated event DoUseGadgetWithActor(name strState, R6Gadget pGadget, Actor pInteractingObject, Vector vLoc, Rotator rRot)
{
    // End:0xB7
    if(!IsInState('PlayerOnMoveTransition') && !IsInState('PlayerOnTransition'))
    {
        // End:0x86
        if(strState != 'None')
        {
            m_pInteractionActor = none;
            m_pInteractingObject = pInteractingObject;
            m_pGadgetToUse = pGadget;
            m_pGadgetToUse.SetDestActor(pInteractingObject);
            m_vDestination = vLoc;
            DesiredRotation = rRot;
            GotoState(strState, 'Start');            
        }
        else
        {
            // End:0xB7
            if((int(Role) == int(ROLE_Authority)) && pGadget != none)
            {
                m_R6Pawn.PawnUseGadget(pGadget);
            }
        }
    }
    return;
}

function OnR6AIRegroupTeam(SeqAct_R6AIRegroupTeam Action)
{
    // End:0x0D
    if(m_OrdersController == none)
    {
        return;
    }
    // End:0x39
    if(Action.InputLinks[0].bHasImpulse)
    {
        m_OrdersController.SendRegroupTeamMessage();        
    }
    else
    {
        // End:0x62
        if(Action.InputLinks[1].bHasImpulse)
        {
            m_OrdersController.SendHoldTeamMessage();
        }
    }
    return;
}

unreliable server function BlockFirstPersonView(bool bBlock, bool bFix)
{
    DoBlockFirstPersonView(bBlock, bFix);
    // End:0x3E
    if(int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        ClientBlockFirstPersonView(bBlock, bFix);
    }
    return;
}

unreliable client simulated function ClientBlockFirstPersonView(bool bBlock, bool bFix)
{
    DoBlockFirstPersonView(bBlock, bFix);
    return;
}

function HandlePickup(Inventory Inv)
{
    return;
}

reliable client simulated event ClientNotifyPickupAmmo(class<R6Weapon> pWeaponClass, int iNbAmmo)
{
    // End:0x12
    if(int(Role) == int(ROLE_Authority))
    {
        return;
    }
    NotifyPickupAmmo(pWeaponClass, iNbAmmo);
    return;
}

reliable client simulated event ClientNotifyPickupNoAmmoTaken(class<R6Weapon> pWeaponClass)
{
    // End:0x12
    if(int(Role) == int(ROLE_Authority))
    {
        return;
    }
    NotifyPickupNoAmmoTaken(pWeaponClass);
    return;
}

simulated function AbortInteraction()
{
    ReturnFromInteractState();
    ServerAbortInteraction();
    return;
}

reliable server function ServerAbortInteraction()
{
    DoAbortInteraction();
    return;
}

simulated function DoAbortInteraction()
{
    m_R6Pawn.AbortInteraction(false);
    return;
}

// Export UR6PlayerController::execClientChatterJoined(FFrame&, void* const)
unreliable client native simulated function ClientChatterJoined(byte byId, string xuid, string xnaddr);

// Export UR6PlayerController::execClientChatterLeft(FFrame&, void* const)
unreliable client native simulated function ClientChatterLeft(byte byId);

// Export UR6PlayerController::execClientAssignChatterId(FFrame&, void* const)
unreliable client native simulated function ClientAssignChatterId(byte byId);

simulated function TimeOutPlayerOnMoveTransition()
{
    return;
}

reliable client simulated function ClientSetPosAndYaw(Vector vPos, int iYaw)
{
    bForceDesiredRotation = false;
    bPreciseDestination = false;
    m_R6Pawn.KillSpeed();
    StopLatentExecution();
    GotoState('PlayerOnTransition');
    // End:0x6E
    if(int(m_R6Pawn.Physics) != int(15))
    {
        m_R6Pawn.SetYaw(iYaw);
        m_R6Pawn.SetLocation(vPos, true);
    }
    return;
}

simulated event ActivateSnakeCam(bool bActivate, Actor pViewer, bool bTeamMate, R6Pawn pPawn)
{
    // End:0x55
    if(bActivate)
    {
        m_R6PlayerCamera.SetViewTarget(R6GadgetSnakeCam(m_R6Pawn.m_pUsedGadget).m_pViewer);
        // End:0x52
        if(m_MagmaInteraction != none)
        {
            m_MagmaInteraction.ShowSnakeCam(true);
        }        
    }
    else
    {
        m_R6PlayerCamera.SetViewTarget(m_R6Pawn);
        // End:0x87
        if(m_MagmaInteraction != none)
        {
            m_MagmaInteraction.ShowSnakeCam(false);
        }
    }
    m_bIsSnakeCam = bActivate;
    return;
}

event float GetFOVScaleFactor()
{
    return 1.0000000;
    return;
}

// Export UR6PlayerController::execIsMoveStickInsideZone(FFrame&, void* const)
native final function bool IsMoveStickInsideZone(float fVal);

simulated function ZoomRope()
{
    // End:0x40
    if((m_R6Pawn != none) && m_R6Pawn.CanRopeScope())
    {
        m_R6Pawn.PawnRopeZoom(!m_R6Pawn.m_bRopeZoom);
    }
    // End:0x57
    if(int(Role) < int(ROLE_Authority))
    {
        ServerZoomRope();
    }
    return;
}

reliable server function ServerZoomRope()
{
    ZoomRope();
    return;
}

reliable server function ServerInvertRope()
{
    // End:0x35
    if(m_R6Pawn.CanRopeInvert())
    {
        GetGameManager().TutorialCaseDone(20, true);
        m_R6Pawn.InvertRope();
    }
    return;
}

reliable server event ServerJumpRope()
{
    // End:0xC6
    if(CanPlayerAction())
    {
        // End:0x50
        if(m_R6Pawn.CanRopeBreach())
        {
            GetGameManager().TutorialCaseDone(41, true);
            m_R6Pawn.RopeBreach(m_R6Pawn.m_pOnWindow);            
        }
        else
        {
            // End:0x74
            if(m_R6Pawn.CanRappelToFastRope())
            {
                m_R6Pawn.RappelToFastRope();                
            }
            else
            {
                // End:0x9D
                if(!m_bPendingJump && m_R6Pawn.CanDoPendingJump())
                {
                    ClientSetPendingJump();                    
                }
                else
                {
                    // End:0xC6
                    if(m_R6Pawn.CanRopeJump())
                    {
                        m_bPendingJump = false;
                        m_R6Pawn.RopeJump();
                    }
                }
            }
        }
    }
    return;
}

reliable client simulated function ClientSetPendingJump()
{
    m_bPendingJump = true;
    return;
}

event GotoPlayerWalking()
{
    GotoState('PlayerWalking');
    // End:0x23
    if(!LocalPlayerController())
    {
        ClientGotoState('PlayerWalking');
    }
    return;
}

function FinishTcToBf()
{
    return;
}

function FinishRopeAim()
{
    return;
}

reliable server event ServerStartRappelAim()
{
    m_R6Pawn.StartRappelAimTimer();
    return;
}

reliable server function ServerSetPawnSliding()
{
    // End:0x23
    if(m_R6Pawn.CanSlideOnLadder())
    {
        m_R6Pawn.SetSlidingLadder(true);
    }
    return;
}

simulated function OnR6KnockOutPlayer(SeqAct_R6KnockOutPlayer Action)
{
    // End:0x3B
    if(Action.InputLinks[0].bHasImpulse)
    {
        Action.OutputLinks[0].bHasImpulse = true;
        GotoState('s_KnockedOut');
    }
    return;
}

reliable server function ServerStartLeavingTurret()
{
    m_R6Pawn.StartLeavingTurret();
    return;
}

// Export UR6PlayerController::execCustomHeadUpdate(FFrame&, void* const)
native simulated function CustomHeadUpdate();

// Export UR6PlayerController::execCustomHeadStartDownload(FFrame&, void* const)
native simulated function CustomHeadStartDownload(int PlayerID, int downloadSize, int crc);

// Export UR6PlayerController::execCustomHeadDownload(FFrame&, void* const)
native simulated function CustomHeadDownload(int PlayerID, CustomHeadDataChunk chunk);

// Export UR6PlayerController::execCustomHeadStopDownload(FFrame&, void* const)
native simulated function CustomHeadStopDownload(int PlayerID, int downloadSize, string xuid);

// Export UR6PlayerController::execCustomHeadPauseDownload(FFrame&, void* const)
native simulated function CustomHeadPauseDownload();

// Export UR6PlayerController::execCustomHeadResumeDownload(FFrame&, void* const)
native simulated function CustomHeadResumeDownload(int Offset);

// Export UR6PlayerController::execCustomHeadReadyForDownload(FFrame&, void* const)
native simulated function CustomHeadReadyForDownload();

// Export UR6PlayerController::execCustomHeadWaitForAck(FFrame&, void* const)
native simulated function CustomHeadWaitForAck(int PlayerID, int Offset);

// Export UR6PlayerController::execCustomHeadAcknowledge(FFrame&, void* const)
native simulated function CustomHeadAcknowledge(int PlayerID, bool proceed);

reliable client simulated event ClientCustomHeadStartDownload(int PlayerID, int downloadSize, int crc)
{
    CustomHeadStartDownload(PlayerID, downloadSize, crc);
    return;
}

reliable server event ServerCustomHeadStartDownload(int PlayerID, int downloadSize, int crc)
{
    CustomHeadStartDownload(PlayerID, downloadSize, crc);
    return;
}

reliable client simulated event ClientCustomHeadDownload(int PlayerID, CustomHeadDataChunk chunk)
{
    CustomHeadDownload(PlayerID, chunk);
    return;
}

reliable server event ServerCustomHeadDownload(int PlayerID, CustomHeadDataChunk chunk)
{
    CustomHeadDownload(PlayerID, chunk);
    return;
}

reliable client simulated event ClientCustomHeadStopDownload(int PlayerID, int downloadSize, string xuid)
{
    CustomHeadStopDownload(PlayerID, downloadSize, xuid);
    return;
}

reliable server event ServerCustomHeadStopDownload(int PlayerID, int downloadSize, string xuid)
{
    CustomHeadStopDownload(PlayerID, downloadSize, xuid);
    return;
}

reliable server event ServerCustomHeadReadyForDownload()
{
    CustomHeadReadyForDownload();
    return;
}

reliable client simulated event ClientCustomHeadPauseDownload()
{
    CustomHeadPauseDownload();
    return;
}

reliable client simulated event ClientCustomHeadResumeDownload(int Offset)
{
    CustomHeadResumeDownload(Offset);
    return;
}

reliable server event ServerCustomHeadWaitForAck(int PlayerID, int Offset)
{
    CustomHeadWaitForAck(PlayerID, Offset);
    return;
}

reliable client simulated event ClientCustomHeadWaitForAck(int PlayerID, int Offset)
{
    CustomHeadWaitForAck(PlayerID, Offset);
    return;
}

reliable server event ServerCustomHeadAcknowledge(int PlayerID, bool proceed)
{
    CustomHeadAcknowledge(PlayerID, proceed);
    return;
}

reliable client simulated event ClientCustomHeadAcknowledge(int PlayerID, bool proceed)
{
    CustomHeadAcknowledge(PlayerID, proceed);
    return;
}

event SetChosenSOL(R6GameEnums.ESOLSelection eSelection)
{
    m_eSOLChosen = eSelection;
    return;
}

reliable client simulated function ClientGotoPlayerPickingUpWeapon()
{
    // End:0x12
    if(int(Role) == int(ROLE_Authority))
    {
        return;
    }
    GotoState('PlayerPickingUpWeapon');
    return;
}

reliable client simulated event ClientCameraShake(class<DamageType> DamageType, float fStrengthRatio)
{
    m_R6PlayerCamera.Shake(DamageType, fStrengthRatio);
    return;
}

simulated function OnR6ToggleInput(SeqAct_R6ToggleInput inAction)
{
    OnToggleInput(inAction);
    // End:0x42
    if(inAction.InputLinks[0].bHasImpulse)
    {
        // End:0x3F
        if(inAction.bToggleFiring)
        {
            m_bFiringInputEnabled = true;
        }        
    }
    else
    {
        // End:0x78
        if(inAction.InputLinks[1].bHasImpulse)
        {
            // End:0x75
            if(inAction.bToggleFiring)
            {
                m_bFiringInputEnabled = false;
            }            
        }
        else
        {
            // End:0xB3
            if(inAction.InputLinks[2].bHasImpulse)
            {
                // End:0xB3
                if(inAction.bToggleFiring)
                {
                    m_bFiringInputEnabled = !m_bFiringInputEnabled;
                }
            }
        }
    }
    return;
}

simulated function OnR6CameraShake(SeqAct_R6CameraShake Action)
{
    // End:0x37
    if(m_R6PlayerCamera != none)
    {
        m_R6PlayerCamera.Shake(Action.m_damageType, Action.m_fStrengthRatio);
    }
    return;
}

simulated function OnR6CustomCameraShake(SeqAct_R6CustomCameraShake Action)
{
    // End:0x9A
    if(m_R6PlayerCamera != none)
    {
        m_R6PlayerCamera.CustomShake(Action.m_fCustomShakeDuration, Action.m_fCustomShakeRollFreq, Action.m_fCustomShakePitchFreq, Action.m_fCustomShakeYawFreq, Action.m_iCustomShakeRollAmp, Action.m_iCustomShakePitchAmp, Action.m_iCustomShakeYawAmp, Action.m_CustomShakeInterpParams, Action.m_bCustomShakeInverted);
    }
    return;
}

simulated function OnR6PerlinNoiseCameraShake(SeqAct_R6PerlinNoiseCameraShake Action)
{
    // End:0xEE
    if(m_R6PlayerCamera != none)
    {
        m_R6PlayerCamera.PerlinNoiseShake(Action.m_fShakeDuration, Action.m_fPitchShakeScale, Action.m_iPitchShakeAmplitude, Action.m_fYawShakeScale, Action.m_iYawShakeAmplitude, Action.m_fRollShakeScale, Action.m_iRollShakeAmplitude, Action.m_fLocXShakeScale, Action.m_fLocXShakeAmplitude, Action.m_fLocYShakeScale, Action.m_fLocYShakeAmplitude, Action.m_fLocZShakeScale, Action.m_fLocZShakeAmplitude, Action.m_ShakeInterpParams, Action.m_bShakeInverted);
    }
    return;
}

function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    HUD.Canvas.Font = Class'Engine.Engine'.default.TinyFont;
    HUD.Canvas.SetPos(0.0000000, 0.0000000);
    HUD.Canvas.SetDrawColor(byte(255), byte(255), byte(255), byte(255));
    HUD.Canvas.__NFUN_465__((("CONTROLLER " $ (GetItemName(string(self)))) $ " Pawn ") $ (GetItemName(string(Pawn))));
    out_YPos += out_YL;
    HUD.Canvas.SetPos(4.0000000, out_YPos);
    // End:0x10A
    if(Pawn == none)
    {
        DisplayDebug(HUD, out_YL, out_YPos);
        return;
    }
    // End:0x177
    if(Enemy != none)
    {
        HUD.Canvas.__NFUN_465__((((("     STATE: " $ string(GetStateName())) $ " Timer: ") $ string(GetTimerCount())) $ " Enemy ") $ Enemy.GetHumanReadableName(), false);        
    }
    else
    {
        HUD.Canvas.__NFUN_465__(((("     STATE: " $ string(GetStateName())) $ " Timer: ") $ string(GetTimerCount())) $ " NO Enemy ", false);
    }
    out_YPos += out_YL;
    HUD.Canvas.SetPos(4.0000000, out_YPos);
    // End:0x238
    if(PlayerReplicationInfo == none)
    {
        HUD.Canvas.__NFUN_465__("     NO PLAYERREPLICATIONINFO", false);        
    }
    else
    {
        PlayerReplicationInfo.DisplayDebug(HUD, out_YL, out_YPos);
    }
    out_YPos += out_YL;
    HUD.Canvas.SetPos(4.0000000, out_YPos);
    // End:0x2B2
    if(PlayerCamera != none)
    {
        PlayerCamera.DisplayDebug(HUD, out_YL, out_YPos);        
    }
    else
    {
        HUD.Canvas.SetDrawColor(byte(255), 0, 0);
        HUD.Canvas.__NFUN_465__("NO CAMERA");
        out_YPos += out_YL;
        HUD.Canvas.SetPos(4.0000000, out_YPos);
    }
    return;
}

event bool IsWaiting()
{
    return false;
    return;
}

// Export UR6PlayerController::execCanObserveSomeone(FFrame&, void* const)
native final function bool CanObserveSomeone();

simulated event bool ShowRespawnScreen(bool bShow)
{
    local R6GameReplicationInfo pGRI;

    pGRI = R6GameReplicationInfo(WorldInfo.GRI);
    // End:0x41
    if((pGRI == none) || int(pGRI.m_eCurrentGameType) != int(4))
    {
        return false;
    }
    // End:0x4E
    if(!CanRestart())
    {
        return false;
    }
    // End:0x6F
    if(m_MagmaInteraction != none)
    {
        m_MagmaInteraction.ShowRespawnScreen(bShow);
    }
    return true;
    return;
}

reliable client simulated event ClientShowRespawnScreen()
{
    ShowRespawnScreen(true);
    return;
}

reliable client simulated event ClientHideRespawnScreen()
{
    ShowRespawnScreen(false);
    return;
}

reliable server event RequestShowObservedPawn()
{
    // End:0x33
    if(((Pawn == none) || Pawn.Health <= 0) && CanObserveSomeone())
    {
        ClientHideRespawnScreen();
    }
    return;
}

reliable server event ServerPauseRespawnDelay(bool bValue)
{
    local R6PlayerReplicationInfo PRepInfo;

    // End:0x7A
    if(!bValue || WorldInfo.TimeSeconds < WaitDelay)
    {
        PRepInfo = GetPlayerInfo();
        // End:0x7A
        if((PRepInfo != none) && !bValue || PRepInfo.m_fRespawnDelay > 0.0000000)
        {
            PRepInfo.m_bPauseRespawnDelay = bValue;
        }
    }
    return;
}

simulated event SetUpdateRotationTimer(float fTime, Rotator rRot)
{
    DesiredRotation = rRot;
    SetTimer(fTime, false, 'UpdateRotationTimer');
    return;
}

function UpdateRotationTimer()
{
    m_rRotationWithoutBase = DesiredRotation;
    SetRotation(DesiredRotation);
    UpdateAimRotation(DesiredRotation);
    return;
}

reliable client simulated function ClientUpdateRotation(Rotator rRot)
{
    DesiredRotation = rRot;
    UpdateRotationTimer();
    return;
}

// Export UR6PlayerController::execNativeTestAiGesture(FFrame&, void* const)
native final function NativeTestAiGesture(int eId);

exec function TestAiGesture(string eId)
{
    NativeTestAiGesture(int(eId));
    return;
}

exec function TestIncapacitationPlayer()
{
    // End:0x4F
    if(m_R6Pawn.Health > 0)
    {
        m_R6Pawn.TakeDamage(1000, 1000, none, Location, Location, vect(0.0000000, 0.0000000, 1.0000000), Class'Engine.R6DamageType');        
    }
    else
    {
        m_R6Pawn.HealDamage(1000, self, Class'Engine.R6DamageType');
    }
    return;
}

exec function TestCivilRunFromGunShots(int iNum)
{
    local R6CivilPawn P, ClosestPawn;
    local float ThisDistance, ClosestPawnDistance;
    local R6GameEnums.EEventRelativeLocation Dir;

    ClosestPawn = none;
    ClosestPawnDistance = 10000000.0000000;
    // End:0x7D
    foreach DynamicActors(Class'R6CivilPawn', P)
    {
        // End:0x7C
        if(P != m_R6Pawn)
        {
            ThisDistance = VSize(P.Location - m_R6Pawn.Location);
            // End:0x7C
            if(ThisDistance < ClosestPawnDistance)
            {
                ClosestPawn = P;
                ClosestPawnDistance = ThisDistance;
            }
        }        
    }    
    // End:0x112
    if(ClosestPawn != none)
    {
        switch(iNum)
        {
            // End:0xA0
            case 3:
                Dir = 6;
                // End:0xCD
                break;
            // End:0xB0
            case 2:
                Dir = 3;
                // End:0xCD
                break;
            // End:0xBF
            case 1:
                Dir = 4;
                // End:0xCD
                break;
            // End:0xFFFF
            default:
                Dir = 1;
                // End:0xCD
                break;
                break;
        }
        ClosestPawn.m_eCivilInteraction = 2;
        ClosestPawn.m_eEventLocation = Dir;
        ClosestPawn.StartInteractionTimer(ClosestPawn.GetInteractTimerLength());
    }
    return;
}

exec function TestCivilRunFromDanger(int iNum)
{
    local R6CivilPawn P, ClosestPawn;
    local float ThisDistance, ClosestPawnDistance;
    local R6GameEnums.EEventRelativeLocation Dir;

    ClosestPawn = none;
    ClosestPawnDistance = 10000000.0000000;
    // End:0x7D
    foreach DynamicActors(Class'R6CivilPawn', P)
    {
        // End:0x7C
        if(P != m_R6Pawn)
        {
            ThisDistance = VSize(P.Location - m_R6Pawn.Location);
            // End:0x7C
            if(ThisDistance < ClosestPawnDistance)
            {
                ClosestPawn = P;
                ClosestPawnDistance = ThisDistance;
            }
        }        
    }    
    // End:0x112
    if(ClosestPawn != none)
    {
        switch(iNum)
        {
            // End:0xA0
            case 3:
                Dir = 6;
                // End:0xCD
                break;
            // End:0xB0
            case 2:
                Dir = 3;
                // End:0xCD
                break;
            // End:0xBF
            case 1:
                Dir = 4;
                // End:0xCD
                break;
            // End:0xFFFF
            default:
                Dir = 1;
                // End:0xCD
                break;
                break;
        }
        ClosestPawn.m_eCivilInteraction = 1;
        ClosestPawn.m_eEventLocation = Dir;
        ClosestPawn.StartInteractionTimer(ClosestPawn.GetInteractTimerLength());
    }
    return;
}

exec function TestCivilChangeMood(int iNum)
{
    local R6CivilPawn P, ClosestPawn;
    local float ThisDistance, ClosestPawnDistance;

    ClosestPawn = none;
    ClosestPawnDistance = 10000000.0000000;
    // End:0x7D
    foreach DynamicActors(Class'R6CivilPawn', P)
    {
        // End:0x7C
        if(P != m_R6Pawn)
        {
            ThisDistance = VSize(P.Location - m_R6Pawn.Location);
            // End:0x7C
            if(ThisDistance < ClosestPawnDistance)
            {
                ClosestPawn = P;
                ClosestPawnDistance = ThisDistance;
            }
        }        
    }    
    // End:0x9A
    if(ClosestPawn != none)
    {
        ClosestPawn.ChangeMood(0);
    }
    return;
}

exec function TestHostageFree(int iNum)
{
    local R6CivilPawn P, ClosestPawn;
    local float ThisDistance, ClosestPawnDistance;

    ClosestPawn = none;
    ClosestPawnDistance = 10000000.0000000;
    // End:0x7D
    foreach DynamicActors(Class'R6CivilPawn', P)
    {
        // End:0x7C
        if(P != m_R6Pawn)
        {
            ThisDistance = VSize(P.Location - m_R6Pawn.Location);
            // End:0x7C
            if(ThisDistance < ClosestPawnDistance)
            {
                ClosestPawn = P;
                ClosestPawnDistance = ThisDistance;
            }
        }        
    }    
    // End:0x98
    if(ClosestPawn != none)
    {
        ClosestPawn.HasBeenFreed();
    }
    return;
}

exec function TestHostageChangePose(int iNum)
{
    local R6CivilPawn P, ClosestPawn;
    local float ThisDistance, ClosestPawnDistance;

    ClosestPawn = none;
    ClosestPawnDistance = 10000000.0000000;
    // End:0x7D
    foreach DynamicActors(Class'R6CivilPawn', P)
    {
        // End:0x7C
        if(P != m_R6Pawn)
        {
            ThisDistance = VSize(P.Location - m_R6Pawn.Location);
            // End:0x7C
            if(ThisDistance < ClosestPawnDistance)
            {
                ClosestPawn = P;
                ClosestPawnDistance = ThisDistance;
            }
        }        
    }    
    // End:0xD9
    if(ClosestPawn != none)
    {
        // End:0xA8
        if(iNum == 1)
        {
            ClosestPawn.ChangePose(0);            
        }
        else
        {
            // End:0xC8
            if(iNum == 2)
            {
                ClosestPawn.ChangePose(1);                
            }
            else
            {
                ClosestPawn.ChangePose(2);
            }
        }
    }
    return;
}

exec function TestHostageTransition(int iNum)
{
    local R6CivilPawn P, ClosestPawn;
    local float ThisDistance, ClosestPawnDistance;

    ClosestPawn = none;
    ClosestPawnDistance = 10000000.0000000;
    // End:0x7D
    foreach DynamicActors(Class'R6CivilPawn', P)
    {
        // End:0x7C
        if(P != m_R6Pawn)
        {
            ThisDistance = VSize(P.Location - m_R6Pawn.Location);
            // End:0x7C
            if(ThisDistance < ClosestPawnDistance)
            {
                ClosestPawn = P;
                ClosestPawnDistance = ThisDistance;
            }
        }        
    }    
    // End:0x89
    if(ClosestPawn != none)
    {
    }
    return;
}

exec function TestIncapacitationRainbow()
{
    local R6RainbowPawn P, ClosestPawn;
    local float ThisDistance, ClosestPawnDistance;

    ClosestPawn = none;
    ClosestPawnDistance = 10000000.0000000;
    // End:0x7D
    foreach DynamicActors(Class'R6RainbowPawn', P)
    {
        // End:0x7C
        if(P != m_R6Pawn)
        {
            ThisDistance = VSize(P.Location - m_R6Pawn.Location);
            // End:0x7C
            if(ThisDistance < ClosestPawnDistance)
            {
                ClosestPawn = P;
                ClosestPawnDistance = ThisDistance;
            }
        }        
    }    
    // End:0xF3
    if(ClosestPawn != none)
    {
        // End:0xD8
        if(ClosestPawn.Health > 0)
        {
            ClosestPawn.TakeDamage(1000, 1000, none, Location, Location, vect(0.0000000, 0.0000000, 1.0000000), Class'Engine.R6DamageType');            
        }
        else
        {
            ClosestPawn.HealDamage(1000, self, Class'Engine.R6DamageType');
        }
    }
    return;
}

exec function TestTerroReactions(int Reaction, int ilocation, int bodypart, int Move)
{
    local R6Character P, ClosestPawn;
    local float ThisDistance, ClosestPawnDistance;
    local SPawnHealthReactionInfo sreaction;

    ClosestPawn = none;
    ClosestPawnDistance = 10000000.0000000;
    // End:0x7D
    foreach DynamicActors(Class'R6Character', P)
    {
        // End:0x7C
        if(P != m_R6Pawn)
        {
            ThisDistance = VSize(P.Location - m_R6Pawn.Location);
            // End:0x7C
            if(ThisDistance < ClosestPawnDistance)
            {
                ClosestPawn = P;
                ClosestPawnDistance = ThisDistance;
            }
        }        
    }    
    // End:0x4FB
    if(ClosestPawn != none)
    {
        // End:0xA4
        if(Reaction == 1)
        {
            sreaction.m_eType = 9;            
        }
        else
        {
            // End:0xC0
            if(Reaction == 2)
            {
                sreaction.m_eType = 2;                
            }
            else
            {
                // End:0xDC
                if(Reaction == 3)
                {
                    sreaction.m_eType = 3;                    
                }
                else
                {
                    // End:0xF8
                    if(Reaction == 4)
                    {
                        sreaction.m_eType = 4;                        
                    }
                    else
                    {
                        // End:0x114
                        if(Reaction == 5)
                        {
                            sreaction.m_eType = 5;                            
                        }
                        else
                        {
                            // End:0x130
                            if(Reaction == 6)
                            {
                                sreaction.m_eType = 6;                                
                            }
                            else
                            {
                                // End:0x14C
                                if(Reaction == 7)
                                {
                                    sreaction.m_eType = 7;                                    
                                }
                                else
                                {
                                    // End:0x168
                                    if(Reaction == 8)
                                    {
                                        sreaction.m_eType = 8;                                        
                                    }
                                    else
                                    {
                                        // End:0x184
                                        if(Reaction == 9)
                                        {
                                            sreaction.m_eType = 10;                                            
                                        }
                                        else
                                        {
                                            // End:0x19F
                                            if(Reaction == 0)
                                            {
                                                sreaction.m_eType = 11;                                                
                                            }
                                            else
                                            {
                                                // End:0x1BB
                                                if(Reaction == 10)
                                                {
                                                    sreaction.m_eType = 15;                                                    
                                                }
                                                else
                                                {
                                                    // End:0x1D7
                                                    if(Reaction == 11)
                                                    {
                                                        sreaction.m_eType = 12;                                                        
                                                    }
                                                    else
                                                    {
                                                        // End:0x1F3
                                                        if(Reaction == 12)
                                                        {
                                                            sreaction.m_eType = 13;                                                            
                                                        }
                                                        else
                                                        {
                                                            // End:0x20C
                                                            if(Reaction == 13)
                                                            {
                                                                sreaction.m_eType = 14;
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        // End:0x227
        if(ilocation == 1)
        {
            sreaction.m_eLocation = 0;            
        }
        else
        {
            // End:0x243
            if(ilocation == 2)
            {
                sreaction.m_eLocation = 1;                
            }
            else
            {
                // End:0x25F
                if(ilocation == 3)
                {
                    sreaction.m_eLocation = 2;                    
                }
                else
                {
                    // End:0x27B
                    if(ilocation == 4)
                    {
                        sreaction.m_eLocation = 3;                        
                    }
                    else
                    {
                        // End:0x297
                        if(ilocation == 5)
                        {
                            sreaction.m_eLocation = 4;                            
                        }
                        else
                        {
                            // End:0x2B3
                            if(ilocation == 6)
                            {
                                sreaction.m_eLocation = 5;                                
                            }
                            else
                            {
                                // End:0x2CF
                                if(ilocation == 7)
                                {
                                    sreaction.m_eLocation = 6;                                    
                                }
                                else
                                {
                                    // End:0x2E8
                                    if(ilocation == 8)
                                    {
                                        sreaction.m_eLocation = 7;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        // End:0x303
        if(bodypart == 1)
        {
            sreaction.m_eBodyPart = 0;            
        }
        else
        {
            // End:0x31F
            if(bodypart == 2)
            {
                sreaction.m_eBodyPart = 1;                
            }
            else
            {
                // End:0x33B
                if(bodypart == 3)
                {
                    sreaction.m_eBodyPart = 2;                    
                }
                else
                {
                    // End:0x357
                    if(bodypart == 4)
                    {
                        sreaction.m_eBodyPart = 3;                        
                    }
                    else
                    {
                        // End:0x373
                        if(bodypart == 5)
                        {
                            sreaction.m_eBodyPart = 4;                            
                        }
                        else
                        {
                            // End:0x38F
                            if(bodypart == 6)
                            {
                                sreaction.m_eBodyPart = 5;                                
                            }
                            else
                            {
                                // End:0x3AB
                                if(bodypart == 7)
                                {
                                    sreaction.m_eBodyPart = 6;                                    
                                }
                                else
                                {
                                    // End:0x3C7
                                    if(bodypart == 8)
                                    {
                                        sreaction.m_eBodyPart = 7;                                        
                                    }
                                    else
                                    {
                                        // End:0x3E3
                                        if(bodypart == 9)
                                        {
                                            sreaction.m_eBodyPart = 8;                                            
                                        }
                                        else
                                        {
                                            // End:0x3FF
                                            if(bodypart == 10)
                                            {
                                                sreaction.m_eBodyPart = 9;                                                
                                            }
                                            else
                                            {
                                                // End:0x41B
                                                if(bodypart == 11)
                                                {
                                                    sreaction.m_eBodyPart = 10;                                                    
                                                }
                                                else
                                                {
                                                    // End:0x437
                                                    if(bodypart == 12)
                                                    {
                                                        sreaction.m_eBodyPart = 11;                                                        
                                                    }
                                                    else
                                                    {
                                                        // End:0x450
                                                        if(bodypart == 13)
                                                        {
                                                            sreaction.m_eBodyPart = 12;
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        // End:0x46B
        if(Move == 1)
        {
            sreaction.m_bStandInPlace = true;            
        }
        else
        {
            // End:0x484
            if(Move == 2)
            {
                sreaction.m_bStandInPlace = false;
            }
        }
        ClientMessage((((((("Start reaction: " $ string(sreaction.m_eType)) $ " ") $ string(sreaction.m_eLocation)) $ " ") $ string(sreaction.m_eBodyPart)) $ " ") $ string(sreaction.m_bStandInPlace));
        ClosestPawn.StartReaction(sreaction);
    }
    return;
}

reliable server event ServerInputReady()
{
    // End:0x37
    if(WorldInfo.Game != none)
    {
        R6GameInfo(WorldInfo.Game).ReceivedInputReady(PlayerReplicationInfo);
    }
    return;
}

reliable server event ServerHasVoice(bool bHasVoice)
{
    // End:0x3D
    if(WorldInfo.Game != none)
    {
        R6GameInfo(WorldInfo.Game).ReceivedHasVoice(PlayerReplicationInfo, bHasVoice);
    }
    return;
}

reliable client simulated event ClientSetKillerLocation(Vector vLocation)
{
    // End:0x1F
    if(m_R6Pawn != none)
    {
        m_R6Pawn.m_vLastKillerPos = vLocation;
    }
    return;
}

// Export UR6PlayerController::execSimulateNetworkTCR(FFrame&, void* const)
native exec function SimulateNetworkTCR();

// Export UR6PlayerController::execSimulateExtremePacketLossTCR(FFrame&, void* const)
native exec function SimulateExtremePacketLossTCR();

// Export UR6PlayerController::execShowNetworkSimulation(FFrame&, void* const)
native exec function ShowNetworkSimulation();

// Export UR6PlayerController::execSetNetworkPacketLag(FFrame&, void* const)
native exec function SetNetworkPacketLag(int iPacketLag);

// Export UR6PlayerController::execSetNetworkPacketLoss(FFrame&, void* const)
native exec function SetNetworkPacketLoss(int iPacketLoss);

reliable client simulated event ClientSetNetworkPacketLag(int iServerPacketLag)
{
    SetNetworkPacketLag(iServerPacketLag);
    return;
}

reliable client simulated event ClientSetNetworkPacketLoss(int iServerPacketLoss)
{
    SetNetworkPacketLoss(iServerPacketLoss);
    return;
}

exec function OpenChat()
{
    m_MagmaInteraction.OpenChat();
    return;
}

exec function OpenTeamChat()
{
    m_MagmaInteraction.OpenTeamChat();
    return;
}

// Export UR6PlayerController::execR6StatNet(FFrame&, void* const)
native exec function R6StatNet();

// Export UR6PlayerController::execR6StatNetClass(FFrame&, void* const)
native exec function R6StatNetClass(class<Actor> ClassToProfile);

function NotifyChangedWeapon(Weapon PreviousWeapon, Weapon NewWeapon)
{
    local R6PlayerReplicationInfo stR6PlayerRep;

    stR6PlayerRep = GetPlayerInfo();
    // End:0x60
    if((int(WorldInfo.NetMode) != int(NM_Client)) && stR6PlayerRep != none)
    {
        GetGameManager().m_StatisticsManager.ChangedWeapon(stR6PlayerRep.m_iStatsPlayerID, NewWeapon);
    }
    return;
}

event NotifyRainbowTeamChanged(bool bAdded)
{
    local bool bHasTeammates;

    // End:0x40
    if((m_R6Pawn != none) && m_R6Pawn.m_pTeamManager != none)
    {
        bHasTeammates = m_R6Pawn.m_pTeamManager.HasAITeammates();
    }
    // End:0x7B
    if(m_bHasRainbowAITeammates != bHasTeammates)
    {
        m_bHasRainbowAITeammates = bHasTeammates;
        // End:0x7B
        if(!m_bHasRainbowAITeammates)
        {
            m_Tags[0] = none;
            m_Tags[1] = none;
        }
    }
    return;
}

unreliable client simulated function SendPlayerStatistics(string strName, string strXUID, GeneralStats stGeneralStats)
{
    local R6PlayerReplicationInfo stR6PlayerRep;
    local bool bLocalPlayer;

    stR6PlayerRep = GetPlayerInfo();
    bLocalPlayer = false;
    // End:0x42
    if((stR6PlayerRep != none) && stR6PlayerRep.m_xuid == strXUID)
    {
        bLocalPlayer = true;
    }
    GetGameManager().m_StatisticsManager.ReceivedPlayerStatistics(strName, strXUID, stGeneralStats, bLocalPlayer);
    return;
}

unreliable client simulated function SendTrueSkillStatistics(string strXUID, TrueSkillStats stTrueSkillStats)
{
    GetGameManager().m_StatisticsManager.ReceivedTrueSkillStatistics(strXUID, stTrueSkillStats);
    return;
}

unreliable client simulated function SendWeaponStatistics(WeaponStatistics stWeaponStats)
{
    local R6PlayerReplicationInfo stR6PlayerRep;

    stR6PlayerRep = GetPlayerInfo();
    GetGameManager().m_StatisticsManager.ReceivedWeaponStatistics(stR6PlayerRep.m_xuid, stWeaponStats);
    return;
}

unreliable server function SendCoopStatistics(CoopStats stCoopStats, R6GameInfo pGameInfo)
{
    local R6PlayerReplicationInfo pPlayerRep;
    local R6CooperativeGame pCoopGame;

    pPlayerRep = GetPlayerInfo();
    pCoopGame = R6CooperativeGame(pGameInfo);
    // End:0x170
    if((pPlayerRep != none) && pCoopGame != none)
    {
        pPlayerRep.m_iKills = stCoopStats.m_iTerroristsKilled;
        pPlayerRep.m_iTerroristsKilled = pCoopGame.m_iStatsNbTerroKilled;
        pPlayerRep.m_iCiviliansWounded = pCoopGame.m_iStatsNbCiviliansWounded;
        pPlayerRep.m_iCiviliansKilled = pCoopGame.m_iStatsNbCiviliansKilled;
        pPlayerRep.m_iTimePlayed = pCoopGame.m_iStatsTimePlayed;
        pPlayerRep.m_iScoreTerroKilled = pCoopGame.m_iScoreTerroKilled;
        pPlayerRep.m_iScoreCiviliansWounded = pCoopGame.m_iScoreCiviliansWounded;
        pPlayerRep.m_iScoreCiviliansKilled = pCoopGame.m_iScoreCiviliansKilled;
        pPlayerRep.m_iScoreTimePlayed = pCoopGame.m_iScoreTimePlayed;
        pPlayerRep.m_iScoreDifficulty = pCoopGame.m_iScoreDifficulty;
        pPlayerRep.m_iScoreTotalScore = pCoopGame.m_iScoreTotalScore;
    }
    return;
}

reliable client simulated event UpdateLocalRemainingTime(int iElapsedTime, int iRemainingTime)
{
    local R6GameReplicationInfo pGameRepInfo;

    pGameRepInfo = R6GameReplicationInfo(WorldInfo.GRI);
    // End:0x4C
    if(pGameRepInfo != none)
    {
        pGameRepInfo.ElapsedTime = iElapsedTime;
        pGameRepInfo.RemainingTime = iRemainingTime;
    }
    return;
}

reliable client simulated function ClientRankedMatchEnded(float fTimePlayed, bool bWon)
{
    HandlePECMatchEnded(fTimePlayed, bWon);
    return;
}

unreliable client simulated event ClientSpawnStrapFromWeapon(R6Weapon pWeapon)
{
    local R6AttachmentsLMG pAttach;

    // End:0x69
    if((pWeapon != none) && pWeapon.Instigator != none)
    {
        pAttach = R6AttachmentsLMG(pWeapon.GetWeaponAttachments());
        // End:0x69
        if(pAttach != none)
        {
            pAttach.StrapOff(R6Pawn(pWeapon.Instigator));
        }
    }
    return;
}

unreliable client simulated event ClientSpawnDoorBrokenPieces(R6InteractiveDoor pDoor, Vector vHitLocation, Vector vMomentum)
{
    // End:0x24
    if(pDoor != none)
    {
        pDoor.SpawnBrokenPieces(vHitLocation, vMomentum);
    }
    return;
}

reliable server event ServerFullAmmoCheat()
{
    local R6InventoryManager invMng;
    local R6Weapon Weapon;
    local R6GroupGadget Gadget;
    local int I;

    // End:0x0D
    if(Pawn == none)
    {
        return;
    }
    invMng = R6InventoryManager(Pawn.InvManager);
    // End:0xED
    if(invMng != none)
    {
        I = 0;
        J0x38:

        // End:0xED [Loop If]
        if(I < invMng.m_inventorySlots.Length)
        {
            Weapon = R6Weapon(invMng.m_inventorySlots[I].m_item);
            // End:0x9C
            if(Weapon != none)
            {
                Weapon.SetAmmunition(9999);
                // [Explicit Continue]
                goto J0xE3;
            }
            Gadget = R6GroupGadget(invMng.m_inventorySlots[I].m_item);
            // End:0xE3
            if(Gadget != none)
            {
                Gadget.m_iAmmo = 9999;
            }
            J0xE3:

            I++;
            // [Loop Continue]
            goto J0x38;
        }
    }
    return;
}

event SetWaypoint(Actor pWaypoint, bool bObjectiveWaypoint)
{
    local Vector vTmp;

    // End:0x14
    if(bObjectiveWaypoint)
    {
        m_pObjectiveWaypoint = pWaypoint;
    }
    m_pWaypointActor = pWaypoint;
    // End:0x41
    if(pWaypoint != none)
    {
        m_vWaypointLoc = pWaypoint.Location;        
    }
    else
    {
        // End:0x6E
        if(m_pObjectiveWaypoint != none)
        {
            m_pWaypointActor = m_pObjectiveWaypoint;
            m_vWaypointLoc = m_pObjectiveWaypoint.Location;            
        }
        else
        {
            m_vWaypointLoc = vTmp;
        }
    }
    // End:0x99
    if(m_RadarReplicationManager != none)
    {
        m_RadarReplicationManager.SetWaypoint(m_pWaypointActor);
    }
    return;
}

simulated event StartCredits()
{
    GotoState('s_EndCredits');
    return;
}

// Export UR6PlayerController::execStartEndCredits(FFrame&, void* const)
native final function StartEndCredits();

// Export UR6PlayerController::execCreditsFadeFinished(FFrame&, void* const)
native final function CreditsFadeFinished();

// Export UR6PlayerController::execStartCreditsStory(FFrame&, void* const)
native final function StartCreditsStory();

event ShowMissionSuccess()
{
    PrepareOpenMenu();
    // End:0x22
    if(m_MagmaInteraction != none)
    {
        m_MagmaInteraction.ShowMissionSuccess();
    }
    return;
}

event LoadNextLevel()
{
    PrepareOpenMenu();
    bGodMode = true;
    GotoState('s_EndMap');
    StartEndMapFade();
    SetTimer(GetMiscConfig().m_fFadeOutTimeSP + 0.2500000, false, 'DoLoadNextMap');
    return;
}

// Export UR6PlayerController::execStartEndMapFade(FFrame&, void* const)
native final function StartEndMapFade();

// Export UR6PlayerController::execDoLoadNextMap(FFrame&, void* const)
native final function DoLoadNextMap();

exec function EnableHidePawnInCamera()
{
    GetCameraConfig().m_bEnableHidePawnInCamera = !GetCameraConfig().m_bEnableHidePawnInCamera;
    return;
}

reliable client simulated event ClientFadeScreen(FadeParams FadeParams)
{
    FadeScreen(FadeParams);
    return;
}

unreliable client simulated event ClientAddNewMotionSensorInfo(MotionSensorRepInfo Info)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x55 [Loop If]
    if(I < m_RadarReplicationManager.m_arrMotionSensorRepInfo.Length)
    {
        // End:0x4B
        if(m_RadarReplicationManager.m_arrMotionSensorRepInfo[I].m_iID == Info.m_iID)
        {
            // [Explicit Break]
            goto J0x55;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    J0x55:

    m_RadarReplicationManager.m_arrMotionSensorRepInfo[I] = Info;
    Pawn.PlaySound(m_MotionSensorSound, 4, true, true, true);
    return;
}

unreliable client simulated event ClientRemoveMotionSensorInfo(int iID)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x65 [Loop If]
    if(I < m_RadarReplicationManager.m_arrMotionSensorRepInfo.Length)
    {
        // End:0x5B
        if(m_RadarReplicationManager.m_arrMotionSensorRepInfo[I].m_iID == iID)
        {
            m_RadarReplicationManager.m_arrMotionSensorRepInfo.Remove(I, 1);
            // [Explicit Break]
            goto J0x65;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    J0x65:

    return;
}

reliable client simulated function ClientShowHeatSignatureFX(float fTime)
{
    // End:0x35
    if(m_MagmaInteraction != none)
    {
        m_MagmaInteraction.RechargeBatteryChargeBar(fTime);
        m_MagmaInteraction.ShowHeatSignature(fTime);
    }
    return;
}

reliable client simulated function ClientShowRadarJamFX(float fTime)
{
    // End:0x30
    if(m_MagmaInteraction != none)
    {
        m_MagmaInteraction.RechargeBatteryChargeBar(fTime);
        m_MagmaInteraction.ShowRadarJamGlitch();
    }
    return;
}

reliable client simulated event ClientToggleCheat(int iCheatIndex)
{
    GetGameManager().EnableCheat(iCheatIndex);
    return;
}

reliable server event ServerFinishedCenteringCamera()
{
    m_bCenteringCamera = false;
    return;
}

reliable client simulated function ClientStartCenterCamera()
{
    m_bCenteringCamera = true;
    return;
}

event ChangePlayerName(string S)
{
    SetName(S);
    return;
}

event SendChatString(string S)
{
    Say(S);
    return;
}

event SendTeamChatString(string S)
{
    TeamSay(S);
    return;
}

reliable client simulated event TeamMessage(PlayerReplicationInfo PRI, coerce string S, name Type, optional float MsgLifeTime)
{
    local bool bTeam;

    // End:0x69
    if((Type == 'Say') || Type == 'TeamSay')
    {
        // End:0x3B
        if(Type == 'TeamSay')
        {
            bTeam = true;            
        }
        else
        {
            bTeam = false;
        }
        // End:0x69
        if(m_MagmaInteraction != none)
        {
            m_MagmaInteraction.DisplayChatMessage(S, bTeam);
        }
    }
    return;
}

function UpdatePreferredTeamChoice()
{
    local R6GameReplicationInfo pGameInfo;

    pGameInfo = R6GameReplicationInfo(WorldInfo.GRI);
    // End:0x56
    if(pGameInfo.m_bTeamGame)
    {
        // End:0x53
        if(PlayerReplicationInfo != none)
        {
            preferredTeamIndex = PlayerReplicationInfo.Team.TeamIndex;
        }        
    }
    else
    {
        preferredTeamIndex = -1;
    }
    return;
}

simulated state PlayerClimbing
{
    function BeginState(name Prev)
    {
        m_bFiringInputEnabled = false;
        return;
    }

    function EndState(name Next)
    {
        m_bFiringInputEnabled = true;
        BlockFirstPersonView(false, false);
        UseCameraDeltaRot(false);
        return;
    }

    simulated function bool CanShowWeaponSwitch()
    {
        return false;
        return;
    }

    simulated function bool TryWeaponMenuLater()
    {
        return false;
        return;
    }

    simulated function bool CanShowWeaponOptions()
    {
        return false;
        return;
    }

    simulated function bool TryWeaponOptionMenuLater()
    {
        return false;
        return;
    }

    simulated function bool CanSwitchWeapon()
    {
        return false;
        return;
    }

    function PlayerMove(float fDeltaTime)
    {
        // End:0x18
        if(Pawn == none)
        {
            GotoState('Dead');            
        }
        else
        {
            DoPlayerMove(fDeltaTime);
        }
        return;
    }

    simulated event bool GetBusyInteractDesc(out R6EngineEnums.ER6InteractDesc eDesc, PlayerController PC)
    {
        return false;
        return;
    }

    simulated event bool GetInteractDesc(out R6EngineEnums.ER6InteractDesc eDesc, optional PlayerController PC)
    {
        eDesc = 0;
        return false;
        return;
    }
    stop;
}

simulated state PlayerOnTransition
{
    ignores ProcessNextWeapon, SwitchToNextWeapon, ProcessPrevWeapon, SwitchToPrevWeapon;

    function BeginState(name PreviousStateName)
    {
        local R6Weapon pWeapon;

        m_bPendingJump = false;
        m_bFiringInputEnabled = false;
        // End:0x3D
        if(m_MagmaInteraction != none)
        {
            m_MagmaInteraction.ShowWeaponMenu(false);
            m_MagmaInteraction.ShowWeaponOptionsMenu(false);
        }
        // End:0xC8
        if((LocalPlayerController()) && m_R6Pawn != none)
        {
            pWeapon = m_R6Pawn.m_R6Weapon;
            // End:0xBA
            if((pWeapon != none) && pWeapon.IsScoping())
            {
                m_iScopeBeforeInteraction = pWeapon.GetScopeAttachment().m_iCurrentScopeIndex;
                pWeapon.ResetScope();                
            }
            else
            {
                m_iScopeBeforeInteraction = -1;
            }            
        }
        else
        {
            m_iScopeBeforeInteraction = -1;
        }
        return;
    }

    simulated function bool CanShowWeaponSwitch()
    {
        return false;
        return;
    }

    simulated function bool TryWeaponMenuLater()
    {
        return false;
        return;
    }

    simulated function bool CanShowWeaponOptions()
    {
        return false;
        return;
    }

    simulated function bool TryWeaponOptionMenuLater()
    {
        return false;
        return;
    }

    event bool CanPlayerAction()
    {
        // End:0x31
        if((m_R6Pawn.m_pOnLadder != none) && int(m_R6Pawn.m_eLadderStatus) == int(1))
        {
            return true;
        }
        // End:0x7B
        if(((m_R6Pawn != none) && m_R6Pawn.m_pInteracting != none) && int(m_R6Pawn.m_pInteracting.m_eType) == int(2))
        {
            return true;            
        }
        else
        {
            return false;
        }
        return;
    }

    event bool CanSendOrder()
    {
        return false;
        return;
    }

    function DoAction()
    {
        // End:0x1F
        if(m_R6Pawn.m_pOnLadder != none)
        {
            m_bPendingJump = true;            
        }
        else
        {
            // End:0x3C
            if(!GetGameManager().IsMultiplayer())
            {
                AbortInteraction();
            }
        }
        return;
    }

    function PlayerMove(float fDeltaTime)
    {
        m_fRepMoveVelocity = GetMoveVelocity();
        UpdateRotation(fDeltaTime);
        return;
    }

    function EndState(name Next)
    {
        local R6EngineEnums.EZoomType eNewType;
        local R6Weapon pWeapon;

        // End:0xC2
        if(Next != 'PlayerClimbing')
        {
            BlockFirstPersonView(false, false);
            UseCameraDeltaRot(false);
            // End:0xC2
            if(m_iScopeBeforeInteraction != -1)
            {
                // End:0xB7
                if((Next == 'PlayerWalking') && m_R6Pawn != none)
                {
                    pWeapon = m_R6Pawn.m_R6Weapon;
                    // End:0xB7
                    if(pWeapon != none)
                    {
                        pWeapon.GetScopeAttachment().SetScope(m_iScopeBeforeInteraction);
                        eNewType = pWeapon.GetCurrentZoomType();
                        pWeapon.StartScopeTransition(0, eNewType);
                    }
                }
                m_iScopeBeforeInteraction = -1;
            }
        }
        m_pGadgetToUse = none;
        m_pInteractionActor = none;
        bForceDesiredRotation = false;
        bPreciseDestination = false;
        m_bCenteringCamera = false;
        m_bFiringInputEnabled = true;
        // End:0x110
        if(int(WorldInfo.NetMode) == int(NM_Client))
        {
            ServerFinishedCenteringCamera();
        }
        return;
    }

    event bool CanUseGadgetPC(R6Gadget GadgetToUse, Actor destActor)
    {
        return false;
        return;
    }

    simulated event bool GetBusyInteractDesc(out R6EngineEnums.ER6InteractDesc eDesc, PlayerController PC)
    {
        return false;
        return;
    }

    simulated function bool CanSwitchWeapon()
    {
        return false;
        return;
    }
Start:

    m_R6Pawn.KillSpeed();
    // End:0xA8
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x5D
        if(m_pGadgetToUse != none)
        {
            // End:0x46
            if(m_pGadgetToUse.BlocksView())
            {
                BlockFirstPersonView(true, true);
            }
            m_R6Pawn.PawnUseGadget(m_pGadgetToUse);            
        }
        else
        {
            // End:0xA8
            if(m_pInteractionActor != none)
            {
                // End:0x93
                if(m_pInteractionActor.BlocksView())
                {
                    BlockFirstPersonView(true, m_pInteractionActor.DisableCameraMoveWhileUsing());
                }
                m_pInteractionActor.Interact(m_R6Pawn);
            }
        }
    }
    stop;            
}

simulated state PlayerOnMoveTransition extends PlayerOnTransition
{
    simulated function BeginState(name PreviousStateName)
    {
        BeginState(PreviousStateName);
        SetTimer(10.0000000, false, 'TimeOutPlayerOnMoveTransition');
        return;
    }

    simulated function EndState(name NextStateName)
    {
        ClearTimer('TimeOutPlayerOnMoveTransition');
        EndState(NextStateName);
        return;
    }

    simulated function TimeOutPlayerOnMoveTransition()
    {
        GotoState('PlayerWalking');
        return;
    }

    function PlayerTick(float fDeltaTime)
    {
        global.PlayerTick(fDeltaTime);
        // End:0x7D
        if(int(WorldInfo.NetMode) == int(NM_Client))
        {
            // End:0x57
            if(bPreciseDestination)
            {
                ReplicateMove(fDeltaTime, m_R6Pawn.Acceleration, m_R6Pawn.Rotation);                
            }
            else
            {
                ReplicateMove(fDeltaTime, vect(0.0000000, 0.0000000, 0.0000000), m_R6Pawn.Rotation);
            }
        }
        return;
    }

    function UpdateRotationForTransition()
    {
        local Vector vDest;

        vDest.X = m_vDestination.X;
        vDest.Y = m_vDestination.Y;
        vDest.Z = m_R6Pawn.Location.Z;
        m_R6Pawn.SetYaw(DesiredRotation.Yaw);
        m_R6Pawn.SetLocation(vDest, true);
        // End:0x95
        if(!LocalPlayerController())
        {
            ClientSetPosAndYaw(vDest, DesiredRotation.Yaw);
        }
        return;
    }
Start:

    m_bDisableCameraInput = true;
    m_bDisableUpdatePawnRotation = true;
    // End:0x7D
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x7D
        if(((m_pInteractionActor != none) && m_pInteractionActor.CenterControllerWhenUsing()) || (m_pGadgetToUse != none) && m_pGadgetToUse.CenterControllerWhenUsing())
        {
            m_bCenteringCamera = true;
            // End:0x7D
            if(!LocalPlayerController())
            {
                ClientStartCenterCamera();
            }
        }
    }
    UpdateMoveVelocity(GetControlsConfig().m_fMoveStandFastWalkVel);
    m_R6Pawn.Acceleration = Normal(m_vDestination - m_R6Pawn.Location) * GetControlsConfig().m_fMoveStandMaxAccel;
    bPreciseDestination = true;
    bForceDesiredRotation = true;
    MoveTo(m_vDestination);
    m_R6Pawn.KillSpeed();
    FinishRotation();
    // End:0x17F
    if(((m_pGadgetToUse != none) && !m_pGadgetToUse.CanUseGadget()) || (m_pInteractionActor != none) && !m_pInteractionActor.CanInteract(m_R6Pawn))
    {
        // End:0x161
        if(m_pGadgetToUse != none)
        {
            BlockFirstPersonView(false, false);
            m_pGadgetToUse = none;            
        }
        else
        {
            // End:0x17C
            if(m_pInteractionActor != none)
            {
                BlockFirstPersonView(false, false);
                m_pInteractionActor = none;
            }
        }        
    }
    else
    {
        // End:0x1A5
        if(int(Role) == int(ROLE_Authority))
        {
            // End:0x19E
            if(m_bCenteringCamera)
            {
                WaitCenterController();
            }
            UpdateRotationForTransition();
        }
    }
    bPreciseDestination = false;
    bForceDesiredRotation = false;
    UpdateMoveVelocity(0.0000000);
    // End:0x274
    if(int(Role) == int(ROLE_Authority))
    {
        m_bDisableCameraInput = false;
        m_bDisableUpdatePawnRotation = false;
        // End:0x21F
        if(m_pGadgetToUse != none)
        {
            // End:0x208
            if(m_pGadgetToUse.BlocksView())
            {
                BlockFirstPersonView(true, true);
            }
            m_R6Pawn.PawnUseGadget(m_pGadgetToUse);            
        }
        else
        {
            // End:0x26D
            if(m_pInteractionActor != none)
            {
                // End:0x255
                if(m_pInteractionActor.BlocksView())
                {
                    BlockFirstPersonView(true, m_pInteractionActor.DisableCameraMoveWhileUsing());
                }
                m_pInteractionActor.Interact(m_R6Pawn);                
            }
            else
            {
                PropagateReturnFromInteractState();
            }
        }
    }
    stop;            
}

state PlayerOnSnakeCam
{
    ignores LeaveTurretPC, DoAction;

    function bool ShouldUpdateVisionModeNow()
    {
        return true;
        return;
    }

    simulated function bool CanShowWeaponSwitch()
    {
        return false;
        return;
    }

    simulated function bool TryWeaponMenuLater()
    {
        return false;
        return;
    }

    simulated function bool CanShowWeaponOptions()
    {
        return false;
        return;
    }

    simulated function bool TryWeaponOptionMenuLater()
    {
        return false;
        return;
    }

    event bool CanSendOrder()
    {
        local R6GadgetSnakeCam pSnakeCam;

        pSnakeCam = R6GadgetSnakeCam(m_R6Pawn.m_pUsedGadget);
        // End:0x3A
        if((pSnakeCam != none) && pSnakeCam.m_bCamOut)
        {
            return false;
        }
        return global.CanSendOrder();
        return;
    }

    exec function NextScope()
    {
        local R6GadgetSnakeCam pSnakeCam;

        pSnakeCam = R6GadgetSnakeCam(m_R6Pawn.m_pUsedGadget);
        // End:0x53
        if((pSnakeCam != none) && pSnakeCam.m_pViewer != none)
        {
            pSnakeCam.m_pViewer.ToggleZoom();
        }
        return;
    }

    event float GetFOVScaleFactor()
    {
        // End:0x69
        if((m_R6Pawn.m_R6InvManager.m_pSnakeCam.m_pViewer != none) && m_R6Pawn.m_R6InvManager.m_pSnakeCam.m_pViewer.IsZoomed())
        {
            return GetControlsConfig().m_fMoveFactorSnakeCamZoom;            
        }
        else
        {
            return global.GetFOVScaleFactor();
        }
        return;
    }

    function PlayerMove(float fDeltaTime)
    {
        local Rotator rRot;

        // End:0x40
        if((m_R6Pawn != none) && !IsMoveStickInsideZone(GetControlsConfig().m_fDropSnakeCamZone))
        {
            UseGadgetPC(m_R6Pawn.m_pUsedGadget, none);            
        }
        else
        {
            rRot = GetCameraDeltaRotation(fDeltaTime);
            UpdateSnakeCamRotation(fDeltaTime, rRot.Yaw, rRot.Pitch);
            // End:0xC6
            if((int(Role) < int(ROLE_Authority)) && (rRot.Yaw != 0) || rRot.Pitch != 0)
            {
                ServerUpdateSnakeCamRotation(fDeltaTime, rRot.Yaw, rRot.Pitch);
            }
        }
        return;
    }

    event GadgetSelect(R6InventoryManager.EGadgetNum iNum)
    {
        UseGadgetPC(m_R6Pawn.m_pUsedGadget, none);
        global.GadgetSelect(iNum);
        return;
    }

    unreliable server event UseGadgetPC(R6Gadget pGadget, Actor pDest)
    {
        // End:0x31
        if(m_R6Pawn.m_pUsedGadget != none)
        {
            m_R6Pawn.PawnUseGadget(m_R6Pawn.m_pUsedGadget);
        }
        return;
    }

    event bool CanPlayerAction()
    {
        return false;
        return;
    }

    event bool CanPlayerBackAction()
    {
        local R6EngineEnums.ER6InteractDesc eDescUnused;

        return (m_OrdersController == none) || !m_OrdersController.GetTeamInteractDesc(eDescUnused);
        return;
    }

    simulated event bool GetInteractDesc(out R6EngineEnums.ER6InteractDesc eDesc, optional PlayerController PC)
    {
        eDesc = 5;
        return true;
        return;
    }

    simulated event bool GetBusyInteractDesc(out R6EngineEnums.ER6InteractDesc eDesc, PlayerController PC)
    {
        return false;
        return;
    }

    simulated function UpdateSnakeCamRotation(float fDeltaTime, int iYaw, int iPitch)
    {
        local R6GadgetSnakeCam pSnakeCam;
        local int iYawModif, iPitchModif;
        local Rotator rDeltaRot, rViewRot;

        pSnakeCam = R6GadgetSnakeCam(m_R6Pawn.m_pUsedGadget);
        // End:0x257
        if((((pSnakeCam != none) && pSnakeCam.m_pViewer != none) && !pSnakeCam.m_bCamIn) && !pSnakeCam.m_bCamOut)
        {
            iYawModif = pSnakeCam.m_pViewer.m_iYawModifier;
            iPitchModif = pSnakeCam.m_pViewer.m_iPitchModifier;
            rViewRot.Pitch = iPitchModif;
            rViewRot.Yaw = iYawModif;
            rDeltaRot.Pitch = iPitch;
            rDeltaRot.Yaw = iYaw;
            ApplyRotationAdhesion(rViewRot, rDeltaRot, fDeltaTime);
            iPitch = rDeltaRot.Pitch;
            iYaw = rDeltaRot.Yaw;
            // End:0x154
            if((iYawModif + iYaw) > GetGadgetsConfig().m_iSnakeCamYawLimit)
            {
                iYaw = GetGadgetsConfig().m_iSnakeCamYawLimit - iYawModif;                
            }
            else
            {
                // End:0x194
                if((iYawModif + iYaw) < -GetGadgetsConfig().m_iSnakeCamYawLimit)
                {
                    iYaw = -GetGadgetsConfig().m_iSnakeCamYawLimit - iYawModif;
                }
            }
            // End:0x1D3
            if((iPitchModif + iPitch) > GetGadgetsConfig().m_iSnakeCamPitchLimitMax)
            {
                iPitch = GetGadgetsConfig().m_iSnakeCamPitchLimitMax - iPitchModif;                
            }
            else
            {
                // End:0x20F
                if((iPitchModif + iPitch) < GetGadgetsConfig().m_iSnakeCamPitchLimitMin)
                {
                    iPitch = GetGadgetsConfig().m_iSnakeCamPitchLimitMin - iPitchModif;
                }
            }
            pSnakeCam.m_pViewer.m_iYawModifier = iYawModif + iYaw;
            pSnakeCam.m_pViewer.m_iPitchModifier = iPitchModif + iPitch;
        }
        return;
    }

    reliable server function ServerUpdateSnakeCamRotation(float fDeltaTime, int iYaw, int iPitch)
    {
        UpdateSnakeCamRotation(fDeltaTime, iYaw, iPitch);
        return;
    }

    function EndState(name NextStateName)
    {
        GetGameManager().TutorialCaseDone(40, true);
        LockGadgetButton();
        return;
    }
    stop;
}

state PlayerOnRope
{
    function BeginState(name PreviousStateName)
    {
        m_fFastRopeDampSpeed = 0.0000000;
        GetGameManager().TutorialCaseDone(4, true);
        return;
    }

    simulated function bool CanShowWeaponSwitch()
    {
        return false;
        return;
    }

    simulated function bool TryWeaponMenuLater()
    {
        return false;
        return;
    }

    simulated function bool CanShowWeaponOptions()
    {
        return (m_R6Pawn != none) && !m_R6Pawn.m_bFastRope;
        return;
    }

    simulated function bool TryWeaponOptionMenuLater()
    {
        return false;
        return;
    }

    function bool CanChangeScope()
    {
        return false;
        return;
    }

    exec function ChangePosture()
    {
        ServerInvertRope();
        return;
    }

    exec function NextScope()
    {
        ZoomRope();
        return;
    }

    function DrawStateInfo(HUD H)
    {
        local string szText;
        local float fXL, fYL;

        // End:0xD6
        if(m_R6Pawn.CanRopeBreach())
        {
            H.Canvas.DrawColor = H.WhiteColor;
            szText = "Press jump to get into the room";
            H.Canvas.__NFUN_464__(szText, fXL, fYL);
            H.Canvas.SetPos((H.SizeX - fXL) - float(10), 20.0000000);
            H.Canvas.__NFUN_465__(szText);
        }
        return;
    }

    function PlayerMove(float fDeltaTime)
    {
        // End:0x18
        if(Pawn == none)
        {
            GotoState('Dead');            
        }
        else
        {
            DoPlayerMove(fDeltaTime);
        }
        return;
    }

    event bool CanPlayerAction()
    {
        local R6EngineEnums.ER6InteractDesc eDescUnused;

        return (m_OrdersController == none) || !m_OrdersController.GetTeamInteractDesc(eDescUnused);
        return;
    }

    function DoAction()
    {
        ServerJumpRope();
        return;
    }

    simulated event bool GetInteractDesc(out R6EngineEnums.ER6InteractDesc eDesc, optional PlayerController PC)
    {
        // End:0x20
        if(m_R6Pawn.CanRopeBreach())
        {
            eDesc = 9;
            return true;            
        }
        else
        {
            // End:0x3F
            if(m_R6Pawn.CanRappelToFastRope())
            {
                eDesc = 10;
                return true;                
            }
            else
            {
                // End:0x5B
                if(m_R6Pawn.CanRopeJump())
                {
                    eDesc = 24;
                    return true;
                }
            }
        }
        return false;
        return;
    }

    simulated event bool GetBusyInteractDesc(out R6EngineEnums.ER6InteractDesc eDesc, PlayerController PC)
    {
        // End:0x52
        if(m_R6Pawn.IsHeightGoodForRopeBreach())
        {
            // End:0x45
            if(!m_R6Pawn.m_pOnRope.IsWindowBlocked(m_R6Pawn, m_R6Pawn.m_pOnWindow, true))
            {
                return false;
            }
            eDesc = 9;
            return true;            
        }
        else
        {
            // End:0x6E
            if(m_R6Pawn.IsPlaceRappelToFastRope())
            {
                eDesc = 10;
                return true;
            }
        }
        return false;
        return;
    }

    function FinishRopeAim()
    {
        StartFire();
        StopFire();
        return;
    }

    function PlayerUpdate(float fDeltaTime)
    {
        global.PlayerUpdate(fDeltaTime);
        PlayerUpdateOnRope(fDeltaTime);
        return;
    }

    event bool CanUseGadgetPC(R6Gadget GadgetToUse, Actor destActor)
    {
        return false;
        return;
    }
    stop;
}

state PlayerOnLadder
{
    function BeginState(name PreviousStateName)
    {
        // End:0x2E
        if((m_R6Pawn != none) && int(m_R6Pawn.m_eNavObAttachingPos) == int(1))
        {
            m_bReverseVertical = true;
        }
        GetGameManager().TutorialCaseDone(34, true);
        // End:0x5A
        if(m_bPendingJump)
        {
            ServerSetPawnSliding();
            m_bPendingJump = false;
        }
        return;
    }

    function EndState(name NextStateName)
    {
        m_bReverseVertical = false;
        // End:0x24
        if(m_R6Pawn != none)
        {
            m_R6Pawn.m_bForceHelmetUpdate = true;
        }
        return;
    }

    simulated function bool CanShowWeaponSwitch()
    {
        return false;
        return;
    }

    simulated function bool TryWeaponMenuLater()
    {
        return false;
        return;
    }

    simulated function bool CanShowWeaponOptions()
    {
        return false;
        return;
    }

    simulated function bool TryWeaponOptionMenuLater()
    {
        return false;
        return;
    }

    event bool CanUseGadgetPC(R6Gadget GadgetToUse, Actor destActor)
    {
        return false;
        return;
    }

    function bool CanChangeScope()
    {
        return false;
        return;
    }

    simulated event bool GetBusyInteractDesc(out R6EngineEnums.ER6InteractDesc eDesc, PlayerController PC)
    {
        return false;
        return;
    }

    function PlayerMove(float fDeltaTime)
    {
        // End:0x17
        if(Pawn == none)
        {
            GotoState('Dead');
            return;
        }
        // End:0x56
        if(m_bReverseVertical && (m_R6PlayerInput.m_fPawnForward <= 0.0000000) || m_R6Pawn.m_bSlidingLadder)
        {
            m_bReverseVertical = false;
        }
        DoPlayerMove(fDeltaTime);
        return;
    }

    event bool CanPlayerAction()
    {
        local R6EngineEnums.ER6InteractDesc eDescUnused;

        // End:0x26
        if((m_OrdersController != none) && m_OrdersController.GetTeamInteractDesc(eDescUnused))
        {
            return false;
        }
        return m_R6Pawn.CanSlideOnLadder();
        return;
    }

    function DoAction()
    {
        ServerSetPawnSliding();
        return;
    }

    function Rotator GetCameraDeltaRotation(float fDeltaTime)
    {
        local Rotator rDeltaRot;
        local int iMinPitch, iMaxPitch, iMinYaw, iMaxYaw;

        // End:0x92
        if(GetGameManager().IsUsingGamePad() && GetControlsConfig().m_bFixedCameraOnLadder)
        {
            m_R6PlayerCamera.GetRotationLimit(iMinPitch, iMaxPitch, 0);
            m_R6PlayerCamera.GetRotationLimit(iMinYaw, iMaxYaw, 1);
            rDeltaRot = m_R6PlayerInput.GetCameraDeltaRotationFixed(fDeltaTime, iMinPitch, iMaxPitch, iMinYaw, iMaxYaw);            
        }
        else
        {
            return global.GetCameraDeltaRotation(fDeltaTime);
        }
        return rDeltaRot;
        return;
    }

    simulated event bool GetInteractDesc(out R6EngineEnums.ER6InteractDesc eDesc, optional PlayerController PC)
    {
        local R6EngineEnums.ER6InteractDesc eDescUnused;

        // End:0x2D
        if(m_OrdersController != none)
        {
            // End:0x2D
            if(m_OrdersController.GetTeamInteractDesc(eDescUnused))
            {
                eDesc = 0;
                return false;
            }
        }
        // End:0x4C
        if(m_R6Pawn.CanSlideOnLadder())
        {
            eDesc = 27;
            return true;            
        }
        else
        {
            eDesc = 0;
            return false;
        }
        return;
    }
    stop;
}

state PlayerDriving
{
    function ProcessDrive(float InForward, float InStrafe, float InUp, bool InJump)
    {
        local Vehicle CurrentVehicle;

        CurrentVehicle = Vehicle(Pawn);
        // End:0x1D
        if(CurrentVehicle == none)
        {
            return;
        }
        CurrentVehicle.Throttle = InForward;
        CurrentVehicle.Steering = -InStrafe;
        CurrentVehicle.Rise = InUp;
        return;
    }

    function PlayerMove(float DeltaTime)
    {
        local Vehicle CurrentVehicle;

        CurrentVehicle = Vehicle(Pawn);
        UpdateRotation(DeltaTime);
        // End:0xF6
        if(int(Role) < int(ROLE_Authority))
        {
            // End:0x8E
            if(CurrentVehicle != none)
            {
                CurrentVehicle.Throttle = PlayerInput.aForward;
                CurrentVehicle.Steering = PlayerInput.aStrafe;
                CurrentVehicle.Rise = PlayerInput.aUp;
            }
            ServerDrive(PlayerInput.aForward, PlayerInput.aStrafe, PlayerInput.aUp, false, ((32767 & (Rotation.Pitch / 2)) * 32768) + (32767 & (Rotation.Yaw / 2)));            
        }
        else
        {
            ProcessDrive(PlayerInput.aForward, PlayerInput.aStrafe, PlayerInput.aUp, false);
        }
        return;
    }

    function BeginState(name PreviousStateName)
    {
        CleanOutSavedMoves();
        return;
    }

    function EndState(name NextStateName)
    {
        CleanOutSavedMoves();
        return;
    }
    stop;
}

state PlayerFlying
{
    function BeginState(name PreviousStateName)
    {
        Pawn.SetPhysics(4);
        return;
    }

    function PlayerMove(float fDeltaTime)
    {
        DoPlayerMove(fDeltaTime);
        return;
    }
    stop;
}

state PlayerWalking
{
    simulated function BeginState(name PreviousStateName)
    {
        // End:0x7D
        if(m_R6Pawn != none)
        {
            // End:0x4D
            if((int(m_R6Pawn.Physics) != int(2)) && int(m_R6Pawn.Physics) != int(10))
            {
                m_R6Pawn.SetPhysics(1);
            }
            // End:0x7D
            if(m_R6Pawn.m_R6InvManager != none)
            {
                m_R6Pawn.m_R6InvManager.EquipRememberedWeapon();
            }
        }
        m_LastWalkingPos.m_vLocation.X = 0.0000000;
        m_LastWalkingPos.m_vLocation.Y = 0.0000000;
        m_LastWalkingPos.m_vLocation.Z = 0.0000000;
        return;
    }

    function EndState(name NextStateName)
    {
        // End:0x4E
        if(m_R6Pawn != none)
        {
            m_LastWalkingPos.m_vLocation = m_R6Pawn.Location;
            m_LastWalkingPos.m_rRotation = m_R6Pawn.Rotation;
            m_R6Pawn.TakeCoverShield(false);
        }
        return;
    }

    function ProcessChangePosture()
    {
        ServerTogglePosture();
        return;
    }

    function PlayerMove(float fDeltaTime)
    {
        // End:0x18
        if(m_R6Pawn == none)
        {
            GotoState('Dead');            
        }
        else
        {
            // End:0x38
            if(m_R6Pawn.IsInTakeCover())
            {
                m_bCanMoveInTakeCover = CanMoveInTakeCover();
            }
            DoPlayerMove(fDeltaTime);
        }
        return;
    }

    function bool AllowPickup()
    {
        return true;
        return;
    }
    stop;
}

state Dead
{
    ignores KilledBy, NextScope, ReloadBut, ReloadButHeld, ReloadButOff, RateOfFireButton, 
	    TagEnemyBut, TagEnemyButHeld, TagEnemyButOff, TagEnemyButHeldOff, UseGadgetButOff, 
	    SwitchWeaponBut, SwitchWeaponButHeld, SwitchWeaponButOff, SetVisionModeBut, SetVisionModeButOff, 
	    VisionModeButHeld, NightVisionButton, HeatVisionButton, SendOrderTeam, GiveOrderUp, 
	    GiveOrderDown, GiveOrderLeft, GiveOrderRight;

    function BeginState(name PreviousStateName)
    {
        local R6EngineEnums.EGameType eCurGameType;

        BeginState(PreviousStateName);
        // End:0x28
        if(!LocalPlayerController())
        {
            ClientGotoState('Dead');            
        }
        else
        {
            // End:0x43
            if(m_MagmaInteraction != none)
            {
                m_MagmaInteraction.PlayerDied();
            }
        }
        m_R6Pawn = none;
        eCurGameType = GetGameManager().GetGameType();
        // End:0xC2
        if(int(eCurGameType) == int(4))
        {
            WaitDelay = (WorldInfo.TimeSeconds + GetCameraConfig().m_fKillCamStart) + GetCameraConfig().m_fKillCamDuration;
            SetTimer(GetCameraConfig().m_fKillCamDuration, false, 'TimerEnterObserverMode');            
        }
        else
        {
            // End:0xEA
            if(int(eCurGameType) == int(3))
            {
                SetTimer(GetCameraConfig().m_fDeadCamDuration, false, 'TimerEnterObserverMode');
            }
        }
        return;
    }

    function EndState(name NextStateName)
    {
        EndState(NextStateName);
        ClearTimer();
        return;
    }

    function TimerEnterObserverMode()
    {
        EnterObserverMode();
        return;
    }

    event bool CanSendOrder()
    {
        return false;
        return;
    }
    stop;
}

state s_KnockedOut
{
    ignores KilledBy, ReloadButOff, NextScope, TagEnemyBut, SwitchWeaponButHeld, ReloadButHeld, 
	    TagEnemyButOff, TagEnemyButHeldOff, UseGadgetButOff, SetVisionModeBut, SetVisionModeButOff, 
	    VisionModeButHeld, NightVisionButton, HeatVisionButton, SendOrderTeam, GiveOrderUp, 
	    GiveOrderDown, GiveOrderLeft, GiveOrderRight;

    function BeginState(name PreviousStateName)
    {
        BeginState(PreviousStateName);
        // End:0x28
        if(!LocalPlayerController())
        {
            ClientGotoState('s_KnockedOut');            
        }
        else
        {
            // End:0x43
            if(m_MagmaInteraction != none)
            {
                m_MagmaInteraction.PlayerDied();
            }
        }
        m_R6Pawn.GotoState('s_KnockDown');
        return;
    }

    event bool CanSendOrder()
    {
        return false;
        return;
    }

    function ProcessChangePosture()
    {
        // End:0x19
        if(m_R6Pawn.bIsCrouched)
        {
            ServerTogglePosture();
        }
        return;
    }

    function PlayerMove(float fDeltaTime)
    {
        // End:0x1D
        if(m_R6Pawn.bIsCrouched)
        {
            DoPlayerMove(fDeltaTime);
        }
        return;
    }

    simulated function OnR6KnockOutPlayer(SeqAct_R6KnockOutPlayer Action)
    {
        // End:0x41
        if(Action.InputLinks[1].bHasImpulse)
        {
            Action.OutputLinks[1].bHasImpulse = true;
            m_R6Pawn.StartGetUpFromKnock();
        }
        return;
    }
    stop;
}

state s_TakeCover
{
    function BeginState(name PreviousStateName)
    {
        // End:0x3D
        if((PreviousStateName != 'PlayerOnTransition') && PreviousStateName != 'PlayerOnMoveTransition')
        {
            // End:0x3A
            if(m_R6Pawn.IsScoping())
            {
                ResetScope();
            }            
        }
        else
        {
            m_R6Pawn.m_R6InvManager.EquipRememberedWeapon();
        }
        m_bPendingShoot = false;
        GetGameManager().TutorialCaseDone(6, true);
        return;
    }

    event bool CanPlayerAction()
    {
        // End:0x1E
        if(int(m_R6Pawn.m_eOTSCameraSide) != int(2))
        {
            return false;            
        }
        else
        {
            return global.CanPlayerAction();
        }
        return;
    }

    function EndState(name NextStateName)
    {
        m_bApplySwitchCoverRot = false;
        return;
    }

    function PlayerUpdate(float fDeltaTime)
    {
        global.PlayerUpdate(fDeltaTime);
        PlayerUpdateTakeCover(fDeltaTime);
        return;
    }

    function ProcessChangePosture()
    {
        ServerTogglePosture();
        return;
    }

    simulated function bool CanChangeScope()
    {
        // End:0x35
        if((m_R6Pawn != none) && m_R6Pawn.IsEnteringCover() || m_R6Pawn.IsExitingCover())
        {
            return false;
        }
        return global.CanChangeScope();
        return;
    }

    event bool CanUseGadgetPC(R6Gadget GadgetToUse, Actor destActor)
    {
        // End:0x30
        if((GadgetToUse != none) && GadgetToUse.m_bCanUseInTakeCover)
        {
            return global.CanUseGadgetPC(GadgetToUse, destActor);
        }
        ClientPlayRejectSound();
        return false;
        return;
    }

    function PlayerMove(float fDeltaTime)
    {
        // End:0x18
        if(m_R6Pawn == none)
        {
            GotoState('Dead');            
        }
        else
        {
            m_bCanMoveInTakeCover = CanMoveInTakeCover();
            DoPlayerMove(fDeltaTime);
        }
        return;
    }
    stop;
}

simulated state PlayerTurreting
{
    ignores DoAction, LeaveTurretPC;

    simulated function BeginState(name PreviousStateName)
    {
        GetGameManager().ShowTutorialCase(49);
        return;
    }

    function EndState(name NextStateName)
    {
        GetGameManager().TutorialCaseDone(49, false);
        LockGadgetButton();
        return;
    }

    function PlayerMove(float fDeltaTime)
    {
        local Vector vNewAccel;
        local Rotator rOldRotation;

        // End:0x18
        if(Pawn == none)
        {
            GotoState('Dead');            
        }
        else
        {
            rOldRotation = Rotation;
            UpdateRotation(fDeltaTime);
            // End:0x5F
            if(int(Role) < int(ROLE_Authority))
            {
                ReplicateMove(fDeltaTime, vNewAccel, rOldRotation - Rotation);                
            }
            else
            {
                ProcessMove(fDeltaTime, vNewAccel, rOldRotation - Rotation);
            }
        }
        return;
    }

    simulated event bool CanPlayerAction()
    {
        return false;
        return;
    }

    event bool CanPlayerBackAction()
    {
        local R6EngineEnums.ER6InteractDesc eDescUnused;

        return (m_OrdersController == none) || !m_OrdersController.GetTeamInteractDesc(eDescUnused);
        return;
    }

    simulated event bool GetInteractDesc(out R6EngineEnums.ER6InteractDesc eDesc, optional PlayerController PC)
    {
        eDesc = 12;
        return true;
        return;
    }

    simulated event bool GetBusyInteractDesc(out R6EngineEnums.ER6InteractDesc eDesc, PlayerController PC)
    {
        return false;
        return;
    }

    unreliable server event UseGadgetPC(R6Gadget pGadget, Actor pDest)
    {
        // End:0x3E
        if(m_R6Pawn.CanLeaveTurret())
        {
            // End:0x2D
            if(int(Role) < int(ROLE_Authority))
            {
                ServerStartLeavingTurret();                
            }
            else
            {
                m_R6Pawn.StartLeavingTurret();
            }
        }
        return;
    }

    simulated function Rotator GetBaseRotation()
    {
        return m_R6Pawn.m_operatedTurret.Rotation;
        return;
    }
    stop;
}

state PlayerInHelicopter
{
    ignores SendOrderTeam, GiveOrderUp, GiveOrderDown, GiveOrderLeft, GiveOrderRight, ReloadBut, 
	    ReloadButHeld, ReloadButOff, RateOfFireButton, SetVisionModeBut, SetVisionModeButOff, 
	    VisionModeButHeld, NightVisionButton, HeatVisionButton, TagEnemyBut, TagEnemyButHeld, 
	    TagEnemyButOff, TagEnemyButHeldOff, UseGadgetButOff, SwitchWeaponBut, SwitchWeaponButHeld;

    event bool CanUseGadgetPC(R6Gadget GadgetToUse, Actor destActor)
    {
        return false;
        return;
    }

    function bool CanChangeScope()
    {
        return false;
        return;
    }

    function PlayerMove(float fDeltaTime)
    {
        UpdateRotation(fDeltaTime);
        return;
    }

    simulated function Rotator GetBaseRotation()
    {
        // End:0x45
        if((int(m_R6Pawn.m_eHelicopterSeat) == int(2)) || int(m_R6Pawn.m_eHelicopterSeat) == int(0))
        {
            return rot(0, 0, 0);            
        }
        else
        {
            return rot(0, 32768, 0);
        }
        return;
    }

    function DoAction()
    {
        m_R6Pawn.StartExitingHelicopter();
        return;
    }

    event bool CanPlayerAction()
    {
        return m_R6Pawn.CanStartExitingHelicopter();
        return;
    }

    event bool CanSendOrder()
    {
        return false;
        return;
    }

    simulated event bool GetInteractDesc(out R6EngineEnums.ER6InteractDesc eDesc, optional PlayerController PC)
    {
        eDesc = 14;
        return true;
        return;
    }

    simulated event bool GetBusyInteractDesc(out R6EngineEnums.ER6InteractDesc eDesc, PlayerController PC)
    {
        return false;
        return;
    }

    exec function SwitchWeaponButOff()
    {
        // End:0x4C
        if(((m_MagmaInteraction != none) && int(m_R6Pawn.m_eCurrentHelicopterAction) == int(1)) && WorldInfo.m_bAllowHeliRideOutfitting)
        {
            m_MagmaInteraction.DisplayOutfitting(true);
        }
        return;
    }
    stop;
}

state PlayerPickingUpWeapon
{
    ignores DoAction;

    function BeginState(name PreviousStateName)
    {
        ClientGotoPlayerPickingUpWeapon();
        return;
    }

    function PickUpWeapon(R6PickupableActor pPickup)
    {
        pPickup.PickupItem(m_R6Pawn);
        HandleWalkOutPickup(pPickup);
        GotoPlayerWalking();
        return;
    }

    function PawnDied(Pawn DiedPawn)
    {
        local R6Pawn pPawn;

        pPawn = R6Pawn(DiedPawn);
        pPawn.CancelPickup();
        PawnDied(DiedPawn);
        return;
    }

    event bool CanUseGadgetPC(R6Gadget GadgetToUse, Actor destActor)
    {
        return false;
        return;
    }

    function PlayerMove(float fDeltaTime)
    {
        DampSpeedOnPickup(fDeltaTime);
        UpdateRotation(fDeltaTime);
        return;
    }

    event bool CanPlayerAction()
    {
        return false;
        return;
    }

    event bool CanSendOrder()
    {
        return false;
        return;
    }

    simulated event bool GetInteractDesc(out R6EngineEnums.ER6InteractDesc eDesc, optional PlayerController PC)
    {
        eDesc = 0;
        return false;
        return;
    }

    simulated event bool GetBusyInteractDesc(out R6EngineEnums.ER6InteractDesc eDesc, PlayerController PC)
    {
        return false;
        return;
    }
    stop;
}

state RoundEnded
{
    ignores KilledBy, TakeDamage, ReceiveWarning;
    stop;
}

auto state PlayerWaiting
{
    ignores TakeDamage, RestartLevel, Suicide, NextWeapon, PrevWeapon, SwitchToBestWeapon, 
	    ThrowWeapon, NextScope, ReloadButHeld, ReloadButOff, RateOfFireButton, 
	    SwitchWeaponBut, SwitchWeaponButHeld, SwitchWeaponButOff, TagEnemyBut, TagEnemyButHeld, 
	    TagEnemyButOff, TagEnemyButHeldOff, UseGadgetButOff, SetVisionModeBut, SetVisionModeButOff, 
	    VisionModeButHeld, NightVisionButton, HeatVisionButton, SendOrderTeam, GiveOrderUp, 
	    GiveOrderDown, GiveOrderLeft, GiveOrderRight;

    simulated function BeginState(name PreviousStateName)
    {
        IgnoreMoveInput(true);
        IgnoreLookInput(true);
        BeginState(PreviousStateName);
        // End:0x3C
        if(m_MagmaInteraction != none)
        {
            m_MagmaInteraction.OnPlayerStatusChanged(string(GetStateName()));
        }
        // End:0x94
        if((PlayerReplicationInfo != none) && (int(GetGameManager().GetGameStatus()) == int(5)) || int(GetGameManager().GetGameStatus()) == int(4))
        {
            PlayerReplicationInfo.bReadyToPlay = true;
        }
        return;
    }

    simulated function EndState(name NextStateName)
    {
        IgnoreMoveInput(false);
        IgnoreLookInput(false);
        EndState(NextStateName);
        // End:0x3E
        if(m_MagmaInteraction != none)
        {
            m_MagmaInteraction.OnPlayerStatusChanged(string(NextStateName));
        }
        return;
    }

    function PlayerMove(float fDeltaTime)
    {
        UpdateRotation(fDeltaTime);
        return;
    }

    event bool IsSpectating()
    {
        return false;
        return;
    }

    event bool IsWaiting()
    {
        return true;
        return;
    }

    exec function ReloadBut()
    {
        TogglePlayerReady();
        return;
    }
    stop;
}

state Spectating
{
    ignores RestartLevel, Suicide, NextWeapon, PrevWeapon, SwitchToBestWeapon, ThrowWeapon, 
	    NextScope, ReloadBut, ReloadButHeld, ReloadButOff, RateOfFireButton, 
	    SwitchWeaponButHeld, TagEnemyBut, TagEnemyButHeld, TagEnemyButOff, TagEnemyButHeldOff, 
	    UseGadgetButOff, SetVisionModeBut, SetVisionModeButOff, VisionModeButHeld, NightVisionButton, 
	    HeatVisionButton, SendOrderTeam, GiveOrderUp, GiveOrderDown, ChangePOV;

    function BeginState(name PreviousStateName)
    {
        bCollideWorld = true;
        // End:0x46
        if(PlayerReplicationInfo != none)
        {
            PlayerReplicationInfo.bIsSpectator = true;
            PlayerReplicationInfo.NetUpdateTime = WorldInfo.TimeSeconds - float(1);
        }
        // End:0x79
        if(WorldInfo.Game != none)
        {
            R6GameInfo(WorldInfo.Game).Spectated(self);
        }
        // End:0x8D
        if(LocalPlayerController())
        {
            SelectVisionMode(0);
        }
        ServerViewNextPlayer();
        IgnoreMoveInput(true);
        IgnoreLookInput(true);
        FlushVisualEffects();
        FadeInSounds();
        return;
    }

    function EndState(name NextStateName)
    {
        // End:0x1C
        if(m_MagmaInteraction != none)
        {
            m_MagmaInteraction.ShowOutfittingHud(false);
        }
        ShowRespawnScreen(false);
        m_eLastVisionMode = 0;
        IgnoreMoveInput(false);
        IgnoreLookInput(false);
        EndState(NextStateName);
        return;
    }

    function PlayerUpdate(float fDeltaTime)
    {
        local R6PlayerReplicationInfo PRepInfo;
        local Actor ActualViewTarget;

        global.PlayerUpdate(fDeltaTime);
        OnPlayerUpdateSpectating(fDeltaTime);
        // End:0x84
        if(LocalPlayerController())
        {
            PRepInfo = GetPlayerInfo();
            // End:0x59
            if((PRepInfo != none) && PRepInfo.m_bPauseRespawnDelay)
            {
                WaitDelay += fDeltaTime;
            }
            ActualViewTarget = GetActivePlayerView();
            // End:0x84
            if((ActualViewTarget == none) || ActualViewTarget == self)
            {
                ServerViewNextPlayer();
            }
        }
        return;
    }

    event ServerPlayerUpdate(float fDeltaTime)
    {
        local R6PlayerReplicationInfo PRepInfo;

        global.ServerPlayerUpdate(fDeltaTime);
        // End:0x4F
        if(!LocalPlayerController())
        {
            PRepInfo = GetPlayerInfo();
            // End:0x4F
            if((PRepInfo != none) && PRepInfo.m_bPauseRespawnDelay)
            {
                WaitDelay += fDeltaTime;
            }
        }
        return;
    }

    reliable client simulated function ClientRestart(Pawn NewPawn)
    {
        // End:0x1F
        if(!PlayerReplicationInfo.bOnlySpectator)
        {
            global.ClientRestart(NewPawn);
        }
        return;
    }

    exec function GiveOrderRight(int iEvent)
    {
        ServerViewNextPlayer();
        return;
    }

    exec function GiveOrderLeft(int iEvent)
    {
        ServerViewPrevPlayer();
        return;
    }

    unreliable server function ServerViewNextPlayer()
    {
        // End:0x29
        if((PlayerReplicationInfo != none) && PlayerReplicationInfo.bOnlySpectator)
        {
            ServerViewNextPlayer();            
        }
        else
        {
            ChangePlayerView(true);
        }
        return;
    }

    unreliable server function ServerViewPrevPlayer()
    {
        // End:0x22
        if((PlayerReplicationInfo != none) && PlayerReplicationInfo.bOnlySpectator)
        {            
        }
        else
        {
            ChangePlayerView(false);
        }
        return;
    }

    simulated event bool CanPlayerAction()
    {
        return false;
        return;
    }

    reliable server event ServerRestartPlayer()
    {
        local R6PlayerReplicationInfo PRepInfo;

        PRepInfo = GetPlayerInfo();
        // End:0x2E
        if((PRepInfo != none) && PRepInfo.m_bPauseRespawnDelay)
        {
            return;
        }
        // End:0x48
        if(WorldInfo.TimeSeconds < WaitDelay)
        {
            return;
        }
        // End:0x63
        if(int(WorldInfo.NetMode) == int(NM_Client))
        {
            return;
        }
        WorldInfo.Game.RestartPlayer(self);
        return;
    }

    function bool ShouldUpdateVisionModeNow()
    {
        return true;
        return;
    }

    exec function OpenMenu()
    {
        // End:0x28
        if(!ShowRespawnScreen(true))
        {
            // End:0x28
            if(m_MagmaInteraction != none)
            {
                m_MagmaInteraction.TogglePauseMenu();
            }
        }
        return;
    }

    reliable client simulated event ClientSetViewTarget(Actor A, optional float TransitionTime, optional bool bWaitRender)
    {
        // End:0x40
        if(((Pawn != A) && m_MagmaInteraction != none) && R6Pawn(A) != none)
        {
            m_MagmaInteraction.FadeOnReset(false);
        }
        ClientSetViewTarget(A, TransitionTime, bWaitRender);
        return;
    }
    stop;
}

simulated state NoInputState
{    stop;
}

simulated state CheatCyclePawns extends NoInputState
{
    function PlayerMove(float fDeltaTime)
    {
        local Rotator rDeltaRot, rViewRotation;

        bSetTurnRot = false;
        rViewRotation = Rotation;
        rDeltaRot = GetCameraDeltaRotation(fDeltaTime);
        ProcessViewRotation(fDeltaTime, rViewRotation, rDeltaRot);
        SetRotation(rViewRotation);
        return;
    }

    exec function PrevWeapon()
    {
        // End:0x26
        if(m_bZoomOnPawnCycle)
        {
            m_R6PlayerCamera.m_vDebugCamOffset.X -= 5.0000000;            
        }
        else
        {
            m_R6PlayerCamera.m_vDebugCamOffset.Z -= 5.0000000;
        }
        return;
    }

    exec function NextWeapon()
    {
        // End:0x26
        if(m_bZoomOnPawnCycle)
        {
            m_R6PlayerCamera.m_vDebugCamOffset.X += 5.0000000;            
        }
        else
        {
            m_R6PlayerCamera.m_vDebugCamOffset.Z += 5.0000000;
        }
        return;
    }

    exec function NextScope()
    {
        m_bZoomOnPawnCycle = !m_bZoomOnPawnCycle;
        return;
    }
    stop;
}

state s_EndCredits
{
    ignores KilledBy, ReloadButOff, NextScope, TagEnemyBut, SwitchWeaponButHeld, ReloadButHeld, 
	    TagEnemyButOff, UseGadgetButOff, TagEnemyButHeldOff, SetVisionModeBut, SetVisionModeButOff, 
	    VisionModeButHeld, NightVisionButton, HeatVisionButton, SendOrderTeam, GiveOrderUp, 
	    GiveOrderDown, GiveOrderLeft, GiveOrderRight;

    function BeginState(name PreviousStateName)
    {
        BeginState(PreviousStateName);
        bGodMode = true;
        // End:0x2F
        if(m_MagmaInteraction != none)
        {
            m_MagmaInteraction.PlayerDied();
        }
        // End:0x72
        if(m_R6Pawn != none)
        {
            m_R6Pawn.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
            m_R6Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
        }
        StartEndCredits();
        SetTimer(GetMiscConfig().m_fFadeToBlackTimeBeforeCredits + 0.2000000, false, 'CreditsFadeFinished');
        return;
    }
    stop;
}

state s_EndMap
{
    ignores KilledBy, ReloadButOff, NextScope, TagEnemyBut, SwitchWeaponButHeld, ReloadButHeld, 
	    TagEnemyButOff, UseGadgetButOff, TagEnemyButHeldOff, SetVisionModeBut, SetVisionModeButOff, 
	    VisionModeButHeld, NightVisionButton, HeatVisionButton, SendOrderTeam, GiveOrderUp, 
	    GiveOrderDown, GiveOrderLeft, GiveOrderRight;

    function BeginState(name PreviousStateName)
    {
        // End:0x19
        if(!LocalPlayerController())
        {
            ClientGotoState('s_EndMap');
        }
        // End:0x5C
        if(m_R6Pawn != none)
        {
            m_R6Pawn.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
            m_R6Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
        }
        return;
    }

    simulated event bool GetInteractDesc(out R6EngineEnums.ER6InteractDesc eDesc, optional PlayerController PC)
    {
        return false;
        return;
    }

    simulated event bool GetBusyInteractDesc(out R6EngineEnums.ER6InteractDesc eDesc, PlayerController PC)
    {
        return false;
        return;
    }
    stop;
}

defaultproperties
{
    m_bAllowVisionMode=true
    m_bFiringInputEnabled=true
    m_rejectSound=SoundCue'Dare.SFX_Menus.Play_Planning_BadClick'
    m_VisionActivationSound=SoundCue'Dare.W_Visions.Play_G_NightVision_Activate'
    m_VisionLoopingSound=SoundCue'Dare.W_Visions.Play_G_NightVision_Loop'
    m_VisionDeactivationSound=SoundCue'Dare.W_Visions.Stop_G_NightVision_Activate'
    m_VisionLoopingStopSound=SoundCue'Dare.W_Visions.Stop_G_NightVision_Loop'
    m_MotionSensorSound=SoundCue'Dare.Player.Play_Multi_MotionSensor_MovementSignalSound'
    CameraClass=Class'R6Camera'
    CheatClass=Class'R6CheatManager'
    InputClass=Class'R6PlayerInput'
    m_SelectedVisionMode=2
    MinHitWall=-0.3000000
    TickGroup=1
}