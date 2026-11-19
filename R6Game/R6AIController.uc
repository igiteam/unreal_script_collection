class R6AIController extends AIController
    native
    hidecategories(lighting);

enum EAsyncPathReqStatus
{
    APRS_None,                      // 0
    APRS_Waiting,                   // 1
    APRS_Finished,                  // 2
    APRS_Max                        // 3
};

enum EMovePrecision
{
    MVPR_Normal,                    // 0
    MVPR_PreciseNoAbort,            // 1
    MVPR_PreciseCanAbort,           // 2
    MVPR_Max                        // 3
};

struct ReactionStimuli
{
    var EAIEvent m_Event;
    var float m_fReactionTimer;

    structdefaultproperties
    {
        m_Event=(m_eEventType=0,m_eGoalType=0,m_nGoalID="None",m_vEventLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000),m_pEventTarget=none,m_damageType=none)
        m_fReactionTimer=0.0000000
    }
};

struct sUnsafeTriangle
{
    var int iTriangleIndex;
    var float fUnsafeTimer;

    structdefaultproperties
    {
        iTriangleIndex=0
        fUnsafeTimer=0.0000000
    }
};

struct sTacticSwitchInfo
{
    var Actor.ETacticType m_eNewTactic;
    var R6Pawn m_pNewTacticLeader;
    var int m_iNewIntData;
    var Vector m_vNewVectorData;
    var float m_fNewFloatData;
    var byte m_u8NewByteData;
    var ENavMesh m_pOptNavMesh;
    var Actor m_pLastActorUsed;
    var Vector m_vLocationToUse;
    var array<int> m_aZonePath;

    structdefaultproperties
    {
        m_eNewTactic=0
        m_pNewTacticLeader=none
        m_iNewIntData=0
        m_vNewVectorData=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_fNewFloatData=0.0000000
        m_u8NewByteData=0
        m_pOptNavMesh=none
        m_pLastActorUsed=none
        m_vLocationToUse=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_aZonePath=none
    }
};

struct NavigationData
{
    var Vector m_vFinalDest_NM;
    var Vector m_vCurrentDest_NM;
    var Vector m_vPathDest_NM;
    var Vector m_vFacingDirAtEnd;
    var array<Actor> m_aObstacles;
    var bool m_bTurningCorner;
    var Vector m_vPreCorner;
    var Vector m_vCorner;
    var Vector m_vPostCorner;
    var array<Vector> m_avCornerTraj;
    var array<Vector> m_avCornerBodyFocus;
    var int m_iNextCornerTrajPt;
    var bool m_bOldForceGunUp;
    var R6Pawn m_pFormationLeader;
    var float m_fFormationAngle;
    var float m_fFormationDistance;
    var float m_fFormationNoiseAngle;
    var Vector m_vLeaderDir;
    var bool m_bLeaderPause;
    var Vector m_vLeaderLastPause;
    var array<Vector> m_aLeaderTrace;
    var int m_iLeaderTraceStart;
    var bool m_bLeaderSlowdown;
    var bool m_bMatchLeaderSpeed;
    var Actor m_pEncroachingDoor;

    structdefaultproperties
    {
        m_vFinalDest_NM=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_vCurrentDest_NM=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_vPathDest_NM=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_vFacingDirAtEnd=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_aObstacles=none
        m_bTurningCorner=false
        m_vPreCorner=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_vCorner=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_vPostCorner=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_avCornerTraj=none
        m_avCornerBodyFocus=none
        m_iNextCornerTrajPt=0
        m_bOldForceGunUp=false
        m_pFormationLeader=none
        m_fFormationAngle=0.0000000
        m_fFormationDistance=0.0000000
        m_fFormationNoiseAngle=0.0000000
        m_vLeaderDir=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_bLeaderPause=false
        m_vLeaderLastPause=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_aLeaderTrace=none
        m_iLeaderTraceStart=0
        m_bLeaderSlowdown=false
        m_bMatchLeaderSpeed=false
        m_pEncroachingDoor=none
    }
};

