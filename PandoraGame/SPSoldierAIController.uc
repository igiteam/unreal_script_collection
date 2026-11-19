class SPSoldierAIController extends SPAIController
    native;

const MaxEnemies = 36;

enum EAggressionMode
{
    eamForcedLow,                   // 0
    eamDefault,                     // 1
    eamHigh,                        // 2
    eamForcedHigh,                  // 3
    EAggressionMode_MAX             // 4
};

struct native SPEnemyData
{
    var native Pointer EnemyInfo;
    var bool AtVertex;
    var bool HasRangeAttacks;
    var native Pointer EnemyNeighborhood;
    var Vector DirectionToSource;
    var bool bIsAtCover;
    var float minDistanceAllowedToHostile;
    var float minDistanceAllowedToHostileSQ;
    var bool bPerformSurroundCheck;
    var int themToMeLOSMask;
    var int meToThemLOSMask;

    structdefaultproperties
    {
        AtVertex=false
        HasRangeAttacks=false
        DirectionToSource=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        bIsAtCover=false
        minDistanceAllowedToHostile=0.0000000
        minDistanceAllowedToHostileSQ=0.0000000
        bPerformSurroundCheck=false
        themToMeLOSMask=0
        meToThemLOSMask=0
    }
};

struct native DestinationInfo
{
    var Vector Loc;
    var SPCoverNode Cover;
    var int VertexID;
    var native Pointer pEntityData;
    var bool bEvaluateAsCover;
    var bool bDefendAreaOnly;
    var Vector TargetLocation;
    var float defendAreaWeight;
    var bool bMustHaveLOSToEnemy;
    var float preferredRangeToTarget;
    var float minRangeToTarget;
    var float maxRangeToTarget;
    var float RangeToTargetWeight;
    var float maxCoverRangeToUsSQ;
    var float maxNonCoverRangeToUsSQ;
    var float oneOverMaxCoverRangeToUsSQ;
    var float oneOverMaxNonCoverRangeToUsSQ;
    var bool bExcludeCoverOutOfRangeToUs;
    var bool bExcludeNonCoverOutOfRangeToUs;
    var float rangeToUsWeight;
    var float rangeToSpotWeight;
    var Vector desiredSpot;
    var float maxRangeToSpotSQ;
    var float oneOverMaxRangeToSpotSQ;
    var float CurrentDestinationWeight;
    var float ratingForHostilesTooClose;
    var float ratingForHostileBehindUs;
    var float ICanShootThemWeight;
    var float ICantShootThemWeight;
    var float TheyCanShootMeWeight;
    var float TheyCantShootMeWeight;
    var float CurrentCoverWeight;
    var float PreviousCoverWeight;
    var bool bAllowStandingCover;
    var bool bAllowLowCover;
    var float OutsideOfAimProfileWeight;
    var bool bUseSidednessTest;
    var bool bDontUseSidednessOnCover;
    var Vector SidednessTargetPoint;
    var Vector SidednessSourcePoint;
    var float SidednessWeight;

    structdefaultproperties
    {
        Loc=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Cover=none
        VertexID=0
        bEvaluateAsCover=false
        bDefendAreaOnly=false
        TargetLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        defendAreaWeight=0.0000000
        bMustHaveLOSToEnemy=false
        preferredRangeToTarget=0.0000000
        minRangeToTarget=0.0000000
        maxRangeToTarget=0.0000000
        RangeToTargetWeight=0.0000000
        maxCoverRangeToUsSQ=0.0000000
        maxNonCoverRangeToUsSQ=0.0000000
        oneOverMaxCoverRangeToUsSQ=0.0000000
        oneOverMaxNonCoverRangeToUsSQ=0.0000000
        bExcludeCoverOutOfRangeToUs=false
        bExcludeNonCoverOutOfRangeToUs=false
        rangeToUsWeight=0.0000000
        rangeToSpotWeight=0.0000000
        desiredSpot=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        maxRangeToSpotSQ=0.0000000
        oneOverMaxRangeToSpotSQ=0.0000000
        CurrentDestinationWeight=0.0000000
        ratingForHostilesTooClose=0.0000000
        ratingForHostileBehindUs=0.0000000
        ICanShootThemWeight=0.0000000
        ICantShootThemWeight=0.0000000
        TheyCanShootMeWeight=0.0000000
        TheyCantShootMeWeight=0.0000000
        CurrentCoverWeight=0.0000000
        PreviousCoverWeight=0.0000000
        bAllowStandingCover=false
        bAllowLowCover=false
        OutsideOfAimProfileWeight=0.0000000
        bUseSidednessTest=false
        bDontUseSidednessOnCover=false
        SidednessTargetPoint=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        SidednessSourcePoint=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        SidednessWeight=0.0000000
    }
};

struct native TrackedGrenadeEntry
{
    var SPGrenadePersistent pGrenade;
    var float Radius;

    structdefaultproperties
    {
        pGrenade=none
        Radius=0.0000000
    }
};

struct native DamageAtCoverEntry
{
    var SPCoverNode CoverNode;
    var float DamageReceived;
    var float EndInvalidTime;

    structdefaultproperties
    {
        CoverNode=none
        DamageReceived=0.0000000
        EndInvalidTime=0.0000000
    }
};

/** *********************************************************************** VARIABLE DECLARATIONS *********************************************************************** Cover point vars */
var(AI) float CoverSearchRadius;
var Vector LastWalkPathLoc;
var(AI) bool bStandAndAttackOnly;
var(AI) bool bNoAttack;
var bool m_bHitTimeOut;
var bool m_bCaughtFireTimeOut;
var bool m_bCachedIsEnemyPlayerTooClose;
var bool m_bAlreadyTurnedToRunWhilePathing;
var bool m_bHasStartedStrafingOnMove;
var bool m_bIgnoreUnderFireMeterWhileMoving;
var bool m_bHasGrenadeInHand;
var bool m_bDisableUpdateTargetting;
var NavigationPoint m_oldDefendAreaKyVertID;
var Actor m_DestructibleTarget;
var Actor m_lastDestructibleTarget;
var float m_DestructibleTargetTime;
var Actor m_knockObstacle;
var Vector m_knockVector;
var name m_aimQuadrant;
var DestinationInfo tempDestinationInfo;
var SPEnemyData m_Enemies[36];
var int m_NumEnemies;
var int m_cachedEnemyPlayerIndex;
var float LastCacheEnemiesTime;
var Vector m_standDestinationLoc;
var int m_standDestinationID;
var SPCoverNode m_reservedCover;
var int m_semiAutoBurstCountLeft;
var SoldierPawn m_SoldierPawn;
var float m_timeLeftToUpdateTargets;
var float m_timeToSwitchTargetsAtCover;
var float m_strafeEndTime;
var Vector m_dirToLastSuppressionPlane;
var Vector m_suggestedGrenadeThrowLocation;
var int m_suggestedGrenadePitchAdjustment;
var float m_timeToNextGrenadeThrow;
var array<TrackedGrenadeEntry> m_trackedGrenades;
var float m_lastSuggestReevaluateTime;
var float m_lastEnemyTooCloseReevaluateTime;
var array<DamageAtCoverEntry> m_invalidatedCoverListFromDamage;
var SPSoldierAIController.EAggressionMode m_aggressionLevel;
var float m_lastValidHighAggressionTargetTime;

// Export USPSoldierAIController::execIsPawnValidTargetForHighAggression(FFrame&, void* const)
native final function bool IsPawnValidTargetForHighAggression(Pawn thePawn);

// Export USPSoldierAIController::execIsCoverInvalidDueToDamage(FFrame&, void* const)
native final function bool IsCoverInvalidDueToDamage(SPCoverNode pCover);

// Export USPSoldierAIController::execReceivedDamageAtCover(FFrame&, void* const)
native final function bool ReceivedDamageAtCover(SPCoverNode pCover, int Damage);

// Export USPSoldierAIController::execValidEnemiesExist(FFrame&, void* const)
native final function bool ValidEnemiesExist();

// Export USPSoldierAIController::execIsCoverAngleValidAgainstEnemy(FFrame&, void* const)
native final function bool IsCoverAngleValidAgainstEnemy(SPCoverNode inNode, Pawn daEnemy, optional int bUseFiringAngles, optional out float enemyDot);

// Export USPSoldierAIController::execReserveCover(FFrame&, void* const)
native final function bool ReserveCover(SPCoverNode newCover);

// Export USPSoldierAIController::execIsValidCover(FFrame&, void* const)
native function bool IsValidCover(SPCoverNode Cover, optional bool bDontCheckInsideDefendArea);

// Export USPSoldierAIController::execHasValidReservedCover(FFrame&, void* const)
native final function bool HasValidReservedCover(optional bool bNoEnemyValidation);

// Export USPSoldierAIController::execClearReservedCover(FFrame&, void* const)
native final function ClearReservedCover();

// Export USPSoldierAIController::execFindBestEnemyForMyCover(FFrame&, void* const)
native final function FindBestEnemyForMyCover(bool bForce);

// Export USPSoldierAIController::execGetDestinationID(FFrame&, void* const)
native final function bool GetDestinationID(out int VertexID);

// Export USPSoldierAIController::execGetDestinationLocation(FFrame&, void* const)
native final function bool GetDestinationLocation(out Vector OutLocation);

// Export USPSoldierAIController::execUpdateTargetAndFocusWhileMoving(FFrame&, void* const)
native final function bool UpdateTargetAndFocusWhileMoving();

// Export USPSoldierAIController::execCheckForPathObstructions(FFrame&, void* const)
native final function CheckForPathObstructions();

// Export USPSoldierAIController::execJumpIfNeeded(FFrame&, void* const)
native final function JumpIfNeeded();

// Export USPSoldierAIController::execGetAimQuadrant(FFrame&, void* const)
native final function name GetAimQuadrant();

// Export USPSoldierAIController::execFindBestDestination(FFrame&, void* const)
native function bool FindBestDestination(out DestinationInfo Info);

// Export USPSoldierAIController::execUpdateHidingVisibility(FFrame&, void* const)
native final function UpdateHidingVisibility(PandoraPlayerController Shooter, bool bVisible);

// Export USPSoldierAIController::execCanClassMoveAndAttack(FFrame&, void* const)
native function bool CanClassMoveAndAttack();

// Export USPSoldierAIController::execExtractSuppressionInfo(FFrame&, void* const)
native final function ExtractSuppressionInfo(out SuppressionMemory Suppression);

// Export USPSoldierAIController::execCanClassUseCoverType(FFrame&, void* const)
native function bool CanClassUseCoverType(CoverLink.ECoverType CoverType, bool bAttacking);

// Export USPSoldierAIController::execShouldThrowGrenadeAtEnemy(FFrame&, void* const)
native function bool ShouldThrowGrenadeAtEnemy();

// Export USPSoldierAIController::execGetGrenadeThrowVelocity(FFrame&, void* const)
native final function Vector GetGrenadeThrowVelocity(const out Vector throwStartLocation);

// Export USPSoldierAIController::execIsPointWithinPotentialAimLimits(FFrame&, void* const)
native final function bool IsPointWithinPotentialAimLimits(const out Vector TargetPoint, SPCoverNode CoverNode, CoverLink.ECoverAction actionType);

// Export USPSoldierAIController::execHasValidCover(FFrame&, void* const)
native final function bool HasValidCover();

// Export USPSoldierAIController::execEnemyIsTarget(FFrame&, void* const)
native final function bool EnemyIsTarget();

// Export USPSoldierAIController::execCanFireAtEnemyFrom(FFrame&, void* const)
native final function bool CanFireAtEnemyFrom(const out Vector chkLocation, optional bool bNoEnemyValidation, optional bool bDynamicBlockersOnly);

// Export USPSoldierAIController::execCachedCanFireAt(FFrame&, void* const)
native final function bool CachedCanFireAt(Pawn TargetPawn, optional out Actor HitActor, optional Vector ChkLoc, optional bool bAllowFudge);

// Export USPSoldierAIController::execCachedCanFireAtEnemy(FFrame&, void* const)
native final function bool CachedCanFireAtEnemy(optional bool bNoEnemyValidation, optional bool bAllowFudge);

// Export USPSoldierAIController::execGetMaxVerticalAngleDifferenceForFiring(FFrame&, void* const)
native function float GetMaxVerticalAngleDifferenceForFiring();

// Export USPSoldierAIController::execGetMaxHorizontalAngleDifferenceForFiring(FFrame&, void* const)
native function float GetMaxHorizontalAngleDifferenceForFiring();

// Export USPSoldierAIController::execShouldIFire(FFrame&, void* const)
native function bool ShouldIFire(out int bHorizontallyRestricted, out int bVerticallyRestricted);

// Export USPSoldierAIController::execNewTargetAdded(FFrame&, void* const)
native function NewTargetAdded(int Idx);

// Export USPSoldierAIController::execReactToSuppression(FFrame&, void* const)
native function ReactToSuppression(out SuppressionMemory Suppression, const Vector currentMovePoint, const Vector finalPoint, Actor finalGoal, optional bool bOnlyAllowLeftRightDodge);

// Export USPSoldierAIController::execGetAimDir(FFrame&, void* const)
native function Rotator GetAimDir();

// Export USPSoldierAIController::execGetBestEnemy(FFrame&, void* const)
native function Pawn GetBestEnemy(array<EnemyListInfo> enemyList, float MaxDistance, bool bTestOnly, out int outBestEnemyIdx, out float outBestEnemyDist);

// Export USPSoldierAIController::execUpdateTargetting(FFrame&, void* const)
native final function UpdateTargetting(float DeltaTime);

// Export USPSoldierAIController::execControlAggressionLevel(FFrame&, void* const)
native final function ControlAggressionLevel();

