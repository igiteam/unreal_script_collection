class SkyBotControllerPilot extends SkyBotControllerBase
    native
    config(AI);

enum HIJACK_GAMEPLAY_MODE
{
    HIJACK_GAMEPLAY_MODE_SPECIAL_MOVES,// 0
    HIJACK_GAMEPLAY_MODE_TURRET,    // 1
    HIJACK_GAMEPLAY_MODE_MAX        // 2
};

enum E_PILOT_SIM_MODE
{
    PILOT_SIM_MODE_NORMAL,          // 0
    E_PILOT_SIM_MODE_SPLINE,        // 1
    E_PILOT_SIM_MODE_CAUTIOUS,      // 2
    E_PILOT_SIM_MODE_EMERGENCY,     // 3
    E_PILOT_SIM_MODE_MAX            // 4
};

struct native s_SplineLocomotionData
{
    var() InterpTrackSplinePath SplinePath;
    var() bool bFollowSplineReversed;

    structdefaultproperties
    {
        SplinePath=none
        bFollowSplineReversed=false
    }
};

var transient int Temp_State_Int;
var transient float Temp_State_Float;
var transient Vector LastSMExtents;
var transient Vector LastSMStartTracePoint;
var transient Vector LastSMEndTracePoint;
var transient bool bLastTraceBoxInfoIsValid;
var transient bool bStoreBoxInfo;
var transient bool bCurrentlyAutoCorrecting;
var transient bool bSpecialManeauverDebugOn;
var(P_Mechanics) bool bAllowBrakeScaleCheat;
var transient bool bEmergencyMode;
var(P_Collision) bool bDoCareAboutEnemyCollision;
var(P_Collision) bool bCareAboutOtherTeamPawnCollision;
var(P_Collision) bool bCareAboutCollisionPredictionWhileFlyBy;
var transient bool bSpecMoveCollisionPredictionMissing;
var(Debug) bool bSpecialMoveMode;
var(Debug) bool bPermanentFakeRigidBody;
var(Debug) bool bForceAttackPlayer;
var(P_StakeOut) bool bStakeOutGodSight;
var(P_Self_Destruct) bool bSelfDestructible;
var transient bool bForceVehicleRoll;
var(P_Charging) bool bCharging_OverideThrottle;
var(P_Pursuit) bool bAllowedToDoPursuit;
var transient bool bFireMode_Allow;
var transient bool bForceStartWithEasyEvade;
var transient bool bDoingHardEvade;
var transient bool bIsEvading;
var transient bool bTetherEnabled;
var transient bool bCurrentlyMigrating;
var transient bool bAlreadyDrewTetherSphere;
var transient bool bSecondaryFirePending;
var transient bool bHijackGamePlayModeSwitchPending;
var transient bool bSpecialMovePending;
var transient bool bLastSpecialMoveFailed;
var transient bool bFirstTimeHijacked;
var(P_Hover) bool bCanHover;
var(P_Hover) bool bHoverIndefinitely;
var(P_Hover) bool bHoverPeriodicallyMove;
var(P_Hover) bool bHover_MoveWhenLoseLOS;
var(P_Hover) bool bHoverCanAttackRocketPacker;
var transient bool bWantHoverMode;
var transient bool bAlreadyRolledDiceForHoverChance;
var transient bool bAvoidObstacleAllowEarlyOut;
var transient bool bApplyingFullBrakeScale;
var(P_AvoidObstacle) bool PreferRetreatAfterAvoid;
var(P_Kamikaze) bool bCanDoKamikaze;
var transient bool bKamikazeDamageApplied;
var transient bool bCanUseBoost;
var bool bCanEvade;
var transient bool bCollisionPredicted;
var transient bool bCareAboutEnemyCollision;
var(P_FlyBy) bool bOnlyFlyByCurrentEnemy;
var transient bool bAllowedToDoFlyBy;
var(P_FlyBy) bool bStopUpdatingFocalPointDuringBreakAway;
var transient bool bFlyByCurrentlyLockedOut;
var transient bool bDoingFlyByBreakAway;
var transient bool bBreakingAwayRight;
var transient bool bForceFlyBy;
var transient bool bDoingPostFlyBy;
var(P_FlyBy) bool P_FlyBy_RetreatAfterFlyBy;
var(P_FlyBy) bool P_FlyBy_HoverWhenCountIsMet;
var(P_FlyBy) bool P_FlyBy_StumbleWhenCountIsMet;
var(P_FlyBy) bool P_FlyBy_GotoLZWhenCountIsMet;
var transient bool bFollowSplineFailed;
var bool bFollowingSpline;
var bool bStartAtNearest;
var bool bUseSplineRoll;
var bool bOverideTolerance;
var bool bSplineLooping;
var bool bQuitSplineWhenSeeEnemy;
var bool bFollowSplineReversed;
var bool bSlowDownIfNeeded;
var bool bBeenWithinToleranceYet;
var bool bSplineData_PredictedPointCurrentlyBeyondTolerance;
var bool bSplineData_PawnCurrentlyBeyondTolerance;
var bool SplineData_HeadOnCollisionImminent;
var bool bAlreadyCalculatedPointClosestToPawn;
var transient bool SavedSplineDataIsValid;
var transient bool bSplineUseAggressivePrecision;
var bool bCruiseControlOn;
var transient bool bGoingBackToLZToLand;
var(P_TurnAroundVol) bool bCareAboutTurnAroundVolumes;
var bool bTakeoffOnStartup;
var(P_Resting) bool bImmediateTetherResting;
var(P_Resting) bool bDoRestingAfterRetreat;
var transient Vector LastExtents;
var transient Vector LastStartTracePoint;
var transient Vector LastEndTracePoint;
var transient name SpecialManeuverBoxFailed;
var transient name RequestedStatePending;
var transient array<int> PilotPerf;
var(P_Mechanics) float SlowestDesiredMPH;
var transient float SlowestDesiredBrakeScaleInternal;
var(P_Collision) float CollisionPredictionStickMultiplier;
var float LowestMPHCollisionBox;
var(P_Stumble) float P_StumbleWaitAfterSpecialMoveTime;
var(P_PhysicsOveride) float PhysicsOverideTurnScalar;
var(P_PhysicsOveride) float PhysicsOverideLeanScalar;
var(P_Collision) float AIHitBoxWidthOveride;
var(P_Self_Destruct) float SelfDestructRange;
var transient array<Rotator> LastValidAdjustedAim;
var(P_Weapon_Aim) float AirToGroundAimError;
var(P_Weapon_Aim) float AirToAirAimError;
var(P_Weapon_Aim) float AimDelayAfterSM;
var(P_Weapon_Aim) float WeaponAcquireTime;
var transient float WeaponAcquireExpireTime;
var(P_Bail) int PMinDriverLeaveHealth;
var(P_Bail) float PDriverLeaveWhenHitPerc;
var(P_ProjectileMonitoring) float Start_SM_EvadeProj_Dist;
var(P_ProjectileMonitoring) float MonitorProjectileChance;
var transient float ForceVehicleRollAmount;
var(P_Charging) float TooCloseToChargeDist;
var(P_Charging) float ChanceToRollCharge;
var(P_Charging) float ChargingFireSecondaryMinTime;
var(P_Charging) float ChargingFireSecondaryMaxTime;
var(P_Charging) float Charging_SM_Time_Min;
var(P_Charging) float Charging_SM_Time_Max;
var(P_Charging) float Charging_OverideThrottle;
var(P_Charging) float Overide_CollisionBoxSize_Charging;
var(P_Charging) float Overide_LookAheadDist_Charging;
var(P_CloseAttack) float PCloseAttackDist;
var(P_Retreat) float PMinRetreatDist;
var(P_Retreat) float PMaxRetreatDist;
var(P_Retreat) float PRetreatTimer;
var(P_Pursuit) float TooCloseToTeamMateDist;
var(P_Pursuit) float Pursuit_AllowFire_Time_On;
var(P_Pursuit) float Pursuit_AllowFire_Time_Off;
var(P_Pursuit) float PPursuitStayWithinDistMin;
var(P_Pursuit) float PPursuitStayWithinDistMax;
var(P_Pursuit) float PursuitMaxThrottleRatio;
var(P_Pursuit) float PPursuitTooCloseDist;
var(P_Pursuit) float PursuitSecondaryWeapFire_MinSec;
var(P_Pursuit) float PursuitSecondaryWeapFire_MaxSec;
var(P_Evade_Easy_Throttle) float PEvadeIsGreaterThanDistMax_Throttle_Easy;
var(P_Evade_Easy_Throttle) float PEvadeIsLessThanDistMin_Throttle_Easy;
var(P_Evade_Easy_Throttle) float PEvadeInSweetSpot_Throttle_Easy;
var(P_Evade_Easy_TimeUntilFirst) float PMinTimeUntilFirstEasyEvade;
var(P_Evade_Easy_TimeUntilFirst) float PMaxTimeUntilFirstEasyEvade;
var(P_Evade_Easy_Time) float PMinTimeEasyEvade;
var(P_Evade_Easy_Time) float PMaxTimeEasyEvade;
var(P_Evade_Hard) float EH_SpecialManeuverTimerMin;
var(P_Evade_Hard) float EH_SpecialManeuverTimerMax;
var(P_Evade_Hard) float PMinTimeHardEvade;
var(P_Evade_Hard) float PMaxTimeHardEvade;
var(P_Evade_EnterCriteria) float PEvadeThresholdDegreesToEnter;
var(P_Evade_EnterCriteria) float PEvadeFacingThresholdDegreesToEnter;
var(P_Evade_EnterCriteria) float PMaxEvadeDistToEnter;
var(P_Evade_EnterCriteria) float PBlockEvadeDelay;
var(P_Evade_RemainInCriteria) float PEvadeThresholdDegrees;
var(P_Evade_RemainInCriteria) float PEvadeFacingThresholdDegrees;
var(P_Evade_RemainInCriteria) float PMaxEvadeDist;
var(P_Evade_Rethink) float PMinEvadeReThinkSec;
var(P_Evade_Rethink) float PEvadeReThinkVariance;
var(P_Evade_New_Direction) float PEvadeDirectionVarianceDegrees;
var(P_Evade_Time) float PMinTimeInEvadeState;
var(P_Evade_Time) float PMaxTimeInEvadeState;
var(P_Evade) float PMinTimeToEvadeAgain;
var(P_Evade) float PMaxTimeToEvadeAgain;
var(P_Evade) float PEvadeStayWithinDistMin;
var(P_Evade) float PEvadeStayWithinDistMax;
var(P_Evade) float PEvadeMaxThrottleRatio;
var(P_Evade) float EvadeTakeHit_SM_Chance;
var(P_Evade) float EvadeTakeHit_SM_Delay_Min;
var(P_Evade) float EvadeTakeHit_SM_Delay_Max;
var transient float HardEvadeExpireTime;
var transient float EasyEvadeExpireTime;
var(P_Mechanics) float EmergencyBoxTraceRadius;
var(P_Mechanics) float InnerRadius;
var(P_Mechanics) float OuterRadius;
var(P_Mechanics) float GlobalThrottleScale;
var(P_CruisingAlt) float CruisingAltitudeRange;
var(P_Evade_HijackMe_EnterCriteria) float PEvadeThresholdDegreesToEnter_HM;
var(P_Evade_HijackMe_EnterCriteria) float PEvadeFacingThresholdDegreesToEnter_HM;
var(P_Evade_HijackMe_EnterCriteria) float PMaxEvadeDistToEnter_HM;
var(P_Evade_HijackMe_Easy_First) float PMinTimeUntilFirstEasyEvade_HM;
var(P_Evade_HijackMe_Easy_First) float PMaxTimeUntilFirstEasyEvade_HM;
var(P_Evade_HijackMe_Easy) float PMinTimeEasyEvade_HM;
var(P_Evade_HijackMe_Easy) float PMaxTimeEasyEvade_HM;
var(P_Evade_HijackMe_Hard) float PMinTimeHardEvade_HM;
var(P_Evade_HijackMe_Hard) float PMaxTimeHardEvade_HM;
var(P_Evade_HijackMe_RemainInCriteria) float PEvadeThresholdDegrees_HM;
var(P_Evade_HijackMe_RemainInCriteria) float PEvadeFacingThresholdDegrees_HM;
var(P_Evade_HijackMe_RemainInCriteria) float PMaxEvadeDist_HM;
var(P_Evade_HijackMe_Rethink) float PMinEvadeReThinkSec_HM;
var(P_Evade_HijackMe_Rethink) float PEvadeReThinkVariance_HM;
var(P_Evade_HijackMe_NewDirection) float PEvadeDirectionVarianceDegrees_HM;
var(P_Evade_HijackMe_Time) float PMinTimeInEvadeState_HM;
var(P_Evade_HijackMe_Time) float PMaxTimeInEvadeState_HM;
var(P_Evade_HijackMe_Again) float PMinTimeToEvadeAgain_HM;
var(P_Evade_HijackMe_Again) float PMaxTimeToEvadeAgain_HM;
var(P_Evade_HijackMe) float PEvadeStayWithinDistMin_HM;
var(P_Evade_HijackMe) float PEvadeStayWithinDistMax_HM;
var(P_Evade_HijackMe_Throttle) float PEvadeIsGreaterThanDistMax_Throttle_Easy_HM;
var(P_Evade_HijackMe_Easy_Throttle) float PEvadeIsLessThanDistMin_Throttle_Easy_HM;
var(P_Evade_HijackMe_Easy_Throttle) float PEvadeInSweetSpot_Throttle_Easy_HM;
var(P_Evade_HijackMe_Hard_Throttle) float PEvadeIsLessThanDistMin_Throttle_Hard_HM;
var(P_Evade_HijackMe_Hard_Throttle) float PEvadeIsGreaterThanDistMax_Throttle_Hard_HM;
var(P_Evade_HijackMe_Hard_Throttle) float PEvadeInSweetSpot_Throttle_Hard_HM;
var(P_Evade_HijackMe) float EHM_SpecialManeuverTimerMin;
var(P_Evade_HijackMe) float EHM_SpecialManeuverTimerMax;
var(P_TakeOff) float PTakeOffTimer;
var(P_RotationTimedOut) float PWaitToTurnTimer;
var Actor TetherActor;
var float TetherDistance;
var float TetherHeight;
var float TetherInnerDistance;
var float TetherInnerHeight;
var(P_Tether) float PRetreatTowardTetherTimer;
var(P_Charging) float SecondaryWeapFire_MinSec;
var(P_Charging) float SecondaryWeapFire_MaxSec;
var float CheckForHijackersTime;
var(P_BeingHijacked_Rethink_Direction) float BH_PMinEvadeReThinkSec;
var(P_BeingHijacked_Rethink_Direction) float BH_PEvadeReThinkVariance;
var(P_BeingHijacked_Rethink_Direction_Degrees_Pitch) float BH_PEvadeDirectionMaxPitchDegrees;
var(P_BeingHijacked_Rethink_Direction_Degrees_YAW) float BH_PEvadeDirectionMinYawDegrees;
var(P_BeingHijacked_Rethink_Direction_Degrees_YAW) float BH_PEvadeDirectionMaxYawDegrees;
var(P_BeingHijacked_FirstTime_SpecialMove_Chance) float BH_HijackGamePlayMode_StartWithSM_Chance;
var(P_BeingHijacked_FirstTime_SpecialMove_Delay) float BH_SpecialManeuverInitialTimerMin;
var(P_BeingHijacked_FirstTime_SpecialMove_Delay) float BH_SpecialManeuverInitialTimerMax;
var(P_BeingHijacked) float BH_SpecialManeuverTimerMin;
var(P_BeingHijacked) float BH_SpecialManeuverTimerMax;
var SkyBotControllerPilot.HIJACK_GAMEPLAY_MODE HijackGamePlayMode;
var(P_BeingHijacked_GameplayMode_SpecialMove) float BH_HijackGamePlayModeTimerMin_SM;
var(P_BeingHijacked_GameplayMode_SpecialMove) float BH_HijackGamePlayModeTimerMax_SM;
var(P_BeingHijacked_GameplayMode_Turret) float BH_HijackGamePlayModeTimerMin_Turret;
var(P_BeingHijacked_GameplayMode_Turret) float BH_HijackGamePlayModeTimerMax_Turret;
var transient name PendingSpecialManeuver;
var(P_BeingHijacked) float BH_PEvadeMaxThrottleRatio;
var(P_BeingHijacked) float BH_SMSettleTimeMin;
var(P_BeingHijacked) float BH_SMSettleTimeMax;
var(P_Hover) float RadiusFromHoverActorMax;
var(P_Hover) float HoverStateTimeMin;
var(P_Hover) float HoverStateTimeMax;
var(P_Hover) float HoverInLocationTimeMin;
var(P_Hover) float HoverInLocationTimeMax;
var(P_Hover) float HoverChance;
var(P_Hover) Actor HoverActor;
var(P_Hover) float HoverAttackEnterDist;
var(P_RangedAttack) float RangedAttackFocalPointOffset;
var(P_RangedAttack) float TooCloseToRangedAttackFocalPoint;
var(P_AvoidObstacle) float FullBrakeScaleDesiredMPH;
var(P_AvoidObstacle) float AboveThisMPHApplyFullBrakeScale;
var transient Vector DirectionBeforeAvoid;
var(P_AvoidObstacle) float EmergencyModeTime;
var(P_AvoidObstacle) float AvoidDirScale;
var(P_AvoidObstacle) float RetreatAfterAvoidChance;
var(P_AvoidObstacle) float PAvoidObsTimer;
var float PAvoidObsTimer_EarlyOut;
var(P_AvoidObstacle) float Post_AvoidObstacle_Time;
var(P_AvoidObstacle) float AvoidanceLookAheadTime;
var transient Vector ClosestPointOnAvoidanceLine;
var(P_Kamikaze) float KamikazeDamage;
var transient float TurningToDesiredRotationTime;
var() float BeenTooLongInTurnSec;
var transient Rotator CachedAdjustedAimRotation;
var transient int InternalBurstStreamAimCounter;
var transient float TimeLeftBeforeFiringSecondaryWeapon;
var float PilotPredictCollisionPulse;
var float PilotPredictCollisionPulseVariance;
var transient Actor CollisionPredictionHitActor;
var transient Actor IsDirectionUnobstructedHitActor;
var transient Projectile MonitoredProjectile;
var Vector CachedYAxisFBA;
var transient float PostFlyByExpireTime;
var transient Actor CurrentFlyByActor;
var(P_FlyBy) float FlyByFireSecondaryMinTime;
var(P_FlyBy) float FlyByFireSecondaryMaxTime;
var(P_FlyBy) float PFlyByLockOutTime;
var(P_FlyBy) float PFlyByTimer;
var(P_FlyBy) float P_PostFlyByTimer;
var(P_FlyBy) int P_FlyBy_Count;
var transient int P_FlyBy_Counter;
var(P_FlyBy) float P_FlyByRadius;
var(P_FlyBy) float P_FlyByDistFromTarget;
var(P_FlyBy) float P_FlyByBreakOffDist;
var(P_FlyBy) float P_FlyByVelTowardEnemyDegrees;
var(P_FlyBy) float P_FlyByVelVsVelDegrees;
var(P_FlyBy) float P_FlyByEnemyVelMin;
var(P_FlyBy) float P_FlyByLookAheadSec;
var(P_FlyBy) float P_FlyBy_SM180_MinDist;
var InterpTrackSplinePath SplinePath;
var float ToleranceOveride;
var Vector SplineData_PredictedPoint;
var Vector SplineData_ClosestPointToPredictedPoint;
var float SplineData_ClosestTimeToPredictedPoint;
var float SplineData_DistToPredictedPoint;
var float SplineData_ToleranceAtPredictedPoint;
var float SplineData_LastClosestTimeToPredictedPoint;
var float SplineData_ToleranceAtVehPoint;
var Vector SplineData_ClosestPointToPawn;
var float SplineData_ClosestTimeToPawn;
var transient Vector SplineData_HighPrecision_Location;
var int SplineData_BaseKeyVehicle;
var int SplineData_BaseKeyPredictedPoint;
var float SplineData_PredictedPointLastSearchMin;
var float SplineData_PredictedPointLastSearchMax;
var transient float SavedManeuverAcceleration;
var transient float SavedManeuverDeceleration;
var transient float SavedManeuverMaxRate;
var transient float SavedBrakeScale;
var transient InterpTrackSplinePath SplinePathBackToTether;
var(Spline) float SplineLowestDesiredMPH;
var(Spline) float SplineManeuverAcceleration;
var(Spline) float SplineManeuverDeceleration;
var(Spline) float SplineManeuverMaxRate;
var(Spline) float SplineBrakeScale;
var(Spline) float SplineBrakeScale_AggressivePrecision;
var float SplineSteeringPulse;
var(Spline) float SplineSteeringPulse_Default;
var(Spline) float SplineSteeringPulse_AggressivePrecision;
var(Spline) float SplineData_PredictAheadSeconds;
var(Spline) float SplineData_PredictAheadCorrectiveSeconds;
var(Spline) float SplineData_VehOutsideToleranceCorrectiveSeconds;
var(Spline) float SplineData_PredictAheadCorrective_DistMin;
var(Spline) float SplineData_PredictAheadCorrective_DistMax;
var float SplineData_ThrottleSlowdownDistBehind0;
var Vector SplineData_ThrottleSlowdownDistBehindPos0;
var float SplineData_ThrottleSlowdownDistAhead1;
var Vector SplineData_ThrottleSlowdownDistAheadPos1;
var float SplineData_ThrottleSlowdownDistAhead2;
var Vector SplineData_ThrottleSlowdownDistAheadPos2;
var(Spline) float SplineData_FocalPoint_MinMPH;
var(Spline) float SplineData_ThrottleSlowdownDistBehind0_Default;
var(Spline) float SplineData_ThrottleSlowdownDistAhead1_Default;
var(Spline) float SplineData_ThrottleSlowdownDistAhead2_Default;
var(Spline) float SplineData_ThrottleSlowdownDistBehind0_AggressivePrecision;
var(Spline) float SplineData_ThrottleSlowdownDistAhead1_AggressivePrecision;
var(Spline) float SplineData_ThrottleSlowdownDistAhead2_AggressivePrecision;
var float CruiseControlSpeedMPH;
var float CruiseControlTimeToReachSpeed;
var array<SkySplineVolume> TouchingSplineVolumeList;
var array<SkySplineVolume> DestTouchingSplineVolumeList;
var array<s_SplineLocomotionData> SplinesInCommonList;
var transient SkyAILandingZone CurrentAILandingZone;
var transient SkyAILandingZone LastSuccessfulLandingZone;
var transient Vector TakeoffDirection;
var int TeamNum;
var(P_Resting) float P_RestingWaitTime;

