class R6Pawn extends Pawn
    native
    config(Game)
    hidecategories(lighting);

const kSlotPrimary = 0;
const kSlotSecondary = 1;
const kSlotPistol = 2;
const kSlotGadget1 = 3;
const kSlotGadget2 = 4;
const kMaxGadgets = 2;

enum R6AIControllerState
{
    EAIS_Default,                   // 0
    EAIS_Dead,                      // 1
    EAIS_Unconscious,               // 2
    EAIS_MAX                        // 3
};

enum EAlliance
{
    ALLY_None,                      // 0
    ALLY_Civilian,                  // 1
    ALLY_Rainbow,                   // 2
    ALLY_Unused,                    // 3
    ALLY_Terrorist1,                // 4
    ALLY_Terrorist2,                // 5
    ALLY_MAX                        // 6
};

enum EAllianceStatus
{
    ALLYSTAT_Neutral,               // 0
    ALLYSTAT_Friend,                // 1
    ALLYSTAT_Enemy,                 // 2
    ALLYSTAT_MAX                    // 3
};

enum ETurretState
{
    ETurretState_NoStep,            // 0
    ETurretState_StepRight,         // 1
    ETurretState_SteppingRight,     // 2
    ETurretState_UnsteppingRight,   // 3
    ETurretState_StepLeft,          // 4
    ETurretState_SteppingLeft,      // 5
    ETurretState_UnsteppingLeft,    // 6
    ETurretState_TakeCover,         // 7
    ETurretState_MAX                // 8
};

enum EMentalStatesIdles
{
    EMentalStatesIdles_Normal,      // 0
    EMentalStatesIdles_LazyOneHanded,// 1
    EMentalStatesIdles_LazyTwoHanded,// 2
    EMentalStatesIdles_Stressed,    // 3
    EMentalStatesIdles_Talk_Alert,  // 4
    EMentalStatesIdles_Talk_Unaware,// 5
    EMentalStatesIdles_Listen_Alert,// 6
    EMentalStatesIdles_Listen_Unaware,// 7
    EMentalStatesIdles_MAX          // 8
};

enum EMentalStatesTransitions
{
    EMentalStatesTransitions_None,  // 0
    EMentalStatesTransitions_LazyOneHanded,// 1
    EMentalStatesTransitions_LazyTwoHanded,// 2
    EMentalStatesTransitions_Stressed,// 3
    EMentalStatesTransitions_MAX    // 4
};

enum EBreachTransitionType
{
    BREACHTYPE_NONE,                // 0
    BREACHTYPE_TCLEFT_TO_LEFT,      // 1
    BREACHTYPE_TCLEFT_TO_FRONT,     // 2
    BREACHTYPE_TCLEFT_TO_RIGHT,     // 3
    BREACHTYPE_TCRIGHT_TO_LEFT,     // 4
    BREACHTYPE_TCRIGHT_TO_FRONT,    // 5
    BREACHTYPE_TCRIGHT_TO_RIGHT,    // 6
    BREACHTYPE_STACKLEFT_TO_LEFT,   // 7
    BREACHTYPE_STACKLEFT_TO_FRONT,  // 8
    BREACHTYPE_STACKLEFT_TO_RIGHT,  // 9
    BREACHTYPE_STACKRIGHT_TO_LEFT,  // 10
    BREACHTYPE_STACKRIGHT_TO_FRONT, // 11
    BREACHTYPE_STACKRIGHT_TO_RIGHT, // 12
    BREACHTYPE_FRONT_TO_LEFT,       // 13
    BREACHTYPE_FRONT_TO_FRONT,      // 14
    BREACHTYPE_FRONT_TO_RIGHT,      // 15
    BREACHTYPE_MAX                  // 16
};

enum EAnimTc360MoveState
{
    ANIMNODETCMOVESTATE_IDLE,       // 0
    ANIMNODETCMOVESTATE_STEP,       // 1
    ANIMNODETCMOVESTATE_WALK,       // 2
    ANIMNODETCMOVESTATE_IDLETOSTEP, // 3
    ANIMNODETCMOVESTATE_IDLETOWALK, // 4
    ANIMNODETCMOVESTATE_STEPTOIDLE, // 5
    ANIMNODETCMOVESTATE_STEPTOWALKWAIT,// 6
    ANIMNODETCMOVESTATE_STEPTOWALK, // 7
    ANIMNODETCMOVESTATE_WALKTOSTEP, // 8
    ANIMNODETCMOVESTATE_WALKTOIDLE, // 9
    ANIMNODETCMOVESTATE_TRANSITIONTOIDLE,// 10
    ANIMNODETCMOVESTATE_TRANSITIONTOSTEP,// 11
    ANIMNODETCMOVESTATE_TRANSITIONTOWALK,// 12
    ANIMNODETCMOVESTATE_MAX         // 13
};

enum EHelmetWantsToStatus
{
    HELMETWANTSTOSTATUS_NONE,       // 0
    HELMETWANTSTOSTATUS_CHANGEMODE, // 1
    HELMETWANTSTOSTATUS_WEARGOGGLE, // 2
    HELMETWANTSTOSTATUS_REMOVEGOGGLE,// 3
    HELMETWANTSTOSTATUS_CHANGEMASK, // 4
    HELMETWANTSTOSTATUS_MAX         // 5
};

enum ELadderStatus
{
    LADDERSTATUS_NONE,              // 0
    LADDERSTATUS_ATTACHING,         // 1
    LADDERSTATUS_DETTACHING,        // 2
    LADDERSTATUS_MAX                // 3
};

enum ENotificationUpdateType
{
    UPDATE_TYPE_NONE,               // 0
    UPDATE_TYPE_RAPPELLING,         // 1
    UPDATE_TYPE_LADDER,             // 2
    UPDATE_TYPE_CLIMB,              // 3
    UPDATE_TYPE_MAX                 // 4
};

enum EAITraining
{
    AIT_Rookie,                     // 0
    AIT_Novice,                     // 1
    AIT_Expert,                     // 2
    AIT_MAX                         // 3
};

struct SDefend
{
    var() bool bUseDefend;
    var() Actor StaticPoint;
    var() Actor CenterPoint;
    var() float DefendRadius;
    var() float GiveUpRadius;
    var() array<Actor> CheckPoints;

    structdefaultproperties
    {
        bUseDefend=false
        StaticPoint=none
        CenterPoint=none
        DefendRadius=0.0000000
        GiveUpRadius=0.0000000
        CheckPoints=none
    }
};

struct ObjectOfInterest
{
    var Vector m_vObjectPosition;
    var Actor m_pActor;

    structdefaultproperties
    {
        m_vObjectPosition=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_pActor=none
    }
};

struct SPawnHealthReactionInfo
{
    var R6GameEnums.ERainbowHealthReaction m_eType;
    var R6GameEnums.EEventRelativeLocation m_eLocation;
    var R6GameEnums.EBodyPartReaction m_eBodyPart;
    var float m_fDuration;
    var bool m_bStandInPlace;
    var bool m_bFast;
    var float m_fScale;
    var float m_fRate;

    structdefaultproperties
    {
        m_eType=0
        m_eLocation=0
        m_eBodyPart=0
        m_fDuration=0.0000000
        m_bStandInPlace=false
        m_bFast=false
        m_fScale=0.0000000
        m_fRate=0.0000000
    }
};

struct STcMovementAnimInfo
{
    structcpptext
    {

    void UpdateTcMoveAnimInfo( class AR6Pawn* pPawn, FLOAT fDelta );
    void Reset();
    BYTE GetMoveState( class AR6Pawn* pPawn, FLOAT fVelocity );
    void UpdateState( class AR6Pawn* pPawn, BYTE eNewState );
    void UpdateBlend( FLOAT fDelta );
    void UpdateWeight( class AR6Pawn* pPawn, FLOAT fVelocity, FLOAT fDelta );
    void UpdateRates( class AR6Pawn* pPawn, FLOAT fVelocity );

    }

    var array<float> m_aWeights;
    var array<float> m_aRates;
    var R6Pawn.EAnimTc360MoveState m_eState;
    var bool m_bBlendToNotMoving;
    var bool m_bDoingSideStep;
    var bool m_bWantsToStop;
    var bool m_bTurningBack;
    var float m_fBlendTimeToGo;
    var float m_fBlendSpeed;
    var float m_fWalkInterpolateSpeed;
    var float m_fBlendToNotMovingLength;
    var Vector m_vOldLocation;

