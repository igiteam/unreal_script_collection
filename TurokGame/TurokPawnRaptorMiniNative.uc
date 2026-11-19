class TurokPawnRaptorMiniNative extends TurokPawnDino
    abstract
    native
    config(Pawn)
    hidecategories(Navigation);

var(TurokPawnRaptorMini) float mScoutRange;
var(TurokPawnRaptorMini) editconst float mMaxAttackRange;
var(TurokPawnRaptorMini) editconst float mMinAttackRange;
var(TurokPawnRaptorMini) int mPackAttackSize;
var(TurokPawnRaptorMini) @NULL mCuriousGraphSet;
var(ParticleEffects) @NULL mDeadParticleSystem;
var bool mbWasGibbed;

// Export UTurokPawnRaptorMiniNative::execAllowMauling(FFrame&, void* const)
native simulated function bool AllowMauling();

simulated event bool CanAutoAimTo()
{
    return false;
    //return ReturnValue;    
}

simulated function bool CanBeDraggedByArrow()
{
    return true;
    //return ReturnValue;    
}

simulated function PostBeginPlay()
{
    local @NULL pos, Rot;
    local float Range, Radius;
    local @NULL graph;

    super(TurokPawn).PostBeginPlay();
    mMaxAttackRange = mEvasionRange;
    mMinAttackRange = SightRadius;
    // End:0x91
    foreach mAttackGraphSet.Graphs(graph)
    {
        // End:0x90
        if(graph.GetCharacterCannedContactPoint(Mesh, pos, Rot, Radius, 0))
        {
            Range = VSize(pos);
            mMaxAttackRange = FMax(Range, mMaxAttackRange);
            mMinAttackRange = FMin(Range, mMinAttackRange);
        }        
    }    
    mScoutRange = FMax((mMaxAttackRange + mMinAttackRange) / 2.0000000, mScoutRange);
    //return;    
}

function TakeDamage(int Damage, @NULL InstigatedBy, @NULL HitLocation, @NULL Momentum, class<Class> DamageType, optional @NULL HitInfo, optional @NULL DamageCauser)
{
    // End:0x70
    if(((int(DamageType.default.mReactionType) == int(2)) && Damage >= Health) && mDeadParticleSystem != none)
    {
        mbWasGibbed = true;
        super(TurokPawn).TakeDamage(Health + 1, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);        
    }
    else
    {
        super(TurokPawn).TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    }
    //return;    
}

state Dying
{
    simulated function BeginState(name PreviousStateName)
    {
        local @NULL impactEmitter, emitterPool;

        super.BeginState(PreviousStateName);
        // End:0x94
        if(mbWasGibbed && mDeadParticleSystem != none)
        {
            emitterPool = Class'TurokPlayerController'.static.GetLocalPlayerController().GetEmitterManager();
            impactEmitter = TurokEmitter(emitterPool.GetEmitter(mDeadParticleSystem, self, Location));
            impactEmitter.mSoundController.TryPlayLocalSound(mDeathSndCue);
            Destroy();
        }
        //return;        
    }
    stop;    
}

defaultproperties
{
    mScoutRange=300.0000000
    mPackAttackSize=2
    mDeadParticleSystem=ParticleSystem'FXCreatureInteraction.ParticleSystems.MiniRaptorGoreExplosionPS'
    mEvasionRange=96.0000000
    mTailAttackEnable=false
    // Reference: TurokRadialShakeComponent'Default__TurokPawnRaptorMiniNative.Shakey'
    begin object name=Shakey
    end object
    mFootStompCamShake=Shakey
    // Reference: TurokAttackFormation'Default__TurokPawnRaptorMiniNative.TurokAFComponent'
    begin object name=TurokAFComponent class=Class'TurokAttackFormation'
        mSpacing=325.0000000
        mAngle=(Pitch=0,Yaw=20024,Roll=0)
        mRankNumbers=4
    end object
    mAttackFormation=TurokAFComponent
    // Reference: TurokAISteer'Default__TurokPawnRaptorMiniNative.TurokAISteerComponent'
    begin object name=TurokAISteerComponent
        mMinSteerSpeedRate=0.1000000
        mDefaultMinSpeedInterpRate=8.0000000
        mDefaultMaxSpeedInterpRate=0.2500000
        mSteeringDecelerationRate=0.0150000
        mSteeringPreset=/* Array type was not detected. */
        mDefaultWallAvoidanceDistanceForward=70.0000000
        mDefaultWallAvoidanceDistanceSide=70.0000000
    end object
    mSteer=TurokAISteerComponent
    // Reference: TurokAIPlanner'Default__TurokPawnRaptorMiniNative.TurokAIPlannerComponent'
    begin object name=TurokAIPlannerComponent
        mAIGoal=/* Array type was not detected. */
    end object
    mPlanner=TurokAIPlannerComponent
    // Reference: DynamicLightEnvironmentComponent'Default__TurokPawnRaptorMiniNative.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    mTerrainFollowType=1
    mbAllowDinoMelee=true
    mValidTarget=false
    // Reference: TurokPathController'Default__TurokPawnRaptorMiniNative.TurokPathControllerComponent'
    begin object name=TurokPathControllerComponent
    end object
    mPathController=TurokPathControllerComponent
    // Reference: TurokTargetingSystem'Default__TurokPawnRaptorMiniNative.TurokTargetingSystemComponent'
    begin object name=TurokTargetingSystemComponent
        mTargetType=7
    end object
    mTargetingSystem=TurokTargetingSystemComponent
    // Reference: TurokSoundController'Default__TurokPawnRaptorMiniNative.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent
    end object
    mSoundController=TurokSoundControllerComponent
    mMaxLeanAngle=4096
    mMaulDamageType=Class'TurokDamageTypeMaulRaptorMini'
    mTerrainSampleRadius=5.0000000
    mTerrainSinkHeight=1.5000000
    mPartialRagdollFixedJoints=/* Array type was not detected. */
    mCollisionEventJoints=/* Array type was not detected. */
    mSkeletalHurt=/* Array type was not detected. */
    // Reference: TurokAnimLadderController'Default__TurokPawnRaptorMiniNative.ladderController'
    begin object name=ladderController
    end object
    mLadderController=ladderController
    mForceReachNodeDist=200.0000000
    SightRadius=960.0000000
    PeripheralVision=-0.7070000
    MeleeRange=96.0000000
    GroundSpeed=675.0000000
    AccelRate=512.0000000
    BaseEyeHeight=25.0000000
    EyeHeight=25.0000000
    // Reference: SkeletalMeshComponent'Default__TurokPawnRaptorMiniNative.TurokSkeletalMeshComponent'
    begin object name=TurokSkeletalMeshComponent
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokPawnRaptorMiniNative.MyLightEnvironment'
    end object
    Mesh=TurokSkeletalMeshComponent
    // Reference: CylinderComponent'Default__TurokPawnRaptorMiniNative.CollisionCylinder'
    begin object name=CollisionCylinder
        CollisionHeight=25.0000000
        CollisionRadius=12.5000000
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    // Reference: ArrowComponent'Default__TurokPawnRaptorMiniNative.Arrow'
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
    Components[10]=TurokAFComponent
    Physics=1
    DrawScale=0.5000000
    CollisionComponent=CollisionCylinder
}