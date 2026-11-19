class TurokPawnDino extends TurokPawn
    abstract
    native
    nativereplication
    config(Pawn)
    hidecategories(Navigation);

const NUM_DIFFICULTY_LEVELS = 3;

var(AimAsset) @NULL mAimAsset;
var() float mMaxStationaryAttackDistance;
var() float mStationaryAttackTurnTolerance;
var(AimAsset) name mAimAssetBone;
var @NULL mMotionGraphSet;
var @NULL mAttackGraphSet;
var @NULL mMiscGraphSet;
var @NULL mMeleeGraphSet;
var @NULL mStartStopGraphSet;
var @NULL mFleeGraphSet;
var @NULL mDOTReactionGraphSet;
var @NULL mAttackTurnGraphSet;
var @NULL mFinishingMovesGraphSet;
var float mTurnToRunClearDist;
var(Melee) float mMaulMeterDistance;
var(Melee) config float mMaulTimeBetweenAttacksScalar;
var(Melee) config float mMaulTimeToFillScalar;
var() float mEvasionRange;
var() config float mMinAttackDelay;
var() config float mMaxAttackDelay;
var bool mbStationaryTurnsOnly;
var(TailAttack) bool mTailAttackEnable;
var(FootStomp) bool mFootStompDamageEnable;
var(FootStomp) bool mFootStompKnockdownEnable;
var(FootStomp) bool mFootStompCamShakeEnable;
var() bool mCheckForPathTurns;
var(Stun) config bool mbStunOnlyOnExplosiveDamage;
var bool mbHasBeenStunned;
var bool mbInStunInvulnerableState;
var bool mbIsStunned;
var() config bool mbDamageInterruptsWatchFlareState;
var int mMaxAttackCacheHits;
var(TailAttack) float mTailAttackRadius;
var(TailAttack) float mTailAttackDamage;
var(TailAttack) float mTailAttackImpulseScale;
var(FootStomp) float mFootStompDamageRadius;
var(FootStomp) float mFootStompDamage;
var(FootStomp) float mFootStompMomentum;
var(FootStomp) const export editinline @NULL mFootStompCamShake;
var(Luring) float mFlareOverrideCurrentTargetDistance;
var(Luring) int mMaxDinosAllowedToReachFlare;
var(Luring) float mFlareTargetDist;
var(AttackFormation) export editinline @NULL mAttackFormation;
var(AttackFormation) editconst config float mAttackFormationSpacing;
var(AttackFormation) editconst config float mAttackFormationStartDistance;
var(AttackFormation) editconst config @NULL mAttackFormationAngle;
var(AttackFormation) editconst config int mAttackFormationRankNumbers;
var(AttackFormation) editconst config float mAttackFormationUpdatePeriod;
var(AttackFormation) editconst config float mAttackFormationGoalRadius;
var(AttackFormation) config int mMaxAttackers;
var() float mMinBreakoffDistance;
var() float mMaxBreakoffDistance;
var() config float mFleeDistance;
var() float mTurnTolerance;
var() float mHopbackDistance;
var(Stun) config float mMinStunTime;
var(Stun) config float mMaxStunTime;
var(Stun) config float mStunInvulnerabilityTime;
var(Stun) config float mStunNoDamageTime;
var(Stun) config float mStunRecoveryHealthBoost;
var(Stun) @NULL mStunEntryGraphSet;
var(Stun) @NULL mStunCycleGraphSet;
var(Stun) @NULL mStunExitGraphSet;
var(Stun) name mStunEntryGraphName;
var(Stun) name mStunCycleGraphName;
var(Stun) name mStunExitGraphName;
var() config float mIgnoreFlareRangeFromEnemy;
var(Senses) config @NULL mSensesIdle;
var(Senses) config @NULL mSensesInvestigate;
var(Senses) config @NULL mSensesAttack;
var(Execute) config float mFrontFinishingMoveRadius;
var(Execute) config float mBackFinishingMoveRadius;
var protected array mMeleeAttackGraphSetNames;
var @NULL mFleeLocation;
var config float mAdaptiveLagTimeModifier[3];
var name mNextStateName;
var() config float mHeadTrackInterpSpeed;
var() config float mFlareResponseIntervalTime;
var int mUpdateDinoIndex;