// Export USkyBotControllerPilot::execChooseSpecialManeuver(FFrame&, void* const)
native final function name ChooseSpecialManeuver(SkySpecialManeuverActor.ESpecialManeuverDefinition SMD, bool bUseDefinition);

// Export USkyBotControllerPilot::execAdjustThrottleBySplineLookAhead(FFrame&, void* const)
native final function float AdjustThrottleBySplineLookAhead();

// Export USkyBotControllerPilot::execPilotPredictCollisionNative(FFrame&, void* const)
native final function bool PilotPredictCollisionNative();

// Export USkyBotControllerPilot::execCanIHoverToAttack(FFrame&, void* const)
native final function bool CanIHoverToAttack(Actor pActorToAttack);

// Export USkyBotControllerPilot::execIsActorOnGround(FFrame&, void* const)
native final function bool IsActorOnGround(Actor pActorToAttack);

// Export USkyBotControllerPilot::execPlayPilotChatter(FFrame&, void* const)
native final function bool PlayPilotChatter(Actor.E_PILOT_CHATTER_CATEGORY category, int TeamIndex);

// Export USkyBotControllerPilot::execDoSplineSteering(FFrame&, void* const)
native final function DoSplineSteering();

// Export USkyBotControllerPilot::execFindBestSplinePath(FFrame&, void* const)
native final function FindBestSplinePath(InterpTrackSplinePath.E_SPLINEPATH_TYPE Type, Actor destActor, out s_SplineLocomotionData splinePathData, optional Vector destPoint);

// Export USkyBotControllerPilot::execGetTeamNum(FFrame&, void* const)
native simulated function byte GetTeamNum();

// Export USkyBotControllerPilot::execIsOutsideTether(FFrame&, void* const)
native final function bool IsOutsideTether(float predictedSeconds);

simulated event PostBeginPlay()
{
    TakeoffDirection = vect(0.0000000, 0.0000000, 0.0000000);
    SetTimer(5.0000000, true, 'FindNewThreat');
    SetTimer(0.5000000, true, 'TryToShootSomething');
    bCareAboutEnemyCollision = bDoCareAboutEnemyCollision;
    super(SkyAIController).PostBeginPlay();
    //return;    
}

simulated function EmergencyModeExpired()
{
    local SkyAirVehicle SAV;

    bEmergencyMode = false;
    SAV = SkyAirVehicle(Pawn);
    // End:0x41
    if(SAV != none)
    {
        // End:0x41
        if(bPermanentFakeRigidBody == false)
        {
            SAV.bFakeRigidBody = false;
        }
    }
    //return;    
}

simulated function TryToShootSomething()
{
    local int I;
    local Vector myFacing, vMeToEnemy;

    // End:0x181
    if((Pawn != none) && !Pawn.IsFiring())
    {
        myFacing = Vector(Pawn.Rotation);
        I = 0;
        J0x44:

        // End:0x181 [Loop If]
        if(I < 8)
        {
            // End:0x177
            if(Squad.Enemies[I] != none)
            {
                vMeToEnemy = Squad.Enemies[I].GetTargetLocation(self) - Pawn.Location;
                // End:0x177
                if((vMeToEnemy Dot myFacing) >= 0.0000000)
                {
                    // End:0x177
                    if(VSize(vMeToEnemy) <= 25000.0000000)
                    {
                        // End:0x177
                        if(CanAttack(Squad.Enemies[I]))
                        {
                            // End:0x150
                            if(CheckFirePermit(Squad.Enemies[I]))
                            {
                                FireWeaponAt(Squad.Enemies[I]);
                                SetTimer(2.5000000 + (FRand() * 0.5000000), false, 'PotShotStopFiring');
                            }
                            // End:0x177
                            if(bSecondaryFirePending == true)
                            {
                                FirePendingSecondary(Squad.Enemies[I]);
                            }
                        }
                    }
                }
            }
            I++;
            // [Loop Continue]
            goto J0x44;
        }
    }
    //return;    
}

simulated event SetPilotSimValues(SkyBotControllerPilot.E_PILOT_SIM_MODE Mode)
{
    local SkyAirVehicle SAV;
    local editinline SkyVehicleSim_CrimsonAircraft Sim;

    SAV = SkyAirVehicle(Pawn);
    // End:0x163
    if(SAV != none)
    {
        Sim = SkyVehicleSim_CrimsonAircraft(SAV.SimObj);
        // End:0x163
        if(Sim != none)
        {
            switch(Mode)
            {
                // End:0x148
                case 0:
                    Sim.BrakeScale = SkyVehicleSim_CrimsonAircraft(Sim.ObjectArchetype).BrakeScale;
                    Sim.Deceleration = SkyVehicleSim_CrimsonAircraft(Sim.ObjectArchetype).Deceleration;
                    Sim.ManeuverAcceleration = SkyVehicleSim_CrimsonAircraft(Sim.ObjectArchetype).ManeuverAcceleration;
                    Sim.ManeuverDeceleration = SkyVehicleSim_CrimsonAircraft(Sim.ObjectArchetype).ManeuverDeceleration;
                    Sim.ManeuverMaxRate = SkyVehicleSim_CrimsonAircraft(Sim.ObjectArchetype).ManeuverMaxRate;
                    Sim.bIsHovering = false;
                    // End:0x163
                    break;
                // End:0x150
                case 1:
                    // End:0x163
                    break;
                // End:0x158
                case 2:
                    // End:0x163
                    break;
                // End:0x160
                case 3:
                    // End:0x163
                    break;
                // End:0xFFFF
                default:
                    break;
            }
        }
        else
        {
        }/* !MISMATCHING REMOVE, tried If got Type:Else Position:0x163! */
        //return;        
    }/* !MISMATCHING REMOVE, tried Else got Type:If Position:0x010! */
}

simulated function SetBrakeScale(float newBrakeScale)
{
    local SkyAirVehicle SAV;
    local editinline SkyVehicleSim_CrimsonAircraft Sim;

    SAV = SkyAirVehicle(Pawn);
    Sim = SkyVehicleSim_CrimsonAircraft(SAV.SimObj);
    // End:0x4A
    if(Sim != none)
    {
        Sim.BrakeScale = newBrakeScale;
    }
    //return;    
}

simulated event SetBrakeScaleForMPH(float DesiredMPH)
{
    local SkyAirVehicle SAV;
    local editinline SkyVehicleSim_CrimsonAircraft Sim;
    local float SlowestSpeed;

    SAV = SkyAirVehicle(Pawn);
    Sim = SkyVehicleSim_CrimsonAircraft(SAV.SimObj);
    // End:0x13C
    if(Sim != none)
    {
        SlowestSpeed = SAV.AirSpeed * Sim.BrakeScale;
        SlowestSpeed *= 0.0223693;
        // End:0xD3
        if(SlowestSpeed > DesiredMPH)
        {
            J0x76:

            // End:0xD0 [Loop If]
            if(SlowestSpeed > DesiredMPH)
            {
                Sim.BrakeScale -= 0.0500000;
                SlowestSpeed = SAV.AirSpeed * Sim.BrakeScale;
                SlowestSpeed *= 0.0223693;
                // [Loop Continue]
                goto J0x76;
            }            
        }
        else
        {
            // End:0x13C
            if(SlowestSpeed < DesiredMPH)
            {
                J0xE2:

                // End:0x13C [Loop If]
                if(SlowestSpeed < DesiredMPH)
                {
                    Sim.BrakeScale += 0.0500000;
                    SlowestSpeed = SAV.AirSpeed * Sim.BrakeScale;
                    SlowestSpeed *= 0.0223693;
                    // [Loop Continue]
                    goto J0xE2;
                }
            }
        }
    }
    //return;    
}

simulated function FindNewThreat()
{
    // End:0x21
    if(Squad != none)
    {
        Squad.FindNewEnemyFor(self, false);
    }
    //return;    
}

simulated function DoBeginCode()
{
    //return;    
}

simulated function DoEndCode()
{
    //return;    
}

simulated function OnEnterNewState()
{
    TurningToDesiredRotationTime = 0.0000000;
    bAllowedToDoFlyBy = true;
    //return;    
}

simulated function SkyBot GetBehaviorTreeController()
{
    // End:0x7B
    if(((SkyVehicle(Pawn) != none) && SkyVehicle(Pawn).Driver != none) && SkyBot(SkyVehicle(Pawn).Driver.Controller) != none)
    {
        return SkyBot(SkyVehicle(Pawn).Driver.Controller);
    }
    return none;
    //return ReturnValue;    
}

event SetTeam(int inTeamIdx)
{
    TeamNum = inTeamIdx;
    //return;    
}

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    //return;    
}

simulated function DoSeekLandingZoneExpired()
{
    SetTimer(1.0000000, false, 'DoSeekLandingZoneExpired');
    //return;    
}

simulated event SeekLandingZone(SkyAILandingZone pLZone)
{
    CurrentAILandingZone = pLZone;
    SetTimer(1.0000000, false, 'DoSeekLandingZoneExpired');
    //return;    
}

simulated event float GetLookAheadDistOveride()
{
    return 1000.0000000;
    //return ReturnValue;    
}

simulated event ExitRocketPackThrust()
{
    local SkyAirVehicle_RocketPackThrust pRPT;

    pRPT = SkyAirVehicle_RocketPackThrust(Pawn);
    // End:0x30
    if(pRPT != none)
    {
        pRPT.DriverLeave(true);
    }
    SkyPawn(Pawn).TurnOffRocketPackThrust();
    //return;    
}

simulated event EnteredCurrentLandingZone(bool bLeaveVehicleOnLZEntry)
{
    local SkyBot BTController;

    LastSuccessfulLandingZone = CurrentAILandingZone;
    CurrentAILandingZone = none;
    BTController = GetBehaviorTreeController();
    // End:0x7C
    if(BTController != none)
    {
        // End:0x5A
        if(bGoingBackToLZToLand)
        {
            BTController.FireExternalEvent("ReachedLZToLand");            
        }
        else
        {
            BTController.FireExternalEvent("ReachedLZToHover");
        }
    }
    // End:0x8F
    if(bLeaveVehicleOnLZEntry)
    {
        ExitRocketPackThrust();
    }
    //return;    
}

simulated event UpdateTouchingVolumeList()
{
    local SkySplineVolume V;

    TouchingSplineVolumeList.Length = 0;
    // End:0x30
    foreach Pawn.TouchingActors(Class'SkySplineVolume', V)
    {
        TouchingSplineVolumeList.AddItem(V);        
    }    
    //return;    
}

simulated event UpdateDestinationTouchingVolumeList(Actor destActor)
{
    local SkySplineVolume V;

    DestTouchingSplineVolumeList.Length = 0;
    // End:0x30
    foreach destActor.TouchingActors(Class'SkySplineVolume', V)
    {
        DestTouchingSplineVolumeList.AddItem(V);        
    }    
    //return;    
}

simulated event UpdateDestinationTouchingVolumeListByPoint(Vector destVector)
{
    local SkySplineVolume V;

    DestTouchingSplineVolumeList.Length = 0;
    // End:0x3B
    foreach Pawn.CollidingActors(Class'SkySplineVolume', V, 100000.0000000, destVector)
    {
        DestTouchingSplineVolumeList.AddItem(V);        
    }    
    //return;    
}

simulated event Destroyed()
{
    // End:0x23
    if(SplinePath != none)
    {
        SplinePath.RemoveClaimant(self);
        SplinePath = none;
    }
    super.Destroyed();
    //return;    
}

event Possess(Pawn aPawn, bool bVehicleTransition)
{
    local SkyAirVehicle SAV;
    local editinline SkyVehicleSim_CrimsonAircraft Sim;
    local float SlowestSpeed;

    SAV = SkyAirVehicle(aPawn);
    // End:0x187
    if((SAV != none) && bAllowBrakeScaleCheat)
    {
        Sim = SkyVehicleSim_CrimsonAircraft(SAV.SimObj);
        // End:0x187
        if(Sim != none)
        {
            // End:0x79
            if(SAV.bAISmallVehicle == false)
            {
                SlowestDesiredBrakeScaleInternal = Sim.BrakeScale;                
            }
            else
            {
                SlowestDesiredBrakeScaleInternal = SkyVehicleSim_CrimsonAircraft(Sim.ObjectArchetype).BrakeScale;
                SlowestSpeed = SAV.AirSpeed * SlowestDesiredBrakeScaleInternal;
                SlowestSpeed *= 0.0223693;
                // End:0x11D
                if(SlowestSpeed > SlowestDesiredMPH)
                {
                    J0xD4:

                    // End:0x11A [Loop If]
                    if(SlowestSpeed > SlowestDesiredMPH)
                    {
                        SlowestDesiredBrakeScaleInternal -= 0.1000000;
                        SlowestSpeed = SAV.AirSpeed * SlowestDesiredBrakeScaleInternal;
                        SlowestSpeed *= 0.0223693;
                        // [Loop Continue]
                        goto J0xD4;
                    }                    
                }
                else
                {
                    // End:0x172
                    if(SlowestSpeed < SlowestDesiredMPH)
                    {
                        J0x12C:

                        // End:0x172 [Loop If]
                        if(SlowestSpeed < SlowestDesiredMPH)
                        {
                            SlowestDesiredBrakeScaleInternal += 0.1000000;
                            SlowestSpeed = SAV.AirSpeed * SlowestDesiredBrakeScaleInternal;
                            SlowestSpeed *= 0.0223693;
                            // [Loop Continue]
                            goto J0x12C;
                        }
                    }
                }
                Sim.BrakeScale = SlowestDesiredBrakeScaleInternal;
            }
        }
    }
    super.Possess(aPawn, bVehicleTransition);
    //return;    
}

event UnPossess()
{
    local SkyAirVehicle SAV;
    local editinline SkyVehicleSim_CrimsonAircraft Sim;

    SAV = SkyAirVehicle(Pawn);
    // End:0x66
    if(SAV != none)
    {
        bPermanentFakeRigidBody = false;
        SAV.bFakeRigidBody = false;
        Sim = SkyVehicleSim_CrimsonAircraft(SAV.SimObj);
        // End:0x66
        if(Sim != none)
        {
            SetPilotSimValues(0);
        }
    }
    super(SkyAIController).UnPossess();
    //return;    
}

