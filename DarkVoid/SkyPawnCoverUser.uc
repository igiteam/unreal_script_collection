class SkyPawnCoverUser extends SkyPawn
    abstract
    native
    config(Pawn);

const MaxCoverGuessDist = 256.f;

enum ECoverState
{
    COVER_None,                     // 0
    COVER_EnterFwd,                 // 1
    COVER_EnterRev,                 // 2
    COVER_EnterUp,                  // 3
    COVER_EnterUpFromGround,        // 4
    COVER_Exit,                     // 5
    COVER_Idle,                     // 6
    COVER_SlideLeft,                // 7
    COVER_SlideRight,               // 8
    COVER_SlipLeft,                 // 9
    COVER_SlipRight,                // 10
    COVER_DiveRollLeft,             // 11
    COVER_DiveRollRight,            // 12
    COVER_SwatTurnStart,            // 13
    COVER_SwatTurnRun,              // 14
    COVER_SwatTurnShortStep,        // 15
    COVER_SwatTurnLongStep,         // 16
    COVER_SwatTurnEnd,              // 17
    COVER_MantleTakeoff,            // 18
    COVER_MantleAirborne,           // 19
    COVER_MantleLong,               // 20
    COVER_MantleLanding,            // 21
    COVER_StepUp,                   // 22
    COVER_AdeptLedgeJump,           // 23
    COVER_VerticalSwatTurn,         // 24
    COVER_Transition,               // 25
    COVER_EnterSettle,              // 26
    COVER_Dangle,                   // 27
    COVER_MAX                       // 28
};

enum ECoverMacroState
{
    COVER_MS_None,                  // 0
    COVER_MS_Entering,              // 1
    COVER_MS_Default,               // 2
    COVER_MS_Transitioning,         // 3
    COVER_MS_Exiting,               // 4
    COVER_MS_MAX                    // 5
};

enum EPositionInCover
{
    COVERPOS_Center,                // 0
    COVERPOS_LeftEdge,              // 1
    COVERPOS_RightEdge,             // 2
    COVERPOS_MAX                    // 3
};

enum ESwatTurnType
{
    SWATTURN_None,                  // 0
    SWATTURN_ShortStep,             // 1
    SWATTURN_LongStep,              // 2
    SWATTURN_Run,                   // 3
    SWATTURN_MAX                    // 4
};

enum ECoverStepOutType
{
    STEPOUT_None,                   // 0
    STEPOUT_SWAT,                   // 1
    STEPOUT_Dive,                   // 2
    STEPOUT_Slip,                   // 3
    STEPOUT_Aim,                    // 4
    STEPOUT_MAX                     // 5
};

enum ESecondaryItemCoverType
{
    ESICT_Any,                      // 0
    ESICT_Crouching,                // 1
    ESICT_Standing,                 // 2
    ESICT_MAX                       // 3
};

enum ESecondaryItemCoverOrientation
{
    ESICO_Any,                      // 0
    ESICO_Horizontal,               // 1
    ESICO_VerticalUp,               // 2
    ESICO_VerticalDown,             // 3
    ESICO_MAX                       // 4
};

enum ESecondaryItemCoverPosition
{
    ESICP_Any,                      // 0
    ESICP_Left,                     // 1
    ESICP_CenterMovingLeft,         // 2
    ESICP_CenterMovingRight,        // 3
    ESICP_Right,                    // 4
    ESICP_MAX                       // 5
};

enum ESecondaryItemCoverFacing
{
    ESICF_Any,                      // 0
    ESICF_Toward,                   // 1
    ESICF_Away,                     // 2
    ESICF_MAX                       // 3
};

struct native EntryPhysicsState
{
    var Vector MovementRate;
    var Rotator RotationRate;
    var Vector FinalLocation;
    var Rotator FinalRotation;
    var float FinalPct;
    var bool ReverseEntryApplied;

    structdefaultproperties
    {
        MovementRate=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        RotationRate=(Pitch=0,Yaw=0,Roll=0)
        FinalLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        FinalRotation=(Pitch=0,Yaw=0,Roll=0)
        FinalPct=0.0000000
        ReverseEntryApplied=false
    }
};

struct native SSecondaryItemCoverInfo
{
    var() SkyPawnCoverUser.ESecondaryItemCoverType CoverType;
    var() SkyPawnCoverUser.ESecondaryItemCoverOrientation CoverOrientation;
    var() SkyPawnCoverUser.ESecondaryItemCoverPosition CoverPosition;
    var() SkyPawnCoverUser.ESecondaryItemCoverFacing CoverFacing;

    structdefaultproperties
    {
        CoverType=ESICT_Any
        CoverOrientation=ESICO_Any
        CoverPosition=ESICP_Any
        CoverFacing=ESICF_Any
    }
};

struct native SSecondaryItemCoverTimingInfo
{
    var() array<SSecondaryItemCoverInfo> CoverInfo;
    var() SSecondaryItemTimingInfo TimingInfo;

    structdefaultproperties
    {
        CoverInfo=none
        TimingInfo=(TakingOutTime=0.0000000,ThrowingTime=0.0000000,AttachTime=0.0000000,ReleaseTime=0.0000000,ThrowingSocket="None")
    }
};