    structdefaultproperties
    {
        m_aWeights[0]=1.0000000
        m_aWeights[1]=0.0000000
        m_aWeights[2]=0.0000000
        m_aWeights[3]=0.0000000
        m_aWeights[4]=0.0000000
        m_aRates[0]=1.0000000
        m_aRates[1]=1.0000000
        m_aRates[2]=1.0000000
        m_aRates[3]=1.0000000
        m_eState=0
        m_bBlendToNotMoving=false
        m_bDoingSideStep=false
        m_bWantsToStop=false
        m_bTurningBack=false
        m_fBlendTimeToGo=0.0000000
        m_fBlendSpeed=0.3000000
        m_fWalkInterpolateSpeed=2.0000000
        m_fBlendToNotMovingLength=0.0000000
        m_vOldLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

struct sObjective
{
    var Actor.EObjectiveType m_eObjectiveType;
    var name m_nNameId;
    var float m_fMaxDistanceFromStartLocation;
    var array<Actor> m_aActors;
    var bool m_bIsMobile;
    var bool m_bCanBeLeader;
    var bool m_bFollowInFormation;
    var float m_fFormationDistance;
    var float m_fFormationAngle;
    var float m_fAttackTimeDelay;

    structdefaultproperties
    {
        m_eObjectiveType=2
        m_nNameId="None"
        m_fMaxDistanceFromStartLocation=0.0000000
        m_aActors=none
        m_bIsMobile=false
        m_bCanBeLeader=false
        m_bFollowInFormation=false
        m_fFormationDistance=0.0000000
        m_fFormationAngle=0.0000000
        m_fAttackTimeDelay=1.0000000
    }
};

struct EnemyInformation
{
    var R6Pawn m_EnemyPawn;
    var Actor m_pBlockingActor;
    var bool m_bCurrentlyVisible;
    var bool m_bAlreadySpotted;
    var bool m_bIsIndirectlyVisible;
    var bool m_bIsVisibleFromWeapon;
    var bool m_bIsIndirectlyVisibleFromWeapon;
    var bool m_bIsLost;
    var bool m_bIsFirstTimeAwareAndSeenByHuman;
    var Actor.AIEventType m_eLastVisualEvent;
    var int m_iLastBoneSeen;
    var Vector m_vLastKnownEyeDirection;
    var Vector m_vLastKnownLocation;
    var Vector m_vLastIntuitionLocation;
    var Vector m_vLastIndirectLocation;
    var Vector m_vLastKnownDirection;
    var int m_iLastKnownTriangleIdx;
    var int m_iLastKnownZoneIdx;
    var float m_fIntuitionTimer;
    var float m_fLastTimeSeen;
    var float m_fLastTimeHeard;
    var float m_fLastTimeReceivedDamageFrom;
    var float m_fLastTimeEnemyFired;
    var float m_fLastTimeGaveDamageTo;
    var float m_fSustainedVisionTime;
    var int m_iThreat;
    var ENavMesh m_pLastKnownNavMesh;
    var Actor m_pThreatObject;

    structdefaultproperties
    {
        m_EnemyPawn=none
        m_pBlockingActor=none
        m_bCurrentlyVisible=false
        m_bAlreadySpotted=false
        m_bIsIndirectlyVisible=false
        m_bIsVisibleFromWeapon=false
        m_bIsIndirectlyVisibleFromWeapon=false
        m_bIsLost=false
        m_bIsFirstTimeAwareAndSeenByHuman=false
        m_eLastVisualEvent=0
        m_iLastBoneSeen=0
        m_vLastKnownEyeDirection=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_vLastKnownLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_vLastIntuitionLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_vLastIndirectLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_vLastKnownDirection=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_iLastKnownTriangleIdx=0
        m_iLastKnownZoneIdx=0
        m_fIntuitionTimer=0.0000000
        m_fLastTimeSeen=0.0000000
        m_fLastTimeHeard=0.0000000
        m_fLastTimeReceivedDamageFrom=0.0000000
        m_fLastTimeEnemyFired=0.0000000
        m_fLastTimeGaveDamageTo=0.0000000
        m_fSustainedVisionTime=0.0000000
        m_iThreat=0
        m_pLastKnownNavMesh=none
        m_pThreatObject=none
    }
};

struct STakeCoverTransition
{
    var int m_iTransitionIndex;
    var float m_fDuration;
    var float m_fCurrentTime;
    var int m_iStartTransitionTick;
    var bool m_bUseAlternatePath;
    var bool m_bPlayReverseTransition;
    var bool m_bAnimatedTransition;
    var int m_iStandStartSecondPartTick;
    var bool m_bStandBreakOccured;
    var float m_fStandSecondPartStartTime;
    var int m_iCrouchStartSecondPartTick;
    var bool m_bCrouchBreakOccured;
    var float m_fCrouchSecondPartStartTime;
    var float m_fStandAnimRate;
    var float m_fCrouchAnimRate;
    var float m_fStandAnimDuration;
    var float m_fCrouchAnimDuration;
    var float m_fStandRealDuration;
    var float m_fCrouchRealDuration;
    var float m_fStandTransitionLength;
    var float m_fStandBreakTransitionLength;
    var float m_fStandReverseTransitionLength;
    var float m_fStandAlternateTransitionLength;
    var float m_fCrouchTransitionLength;
    var float m_fCrouchBreakTransitionLength;
    var float m_fCrouchReverseTransitionLength;
    var float m_fCrouchAlternateTransitionLength;
    var R6EngineEnums.ETakeCover m_eFromAction;
    var R6EngineEnums.ETakeCover m_eToAction;
    var R6EngineEnums.ETakeCoverAngle m_eFromAngle;
    var R6EngineEnums.ETakeCoverAngle m_eToAngle;
    var R6EngineEnums.ETakeCoverMode m_eTakeCoverMode;

    structdefaultproperties
    {
        m_iTransitionIndex=0
        m_fDuration=0.0000000
        m_fCurrentTime=0.0000000
        m_iStartTransitionTick=0
        m_bUseAlternatePath=false
        m_bPlayReverseTransition=false
        m_bAnimatedTransition=false
        m_iStandStartSecondPartTick=0
        m_bStandBreakOccured=false
        m_fStandSecondPartStartTime=0.0000000
        m_iCrouchStartSecondPartTick=0
        m_bCrouchBreakOccured=false
        m_fCrouchSecondPartStartTime=0.0000000
        m_fStandAnimRate=0.0000000
        m_fCrouchAnimRate=0.0000000
        m_fStandAnimDuration=0.0000000
        m_fCrouchAnimDuration=0.0000000
        m_fStandRealDuration=0.0000000
        m_fCrouchRealDuration=0.0000000
        m_fStandTransitionLength=0.0000000
        m_fStandBreakTransitionLength=0.0000000
        m_fStandReverseTransitionLength=0.0000000
        m_fStandAlternateTransitionLength=0.0000000
        m_fCrouchTransitionLength=0.0000000
        m_fCrouchBreakTransitionLength=0.0000000
        m_fCrouchReverseTransitionLength=0.0000000
        m_fCrouchAlternateTransitionLength=0.0000000
        m_eFromAction=0
        m_eToAction=0
        m_eFromAngle=0
        m_eToAngle=0
        m_eTakeCoverMode=0
    }
};

struct SFacialExpressionInfo
{
    var name m_FacialExpression;
    var float m_fBlendInTime;
    var float m_fBlendOutTime;
    var float m_fDuration;
    var float m_fBlend;
    var float m_fTimeLeft;
    var bool m_bInUse;
    var bool m_bOverrideDefault;

    structdefaultproperties
    {
        m_FacialExpression="None"
        m_fBlendInTime=0.0000000
        m_fBlendOutTime=0.0000000
        m_fDuration=0.0000000
        m_fBlend=0.0000000
        m_fTimeLeft=0.0000000
        m_bInUse=false
        m_bOverrideDefault=false
    }
};

struct SGestureInfo
{
    var name m_strAnim;
    var R6GameEnums.EEventRelativeLocation m_eDir;
    var float m_fLength;
    var R6EngineEnums.EAIGestureId m_eId;
    var bool m_bIkDisabled;
    var bool m_bHead;

    structdefaultproperties
    {
        m_strAnim="None"
        m_eDir=0
        m_fLength=0.0000000
        m_eId=0
        m_bIkDisabled=false
        m_bHead=false
    }
};

struct SPawnNetRelevantStatus
{
    var bool m_bLastRelevantStatus;
    var byte m_u8LastRelevantLineCheckID;
    var float m_fLastRelevantTime;
    var byte m_u8RelevantLineCheckID;

    structdefaultproperties
    {
        m_bLastRelevantStatus=false
        m_u8LastRelevantLineCheckID=0
        m_fLastRelevantTime=0.0000000
        m_u8RelevantLineCheckID=0
    }
};

var STcMovementAnimInfo m_TcMoveAnimInfo;
var() bool m_bLeaderPawn;
var bool bBackward;
var private const bool m_bIsHeadFocusDisabled;
var bool bRenderDebug;
var bool m_bRenderFocus;
var bool m_bRenderFOV;
var bool m_bRenderGunFOV;
var bool m_bRenderDialogs;
var bool m_bRenderCollisionBox;
var bool m_bRenderPathFollowing;
var bool m_bRenderPFTraceColor;
var bool m_bRenderBulletTrace;
var bool m_bForceNoAnim;
var bool m_bTickAnimOptActive;
var bool m_bRenderRotation;
var bool m_bRenderNeutralPerception;
var bool m_bLDDebug;
var bool m_bRenderGrenade;
var bool m_bReactionDisabledIk;
var bool m_bUseWeaponIK;
var bool m_bUsingGoggles;
var bool m_bForceHelmetUpdate;
var bool m_bPickingWeapon;
var bool m_bThrowingWeapon;
var bool m_bOnRopeStop;
var bool m_bSettingRope;
var bool m_bBlendOutRopeTree;
var bool m_bRopeAiming;
var bool m_bRopeSpin;
var bool m_bRopeInAimTransition;
var bool m_bWantsToBreach;
var bool m_bPlayingIdleAnim;
var bool m_bNoRopeSockets;
var bool m_bPlayingInteractAnim;
var bool m_bRepResetWeaponAnim;
var bool m_bRepResetGadgetAnim;
var bool m_bRepResetReactionAnim;
var bool m_bRepResetJumpAnim;
var bool m_bRepResetHandSignalAnim;
var bool m_bRepResetInteractAnim;
var bool m_bUseAnimPosture;
var bool m_bFastRope;
var bool m_bRopeLeftSide;
var bool m_bRappelToFastRope;
var bool m_bRopeZoom;
var bool m_bForceAIFastRopeYaw;
var bool m_bTcSideLeft;
var bool m_bTcNearHandle;
var bool m_bUpdatePlaceLHand;
var bool m_bUpdatePlaceRHand;
var bool m_bPlaceLHand;
var bool m_bPlaceRHand;
var bool m_bIsDoorAssaultSpecialCase;
var bool m_bAIPeekOnCover;
var bool m_bPlayFullIncapAnim;
var bool m_bShowDeadInRadar;
var bool m_bStartSlide;
var bool m_bSlidingLadder;
var bool m_bLeftHandUp;
var bool m_bDelayInvSpawn;
var bool m_bWaitInventoryMgr;
var bool m_bTcShield;
var bool m_bPreviousWasShield;
var bool m_bPreviousWasPistol;
var bool m_bSwitchOnInteraction;
var bool m_bClientSwitchingToShield;
var bool m_bClientSwitchingWeapon;
var() bool m_bDisableSenses;
var bool m_bIsDeactivated;
var bool m_bIsOkToShootInEntryAnim;
var bool m_bIsInIslandZone;
var bool m_bIsCurrentEnemyLocked;
var bool m_bLockRootBone;
var bool m_bDisableTPAim;
var bool m_bDisableFPMovement;
var bool m_bCanUpdateBodyRotation;
var bool m_bScriptEnableBodyRotation;
var bool m_bIsPeekingUpExposed;
var const bool m_bIsOnLeftCorner;
var const bool m_bIsOnRightCorner;
var const bool m_bBlendOTSCameraSwitchSide;
var const bool m_bBlendBlindFireUpSwitchSide;
var const bool m_bSwitchingCoverSeg;
var const bool m_bAdjustingOnCoverSeg;
var bool m_bTakeCoverDisableScope;
var bool m_bHideBecauseInCameraFOV;
var const bool m_bHighWallLeft;
var const bool m_bHighWallRight;
var const bool m_bIsEnteringCover;
var const bool m_bIsPlayingEnteringCover;
var const bool m_bPlayReverseEntering;
var const bool m_bEnterBlendToNewTree;
var const bool m_bIsExitingCover;
var const bool m_bIsPlayingExitingCover;
var const bool m_bPlayReverseExiting;
var const bool m_bExitBlendToNewTree;
var const bool m_bOffsetRootWhileEnterExit;
var bool m_bPlayingHandSignal;
var bool m_bCanCommunicateFiringLine;
var bool m_bCanDoIdleChat;
var bool m_bCommunicationFromAIDisabled;
var bool m_bDidRecruitmentDialog;
var bool m_bIsScanning;
var bool m_bHasScriptedWalkAnim;
var bool m_bDoUpdateScriptedWalkAnim;
var bool m_bPauseScriptedAnim;
var bool m_bUnpauseScriptedAnim;
var bool m_bIsInScriptedAnim;
var bool m_bRemoveScriptedAnim;
var bool m_bResetBlendBySpeedAnims;
var bool m_bIsKnockedDown;
var bool m_bFacialAnimResetPos;
var bool m_bLoopFacialAnim;
var bool m_bDiedByHeadShot;
var bool m_bPreventRagdoll;
var bool m_bInitRagdoll;
var bool m_bInstantHelicopterAnimBlending;
var const bool m_bGunUp;
var const bool m_bGunInsideWall;
var bool m_bWantsGunUp;
var bool m_bForceGunUp;
var bool m_bForceLowReadyAim;
var bool m_bIdleAIActive;
var bool m_bIdleActionEffectDone;
var bool m_bIdleRoleEffectDone;
var bool m_bHeadMovementOutOfRange;
var bool m_bIsStartingMove;
var bool m_bIsMotionless;
var R6XTOSystem m_XTOS;
var R6GameEnums.ERainbowEntryLocation m_eRainbowEntryLocation;
var R6Pawn.EBreachTransitionType m_eBreachTransition;
var byte m_u8BarrelIKDisabled;
var R6Pawn.EHelmetWantsToStatus m_eHelmetWantsToStatus;
var R6GameEnums.EPawnRopeStatus m_eRopeStatus;
var R6GameEnums.ENavObjAttachment m_eNavObAttachingPos;
var R6GameEnums.EEventRelativeLocation m_eIncapaciteDir;
var R6GameEnums.EIncapaciteState m_eIncapaciteState;
var R6EngineEnums.EHealthStates m_eHealthState;
var R6GameEnums.EThrowType m_eThrowType;
var R6GameEnums.EPawnInteractionType m_ePawnInteraction;
var R6EngineEnums.EAIPeekCoverStatus m_eAIPeekCoverStatus;
var R6Pawn.ELadderStatus m_eLadderStatus;
var() R6GameEnums.EMentalState m_eMentalState;
var() R6GameEnums.EDetectionAction m_eDetectionAction;
var() R6Pawn.EAlliance m_eAlliance;
var R6GameEnums.EPawnAlertStatus m_eAlertStatus;
var(AI) R6Pawn.R6AIControllerState InitialAIState;
var const R6EngineEnums.ETakeCover m_eTakeCoverAction;
var const R6EngineEnums.ETakeCover m_eWantsToTakeCoverAction;
var const R6EngineEnums.ETakeCover m_eFromTakeCoverAction;
var const R6EngineEnums.ETakeCover m_eDesiredTakeCoverAction;
var const R6EngineEnums.ETakeCover m_eRepTakeCoverAction;
var R6EngineEnums.EActionSide m_eBlindFireSide;
var const R6EngineEnums.EActionSide m_eTakeCoverPeekPushSide;
var const R6EngineEnums.ETakeCoverAngle m_eTakeCoverAngles[3];
var const R6EngineEnums.ETakeCoverAngle m_eWantsToTakeCoverAngles[3];
var const R6EngineEnums.ETakeCoverAngle m_eFromTakeCoverAngles[3];
var const R6EngineEnums.ETakeCoverAngle m_eDesiredTakeCoverAngles[3];
var const R6EngineEnums.ETakeCoverAngle m_eRepTakeCoverAngles[3];
var const R6EngineEnums.EActionSide m_eOTSCameraSide;
var const R6EngineEnums.EActionSide m_ePreTransitionOTSCameraSide;
var const R6EngineEnums.EActionSide m_eBlindFireUpSide;
var R6EngineEnums.EActionSide m_eTakeCoverMoveDir;
var const byte m_u8CoverSegExtraInfo;
var const R6EngineEnums.EActionSide m_eEnterSnapOnCornerSide;
var const R6GameEnums.EEnterTakeCover m_eEnteringType;
var const R6GameEnums.EExitTakeCover m_eExitingType;
var Actor.EPhysics m_eDefaultPhysics;
var byte m_UpdateScriptedAnim;
var R6GameEnums.EHelicopterSittingPos m_eHelicopterSeat;
var R6GameEnums.EHelicopterAction m_eCurrentHelicopterAction;
var R6Pawn.EMentalStatesIdles m_eCurrentMentalStateIdle;
var R6Pawn.EMentalStatesTransitions m_eCurrentMentalStateTransition;
var R6GameEnums.EPlayerClass m_ePlayerClass;
var const R6EngineEnums.EMoodType m_eOriginalMoodType;
var const R6EngineEnums.EIdleRole m_eIdleRole;
var R6EngineEnums.EIdleAction m_eIdleAction;
var array<R6EngineEnums.ECommunicationTeamMessageType> m_aOrdersQueue;
var float EPawn_PerfTimer;
var name Event;
var ObjectOfInterest m_FocusInterest;
var Actor m_pHeadFocusForZombie;
var Vector m_vFocusInterestReplication;
var float m_fNextMoveSound;
var native const Pointer SceneViewState;
var float m_fMovementRatio;
var Actor m_pOnClimb;
var R6InteractiveWindow m_pOnWindow;
var float m_fLastGlassBreakTest;
var SPawnHealthReactionInfo m_sReactionInfo;
var float m_fClimbHeight;
var export editinline AudioComponent m_pRopeKickDownPlay;
var export editinline AudioComponent m_pRopeKickDownStop;
var R6PickupableActor m_pWeaponToPickUp;
var R6InteractiveRope m_pOnRope;
var float m_fRopeSpeed;
var Vector m_vRopeDescendPos;
var int m_iResetJumpAnim;
var int m_iResetHandSignal;
var int m_iResetGadgetAnim;
var int m_iResetReactionAnim;
var int m_iResetFireAnimation;
var int m_iResetInteractAnimation;
var float m_fRopeWindowBreachHeight;
var float m_fFastRopeNoiseOffset;
var int m_iForcedAIFastRopeYaw;
var float m_fRecoveryTime;
var float m_fReplicatedRecoveryTime;
var name m_strIncapacitedAnimPlayed;
var float m_fIncapacitatedAnimPosition;
var int m_iIncapacitatedDamage;
var R6Gadget m_pUsedGadget;
var float m_fGadgetAnimTimeLength;
var float m_fUseGadgetCounter;
var Vector m_vLHandPos;
var Vector m_vRHandPos;
var Rotator m_rLHandRot;
var Rotator m_rRHandRot;
var Vector m_vLFeetPos;
var Vector m_vRFeetPos;
var Rotator m_rLFeetRot;
var Rotator m_rRFeetRot;
var R6InteractiveActor m_pInteracting;
var R6Pawn m_pIncapacitatedPawnInteraction;
var float m_fInteractCounter;
var float m_fInteractLength;
var float m_fIncapAnimCounter;
var float m_fIncapAnimLength;
var int m_iEnableRootRotationTick;
var float m_fAnimToDestination;
var R6InteractiveLadder m_pOnLadder;
var float m_fEnterHeight;
var R6Turret m_operatedTurret;
var transient bool m_bEnteringTurret;
var transient bool m_bExitingTurret;
var transient bool m_bEnteringTurretTC;
var transient bool m_bExitingTurretTC;
var transient bool m_bTakingCoverOnTurret;
var transient bool m_bLastHitExplosive;
var transient float m_fEnterExitTurretTime;
var transient float m_fEnterExitTurretTCTime;
var R6ObstacleAllowance m_pObstacleAllowance;
var R6InventoryManager m_R6InvManager;
var() editinline R6EquipmentTemplate m_EquipmentTemplate;
var() editinline R6AITemplate m_AITemplate;
var R6Weapon m_R6Weapon;
var R6WeaponAttachmentsReplicator m_WeaponAttachmentsReplicator;
var Vector m_vLastHandLocation;
var Vector m_vHandVelocity;
var Rotator m_rLastHandRotation;
var Rotator m_rHandRotationRate;
var string m_strPlayerEquipmentTemplate;
var R6SoundReplicationInfo m_SoundRepInfo;
var R6AIController m_pAI;
var R6ActionSpot m_pActionSpot;
var R6SpawnPoint m_pSpawnPoint;
var array<R6WakeInfo> m_ZombieWakeEvents;
var ENavMesh m_pOnNavMesh;
var ENavMesh m_pPendingNavMesh;
var AnimNode pPendingAnimTree;
var sObjective m_sDefaultObjective;
var array<EnemyInformation> EnemyInfo;
var int m_iCurrentEnemy;
var R6Pawn m_pLockedPawn;
var array<EnemyInformation> m_aNeutralInfo;
var array<R6Pawn> m_aPawnToNotifyOfDeath;
var R6TeamManager m_pTeamManager;
var Vector m_vEyeLocation;
var Vector m_vEyeDirection;
var Vector m_vSmoothLookAt;
var int m_iSmoothLookAtTick;
var float m_fVisibilityModifier;
var editinline SDefend DefendInfo;
var Rotator m_rAimRotation;
var Rotator m_rDesiredAimRotation;
var int m_iOldDesiredAimYaw[3];
var Rotator m_rPreSkelControlRootRotation;
var Matrix m_mLockBoneRotation;
var Rotator m_rTurnAnimTargetRotation;
var float m_fTurnAngleToPlay;
var R6CoverManager m_CoverManager;
var const float m_fLeftCornerDist;
var const float m_fRightCornerDist;
var const STakeCoverTransition m_TakeCoverTransition;
var const int m_iCoverSegInfo;
var const Vector m_vCoverSegLeftPoint;
var const Vector m_vCoverSegRightPoint;
var const Vector m_vStandLeftCoverPoint;
var const Vector m_vStandRightCoverPoint;
var const Vector m_vCrouchLeftCoverPoint;
var const Vector m_vCrouchRightCoverPoint;
var const float m_fCoverSegHeight;
var const Vector m_vNearestLocOnCoverSeg;
var const Vector m_vCoverSegFacingDir;
var const Rotator m_rCoverSegFacingDir;
var const float m_fEnterTransitionTimer;
var const float m_fEnterTransitionLength;
var const int m_iStartEnterTransitionTick;
var const float m_fEnterBlendTimeToNewTree;
var const float m_fExitTransitionTimer;
var const float m_fExitTransitionLength;
var const int m_iStartExitTransitionTick;
var const float m_fExitBlendTimeToNewTree;
var const float m_fForwardDistanceFromCover;
var const float m_fSideDistanceFromCover;
var const Vector m_vRootOffsetWhenExiting;
var const float m_fEnterCoverVelocity;
var const float m_fEnterCoverMoveCylinderTime;
var int m_iForceComponentsVisibility;
var float m_fTimeLastOrder;
var float m_fTimerCountHandSignal;
var float m_fTimeOfDeath;
var int m_iNumberOfBulletFiredAtNothing;
var float m_fStuckTimer;
var Vector m_vStuckPosition;
var R6Tactic m_pStuckTactic;
var float m_fMovementRatio_Backup;
var Vector m_vVelocity_Backup;
var Vector m_vAcceleration_Backup;
var float m_fGroundSpeed_Backup;
var Vector m_vVelocity_Anim;
var Vector m_vAcceleration_Anim;
var Vector m_vLastLocation_Anim;
var name m_SpecialAnimName;
var float m_fScriptedWalkSpeed;
var name m_AnimForward;
var name m_AnimStrafeLeft;
var name m_AnimStrafeRight;
var MatineeActor m_ActiveMatineeActors[2];
var name m_MatineeGroupsAttached[2];
var int m_iCurrentBodyAnim;
var R6ScriptedAnimInfo m_ScriptedAnim;
var R6ScriptedAnimInfo m_RepScriptedAnimInfo;
var name m_FacialAnim;
var name m_AnimThatTriggeredFacial;
var float m_FacialAnimStartOffset;
var float m_FacialAnimCurrentPos;
var SoundCue m_CurrentDialogVoiceLine;
var SeqAct_R6PawnTalk m_CurrentDialogAction;
var transient SFacialExpressionInfo m_FacialExpression1;
var transient SFacialExpressionInfo m_FacialExpression2;
var transient SFacialExpressionInfo m_FacialExpression3;
var transient name m_LastHitBoneName;
var transient Vector m_vLastHitMomentum;
var transient Vector m_vLastHitExplosiveOrigin;
var transient float m_fLastHitExplosiveRadius;
var transient float m_fLasthitExplosiveStrength;
var transient Vector m_vDeathVelocity;
var class<DamageType> m_LastDamage;
var Controller m_pLastKiller;
var Vector m_vLastKillerPos;
var transient float m_fRagdollLifetTime;
var transient float m_fRagdollToAnimBlendTime;
var name m_ReactionBone;
var float m_fReactionStartTime;
var Vector m_vReactionAxis;
var float m_fLastKActorDamage;
var R6Helicopter m_InHelicopter;
var float m_fHelicopterActionTime;
var int m_iHelicopterEntryIndex;
var string m_helicopterEntryAnims[4];
var string m_helicopterEntryAlone;
var array<string> m_helicopterSittingAnims;
var string m_szHelicopterSittingToFastRopingAnim;
var int m_iResetHelicopterAnim;
var array<R6Pawn> m_TraceExclusionList;
var transient Vector m_vFPMeshPostureOffset;
var transient Rotator m_rFPMeshPostureOffset;
var float m_fFallingFromHeight;
var() StaticMesh m_pouchMesh;
var export editinline StaticMeshComponent m_pouchComponent;
var const float m_fWeaponStanceTransitionTimer;
var const float m_fWeaponStanceTransitionLength;
var float m_fWeaponStanceCheck;
var float m_fDelayGunUp;
var float m_fBreathingSpeed;
var float m_fBreathMovementFactor;
var() GestureSpeed m_sGestureSpeed;
var() PostureType m_sPostureType;
var R6Pawn m_pIdleTarget;
var Vector m_vInFrontOfBody;
var float m_fHeadConeAngle;
var float m_fLastMove;
var R6VoiceBank m_pVoiceBank;
var float m_fCrouchWeight;
var float m_fStandWeight;
var array<SGestureInfo> m_aGestureInfo;
var int m_iActiveGesture;
var transient float m_fHitElapsedTime;
var transient float m_fHitCount;
var transient Vector m_vHitCummulated;
var R6RadarPawnRepInfo m_RadarPawnRepInfo;
var Vector m_vLastReplicatedPos;
var float m_fRemotePawnAdjustPosTime;
var native const transient map{VOID,VOID} m_CachePawnNetRelevantStatus;
var float m_fTornOffTime;

replication
{
    // Pos:0x000
    if(((!bSkipActorPropertyReplication || bNetInitial) && bReplicateMovement) && ((int(RemoteRole) == int(ROLE_AutonomousProxy)) && bNetInitial) || ((int(RemoteRole) == int(ROLE_SimulatedProxy)) && bNetInitial || bUpdateSimulatedPosition) && ((Base == none) || Base.bWorldGeometry) || int(Physics) == int(13))
        m_rAimRotation;

    // Pos:0x096
    if(int(Role) == int(ROLE_Authority))
        m_ActiveMatineeActors, m_AnimThatTriggeredFacial, 
        m_FacialAnim, m_InHelicopter, 
        m_MatineeGroupsAttached, m_SoundRepInfo, 
        m_UpdateScriptedAnim, m_bAdjustingOnCoverSeg, 
        m_bEnteringTurret, m_bEnteringTurretTC, 
        m_bExitingTurret, m_bExitingTurretTC, 
        m_bIsKnockedDown, m_bIsOnLeftCorner, 
        m_bIsOnRightCorner, m_bPickingWeapon, 
        m_bPlayingInteractAnim, m_bPreviousWasPistol, 
        m_bPreviousWasShield, m_bRemoveScriptedAnim, 
        m_bRepResetGadgetAnim, m_bRepResetHandSignalAnim, 
        m_bRepResetInteractAnim, m_bRepResetReactionAnim, 
        m_bRepResetWeaponAnim, m_bSwitchingCoverSeg, 
        m_bTakingCoverOnTurret, m_bTcNearHandle, 
        m_bTcSideLeft, m_bThrowingWeapon, 
        m_eBlindFireSide, m_eHealthState, 
        m_ePawnInteraction, m_eTakeCoverMoveDir, 
        m_fHitCount, m_fInteractLength, 
        m_fReplicatedRecoveryTime, m_fTurnAngleToPlay, 
        m_operatedTurret, m_pInteracting, 
        m_pUsedGadget, m_pWeaponToPickUp, 
        m_sReactionInfo, m_vFocusInterestReplication, 
        m_vHitCummulated;

    // Pos:0x0A3
    if((int(Role) == int(ROLE_Authority)) && m_InHelicopter != none)
        m_eHelicopterSeat;

    // Pos:0x0BD
    if(((int(Role) == int(ROLE_Authority)) && m_pOnLadder != none) && !bNetOwner)
        m_bSlidingLadder, m_bStartSlide, 
        m_fEnterHeight;

    // Pos:0x0E4
    if(((int(Role) == int(ROLE_Authority)) && m_pOnClimb != none) && !bNetOwner)
        m_fClimbHeight;

    // Pos:0x10B
    if(((int(Role) == int(ROLE_Authority)) && m_pOnRope != none) && !bNetOwner)
        m_bFastRope, m_bOnRopeStop, 
        m_bRepResetJumpAnim, m_bRopeAiming, 
        m_bRopeInAimTransition, m_bRopeLeftSide, 
        m_bRopeSpin, m_bRopeZoom, 
        m_fRopeSpeed;

    // Pos:0x132
    if((int(Role) == int(ROLE_Authority)) && m_pUsedGadget != none)
        m_fGadgetAnimTimeLength;

    // Pos:0x14C
    if((int(Role) == int(ROLE_Authority)) && int(RemoteRole) != int(ROLE_AutonomousProxy))
        m_RepScriptedAnimInfo;

    // Pos:0x16B
    if(((!bNetOwner && bNetInitial) && int(Role) == int(ROLE_Authority)) && int(m_eTakeCoverAction) != int(0))
        m_fCoverSegHeight, m_iCoverSegInfo, 
        m_u8CoverSegExtraInfo, m_vCoverSegLeftPoint, 
        m_vCoverSegRightPoint;

    // Pos:0x1A2
    if((bNetOwner && int(Role) == int(ROLE_Authority)) && int(m_eTakeCoverAction) != int(0))
        m_bHighWallLeft, m_bHighWallRight;

    // Pos:0x1CC
    if(!bNetOwner && int(Role) == int(ROLE_Authority))
        m_WeaponAttachmentsReplicator, m_bForceGunUp, 
        m_bIsPeekingUpExposed, m_bSettingRope, 
        m_bSwitchOnInteraction, m_bTcShield, 
        m_bWantsGunUp, m_eLadderStatus, 
        m_eNavObAttachingPos, m_eRepTakeCoverAction, 
        m_eRepTakeCoverAngles, m_eRopeStatus, 
        m_pOnClimb, m_pOnLadder, 
        m_pOnRope, m_pOnWindow;
}

// Export UR6Pawn::execDropCurrentWeapon(FFrame&, void* const)
native function Actor DropCurrentWeapon();

// Export UR6Pawn::execSelectVisionMode(FFrame&, void* const)
native function SelectVisionMode(R6EngineEnums.EVisionMode eMode);

// Export UR6Pawn::execEnableVisionMode(FFrame&, void* const)
native function EnableVisionMode(bool bEnable, R6EngineEnums.EVisionMode eMode);

// Export UR6Pawn::execSetupUpdateVisionModeTimer(FFrame&, void* const)
native function SetupUpdateVisionModeTimer();

// Export UR6Pawn::execGetVisionModeTimerLength(FFrame&, void* const)
native function float GetVisionModeTimerLength();

// Export UR6Pawn::execUpdateVisionMode(FFrame&, void* const)
native function UpdateVisionMode();

// Export UR6Pawn::execIsBusyWithHelmet(FFrame&, void* const)
native function bool IsBusyWithHelmet();

// Export UR6Pawn::execCanChangeVisionMode(FFrame&, void* const)
native function bool CanChangeVisionMode();

// Export UR6Pawn::execInstantVisionModeChange(FFrame&, void* const)
native function InstantVisionModeChange(R6EngineEnums.EVisionMode EVisionMode);

// Export UR6Pawn::execIsReadyToFire(FFrame&, void* const)
native final function bool IsReadyToFire();

// Export UR6Pawn::execLockYawRotation(FFrame&, void* const)
native final function LockYawRotation(bool bLock);

// Export UR6Pawn::execStartReaction(FFrame&, void* const)
native final function StartReaction(SPawnHealthReactionInfo Reaction);

// Export UR6Pawn::execEndReaction(FFrame&, void* const)
native final function EndReaction();

// Export UR6Pawn::execEnableBarrelIK(FFrame&, void* const)
native final function EnableBarrelIK();

// Export UR6Pawn::execDisableBarrelIK(FFrame&, void* const)
native final function DisableBarrelIK();

// Export UR6Pawn::execUpdateWeaponBarrelIK(FFrame&, void* const)
native final function UpdateWeaponBarrelIK(R6Weapon pWeapon);

// Export UR6Pawn::execPlaceLHand(FFrame&, void* const)
native final function PlaceLHand(bool bValue, optional Vector vOffset, optional bool bUpdate);

// Export UR6Pawn::execPlaceRHand(FFrame&, void* const)
native final function PlaceRHand(bool bValue, optional Vector vOffset, optional bool bUpdate);

// Export UR6Pawn::execEnableLockBoneControl(FFrame&, void* const)
native function EnableLockBoneControl();

// Export UR6Pawn::execCheckAlliance(FFrame&, void* const)
native final function R6Pawn.EAllianceStatus CheckAlliance(R6Pawn TargetPawn);

// Export UR6Pawn::execGetHeadDirection(FFrame&, void* const)
native final function Rotator GetHeadDirection();

// Export UR6Pawn::execGetOverHeadLocation(FFrame&, void* const)
native final function GetOverHeadLocation(out Vector vOutLocation);

// Export UR6Pawn::execInitRagdoll(FFrame&, void* const)
native function bool InitRagdoll();

// Export UR6Pawn::execTermRagdoll(FFrame&, void* const)
native function bool TermRagdoll();

// Export UR6Pawn::execGetAllBoneAutoAimInfluences(FFrame&, void* const)
native final function GetAllBoneAutoAimInfluences(out array<SAutoAimInfluence> autoAimInfluences);

// Export UR6Pawn::execEnterTakeCover(FFrame&, void* const)
native final function bool EnterTakeCover(R6GameEnums.EEnterTakeCover eEnteringType);

// Export UR6Pawn::execExitTakeCover(FFrame&, void* const)
native final function bool ExitTakeCover(R6GameEnums.EExitTakeCover eExitingType);

// Export UR6Pawn::execIsInTakeCoverReady(FFrame&, void* const)
native final function bool IsInTakeCoverReady();

// Export UR6Pawn::execIsInTakeCoverAndNotExited(FFrame&, void* const)
native final function bool IsInTakeCoverAndNotExited();

// Export UR6Pawn::execIsEnteringCover(FFrame&, void* const)
native final function bool IsEnteringCover();

// Export UR6Pawn::execIsPlayingEnteringCover(FFrame&, void* const)
native final function bool IsPlayingEnteringCover();

// Export UR6Pawn::execIsExitingCover(FFrame&, void* const)
native final function bool IsExitingCover();

// Export UR6Pawn::execIsPlayingExitingCover(FFrame&, void* const)
native final function bool IsPlayingExitingCover();

// Export UR6Pawn::execSetTakeCoverAction(FFrame&, void* const)
native final function bool SetTakeCoverAction(R6EngineEnums.ETakeCover eNewTakeCoverAction);

// Export UR6Pawn::execGetTakeCoverAction(FFrame&, void* const)
native final function R6EngineEnums.ETakeCover GetTakeCoverAction();

// Export UR6Pawn::execIsTakeCoverTransition(FFrame&, void* const)
native final function bool IsTakeCoverTransition(R6EngineEnums.ETakeCover eTakeCoverActionFrom, R6EngineEnums.ETakeCover eTakeCoverActionTo);

// Export UR6Pawn::execIsTakeCoverTransitionTo(FFrame&, void* const)
native final function bool IsTakeCoverTransitionTo(R6EngineEnums.ETakeCover eTakeCoverActionTo);

// Export UR6Pawn::execIsTakeCoverTransitionFrom(FFrame&, void* const)
native final function bool IsTakeCoverTransitionFrom(R6EngineEnums.ETakeCover eTakeCoverActionFrom);

// Export UR6Pawn::execIsCurrentTakeCoverAction(FFrame&, void* const)
native final function bool IsCurrentTakeCoverAction(R6EngineEnums.ETakeCover eTakeCoverAction);

// Export UR6Pawn::execIsTakeCoverAction(FFrame&, void* const)
native final function bool IsTakeCoverAction(R6EngineEnums.ETakeCover eTakeCoverAction);

// Export UR6Pawn::execTcIsPastTransitionToCorner(FFrame&, void* const)
native final function bool TcIsPastTransitionToCorner(R6EngineEnums.EActionSide ePawnActionSide);

// Export UR6Pawn::execTcIsMovingBackwards(FFrame&, void* const)
native final function bool TcIsMovingBackwards();

// Export UR6Pawn::execSetTakeCoverAngle(FFrame&, void* const)
native final function bool SetTakeCoverAngle(R6EngineEnums.ETakeCoverMode eAngleMode, R6EngineEnums.ETakeCoverAngle eNewAngle);

// Export UR6Pawn::execGetTakeCoverAngle(FFrame&, void* const)
native final function R6EngineEnums.ETakeCoverAngle GetTakeCoverAngle(R6EngineEnums.ETakeCoverMode ETakeCoverMode);

// Export UR6Pawn::execIsTakeCoverAngleTransition(FFrame&, void* const)
native final function bool IsTakeCoverAngleTransition(R6EngineEnums.ETakeCoverMode eAngleMode, R6EngineEnums.ETakeCoverAngle eAngleFrom, R6EngineEnums.ETakeCoverAngle eAngleTo);

// Export UR6Pawn::execIsTakeCoverAngleTransitionTo(FFrame&, void* const)
native final function bool IsTakeCoverAngleTransitionTo(R6EngineEnums.ETakeCoverMode eAngleMode, R6EngineEnums.ETakeCoverAngle eAngleTo);

// Export UR6Pawn::execIsTakeCoverAngleTransitionFrom(FFrame&, void* const)
native final function bool IsTakeCoverAngleTransitionFrom(R6EngineEnums.ETakeCoverMode eAngleMode, R6EngineEnums.ETakeCoverAngle eAngleFrom);

// Export UR6Pawn::execIsCurrentTakeCoverAngle(FFrame&, void* const)
native final function bool IsCurrentTakeCoverAngle(R6EngineEnums.ETakeCoverMode eAngleMode, R6EngineEnums.ETakeCoverAngle eAngle);

// Export UR6Pawn::execIsTakeCoverAngle(FFrame&, void* const)
native final function bool IsTakeCoverAngle(R6EngineEnums.ETakeCoverMode eAngleMode, R6EngineEnums.ETakeCoverAngle eAngle);

// Export UR6Pawn::execReduceDamageInTakeCover(FFrame&, void* const)
native final function ReduceDamageInTakeCover(out int iDamage);

// Export UR6Pawn::execGetThrowType(FFrame&, void* const)
native final function R6GameEnums.EThrowType GetThrowType();

// Export UR6Pawn::execKillSpeed(FFrame&, void* const)
native final function KillSpeed();

// Export UR6Pawn::execGetMovementSpeed(FFrame&, void* const)
native final function float GetMovementSpeed(Actor.ER6MoveFlags MoveFlags);

// Export UR6Pawn::execTakeLandingDamage(FFrame&, void* const)
native final function TakeLandingDamage();

// Export UR6Pawn::execEnablePerBoneCollision(FFrame&, void* const)
native final function EnablePerBoneCollision(bool bEnable);

// Export UR6Pawn::execTogglePerBoneCollision(FFrame&, void* const)
native final function TogglePerBoneCollision();

// Export UR6Pawn::execHasSpaceToClimbLadder(FFrame&, void* const)
native final function bool HasSpaceToClimbLadder(R6InteractiveLadder pLadder);

// Export UR6Pawn::execCanSlideOnLadder(FFrame&, void* const)
native final function bool CanSlideOnLadder();

// Export UR6Pawn::execphysOnRopeCheckWindowCollision(FFrame&, void* const)
native final function physOnRopeCheckWindowCollision();

// Export UR6Pawn::execCanShootOnRope(FFrame&, void* const)
native final function bool CanShootOnRope(optional bool bUseRotationParam, optional Rotator rRotationParam);

// Export UR6Pawn::execCanShootEnemyOnRope(FFrame&, void* const)
native final function bool CanShootEnemyOnRope(optional Actor pForcedEnemy);

// Export UR6Pawn::execCanReloadOnRope(FFrame&, void* const)
native final function bool CanReloadOnRope();

// Export UR6Pawn::execCanDoPendingJump(FFrame&, void* const)
native final function bool CanDoPendingJump();

// Export UR6Pawn::execIsRopeKickDown(FFrame&, void* const)
native final function bool IsRopeKickDown();

// Export UR6Pawn::execSetSpecialAnimation(FFrame&, void* const)
native final function SetSpecialAnimation(R6AnimContainerBase SpecialAnim);

// Export UR6Pawn::execSetSpecialAnimationName(FFrame&, void* const)
native final function SetSpecialAnimationName(name SpecialAnimName);

// Export UR6Pawn::execSetScriptedAnim(FFrame&, void* const)
native final function SetScriptedAnim(out R6ScriptedAnimInfo AnimInfo);

// Export UR6Pawn::execRemoveScriptedAnim(FFrame&, void* const)
native final function RemoveScriptedAnim(bool bFacialAnim, name LastAnimPlayed);

// Export UR6Pawn::execSetPawnInScriptedAnim(FFrame&, void* const)
native final function SetPawnInScriptedAnim(bool bSet);

// Export UR6Pawn::execPauseScriptedAnim(FFrame&, void* const)
native final function PauseScriptedAnim(bool bPaused, name AnimToPause);

// Export UR6Pawn::execEnableFocusUpdatesBodyRotation(FFrame&, void* const)
native final function EnableFocusUpdatesBodyRotation(bool bEnable);

// Export UR6Pawn::execSetFacialAnim(FFrame&, void* const)
native final function SetFacialAnim(name FacialAnimName, name AnimOwner, optional bool bLoop, optional float fStartOffset);

// Export UR6Pawn::execIsFacialAnimIsPlaying(FFrame&, void* const)
native final function bool IsFacialAnimIsPlaying();

// Export UR6Pawn::execSetHelicopter(FFrame&, void* const)
native final function SetHelicopter(R6Helicopter pChopper);

// Export UR6Pawn::execSetEnteringPosition(FFrame&, void* const)
native function SetEnteringPosition();

// Export UR6Pawn::execSetSittingPosition(FFrame&, void* const)
native function SetSittingPosition();

// Export UR6Pawn::execForceInsideHelicopter(FFrame&, void* const)
native final function ForceInsideHelicopter(R6Helicopter pChopper, R6GameEnums.EHelicopterSittingPos eSeat);

// Export UR6Pawn::execForceOutsideHelicopter(FFrame&, void* const)
native final function ForceOutsideHelicopter();

// Export UR6Pawn::execStartTeamHelicopterEntry(FFrame&, void* const)
native final function StartTeamHelicopterEntry(R6Helicopter pChopper);

// Export UR6Pawn::execStartEnteringHelicopter(FFrame&, void* const)
native final function StartEnteringHelicopter(R6Helicopter pChopper, optional bool bInstant);

// Export UR6Pawn::execEnteredHelicopter(FFrame&, void* const)
native final function EnteredHelicopter(optional bool bInstant);

// Export UR6Pawn::execCanStartExitingHelicopter(FFrame&, void* const)
native final function bool CanStartExitingHelicopter();

// Export UR6Pawn::execStartExitingHelicopter(FFrame&, void* const)
native final function StartExitingHelicopter(optional bool bInstant);

// Export UR6Pawn::execExitedHelicopter(FFrame&, void* const)
native final function ExitedHelicopter(optional bool bInstant);

// Export UR6Pawn::execGetHelicopterActionDuration(FFrame&, void* const)
native final function float GetHelicopterActionDuration(R6GameEnums.EHelicopterAction eAction);

// Export UR6Pawn::execSetHelicopterAction(FFrame&, void* const)
native function SetHelicopterAction(R6GameEnums.EHelicopterAction eNewAction, optional bool bInstantChange);

// Export UR6Pawn::execForceControllerViewRotation(FFrame&, void* const)
native final function ForceControllerViewRotation(Rotator rNewRotation);

// Export UR6Pawn::execCreateWeaponAttachmentsReplicator(FFrame&, void* const)
native function CreateWeaponAttachmentsReplicator();

// Export UR6Pawn::execCreateFirstPersonMesh(FFrame&, void* const)
native function CreateFirstPersonMesh();

// Export UR6Pawn::execGetBlockVolume(FFrame&, void* const)
native function R6BlockVolume GetBlockVolume();

// Export UR6Pawn::execCreateBlockVolume(FFrame&, void* const)
native function CreateBlockVolume();

// Export UR6Pawn::execDeleteBlockVolume(FFrame&, void* const)
native function DeleteBlockVolume();

// Export UR6Pawn::execSetupOnRope(FFrame&, void* const)
native final function SetupOnRope();

// Export UR6Pawn::execSetupOffRope(FFrame&, void* const)
native final function SetupOffRope();

// Export UR6Pawn::execCanRappelToFastRope(FFrame&, void* const)
native final function bool CanRappelToFastRope();

// Export UR6Pawn::execCanRopeJump(FFrame&, void* const)
native final function bool CanRopeJump();

// Export UR6Pawn::execCanRopeBreach(FFrame&, void* const)
native final function bool CanRopeBreach();

// Export UR6Pawn::execCanRopeScope(FFrame&, void* const)
native final function bool CanRopeScope();

// Export UR6Pawn::execCanRopeInvert(FFrame&, void* const)
native final function bool CanRopeInvert();

// Export UR6Pawn::execCanFastRopeBrake(FFrame&, void* const)
native final function bool CanFastRopeBrake();

// Export UR6Pawn::execIsHeightGoodForRopeBreach(FFrame&, void* const)
native final function bool IsHeightGoodForRopeBreach();

// Export UR6Pawn::execIsPlaceRappelToFastRope(FFrame&, void* const)
native final function bool IsPlaceRappelToFastRope();

// Export UR6Pawn::execAdjustOnRope(FFrame&, void* const)
native final function AdjustOnRope();

// Export UR6Pawn::execRopeJump(FFrame&, void* const)
native final function RopeJump();

// Export UR6Pawn::execRopeBreach(FFrame&, void* const)
native final function RopeBreach(R6InteractiveWindow pWindow);

// Export UR6Pawn::execInvertRope(FFrame&, void* const)
native final function InvertRope();

// Export UR6Pawn::execFastRopeBrake(FFrame&, void* const)
native final function FastRopeBrake();

// Export UR6Pawn::execClimbRope(FFrame&, void* const)
native final function ClimbRope(R6InteractiveRope pRope, bool bSettingNew);

// Export UR6Pawn::execRappelToFastRope(FFrame&, void* const)
native final function RappelToFastRope();

// Export UR6Pawn::execEndClimbRope(FFrame&, void* const)
native final function EndClimbRope(bool bEndWithTransition);

// Export UR6Pawn::execSetRopeStatus(FFrame&, void* const)
native final function SetRopeStatus(R6GameEnums.EPawnRopeStatus eStatus);

// Export UR6Pawn::execSetRopeSpeed(FFrame&, void* const)
native final function SetRopeSpeed(float fSpeed);

// Export UR6Pawn::execClimbR6Ladder(FFrame&, void* const)
native final function ClimbR6Ladder(R6InteractiveLadder pLadder);

// Export UR6Pawn::execEndClimbR6Ladder(FFrame&, void* const)
native final function EndClimbR6Ladder();

// Export UR6Pawn::execSetupOnLadder(FFrame&, void* const)
native final function SetupOnLadder();

// Export UR6Pawn::execSetupOffLadder(FFrame&, void* const)
native final function SetupOffLadder();

// Export UR6Pawn::execClimbActor(FFrame&, void* const)
native final function ClimbActor(Actor pClimb);

// Export UR6Pawn::execEndClimbActor(FFrame&, void* const)
native final function EndClimbActor();

// Export UR6Pawn::execSetupOffClimbActor(FFrame&, void* const)
native final function SetupOffClimbActor();

// Export UR6Pawn::execGetClimbTime(FFrame&, void* const)
native final function float GetClimbTime();

// Export UR6Pawn::execPawnUseGadget(FFrame&, void* const)
native final function PawnUseGadget(R6Gadget pGadget);

// Export UR6Pawn::execPawnCanUseGadget(FFrame&, void* const)
native final function bool PawnCanUseGadget(R6Gadget pGadget);

// Export UR6Pawn::execPawnEndUseGadget(FFrame&, void* const)
native final function PawnEndUseGadget();

// Export UR6Pawn::execCanBeIncapacitated(FFrame&, void* const)
native function bool CanBeIncapacitated();

// Export UR6Pawn::execRestsIncapacitated(FFrame&, void* const)
native final function bool RestsIncapacitated();

// Export UR6Pawn::execStartInteractWith(FFrame&, void* const)
native final function StartInteractWith(R6InteractiveActor pActor);

// Export UR6Pawn::execResetInteractAnim(FFrame&, void* const)
native final function ResetInteractAnim();

// Export UR6Pawn::execIsTeamLookingAtMe(FFrame&, void* const)
native final function bool IsTeamLookingAtMe();

// Export UR6Pawn::execEntryDoor(FFrame&, void* const)
native final function EntryDoor(R6InteractiveDoor pDoor, R6Pawn.EBreachTransitionType EType);

// Export UR6Pawn::execProtectStance(FFrame&, void* const)
native final function ProtectStance();

// Export UR6Pawn::execUnprotectStance(FFrame&, void* const)
native final function UnprotectStance();

// Export UR6Pawn::execDetonateDoorBreach(FFrame&, void* const)
native final function DetonateDoorBreach();

// Export UR6Pawn::execMakeGesture(FFrame&, void* const)
native final function MakeGesture(array<SGestureInfo> aGestures);

// Export UR6Pawn::execUnFreezeRagdoll(FFrame&, void* const)
native final function UnFreezeRagdoll();

// Export UR6Pawn::execFreezeRagdoll(FFrame&, void* const)
native final function FreezeRagdoll();

// Export UR6Pawn::execActivateFireDeath(FFrame&, void* const)
native final function ActivateFireDeath(Vector vOrigin);

// Export UR6Pawn::execGetFloorHeight(FFrame&, void* const)
native final function float GetFloorHeight();

// Export UR6Pawn::execGetLocationHeight(FFrame&, void* const)
native final function float GetLocationHeight();

// Export UR6Pawn::execAdjustRBVolume(FFrame&, void* const)
native final function AdjustRBVolume();

// Export UR6Pawn::execResetHealthRecoveryTimer(FFrame&, void* const)
native final function ResetHealthRecoveryTimer();

// Export UR6Pawn::execUpdateHealthState(FFrame&, void* const)
native final function UpdateHealthState();

// Export UR6Pawn::execOnR6PawnTalk(FFrame&, void* const)
native final function OnR6PawnTalk(SeqAct_R6PawnTalk Action);

// Export UR6Pawn::execCommunicateScriptedSound(FFrame&, void* const)
native final function CommunicateScriptedSound(SoundCue InSoundCue);

// Export UR6Pawn::execGetPlayerClass(FFrame&, void* const)
native function R6GameEnums.EPlayerClass GetPlayerClass();

// Export UR6Pawn::execCanBeRevived(FFrame&, void* const)
native function bool CanBeRevived();

// Export UR6Pawn::execCanBeHealed(FFrame&, void* const)
native function bool CanBeHealed();

// Export UR6Pawn::execIsAHacker(FFrame&, void* const)
native function bool IsAHacker();

// Export UR6Pawn::execIsADemolition(FFrame&, void* const)
native function bool IsADemolition();

// Export UR6Pawn::execInitPouch(FFrame&, void* const)
native final function InitPouch();

// Export UR6Pawn::execGetThrowAnimTime(FFrame&, void* const)
native function float GetThrowAnimTime();

// Export UR6Pawn::execGetPickupAnimTime(FFrame&, void* const)
native function float GetPickupAnimTime();

// Export UR6Pawn::execCanPickup(FFrame&, void* const)
native function Inventory.EPickupResult CanPickup(R6PickupableActor pPickup);

// Export UR6Pawn::execStartPickup(FFrame&, void* const)
native function StartPickup(R6PickupableActor pPickup);

// Export UR6Pawn::execStartThrowingWeapon(FFrame&, void* const)
native function StartThrowingWeapon();

// Export UR6Pawn::execReleaseThrownWeapon(FFrame&, void* const)
native function ReleaseThrownWeapon();

// Export UR6Pawn::execDoneThrowingWeapon(FFrame&, void* const)
native function DoneThrowingWeapon();

// Export UR6Pawn::execDoneHolsteringForPickup(FFrame&, void* const)
native function DoneHolsteringForPickup();

// Export UR6Pawn::execStartPickingWeapon(FFrame&, void* const)
native function StartPickingWeapon();

// Export UR6Pawn::execGrabWeapon(FFrame&, void* const)
native function GrabWeapon();

// Export UR6Pawn::execDonePickingWeapon(FFrame&, void* const)
native function DonePickingWeapon();

// Export UR6Pawn::execCancelPickup(FFrame&, void* const)
native function CancelPickup();

// Export UR6Pawn::execSetWantsGunUp(FFrame&, void* const)
native final function SetWantsGunUp(bool bUp);

// Export UR6Pawn::execForceGunUp(FFrame&, void* const)
native final function ForceGunUp(bool bForce);

// Export UR6Pawn::execIsGunUp(FFrame&, void* const)
native function bool IsGunUp();

// Export UR6Pawn::execIsWantsToGunUp(FFrame&, void* const)
native function bool IsWantsToGunUp();

// Export UR6Pawn::execGetRelativeLocationFromWorldLocation(FFrame&, void* const)
native final function R6GameEnums.EEventRelativeLocation GetRelativeLocationFromWorldLocation(Vector vLocation);

// Export UR6Pawn::execHasWeaponInInventory(FFrame&, void* const)
native function bool HasWeaponInInventory(optional bool bWithAmmo);

// Export UR6Pawn::execCanReviveCharacters(FFrame&, void* const)
native function bool CanReviveCharacters();

// Export UR6Pawn::execCanReloadWeapon(FFrame&, void* const)
native function bool CanReloadWeapon();

// Export UR6Pawn::execLoadEquipmentTemplate(FFrame&, void* const)
native function bool LoadEquipmentTemplate(string strTemplate);

// Export UR6Pawn::execInitInventory(FFrame&, void* const)
native function InitInventory(optional bool bFromLevelStart);

// Export UR6Pawn::execPutDownCurrentWeapon(FFrame&, void* const)
native function PutDownCurrentWeapon();

// Export UR6Pawn::execEquipCurrentWeapon(FFrame&, void* const)
native function EquipCurrentWeapon(optional bool bInstantSwitch);

reliable server event ServerSetEquipmentTemplate(class<R6Weapon> PrimaryType, class<R6Weapon> SecondaryType, class<R6Pistol> PistolType, class<R6Gadget> Gadget1Type, class<R6Gadget> Gadget2Type, byte PrimaryAttach, byte SecAttach, byte PistolAttach)
{
    m_EquipmentTemplate.Reset(PrimaryType, SecondaryType, PistolType, Gadget1Type, Gadget2Type, PrimaryAttach, SecAttach, PistolAttach);
    return;
}

reliable server event ServerGiveInitialInventory()
{
    InitInventory();
    return;
}

event int GetMaxHealth()
{
    return GetHealthConfig().m_iMaxHealthNPC;
    return;
}

function InitHealth()
{
    Health = GetMaxHealth();
    m_eHealthState = 0;
    return;
}

function PlayerChangedTeam()
{
    Died(none, Class'Engine.R6DamageType', Location);
    return;
}

function gibbedBy(Actor other)
{
    return;
}

function plog(coerce string S)
{
    return;
}

event InterpGroupAttached(SeqAct_Interp InterpAction, name GroupName)
{
    // End:0x33
    if(m_ActiveMatineeActors[0] == none)
    {
        m_ActiveMatineeActors[0] = InterpAction.ReplicatedActor;
        m_MatineeGroupsAttached[0] = GroupName;        
    }
    else
    {
        // End:0x66
        if(m_ActiveMatineeActors[1] == none)
        {
            m_ActiveMatineeActors[1] = InterpAction.ReplicatedActor;
            m_MatineeGroupsAttached[1] = GroupName;            
        }
    }
    return;
}

simulated event InterpolationFinished(SeqAct_Interp InterpAction)
{
    InterpolationFinished(InterpAction);
    // End:0x32
    if(m_ActiveMatineeActors[0] == InterpAction.ReplicatedActor)
    {
        m_ActiveMatineeActors[0] = none;        
    }
    else
    {
        // End:0x55
        if(m_ActiveMatineeActors[1] == InterpAction.ReplicatedActor)
        {
            m_ActiveMatineeActors[1] = none;
        }
    }
    return;
}

simulated event SetAnimPosition(out R6ScriptedAnimInfo AnimInfo, bool bFireNotifies)
{
    SetScriptedAnim(AnimInfo);
    return;
}

simulated event FinishAnimControl(bool bFacialAnim, name LastAnimPlayed)
{
    RemoveScriptedAnim(bFacialAnim, LastAnimPlayed);
    return;
}

simulated event NotifyAnimPaused(bool bPaused, name AnimToPause)
{
    PauseScriptedAnim(bPaused, AnimToPause);
    return;
}

function PossessedBy(Controller C, bool bVehicleTransition)
{
    m_pAI = R6AIController(C);
    PossessedBy(C, bVehicleTransition);
    CreateSoundReplicationInfo();
    // End:0x56
    if(m_SoundRepInfo != none)
    {
        m_SoundRepInfo.m_PawnRepInfo = R6PawnReplicationInfo(Controller.m_PawnRepInfo);
    }
    return;
}

function CreateSoundReplicationInfo()
{
    // End:0x6E
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x2E
        if(m_SoundRepInfo != none)
        {
            m_SoundRepInfo.Destroy();
            m_SoundRepInfo = none;
        }
        m_SoundRepInfo = __NFUN_278__(Class'R6SoundReplicationInfo', self);
        m_SoundRepInfo.m_pawnOwner = self;
        // End:0x6E
        if(!m_bSpawned)
        {
            m_SoundRepInfo.SetDeleteOnReset(false);
        }
    }
    return;
}

simulated event bool IsAutoAimable(Pawn aimingPawn)
{
    local R6Pawn pAimingR6Pawn;

    pAimingR6Pawn = R6Pawn(aimingPawn);
    return ((IsAlive()) && !IsATerro() || m_operatedTurret == none) && int(pAimingR6Pawn.CheckAlliance(self)) == int(2);
    return;
}

event bool IsFiringFromHip()
{
    return false;
    return;
}

event GetAutoAimInfluences(out array<SAutoAimInfluence> autoAimInfluences)
{
    GetAllBoneAutoAimInfluences(autoAimInfluences);
    return;
}

// Export UR6Pawn::execSetFocusHead(FFrame&, void* const)
native final function SetFocusHead(Vector vFocus, Actor pActor);

// Export UR6Pawn::execSetFocusBody(FFrame&, void* const)
native final function SetFocusBody(Vector vFocus, Actor pActor);

// Export UR6Pawn::execIsAimingAtCenter(FFrame&, void* const)
native final function bool IsAimingAtCenter();

// Export UR6Pawn::execNeedsPlayerUpdateFocusOfInterest(FFrame&, void* const)
native final function bool NeedsPlayerUpdateFocusOfInterest();

// Export UR6Pawn::execPlayerUpdateFocusOfInterest(FFrame&, void* const)
native final function PlayerUpdateFocusOfInterest();

event bool HealDamage(int Amount, Controller Healer, class<DamageType> DamageType)
{
    local bool bIncapacitated;
    local int iMaxHealth;

    bIncapacitated = IsIncapacitated();
    Health += Amount;
    iMaxHealth = GetMaxHealth();
    // End:0x41
    if(Health > iMaxHealth)
    {
        Health = iMaxHealth;
    }
    // End:0x6F
    if((bIncapacitated && !IsIncapacitated()) && RestsIncapacitated())
    {
        RecoverIncapacitation(Healer);
    }
    // End:0xEB
    if(R6GameInfo(WorldInfo.Game) != none)
    {
        // End:0xBE
        if(Controller != none)
        {
            R6GameInfo(WorldInfo.Game).Revived(Healer, Controller);            
        }
        else
        {
            R6GameInfo(WorldInfo.Game).Revived(Healer, Controller(Owner));
        }
    }
    UpdateHealthState();
    return true;
    return;
}

simulated function ProcessHealing()
{
    local int iPointToHeal;

    // End:0x45
    if((int(Role) == int(ROLE_Authority)) && m_pIncapacitatedPawnInteraction != none)
    {
        iPointToHeal = GetMaxHealth();
        m_pIncapacitatedPawnInteraction.HealDamage(iPointToHeal, Controller, none);
    }
    return;
}

event Landed(Vector HitNormal, Actor FloorActor, Vector vLocation)
{
    TakeLandingDamage();
    return;
}

function NotifyShotJustMissed(Pawn pInstigator)
{
    m_pAI.NotifyShotJustMissed(pInstigator);
    return;
}

function CheckBob(float fDeltaTime, Vector vY)
{
    return;
}

function string GetDebugName()
{
    // End:0x1A
    if(PlayerReplicationInfo != none)
    {
        return PlayerReplicationInfo.PlayerName;
    }
    return GetItemName(string(self));
    return;
}

simulated function PreBeginPlay()
{
    PreBeginPlay();
    // End:0x39
    if((int(Role) == int(ROLE_Authority)) && int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        CreateWeaponAttachmentsReplicator();
    }
    return;
}

simulated function PostBeginPlay()
{
    PostBeginPlay();
    // End:0x51
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x51
        if(int(GetGameManager().GetGameType()) != int(ROLE_MAX))
        {
            R6GameInfo(WorldInfo.Game).GetTeamManager(self);
        }
    }
    CreateBlockVolume();
    StandHeight = GetCollisionHeight();
    SetPhysics(m_eDefaultPhysics);
    bWantsToCrouch = false;
    InitHealth();
    m_rAimRotation = Rotation;
    m_rDesiredAimRotation = Rotation;
    m_vInFrontOfBody = Vector(Rotation);
    m_vLastReplicatedPos = Location;
    // End:0xC5
    if(m_CoverManager == none)
    {
        m_CoverManager = new Class'R6CoverManager';        
    }
    // End:0xD3
    if(m_CoverManager == none)
    {        
    }
    else
    {
        m_CoverManager.Init(self);
    }
    // End:0x11F
    if((int(Role) == int(ROLE_Authority)) && m_XTOS == none)
    {
        m_XTOS = new Class'R6XTOSystem';        
        m_XTOS.Init();
    }
    InitPouch();
    return;
}