// Export USPSoldierAIController::execUpdateImmediateResponseEvents(FFrame&, void* const)
native final function UpdateImmediateResponseEvents(float DeltaTime);

// Export USPSoldierAIController::execAddNearbyGrenade(FFrame&, void* const)
native final function AddNearbyGrenade(SPGrenadePersistent theGrenade, float Radius);

// Export USPSoldierAIController::execHasValidGrenadeToReactTo(FFrame&, void* const)
native final function bool HasValidGrenadeToReactTo(const out Vector pawnLocation);

// Export USPSoldierAIController::execIsValidGrenadeToReactTo(FFrame&, void* const)
native final function bool IsValidGrenadeToReactTo(SPGrenadePersistent pGrenade, float Radius, const out Vector pawnLocation);

// Export USPSoldierAIController::execFindAvoidGrenadeDestination(FFrame&, void* const)
native final function bool FindAvoidGrenadeDestination(out Vector Loc);

// Export USPSoldierAIController::execDoWePreferFullVisibilityToAttack(FFrame&, void* const)
native function bool DoWePreferFullVisibilityToAttack();

event EnemyIsTooClose()
{
    //return;    
}

event AcquiredNewEnemy()
{
    //return;    
}

event bool WantsToLookForCover()
{
    return true;
    //return ReturnValue;    
}

function EnableAI(optional bool bDontResetPhysics, optional bool bDontResetSceneAnims)
{
    m_SoldierPawn.HeadTrackComponent.m_GlobalTurnOffHeadTracking = true;
    super.EnableAI(bDontResetPhysics, bDontResetSceneAnims);
    //return;    
}

function SoftEnableAI()
{
    m_SoldierPawn.HeadTrackComponent.m_GlobalTurnOffHeadTracking = true;
    super.SoftEnableAI();
    //return;    
}

function DisableAI(optional bool bDontResetPhysics, optional bool bDontResetSceneAnims)
{
    m_SoldierPawn.HeadTrackComponent.m_GlobalTurnOffHeadTracking = false;
    super.DisableAI(bDontResetPhysics, bDontResetSceneAnims);
    //return;    
}

function SoftDisableAI()
{
    m_SoldierPawn.HeadTrackComponent.m_GlobalTurnOffHeadTracking = false;
    super.SoftDisableAI();
    //return;    
}

function SceneFinished()
{
    m_SoldierPawn.HeadTrackComponent.m_GlobalTurnOffHeadTracking = true;
    super.SceneFinished();
    //return;    
}

event UnPossess()
{
    // End:0x12
    if(m_SoldierPawn != none)
    {
        m_SoldierPawn = none;
    }
    super(Controller).UnPossess();
    //return;    
}

function Tick(float ElapsedTime)
{
    // End:0x45
    if((!m_bAIDisabled && Pawn != none) && Pawn.Health > 0)
    {
        UpdateTargetting(ElapsedTime);
        UpdateImmediateResponseEvents(ElapsedTime);
    }
    super.Tick(ElapsedTime);
    //return;    
}

function bool CanStepAsideFor(SPPawn pawnToStepAsideFor)
{
    local SPSoldierAIController inputAIController;

    // End:0x52
    if(PlayerPawn(pawnToStepAsideFor) == none)
    {
        inputAIController = SPSoldierAIController(pawnToStepAsideFor.Controller);
        // End:0x52
        if((inputAIController == none) || !inputAIController.AreWeSteppingAsideForPawn())
        {
            return false;
        }
    }
    return super.CanStepAsideFor(pawnToStepAsideFor);
    //return ReturnValue;    
}