var bool bUseCoverSearchOptimization;
var globalconfig bool bCoverDebug_PlayerFOV;
var globalconfig bool bCoverDebug_CoverFOV;
var globalconfig bool bCoverDebug_CoverVolume;
var globalconfig bool bCoverDebug_FoundCover;
var globalconfig bool bCoverDebug_ValidatedCover;
var bool bLastMovedLeft;
var protected bool VerticalMantleReturnToCover;
var protected repnotify bool IsVerticalMantling;
var bool VerticalMantleStartCompleted;
var bool bWasInCover;
var() bool bAlignPawnIntoCoverHorz;
var() bool bAlignPawnOffLedgeVertUp;
var() bool bAlignPawnOffLedgeVertDown;
var transient bool bRotateToCoverShortestTurn;
var transient bool bRotateToCoverClockwise;
var transient bool bRotateToCoverInitialized;
var bool bHasSWATLoc;
var transient bool bBlockStopTargetingInput;
var transient bool bTriggerStopTargetingInputEvent;
var protected bool bCanTargetFromCover;
var protected bool bCanFireFromCover;
var protected bool bCanThrowSecondaryItemFromCover;
var protected bool bSwatTurningToLeft;
var bool bCanBlindFire;
var transient bool bMoveTowardInitatedCoverSpecialMove;
var transient bool bMoveTowardInitiatedHorizontalMantle;
var transient bool bMoveTowardInitiatedCompoundCoverMove;
var transient bool bIsPerformingInterpolatedMove;
var transient bool bJustTransitionedFromCoverEnter;
var deprecated transient bool bAligningRotationToCover;
var(Collision) bool bUseCollisionDuringVertCover;
var(Collision) bool bUseCollisionDuringHorzCover;
var bool bSteppingOut;
var() bool bCanMoveAndFireInHorzShort;
var() bool bCanMoveAndFireInHorzStand;
var() bool bCanMoveAndFireInVertDown;
var() bool bCanMoveAndFireInVertUp;
var() bool bCanPlayTakeHitPhysicsAnimationsOnFoot;
var() bool bCanPlayTakeHitPhysicsAnimationsInHorzCover;
var() bool bCanPlayTakeHitPhysicsAnimationsInVertCover;
var(Collision) bool bTakeRBCollisionDamage;
var(CoverDangle) bool bCoverDangleEnabled;
var transient bool bCoverDangleFailureIsActive;
var transient bool bCoverDangleFailureCanRecover;
var transient bool bCoverDangleFailureIsRecovering;
var(Health) bool bUseInvulnCoverAngles;
var bool bIsVaultMantle;
var bool bLeapingToGround;
var transient bool bEnteringByPlatformGrab;
var(VerticalFudge) config float VerticalSwatTurnZDeltaAmount;
var(SpecialMoves) config float Run2CoverMaxDist;
var(SpecialMoves) config float Run2CoverMaxDistFast;
var(SpecialMoves) config float Run2CoverFastDistSpeed;
var(SpecialMoves) config float Run2CoverPerpendicularMaxDist;
var(SpecialMoves) float LedgeJumpMaxDistance;
var(SpecialMoves) float LedgeJumpMaxDistance_2D;
var float LastCoverActionTime;
var float NextCoverActionTime;
var() config float HorizontalCoverMovementSpeed;
var() config float VerticalCoverMovementSpeed;
var() config float HorizontalCoverEntryMovementSpeed;
var() config float VerticalCoverUpEntryMovementSpeed;
var() config float VerticalCoverUpEntryMovementAccel;
var() config float VerticalCoverDownEntryMovementSpeed;
var() config float VerticalCoverDownEntryMovementAccel;
var transient float CurrentVerticalCoverEntryMovementSpeed;
var config float PawnAcquireCoverFOV;
var config float PawnAcquireCoverRange2D_VertUp;
var config float PawnAcquireCoverRangeZ_VertUp;
var config float PawnAcquireCoverFOVRoadieRun;
var float HorizCoverMinNavSearchRadius;
var(CoverSearch) float VertUpCoverSearchRadius;
var(CoverSearch) float ShuffleCoverSearchRadius;
var(CoverSearch) float PlatformGrapCoverSearchRadius;
var(CoverEnter) float CoverEnterMoveControlTimer;
var transient float SuppressAutoGrab;
var config float CoverAcquireFOV;
var(CoverEnter) float PlatformGrabPawnFOV;
var(CoverEnter) float PlatformGrabCameraFOV;
var config float RoadieRunCoverAcquireFOV;
var config float CoverSnapScale;
var deprecated config float NoCoverFireFOVLeftEdge;
var deprecated config float NoCoverFireFOVCenter;
var deprecated config float NoCoverFireFOVRightEdge;
var(CoverAim) config float NoCoverFireFOVLeftEdgeMin;
var(CoverAim) config float NoCoverFireFOVLeftEdgeMax;
var(CoverAim) config float NoCoverFireFOVCenterMin;
var(CoverAim) config float NoCoverFireFOVCenterMax;
var(CoverAim) config float NoCoverFireFOVRightEdgeMin;
var(CoverAim) config float NoCoverFireFOVRightEdgeMax;
var(CoverAim) config float NoCoverSecondaryItemFOVLeftEdgeMin;
var(CoverAim) config float NoCoverSecondaryItemFOVLeftEdgeMax;
var(CoverAim) config float NoCoverSecondaryItemFOVCenterMin;
var(CoverAim) config float NoCoverSecondaryItemFOVCenterMax;
var(CoverAim) config float NoCoverSecondaryItemFOVRightEdgeMin;
var(CoverAim) config float NoCoverSecondaryItemFOVRightEdgeMax;
var config float VerticalMantleUpToCoverInputTime;
var config float VerticalMantleDownToCoverInputTime;
var(CoverExit) float TriggerCoverExitInputAngle;
var(CoverExit) float TriggerCoverExitInputDuration;
var(CoverExit) float TriggerVertUpCoverExitInputAngle;
var(CoverExit) float TriggerVertUpCoverExitInputDuration;
var(CoverExit) float TriggerVertDownCoverExitInputAngle;
var(CoverExit) float TriggerVertDownCoverExitInputDuration;
var protected transient float CoverExitTimer;
var CoverLink CurrentLink;
var int CurrentSlotIdx;
var CoverLink PreviousLink;
var int PreviousSlotIdx;
var int LeftSlotIdx;
var int RightSlotIdx;
var float CurrentSlotPct;
var Vector CoverNormal;
var float CoverEnterAngle;
var float CoverEnterDistance;
var CovPosInfo AdeptLedgeJumpTarget;
var config float PlatformGrabDistance;
var config float PlatformGrabSearchDistance;
var config float LedgeLeapDistance;
var transient float RotateToCoverTime;
var transient float RotateToCoverStartTime;
var transient EntryPhysicsState EntryPhysics;
var Vector NextSWATLoc;
var Vector NextSWATRate;
var() float SWATOffset;
var() Vector VertUpPawnOffset;
var() float VerticalDownTakeCoverDistance;
var private SkyPawnCoverUser.ECoverState CoverState;
var private SkyPawnCoverUser.ECoverMacroState CoverMacroState;
var private SkyPawnCoverUser.EPositionInCover PositionInCover;
var protected SkyPawnCoverUser.ESwatTurnType SwatTurnType;
var CoverLink.ECoverAction CoverAction;
var transient CoverLink.ECoverDirection ReplicatedCoverDirection;
var repnotify transient SkyPawnCoverUser.ECoverState RepExitCoverState;
var SkyPawnCoverUser.ECoverStepOutType StepoutType;
var CoverLink.ECoverDirection StepoutDirection;
var float MantleLandingAnimLength;
var float MantleAirborneTimeout;
var protected transient float MantleAirborneTimer;
var config float SwatTurnShortDist;
var config float SwatTurnLongDist;
var transient float fPathingSlideAmount;
var transient float CanClaimCoverTimeLockout;
var float FreshCoverDirectionTime;
var repnotify transient CovPosInfo RepCoverToCoverInfo;
var repnotify transient CovPosInfo RepCovInfo;
var repnotify transient int RepSlot;
var repnotify transient CoverReference RepSwatInfo;
var transient CoverLink PreviousCoverLink;
var transient int TransitionSlotIdx;
var native map{VOID,VOID} CoverIKControls;
var config float NearEdgeDistance;
var(Collision) float StepUpCheckInCover;
var(Collision) float StepDownCheckInCover;
var(Collision) float RBCollisionDamageScale;
var(Collision) float RBCollisionMinimumDamageSpeed;
var(Collision) float RBCollisionDamagePeriod;
var transient float RBCollisionTimeSinceDamage;
var(CoverDangle) float CoverDangleInitialMeterValue;
var(CoverDangle) float CoverDangleDecayRate;
var(CoverDangle) float CoverDanglePlayerMitigation;
var transient float CoverDangleMeter;
var const float CoverDangleEmptyMeter;
var const float CoverDangleFullMeter;
var transient float CoverDangleFailureElapsedTime;
var transient float CoverDangleFailureTimeSinceDamage;
var transient Vector JetPackBoneRecoveryInitialWorldPosition;
var transient Quat JetPackBoneRecoveryInitialWorldQuaternion;
var transient float CoverDangleFailureOnGroundElapsedTime;
var(CoverDangle) float CoverDangleFailureFallTime;
var(CoverDangle) float CoverDangleFailureRecoverySpeed;
var(CoverDangle) float CoverDangleFailureDamageScale;
var(CoverDangle) float CoverDangleFailureDamagePeriod;
var(CoverDangle) float CoverDangleFailureMinimumDamageSpeed;
var(CoverDangle) float CoverDangleFailureOnGroundTime;
var transient array<SkySeqAct_Dangle> ActiveKismetDangleActions;
var(CoverDangle) float CoverDestroyFailureFallTime;
var(CoverDangle) float CoverDestroyFailureRecoverySpeed;
var(CoverDangle) float CoverDestroyFailureDamageScale;
var(CoverDangle) float CoverDestroyFailureDamagePeriod;
var(CoverDangle) float CoverDestroyFailureMinimumDamageSpeed;
var(CoverDangle) float CoverDestroyFailureOnGroundTime;
var(Health) float InvulnMidLevelHorzAngle;
var(Health) float InvulnMidLevelVertAngle;
var(Health) float InvulnStandingHorzAngle;
var(Health) float InvulnVertUpHorzAngle;
var(Health) float InvulnVertUpVertAngle;
var(Health) float InvulnVertDownHorzAngle;
var(Health) float InvulnVertDownVertAngle;
var float InvulnMidLevelHorzAngleDot;
var float InvulnMidLevelVertAngleDot;
var float InvulnStandingHorzAngleDot;
var float InvulnVertUpHorzAngleDot;
var float InvulnVertUpVertAngleDot;
var float InvulnVertDownHorzAngleDot;
var float InvulnVertDownVertAngleDot;
var transient float InCoverDuration;
var transient float OutOfCoverDuration;
var(Sounds) SoundCue FailDangleSound;
var(Weapon) name VertDownWeaponDropSocket;
var(HitReactions) protected array<StumbleSet> StandingCoverStumbles;
var(HitReactions) protected array<StumbleSet> CrouchingCoverStumbles;
var(HitReactions) protected array<StumbleSet> VertUpCoverStumbles;
var(HitReactions) protected array<StumbleSet> VertDownCoverStumbles;
var(SecondaryItem) array<SSecondaryItemCoverTimingInfo> SecondaryItemCoverTimingInfo;
var transient string LedgeJumpKeyString;
var transient CoverSlotMarker LastUsedCoverMarker;