replication
{
    // Pos:0x000
    if(bNetDirty
        mbIsStunned;
}

function AdjustDamage(out int inDamage, out @NULL Momentum, @NULL InstigatedBy, @NULL HitLocation, class<Class> DamageType, optional @NULL HitInfo)
{
    super.AdjustDamage(inDamage, Momentum, InstigatedBy, HitLocation, DamageType, HitInfo);
    // End:0x35
    if(mbInStunInvulnerableState)
    {
        inDamage = 0;
    }
    //return;    
}

// Export UTurokPawnDino::execPickTurnAnim(FFrame&, void* const)
native function bool PickTurnAnim(int Angle, out @NULL pGraph, optional bool bRunning);

// Export UTurokPawnDino::execPickStartAnim(FFrame&, void* const)
native function bool PickStartAnim(float Speed, out @NULL pGraph, out name graphName, optional float endSpeedTolerance);

// Export UTurokPawnDino::execPickStopAnim(FFrame&, void* const)
native function bool PickStopAnim(float Speed, out @NULL pGraph, optional float startSpeedTolerance, optional bool bSearchPhase);

// Export UTurokPawnDino::execCheckForTurnOnPath(FFrame&, void* const)
native function bool CheckForTurnOnPath();

// Export UTurokPawnDino::execOnGraphStart(FFrame&, void* const)
native function OnGraphStart(@NULL Start);

// Export UTurokPawnDino::execOnGraphEndToLoco(FFrame&, void* const)
native function OnGraphEndToLoco(@NULL End, @NULL locoAsset, @NULL Params, float residualTick, byte actorType);

// Export UTurokPawnDino::execAttachDefaultAnimations(FFrame&, void* const)
protected native function AttachDefaultAnimations();

// Export UTurokPawnDino::execTryPlayFootStepSound(FFrame&, void* const)
native simulated function TryPlayFootStepSound(name JointName);

event SendFootstepCameraShake()
{
    Class'TurokRadialParametricShake'.static.BroadcastRadialShake(self, mFootStompCamShake);
    //return;    
}

function TakeFallingDamage()
{
    //return;    
}

function ShowAttackContactPoints(@NULL HUD)
{
    //return;    
}

event Touch(@NULL Other, @NULL HitLocation, @NULL HitNormal)
{
    super.Touch(Other, HitLocation, HitNormal);
    // End:0x75
    if(int(Physics) == int(12))
    {
        // End:0x75
        if(TurokPawnMiniGunAutoTurretNative(Other) != none)
        {
            TurokPawnMiniGunAutoTurretNative(Other).TakeDamage(Health, none, Other.Location, vect(0.0000000, 0.0000000, 9.0000000), Class'Engine.DmgType_Suicided');
        }
    }
    //return;    
}

state MeleeAttackAnimation extends CannedAnimation
{
    simulated function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
        Velocity = vect(0.0000000, 0.0000000, 0.0000000);
        mbEnableImpactAnims = false;
        DeActivateSkeletalHurt(5);
        // End:0x83
        if(Controller != none)
        {
            mNextStateName = 'StealthKillAnimation';
            Controller.GotoState('StealthKillAnimation');
            Controller.bGodMode = true;
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        // End:0x27
        if(Controller != none)
        {
            Controller.bGodMode = false;
        }
        // End:0x67
        if(int(Role) == int(ROLE_Authority))
        {
            global.TakeDamage(Health, mStealthKiller, Location, vect(0.0000000, 0.0000000, 0.0000000), Class'TurokDamageTypeStealthKill');            
        }
        else
        {
            // End:0x9A
            if(bPlayedDeath == false)
            {
                TearOffMomentum = vect(0.0000000, 0.0000000, 0.0000000);
                global.PlayDying(Class'TurokDamageTypeStealthKill', Location);
            }
        }
        //return;        
    }
    stop;    
}

defaultproperties
{
    mMaxStationaryAttackDistance=240.0000000
    mStationaryAttackTurnTolerance=45.0000000
    mAimAssetBone="jt_Spine1_C"
    mTurnToRunClearDist=350.0000000
    mMaulMeterDistance=600.0000000
    mTailAttackEnable=true
    mMaxAttackCacheHits=3
    mTailAttackRadius=100.0000000
    mTailAttackDamage=100.0000000
    mTailAttackImpulseScale=100.0000000
    mFootStompDamageRadius=150.0000000
    mFootStompDamage=50.0000000
    mFootStompMomentum=1000.0000000
    // Reference: TurokRadialShakeComponent'Default__TurokPawnDino.Shakey'
    begin object name=Shakey class=Class'TurokRadialShakeComponent'
        Duration=0.2500000
        Radius=1800.0000000
        mParams=(mRollAmplitude=1.5000000,mRollFrequency=4.0000000,mPitchAmplitude=2.0000000,mPitchFrequency=3.0000000,mYawAmplitude=2.3000000,mYawFrequency=3.0000000,mXAmplitude=0.0000000,mXFrequency=0.0000000,mYAmplitude=0.0000000,mYFrequency=0.0000000,mZAmplitude=2.5000000,mZFrequency=2.0000000)
    end object
    mFootStompCamShake=Shakey
    mFlareOverrideCurrentTargetDistance=800.0000000
    mMaxDinosAllowedToReachFlare=1
    mFlareTargetDist=100.0000000
    mMinBreakoffDistance=1500.0000000
    mMaxBreakoffDistance=5000.0000000
    mTurnTolerance=22.5000000
    mHopbackDistance=120.0000000
    mMeleeAttackGraphSetNames=/* Array type was not detected. */
    // Reference: TurokAISteer'Default__TurokPawnDino.TurokAISteerComponent'
    begin object name=TurokAISteerComponent
    end object
    mSteer=TurokAISteerComponent
    // Reference: TurokAIPlanner'Default__TurokPawnDino.TurokAIPlannerComponent'
    begin object name=TurokAIPlannerComponent
    end object
    mPlanner=TurokAIPlannerComponent
    // Reference: DynamicLightEnvironmentComponent'Default__TurokPawnDino.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    mbPlaysTurnAnimations=true
    // Reference: TurokPathController'Default__TurokPawnDino.TurokPathControllerComponent'
    begin object name=TurokPathControllerComponent
    end object
    mPathController=TurokPathControllerComponent
    // Reference: TurokTargetingSystem'Default__TurokPawnDino.TurokTargetingSystemComponent'
    begin object name=TurokTargetingSystemComponent
    end object
    mTargetingSystem=TurokTargetingSystemComponent
    // Reference: TurokSoundController'Default__TurokPawnDino.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent
    end object
    mSoundController=TurokSoundControllerComponent
    mFoleyOffset=0.0120000
    mGrassFootstepSound=SoundCue'SndBushInteraction.BushBig'
    mExplodeSndCue=SoundCue'SndDinoExplode.DinoExplodeASndCue'
    mBodyFallSndCue=SoundCue'SndCreatureDinosaurRaptorNEW.RaptorFallSnd'
    mBloodyPartSndCue=SoundCue'SndDinoExplode.DinoChunks'
    mArrowTakeDamageSndCue=SoundCue'SndProxy.SndProxy_DeathScream'
    mFireTakeDamageSndCue=SoundCue'SndProxy.SndProxy_DeathScream'
    // Reference: TurokAnimLadderController'Default__TurokPawnDino.ladderController'
    begin object name=ladderController
    end object
    mLadderController=ladderController
    bCanClimbLadders=false
    bSimulateGravity=true
    // Reference: SkeletalMeshComponent'Default__TurokPawnDino.TurokSkeletalMeshComponent'
    begin object name=TurokSkeletalMeshComponent
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokPawnDino.MyLightEnvironment'
    end object
    Mesh=TurokSkeletalMeshComponent
    // Reference: CylinderComponent'Default__TurokPawnDino.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    mDefaultTraceTypeFlags=0
    Components[0]=CollisionCylinder
    // Reference: ArrowComponent'Default__TurokPawnDino.Arrow'
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