simulated function InvManagerCreated()
{
    m_R6InvManager = R6InventoryManager(InvManager);
    m_bWaitInventoryMgr = false;
    return;
}

// Export UR6Pawn::execEquipBestWeapon(FFrame&, void* const)
native final function EquipBestWeapon(optional bool bInstantEquip);

function SetMovementPhysics()
{
    // End:0x12
    if(int(Physics) == int(2))
    {
        return;
    }
    // End:0x2C
    if(PhysicsVolume.bWaterVolume)
    {
        SetPhysics(3);        
    }
    else
    {
        SetPhysics(1);
    }
    return;
}

function OnR6SetPawnDead(SeqAct_R6SetPawnDead Action)
{
    local Vector vTmp;

    m_bPreventRagdoll = Action.m_bPreventRagdoll;
    Died(none, none, vTmp);
    return;
}

function OnR6DisableRagdoll(SeqAct_R6DisableRagdoll Action)
{
    // End:0x24
    if(Action.InputLinks[0].bHasImpulse)
    {
        m_bPreventRagdoll = false;        
    }
    else
    {
        // End:0x45
        if(Action.InputLinks[1].bHasImpulse)
        {
            m_bPreventRagdoll = true;
        }
    }
    return;
}

function OnR6SetGunStance(SeqAct_R6SetGunStance Action)
{
    // End:0x23
    if(Action.InputLinks[0].bHasImpulse)
    {
        SetWantsGunUp(true);        
    }
    else
    {
        // End:0x46
        if(Action.InputLinks[1].bHasImpulse)
        {
            SetWantsGunUp(false);            
        }
        else
        {
            // End:0x6F
            if(Action.InputLinks[2].bHasImpulse)
            {
                SetWantsGunUp(!IsWantsToGunUp());
            }
        }
    }
    return;
}

