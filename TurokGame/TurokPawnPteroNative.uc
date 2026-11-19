class TurokPawnPteroNative extends TurokPawnDino
    abstract
    native
    config(Game)
    hidecategories(Navigation);

const mLocationFutureBufferSize = 30;
const mLocationFutureTime = 1.0f;
const mPathBlendTime = 0.75f;
const mDefaultPathBlendSpeed = 0.008f;

enum EPteroSteer
{
    PTEROSTEER_Default,             // 0
    PTEROSTEER_Attack,              // 1
    PTEROSTEER_MAX                  // 2
};

enum EPteroGoal
{
    PTEROGOAL_FlyPath,              // 0
    PTEROGOAL_AttackEnemy,          // 1
    PTEROGOAL_MAX                   // 2
};

struct native PteroLocationHistory
{
    var float mHeight;
    var int mYaw;
    var float mTime;

    structdefaultproperties
    {
        mHeight=0.0000000
        mYaw=0
        mTime=-1.0000000
    }
};

var() string mMatineePathName;
var @NULL mPathActor;
var bool mbStickToPathXY;
var bool mbStickToPathZ;
var bool mbBlendToPath;
var bool mbMonitorRelativeOrientation;
var bool mbAlwaysStayOnPath;
var bool mbAllowAttackSwoopDown;
var bool mbAutoFaceDirectionOfMovement;
var @NULL mBlendStartPos;
var @NULL mBlendStartRot;
var @NULL mBlendTargetPos;
var @NULL mBlendTargetRot;
var float mBlendTimeRemaining;
var float mAttemptedLockonTime;
var @NULL mOffsetFromPath;
var @NULL mLocationFuture[30];
var int mLocationFuturePtr;
var float mMoveHeight;
var float mMinSwoopStartHeightAboveEnemy;
var float mMaxSwoopStartHeightAboveEnemy;
var float mMinSwoopTime;
var float mMaxSwoopTime;
var @NULL mPathAttackGraphSet;
var @NULL mPickupAttackGraphSet;
var @NULL mLastPathActorLocation;
var float mPathBlendSpeed;
var(Sound) float mIdleFadeOutTime;

// Export UTurokPawnPteroNative::execAttachToPath(FFrame&, void* const)
native function AttachToPath();

// Export UTurokPawnPteroNative::execGetLocationFutureHeightChange(FFrame&, void* const)
native function float GetLocationFutureHeightChange();

// Export UTurokPawnPteroNative::execGetLocationFutureYaw(FFrame&, void* const)
native function int GetLocationFutureYaw();

// Export UTurokPawnPteroNative::execGetTrackPositionAtTime(FFrame&, void* const)
native function bool GetTrackPositionAtTime(float fTime, out @NULL futurePos, out @NULL futureRot);

// Export UTurokPawnPteroNative::execGetCurrentTrackTime(FFrame&, void* const)
native function float GetCurrentTrackTime();

// Export UTurokPawnPteroNative::execInitPathBlend(FFrame&, void* const)
native function InitPathBlend();

simulated event StopIdleSound()
{
    // End:0x2D
    if(mPawnIdleSoundCue != none)
    {
        mSoundController.FadeOutAudioChannel(mPawnIdleSndChannel, mIdleFadeOutTime, 0.0000000);
    }
    //return;    
}

