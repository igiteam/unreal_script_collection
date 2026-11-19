class TurokPawn extends Pawn
    abstract
    native
    nativereplication
    config(Pawn)
    hidecategories(Navigation)
    implements(TurokAnimInterfaceGraphPlayback);

const LeashReturnTime = 2.0f;
const mCumulativeDamageFrames = 450;

enum ETerrainFollowType
{
    ETFT_None,                      // 0
    ETFT_Biped,                     // 1
    ETFT_BipedLong,                 // 2
    ETFT_Quadraped,                 // 3
    ETFT_MAX                        // 4
};

enum EPoweredRagdollState
{
    EPRS_None,                      // 0
    EPRS_StandingDeath,             // 1
    EPRS_MovingDeath,               // 2
    EPRS_ExplosionDeath,            // 3
    EPRS_BluntTraumaDeath,          // 4
    EPRS_ArrowDeath,                // 5
    EPRS_StealthKillDeath,          // 6
    EPRS_ReactionAnimation,         // 7
    EPRS_KnockdownAnimation,        // 8
    EPRS_DriveToRecoveryAnimation,  // 9
    EPRS_RecoveryAnimation,         // 10
    EPRS_MAX                        // 11
};

enum EFootType
{
    FT_Left,                        // 0
    FT_Right,                       // 1
    FT_MAX                          // 2
};

struct native SkeletalHurtInfo
{
    var() const byte mHurtType;
    var() const class<Class> mHurtDamageType;
    var() const array mHurtBoneNames;
    var transient float mHurtRadius;
    var transient float mHurtDamage;
    var transient float mHurtMomentum;
    var transient array mHurtActors;
    var transient bool mbCauseKnockdown;
    var transient bool mShowDebug;
    var transient bool mbActive;
    var transient float mActiveUntilTime;
    var transient float mResetHurtActorsInterval;
    var transient float mResetHurtActorsTime;
    var transient bool mbColliding;

    structdefaultproperties
    {
        mHurtType=0
        mHurtDamageType=Class'TurokDamageType'
        mHurtBoneNames=none
        mHurtRadius=0.0000000
        mHurtDamage=0.0000000
        mHurtMomentum=0.0000000
        mHurtActors=none
        mbCauseKnockdown=false
        mShowDebug=false
        mbActive=false
        mActiveUntilTime=0.0000000
        mResetHurtActorsInterval=0.0000000
        mResetHurtActorsTime=0.0000000
        mbColliding=false
    }
};

struct native KnockdownRecoveryPose
{
    var @NULL mRecoveryGraph;
    var @NULL mPlaneNormal;
    var @NULL mPoint0;
    var @NULL mPoint1;
    var @NULL mPoint2;