function OnSeqAct_R6ToggleBodyRotation(SeqAct_R6ToggleBodyRotation Action)
{
    // End:0x23
    if(Action.InputLinks[0].bHasImpulse)
    {
        EnableFocusUpdatesBodyRotation(true);        
    }
    else
    {
        // End:0x43
        if(Action.InputLinks[1].bHasImpulse)
        {
            EnableFocusUpdatesBodyRotation(false);
        }
    }
    // End:0x6B
    if(Action.InputLinks[2].bHasImpulse)
    {
        EnableFocusUpdatesBodyRotation(!m_bScriptEnableBodyRotation);
    }
    return;
}

function StopShowingDeadInRadar()
{
    m_bShowDeadInRadar = false;
    return;
}

simulated function bool CanSwitchWeapon()
{
    return (((((((m_R6Weapon != none) && m_R6Weapon.CanPutDown()) && m_pUsedGadget == none) && m_pOnRope == none) && !m_bUsingGoggles) && m_R6Weapon.HasRecoveredFromShoot()) && m_operatedTurret == none) && m_InHelicopter == none;
    return;
}

simulated event SetActiveWeapon(Weapon NewWeapon, optional bool bInstantSwitch)
{
    // End:0x29
    if(m_R6InvManager != none)
    {
        m_R6InvManager.SetCurrentWeapon(NewWeapon, false, bInstantSwitch);
    }
    return;
}

