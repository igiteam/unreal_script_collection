class TurokPawnLurkerNative extends TurokPawnDino
    abstract
    native
    config(Game)
    hidecategories(Navigation);

enum ELurkerSteer
{
    LURKERSTEER_Default,            // 0
    LURKERSTEER_DefaultScripted,    // 1
    LURKERSTEER_Investigate,        // 2
    LURKERSTEER_Wander,             // 3
    LURKERSTEER_Damaged,            // 4
    LURKERSTEER_Stalk,              // 5
    LURKERSTEER_Recovery,           // 6
    LURKERSTEER_InsideAttack,       // 7
    LURKERSTEER_Breakoff,           // 8
    LURKERSTEER_MoveToSafety,       // 9
    LURKERSTEER_Spitting,           // 10
    LURKERSTEER_FastAttack,         // 11
    LURKERSTEER_MAX                 // 12
};

var array mSurfaceList;
var(LurkerAttackPattern) float mMinHideDist;
var(LurkerAttackPattern) float mMinAttackDist;
var(LurkerAttackPattern) float mMinDistToCover;
var(LurkerAttackPattern) float mMinSurfaceTimeDelta;
var(LurkerAttackPattern) float mIdleTime;
var(LurkerAttackPattern) float mBreakToSurfacePercent;
var(LurkerAttackPattern) float mPlayerThreatTweak;
var(LurkerAttackPattern) int mRandomAttacksBeforeUsingSurface;
var @NULL mSurfaceGraphSet;
var private float mLastTime;
var private float mTrackingTime;

// Export UTurokPawnLurkerNative::execGetFootStepVolume(FFrame&, void* const)
native simulated function float GetFootStepVolume(float Speed, optional name JointName);

// Export UTurokPawnLurkerNative::execSetTGraphRate(FFrame&, void* const)
native final function SetTGraphRate(float Rate);

// Export UTurokPawnLurkerNative::execCheckForWallCollisions(FFrame&, void* const)
native final function @NULL CheckForWallCollisions(out @NULL vHitLoc, out @NULL vHitNormal);

// Export UTurokPawnLurkerNative::execFindJumpTarget(FFrame&, void* const)
native final function @NULL FindJumpTarget(@NULL vRay, out @NULL vHitLoc, out @NULL vHitNormal);

// Export UTurokPawnLurkerNative::execCheckEndLocation(FFrame&, void* const)
native function CheckEndLocation();

simulated event PostBeginPlay()
{
    local @NULL lkrSurface;

    super(TurokPawn).PostBeginPlay();
    // End:0x29
    foreach AllActors(Class'TurokLurkerSurface', lkrSurface)
    {
        mSurfaceList[mSurfaceList.Length] = lkrSurface;        
    }    
    //return;    
}

simulated event PlayFoleySound()
{
    // End:0x25
    if(mSoundController.CanPlayLimitedSound('Foley'))
    {
        super(TurokPawn).PlayFoleySound();
    }
    //return;    
}

simulated event bool CanAutoAimTo()
{
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    mMinHideDist=1000.0000000
    mMinAttackDist=120.0000000
    mMinDistToCover=1800.0000000
    mMinSurfaceTimeDelta=5.0000000
    mIdleTime=2.0000000
    mBreakToSurfacePercent=35.0000000
    mPlayerThreatTweak=0.1750000
    mRandomAttacksBeforeUsingSurface=2
    mTrackingTime=1.0000000
    // Reference: TurokRadialShakeComponent'Default__TurokPawnLurkerNative.Shakey'
    begin object name=Shakey
    end object
    mFootStompCamShake=Shakey
    // Reference: TurokAISteer'Default__TurokPawnLurkerNative.TurokAISteerComponent'
    begin object name=TurokAISteerComponent
        mMinSteerSpeedRate=0.1500000
        mDefaultMinSpeedInterpRate=8.0000000
        mDefaultMaxSpeedInterpRate=5.0000000
        mSteeringDecelerationRate=0.0080000
        mSteeringPreset=/* Array type was not detected. */
        mMinWallAvoidanceSpeed=0.5000000
    end object
    mSteer=TurokAISteerComponent
    // Reference: TurokAIPlanner'Default__TurokPawnLurkerNative.TurokAIPlannerComponent'
    begin object name=TurokAIPlannerComponent
        mAIGoal=/* Array type was not detected. */
        mSortedGoals=true
    end object
    mPlanner=TurokAIPlannerComponent
    // Reference: DynamicLightEnvironmentComponent'Default__TurokPawnLurkerNative.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: TurokPathController'Default__TurokPawnLurkerNative.TurokPathControllerComponent'
    begin object name=TurokPathControllerComponent
    end object
    mPathController=TurokPathControllerComponent
    // Reference: TurokTargetingSystem'Default__TurokPawnLurkerNative.TurokTargetingSystemComponent'
    begin object name=TurokTargetingSystemComponent
    end object
    mTargetingSystem=TurokTargetingSystemComponent
    // Reference: TurokSoundController'Default__TurokPawnLurkerNative.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent
    end object
    mSoundController=TurokSoundControllerComponent
    mPartialRagdollFixedJoints=/* Array type was not detected. */
    mRecoveryPlaneJoints=/* Array type was not detected. */
    mCollisionEventJoints=/* Array type was not detected. */
    mSkeletalHurt=/* Array type was not detected. */
    // Reference: TurokAnimLadderController'Default__TurokPawnLurkerNative.ladderController'
    begin object name=ladderController
    end object
    mLadderController=ladderController
    // Reference: SkeletalMeshComponent'Default__TurokPawnLurkerNative.TurokSkeletalMeshComponent'
    begin object name=TurokSkeletalMeshComponent
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokPawnLurkerNative.MyLightEnvironment'
    end object
    Mesh=TurokSkeletalMeshComponent
    // Reference: CylinderComponent'Default__TurokPawnLurkerNative.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    // Reference: ArrowComponent'Default__TurokPawnLurkerNative.Arrow'
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