replication
{
    // Pos:0x000
    if((int(Role) == int(ROLE_Authority)) && !bNetOwner
        CurrentSlotPct, IsVerticalMantling, 
        LeftSlotIdx, PositionInCover, 
        RepCovInfo, RepCoverToCoverInfo, 
        RepExitCoverState, RepSlot, 
        RepSwatInfo, RightSlotIdx, 
        bLastMovedLeft;
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x2A
    if(VarName == 'IsVerticalMantling')
    {
        // End:0x27
        if(IsVerticalMantling)
        {
            StartVerticalMantle(false);
        }        
    }
    else
    {
        // End:0x67
        if(VarName == 'RepExitCoverState')
        {
            // End:0x64
            if(int(RepExitCoverState) != int(GetCoverState()))
            {
                SetCoverState(RepExitCoverState);
            }            
        }
        else
        {
            // End:0xA2
            if(VarName == 'RepCoverToCoverInfo')
            {
                // End:0x9F
                if(RepCoverToCoverInfo.Link != none)
                {
                    CoverToCover(RepCoverToCoverInfo);
                }                
            }
            else
            {
                // End:0x12F
                if(VarName == 'RepCovInfo')
                {
                    // End:0x12C
                    if(RepCovInfo.Link != none)
                    {
                        // End:0x11C
                        if(int(GetCoverState()) != int(0))
                        {
                            // End:0x102
                            if(CurrentLink != none)
                            {
                                CurrentLink.UnClaim(self, CurrentSlotIdx, true);
                            }
                            ClaimCoverPhysically(RepCovInfo);
                            SetCoverState(6);                            
                        }
                        else
                        {
                            PerformAcquireCover(RepCovInfo);
                        }
                    }                    
                }
                else
                {
                    // End:0x165
                    if(VarName == 'RepSwatInfo')
                    {
                        // End:0x162
                        if(int(GetCoverState()) != int(0))
                        {
                            PerformSwatTurn(RepSwatInfo);
                        }                        
                    }
                    else
                    {
                        // End:0x199
                        if(VarName == 'RepSlot')
                        {
                            // End:0x196
                            if(CurrentSlotIdx != RepSlot)
                            {
                                ReachedCoverSlot(RepSlot);
                            }                            
                        }
                        else
                        {
                            super.ReplicatedEvent(VarName);
                        }
                    }
                }
            }
        }
    }
    //return;    
}

// Export USkyPawnCoverUser::execCanEnterVerticalCover(FFrame&, void* const)
native function bool CanEnterVerticalCover(Vector ReticleHitLocation, Vector ReticleHitNormal, out CovPosInfo CoverInfo);

// Export USkyPawnCoverUser::execMyRotateToward(FFrame&, void* const)
native function MyRotateToward(Vector FocalPoint);

// Export USkyPawnCoverUser::execGuessAtCover(FFrame&, void* const)
native final function bool GuessAtCover(out CoverInfo out_Cover);

// Export USkyPawnCoverUser::execGetCoverState(FFrame&, void* const)
native function SkyPawnCoverUser.ECoverState GetCoverState();

// Export USkyPawnCoverUser::execGetCoverMacroState(FFrame&, void* const)
native function SkyPawnCoverUser.ECoverMacroState GetCoverMacroState();

// Export USkyPawnCoverUser::execSetCoverState(FFrame&, void* const)
protected native function SetCoverState(SkyPawnCoverUser.ECoverState NewState);

// Export USkyPawnCoverUser::execUpdateCoverMacroState(FFrame&, void* const)
protected native function UpdateCoverMacroState();

// Export USkyPawnCoverUser::execMoveToCurrentCoverPosition(FFrame&, void* const)
native function MoveToCurrentCoverPosition(optional bool bDontAlignLocation, optional bool bDontAlignRotation);

// Export USkyPawnCoverUser::execGetCurrentSlotLocation(FFrame&, void* const)
native function Vector GetCurrentSlotLocation();

simulated function PostBeginPlay()
{
    InvulnMidLevelHorzAngleDot = Cos(InvulnMidLevelHorzAngle * 0.0174533);
    InvulnMidLevelVertAngleDot = Cos(InvulnMidLevelVertAngle * 0.0174533);
    InvulnStandingHorzAngleDot = Cos(InvulnStandingHorzAngle * 0.0174533);
    InvulnVertUpHorzAngleDot = Cos(InvulnVertUpHorzAngle * 0.0174533);
    InvulnVertUpVertAngleDot = Cos(InvulnVertUpVertAngle * 0.0174533);
    InvulnVertDownHorzAngleDot = Cos(InvulnVertDownHorzAngle * 0.0174533);
    InvulnVertDownVertAngleDot = Cos(InvulnVertDownVertAngle * 0.0174533);
    ResetTempPathingFlags();
    CanClaimCoverTimeLockout = 0.0000000;
    super.PostBeginPlay();
    //return;    
}

final function ResetTempPathingFlags()
{
    bMoveTowardInitatedCoverSpecialMove = false;
    bMoveTowardInitiatedHorizontalMantle = false;
    bMoveTowardInitiatedCompoundCoverMove = false;
    fPathingSlideAmount = 0.0000000;
    //return;    
}

// Export USkyPawnCoverUser::execCanPlayTakeHitPhysicsAnimation(FFrame&, void* const)
native simulated function bool CanPlayTakeHitPhysicsAnimation();

function StopEnterCoverRumble()
{
    local SkyPlayerController pController;

    pController = SkyPlayerController(Controller);
    // End:0x41
    if((pController != none) && EnterCoverFFeedback != none)
    {
        pController.StopRumble(EnterCoverFFeedback);
    }
    //return;    
}

reliable server event ServerCoverToCoverTransition(CovPosInfo newcover, bool Mantle)
{
    // End:0x7A
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x60
        if(Mantle)
        {
            // End:0x3B
            if(CurrentLink != none)
            {
                CurrentLink.UnClaim(self, CurrentSlotIdx, true);
            }
            RepCovInfo = newcover;
            ClaimCoverPhysically(newcover);
            SetCoverState(6);            
        }
        else
        {
            RepCoverToCoverInfo = newcover;
            CoverToCover(newcover);
        }
    }
    //return;    
}

simulated function CoverToCover(CovPosInfo newcover)
{
    // End:0x22
    if(CurrentLink != none)
    {
        CurrentLink.UnClaim(self, CurrentSlotIdx, true);
    }
    // End:0x43
    if(newcover.Link != none)
    {
        ClaimCoverPhysically(newcover);
    }
    SetCoverState(23);
    // End:0x79
    if(int(GetCoverOrientation()) == int(1))
    {
        PrimaryWSM.TryHolster();
    }
    //return;    
}

// Export USkyPawnCoverUser::execGetPositionInCover(FFrame&, void* const)
native function SkyPawnCoverUser.EPositionInCover GetPositionInCover();

// Export USkyPawnCoverUser::execSetPositionInCover(FFrame&, void* const)
protected native function SetPositionInCover(SkyPawnCoverUser.EPositionInCover NewPosInCover);

// Export USkyPawnCoverUser::execGetCoverOrientation(FFrame&, void* const)
native function CoverLink.ECoverOrientation GetCoverOrientation();

// Export USkyPawnCoverUser::execGetCoverFacing(FFrame&, void* const)
native function CoverLink.ECoverFacing GetCoverFacing(float RightDegreeLimit, float LeftDegreeLimit, optional bool bUseControllerRot);

// Export USkyPawnCoverUser::execGetCoverPositionAnim(FFrame&, void* const)
native function SkyPawnCoverUser.EPositionInCover GetCoverPositionAnim(bool bIgnoreCenter);

// Export USkyPawnCoverUser::execGetCoverMovement(FFrame&, void* const)
native function CoverLink.ECoverDirection GetCoverMovement();

// Export USkyPawnCoverUser::execExitCover(FFrame&, void* const)
native function ExitCover(optional bool bSkipManeuvers, optional bool bSkipStepOut);

// Export USkyPawnCoverUser::execCanSlip(FFrame&, void* const)
native function bool CanSlip();

// Export USkyPawnCoverUser::execCanDiveRoll(FFrame&, void* const)
native function bool CanDiveRoll();

// Export USkyPawnCoverUser::execCanMantle(FFrame&, void* const)
native function bool CanMantle();

// Export USkyPawnCoverUser::execCanPopup(FFrame&, void* const)
native function bool CanPopup();

// Export USkyPawnCoverUser::execCanDraw(FFrame&, void* const)
native function bool CanDraw();

// Export USkyPawnCoverUser::execCanStepUp(FFrame&, void* const)
native function bool CanStepUp();

// Export USkyPawnCoverUser::execIsDoingVaultMantle(FFrame&, void* const)
native function bool IsDoingVaultMantle();

// Export USkyPawnCoverUser::execCanSlide(FFrame&, void* const)
native function bool CanSlide();

// Export USkyPawnCoverUser::execCanSlideFurtherLeft(FFrame&, void* const)
native function bool CanSlideFurtherLeft();

// Export USkyPawnCoverUser::execCanSlideFurtherRight(FFrame&, void* const)
native function bool CanSlideFurtherRight();

// Export USkyPawnCoverUser::execCheckYawLimits(FFrame&, void* const)
native function bool CheckYawLimits(Vector refVect, Vector facingVect, float leftLimit, float rightLimit);

// Export USkyPawnCoverUser::execGetCoverNormal(FFrame&, void* const)
native final function Vector GetCoverNormal();

// Export USkyPawnCoverUser::execGetInterpCoverNormalRot(FFrame&, void* const)
native final function Rotator GetInterpCoverNormalRot();

// Export USkyPawnCoverUser::execGetAdjustedCoverNormal(FFrame&, void* const)
native final function Vector GetAdjustedCoverNormal(CovPosInfo CovInfo);

// Export USkyPawnCoverUser::execGetCoverSurfaceNormal(FFrame&, void* const)
native final function Vector GetCoverSurfaceNormal();

// Export USkyPawnCoverUser::execStartVerticalMantle(FFrame&, void* const)
native function StartVerticalMantle(bool ReturnToCover);

// Export USkyPawnCoverUser::execHasStartedVerticalMantle(FFrame&, void* const)
native function bool HasStartedVerticalMantle();

// Export USkyPawnCoverUser::execWillVerticalMantleReturnToCover(FFrame&, void* const)
native function bool WillVerticalMantleReturnToCover();

// Export USkyPawnCoverUser::execCanPerformAdeptLedgeJump(FFrame&, void* const)
native function bool CanPerformAdeptLedgeJump();

// Export USkyPawnCoverUser::execUpdateAdeptLedgeJumpTarget(FFrame&, void* const)
native function bool UpdateAdeptLedgeJumpTarget();

// Export USkyPawnCoverUser::execStartAdeptLedgeJump(FFrame&, void* const)
native function StartAdeptLedgeJump();

// Export USkyPawnCoverUser::execTransitionToNextCoverSlot(FFrame&, void* const)
native function TransitionToNextCoverSlot(float TransitionTime);

// Export USkyPawnCoverUser::execBeginTransitionToSlot(FFrame&, void* const)
native function BeginTransitionToSlot(int NewSlotIdx);

// Export USkyPawnCoverUser::execCheckFiringAnglesForTarget(FFrame&, void* const)
native function bool CheckFiringAnglesForTarget(Vector theirLocation);

// Export USkyPawnCoverUser::execCanFireFromCover(FFrame&, void* const)
native function bool CanFireFromCover();

// Export USkyPawnCoverUser::execCanTargetFromCover(FFrame&, void* const)
native function bool CanTargetFromCover();