simulated function name GetDefaultCameraMode(PlayerController RequestedBy)
{
    return 'Default';
    return;
}

event BecomeViewTarget(PlayerController PC)
{
    BecomeViewTarget(PC);
    return;
}

simulated function OnR6AnimStaticShoot(SeqAct_R6AnimStaticShoot Action)
{
    // End:0x1D
    if(Weapon != none)
    {
        Weapon.StartFire(0);
    }
    return;
}

function Fall()
{
    GotoState('s_Falling');
    return;
}

function Revive(R6Pawn pR6Pawn)
{
    // End:0x78
    if(CanReviveCharacters())
    {
        m_eIncapaciteState = 4;
        m_pIncapacitatedPawnInteraction = pR6Pawn;
        pR6Pawn.m_pIncapacitatedPawnInteraction = self;
        StartIncapacitateAnim();
        // End:0x78
        if(!m_bIsNPCPawn && Controller != none)
        {
            KillSpeed();
            R6PlayerController(Controller).m_bDisableCameraInput = true;
            Controller.GotoInteractState();
        }
    }
    return;
}

function RecoverIncapacitation(Controller Healer)
{
    m_fRecoveryTime = 0.0000000;
    m_fReplicatedRecoveryTime = 0.0000000;
    m_eIncapaciteState = 3;
    bWantsToCrouch = false;
    StartIncapacitateAnim();
    // End:0x4D
    if(Controller != none)
    {
        Controller.ReviveEvent(Healer);
    }
    return;
}

event StartIncapacitateAnim()
{
    // End:0x32
    if((int(m_sReactionInfo.m_eType) != int(7)) && int(m_sReactionInfo.m_eType) != int(0))
    {
        EndReaction();
    }
    m_fIncapAnimCounter = 0.0000000;
    m_fIncapAnimLength = GetIncapaciteTimerLength();
    // End:0x98
    if(m_fIncapAnimLength > 0.0000000)
    {
        // End:0x8A
        if(int(m_eIncapaciteState) == int(4))
        {
            bWantsToCrouch = true;
            DisableBarrelIK();
            StartTimerEnableBarrelIk(m_fIncapAnimLength - 0.2500000);
        }
        SetTimer(m_fIncapAnimLength, false, 'IncapacitateTimer');
    }
    return;
}

function IncapacitateTimer()
{
    // End:0x32
    if(int(m_eIncapaciteState) == int(1))
    {
        bStationary = false;
        bReplicateMovement = false;
        m_eIncapaciteState = 2;
        m_iIncapacitatedDamage = 0;        
    }
    else
    {
        // End:0xA8
        if(int(m_eIncapaciteState) == int(3))
        {
            bStationary = true;
            bReplicateMovement = true;
            Mesh.m_bEnableHumanIK = true;
            m_eIncapaciteState = 0;
            m_eHealthState = 5;
            m_bUseWeaponIK = false;
            SetTimer(GetHealthConfig().m_fInvulnerableTimeAfterRevive, false, 'InvulnerableTimer');
            m_u8BarrelIKDisabled = 0;
            GotoState('DefaultState');            
        }
        else
        {
            // End:0x120
            if(int(m_eIncapaciteState) == int(4))
            {
                ProcessHealing();
                m_pIncapacitatedPawnInteraction.m_fRecoveryTime = 0.0000000;
                m_eIncapaciteState = 0;
                m_pIncapacitatedPawnInteraction.m_pIncapacitatedPawnInteraction = none;
                m_pIncapacitatedPawnInteraction = none;
                EnableBarrelIK();
                // End:0x120
                if(!m_bIsNPCPawn && Controller != none)
                {
                    Controller.PropagateReturnFromInteractState();
                }
            }
        }
    }
    m_fIncapAnimCounter = 0.0000000;
    m_fIncapAnimLength = 0.0000000;
    return;
}

function InvulnerableTimer()
{
    m_eHealthState = 0;
    return;
}

function OnR6RemovePawn(SeqAct_R6RemovePawn Action)
{
    GotoState('s_Obsolete');
    return;
}

simulated event StartGetUpFromKnock()
{
    return;
}

simulated event SetSlidingLadder(bool bSlide)
{
    // End:0x73
    if((m_pOnLadder != none) && bSlide)
    {
        // End:0x68
        if(!m_bSlidingLadder)
        {
            // End:0x41
            if(!IsLocallyControlled() && Controller != none)
            {
                ClientSlideLadder(true);
            }
            m_bStartSlide = true;
            m_pOnLadder.EnableBottomVolume(true, self);
            StartInteractionTimer(GetInteractTimerLength());
        }
        m_bSlidingLadder = true;        
    }
    else
    {
        // End:0x93
        if(!IsLocallyControlled() && Controller != none)
        {
            ClientSlideLadder(false);
        }
        m_bStartSlide = false;
        m_bSlidingLadder = false;
    }
    return;
}

event GetPIPInfo(out sPIPInfo pipInfo)
{
    pipInfo.rRotation = GetHeadDirection();
    pipInfo.vLocation = Mesh.GetBoneLocation('R65_BA_Head');
    pipInfo.fFov = 59.8400000;
    pipInfo.fAspectRatio = 1.0000000;
    // End:0xAE
    if(Controller.bIsPlayer)
    {
        pipInfo.bDistortionEnable = true;
        pipInfo.fDistortionStrength = 1.5000000;
        pipInfo.fDistortionScale = 1.6000000;
        pipInfo.EVisionMode = Controller.GetVisionMode();        
    }
    else
    {
        pipInfo.bDistortionEnable = false;
        pipInfo.EVisionMode = 0;
    }
    return;
}

simulated event TakeCoverShield(bool bEnable)
{
    local R6Shield pShield;

    // End:0x8B
    if(m_bTcShield != bEnable)
    {
        pShield = R6Shield(m_R6Weapon);
        // End:0x8B
        if((pShield != none) && pShield.m_bDoingChangeTcTransition || pShield.IsReadyToFire())
        {
            m_bTcShield = bEnable;
            pShield.ChangeTcStance();
            // End:0x8B
            if(m_bTcShield)
            {
                pShield.ResetScope();
            }
        }
    }
    return;
}

simulated function SetWeapon(Weapon NewWeapon)
{
    local R6Weapon pR6Weapon;
    local R6Shield pShield;
    local class<Weapon> pWeaponClass;
    local R6PlayerController pPC;

    pR6Weapon = R6Weapon(NewWeapon);
    UpdateWeaponBarrelIK(pR6Weapon);
    // End:0xBE
    if((m_R6Weapon != none) && !m_bIsNPCPawn)
    {
        pPC = R6PlayerController(Controller);
        // End:0xBE
        if(((pPC != none) && pPC.myHUD != none) && pPC.myHUD.AnimDebugThis == m_R6Weapon)
        {
            pPC.myHUD.SetAnimDebugTarget(NewWeapon, string(pPC.myHUD.AnimDebugStartingPoint));
        }
    }
    m_R6Weapon = pR6Weapon;
    m_bTcShield = false;
    // End:0x17E
    if(m_R6Weapon != none)
    {
        m_R6InvManager.m_iActiveWeapon = m_R6Weapon.m_iSlotIndex;
        // End:0x17B
        if(Controller != none)
        {
            pWeaponClass = m_R6Weapon.Class;
            pShield = R6Shield(m_R6Weapon);
            // End:0x166
            if((pShield != none) && pShield.m_FireableWeapon != none)
            {
                pWeaponClass = pShield.m_FireableWeapon.Class;
            }
            Controller.SetWeaponSound(pWeaponClass);
        }        
    }
    else
    {
        m_R6InvManager.m_iActiveWeapon = -1;
    }
    SetWeapon(NewWeapon);
    return;
}

reliable server function ServerSetWeapon(Weapon NewWeapon)
{
    local R6Weapon r6weap;

    r6weap = R6Weapon(NewWeapon);
    // End:0x31
    if((NewWeapon != none) && m_R6Weapon == none)
    {
        EnableBarrelIK();        
    }
    else
    {
        // End:0x52
        if((NewWeapon == none) && m_R6Weapon != none)
        {
            DisableBarrelIK();            
        }
        else
        {
            // End:0xB1
            if((r6weap != none) && m_R6Weapon != none)
            {
                // End:0xB1
                if(r6weap.UsesBarrelIK() != m_R6Weapon.UsesBarrelIK())
                {
                    // End:0xAB
                    if(r6weap.UsesBarrelIK())
                    {
                        EnableBarrelIK();                        
                    }
                    else
                    {
                        DisableBarrelIK();
                    }
                }
            }
        }
    }
    UpdateWeaponBarrelIK(r6weap);
    m_R6Weapon = r6weap;
    // End:0xF2
    if(m_R6Weapon != none)
    {
        m_R6InvManager.m_iActiveWeapon = m_R6Weapon.m_iSlotIndex;        
    }
    else
    {
        m_R6InvManager.m_iActiveWeapon = -1;
    }
    return;
}

event StartOperatingTurret(R6Turret Turret)
{
    m_operatedTurret = Turret;
    m_operatedTurret.SetOwner(self);
    m_operatedTurret.OperatorEnter(self);
    NetUpdateTime = WorldInfo.TimeSeconds - float(1);
    StopFiring();
    ShouldCrouch(false);
    Velocity = vect(0.0000000, 0.0000000, 0.0000000);
    Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
    HolsterOnInteraction();
    m_bEnteringTurret = true;
    m_bExitingTurret = false;
    SetTimer(GetWeaponsConfig().m_fEnterExitTurretDuration, false, 'FinishedGrabbingTurret');
    return;
}

function FinishedGrabbingTurret()
{
    EquipTurretWeapon();
    m_R6Weapon.SetCameraRecoil(m_R6Weapon);
    m_bEnteringTurret = false;
    m_fEnterExitTurretTime = 1.0000000;
    m_fEnterExitTurretTCTime = 0.0000000;
    return;
}