struct PathFindingData
{
    var bool m_bUseSpecialPath;
    var bool m_bUseCoverPath;
    var bool m_bDirectPath;
    var bool m_bIsLimited;
    var bool m_bAvoidPhysObstacles;
    var bool m_bAvoidEnemyCoverage;
    var bool m_bAvoidSmoke;
    var bool m_bAvoidTearGas;
    var bool m_bChangingNavMesh;
    var ENavMesh m_pPendingNavMesh;
    var float m_fAllowedPathCost;
    var R6AIController.EAsyncPathReqStatus m_eAsyncPathReqStatus;
    var int m_iAsyncPathLastResult;
    var array<R6PathNode> m_aAsyncPathLastPath;
    var int m_iLastPathFindResult;
    var Vector m_vAdjCurrentDest_NM;
    var int m_iGoalNavIndex;
    var bool m_bNeedNewPath;
    var array<int> m_TrianglesToDisable;
    var array<R6PathNode> m_aCurrentPath;
    var array<R6PathNode> m_aLastComputedPath;
    var R6PathFindOptions m_LastComputedPathOptions;
    var array<R6PathNode> m_aPartialPath;
    var bool m_bCurrentPathUsesSubs;
    var bool m_bStopDuringReqWait;
    var Double m_fLastPFAvoidingPhys;
    var int m_iCurrentSubIndex;
    var int m_iGoalSubIndex;
    var float m_fCost;

    structdefaultproperties
    {
        m_bUseSpecialPath=false
        m_bUseCoverPath=false
        m_bDirectPath=false
        m_bIsLimited=false
        m_bAvoidPhysObstacles=false
        m_bAvoidEnemyCoverage=false
        m_bAvoidSmoke=false
        m_bAvoidTearGas=false
        m_bChangingNavMesh=false
        m_pPendingNavMesh=none
        m_fAllowedPathCost=0.0000000
        m_eAsyncPathReqStatus=0
        m_iAsyncPathLastResult=0
        m_aAsyncPathLastPath=none
        m_iLastPathFindResult=0
        m_vAdjCurrentDest_NM=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_iGoalNavIndex=0
        m_bNeedNewPath=false
        m_TrianglesToDisable=none
        m_aCurrentPath=none
        m_aLastComputedPath=none
        m_LastComputedPathOptions=(m_bAvoidPhysObstacles=false,m_bAvoidSmoke=false,m_bAvoidTearGas=false,m_iTeamCoverageRestriction=0,m_bUsesObstacleAllowance=false,m_NavObjAllowance=(m_bDoorNotAllowed=false,m_bRopeNotAllowed=false,m_bWindowNotAllowed=false,m_bLedgeNotAllowed=false,m_bRopeLedgeNotAllowed=false,m_bLadderNotAllowed=false,m_aIllegalInteractiveActor=none),m_aSmokeZones=none,m_aTearGasZones=none,m_pPawn=none,m_fAllowedPathCost=0.0000000)
        m_aPartialPath=none
        m_bCurrentPathUsesSubs=false
        m_bStopDuringReqWait=false
        m_fLastPFAvoidingPhys=none
        m_iCurrentSubIndex=0
        m_iGoalSubIndex=0
        m_fCost=0.0000000
    }
};

struct PathFollowingData
{
    var bool m_bBackwards;
    var int m_iMoveFlags;
    var bool m_bKeepFocus;
    var bool m_bCanAbortUltraPrecise;
    var Vector m_vInterDest[4];
    var int m_iValidInterDest;
    var int m_iAvoidanceResult;
    var Actor m_pBlockingObject;
    var Actor m_pLastAvoidObject;
    var Actor m_pLastUnavoidable;
    var float m_fLastAvoidDistance;
    var int m_iLastAvoidSide;
    var float m_fObstacleTimer;
    var Vector m_LastAlternateDestination;
    var Vector m_LastAvoidedDestination;
    var bool m_bSecondTry;
    var bool m_bForceSide;
    var bool m_bUseSubTriangles;
    var array<ENavMesh> m_aConnectedNavMeshes;
    var Actor m_pDeadEndObstacle[2];
    var Vector m_vDeadEndObstPos[2];
    var Vector m_vDeadEndMyPos[2];
    var Vector m_vDeadEndSubDest[2];
    var float m_fDeadEndWait[2];
    var Vector m_vFormationDest;
    var Vector m_vFormationDir;