// Export USkyPawnCoverUser::execCanPrimaryWeaponFire(FFrame&, void* const)
native function bool CanPrimaryWeaponFire(optional bool bIgnoreReload, optional bool bCheckingForTargeting);

function bool CanReloadWeapon()
{
    // End:0x5C
    if((((int(GetCoverState()) != int(0)) && int(GetCoverState()) != int(7)) && int(GetCoverState()) != int(8)) && int(GetCoverState()) != int(6))
    {
        return false;
    }
    // End:0x7C
    if((IsShuffling()) && !CanPopup())
    {
        return false;
    }
    return super.CanReloadWeapon();
    //return ReturnValue;    
}

event bool CanSecondaryItemFire()
{
    local SkyPawnCoverUser.ECoverState pCoverState;
    local SkyPawnCoverUser.ECoverMacroState pCoverMacroState;

    pCoverMacroState = GetCoverMacroState();
    pCoverState = GetCoverState();
    // End:0x44
    if((int(pCoverMacroState) == int(1)) || int(pCoverMacroState) == int(4))
    {
        return false;
    }
    // End:0x63
    if((int(pCoverState) != int(0)) && !bCanThrowSecondaryItemFromCover)
    {
        return false;
    }
    // End:0x84
    if((GripDangleIsActive()) || int(pCoverState) == int(27))
    {
        return false;
    }
    return super.CanSecondaryItemFire();
    //return ReturnValue;    
}

function bool CanPerformTargeting()
{
    local float leftLimit, rightLimit;
    local Vector viewloc;
    local Rotator ViewRot;
    local SkySecondaryItem Item;
    local CoverSlot Slot;

    // End:0x0D
    if(Weapon == none)
    {
        return false;
    }
    // End:0x35
    if((int(GetCoverState()) != int(0)) && !CanTargetFromCover())
    {
        return false;
    }
    // End:0x118
    if((int(GetCoverState()) == int(8)) || int(GetCoverState()) == int(7))
    {
        Slot = CurrentLink.Slots[CurrentSlotIdx];
        // End:0x118
        if(((((int(Slot.CoverType) == int(1)) && !bCanMoveAndFireInHorzStand) || (int(Slot.CoverType) == int(2)) && !bCanMoveAndFireInHorzShort) || (int(GetCoverOrientation()) == int(2)) && !bCanMoveAndFireInVertDown) || (int(GetCoverOrientation()) == int(1)) && !bCanMoveAndFireInVertUp)
        {
            return false;
        }
    }
    // End:0x1FD
    if(IsInVerticleCover())
    {
        // End:0x153
        if(int(GetCoverOrientation()) == int(2))
        {
            leftLimit = ShootableAngleVertDownLeft;
            rightLimit = ShootableAngleVertDownRight;            
        }
        else
        {
            leftLimit = ShootableAngleVertUpLeft;
            rightLimit = ShootableAngleVertUpRight;
            // End:0x1A9
            if((IsCurrentCoverHangingShuffle()) || ((IsCurrentCoverStandingShuffle()) && !CanMantle()) && !CanPopup())
            {
                return false;
            }
        }
        Controller.GetPlayerViewPoint(viewloc, ViewRot);
        // End:0x1FA
        if(!CheckYawLimits(Vector(CurrentLink.Rotation), Vector(ViewRot), leftLimit, rightLimit))
        {
            return false;
        }        
    }
    else
    {
        // End:0x262
        if(int(GetCoverType()) == int(2))
        {
            Item = SkySecondaryItem(SecondaryWeapon);
            // End:0x262
            if(((Item != none) && int(Item.Using) == int(2)) && !PrimaryWSM.IsTargeting())
            {
                return false;
            }
        }
    }
    // End:0x2AF
    if(((IsInVerticleCover()) && int(GetCoverOrientation()) == int(1)) && int(GetCoverType()) == int(1))
    {
        return !Weapon.bAllowZoom;        
    }
    else
    {
        return super.CanPerformTargeting();
    }
    //return ReturnValue;    
}

simulated event DrawAdeptLedgeJumpHUD(HUD H, Actor ledgejumptarget, optional Vector WorldPos)
{
    local float iconScale;
    local name Modifier;
    local int ColorParam;
    local Surface Icon;
    local MaterialInstanceConstant mic;

    // End:0x26
    if((bGoingIntervehicular || IsHijacking()) || bGoingIntervehicular)
    {
        return;
    }
    iconScale = 0.6000000;
    // End:0x279
    if(SkyHUD(H) != none)
    {
        // End:0x279
        if(!SkyHUD(H).bDrawingMelee)
        {
            // End:0x82
            if(ledgejumptarget != none)
            {
                WorldPos = ledgejumptarget.GetTargetLocation(none);
            }
            Icon = SkyHUD(H).GetInputButtonForCommand("TryAdeptLedgeJump", Modifier, ColorParam);
            // End:0x218
            if(Icon != none)
            {
                // End:0x1E8
                if(MaterialInterface(Icon) != none)
                {
                    // End:0x13F
                    if(((Modifier != 'None') && PlayerController(Controller).PlayerInput != none) && PlayerController(Controller).PlayerInput.PressedKeys.Find(Modifier) < 0)
                    {
                        ColorParam = 0;
                    }
                    // End:0x169
                    if(Icon == SkyHUD(H).GetCurrentInteractButtonImage())
                    {
                        ColorParam = 0;
                    }
                    mic = new (Outer) Class'Engine.MaterialInstanceConstant';
                    mic.SetParent(MaterialInterface(Icon));
                    // End:0x1DD
                    if(ColorParam == 0)
                    {
                        mic.SetVectorParameterValue('DrawColor', SkyHUD(H).UIColors[ColorParam]);
                    }
                    Icon = mic;
                }
                SkyHUD(H).DrawIconAtLocation(WorldPos, Icon, "", iconScale, true);                
            }
            else
            {
                // End:0x24D
                if(LedgeJumpKeyString == "")
                {
                    LedgeJumpKeyString = SkyHUD(H).GetKeyboardStringForCommand('TryAdeptLedgeJump');
                }
                SkyHUD(H).DrawIconAtLocation(WorldPos, none, LedgeJumpKeyString, iconScale, true);
            }
        }
    }
    //return;    
}

// Export USkyPawnCoverUser::execGetCoverType(FFrame&, void* const)
native final function CoverLink.ECoverType GetCoverType();

// Export USkyPawnCoverUser::execGetPreviousCoverType(FFrame&, void* const)
native final function CoverLink.ECoverType GetPreviousCoverType();

// Export USkyPawnCoverUser::execGetPendingMantleType(FFrame&, void* const)
native final function CoverLink.ECoverType GetPendingMantleType();

// Export USkyPawnCoverUser::execIsPendingMantleHanging(FFrame&, void* const)
native final function bool IsPendingMantleHanging();

// Export USkyPawnCoverUser::execIsOnLeftSideOfCover(FFrame&, void* const)
native final function bool IsOnLeftSideOfCover();

// Export USkyPawnCoverUser::execGetSwatTurnType(FFrame&, void* const)
native function SkyPawnCoverUser.ESwatTurnType GetSwatTurnType();

// Export USkyPawnCoverUser::execIsSwatTurningToLeft(FFrame&, void* const)
native function bool IsSwatTurningToLeft();

// Export USkyPawnCoverUser::execGetPendingCoverType(FFrame&, void* const)
native final function CoverLink.ECoverType GetPendingCoverType();

// Export USkyPawnCoverUser::execIsPendingCoverHanging(FFrame&, void* const)
native final function bool IsPendingCoverHanging();

// Export USkyPawnCoverUser::execIsCurrentCoverShuffle(FFrame&, void* const)
native function bool IsCurrentCoverShuffle();

// Export USkyPawnCoverUser::execIsCurrentCoverHangingShuffle(FFrame&, void* const)
native function bool IsCurrentCoverHangingShuffle();

// Export USkyPawnCoverUser::execIsCurrentCoverStandingShuffle(FFrame&, void* const)
native function bool IsCurrentCoverStandingShuffle();

// Export USkyPawnCoverUser::execMoveToCover(FFrame&, void* const)
native function MoveToCover(float Time);

// Export USkyPawnCoverUser::execRotateToCover(FFrame&, void* const)
native function RotateToCover(float Time, bool bShortestTurn, optional bool bClockwise, optional bool bReadjusting);

// Export USkyPawnCoverUser::execIsInCover(FFrame&, void* const)
native function bool IsInCover();

// Export USkyPawnCoverUser::execIsShuffling(FFrame&, void* const)
native function bool IsShuffling();

// Export USkyPawnCoverUser::execIsUsingCoverCamera(FFrame&, void* const)
native function bool IsUsingCoverCamera();

// Export USkyPawnCoverUser::execIsMantling(FFrame&, void* const)
native function bool IsMantling();

// Export USkyPawnCoverUser::execIsSteppingUp(FFrame&, void* const)
native function bool IsSteppingUp();

// Export USkyPawnCoverUser::execIsSwatTurning(FFrame&, void* const)
native function bool IsSwatTurning();

// Export USkyPawnCoverUser::execFindCoverForPlayer(FFrame&, void* const)
native final simulated function bool FindCoverForPlayer(Vector FromLoc, Vector Direction, float FOV, float MaxDistance, out CovPosInfo OutCovPosInfo, optional bool VertDownOnly);

// Export USkyPawnCoverUser::execFindCoverHorizontal(FFrame&, void* const)
native final simulated function bool FindCoverHorizontal(Vector FromLoc, Vector Direction, float FOV, float MaxDistance, out CovPosInfo OutCovPosInfo);

