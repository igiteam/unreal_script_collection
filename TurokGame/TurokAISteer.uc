class TurokAISteer extends ActorComponent
    native
    hidecategories(Actor,Object,ActorComponent);

const kMaxNumRecentHeadings = 30;

enum eZigZagType
{
    ZIGZAG_Normal,                  // 0
    ZIGZAG_Regular,                 // 1
    ZIGZAG_Uniform,                 // 2
    ZIGZAG_MAX                      // 3
};

enum eSteeringAccumulationType
{
    STEERACC_Weighted,              // 0
    STEERACC_Prioritized,           // 1
    STEERACC_MAX                    // 2
};

var @NULL mSteeringVector;
var @NULL mLastSteeringVector;
var @NULL mFacingRotation;
var @NULL mLastFacingRotation;
var bool mbAvoiding;
var bool mbAvoidanceChosenDirection;
var bool mbCapAvoidanceSpeed;
var bool mbAllowEmergencyStop;
var bool mbSpeedOverride;
var bool mAllowStrafing;
var bool mbZigZag;
var bool mbForceDecelerate;
var bool mbQuitWhenSpeedReached;
var bool mbTurnOffWhenSpeedReached;
var() bool mbHackcelerateOnOneWayPaths;
var @NULL mAvoidanceHitActor;
var @NULL mAvoidanceHitPosition;
var @NULL mAvoidanceHitNormal;
var @NULL mAvoidanceTarget;
var float mAvoidanceTimer;
var float mAvoidanceReevaluateTargetTimer;
var float mForceEmergencyStopTimer;
var @NULL mUnalignedAvoidance;
var float mLastHeadingChange;
var int mLastHeadingChangeDirection;
var() float mDefaultSeparationBufferDist;
var float mWanderTargetMaxAngle;
var int mLastWanderSteer;
var(ZigZag) float mZigZagInterval;
var(ZigZag) float mZigZagAngle;
var(ZigZag) byte mZigZagType;
var byte mAccumulationType;
var(ZigZag) float mZigZagRetargetPlayerDistance;
var @NULL mZigZagSeekPoint;
var float mZigZagTimer;
var int mZigZagDir;
var float mLastRandomSpeed;
var float mForceDecelerateSpeed;
var float mLastDecelSpeed;
var float mDecelRate;
var float mForceDecelTime;
var float mForceDecelCurrentTime;
var float mDisableAccelBoostTimer;
var float mBackWeight;
var float mLeftWeight;
var float mRightWeight;
var() float mMinSteerSpeedRate;
var() float mDefaultMinSpeedInterpRate;
var() float mDefaultMaxSpeedInterpRate;
var() float mMinAvoidanceSpeed;
var() float mSteeringDecelerationRate;
var() float mSeparationNeighbourDistance;
var() array mSteeringPreset;
var() float mDefaultWallAvoidanceDistanceForward;
var() float mDefaultWallAvoidanceDistanceSide;
var() float mMaxPrioritizedForce;
var() float mMinWallAvoidanceSpeed;
var @NULL mRecentHeadings[30];
var int mRecentHeadingPtr;

// Export UTurokAISteer::execSteerForSeek(FFrame&, void* const)
native function @NULL SteerForSeek(@NULL startPos, @NULL seekPos, float DeltaTime);

// Export UTurokAISteer::execSteerForFlee(FFrame&, void* const)
native function @NULL SteerForFlee(@NULL startPos, @NULL seekPos);

// Export UTurokAISteer::execSteerForSeparation(FFrame&, void* const)
native function @NULL SteerForSeparation(@NULL Pawn, array nearbyPawns, float Weight, optional @NULL Target);

// Export UTurokAISteer::execSteerForCohesion(FFrame&, void* const)
native function @NULL SteerForCohesion(@NULL Pawn, array nearbyPawns, float Weight, optional @NULL Target);

// Export UTurokAISteer::execSteerForAvoidance(FFrame&, void* const)
native function SteerForAvoidance(@NULL Pawn, @NULL startPos, @NULL targetPos, float Weight);

// Export UTurokAISteer::execSteerForPursuit(FFrame&, void* const)
native function @NULL SteerForPursuit(@NULL Actor, @NULL Other, float maxPreditionTime);

// Export UTurokAISteer::execSteerForEvasion(FFrame&, void* const)
native function @NULL SteerForEvasion(@NULL Actor, @NULL Other, float maxPreditionTime);

// Export UTurokAISteer::execSteerForWander(FFrame&, void* const)
native function @NULL SteerForWander(@NULL Pawn, float DeltaTime);