simulated function bool ReachedFocalPoint(float Dist)
{
    local Vector Extent;

    // End:0x76
    if(Pawn != none)
    {
        Pawn.GetBoundingCylinder(Extent.X, Extent.Z);
        // End:0x76
        if(VSize(GetFocalPoint() - Pawn.Location) <= (Extent.X + Dist))
        {
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

simulated event bool ShouldOffsetFocalPointAbovePawn()
{
    return true;
    //return ReturnValue;    
}

simulated event float GetHitBoxWidthOveride()
{
    return 0.1000000;
    //return ReturnValue;    
}

simulated event bool ShouldShrinkCollisionBox()
{
    return false;
    //return ReturnValue;    
}

simulated event SetCruiseControl(float MilesPerHour, float TimeToReachSpeed)
{
    bCruiseControlOn = true;
    CruiseControlSpeedMPH = MilesPerHour;
    CruiseControlTimeToReachSpeed = TimeToReachSpeed;
    //return;    
}

function VehicleFightEnemy()
{
    // End:0x2E
    if((SkyAirVehicle(Pawn) != none) && Enemy != none)
    {
        DoRangedAttackOn(Enemy);
        return;
    }
    //return;    
}

simulated function bool MigrationCheck()
{
    // End:0x29
    if(bTetherEnabled && IsOutsideTether(0.0000000))
    {
        GotoState('FlyingMigrate');
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated function HandleEnemySwitchedPawn(Pawn OldPawn, Pawn NewPawn)
{
    // End:0x2C
    if((bLockedEnemy == true) && LockedEnemy == OldPawn)
    {
        LockEnemy(NewPawn);
    }
    // End:0x46
    if(CurrentFlyByActor == OldPawn)
    {
        CurrentFlyByActor = NewPawn;
    }
    super(SkyAIController).HandleEnemySwitchedPawn(OldPawn, NewPawn);
    //return;    
}

simulated event bool CareAboutCollisionPrediction()
{
    return true;
    //return ReturnValue;    
}

simulated function bool AllowedToDoSpecialManeuver()
{
    return true;
    //return ReturnValue;    
}

simulated function BeingHijacked()
{
    bFirstTimeHijacked = true;
    DoFlyingBeingHijacked();
    //return;    
}

function CheckForHijackers()
{
    local SkyAirVehicle SAV;

    SAV = SkyAirVehicle(Pawn);
    // End:0x3E
    if((SAV != none) && SAV.IsBeingHijacked())
    {
        DoFlyingBeingHijacked();
    }
    //return;    
}

function DoneReactingFSMD()
{
    GotoState('FlyingAvoidObstacle');
    //return;    
}

simulated function EnterTurnAroundVolumes()
{
    GotoState('FlyingTurnAroundVolume');
    //return;    
}

simulated event ExitTurnAroundVolumes()
{
    //return;    
}

event bool CollisionPredicted(Vector vSuggestedNewFocalPoint, bool bForceRoll, int suggestedRollValue)
{
    Focus = none;
    SetFocalPoint(vSuggestedNewFocalPoint);
    // End:0x4D
    if(bForceRoll)
    {
        SkyAirVehicle(Pawn).ForceRoll = true;
        SkyAirVehicle(Pawn).ForceRollValue = suggestedRollValue;
    }
    GotoState('FlyingAvoidObstacle');
    return true;
    //return ReturnValue;    
}

event bool FaceRotationTimeOut()
{
    GotoState('FlyingRotationTimedOut');
    return true;
    //return ReturnValue;    
}

function bool PickSpecialManeuver(SkySpecialManeuverActor.ESpecialManeuverDefinition SMD, bool bUseDefinition)
{
    local SkyAirVehicle SAV;
    local name SpecialMan;

    bSpecialMovePending = true;
    PendingSpecialManeuver = 'None';
    // End:0x112
    if(((bEmergencyMode == false) && (AllowedToDoSpecialManeuver()) == true) && SkyAirVehicle(Pawn).AllowSpecialMoves() == true)
    {
        SAV = SkyAirVehicle(Pawn);
        // End:0x112
        if(!(SAV.PotentialHijacker != none) && SAV.PotentialHijacker.IsEndingHijack() && !SAV.IsStalled())
        {
            // End:0x112
            if((SkyAirVehicle(Pawn).CurrentActiveSpecialManeuver == 'None') && GetStateName() != 'FlyingSpecialManeuver')
            {
                SpecialMan = ChooseSpecialManeuver(SMD, bUseDefinition);
                PendingSpecialManeuver = SpecialMan;
            }
        }
    }
    return PendingSpecialManeuver != 'None';
    //return ReturnValue;    
}

function TrySpecialManeuverTimer()
{
    bSpecialMovePending = true;
    //return;    
}

function SwitchHijackGamePlayMode()
{
    local SkyAirVehicle_UFO SAV;

    SAV = SkyAirVehicle_UFO(Pawn);
    // End:0xA9
    if(SAV != none)
    {
        // End:0x36
        if(int(HijackGamePlayMode) == int(0))
        {
            HijackGamePlayMode = 1;            
        }
        else
        {
            HijackGamePlayMode = 0;
        }
        // End:0x7D
        if(int(HijackGamePlayMode) == int(0))
        {
            SetTimer((0.0001000 + BH_HijackGamePlayModeTimerMin_SM) + (FRand() * (BH_HijackGamePlayModeTimerMax_SM - BH_HijackGamePlayModeTimerMin_SM)), false, 'SwitchHijackGamePlayModeExpired');            
        }
        else
        {
            SetTimer((0.0001000 + BH_HijackGamePlayModeTimerMin_Turret) + (FRand() * (BH_HijackGamePlayModeTimerMax_Turret - BH_HijackGamePlayModeTimerMin_Turret)), false, 'SwitchHijackGamePlayModeExpired');
        }
    }
    //return;    
}

simulated function SwitchHijackGamePlayModeExpired()
{
    bHijackGamePlayModeSwitchPending = true;
    //return;    
}

simulated function bool ReadyToDoSM()
{
    // End:0x31
    if(((bEmergencyMode == false) && bSpecialMovePending == true) && PendingSpecialManeuver != 'None')
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated function ClearPendingSM()
{
    bSpecialMovePending = false;
    PendingSpecialManeuver = 'None';
    //return;    
}

simulated function WaitForSpecialManeuverToSettle()
{
    //return;    
}

function ChooseAttackMode()
{
    // End:0x1A
    if(SkyAirVehicle(Pawn) != none)
    {
        VehicleFightEnemy();
    }
    //return;    
}

function FightEnemy()
{
    ChooseAttackMode();
    //return;    
}

simulated function bool IsOnlyATarget(Pawn TestPawn)
{
    return !(SkyPawn(TestPawn) != none) || SkyVehicle(TestPawn) != none;
    //return ReturnValue;    
}

simulated function DoEvade()
{
    // End:0x21
    if(SkyAirVehicle_RocketPackThrust(Enemy) != none)
    {
        GotoState('FlyingEvadeHijackMe');        
    }
    else
    {
        GotoState('FlyingEvade');
    }
    //return;    
}

function Restart(bool bVehicleTransition)
{
    super.Restart(bVehicleTransition);
    GotoState('Start_State');
    //return;    
}

// Export USkyBotControllerPilot::execUseTakeoffVector(FFrame&, void* const)
native final function UseTakeoffVector(Vector TakeoffVector);

// Export USkyBotControllerPilot::execClearTakeoffVector(FFrame&, void* const)
native final function ClearTakeoffVector();

event bool SetFollowSpline(s_FollowSplineData Data)
{
    // End:0x21
    if(Data.SplinePath == none)
    {
        bFollowSplineFailed = true;        
    }
    else
    {
        // End:0x313
        if(((Data.bFollowSplineReversed == false) && int(Data.SplinePath.CurrentDirectionMode) != int(2)) || (Data.bFollowSplineReversed == true) && int(Data.SplinePath.CurrentDirectionMode) != int(1))
        {
            SplinePath = Data.SplinePath;
            // End:0xE7
            if(Data.bOverideUseSplineRoll == true)
            {
                bUseSplineRoll = Data.bUseSplineRoll;                
            }
            else
            {
                bUseSplineRoll = Data.SplinePath.bDefaultUseSplineRoll;
            }
            // End:0x13B
            if(Data.bOverideUseAggressivePrecision == true)
            {
                bSplineUseAggressivePrecision = Data.bUseAggressivePrecision;                
            }
            else
            {
                bSplineUseAggressivePrecision = Data.SplinePath.bUseAggressivePrecision;
            }
            // End:0x18D
            if(Data.bOverideLowestDesiredMPH == true)
            {
                SplineLowestDesiredMPH = Data.LowestDesiredMPH;                
            }
            else
            {
                SplineLowestDesiredMPH = Data.SplinePath.LowestDesiredMPH;
            }
            bOverideTolerance = Data.bOverideTolerance;
            ToleranceOveride = Data.ToleranceOveride;
            // End:0x20D
            if(Data.bOverideLooping == true)
            {
                bSplineLooping = Data.bLooping;                
            }
            else
            {
                bSplineLooping = Data.SplinePath.bLooping;
            }
            // End:0x261
            if(Data.bQuitSplineWhenSeeEnemyOveride == true)
            {
                bQuitSplineWhenSeeEnemy = Data.bQuitSplineWhenSeeEnemy;                
            }
            else
            {
                bQuitSplineWhenSeeEnemy = Data.SplinePath.bQuitSplineWhenSeeEnemy;
            }
            // End:0x2B5
            if(Data.bSlowDownIfNeededOveride == true)
            {
                bSlowDownIfNeeded = Data.bSlowDownIfNeeded;                
            }
            else
            {
                bSlowDownIfNeeded = Data.SplinePath.bSlowDownIfNeeded;
            }
            bFollowSplineReversed = Data.bFollowSplineReversed;
            SplinePath.AddClaimant(self);
            GotoState('FlyingFollowSpline');
            return true;            
        }
    }
    return false;
    //return ReturnValue;    
}

simulated function ExitWantHover()
{
    bWantHoverMode = false;
    GotoState('FlyingRangedAttack');
    //return;    
}

simulated function DoHover(Actor myHoverActor)
{
    // End:0x65
    if(bCanHover == true)
    {
        bWantHoverMode = true;
        HoverActor = myHoverActor;
        // End:0x57
        if(bHoverIndefinitely == false)
        {
            SetTimer((0.0001000 + HoverStateTimeMin) + (FRand() * (HoverStateTimeMax - HoverStateTimeMin)), false, 'ExitWantHover');
        }
        GotoState('FlyingHoverAttack');
    }
    //return;    
}

simulated function OnToggleHover(SkySeqAct_ToggleHover Action)
{
    bHoverIndefinitely = Action.bHoverIndefinitely;
    bHoverPeriodicallyMove = Action.bHoverPeriodicallyMove;
    bHover_MoveWhenLoseLOS = Action.bHover_MoveWhenLoseLOS;
    // End:0x74
    if(Action.bHoverOn == false)
    {
        bWantHoverMode = false;
        GotoState('FlyingRangedAttack');        
    }
    else
    {
        DoHover(Action.HoverActor);
    }
    //return;    
}

event bool OnFollowSpline(SkySeqAct_FollowSpline Action)
{
    local int Index;

    // End:0x22
    if(Action.bExitSplineFollowing == true)
    {
        ExitSplineFollowing();
        return true;
    }
    // End:0x57
    if(Action.Data.Length > 1)
    {
        Index = Rand(10000) % Action.Data.Length;
    }
    // End:0x87
    if(Action.Data[Index].SplinePath == none)
    {
        bFollowSplineFailed = true;
        return false;
    }
    return SetFollowSpline(Action.Data[Index]);
    //return ReturnValue;    
}

event InitFollowSplineData(out s_FollowSplineData outData)
{
    local s_FollowSplineData dummyData;

    outData = dummyData;
    //return;    
}

function OnSetTether(SkySeqAct_SetTether Action)
{
    local Actor InTether;
    local array<Object> objVars;
    local int Idx, num;
    local Controller C;

    Action.GetObjectVars(objVars, "Tether Actor");
    num = objVars.Length;
    Idx = 0;
    J0x36:

    // End:0x73 [Loop If]
    if(Idx < num)
    {
        InTether = Actor(objVars[Idx]);
        // End:0x69
        if(InTether != none)
        {
            // [Explicit Break]
            goto J0x73;
        }
        Idx++;
        // [Loop Continue]
        goto J0x36;
    }
    J0x73:

    C = Controller(InTether);
    // End:0xA3
    if(C != none)
    {
        InTether = C.Pawn;
    }
    TetherActor = InTether;
    TetherDistance = Action.TetherDistance;
    TetherHeight = Action.TetherHeight;
    TetherInnerDistance = Action.TetherInnerDistance;
    TetherInnerHeight = Action.TetherInnerHeight;
    SplinePathBackToTether = Action.SplinePathBackToTether;
    //return;    
}

function OnPilotSeekLandingZone(SkySeqAct_PilotSeekLandingZone Action)
{
    local int I;
    local SkyGame Info;

    // End:0xAF
    if(WorldInfo != none)
    {
        Info = SkyGame(WorldInfo.Game);
        // End:0xAF
        if(Info != none)
        {
            I = 0;
            J0x37:

            // End:0xAF [Loop If]
            if(I < Info.AvailLandingZones.Length)
            {
                // End:0xA5
                if(Info.AvailLandingZones[I] != none)
                {
                    SeekLandingZone(Info.AvailLandingZones[I]);
                    bGoingBackToLZToLand = Action.bGoingBackToLZToLand;
                    // [Explicit Break]
                    goto J0xAF;
                }
                I++;
                // [Loop Continue]
                goto J0x37;
            }
        }
    }
    J0xAF:

    //return;    
}

function OnSetPilotVars(SkySeqAct_SetPilotVars Action)
{
    local Actor AltitudeActor;
    local array<Object> objVars;
    local Controller C;

    Action.GetObjectVars(objVars, "Cruising Altitude Actor");
    AltitudeActor = Actor(objVars[0]);
    // End:0x4E
    if(AltitudeActor != none)
    {        
    }
    else
    {
        C = Controller(AltitudeActor);
        // End:0x7E
        if(C != none)
        {
            AltitudeActor = C.Pawn;
        }
    }
    // End:0xB8
    if(AltitudeActor != none)
    {
        SkyAirVehicle(Pawn).CruisingAltitude = AltitudeActor.Location.Z;
    }
    // End:0xE0
    if(Action.bSetGlobalThrottleScale)
    {
        GlobalThrottleScale = Action.GlobalThrottleScale;
    }
    // End:0x108
    if(Action.bSetCruisingAltitudeRange)
    {
        CruisingAltitudeRange = Action.CruisingAltitudeRange;
    }
    // End:0x132
    if(Action.bSetCareAboutCollisionPredictionWhileFlyBy)
    {
        bCareAboutCollisionPredictionWhileFlyBy = Action.bCareAboutCollisionPredictionWhileFlyBy;
    }
    //return;    
}

function OnRequestChangeState(SkySeqAct_RequestChangeState Action)
{
    // End:0x4F
    if(Action.NewState != 'None')
    {
        RequestedStatePending = Action.NewState;
        SetTimer(0.0500000, true, 'RequestChangeState');
        RequestChangeState();
    }
    //return;    
}

simulated function RequestChangeState()
{
    // End:0x1D
    if(RequestedStatePending != 'None')
    {
        GotoState(RequestedStatePending);
    }
    ClearTimer('RequestChangeState');
    //return;    
}

function Timer()
{
    //return;    
}

// Export USkyBotControllerPilot::execGetDesiredThrottleSpeedNative(FFrame&, void* const)
native final function float GetDesiredThrottleSpeedNative();

simulated event float GetDesiredThrottleSpeed()
{
    return GetDesiredThrottleSpeedNative();
    //return ReturnValue;    
}

simulated function bool ShouldEvade()
{
    local float myCompareDist, myCompareDot, myPawnFacingCompareDot;
    local Vector PawnFacing;

    // End:0x1F5
    if(bCanEvade == true)
    {
        // End:0x1E
        if(SkyAirVehicle(Enemy) == none)
        {
            return false;
        }
        // End:0xBF
        if(SkyAirVehicle_RocketPackThrust(Enemy) != none)
        {
            // End:0x7B
            if(bIsEvading)
            {
                myCompareDist = PMaxEvadeDist_HM;
                myCompareDot = Cos(PEvadeThresholdDegrees_HM * (3.1415930 / 180.0000000));
                myPawnFacingCompareDot = Cos(PEvadeFacingThresholdDegrees_HM * (3.1415930 / 180.0000000));                
            }
            else
            {
                myCompareDist = PMaxEvadeDistToEnter_HM;
                myCompareDot = Cos(PEvadeThresholdDegreesToEnter_HM * (3.1415930 / 180.0000000));
                myPawnFacingCompareDot = Cos(PEvadeFacingThresholdDegreesToEnter_HM * (3.1415930 / 180.0000000));
            }            
        }
        else
        {
            // End:0x10C
            if(bIsEvading)
            {
                myCompareDist = PMaxEvadeDist;
                myCompareDot = Cos(PEvadeThresholdDegrees * (3.1415930 / 180.0000000));
                myPawnFacingCompareDot = Cos(PEvadeFacingThresholdDegrees * (3.1415930 / 180.0000000));                
            }
            else
            {
                myCompareDist = PMaxEvadeDistToEnter;
                myCompareDot = Cos(PEvadeThresholdDegreesToEnter * (3.1415930 / 180.0000000));
                myPawnFacingCompareDot = Cos(PEvadeFacingThresholdDegreesToEnter * (3.1415930 / 180.0000000));
            }
        }
        // End:0x1F5
        if(VSize(Pawn.Location - Enemy.GetTargetLocation(self)) < myCompareDist)
        {
            PawnFacing = Vector(Pawn.Rotation);
            // End:0x1F5
            if((PawnFacing Dot Normal(Pawn.Location - Enemy.GetTargetLocation(self))) >= myCompareDot)
            {
                // End:0x1F5
                if((PawnFacing Dot Vector(Enemy.Rotation)) >= myPawnFacingCompareDot)
                {
                    return true;
                }
            }
        }
    }
    return false;
    //return ReturnValue;    
}

simulated function EnableEvadeAgain()
{
    bCanEvade = true;
    //return;    
}

function NotifyTakeHit(Controller InstigatedBy, Vector HitLocation, int Damage, class<DamageType> DamageType, Vector Momentum)
{
    super.NotifyTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum);
    // End:0xC2
    if((Pawn.Health > 0) && Damage > 0)
    {
        // End:0xB8
        if((Pawn.Health < PMinDriverLeaveHealth) && SkyAirVehicle(Pawn) != none)
        {
            // End:0xB8
            if(FRand() <= PDriverLeaveWhenHitPerc)
            {
                SkyAirVehicle(Pawn).TriggerEventClass(Class'SkySeqEvent_PilotBail', Pawn);
                SkyAirVehicle(Pawn).DriverLeave(true);
            }
        }
        WhatToDoNext();
    }
    //return;    
}

simulated event FindSplinePathUsingVolumes(InterpTrackSplinePath.E_SPLINEPATH_TYPE Type, Actor destActor, out s_SplineLocomotionData splineData, Vector destPoint)
{
    FindBestSplinePath(Type, destActor, splineData, destPoint);
    //return;    
}

simulated event bool SplineFollowingDone()
{
    ExitSplineFollowing();
    return true;
    //return ReturnValue;    
}

simulated event bool IsTakingOff()
{
    return false;
    //return ReturnValue;    
}

function FindNewRetreatDest()
{
    local Vector EnemyDir, EnemyLoc, StrafeAxis, airplaneForward, tempVec;

    local Rotator myRot;
    local Vector newFP;

    // End:0x17
    if(bEnemyInfoValid)
    {
        EnemyLoc = LastSeenPos;        
    }
    else
    {
        // End:0x41
        if(Enemy != none)
        {
            EnemyLoc = Enemy.GetTargetLocation(self);            
        }
        else
        {
            GotoState('FlyingStakeOut');
            return;
        }
    }
    airplaneForward = Vector(Pawn.Rotation);
    StrafeAxis = -airplaneForward Cross vect(0.0000000, 0.0000000, 1.0000000);
    EnemyDir = airplaneForward;
    EnemyDir += (StrafeAxis * ((FRand() - 0.5000000) * 2.0000000));
    EnemyDir.Z = 0.0000000;
    EnemyDir = Normal(EnemyDir);
    EnemyDir *= Pawn.Lerp(PMinRetreatDist, PMaxRetreatDist, FRand());
    // End:0x22A
    if(SkyAirVehicle(Pawn).bAISmallVehicle)
    {
        // End:0x15F
        if(Enemy != none)
        {
            SkyAirVehicle(Pawn).CruisingAltitude = Enemy.Location.Z;
            SkyAirVehicle(Pawn).CruisingAltitude += 1500.0000000;            
        }
        else
        {
            SkyAirVehicle(Pawn).CruisingAltitude = Pawn.Location.Z;
        }
        GetRandomDirection(10.0000000, 45.0000000, myRot);
        newFP = Pawn.Location + (Vector(Pawn.Rotation + myRot) * 15000.0000000);
        // End:0x20F
        if(FRand() < 0.5000000)
        {
            newFP.Z = SkyAirVehicle(Pawn).CruisingAltitude;
        }
        Focus = none;
        SetFocalPoint(newFP);
        FixupFocalPoint();
        return;
    }
    EnemyDir.Z = SkyAirVehicle(Pawn).CruisingAltitude + (((FRand() - 0.5000000) * 2.0000000) * CruisingAltitudeRange);
    Focus = none;
    SetFocalPoint(Pawn.Location + EnemyDir);
    tempVec = GetFocalPoint() - EnemyLoc;
    // End:0x2CF
    if(VSize(tempVec) > PMaxRetreatDist)
    {
        SetFocalPoint((Normal(tempVec) * PMaxRetreatDist) + EnemyLoc);        
    }
    else
    {
        // End:0x2FC
        if(VSize(tempVec) < PMinRetreatDist)
        {
            SetFocalPoint((Normal(tempVec) * PMinRetreatDist) + EnemyLoc);
        }
    }
    FixupFocalPoint();
    //return;    
}

function DoStakeOut()
{
    // End:0x1E
    if(SkyAirVehicle(Pawn) != none)
    {
        GotoState('FlyingStakeOut');
    }
    //return;    
}

function Wander()
{
    // End:0x26
    if(SkyAirVehicle(Pawn) != none)
    {
        GotoState('FlyingStakeOut', 'Begin');
    }
    //return;    
}

// Export USkyBotControllerPilot::execFixupFocalPoint(FFrame&, void* const)
native final function FixupFocalPoint();

function FindNewMigrateDest()
{
    local Vector HitLocation, HitNormal;
    local TraceHitInfo HitInfo;
    local Actor HitActor;
    local Vector tempVec;
    local SkySeqAct_FollowSpline myFollowSplineAction;
    local bool bUseEmergencySpline;
    local float ClosestTimeToTether, ClosestTimeToVehicle;
    local int BaseKey;
    local Vector TempLocation, ClosestPointOnSpline;

    // End:0x31E
    if(Pawn != none)
    {
        // End:0x31E
        if(TetherActor != none)
        {
            // End:0x84
            if(SplinePathBackToTether != none)
            {
                HitActor = Pawn.Trace(HitLocation, HitNormal, TetherActor.Location, Pawn.Location, true, vect(0.0000000, 0.0000000, 0.0000000), HitInfo, 8);
                // End:0x84
                if(HitActor != none)
                {
                    bUseEmergencySpline = true;
                }
            }
            // End:0x1EF
            if(bUseEmergencySpline == false)
            {
                tempVec = TetherActor.Location;
                // End:0xEF
                if(TetherInnerDistance != -1.0000000)
                {
                    tempVec += (Normal(Pawn.Location - tempVec) * (TetherInnerDistance + ((TetherDistance - TetherInnerDistance) * 0.5000000)));
                }
                // End:0x1D9
                if((TetherInnerHeight != -1.0000000) && TetherHeight != -1.0000000)
                {
                    // End:0x192
                    if(Pawn.Location.Z > TetherActor.Location.Z)
                    {
                        tempVec.Z = (TetherActor.Location.Z + TetherInnerHeight) + ((TetherHeight - TetherInnerHeight) * 0.5000000);                        
                    }
                    else
                    {
                        tempVec.Z = (TetherActor.Location.Z - TetherInnerHeight) - ((TetherHeight - TetherInnerHeight) * 0.5000000);
                    }
                }
                Focus = none;
                SetFocalPoint(tempVec);                
            }
            else
            {
                myFollowSplineAction = new (self) Class'SkySeqAct_FollowSpline';
                myFollowSplineAction.Data.Add(1);
                myFollowSplineAction.Data[0].SplinePath = SplinePathBackToTether;
                TempLocation = Pawn.Location;
                ClosestTimeToVehicle = SplinePathBackToTether.FindClosestPointOnTrack(TempLocation, ClosestPointOnSpline, 0.0000000, 99999.0000000, BaseKey);
                TempLocation = TetherActor.Location;
                ClosestTimeToTether = SplinePathBackToTether.FindClosestPointOnTrack(TempLocation, ClosestPointOnSpline, 0.0000000, 99999.0000000, BaseKey);
                // End:0x2EB
                if(ClosestTimeToVehicle > ClosestTimeToTether)
                {
                    myFollowSplineAction.Data[0].bFollowSplineReversed = true;                    
                }
                else
                {
                    myFollowSplineAction.Data[0].bFollowSplineReversed = false;
                }
                OnFollowSpline(myFollowSplineAction);
                return;
            }            
        }
    }
    //return;    
}

simulated function bool CanDoSM_180()
{
    // End:0x10F
    if((Enemy != none) && Pawn != none)
    {
        // End:0x10F
        if(VSize(Enemy.GetTargetLocation(self) - Pawn.Location) >= P_FlyBy_SM180_MinDist)
        {
            // End:0x10F
            if((Vector(Pawn.Rotation) Dot (Enemy.GetTargetLocation(self) - Pawn.Location)) <= 0.0000000)
            {
                // End:0x10F
                if((((Normal(Pawn.Velocity) Dot Normal(Enemy.Velocity)) < -0.7070000) || VSize(Enemy.Velocity) < P_FlyByEnemyVelMin) || (SkyPawn(Enemy) != none) && int(SkyPawn(Enemy).RocketPackState) == int(3))
                {
                    return true;
                }
            }
        }
    }
    return false;
    //return ReturnValue;    
}

simulated event RammingImminent(Actor OtherActor)
{
    CurrentFlyByActor = OtherActor;
    bForceFlyBy = true;
    GotoState('FlyingFlyBy');
    //return;    
}

// Export USkyBotControllerPilot::execFindNewFlyByDest(FFrame&, void* const)
native final function bool FindNewFlyByDest(Actor myFlyByActor, bool bMustBeWithinBreakAwayDist);

simulated function SkyAILandingZone FindAnyLandingZone()
{
    local SkyGame Info;
    local int I;

    // End:0x8C
    if(WorldInfo != none)
    {
        Info = SkyGame(WorldInfo.Game);
        // End:0x8C
        if(Info != none)
        {
            I = 0;
            J0x37:

            // End:0x8C [Loop If]
            if(I < Info.AvailLandingZones.Length)
            {
                // End:0x82
                if(Info.AvailLandingZones[I] != none)
                {
                    return Info.AvailLandingZones[I];
                }
                I++;
                // [Loop Continue]
                goto J0x37;
            }
        }
    }
    return none;
    //return ReturnValue;    
}

simulated function FlyByLockOutTimerExpired()
{
    bFlyByCurrentlyLockedOut = false;
    //return;    
}

simulated event ImmediateTetherResting()
{
    //return;    
}

simulated function CheckFocalPointReached()
{
    //return;    
}

simulated function FireSecondaryExpired()
{
    bSecondaryFirePending = true;
    //return;    
}

// Export USkyBotControllerPilot::execFirePendingSecondary(FFrame&, void* const)
native final function FirePendingSecondary(Actor Target);

simulated event ResumeSecondaryFireCountdown()
{
    // End:0x2A
    if(TimeLeftBeforeFiringSecondaryWeapon > float(0))
    {
        SetTimer(0.0001000 + TimeLeftBeforeFiringSecondaryWeapon, false, 'FireSecondaryExpired');        
    }
    else
    {
        SetTimer((0.0001000 + SecondaryWeapFire_MinSec) + ((SecondaryWeapFire_MaxSec - SecondaryWeapFire_MinSec) * FRand()), false, 'FireSecondaryExpired');
    }
    //return;    
}

simulated function PauseSecondaryFireCountdown()
{
    TimeLeftBeforeFiringSecondaryWeapon = GetTimerRate('FireSecondaryExpired') - GetTimerCount('FireSecondaryExpired');
    ClearTimer('FireSecondaryExpired');
    //return;    
}

simulated function bool CanDoFlyBy(Actor myFocus)
{
    // End:0x3D
    if(bFlyByCurrentlyLockedOut == false)
    {
        // End:0x3D
        if((bOnlyFlyByCurrentEnemy == false) || myFocus == Enemy)
        {
            // End:0x3D
            if(FindNewFlyByDest(myFocus, false) == true)
            {
                return true;
            }
        }
    }
    return false;
    //return ReturnValue;    
}

simulated function FireSecondaryIfHeadOn()
{
    // End:0x42
    if((Enemy != none) && (Enemy.Velocity Dot Pawn.Velocity) < 0.0000000)
    {
        FirePendingSecondary(Enemy);
    }
    //return;    
}

simulated event SelfDestruct()
{
    GotoState('FlyingSelfDestruct');
    //return;    
}

simulated event DoStumble()
{
    //return;    
}

simulated function DoFlyingBeingHijacked()
{
    GotoState('FlyingBeingHijacked');
    //return;    
}

simulated event SetCruiseControlForcedBySpline(float MilesPerHour, float TimeToReachSpeed)
{
    //return;    
}

simulated function ExitSplineFollowing()
{
    local editinline SkyVehicleSim_CrimsonAircraft Sim;

    bFollowingSpline = false;
    // End:0x2B
    if(SplinePath != none)
    {
        SplinePath.RemoveClaimant(self);
        SplinePath = none;
    }
    // End:0xC1
    if(SkyAirVehicle(Pawn) != none)
    {
        Sim = SkyVehicleSim_CrimsonAircraft(SkyAirVehicle(Pawn).SimObj);
        // End:0xC1
        if(Sim != none)
        {
            Sim.ManeuverAcceleration = SavedManeuverAcceleration;
            Sim.ManeuverDeceleration = SavedManeuverDeceleration;
            Sim.ManeuverMaxRate = SavedManeuverMaxRate;
            Sim.BrakeScale = SavedBrakeScale;
            SavedSplineDataIsValid = false;
        }
    }
    GotoState('FlyingRangedAttack');
    //return;    
}

simulated function SnapTurnLockedOut()
{
    //return;    
}

simulated function DoDelayedEvade()
{
    //return;    
}

simulated function bool TryHoverAttackOn(Actor A)
{
    local Vector OtherToMe;
    local float Dist;

    // End:0xA7
    if((((bCanHover == true) && HoverChance != 0.0000000) && A != none) && Pawn != none)
    {
        OtherToMe = A.GetTargetLocation(self) - Pawn.Location;
        Dist = VSize(OtherToMe);
        // End:0xA7
        if(Dist <= HoverAttackEnterDist)
        {
            // End:0xA7
            if(CanIHoverToAttack(A) == true)
            {
                bAlreadyRolledDiceForHoverChance = true;
                // End:0xA7
                if(FRand() <= HoverChance)
                {
                    return true;
                }
            }
        }
    }
    return false;
    //return ReturnValue;    
}

simulated function DoCloseRangeAttackOn(Actor A)
{
    // End:0x19
    if(A == none)
    {
        GotoState('FlyingStakeOut');
    }
    // End:0x69
    if((((bCanHover == true) && HoverChance != 0.0000000) && FRand() <= HoverChance) && CanIHoverToAttack(A) == true)
    {
        DoHover(A);        
    }
    else
    {
        GotoState('FlyingCharging');
    }
    //return;    
}

function DoRangedAttackOn(Actor A)
{
    // End:0x1B
    if(A == none)
    {
        GotoState('FlyingStakeOut');
        return;
    }
    Focus = A;
    // End:0x65
    if(SkyAirVehicle(Pawn) != none)
    {
        // End:0x57
        if((CanStartPursuit()) == true)
        {
            GotoState('FlyingPursuit');            
        }
        else
        {
            GotoState('FlyingRangedAttack');
        }
    }
    //return;    
}

simulated function bool CanStartPursuit()
{
    local float myDot;
    local Vector PawnToEnemy, PawnFacing;

    // End:0xDD
    if((bAllowedToDoPursuit && SkyAirVehicle(Enemy) != none) && Pawn != none)
    {
        // End:0xDD
        if(SkyAirVehicle(Enemy).HasWheelsOnGround() == false)
        {
            PawnToEnemy = Normal(Enemy.GetTargetLocation(self) - Pawn.Location);
            PawnFacing = Vector(Pawn.Rotation);
            myDot = PawnToEnemy Dot PawnFacing;
            // End:0xDD
            if(myDot >= 0.7071060)
            {
                myDot = Vector(Enemy.Rotation) Dot PawnFacing;
                // End:0xDD
                if(myDot >= -0.7071060)
                {
                    return true;
                }
            }
        }
    }
    return false;
    //return ReturnValue;    
}

simulated function MonitorProjectile()
{
    local Vector X, Y, Z;

    // End:0x33
    if((MonitoredProjectile == none) || MonitoredProjectile.bDeleteMe == true)
    {
        ClearTimer('MonitorProjectile');
    }
    // End:0xDD
    if((ReadyToDoSM()) == false)
    {
        // End:0xDD
        if(VSize(Pawn.Location - MonitoredProjectile.Location) <= Start_SM_EvadeProj_Dist)
        {
            GetAxes(Pawn.Rotation, X, Y, Z);
            // End:0xD0
            if((Y Dot (MonitoredProjectile.Location - Pawn.Location)) >= 0.0000000)
            {
                PickSpecialManeuver(3, false);                
            }
            else
            {
                PickSpecialManeuver(2, false);
            }
        }
    }
    //return;    
}

function ReceiveProjectileWarning(Projectile Proj)
{
    // End:0x3B
    if((MonitorProjectileChance > 0.0000000) && FRand() <= MonitorProjectileChance)
    {
        MonitoredProjectile = Proj;
        SetTimer(0.1000000, true, 'MonitorProjectile');
    }
    //return;    
}

simulated function GetRandomDirection(float DegreesMin, float DegreesMax, out Rotator outRot)
{
    outRot.Pitch = int(Pawn.Lerp(DegreesMin, DegreesMax, FRand()) * (65536.0000000 / 360.0000000));
    // End:0x68
    if(FRand() > 0.5000000)
    {
        outRot.Pitch = -outRot.Pitch;
    }
    outRot.Yaw = int(Pawn.Lerp(DegreesMin, DegreesMax, FRand()) * (65536.0000000 / 360.0000000));
    // End:0xD0
    if(FRand() > 0.5000000)
    {
        outRot.Yaw = -outRot.Yaw;
    }
    outRot.Roll = 0;
    //return;    
}

simulated function StopEvade()
{
    //return;    
}

// Export USkyBotControllerPilot::execGetAdjustedAimFor(FFrame&, void* const)
native function Rotator GetAdjustedAimFor(Weapon InWeapon, Vector projStart);

protected event ExecuteWhatToDoNext()
{
    // End:0x0D
    if(Pawn == none)
    {
        return;
    }
    // End:0x72
    if(Enemy == none)
    {
        // End:0x72
        if((Focus == none) || (Pawn(Focus) != none) && Pawn(Focus).Health <= 0)
        {
            StopFiring();
            // End:0x72
            if(Pawn.Health <= 0)
            {
                return;
            }
        }
    }
    // End:0xA0
    if(int(Pawn.Physics) == int(0))
    {
        Pawn.SetMovementPhysics();
    }
    bIgnoreEnemyChange = true;
    // End:0xF8
    if(Pawn(Enemy) != none)
    {
        // End:0xF8
        if((Pawn(Enemy).Health <= 0) || Pawn(Enemy).Controller == none)
        {
            LoseEnemy();
        }
    }
    // End:0x159
    if(((Squad != none) && Enemy != none) && !Squad.MustKeepEnemy(Enemy))
    {
        // End:0x159
        if(LostContact(30.0000000))
        {
            LoseEnemy();
            PlayPilotChatter(8, TeamNum);
        }
    }
    bIgnoreEnemyChange = false;
    // End:0x193
    if((IsTakingOff()) == false)
    {
        // End:0x189
        if(Enemy != none)
        {
            FightEnemy();            
        }
        else
        {
            Wander();
        }
    }
    //return;    
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    local Vector MinPos, MaxPos;
    local SkyBotControllerPilot AIC;
    local Vector TempOffset, TempOffset2;

    super.DisplayDebug(HUD, out_YL, out_YPos);
    // End:0x27B
    if(HUD.ShouldDisplayDebug('splines'))
    {
        DrawDebugLine(Pawn.Location, Pawn.Location + (Vector(Rotation) * 10000.0000000), 255, 0, 0);
        DrawDebugLine(Pawn.Location, GetFocalPoint(), 0, 255, 0);
        // End:0x27B
        if(bFollowingSpline && SplinePath != none)
        {
            SplinePath.Render3DTrackInGame();
            // End:0x111
            if(bSplineData_PredictedPointCurrentlyBeyondTolerance == true)
            {
                DrawDebugSphere(SplineData_PredictedPoint, 200.0000000, 10, 255, 0, 0);
                DrawDebugLine(SplineData_PredictedPoint, SplineData_ClosestPointToPredictedPoint, 255, 0, 0);
                DrawDebugSphere(GetFocalPoint(), 200.0000000, 10, 255, 255, 255);                
            }
            else
            {
                DrawDebugSphere(SplineData_PredictedPoint, 200.0000000, 10, 151, 0, 0);
                DrawDebugLine(Pawn.Location, GetFocalPoint(), 255, 0, 0);
                DrawDebugSphere(GetFocalPoint(), 200.0000000, 10, 128, 128, 128);
            }
            MinPos = SplinePath.EvalPositionAtTimeFromScript(SplineData_PredictedPointLastSearchMin);
            MaxPos = SplinePath.EvalPositionAtTimeFromScript(SplineData_PredictedPointLastSearchMax);
            DrawDebugLine(MinPos, MaxPos, 128, 0, 255);
            // End:0x202
            if(bSplineData_PawnCurrentlyBeyondTolerance == true)
            {
                DrawDebugLine(Pawn.Location, SplineData_ClosestPointToPawn, 255, 128, 64);
                DrawDebugLine(Pawn.Location, GetFocalPoint(), 255, 128, 64);
            }
            DrawDebugSphere(SplineData_ThrottleSlowdownDistBehindPos0, 100.0000000, 10, 255, 128, 255);
            DrawDebugLine(SplineData_ThrottleSlowdownDistBehindPos0, SplineData_ThrottleSlowdownDistAheadPos1, 255, 128, 255);
            DrawDebugSphere(SplineData_ThrottleSlowdownDistAheadPos1, 100.0000000, 10, 255, 128, 255);
            DrawDebugSphere(SplineData_ThrottleSlowdownDistAheadPos2, 100.0000000, 10, 128, 0, 255);
            DrawDebugLine(SplineData_ThrottleSlowdownDistAheadPos1, SplineData_ThrottleSlowdownDistAheadPos2, 128, 0, 255);
        }
    }
    // End:0x4AA
    if(HUD.ShouldDisplayDebug('tethers'))
    {
        // End:0x4AA
        if((TetherActor != none) && bAlreadyDrewTetherSphere == false)
        {
            // End:0x341
            foreach WorldInfo.AllControllers(Class'SkyBotControllerPilot', AIC)
            {
                // End:0x340
                if(((AIC.bAlreadyDrewTetherSphere && AIC.TetherActor == TetherActor) && AIC.TetherDistance == TetherDistance) && AIC.TetherHeight == TetherHeight)
                {
                    bAlreadyDrewTetherSphere = true;
                    // End:0x341
                    break;
                }                
            }            
            // End:0x4AA
            if(bAlreadyDrewTetherSphere == false)
            {
                // End:0x3B5
                if(TetherHeight == -1.0000000)
                {
                    DrawDebugSphere(TetherActor.Location, TetherDistance, 10, 255, 0, 255, true);
                    // End:0x3B2
                    if(TetherInnerDistance != -1.0000000)
                    {
                        DrawDebugSphere(TetherActor.Location, TetherInnerDistance, 10, 255, 128, 255, true);
                    }                    
                }
                else
                {
                    TempOffset.Z = -TetherHeight;
                    TempOffset2.Z = TetherHeight;
                    DrawDebugCylinder(TetherActor.Location + TempOffset, TetherActor.Location + TempOffset2, TetherDistance, 10, 255, 0, 255, true);
                    // End:0x4A2
                    if(TetherInnerHeight != float(-1))
                    {
                        TempOffset.Z = -TetherInnerHeight;
                        TempOffset2.Z = TetherInnerHeight;
                        DrawDebugCylinder(TetherActor.Location + TempOffset, TetherActor.Location + TempOffset2, TetherDistance, 10, 255, 128, 255, true);
                    }
                }
                bAlreadyDrewTetherSphere = true;
            }
        }
    }
    //return;    
}

state PILOTSTATE
{
    function BeginState(name PreviousStateName)
    {
        OnEnterNewState();
        SetRotation(Pawn.Rotation);
        DoBeginCode();
        //return;        
    }

    function EndState(name NextStateName)
    {
        DoEndCode();
        //return;        
    }

    function PushedState()
    {
        OnEnterNewState();
        DoBeginCode();
        //return;        
    }

    function PoppedState()
    {
        DoEndCode();
        //return;        
    }

    function ContinuedState()
    {
        OnEnterNewState();
        DoBeginCode();
        //return;        
    }

    function PausedState()
    {
        DoEndCode();
        //return;        
    }
    stop;    
}

auto state Start_State extends PILOTSTATE
{
    simulated function bool MigrationCheck()
    {
        return false;
        //return ReturnValue;        
    }

    simulated function DoBeginCode()
    {
        SetTimer(0.5000000, true, 'MigrationCheck');
        //return;        
    }
    J0x00:
    // End:0x1B [Loop If]
    if(Vehicle(Pawn) == none)
    {
        Sleep(0.0500000);
        // [Loop Continue]
        goto J0x00;
    }
    // End:0x35
    if(bSpecialMoveMode == true)
    {
        GotoState('FlyingSpecialMove_DEBUG');
    }
    // End:0x53
    if(SkyAirVehicle(Pawn) != none)
    {
        GotoState('FlyingTakeOff');
    }
    stop;                    
}

state FlyingSpecialMove_DEBUG extends PILOTSTATE
{
    ignores WhatToDoNext, RequestChangeState, DoSeekLandingZoneExpired;

    simulated function bool MigrationCheck()
    {
        return false;
        //return ReturnValue;        
    }

    function bool CanAttack(Actor Other)
    {
        return false;
        //return ReturnValue;        
    }

    event bool FaceRotationTimeOut()
    {
        return false;
        //return ReturnValue;        
    }

    function DoneReactingFSMD()
    {
        GotoState('FlyingAvoidObstacle');
        //return;        
    }

    simulated function DoBeginCode()
    {
        StopFiring();
        SetTimer(10.0000000, false, 'DoneReactingFSMD');
        //return;        
    }

    simulated function DoEndCode()
    {
        ClearTimer('DoneReactingFSMD');
        //return;        
    }

    simulated event float GetDesiredThrottleSpeed()
    {
        return 0.0000000;
        //return ReturnValue;        
    }

    simulated event bool ShouldOffsetFocalPointAbovePawn()
    {
        return false;
        //return ReturnValue;        
    }
Begin:

    // End:0x20
    if(PickSpecialManeuver(0, false))
    {
        PushState('FlyingSpecialManeuver');
    }
    Sleep(2.0000000);
    goto 'Begin';
    stop;        
}

state FlyingTurnAroundVolume extends PILOTSTATE
{
    ignores WhatToDoNext, RammingImminent, RequestChangeState, FindSplinePathUsingVolumes, DoRangedAttackOn, DoFlyingBeingHijacked, 
	    DoEndCode;

    simulated event float GetDesiredThrottleSpeed()
    {
        return 0.0000000;
        //return ReturnValue;        
    }

    simulated function bool MigrationCheck()
    {
        return false;
        //return ReturnValue;        
    }

    event bool FaceRotationTimeOut()
    {
        return false;
        //return ReturnValue;        
    }

    simulated event bool ShouldOffsetFocalPointAbovePawn()
    {
        return false;
        //return ReturnValue;        
    }

    simulated event bool CareAboutCollisionPrediction()
    {
        return false;
        //return ReturnValue;        
    }

    function bool CanAttack(Actor Other)
    {
        StopFiring();
        return false;
        //return ReturnValue;        
    }

    simulated function bool AllowedToDoSpecialManeuver()
    {
        return false;
        //return ReturnValue;        
    }

    simulated function EnterTurnAroundVolumes()
    {
        //return;        
    }

    simulated event ExitTurnAroundVolumes()
    {
        //return;        
    }

    simulated function DoBeginCode()
    {
        bAllowedToDoFlyBy = false;
        //return;        
    }
Begin:

    ScriptTrace();
    Pawn.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
    Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
    PendingSpecialManeuver = 'SnapTurn';
    PushState('FlyingSpecialManeuver');
    Focus = none;
    // End:0xF0
    if(SkyAirVehicle(Pawn).TurnAroundVolumeList.Length > 0)
    {
        // End:0xED
        if(SkyAirVehicle(Pawn).TurnAroundVolumeList[0].Vol != none)
        {
            SetFocalPoint(SkyAirVehicle(Pawn).LocationBeforeSpecialManeuver + (SkyAirVehicle(Pawn).TurnAroundVolumeList[0].HitNormal * 10000.0000000));
        }        
    }
    else
    {
        SetFocalPoint(SkyAirVehicle(Pawn).Location + (Vector(SkyAirVehicle(Pawn).Rotation) * 10000.0000000));
    }
    J0x12A:

    // End:0x150 [Loop If]
    if(SkyAirVehicle(Pawn).TurnAroundVolumeList.Length > 0)
    {
        Sleep(0.0300000);
        // [Loop Continue]
        goto J0x12A;
    }
    // End:0x18C
    if((SkyAirVehicle(Pawn) != none) && SkyAirVehicle(Pawn).IsBeingHijacked())
    {
        GotoState('FlyingBeingHijacked');
    }
    // End:0x1A5
    if(Enemy != none)
    {
        GotoState('FlyingRangedAttack');
    }
    GotoState('FlyingStakeOut');
    stop;                    
}

state FlyingBeingHijacked extends PILOTSTATE
{
    ignores WhatToDoNext, RammingImminent, RequestChangeState, DoRangedAttackOn, DoFlyingBeingHijacked;

    simulated function bool MigrationCheck()
    {
        return false;
        //return ReturnValue;        
    }

    function bool CanAttack(Actor Other)
    {
        StopFiring();
        return false;
        //return ReturnValue;        
    }

    simulated event float GetDesiredThrottleSpeed()
    {
        return BH_PEvadeMaxThrottleRatio;
        //return ReturnValue;        
    }

    simulated function bool AllowedToDoSpecialManeuver()
    {
        local SkyAirVehicle SAV;

        SAV = SkyAirVehicle(Pawn);
        // End:0x6C
        if((int(HijackGamePlayMode) == int(0)) && ((SAV == none) || SAV.PotentialHijacker == none) || SAV.PotentialHijacker.IsInteractingWithGripPoint() == false)
        {
            return true;
        }
        return false;
        //return ReturnValue;        
    }

    simulated function SwitchHijackGamePlayModeExpired()
    {
        SwitchHijackGamePlayMode();
        bHijackGamePlayModeSwitchPending = false;
        //return;        
    }

    simulated function BH_EvadeTimer()
    {
        local Rotator myRotation;
        local float tempYawDegrees;

        // End:0x118
        if(SkyAirVehicle(Pawn) != none)
        {
            // End:0x80
            if(Pawn.Location.Z > (SkyAirVehicle(Pawn).CruisingAltitude + (0.5000000 * CruisingAltitudeRange)))
            {
                myRotation.Pitch = int(-(FRand() * (BH_PEvadeDirectionMaxPitchDegrees * 0.5000000)) * 182.0440000);                
            }
            else
            {
                // End:0xEE
                if(Pawn.Location.Z < (SkyAirVehicle(Pawn).CruisingAltitude - (0.5000000 * CruisingAltitudeRange)))
                {
                    myRotation.Pitch = int((FRand() * (BH_PEvadeDirectionMaxPitchDegrees * 0.5000000)) * 182.0440000);                    
                }
                else
                {
                    myRotation.Pitch = int(((FRand() - 0.5000000) * BH_PEvadeDirectionMaxPitchDegrees) * 182.0440000);
                }
            }
        }
        tempYawDegrees = Pawn.Lerp(BH_PEvadeDirectionMinYawDegrees, BH_PEvadeDirectionMaxYawDegrees, FRand());
        // End:0x14F
        if(FRand() < 0.5000000)
        {
            tempYawDegrees = -tempYawDegrees;
        }
        myRotation.Yaw = int(float(Pawn.Rotation.Yaw) + (tempYawDegrees * 182.0440000));
        myRotation.Roll = 0;
        Focus = none;
        SetFocalPoint(Pawn.Location + (Vector(myRotation) * 100000.0000000));
        FixupFocalPoint();
        SetTimer((0.0001000 + BH_PMinEvadeReThinkSec) + (FRand() * BH_PEvadeReThinkVariance), false, 'BH_EvadeTimer');
        //return;        
    }

    function bool PickSpecialManeuver(SkySpecialManeuverActor.ESpecialManeuverDefinition SMD, bool bUseDefinition)
    {
        bSpecialMovePending = true;
        // End:0x44
        if(SkyAirVehicle(Pawn).PotentialHijacker.IsGripping())
        {
            return global.PickSpecialManeuver(SMD, bUseDefinition);
        }
        return false;
        //return ReturnValue;        
    }

    simulated function DoBeginCode()
    {
        Focus = none;
        bAllowedToDoFlyBy = false;
        SetTimer((0.0001000 + BH_PMinEvadeReThinkSec) + (FRand() * BH_PEvadeReThinkVariance), false, 'BH_EvadeTimer');
        ClearTimer('CheckForHijackers');
        // End:0xA5
        if(bFirstTimeHijacked)
        {
            SetTimer((0.0001000 + BH_SpecialManeuverInitialTimerMin) + (FRand() * (BH_SpecialManeuverInitialTimerMax - BH_SpecialManeuverInitialTimerMin)), false, 'TrySpecialManeuverTimer');
            // End:0x90
            if(FRand() < BH_HijackGamePlayMode_StartWithSM_Chance)
            {
                HijackGamePlayMode = 1;                
            }
            else
            {
                HijackGamePlayMode = 0;
            }
            SwitchHijackGamePlayMode();            
        }
        else
        {
            // End:0xBB
            if(bHijackGamePlayModeSwitchPending == true)
            {
                SwitchHijackGamePlayModeExpired();
            }
        }
        bFirstTimeHijacked = false;
        //return;        
    }

    simulated function DoEndCode()
    {
        ClearTimer('BH_EvadeTimer');
        SetTimer(0.0001000 + CheckForHijackersTime, true, 'CheckForHijackers');
        //return;        
    }
Begin:

    StopFiring();
Loop:


    // End:0x4F
    if((SkyAirVehicle(Pawn) != none) && SkyAirVehicle(Pawn).IsBeingHijacked() == false)
    {
        ClearPendingSM();
        goto 'FlyingStakeOut';
    }
    // End:0xB6
    if(bSpecialMovePending == true)
    {
        // End:0xB6
        if((ReadyToDoSM()) || PickSpecialManeuver(0, false))
        {
            PushState('FlyingSpecialManeuver');
            SetTimer((0.0001000 + BH_SpecialManeuverTimerMin) + (FRand() * (BH_SpecialManeuverTimerMax - BH_SpecialManeuverTimerMin)), false, 'TrySpecialManeuverTimer');
        }
    }
    Sleep(0.2500000);
    goto 'Loop';
    stop;                
}

state FlyingSpecialManeuver extends PILOTSTATE
{
    ignores WhatToDoNext, RammingImminent, RequestChangeState, FindSplinePathUsingVolumes, DoFlyingBeingHijacked;

    simulated function bool MigrationCheck()
    {
        return false;
        //return ReturnValue;        
    }

    event bool FaceRotationTimeOut()
    {
        return true;
        //return ReturnValue;        
    }

    simulated event bool CareAboutCollisionPrediction()
    {
        return false;
        //return ReturnValue;        
    }

    function bool CanAttack(Actor Other)
    {
        StopFiring();
        return false;
        //return ReturnValue;        
    }

    simulated function DoBeginCode()
    {
        bAllowedToDoFlyBy = false;
        //return;        
    }

    simulated function DoEndCode()
    {
        local SkyAirVehicle SAV;

        Focus = none;
        SetFocalPoint(Pawn.Location + (Vector(Pawn.Rotation) * 100000.0000000));
        FixupFocalPoint();
        SetTimer((0.0001000 + BH_SMSettleTimeMin) + ((BH_SMSettleTimeMax - BH_SMSettleTimeMin) * FRand()), false, 'WaitForSpecialManeuverToSettle');
        ClearPendingSM();
        ClearTimer('FailedToFinishMove');
        SAV = SkyAirVehicle(Pawn);
        // End:0x14A
        if(SAV != none)
        {
            // End:0x14A
            if(SAV.CurrentActiveSpecialManeuver != 'None')
            {
                SAV.SetCurrentActiveSpecialManeuver('None');
                // End:0x111
                if(SAV.RollFromTurnSkel != none)
                {
                    SAV.RollFromTurnSkel.SetSkelControlStrength(1.0000000, 1.0000000);
                }
                // End:0x14A
                if(SAV.StabilizerSkel != none)
                {
                    SAV.StabilizerSkel.SetSkelControlStrength(1.0000000, 1.0000000);
                }
            }
        }
        //return;        
    }

    simulated function FailedToFinishMove()
    {
        bLastSpecialMoveFailed = true;
        PopState();
        //return;        
    }
Begin:

    StopFiring();
    bLastSpecialMoveFailed = false;
    // End:0x36
    if(PendingSpecialManeuver == 'None')
    {
        ClearPendingSM();
        PopState();
    }
    SetTimer(6.0000000, false, 'FailedToFinishMove');
    SkyAirVehicle(Pawn).SetCurrentActiveSpecialManeuver(PendingSpecialManeuver);
    ClearPendingSM();
SomeDeal:


    Sleep(0.2500000);
    // End:0xA2
    if(SkyAirVehicle(Pawn).CurrentActiveSpecialManeuver == 'None')
    {
        PopState();
    }
    goto 'SomeDeal';
    stop;                
}

state FlyingStakeOut extends PILOTSTATE
{
    simulated function DoSeekLandingZoneExpired()
    {
        GotoState('FlyingSeekLandingZone');
        //return;        
    }

    event SeePlayer(Pawn SeenPlayer)
    {
        global.SeePlayer(SeenPlayer);
        // End:0x24
        if(Enemy != none)
        {
            FightEnemy();
        }
        //return;        
    }

    function FindNewStakeOutDir()
    {
        local Vector EnemyLoc, tempVec;

        // End:0x15E
        if(SkyAirVehicle(Pawn) != none)
        {
            // End:0x27
            if(bEnemyInfoValid)
            {
                EnemyLoc = LastSeenPos;                
            }
            else
            {
                // End:0x5C
                if((Enemy != none) && bStakeOutGodSight)
                {
                    EnemyLoc = Enemy.GetTargetLocation(self);                    
                }
                else
                {
                    // End:0x7F
                    if(TetherActor != none)
                    {
                        EnemyLoc = TetherActor.Location;                        
                    }
                    else
                    {
                        EnemyLoc = Pawn.Location;
                    }
                }
            }
            tempVec.X = FRand() - 0.5000000;
            tempVec.Y = FRand() - 0.5000000;
            tempVec.Z = 0.0000000;
            tempVec = Normal(tempVec);
            tempVec *= (50000.0000000 + (FRand() * 3000.0000000));
            tempVec += EnemyLoc;
            tempVec.Z = SkyAirVehicle(Pawn).CruisingAltitude + ((FRand() - 0.5000000) * CruisingAltitudeRange);
            Focus = none;
            SetFocalPoint(tempVec);
            FixupFocalPoint();
        }
        SetTimer(7.0000000 + (FRand() * 7.0000000), false, 'FindNewStakeOutDir');
        //return;        
    }

    simulated function DoBeginCode()
    {
        SetTimer(0.0333300, true, 'CheckIfAtStakeOutDest');
        FindNewStakeOutDir();
        //return;        
    }

    simulated function CheckIfAtStakeOutDest()
    {
        // End:0x1C
        if(ReachedFocalPoint(3000.0000000))
        {
            FindNewStakeOutDir();
        }
        //return;        
    }

    simulated function DoEndCode()
    {
        ClearTimer('CheckIfAtStakeOutDest');
        ClearTimer('FindNewStakeOutDir');
        //return;        
    }
Begin:

    Sleep(1000.0000000);
    goto 'Begin';
    stop;        
}

state FlyingMigrate extends PILOTSTATE
{
    ignores WhatToDoNext, DoSeekLandingZoneExpired, FindSplinePathUsingVolumes, DoFlyingBeingHijacked, DoRangedAttackOn, DoEndCode;

    simulated function bool MigrationCheck()
    {
        return false;
        //return ReturnValue;        
    }

    simulated event bool ShouldOffsetFocalPointAbovePawn()
    {
        return false;
        //return ReturnValue;        
    }

    simulated function bool AllowedToDoSpecialManeuver()
    {
        return false;
        //return ReturnValue;        
    }

    event bool FaceRotationTimeOut()
    {
        return true;
        //return ReturnValue;        
    }

    simulated function DoBeginCode()
    {
        bCurrentlyMigrating = true;
        FindNewMigrateDest();
        //return;        
    }
Loop:

    // End:0x27
    if(IsOutsideTether(0.0000000) == false)
    {
        bCurrentlyMigrating = false;
        GotoState('FlyingStakeOut');
    }
    Sleep(0.5000000);
    goto 'Loop';
    stop;            
}

state FlyingFlyBy extends PILOTSTATE
{
    ignores WhatToDoNext, RammingImminent;

    simulated event ImmediateTetherResting()
    {
        GotoState('FlyingResting');
        //return;        
    }

    simulated event bool CareAboutCollisionPrediction()
    {
        return bCareAboutCollisionPredictionWhileFlyBy;
        //return ReturnValue;        
    }

    simulated function DoSeekLandingZoneExpired()
    {
        GotoState('FlyingSeekLandingZone');
        //return;        
    }

    simulated event float GetDesiredThrottleSpeed()
    {
        return 1.0000000;
        //return ReturnValue;        
    }

    event bool FaceRotationTimeOut()
    {
        return false;
        //return ReturnValue;        
    }

    function DoneWithFlyBy()
    {
        DoRangedAttackOn(Enemy);
        //return;        
    }

    simulated function TurnOnCollision()
    {
        bCareAboutEnemyCollision = bDoCareAboutEnemyCollision;
        //return;        
    }

    simulated function UpdateCounter()
    {
        local SkyBot BTController;

        P_FlyBy_Counter++;
        BTController = GetBehaviorTreeController();
        // End:0x45
        if(BTController != none)
        {
            BTController.FireExternalEvent("FlyByPassComplete");
        }
        // End:0x87
        if(P_FlyBy_Counter >= P_FlyBy_Count)
        {
            // End:0x87
            if(BTController != none)
            {
                BTController.FireExternalEvent("FlyByFinalPassComplete");
            }
        }
        //return;        
    }

    simulated function DoBeginCode()
    {
        SetTimer(0.0001000 + PFlyByTimer, false, 'DoneWithFlyBy');
        bCareAboutEnemyCollision = false;
        Focus = none;
        //return;        
    }

    simulated function DoEndCode()
    {
        ClearTimer('DoneWithFlyBy');
        bCareAboutEnemyCollision = bDoCareAboutEnemyCollision;
        bDoingFlyByBreakAway = false;
        bForceFlyBy = false;
        bDoingPostFlyBy = false;
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        local SkyBot BTController;

        super.BeginState(PreviousStateName);
        // End:0xDD
        if(CurrentFlyByActor == Enemy)
        {
            // End:0x30
            if(P_FlyBy_Counter == -1)
            {
                P_FlyBy_Counter = 0;
            }
            bFlyByCurrentlyLockedOut = true;
            BTController = GetBehaviorTreeController();
            // End:0xB8
            if(BTController != none)
            {
                BTController.FireExternalEvent("FlyByPassBegin");
                BTController.Pawn.TriggerRemoteEvent('FlyByPassBegin', BTController.Pawn, BTController.Pawn);
            }
            SetTimer(FlyByFireSecondaryMinTime + (FRand() * (FlyByFireSecondaryMaxTime - FlyByFireSecondaryMinTime)), false, 'FireSecondaryIfHeadOn');
        }
        //return;        
    }

    function EndState(name NextStateName)
    {
        local SkyBot BTController;

        // End:0xA7
        if(CurrentFlyByActor == Enemy)
        {
            BTController = GetBehaviorTreeController();
            // End:0x8D
            if(BTController != none)
            {
                BTController.FireExternalEvent("FlyByPassEnd");
                BTController.Pawn.TriggerRemoteEvent('FlyByPassEnd', BTController.Pawn, BTController.Pawn);
            }
            SetTimer(0.0001000 + PFlyByLockOutTime, false, 'FlyByLockOutTimerExpired');
        }
        CurrentFlyByActor = none;
        super.EndState(NextStateName);
        //return;        
    }
Loop:

    // End:0x263
    if(FindNewFlyByDest(CurrentFlyByActor, false) == false)
    {
        Focus = none;
        SetFocalPoint(Pawn.Location + (Normal(Pawn.Velocity) * 2000000.0000000));
        FixupFocalPoint();
        // End:0x75
        if(CurrentFlyByActor != Enemy)
        {
            DoRangedAttackOn(Enemy);
            Sleep(0.1000000);
        }
        // End:0x1E5
        if(bDoingFlyByBreakAway)
        {
            UpdateCounter();
            SetTimer(2.0000000, false, 'TurnOnCollision');
            PostFlyByExpireTime = WorldInfo.TimeSeconds + P_PostFlyByTimer;
            bDoingPostFlyBy = true;
            J0xBF:

            // End:0x105 [Loop If]
            if(WorldInfo.TimeSeconds < PostFlyByExpireTime)
            {
                // End:0xFA
                if((ShouldEvade()) == true)
                {
                    DoEvade();
                    Sleep(0.0100000);
                }
                Sleep(0.2500000);
                // [Loop Continue]
                goto J0xBF;
            }
            // End:0x1E2
            if(P_FlyBy_Counter >= P_FlyBy_Count)
            {
                // End:0x151
                if((GetBehaviorTreeController()) != none)
                {
                    GetBehaviorTreeController().FireExternalEvent("FinalPostFlyByComplete");
                }
                P_FlyBy_Counter = -1;
                // End:0x176
                if(P_FlyBy_HoverWhenCountIsMet)
                {
                    GotoState('FlyingHoverAttack');                    
                }
                else
                {
                    // End:0x190
                    if(P_FlyBy_StumbleWhenCountIsMet)
                    {
                        GotoState('FlyingStumble');                        
                    }
                    else
                    {
                        // End:0x1E2
                        if(P_FlyBy_GotoLZWhenCountIsMet)
                        {
                            // End:0x1E2
                            if(SkyGame(WorldInfo.Game).AvailLandingZones.Length > 0)
                            {
                                SeekLandingZone(FindAnyLandingZone());
                                bGoingBackToLZToLand = false;
                                Sleep(5.0000000);
                            }
                        }
                    }
                }
            }            
        }
        else
        {
            GotoState('FlyingRetreat');
        }
        // End:0x255
        if(P_FlyBy_RetreatAfterFlyBy == false)
        {
            // End:0x23B
            if(((Enemy != none) && CanDoSM_180()) && PickSpecialManeuver(1, true))
            {
                PushState('FlyingSpecialManeuver');
            }
            DoRangedAttackOn(Enemy);
            Sleep(0.0100000);            
        }
        else
        {
            GotoState('FlyingRetreat');
        }
    }
    // End:0x2E8
    if(CurrentFlyByActor == Enemy)
    {
        // End:0x2E8
        if((Enemy != none) && SkyAirVehicle(Pawn).NeedToTurnNative(Enemy.GetTargetLocation(self)) == false)
        {
            // End:0x2D1
            if(CheckFirePermit(Enemy))
            {
                FireWeaponAt(Enemy);
            }
            // End:0x2E8
            if(bSecondaryFirePending == true)
            {
                FirePendingSecondary(Enemy);
            }
        }
    }
    Sleep(0.1000000);
    goto 'Loop';
    stop;        
}

state FlyingKamikaze extends PILOTSTATE
{
    ignores WhatToDoNext, RammingImminent, DoBeginCode, DoEndCode;

    simulated function bool MigrationCheck()
    {
        return false;
        //return ReturnValue;        
    }

    event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
    {
        local Vector DamageMomentum;

        // End:0x98
        if(SkyAirVehicle(Pawn).bAISmallVehicle && Other == Enemy)
        {
            DamageMomentum = Normal(Other.Location - Instigator.Location);
            Other.TakeDamage(int(KamikazeDamage), Instigator.Controller, HitLocation, DamageMomentum, Class'SkyDmgType_WatcherMelee',, Instigator);
            bKamikazeDamageApplied = true;
        }
        //return;        
    }

    simulated event bool CareAboutCollisionPrediction()
    {
        return false;
        //return ReturnValue;        
    }

    simulated function DoSeekLandingZoneExpired()
    {
        GotoState('FlyingSeekLandingZone');
        //return;        
    }

    simulated event float GetDesiredThrottleSpeed()
    {
        return 1.0000000;
        //return ReturnValue;        
    }

    simulated event bool ShouldOffsetFocalPointAbovePawn()
    {
        return false;
        //return ReturnValue;        
    }

    event bool FaceRotationTimeOut()
    {
        return false;
        //return ReturnValue;        
    }

    function DoneWithFlyBy()
    {
        GotoState('FlyingRetreat');
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        SetTimer(7.0000000, false, 'DoneWithFlyBy');
        bKamikazeDamageApplied = false;
        super.BeginState(PreviousStateName);
        //return;        
    }

    function EndState(name NextStateName)
    {
        ClearTimer('DoneWithFlyBy');
        bKamikazeDamageApplied = false;
        super.EndState(NextStateName);
        //return;        
    }
Loop:

    // End:0x1A
    if(bKamikazeDamageApplied == true)
    {
        GotoState('FlyingRetreat');
    }
    // End:0x67
    if((Vector(Pawn.Rotation) Dot Normal(Enemy.Location - Pawn.Location)) < 0.0000000)
    {
        GotoState('FlyingRetreat');
    }
    // End:0x81
    if(LineOfSightTo(Enemy) == false)
    {
        DoStakeOut();
    }
    Focus = Enemy;
    Sleep(0.1000000);
    goto 'Loop';
    stop;        
}

state FlyingRetreat extends PILOTSTATE
{
    ignores WhatToDoNext, DoEndCode;

    simulated event float GetDesiredThrottleSpeed()
    {
        return 0.8500000;
        //return ReturnValue;        
    }

    simulated function DoSeekLandingZoneExpired()
    {
        GotoState('FlyingSeekLandingZone');
        //return;        
    }

    function DoneWithFlyingRetreat()
    {
        // End:0x19
        if(bDoRestingAfterRetreat)
        {
            GotoState('FlyingResting');
            return;
        }
        DoRangedAttackOn(Enemy);
        //return;        
    }

    simulated function CheckFocalPointReached()
    {
        // End:0x1F
        if((ReachedFocalPoint(3000.0000000)) == true)
        {
            DoneWithFlyingRetreat();
        }
        //return;        
    }

    simulated function DoBeginCode()
    {
        SetTimer(0.0333300, true, 'CheckFocalPointReached');
        FindNewRetreatDest();
        //return;        
    }

    function EndState(name NextStateName)
    {
        ClearTimer('DoneWithFlyingRetreat');
        ClearTimer('DoDelayedEvade');
        ClearTimer('CheckFocalPointReached');
        super.EndState(NextStateName);
        //return;        
    }

    simulated function DoDelayedEvade()
    {
        // End:0x1A
        if((ShouldEvade()) == true)
        {
            DoEvade();
        }
        //return;        
    }
Begin:

    SetTimer(0.0001000 + PRetreatTimer, false, 'DoneWithFlyingRetreat');
RetreatLoop:


    // End:0x84
    if((bCanEvade == true) && IsTimerActive('DoDelayedEvade') == false)
    {
        // End:0x84
        if((ShouldEvade()) == true)
        {
            // End:0x6A
            if(PBlockEvadeDelay == 0.0000000)
            {
                DoDelayedEvade();                
            }
            else
            {
                SetTimer(0.0001000 + PBlockEvadeDelay, false, 'DoDelayedEvade');
            }
        }
    }
    // End:0xE0
    if(CanDoSM_180())
    {
        // End:0xE0
        if((Enemy != none) && PickSpecialManeuver(1, true))
        {
            PushState('FlyingSpecialManeuver');
            Focus = Enemy;
            DoRangedAttackOn(Enemy);
            Sleep(0.0100000);
        }
    }
    // End:0x1A3
    if((SkyAirVehicle(Pawn).bAISmallVehicle && VSize(Enemy.Location - Pawn.Location) > 5000.0000000) || (VSize(Enemy.Location - Pawn.Location) > 10000.0000000) && (Normal(Enemy.Location - Pawn.Location) Dot Vector(Pawn.Rotation)) >= 0.0000000)
    {
        GotoState('FlyingRangedAttack');
    }
    Sleep(0.2500000);
    goto 'RetreatLoop';
    stop;            
}

state FlyingCharging extends PILOTSTATE
{
    simulated event ImmediateTetherResting()
    {
        GotoState('FlyingResting');
        //return;        
    }

    event PotShotStopFiring()
    {
        //return;        
    }

    simulated event float GetDesiredThrottleSpeed()
    {
        // End:0x0F
        if(bCharging_OverideThrottle)
        {
            return Charging_OverideThrottle;
        }
        // End:0x33
        if((Focus != none) && IsActorOnGround(Focus) == false)
        {
            return 1.0000000;
        }
        return global.GetDesiredThrottleSpeed();
        //return ReturnValue;        
    }

    simulated event float GetHitBoxWidthOveride()
    {
        return Overide_CollisionBoxSize_Charging;
        //return ReturnValue;        
    }

    simulated event bool ShouldShrinkCollisionBox()
    {
        // End:0x11
        if(Overide_CollisionBoxSize_Charging != -1.0000000)
        {
            return true;
        }
        return false;
        //return ReturnValue;        
    }

    simulated event float GetLookAheadDistOveride()
    {
        return Overide_LookAheadDist_Charging;
        //return ReturnValue;        
    }

    simulated function DoSeekLandingZoneExpired()
    {
        GotoState('FlyingSeekLandingZone');
        //return;        
    }

    simulated function bool ChargingSpecialMove()
    {
        local Vector X, Y, Z;

        // End:0x165
        if((ReadyToDoSM()) == false)
        {
            // End:0x165
            if(((Pawn.Location - Enemy.GetTargetLocation(self)) Dot Vector(Enemy.Rotation)) > 0.0000000)
            {
                // End:0x165
                if(((Enemy.GetTargetLocation(self) - Pawn.Location) Dot Vector(Rotation)) > 0.0000000)
                {
                    GetAxes(Enemy.Rotation, X, Y, Z);
                    // End:0x127
                    if((Y Dot (Pawn.Location - Enemy.GetTargetLocation(self))) >= 0.0000000)
                    {
                        // End:0x124
                        if(PickSpecialManeuver(3, true))
                        {
                            SetTimer((0.0001000 + Charging_SM_Time_Min) + (FRand() * (Charging_SM_Time_Max - Charging_SM_Time_Min)), false, 'ChargingSpecialMove');
                            return true;
                        }                        
                    }
                    else
                    {
                        // End:0x165
                        if(PickSpecialManeuver(2, true))
                        {
                            SetTimer((0.0001000 + Charging_SM_Time_Min) + (FRand() * (Charging_SM_Time_Max - Charging_SM_Time_Min)), false, 'ChargingSpecialMove');
                            return true;
                        }
                    }
                }
            }
        }
        SetTimer((0.0001000 + Charging_SM_Time_Min) + (FRand() * (Charging_SM_Time_Max - Charging_SM_Time_Min)), false, 'ChargingSpecialMove');
        return false;
        //return ReturnValue;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        bAlreadyRolledDiceForHoverChance = false;
        SetTimer(ChargingFireSecondaryMinTime + (FRand() * (ChargingFireSecondaryMaxTime - ChargingFireSecondaryMinTime)), false, 'FireSecondaryIfHeadOn');
        //return;        
    }

    simulated function DoBeginCode()
    {
        ResumeSecondaryFireCountdown();
        SetTimer((0.0001000 + Charging_SM_Time_Min) + (FRand() * (Charging_SM_Time_Max - Charging_SM_Time_Min)), false, 'ChargingSpecialMove');
        bCareAboutEnemyCollision = false;
        // End:0x89
        if((SkyAirVehicle_UFO(Pawn) != none) && FRand() < ChanceToRollCharge)
        {
            bForceVehicleRoll = true;
            // End:0x7E
            if(FRand() > 0.5000000)
            {
                ForceVehicleRollAmount = 1.0000000;                
            }
            else
            {
                ForceVehicleRollAmount = -1.0000000;
            }
        }
        //return;        
    }

    simulated function DoEndCode()
    {
        PauseSecondaryFireCountdown();
        ClearTimer('ChargingSpecialMove');
        bCareAboutEnemyCollision = bDoCareAboutEnemyCollision;
        bForceVehicleRoll = false;
        //return;        
    }

    simulated event bool ShouldOffsetFocalPointAbovePawn()
    {
        return false;
        //return ReturnValue;        
    }
Begin:

    // End:0x19
    if(Focus == none)
    {
        GotoState('FlyingStakeOut');
    }
    SetFocalPoint(SkyAirVehicle(Pawn).GetAdjustedFocalPoint(Focus));
    // End:0x6A
    if((TryHoverAttackOn(Focus)) == true)
    {
        DoHover(Focus);
        Sleep(0.0100000);
    }
    // End:0x84
    if(bCanDoKamikaze)
    {
        GotoState('FlyingKamikaze');        
    }
    else
    {
        // End:0xA5
        if((CanStartPursuit()) == true)
        {
            GotoState('FlyingPursuit');            
        }
        else
        {
            // End:0xD3
            if((CanDoFlyBy(Focus)) == true)
            {
                CurrentFlyByActor = Enemy;
                GotoState('FlyingFlyBy');
            }
        }
    }
    Pawn.DesiredRotation = Rotator(GetFocalPoint() - Pawn.Location);
    J0xFC:

    // End:0x2EE [Loop If]
    if(SkyAirVehicle(Pawn).NeedToTurnNative(GetFocalPoint()))
    {
        // End:0x146
        if((TryHoverAttackOn(Focus)) == true)
        {
            DoHover(Focus);
            Sleep(0.0100000);
        }
        // End:0x160
        if(bCanDoKamikaze)
        {
            GotoState('FlyingKamikaze');            
        }
        else
        {
            // End:0x181
            if((CanStartPursuit()) == true)
            {
                GotoState('FlyingPursuit');                
            }
            else
            {
                // End:0x1AF
                if((CanDoFlyBy(Focus)) == true)
                {
                    CurrentFlyByActor = Enemy;
                    GotoState('FlyingFlyBy');
                }
            }
        }
        Sleep(0.1000000);
        SetFocalPoint(SkyAirVehicle(Pawn).GetAdjustedFocalPoint(Focus));
        Pawn.DesiredRotation = Rotator(GetFocalPoint() - Pawn.Location);
        // End:0x225
        if(ReadyToDoSM())
        {
            PushState('FlyingSpecialManeuver');            
        }
        else
        {
            // End:0x276
            if(CanDoSM_180())
            {
                // End:0x276
                if((Enemy != none) && PickSpecialManeuver(1, true))
                {
                    PushState('FlyingSpecialManeuver');
                    DoRangedAttackOn(Enemy);
                    Sleep(0.0100000);
                }
            }
        }
        // End:0x2EB
        if(SkyAirVehicle(Pawn).bAISmallVehicle)
        {
            // End:0x2EB
            if(VSize(Pawn.Location - GetFocalPoint()) <= TooCloseToChargeDist)
            {
                // End:0x2DD
                if(CheckFirePermit(Focus))
                {
                    FireWeaponAt(Focus);
                    FirePendingSecondary(Focus);
                }
                GotoState('FlyingRetreat');
            }
        }
        // [Loop Continue]
        goto J0xFC;
    }
    // End:0x303
    if(Focus == none)
    {
        WhatToDoNext();
    }
    // End:0x324
    if(CheckFirePermit(Focus))
    {
        FireWeaponAt(Focus);
    }
    // End:0x33B
    if(bSecondaryFirePending == true)
    {
        FirePendingSecondary(Focus);
    }
    Sleep(0.1000000);
    // End:0x360
    if(ReadyToDoSM())
    {
        PushState('FlyingSpecialManeuver');
    }
    // End:0x37E
    if((CanStartPursuit()) == true)
    {
        GotoState('FlyingPursuit');
    }
    // End:0x3F3
    if(SkyAirVehicle(Pawn).bAISmallVehicle)
    {
        // End:0x3F3
        if(VSize(Pawn.Location - GetFocalPoint()) <= TooCloseToChargeDist)
        {
            // End:0x3E5
            if(CheckFirePermit(Focus))
            {
                FireWeaponAt(Focus);
                FirePendingSecondary(Focus);
            }
            GotoState('FlyingRetreat');
        }
    }
    goto 'Begin';
    stop;            
}

state FlyingHoverFindPosition extends PILOTSTATE
{
    ignores WhatToDoNext, RammingImminent;

    simulated function DoSeekLandingZoneExpired()
    {
        GotoState('FlyingSeekLandingZone');
        //return;        
    }

    event bool FaceRotationTimeOut()
    {
        SetFocalPoint(FindHoverPosition());
        return true;
        //return ReturnValue;        
    }

    function Vector FindHoverPosition()
    {
        local Vector myDir;
        local float amountToMove;
        local Rotator amountToRot;
        local Vector hoverPoint;

        Focus = none;
        // End:0x1D
        if(HoverActor == none)
        {
            HoverActor = Enemy;
        }
        myDir = Pawn.Location - HoverActor.Location;
        myDir.Z = 0.0000000;
        amountToMove = (FRand() - 0.5000000) * 2.0000000;
        // End:0x9D
        if((amountToMove >= 0.0000000) && amountToMove < 0.2000000)
        {
            amountToMove = 0.2000000;            
        }
        else
        {
            // End:0xC8
            if((amountToMove < 0.0000000) && amountToMove > -0.2000000)
            {
                amountToMove = -0.2000000;
            }
        }
        amountToRot.Pitch = 0;
        amountToRot.Yaw = int(float(16384) * amountToMove);
        amountToRot.Roll = 0;
        myDir = myDir >> amountToRot;
        myDir = Normal(myDir);
        myDir *= RadiusFromHoverActorMax;
        hoverPoint = HoverActor.Location + myDir;
        hoverPoint.Z += 10000.0000000;
        return hoverPoint;
        //return ReturnValue;        
    }

    simulated function DoBeginCode()
    {
        local SkyAirVehicle CurrentSkyAirVehicle;

        CurrentSkyAirVehicle = SkyAirVehicle(Pawn);
        // End:0x3C
        if(CurrentSkyAirVehicle != none)
        {
            SkyVehicleSim_CrimsonAircraft(CurrentSkyAirVehicle.SimObj).bIsHovering = true;
        }
        SetFocalPoint(FindHoverPosition());
        //return;        
    }

    simulated function DoEndCode()
    {
        local SkyAirVehicle CurrentSkyAirVehicle;

        CurrentSkyAirVehicle = SkyAirVehicle(Pawn);
        // End:0x3C
        if(CurrentSkyAirVehicle != none)
        {
            SkyVehicleSim_CrimsonAircraft(CurrentSkyAirVehicle.SimObj).bIsHovering = false;
        }
        //return;        
    }

    simulated event float GetDesiredThrottleSpeed()
    {
        return 0.2500000;
        //return ReturnValue;        
    }

    simulated event bool ShouldOffsetFocalPointAbovePawn()
    {
        return false;
        //return ReturnValue;        
    }
Begin:

    Sleep(0.1000000);
    // End:0x39
    if(VSize(GetFocalPoint() - Pawn.Location) <= 700.0000000)
    {
        GotoState('FlyingHoverAttack');
    }
    // End:0x56
    if(ReadyToDoSM())
    {
        PushState('FlyingSpecialManeuver');
    }
    goto 'Begin';
    stop;                
}

state FlyingHoverAttack extends PILOTSTATE
{
    ignores WhatToDoNext, RammingImminent;

    simulated function DoSeekLandingZoneExpired()
    {
        GotoState('FlyingSeekLandingZone');
        //return;        
    }

    simulated event bool CareAboutCollisionPrediction()
    {
        return false;
        //return ReturnValue;        
    }

    event bool FaceRotationTimeOut()
    {
        return false;
        //return ReturnValue;        
    }

    simulated function DoBeginCode()
    {
        local SkyAirVehicle CurrentSkyAirVehicle;

        CurrentSkyAirVehicle = SkyAirVehicle(Pawn);
        // End:0x3C
        if(CurrentSkyAirVehicle != none)
        {
            SkyVehicleSim_CrimsonAircraft(CurrentSkyAirVehicle.SimObj).bIsHovering = true;
        }
        ResumeSecondaryFireCountdown();
        SetTimer((0.0001000 + HoverInLocationTimeMin) + (FRand() * (HoverInLocationTimeMax - HoverInLocationTimeMin)), false, 'TimeToChooseAnotherHoverPoint');
        bAllowedToDoFlyBy = false;
        //return;        
    }

    simulated function DoEndCode()
    {
        local SkyAirVehicle CurrentSkyAirVehicle;

        CurrentSkyAirVehicle = SkyAirVehicle(Pawn);
        // End:0x3C
        if(CurrentSkyAirVehicle != none)
        {
            SkyVehicleSim_CrimsonAircraft(CurrentSkyAirVehicle.SimObj).bIsHovering = false;
        }
        PauseSecondaryFireCountdown();
        StopFiring();
        //return;        
    }

    simulated event float GetDesiredThrottleSpeed()
    {
        return -1.0000000;
        //return ReturnValue;        
    }

    simulated function TimeToChooseAnotherHoverPoint()
    {
        // End:0x1A
        if(bHoverPeriodicallyMove == true)
        {
            GotoState('FlyingHoverFindPosition');
        }
        //return;        
    }

    simulated event bool ShouldOffsetFocalPointAbovePawn()
    {
        return false;
        //return ReturnValue;        
    }
Begin:

    // End:0x2B
    if(Focus == none)
    {
        Focus = Enemy;
        // End:0x2B
        if(Focus == none)
        {
            WhatToDoNext();
        }
    }
    SetFocalPoint(Focus.GetTargetLocation(self));
    // End:0x69
    if(SkyAirVehicle(Pawn).NeedToTurnNative(GetFocalPoint()))
    {
        FinishRotation();
    }
    // End:0x7E
    if(Focus == none)
    {
        WhatToDoNext();
    }
    // End:0xBA
    if(LineOfSightTo(Focus) == true)
    {
        Sleep(WeaponAcquireTime);
        // End:0xB7
        if(CheckFirePermit(Focus))
        {
            FireWeaponAt(Focus);
        }        
    }
    else
    {
        // End:0xD4
        if(bHover_MoveWhenLoseLOS == true)
        {
            GotoState('FlyingHoverFindPosition');
        }
    }
    // End:0xEB
    if(bSecondaryFirePending == true)
    {
        FirePendingSecondary(Focus);
    }
    Sleep(0.1000000);
    goto 'Begin';
    stop;            
}

state FlyingSelfDestruct extends PILOTSTATE
{
    ignores WhatToDoNext, RammingImminent, RequestChangeState, SelfDestruct, DoSeekLandingZoneExpired;

    simulated function bool MigrationCheck()
    {
        return false;
        //return ReturnValue;        
    }

    simulated event bool CareAboutCollisionPrediction()
    {
        return false;
        //return ReturnValue;        
    }

    event bool FaceRotationTimeOut()
    {
        return false;
        //return ReturnValue;        
    }

    function DoneReactingSelfDestruct()
    {
        DoRangedAttackOn(Enemy);
        //return;        
    }

    simulated function DoBeginCode()
    {
        local SkyAirVehicle CurrentSkyAirVehicle;

        CurrentSkyAirVehicle = SkyAirVehicle(Pawn);
        // End:0x3C
        if(CurrentSkyAirVehicle != none)
        {
            SkyVehicleSim_CrimsonAircraft(CurrentSkyAirVehicle.SimObj).bIsHovering = true;
        }
        StopFiring();
        bAllowedToDoFlyBy = false;
        //return;        
    }

    simulated function DoEndCode()
    {
        local SkyAirVehicle CurrentSkyAirVehicle;

        CurrentSkyAirVehicle = SkyAirVehicle(Pawn);
        // End:0x3C
        if(CurrentSkyAirVehicle != none)
        {
            SkyVehicleSim_CrimsonAircraft(CurrentSkyAirVehicle.SimObj).bIsHovering = false;
        }
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        SetTimer(30.0000000, false, 'DoneReactingSelfDestruct');
        super.BeginState(PreviousStateName);
        //return;        
    }

    function EndState(name NextStateName)
    {
        ClearTimer('DoneReactingSelfDestruct');
        super.EndState(NextStateName);
        //return;        
    }

    simulated event float GetDesiredThrottleSpeed()
    {
        return -1.0000000;
        //return ReturnValue;        
    }

    simulated event bool ShouldOffsetFocalPointAbovePawn()
    {
        return false;
        //return ReturnValue;        
    }
Begin:

    Focus = Enemy;
    // End:0x42
    if(PickSpecialManeuver(7, true))
    {
        PushState('FlyingSpecialManeuver');
        SkyVehicle(Pawn).StartSecondaryFire(0);
    }
    ClearPendingSM();
    Sleep(0.1000000);
    // End:0x6A
    if(IsTimerActive('DoneReactingSelfDestruct') == false)
    {
    }
    goto 'Begin';
    stop;                
}

state FlyingStumble extends PILOTSTATE
{
    ignores WhatToDoNext, RammingImminent;

    simulated function bool MigrationCheck()
    {
        return false;
        //return ReturnValue;        
    }

    simulated function DoSeekLandingZoneExpired()
    {
        GotoState('FlyingSeekLandingZone');
        //return;        
    }

    simulated event bool CareAboutCollisionPrediction()
    {
        return false;
        //return ReturnValue;        
    }

    event bool FaceRotationTimeOut()
    {
        return false;
        //return ReturnValue;        
    }

    function BeginState(name PreviousStateName)
    {
        local SkyBot SkyBotController;

        super.BeginState(PreviousStateName);
        SkyBotController = GetBehaviorTreeController();
        // End:0x44
        if(SkyBotController != none)
        {
            SkyBotController.FireExternalEvent("BeginStumble");
        }
        //return;        
    }

    function EndState(name NextStateName)
    {
        local SkyBot SkyBotController;

        SkyBotController = GetBehaviorTreeController();
        // End:0x37
        if(SkyBotController != none)
        {
            SkyBotController.FireExternalEvent("EndStumble");
        }
        super.EndState(NextStateName);
        //return;        
    }

    simulated function DoBeginCode()
    {
        local SkyAirVehicle CurrentSkyAirVehicle;

        CurrentSkyAirVehicle = SkyAirVehicle(Pawn);
        // End:0x3C
        if(CurrentSkyAirVehicle != none)
        {
            SkyVehicleSim_CrimsonAircraft(CurrentSkyAirVehicle.SimObj).bIsHovering = true;
        }
        StopFiring();
        bAllowedToDoFlyBy = false;
        //return;        
    }

    simulated function DoEndCode()
    {
        local SkyAirVehicle CurrentSkyAirVehicle;

        CurrentSkyAirVehicle = SkyAirVehicle(Pawn);
        // End:0x3C
        if(CurrentSkyAirVehicle != none)
        {
            SkyVehicleSim_CrimsonAircraft(CurrentSkyAirVehicle.SimObj).bIsHovering = false;
        }
        //return;        
    }

    simulated event float GetDesiredThrottleSpeed()
    {
        return -1.0000000;
        //return ReturnValue;        
    }

    simulated event bool ShouldOffsetFocalPointAbovePawn()
    {
        return false;
        //return ReturnValue;        
    }
Begin:

    Focus = none;
    SetFocalPoint(Pawn.Location + (Vector(Pawn.Rotation) * 10000.0000000));
    Sleep(60.0000000);
    DoRangedAttackOn(Enemy);
    Sleep(0.1000000);
    stop;        
}

state FlyingResting extends PILOTSTATE
{
    ignores WhatToDoNext, RammingImminent, RequestChangeState;

    simulated function bool MigrationCheck()
    {
        return false;
        //return ReturnValue;        
    }

    simulated function DoSeekLandingZoneExpired()
    {
        GotoState('FlyingSeekLandingZone');
        //return;        
    }

    simulated event bool CareAboutCollisionPrediction()
    {
        return false;
        //return ReturnValue;        
    }

    event bool FaceRotationTimeOut()
    {
        return false;
        //return ReturnValue;        
    }

    simulated function DoBeginCode()
    {
        local SkyAirVehicle CurrentSkyAirVehicle;

        CurrentSkyAirVehicle = SkyAirVehicle(Pawn);
        // End:0x3C
        if(CurrentSkyAirVehicle != none)
        {
            SkyVehicleSim_CrimsonAircraft(CurrentSkyAirVehicle.SimObj).bIsHovering = true;
        }
        StopFiring();
        bAllowedToDoFlyBy = false;
        //return;        
    }

    simulated function DoEndCode()
    {
        local SkyAirVehicle CurrentSkyAirVehicle;

        CurrentSkyAirVehicle = SkyAirVehicle(Pawn);
        // End:0x3C
        if(CurrentSkyAirVehicle != none)
        {
            SkyVehicleSim_CrimsonAircraft(CurrentSkyAirVehicle.SimObj).bIsHovering = false;
        }
        //return;        
    }

    simulated event float GetDesiredThrottleSpeed()
    {
        return -1.0000000;
        //return ReturnValue;        
    }

    simulated event bool ShouldOffsetFocalPointAbovePawn()
    {
        return false;
        //return ReturnValue;        
    }
Begin:

    // End:0x16
    if(Focus == none)
    {
        Focus = Enemy;
    }
    Temp_State_Float = WorldInfo.TimeSeconds + P_RestingWaitTime;
    J0x32:

    // End:0xAC [Loop If]
    if(WorldInfo.TimeSeconds <= Temp_State_Float)
    {
        // End:0xA1
        if(IsOutsideTether(0.0000000))
        {
            // End:0x9E
            if((Vector(Pawn.Rotation) Dot (TetherActor.Location - Pawn.Location)) <= 0.0000000)
            {
                Sleep(0.7500000);
            }
            // [Explicit Break]
            goto J0xAC;
        }
        Sleep(0.2500000);
        // [Loop Continue]
        goto J0x32;
    }
    J0xAC:

    DoRangedAttackOn(Enemy);
    Sleep(0.0100000);
    stop;                    
}

state FlyingFollowSpline extends PILOTSTATE
{
    ignores WhatToDoNext, RammingImminent, EnterTurnAroundVolumes, ExitTurnAroundVolumes, DoFlyingBeingHijacked, DoRangedAttackOn, 
	    DoEndCode;

    simulated function bool MigrationCheck()
    {
        return false;
        //return ReturnValue;        
    }

    event bool FaceRotationTimeOut()
    {
        return false;
        //return ReturnValue;        
    }

    simulated function bool AllowedToDoSpecialManeuver()
    {
        return false;
        //return ReturnValue;        
    }

    simulated function StopCruiseControl()
    {
        bCruiseControlOn = false;
        //return;        
    }

    simulated event SetCruiseControlForcedBySpline(float MilesPerHour, float TimeToReachSpeed)
    {
        global.SetCruiseControl(MilesPerHour, TimeToReachSpeed);
        //return;        
    }

    simulated event bool CareAboutCollisionPrediction()
    {
        return false;
        //return ReturnValue;        
    }

    simulated event float GetDesiredThrottleSpeed()
    {
        local float SteeringAngle, SteeringDegrees, myDot;
        local SkyAirVehicle SVeh;
        local float myThrottle, myThrottle2;

        SVeh = SkyAirVehicle(Pawn);
        // End:0xD1
        if(SVeh != none)
        {
            myDot = Normal(GetFocalPoint() - SVeh.Location) Dot Normal(SVeh.Velocity);
            SteeringAngle = Acos(myDot);
            SteeringDegrees = SteeringAngle * (180.0000000 / 3.1415930);
            myThrottle = (180.0000000 - SteeringDegrees) / 180.0000000;
            myThrottle -= 1.0000000;
            myThrottle2 = AdjustThrottleBySplineLookAhead();
            myThrottle += myThrottle2;
            myThrottle = FClamp(myThrottle, -1.0000000, 1.0000000);
            return myThrottle;
        }
        //return ReturnValue;        
    }

    simulated function DoBeginCode()
    {
        // End:0x3E
        if((Pawn != none) && Pawn.Weapon != none)
        {
            Pawn.Weapon.ClearTimer();
        }
        Focus = none;
        bAllowedToDoFlyBy = false;
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        local editinline SkyVehicleSim_CrimsonAircraft Sim;
        local float SlowestSpeed;
        local SkyAirVehicle SAV;

        super.BeginState(PreviousStateName);
        bFollowingSpline = true;
        bBeenWithinToleranceYet = false;
        SAV = SkyAirVehicle(Pawn);
        // End:0x279
        if(SAV != none)
        {
            Sim = SkyVehicleSim_CrimsonAircraft(SAV.SimObj);
            // End:0x279
            if(Sim != none)
            {
                SavedManeuverAcceleration = Sim.ManeuverAcceleration;
                SavedManeuverDeceleration = Sim.ManeuverDeceleration;
                SavedManeuverMaxRate = Sim.ManeuverMaxRate;
                SavedBrakeScale = Sim.BrakeScale;
                SavedSplineDataIsValid = true;
                // End:0x1F9
                if(bSplineUseAggressivePrecision == true)
                {
                    SlowestSpeed = SAV.AirSpeed * Sim.BrakeScale;
                    SlowestSpeed *= 0.0223693;
                    // End:0x161
                    if(SlowestSpeed > SplineLowestDesiredMPH)
                    {
                        J0x104:

                        // End:0x15E [Loop If]
                        if(SlowestSpeed > SplineLowestDesiredMPH)
                        {
                            Sim.BrakeScale -= 0.1000000;
                            SlowestSpeed = SAV.AirSpeed * Sim.BrakeScale;
                            SlowestSpeed *= 0.0223693;
                            // [Loop Continue]
                            goto J0x104;
                        }                        
                    }
                    else
                    {
                        // End:0x1CA
                        if(SlowestSpeed < SplineLowestDesiredMPH)
                        {
                            J0x170:

                            // End:0x1CA [Loop If]
                            if(SlowestSpeed < SplineLowestDesiredMPH)
                            {
                                Sim.BrakeScale += 0.1000000;
                                SlowestSpeed = SAV.AirSpeed * Sim.BrakeScale;
                                SlowestSpeed *= 0.0223693;
                                // [Loop Continue]
                                goto J0x170;
                            }
                        }
                    }
                    SplineSteeringPulse = SplineSteeringPulse_AggressivePrecision;
                    SplineData_ThrottleSlowdownDistBehind0 = SplineData_ThrottleSlowdownDistBehind0_AggressivePrecision;
                    SplineData_ThrottleSlowdownDistAhead1 = SplineData_ThrottleSlowdownDistAhead1_AggressivePrecision;
                    SplineData_ThrottleSlowdownDistAhead2 = SplineData_ThrottleSlowdownDistAhead2_AggressivePrecision;                    
                }
                else
                {
                    Sim.BrakeScale = SplineBrakeScale;
                    SplineSteeringPulse = SplineSteeringPulse_Default;
                    SplineData_ThrottleSlowdownDistBehind0 = SplineData_ThrottleSlowdownDistBehind0_Default;
                    SplineData_ThrottleSlowdownDistAhead1 = SplineData_ThrottleSlowdownDistAhead1_Default;
                    SplineData_ThrottleSlowdownDistAhead2 = SplineData_ThrottleSlowdownDistAhead2_Default;
                }
                Sim.ManeuverAcceleration = SplineManeuverAcceleration;
                Sim.ManeuverDeceleration = SplineManeuverDeceleration;
                Sim.ManeuverMaxRate = SplineManeuverMaxRate;
            }
        }
        SetTimer(0.0001000 + SplineSteeringPulse, true, 'DoSplineSteering');
        //return;        
    }

    function EndState(name NextStateName)
    {
        ClearTimer('StopCruiseControl');
        ExitSplineFollowing();
        super.EndState(NextStateName);
        //return;        
    }
Begin:

    // End:0x66
    if(bCurrentlyMigrating == true)
    {
        // End:0x66
        if(IsOutsideTether(0.0000000) == false)
        {
            // End:0x66
            if(VSize(Pawn.Location - TetherActor.Location) <= (TetherDistance * 0.5000000))
            {
                bCurrentlyMigrating = false;
                GotoState('FlyingStakeOut');
            }
        }
    }
    Sleep(0.5000000);
    goto 'Begin';
    stop;                
}

state FlyingAvoidObstacle extends PILOTSTATE
{
    ignores WhatToDoNext, RammingImminent, RequestChangeState, DoRangedAttackOn, DoFlyingBeingHijacked, AllowEarlyOut;

    simulated event bool CareAboutCollisionPrediction()
    {
        return false;
        //return ReturnValue;        
    }

    simulated event float GetDesiredThrottleSpeed()
    {
        return -1.0000000;
        //return ReturnValue;        
    }

    simulated function bool MigrationCheck()
    {
        return false;
        //return ReturnValue;        
    }

    function DoneWithAvoid()
    {
        // End:0x19
        if(bSpecialMoveMode)
        {
            GotoState('FlyingSpecialMove_DEBUG');
            return;
        }
        // End:0x50
        if(TetherActor != none)
        {
            // End:0x4D
            if(bTetherEnabled && IsOutsideTether(0.0000000))
            {
                GotoState('FlyingMigrate');
                return;
            }            
        }
        // End:0x6C
        if(bWantHoverMode == true)
        {
            GotoState('FlyingHoverAttack');
            return;
        }
        // End:0xAD
        if((SkyAirVehicle(Pawn) != none) && SkyAirVehicle(Pawn).IsBeingHijacked())
        {
            GotoState('FlyingBeingHijacked');
            return;            
        }
        else
        {
            // End:0xEA
            if(CurrentAILandingZone == none)
            {
                // End:0xD7
                if(PreferRetreatAfterAvoid == true)
                {
                    GotoState('FlyingRetreat');
                    return;                    
                }
                else
                {
                    GotoState('FlyingRetreat');
                    return;
                }                
            }
            else
            {
                GotoState('FlyingSeekLandingZone');
                return;
            }
        }
        //return;        
    }

    simulated function TurnOffFullBrakeScale()
    {
        bApplyingFullBrakeScale = false;
        SetBrakeScaleForMPH(SlowestDesiredMPH);
        //return;        
    }

    simulated function DoBeginCode()
    {
        local float myDot, ratio;
        local editinline SkyVehicleSim_CrimsonAircraft Sim;

        Sim = SkyVehicleSim_CrimsonAircraft(SkyAirVehicle(Pawn).SimObj);
        // End:0xE6
        if((Sim != none) && SkyAirVehicle(Pawn).bAISmallVehicle == false)
        {
            Sim.ManeuverAcceleration = SkyVehicleSim_CrimsonAircraft(Sim.ObjectArchetype).ManeuverAcceleration * 1.3300000;
            Sim.ManeuverDeceleration = SkyVehicleSim_CrimsonAircraft(Sim.ObjectArchetype).ManeuverDeceleration * 1.3300000;
            Sim.ManeuverMaxRate = SkyVehicleSim_CrimsonAircraft(Sim.ObjectArchetype).ManeuverMaxRate * 1.3300000;
        }
        StopFiring();
        // End:0x12E
        if((Pawn != none) && Pawn.Weapon != none)
        {
            Pawn.Weapon.ClearTimer();
        }
        DirectionBeforeAvoid = Vector(Pawn.Rotation);
        // End:0x1CD
        if(bApplyingFullBrakeScale == false)
        {
            // End:0x1CD
            if(bLastTraceBoxInfoIsValid)
            {
                myDot = DirectionBeforeAvoid Dot Normal(LastEndTracePoint - Pawn.Location);
                ratio = 1.0000000 - (Acos(myDot) / 3.1415930);
                ratio = 20.0000000 + (ratio * (SlowestDesiredMPH - 20.0000000));
                SetBrakeScaleForMPH(ratio);
            }
        }
        bAllowedToDoFlyBy = false;
        //return;        
    }

    simulated function DoEndCode()
    {
        local editinline SkyVehicleSim_CrimsonAircraft Sim;

        SetBrakeScale(SlowestDesiredBrakeScaleInternal);
        bApplyingFullBrakeScale = false;
        Sim = SkyVehicleSim_CrimsonAircraft(SkyAirVehicle(Pawn).SimObj);
        // End:0xF9
        if(Sim != none)
        {
            Sim.Deceleration = SkyVehicleSim_CrimsonAircraft(Sim.ObjectArchetype).Deceleration;
            Sim.ManeuverAcceleration = SkyVehicleSim_CrimsonAircraft(Sim.ObjectArchetype).ManeuverAcceleration;
            Sim.ManeuverDeceleration = SkyVehicleSim_CrimsonAircraft(Sim.ObjectArchetype).ManeuverDeceleration;
            Sim.ManeuverMaxRate = SkyVehicleSim_CrimsonAircraft(Sim.ObjectArchetype).ManeuverMaxRate;
        }
        bCurrentlyAutoCorrecting = false;
        ClearTimer('TurnOffFullBrakeScale');
        //return;        
    }

    function EndState(name NextStateName)
    {
        ClearTimer('DoneWithAvoid');
        bAvoidObstacleAllowEarlyOut = true;
        super.EndState(NextStateName);
        //return;        
    }
Begin:

    // End:0x14F
    if(bLastTraceBoxInfoIsValid == true)
    {
        // End:0x129
        if((Vector(Pawn.Rotation) Dot Normal(LastEndTracePoint - LastStartTracePoint)) <= -0.9000000)
        {
            bApplyingFullBrakeScale = true;
            SetBrakeScaleForMPH(FullBrakeScaleDesiredMPH);
            // End:0x113
            if((SkyAirVehicle(Pawn) != none) && SkyAirVehicle(Pawn).IsBeingHijacked() == false)
            {
                // End:0x113
                if(IsTimerActive('SnapTurnLockedOut') == false)
                {
                    Pawn.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
                    Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
                    PendingSpecialManeuver = 'SnapTurn';
                    PushState('FlyingSpecialManeuver');
                    SetTimer(10.0000000, false, 'SnapTurnLockedOut');
                    DoneWithAvoid();
                    Sleep(0.0100000);
                }
            }
            SetTimer(2.5000000, false, 'TurnOffFullBrakeScale');            
        }
        else
        {
            // End:0x14F
            if(SkyAirVehicle(Pawn).bAISmallVehicle == false)
            {
                PAvoidObsTimer = 1.5000000;
            }
        }
    }
    SetTimer(0.0001000 + PAvoidObsTimer, false, 'DoneWithAvoid');
Wait:


    Sleep(0.0100000);
    // End:0x1CE
    if(Enemy != none)
    {
        // End:0x1CE
        if(SkyAirVehicle(Pawn).NeedToTurnNative(Enemy.GetTargetLocation(self)) == false)
        {
            // End:0x1CE
            if(CheckFirePermit(Enemy))
            {
                FireWeaponAt(Enemy);
            }
        }
    }
    // End:0x24C
    if(bAvoidObstacleAllowEarlyOut && bLastTraceBoxInfoIsValid)
    {
        // End:0x24C
        if(bCurrentlyAutoCorrecting == false)
        {
            // End:0x24C
            if((Vector(Pawn.Rotation) Dot Normal((LastEndTracePoint + (Normal(LastEndTracePoint - LastStartTracePoint) * 20000.0000000)) - Pawn.Location)) >= 0.9000000)
            {
                DoneWithAvoid();
                Sleep(0.0100000);
            }
        }
    }
    goto 'Wait';
    stop;        
}

state FlyingSeekLandingZone extends PILOTSTATE
{
    ignores WhatToDoNext, RammingImminent, RequestChangeState, DoRangedAttackOn, SlowDownTimer, DoBeginCode, 
	    DoEndCode;

    simulated function DoSeekLandingZoneExpired()
    {
        ClearTimer('DoSeekLandingZoneExpired');
        //return;        
    }

    simulated event bool ShouldShrinkCollisionBox()
    {
        local float Dist;

        Dist = VSize(CurrentAILandingZone.TheCenter - Pawn.Location);
        // End:0x59
        if(Dist <= 30000.0000000)
        {
            // End:0x59
            if(FastTrace(GetFocalPoint(), Pawn.Location) == true)
            {
                return true;
            }
        }
        return false;
        //return ReturnValue;        
    }

    simulated event float GetDesiredThrottleSpeed()
    {
        local float Dist, ratio;

        // End:0x1C
        if(IsTimerActive('SlowDownTimer'))
        {
            return -0.9000000;            
        }
        else
        {
            Dist = VSize(CurrentAILandingZone.TheCenter - Pawn.Location);
            // End:0x7F
            if(Dist <= 30000.0000000)
            {
                ratio = Dist / 30000.0000000;
                ratio = 1.0000000 - ratio;
                return -ratio;
            }
        }
        return 0.0000000;
        //return ReturnValue;        
    }

    event bool FaceRotationTimeOut()
    {
        SetTimer(3.0000000, false, 'SlowDownTimer');
        return true;
        //return ReturnValue;        
    }

    simulated function EndState(name NextStateName)
    {
        ClearTimer('SlowDownTimer');
        super.EndState(NextStateName);
        //return;        
    }

    simulated function Vector FindFakeLanding()
    {
        local Vector destSpot;

        // End:0x113
        if(CurrentAILandingZone.TheCenter.Z > (Pawn.Location.Z + 500.0000000))
        {
            destSpot.X = Pawn.Location.X - CurrentAILandingZone.TheCenter.X;
            destSpot.Y = Pawn.Location.Y - CurrentAILandingZone.TheCenter.Y;
            destSpot.Z = 0.0000000;
            Normal(destSpot);
            destSpot *= 10000.0000000;
            destSpot += CurrentAILandingZone.TheCenter;
            return destSpot;
        }
        return CurrentAILandingZone.TheCenter;
        //return ReturnValue;        
    }
Wait:

    // End:0x27
    if(CurrentAILandingZone.Encompasses(Pawn))
    {
        EnteredCurrentLandingZone(true);
    }
    Focus = none;
    // End:0x70
    if(FastTrace(CurrentAILandingZone.TheCenter, Pawn.Location) == true)
    {
        SetFocalPoint(CurrentAILandingZone.TheCenter);        
    }
    else
    {
        SetFocalPoint(FindFakeLanding());
    }
    Sleep(0.2500000);
    goto 'Wait';
    stop;                    
}

state FlyingTakeOff extends PILOTSTATE
{
    ignores WhatToDoNext, SeePlayer, RammingImminent, RequestChangeState, FindSplinePathUsingVolumes, DoBeginCode, 
	    DoEndCode;

    simulated function bool MigrationCheck()
    {
        return false;
        //return ReturnValue;        
    }

    simulated event bool CareAboutCollisionPrediction()
    {
        return false;
        //return ReturnValue;        
    }

    event bool FaceRotationTimeOut()
    {
        return false;
        //return ReturnValue;        
    }

    simulated event bool IsTakingOff()
    {
        return true;
        //return ReturnValue;        
    }

    function TakeOffDone()
    {
        DoRangedAttackOn(Enemy);
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        SetTimer(0.0001000 + CheckForHijackersTime, true, 'CheckForHijackers');
        Focus = none;
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        ClearTimer('TakeOffDone');
        Pawn.AirSpeed = Pawn(Pawn.ObjectArchetype).AirSpeed;
        SkyAirVehicle(Pawn).bTakeoff = false;
        super.EndState(NextStateName);
        //return;        
    }
Begin:

    // End:0x48
    if((SkyAirVehicle(Pawn) != none) && int(SkyAirVehicle(Pawn).AirVehicleState) != 3)
    {
        SkyAirVehicle(Pawn).Takeoff();
    }
    Focus = none;
    // End:0xBB
    if(bTakeoffOnStartup && VSizeSq(TakeoffDirection) > 0.0000000)
    {
        Pawn.AirSpeed *= 0.2500000;
        SetFocalPoint(Pawn.Location + ((TakeoffDirection * float(300000)) * PTakeOffTimer));
        FixupFocalPoint();        
    }
    else
    {
        SetFocalPoint((Normal(Vector(Pawn.Rotation) + vect(0.0000000, 0.0000000, 0.2500000)) * 300000.0000000) + Pawn.Location);
    }
    SetTimer(0.0001000 + PTakeOffTimer, false, 'TakeOffDone');
    stop;        
}

state FlyingRotationTimedOut extends PILOTSTATE
{
    ignores DoRangedAttackOn;

    event bool FaceRotationTimeOut()
    {
        TravelToNewLocationDone();
        return true;
        //return ReturnValue;        
    }

    simulated function DoSeekLandingZoneExpired()
    {
        GotoState('FlyingSeekLandingZone');
        //return;        
    }

    function TravelToNewLocationDone()
    {
        GotoState('FlyingRangedAttack');
        //return;        
    }

    simulated function CheckIfAtRTODest()
    {
        // End:0x1C
        if(ReachedFocalPoint(3000.0000000))
        {
            TravelToNewLocationDone();
        }
        //return;        
    }

    simulated function ChooseNewRTODest()
    {
        local Vector tempFocalPoint;

        tempFocalPoint.X = FRand() - 0.5000000;
        tempFocalPoint.Y = FRand() - 0.5000000;
        tempFocalPoint.Z = 0.0000000;
        tempFocalPoint = Normal(tempFocalPoint);
        tempFocalPoint *= (50000.0000000 + (FRand() * 2000.0000000));
        tempFocalPoint.X += Pawn.Location.X;
        tempFocalPoint.Y += Pawn.Location.Y;
        tempFocalPoint.Z = SkyAirVehicle(Pawn).CruisingAltitude + ((FRand() - 0.5000000) * CruisingAltitudeRange);
        Focus = none;
        SetFocalPoint(tempFocalPoint);
        FixupFocalPoint();
        //return;        
    }

    simulated function DoBeginCode()
    {
        ChooseNewRTODest();
        SetTimer(0.0333300, true, 'CheckIfAtRTODest');
        //return;        
    }

    simulated function DoEndCode()
    {
        ClearTimer('TravelToNewLocationDone');
        ClearTimer('CheckIfAtRTODest');
        //return;        
    }
Begin:

    SetTimer(0.0001000 + PWaitToTurnTimer, false, 'TravelToNewLocationDone');
    Sleep(PWaitToTurnTimer + 0.5000000);
    goto 'Begin';
    stop;                    
}

state FlyingRangedAttack extends PILOTSTATE
{
    simulated event ImmediateTetherResting()
    {
        GotoState('FlyingResting');
        //return;        
    }

    simulated function DoSeekLandingZoneExpired()
    {
        GotoState('FlyingSeekLandingZone');
        //return;        
    }

    function bool CanAttack(Actor Other)
    {
        local Vector OtherToMe;
        local float Dist;

        // End:0x77
        if(((global.CanAttack(Other)) && Other != none) && Pawn != none)
        {
            OtherToMe = Other.GetTargetLocation(self) - Pawn.Location;
            Dist = VSize(OtherToMe);
            // End:0x77
            if(Dist < PCloseAttackDist)
            {
                return true;
            }
        }
        return false;
        //return ReturnValue;        
    }

    simulated event float GetDesiredThrottleSpeed()
    {
        local Vector PawnToEnemy;

        PawnToEnemy = Enemy.Location - Pawn.Location;
        // End:0x63
        if((VSize(PawnToEnemy) > 20000.0000000) || (Normal(PawnToEnemy) Dot Vector(Pawn.Rotation)) >= 0.9800000)
        {
            return 0.8000000;
        }
        return global.GetDesiredThrottleSpeed();
        //return ReturnValue;        
    }

    function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        PlayPilotChatter(6, TeamNum);
        //return;        
    }

    function EndState(name NextStateName)
    {
        ClearTimer('DoDelayedEvade');
        super.EndState(NextStateName);
        //return;        
    }

    simulated function DoDelayedEvade()
    {
        // End:0x1A
        if((ShouldEvade()) == true)
        {
            DoEvade();
        }
        //return;        
    }
Begin:

    Sleep(0.0000000);
    // End:0x21
    if(Enemy == none)
    {
        GotoState('FlyingStakeOut');
    }
    // End:0x4C
    if(Focus == none)
    {
        Focus = Enemy;
        // End:0x4C
        if(Focus == none)
        {
            WhatToDoNext();
        }
    }
    SetFocalPoint(SkyAirVehicle(Pawn).GetAdjustedFocalPoint(Focus));
    // End:0xDB
    if((bCanEvade == true) && IsTimerActive('DoDelayedEvade') == false)
    {
        // End:0xDB
        if((ShouldEvade()) == true)
        {
            // End:0xC1
            if(PBlockEvadeDelay == 0.0000000)
            {
                DoDelayedEvade();                
            }
            else
            {
                SetTimer(0.0001000 + PBlockEvadeDelay, false, 'DoDelayedEvade');
            }
        }
    }
    J0xDB:

    // End:0x1A7 [Loop If]
    if(SkyAirVehicle(Pawn).NeedToTurnNative(GetFocalPoint()))
    {
        // End:0x119
        if(ReadyToDoSM())
        {
            PushState('FlyingSpecialManeuver');            
        }
        else
        {
            // End:0x153
            if(CanDoSM_180())
            {
                // End:0x153
                if((Enemy != none) && PickSpecialManeuver(1, true))
                {
                    PushState('FlyingSpecialManeuver');
                }
            }
        }
        // End:0x19C
        if(SkyAirVehicle(Pawn).bAISmallVehicle)
        {
            // End:0x19C
            if(VSize(GetFocalPoint() - Pawn.Location) < TooCloseToRangedAttackFocalPoint)
            {
                GotoState('FlyingRetreat');
            }
        }
        Sleep(0.1000000);
        // [Loop Continue]
        goto J0xDB;
    }
    // End:0x1BD
    if(Focus == none)
    {
        Focus = Enemy;
    }
    // End:0x1DE
    if(CanAttack(Focus))
    {
        DoCloseRangeAttackOn(Focus);
    }
    Sleep(0.1000000);
    // End:0x203
    if(ReadyToDoSM())
    {
        PushState('FlyingSpecialManeuver');
    }
    // End:0x23D
    if(CanDoSM_180())
    {
        // End:0x23D
        if((Enemy != none) && PickSpecialManeuver(1, true))
        {
            PushState('FlyingSpecialManeuver');
        }
    }
    goto 'Begin';
    stop;                    
}

state Frozen
{
    ignores WhatToDoNext, FindSplinePathUsingVolumes, DoFlyingBeingHijacked, DoRangedAttackOn, DoBeginCode, DoEndCode;

    event bool FaceRotationTimeOut()
    {
        return false;
        //return ReturnValue;        
    }

    simulated event bool CareAboutCollisionPrediction()
    {
        return false;
        //return ReturnValue;        
    }

    simulated function bool AllowedToDoSpecialManeuver()
    {
        return false;
        //return ReturnValue;        
    }
    stop;    
}

state FrozenInputLocked
{
    event bool FaceRotationTimeOut()
    {
        return false;
        //return ReturnValue;        
    }

    simulated event bool CareAboutCollisionPrediction()
    {
        return false;
        //return ReturnValue;        
    }
    stop;    
}

state FlyingPursuit extends PILOTSTATE
{
    ignores WhatToDoNext, RammingImminent;

    simulated event ResumeSecondaryFireCountdown()
    {
        // End:0x2A
        if(TimeLeftBeforeFiringSecondaryWeapon > float(0))
        {
            SetTimer(0.0001000 + TimeLeftBeforeFiringSecondaryWeapon, false, 'FireSecondaryExpired');            
        }
        else
        {
            SetTimer((0.0001000 + PursuitSecondaryWeapFire_MinSec) + ((PursuitSecondaryWeapFire_MaxSec - PursuitSecondaryWeapFire_MinSec) * FRand()), false, 'FireSecondaryExpired');
        }
        //return;        
    }

    simulated function DoSeekLandingZoneExpired()
    {
        GotoState('FlyingSeekLandingZone');
        //return;        
    }

    simulated event float GetDesiredThrottleSpeed()
    {
        local float myThrottleSpeed;

        // End:0xD4
        if((Pawn != none) && Enemy != none)
        {
            // End:0x54
            if(VSize(Pawn.Location - Enemy.GetTargetLocation(self)) > PPursuitStayWithinDistMax)
            {
                return PursuitMaxThrottleRatio;                
            }
            else
            {
                // End:0x9B
                if(VSize(Pawn.Location - Enemy.GetTargetLocation(self)) < PPursuitTooCloseDist)
                {
                    myThrottleSpeed = -1.0000000;
                    return myThrottleSpeed;                    
                }
                else
                {
                    // End:0xD4
                    if(VSize(Pawn.Location - Enemy.GetTargetLocation(self)) < PPursuitStayWithinDistMin)
                    {
                        return 0.0000000;
                    }
                }
            }
        }
        return 1.0000000;
        //return ReturnValue;        
    }

    function bool CanAttack(Actor Other)
    {
        local Vector OtherToMe;
        local float Dist;

        // End:0x85
        if((global.CanAttack(Other)) && bFireMode_Allow == true)
        {
            // End:0x85
            if((Other != none) && Pawn != none)
            {
                OtherToMe = Other.GetTargetLocation(self) - Pawn.Location;
                Dist = VSize(OtherToMe);
                // End:0x83
                if(Dist < PCloseAttackDist)
                {
                    return true;
                }
                return false;
            }
        }
        return false;
        //return ReturnValue;        
    }

    simulated function AllowFireOff()
    {
        bFireMode_Allow = false;
        SetTimer(Pursuit_AllowFire_Time_Off, false, 'AllowFireOn');
        PlayPilotChatter(2, TeamNum);
        //return;        
    }

    simulated function AllowFireOn()
    {
        bFireMode_Allow = true;
        SetTimer(Pursuit_AllowFire_Time_On, false, 'AllowFireOff');
        //return;        
    }

    simulated function DoBeginCode()
    {
        ResumeSecondaryFireCountdown();
        AllowFireOn();
        //return;        
    }

    simulated function DoEndCode()
    {
        PauseSecondaryFireCountdown();
        ClearTimer('AllowFireOn');
        ClearTimer('AllowFireOff');
        //return;        
    }
Begin:

    // End:0x19
    if(Enemy == none)
    {
        GotoState('FlyingStakeOut');
    }
    // End:0x37
    if((CanStartPursuit()) == false)
    {
        GotoState('FlyingRangedAttack');
    }
    // End:0x76
    if(Enemy != none)
    {
        Focus = Enemy;
        Sleep(0.1000000);
        // End:0x76
        if(SkyAirVehicle(Pawn).NeedToTurnNative(GetFocalPoint()))
        {
            FinishRotation();
        }
    }
    // End:0xC0
    if(CanAttack(Focus))
    {
        // End:0xA9
        if(CheckFirePermit(Focus))
        {
            FireWeaponAt(Focus);
        }
        // End:0xC0
        if(bSecondaryFirePending == true)
        {
            FirePendingSecondary(Focus);
        }
    }
    Sleep(0.2500000);
    goto 'Begin';
    stop;        
}

state FlyingEvade extends PILOTSTATE
{
    ignores WhatToDoNext, DoRangedAttackOn;

    simulated function DoSeekLandingZoneExpired()
    {
        GotoState('FlyingSeekLandingZone');
        //return;        
    }

    simulated function EvadeTakeHitSMExpired()
    {
        //return;        
    }

    simulated event float GetDesiredThrottleSpeed()
    {
        // End:0x12
        if(bDoingHardEvade)
        {
            return 1.0000000;            
        }
        else
        {
            // End:0x9F
            if((Pawn != none) && Enemy != none)
            {
                // End:0x66
                if(VSize(Pawn.Location - Enemy.GetTargetLocation(self)) < PEvadeStayWithinDistMin)
                {
                    return PEvadeIsLessThanDistMin_Throttle_Easy;                    
                }
                else
                {
                    // End:0x9F
                    if(VSize(Pawn.Location - Enemy.GetTargetLocation(self)) > PEvadeStayWithinDistMax)
                    {
                        return PEvadeIsGreaterThanDistMax_Throttle_Easy;
                    }
                }
            }
        }
        return PEvadeInSweetSpot_Throttle_Easy;
        //return ReturnValue;        
    }

    function bool CanAttack(Actor Other)
    {
        StopFiring();
        return false;
        //return ReturnValue;        
    }

    simulated function StopEvade()
    {
        bCanEvade = false;
        GotoState('FlyingRangedAttack');
        //return;        
    }

    simulated function EvadeTimer()
    {
        local Vector tempVec;
        local Rotator myRot;

        tempVec = Pawn.Location - Enemy.GetTargetLocation(self);
        // End:0x4E
        if(VSize(tempVec) > PMaxEvadeDist)
        {
            GotoState('FlyingRangedAttack');
            return;
        }
        // End:0x7A
        if(bDoingHardEvade)
        {
            GetRandomDirection(PEvadeDirectionVarianceDegrees * 0.5000000, PEvadeDirectionVarianceDegrees, myRot);            
        }
        else
        {
            GetRandomDirection(5.0000000, 10.0000000, myRot);
        }
        // End:0xAD
        if(bDoingHardEvade)
        {
            myRot = Rotator(-Vector(myRot));
        }
        // End:0x12B
        if(SkyAirVehicle(Pawn) != none)
        {
            // End:0x12B
            if(Pawn.Location.Z > (SkyAirVehicle(Pawn).CruisingAltitude + (0.5000000 * CruisingAltitudeRange)))
            {
                myRot.Pitch = int(-Abs(FRand() * float(myRot.Pitch)));
            }
        }
        SetFocalPoint(Pawn.Location + (Vector(Pawn.Rotation + myRot) * 100000.0000000));
        Focus = none;
        FixupFocalPoint();
        // End:0x1A4
        if(bDoingHardEvade == false)
        {
            SetTimer((0.0001000 + PMinEvadeReThinkSec) + (FRand() * PEvadeReThinkVariance), false, 'EvadeTimer');            
        }
        else
        {
            SetTimer((0.0000100 + 2.0000000) + (FRand() * 0.5000000), false, 'EvadeTimer');
        }
        //return;        
    }

    simulated function DoBeginCode()
    {
        bIsEvading = true;
        EvadeTimer();
        //return;        
    }

    simulated function DoEndCode()
    {
        ClearTimer('EvadeTimer');
        bIsEvading = false;
        //return;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        bForceStartWithEasyEvade = false;
        // End:0x2E
        if(PreviousStateName == 'FlyingFlyBy')
        {
            bForceStartWithEasyEvade = true;
        }
        ClearPendingSM();
        SetTimer((0.0001000 + PMinTimeInEvadeState) + (FRand() * (PMaxTimeInEvadeState - PMinTimeInEvadeState)), false, 'StopEvade');
        // End:0xA6
        if(IsTimerActive('TrySpecialManeuverTimer') == false)
        {
            SetTimer((0.0001000 + EH_SpecialManeuverTimerMin) + (FRand() * (EH_SpecialManeuverTimerMax - EH_SpecialManeuverTimerMin)), false, 'TrySpecialManeuverTimer');
        }
        ClearPendingSM();
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        bCanUseBoost = true;
        ClearTimer('StopEvade');
        ClearTimer('TrySpecialManeuver');
        // End:0x6B
        if(bCanEvade == false)
        {
            SetTimer((0.0001000 + PMinTimeToEvadeAgain) + (FRand() * (PMaxTimeToEvadeAgain - PMinTimeToEvadeAgain)), false, 'EnableEvadeAgain');
        }
        //return;        
    }
Begin:

    bDoingHardEvade = true;
    EvadeTimer();
    HardEvadeExpireTime = PMinTimeUntilFirstEasyEvade + (FRand() * (PMaxTimeUntilFirstEasyEvade - PMinTimeUntilFirstEasyEvade));
    HardEvadeExpireTime += WorldInfo.TimeSeconds;
    // End:0x66
    if(bForceStartWithEasyEvade || FRand() <= 0.5000000)
    {
        goto 'EasyEvade';
    }
    J0x66:

    // End:0xCC [Loop If]
    if(WorldInfo.TimeSeconds <= HardEvadeExpireTime)
    {
        // End:0xA7
        if(IsTimerActive('StopEvade') == false)
        {
            StopEvade();
            Sleep(0.1000000);
        }
        // End:0xC1
        if((ShouldEvade()) == false)
        {
            StopEvade();
        }
        Sleep(0.2500000);
        // [Loop Continue]
        goto J0x66;
    }
EasyEvade:


    bDoingHardEvade = false;
    EvadeTimer();
    ClearPendingSM();
    bCanUseBoost = false;
    Sleep(PMinTimeEasyEvade + (FRand() * (PMaxTimeEasyEvade - PMinTimeEasyEvade)));
    bDoingHardEvade = true;
    EvadeTimer();
    bCanUseBoost = true;
    HardEvadeExpireTime = PMinTimeHardEvade + (FRand() * (PMaxTimeHardEvade - PMinTimeHardEvade));
    HardEvadeExpireTime += WorldInfo.TimeSeconds;
    PlayPilotChatter(3, TeamNum);
    J0x164:

    // End:0x1CA [Loop If]
    if(WorldInfo.TimeSeconds <= HardEvadeExpireTime)
    {
        // End:0x1A5
        if(IsTimerActive('StopEvade') == false)
        {
            StopEvade();
            Sleep(0.1000000);
        }
        // End:0x1BF
        if((ShouldEvade()) == false)
        {
            StopEvade();
        }
        Sleep(0.2500000);
        // [Loop Continue]
        goto J0x164;
    }
    goto 'EasyEvade';
    stop;                
}

state FlyingEvadeHijackMe extends PILOTSTATE
{
    ignores WhatToDoNext, DoRangedAttackOn;

    simulated function DoSeekLandingZoneExpired()
    {
        GotoState('FlyingSeekLandingZone');
        //return;        
    }

    function NotifyTakeHit(Controller InstigatedBy, Vector HitLocation, int Damage, class<DamageType> DamageType, Vector Momentum)
    {
        super(SkyBotControllerPilot).NotifyTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum);
        //return;        
    }

    simulated event float GetDesiredThrottleSpeed()
    {
        // End:0x12
        if(bDoingHardEvade)
        {
            return 1.0000000;            
        }
        else
        {
            // End:0x9F
            if((Pawn != none) && Enemy != none)
            {
                // End:0x66
                if(VSize(Pawn.Location - Enemy.GetTargetLocation(self)) < PEvadeStayWithinDistMin_HM)
                {
                    return PEvadeIsLessThanDistMin_Throttle_Easy_HM;                    
                }
                else
                {
                    // End:0x9F
                    if(VSize(Pawn.Location - Enemy.GetTargetLocation(self)) > PEvadeStayWithinDistMax_HM)
                    {
                        return PEvadeIsGreaterThanDistMax_Throttle_Easy_HM;
                    }
                }
            }
        }
        return PEvadeInSweetSpot_Throttle_Easy_HM;
        //return ReturnValue;        
    }

    function bool CanAttack(Actor Other)
    {
        StopFiring();
        return false;
        //return ReturnValue;        
    }

    simulated function StopEvade()
    {
        bCanEvade = false;
        GotoState('FlyingRangedAttack');
        //return;        
    }

    simulated function EvadeTimer()
    {
        local Vector tempVec;
        local Rotator myRot;

        tempVec = Pawn.Location - Enemy.GetTargetLocation(self);
        // End:0x4E
        if(VSize(tempVec) > PMaxEvadeDist_HM)
        {
            GotoState('FlyingRangedAttack');
            return;
        }
        // End:0x7A
        if(bDoingHardEvade)
        {
            GetRandomDirection(PEvadeDirectionVarianceDegrees_HM * 0.5000000, PEvadeDirectionVarianceDegrees_HM, myRot);            
        }
        else
        {
            GetRandomDirection(5.0000000, 10.0000000, myRot);
        }
        // End:0xAD
        if(bDoingHardEvade)
        {
            myRot = Rotator(-Vector(myRot));
        }
        // End:0x12B
        if(SkyAirVehicle(Pawn) != none)
        {
            // End:0x12B
            if(Pawn.Location.Z > (SkyAirVehicle(Pawn).CruisingAltitude + (0.5000000 * CruisingAltitudeRange)))
            {
                myRot.Pitch = int(-Abs(FRand() * float(myRot.Pitch)));
            }
        }
        SetFocalPoint(Pawn.Location + (Vector(Pawn.Rotation + myRot) * 100000.0000000));
        Focus = none;
        FixupFocalPoint();
        // End:0x1A4
        if(bDoingHardEvade == false)
        {
            SetTimer((0.0000100 + PMinEvadeReThinkSec_HM) + (FRand() * PEvadeReThinkVariance_HM), false, 'EvadeTimer');            
        }
        else
        {
            SetTimer((0.0000100 + 2.0000000) + (FRand() * 0.5000000), false, 'EvadeTimer');
        }
        //return;        
    }

    simulated function DoBeginCode()
    {
        bIsEvading = true;
        EvadeTimer();
        //return;        
    }

    simulated function DoEndCode()
    {
        ClearTimer('EvadeTimer');
        bIsEvading = false;
        //return;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        bForceStartWithEasyEvade = false;
        // End:0x2E
        if(PreviousStateName == 'FlyingFlyBy')
        {
            bForceStartWithEasyEvade = true;
        }
        SetTimer((0.0000100 + PMinTimeInEvadeState_HM) + (FRand() * (PMaxTimeInEvadeState_HM - PMinTimeInEvadeState_HM)), false, 'StopEvade');
        // End:0x9C
        if(IsTimerActive('TrySpecialManeuverTimer') == false)
        {
            SetTimer((0.0000100 + EHM_SpecialManeuverTimerMin) + (FRand() * (EHM_SpecialManeuverTimerMax - EHM_SpecialManeuverTimerMin)), false, 'TrySpecialManeuverTimer');
        }
        ClearPendingSM();
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        bCanUseBoost = true;
        ClearTimer('StopEvade');
        ClearTimer('TrySpecialManeuver');
        // End:0x6B
        if(bCanEvade == false)
        {
            SetTimer((0.0000100 + PMinTimeToEvadeAgain_HM) + (FRand() * (PMaxTimeToEvadeAgain_HM - PMinTimeToEvadeAgain_HM)), false, 'EnableEvadeAgain');
        }
        //return;        
    }
Begin:

    bDoingHardEvade = true;
    EvadeTimer();
    HardEvadeExpireTime = PMinTimeUntilFirstEasyEvade_HM + (FRand() * (PMaxTimeUntilFirstEasyEvade_HM - PMinTimeUntilFirstEasyEvade_HM));
    HardEvadeExpireTime += WorldInfo.TimeSeconds;
    // End:0x66
    if(bForceStartWithEasyEvade || FRand() <= 0.5000000)
    {
        goto 'EasyEvade';
    }
    J0x66:

    // End:0xCC [Loop If]
    if(WorldInfo.TimeSeconds <= HardEvadeExpireTime)
    {
        // End:0xA7
        if(IsTimerActive('StopEvade') == false)
        {
            StopEvade();
            Sleep(0.1000000);
        }
        // End:0xC1
        if((ShouldEvade()) == false)
        {
            StopEvade();
        }
        Sleep(0.2500000);
        // [Loop Continue]
        goto J0x66;
    }
EasyEvade:


    bDoingHardEvade = false;
    EvadeTimer();
    ClearPendingSM();
    bCanUseBoost = false;
    Sleep(PMinTimeEasyEvade_HM + (FRand() * (PMaxTimeEasyEvade_HM - PMinTimeEasyEvade_HM)));
    bDoingHardEvade = true;
    EvadeTimer();
    bCanUseBoost = true;
    HardEvadeExpireTime = PMinTimeHardEvade_HM + (FRand() * (PMaxTimeHardEvade_HM - PMinTimeHardEvade_HM));
    HardEvadeExpireTime += WorldInfo.TimeSeconds;
    J0x157:

    // End:0x1BD [Loop If]
    if(WorldInfo.TimeSeconds <= HardEvadeExpireTime)
    {
        // End:0x198
        if(IsTimerActive('StopEvade') == false)
        {
            StopEvade();
            Sleep(0.1000000);
        }
        // End:0x1B2
        if((ShouldEvade()) == false)
        {
            StopEvade();
        }
        Sleep(0.2500000);
        // [Loop Continue]
        goto J0x157;
    }
    goto 'EasyEvade';
    stop;                    
}