// Export USkyPawnCoverUser::execFindCoverVerticalDown(FFrame&, void* const)
native final simulated function bool FindCoverVerticalDown(Vector PlayerLoc, Vector Direction, float FOV, out CovPosInfo OutCovPosInfo, optional bool bSearchingForAdeptJump);

// Export USkyPawnCoverUser::execFindCoverVerticalUp(FFrame&, void* const)
native final simulated function bool FindCoverVerticalUp(Vector FromLoc, out CovPosInfo OutCovPosInfo, optional bool bSearchingForAdeptJump);

// Export USkyPawnCoverUser::execFindCoverShuffle(FFrame&, void* const)
native final simulated function bool FindCoverShuffle(Vector FromLoc, Vector Direction, out CovPosInfo OutCovPosInfo, optional bool bSearchForLedgeJump);

// Export USkyPawnCoverUser::execFindCoverPlatformGrab(FFrame&, void* const)
native final simulated function bool FindCoverPlatformGrab(Vector FromLoc, Vector Direction, out CovPosInfo OutCovPosInfo);

// Export USkyPawnCoverUser::execFillCoverPosInfo(FFrame&, void* const)
native final simulated function FillCoverPosInfo(CoverLink Link, int SlotIdx, Vector FromLoc, Vector Direction, float MaxDistance, out CovPosInfo out_CovPosInfo);

// Export USkyPawnCoverUser::execFillCoverPosInfoVertical(FFrame&, void* const)
native final simulated function FillCoverPosInfoVertical(CoverLink Link, int SlotIdx, Vector FromLoc, Vector Direction, float MaxDistance, out CovPosInfo out_CovPosInfo);

// Export USkyPawnCoverUser::execValidatePotentialCover(FFrame&, void* const)
native final simulated function bool ValidatePotentialCover(Vector FromLoc, Vector Direction, out float OutMinDotFOV, out float OutMaxDistanceSquared, out CovPosInfo OutCovPosInfo);

// Export USkyPawnCoverUser::execValidatePotentialCoverVertical(FFrame&, void* const)
native final simulated function bool ValidatePotentialCoverVertical(Vector FromLoc, Vector Direction, out float OutMinDotFOV, out float OutMaxDistanceSquared, out CovPosInfo OutCovPosInfo, optional bool SearchingForAdeptJump);

// Export USkyPawnCoverUser::execValidatePotentialCoverShuffle(FFrame&, void* const)
native final simulated function bool ValidatePotentialCoverShuffle(Vector FromLoc, Vector Direction, out float OutMinDotFOV, out float OutMaxDistanceSquared, out CovPosInfo OutCovPosInfo, optional bool bSearchForLedgeJump);

// Export USkyPawnCoverUser::execValidatePotentialCoverPlatformGrab(FFrame&, void* const)
native final simulated function bool ValidatePotentialCoverPlatformGrab(Vector FromLoc, Vector Direction, out float OutMaxDistanceSquared, out CovPosInfo OutCovPosInfo, bool bVertUp);

// Export USkyPawnCoverUser::execCheckForPlatformGrab(FFrame&, void* const)
native final simulated function CheckForPlatformGrab();

// Export USkyPawnCoverUser::execGetVerticalMantleTarget(FFrame&, void* const)
native final simulated function bool GetVerticalMantleTarget(out CovPosInfo OutCovPosInfo, bool bDestVertUp);

simulated event ReachedCoverSlot(int SlotIdx)
{
    local int OldSlotIdx, PendingSlotIdx;

    OldSlotIdx = CurrentSlotIdx;
    CurrentSlotIdx = SlotIdx;
    // End:0x31
    if(int(Role) == int(ROLE_Authority))
    {
        RepSlot = CurrentSlotIdx;
    }
    // End:0x75
    if((OldSlotIdx >= 0) && CurrentLink != none)
    {
        // End:0x75
        if(!CurrentLink.bClaimAllSlots)
        {
            CurrentLink.UnClaim(self, OldSlotIdx, false);
        }
    }
    PendingSlotIdx = SlotIdx;
    // End:0xBF
    if((CurrentSlotPct < 0.5000000) && CurrentLink.Slots.Length > (SlotIdx + 1))
    {
        PendingSlotIdx = SlotIdx + 1;        
    }
    else
    {
        // End:0xE9
        if((CurrentSlotPct >= 0.5000000) && SlotIdx > 0)
        {
            PendingSlotIdx = SlotIdx - 1;
        }
    }
    // End:0x17F
    if(((PendingSlotIdx != SlotIdx) && int(CurrentLink.Slots[SlotIdx].CoverType) != int(CurrentLink.Slots[PendingSlotIdx].CoverType)) && int(CurrentLink.Slots[SlotIdx].CoverOrientation) == int(1))
    {
        BeginTransitionToSlot(PendingSlotIdx);
    }
    CurrentLink.Claim(self, CurrentSlotIdx);
    SetAnchor(CurrentLink.Slots[CurrentSlotIdx].SlotMarker);
    // End:0x1E7
    if(CurrentLink.IsLeftEdgeSlot(CurrentSlotIdx, false))
    {
        SetPositionInCover(1);        
    }
    else
    {
        // End:0x20F
        if(CurrentLink.IsRightEdgeSlot(CurrentSlotIdx, false))
        {
            SetPositionInCover(2);            
        }
        else
        {
            SetPositionInCover(0);
        }
    }
    PerformStepoutAction();
    //return;    
}

final simulated function bool CanPrepareRun2Cover(float CheckDist, out CovPosInfo OutFoundCovInfo, optional Vector CheckDir, optional float AcquireCoverFOV, optional bool VertDownOnly)
{
    local bool bFoundCover;
    local float Run2CoverDist;

    // End:0x20
    if(GroundSpeed < Run2CoverFastDistSpeed)
    {
        Run2CoverDist = Run2CoverMaxDist;        
    }
    else
    {
        Run2CoverDist = Run2CoverMaxDistFast;
    }
    CheckDist = FClamp(CheckDist, 0.0000000, Run2CoverDist);
    // End:0x5C
    if(AcquireCoverFOV == 0.0000000)
    {
        AcquireCoverFOV = PawnAcquireCoverFOV;
    }
    // End:0x95
    if(!IsZero(CheckDir))
    {
        bFoundCover = FindCoverForPlayer(Location, CheckDir, AcquireCoverFOV, CheckDist, OutFoundCovInfo, VertDownOnly);
    }
    // End:0xCE
    if(!bFoundCover)
    {
        bFoundCover = FindCoverForPlayer(Location, Vector(Rotation), AcquireCoverFOV, CheckDist, OutFoundCovInfo, VertDownOnly);
    }
    return bFoundCover;
    //return ReturnValue;    
}

// Export USkyPawnCoverUser::execClaimCoverPhysically(FFrame&, void* const)
protected native final function ClaimCoverPhysically(CovPosInfo CovInfo);

// Export USkyPawnCoverUser::execCannotUseVerticalUp(FFrame&, void* const)
native final function bool CannotUseVerticalUp();