// Export UTurokAISteer::execSteerForAlignment(FFrame&, void* const)
native function @NULL SteerForAlignment(@NULL Pawn, array nearbyPawns, optional @NULL Target);

// Export UTurokAISteer::execSteerToAvoidNeighbours(FFrame&, void* const)
native function @NULL SteerToAvoidNeighbours(@NULL Pawn, float minTimeToCollision, array nearbyPawns, float DeltaTime);

// Export UTurokAISteer::execSteerToAvoidCloseNeighbours(FFrame&, void* const)
native function bool SteerToAvoidCloseNeighbours(@NULL Pawn, float minSeparationDistance, array nearbyPawns, out @NULL steerVector);

// Export UTurokAISteer::execSteerForWallAvoidance(FFrame&, void* const)
native function @NULL SteerForWallAvoidance(@NULL Pawn, @NULL startPos);

// Export UTurokAISteer::execSteerForWallAvoidanceWeighted(FFrame&, void* const)
native function SteerForWallAvoidanceWeighted(@NULL Pawn, @NULL startPos, float Weight);

// Export UTurokAISteer::execSteerForQueuing(FFrame&, void* const)
native function SteerForQueuing(@NULL Pawn, array nearbyPawns, float Weight, optional @NULL Target);

// Export UTurokAISteer::execInitSteering(FFrame&, void* const)
native function InitSteering();

// Export UTurokAISteer::execResetSteeringVectors(FFrame&, void* const)
native function ResetSteeringVectors(@NULL Pawn);

// Export UTurokAISteer::execSteerVector2d(FFrame&, void* const)
native function @NULL SteerVector2d(@NULL Pawn, float dt, out float steerSpeedRate);

// Export UTurokAISteer::execSetZigZag(FFrame&, void* const)
native function SetZigZag(bool Active);

// Export UTurokAISteer::execIsZigZagging(FFrame&, void* const)
native function bool IsZigZagging();

// Export UTurokAISteer::execForceDeceleration(FFrame&, void* const)
native function ForceDeceleration(@NULL Pawn, bool Activate, float TargetSpeed, float Rate, bool QuitWhenSpeedReached, optional bool bTurnOffWhenSpeedReached, optional float ForceDecelTime);

// Export UTurokAISteer::execSteerForWallAvoidance2(FFrame&, void* const)
native function SteerForWallAvoidance2(@NULL Pawn, @NULL startPos, float Weight);

// Export UTurokAISteer::execIsCloseNeighbor(FFrame&, void* const)
native final function bool IsCloseNeighbor(@NULL Pawn, @NULL Other, float MaxRadius, float cosMaxAngle, optional float MinRadius);

function LogSteer()
{
    //return;    
}

// Export UTurokAISteer::execSetForSteering(FFrame&, void* const)
native function SetForSteering();

event @NULL FacingRotation2d(float dt, out float steerSpeedRate)
{
    //return ReturnValue;    
}

function @NULL SteerPosition2d(@NULL startPos, float Distance, float dt)
{
    //return ReturnValue;    
}

function DisplayDebug(@NULL HUD, out float out_YL, out float out_YPos)
{
    local @NULL Canvas;

    Canvas = HUD.Canvas;
    // End:0xEB
    if(HUD.ShouldDisplayDebug('AI'))
    {
        Canvas.DrawColor.R = 0;
        Canvas.DrawColor.G = byte(255);
        Canvas.DrawColor.B = byte(255);
        Canvas.__NFUN_465__("          Obstacle:" $ Owner.GetItemName(string(mAvoidanceHitActor)), false);
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
    }
    //return;    
}

defaultproperties
{
    mbAllowEmergencyStop=true
    mbQuitWhenSpeedReached=true
    mDefaultSeparationBufferDist=2.5000000
    mWanderTargetMaxAngle=30.0000000
    mZigZagInterval=0.8000000
    mZigZagAngle=60.0000000
    mZigZagType=1
    mZigZagRetargetPlayerDistance=700.0000000
    mForceDecelerateSpeed=0.1000000
    mLastDecelSpeed=1.0000000
    mDecelRate=0.9000000
    mMinSteerSpeedRate=0.2500000
    mDefaultMinSpeedInterpRate=2.0000000
    mDefaultMaxSpeedInterpRate=1.0000000
    mMinAvoidanceSpeed=0.4000000
    mSteeringDecelerationRate=0.0100000
    mSeparationNeighbourDistance=1000.0000000
    mDefaultWallAvoidanceDistanceForward=100.0000000
    mDefaultWallAvoidanceDistanceSide=100.0000000
    mMaxPrioritizedForce=5.0000000
    mMinWallAvoidanceSpeed=0.1000000
    TickGroup=3
}