function OnOverrideAggressionLevel(SeqAct_OverrideAggressionLevel Action)
{
    switch(Action.AggressionLevel)
    {
        // End:0x28
        case 0:
            ClearBadVertexPairs();
            m_aggressionLevel = 0;
            // End:0x73
            break;
        // End:0x60
        case 1:
            // End:0x5D
            if((int(m_aggressionLevel) == int(0)) || int(m_aggressionLevel) == int(3))
            {
                ClearBadVertexPairs();
                m_aggressionLevel = 1;
            }
            // End:0x73
            break;
        // End:0x70
        case 2:
            m_aggressionLevel = 3;
            // End:0x73
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}

final function ForceToSeeIfPlayer(Pawn inPawn)
{
    local PandoraPlayerController PlayerController;

    // End:0x78
    if(inPawn != none)
    {
        PlayerController = PandoraPlayerController(inPawn.Controller);
        // End:0x78
        if(PlayerController != none)
        {
            // End:0x78
            if(VSizeSq(Pawn.Location - inPawn.Location) < float(1000 * 1000))
            {
                SeePlayer(inPawn);
            }
        }
    }
    //return;    
}

function float RateWeapon(Weapon inWeapon)
{
    // End:0x19
    if(SPGrenadeLauncherPersistent(inWeapon) != none)
    {
        return -1.0000000;        
    }
    else
    {
        return super.RateWeapon(inWeapon);
    }
    //return ReturnValue;    
}

function float GetUnderFireMeterAdjustementForHit()
{
    return m_SoldierPawn.m_SoldierGDData.UnderFireAdjustmentForBeingHit;
    //return ReturnValue;    
}

function float GetUnderFireMeterAdjustementForNearMiss()
{
    return m_SoldierPawn.m_SoldierGDData.UnderFireAdjustmentForNearMiss;
    //return ReturnValue;    
}

function float GetRandomChanceToClearUnderFireMeter()
{
    return m_SoldierPawn.m_SoldierGDData.DefaultRandomChanceToResetUnderFireMeter;
    //return ReturnValue;    
}

function float GetDurationToHoldUnderFireMeterAfterBeingShot()
{
    return m_SoldierPawn.m_SoldierGDData.DefaultUnderFireMeterPreventDecayForDurationAfterBeingShot;
    //return ReturnValue;    
}

event bool IsSuppressionValid(SPPawn Originator, const out Vector Origin, const out Vector End)
{
    // End:0x35
    if((Originator.Controller != none) && IsFriendly(Originator.Controller))
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function bool AllowedToReactToSuppression(out SuppressionMemory Suppression)
{
    return true;
    //return ReturnValue;    
}

event SuppressionDetected(out SuppressionMemory Suppression)
{
    local Vector V;

    // End:0x16
    if(!AllowedToReactToSuppression(Suppression))
    {
        return;
    }
    ForceToSeeIfPlayer(Suppression.Instigator);
    ApplyDamageToTargetTable(Suppression.Instigator.Controller, m_SoldierPawn.m_SoldierGDData.TreatSuppressionAsDamageAmount, true, m_SoldierPawn.m_SoldierGDData.GetValue(m_SoldierPawn.m_SoldierGDData.BroadcastDamageToSquadMemberRange));
    ExtractSuppressionInfo(Suppression);
    NotifyNearMiss(Suppression.Instigator, none, V);
    //return;    
}

function BreakTimer()
{
    //return;    
}

function SetBreakTimer()
{
    local SPWeapon myWeapon;
    local SPPawn.EEnemyRange eRange;

    myWeapon = SPWeapon(Pawn.Weapon);
    // End:0x109
    if(myWeapon != none)
    {
        eRange = m_SoldierPawn.GetActorRange(GetEnemy(), m_SoldierPawn.m_SoldierGDData.EnemyMaxNearRange, m_SoldierPawn.m_SoldierGDData.EnemyMaxMediumRange);
        // End:0xC3
        if(myWeapon.bSemiAuto)
        {
            // End:0xC0
            if(m_semiAutoBurstCountLeft < 0)
            {
                m_semiAutoBurstCountLeft = m_SoldierPawn.m_SoldierGDData.GetBurstCount(eRange);
            }            
        }
        else
        {
            // End:0x109
            if(!IsTimerActive('BreakTimer'))
            {
                SetTimer(m_SoldierPawn.m_SoldierGDData.GetBurstTime(eRange), false, 'BreakTimer');
            }
        }
    }
    //return;    
}

final function FiringAnimationFinished()
{
    local SPWeapon myWeapon;

    // End:0x0B
    if(m_bAIDisabled)
    {
        return;
    }
    // End:0x45
    if(Pawn != none)
    {
        myWeapon = SPWeapon(Pawn.Weapon);
        // End:0x45
        if(myWeapon != none)
        {
            StopFiring();
        }
    }
    // End:0x52
    if(m_semiAutoBurstCountLeft < 0)
    {
        return;
    }
    m_semiAutoBurstCountLeft--;
    // End:0x79
    if(m_semiAutoBurstCountLeft <= 0)
    {
        BreakTimer();
        m_semiAutoBurstCountLeft = -1;
    }
    //return;    
}

final function bool ShouldPauseInsteadOfBreak()
{
    local SPPawn.EEnemyRange eRange;
    local SPWeapon myWeapon;

    eRange = m_SoldierPawn.GetActorRange(GetEnemy(), m_SoldierPawn.m_SoldierGDData.EnemyMaxNearRange, m_SoldierPawn.m_SoldierGDData.EnemyMaxMediumRange);
    myWeapon = SPWeapon(Pawn.Weapon);
    // End:0x7E
    if(myWeapon == none)
    {
        return true;        
    }
    else
    {
        return m_SoldierPawn.m_SoldierGDData.ShouldPauseInsteadOfBreak(!myWeapon.bSemiAuto, eRange);
    }
    //return ReturnValue;    
}

final function float GetBreakDuration()
{
    local SPPawn.EEnemyRange eRange;
    local SPWeapon myWeapon;
    local float Time;

    eRange = m_SoldierPawn.GetActorRange(GetEnemy(), m_SoldierPawn.m_SoldierGDData.EnemyMaxNearRange, m_SoldierPawn.m_SoldierGDData.EnemyMaxMediumRange);
    myWeapon = SPWeapon(Pawn.Weapon);
    // End:0x87
    if(myWeapon == none)
    {
        Time = 0.0000000;        
    }
    else
    {
        Time = m_SoldierPawn.m_SoldierGDData.GetBreakTime(!myWeapon.bSemiAuto, eRange);
    }
    return Time;
    //return ReturnValue;    
}

final function float GetPauseDuration()
{
    local SPPawn.EEnemyRange eRange;
    local SPWeapon myWeapon;
    local float Time;

    eRange = m_SoldierPawn.GetActorRange(GetEnemy(), m_SoldierPawn.m_SoldierGDData.EnemyMaxNearRange, m_SoldierPawn.m_SoldierGDData.EnemyMaxMediumRange);
    myWeapon = SPWeapon(Pawn.Weapon);
    // End:0x87
    if(myWeapon == none)
    {
        Time = 0.0000000;        
    }
    else
    {
        Time = m_SoldierPawn.m_SoldierGDData.GetPauseTime(!myWeapon.bSemiAuto, eRange);
    }
    return Time;
    //return ReturnValue;    
}

final function bool SetCoverAction(optional Controller targetController, optional bool bTest)
{
    local bool bSetAction;
    local Pawn TargetPawn;
    local Vector viewPt, targetPt;

    // End:0x318
    if((m_currentCover != none) && (GetEnemy()) != none)
    {
        // End:0x46
        if(!CanClassUseCoverType(m_currentCover.CoverType, true))
        {
            ResetCoverAction();
            return false;
        }
        // End:0x69
        if(targetController != none)
        {
            TargetPawn = targetController.Pawn;            
        }
        else
        {
            TargetPawn = GetEnemy();
        }
        targetPt = TargetPawn.GetTargetLocation(Pawn);
        switch(m_currentCover.CoverType)
        {
            // End:0xB1
            case 3:
            // End:0x1D0
            case 2:
                // End:0x14D
                if(m_currentCover.IsPointWithinPrimaryAimProfile(targetPt) && IsPointWithinPotentialAimLimits(targetPt, m_currentCover, 7))
                {
                    viewPt = m_currentCover.GetPeekViewPointFromCoverType(m_currentCover.CoverType, 7);
                    // End:0x14A
                    if(CanFireAt(TargetPawn,, viewPt))
                    {
                        // End:0x13C
                        if(!bTest)
                        {
                            m_currentCoverAction = 7;
                        }
                        bSetAction = true;
                        // End:0x315
                        break;                        
                    }
                    else
                    {
                        // [Explicit Continue]
                        goto J0x315;
                    }
                }
                // End:0x1CD
                if(!bSetAction && m_currentCover.IsPointWithinSecondaryAimProfile(targetPt))
                {
                    viewPt = m_currentCover.GetPeekViewPointFromCoverType(4, 0);
                    // End:0x1CA
                    if(CanFireAt(TargetPawn,, viewPt))
                    {
                        // End:0x1BC
                        if(!bTest)
                        {
                            m_currentCoverAction = 12;
                        }
                        bSetAction = true;
                        // End:0x315
                        break;                        
                    }
                    else
                    {
                        // [Explicit Continue]
                        goto J0x315;
                    }
                }
                // End:0x315
                break;
            // End:0x30F
            case 1:
                // End:0x272
                if(m_currentCover.bLeanLeft)
                {
                    viewPt = m_currentCover.GetPeekViewPointFromCoverType(m_currentCover.CoverType, 5);
                    // End:0x26F
                    if(m_currentCover.IsPointWithinPrimaryAimProfile(targetPt) && CanFireAt(TargetPawn,, viewPt))
                    {
                        // End:0x26F
                        if(!bSetAction)
                        {
                            // End:0x264
                            if(!bTest)
                            {
                                m_currentCoverAction = 5;
                            }
                            bSetAction = true;
                            // [Explicit Continue]
                            goto J0x315;
                        }
                    }                    
                }
                else
                {
                    // End:0x30C
                    if(m_currentCover.bLeanRight)
                    {
                        viewPt = m_currentCover.GetPeekViewPointFromCoverType(m_currentCover.CoverType, 6);
                        // End:0x30C
                        if(m_currentCover.IsPointWithinPrimaryAimProfile(targetPt) && CanFireAt(TargetPawn,, viewPt))
                        {
                            // End:0x30C
                            if(!bSetAction)
                            {
                                // End:0x301
                                if(!bTest)
                                {
                                    m_currentCoverAction = 6;
                                }
                                bSetAction = true;
                                // [Explicit Continue]
                                goto J0x315;
                            }
                        }
                    }
                }
                // End:0x315
                break;
            // End:0xFFFF
            default:
                // End:0x315
                break;
                break;
        }
        J0x315:
        
    }
    else
    {
        ResetCoverAction();
    }
    // End:0x329
    if(!bSetAction)
    {
    }
    return bSetAction;
    //return ReturnValue;    
}

final function ResetCoverAction()
{
    m_currentCoverAction = 0;
    //return;    
}

function NotifyCoverClaimRevoked(SPCoverNode revokedNode)
{
    // End:0x37
    if((revokedNode != none) && (revokedNode == m_currentCover) || revokedNode == m_reservedCover)
    {
        EvaluateSituation();
    }
    //return;    
}

final function ClearCurrentCover()
{
    // End:0x2F
    if(m_currentCover != none)
    {
        m_previousCover = m_currentCover;
        m_currentCover = none;
        m_previousCover.UnClaim(self, false);
    }
    //return;    
}

final function bool OccupyCover(SPCoverNode Cover)
{
    // End:0x17
    if(!IsValidCover(Cover))
    {
        return false;
    }
    // End:0x37
    if(Cover != m_currentCover)
    {
        ClearCurrentCover();
        m_lastCoverTime = AITime;
    }
    m_currentCover = Cover;
    Cover.Claim(self);
    return true;
    //return ReturnValue;    
}

simulated event GetPlayerViewPoint(out Vector out_Location, out Rotator out_Rotation)
{
    super(AIController).GetPlayerViewPoint(out_Location, out_Rotation);
    // End:0x3C
    if(Pawn != none)
    {
        out_Location.Z += Pawn.EyeHeight;
    }
    //return;    
}

function ClearYourMindFunc(optional bool bDontResetPhysics, optional bool bDontResetSceneAnims, optional bool bNoAIMoveToActorLatentClear)
{
    ClearReservedCover();
    ClearCurrentCover();
    super.ClearYourMindFunc(bDontResetPhysics, bDontResetSceneAnims, bNoAIMoveToActorLatentClear);
    //return;    
}

event HitDeathAnimFinished()
{
    //return;    
}

simulated event Destroyed()
{
    ClearReservedCover();
    ClearCurrentCover();
    super.Destroyed();
    //return;    
}

function SetSuppressionConstraints()
{
    m_SuppressionConstraints.ShouldTest = true;
    m_SuppressionConstraints.MaxAvoidanceDistance = 900.0000000;
    m_SuppressionConstraints.Strength = 1.0000000;
    //return;    
}

function SetPathConstraints()
{
    ResetPathConstraints();
    SetSuppressionConstraints();
    //return;    
}

function bool ReserveDestination(const out Vector Loc, Actor GoalActor)
{
    local SPCoverNode asCover;

    asCover = SPCoverNode(GoalActor);
    // End:0x42
    if((asCover != none) && asCover == m_reservedCover)
    {
        m_pendingMoveGoalInfo.bMovingToCover = true;        
    }
    else
    {
        return super.ReserveDestination(Loc, GoalActor);
    }
    return true;
    //return ReturnValue;    
}

function bool CanUseCover()
{
    return true;
    //return ReturnValue;    
}

function NotifyTakeHit(Controller instigatedBy, Vector HitLocation, int Damage, class<DamageType> DamageType, Vector Momentum)
{
    super.NotifyTakeHit(instigatedBy, HitLocation, Damage, DamageType, Momentum);
    // End:0x15F
    if(((Pawn != none) && Damage > 0) && Pawn.Health > 0)
    {
        // End:0x6E
        if(instigatedBy != none)
        {
            ForceToSeeIfPlayer(instigatedBy.Pawn);
        }
        // End:0xB7
        if(class<SPDamageTypeImpactFlame>(DamageType) != none)
        {
            m_SoldierPawn.Health = 0;
            m_SoldierPawn.Died(instigatedBy, DamageType, HitLocation);
            return;            
        }
        else
        {
            // End:0x126
            if(DamageType != Class'SPDamageTypeMeleeAny')
            {
                // End:0x124
                if(IsAtCover(m_currentCover))
                {
                    // End:0x124
                    if(!m_SoldierPawn.m_SoldierGDData.bOnlyReactToPlayerBullets || PlayerController(instigatedBy) != none)
                    {
                        // End:0x124
                        if(!ReceivedDamageAtCover(m_currentCover, Damage))
                        {
                            EvaluateSituation();
                        }
                    }
                }
                return;
            }
        }
        // End:0x14F
        if(IsInState('TakeHit'))
        {
            GotoState('TakeHit', 'RestartHit', false, true);            
        }
        else
        {
            PushState('TakeHit');
        }
    }
    //return;    
}

function TestFunc()
{
    super.TestFunc();
    //return;    
}

function EvaluateSituation()
{
    local int DestVertex;
    local bool bFoundDestination;

    // End:0x28
    if(m_bAIDisabled)
    {
        // End:0x25
        if(!IsInState('AIDisabled'))
        {
            SoftDisableAI();
        }        
    }
    else
    {
        // End:0x57
        if((SPPawn(Pawn) != none) && SPPawn(Pawn).m_bIsAttachedToTentacle)
        {
            return;            
        }
        else
        {
            EvaluateWeapons();
            InitDestinationInfo(tempDestinationInfo);
            // End:0xAD
            if((CheckForEnemy()) || HasValidEnemy(,,, true))
            {
                bFoundDestination = FindBestDestination(tempDestinationInfo);                
            }
            else
            {
                bFoundDestination = FindBestDestination(tempDestinationInfo);
            }
            // End:0x21A
            if(bFoundDestination)
            {
                // End:0x180
                if(tempDestinationInfo.Cover != none)
                {
                    // End:0x17D
                    if((tempDestinationInfo.Cover != m_reservedCover) && tempDestinationInfo.Cover != m_currentCover)
                    {
                        // End:0x17A
                        if(ReserveCover(tempDestinationInfo.Cover))
                        {
                            // End:0x177
                            if(m_currentCover != m_reservedCover)
                            {
                                // End:0x169
                                if(IsInState('Attack_Cover'))
                                {
                                    ClearCurrentCover();
                                    m_bMovingToCover = false;
                                    bForceDesiredRotation = false;                                    
                                }
                                GotoState('Attack_Cover');
                            }                            
                        }                        
                    }                    
                }
                else
                {
                    // End:0x217
                    if(!IsInState('Attack_Stand', true) || (tempDestinationInfo.VertexID != GetCurrentVertex()) && !GetDestinationID(DestVertex) || tempDestinationInfo.VertexID != DestVertex)
                    {
                        m_standDestinationID = tempDestinationInfo.VertexID;
                        m_standDestinationLoc = tempDestinationInfo.Loc;
                        GotoState('Attack_Stand');
                    }
                }                
            }
            else
            {
                // End:0x25A
                if((GetEnemy()) != none)
                {
                    m_standDestinationID = GetCurrentVertex();
                    m_standDestinationLoc = GetKyVertexLocation(m_standDestinationID);
                    GotoState('Attack_Stand');
                    return;                    
                }
                else
                {
                    // End:0x27D
                    if(!IsInState('Idle'))
                    {
                        GotoState('Idle');                        
                    }
                }
            }
        }
    }
    //return;    
}

function bool IsLookingForAttackDestination()
{
    return (GetEnemy()) != none;
    //return ReturnValue;    
}

function InitSuppressionPartOfDestinationInfo(out DestinationInfo theInfo)
{
    theInfo.rangeToSpotWeight = 0.0000000;
    theInfo.maxRangeToSpotSQ = 0.0000000;
    theInfo.oneOverMaxRangeToSpotSQ = 0.0000000;
    theInfo.desiredSpot = vect(0.0000000, 0.0000000, 0.0000000);
    //return;    
}

function InitRangeToUsPartOfDestinationInfo(out DestinationInfo theInfo)
{
    theInfo.maxCoverRangeToUsSQ = m_SoldierPawn.m_SoldierGDData.MaxDistanceToMoveToCover * m_SoldierPawn.m_SoldierGDData.MaxDistanceToMoveToCover;
    // End:0x8A
    if(theInfo.maxCoverRangeToUsSQ > 0.0000000)
    {
        theInfo.oneOverMaxCoverRangeToUsSQ = 1.0000000 / theInfo.maxCoverRangeToUsSQ;        
    }
    else
    {
        theInfo.oneOverMaxCoverRangeToUsSQ = 0.0000000;
    }
    theInfo.maxNonCoverRangeToUsSQ = m_SoldierPawn.m_SoldierGDData.MaxDistanceToMoveToNonCover * m_SoldierPawn.m_SoldierGDData.MaxDistanceToMoveToNonCover;
    // End:0x12A
    if(theInfo.maxNonCoverRangeToUsSQ > 0.0000000)
    {
        theInfo.oneOverMaxNonCoverRangeToUsSQ = 1.0000000 / theInfo.maxNonCoverRangeToUsSQ;        
    }
    else
    {
        theInfo.oneOverMaxNonCoverRangeToUsSQ = 0.0000000;
    }
    theInfo.rangeToUsWeight = m_SoldierPawn.m_SoldierGDData.DistanceToMoveWeight;
    theInfo.bExcludeCoverOutOfRangeToUs = false;
    theInfo.bExcludeNonCoverOutOfRangeToUs = false;
    //return;    
}

function InitDestinationInfo(out DestinationInfo theInfo)
{
    local Pawn MyEnemy;
    local float distanceToTargetSQ;
    local Vector RightVec, favoredDir, targetFacingDir, dirToMe;
    local bool bForceSidednessTest;

    theInfo.preferredRangeToTarget = m_SoldierPawn.m_SoldierGDData.PreferredAttackRange;
    theInfo.minRangeToTarget = m_SoldierPawn.MinShootDist;
    // End:0x91
    if(m_SoldierPawn.CanAttackActorAtAnyDistance(GetEnemy()))
    {
        theInfo.maxRangeToTarget = m_SoldierPawn.MaxShootDist * 3.0000000;        
    }
    else
    {
        theInfo.maxRangeToTarget = m_SoldierPawn.MaxShootDist;
    }
    theInfo.RangeToTargetWeight = m_SoldierPawn.m_SoldierGDData.RangeToTargetWeight;
    InitRangeToUsPartOfDestinationInfo(theInfo);
    theInfo.CurrentDestinationWeight = m_SoldierPawn.m_SoldierGDData.CurrentDestinationWeight;
    theInfo.ratingForHostilesTooClose = m_SoldierPawn.m_SoldierGDData.HostileTooCloseWeight;
    theInfo.ratingForHostileBehindUs = m_SoldierPawn.m_SoldierGDData.HostileBehindUsWeight;
    theInfo.ICanShootThemWeight = m_SoldierPawn.m_SoldierGDData.ICanShootThemWeight;
    theInfo.ICantShootThemWeight = m_SoldierPawn.m_SoldierGDData.ICantShootThemWeight;
    theInfo.TheyCanShootMeWeight = m_SoldierPawn.m_SoldierGDData.TheyCanShootMeWeight;
    theInfo.TheyCantShootMeWeight = m_SoldierPawn.m_SoldierGDData.TheyCantShootMeWeight;
    theInfo.CurrentCoverWeight = m_SoldierPawn.m_SoldierGDData.CurrentCoverWeight;
    theInfo.OutsideOfAimProfileWeight = m_SoldierPawn.m_SoldierGDData.OutsideOfAimProfileWeight;
    InitSuppressionPartOfDestinationInfo(theInfo);
    theInfo.bAllowStandingCover = CanClassUseCoverType(1, IsLookingForAttackDestination());
    theInfo.bAllowLowCover = CanClassUseCoverType(3, IsLookingForAttackDestination());
    theInfo.bUseSidednessTest = false;
    MyEnemy = GetEnemy();
    // End:0x5B2
    if(MyEnemy != none)
    {
        theInfo.PreviousCoverWeight = m_SoldierPawn.m_SoldierGDData.PreviousCoverWeight;
        // End:0x5AF
        if(PlayerPawn(MyEnemy) != none)
        {
            distanceToTargetSQ = m_SoldierPawn.DistanceBetweenCollisionSQ(MyEnemy);
            bForceSidednessTest = m_SoldierPawn.m_SoldierGDData.bAlwaysTryToPreventRunningByPlayer || m_SoldierPawn.m_SoldierGDData.bTryToPreventRunningByPlayerUnlessPlayerTooClose;
            theInfo.bUseSidednessTest = bForceSidednessTest;
            theInfo.bDontUseSidednessOnCover = !theInfo.bUseSidednessTest;
            theInfo.SidednessSourcePoint = Pawn.Location;
            theInfo.SidednessTargetPoint = MyEnemy.Location;
            theInfo.SidednessWeight = m_SoldierPawn.m_SoldierGDData.SidednessWeight;
            // End:0x5AF
            if(distanceToTargetSQ < (m_SoldierPawn.m_SoldierGDData.EnemyMaxNearRange * m_SoldierPawn.m_SoldierGDData.EnemyMaxNearRange))
            {
                dirToMe = Pawn.Location - MyEnemy.Location;
                dirToMe = Normal(dirToMe);
                targetFacingDir = Vector(MyEnemy.Rotation);
                RightVec = targetFacingDir Cross vect(0.0000000, 0.0000000, 1.0000000);
                RightVec = Normal(RightVec);
                favoredDir = (RightVec Dot dirToMe) * RightVec;
                theInfo.SidednessTargetPoint = Pawn.Location - (((favoredDir * 100.0000000) * m_SoldierPawn.m_SoldierGDData.PlayerTooCloseSidestepPercentage) + ((dirToMe * 100.0000000) * (1.0000000 - m_SoldierPawn.m_SoldierGDData.PlayerTooCloseSidestepPercentage)));
                theInfo.preferredRangeToTarget = m_SoldierPawn.m_SoldierGDData.EnemyMaxMediumRange;
                theInfo.bUseSidednessTest = true;
            }
        }        
    }
    else
    {
        theInfo.PreviousCoverWeight = 0.0000000;
    }
    //return;    
}

function GotoMoveToGoalState()
{
    PushState('MoveToGoalWhileAttacking');
    //return;    
}

function GotoMoveToStepAsideLocation()
{
    PushState('MoveToStepAsideLocationState');
    //return;    
}

function bool ShouldIGotoDefendArea(optional bool bInIdleState)
{
    // End:0x0C
    if(bStandAndAttackOnly)
    {
        return false;
    }
    return super.ShouldIGotoDefendArea(bInIdleState);
    //return ReturnValue;    
}

function bool ShouldIPursueEnemy()
{
    return false;
    //return ReturnValue;    
}

function bool CanIScatter(Actor scatterObject, bool bObstacleWasBumped)
{
    local bool bRetval;
    local float Dist;

    bRetval = super.CanIScatter(scatterObject, bObstacleWasBumped);
    // End:0x7D
    if((bRetval == true) && Pawn != none)
    {
        // End:0x3F
        if(bObstacleWasBumped == true)
        {
            return true;
        }
        Dist = VSize(scatterObject.Location - Pawn.Location);
        // End:0x7D
        if(Dist <= (GetObstacleSearchRadius()))
        {
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

function bool CanISmash(Actor SmashTarget, bool bObstacleWasBumped)
{
    // End:0x14
    if(IsOnTopOf(SmashTarget))
    {
        return false;
    }
    // End:0x47
    if(!CheckHistory(SmashTarget, 3, 0.0000000, 3.0000000, 1, 3.0000000, true))
    {
        ClearDestTargetIfObstacle(SmashTarget);
        return false;
    }
    return true;
    //return ReturnValue;    
}

function SPAIController.eObstacleAction GetSmashObstacleAction(SPAIController.eObstacleAction currObstacleAction, Actor obstacle, Actor MyEnemy, bool bObstacleWasBumped)
{
    // End:0x6B
    if((int(currObstacleAction) == int(0)) && Pawn.DoesObjectHaveOATSTag(obstacle, 3))
    {
        // End:0x4F
        if(CanISmash(obstacle, bObstacleWasBumped))
        {
            currObstacleAction = 3;            
        }
        else
        {
            Pawn.RemoveOATSTagFromObjectBITFIELD(obstacle, 8, 3.0000000);
        }
    }
    return currObstacleAction;
    //return ReturnValue;    
}

function bool CanIKnock(Actor knockObject, bool bObstacleWasBumped, optional out int bPreventDisableKnockability)
{
    // End:0x15
    if(!bObstacleWasBumped)
    {
        bPreventDisableKnockability = 1;
        return false;
    }
    // End:0x27
    if(!AllowedToMoveObject(knockObject))
    {
        return false;
    }
    // End:0x48
    if((IsFacing(Pawn, knockObject, 0.2500000)) == false)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function SPAIController.eObstacleAction GetKnockObstacleAction(SPAIController.eObstacleAction currObstacleAction, Actor obstacle, Actor MyEnemy, bool bObstacleWasBumped)
{
    local bool bCanDeal;
    local int bDistanceFailed, bTimeFailed, bAttemptsFailed;

    // End:0xD5
    if((int(currObstacleAction) == int(0)) && Pawn.DoesObjectHaveOATSTag(obstacle, 4))
    {
        // End:0xD5
        if(CanIKnock(obstacle, bObstacleWasBumped))
        {
            bDistanceFailed = 0;
            bTimeFailed = 0;
            bAttemptsFailed = 0;
            bCanDeal = CheckHistory(obstacle, 4, 0.0000000, 2.0000000, 3, 6.0000000, false, bDistanceFailed, bTimeFailed, bAttemptsFailed);
            // End:0xA3
            if(bCanDeal)
            {
                currObstacleAction = 4;                
            }
            else
            {
                // End:0xD5
                if(bObstacleWasBumped && bAttemptsFailed != 0)
                {
                    Pawn.RemoveOATSTagFromObjectBITFIELD(obstacle, 16, 6.0000000);
                }
            }
        }
    }
    return currObstacleAction;
    //return ReturnValue;    
}

function bool DealWithSmashObstacle(Actor obstacle, Pawn MyEnemy, bool bObstacleWasBumped)
{
    return DealWithShootableObstacle(obstacle, 3, MyEnemy, bObstacleWasBumped);
    //return ReturnValue;    
}

function bool DealWithKnockObstacle(Actor obstacle, Pawn MyEnemy, bool bObstacleWasBumped)
{
    // End:0x17
    if(IsInState('ShootAtObstacle'))
    {
        PopState();
    }
    SetKnockObstacle(obstacle);
    PushState('KnockObstacle');
    return true;
    //return ReturnValue;    
}

function bool DealWithObstacleObstacle(Actor obstacle, Pawn MyEnemy, bool bObstacleWasBumped)
{
    local Vector dirNode;
    local float daDot, ColHeight, ColRadius, collisionDist;

    // End:0x170
    if(!bObstacleWasBumped)
    {
        // End:0x39
        if(!Pawn.bJumpCapable || !Pawn.bCanJump)
        {
            return false;
        }
        // End:0x63
        if(Pawn.bIsCrouched || Pawn.bWantsToCrouch)
        {
            return false;
        }
        // End:0x7F
        if(int(Pawn.Physics) != int(1))
        {
            return false;
        }
        // End:0x93
        if(IsOnTopOf(obstacle))
        {
            return false;
        }
        dirNode = obstacle.Location - Pawn.Location;
        daDot = Normal(Pawn.Velocity) Dot Normal(dirNode);
        // End:0xEA
        if(daDot <= 0.9000000)
        {
            return false;
        }
        // End:0x101
        if(obstacle.CollisionComponent == none)
        {
            return false;
        }
        obstacle.GetBoundingCylinder(ColRadius, ColHeight);
        // End:0x13A
        if(ColHeight > Pawn.MaxStepHeight)
        {
            return false;
        }
        collisionDist = Pawn.GetCollisionRadius() + ColRadius;
        // End:0x16E
        if(VSize(dirNode) <= collisionDist)
        {
            return false;
        }
        return false;
    }
    return false;
    //return ReturnValue;    
}

final function ClearDestTargetIfObstacle(Actor obstacle)
{
    // End:0x16
    if(m_DestructibleTarget == obstacle)
    {
        SetDestructibleTarget(none);
    }
    //return;    
}

function bool DealWithShootableObstacle(Actor obstacle, SPAIController.eObstacleAction obstacleAction, Pawn MyEnemy, bool bObstacleWasBumped)
{
    local float daDot, myDistToObstacle;
    local Vector vecToObstacle;

    // End:0xD3
    if(obstacle == m_DestructibleTarget)
    {
        // End:0x2B
        if(m_DestructibleTarget.bDeleteMe)
        {
            SetDestructibleTarget(none);
            return false;
        }
        // End:0xD3
        if((WorldInfo.TimeSeconds - m_DestructibleTargetTime) > 3.0000000)
        {
            CheckHistory(obstacle, obstacleAction, 0.0000000, 3.0000000, 1, 3.0000000, false);
            SetDestructibleTarget(none);
            // End:0xA5
            if(int(obstacleAction) == int(4))
            {
                Pawn.RemoveOATSTagFromObjectBITFIELD(obstacle, 16, 2.0000000);                
            }
            else
            {
                // End:0xD1
                if(int(obstacleAction) == int(3))
                {
                    Pawn.RemoveOATSTagFromObjectBITFIELD(obstacle, 8, 2.0000000);
                }
            }
            return false;
        }
    }
    vecToObstacle = obstacle.Location - Pawn.Location;
    myDistToObstacle = VSize(vecToObstacle);
    // End:0x131
    if(!IsFacing(Pawn, obstacle, 0.2000000))
    {
        ClearDestTargetIfObstacle(obstacle);
        return false;
    }
    // End:0x188
    if(((m_DestructibleTarget != none) && m_DestructibleTarget != obstacle) && myDistToObstacle > VSize(m_DestructibleTarget.Location - Pawn.Location))
    {
        ClearDestTargetIfObstacle(obstacle);
        return false;
    }
    // End:0x1DC
    if(((MyEnemy != none) && m_bAIDisabled == false) && myDistToObstacle > VSize(MyEnemy.Location - Pawn.Location))
    {
        ClearDestTargetIfObstacle(obstacle);
        return false;
    }
    // End:0x28C
    if(((CurrentPath != none) && CurrentPath.Start != none) && CurrentPath.End.Actor != none)
    {
        daDot = Normal(CurrentPath.End.Actor.Location - CurrentPath.Start.Location) Dot Normal(vecToObstacle);
        // End:0x28C
        if(daDot <= 0.0000000)
        {
            ClearDestTargetIfObstacle(obstacle);
            return false;
        }
    }
    SetDestructibleTarget(obstacle);
    return false;
    //return ReturnValue;    
}

final function SetDestructibleTarget(Actor destructibleTarget)
{
    // End:0x2F
    if(m_DestructibleTarget != destructibleTarget)
    {
        m_DestructibleTarget = destructibleTarget;
        m_DestructibleTargetTime = WorldInfo.TimeSeconds;
    }
    //return;    
}

final function Actor GetBestDestructibleTarget()
{
    local int I;
    local Actor chkActor;

    // End:0x0D
    if(Pawn == none)
    {
        return none;
    }
    // End:0x32
    if(m_DestructibleTarget != none)
    {
        DealWithObstacle(m_DestructibleTarget, GetEnemy(), false);
    }
    // End:0x103
    if(((CurrentPath != none) && CurrentPath.Start != none) && CurrentPath.End.Actor != none)
    {
        I = 0;
        J0x7D:

        // End:0x103 [Loop If]
        if(I < CurrentPath.PathBlockers.Length)
        {
            chkActor = CurrentPath.PathBlockers[I].blocker;
            // End:0xF9
            if((chkActor != none) && !chkActor.bDeleteMe)
            {
                DealWithObstacle(chkActor, GetEnemy(), false);
            }
            I++;
            // [Loop Continue]
            goto J0x7D;
        }
    }
    return m_DestructibleTarget;
    //return ReturnValue;    
}

final function SetKnockObstacle(Actor knockableObject)
{
    m_knockObstacle = knockableObject;
    //return;    
}

event MayFall()
{
    //return;    
}

event ActionStateAnimFinished()
{
    //return;    
}

function NotifyKilled(Controller Killer, Controller Killed, Pawn Other)
{
    local Vector Delta;

    // End:0xD0
    if(Killed == self)
    {
        // End:0xD0
        if(m_squad != none)
        {
            // End:0x55
            if(IsAtCover(m_currentCover))
            {
                m_squad.InvalidateCoverDueToDeath(m_currentCover, m_SoldierPawn.m_SoldierGDData.DurationToInvalidateCoverWeDiedAt);                
            }
            else
            {
                // End:0xD0
                if(m_previousCover != none)
                {
                    Delta = Pawn.Location - m_previousCover.Location;
                    // End:0xD0
                    if(VSizeSq(Delta) < (200.0000000 * 200.0000000))
                    {
                        m_squad.InvalidateCoverDueToDeath(m_previousCover, m_SoldierPawn.m_SoldierGDData.DurationToInvalidateCoverWeDiedAt);
                    }
                }
            }
        }
    }
    super.NotifyKilled(Killer, Killed, Other);
    //return;    
}

function NotifyDying()
{
    ClearTimer('TryToReactToNearbyGrenade');
    // End:0x27
    if(IsInState('TakeHit'))
    {
        PopState();
    }
    // End:0x49
    if(!IsInState('ControllerDying'))
    {
        PushState('ControllerDying');
    }
    //return;    
}

final function bool SetPawnActionState(SoldierPawn.ESoldierPawnActionState actionState)
{
    // End:0x22
    if(m_SoldierPawn != none)
    {
        m_SoldierPawn.SetActionState(actionState);
        return true;
    }
    return false;
    //return ReturnValue;    
}

final function bool ClearPawnActionState()
{
    // End:0x1F
    if(m_SoldierPawn != none)
    {
        m_SoldierPawn.SetActionState(0);
        return true;
    }
    return false;
    //return ReturnValue;    
}

final function ResetMovementParameters()
{
    m_bIgnoreUnderFireMeterWhileMoving = false;
    m_bAlreadyTurnedToRunWhilePathing = false;
    m_SoldierPawn.SetMovementType(2);
    //return;    
}

function bool AllowOnlyCheckDynamicActorsInCanFireAt()
{
    return true;
    //return ReturnValue;    
}

function float GetDesiredStepAsideGoalStopConditionPercentage()
{
    return m_SoldierPawn.m_SoldierGDData.DesiredStepAsideGoalStopConditionPercentage;
    //return ReturnValue;    
}

function float GetDesiredStepAsideDistance()
{
    return m_SoldierPawn.m_SoldierGDData.DesiredStepAsideDistance;
    //return ReturnValue;    
}

function bool AreWeSteppingAsideForPawn()
{
    return false;
    //return ReturnValue;    
}

event KnockEffect()
{
    //return;    
}

function GrenadeThrowAnimFinished()
{
    //return;    
}

function NotifyTakeOutGrenade()
{
    //return;    
}

function NotifyThrowGrenade()
{
    //return;    
}

event bool IsThrowingGrenade()
{
    return false;
    //return ReturnValue;    
}

final function ThrowGrenade(const out Vector throwVelocity, const out Vector throwStartLocation)
{
    // End:0x24
    if((m_SoldierPawn == none) || m_SoldierPawn.m_grenadeWeapon == none)
    {
        return;
    }
    m_SoldierPawn.m_grenadeWeapon.GrenadeFireNPC(throwVelocity, throwStartLocation);
    //return;    
}

final function bool CanKneel()
{
    local SPWeapon myWeapon;

    myWeapon = SPWeapon(Pawn.Weapon);
    // End:0x27
    if(myWeapon == none)
    {
        return true;
    }
    // End:0x5F
    if((int(myWeapon.WeaponType) == int(3)) || int(myWeapon.WeaponType) == int(10))
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

event bool NotifyBump(Actor Other, Vector HitNormal)
{
    local SPPawn bumpPawn;

    bumpPawn = SPPawn(Other);
    // End:0x3E
    if(bumpPawn != none)
    {
        // End:0x3E
        if(CanStepAsideFor(bumpPawn))
        {
            StepAsideForPawn(bumpPawn);
            return true;
        }
    }
    return super.NotifyBump(Other, HitNormal);
    //return ReturnValue;    
}

function ValidateCurrentCoverTimer()
{
    //return;    
}

function bool ArrivedAtCover()
{
    // End:0x1A
    if(IsAtCover(m_reservedCover))
    {
        // End:0x1A
        if(HasValidReservedCover())
        {
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

event BreakOutOfSlam()
{
    bForceDesiredRotation = false;
    //return;    
}

event NotifyBeginSlam()
{
    GotoState('WerewolfSlam');
    //return;    
}

event NotifyBeginMaul()
{
    //return;    
}

event NotifyBeginGriffonPounce()
{
    GotoState('GriffonPounce');
    //return;    
}

function SetAttachedTentacle(bool isAttaching)
{
    // End:0x37
    if(isAttaching)
    {
        ClearYourMindFunc(true, false, true);
        m_bAIDisabled = true;
        m_bIsWaitingForSceneFinish = false;
        GotoState('GrabbedByTentacle');        
    }
    else
    {
        m_bAIDisabled = false;
        EvaluateSituation();
    }
    //return;    
}

function TentacleThrowSoldier()
{
    //return;    
}

function bool CanReactToGrenades()
{
    // End:0x44
    if(((m_bAIDisabled || Pawn == none) || Pawn.IsPendingKill()) || Pawn.Health <= 0)
    {
        return false;
    }
    // End:0x72
    if((m_SoldierPawn.CATAttackerPawn != none) || m_SoldierPawn.CATDefenderPawn != none)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function GrenadeNearby(SPGrenadePersistent theGrenade, float Radius)
{
    local SPSquadHuman humanSquad;

    // End:0x11
    if(!CanReactToGrenades())
    {
        return;
    }
    AddNearbyGrenade(theGrenade, Radius);
    humanSquad = SPSquadHuman(m_squad);
    // End:0x9A
    if(((humanSquad != none) && m_SoldierPawn.GrenadeAlertSoundCue != none) && humanSquad.ShouldDoGrenadeYell(theGrenade))
    {
        humanSquad.PreventGrenadeYell(theGrenade);
        m_SoldierPawn.YellGrenadeAlert();
    }
    SetTimer(RandRange(0.0000000, m_SoldierPawn.m_SoldierGDData.MaxTimeToWaitForGrenadeReaction), false, 'TryToReactToNearbyGrenade');
    //return;    
}

function TryToReactToNearbyGrenade()
{
    // End:0x11
    if(!CanReactToGrenades())
    {
        return;
    }
    // End:0x2D
    if(!HasValidGrenadeToReactTo(m_SoldierPawn.Location))
    {
        return;
    }
    GotoState('ReactToNearbyGrenade');
    //return;    
}

event bool AreWeRunningFromAGrenade()
{
    return false;
    //return ReturnValue;    
}

auto state WaitingForPawn
{
    function Possess(Pawn NewPawn, bool bVehicleTransition)
    {
        local float maxTime;

        // End:0xF2
        if(m_SoldierPawn == none)
        {
            m_SoldierPawn = SoldierPawn(NewPawn);
            // End:0xF2
            if(m_SoldierPawn.m_SoldierGDData != none)
            {
                maxTime = m_SoldierPawn.m_SoldierGDData.GetValue(m_SoldierPawn.m_SoldierGDData.MinTimeBetweenIndividualGrenadeThrows.Max);
                m_timeToNextGrenadeThrow = AITime + RandRange(0.0000000, maxTime);
                m_checkForFriendliesExtent = m_SoldierPawn.m_SoldierGDData.CheckForFriendliesBeforeFiringExtent;
                m_suppressionThreshold = m_SoldierPawn.m_SoldierGDData.UnderFireMeterAtWhichWeAreSuppressed;
                m_suppressionDecay = m_SoldierPawn.m_SoldierGDData.DefaultUnderFireMeterDecayValue;
            }
        }
        super.Possess(NewPawn, bVehicleTransition);
        //return;        
    }
    stop;    
}

state TakeHit
{
    event bool NotifyLanded(Vector HitNormal, Actor FloorActor)
    {
        Pawn.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
        return false;
        //return ReturnValue;        
    }

    function EndState(name NextStateName)
    {
        ClearState();
        //return;        
    }

    event PoppedState()
    {
        ClearState();
        //return;        
    }

    function ClearState()
    {
        ClearTimer('ClearHitTimeOut');
        ClearTimer('HitAnimTimeOut');
        // End:0x46
        if(m_SoldierPawn != none)
        {
            m_bHitTimeOut = false;
            m_SoldierPawn.SetAnimHitDeathState(0);
        }
        //return;        
    }

    function ClearHitTimeOut()
    {
        m_bHitTimeOut = false;
        //return;        
    }

    function HitAnimTimeOut()
    {
        PopState();
        //return;        
    }

    function bool CanStepAsideFor(SPPawn pawnToStepAsideFor)
    {
        return false;
        //return ReturnValue;        
    }

    event ControllerReadyForRagdoll()
    {
        PopState();
        //return;        
    }

    event HitDeathAnimFinished()
    {
        PopState();
        //return;        
    }

    function TakeHitStart(bool bRestart)
    {
        // End:0x15
        if(m_SoldierPawn == none)
        {
            PopState();            
        }
        else
        {
            m_bHitTimeOut = true;
            m_SoldierPawn.SetAnimHitDeathState(1, bRestart);
            SetTimer(0.2000000, false, 'ClearHitTimeOut');
            SetTimer(2.0000000, false, 'HitAnimTimeOut');
        }
        //return;        
    }
RestartHit:

    // End:0x17
    if(m_bHitTimeOut == false)
    {
        TakeHitStart(true);
    }
    goto 'End';
Begin:


    TakeHitStart(false);
End:


    stop;                
}

state ShootAtObstacle
{
    function BeginState(name PreviousStateName)
    {
        SetTimeOutTimer();
        //return;        
    }

    event PushedState()
    {
        SetTimeOutTimer();
        //return;        
    }

    function ContinuedState()
    {
        SetTimeOutTimer();
        //return;        
    }

    event PausedState()
    {
        ClearTimeOutTimer();
        Cleanup();
        //return;        
    }

    event PoppedState()
    {
        ClearTimeOutTimer();
        Cleanup();
        //return;        
    }

    function EndState(name NextStateName)
    {
        ClearTimeOutTimer();
        Cleanup();
        //return;        
    }

    event bool NotifyBump(Actor Other, Vector HitNormal)
    {
        DealWithObstacle(Other, GetEnemy(), true);
        return false;
        //return ReturnValue;        
    }

    function SetTimeOutTimer()
    {
        SetTimer(8.0000000, false, 'ShootAtObstacleTimer');
        //return;        
    }

    function ClearTimeOutTimer()
    {
        ClearTimer('ShootAtObstacleTimer');
        //return;        
    }

    function Cleanup()
    {
        Target = none;
        Focus = none;
        FocalPoint = vect(0.0000000, 0.0000000, 0.0000000);
        StopFiring();
        //return;        
    }

    function ShootAtObstacleTimer()
    {
        PopState();
        //return;        
    }
Begin:

    // End:0x45
    if(Pawn != none)
    {
        Pawn.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
        Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
    }
RestartShootAtObs:


    // End:0x5A
    if(m_DestructibleTarget == none)
    {
        PopState();        
    }
    else
    {
        // End:0x77
        if(m_DestructibleTarget.bDeleteMe)
        {
            PopState();            
        }
        else
        {
            // End:0xC1
            if((Pawn != none) && VSize(m_DestructibleTarget.Location - Pawn.Location) >= (300.0000000 + 50.0000000))
            {
                PopState();                
            }
            else
            {
                // End:0x105
                if(!IsReloading())
                {
                    Target = m_DestructibleTarget;
                    Focus = m_DestructibleTarget;
                    FocalPoint = m_DestructibleTarget.Location;
                    FiringCheck();
                }
            }
        }
    }
    Sleep(RandRange(0.1000000, 0.2000000));
    m_lastDestructibleTarget = m_DestructibleTarget;
    m_DestructibleTarget = GetBestDestructibleTarget();
    // End:0x13E
    if(m_DestructibleTarget != m_lastDestructibleTarget)
    {
    }
    goto 'RestartShootAtObs';
    stop;                
}

state MoveToGoalWhileAttacking extends KyMoveToGoal
{
    function SetDefendAreaSquadCommand(SPSquad.ESPSquadCommands squadCommand, SquadCommandDefendArea_Params Param)
    {
        // End:0x36
        if(!IsSameDefendAreaCommand(squadCommand, Param))
        {
            super(SPAIController).SetDefendAreaSquadCommand(squadCommand, Param);
            AbortMove(false);
        }
        //return;        
    }

    function ClearDefendAreaSquadCommand()
    {
        local bool bWasDefendingArea;

        bWasDefendingArea = IsDefendingArea();
        super(SPAIController).ClearDefendAreaSquadCommand();
        // End:0x29
        if(bWasDefendingArea)
        {
            AbortMove(false);
        }
        //return;        
    }

    function OnSeeEnemy(int PlayerIdx, bool bNewEnemy)
    {
        EnemyTest();
        //return;        
    }

    final function EnemyTest()
    {
        local int enemyIdx;
        local Controller EnemyController;

        // End:0x77
        if(!HasValidEnemy(,,, true) && ValidEnemiesExist())
        {
            // End:0x77
            if(CheckForEnemy(true,, enemyIdx, EnemyController))
            {
                // End:0x77
                if((EnemyController != none) && EnemyController.Pawn != none)
                {
                    SetEnemy(EnemyController.Pawn, enemyIdx);
                }
            }
        }
        //return;        
    }

    function SetTimers()
    {
        super.SetTimers();
        SetTimer(RandRange(m_SoldierPawn.m_SoldierGDData.MinMoveToGoalReevaluateCheckTime, m_SoldierPawn.m_SoldierGDData.MaxMoveToGoalReevaluateCheckTime), true, 'MoveToGoalReEvaluateCheck');
        //return;        
    }

    function ClearTimers()
    {
        super.ClearTimers();
        ClearTimer('MoveToGoalReEvaluateCheck');
        //return;        
    }

    event bool UpdateFocus()
    {
        return UpdateTargetAndFocusWhileMoving();
        //return ReturnValue;        
    }

    event AcquiredNewEnemy()
    {
        // End:0x18
        if(!m_bAIDisabled)
        {
            AbortMove(false);
        }
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        InitializeState();
        super.BeginState(PreviousStateName);
        //return;        
    }

    function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        StopFiring();
        // End:0x30
        if(Focus != (GetEnemy()))
        {
            Focus = none;
        }
        SetDestructibleTarget(none);
        //return;        
    }

    function PushedState()
    {
        InitializeState();
        super.PushedState();
        //return;        
    }

    function InitializeState()
    {
        m_bHasStartedStrafingOnMove = false;
        SetDestructibleTarget(none);
        //return;        
    }

    function PoppedState()
    {
        super.PoppedState();
        StopFiring();
        // End:0x2B
        if(Focus != (GetEnemy()))
        {
            Focus = none;
        }
        SetDestructibleTarget(none);
        //return;        
    }

    function UpdateUnderFireMeter()
    {
        // End:0x39
        if(FRand() < m_SoldierPawn.m_SoldierGDData.RandomChanceToResetUnderFireMeterWhileMoving)
        {
            m_underFireMeter = 0.0000000;
            m_lastShotTime = -1.0000000;            
        }
        else
        {
            // End:0xA3
            if((AITime - m_lastShotTime) > m_SoldierPawn.m_SoldierGDData.UnderFireMeterPreventDecayForDurationAfterBeingShotWhileMoving)
            {
                m_underFireMeter = FClamp(m_underFireMeter - ((AITime - m_lastShotTime) * m_SoldierPawn.m_SoldierGDData.UnderFireMeterDecayValueWhileMoving), 0.0000000, 1.0000000);
            }
        }
        //return;        
    }

    final function bool ValidateDestructibleTarget()
    {
        // End:0x29
        if(m_DestructibleTarget != none)
        {
            // End:0x22
            if(!m_DestructibleTarget.bDeleteMe)
            {
                return true;
            }
            SetDestructibleTarget(none);
        }
        Target = none;
        Focus = none;
        StopFiring();
        return false;
        //return ReturnValue;        
    }

    final function bool WithinDestructibleShootingRange()
    {
        // End:0x0D
        if(Pawn == none)
        {
            return false;
        }
        return VSize(m_DestructibleTarget.Location - Pawn.Location) < 300.0000000;
        //return ReturnValue;        
    }

    function bool ShouldIFire(out int bHorizontallyRestricted, out int bVerticallyRestricted)
    {
        // End:0x88
        if(EnemyIsTarget() && !IsEnemyPotentiallyVisible(true, 0.5000000) || VSizeSq(Pawn.Velocity) > ((SPPawn(Pawn).m_movementTypeInfo[0].GroundSpeed * SPPawn(Pawn).m_movementTypeInfo[0].GroundSpeed) + 1.0000000))
        {
            return false;            
        }
        else
        {
            return super(SPAIController).ShouldIFire(bHorizontallyRestricted, bVerticallyRestricted);
        }
        //return ReturnValue;        
    }

    event SuppressionDetected(out SuppressionMemory Suppression)
    {
        // End:0x16
        if(!AllowedToReactToSuppression(Suppression))
        {
            return;
        }
        ForceToSeeIfPlayer(Suppression.Instigator);
        ApplyDamageToTargetTable(Suppression.Instigator.Controller, m_SoldierPawn.m_SoldierGDData.TreatSuppressionAsDamageAmount, true, m_SoldierPawn.m_SoldierGDData.GetValue(m_SoldierPawn.m_SoldierGDData.BroadcastDamageToSquadMemberRange));
        ExtractSuppressionInfo(Suppression);
        super.SuppressionDetected(Suppression);
        //return;        
    }

    function bool IsMovingToCover()
    {
        return m_reservedCover != none;
        //return ReturnValue;        
    }

    function MoveToGoalReEvaluateCheck()
    {
        // End:0x33
        if(!m_bAIDisabled)
        {
            // End:0x33
            if((WantsToLookForCover()) && !IsMovingToCover())
            {
                EvaluateSituation();
            }
        }
        //return;        
    }

    function MoveToGoalTimerUpdate()
    {
        local Vector currentDest;

        EnemyTest();
        m_DestructibleTarget = GetBestDestructibleTarget();
        // End:0x4C
        if(ValidateDestructibleTarget())
        {
            // End:0x37
            if(WithinDestructibleShootingRange())
            {
                PushState('ShootAtObstacle');                
            }
            else
            {
                Target = m_DestructibleTarget;
                StopFiring();
            }
        }
        // End:0xD0
        if(((!m_bAIDisabled && IsDefendingArea()) && !AreWeRunningFromAGrenade()) && !AreWeSteppingAsideForPawn())
        {
            // End:0xD0
            if(((GetEnemy()) == none) || !IsDestinationOutsideOfDefendAreaValid())
            {
                // End:0xD0
                if(GetDestinationLocation(currentDest))
                {
                    // End:0xD0
                    if(!IsLocationInDefendArea(currentDest, true))
                    {
                        AbortMove(false);
                        return;
                    }
                }
            }
        }
        // End:0x12B
        if(((HasValidEnemy(,,, true)) && IsEnemyPotentiallyVisible(true)) && CanFireAt(GetEnemy(),,, AllowOnlyCheckDynamicActorsInCanFireAt()))
        {
            Target = GetEnemy();
            FiringCheck();            
        }
        else
        {
            Target = none;
            StopFiring();
        }
        //return;        
    }

    function bool FiringCheck()
    {
        // End:0x1E
        if(!CanClassMoveAndAttack())
        {
            StopFiring();
            return false;            
        }
        else
        {
            return super(SPAIController).FiringCheck();
        }
        //return ReturnValue;        
    }
    stop;    
}

state MoveToCover extends MoveToGoalWhileAttacking
{
    function PoppedState()
    {
        super.PoppedState();
        //return;        
    }

    function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        StopFiring();
        ClearReservedCover();
        ClearCurrentCover();
        m_bMovingToCover = false;
        //return;        
    }

    function bool ShouldIFire(out int bHorizontallyRestricted, out int bVerticallyRestricted)
    {
        // End:0x4E
        if(EnemyIsTarget() && VSize(Pawn.Velocity) > (SPPawn(Pawn).m_movementTypeInfo[0].GroundSpeed + 1.0000000))
        {
            return false;            
        }
        else
        {
            return super.ShouldIFire(bHorizontallyRestricted, bVerticallyRestricted);
        }
        //return ReturnValue;        
    }

    function MoveToGoalTimerUpdate()
    {
        // End:0x29
        if(!m_bAIDisabled && !HasValidReservedCover())
        {
            AbortMove(false);            
        }
        else
        {
            super.MoveToGoalTimerUpdate();
        }
        //return;        
    }

    event AcquiredNewEnemy()
    {
        // End:0x26
        if(!m_bAIDisabled && !HasValidReservedCover())
        {
            AbortMove(false);
        }
        //return;        
    }
    stop;    
}

state MoveToDefendAreaCover extends MoveToCover
{    stop;    
}

state MoveToStepAsideLocationState extends MoveToGoalWhileAttacking
{
    function bool AreWeSteppingAsideForPawn()
    {
        return true;
        //return ReturnValue;        
    }

    function bool CanStepAsideFor(SPPawn pawnToStepAsideFor)
    {
        return false;
        //return ReturnValue;        
    }
    stop;    
}

state MoveToDefendAreaDestination extends MoveToGoalWhileAttacking
{
    function SetDefendAreaSquadCommand(SPSquad.ESPSquadCommands squadCommand, SquadCommandDefendArea_Params Param)
    {
        // End:0x36
        if(!IsSameDefendAreaCommand(squadCommand, Param))
        {
            super.SetDefendAreaSquadCommand(squadCommand, Param);
            AbortMove(false);
        }
        //return;        
    }

    function ClearDefendAreaSquadCommand()
    {
        local bool bWasDefendingArea;

        bWasDefendingArea = IsDefendingArea();
        super.ClearDefendAreaSquadCommand();
        // End:0x29
        if(bWasDefendingArea)
        {
            AbortMove(false);
        }
        //return;        
    }
    stop;    
}

state ControllerDying
{
    function ContinuedState()
    {
        //return;        
    }

    function NotifyDied()
    {
        PopState();
        GotoState('WaitingForTheInevitable');
        //return;        
    }
    stop;    
}

state WaitingForTheInevitable
{
    function ContinuedState()
    {
        //return;        
    }
    stop;    
}

state KnockObstacle
{
    function BeginState(name PreviousStateName)
    {
        //return;        
    }

    event PoppedState()
    {
        Cleanup();
        //return;        
    }

    function EndState(name NextStateName)
    {
        Cleanup();
        //return;        
    }

    function Cleanup()
    {
        ClearPawnActionState();
        SetKnockObstacle(none);
        //return;        
    }

    final function bool PawnIsInKnockAway()
    {
        // End:0x27
        if(m_SoldierPawn != none)
        {
            // End:0x27
            if(int(m_SoldierPawn.m_actionState) == int(8))
            {
                return true;
            }
        }
        return false;
        //return ReturnValue;        
    }

    event KnockEffect()
    {
        local editinline StaticMeshComponent StaticMesh;
        local Vector impulseOffset;
        local float Speed;

        Speed = 600.0000000;
        m_knockObstacle.SetPhysics(10);
        StaticMesh = m_knockObstacle.GetStaticMeshComponent();
        // End:0x92
        if(StaticMesh != none)
        {
            impulseOffset = vect(0.0000000, 0.0000000, 0.0000000);
            StaticMesh.AddImpulse(m_knockVector * Speed, impulseOffset, 'None', true, GetKnockAwayMinDamage(), GetKnockAwayMaxDamage(), Pawn);
        }
        //return;        
    }

    event ActionStateAnimFinished()
    {
        PopState();
        //return;        
    }
Begin:

    // End:0x12
    if(Pawn == none)
    {
        PopState();
    }
    // End:0x2B
    if(IsOnTopOf(m_knockObstacle))
    {
        PopState();
    }
    // End:0x3F
    if(!SetPawnActionState(8))
    {
        PopState();
    }
    // End:0x66
    if((m_knockObstacle == none) || m_knockObstacle.bDeleteMe)
    {
        PopState();
    }
    Pawn.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
    Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
    Target = none;
    Focus = none;
    FocalPoint = vect(0.0000000, 0.0000000, 0.0000000);
    PreserveRotation();
    m_SoldierPawn.m_knockDirection = m_SoldierPawn.GetBestKnockDirection(m_knockObstacle, m_knockVector);
    J0xF5:

    // End:0x10C [Loop If]
    if(PawnIsInKnockAway() == true)
    {
        Sleep(0.0000000);
        // [Loop Continue]
        goto J0xF5;
    }
    PopState();
    stop;                    
}

state Break
{
    function BeginState(name PreviousStateName)
    {
        SetTimers();
        //return;        
    }

    event PushedState()
    {
        SetTimers();
        //return;        
    }

    function ContinuedState()
    {
        EndBreak();
        //return;        
    }

    function SetTimers()
    {
        local float Time;

        ClearTimer('BreakTimer');
        ClearTimer('EndBreak');
        Time = GetBreakDuration();
        // End:0x4F
        if(Time > float(0))
        {
            SetTimer(Time, false, 'EndBreak');            
        }
        else
        {
            EndBreak();
        }
        //return;        
    }

    event PoppedState()
    {
        ClearTimer('EndBreak');
        //return;        
    }

    function EndState(name PreviousStateName)
    {
        ClearTimer('EndBreak');
        //return;        
    }

    event PausedState()
    {
        ClearTimer('EndBreak');
        //return;        
    }

    function EndBreak()
    {
        PopState();
        //return;        
    }

    final function ValidateCover()
    {
        // End:0x32
        if((m_currentCover != none) && IsAtCover(m_currentCover))
        {
            // End:0x32
            if(!HasValidCover())
            {
                EndBreak();
                return;
            }
        }
        //return;        
    }
    J0x00:
    // End:0x15 [Loop If]
    if(true)
    {
        ValidateCover();
        Sleep(0.2000000);
        // [Loop Continue]
        goto J0x00;
    }
    stop;            
}

state PauseAttack
{
    function BeginState(name PreviousStateName)
    {
        SetTimers();
        //return;        
    }

    event PushedState()
    {
        SetTimers();
        //return;        
    }

    function ContinuedState()
    {
        EndBreak();
        //return;        
    }

    function SetTimers()
    {
        local float Time;

        ClearTimer('BreakTimer');
        ClearTimer('EndBreak');
        Time = GetPauseDuration();
        // End:0x4F
        if(Time > float(0))
        {
            SetTimer(Time, false, 'EndBreak');            
        }
        else
        {
            EndBreak();
        }
        //return;        
    }

    event PoppedState()
    {
        ClearTimer('EndBreak');
        //return;        
    }

    function EndState(name PreviousStateName)
    {
        ClearTimer('EndBreak');
        //return;        
    }

    event PausedState()
    {
        ClearTimer('EndBreak');
        //return;        
    }

    function EndBreak()
    {
        PopState();
        //return;        
    }
    J0x00:
    // End:0x0F [Loop If]
    if(true)
    {
        Sleep(2.0000000);
        // [Loop Continue]
        goto J0x00;
    }
    stop;                    
}

state ThrowGrenadeAtEnemy
{
    function BeginState(name PreviousStateName)
    {
        m_bDisableUpdateTargetting = true;
        m_bHasGrenadeInHand = false;
        //return;        
    }

    event PoppedState()
    {
        Cleanup();
        //return;        
    }

    event PushedState()
    {
        //return;        
    }

    function EndState(name PreviousStateName)
    {
        Cleanup();
        //return;        
    }

    function Cleanup()
    {
        local float minTime, maxTime;
        local SPSquadHuman humanSquad;

        // End:0x13
        if(m_bHasGrenadeInHand)
        {
            DropGrenade();
        }
        m_bDisableUpdateTargetting = false;
        m_SoldierPawn.StopThrowingGrenade();
        minTime = m_SoldierPawn.m_SoldierGDData.GetValue(m_SoldierPawn.m_SoldierGDData.MinTimeBetweenIndividualGrenadeThrows.Min);
        maxTime = m_SoldierPawn.m_SoldierGDData.GetValue(m_SoldierPawn.m_SoldierGDData.MinTimeBetweenIndividualGrenadeThrows.Max);
        m_timeToNextGrenadeThrow = AITime + RandRange(minTime, maxTime);
        humanSquad = SPSquadHuman(m_squad);
        // End:0x104
        if(humanSquad != none)
        {
            humanSquad.SquadMemberJustThrewGrenade(self);
        }
        //return;        
    }

    event bool IsThrowingGrenade()
    {
        return true;
        //return ReturnValue;        
    }

    function GrenadeThrowAnimFinished()
    {
        PopState();
        //return;        
    }

    function NotifyTakeOutGrenade()
    {
        m_bHasGrenadeInHand = true;
        //return;        
    }

    function DropGrenade()
    {
        local Vector throwStartLocation, V;

        // End:0x4B
        if(m_bHasGrenadeInHand)
        {
            throwStartLocation = m_SoldierPawn.m_grenadeWeapon.Mesh.GetPosition();
            ThrowGrenade(V, throwStartLocation);
            m_bHasGrenadeInHand = false;
        }
        //return;        
    }

    function NotifyThrowGrenade()
    {
        local Vector throwVelocity, throwStartLocation;

        // End:0x5C
        if(m_bHasGrenadeInHand)
        {
            throwStartLocation = m_SoldierPawn.m_grenadeWeapon.Mesh.GetPosition();
            throwVelocity = GetGrenadeThrowVelocity(throwStartLocation);
            ThrowGrenade(throwVelocity, throwStartLocation);
            m_bHasGrenadeInHand = false;
        }
        //return;        
    }
Begin:

    Target = none;
    m_SoldierPawn.StartThrowingGrenade();
    // End:0x35
    if(m_currentCover == none)
    {
        Focus = GetEnemy();
        FinishRotation();
    }
    Sleep(10.0000000);
    stop;            
}

state Idle
{
    function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        Focus = none;
        Target = none;
        PreserveRotation();
        //return;        
    }

    function OnSeeEnemy(int PlayerIdx, bool bNewEnemy)
    {
        // End:0x19
        if(bNewEnemy)
        {
            GotoState(GetStateName(), 'SawEnemy');
        }
        //return;        
    }

    event AcquiredNewEnemy()
    {
        GotoState(GetStateName(), 'SawEnemy');
        //return;        
    }

    function OnHearEnemy(int PlayerIdx)
    {
        GotoState(GetStateName(), 'InvestigateNoise');
        //return;        
    }
Begin:

    EvaluateWeapons();
    ResetMovementParameters();
LookAround:


    Sleep(RandRange(0.3000000, 1.5000000));
Evaluate:


    EvaluateSituation();
    goto 'LookAround';
InvestigateNoise:


    Focus = m_recentNoise[m_recentNoise.Length - 1].NoiseMaker;
    Sleep(RandRange(0.0000000, 0.2000000));
    goto 'Evaluate';
SawEnemy:


    Sleep(0.0000000);
    goto 'Evaluate';
    stop;        
}

state Attack_Stand
{
    function GotoMoveToGoalState()
    {
        // End:0x1C
        if(IsDefendingArea())
        {
            PushState('MoveToDefendAreaDestination');            
        }
        else
        {
            PushState('MoveToGoalWhileAttacking');
        }
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        // End:0x1B
        if(Focus != (GetEnemy()))
        {
            Focus = none;
        }
        Pawn.SetMovementPhysics();
        SetTimer(RandRange(0.2500000, 1.5000000), false, 'Attack_StandFireTimer');
        //return;        
    }

    function ContinuedState()
    {
        SetTimer(RandRange(0.2500000, 1.5000000), false, 'Attack_StandFireTimer');
        //return;        
    }

    event PoppedState()
    {
        ClearTimer('Attack_StandFireTimer');
        ClearTimer('BreakTimer');
        m_SoldierPawn.m_bKneel = false;
        //return;        
    }

    event PausedState()
    {
        ClearTimer('Attack_StandFireTimer');
        ClearTimer('BreakTimer');
        m_SoldierPawn.m_bKneel = false;
        //return;        
    }

    function EndState(name NextStateName)
    {
        StopFiring();
        ClearTimer('Attack_StandFireTimer');
        ClearTimer('BreakTimer');
        m_SoldierPawn.m_bKneel = false;
        //return;        
    }

    final function Attack_StandFireTimer()
    {
        local bool bKneel;

        // End:0x4B
        if(CanKneel())
        {
            bKneel = IsUnderFire();
            // End:0x48
            if(bKneel != m_SoldierPawn.m_bKneel)
            {
                m_SoldierPawn.m_bKneel = bKneel;
            }            
        }
        else
        {
            m_SoldierPawn.m_bKneel = false;
        }
        SetTimer(RandRange(1.0000000, 1.5000000), false, 'Attack_StandFireTimer');
        //return;        
    }

    function InitSuppressionPartOfDestinationInfo(out DestinationInfo theInfo)
    {
        local Vector spotToMove;

        // End:0xB5
        if((m_SoldierPawn != none) && IsUnderFire())
        {
            spotToMove = m_SoldierPawn.Location - (m_dirToLastSuppressionPlane * 500.0000000);
            theInfo.rangeToSpotWeight = 50.0000000;
            theInfo.maxRangeToSpotSQ = 500.0000000 * 500.0000000;
            theInfo.oneOverMaxRangeToSpotSQ = 1.0000000 / theInfo.maxRangeToSpotSQ;
            theInfo.desiredSpot = spotToMove;
            m_bIgnoreUnderFireMeterWhileMoving = true;            
        }
        else
        {
            global.InitSuppressionPartOfDestinationInfo(theInfo);
        }
        //return;        
    }

    function BreakTimer()
    {
        // End:0x8C
        if(!m_SoldierPawn.m_bKneel)
        {
            // End:0x89
            if(!IsReloading())
            {
                // End:0x31
                if(IsFiring())
                {
                }
                StopFiring();
                // End:0x5B
                if(ShouldThrowGrenadeAtEnemy())
                {
                    PushState('ThrowGrenadeAtEnemy');                    
                }
                else
                {
                    // End:0x77
                    if(ShouldPauseInsteadOfBreak())
                    {
                        PushState('PauseAttack');                        
                    }
                    else
                    {
                        PushState('Break');
                    }
                }
                return;
            }            
        }
        else
        {
            // End:0xD7
            if(!IsReloading())
            {
                StopFiring();
                // End:0xC5
                if(ShouldThrowGrenadeAtEnemy())
                {
                    PushState('ThrowGrenadeAtEnemy');                    
                }
                else
                {
                    PushState('PauseAttack');
                }
                return;
            }
        }
        //return;        
    }

    function OnSeeEnemy(int PlayerIdx, bool bNewEnemy)
    {
        // End:0x2D
        if(bNewEnemy && (GetEnemy()) == none)
        {
            GotoState(GetStateName(), 'Evaluate');
            return;
        }
        //return;        
    }

    event AcquiredNewEnemy()
    {
        GotoState(GetStateName(), 'Evaluate');
        return;
        //return;        
    }

    function OnHearEnemy(int PlayerIdx)
    {
        // End:0x22
        if((GetEnemy()) == none)
        {
            GotoState(GetStateName(), 'InvestigateNoise');
            return;
        }
        //return;        
    }

    function bool ShouldSuggestReevaluateSituation()
    {
        // End:0x4B
        if((AITime - m_lastSuggestReevaluateTime) < RandRange(m_SoldierPawn.m_SoldierGDData.MinSuggestReevaluateTime, m_SoldierPawn.m_SoldierGDData.MaxSuggestReevaluateTime))
        {
            return false;
        }
        return true;
        //return ReturnValue;        
    }

    function CheckForSuggestReevaluate()
    {
        // End:0x28
        if(ShouldSuggestReevaluateSituation())
        {
            m_lastSuggestReevaluateTime = AITime;
            GotoState(GetStateName(), 'Evaluate');
        }
        //return;        
    }

    event EnemyIsTooClose()
    {
        GotoState('Attack_Stand', 'Evaluate');
        //return;        
    }

    event CantSeePlayer(Pawn pawnNotSeen, bool bCanPotentiallySee)
    {
        local BadVertexPairsToStandAtInfo badPairInfo;

        // End:0xA1
        if((((pawnNotSeen != none) && !bCanPotentiallySee) && m_SoldierPawn != none) && pawnNotSeen == (GetEnemy()))
        {
            // End:0xA1
            if((int(m_aggressionLevel) > int(1)) && IsPawnValidTargetForHighAggression(pawnNotSeen))
            {
                badPairInfo.EndBadTime = AITime + m_SoldierPawn.m_SoldierGDData.CantSeeEnemyInHighAggressionBadPairDuration;
                AddCurrentLocationToBadVertexPairs(GetEnemy(), badPairInfo);
            }
        }
        super(SPAIController).CantSeePlayer(pawnNotSeen, bCanPotentiallySee);
        //return;        
    }
Begin:

    // End:0x56
    if(m_standDestinationID != GetCurrentVertex())
    {
        SetMoveGoal(none, 1, m_standDestinationLoc, 2, true,,, true);
        // End:0x56
        if((int(m_lastMoveStatus) != int(4)) || m_bMoveAborted)
        {
            Sleep(0.0000000);
            goto 'Evaluate';
        }
    }
    ResetMovementParameters();
AttackStandLoop:


    Target = GetEnemy();
    // End:0xCB
    if(ShouldITurnToTarget(m_SoldierPawn.m_SoldierGDData.StandAttackMaxHalfAngleBeforeTurning))
    {
        StopFiring();
        Focus = Target;
        FinishRotation();
        PreserveRotation();
        // End:0xCB
        if(Focus != (GetEnemy()))
        {
            Focus = none;
        }
    }
    // End:0xFA
    if(!HasValidEnemy(,,, true))
    {
        StopFiring();
        // End:0xFA
        if(ValidEnemiesExist())
        {
            goto 'Evaluate';
        }
    }
    // End:0x17D
    if((IsEnemyPotentiallyVisible(true) && CanFireAt(GetEnemy(),,, AllowOnlyCheckDynamicActorsInCanFireAt())) && FiringCheck())
    {
        SetBreakTimer();
        Sleep(RandRange(m_SoldierPawn.m_SoldierGDData.MinSuggestReevaluateTime, m_SoldierPawn.m_SoldierGDData.MaxSuggestReevaluateTime));        
    }
    else
    {
        Sleep(RandRange(m_SoldierPawn.m_SoldierGDData.MinFailedFiringCheckSleepTime, m_SoldierPawn.m_SoldierGDData.MaxFailedFiringCheckSleepTime));
    }
    CheckForSuggestReevaluate();
    goto 'AttackStandLoop';
Evaluate:


    Sleep(0.0000000);
    EvaluateSituation();
    goto 'AttackStandLoop';
InvestigateNoise:


    Focus = m_recentNoise[m_recentNoise.Length - 1].NoiseMaker;
    Sleep(RandRange(0.0000000, 0.2000000));
    goto 'Evaluate';
    stop;            
}

state Attack_Cover
{
    event PoppedState()
    {
        EndCoverState();
        //return;        
    }

    event PausedState()
    {
        ClearTimer('BreakTimer');
        ClearTimer('ValidateCurrentCoverTimer');
        //return;        
    }

    function ContinuedState()
    {
        //return;        
    }

    function EndCoverState(optional name NextStateName)
    {
        ClearTimer('BreakTimer');
        ClearTimer('ValidateCurrentCoverTimer');
        StopFiring();
        ClearReservedCover();
        ClearCurrentCover();
        m_bMovingToCover = false;
        bForceDesiredRotation = false;
        //return;        
    }

    function EndState(name NextStateName)
    {
        EndCoverState(NextStateName);
        //return;        
    }

    event bool IsMovingToCover()
    {
        return m_bMovingToCover;
        //return ReturnValue;        
    }

    function GotoMoveToGoalState()
    {
        // End:0x1C
        if(IsDefendingArea())
        {
            PushState('MoveToDefendAreaCover');            
        }
        else
        {
            PushState('MoveToCover');
        }
        //return;        
    }

    function bool ShouldIFire(out int bHorizontallyRestricted, out int bVerticallyRestricted)
    {
        local float chanceToRespectUnderFire;

        chanceToRespectUnderFire = m_SoldierPawn.m_SoldierGDData.GetValue(m_SoldierPawn.m_SoldierGDData.UnderFireSoWeShouldHidePercent);
        // End:0x6F
        if((EnemyIsTarget() && IsUnderFire()) && RandRange(1.0000000, 100.0000000) <= chanceToRespectUnderFire)
        {
            return false;
        }
        return global.ShouldIFire(bHorizontallyRestricted, bVerticallyRestricted);
        //return ReturnValue;        
    }

    function BreakTimer()
    {
        // End:0x70
        if(HasValidCover())
        {
            // End:0x70
            if(!IsReloading())
            {
                StopFiring();
                // End:0x42
                if(ShouldThrowGrenadeAtEnemy())
                {
                    GotoState(GetStateName(), 'StartThrowGrenadeAtEnemy');                    
                }
                else
                {
                    // End:0x5E
                    if(ShouldPauseInsteadOfBreak())
                    {
                        GotoState(GetStateName(), 'StartPauseAttack');                        
                    }
                    else
                    {
                        GotoState(GetStateName(), 'StartBreak');
                    }
                }
                return;
            }
        }
        //return;        
    }

    function ValidateCurrentCoverTimer()
    {
        FindBestEnemyForMyCover(false);
        // End:0x24
        if(!HasValidCover())
        {
            GotoState(GetStateName(), 'Evaluate');
            return;
        }
        //return;        
    }

    function bool ShouldSuggestReevaluateSituation()
    {
        // End:0x4B
        if((AITime - m_lastSuggestReevaluateTime) < RandRange(m_SoldierPawn.m_SoldierGDData.MinSuggestReevaluateTime, m_SoldierPawn.m_SoldierGDData.MaxSuggestReevaluateTime))
        {
            return false;
        }
        // End:0x72
        if(!EnemyRecentlyVisible(true, m_SoldierPawn.m_SoldierGDData.SuggestedMinTimeAtCoverIfNoVisibleEnemy))
        {
            return true;
        }
        // End:0x90
        if(!IsCoverAngleValidAgainstEnemy(m_currentCover, GetEnemy(), 1))
        {
            return true;
        }
        return false;
        //return ReturnValue;        
    }

    function SetValidateTimer()
    {
        SetTimer(0.5000000, true, 'ValidateCurrentCoverTimer');
        //return;        
    }

    function InitDestinationInfo(out DestinationInfo theInfo)
    {
        local int Idx, ratingBias;

        global.InitDestinationInfo(theInfo);
        // End:0x113
        if(!m_bMovingToCover)
        {
            // End:0x113
            if(HasValidEnemy(,,, true))
            {
                // End:0x113
                if(!CachedCanFireAtEnemy(true, false))
                {
                    Idx = GetPlayerIdx(GetEnemy().Controller);
                    // End:0x113
                    if((Idx >= 0) && Idx < m_playerList.Length)
                    {
                        ratingBias = int((AITime - m_playerList[Idx].LastSeenTime) * m_SoldierPawn.m_SoldierGDData.CantShootRatingBiasPerSecond);
                        // End:0xFA
                        if(float(ratingBias) < m_SoldierPawn.m_SoldierGDData.MinCantShootRatingBias)
                        {
                            ratingBias = int(m_SoldierPawn.m_SoldierGDData.MinCantShootRatingBias);
                        }
                        theInfo.CurrentCoverWeight += float(ratingBias);
                    }
                }
            }
        }
        //return;        
    }

    function OnSeeEnemy(int PlayerIdx, bool bNewEnemy)
    {
        // End:0x38
        if(!m_bMovingToCover)
        {
            // End:0x38
            if(bNewEnemy && (GetEnemy()) == none)
            {
                GotoState(GetStateName(), 'Evaluate');
                return;
            }
        }
        //return;        
    }

    event AcquiredNewEnemy()
    {
        // End:0x15
        if(!m_bMovingToCover)
        {
            ValidateCurrentCoverTimer();
        }
        //return;        
    }

    function OnHearEnemy(int PlayerIdx)
    {
        // End:0x22
        if((GetEnemy()) == none)
        {
            GotoState(GetStateName(), 'InvestigateNoise');
            return;
        }
        //return;        
    }

    function CheckForSuggestReevaluate()
    {
        // End:0x22
        if(ShouldSuggestReevaluateSituation())
        {
            m_lastSuggestReevaluateTime = AITime;
            EvaluateSituation();
        }
        //return;        
    }

    event CantSeePlayer(Pawn pawnNotSeen, bool bCanPotentiallySee)
    {
        local BadVertexPairsToStandAtInfo badPairInfo;

        // End:0xA1
        if((((pawnNotSeen != none) && !bCanPotentiallySee) && m_SoldierPawn != none) && pawnNotSeen == (GetEnemy()))
        {
            // End:0xA1
            if((int(m_aggressionLevel) > int(1)) && IsPawnValidTargetForHighAggression(pawnNotSeen))
            {
                badPairInfo.EndBadTime = AITime + m_SoldierPawn.m_SoldierGDData.CantSeeEnemyInHighAggressionBadPairDuration;
                AddCurrentLocationToBadVertexPairs(GetEnemy(), badPairInfo);
            }
        }
        super(SPAIController).CantSeePlayer(pawnNotSeen, bCanPotentiallySee);
        //return;        
    }
Begin:

    m_bMovingToCover = false;
    // End:0xE7
    if(!ArrivedAtCover())
    {
        m_bMovingToCover = true;
        SetMoveGoal(m_reservedCover, 1, vect(0.0000000, 0.0000000, 0.0000000), 0, false);
        m_bMovingToCover = false;
        // End:0x6B
        if(int(m_lastMoveStatus) != int(4))
        {
            // End:0x68
            if(m_bMoveAborted)
            {                
            }            
        }
        else
        {
            // End:0x77
            if(m_bMoveAborted)
            {                
            }
            else
            {
                // End:0x86
                if(!HasValidReservedCover())
                {                    
                }
                else
                {
                    // End:0x96
                    if(!OccupyCover(m_reservedCover))
                    {
                    }
                }
            }
        }
        // End:0xE7
        if((((int(m_lastMoveStatus) != int(4)) || m_bMoveAborted) || !HasValidReservedCover()) || !OccupyCover(m_reservedCover))
        {
            ClearCurrentCover();
            ClearReservedCover();
            goto 'Evaluate';
        }
    }
    ResetMovementParameters();
    SnapToCurrentCover();
    SetValidateTimer();
CoverAttackLoop:


    FindBestEnemyForMyCover(false);
    Target = GetEnemy();
    // End:0x143
    if(!HasValidEnemy(,,, true))
    {
        StopFiring();
        CheckForEnemy();
    }
    // End:0x256
    if(SetCoverAction())
    {
        // End:0x236
        if(!FiringCheck())
        {
            // End:0x1F8
            if(IsUnderFire() && RandRange(1.0000000, 100.0000000) <= m_SoldierPawn.m_SoldierGDData.GetValue(m_SoldierPawn.m_SoldierGDData.UnderFireSoWeShouldHidePercent))
            {
                ResetCoverAction();
                Sleep(RandRange(m_SoldierPawn.m_SoldierGDData.MinHideFromFiringSleepTime, m_SoldierPawn.m_SoldierGDData.MaxHideFromFiringSleepTime));                
            }
            else
            {
                Sleep(RandRange(m_SoldierPawn.m_SoldierGDData.MinFailedFiringCheckSleepTime, m_SoldierPawn.m_SoldierGDData.MaxFailedFiringCheckSleepTime));
            }            
        }
        else
        {
            SetBreakTimer();
            Sleep(RandRange(0.3000000, 1.5000000));
        }        
    }
    else
    {
        Target = none;
        StopFiring();
        Sleep(RandRange(m_SoldierPawn.m_SoldierGDData.MinFailedFiringCheckSleepTime, m_SoldierPawn.m_SoldierGDData.MaxFailedFiringCheckSleepTime));
    }
    CheckForSuggestReevaluate();
    goto 'CoverAttackLoop';
Evaluate:


    Sleep(0.0000000);
    EvaluateSituation();
    goto 'CoverAttackLoop';
InvestigateNoise:


    Focus = m_recentNoise[m_recentNoise.Length - 1].NoiseMaker;
    Sleep(RandRange(0.0000000, 0.2000000));
    goto 'Evaluate';
StartPauseAttack:


    ValidateCurrentCoverTimer();
    PushState('PauseAttack');
    SetValidateTimer();
    goto 'CoverAttackLoop';
StartBreak:


    ValidateCurrentCoverTimer();
    PushState('Break');
    SetValidateTimer();
    goto 'CoverAttackLoop';
StartThrowGrenadeAtEnemy:


    ValidateCurrentCoverTimer();
    PushState('ThrowGrenadeAtEnemy');
    SetValidateTimer();
    goto 'CoverAttackLoop';
    stop;            
}

state GotoDefendAreaDestination
{
    function GotoMoveToGoalState()
    {
        PushState('MoveToDefendAreaDestination');
        //return;        
    }
Begin:

    // End:0x33
    if(m_defendAreaNavPoint != none)
    {
        SetMoveGoal(m_defendAreaNavPoint, 1, vect(0.0000000, 0.0000000, 0.0000000), 0, false);        
    }
    else
    {
        SetMoveGoal(none, 1, m_defendAreaPosition, 2, false);
    }
    // End:0x63
    if(IsActorInDefendArea(Pawn))
    {
        SetHasBeenInDefendArea(true);
    }
    GotoState('Idle');
    stop;            
}

state WerewolfSlam
{
    function EndState(name NextStateName)
    {
        // End:0x34
        if((NextStateName != 'WaitingForTheInevitable') && NextStateName != 'WerewolfMaul')
        {
            ClearPawnActionState();
            SetCollision(true, true);
        }
        //return;        
    }

    event PushedState()
    {
        //return;        
    }

    event PoppedState()
    {
        //return;        
    }

    event NotifyBeginMaul()
    {
        GotoState('WerewolfMaul');
        //return;        
    }

    event BreakOutOfSlam()
    {
        ClearPawnActionState();
        SetCollision(true, true);
        EvaluateSituation();
        //return;        
    }
Begin:

    // End:0x17
    if(!SetPawnActionState(1))
    {
        BreakOutOfSlam();
    }
    stop;                    
}

state WerewolfMaul
{
    function EndState(name NextStateName)
    {
        // End:0x19
        if(NextStateName != 'WaitingForTheInevitable')
        {
            ClearPawnActionState();
        }
        SetCollision(true, true);
        //return;        
    }

    event PushedState()
    {
        //return;        
    }

    event PoppedState()
    {
        //return;        
    }

    event BreakOutOfSlam()
    {
        GotoState(GetStateName(), 'MaulRecover', false, true);
        //return;        
    }

    event ActionStateAnimFinished()
    {
        // End:0x37
        if(m_SoldierPawn != none)
        {
            // End:0x37
            if(int(m_SoldierPawn.m_actionState) == int(7))
            {
                m_SoldierPawn.SetActionState(0);
            }
        }
        //return;        
    }

    function bool PawnIsInMaulRecover()
    {
        // End:0x27
        if(m_SoldierPawn != none)
        {
            // End:0x27
            if(int(m_SoldierPawn.m_actionState) == int(7))
            {
                return true;
            }
        }
        return false;
        //return ReturnValue;        
    }
Begin:

    SetPawnActionState(2);
    J0x08:

    // End:0x17 [Loop If]
    if(true)
    {
        Sleep(0.1000000);
        // [Loop Continue]
        goto J0x08;
    }
MaulRecover:


    // End:0x42
    if(Pawn != none)
    {
        SetPawnActionState(7);
        J0x2A:

        // End:0x42 [Loop If]
        if(PawnIsInMaulRecover())
        {
            Sleep(0.1000000);
            // [Loop Continue]
            goto J0x2A;
        }
    }
    SetCollision(true, true);
    EvaluateSituation();
    stop;        
}

state GriffonPounce
{
    event NotifyEndGriffonPounce()
    {
        // End:0x1D
        if(Pawn.Health > 0)
        {
            SetPawnActionState(4);
        }
        //return;        
    }

    event StartGriffonPounceFinished()
    {
        // End:0x31
        if(Pawn.Health > 0)
        {
            Pawn.SetMovementPhysics();
            SetPawnActionState(3);
        }
        //return;        
    }

    event EndGriffonPounceFinished()
    {
        EvaluateSituation();
        //return;        
    }

    function EndState(name NextStateName)
    {
        // End:0x29
        if(Pawn.Health > 0)
        {
            Pawn.SetMovementPhysics();
        }
        //return;        
    }

    event PoppedState()
    {
        // End:0x29
        if(Pawn.Health > 0)
        {
            Pawn.SetMovementPhysics();
        }
        //return;        
    }

    function NotifyTakeHit(Controller instigatedBy, Vector HitLocation, int Damage, class<DamageType> DamageType, Vector Momentum)
    {
        // End:0x1D
        if(Pawn.Health <= 0)
        {
            SetPawnActionState(6);
        }
        //return;        
    }
Begin:

    Pawn.SetPhysics(0);
    SetPawnActionState(5);
    stop;                    
}

state GrabbedByTentacle
{
    function EndState(name NextStateName)
    {
        // End:0x5B
        if(m_SoldierPawn != none)
        {
            m_SoldierPawn.SetCollision(true, true);
            m_SoldierPawn.SetMovementPhysics();
            m_SoldierPawn.bCollideWorld = true;
            SetPawnActionState(0);
            m_SoldierPawn.m_bIsAttachedToTentacle = false;
        }
        m_bAIDisabled = false;
        EvaluateSituation();
        //return;        
    }

    function Tick(float DeltaTime)
    {
        // End:0x25
        if(m_SoldierPawn != none)
        {
            // End:0x25
            if(int(m_SoldierPawn.m_actionState) == int(11))
            {
            }
        }
        //return;        
    }

    function bool CanReactToGrenades()
    {
        return false;
        //return ReturnValue;        
    }
Begin:

    SetPawnActionState(10);
    stop;                
}

state ReactToNearbyGrenade
{
    function BeginState(name PreviousStateName)
    {
        //return;        
    }

    function EndState(name NextStateName)
    {
        //return;        
    }

    function GotoMoveToGoalState()
    {
        PushState('MoveToGoalWhileRunningFromGrenade');
        //return;        
    }

    function RunToSafePlace()
    {
        local Vector safePlaceLocation;

        // End:0x3C
        if(FindAvoidGrenadeDestination(safePlaceLocation))
        {
            ResetMovementParameters();
            AdjustUnderFireMeter(1.0000000);
            SetMoveGoal(none, 1, safePlaceLocation, 2, false);
        }
        //return;        
    }
Begin:

    RunToSafePlace();
    Sleep(0.0000000);
    EvaluateSituation();
    stop;                
}

state MoveToGoalWhileRunningFromGrenade extends MoveToGoalWhileAttacking
{
    function GotoMoveToGoalState()
    {
        GotoState('MoveToGoalWhileRunningFromGrenade', 'Begin', true, true);
        //return;        
    }

    function MoveToGoalTimerUpdate()
    {
        super(SPAIController).MoveToGoalTimerUpdate();
        // End:0x2F
        if(!HasValidGrenadeToReactTo(m_SoldierPawn.Location))
        {
            AbortMove(false);
            return;
        }
        //return;        
    }

    function TryToReactToNearbyGrenade()
    {
        // End:0x1D
        if(!HasValidGrenadeToReactTo(m_moveGoalInfo.Loc))
        {
            return;
        }
        super(SPSoldierAIController).TryToReactToNearbyGrenade();
        //return;        
    }

    event bool IsMovingToCover()
    {
        return false;
        //return ReturnValue;        
    }

    event bool UpdateFocus()
    {
        return UpdateTargetAndFocusWhileMoving();
        //return ReturnValue;        
    }

    function bool AreWeRunningFromAGrenade()
    {
        return true;
        //return ReturnValue;        
    }
    stop;    
}
