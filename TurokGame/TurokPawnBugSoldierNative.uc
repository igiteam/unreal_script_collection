class TurokPawnBugSoldierNative extends TurokPawnBug
    abstract
    native
    config(Pawn)
    hidecategories(Navigation);

enum ESoldierBugSteer
{
    SOLDIERBUGSTEER_Default,        // 0
    SOLDIERBUGSTEER_Investigate,    // 1
    SOLDIERBUGSTEER_Attack,         // 2
    SOLDIERBUGSTEER_Wander,         // 3
    SOLDIERBUGSTEER_Breakoff,       // 4
    SOLDIERBUGSTEER_Protect,        // 5
    SOLDIERBUGSTEER_Flee,           // 6
    SOLDIERBUGSTEER_ScriptWalk,     // 7
    SOLDIERBUGSTEER_ScriptJog,      // 8
    SOLDIERBUGSTEER_ScriptRun,      // 9
    SOLDIERBUGSTEER_ScriptWalkNoAvoid,// 10
    SOLDIERBUGSTEER_ScriptJogNoAvoid,// 11
    SOLDIERBUGSTEER_ScriptRunNoAvoid,// 12
    SOLDIERBUGSTEER_MAX             // 13
};

enum ESoldierBugGoal
{
    SOLDIERBUGGOAL_Idle,            // 0
    SOLDIERBUGGOAL_AttackEnemy,     // 1
    SOLDIERBUGGOAL_Wander,          // 2
    SOLDIERBUGGOAL_Investigate,     // 3
    SOLDIERBUGGOAL_FlareAvoid,      // 4
    SOLDIERBUGGOAL_InvestigateFlare,// 5
    SOLDIERBUGGOAL_MAX              // 6
};

var() float mMinStationaryAttackDistance;
var() float mLocoToAttackDistance;
var() float mAttackStepDistance;
var @NULL mAttackStepGraphSet;
var() array mAttackDistances;

// Export UTurokPawnBugSoldierNative::execAttachDefaultAnimations(FFrame&, void* const)
protected native function AttachDefaultAnimations();

// Export UTurokPawnBugSoldierNative::execCheckEndLocation(FFrame&, void* const)
native function CheckEndLocation();

event Falling()
{
    SetPhysics(2);
    //return;    
}

defaultproperties
{
    // Reference: TurokRadialShakeComponent'Default__TurokPawnBugSoldierNative.Shakey'
    begin object name=Shakey
    end object
    mFootStompCamShake=Shakey
    mHopbackDistance=170.0000000
    // Reference: TurokAISteer'Default__TurokPawnBugSoldierNative.TurokAISteerComponent'
    begin object name=TurokAISteerComponent
    end object
    mSteer=TurokAISteerComponent
    // Reference: TurokAIPlanner'Default__TurokPawnBugSoldierNative.TurokAIPlannerComponent'
    begin object name=TurokAIPlannerComponent
    end object
    mPlanner=TurokAIPlannerComponent
    // Reference: DynamicLightEnvironmentComponent'Default__TurokPawnBugSoldierNative.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    mbFlareAvoid=true
    // Reference: TurokPathController'Default__TurokPawnBugSoldierNative.TurokPathControllerComponent'
    begin object name=TurokPathControllerComponent
    end object
    mPathController=TurokPathControllerComponent
    // Reference: TurokTargetingSystem'Default__TurokPawnBugSoldierNative.TurokTargetingSystemComponent'
    begin object name=TurokTargetingSystemComponent
    end object
    mTargetingSystem=TurokTargetingSystemComponent
    // Reference: TurokSoundController'Default__TurokPawnBugSoldierNative.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent
    end object
    mSoundController=TurokSoundControllerComponent
    mPartialRagdollFixedJoints=/* Array type was not detected. */
    mCollisionEventJoints=/* Array type was not detected. */
    mSkeletalHurt=/* Array type was not detected. */
    // Reference: TurokAnimLadderController'Default__TurokPawnBugSoldierNative.ladderController'
    begin object name=ladderController
    end object
    mLadderController=ladderController
    // Reference: SkeletalMeshComponent'Default__TurokPawnBugSoldierNative.TurokSkeletalMeshComponent'
    begin object name=TurokSkeletalMeshComponent
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokPawnBugSoldierNative.MyLightEnvironment'
    end object
    Mesh=TurokSkeletalMeshComponent
    // Reference: CylinderComponent'Default__TurokPawnBugSoldierNative.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    // Reference: ArrowComponent'Default__TurokPawnBugSoldierNative.Arrow'
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