simulated function bool CanLeaveTurret()
{
    // End:0x0D
    if(m_R6Weapon == none)
    {
        return false;
    }
    return ((!m_bEnteringTurret && !m_bExitingTurret) && !m_R6Weapon.IsReloading()) && !IsFiring();
    return;
}

event StartLeavingTurret(optional bool bForcedLeave)
{
    // End:0x12
    if(IsFiring())
    {
        StopFiring();
    }
    // End:0x2C
    if(IsScoping())
    {
        m_R6Weapon.ResetScope();
    }
    // End:0x8E
    if((m_bTakingCoverOnTurret || m_bEnteringTurretTC) || m_bExitingTurretTC)
    {
        // End:0x6A
        if(m_bEnteringTurretTC)
        {
            ClearTimer('EnteredTurretTakeCover');
            m_bEnteringTurretTC = false;            
        }
        else
        {
            // End:0x86
            if(m_bExitingTurretTC)
            {
                ClearTimer('ExitedTurretTakeCover');
                m_bExitingTurretTC = false;
            }
        }
        m_bTakingCoverOnTurret = false;
    }
    UnequipTurretWeapon();
    // End:0xD9
    if(!bForcedLeave)
    {
        SetEquipOnInteractionTimer(GetWeaponsConfig().m_fEnterExitTurretDuration);
        SetTimer(GetWeaponsConfig().m_fEnterExitTurretDuration, false, 'FinishedLeavingTurret');
        m_bExitingTurret = true;        
    }
    else
    {
        FinishedLeavingTurret();
    }
    return;
}

simulated event FinishedLeavingTurret()
{
    m_bExitingTurret = false;
    m_operatedTurret.m_bResetAnimAfterOperatorLeft = true;
    m_operatedTurret.OperatorLeave();
    StopOperatingTurret();
    m_fEnterExitTurretTime = 0.0000000;
    m_fEnterExitTurretTCTime = 0.0000000;
    return;
}

event StopOperatingTurret()
{
    NetUpdateTime = WorldInfo.TimeSeconds - float(1);
    m_operatedTurret.SetOwner(none);
    m_operatedTurret = none;
    m_bEnteringTurret = false;
    m_bExitingTurret = false;
    ClearTimer('FinishedEnteringTurret');
    ClearTimer('FinishedLeavingTurret');
    ClearTimer('FinishedGrabbingTurret');
    // End:0x79
    if(Controller != none)
    {
        Controller.PropagateReturnFromInteractState();
    }
    return;
}

// Export UR6Pawn::execCanEnterTurretTakeCover(FFrame&, void* const)
native simulated function bool CanEnterTurretTakeCover();

// Export UR6Pawn::execCanExitTurretTakeCover(FFrame&, void* const)
native simulated function bool CanExitTurretTakeCover();

// Export UR6Pawn::execEnterTurretTakeCover(FFrame&, void* const)
native simulated function EnterTurretTakeCover();

// Export UR6Pawn::execEnteredTurretTakeCover(FFrame&, void* const)
native simulated function EnteredTurretTakeCover();

// Export UR6Pawn::execExitTurretTakeCover(FFrame&, void* const)
native simulated function ExitTurretTakeCover();

// Export UR6Pawn::execExitedTurretTakeCover(FFrame&, void* const)
native simulated function ExitedTurretTakeCover();

function EquipTurretWeapon()
{
    m_operatedTurret.m_pMountedWeapon.SetInstigator(self);
    m_operatedTurret.m_pMountedWeapon.SetInvManager(m_R6InvManager);
    m_operatedTurret.m_pMountedWeapon.GotoState('Active');
    m_R6InvManager.SetCurrentWeapon(m_operatedTurret.m_pMountedWeapon, false, true);
    return;
}

simulated event UnequipTurretWeapon()
{
    m_R6InvManager.SetCurrentWeapon(none, false, true);
    m_operatedTurret.m_pMountedWeapon.GotoState('Inactive');
    m_operatedTurret.m_pMountedWeapon.SetInstigator(none);
    m_operatedTurret.m_pMountedWeapon.SetInvManager(none);
    return;
}

function InteractSuccesful(Pawn pInteractor)
{
    local R6PlayerController pPC;

    InteractSuccesful(pInteractor);
    pPC = R6PlayerController(pInteractor.Controller);
    // End:0x54
    if(pPC != none)
    {
        GetGameManager().TutorialCaseDone(29, true);
        pPC.ReturnFromInteractState();
    }
    return;
}

event EndInteractWith(bool bInteractSuccess)
{
    local R6PlayerController pPC;

    // End:0x119
    if(m_pInteracting != none)
    {
        // End:0x46
        if(((int(m_eRainbowEntryLocation) == int(3)) || int(m_eRainbowEntryLocation) == int(1)) && !IsInTakeCover())
        {
            EnterTakeCover(3);            
        }
        else
        {
            // End:0x7C
            if(((int(m_eRainbowEntryLocation) == int(4)) || int(m_eRainbowEntryLocation) == int(2)) && IsInTakeCover())
            {
                ExitTakeCover(3);
            }
        }
        m_pInteracting.EnableBlockingVolume(false, self);
        EnableBarrelIK();
        // End:0xB1
        if(bInteractSuccess)
        {
            m_pInteracting.InteractSuccesful(self);            
        }
        else
        {
            m_pInteracting.AbortInteraction();
        }
        m_pInteracting = none;
        m_bPlayingInteractAnim = false;
        m_fInteractCounter = 0.0000000;
        m_fInteractLength = 0.0000000;
        m_ePawnInteraction = 0;
        pPC = R6PlayerController(Controller);
        // End:0x119
        if(pPC != none)
        {
            pPC.ReturnFromInteractState();
        }
    }
    return;
}

event AbortInteraction(bool bTriggerInteraction)
{
    local R6PlayerController pPC;

    // End:0x10
    if(bTriggerInteraction)
    {
        TimerInteractionFinished();
    }
    // End:0x35
    if(int(m_ePawnInteraction) == int(11))
    {
        DoorEntryFinished();
        ClearTimer('DoorEntryFinished');        
    }
    else
    {
        ClearTimer('TimerInteractionFinished');
    }
    m_fInteractCounter = 0.0000000;
    m_fInteractLength = 0.0000000;
    // End:0x71
    if(m_pInteracting != none)
    {
        EndInteractWith(bTriggerInteraction);        
    }
    else
    {
        pPC = R6PlayerController(Controller);
        // End:0x9C
        if(pPC != none)
        {
            pPC.ReturnFromInteractState();
        }
    }
    return;
}

function OnR6SetCurrentWeapon(SeqAct_R6SetCurrentWeapon Action)
{
    local Weapon pNewWeapon;
    local int iNewSlot;

    // End:0x1C
    if(Action.SetPrimary)
    {
        iNewSlot = 0;        
    }
    else
    {
        // End:0x38
        if(Action.SetSecondary)
        {
            iNewSlot = 1;            
        }
        else
        {
            // End:0x55
            if(Action.SetPistol)
            {
                iNewSlot = 2;                
            }
            else
            {
                return;
            }
        }
    }
    pNewWeapon = Weapon(m_R6InvManager.GetItemFromSlot(iNewSlot));
    // End:0x83
    if(pNewWeapon == none)
    {
        return;
    }
    // End:0xA4
    if(IsWeaponHolstered())
    {
        m_R6InvManager.m_iWeaponRemembered = iNewSlot;        
    }
    else
    {
        m_R6InvManager.SetCurrentWeapon(pNewWeapon, true, Action.bInstantSwitch);
    }
    return;
}