    structdefaultproperties
    {
        mRecoveryGraph=none
        mPlaneNormal=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        mPoint0=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        mPoint1=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        mPoint2=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

struct native ActorReachableInfo
{
    var int mReachable;
    var float mTime;
    var @NULL mLocation;
    var @NULL mReachableLoc;

    structdefaultproperties
    {
        mReachable=0
        mTime=0.0000000
        mLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        mReachableLoc=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

struct native CumulativeDamageTracking
{
    var int mDamage;
    var float mTimestamp;

    structdefaultproperties
    {
        mDamage=0
        mTimestamp=0.0000000
    }
};

struct native SensesOverride
{
    var float mHearingThreshold;
    var float mSightRadius;
    var float mPeripheralVision;

    structdefaultproperties
    {
        mHearingThreshold=0.0000000
        mSightRadius=0.0000000
        mPeripheralVision=0.0000000
    }
};

var(Steer) export editinline @NULL mSteer;
var(Planner) export editinline @NULL mPlanner;
var(Locomotion) @NULL mLocoTemplate;
var array mFences;
var export editinline @NULL LightEnvironment;
var config name mPawnName;
var(Debug) private transient bool mDebugShowHurtRadius;
var private const transient bool mbRagdollStateChangePending;
var private transient bool mbPlayedDeathAnimation;
var private transient bool mbCanBeKnockedDownByArrows;
var private transient bool mbCinematicActor;
var protected @NULL mLookTarget;
var protected @NULL mLookTargetGoal;
var protected @NULL mLookDir;
var(IdleHeadTracking) float mUpdateRange;
var(IdleHeadTracking) float mLookSphereRadius;
var(IdleHeadTracking) float mRandomSphereRadius;
var(IdleHeadTracking) float mWeightCurrent;
var(IdleHeadTracking) float mWeightTarget;
var(IdleHeadTracking) float mAngleThreshold;
var(IdleHeadTracking) float mLookSphereDistance;
var(IdleHeadTracking) float mLookSphereHeight;
var protected repnotify byte mDesiredMoveMode;
var protected const byte mReplicatedStunFactor;
var(TerrainFollowing) const byte mTerrainFollowType;
var protected repnotify byte mAltMaterialIndex;
var const byte mAnimState;
var protected repnotify byte mAnimInterruptToLocoFlag;
var(ImpactSystem) export editinline @NULL mImpactSystem;
var(HealthSystem) @NULL mHealthAsset;
var bool mbEnableImpactAnims;
var protected bool mbIsMauling;
var private bool mbIsDying;
var(DeadBodyManager) bool mbUseDeadBodyManager;
var repnotify bool mIsOnFire;
var(OnFire) bool mFlammable;
var bool mbCanTriggerSounds;
var(Leaning) bool mbUseDesiredSpeed;
var bool mbCumulativeDamageResetPending;
var(HitReaction) bool mbAllowRagdollFromSkeletalHurtDamage;
var bool mbStuckToWorld;
var bool mbDraggedByArrow;
var(Mauling) protected const bool mbAllowDinoMelee;
var(PoweredRagdoll) const bool mbUsePoweredRagdoll;
var(Luring) bool mbFlareAvoid;
var bool mIsInStealthPocket;
var bool mValidTarget;
var bool mbPlaysTurnAnimations;
var bool mbHasFlareAttached;
var(LureAchievement) bool mbHasHadFlareAttachedRecently;
var bool mbStealthKillTriggersEventOnly;
var bool mCanBeStealthKilled;
var protected bool mIdleTrackingEnabled;
var protected const bool mbReplicateTransitionGraph;
var bool mbConsiderAnchorCostsWhenPathing;
var bool mbFavourPathsAhead;
var bool mbDoFullPathSkipCheck;
var bool mDetectedBadSkipAhead;
var() config bool mbRespectKnockdownTimer;
var bool mbSkelHurtTraceAllComponents;
var float mAnimScrubPercent;
var(PathFinding) export editinline @NULL mPathController;
var(Targeting) export editinline @NULL mTargetingSystem;
var(Movement) config float mBaseGroundSpeed;
var(Movement) const float mBaseWaterSpeed;
var(Movement) const float mBaseAirSpeed;
var(Movement) const float mBaseLadderSpeed;
var(Movement) const float mBaseAccelRate;
var(Movement) const float mUnarmedMoveBonus;
var(Movement) config float mForwardMoveFactor;
var(Movement) config float mRearMoveFactor;
var(Movement) const float mLandPenalty;
var private int mLastDamage;
var private @NULL mHitInfo;
var array mHitByList;
var private @NULL mHitBy;
var array mArrowsStuckToMe;
var(Health) config int mDefaultHealth;
var() const int mDamageReactionHealth;
var(DeadBodyManager) float mfSinkBodySpeed;
var(DeadBodyManager) config float mfCoolDownSeconds;
var(DeadBodyManager) config float mfRagdollSleepTimeout;
var(DeadBodyManager) config float mfRagdollRetryTimer;
var float mfSinkDist;
var(DeadBodyManager) @NULL mSinkPS;
var @NULL mpSinkEmitter;
var protected repnotify @NULL mFireLocation;
var float mBurnTimeRemaining;
var(OnFire) config float mMaxBurnTime;
var(OnFire) config float mInitialBurnTime;
var(OnFire) config float mNapalmBurnTime;
var(OnFire) config float mAddNapalmBurnTime;
var(OnFire) config float mAdditionalBurnTime;
var(OnFire) int mNumFireStrikes;
var(OnFire) config int mMaxFireStrikes;
var(OnFire) @NULL mFlamePS;
var(OnFire) array mFlameBones;
var(OnFire) config int mMaxNumFlames;
var(OnFire) float mFlameEmitterScale;
var(OnFire) float mFireDamageInterval;
var(OnFire) config int mFireDamage;
var @NULL mFireHitInfo;
var array mFlameEmitters;
var @NULL mFireInstigator;
var float mLastFlameSpawnTime;
var float mMinTimeBetweenFlameSpawn;
var float mTazerStunTime;
var(TazerStun) float mMaxTazerStunTime;
var protected transient @NULL mAnimController;
var export editinline @NULL mSoundController;
var int mWeaponAmbientSndChannelIndex;
var(Sound) float mFoleyOffset;
var array mFoleySounds;
var(Sound) @NULL mGrassFootstepSound;
var(Sound) float mMinGrassSoundThresh;
var(Sound) protected const float mMaxFootstepDistance;
var int mPawnIdleSndChannel;
var @NULL mPawnIdleSoundCue;
var int mPawnAmbientSndChannel;
var @NULL mPawnAmbientSoundCue;
var(Sound) config float mMinBodyFallVelocityVol;
var(Sound) config float mMaxBodyFallVelocityVol;
var(Sound) config float mMinBodyChunkVelocityVol;
var(Sound) config float mMaxBodyChunkVelocityVol;
var(Sound) float mImpactNoiseLevel;
var export editinline array mWeaponAudioComponent;
var int mWeaponACIndex;
var const int mMaxWeaponImpactAC;
var export editinline array mWeaponImpactAudioComponent;
var int mWeaponImpactACIndex;
var @NULL mExplodeSndCue;
var @NULL mBodyFallSndCue;
var @NULL mBloodyPartSndCue;
var @NULL mTakeDamageSndCue;
var @NULL mJumpSndCue;
var @NULL mGearSndCue;
var(Sound) @NULL mDeathSndCue;
var(Sound) @NULL mExertionSndCue;
var(Sound) @NULL mGruntSndCue;
var @NULL mBurningSndCue;
var @NULL mArrowTakeDamageSndCue;
var @NULL mFireTakeDamageSndCue;
var float mMinDamagePcntToTriggerAudio;
var float mSpawnSoundEnableDelay;
var(Footstep) editinline array mFootStepEffects;
var(Noise) config float mMinFootstepNoiseLevel;
var(Noise) config float mMaxFootstepNoiseLevel;
var(Sound) float mMinFootstepVolume;
var(Leaning) int mMaxLeanAngle;
var(Leaning) int mMinLeanYaw;
var(Leaning) int mMaxLeanYaw;
var(Leaning) float mMinLeanSpeed;
var(Leaning) float mMaxLeanSpeed;
var(Leaning) float mLeanNormalBlendSpeed;
var(Leaning) float mLeanFastBlendSpeed;
var(Leaning) float mLeanOffBlendSpeed;
var int mLastLeanAngle;
var int mLastYaw;
var(AI) float mLeashRadius;
var float mLeashReturnTimer;
var @NULL mCumulativeDamage[450];
var int mCumulativeDamagePtr;
var float mDamageThresholdCheckTime;
var float mPendingResetCumulativeDamageTime;
var protected const float mStunMovementFactor;
var(HitReaction) config float mStunMovementRecoveryRate;
var(HitReaction) config float mStunMultiplier;
var(HitReaction) config float mMaxStunMovementFactor;
var(HitReaction) float mStunDamageTime;
var(HitReaction) config float mDamageTime;
var(HitReaction) config int mDamageThreshold;
var(HitReaction) float mCumulativeDamageResetTime;
var private @NULL mInitialLocation;
var @NULL mStickingArrow;
var float mTurnAngle;
var @NULL mTurnDiff;
var float mTurnDistSq;
var() float mSmallestStandingTurnAnim;
var() float mSmallestRunningTurnAnim;
var(Jump) const float mHorizontalJumpModifier;
var(Jump) const float mVerticalJumpModifier;
var(Jump) const float mHorizontalSpeedJumpModifier;
var(Jump) const float mVerticalSpeedJumpModifier;
var(Mauling) protected const class<Class> mMaulDamageType;
var(TerrainFollowing) const float mTerrainSampleRadius;
var(TerrainFollowing) const float mTerrainSinkHeight;
var private const transient float mTerrainHeight;
var private const transient @NULL mTerrainFollowRot;
var private const transient @NULL mTerrainNormal;
var(TerrainFollowing) private float mTerrainFollowRayLengthMultiplier;
var private const array mPartialRagdollFixedJoints;
var private const array mRecoveryPlaneJoints;
var private const array mCollisionEventJoints;
var private const transient byte mRagdollState;
var private const transient byte mPendingRagdollState;
var private const transient float mMotorStrength;
var private const transient float mMaxMotorStrength;
var private transient float mPowerDuration;
var private const transient float mMotorRampInRate;
var private const transient float mMotorRampOutRate;
var private const transient int mActiveRecoveryPose;
var private const transient array mRecoveryPoses;
var config float mRBExplosionForceModifier;
var protected transient array mMaterialInstances;
var protected const @NULL mGorePhysicsAsset;
var protected const @NULL mGoreSkeletalMesh;
var protected const @NULL mGoreImpactParticle;
var protected const @NULL mGoreTrailerParticle;
var protected const array mGoreTrailerBones;
var protected config array mAltMaterialTint;
var protected const config float mMaxDamageRevealLevel;
var protected const config float mGibDamageRevealLevel;
var(SkeletalHurt) const array mSkeletalHurt;
var private @NULL mMPAISpawnTarget;
var private @NULL mMPAISpawnPoint;
var(Luring) int mMaxCombatFlareDistractions;
var(Luring) config float mFlareAvoidRadius;
var int mCombatFlareDistractions;
var(Terror) int mMaxTerror;
var(Terror) int mCurrTerror;
var export editinline @NULL mCurrentGrassField;
var @NULL mGrassCollisionVolumes;
var name mGrassCollVolName;
var protected @NULL mPainVolume;
var float mVisibility;
var float mFindAnchorTime;
var(IdleNodes) config float mMinIdleNodeDistance;
var(IdleNodes) config float mMaxIdleNodeDistance;
var(LureAchievement) float mFlareTrackingTime;
var(AimAssist) config float mAimAssistSphereSize;
var(AimAssist) config float mReticulePctFromCentre;
var float mAimAssistDistFromTargetCentre;
var float mRecoveryAnimDuration;
var float mRecoveryAnimTime;
var() config int mSmoothedSteeringFrames;
var config float mBumpNoise;
var protected const transient float mNetAutonomousTime;
var protected const transient @NULL mNetLocationCorrection;
var protected const transient @NULL mNetRotationCorrection;
var protected const config float mSmoothCorrectionTolerance;
var protected const config float mSmoothCorrectionPositionSpeed;
var protected const config float mSmoothCorrectionRotationSpeed;
var protected @NULL mSpatialTarget;
var protected @NULL mSpatialTargetActor;
var protected repnotify @NULL mReplicatedGraph;
var protected repnotify @NULL mLadderVolume;
var export editinline @NULL mLadderController;
var float mMaxGameSpeedModifier;
var const float mPawnCollisionRadius;
var int mExtentUpdateIndex;
var array mExtentBones;
var array mExtentBoneIndices;
var array mExtents;
var private @NULL mLastPointReachable;
var private native transient @NULL mReachables;
var() private float mReachableValidTime;
var() int mIdleNodeSelectionChance;
var() int mIdleNodeCoolDown;
var @NULL mLastInterestPoint;
var float mForceReachNodeDist;
var name mJumpUpGraphName;
var name mJumpDownGraphName;
var name mJumpOverGraphName;
var name mRunOutRightGraphName;
var name mRunOutLeftGraphName;
var name mCurrentGraphName;
var @NULL mTerrorGraphSet;
var @NULL mClimbingGraphSet;
var @NULL mJumpGraphSet;
var @NULL mRunGraphSet;
var @NULL mIdleGraphSet;
var @NULL mRecoveryGraphSet;
var @NULL mMaulGraphSet;
var(Ledge) float mScanDistance;
var(Ledge) float mLeapTriggerDistance;
var @NULL mLastBadAnchor;
var @NULL mStealthKiller;
var(Decals) @NULL mBloodDecal;
var(Decals) float mBloodDecalMaxDistance;
var(Decals) float mBloodDecalMaxSize;
var(Decals) float mBloodDecalMinSize;
var(Decals) float mBloodDecalLastTime;
var @NULL mRagdollStartPosition;
var int mUpdatePawnIndex;
var float mAIUsageCost;

replication
{
    // Pos:0x000
    if(bNetDirty && !bNetOwner
        mAltMaterialIndex, mAnimInterruptToLocoFlag, 
        mBurnTimeRemaining, mDesiredMoveMode, 
        mFireLocation, mIdleTrackingEnabled, 
        mIsOnFire, mLadderVolume, 
        mReplicatedGraph, mReplicatedStunFactor, 
        mSpatialTargetActor;
}

// Export UTurokPawn::execGetLocoActiveState(FFrame&, void* const)
native function byte GetLocoActiveState();

// Export UTurokPawn::execGetFootStepVolume(FFrame&, void* const)
native function float GetFootStepVolume(float Speed, optional name JointName);

// Export UTurokPawn::execTryPlayFootStepSound(FFrame&, void* const)
native function TryPlayFootStepSound(name JointName);

// Export UTurokPawn::execPlayLandSound(FFrame&, void* const)
native final function PlayLandSound(float VelocityMult);

// Export UTurokPawn::execApplyBloodDecal(FFrame&, void* const)
native final function ApplyBloodDecal(@NULL Direction);

// Export UTurokPawn::execEnableSoundTriggerTimed(FFrame&, void* const)
native function EnableSoundTriggerTimed();

// Export UTurokPawn::execGetLocalPlayerController(FFrame&, void* const)
native function @NULL GetLocalPlayerController();

// Export UTurokPawn::execInitMovementPhysics(FFrame&, void* const)
native function InitMovementPhysics(float DeltaTime);

// Export UTurokPawn::execInitiateLocalImpact(FFrame&, void* const)
native function bool InitiateLocalImpact(class<Class> DamageType, @NULL Momentum, @NULL HitLoc, @NULL HitInfo);

// Export UTurokPawn::execInitiateDeathAnim(FFrame&, void* const)
native function bool InitiateDeathAnim(class<Class> DamageType, @NULL Momentum, @NULL HitLoc, @NULL HitInfo);

// Export UTurokPawn::execTriggerGore(FFrame&, void* const)
native final function TriggerGore();

// Export UTurokPawn::execGetHitBodyPart(FFrame&, void* const)
native function byte GetHitBodyPart(@NULL HitInfo);

// Export UTurokPawn::execGetDamageScale(FFrame&, void* const)
native function float GetDamageScale(@NULL HitInfo, class<Class> DamageType);

// Export UTurokPawn::execGetImpactMaterial(FFrame&, void* const)
native function @NULL GetImpactMaterial(@NULL P, @NULL HitInfo);

// Export UTurokPawn::execAddToDeadBodyManager(FFrame&, void* const)
native function AddToDeadBodyManager();

// Export UTurokPawn::execIsSteeringActive(FFrame&, void* const)
native function bool IsSteeringActive();

// Export UTurokPawn::execCheckEndLocation(FFrame&, void* const)
native function CheckEndLocation();

// Export UTurokPawn::execGetChildBoneNames(FFrame&, void* const)
native final function GetChildBoneNames(name BoneName, @NULL SkelMesh, out array childBoneNames);

// Export UTurokPawn::execSetAnchor(FFrame&, void* const)
native function SetAnchor(@NULL NewAnchor);

// Export UTurokPawn::execIsDamageTypePlayerOnly(FFrame&, void* const)
native function bool IsDamageTypePlayerOnly(class<Class> DamageType);

// Export UTurokPawn::execGetMaxSpeedModifier(FFrame&, void* const)
native function float GetMaxSpeedModifier();

// Export UTurokPawn::execGetCurrentSpeedModifier(FFrame&, void* const)
native function float GetCurrentSpeedModifier();

// Export UTurokPawn::execSetStunMovementFactor(FFrame&, void* const)
native function SetStunMovementFactor(float StunFactor);

// Export UTurokPawn::execGetProjectileAttachmentSpeedModifier(FFrame&, void* const)
native function float GetProjectileAttachmentSpeedModifier();

// Export UTurokPawn::execEmptyReachablesMap(FFrame&, void* const)
native final function EmptyReachablesMap();

// Export UTurokPawn::execInitPawnForDragging(FFrame&, void* const)
native function InitPawnForDragging(name BoneName);

// Export UTurokPawn::execReleasePawnFromSticking(FFrame&, void* const)
native function ReleasePawnFromSticking(name BoneName);

// Export UTurokPawn::execIsDying(FFrame&, void* const)
native function bool IsDying();

// Export UTurokPawn::execIsMauling(FFrame&, void* const)
native function bool IsMauling();

// Export UTurokPawn::execDrawAnimState3D(FFrame&, void* const)
native final function DrawAnimState3D(@NULL HUD);

// Export UTurokPawn::execDrawPawnState3D(FFrame&, void* const)
native final function DrawPawnState3D(@NULL HUD);

// Export UTurokPawn::execSetActionActor(FFrame&, void* const)
native final function SetActionActor(@NULL Actor);

// Export UTurokPawn::execSetActionLocation(FFrame&, void* const)
native final function SetActionLocation(@NULL pos, @NULL Rot);

// Export UTurokPawn::execPlayGraphLocal(FFrame&, void* const)
native final function PlayGraphLocal(@NULL graph, @NULL aiInterface, byte actorType);

// Export UTurokPawn::execPlayGraphReplicated(FFrame&, void* const)
native final function PlayGraphReplicated(@NULL graph, @NULL aiInterface, byte actorType);

// Export UTurokPawn::execPlayCannedAnimation(FFrame&, void* const)
native final function PlayCannedAnimation(name Anim, array AnimSets, float blendTime, bool bLoop, bool bMirror, optional float Rate);

// Export UTurokPawn::execPlayLocomotion(FFrame&, void* const)
protected native final function PlayLocomotion(@NULL asset, float blendTime, @NULL Params);

// Export UTurokPawn::execSetMovementMode(FFrame&, void* const)
native final function SetMovementMode(byte moveMode);

// Export UTurokPawn::execSimulatedSetMovementMode(FFrame&, void* const)
native final function SimulatedSetMovementMode(byte moveMode);

// Export UTurokPawn::execPlayTransitionGraph(FFrame&, void* const)
private native final function PlayTransitionGraph(@NULL graph, @NULL aiInterface, byte actorType);

// Export UTurokPawn::execOnGraphStart(FFrame&, void* const)
native function OnGraphStart(@NULL Start);

// Export UTurokPawn::execOnGraphEndToLoco(FFrame&, void* const)
native function OnGraphEndToLoco(@NULL End, @NULL locoAsset, @NULL Params, float residualTick, byte actorType);

// Export UTurokPawn::execOnGraphEndToGraph(FFrame&, void* const)
native function OnGraphEndToGraph(@NULL End, @NULL graph, float residualTick, byte actorType, @NULL aiInterface);

// Export UTurokPawn::execOnGraphSpatialTarget(FFrame&, void* const)
native function @NULL OnGraphSpatialTarget();

// Export UTurokPawn::execOnGraphActionLocation(FFrame&, void* const)
native function OnGraphActionLocation(@NULL Action, out @NULL pos, out @NULL Rot, byte actorType);

// Export UTurokPawn::execOnAnimStateChanged(FFrame&, void* const)
native function OnAnimStateChanged(byte NewState);

// Export UTurokPawn::execAttachDefaultAnimations(FFrame&, void* const)
protected native function AttachDefaultAnimations();

// Export UTurokPawn::execClearAnimAIInterface(FFrame&, void* const)
protected native final function ClearAnimAIInterface();

// Export UTurokPawn::execIsPlayingGraphFromGraphSet(FFrame&, void* const)
native final function bool IsPlayingGraphFromGraphSet(@NULL graphSet);

// Export UTurokPawn::execResetTerrainFollowOffset(FFrame&, void* const)
native function ResetTerrainFollowOffset();

// Export UTurokPawn::execSetMeshVisibility(FFrame&, void* const)
native function SetMeshVisibility(bool bIs3rdPerson);

// Export UTurokPawn::execApplyRBExplosionForces(FFrame&, void* const)
protected native final function ApplyRBExplosionForces(@NULL explosionOrigin, class<Class> DamageType);

// Export UTurokPawn::execPowerConstraints(FFrame&, void* const)
native final function PowerConstraints(byte State, float motorStrength, float Duration, float rampIn, float rampOut);

// Export UTurokPawn::execCanFreezeRagdoll(FFrame&, void* const)
protected native final function bool CanFreezeRagdoll();

// Export UTurokPawn::execFreezeRagdoll(FFrame&, void* const)
protected native final function FreezeRagdoll();

// Export UTurokPawn::execActivateSkeletalHurt(FFrame&, void* const)
native final function bool ActivateSkeletalHurt(byte hurtType, float hurtDamage, float HurtRadius, float hurtMomentum, float hurtDuration, bool causeKnockdown, optional bool bUsePhysics, optional float resetHurtActorsTime);

// Export UTurokPawn::execIsSkeletalHurtActive(FFrame&, void* const)
native final function bool IsSkeletalHurtActive(byte hurtType);

// Export UTurokPawn::execDeActivateSkeletalHurt(FFrame&, void* const)
native final function DeActivateSkeletalHurt(byte hurtType);

// Export UTurokPawn::execDeActivateAllSkeletalHurt(FFrame&, void* const)
native final function DeActivateAllSkeletalHurt();

// Export UTurokPawn::execIsSkeletalHurtColliding(FFrame&, void* const)
native final function bool IsSkeletalHurtColliding(byte hurtType);

// Export UTurokPawn::execCheckForInterestPoints(FFrame&, void* const)
native function CheckForInterestPoints(int checkNum);

// Export UTurokPawn::execGetBaseAimRotation(FFrame&, void* const)
native singular simulated function @NULL GetBaseAimRotation();

// Export UTurokPawn::execProcessViewRotation(FFrame&, void* const)
native simulated function ProcessViewRotation(float DeltaTime, out @NULL out_ViewRotation, out @NULL out_DeltaRot);

// Export UTurokPawn::execFaceRotation(FFrame&, void* const)
native simulated function FaceRotation(@NULL NewRotation, float DeltaTime);

// Export UTurokPawn::execGetCumulativeDamageTotal(FFrame&, void* const)
native function int GetCumulativeDamageTotal(float checkTime, float CurrentTime);

// Export UTurokPawn::execTouchedLevelStreamingVolume(FFrame&, void* const)
native function TouchedLevelStreamingVolume(@NULL streamingVolume);

// Export UTurokPawn::execUnTouchedLevelStreamingVolume(FFrame&, void* const)
native function UnTouchedLevelStreamingVolume(@NULL streamingVolume);

// Export UTurokPawn::execValidAnchor(FFrame&, void* const)
native function bool ValidAnchor();

// Export UTurokPawn::execIsInGrass(FFrame&, void* const)
native function bool IsInGrass();

// Export UTurokPawn::execIsFloorSteep(FFrame&, void* const)
native function bool IsFloorSteep();

// Export UTurokPawn::execGetCollisionRadius(FFrame&, void* const)
native simulated function float GetCollisionRadius();

// Export UTurokPawn::execHasFlareAttached(FFrame&, void* const)
native function bool HasFlareAttached();

// Export UTurokPawn::execCancelRagdollState(FFrame&, void* const)
native function CancelRagdollState();

// Export UTurokPawn::execCheckIfBeingEncroachedOn(FFrame&, void* const)
native function bool CheckIfBeingEncroachedOn();

// Export UTurokPawn::execCheckActionValidEndLocation(FFrame&, void* const)
native function bool CheckActionValidEndLocation();

// Export UTurokPawn::execEffectIsRelevant(FFrame&, void* const)
native simulated event bool EffectIsRelevant(@NULL SpawnLocation, bool bForceDedicated, optional float CullDistance);

// Export UTurokPawn::execPlayDeathSound(FFrame&, void* const)
native simulated function PlayDeathSound(byte DamageType, optional @NULL deathSound);

// Export UTurokPawn::execPlayExertionSound(FFrame&, void* const)
native simulated function PlayExertionSound();

// Export UTurokPawn::execPlayGruntSound(FFrame&, void* const)
native simulated function PlayGruntSound();

// Export UTurokPawn::execIsAttracted(FFrame&, void* const)
native function bool IsAttracted(@NULL Flare);

// Export UTurokPawn::execAllowMauling(FFrame&, void* const)
native simulated function bool AllowMauling();

simulated event ReplicatedEvent(name VarName)
{
    // End:0x42
    if(VarName == 'mReplicatedGraph')
    {
        // End:0x26
        if(mReplicatedGraph.mActionActorSet)
        {
        }
        // End:0x39
        if(mReplicatedGraph.mActionLocationSet)
        {
        }
        OnReplicatedGraphChanged();        
    }
    else
    {
        // End:0x6F
        if(VarName == 'mAnimInterruptToLocoFlag')
        {
            // End:0x6C
            if(int(mAnimInterruptToLocoFlag) != 0)
            {
                AnimInterruptToLoco();
            }            
        }
        else
        {
            // End:0x90
            if(VarName == 'mDesiredMoveMode')
            {
                SimulatedSetMovementMode(mDesiredMoveMode);                
            }
            else
            {
                // End:0xCD
                if(VarName == 'mLadderVolume')
                {
                    // End:0xC0
                    if(mLadderVolume != none)
                    {
                        ClimbLadder(mLadderVolume);                        
                    }
                    else
                    {
                        EndClimbing();
                    }                    
                }
                else
                {
                    // End:0x103
                    if(VarName == 'mIsOnFire')
                    {
                        // End:0xF6
                        if(mIsOnFire)
                        {
                            OnFireBegin();                            
                        }
                        else
                        {
                            OnFireEnd();
                        }                        
                    }
                    else
                    {
                        // End:0x141
                        if(VarName == 'mFireLocation')
                        {
                            // End:0x134
                            if(mFlameBones.Length == 0)
                            {
                                SpawnFlameEmitter(mFireLocation);                                
                            }
                            else
                            {
                                SpawnFlameEmitterAtBone();
                            }                            
                        }
                        else
                        {
                            // End:0x166
                            if(VarName == 'mAltMaterialIndex')
                            {
                                SetupAltMaterial(mAltMaterialIndex);                                
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
    }
    //return;    
}

function EnableSmashDamage()
{
    //return;    
}

function EnableMaulSmashDamage()
{
    //return;    
}

simulated event PostBeginPlay()
{
    mbCanTriggerSounds = false;
    super.PostBeginPlay();
    mGrassCollisionVolumes = TurokSkelControlCollisionVolume(Mesh.FindSkelControl(mGrassCollVolName));
    PlayAmbientSound();
    // End:0x5B
    if(mSpawnSoundEnableDelay > float(0))
    {
        SetTimer(mSpawnSoundEnableDelay, false, 'EnableSoundTriggerTimed');        
    }
    else
    {
        mbCanTriggerSounds = true;
    }
    SetupDamageReveal();
    // End:0xA8
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0xA8
        if(mAltMaterialTint.Length > 0)
        {
            mAltMaterialIndex = byte(Rand(mAltMaterialTint.Length));
            SetupAltMaterial(mAltMaterialIndex);
        }
    }
    //return;    
}

simulated event Destroyed()
{
    local int I;

    ClearAnimAIInterface();
    mbIsDying = true;
    I = 0;
    J0x15:

    // End:0x3C [Loop If]
    if(I < mMaterialInstances.Length)
    {
        mMaterialInstances[I] = none;
        ++I;
        // [Loop Continue]
        goto J0x15;
    }
    // End:0x9C
    if(!Class'TurokUtil'.static.IsMultiplayerGame())
    {
        I = 0;
        J0x57:

        // End:0x9C [Loop If]
        if(I < mArrowsStuckToMe.Length)
        {
            // End:0x92
            if(mArrowsStuckToMe[I] != none)
            {
                mArrowsStuckToMe[I].RemovePersistentArrowFromPawn(self);
            }
            ++I;
            // [Loop Continue]
            goto J0x57;
        }
    }
    // End:0xEA
    if(mpSinkEmitter != none)
    {
        mpSinkEmitter.ParticleSystemComponent.DeactivateSystem();
        mpSinkEmitter.ParticleSystemComponent.KillParticlesForced();
        mpSinkEmitter.Destroy();
        mpSinkEmitter = none;
    }
    super.Destroyed();
    //return;    
}

simulated event UnPossessed()
{
    ClearAnimAIInterface();
    super.UnPossessed();
    //return;    
}

simulated function Tick(float DeltaTime)
{
    super(Actor).Tick(DeltaTime);
    // End:0x53
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x53
        if(mIsOnFire)
        {
            mBurnTimeRemaining -= DeltaTime;
            // End:0x53
            if(mBurnTimeRemaining <= 0.0000000)
            {
                OnFireEndServer();
                OnFireEnd();
            }
        }
    }
    //return;    
}

event PostBeginPlayStreamed()
{
    // End:0x22
    if((Health > 0) && !bDontPossess)
    {
        SpawnDefaultControllerStreamed();
    }
    //return;    
}

function SpawnDefaultControllerStreamed()
{
    // End:0x0D
    if(Controller != none)
    {
        return;
    }
    // End:0x2C
    if(ControllerClass != none)
    {
        Controller = __NFUN_278__(ControllerClass, self);
    }
    // End:0x59
    if(Controller != none)
    {
        Controller.SetOwner(none);
        Controller.Possess(self, false);
    }
    //return;    
}

simulated function SetupDamageReveal()
{
    local float MaterialDamage;
    local @NULL MaterialAltColor;
    local int MaterialCount, MaterialInstanceIndex;

    MaterialInstanceIndex = 0;
    MaterialCount = 0;
    J0x0E:

    // End:0x16A [Loop If]
    if(MaterialCount < Mesh.GetNumElements())
    {
        // End:0x160
        if((Mesh.GetMaterial(MaterialCount) != none) && Mesh.GetMaterial(MaterialCount).GetScalarParameterValue('DmgdReveal', MaterialDamage) || Mesh.GetMaterial(MaterialCount).GetVectorParameterValue('VAltTint', MaterialAltColor))
        {
            // End:0x136
            if(mMaterialInstances.Length <= MaterialInstanceIndex)
            {
                mMaterialInstances[MaterialInstanceIndex] = new (self) Class'Engine.MaterialInstanceConstant';
                mMaterialInstances[MaterialInstanceIndex].SetParent(Mesh.GetMaterial(MaterialCount));
                Mesh.SetMaterial(MaterialCount, mMaterialInstances[MaterialInstanceIndex]);
            }
            mMaterialInstances[MaterialInstanceIndex].SetScalarParameterValue('DmgdReveal', 0.9990000);
            MaterialInstanceIndex++;
        }
        MaterialCount++;
        // [Loop Continue]
        goto J0x0E;
    }
    //return;    
}

simulated function SetupAltMaterial(byte AltMaterialIndex)
{
    local float MaterialDamage;
    local @NULL MaterialAltColor;
    local int MaterialCount, MaterialInstanceIndex;

    MaterialInstanceIndex = 0;
    // DebugMode: 0
    assert(int(AltMaterialIndex) < mAltMaterialTint.Length);
    mAltMaterialIndex = AltMaterialIndex;
    MaterialCount = 0;
    J0x2C:

    // End:0x19B [Loop If]
    if(MaterialCount < Mesh.GetNumElements())
    {
        // End:0x191
        if((Mesh.GetMaterial(MaterialCount) != none) && Mesh.GetMaterial(MaterialCount).GetScalarParameterValue('DmgdReveal', MaterialDamage) || Mesh.GetMaterial(MaterialCount).GetVectorParameterValue('VAltTint', MaterialAltColor))
        {
            // End:0x154
            if(mMaterialInstances.Length <= MaterialInstanceIndex)
            {
                mMaterialInstances[MaterialInstanceIndex] = new (self) Class'Engine.MaterialInstanceConstant';
                mMaterialInstances[MaterialInstanceIndex].SetParent(Mesh.GetMaterial(MaterialCount));
                Mesh.SetMaterial(MaterialCount, mMaterialInstances[MaterialInstanceIndex]);
            }
            MaterialAltColor = mAltMaterialTint[int(mAltMaterialIndex)];
            mMaterialInstances[MaterialInstanceIndex].SetVectorParameterValue('VAltTint', MaterialAltColor);
            MaterialInstanceIndex++;
        }
        MaterialCount++;
        // [Loop Continue]
        goto J0x2C;
    }
    //return;    
}

simulated function @NULL GetAnimController()
{
    return mAnimController;
    //return ReturnValue;    
}

simulated function byte GetRagdollState()
{
    return mRagdollState;
    //return ReturnValue;    
}

simulated event @NULL GetMaulGraphSet()
{
    return mMaulGraphSet;
    //return ReturnValue;    
}

simulated event bool ShouldApplyCameraReposition()
{
    return true;
    //return ReturnValue;    
}

simulated event AnimInterruptToLoco()
{
    local @NULL Params;

    // End:0xCC
    if(int(mAnimState) != int(1))
    {
        Params.mSpeed = VSize2D(Velocity);
        Params.mRelMoveAngle = Class'TurokUtil'.static.GetRelativeAngle(Class'TurokUtil'.static.GetRotation(Velocity), Rotation);
        Params.mPhase = 0.0000000;
        Params.mMovementMode = mDesiredMoveMode;
        PlayLocomotion(mLocoTemplate, 0.3300000, Params);
        // End:0xCC
        if(int(Role) == int(ROLE_Authority))
        {
            mAnimInterruptToLocoFlag = byte(float(int(mAnimInterruptToLocoFlag) + 1) % float(8));
        }
    }
    //return;    
}

simulated function LocalAnimInterruptToLoco()
{
    local @NULL Params;

    // End:0xA2
    if(int(mAnimState) != int(1))
    {
        Params.mSpeed = VSize2D(Velocity);
        Params.mRelMoveAngle = Class'TurokUtil'.static.GetRelativeAngle(Class'TurokUtil'.static.GetRotation(Velocity), Rotation);
        Params.mPhase = 0.0000000;
        Params.mMovementMode = mDesiredMoveMode;
        PlayLocomotion(mLocoTemplate, 0.3300000, Params);
    }
    //return;    
}

private final simulated function OnReplicatedGraphChanged()
{
    local @NULL graph;

    graph = TurokAnimTransitionGraph(mReplicatedGraph.mGraph);
    // End:0x27
    if(graph == none)
    {
        return;
    }
    // End:0x41
    if(!graph.IsReplicateable())
    {
        return;
    }
    // End:0x4E
    if(mAnimController == none)
    {
        return;
    }
    PlayGraphLocal(graph, Controller, mReplicatedGraph.mActorType);
    //return;    
}

function HealAmount(int healthAmt)
{
    // End:0x0D
    if(healthAmt < 0)
    {
        return;
    }
    Health += healthAmt;
    // End:0x33
    if(Health > mDefaultHealth)
    {
        Health = mDefaultHealth;
    }
    // End:0x4F
    if(Health == mDefaultHealth)
    {
        mHitByList.Remove(0, mHitByList.Length);
    }
    //return;    
}

function int GetNeededHealth()
{
    local int RemainingHealth;

    RemainingHealth = mDefaultHealth - Health;
    // End:0x23
    if(RemainingHealth >= 0)
    {
        return RemainingHealth;
    }
    return 0;
    //return ReturnValue;    
}

function @NULL GetHitInfo()
{
    return mHitInfo;
    //return ReturnValue;    
}

function bool QueryNeedHealth()
{
    return mDefaultHealth > Health;
    //return ReturnValue;    
}

simulated event RemoveStuckArrow(@NULL stuckArrow)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x45 [Loop If]
    if(I < mArrowsStuckToMe.Length)
    {
        // End:0x3B
        if(mArrowsStuckToMe[I] == stuckArrow)
        {
            mArrowsStuckToMe.Remove(I, 1);
            // [Explicit Break]
            goto J0x45;
        }
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    J0x45:

    //return;    
}

simulated event AddStuckArrow(@NULL stuckArrow)
{
    mArrowsStuckToMe.Insert(0, 1);
    mArrowsStuckToMe[0] = stuckArrow;
    //return;    
}

function gibbedBy(@NULL Other)
{
    return;
    //return;    
}

function bool Died(@NULL Killer, class<Class> DamageType, @NULL HitLocation)
{
    local int I;

    mbIsDying = true;
    // End:0x24
    if(!super.Died(Killer, DamageType, HitLocation))
    {
        return false;
    }
    StopAllPawnAmbientSounds();
    I = 0;
    J0x36:

    // End:0xA4 [Loop If]
    if(I < mHitByList.Length)
    {
        // End:0x9A
        if((TurokPlayerController(mHitByList[I]) != none) && mHitByList[I] != Killer)
        {
            TurokPlayerController(mHitByList[I]).RecordStat(39, 1.0000000, 1);
        }
        I++;
        // [Loop Continue]
        goto J0x36;
    }
    mHitByList.Remove(0, mHitByList.Length);
    // End:0xDC
    if(mMPAISpawnTarget != none)
    {
        mMPAISpawnTarget.NotifyKilled(self, Killer);
        mMPAISpawnTarget = none;
    }
    mMPAISpawnPoint = none;
    // End:0x141
    if(Class'TurokUtil'.static.IsMultiplayerGame())
    {
        I = 0;
        J0xFC:

        // End:0x141 [Loop If]
        if(I < mArrowsStuckToMe.Length)
        {
            // End:0x137
            if(mArrowsStuckToMe[I] != none)
            {
                mArrowsStuckToMe[I].RemovePersistentArrowFromPawn(self);
            }
            ++I;
            // [Loop Continue]
            goto J0xFC;
        }
    }
    EmptyReachablesMap();
    LightEnvironment.mUpdateOnMoveOnly = true;
    return true;
    //return ReturnValue;    
}

event ClearCumulativeDamageTotal()
{
    local int Count;

    Count = 0;
    J0x07:

    // End:0x52 [Loop If]
    if(Count < 450)
    {
        mCumulativeDamage[Count].mDamage = 0;
        mCumulativeDamage[Count].mTimestamp = 0.0000000;
        Count++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function SetMPAISpawnInfo(@NULL SpawnTarget, @NULL SpawnPoint)
{
    mMPAISpawnTarget = SpawnTarget;
    mMPAISpawnPoint = SpawnPoint;
    //return;    
}

function @NULL GetMPAISpawnTarget()
{
    return mMPAISpawnTarget;
    //return ReturnValue;    
}

function @NULL GetMPAISpawnPoint()
{
    return mMPAISpawnPoint;
    //return ReturnValue;    
}

simulated function NotifySkelInVolume(@NULL vol, name BoneName, @NULL BoneLocation)
{
    //return;    
}

function bool CanBeInstakilledByDino()
{
    return true;
    //return ReturnValue;    
}

function OverrideSenses(@NULL newSenses)
{
    HearingThreshold = newSenses.mHearingThreshold;
    SightRadius = newSenses.mSightRadius;
    PeripheralVision = newSenses.mPeripheralVision;
    //return;    
}

simulated event ScriptGotoState(optional name NewState)
{
    GotoState(NewState);
    //return;    
}

simulated event ScriptPushState(optional name NewState)
{
    PushState(NewState);
    //return;    
}

simulated event ScriptPopState()
{
    PopState();
    //return;    
}

function PlayTeleportEffect(bool bOut, bool bSound)
{
    //return;    
}

simulated event StartCrouch(float HeightAdjust)
{
    local @NULL Offset;

    super.StartCrouch(HeightAdjust);
    Offset = vect(0.0000000, 0.0000000, 1.0000000) * -HeightAdjust;
    Move(Offset);
    //return;    
}

simulated function bool DoJump(bool bUpdating)
{
    local float velMag, horzJumpBonus, vertJumpBonus;

    // End:0x241
    if((!bIsCrouched && !bWantsToCrouch) && ((int(Physics) == int(1)) || int(Physics) == int(9)) || int(Physics) == int(8))
    {
        // End:0x90
        if(int(Role) == int(ROLE_Authority))
        {
            // End:0x90
            if(bCountJumps && InvManager != none)
            {
                InvManager.OwnerEvent('Jumped');
            }
        }
        // End:0xB5
        if(int(Physics) == int(8))
        {
            Velocity = JumpZ * Floor;            
        }
        else
        {
            // End:0xDD
            if(int(Physics) == int(9))
            {
                Velocity.Z = 0.0000000;                
            }
            else
            {
                // End:0xFE
                if(bIsWalking)
                {
                    Velocity.Z = default.JumpZ;                    
                }
                else
                {
                    velMag = Sqrt(Velocity Dot Velocity);
                    // End:0x12C
                    if(velMag > GroundSpeed)
                    {
                        velMag = GroundSpeed;
                    }
                    horzJumpBonus = mHorizontalJumpModifier * (1.0000000 + ((mHorizontalSpeedJumpModifier * velMag) / GroundSpeed));
                    vertJumpBonus = mVerticalJumpModifier * (1.0000000 + ((mVerticalSpeedJumpModifier * velMag) / GroundSpeed));
                    Velocity.Z = vertJumpBonus * JumpZ;
                    Velocity.X *= horzJumpBonus;
                    Velocity.Y *= horzJumpBonus;
                }
            }
        }
        // End:0x230
        if(((Base != none) && !Base.bWorldGeometry) && Base.Velocity.Z > 0.0000000)
        {
            Velocity.Z += Base.Velocity.Z;
        }
        PlayJumpSound();
        SetPhysics(2);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function TakeFallingDamage()
{
    local float EffectiveSpeed;
    local bool shouldMakeNoise;
    local int actualDamage;

    // End:0x106
    if(Velocity.Z < (float(-1) * MaxFallSpeed))
    {
        EffectiveSpeed = Velocity.Z;
        // End:0xF9
        if(EffectiveSpeed < (float(-1) * MaxFallSpeed))
        {
            actualDamage = int((float(-100) * EffectiveSpeed) / MaxFallSpeed);
            // End:0xA8
            if(int(Role) == int(ROLE_Authority))
            {
                TakeDamage(actualDamage, none, Location, vect(0.0000000, 0.0000000, 0.0000000), Class'Engine.DmgType_Fell');                
            }
            else
            {
                // End:0xE8
                if(int(Role) == int(ROLE_AutonomousProxy))
                {
                    Controller.NotifyTakeHit(none, Location, actualDamage, Class'Engine.DmgType_Fell', vect(0.0000000, 0.0000000, 0.0000000));
                }
            }
            MakeNoise(mMaxFootstepNoiseLevel, 'NOISE_Footstep');
        }
        PlayGruntSound();        
    }
    else
    {
        // End:0x183
        if(Velocity.Z < (-1.4000000 * JumpZ))
        {
            // End:0x183
            if(int(Role) == int(ROLE_Authority))
            {
                shouldMakeNoise = true;
                // End:0x169
                if(TurokPawnPlayer(self) != none)
                {
                    // End:0x169
                    if(TurokPawnPlayer(self).GetIsStealth())
                    {
                        shouldMakeNoise = false;
                    }
                }
                // End:0x183
                if(shouldMakeNoise)
                {
                    MakeNoise(mMaxFootstepNoiseLevel, 'NOISE_Footstep');
                }
            }
        }
    }
    //return;    
}

simulated function ClimbLadder(@NULL L)
{
    local @NULL lv;

    lv = TurokLadderVolume(L);
    // End:0x1D
    if(lv == none)
    {
        return;
    }
    // End:0x53
    if(!IsInState('climbing'))
    {
        OnLadder = lv;
        mLadderVolume = lv;
        GotoState('climbing');
    }
    //return;    
}

simulated function EndClimbing()
{
    //return;    
}

// Export UTurokPawn::execCanHurt(FFrame&, void* const)
native function bool CanHurt(@NULL Other, optional class<Class> DamageType);

simulated event bool CanAutoAimTo()
{
    return false;
    //return ReturnValue;    
}

simulated function PlayDyingSound()
{
    //return;    
}

simulated event RigidBodyCollision(@NULL pHitComponent, @NULL pOtherComponent, const out array pContactInfos, int ContactIndex)
{
    local float velMag;
    local @NULL relVel, velocity0, velocity1;
    local float Volume;

    super(Actor).RigidBodyCollision(pHitComponent, pOtherComponent, pContactInfos, ContactIndex);
    velocity1 = pContactInfos[0].ContactVelocity[1];
    velocity0 = pContactInfos[0].ContactVelocity[0];
    relVel = velocity1 - velocity0;
    velMag = VSize(relVel);
    // End:0xB9
    if(Mesh.SkeletalMesh == mGoreSkeletalMesh)
    {
        Volume = FClamp(velMag - mMinBodyChunkVelocityVol, 0.0000000, mMaxBodyChunkVelocityVol - mMinBodyChunkVelocityVol) / (mMaxBodyChunkVelocityVol - mMinBodyChunkVelocityVol);        
    }
    else
    {
        Volume = FClamp(velMag - mMinBodyFallVelocityVol, 0.0000000, mMaxBodyFallVelocityVol - mMinBodyFallVelocityVol) / (mMaxBodyFallVelocityVol - mMinBodyFallVelocityVol);
    }
    // End:0x212
    if(Volume > float(0))
    {
        // End:0x15F
        if(Mesh.SkeletalMesh == mGoreSkeletalMesh)
        {
            mSoundController.AddLimitedSound('BodyFall', 0.5000000);
            mSoundController.TryPlayLimitedSound('BodyFall', mBloodyPartSndCue, Location,,,, Volume);            
        }
        else
        {
            mSoundController.AddLimitedSound('BodyFall', 0.5000000);
            mSoundController.TryPlayLimitedSound('BodyFall', mBodyFallSndCue, Location,,,, Volume);
        }
        // End:0x212
        if(Mesh.SkeletalMesh != mGoreSkeletalMesh)
        {
            // End:0x212
            if((((int(mRagdollState) == int(3)) || int(mRagdollState) == int(4)) || int(mRagdollState) == int(8)) && mPowerDuration > 0.2500000)
            {
                mPowerDuration = 0.2500000;
            }
        }
    }
    //return;    
}

// Export UTurokPawn::execPlayIdleSound(FFrame&, void* const)
native function PlayIdleSound();

// Export UTurokPawn::execStopIdleSound(FFrame&, void* const)
native function StopIdleSound();

simulated event PlayAmbientSound(optional @NULL sc)
{
    local @NULL cue;

    // End:0x1A
    if(sc != none)
    {
        cue = sc;        
    }
    else
    {
        // End:0x33
        if(mPawnAmbientSoundCue != none)
        {
            cue = mPawnAmbientSoundCue;            
        }
        else
        {
            StopAmbientSound(0.5000000);
            return;
        }
    }
    // End:0x76
    if(mPawnAmbientSndChannel == -1)
    {
        mPawnAmbientSndChannel = mSoundController.CreateAudioChannel(cue, true, true);        
    }
    else
    {
        mSoundController.ChangeAudioChannel(mPawnAmbientSndChannel, cue, true, true);
    }
    //return;    
}

simulated event StopAmbientSound(optional float FadeTime = 0.0000000)
{
    // End:0x1A
    if(mPawnAmbientSndChannel == -1)
    {
        return;
    }
    // End:0x43
    if(FadeTime == float(0))
    {
        mSoundController.StopAudioChannel(mPawnAmbientSndChannel);        
    }
    else
    {
        mSoundController.FadeOutAudioChannel(mPawnAmbientSndChannel, FadeTime, 0.0000000);
    }
    //return;    
}

simulated event StopAllPawnAmbientSounds(optional float FadeTime = 0.0000000)
{
    StopIdleSound();
    StopAmbientSound();
    // End:0x46
    if(mWeaponAmbientSndChannelIndex >= 0)
    {
        mSoundController.StopAudioChannel(mWeaponAmbientSndChannelIndex, 0.5000000);
    }
    //return;    
}

function ResetDamageArray()
{
    // End:0x59
    if(!mbCumulativeDamageResetPending)
    {
        // End:0x40
        if(mCumulativeDamageResetTime > 0.0000000)
        {
            mbCumulativeDamageResetPending = true;
            mPendingResetCumulativeDamageTime = WorldInfo.TimeSeconds + mCumulativeDamageResetTime;            
        }
        else
        {
            // End:0x59
            if(mCumulativeDamageResetTime == 0.0000000)
            {
                ClearCumulativeDamageTotal();
            }
        }
    }
    //return;    
}

simulated event PlayGrassFootstepSound()
{
    local float mSpeed;

    mSpeed = Abs(VSize2D(Velocity));
    // End:0x53
    if(mSpeed >= mMinGrassSoundThresh)
    {
        mSoundController.TryPlayLimitedSound('Grass', mGrassFootstepSound, Location,,,, mSpeed / GroundSpeed);
    }
    //return;    
}

simulated event PlayFoleySound()
{
    // End:0x58
    if(mFoleySounds.Length > 0)
    {
        // End:0x58
        if(mFoleySounds[0] != none)
        {
            mSoundController.TryPlayLimitedSound('Foley', mFoleySounds[0], Location,,, true, GetFootStepVolume(1.0000000, 'jt_Foot_R'));
        }
    }
    //return;    
}

simulated function PlayJumpSound()
{
    mSoundController.TryPlayReplicatedSound(mJumpSndCue, true, false, Location);
    //return;    
}

event Landed(@NULL HitNormal, @NULL FloorActor)
{
    // End:0x45
    if(Velocity.Z < float(-200))
    {
        PlayLandSound(FClamp(Abs(Velocity.Z / MaxFallSpeed), 0.8000000, 1.0000000));
    }
    TakeFallingDamage();
    // End:0x73
    if(Health > 0)
    {
        PlayLanded(Velocity.Z);
    }
    // End:0xB5
    if((Velocity.Z < float(-200)) && PlayerController(Controller) != none)
    {
        OldZ = Location.Z;
    }
    LastHitBy = none;
    //return;    
}

final event CreateAmmoPool(class<Class> newAmmoPoolClass)
{
    // End:0x37
    if(TurokInventoryManager(InvManager) != none)
    {
        TurokInventoryManager(InvManager).CreateAmmoPool(newAmmoPoolClass, 999, 999);
    }
    //return;    
}

event Touch(@NULL Other, @NULL HitLocation, @NULL HitNormal)
{
    local @NULL streamingVolume;

    streamingVolume = LevelStreamingVolume(Other);
    // End:0x2A
    if(streamingVolume != none)
    {
        TouchedLevelStreamingVolume(streamingVolume);
    }
    //return;    
}

event UnTouch(@NULL Other)
{
    local @NULL streamingVolume;

    streamingVolume = LevelStreamingVolume(Other);
    // End:0x2A
    if(streamingVolume != none)
    {
        UnTouchedLevelStreamingVolume(streamingVolume);
    }
    //return;    
}

event StunTriggered()
{
    ResetDamageArray();
    //return;    
}

function CrushedBy(@NULL OtherPawn)
{
    TakeRadiusDamage(OtherPawn.Controller, ((1.0000000 - (OtherPawn.Velocity.Z / float(400))) * OtherPawn.Mass) / Mass, OtherPawn.CylinderComponent.CollisionRadius, Class'TurokDamageTypeFoot', VSize(0.5000000 * OtherPawn.Velocity), Location, true, self);
    //return;    
}

// Export UTurokPawn::execInGodMode(FFrame&, void* const)
native function bool InGodMode();

simulated function bool CanBeDraggedByArrow()
{
    return false;
    //return ReturnValue;    
}

simulated function bool ArrowCanStickInto()
{
    return true;
    //return ReturnValue;    
}

function PlayHit(float Damage, @NULL InstigatedBy, @NULL HitLocation, class<Class> DamageType, @NULL Momentum, @NULL HitInfo)
{
    super.PlayHit(Damage, InstigatedBy, HitLocation, DamageType, Momentum, HitInfo);
    mHitInfo = HitInfo;
    //return;    
}

function AdjustDamage(out int inDamage, out @NULL Momentum, @NULL InstigatedBy, @NULL HitLocation, class<Class> DamageType, optional @NULL HitInfo)
{
    local float scaleDamage;

    scaleDamage = GetDamageScale(HitInfo, DamageType);
    // End:0x44
    if((InGodMode()) || scaleDamage <= 0.0000000)
    {
        scaleDamage = 1.0000000;
    }
    inDamage = int(float(inDamage) * scaleDamage);
    // End:0x6C
    if(inDamage < 0)
    {
        inDamage = 0;
    }
    // End:0xDC
    if(InstigatedBy != none)
    {
        // End:0xDC
        if((TurokPawnPlayer(InstigatedBy.Pawn) != none) && inDamage > 0)
        {
            // End:0xDC
            if(TurokPawnPlayer(InstigatedBy.Pawn).mbPlayerCanOneShotKill && !InGodMode())
            {
                inDamage = Health + 1;
            }
        }
    }
    mLastDamage = inDamage;
    //return;    
}

simulated function TakeRadiusDamage(@NULL InstigatedBy, float BaseDamage, float DamageRadius, class<Class> DamageType, float Momentum, @NULL HurtOrigin, bool bFullDamage, @NULL DamageCauser)
{
    local @NULL radHitDir;
    local float radDist;
    local @NULL radHitInfo;
    local float damageScale, impulseScale;
    local @NULL damageMomentum;
    local float damageEffectDist;

    radHitDir = Location - HurtOrigin;
    radDist = VSize(radHitDir);
    radHitDir = Normal(radHitDir);
    radHitInfo.HitComponent = Mesh;
    radHitInfo.BoneName = 'jt_Cog_C';
    impulseScale = DamageType.default.RadialMinDamageImpulse + ((1.0000000 - FClamp(radDist / DamageType.default.DamageKnockdownRadius, 0.0000000, 1.0000000)) * (DamageType.default.RadialDamageImpulse - DamageType.default.RadialMinDamageImpulse));
    damageMomentum = impulseScale * radHitDir;
    // End:0x210
    if(int(Role) == int(ROLE_Authority))
    {
        damageEffectDist = DamageType.default.DamageGibRadius + (GetRadiusDamageBufferDistance());
        // End:0x111
        if(bFullDamage)
        {
            damageScale = 1.0000000;            
        }
        else
        {
            // End:0x12E
            if(radDist <= damageEffectDist)
            {
                damageScale = 1.0000000;                
            }
            else
            {
                damageScale = 1.0000000 - ((FClamp(radDist, damageEffectDist, DamageRadius) - damageEffectDist) / (DamageRadius - damageEffectDist));
            }
        }
        // End:0x1A6
        if(damageScale > 0.0000000)
        {
            TakeDamage(int(damageScale * BaseDamage), InstigatedBy, HurtOrigin, damageMomentum, DamageType, radHitInfo, DamageCauser);
        }
        damageEffectDist = DamageType.default.DamageKnockdownRadius + (GetRadiusDamageBufferDistance());
        // End:0x210
        if((Health > 0) && (radDist < damageEffectDist) || bFullDamage)
        {
            TakeImpact(DamageType, BaseDamage, HurtOrigin, damageMomentum, radHitInfo);
        }
    }
    // End:0x2A8
    if((mBloodDecal != none) && int(DamageType.default.mReactionType) == int(2))
    {
        ApplyBloodDecal(vect(400.0000000, 0.0000000, 0.0000000));
        ApplyBloodDecal(vect(-400.0000000, 0.0000000, 0.0000000));
        ApplyBloodDecal(vect(0.0000000, 0.0000000, 400.0000000));
        ApplyBloodDecal(vect(0.0000000, 0.0000000, -400.0000000));
        ApplyBloodDecal(vect(0.0000000, 400.0000000, 0.0000000));
        ApplyBloodDecal(vect(0.0000000, -400.0000000, 0.0000000));
    }
    //return;    
}

simulated function PlayDying(class<Class> DamageType, @NULL HitLoc)
{
    local @NULL HitInfo;

    ClearAnimAIInterface();
    bTearOff = true;
    Velocity += TearOffMomentum;
    TakeHitLocation = HitLoc;
    HitDamageType = DamageType;
    bPlayedDeath = true;
    CheckHitInfo(HitInfo, Mesh, Normal(TearOffMomentum), HitLoc);
    // End:0xA0
    if(HitInfo.BoneName == 'None')
    {
        HitInfo.HitComponent = Mesh;
        HitInfo.BoneName = 'jt_Cog_C';
    }
    mbPlayedDeathAnimation = InitiateDeathAnim(DamageType, TearOffMomentum, HitLoc, HitInfo);
    // End:0xFE
    if((class<TurokDamageType>(DamageType) != none) && IsLocallyControlled())
    {
        PlayDeathSound(class<TurokDamageType>(DamageType).default.mDamageType);
    }
    // End:0x126
    if(Mesh.SkeletalMesh == mGoreSkeletalMesh)
    {
        RevealDamageTexture(0, DamageType);
    }
    GotoState('Dying');
    //return;    
}

simulated function PlayTakeDamageSound(float Damage, @NULL HitLocation, class<Class> DamageType)
{
    local @NULL sc;

    // End:0x1C
    if((float(Health) / float(mDefaultHealth)) <= mMinDamagePcntToTriggerAudio)
    {
        return;
    }
    // End:0x46
    if((DamageType == Class'TurokDamageTypeBow') && mArrowTakeDamageSndCue != none)
    {
        sc = mArrowTakeDamageSndCue;        
    }
    else
    {
        // End:0x81
        if(((DamageType == Class'TurokDamageTypeFlameThrower') || DamageType == Class'TurokDamageTypeNapalmGrenade') && mFireTakeDamageSndCue != none)
        {
            sc = mFireTakeDamageSndCue;            
        }
        else
        {
            sc = mTakeDamageSndCue;
        }
    }
    // End:0xCE
    if((sc != none) && !IsMauling())
    {
        mSoundController.TryPlayLimitedSound('TakeDamage', sc, Location);
    }
    //return;    
}

simulated event TakeImpact(class<Class> pDamageType, float Damage, @NULL HitLocation, @NULL HitMomentum, @NULL HitInfo)
{
    local float scaleDamage;

    scaleDamage = GetDamageScale(HitInfo, pDamageType);
    // End:0x34
    if(scaleDamage <= 0.0000000)
    {
        scaleDamage = 1.0000000;
    }
    Damage *= scaleDamage;
    InitiateLocalImpact(pDamageType, HitMomentum, HitLocation, HitInfo);
    RevealDamageTexture(int(Damage), pDamageType);
    // End:0x9F
    if((pDamageType == Class'TurokDamageTypeFlameThrower') || pDamageType == Class'TurokDamageTypeNapalmGrenade')
    {
        mFireHitInfo = HitInfo;
    }
    // End:0xB1
    if(pDamageType == Class'TurokDamageTypeTazer')
    {        
    }
    else
    {
        // End:0xDF
        if(pDamageType == Class'TurokDamageTypeTazerElectricalBolt')
        {
            mTazerStunTime = float(Min(int(Damage + mTazerStunTime), int(mMaxTazerStunTime)));
        }
    }
    // End:0x101
    if(IsLocallyControlled())
    {
        PlayTakeDamageSound(Damage, HitLocation, pDamageType);
    }
    //return;    
}

simulated event HitByTazer(float stunTime, @NULL tazerInstigator)
{
    //return;    
}

simulated function FlareAttached()
{
    mbHasFlareAttached = true;
    mbHasHadFlareAttachedRecently = true;
    SetTimer(mFlareTrackingTime, false, 'FlareRecentAttachTimer');
    //return;    
}

simulated function FlareRecentAttachTimer()
{
    mbHasHadFlareAttachedRecently = false;
    //return;    
}

simulated function FlareRemoved()
{
    mbHasFlareAttached = false;
    //return;    
}

function SetSpatialTarget(@NULL vTarget)
{
    mSpatialTarget = vTarget;
    //return;    
}

simulated function @NULL GetSpatialTarget()
{
    return mSpatialTarget;
    //return ReturnValue;    
}

function HitReactionSlowDown(float Damage, @NULL InstigatedBy, class<Class> DamageType)
{
    local int totalDamage;
    local bool bIsPlayerDamage;

    mCumulativeDamage[mCumulativeDamagePtr].mDamage += int(Damage);
    mCumulativeDamage[mCumulativeDamagePtr].mTimestamp = WorldInfo.TimeSeconds;
    totalDamage = GetCumulativeDamageTotal(mDamageTime, WorldInfo.TimeSeconds);
    // End:0x112
    if((mDamageThresholdCheckTime < WorldInfo.TimeSeconds) && totalDamage >= mDamageThreshold)
    {
        // End:0xF7
        if(TurokAIController(Controller) != none)
        {
            bIsPlayerDamage = false;
            // End:0xD4
            if((InstigatedBy != none) && TurokPawnPlayer(InstigatedBy.Pawn) != none)
            {
                bIsPlayerDamage = true;
            }
            TurokAIController(Controller).DamageOverTimeThresholdReached(bIsPlayerDamage, DamageType);
        }
        mDamageThresholdCheckTime = WorldInfo.TimeSeconds + mDamageTime;
    }
    // End:0x147
    if(mStunDamageTime > 0.0000000)
    {
        totalDamage = GetCumulativeDamageTotal(mStunDamageTime, WorldInfo.TimeSeconds);        
    }
    else
    {
        totalDamage = int(Damage);
    }
    StunTriggered();
    ApplyStun(Damage, InstigatedBy);
    //return;    
}

function ApplyStun(float Damage, @NULL InstigatedBy)
{
    //return;    
}

function AddVelocity(@NULL NewVelocity, @NULL HitLocation, class<Class> DamageType, optional @NULL HitInfo)
{
    //return;    
}

simulated function RevealDamageTexture(int Damage, class<Class> DamageType)
{
    local float MaterialDamage, DamagePercent;
    local int MaterialInstanceIndex;

    MaterialInstanceIndex = 0;
    J0x07:

    // End:0x15C [Loop If]
    if(MaterialInstanceIndex < mMaterialInstances.Length)
    {
        // End:0x152
        if((mMaterialInstances[MaterialInstanceIndex] != none) && mMaterialInstances[MaterialInstanceIndex].GetScalarParameterValue('DmgdReveal', MaterialDamage))
        {
            // End:0x92
            if(Mesh.SkeletalMesh == mGoreSkeletalMesh)
            {
                mMaterialInstances[MaterialInstanceIndex].SetScalarParameterValue('DmgdReveal', mGibDamageRevealLevel);
                // [Explicit Continue]
                goto J0x152;
            }
            // End:0x152
            if(((int(DamageType.default.mReactionType) == int(1)) || int(DamageType.default.mReactionType) == int(2)) || int(DamageType.default.mReactionType) == int(4))
            {
                DamagePercent = FClamp(float(Damage) / float(mDefaultHealth), 0.0000000, 0.3300000);
                DamagePercent *= (1.0000000 - mMaxDamageRevealLevel);
                MaterialDamage = FMax(MaterialDamage - DamagePercent, mMaxDamageRevealLevel);
                mMaterialInstances[MaterialInstanceIndex].SetScalarParameterValue('DmgdReveal', MaterialDamage);
            }
        }
        J0x152:

        ++MaterialInstanceIndex;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

event TakeDamage(int Damage, @NULL InstigatedBy, @NULL HitLocation, @NULL Momentum, class<Class> DamageType, optional @NULL HitInfo, optional @NULL DamageCauser)
{
    local int actualDamage;

    actualDamage = Damage;
    TrackHittingController(InstigatedBy);
    super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo);
    HitReactionSlowDown(float(mLastDamage), InstigatedBy, DamageType);
    // End:0x112
    if(DamageType == Class'TurokDamageTypeFlameThrower')
    {
        // End:0xB7
        if(mIsOnFire)
        {
            mFireInstigator = InstigatedBy;
            mBurnTimeRemaining += mAdditionalBurnTime;
            // End:0xA5
            if(mBurnTimeRemaining > mMaxBurnTime)
            {
                mBurnTimeRemaining = mMaxBurnTime;
            }
            TriggerFlames(HitLocation);            
        }
        else
        {
            // End:0x10F
            if(mFlammable)
            {
                mNumFireStrikes++;
                // End:0x10F
                if(mNumFireStrikes >= mMaxFireStrikes)
                {
                    mNumFireStrikes = 0;
                    OnFireBeginServer(InstigatedBy, HitLocation, DamageType);
                    OnFireBegin();
                    TriggerFlames(HitLocation);
                }
            }
        }        
    }
    else
    {
        // End:0x184
        if(DamageType == Class'TurokDamageTypeNapalmGrenade')
        {
            // End:0x14E
            if(mIsOnFire)
            {
                mFireInstigator = InstigatedBy;
                mBurnTimeRemaining += mAddNapalmBurnTime;
                SpawnNapalmFlames();                
            }
            else
            {
                // End:0x184
                if(mFlammable)
                {
                    OnFireBeginServer(InstigatedBy, HitLocation, DamageType);
                    OnFireBegin();
                    SpawnNapalmFlames();
                }
            }
        }
    }
    // End:0x1EE
    if(actualDamage > 0)
    {
        // End:0x1C0
        if(TurokAIController(InstigatedBy) != none)
        {
            TurokAIController(InstigatedBy).NotifyCausedDamage(self, HitLocation);            
        }
        else
        {
            // End:0x1EE
            if(TurokPlayerController(InstigatedBy) != none)
            {
                TurokPlayerController(InstigatedBy).NotifyCausedDamage(self, HitLocation);
            }
        }
    }
    //return;    
}

simulated function SpawnNapalmFlames()
{
    local int Index;

    // End:0x45
    if(mExtents.Length > 0)
    {
        Index = 0;
        J0x13:

        // End:0x42 [Loop If]
        if(Index < mExtents.Length)
        {
            TriggerFlames(mExtents[Index]);
            Index++;
            // [Loop Continue]
            goto J0x13;
        }        
    }
    else
    {
        TriggerFlames(Location);
    }
    //return;    
}

simulated function TrackHittingController(@NULL hitter)
{
    local int I;
    local bool foundHitter;

    mHitBy = hitter;
    // End:0x3B
    if(((hitter == none) || hitter.PlayerReplicationInfo == none) || PlayerReplicationInfo == none)
    {
        return;
    }
    // End:0x4C
    if(hitter == Owner)
    {
        return;
    }
    // End:0xC3
    if(((hitter.PlayerReplicationInfo.Team != none) && PlayerReplicationInfo.Team != none) && int(hitter.PlayerReplicationInfo.Team.TeamIndex) == int(PlayerReplicationInfo.Team.TeamIndex))
    {
        return;
    }
    I = 0;
    foundHitter = false;
    J0xD2:

    // End:0x117 [Loop If]
    if((I < mHitByList.Length) && foundHitter == false)
    {
        // End:0x10D
        if(mHitByList[I] == hitter)
        {
            foundHitter = true;
        }
        I++;
        // [Loop Continue]
        goto J0xD2;
    }
    // End:0x134
    if(!foundHitter)
    {
        mHitByList[mHitByList.Length] = hitter;
    }
    //return;    
}

simulated event HitLedge()
{
    //return;    
}

function float GetRadiusDamageBufferDistance()
{
    return 0.0000000;
    //return ReturnValue;    
}

simulated function DisplayDebug(@NULL HUD, out float out_YL, out float out_YPos)
{
    local @NULL Canvas, P;
    local string DebugInfo;

    super.DisplayDebug(HUD, out_YL, out_YPos);
    Canvas = HUD.Canvas;
    Canvas.SetDrawColor(byte(255), byte(255), byte(255));
    // End:0x38B
    if(HUD.ShouldDisplayDebug('net'))
    {
        // End:0x38A
        foreach WorldInfo.AllPawns(Class'TurokPawnPlayer', P)
        {
            out_YPos += out_YL;
            Canvas.SetPos(4.0000000, out_YPos);
            Canvas.__NFUN_465__(P.GetHumanReadableName());
            out_YPos += out_YL;
            Canvas.SetPos(20.0000000, out_YPos);
            Canvas.__NFUN_465__((((((((("Loc:" $ string(P.Location)) @ "Vel:") $ string(P.Velocity)) @ "Acc:") $ string(P.Acceleration)) @ "Phys:") $ string(P.Physics)) @ "Crouch:") $ string(P.bIsCrouched));
            out_YPos += out_YL;
            Canvas.SetPos(20.0000000, out_YPos);
            Canvas.__NFUN_465__((((("Rot:" $ string(P.Rotation)) @ "Spatial:") $ string(P.mSpatialTarget)) @ "ViewRot:") @ string(P.GetViewRotation()));
            out_YPos += out_YL;
            Canvas.SetPos(20.0000000, out_YPos);
            Canvas.__NFUN_465__((((("RM-Delta:" $ string(P.Mesh.RootMotionDelta)) @ "RM-Rot:") $ string(P.Mesh.RootMotionRotation)) @ "AnimState:") $ string(P.mAnimState));
            // End:0x389
            if(P.PlayerReplicationInfo != none)
            {
                DebugInfo = "ID:" $ string(P.PlayerReplicationInfo.PlayerID);
                // End:0x337
                if(P.PlayerReplicationInfo.Team != none)
                {                    
                    DebugInfo @= ("Team:" $ string(P.PlayerReplicationInfo.Team.TeamIndex));                    
                }
                else
                {                    
                    DebugInfo @= "Team:Unknown";
                }
                out_YPos += out_YL;
                Canvas.SetPos(30.0000000, out_YPos);
                Canvas.__NFUN_465__(DebugInfo);
            }            
        }        
    }
    //return;    
}

function bool GetIsStealthPocket()
{
    return mIsInStealthPocket;
    //return ReturnValue;    
}

function SetIsStealthPocket(bool pocket)
{
    mIsInStealthPocket = pocket;
    //return;    
}

function StealthVisibility(float factor)
{
    mVisibility = factor;
    //return;    
}

function TouchPainVolume(@NULL PV)
{
    // End:0x82
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x82
        if((((mPainVolume != PV) && PV.DamagePerSec > float(0)) && Health > 0) && !mbIsDying)
        {
            mPainVolume = PV;
            SetTimer(1.0000000, true, 'PainVolumeTimer');
            SetTimer(0.1000000, false, 'InstantPainVolumeDamage');
        }
    }
    //return;    
}

function UnTouchPainVolume(@NULL PV)
{
    // End:0x42
    if(int(Role) == int(ROLE_Authority))
    {
        // DebugMode: 0
        assert(PV != none);
        // End:0x42
        if(PV == mPainVolume)
        {
            ClearTimer('PainVolumeTimer');
            mPainVolume = none;
        }
    }
    //return;    
}

function PainVolumeTimer()
{
    // DebugMode: 0
    assert(mPainVolume != none);
    mPainVolume.CausePainTo(self);
    // End:0x4D
    if((Health <= 0) || mbIsDying)
    {
        ClearTimer('PainVolumeTimer');
        mPainVolume = none;
    }
    //return;    
}

function InstantPainVolumeDamage()
{
    // End:0x1F
    if(mPainVolume != none)
    {
        mPainVolume.CausePainTo(self);
    }
    // End:0x4C
    if((Health <= 0) || mbIsDying)
    {
        ClearTimer('PainVolumeTimer');
        mPainVolume = none;
    }
    //return;    
}

function OnPawnAddAnimSet(@NULL Action)
{
    local int iAnimSet, iIndex;

    // End:0x88
    if(Mesh != none)
    {
        iAnimSet = 0;
        J0x12:

        // End:0x88 [Loop If]
        if(iAnimSet < Action.mAnimSets.Length)
        {
            iIndex = Mesh.AnimSets.Length;
            Mesh.AnimSets.Insert(iIndex, 1);
            Mesh.AnimSets[iIndex] = Action.mAnimSets[iAnimSet];
            ++iAnimSet;
            // [Loop Continue]
            goto J0x12;
        }
    }
    //return;    
}

function (@NULL Action)
{
    local int iAnimSet, iIndex;


    /* Statement decompilation error: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
        
    */
    // End:0x84
    /*@Error*/
    iAnimSet = 0;
    J0x12:

    // End:0x84 [Loop If]
    if(iAnimSet < Action.mAnimSets.Length)
    {
        iIndex = Mesh.AnimSets.Find(@NULL = @NULL);
        /* Statement decompilation error: Object reference not set to an instance of an object.
            
        */

        /*@Error*/
        @NULL
        @NULL
        iIndex
        -1        
        Mesh.AnimSets.Remove(iIndex, 1);
        ++iAnimSet;
        // [Loop Continue]
        goto J0x12;
        //return;        
        @NULL
        default.@NULL
        @NULL
    }
}

function OnPawnAlertState(@NULL Action)
{
    //return;    
}

simulated function OnAIAssignNodeGroup(@NULL Action)
{
    local array nodeGroup;

    Action.GetObjectVars(nodeGroup, "NodeGroup");
    // End:0x80
    if((nodeGroup.Length == 1) && TurokNodeGroup(nodeGroup[0]) != none)
    {
        mPathController.SetNodeGroup(TurokNodeGroup(nodeGroup[0]));
        mPathController.mbStickToPaths = Action.mbStickToPaths;        
    }
    else
    {
        mPathController.SetNodeGroup(none);
        mPathController.mbStickToPaths = false;
    }
    //return;    
}

simulated function OnAssignFence(@NULL Action)
{
    local int Index, RemoveIndex;
    local @NULL newFence;
    local array newFences;

    Action.GetObjectVars(newFences, "Fence");
    // End:0x75
    if((Action.InputLinks[0].bHasImpulse || Action.InputLinks[3].bHasImpulse) && mFences.Length > 0)
    {
        mFences.Remove(0, mFences.Length);
    }
    // End:0x11D
    if(Action.InputLinks[1].bHasImpulse || Action.InputLinks[0].bHasImpulse)
    {
        Index = 0;
        J0xBA:

        // End:0x11A [Loop If]
        if(Index < newFences.Length)
        {
            newFence = TurokFence(newFences[Index]);
            // End:0x110
            if(newFence != none)
            {
                // End:0x110
                if(mFences.Find(switch(newFence)) < 0)
                {
                    {
                        mFences[mFences.Length] = newFence;
                    }
                }/* !MISMATCHING REMOVE, tried If got Type:Switch Position:0x0F5! */
                Index++;
                // [Loop Continue]
                goto J0xBA;
            }/* !MISMATCHING REMOVE, tried Loop got Type:If Position:0x0E0! */            
        }/* !MISMATCHING REMOVE, tried If got Type:Loop Position:0x0BA! */
        else
        {
            // End:0x1D0
            if(Action.InputLinks[2].bHasImpulse)
            {
                Index = 0;
                J0x143:

                // End:0x1D0 [Loop If]
                if((Index < newFences.Length) && mFences.Length > 0)
                {
                    newFence = TurokFence(newFences[Index]);
                    // End:0x1C6
                    if(newFence != none)
                    {
                        RemoveIndex = mFences.Find(switch(newFence))
                        {
                            J0x195:

                            // End:0x1C6 [Loop If]
                            if(RemoveIndex > -1)
                            {
                                mFences.Remove(RemoveIndex, 1);
                                RemoveIndex = mFences.Find(switch(newFence))
                                {
                                    // [Loop Continue]
                                    goto J0x195;
                                }/* !MISMATCHING REMOVE, tried Loop got Type:Switch Position:0x1BC! */
                            }/* !MISMATCHING REMOVE, tried If got Type:Loop Position:0x195! */
                            Index++;
                            // [Loop Continue]
                            goto J0x143;
                        }/* !MISMATCHING REMOVE, tried Loop got Type:Switch Position:0x18E! */
                    }
                }/* !MISMATCHING REMOVE, tried Else got Type:Loop Position:0x143! */
                // End:0x1F8
                if(TurokAIController(Controller) != none)
                {
                    TurokAIController(Controller).ClearIndividualPathDistanceCache();
                }
                //return;                
}

simulated function OnAIAssignNodeGroupStreamingAutoLinkName(@NULL Action)
{
    // End:0x28
    if(mPathController != none)
    {
        mPathController.mNodeGroupStreamingAutoLinkName = Action.mNodeGroupStreamingAutoLinkName;
    }
    //return;    
}

simulated function OnAISetupTerrorsaur(@NULL Action)
{
    local @NULL pteroPawn;

    pteroPawn = TurokPawnPteroNative(self);
    // End:0x16F
    if(pteroPawn != none)
    {
        pteroPawn.mMatineePathName = Action.mPathName;
        pteroPawn.mbAlwaysStayOnPath = Action.mbAlwaysStayOnPath;
        pteroPawn.mMoveHeight = Action.mMoveHeight;
        pteroPawn.mbAllowAttackSwoopDown = Action.mbAllowAttackSwoopDown;
        pteroPawn.mMinSwoopStartHeightAboveEnemy = Action.mMinSwoopStartHeightAboveEnemy;
        pteroPawn.mMaxSwoopStartHeightAboveEnemy = Action.mMaxSwoopStartHeightAboveEnemy;
        pteroPawn.mMinSwoopTime = Action.mMinSwoopTime;
        pteroPawn.mMaxSwoopTime = Action.mMaxSwoopTime;
        pteroPawn.SightRadius = Action.mSightRadius;
        pteroPawn.PeripheralVision = Action.mPeripheralVision;
        pteroPawn.mbAutoFaceDirectionOfMovement = Action.mbAutoFaceDirectionOfMovement;
        pteroPawn.AttachToPath();
    }
    //return;    
}

simulated function OnAISetStunValues(@NULL Action)
{
    mStunDamageTime = Action.mStunDamageTime;
    mDamageTime = Action.mReactionAnimDamageTime;
    mDamageThreshold = Action.mReactionAnimDamageThreshold;
    mCumulativeDamageResetTime = Action.mResetTime;
    //return;    
}

simulated function OnBetterGiveInventory(@NULL inAction)
{
    local @NULL invMan, Weap, fireblade;

    invMan = TurokInventoryManager(InvManager);
    // End:0x1D
    if(invMan == none)
    {
        return;
    }
    invMan.mbDrawItemPickups = inAction.mbDrawItemPickups;
    // End:0x61
    if(inAction.mbClearInventory)
    {
        invMan.DestroyInventory();
    }
    OnGiveInventory(inAction);
    // End:0xED
    if((int(inAction.mbSwitchToWeapon) != int(0)) && InvManager != none)
    {
        invMan.SetCurrentWeaponByType(inAction.mbSwitchToWeapon, inAction.mbSwitchToDualWield);
        // End:0xED
        if(TurokPawnHuman(self) != none)
        {
            TurokPawnHuman(self).mWeaponMediator.mbWeaponsLowered = false;
        }
    }
    // End:0x14E
    if(inAction.mbNoExplodingArrowHack)
    {
        // End:0x14D
        foreach invMan.InventoryActors(Class'TurokWeapon', Weap)
        {
            // End:0x14C
            if(int(Weap.mWeaponType) == int(1))
            {
                TurokWeapBowNative(Weap).RemoveExplodingArrows();
            }            
        }        
    }
    // End:0x1EE
    if(inAction.mbNoDynamicPilotLightHack)
    {
        // End:0x1ED
        foreach invMan.InventoryActors(Class'TurokWeapon', Weap)
        {
            // End:0x1EC
            if(int(Weap.mWeaponType) == int(3))
            {
                fireblade = TurokWeapAttachFirebladeNative(Weap.GetAttachment());
                // End:0x1EC
                if(fireblade != none)
                {
                    fireblade.bDisablePilotLight = true;
                    fireblade.DisableWeaponLight(fireblade.mPilotFlameLight);
                }
            }            
        }        
    }
    invMan.mbDrawItemPickups = true;
    //return;    
}

simulated function OnGiveInventory(@NULL inAction)
{
    local int idx;
    local class<Class> InvClass;

    // End:0xB3
    if(inAction.InventoryList.Length > 0)
    {
        idx = 0;
        J0x1C:

        // End:0xB0 [Loop If]
        if(idx < inAction.InventoryList.Length)
        {
            InvClass = inAction.InventoryList[idx];
            // End:0x69
            if(InvClass != none)
            {
                CreateInventory(InvClass, true);
                // [Explicit Continue]
                goto J0xA6;
            }
            inAction.ScriptLog("WARNING: Attempting to give NULL inventory!");
            J0xA6:

            idx++;
            // [Loop Continue]
            goto J0x1C;
        }        
    }
    else
    {
        inAction.ScriptLog("WARNING: Give Inventory without any inventory specified!");
    }
    //return;    
}

simulated function OnAddImpulse(@NULL inAction)
{
    Mesh.AddImpulse(inAction.mImpulse);
    //return;    
}

simulated function class<Class> GetMaulDamageType()
{
    return mMaulDamageType;
    //return ReturnValue;    
}

simulated event FinishLadderGracefully()
{
    // End:0x1E
    if(mLadderController != none)
    {
        mLadderController.FinishLadderGracefully();
    }
    //return;    
}

simulated function TriggerFlames(@NULL HitLocation)
{
    mFireLocation = HitLocation;
    // End:0x29
    if(mFlameBones.Length == 0)
    {
        SpawnFlameEmitter(mFireLocation);        
    }
    else
    {
        SpawnFlameEmitterAtBone();
    }
    //return;    
}

simulated function OnFireBegin()
{
    FireReactionTimer();
    //return;    
}

function OnFireBeginServer(@NULL InstigatedBy, @NULL HitLocation, class<Class> DamageType)
{
    mFireInstigator = InstigatedBy;
    // End:0x28
    if(DamageType == Class'TurokDamageTypeFlameThrower')
    {
        mBurnTimeRemaining = mInitialBurnTime;        
    }
    else
    {
        mBurnTimeRemaining = mNapalmBurnTime;
    }
    mIsOnFire = true;
    SetTimer(mFireDamageInterval, true, 'FireDamageTimer');
    //return;    
}

simulated function OnFireEnd()
{
    local int I;

    // End:0x5F
    if(mFlameBones.Length != 0)
    {
        I = mFlameEmitters.Length - 1;
        J0x1B:

        // End:0x5F [Loop If]
        if(I >= 0)
        {
            // End:0x55
            if(mFlameEmitters[I] != none)
            {
                mFlameEmitters[I].ParticleSystemComponent.DeactivateSystem();
            }
            I--;
            // [Loop Continue]
            goto J0x1B;
        }
    }
    // End:0x82
    if(IsTimerActive('FireReactionTimer'))
    {
        ClearTimer('FireReactionTimer');
    }
    //return;    
}

function OnFireEndServer()
{
    mIsOnFire = false;
    // End:0x2B
    if(IsTimerActive('FireDamageTimer'))
    {
        ClearTimer('FireDamageTimer');
    }
    //return;    
}

simulated function SpawnFlameEmitter(@NULL SpawnLocation)
{
    local name ClosestBoneName;
    local @NULL ClosestBoneLocation;
    local int EmitterIndex;

    // End:0x0D
    if(mMaxNumFlames <= 0)
    {
        return;
    }
    CleanEmitterArray();
    // End:0x57
    if(mFlameEmitters.Length >= mMaxNumFlames)
    {
        mFlameEmitters[0].ParticleSystemComponent.DeactivateSystem();
        mFlameEmitters[0].Destroy();
        mFlameEmitters.Remove(0, 1);
    }
    EmitterIndex = mFlameEmitters.Length;
    mFlameEmitters[EmitterIndex] = __NFUN_278__(Class'TurokEmitter');
    mFlameEmitters[EmitterIndex].SetTemplate(mFlamePS, true);
    ClosestBoneName = Mesh.FindClosestBone(SpawnLocation, ClosestBoneLocation);
    mFlameEmitters[EmitterIndex].SetLocation(ClosestBoneLocation);
    mFlameEmitters[EmitterIndex].attachTo(self, ClosestBoneName);
    mFlameEmitters[EmitterIndex].SetDrawScale(mFlameEmitterScale);
    mFlameEmitters[EmitterIndex].LifeSpan = mBurnTimeRemaining;
    mFlameEmitters[EmitterIndex].ParticleSystemComponent.ActivateSystem();
    //return;    
}

simulated function SpawnFlameEmitterAtBone()
{
    local int Index;

    CleanEmitterArray();
    // End:0x132
    if(mFlameBones.Length > 0)
    {
        Index = 0;
        J0x1D:

        // End:0x132 [Loop If]
        if((Index < mFlameBones.Length) && Index < mMaxNumFlames)
        {
            // End:0x9A
            if((mFlameEmitters.Length <= Index) || mFlameEmitters[Index] == none)
            {
                mFlameEmitters[Index] = __NFUN_278__(Class'TurokEmitter');
                mFlameEmitters[Index].SetTemplate(mFlamePS, true);
            }
            mFlameEmitters[Index].SetLocation(Mesh.GetBoneLocation(name(mFlameBones[Index])));
            mFlameEmitters[Index].attachTo(self, name(mFlameBones[Index]));
            mFlameEmitters[Index].SetDrawScale(mFlameEmitterScale);
            mFlameEmitters[Index].ParticleSystemComponent.ActivateSystem();
            Index++;
            // [Loop Continue]
            goto J0x1D;
        }
    }
    //return;    
}

simulated event FireDamageTimer()
{
    TakeDamage(mFireDamage, mFireInstigator, Location, vect(0.0000000, 0.0000000, 0.0000000), Class'TurokDamageTypeFire', mFireHitInfo);
    CleanEmitterArray();
    //return;    
}

simulated event SetFireReactionTimer(float Duration)
{
    ClearTimer('FireReactionTimer');
    SetTimer(Duration, true, 'FireReactionTimer');
    //return;    
}

simulated event FireReactionTimer()
{
    // End:0x43
    if(mIsOnFire)
    {
        // End:0x40
        if(mbEnableImpactAnims)
        {
            InitiateLocalImpact(Class'TurokDamageTypeFire', vect(0.0000000, 0.0000000, 0.0000000), vect(0.0000000, 0.0000000, 0.0000000), mFireHitInfo);
        }        
    }
    else
    {
        ClearTimer('FireReactionTimer');
    }
    //return;    
}

simulated function CleanEmitterArray()
{
    local int I;

    I = mFlameEmitters.Length - 1;
    J0x0F:

    // End:0x5B [Loop If]
    if(I >= 0)
    {
        // End:0x51
        if((mFlameEmitters[I] == none) || mFlameEmitters[I].bDeleteMe)
        {
            mFlameEmitters.Remove(I, 1);
        }
        I--;
        // [Loop Continue]
        goto J0x0F;
    }
    //return;    
}

simulated function TakeRagdollImpulse(@NULL HitLocation, @NULL HitMomentum, class<Class> DamageType, optional @NULL HitInfo)
{
    CheckHitInfo(HitInfo, Mesh, Normal(HitMomentum), HitLocation);
    // End:0x49
    if((int(Physics) != int(10)) || HitMomentum == vect(0.0000000, 0.0000000, 0.0000000))
    {
        return;
    }
    // End:0xED
    if((HitInfo.BoneName != 'None') && !mbStuckToWorld)
    {
        // End:0xB6
        if(int(mRagdollState) != int(0))
        {
            Mesh.AddImpulse(HitMomentum / Mass, HitLocation, HitInfo.BoneName, true);            
        }
        else
        {
            Mesh.AddImpulse((HitMomentum * 0.5000000) / Mass, HitLocation, HitInfo.BoneName, true);
        }
    }
    //return;    
}

simulated event RemoveDeadBody()
{
    FreezeRagdoll();
    GotoState('SinkBodyExecute');
    //return;    
}

event PreCinematicStateCleanUp()
{
    //return;    
}

state CannedAnimation
{
    simulated function PushedState()
    {
        Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
        Velocity = vect(0.0000000, 0.0000000, 0.0000000);
        SetPhysics(12);
        //return;        
    }

    simulated function PoppedState()
    {
        // End:0x15
        if(int(Physics) == int(12))
        {
            SetPhysics(1);
        }
        //return;        
    }

    simulated function BeginState(name PreviousState)
    {
        PushedState();
        //return;        
    }

    simulated function EndState(name NextState)
    {
        PoppedState();
        //return;        
    }
    stop;    
}

state DieByMaulingAnimation extends CannedAnimation
{
    event TakeDamage(int Damage, @NULL InstigatedBy, @NULL HitLocation, @NULL Momentum, class<Class> DamageType, optional @NULL HitInfo, optional @NULL DamageCauser)
    {
        local class<Class> tDamageType;

        tDamageType = class<TurokDamageType>(DamageType);
        // End:0x5E
        if((tDamageType != none) && tDamageType.static.IsMaulType())
        {
            super(TurokPawn).TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
        }
        //return;        
    }
    stop;    
}

state AttackerMaulAnimation extends CannedAnimation
{
    simulated function BeginState(name prevState)
    {
        mbIsMauling = true;
        super.BeginState(prevState);
        //return;        
    }

    simulated function EndState(name NextState)
    {
        mbIsMauling = false;
        super.EndState(NextState);
        //return;        
    }
    stop;    
}

state climbing
{
    simulated event bool ShouldApplyCameraReposition()
    {
        return false;
        //return ReturnValue;        
    }

    simulated function Tick(float DeltaTime)
    {
        // End:0x36
        if(TurokPlayerController(Controller) != none)
        {
            TurokPlayerController(Controller).mHitReactionManager.UpdateGroggy(DeltaTime);
        }
        // End:0x61
        if(int(Physics) == int(9))
        {
            mLadderController.Tick(DeltaTime);            
        }
        else
        {
            EndClimbing();
        }
        //return;        
    }

    simulated function BeginState(name PreviousState)
    {
        local @NULL R;

        // End:0x27
        if(PlayerController(Controller) != none)
        {
            Controller.GotoState('PlayerClimbing');
        }
        // End:0x4B
        if(int(Role) == int(ROLE_Authority))
        {
            mLadderVolume.MarkLadderInUse(self);
        }
        // End:0xB9
        if(int(Role) > int(ROLE_SimulatedProxy))
        {
            R = mLadderVolume.GetStartRotationFromPawnPosition(self);
            Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
            Velocity = vect(0.0000000, 0.0000000, 0.0000000);
            SetRotation(R);
            Controller.SetRotation(R);
            SetPhysics(9);
        }
        mbEnableImpactAnims = false;
        mLadderController.InitSequence();
        //return;        
    }

    simulated function EndState(name NextState)
    {
        // End:0x24
        if(int(Role) == int(ROLE_Authority))
        {
            mLadderVolume.MarkLadderNotInUse(self);
        }
        // End:0x3E
        if(int(Physics) == int(9))
        {
            SetMovementPhysics();
        }
        mLadderController.SetClimbing(false);
        OnLadder = none;
        mLadderVolume = none;
        mbEnableImpactAnims = true;
        //return;        
    }

    simulated function bool DoJump(bool bUpdating)
    {
        // End:0x67
        if(((mLadderController.IsClimbing() && !mLadderController.IsDuringEndAnimation()) && !mLadderController.IsDuringStartAnimation()) && super(TurokPawn).DoJump(bUpdating))
        {
            EndClimbing();
            return true;
        }
        return false;
        //return ReturnValue;        
    }

    simulated function EndClimbing()
    {
        // End:0x18
        if(IsPlayingGraphFromGraphSet(mClimbingGraphSet))
        {
            AnimInterruptToLoco();
        }
        mLadderController.FinishLadderGracefully();
        // End:0x71
        if(TurokPlayerController(Controller) != none)
        {
            // End:0x71
            if(TurokPlayerController(Controller).IsInState('PlayerClimbing'))
            {
                TurokPlayerController(Controller).ReturnToWalking();
            }
        }
        GotoState('Auto');
        //return;        
    }

    simulated event bool AllowMauling()
    {
        return false;
        //return ReturnValue;        
    }
    stop;    
}

state Dying
{
    simulated function CheckRagDoll()
    {
        // End:0x1A
        if(mbDraggedByArrow)
        {
            GotoState('DeadRagDollDragging');            
        }
        else
        {
            // End:0x34
            if(CanFreezeRagdoll())
            {
                GotoState('DeadRagDollFrozen');                
            }
            else
            {
                SetTimer(mfRagdollRetryTimer, false, 'CheckRagDoll');
            }
        }
        //return;        
    }

    simulated function RagDollSleepTimeout()
    {
        GotoState('DeadRagDollFrozen');
        //return;        
    }

    simulated function OnAnimEnd(@NULL Anim, float PlayedTime, float ExcessTime)
    {
        // End:0x2C
        if(int(mRagdollState) == int(0))
        {
            PowerConstraints(1, 0.0000000, 1.0000000, 0.0000000, 0.0000000);
        }
        SetRagDollTimers();
        //return;        
    }

    simulated event TakeImpact(class<Class> DamageType, float Damage, @NULL HitLocation, @NULL HitMomentum, @NULL HitInfo)
    {
        local float scaleDamage;

        scaleDamage = GetDamageScale(HitInfo, DamageType);
        // End:0x34
        if(scaleDamage <= 0.0000000)
        {
            scaleDamage = 1.0000000;
        }
        Damage *= scaleDamage;
        RevealDamageTexture(int(Damage), DamageType);
        // End:0x8C
        if(EffectIsRelevant(Location, false, 0.0000000))
        {
            TakeRagdollImpulse(HitLocation, HitMomentum, DamageType, HitInfo);
        }
        //return;        
    }

    simulated function SetRagDollTimers()
    {
        SetTimer(mfCoolDownSeconds, false, 'CheckRagDoll');
        SetTimer(mfRagdollSleepTimeout, false, 'RagDollSleepTimeout');
        //return;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        local int I;

        DeActivateAllSkeletalHurt();
        // End:0x22
        if(TurokDoorMoverVolume(PhysicsVolume) != none)
        {
            mfRagdollSleepTimeout /= 5.0000000;
        }
        // End:0x37
        if(int(Physics) != int(10))
        {
            SetPhysics(2);
        }
        SetCollision(true, false);
        // End:0x7C
        if(Controller != none)
        {
            // End:0x68
            if(Controller.bIsPlayer)
            {
                DetachFromController();                
            }
            else
            {
                Controller.PawnDied(self);
            }
        }
        I = 0;
        J0x83:

        // End:0xC7 [Loop If]
        if(I < Attached.Length)
        {
            // End:0xBD
            if(Attached[I] != none)
            {
                Attached[I].PawnBaseDied();
            }
            I++;
            // [Loop Continue]
            goto J0x83;
        }
        ClearAnimAIInterface();
        // End:0xE2
        if(!mbPlayedDeathAnimation)
        {
            SetRagDollTimers();
        }
        // End:0xF5
        if(mbUseDeadBodyManager)
        {
            AddToDeadBodyManager();
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        // End:0x23
        if(IsTimerActive('CheckRagDoll'))
        {
            ClearTimer('CheckRagDoll');
        }
        // End:0x46
        if(IsTimerActive('RagDollSleepTimeout'))
        {
            ClearTimer('RagDollSleepTimeout');
        }
        // End:0x57
        if(IsLocallyControlled())
        {
            mbCanTriggerSounds = false;
        }
        //return;        
    }
    stop;    
}

state DeadRagDollFrozen
{
    simulated event RemoveDeadBody()
    {
        GotoState('SinkBodyExecute');
        //return;        
    }

    simulated event Timer()
    {
        // End:0x15
        if(!LocalPlayerCanSeeMe())
        {
            Destroy();            
        }
        else
        {
            SetTimer(mfRagdollRetryTimer, false);
        }
        //return;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        local @NULL cogLocation, doorVolume;

        FreezeRagdoll();
        cogLocation = Mesh.GetBoneLocation('jt_Cog_C');
        // End:0x6B
        foreach CollidingActors(Class'TurokDoorMoverVolume', doorVolume, GetCollisionRadius(), cogLocation, true)
        {
            doorVolume.PawnLeavingVolume(self);
            GotoState('SinkBodyExecute');            
            return;            
        }        
        // End:0x8C
        if(InterpActor(Base) != none)
        {
            GotoState('SinkBodyExecute');
            return;
        }
        // End:0xA5
        if(!mbUseDeadBodyManager)
        {
            SetTimer(2.0000000, false);            
        }
        else
        {
            StopTicking();
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        SetPhysics(0);
        //return;        
    }
    stop;    
}

state DeadRagDollStuckToWorld
{
    simulated function WaitForUnstuck()
    {
        // End:0x2F
        if((mStickingArrow != none) && mbStuckToWorld == true)
        {
            SetTimer(1.0000000, false, 'WaitForUnstuck');            
        }
        else
        {
            // End:0x70
            if(int(Physics) == int(10))
            {
                mbStuckToWorld = false;
                SetTimer(mfCoolDownSeconds, false, 'CheckRagDoll');
                SetTimer(mfRagdollSleepTimeout, false, 'RagDollSleepTimeout');                
            }
            else
            {
                mbStuckToWorld = false;
                GotoState('DeadRagDollFrozen');
            }
        }
        //return;        
    }

    simulated function CheckRagDoll()
    {
        // End:0x1A
        if(CanFreezeRagdoll())
        {
            GotoState('DeadRagDollFrozen');            
        }
        else
        {
            SetTimer(mfRagdollRetryTimer, false, 'CheckRagDoll');
        }
        //return;        
    }

    simulated function RagDollSleepTimeout()
    {
        GotoState('DeadRagDollFrozen');
        //return;        
    }

    simulated event TakeImpact(class<Class> DamageType, float Damage, @NULL HitLocation, @NULL HitMomentum, @NULL HitInfo)
    {
        // End:0x36
        if(EffectIsRelevant(Location, false, 0.0000000))
        {
            TakeRagdollImpulse(HitLocation, HitMomentum, DamageType, HitInfo);
        }
        //return;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        WaitForUnstuck();
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        // End:0x23
        if(IsTimerActive('WaitForUnstuck'))
        {
            ClearTimer('WaitForUnstuck');
        }
        // End:0x46
        if(IsTimerActive('CheckRagDoll'))
        {
            ClearTimer('CheckRagDoll');
        }
        // End:0x69
        if(IsTimerActive('RagDollSleepTimeout'))
        {
            ClearTimer('RagDollSleepTimeout');
        }
        //return;        
    }
    stop;    
}

state DeadRagDollDragging
{
    simulated function MonitorDraggingRagDoll()
    {
        // End:0x34
        if(mbDraggedByArrow)
        {
            // End:0x31
            if(!IsTimerActive('MonitorDraggingRagDoll'))
            {
                SetTimer(0.1000000, true, 'MonitorDraggingRagDoll');
            }            
        }
        else
        {
            ClearTimer('MonitorDraggingRagDoll');
            GotoState('DeadRagDollStuckToWorld');
        }
        //return;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        MonitorDraggingRagDoll();
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        // End:0x23
        if(IsTimerActive('MonitorDraggingRagDoll'))
        {
            ClearTimer('MonitorDraggingRagDoll');
        }
        //return;        
    }
    stop;    
}

state SinkBodyExecute
{
    simulated function Tick(float DeltaTime)
    {
        local @NULL SinkVector;

        SinkVector.X = 0.0000000;
        SinkVector.Y = 0.0000000;
        SinkVector.Z = -mfSinkBodySpeed * DeltaTime;
        Move(SinkVector);
        mfSinkDist -= (mfSinkBodySpeed * DeltaTime);
        // End:0x94
        if(mfSinkDist < float(0))
        {
            Mesh.SetHidden(true);
            Mesh.bUpdateAnimWhenNotRendered = false;
            Destroy();
        }
        //return;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        local @NULL HitActor, MyLocation, HitLocation, HitNormal, SpawnRotation, DownDist;

        StartTicking();
        MyLocation = Mesh.GetBoneLocation('jt_Cog_C');
        DownDist.X = 0.0000000;
        DownDist.Y = 0.0000000;
        DownDist.Z = (GetCollisionHeight()) * 2.0000000;
        HitActor = Trace(HitLocation, HitNormal, MyLocation - DownDist, MyLocation, false);
        // End:0x175
        if(mSinkPS != none)
        {
            // End:0x175
            if(EffectIsRelevant(Location, false, 0.0000000))
            {
                // End:0x175
                if(HitActor != none)
                {
                    SpawnRotation.Yaw = 0;
                    SpawnRotation.Pitch = 0;
                    SpawnRotation.Roll = 0;
                    mpSinkEmitter = __NFUN_278__(Class'TurokEmitter',,, HitLocation, SpawnRotation);
                    // End:0x175
                    if(mpSinkEmitter != none)
                    {
                        mpSinkEmitter.SetFloatParameter('SpawnRadius', Mesh.Bounds.SphereRadius * 0.7500000);
                        mpSinkEmitter.SetTemplate(mSinkPS, false);
                    }
                }
            }
        }
        mfSinkDist = (GetCollisionHeight()) * 4.0000000;
        //return;        
    }
    stop;    
}

state KismetState
{
    function BeginState(name PreviousStateName)
    {
        PushedState();
        //return;        
    }

    function EndState(name NextStateName)
    {
        PoppedState();
        //return;        
    }

    function PushedState()
    {
        PauseAllTimers();
        //return;        
    }

    function PoppedState()
    {
        UnpauseAllTimers();
        //return;        
    }

    simulated event bool AllowMauling()
    {
        return false;
        //return ReturnValue;        
    }
    stop;    
}

state ScriptedMoveState extends KismetState
{
    function PushedState()
    {
        // End:0x15
        if(int(Physics) == int(12))
        {
            SetPhysics(1);
        }
        PauseAllTimers();
        //return;        
    }
    stop;    
}

state CinematicState extends KismetState
{    stop;    
}

state TrackPlayerState extends KismetState
{    stop;    
}

state ScriptedIdleState extends KismetState
{    stop;    
}

state PlayTransitionGraphState extends KismetState
{    stop;    
}

defaultproperties
{
    // Reference: TurokAISteer'Default__TurokPawn.TurokAISteerComponent'
    begin object name=TurokAISteerComponent class=Class'TurokAISteer'
    end object
    mSteer=TurokAISteerComponent
    // Reference: TurokAIPlanner'Default__TurokPawn.TurokAIPlannerComponent'
    begin object name=TurokAIPlannerComponent class=Class'TurokAIPlanner'
    end object
    mPlanner=TurokAIPlannerComponent
    // Reference: DynamicLightEnvironmentComponent'Default__TurokPawn.MyLightEnvironment'
    begin object name=MyLightEnvironment class=Class'Engine.DynamicLightEnvironmentComponent'
    end object
    LightEnvironment=MyLightEnvironment
    mbCanBeKnockedDownByArrows=true
    mUpdateRange=10000.0000000
    mLookSphereRadius=3000.0000000
    mRandomSphereRadius=1750.0000000
    mWeightCurrent=10.0000000
    mWeightTarget=1.0000000
    mAngleThreshold=0.5000000
    mLookSphereDistance=3500.0000000
    mLookSphereHeight=200.0000000
    mReplicatedStunFactor=255
    mbEnableImpactAnims=true
    mbUseDeadBodyManager=true
    mFlammable=true
    mbCanTriggerSounds=true
    mbUseDesiredSpeed=true
    mbAllowRagdollFromSkeletalHurtDamage=true
    mbUsePoweredRagdoll=true
    mValidTarget=true
    mCanBeStealthKilled=true
    mbConsiderAnchorCostsWhenPathing=true
    // Reference: TurokPathController'Default__TurokPawn.TurokPathControllerComponent'
    begin object name=TurokPathControllerComponent class=Class'TurokPathController'
    end object
    mPathController=TurokPathControllerComponent
    // Reference: TurokTargetingSystem'Default__TurokPawn.TurokTargetingSystemComponent'
    begin object name=TurokTargetingSystemComponent class=Class'TurokTargetingSystem'
    end object
    mTargetingSystem=TurokTargetingSystemComponent
    mBaseWaterSpeed=200.0000000
    mBaseAirSpeed=425.0000000
    mBaseLadderSpeed=100.0000000
    mUnarmedMoveBonus=1.0000000
    mLandPenalty=1.0000000
    mDamageReactionHealth=200
    mfSinkBodySpeed=100.0000000
    mSinkPS=ParticleSystem'FXSmokes.ParticleSystems.SinkingBodyPS'
    mFlamePS=ParticleSystem'FXFires.ParticleSystems.PawnOnFirePS'
    mFlameEmitterScale=1.0000000
    mFireDamageInterval=1.0000000
    mMinTimeBetweenFlameSpawn=0.5000000
    mMaxTazerStunTime=2.0000000
    // Reference: TurokSoundController'Default__TurokPawn.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent class=Class'TurokSoundController'
        mLimitedSounds=/* Array type was not detected. */
    end object
    mSoundController=TurokSoundControllerComponent
    mWeaponAmbientSndChannelIndex=-1
    mFoleyOffset=-0.0200000
    mGrassFootstepSound=SoundCue'SndBushInteraction.BushSmall'
    mMinGrassSoundThresh=5.0000000
    mMaxFootstepDistance=1600.0000000
    mPawnIdleSndChannel=-1
    mPawnAmbientSndChannel=-1
    mImpactNoiseLevel=0.5000000
    mMaxWeaponImpactAC=2
    mMinDamagePcntToTriggerAudio=0.0200000
    mFootStepEffects=/* Array type was not detected. */
    mMinFootstepVolume=0.7000000
    mMinLeanYaw=50
    mMaxLeanYaw=350
    mMinLeanSpeed=0.2500000
    mMaxLeanSpeed=0.5000000
    mLeanNormalBlendSpeed=0.0500000
    mLeanFastBlendSpeed=0.2000000
    mLeanOffBlendSpeed=0.8000000
    mLeashRadius=3000.0000000
    mStunMovementFactor=1.0000000
    mCumulativeDamageResetTime=-1.0000000
    mSmallestStandingTurnAnim=45.0000000
    mSmallestRunningTurnAnim=90.0000000
    mHorizontalJumpModifier=0.5000000
    mVerticalJumpModifier=1.1000000
    mHorizontalSpeedJumpModifier=1.0000000
    mVerticalSpeedJumpModifier=0.1000000
    mMaulDamageType=Class'TurokDamageTypeMaulRaptor'
    mTerrainFollowRayLengthMultiplier=1.1000000
    mActiveRecoveryPose=-1
    mMaxCombatFlareDistractions=2
    mMaxTerror=100
    mGrassCollVolName="CollisionVolumeController"
    mVisibility=1.0000000
    mFlareTrackingTime=20.0000000
    // Reference: TurokAnimLadderController'Default__TurokPawn.ladderController'
    begin object name=ladderController class=Class'TurokAnimLadderController'
    end object
    mLadderController=ladderController
    mPawnCollisionRadius=16.0000000
    mExtentBones=/* Array type was not detected. */
    mReachableValidTime=0.2500000
    mIdleNodeSelectionChance=100
    mForceReachNodeDist=50.0000000
    mJumpUpGraphName="divefwd"
    mJumpDownGraphName="divefwd"
    mJumpOverGraphName="divefwd"
    mRunOutRightGraphName="divefwd"
    mRunOutLeftGraphName="divefwd"
    mScanDistance=48.0000000
    mLeapTriggerDistance=16.0000000
    mBloodDecalMaxDistance=400.0000000
    mBloodDecalMaxSize=200.0000000
    mBloodDecalMinSize=100.0000000
    mAIUsageCost=1.0000000
    MaxStepHeight=30.0000000
    bJumpCapable=false
    bCanClimbLadders=true
    bSimulateGravity=false
    bCanWalkOffLedges=true
    bMuffledHearing=true
    bAroundCornerHearing=true
    PathSearchType=3
    GroundSpeed=425.0000000
    WaterSpeed=200.0000000
    AirSpeed=425.0000000
    LadderSpeed=150.0000000
    Health=1
    // Reference: SkeletalMeshComponent'Default__TurokPawn.TurokSkeletalMeshComponent'
    begin object name=TurokSkeletalMeshComponent class=Class'Engine.SkeletalMeshComponent'
        bExtractRootMotion=true
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokPawn.MyLightEnvironment'
        CollideActors=true
        BlockActors=true
        BlockZeroExtent=true
        RBChannel=2
        RBCollideWithChannels=(GameplayPhysics=true,EffectPhysics=true)
        ScriptRigidBodyCollisionThreshold=10.0000000
    end object
    Mesh=TurokSkeletalMeshComponent
    // Reference: CylinderComponent'Default__TurokPawn.CollisionCylinder'
    begin object name=CollisionCylinder
        BlockZeroExtent=false
    end object
    CylinderComponent=CollisionCylinder
    InventoryManagerClass=none
    mDefaultTraceTypeFlags=131072
    mDefaultTraceSourceFlags=528
    bNetInitialRotation=true
    Components[0]=CollisionCylinder
    // Reference: ArrowComponent'Default__TurokPawn.Arrow'
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
    Mass=1.0000000
    SupportedEvents=/* Array type was not detected. */
}