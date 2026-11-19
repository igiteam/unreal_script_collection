class TurokPawnRaptorNative extends TurokPawnDino
    abstract
    native
    config(Pawn)
    hidecategories(Navigation);

enum ERaptorSteer
{
    RAPTORSTEER_Default,            // 0
    RAPTORSTEER_DefaultScripted,    // 1
    RAPTORSTEER_Investigate,        // 2
    RAPTORSTEER_Wander,             // 3
    RAPTORSTEER_Damaged,            // 4
    RAPTORSTEER_Stalk,              // 5
    RAPTORSTEER_Recovery,           // 6
    RAPTORSTEER_InsideAttack,       // 7
    RAPTORSTEER_Breakoff,           // 8
    RAPTORSTEER_MoveToSafety,       // 9
    RAPTORSTEER_Spitting,           // 10
    RAPTORSTEER_FastAttack,         // 11
    RAPTORSTEER_ScriptWalk,         // 12
    RAPTORSTEER_ScriptJog,          // 13
    RAPTORSTEER_ScriptRun,          // 14
    RAPTORSTEER_ScriptWalkNoAvoid,  // 15
    RAPTORSTEER_ScriptJogNoAvoid,   // 16
    RAPTORSTEER_ScriptRunNoAvoid,   // 17
    RAPTORSTEER_MAX                 // 18
};

enum ERaptorGoal
{
    RAPTORGOAL_InsideAttackEnemy,   // 0
    RAPTORGOAL_PostMaulDelay,       // 1
    RAPTORGOAL_InvestigateFlare,    // 2
    RAPTORGOAL_Investigate,         // 3
    RAPTORGOAL_Wander,              // 4
    RAPTORGOAL_Idle,                // 5
    RAPTORGOAL_SpitAttack,          // 6
    RAPTORGOAL_HoldForSpitAttack,   // 7
    RAPTORGOAL_MAX                  // 8
};

struct native SpeedVarianceEntry
{
    var() float mSpeed;
    var() int mStartChance;
    var() int mEndChance;
    var() float mMaxTime;

    structdefaultproperties
    {
        mSpeed=1.0000000
        mStartChance=50
        mEndChance=50
        mMaxTime=1.0000000
    }
};

struct native SpeedVariance
{
    var() float mTime;
    var() int mChance;
    var() array mEntry;

    structdefaultproperties
    {
        mTime=1.0000000
        mChance=50
        mEntry=/* Array type was not detected. */
    }
};

var(ScriptedAttacks) array mCloseStationaryAttacks;
var(ScriptedAttacks) array mMediumStationaryAttacks;
var(ScriptedAttacks) array mFarStationaryAttacks;
var(ScriptedAttacks) array mSpecialStationaryAttacks;
var(ScriptedAttacks) float mScriptedAttackDistance;
var(ScriptedAttacks) float mScriptedAttackMediumDistance;
var(ScriptedAttacks) float mScriptedAttackFarDistance;
var(ScriptedAttacks) float mScriptedAttackMinAttacks;
var(ScriptedAttacks) float mScriptedAttackMaxAttacks;
var() config int mMaxAttackingRaptors;
var() @NULL mSpeedVariance;
var bool mbPerformCameraCollision;

function EnableSmashDamage()
{
    ActivateSkeletalHurt(5, 0.0000000, 30.0000000, 1.0000000, -1.0000000, false, true, 1.0000000);
    //return;    
}

function EnableMaulSmashDamage()
{
    ActivateSkeletalHurt(8, 0.0000000, 30.0000000, 1.0000000, -1.0000000, false, true, 1.0000000);
    //return;    
}

simulated function PostBeginPlay()
{
    super(TurokPawn).PostBeginPlay();
    EnableSmashDamage();
    //return;    
}

event TakeDamage(int Damage, @NULL InstigatedBy, @NULL HitLocation, @NULL Momentum, class<Class> DamageType, optional @NULL HitInfo, optional @NULL DamageCauser)
{
    // End:0x2B
    if((TurokAIControllerGiganoto(InstigatedBy) != none) && Damage > 5)
    {
        Damage = Health;
    }
    super(TurokPawn).TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    //return;    
}

defaultproperties
{
    mSpeedVariance=(mTime=1.0000000,mChance=50,mEntry=/* Array type was not detected. */)
    // Reference: TurokRadialShakeComponent'Default__TurokPawnRaptorNative.Shakey'
    begin object name=Shakey
    end object
    mFootStompCamShake=Shakey
    mFlareTargetDist=130.0000000
    // Reference: TurokAISteer'Default__TurokPawnRaptorNative.TurokAISteerComponent'
    begin object name=TurokAISteerComponent
        mbHackcelerateOnOneWayPaths=true
        mMinSteerSpeedRate=0.1000000
        mDefaultMinSpeedInterpRate=8.0000000
        mSteeringDecelerationRate=0.0150000
        mSteeringPreset=/* Array type was not detected. */
        mDefaultWallAvoidanceDistanceForward=150.0000000
        mDefaultWallAvoidanceDistanceSide=150.0000000
    end object
    mSteer=TurokAISteerComponent
    // Reference: TurokAIPlanner'Default__TurokPawnRaptorNative.TurokAIPlannerComponent'
    begin object name=TurokAIPlannerComponent
        mAIGoal=/* Array type was not detected. */
        mSortedGoals=true
    end object
    mPlanner=TurokAIPlannerComponent
    // Reference: DynamicLightEnvironmentComponent'Default__TurokPawnRaptorNative.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: TurokPathController'Default__TurokPawnRaptorNative.TurokPathControllerComponent'
    begin object name=TurokPathControllerComponent
    end object
    mPathController=TurokPathControllerComponent
    // Reference: TurokTargetingSystem'Default__TurokPawnRaptorNative.TurokTargetingSystemComponent'
    begin object name=TurokTargetingSystemComponent
    end object
    mTargetingSystem=TurokTargetingSystemComponent
    // Reference: TurokSoundController'Default__TurokPawnRaptorNative.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent
    end object
    mSoundController=TurokSoundControllerComponent
    mPartialRagdollFixedJoints=/* Array type was not detected. */
    mRecoveryPlaneJoints=/* Array type was not detected. */
    mCollisionEventJoints=/* Array type was not detected. */
    mSkeletalHurt=/* Array type was not detected. */
    // Reference: TurokAnimLadderController'Default__TurokPawnRaptorNative.ladderController'
    begin object name=ladderController
    end object
    mLadderController=ladderController
    // Reference: SkeletalMeshComponent'Default__TurokPawnRaptorNative.TurokSkeletalMeshComponent'
    begin object name=TurokSkeletalMeshComponent
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokPawnRaptorNative.MyLightEnvironment'
    end object
    Mesh=TurokSkeletalMeshComponent
    // Reference: CylinderComponent'Default__TurokPawnRaptorNative.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    // Reference: ArrowComponent'Default__TurokPawnRaptorNative.Arrow'
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