function OnR6DisableInterPawnCollision(SeqAct_R6DisableInterPawnCollision Action)
{
    local int I, iIndexFound;
    local R6Pawn pPawn;

    I = 0;
    J0x07:

    // End:0x10E [Loop If]
    if(I < Action.VariableLinks[0].LinkedVariables.Length)
    {
        pPawn = R6Pawn(SeqVar_Object(Action.VariableLinks[0].LinkedVariables[I]).ObjValue);
        // End:0x104
        if((pPawn != none) && self != pPawn)
        {
            iIndexFound = m_TraceExclusionList.Find(pPawn);
            // End:0xB7
            if(Action.InputLinks[0].bHasImpulse)
            {
                // End:0xB4
                if(iIndexFound >= 0)
                {
                    m_TraceExclusionList.Remove(iIndexFound, 1);
                }
                // [Explicit Continue]
                goto J0x104;
            }
            // End:0x104
            if(Action.InputLinks[1].bHasImpulse)
            {
                // End:0x104
                if(iIndexFound == -1)
                {
                    m_TraceExclusionList.Length = m_TraceExclusionList.Length + 1;
                    m_TraceExclusionList[m_TraceExclusionList.Length - 1] = pPawn;
                }
            }
        }
        J0x104:

        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

event PlayPawnTalk(SeqAct_R6PawnTalk Action)
{
    m_CurrentDialogVoiceLine = Action.m_VoiceLine;
    m_CurrentDialogAction = Action;
    // End:0x46
    if(m_CurrentDialogVoiceLine != none)
    {
        CommunicateScriptedSound(m_CurrentDialogVoiceLine);
        Action.m_bFinished = false;
    }
    return;
}

event TalkFinished()
{
    // End:0x1A
    if(m_CurrentDialogAction != none)
    {
        m_CurrentDialogAction.Finished();
    }
    m_CurrentDialogVoiceLine = none;
    m_CurrentDialogAction = none;
    return;
}

event TalkInterrupted()
{
    StopSound(m_CurrentDialogVoiceLine);
    m_CurrentDialogVoiceLine = none;
    m_CurrentDialogAction = none;
    return;
}

function bool CanPerformHandSignal()
{
    return R6Shield(m_R6Weapon) == none;
    return;
}

event QueueOrder(R6EngineEnums.ECommunicationTeamMessageType eOrder)
{
    local R6EngineEnums.EOrderSignalId eSignal;
    local float fTimer;

    // End:0x1A
    if((m_aOrdersQueue.Length > 0) || IsInTakeCover())
    {
        return;
    }
    // End:0xE4
    if(CanPerformHandSignal())
    {
        eSignal = GetHandSignalsConfig().GetHandSignalId(eOrder);
        fTimer = GetHandSignalsConfig().m_aHandSignalProperties[int(eSignal)].m_fTime;
        // End:0xE4
        if(fTimer > 0.0000000)
        {
            m_aOrdersQueue[m_aOrdersQueue.Length] = eOrder;
            // End:0xE4
            if(m_aOrdersQueue.Length == 1)
            {
                SetTimer(fTimer, false, 'HandSignalsTimer');
                m_fTimeLastOrder = WorldTime();
                m_fTimerCountHandSignal = fTimer;
                // End:0xE4
                if(m_iResetHandSignal != (GetGTicksGame() + 1))
                {
                    m_iResetHandSignal = GetGTicksGame() + 1;
                    m_bRepResetHandSignalAnim = !m_bRepResetHandSignalAnim;
                }
            }
        }
    }
    return;
}

event AbortHandSignals()
{
    m_aOrdersQueue.Length = 0;
    // End:0x21
    if(IsTimerActive('HandsSignalsTimer'))
    {
        ClearTimer('HandSignalsTimer');
    }
    m_fTimerCountHandSignal = 0.0000000;
    return;
}

function HandSignalsTimer()
{
    local R6EngineEnums.EOrderSignalId eSignal;
    local float fTimer;

    m_bUseWeaponIK = false;
    // End:0xD2
    if(m_aOrdersQueue.Length > 0)
    {
        m_aOrdersQueue.Remove(0, 1);
        // End:0xD2
        if(m_aOrdersQueue.Length > 0)
        {
            // End:0xCA
            if(CanPerformHandSignal())
            {
                eSignal = GetHandSignalsConfig().GetHandSignalId(m_aOrdersQueue[0]);
                fTimer = GetHandSignalsConfig().m_aHandSignalProperties[int(eSignal)].m_fTime;
                SetTimer(fTimer, false, 'HandSignalsTimer');
                m_fTimeLastOrder = WorldTime();
                m_fTimerCountHandSignal = fTimer;
                // End:0xC7
                if(m_iResetHandSignal != (GetGTicksGame() + 1))
                {
                    m_iResetHandSignal = GetGTicksGame() + 1;
                    m_bRepResetHandSignalAnim = !m_bRepResetHandSignalAnim;
                }                
            }
            else
            {
                m_aOrdersQueue.Length = 0;
            }
        }
    }
    return;
}

simulated event SkeletalMeshComponent GetMeshForCamera()
{
    return Mesh;
    return;
}

event AiCoverPeekLeft(optional bool bQuickPeek)
{
    local float fTime;
    local name TimerName;
    local R6EngineEnums.EAIPeekCoverStatus ePeekLeft;

    TimerName = 'TimerInteractionFinished';
    m_bAIPeekOnCover = IsInTakeCover();
    // End:0x56
    if(int(m_eAIPeekCoverStatus) == int(12))
    {
        ePeekLeft = ((bQuickPeek) ? 8 : 0);
        fTime = GetPeekLookLength(ePeekLeft, m_bAIPeekOnCover);
    }
    // End:0x8F
    if(fTime > 0.0000000)
    {
        ResetInteractAnim();
        m_eAIPeekCoverStatus = ePeekLeft;
        m_fInteractLength = fTime;
        SetTimer(fTime, false, TimerName);
    }
    return;
}

event AiCoverPeekRight(optional bool bQuickPeek)
{
    local float fTime;
    local R6EngineEnums.EAIPeekCoverStatus ePeekRight;

    m_bAIPeekOnCover = IsInTakeCover();
    // End:0x4B
    if(int(m_eAIPeekCoverStatus) == int(12))
    {
        ePeekRight = ((bQuickPeek) ? 9 : 1);
        fTime = GetPeekLookLength(ePeekRight, m_bAIPeekOnCover);
    }
    // End:0x77
    if(fTime > 0.0000000)
    {
        ResetInteractAnim();
        m_eAIPeekCoverStatus = ePeekRight;
        StartInteractionTimer(fTime);
    }
    return;
}

event AiCoverPeekUpLeft(optional bool bQuickPeek)
{
    local float fTime;
    local R6EngineEnums.EAIPeekCoverStatus ePeekUp;

    m_bAIPeekOnCover = IsInTakeCover();
    // End:0x7B
    if(m_bAIPeekOnCover)
    {
        // End:0x4F
        if(int(m_eAIPeekCoverStatus) == int(12))
        {
            ePeekUp = ((bQuickPeek) ? 10 : 2);
            fTime = GetPeekLookLength(ePeekUp, true);
        }
        // End:0x7B
        if(fTime > 0.0000000)
        {
            ResetInteractAnim();
            m_eAIPeekCoverStatus = ePeekUp;
            StartInteractionTimer(fTime);
        }
    }
    return;
}

event AiCoverPeekUpRight(optional bool bQuickPeek)
{
    local float fTime;
    local R6EngineEnums.EAIPeekCoverStatus ePeekUp;

    m_bAIPeekOnCover = IsInTakeCover();
    // End:0x7B
    if(m_bAIPeekOnCover)
    {
        // End:0x4F
        if(int(m_eAIPeekCoverStatus) == int(12))
        {
            ePeekUp = ((bQuickPeek) ? 11 : 3);
            fTime = GetPeekLookLength(ePeekUp, true);
        }
        // End:0x7B
        if(fTime > 0.0000000)
        {
            ResetInteractAnim();
            m_eAIPeekCoverStatus = ePeekUp;
            StartInteractionTimer(fTime);
        }
    }
    return;
}

event AiCoverStopPeek()
{
    local float fTime;

    switch(m_eAIPeekCoverStatus)
    {
        // End:0x2E
        case 13:
            m_eAIPeekCoverStatus = 4;
            fTime = GetPeekLookLength(m_eAIPeekCoverStatus, m_bAIPeekOnCover);
            // End:0xA6
            break;
        // End:0x55
        case 14:
            m_eAIPeekCoverStatus = 5;
            fTime = GetPeekLookLength(m_eAIPeekCoverStatus, m_bAIPeekOnCover);
            // End:0xA6
            break;
        // End:0x7C
        case 15:
            m_eAIPeekCoverStatus = 6;
            fTime = GetPeekLookLength(m_eAIPeekCoverStatus, m_bAIPeekOnCover);
            // End:0xA6
            break;
        // End:0xA3
        case 16:
            m_eAIPeekCoverStatus = 7;
            fTime = GetPeekLookLength(m_eAIPeekCoverStatus, m_bAIPeekOnCover);
            // End:0xA6
            break;
        // End:0xFFFF
        default:
            break;
    }
    // End:0xC7
    if(fTime > 0.0000000)
    {
        ResetInteractAnim();
        StartInteractionTimer(fTime);
    }
    return;
}

// Export UR6Pawn::execGetPeekLookLength(FFrame&, void* const)
native final function float GetPeekLookLength(R6EngineEnums.EAIPeekCoverStatus eStatus, bool bInTakeCover);

event StartDoorEntryTimer(R6InteractiveDoor pDoor)
{
    local float fTime;

    fTime = pDoor.GetInteractTime(self);
    m_fInteractCounter = 0.0000000;
    m_fInteractLength = fTime;
    ResetInteractAnim();
    SetTimer(fTime, false, 'DoorEntryFinished');
    return;
}

function DoorEntryFinished()
{
    m_eBreachTransition = 0;
    m_fInteractCounter = 0.0000000;
    m_fInteractLength = 0.0000000;
    m_bPlayingInteractAnim = false;
    m_ePawnInteraction = 0;
    return;
}

event SendDelayedProtect(float fTime)
{
    SetTimer(fTime, false, 'ProtectStance');
    return;
}

// Export UR6Pawn::execGetInteractTimerLength(FFrame&, void* const)
native function float GetInteractTimerLength();

// Export UR6Pawn::execGetIncapaciteTimerLength(FFrame&, void* const)
native function float GetIncapaciteTimerLength();

simulated event StartInteractionTimer(float fTime)
{
    // End:0x1F
    if((int(Role) != int(ROLE_Authority)) && !IsLocallyControlled())
    {
        return;
    }
    m_fTurnAngleToPlay = 0.0000000;
    m_fInteractCounter = 0.0000000;
    m_fInteractLength = fTime;
    // End:0x5D
    if(fTime != 0.0000000)
    {
        SetTimer(fTime, false, 'TimerInteractionFinished');
    }
    return;
}

event StartTimerEnableBarrelIk(float fTime)
{
    SetTimer(fTime, false, 'EnableBarrelIK');
    return;
}

simulated event StartBlendOutRopeTreeTimer(float fTime)
{
    SetTimer(fTime, false, 'EnableBlendOutRope');
    return;
}

simulated function EnableBlendOutRope()
{
    m_bBlendOutRopeTree = true;
    return;
}

simulated function TimerInteractionFinished()
{
    // End:0x4D
    if(int(m_ePawnInteraction) == int(15))
    {
        m_ePawnInteraction = 0;
        m_bPlayingInteractAnim = false;
        // End:0x4A
        if((int(m_eRainbowEntryLocation) == int(3)) || int(m_eRainbowEntryLocation) == int(1))
        {
            EnterTakeCover(3);
        }        
    }
    else
    {
        // End:0x70
        if(int(m_ePawnInteraction) == int(14))
        {
            m_ePawnInteraction = 13;
            m_bPlayingInteractAnim = false;            
        }
        else
        {
            // End:0x108
            if(int(m_eAIPeekCoverStatus) < int(12))
            {
                switch(m_eAIPeekCoverStatus)
                {
                    // End:0x97
                    case 0:
                        m_eAIPeekCoverStatus = 13;
                        // End:0xFD
                        break;
                    // End:0xA7
                    case 1:
                        m_eAIPeekCoverStatus = 14;
                        // End:0xFD
                        break;
                    // End:0xB7
                    case 2:
                        m_eAIPeekCoverStatus = 15;
                        // End:0xFD
                        break;
                    // End:0xC7
                    case 3:
                        m_eAIPeekCoverStatus = 16;
                        // End:0xFD
                        break;
                    // End:0xCC
                    case 4:
                    // End:0xD1
                    case 5:
                    // End:0xD6
                    case 6:
                    // End:0xDB
                    case 7:
                    // End:0xE0
                    case 8:
                    // End:0xE5
                    case 9:
                    // End:0xEA
                    case 10:
                    // End:0xFA
                    case 11:
                        m_eAIPeekCoverStatus = 12;
                        // End:0xFD
                        break;
                    // End:0xFFFF
                    default:
                        break;
                }
                m_bPlayingInteractAnim = false;                
            }
            else
            {
                // End:0x234
                if(int(m_eRopeStatus) != int(0))
                {
                    switch(m_eRopeStatus)
                    {
                        // End:0x124
                        case 8:
                        // End:0x129
                        case 5:
                        // End:0x146
                        case 2:
                            TimerJumpStart();
                            StartInteractionTimer(GetInteractTimerLength());
                            // End:0x231
                            break;
                        // End:0x14B
                        case 3:
                        // End:0x150
                        case 4:
                        // End:0x155
                        case 6:
                        // End:0x15A
                        case 7:
                        // End:0x15F
                        case 9:
                        // End:0x16D
                        case 10:
                            TimerJumpEnd();
                            // End:0x231
                            break;
                        // End:0x17D
                        case 13:
                            SetRopeStatus(0);
                            // End:0x231
                            break;
                        // End:0x193
                        case 11:
                            SetRopeStatus(1);
                            physOnRopeCheckWindowCollision();
                            // End:0x231
                            break;
                        // End:0x1D5
                        case 12:
                            SetRopeStatus(0);
                            // End:0x1CC
                            if(m_bWantsToBreach && m_pOnWindow != none)
                            {
                                m_bWantsToBreach = false;
                                RopeBreach(m_pOnWindow);                                
                            }
                            else
                            {
                                physOnRopeCheckWindowCollision();
                            }
                            // End:0x231
                            break;
                        // End:0x218
                        case 14:
                            // End:0x1FE
                            if(m_bRappelToFastRope)
                            {
                                SetRopeStatus(0);
                                m_bFastRope = true;
                                m_bRappelToFastRope = false;                                
                            }
                            else
                            {
                                SetupOnRope();
                            }
                            physOnRopeCheckWindowCollision();
                            m_vRopeDescendPos = Location;
                            // End:0x231
                            break;
                        // End:0x22E
                        case 15:
                            SetupOffRope();
                            SetRopeStatus(0);
                            // End:0x231
                            break;
                        // End:0xFFFF
                        default:
                            break;
                    }                    
                }
                else
                {
                    // End:0x26E
                    if(int(m_eLadderStatus) != int(0))
                    {
                        // End:0x25D
                        if(int(m_eLadderStatus) == int(1))
                        {
                            SetupOnLadder();                            
                        }
                        else
                        {
                            SetupOffLadder();
                        }
                        m_eLadderStatus = 0;                        
                    }
                    else
                    {
                        // End:0x282
                        if(m_bStartSlide)
                        {
                            m_bStartSlide = false;                            
                        }
                        else
                        {
                            // End:0x29C
                            if(m_pOnClimb != none)
                            {
                                EndClimbActor();
                                SetupOffClimbActor();                                
                            }
                            else
                            {
                                // End:0x2AF
                                if(m_pInteracting != none)
                                {
                                    EndInteractWith(true);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    m_fInteractCounter = 0.0000000;
    m_fInteractLength = 0.0000000;
    return;
}

singular simulated event BaseChange()
{
    // End:0x22
    if((Base == none) && int(Physics) == int(0))
    {
        SetPhysics(2);
    }
    return;
}

simulated event GetCameraLimitYawAngles(out int iMinYawAngle, out int iMaxYawAngle)
{
    // End:0x36
    if(m_operatedTurret != none)
    {
        iMinYawAngle = m_operatedTurret.m_iMaxLeftAimingAngle;
        iMaxYawAngle = m_operatedTurret.m_iMaxRightAimingAngle;        
    }
    else
    {
        iMinYawAngle = 0;
        iMaxYawAngle = 0;
    }
    return;
}

simulated event GetCameraLimitPitchAngles(out int iMinPitchAngle, out int iMaxPitchAngle)
{
    // End:0x36
    if(m_operatedTurret != none)
    {
        iMinPitchAngle = m_operatedTurret.m_iMaxDownAimingAngle;
        iMaxPitchAngle = m_operatedTurret.m_iMaxUpAimingAngle;        
    }
    else
    {
        iMinPitchAngle = 0;
        iMaxPitchAngle = 0;
    }
    return;
}

event bool ShouldApplyYawAimingOnRootBone()
{
    return m_InHelicopter != none;
    return;
}

event HolsterWeapon(optional bool bInstantSwitch)
{
    // End:0x41
    if((m_R6Weapon != none) && !m_R6Weapon.IsPuttingDown())
    {
        m_R6InvManager.RememberWeapon();
        SetActiveWeapon(none, bInstantSwitch);
    }
    return;
}

event bool IsWeaponHolstered()
{
    return m_R6Weapon == none;
    return;
}

event EquipLastWeapon(optional bool bInstantSwitch)
{
    m_R6InvManager.EquipRememberedWeapon(true, bInstantSwitch);
    return;
}

simulated event EndCrouch(float fHeightAdjust)
{
    EndCrouch(fHeightAdjust);
    PostureChanged();
    AdjustRBVolume();
    return;
}

simulated event StartCrouch(float fHeightAdjust)
{
    StartCrouch(fHeightAdjust);
    PostureChanged();
    AdjustRBVolume();
    return;
}

// Export UR6Pawn::execPostureChanged(FFrame&, void* const)
native final simulated function PostureChanged();

simulated function TimerJumpStart()
{
    local R6RapellingConfig pRappelConfig;

    pRappelConfig = GetRapellingConfig();
    // End:0xB3
    if(m_pOnRope != none)
    {
        // End:0x72
        if(int(m_eRopeStatus) != int(2))
        {
            Velocity = Vector(m_pOnRope.Rotation) * pRappelConfig.m_fSpeedImpulseOnBreaching;
            Velocity.Z = -m_fRopeWindowBreachHeight / pRappelConfig.m_fFallDurationOnBreaching;            
        }
        else
        {
            Velocity = Vector(m_pOnRope.Rotation) * pRappelConfig.m_fSpeedImpulseOnKickDown;
            Velocity.Z = -pRappelConfig.m_fGravityOnKickDown;
        }
    }
    SetRopeStatus(byte(int(m_eRopeStatus) + 1));
    return;
}

// Export UR6Pawn::execTimerJumpEnd(FFrame&, void* const)
native final function TimerJumpEnd();

event StartInstantEquipWeaponTimer()
{
    local float fTime;

    // End:0x99
    if(int(m_eRopeStatus) == int(14))
    {
        // End:0x31
        if(m_bRappelToFastRope)
        {
            fTime = GetInteractLengthsConfig().m_fDropWeaponRappelToFastRope;            
        }
        else
        {
            // End:0x59
            if(int(m_eNavObAttachingPos) == int(1))
            {
                fTime = GetInteractLengthsConfig().m_fEquipWeaponAttachTopRappel;                
            }
            else
            {
                // End:0x81
                if(int(m_eNavObAttachingPos) == int(2))
                {
                    fTime = GetInteractLengthsConfig().m_fEquipWeaponAttachBottomRappel;                    
                }
                else
                {
                    fTime = GetInteractLengthsConfig().m_fEquipWeaponAttachWindowRappel;
                }
            }
        }        
    }
    else
    {
        // End:0xF9
        if(int(m_eRopeStatus) == int(15))
        {
            // End:0xD1
            if(int(m_eNavObAttachingPos) == int(1))
            {
                fTime = GetInteractLengthsConfig().m_fDropWeaponDetachTopRappel;                
            }
            else
            {
                // End:0xF6
                if(int(m_eNavObAttachingPos) == int(2))
                {
                    fTime = GetInteractLengthsConfig().m_fDropWeaponDetachBottomRappel;
                }
            }            
        }
        else
        {
            // End:0x153
            if((int(m_eRopeStatus) >= int(5)) && int(m_eRopeStatus) <= int(10))
            {
                // End:0x13E
                if(m_R6Weapon != none)
                {
                    fTime = GetInteractLengthsConfig().m_fDropWeaponBreachRappel;                    
                }
                else
                {
                    fTime = GetInteractLengthsConfig().m_fEquipWeaponBreachRappel;
                }
            }
        }
    }
    // End:0x170
    if(fTime > 0.0000000)
    {
        SetTimer(fTime, false, 'TimerInstantEquipWeapon');
    }
    return;
}

function int GetRopeWeapon()
{
    return 2;
    return;
}

function TimerInstantEquipWeapon()
{
    // End:0x7C
    if((int(m_eRopeStatus) == int(14)) || int(m_eRopeStatus) == int(15))
    {
        // End:0x54
        if(m_bRappelToFastRope || int(m_eRopeStatus) == int(15))
        {
            m_R6InvManager.SetCurrentWeapon(none, false, true);            
        }
        else
        {
            // End:0x79
            if(m_R6InvManager != none)
            {
                m_R6InvManager.SetCurrentWeaponIndex(GetRopeWeapon(), false, true);
            }
        }        
    }
    else
    {
        // End:0x1F6
        if((int(m_eRopeStatus) >= int(5)) && int(m_eRopeStatus) <= int(10))
        {
            // End:0x1F6
            if(m_R6InvManager != none)
            {
                // End:0xD2
                if(m_R6Weapon != none)
                {
                    m_R6InvManager.SetCurrentWeapon(none, false, true);
                    StartInstantEquipWeaponTimer();                    
                }
                else
                {
                    // End:0xFA
                    if(m_R6InvManager.m_iWeaponRemembered == -1)
                    {
                        m_R6InvManager.m_iWeaponRemembered = 0;
                    }
                    // End:0x1E3
                    if((m_R6InvManager.m_inventorySlots[m_R6InvManager.m_iWeaponRemembered].m_item == none) || int(R6Weapon(m_R6InvManager.m_inventorySlots[m_R6InvManager.m_iWeaponRemembered].m_item).m_eWeaponAnimType) == int(3))
                    {
                        // End:0x1AC
                        if(GetGameManager().IsMultiplayer() && !GetGameManager().IsSplitscreen())
                        {
                            m_R6InvManager.m_iWeaponRemembered = GetRopeWeapon();                            
                        }
                        else
                        {
                            // End:0x1D3
                            if(m_R6InvManager.m_iWeaponRemembered == 0)
                            {
                                m_R6InvManager.m_iWeaponRemembered = 1;                                
                            }
                            else
                            {
                                m_R6InvManager.m_iWeaponRemembered = 0;
                            }
                        }
                    }
                    m_R6InvManager.EquipRememberedWeapon(false, true);
                }
            }
        }
    }
    return;
}

event HolsterOnInteraction()
{
    // End:0x2F
    if(m_R6Weapon != none)
    {
        m_R6InvManager.RememberWeapon();
        m_R6InvManager.SetCurrentWeapon(none, true, false, true);
    }
    return;
}

simulated event SetEquipOnInteractionTimer(float fInteractTime)
{
    SetTimer(fInteractTime - GetWeaponsConfig().m_fSwitchAnimTimeChest, false, 'EquipOnInteraction');
    return;
}

simulated event EquipOnInteraction()
{
    // End:0x1E
    if(m_R6Weapon == none)
    {
        m_R6InvManager.EquipRememberedWeapon(true, false, true);
    }
    return;
}

event KilledByLastDamage()
{
    Health = 0;
    Died(m_pLastKiller, m_LastDamage, Location);
    return;
}

event StartGestureTimer()
{
    local float fTimerLength;
    local bool bMoreGestures;

    // End:0x12E
    if(m_aGestureInfo.Length > m_iActiveGesture)
    {
        bMoreGestures = m_aGestureInfo.Length > (m_iActiveGesture + 1);
        fTimerLength = m_aGestureInfo[m_iActiveGesture].m_fLength;
        // End:0x97
        if(((m_iActiveGesture > 0) && !m_aGestureInfo[m_iActiveGesture].m_bHead) && !m_aGestureInfo[m_iActiveGesture - 1].m_bHead)
        {
            fTimerLength = fTimerLength - GetInteractLengthsConfig().m_fAIGestureArmBlendInPos;
        }
        // End:0xBC
        if(bMoreGestures)
        {
            fTimerLength = fTimerLength - GetInteractLengthsConfig().m_fAIGestureArmBlendOutPos;
        }
        // End:0x120
        if(m_aGestureInfo[m_iActiveGesture].m_bIkDisabled)
        {
            DisableBarrelIK();
            // End:0xF9
            if(!bMoreGestures)
            {
                SetTimer(fTimerLength - 0.3000000, false, 'ActiveBarrelIkTimer');                
            }
            else
            {
                // End:0x120
                if(!m_aGestureInfo[m_iActiveGesture + 1].m_bIkDisabled)
                {
                    SetTimer(fTimerLength, false, 'ActiveBarrelIkTimer');
                }
            }
        }
        SetTimer(fTimerLength, false, 'EndGestureTimer');
    }
    return;
}

function ActiveBarrelIkTimer()
{
    m_bUseWeaponIK = true;
    return;
}

function EndGestureTimer(optional bool bCancelAll)
{
    // End:0x1B
    if(m_aGestureInfo[m_iActiveGesture].m_bIkDisabled)
    {
        EnableBarrelIK();
    }
    m_bUseWeaponIK = false;
    // End:0x57
    if(bCancelAll || m_aGestureInfo.Length <= (m_iActiveGesture + 1))
    {
        m_iActiveGesture = -1;
        m_aGestureInfo.Length = 0;        
    }
    else
    {
        m_iActiveGesture++;
        StartGestureTimer();
    }
    return;
}

event AbortGesture()
{
    // End:0x3B
    if((m_iActiveGesture >= 0) && m_iActiveGesture < m_aGestureInfo.Length)
    {
        ClearTimer('EndGestureTimer');
        ClearTimer('ActiveBarrelIkTimer');
        EndGestureTimer(true);
    }
    return;
}

// Export UR6Pawn::execUpdateRopeAttachZoom(FFrame&, void* const)
native final function UpdateRopeAttachZoom();

simulated function PawnRopeZoom(bool bEnable)
{
    // End:0x24
    if(bEnable != m_bRopeZoom)
    {
        m_bRopeZoom = bEnable;
        UpdateRopeAttachZoom();
    }
    return;
}

event PrepareTimerReorientFPMesh(float fTime)
{
    SetTimer(fTime, false, 'TimerReorientFPMesh');
    return;
}

function TimerReorientFPMesh()
{
    local R6PlayerController pPC;

    m_bDisableFPMovement = false;
    pPC = R6PlayerController(Controller);
    // End:0x35
    if(pPC != none)
    {
        pPC.UseCameraDeltaRot(false, true);
    }
    return;
}

simulated event StartRappelAimTimer()
{
    // End:0x33
    if((m_R6Weapon != none) && m_R6Weapon.IsInShootSequence())
    {
        m_bRopeAiming = true;
        m_bRopeInAimTransition = false;        
    }
    else
    {
        // End:0x5E
        if(!m_bRopeInAimTransition)
        {
            SetTimer(GetRapellingConfig().m_fRappelAimTransitionLength, false, 'RappelAimTimer');
            m_bRopeInAimTransition = true;
        }
    }
    return;
}

simulated event ClearRappelAimTimer()
{
    m_bRopeInAimTransition = false;
    ClearTimer('RappelAimTimer');
    return;
}

simulated function RappelAimTimer()
{
    local R6PlayerController pPC;

    m_bRopeAiming = true;
    m_bRopeInAimTransition = false;
    // End:0x53
    if(!m_bIsNPCPawn && Controller != none)
    {
        pPC = R6PlayerController(Controller);
        // End:0x53
        if(pPC != none)
        {
            pPC.FinishRopeAim();
        }
    }
    return;
}

// Export UR6Pawn::execIsAimingOnRope(FFrame&, void* const)
native simulated function bool IsAimingOnRope();

event StartDetonateBreachTimer(float fTime)
{
    SetTimer(fTime, false, 'DetonateDoorBreach');
    return;
}

singular simulated function Rotator GetBaseAimRotation()
{
    return m_rAimRotation;
    return;
}

reliable client simulated event ClientClimbRope(R6InteractiveRope pRope, Vector vPos, int iYaw, bool bSettingNew)
{
    SetLocation(vPos, true);
    SetYaw(iYaw);
    ClimbRope(pRope, bSettingNew);
    return;
}

reliable client simulated event ClientEndClimbRope(bool bTransition, R6GameEnums.ENavObjAttachment eNavAtt, Vector vPos)
{
    SetLocation(vPos, true);
    m_eNavObAttachingPos = eNavAtt;
    EndClimbRope(bTransition);
    return;
}

reliable client simulated event ClientRopeBreach(R6InteractiveWindow pWindow)
{
    RopeBreach(pWindow);
    return;
}

reliable client simulated event ClientRopeJump()
{
    RopeJump();
    return;
}

reliable client simulated event ClientRopeInvert()
{
    InvertRope();
    return;
}

reliable client simulated event ClientClimbLadder(R6InteractiveLadder pLadder, Vector vPos, int iYaw)
{
    SetLocation(vPos, true);
    SetYaw(iYaw);
    ClimbR6Ladder(pLadder);
    return;
}

reliable client simulated event ClientEndClimbLadder(R6GameEnums.ENavObjAttachment eNavAtt, Vector vPos)
{
    m_eNavObAttachingPos = eNavAtt;
    SetLocation(vPos, true);
    EndClimbR6Ladder();
    return;
}

reliable client simulated function ClientSlideLadder(bool bSlide)
{
    SetSlidingLadder(bSlide);
    return;
}

reliable client simulated event ClientClimbActor(Actor pClimb, Vector vPos, int iYaw)
{
    SetLocation(vPos, true);
    SetYaw(iYaw);
    // End:0x45
    if((Controller != none) && !m_bIsNPCPawn)
    {
        R6PlayerController(Controller).ForceViewRotation(Rotation);
    }
    ClimbActor(pClimb);
    return;
}

auto state DefaultState
{    stop;
}

state s_Falling
{
    function BeginState(name PreviousStateName)
    {
        SetPhysics(2);
        return;
    }

    function Landed(Vector HitNormal, Actor FloorActor, Vector vLocation)
    {
        SetPhysics(1);
        GotoState('DefaultState');
        return;
    }
    stop;
}

state s_Waiting
{    stop;
}

state s_Inert
{
    function BeginState(name PreviousStateName)
    {
        SetCollision(true);
        bWantsToCrouch = false;
        return;
    }
Begin:

    stop;
    stop;        
}

state s_Unconscious extends s_Inert
{
    function BeginState(name PreviousStateName)
    {
        BeginState(PreviousStateName);
        Disable('Tick');
        return;
    }

    function EndState(name NextStateName)
    {
        // End:0x15
        if(Health > 0)
        {
            SetCollision(true);
            SetPhysics(1);
        }
        EndState(NextStateName);
        return;
    }
    stop;
}

state s_InitiallyUnconscious extends s_Unconscious
{
    function BeginState(name PreviousStateName)
    {
        BeginState(PreviousStateName);
        return;
    }
    stop;
}

simulated state s_Dying
{
    ignores BreathTimer;

    simulated function BeginState(name PreviousStateName)
    {
        local int I;

        // End:0xDB
        if(!m_bIsNPCPawn)
        {
            // End:0x25
            if(IsScoping())
            {
                m_R6Weapon.ResetScope();
            }
            // End:0x57
            if(bTearOff && int(WorldInfo.NetMode) == int(NM_DedicatedServer))
            {
                LifeSpan = 2.0000000;                
            }
            else
            {
                // End:0xDB
                if(GetGameManager().IsMultiplayer())
                {
                    // End:0xC3
                    if(((PlayerReplicationInfo != none) && R6PlayerReplicationInfo(PlayerReplicationInfo) != none) && R6PlayerReplicationInfo(PlayerReplicationInfo).m_fRespawnDelay != 0.0000000)
                    {
                        LifeSpan = R6PlayerReplicationInfo(PlayerReplicationInfo).m_fRespawnDelay;                        
                    }
                    else
                    {
                        LifeSpan = float(Class'R6MultiPlayerGame'.static.GetRespawnDelay());
                    }
                }
            }
        }
        SetCollision(true, false);
        I = 0;
        J0xE7:

        // End:0x128 [Loop If]
        if(I < Attached.Length)
        {
            // End:0x11E
            if(Attached[I] != none)
            {
                Attached[I].PawnBaseDied();
            }
            I++;
            // [Loop Continue]
            goto J0xE7;
        }
        // End:0x189
        if(Controller != none)
        {
            Controller.DeadEvent();
            // End:0x160
            if(Controller.bIsPlayer)
            {
                DetachFromController();                
            }
            else
            {
                Controller.Destroy();
                Controller = none;
                m_pAI = none;
                LastHitBy = none;
                bDisableAI = true;
            }
        }
        return;
    }
    stop;
}

state s_InitiallyDead extends s_Dying
{
    function BeginState(name PreviousStateName)
    {
        Health = 0;
        BeginState(PreviousStateName);
        return;
    }
    stop;
}

simulated state s_Incapacitated
{
    simulated function BeginState(name PreviousState)
    {
        // End:0x45
        if(!m_bIsNPCPawn && Controller != none)
        {
            // End:0x32
            if(IsScoping())
            {
                m_R6Weapon.ResetScope();
            }
            Controller.GotoState('Incapacitated');
        }
        return;
    }

    simulated function EndState(name NextState)
    {
        // End:0x3A
        if(Controller != none)
        {
            // End:0x3A
            if(!m_bIsNPCPawn && NextState != 's_Dying')
            {
                Controller.GotoState('PlayerWalking');
            }
        }
        return;
    }
    stop;
}

simulated state s_Obsolete
{
    simulated function BeginState(name PreviousStateName)
    {
        m_bTickOnlyWhenVisible = true;
        bDisableAI = true;
        SetTimer(0.0100000, false);
        return;
    }

    simulated function MakePawnObsolete()
    {
        // End:0x86
        if(m_pTeamManager != none)
        {
            // End:0x74
            if((m_pTeamManager.m_pCurrentGameInfo.m_pAIInfo.m_pAIPawnActivationManager != none) && (IsATerro()) || IsAHostage())
            {
                m_pTeamManager.m_pCurrentGameInfo.m_pAIInfo.m_pAIPawnActivationManager.m_iNumAIPawnsExist--;
            }
            m_pTeamManager.RemovePawnFromTeam(self, true);
        }
        // End:0x9D
        if(m_pAI != none)
        {
            m_pAI.Destroy();
        }
        Health = 0;
        Destroy();
        return;
    }

    simulated event Timer()
    {
        // End:0x1D
        if(bHidden || !PlayerCanSeeMe())
        {
            MakePawnObsolete();            
        }
        else
        {
            SetTimer(2.0000000, false);
        }
        return;
    }
    stop;
}

simulated state s_KnockDown
{
    simulated function BeginState(name PreviousState)
    {
        // End:0x77
        if(!m_bIsNPCPawn)
        {
            m_bIsKnockedDown = true;
            // End:0x2D
            if(IsScoping())
            {
                m_R6Weapon.ResetScope();
            }
            StartKnockDown();
            // End:0x74
            if(((Controller != none) && Controller.LocalPlayerController()) && bIsCrouched)
            {
                R6PlayerController(Controller).ChangePosture();
            }            
        }
        else
        {
            GotoState('DefaultState');
        }
        return;
    }

    simulated function StartKnockDown()
    {
        local bool bStartKnockDown;

        bStartKnockDown = false;
        // End:0x28
        if(IsInTakeCover())
        {
            // End:0x25
            if(!IsPlayingExitingCover())
            {
                ExitTakeCover(0);
            }            
        }
        else
        {
            // End:0x9F
            if(!IsPlayingExitingCover())
            {
                // End:0x9F
                if(!IsScoping())
                {
                    // End:0x8C
                    if((((Controller != none) && Controller.LocalPlayerController()) && bIsCrouched) && !bWantsToCrouch)
                    {
                        R6PlayerController(Controller).ChangePosture();
                    }
                    // End:0x9F
                    if(!bIsCrouched)
                    {
                        bStartKnockDown = true;
                    }
                }
            }
        }
        // End:0xEF
        if(bStartKnockDown)
        {
            Velocity = vect(0.0000000, 0.0000000, 0.0000000);
            Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
            m_eIncapaciteState = 1;
            m_eIncapaciteDir = 8;
            m_bPlayFullIncapAnim = true;
            DisableBarrelIK();            
        }
        else
        {
            SetTimer(0.1000000, false, 'StartKnockDown');
        }
        return;
    }

    simulated event StartGetUpFromKnock()
    {
        m_bIsKnockedDown = false;
        // End:0x76
        if(int(m_eIncapaciteState) == int(1))
        {
            // End:0x61
            if((m_fIncapAnimCounter >= m_fIncapAnimLength) || m_fIncapAnimLength <= 0.0000000)
            {
                m_eIncapaciteState = 3;
                m_eIncapaciteDir = 8;
                SetTimer(0.1000000, false, 'CheckGotUp');
                m_bPlayFullIncapAnim = true;                
            }
            else
            {
                SetTimer(m_fIncapAnimLength - m_fIncapAnimCounter, false, 'StartGetUpFromKnock');
            }
        }
        return;
    }

    simulated function CheckGotUp()
    {
        // End:0x5A
        if(int(m_eIncapaciteState) == int(3))
        {
            // End:0x45
            if((m_fIncapAnimCounter >= m_fIncapAnimLength) || m_fIncapAnimLength <= 0.0000000)
            {
                m_eIncapaciteState = 0;
                GotoState('DefaultState');                
            }
            else
            {
                SetTimer(m_fIncapAnimLength - m_fIncapAnimCounter, false, 'CheckGotUp');
            }
        }
        return;
    }

    simulated function EndState(name NextState)
    {
        // End:0x37
        if(!m_bIsNPCPawn)
        {
            EnableBarrelIK();
            m_bPlayFullIncapAnim = false;
            // End:0x37
            if(Controller != none)
            {
                Controller.GotoState('PlayerWalking');
            }
        }
        return;
    }
    stop;
}

defaultproperties
{
    m_TcMoveAnimInfo=(m_aWeights=m_aWeights[0]=1.0000000
    m_aWeights[1]=0.0000000
    m_aWeights[2]=0.0000000
    m_aWeights[3]=0.0000000
    m_aWeights[4]=0.0000000,m_aRates=m_aRates[0]=1.0000000
    m_aRates[1]=1.0000000
    m_aRates[2]=1.0000000
    m_aRates[3]=1.0000000,m_eState=0,m_bBlendToNotMoving=false,m_bDoingSideStep=false,m_bWantsToStop=false,m_bTurningBack=false,m_fBlendTimeToGo=0.0000000,m_fBlendSpeed=0.3000000,m_fWalkInterpolateSpeed=2.0000000,m_fBlendToNotMovingLength=0.0000000,m_vOldLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000))
    m_bTickAnimOptActive=true
    m_bDelayInvSpawn=true
    m_bWaitInventoryMgr=true
    m_bGunUp=true
    m_bWantsGunUp=true
    m_u8BarrelIKDisabled=1
    m_eThrowType=17
    m_eAIPeekCoverStatus=12
    m_eAlliance=4
    m_eDefaultPhysics=1
    m_eCurrentHelicopterAction=4
    m_eOriginalMoodType=1
    m_eIdleRole=1
    m_EquipmentTemplate=R6EquipmentTemplate'EquipmentTemplates.DefaultPawnEquipment'
    m_AITemplate=R6AITemplate'RS5CharacterAITemplate.DefaultAITemplate'
    m_sDefaultObjective=(m_eObjectiveType=2,m_nNameId="None",m_fMaxDistanceFromStartLocation=0.0000000,m_aActors=none,m_bIsMobile=false,m_bCanBeLeader=false,m_bFollowInFormation=false,m_fFormationDistance=0.0000000,m_fFormationAngle=0.0000000,m_fAttackTimeDelay=1.0000000)
    m_iCurrentEnemy=-1
    m_ScriptedAnim=(m_AnimName="None",m_bLooping=false,m_bKeepAnimAtLastFrame=false,m_fAnimPos=0.0000000,m_fStartPos=0.0000000,m_fPlayRate=1.0000000,m_fStartBlendTime=0.5000000,m_fEndBlendTime=0.5000000,m_bApplyRootYawRotation=true,m_bNoFailCollision=false,m_bIsFacial=false,m_bCalculateVelocity=false,m_eRootMotion=2,m_eRootMotion[1]=2,m_eRootMotion[2]=0)
    m_RepScriptedAnimInfo=(m_AnimName="None",m_bLooping=false,m_bKeepAnimAtLastFrame=false,m_fAnimPos=0.0000000,m_fStartPos=0.0000000,m_fPlayRate=1.0000000,m_fStartBlendTime=0.5000000,m_fEndBlendTime=0.5000000,m_bApplyRootYawRotation=true,m_bNoFailCollision=false,m_bIsFacial=false,m_bCalculateVelocity=false,m_eRootMotion=2,m_eRootMotion[1]=2,m_eRootMotion[2]=0)
    m_szHelicopterSittingToFastRopingAnim="HeliSeat_FastRope"
    m_sGestureSpeed=(m_eMoodType=0,m_fBodySpeed=1.0000000,m_fBreathingSpeed=1.0000000,m_fHeadSpeed=1.0000000,m_fOriginalHeadSpeed=1.0000000)
    m_sPostureType=(m_eMoodType=0,m_fBreathingStrength=1500.0000000,m_eHeadPosture=0)
    m_fHeadConeAngle=1.2000000
    m_fStandWeight=1.0000000
    m_iActiveGesture=-1
    bCanCrouch=true
    bCanSwim=true
    bCanClimbLadders=true
    bCanClimb=true
    bCanStrafe=true
    bCanPickupInventory=true
    bMuffledHearing=true
    bDontPossess=true
    HearingThreshold=15000.0000000
    SightRadius=12000.0000000
    MeleeRange=20.0000000
    GroundSpeed=350.0000000
    LadderSpeed=350.0000000
    JumpZ=540.0000000
    AirControl=0.3500000
    WalkingPct=0.3000000
    CrouchedPct=1.0000000
    BaseEyeHeight=60.0000000
    EyeHeight=60.0000000
    UnderWaterTime=20.0000000
    ControllerClass=Class'R6AIController'
    InventoryManagerClass=Class'R6InventoryManager'
    m_bIsDynamicObstacle=true
    bNetInitialRotation=true
    bCollideSB=true
    m_bSnakeCamRelevant=true
    m_bIsNPCPawn=true
    // Reference: CylinderComponent'Default__R6Pawn.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: CylinderComponent'Engine.Default__Pawn.CollisionCylinder'
    begin object name="CollisionCylinder"
    end object
    Components[0]=CollisionCylinder
    // Reference: ArrowComponent'Default__R6Pawn.Arrow'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: ArrowComponent'Engine.Default__Pawn.Arrow'
    begin object name="Arrow"
    end object
    Components[1]=Arrow
    m_eExplosionCollisionOverride=2
    TickGroup=1
    m_supportedExplosionEffects=/* Array type was not detected. */
    Buoyancy=99.0000000
    RotationRate=(Pitch=0,Yaw=40000,Roll=2048)
    MessageClass=Class'R6GameMessage'
    SupportedEvents=/* Array type was not detected. */
}