simulated event bool CanEnterCover()
{
    // End:0x2C
    if((SkyWeaponBase(Weapon) != none) && SkyWeaponBase(Weapon).bIsLargeWeapon)
    {
        return false;
    }
    // End:0x3B
    if(UsingSecondaryItem())
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

simulated event PerformAcquireCover(CovPosInfo CovInfo, optional bool bPlatformGrab)
{
    local Vector LeftToRight, XAxis, YAxis, ZAxis;
    local Rotator SlotRot;
    local SkyPlayerController SPC;

    // End:0x34
    if(CanClaimCoverTimeLockout > float(0))
    {
        // End:0x29
        if(WorldInfo.TimeSeconds < CanClaimCoverTimeLockout)
        {
            return;
        }
        CanClaimCoverTimeLockout = 0.0000000;
    }
    // End:0x4EB
    if(int(GetCoverState()) == int(0))
    {
        // End:0x5A
        if(!CanEnterCover())
        {
            return;
        }
        bLeapingToGround = false;
        CurrentVerticalCoverEntryMovementSpeed = 0.0000000;
        bEnteringByPlatformGrab = bPlatformGrab;
        ClaimCoverPhysically(CovInfo);
        // End:0x9C
        if(IsRocketPacking())
        {
            StopRocketPack();
        }
        // End:0xF0
        if(IsSprinting())
        {
            SPC = SkyPlayerController(Controller);
            // End:0xE6
            if(SPC != none)
            {
                SPC.SetSprint(0, ((bSprintingMode2) ? 1 : 0));
            }
            StopSprint();
        }
        // End:0x10F
        if(RocketPack != none)
        {
            RocketPack.OnLand();
        }
        // End:0x16D
        if((int(GetCoverOrientation()) == int(2)) || (int(GetCoverOrientation()) == int(0)) && (Vector(Rotation) Dot CovInfo.Normal) < float(0))
        {
            SetCoverState(1);            
        }
        else
        {
            // End:0x1C5
            if(int(GetCoverOrientation()) == int(1))
            {
                // End:0x1A1
                if(int(Physics) == int(1))
                {
                    SetCoverState(4);                    
                }
                else
                {
                    SetCoverState(3);
                }
                PrimaryWSM.TryHolster();                
            }
            else
            {
                SetCoverState(2);
            }
        }
        EntryPhysics.FinalPct = CovInfo.LtToRtPct;
        EntryPhysics.FinalLocation = CovInfo.Location;
        UpdateSlotLocByCoverOrientation(EntryPhysics.FinalLocation);
        EntryPhysics.ReverseEntryApplied = false;
        // End:0x2BE
        if(int(CovInfo.Link.CoverOrientation) == int(0))
        {
            // End:0x296
            if(!bAlignPawnIntoCoverHorz)
            {
                EntryPhysics.FinalRotation = Rotator(CovInfo.Normal);                
            }
            else
            {
                EntryPhysics.FinalRotation = Rotator(-CovInfo.Normal);
            }            
        }
        else
        {
            // End:0x3CA
            if((CovInfo.LtSlotIdx != CovInfo.RtSlotIdx) && int(CovInfo.Link.Slots[CovInfo.LtSlotIdx].CoverType) == int(CovInfo.Link.Slots[CovInfo.RtSlotIdx].CoverType))
            {
                LeftToRight = CovInfo.Link.GetSlotLocation(CovInfo.RtSlotIdx) - CovInfo.Link.GetSlotLocation(CovInfo.LtSlotIdx);
                LeftToRight = Normal(LeftToRight);                
            }
            else
            {
                SlotRot = CovInfo.Link.GetSlotRotation(CovInfo.RtSlotIdx);
                GetAxes(SlotRot, XAxis, YAxis, ZAxis);
                LeftToRight = Normal(YAxis);
            }
            EntryPhysics.FinalRotation = Rotator(LeftToRight Cross CovInfo.Normal);
        }
        CoverEnterDistance = VSize(Location - CovInfo.Location);
        CoverEnterAngle = Acos((CoverNormal Dot (Location - CovInfo.Location)) / CoverEnterDistance) * (360.0000000 / (3.1415930 * 2.0000000));
        // End:0x4EB
        if(((Location - CovInfo.Location) Dot CovInfo.Tangent) >= float(0))
        {
            CoverEnterAngle *= -1.0000000;
        }
    }
    //return;    
}

final simulated event PerformReleaseCover(optional bool bSkipManeuvers, optional bool bSkipStepOut)
{
    // End:0x44
    if((int(GetCoverState()) != int(0)) && int(GetCoverState()) != int(27))
    {
        ExitCover(bSkipManeuvers, bSkipStepOut);
    }
    //return;    
}

reliable server event ServerSetExitCoverState(SkyPawnCoverUser.ECoverState S)
{
    // End:0x76
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x44
        if(int(S) == int(0))
        {
            RepCoverToCoverInfo.Link = none;
            RepCovInfo.Link = none;
        }
        RepExitCoverState = S;
        // End:0x76
        if(int(GetCoverState()) != int(S))
        {
            SetCoverState(S);
        }
    }
    //return;    
}

final simulated event PerformSwatTurn(CoverReference Info)
{
    local float DistToSwatGoal;
    local Vector ToGoal;
    local float CurrentZDelta;
    local Vector vUp, CoverRight;
    local float dotToGoal;
    local CoverLink.ECoverOrientation CO;

    vUp.Z = 1.0000000;
    // End:0x5AF
    if(int(GetCoverState()) != int(0))
    {
        CO = GetCoverOrientation();
        CurrentZDelta = Location.Z - CurrentLink.GetSlotLocation(CurrentSlotIdx).Z;
        PreviousLink = CurrentLink;
        PreviousSlotIdx = CurrentSlotIdx;
        CurrentLink.UnClaim(self, CurrentSlotIdx, true);
        CurrentLink = CoverLink(Info.Actor);
        CurrentSlotIdx = Info.SlotIdx;
        CoverNormal = Vector(CurrentLink.GetSlotRotation(CurrentSlotIdx)) * -1.0000000;
        bSwatTurningToLeft = float(Info.Direction) < 0.0000000;
        // End:0x14E
        if(bSwatTurningToLeft)
        {
            RightSlotIdx = CurrentSlotIdx;
            LeftSlotIdx = ((CurrentSlotIdx > 0) ? CurrentSlotIdx - 1 : CurrentSlotIdx);            
        }
        else
        {
            LeftSlotIdx = CurrentSlotIdx;
            RightSlotIdx = ((CurrentSlotIdx < (CurrentLink.Slots.Length - 1)) ? CurrentSlotIdx + 1 : CurrentSlotIdx);
        }
        // End:0x1D2
        if((LeftSlotIdx == RightSlotIdx) || float(Info.Direction) < 0.0000000)
        {
            CurrentSlotPct = 1.0000000;
            SetPositionInCover(2);            
        }
        else
        {
            CurrentSlotPct = 0.0000000;
            SetPositionInCover(1);
        }
        CurrentLink.Claim(self, CurrentSlotIdx);
        ToGoal = CurrentLink.GetSlotLocation(CurrentSlotIdx) - Location;
        DistToSwatGoal = VSize(ToGoal);
        // End:0x249
        if(DistToSwatGoal <= SwatTurnShortDist)
        {
            SwatTurnType = 1;            
        }
        else
        {
            // End:0x263
            if(DistToSwatGoal <= SwatTurnLongDist)
            {
                SwatTurnType = 2;                
            }
            else
            {
                SwatTurnType = 3;
            }
        }
        // End:0x28A
        if(int(CO) == int(0))
        {
            SetCoverState(13);            
        }
        else
        {
            SetCoverState(24);
            // End:0x2EF
            if((int(CO) == int(1)) && !PrimaryWSM.IsTargeting() || PrimaryWSM.IsZooming())
            {
                PrimaryWSM.TryHolster();
            }
        }
        EntryPhysics.FinalLocation = CurrentLink.GetSlotLocation(CurrentSlotIdx);
        UpdateSlotLocByCoverOrientation(EntryPhysics.FinalLocation);
        // End:0x4E1
        if(int(CO) == int(0))
        {
            CoverRight = vUp Cross GetCoverNormal();
            CoverRight = Normal(CoverRight);
            dotToGoal = GetCoverNormal() Dot Normal(ToGoal);
            // End:0x432
            if(dotToGoal > 0.0001000)
            {
                bHasSWATLoc = true;
                NextSWATLoc = EntryPhysics.FinalLocation;
                // End:0x3E6
                if(int(PositionInCover) == int(2))
                {
                    EntryPhysics.FinalLocation = EntryPhysics.FinalLocation + (CoverRight * -SWATOffset);                    
                }
                else
                {
                    EntryPhysics.FinalLocation = EntryPhysics.FinalLocation + (CoverRight * SWATOffset);
                }
                UpdateSlotLocByCoverOrientation(EntryPhysics.FinalLocation);                
            }
            else
            {
                // End:0x4D9
                if(dotToGoal < -0.0001000)
                {
                    bHasSWATLoc = true;
                    NextSWATLoc = EntryPhysics.FinalLocation;
                    // End:0x496
                    if(int(PositionInCover) == int(2))
                    {
                        EntryPhysics.FinalLocation = Location + (CoverRight * SWATOffset);                        
                    }
                    else
                    {
                        EntryPhysics.FinalLocation = Location + (CoverRight * -SWATOffset);
                    }
                    UpdateSlotLocByCoverOrientation(EntryPhysics.FinalLocation);                    
                }
                else
                {
                    bHasSWATLoc = false;
                }
            }
        }
        // End:0x51A
        if(int(CO) == int(2))
        {
            EntryPhysics.FinalLocation.Z += (CurrentZDelta + VerticalSwatTurnZDeltaAmount);
        }
        EntryPhysics.FinalRotation = GetExpectedPawnRotation();
        CoverEnterDistance = VSize(Location - EntryPhysics.FinalLocation);
        CoverEnterAngle = Acos((CoverNormal Dot (Location - EntryPhysics.FinalLocation)) / CoverEnterDistance) * (360.0000000 / (3.1415930 * 2.0000000));
        // End:0x5AF
        if(bSwatTurningToLeft)
        {
            CoverEnterAngle *= -1.0000000;
        }
    }
    //return;    
}

// Export USkyPawnCoverUser::execSwatTurnLineCheck(FFrame&, void* const)
native function bool SwatTurnLineCheck(CoverLink DestLink, int DestSlotIdx);