defaultproperties
{
    mLocationFuture[0]=(mHeight=0.0000000,mYaw=0,mTime=-1.0000000)
    mLocationFuture[1]=(mHeight=0.0000000,mYaw=0,mTime=-1.0000000)
    mLocationFuture[2]=(mHeight=0.0000000,mYaw=0,mTime=-1.0000000)
    mLocationFuture[3]=(mHeight=0.0000000,mYaw=0,mTime=-1.0000000)
    mLocationFuture[4]=(mHeight=0.0000000,mYaw=0,mTime=-1.0000000)
    mLocationFuture[5]=(mHeight=0.0000000,mYaw=0,mTime=-1.0000000)
    mLocationFuture[6]=(mHeight=0.0000000,mYaw=0,mTime=-1.0000000)
    mLocationFuture[7]=(mHeight=0.0000000,mYaw=0,mTime=-1.0000000)
    mLocationFuture[8]=(mHeight=0.0000000,mYaw=0,mTime=-1.0000000)
    mLocationFuture[9]=(mHeight=0.0000000,mYaw=0,mTime=-1.0000000)
    mLocationFuture[10]=(mHeight=0.0000000,mYaw=0,mTime=-1.0000000)
    mLocationFuture[11]=(mHeight=0.0000000,mYaw=0,mTime=-1.0000000)
    mLocationFuture[12]=(mHeight=0.0000000,mYaw=0,mTime=-1.0000000)
    mLocationFuture[13]=(mHeight=0.0000000,mYaw=0,mTime=-1.0000000)
    mLocationFuture[14]=(mHeight=0.0000000,mYaw=0,mTime=-1.0000000)
    mLocationFuture[15]=(mHeight=0.0000000,mYaw=0,mTime=-1.0000000)
    mLocationFuture[16]=(mHeight=0.0000000,mYaw=0,mTime=-1.0000000)
    mLocationFuture[17]=(mHeight=0.0000000,mYaw=0,mTime=-1.0000000)
    mLocationFuture[18]=(mHeight=0.0000000,mYaw=0,mTime=-1.0000000)
    mLocationFuture[19]=(mHeight=0.0000000,mYaw=0,mTime=-1.0000000)
    mLocationFuture[20]=(mHeight=0.0000000,mYaw=0,mTime=-1.0000000)
    mLocationFuture[21]=(mHeight=0.0000000,mYaw=0,mTime=-1.0000000)
    mLocationFuture[22]=(mHeight=0.0000000,mYaw=0,mTime=-1.0000000)
    mLocationFuture[23]=(mHeight=0.0000000,mYaw=0,mTime=-1.0000000)
    mLocationFuture[24]=(mHeight=0.0000000,mYaw=0,mTime=-1.0000000)
    mLocationFuture[25]=(mHeight=0.0000000,mYaw=0,mTime=-1.0000000)
    mLocationFuture[26]=(mHeight=0.0000000,mYaw=0,mTime=-1.0000000)
    mLocationFuture[27]=(mHeight=0.0000000,mYaw=0,mTime=-1.0000000)
    mLocationFuture[28]=(mHeight=0.0000000,mYaw=0,mTime=-1.0000000)
    mLocationFuture[29]=(mHeight=0.0000000,mYaw=0,mTime=-1.0000000)
    mPathBlendSpeed=0.0080000
    mIdleFadeOutTime=0.5000000
    // Reference: TurokRadialShakeComponent'Default__TurokPawnPteroNative.Shakey'
    begin object name=Shakey
    end object
    mFootStompCamShake=Shakey
    // Reference: TurokAISteer'Default__TurokPawnPteroNative.TurokAISteerComponent'
    begin object name=TurokAISteerComponent
    end object
    mSteer=TurokAISteerComponent
    // Reference: TurokAIPlanner'Default__TurokPawnPteroNative.TurokAIPlannerComponent'
    begin object name=TurokAIPlannerComponent
    end object
    mPlanner=TurokAIPlannerComponent
    // Reference: DynamicLightEnvironmentComponent'Default__TurokPawnPteroNative.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: TurokPathController'Default__TurokPawnPteroNative.TurokPathControllerComponent'
    begin object name=TurokPathControllerComponent
    end object
    mPathController=TurokPathControllerComponent
    // Reference: TurokTargetingSystem'Default__TurokPawnPteroNative.TurokTargetingSystemComponent'
    begin object name=TurokTargetingSystemComponent
    end object
    mTargetingSystem=TurokTargetingSystemComponent
    // Reference: TurokSoundController'Default__TurokPawnPteroNative.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent
    end object
    mSoundController=TurokSoundControllerComponent
    mPartialRagdollFixedJoints=/* Array type was not detected. */
    mCollisionEventJoints=/* Array type was not detected. */
    mSkeletalHurt=/* Array type was not detected. */
    // Reference: TurokAnimLadderController'Default__TurokPawnPteroNative.ladderController'
    begin object name=ladderController
    end object
    mLadderController=ladderController
    // Reference: SkeletalMeshComponent'Default__TurokPawnPteroNative.TurokSkeletalMeshComponent'
    begin object name=TurokSkeletalMeshComponent
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokPawnPteroNative.MyLightEnvironment'
    end object
    Mesh=TurokSkeletalMeshComponent
    // Reference: CylinderComponent'Default__TurokPawnPteroNative.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    // Reference: ArrowComponent'Default__TurokPawnPteroNative.Arrow'
    begin object name=Arrow
    end object
    Components[1]=Arrow
    Components[2]=TurokAISteerComponent
    Components[3]=TurokAIPlannerComponent
    Components[4]=TurokPathControllerComponent
    Components[5]=TurokTargetingSystemComponent
    Components[6]=MyLightEnvironment
    Components[7]=TurokSkeletalMeshComponent
    Components[8]=TurokSoundControllerComponent
    Components[9]=ladderController
    CollisionComponent=CollisionCylinder
}