    structdefaultproperties
    {
        m_bBackwards=false
        m_iMoveFlags=0
        m_bKeepFocus=false
        m_bCanAbortUltraPrecise=false
        m_vInterDest[0]=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_vInterDest[1]=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_vInterDest[2]=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_vInterDest[3]=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_iValidInterDest=0
        m_iAvoidanceResult=0
        m_pBlockingObject=none
        m_pLastAvoidObject=none
        m_pLastUnavoidable=none
        m_fLastAvoidDistance=0.0000000
        m_iLastAvoidSide=0
        m_fObstacleTimer=0.0000000
        m_LastAlternateDestination=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_LastAvoidedDestination=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_bSecondTry=false
        m_bForceSide=false
        m_bUseSubTriangles=false
        m_aConnectedNavMeshes=none
        m_pDeadEndObstacle[0]=none
        m_pDeadEndObstacle[1]=none
        m_vDeadEndObstPos[0]=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_vDeadEndObstPos[1]=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_vDeadEndMyPos[0]=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_vDeadEndMyPos[1]=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_vDeadEndSubDest[0]=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_vDeadEndSubDest[1]=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_fDeadEndWait[0]=0.0000000
        m_fDeadEndWait[1]=0.0000000
        m_vFormationDest=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_vFormationDir=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

struct bbox
{
    var Box aBox;
    var Vector Start;
    var Vector Dir;
    var Vector tangeant1;
    var Vector tangeant2;

    structdefaultproperties
    {
        aBox=(Min=(X=0.0000000,Y=0.0000000,Z=0.0000000),Max=(X=0.0000000,Y=0.0000000,Z=0.0000000),IsValid=None)
        Start=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Dir=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        tangeant1=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        tangeant2=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

struct WaitForGoalDesc
{
    var name m_sJumpLabel;
    var name m_sStateName;
    var name m_sGoalName;
    var Actor.GoalType m_eGoalType;
    var int m_iLastGoalStatus;

    structdefaultproperties
    {
        m_sJumpLabel="None"
        m_sStateName="None"
        m_sGoalName="None"
        m_eGoalType=0
        m_iLastGoalStatus=0
    }
};

struct FocusPoint
{
    var Actor infopoint;
    var bool bStillValidForPatrol;
    var bool bValidForNextFocus;
    var float fDistance;
    var float fDot;

    structdefaultproperties
    {
        infopoint=none
        bStillValidForPatrol=false
        bValidForNextFocus=false
        fDistance=0.0000000
        fDot=0.0000000
    }
};

var float CheckEnemyBones_PerfTimer;
var float EGAnim_PerfTimer;
var float EGWait_PerfTimer;
var float EGPatrol_PerfTimer;
var float EGShoot_PerfTimer;
var float BSSetCorners_PerfTimer;
var float Controller_PerfTimer;
var float m_fDistBackWard;
var float m_fBackWardTimer;
var R6Pawn m_R6Pawn;
var R6Tactic m_pTactic;
var byte m_eTacticRole;
var byte m_eCurrentTacticStep;
var R6EngineEnums.EVisionMode m_CurrentVisionMode;
var Actor.ER6MoveFlags m_iFastCoverWaitFlag;
var R6GameEnums.EActionType m_eReactionActionType;
var Actor.GoalType LastGoalType;
var Actor.GoalStatus ReturnStatus;
var int m_iTacticPositionNum;
var int m_iShareCoverPosition;
var bool m_bTacticReady;
var bool m_bShouldTeamManagerIgnore;
var bool m_bIsSearchLocationVisible;
var bool m_bIsScanSearchLoc;
var bool m_bHasCheckedRevivePath;
var bool m_bInteractiveObject;
var bool m_bIsMovingToThrowGrenade;
var bool m_bIncreaseCoverAngle;
var bool m_bCoveringToLeft;
var bool m_bFoundCoverAngle;
var bool m_bCrouchAtDestination;
var bool m_bNeedsCatchup;
var bool m_bInvestigatingSound;
var bool m_bMustDelayStartOfMove;
var bool m_bHasDelayedStartOfMove;
var bool m_bShootInGunDirection;
var bool m_bIsIdleReady;
var bool m_bIsUpdateAimRotForGrenade;
var bool m_bIsShootingAtNearbyEnemy;
var bool m_bIsTacticWaitingOnSR;
var bool m_bIsTacticHasMadePreviousSR;
var bool m_bIsTacticPreviousSRFailed;
var bool m_bIsCombatWaitingOnSR;
var bool m_bIsCombatHasMadePreviousSR;
var bool m_bIsCombatPreviousSRFailed;
var bool m_bHasFlippedTableForCover;
var bool m_bHasNoSuppressorWeapon;
var bool m_bUseSpecificZoneForConstraint;
var bool m_bHasUpdatedClearList;
var bool m_bIsCreatingClearList;
var bool m_bIsSwitchingTactic;
var bool m_bIsIdleActionDesired;
var bool m_bIsPeekingActionDesired;
var bool m_bCalculatedActionCondition;
var bool m_bCalculatedActionExecution;
var bool m_bWasMovingInCover;
var bool m_bIsStopToShoot;
var bool m_bIsWaitingForTeamMessageResponse;
var bool m_bIsExitingCover;
var bool m_bIsMakingCover;
var bool m_bIsPawnNonCombatPeeking;
var bool bNotResponsive;
var bool bNotifyAction;
var bool bNoSlowDown;
var bool bJumpMode;
var bool bSwitchFocus;
var bool bListFilled;
var bool bFirstTime;
var bool bAtLeastOneValid;
var bool m_bWantsToReact;
var bool m_bIsLastForwardReactionSurprise;
var bool m_bSearchRight;
var bool m_bRestrictionEnabled;
var bool m_bIsInAction;
var bool m_bIsOutOfSyncFromLeader;
var int m_iTacticData;
var Vector m_vSearchLocation;
var float m_fMaxDistanceFromSearchLoc;
var R6GoalList_Ptr m_pGoalList;
var float EnvironmentCheckTimer;
var array<R6AIController> aoCloseControllers;
var array<ReactionStimuli> m_aStimuli;
var R6InteractiveDoor m_Door;
var R6Pawn m_pawnToFollow;
var Vector m_vFormationDest;
var int m_iTeamMemberNumber;
var float m_fCoverFocus;
var int m_iAdjustedAngle;
var Vector m_vAdjustedAngle;
var Vector m_vPositionWhenAngleCalculated;
var int m_iCurrentCorner;
var float m_fApproachAngle;
var float m_fDistFromCorner;
var Vector m_vCornerApproachPosition;
var int m_iCoverMin;
var int m_iCoverMax;
var array<int> m_iRiskPointCoverList;
var float m_fCoverTimer;
var int m_iCurrentlyCovering;
var int m_iCurrentlyCoveringTeammate;
var Vector m_vRiskPointLineCheckStart;
var int m_iCoverListPasses;
var float m_fCoverListDoneTimer;
var int m_iLastMotionTick;
var Vector m_vInvestigatingLocation;
var Vector m_vOriginalBasicPos;
var Rotator m_rOriginalBasicRot;
var float m_fIdleStartTimer;
var float m_fIdleActionTimer;
var float m_fIdleActionTimeLimit;
var float m_fIdleActionTimeBase;
var array<float> m_aProbaActionChoice;
var float m_fGrenadeAngle;
var float m_fGrenadeSpeed;
var float m_fLostTime;
var array<sUnsafeTriangle> m_aUnsafeTriangle;
var array<Vector> m_avThreatLocation;
var sTacticSwitchInfo m_TacticSwitchInfo;
var float m_fLastCombatSRFailedTime;
var int m_iZoneForConstraint;
var ENavMesh m_pNavMeshForConstraint;
var Vector m_vClearLocation;
var R6ActionManager m_pActionManager;
var int m_iNonSpecialMoveCount;
var int m_iCombatActionBehaviourInfo;
var float m_fBehaviourTimer;
var array<int> m_iActionCounts;
var Vector m_vCalculatedActionLocation;
var Vector m_vCalculatedActionTargetLocation;
var int m_iCalculatedCoverIndex;
var native Pointer m_pCurrentAction;
var Vector m_vStopToShootOldVelocity;
var array<R6TeamCommunication> m_aTeamMessageSentQueue;
var array<R6TeamCommunication> m_aTeamMessageReceivedQueue;
var float m_fCommunicationRequestTimer;
var float m_fWaitForTeamMessageResponseTimer;
var string m_strMessage;
var float m_fClearMessageStringTimer;
var float m_fPlayMessageTimer;
var R6TeamCommunication m_pComTemplate;
var native Pointer m_pSpecialCaseCoverSeg;
var Actor m_pCoverActor;
var float m_fLastPeekFromCoverTime;
var float m_fPeekFromCoverStartTime;
var float m_fPeekFromCoverTime;
var float m_fResetPeekTime;
var float m_fEnterCoverTime;
var float m_fUnCrouchInvalidTime;
var Vector m_vCurrentCoverLocation;
var native Pointer m_pDesiredCoverSeg;
var Vector m_vDesiredCoverLocation;
var ENavMesh PendingNavMesh;
var int PendingNavIndex;
var ENavMesh m_pLastDestinationNavMesh;
var Vector m_vLastMoveToDestination;
var Vector m_vLeaderInteractionDest;
var NavigationData m_NavData;
var PathFindingData m_PFindingData;
var PathFollowingData m_PFollowingData;
var array<bbox> debugBoxList;
var array<Vector> debugVectors;
var int LastGoalStatus;
var name LastGoalID;
var WaitForGoalDesc m_LastWaitForGoal;
var Vector m_vFireLocation;
var Vector m_vOffsetFireLocation;
var Vector PrevStrictFocus;
var Vector AimOriginalDir;
var array<FocusPoint> FocusPointList;
var int FocusFrameCount;
var float FocusTimer;
var int invalidCounter;
var float m_fLastFramePatrolMoveRatioMult;
var float m_fMovementNoiseSeed;
var int m_iLastZombieTacticSwitch;
var R6RequestNavMeshPath_Ptr m_pRequestNavMeshPath;
var R6ComputedCoverData_Ptr m_pComputedCoverData;
var R6ComputedCornerData_Ptr m_pComputedCornerData;
var R6ComputedFindPath_Ptr m_pComputedSafePathData;
var R6ComputedSearchData_Ptr m_pComputedSearchData;
var R6ComputedAmbushData_Ptr m_pComputedAmbushData;
var R6ComputedAdvanceData_Ptr m_pComputedAdvanceData;
var R6ComputedNavMeshPathData_Ptr m_pComputedNavMeshPathData;
var float m_fBlindReactionTimer;
var float m_fSeeGrenadeReactionTimer;
var float m_fThrowGrenadeTimer;
var Vector m_vTearGasLocation;
var float m_fLastTimeRecievedDamage;
var float m_fBeingSurpressedTimer;
var float m_fFailSafeNotifyLeaderTimer;
var float m_fLastForwardReactionTime;

// Export UR6AIController::execInitialSetup(FFrame&, void* const)
native function InitialSetup();

// Export UR6AIController::execChooseToInteract(FFrame&, void* const)
native final function bool ChooseToInteract(R6InteractiveActor pInteractActor);

// Export UR6AIController::execUpdateMoveTo(FFrame&, void* const)
native final function UpdateMoveTo(name GoalID, optional Actor.ER6MoveFlags eMoveFlag, optional Vector vDestination, optional bool bKeepFocus, optional bool bBackward);

// Export UR6AIController::execAddGoalMoveFromIdle(FFrame&, void* const)
native final function AddGoalMoveFromIdle(name GoalID, Vector vDestination, array<byte> aAnimSequence);

// Export UR6AIController::execAddGoalKismet(FFrame&, void* const)
native final function AddGoalKismet(name GoalID, bool bConcurrent, R6InteractiveActor InteractObject);

// Export UR6AIController::execAddGoalThrowGrenade(FFrame&, void* const)
native final function AddGoalThrowGrenade(name GoalID, bool bConcurrent, Vector vTargetLocation, R6EngineEnums.EGrenadeType eThrowGrenadeType, optional bool bIsThrowTowardsDir, optional Actor pTarget);

// Export UR6AIController::execAddGoalSetBreachingCharge(FFrame&, void* const)
native final function AddGoalSetBreachingCharge(name GoalID, bool bConcurrent, optional Actor pTarget);

// Export UR6AIController::execAddGoalDetonateBreachingCharge(FFrame&, void* const)
native final function AddGoalDetonateBreachingCharge(name GoalID, bool bConcurrent);

// Export UR6AIController::execAddGoalScopeDoor(FFrame&, void* const)
native final function AddGoalScopeDoor(name GoalID, bool bConcurrent, optional Actor pTarget);

// Export UR6AIController::execAddGoalWait(FFrame&, void* const)
native final function AddGoalWait(name GoalID, bool bConcurrent, optional Vector vFocus, optional float fTimer, optional Actor pTarget, optional bool a_bIndefiniteWait);

// Export UR6AIController::execWaitForGoal(FFrame&, void* const)
native final latent function WaitForGoal(optional Actor.GoalType Type, optional name Label, optional name statename, optional name GoalID);

// Export UR6AIController::execActivateStunReaction(FFrame&, void* const)
native final function ActivateStunReaction(Vector vOrigin, optional float fDesiredDuration);

// Export UR6AIController::execActivateChokeReaction(FFrame&, void* const)
native final function ActivateChokeReaction(Vector vOrigin, optional float fDesiredDuration);

// Export UR6AIController::execActivateFireReaction(FFrame&, void* const)
native final function ActivateFireReaction(Vector vOrigin);

// Export UR6AIController::execActivateFlinchReaction(FFrame&, void* const)
native final function ActivateFlinchReaction();

// Export UR6AIController::execIsAScriptZombie(FFrame&, void* const)
native final function bool IsAScriptZombie();

// Export UR6AIController::execDoesWeaponNeedSupressorToggle(FFrame&, void* const)
native final function bool DoesWeaponNeedSupressorToggle(optional int iSlotCheck);

function NotifyAction()
{
    bNotifyAction = true;
    return;
}

event PostBeginPlay()
{
    PostBeginPlay();
    SightCounter = -0.1000000;
    // End:0x30
    if(m_PawnRepInfo != none)
    {
        m_PawnRepInfo.Destroy();
        m_PawnRepInfo = none;
    }
    m_PawnRepInfo = __NFUN_278__(Class'R6PawnReplicationInfo');
    // End:0x80
    if(m_PawnRepInfo != none)
    {
        R6PawnReplicationInfo(m_PawnRepInfo).m_ControllerOwner = self;
        // End:0x80
        if(!m_bSpawned)
        {
            m_PawnRepInfo.SetDeleteOnReset(false);
        }
    }
    return;
}

function Possess(Pawn aPawn, bool bVehicleTransition)
{
    Possess(aPawn, bVehicleTransition);
    m_R6Pawn = R6Pawn(aPawn);
    CurrentNavIndex = -1;
    m_PFindingData.m_iGoalNavIndex = -1;
    m_PFindingData.m_bNeedNewPath = true;
    EnvironmentCheckTimer = 0.2500000 * FRand();
    // End:0x8C
    if(m_R6Pawn != none)
    {
        m_vOriginalBasicPos = m_R6Pawn.Location;
        m_rOriginalBasicRot = m_R6Pawn.Rotation;
    }
    // End:0xCF
    if(!bVehicleTransition)
    {
        InitialSetup();
        m_R6Pawn.m_pTeamManager = R6GameInfo(WorldInfo.Game).GetTeamManager(m_R6Pawn);
    }
    return;
}

event NotifyShotJustMissed(Pawn pInstigatorPawn)
{
    local EAIEvent AIEvent;

    // End:0x68
    if(m_R6Pawn.m_pTeamManager != none)
    {
        AIEvent.m_eEventType = 39;
        AIEvent.m_vEventLocation = pInstigatorPawn.Location;
        AIEvent.m_pEventTarget = pInstigatorPawn;
        m_R6Pawn.m_pTeamManager.NotifyTeamManager(self, AIEvent);
    }
    return;
}

function Trigger(Actor other, Pawn EventInstigator, optional name EventID)
{
    return;
}

event SeePlayer(Pawn SeenPlayer)
{
    return;
}

function plog(coerce string S)
{
    return;
}

function Timer()
{
    return;
}

event EnemyNotVisible()
{
    return;
}

function Revive()
{
    return;
}

// Export UR6AIController::execDisplayGoalList(FFrame&, void* const)
native final function DisplayGoalList(HUD HUD, out float out_YL, out float out_YPos);

// Export UR6AIController::execTakeDamageEvent(FFrame&, void* const)
native final function TakeDamageEvent(R6Pawn Attacker, Class DamageType, Vector HitLocation);

// Export UR6AIController::execGrenadeThrownEvent(FFrame&, void* const)
native final function GrenadeThrownEvent(R6ProjectileGrenade thrownProjectile);

event ReloadWeapon()
{
    // End:0x46
    if(m_R6Pawn.m_R6Weapon != none)
    {
        m_R6Pawn.m_R6Weapon.ForceReload();
        m_R6Pawn.m_R6Weapon.AddAmmunition();
    }
    return;
}

event UpdateVisionMode(R6EngineEnums.EVisionMode EVisionMode, optional R6EngineEnums.EVisionModeAction eAction)
{
    m_CurrentVisionMode = EVisionMode;
    return;
}

// Export UR6AIController::execGetVisionMode(FFrame&, void* const)
native function R6EngineEnums.EVisionMode GetVisionMode();

// Export UR6AIController::execDEBUG_SwitchMood(FFrame&, void* const)
native final function DEBUG_SwitchMood();

event UseDoor(R6InteractiveDoor pDoor, R6InteractiveDoor.EUseDoor eUse)
{
    m_Door = pDoor;
    switch(eUse)
    {
        // End:0x28
        case 0:
            GotoState('s_Door', 'OpeningDoor');
            // End:0x41
            break;
        // End:0x3E
        case 1:
            GotoState('s_Door', 'CloseDoor');
            // End:0x41
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    DisplayDebug(HUD, out_YL, out_YPos);
    DisplayGoalList(HUD, out_YL, out_YPos);
    return;
}

function NotifyKilled(Controller Killer, Controller Killed, Pawn KilledPawn)
{
    // End:0x25
    if(Pawn != none)
    {
        Pawn.TriggerEventClass(Class'Engine.SeqEvent_SeeDeath', KilledPawn);
    }
    return;
}

// Export UR6AIController::execUpdateMoveToDestination(FFrame&, void* const)
native function UpdateMoveToDestination();

auto state s_Default
{    stop;
}

state s_Inert
{    stop;
}

state s_Dead extends s_Inert
{    stop;
}

state s_Incapacitated extends s_Inert
{    stop;
}

state s_Door
{
    function EndState(name NextStateName)
    {
        m_Door = none;
        m_bInteractiveObject = false;
        return;
    }
OpeningDoor:

    m_Door.OpenBy(m_R6Pawn);
    Sleep(0.5000000);
    GotoState('s_Default');
    stop;
CloseDoor:


    stop;                
}

defaultproperties
{
    m_fDistBackWard=-1.0000000
    m_iCurrentCorner=-1
    m_iCurrentlyCovering=-1
    m_iCoverListPasses=-1
    m_fCoverListDoneTimer=-1.0000000
    m_iLastMotionTick=-5
    TickGroup=1
}