final simulated event bool CanSwatTurn(out CoverReference Info, optional bool bIgnoreInput)
{
    local CoverSlot Slot;
    local SkyPlayerController PC;
    local bool bAtLeftEdge;

    // End:0x52
    if((((!bCanSwatTurn || !IsInCover()) || CurrentLink == none) || int(GetPositionInCover()) == int(0)) || UsingSecondaryItem())
    {
        return false;
    }
    PC = SkyPlayerController(Controller);
    Slot = CurrentLink.Slots[CurrentSlotIdx];
    bAtLeftEdge = int(GetPositionInCover()) == int(1);
    // End:0x179
    if(PC != none)
    {
        // End:0x179
        if(PC.IsLocalPlayerController() && !bIgnoreInput)
        {
            // End:0x179
            if((((Abs(PC.RemappedJoyRight) < PC.DeadZoneThreshold) || bAtLeftEdge && PC.RemappedJoyRight > PC.DeadZoneThreshold) || !bAtLeftEdge && PC.RemappedJoyRight < -PC.DeadZoneThreshold) || Abs(PC.RemappedJoyUp) > Abs(PC.RemappedJoyRight))
            {
                return false;
            }
        }
    }
    // End:0x1E9
    if(!CurrentLink.GetSwatTurnTarget(CurrentSlotIdx, ((bAtLeftEdge) ? -1 : 1), Info) || !CoverLink(Info.Actor).IsValidClaim(self, Info.SlotIdx, true))
    {
        return false;
    }
    // End:0x21F
    if(!SwatTurnLineCheck(CoverLink(Info.Actor), Info.SlotIdx))
    {
        return false;
    }
    // End:0x267
    if((bAtLeftEdge && !Slot.bCanSwatTurn_Left) || !bAtLeftEdge && !Slot.bCanSwatTurn_Right)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

final simulated function SetCoverAction(CoverLink.ECoverAction NewCoverAction)
{
    // End:0x1BD
    if(int(NewCoverAction) != int(CoverAction))
    {
        // End:0x18D
        if(!IsHumanControlled())
        {
            // End:0x85
            if(((int(CoverAction) == int(3)) || int(CoverAction) == int(1)) && (int(NewCoverAction) != int(3)) && int(NewCoverAction) != int(1))
            {
                NextCoverActionTime = -WorldInfo.TimeSeconds + 0.3500000;                
            }
            else
            {
                // End:0xE7
                if(((int(CoverAction) == int(4)) || int(CoverAction) == int(2)) && (int(NewCoverAction) != int(4)) && int(NewCoverAction) != int(2))
                {
                    NextCoverActionTime = WorldInfo.TimeSeconds + 0.3500000;
                }
            }
            // End:0x18D
            if((int(NewCoverAction) != int(0)) && Abs(NextCoverActionTime) > WorldInfo.TimeSeconds)
            {
                // End:0x152
                if(((NextCoverActionTime < 0.0000000) && int(NewCoverAction) != int(3)) && int(NewCoverAction) != int(1))
                {
                    NewCoverAction = 0;                    
                }
                else
                {
                    // End:0x18D
                    if(((NextCoverActionTime > 0.0000000) && int(NewCoverAction) != int(4)) && int(NewCoverAction) != int(2))
                    {
                        NewCoverAction = 0;
                    }
                }
            }
        }
        CoverAction = NewCoverAction;
        LastCoverActionTime = WorldInfo.TimeSeconds;
        // End:0x1BD
        if(int(Role) == int(ROLE_Authority))
        {
        }
    }
    //return;    
}

final function CoverLink.ECoverType FindCoverType()
{
    local CoverLink.ECoverType LeftType, RightType, RetType;

    RetType = 0;
    // End:0x126
    if(CurrentLink.Slots.Length > 1)
    {
        // End:0x74
        if((((LeftSlotIdx < 0) || RightSlotIdx < 0) || LeftSlotIdx >= CurrentLink.Slots.Length) || RightSlotIdx >= CurrentLink.Slots.Length)
        {
            ScriptTrace();
        }
        LeftType = CurrentLink.Slots[LeftSlotIdx].CoverType;
        RightType = CurrentLink.Slots[RightSlotIdx].CoverType;
        // End:0xDD
        if(CurrentSlotPct <= 0.1000000)
        {
            RetType = LeftType;            
        }
        else
        {
            // End:0xFA
            if(CurrentSlotPct >= 0.9000000)
            {
                RetType = RightType;                
            }
            else
            {
                // End:0x11B
                if(int(LeftType) > int(RightType))
                {
                    RetType = LeftType;                    
                }
                else
                {
                    RetType = RightType;
                }
            }
        }
    }
    // End:0x158
    if(int(RetType) != int(0))
    {
        RetType = CurrentLink.Slots[0].CoverType;
    }
    return RetType;
    //return ReturnValue;    
}

function NotifyCoverDestroyed(CoverLink Link, array<int> Slots)
{
    local int I;

    // End:0x8A
    if((int(GetCoverState()) != int(0)) && CurrentLink == Link)
    {
        I = 0;
        J0x2D:

        // End:0x8A [Loop If]
        if(I < Slots.Length)
        {
            // End:0x80
            if(Slots[I] == CurrentSlotIdx)
            {
                ExitCover();
                // End:0x7E
                if(int(GetCoverOrientation()) != int(0))
                {
                    CoverDangleFailureStart(false);
                }
                return;
            }
            ++I;
            // [Loop Continue]
            goto J0x2D;
        }
    }
    //return;    
}

function NotifyCoverGone()
{
    SetCoverState(0);
    // End:0x35
    if(SkyAIController(Controller) != none)
    {
        SkyAIController(Controller).NotifyExitCoverFinished();
    }
    //return;    
}

// Export USkyPawnCoverUser::execIsLeaning(FFrame&, void* const)
native final simulated function bool IsLeaning(CoverLink.ECoverAction PawnCA);

// Export USkyPawnCoverUser::execIsPoppingUp(FFrame&, void* const)
native final simulated function bool IsPoppingUp();

final simulated function bool IsPeeking(CoverLink.ECoverAction PawnCA)
{
    return ((int(PawnCA) == int(8)) || int(PawnCA) == int(7)) || int(PawnCA) == int(9);
    //return ReturnValue;    
}

final simulated function bool IsBlindFiring(CoverLink.ECoverAction PawnCA)
{
    return ((int(PawnCA) == int(2)) || int(PawnCA) == int(1)) || int(PawnCA) == int(6);
    //return ReturnValue;    
}

simulated function CovPosInfo CoverInfoToCovPosInfo(CoverInfo CovInfo)
{
    local CovPosInfo TheInfo;

    TheInfo.Link = CovInfo.Link;
    // End:0x95
    if(CovInfo.SlotIdx > 0)
    {
        TheInfo.LtSlotIdx = CovInfo.SlotIdx - 1;
        TheInfo.RtSlotIdx = CovInfo.SlotIdx;
        TheInfo.LtToRtPct = 1.0000000;        
    }
    else
    {
        TheInfo.LtSlotIdx = CovInfo.SlotIdx;
        TheInfo.RtSlotIdx = CovInfo.SlotIdx + 1;
        TheInfo.LtToRtPct = 0.0000000;
    }
    TheInfo.Location = CovInfo.Link.GetSlotLocation(CovInfo.SlotIdx);
    TheInfo.Normal = Vector(CovInfo.Link.GetSlotRotation(CovInfo.SlotIdx)) * -1.0000000;
    return TheInfo;
    //return ReturnValue;    
}

function bool NeedToTurn(Vector targ)
{
    local Vector LookDir, AimDir;
    local bool Result;
    local float HACK_ANGLE_THAT_SOMEONE_SHOULD_PARAMETERIZE;

    HACK_ANGLE_THAT_SOMEONE_SHOULD_PARAMETERIZE = 0.9300000;
    // End:0xFD
    if((IsInCover()) == false)
    {
        // End:0xD6
        if((SkyWeapon(Weapon) != none) && Controller != none)
        {
            LookDir = Vector(Controller.Rotation);
            LookDir.Z = 0.0000000;
            LookDir = Normal(LookDir);
            AimDir = targ - Location;
            AimDir.Z = 0.0000000;
            AimDir = Normal(AimDir);
            Result = (LookDir Dot AimDir) < HACK_ANGLE_THAT_SOMEONE_SHOULD_PARAMETERIZE;
            // End:0xCC
            if(!Result)
            {
            }
            return Result;            
        }
        else
        {
            Result = super.NeedToTurn(targ);
            // End:0xF3
            if(!Result)
            {
            }
            return Result;
        }        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
}

// Export USkyPawnCoverUser::execIsInVerticleCover(FFrame&, void* const)
native simulated function bool IsInVerticleCover();

function bool CannotJumpNow()
{
    return (super.CannotJumpNow() || int(GetCoverState()) != int(0)) || CoverDangleFailureIsActive();
    //return ReturnValue;    
}

simulated function StartFire(byte FireModeNum)
{
    local bool bMayStart;

    // End:0x20
    if(int(GetCoverState()) == int(0))
    {
        bMayStart = true;        
    }
    else
    {
        bMayStart = ((int(GetCoverState()) == int(6)) || int(GetCoverState()) == int(7)) || int(GetCoverState()) == int(8);
    }
    // End:0x7B
    if(bMayStart)
    {
        super.StartFire(FireModeNum);
    }
    //return;    
}

simulated event bool CanRocketPack()
{
    // End:0x17
    if(int(GetCoverState()) != int(0))
    {
        return false;
    }
    // End:0x26
    if(CoverDangleFailureIsActive())
    {
        return false;
    }
    return super.CanRocketPack();
    //return ReturnValue;    
}

// Export USkyPawnCoverUser::execCanUseItem(FFrame&, void* const)
native function bool CanUseItem();

event bool Can180()
{
    return super.Can180() && !CoverDangleFailureIsActive();
    //return ReturnValue;    
}

function bool CanSprint()
{
    // End:0x0F
    if(CoverDangleFailureIsActive())
    {
        return false;
    }
    // End:0x26
    if(int(GetCoverState()) != int(0))
    {
        return false;
    }
    return super.CanSprint();
    //return ReturnValue;    
}

function bool CanDuck()
{
    return super.CanDuck() && !CoverDangleFailureIsActive();
    //return ReturnValue;    
}

function bool CanSprintDive()
{
    // End:0x0F
    if(CoverDangleFailureIsActive())
    {
        return false;
    }
    return super.CanSprintDive();
    //return ReturnValue;    
}

// Export USkyPawnCoverUser::execTakeDamage(FFrame&, void* const)
native function TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser);

simulated event TakeFallingDamage(Vector HitNormal)
{
    // End:0x39
    if((IsInVerticalSpace() && Velocity.Z < (2.0000000 * MaxFallSpeedDeath)) && bMoveTowardInitatedCoverSpecialMove)
    {
        return;
    }
    super.TakeFallingDamage(HitNormal);
    //return;    
}

simulated function SetTargeting(bool Value)
{
    super.SetTargeting(Value);
    //return;    
}

simulated function ResetPreviousCoverLink()
{
    PreviousCoverLink = none;
    //return;    
}

event SetupCoverFallingDefaults(bool bDangleFalling)
{
    local SkyPawnCoverUser Defaults;

    Defaults = SkyPawnCoverUser(ObjectArchetype);
    // End:0x123
    if(Defaults != none)
    {
        // End:0xA5
        if(bDangleFalling)
        {
            CoverDangleFailureFallTime = Defaults.CoverDangleFailureFallTime;
            CoverDangleFailureRecoverySpeed = Defaults.CoverDangleFailureRecoverySpeed;
            CoverDangleFailureDamageScale = Defaults.CoverDangleFailureDamageScale;
            CoverDangleFailureDamagePeriod = Defaults.CoverDangleFailureDamagePeriod;
            CoverDangleFailureMinimumDamageSpeed = Defaults.CoverDangleFailureMinimumDamageSpeed;
            CoverDangleFailureOnGroundTime = Defaults.CoverDangleFailureOnGroundTime;            
        }
        else
        {
            CoverDangleFailureFallTime = Defaults.CoverDestroyFailureFallTime;
            CoverDangleFailureRecoverySpeed = Defaults.CoverDestroyFailureRecoverySpeed;
            CoverDangleFailureDamageScale = Defaults.CoverDestroyFailureDamageScale;
            CoverDangleFailureDamagePeriod = Defaults.CoverDestroyFailureDamagePeriod;
            CoverDangleFailureMinimumDamageSpeed = Defaults.CoverDestroyFailureMinimumDamageSpeed;
            CoverDangleFailureOnGroundTime = Defaults.CoverDestroyFailureOnGroundTime;
        }
    }
    //return;    
}

function DropWeapon(SkyWeapon drop, optional bool bAuxiliary, optional int auxIndex)
{
    local Vector SocketLocation;
    local Rotator SocketRotation;
    local Vector RelativeVelocity;

    // End:0x46
    if((IsInVerticleCover()) && VertDownWeaponDropSocket != 'None')
    {
        Mesh.GetSocketWorldLocationAndRotation(VertDownWeaponDropSocket, SocketLocation, SocketRotation);        
    }
    else
    {
        // End:0x82
        if(bAuxiliary)
        {
            Mesh.GetSocketWorldLocationAndRotation(AuxWeapons[auxIndex].Socket, SocketLocation, SocketRotation);            
        }
        else
        {
            Mesh.GetSocketWorldLocationAndRotation(TwoHandedWeaponBone, SocketLocation, SocketRotation);
        }
    }
    RelativeVelocity = Pickup_DropVelocity >> Rotation;
    drop.DropFromEx(SocketLocation, SocketRotation, Velocity + RelativeVelocity, Pickup_AngularVelocity >> SocketRotation, bAuxiliary, auxIndex);
    //return;    
}

function DrawDebugStates(Canvas Canvas, float YL, out float out_YPos)
{
    super.DrawDebugStates(Canvas, YL, out_YPos);
    Canvas.DrawText("Cover State = " $ string(CoverState));
    out_YPos += YL;
    Canvas.SetPos(4.0000000, out_YPos);
    //return;    
}

// Export USkyPawnCoverUser::execIsValidSoundContext(FFrame&, void* const)
native function bool IsValidSoundContext(name SoundContext);

// Export USkyPawnCoverUser::execIsValidEffectContext(FFrame&, void* const)
native function bool IsValidEffectContext(name EffectContext);

// Export USkyPawnCoverUser::execIsValidEffectType(FFrame&, void* const)
native function bool IsValidEffectType(name EffectType);

// Export USkyPawnCoverUser::execIsNearEdge(FFrame&, void* const)
native function bool IsNearEdge(CoverLink.ECoverDirection Direction);

// Export USkyPawnCoverUser::execGetEdgeDistance(FFrame&, void* const)
native function float GetEdgeDistance(CoverLink.ECoverDirection Direction, float MaxDistance, optional float InPercent = -1.0000000);

// Export USkyPawnCoverUser::execGetClosestEdge(FFrame&, void* const)
native function CoverLink.ECoverDirection GetClosestEdge(out float Distance);

// Export USkyPawnCoverUser::execTryTriggerStepout(FFrame&, void* const)
native function bool TryTriggerStepout();

// Export USkyPawnCoverUser::execCanStepout(FFrame&, void* const)
native function SkyPawnCoverUser.ECoverStepOutType CanStepout(CoverLink.ECoverDirection Position, bool bCheckSwatAndDive, bool bCheckSlip, bool bCheckTarget);

// Export USkyPawnCoverUser::execPerformStepout(FFrame&, void* const)
native function PerformStepout(SkyPawnCoverUser.ECoverStepOutType Type, CoverLink.ECoverDirection Direction);

// Export USkyPawnCoverUser::execPerformStepoutAction(FFrame&, void* const)
native function PerformStepoutAction();

// Export USkyPawnCoverUser::execAbortStepoutAction(FFrame&, void* const)
native function AbortStepoutAction();

// Export USkyPawnCoverUser::execCoverDangleAction(FFrame&, void* const)
native function CoverDangleAction(string Button);

// Export USkyPawnCoverUser::execCoverDangleStart(FFrame&, void* const)
native function CoverDangleStart();

// Export USkyPawnCoverUser::execCoverDangleStop(FFrame&, void* const)
native function CoverDangleStop(bool bSuccess);

// Export USkyPawnCoverUser::execCoverDangleToggle(FFrame&, void* const)
native function CoverDangleToggle(bool bOn);

// Export USkyPawnCoverUser::execCoverDangleAllowed(FFrame&, void* const)
native function bool CoverDangleAllowed();

// Export USkyPawnCoverUser::execCoverDangleUpdate(FFrame&, void* const)
native function CoverDangleUpdate(float DeltaSeconds);

// Export USkyPawnCoverUser::execCoverDangleFailureStart(FFrame&, void* const)
native function CoverDangleFailureStart(bool bDangleFalling);

// Export USkyPawnCoverUser::execCoverDangleFailureIsActive(FFrame&, void* const)
native function bool CoverDangleFailureIsActive();

// Export USkyPawnCoverUser::execCanRecoverFromCoverDangleFailure(FFrame&, void* const)
native function bool CanRecoverFromCoverDangleFailure();

// Export USkyPawnCoverUser::execIsRecoveringFromCoverDangleFailure(FFrame&, void* const)
native function bool IsRecoveringFromCoverDangleFailure();

// Export USkyPawnCoverUser::execCoverDangleFailureUpdate(FFrame&, void* const)
native function CoverDangleFailureUpdate(float DeltaSeconds);

// Export USkyPawnCoverUser::execCoverDangleFailureRecover(FFrame&, void* const)
native function CoverDangleFailureRecover();

// Export USkyPawnCoverUser::execCoverDangleFailureStop(FFrame&, void* const)
native function CoverDangleFailureStop(bool bRecovered);

// Export USkyPawnCoverUser::execUpdateSlotLocByCoverOrientation(FFrame&, void* const)
native function UpdateSlotLocByCoverOrientation(out Vector SlotLoc);

// Export USkyPawnCoverUser::execGetExpectedPawnRotation(FFrame&, void* const)
native function Rotator GetExpectedPawnRotation();

event bool IsBlindFiringTrophy()
{
    return ((IsInCover()) && PrimaryWSM != none) && !PrimaryWSM.IsTargeting();
    //return ReturnValue;    
}

function ProcessDeathSpawn(class<DamageType> DamageType)
{
    local int I;
    local float delay;

    I = 0;
    J0x07:

    // End:0x18A [Loop If]
    if(I < DeathSpawnTypes.Length)
    {
        // End:0x180
        if((DeathSpawnTypes[I].DamageType == none) || ClassIsChildOf(DamageType, DeathSpawnTypes[I].DamageType))
        {
            // End:0x82
            if(DeathSpawnTypes[I].bNoSpawnInVerticalCover && IsInVerticleCover())
            {
                // [Explicit Continue]
                goto J0x180;
            }
            // End:0x17D
            if((RandRange(0.0000000, 100.0000000) <= DeathSpawnTypes[I].PctChance) && DeathSpawnTypes[I].PctChance > 0.0000000)
            {
                DeathSpawnIndex = I;
                // End:0x116
                if((int(Physics) == int(1)) && Base != none)
                {
                    delay = DeathSpawnTypes[I].GroundSpawnDelay;                    
                }
                else
                {
                    delay = DeathSpawnTypes[I].AirSpawnDelay;
                }
                // End:0x157
                if(delay > 0.0000000)
                {
                    SetTimer(delay, false, 'SpawnDeathSpawn');                    
                }
                else
                {
                    SpawnDeathSpawn();
                }
                DeathReactionOverride = DeathSpawnTypes[I].DeathReactionOverride;
            }
            // [Explicit Break]
            goto J0x18A;
        }
        J0x180:

        I++;
        // [Loop Continue]
        goto J0x07;
    }
    J0x18A:

    //return;    
}

simulated state Dying
{
    simulated function BeginState(name PreviousStateName)
    {
        // End:0x20
        if(Controller != none)
        {
            Controller.PawnDied(self);
        }
        super.BeginState(PreviousStateName);
        //return;        
    }
    stop;    
}
