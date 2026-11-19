class TurokPawnBossWaterNative extends TurokPawn
    abstract
    native
    config(Pawn)
    hidecategories(Navigation);

var @NULL mGraphSet;
var @NULL mBiteAsset;
var name mBiteControllerName;
var @NULL mBiteLookAsset;
var name mBiteLookControllerName;
var @NULL mFarBiteAsset;
var name mFarBiteControllerName;
var @NULL mThrowLookAsset;
var name mThrowLookControllerName;
var @NULL mThrowAsset;
var name mThrowControllerName;
var bool mIsInLowState;
var bool mPlayingSBA;
var(AttackPattern) config int mHealthThresholdAlpha;
var(AttackPattern) config int mHealthThresholdOmikron;
var(AttackPattern) config int mHealthThresholdTau;
var(AttackPattern) config float mAlphaTrackTime;
var(AttackPattern) config float mOmikronTrackTime;
var(AttackPattern) config float mTauTrackTime;
var(AttackPattern) config float mOmegaTrackTime;
var(AttackPattern) config float mGeyserDamage;
var(AttackPattern) config float mFlameThrowerDamage;
var(AttackPattern) config float mRPGDamage;
var(AttackPattern) config float mOtherDamage;
var(AttackPattern) config float mHitReactionThreshold;
var(AttackPattern) config float mSwipeDamage;
var(AttackPattern) config float mBiteDamage;
var(AttackPattern) config float mDamageRadius;
var(Sound) @NULL mPickRockSndCue;
var @NULL damageVolumeWatcher;
var class<Class> mProjectileRockClass;
var class<Class> mProjectileStalactiteClass;

// Export UTurokPawnBossWaterNative::execAttachRock(FFrame&, void* const)
native final function AttachRock(@NULL S, name BoneName);

// Export UTurokPawnBossWaterNative::execAttachStalactites(FFrame&, void* const)
native final function AttachStalactites(@NULL S, name boneNameLeft, name boneNameRight);

// Export UTurokPawnBossWaterNative::execDetachRock(FFrame&, void* const)
native final function DetachRock(@NULL S);

// Export UTurokPawnBossWaterNative::execDetachRockLeft(FFrame&, void* const)
native final function DetachRockLeft(@NULL S);

// Export UTurokPawnBossWaterNative::execDetachRockRight(FFrame&, void* const)
native final function DetachRockRight(@NULL S);

simulated function bool ArrowCanStickInto()
{
    return false;
    //return ReturnValue;    
}

simulated function PostBeginPlay()
{
    // End:0xC4
    if(int(Role) == int(ROLE_Authority))
    {
        damageVolumeWatcher = __NFUN_278__(Class'TurokSkeletonInVolumeWatcher', self);
        damageVolumeWatcher.mBoneNames[0] = 'jt_Head_C';
        damageVolumeWatcher.mBoneNames[1] = 'jt_Neck9_C';
        damageVolumeWatcher.mBoneNames[2] = 'jt_Neck8_C';
        damageVolumeWatcher.mBoneNames[3] = 'jt_Neck7_C';
        damageVolumeWatcher.mBoneNames[4] = 'jt_Neck6_C';
        damageVolumeWatcher.mBoneNames[5] = 'jt_Neck5_C';
    }
    super.PostBeginPlay();
    //return;    
}

simulated event Destroyed()
{
    // End:0x1E
    if(damageVolumeWatcher != none)
    {
        damageVolumeWatcher.Destroy();
        damageVolumeWatcher = none;
    }
    super.Destroyed();
    //return;    
}

// Export UTurokPawnBossWaterNative::execCanHurt(FFrame&, void* const)
native function bool CanHurt(@NULL Other, optional class<Class> DamageType);

event TakeDamage(int Damage, @NULL InstigatedBy, @NULL HitLocation, @NULL Momentum, class<Class> DamageType, optional @NULL HitInfo, optional @NULL DamageCauser)
{
    // End:0x50
    if(Damage >= Health)
    {
        Damage = Health - 1;
        DeActivateSkeletalHurt(1);
        DeActivateSkeletalHurt(2);
        DetachRock(Mesh);
        DetachRockLeft(Mesh);
        DetachRockRight(Mesh);
    }
    super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo);
    //return;    
}

simulated function NotifySkelInVolume(@NULL vol, name BoneName, @NULL BoneLocation)
{
    // End:0x4E
    if(!IsTimerActive('damageTimer'))
    {
        SetTimer(3.0000000, false, 'damageTimer');
        TakeDamage(150, none, BoneLocation, vect(0.0000000, 0.0000000, 0.0000000), Class'TurokDamageTypeGeyser');
    }
    //return;    
}

simulated function damageTimer()
{
    ClearTimer('damageTimer');
    //return;    
}

simulated function OnAnimEnd(@NULL Anim, float PlayedTime, float ExcessTime)
{
    mPlayingSBA = false;
    //return;    
}

function AdjustDamage(out int inDamage, out @NULL Momentum, @NULL InstigatedBy, @NULL HitLocation, class<Class> DamageType, optional @NULL HitInfo)
{
    super.AdjustDamage(inDamage, Momentum, InstigatedBy, HitLocation, DamageType, HitInfo);
    // End:0x44
    if(DamageType == Class'TurokDamageTypeGeyser')
    {
        inDamage = int(mGeyserDamage);        
    }
    else
    {
        // End:0x63
        if(DamageType == Class'TurokDamageTypeFlameThrower')
        {
            inDamage = int(mFlameThrowerDamage);            
        }
        else
        {
            // End:0x93
            if((DamageType == Class'TurokDamageTypeRPG') || DamageType == Class'TurokDamageTypeNapalmGrenade')
            {
                inDamage = int(mRPGDamage);                
            }
            else
            {
                inDamage = int(mOtherDamage);
            }
        }
    }
    // End:0xBD
    if(inDamage >= Health)
    {
        inDamage = Health - 1;
    }
    //return;    
}

simulated event PickUpRock(name BoneName)
{
    mSoundController.TryPlayLocalSound(mPickRockSndCue);
    AttachRock(Mesh, BoneName);
    //return;    
}

simulated event HideRock()
{
    DetachRock(Mesh);
    //return;    
}

simulated event @NULL RockFire(@NULL Target, name BoneName)
{
    local @NULL AimDir, RealStartLoc, qOrientataion, rOrientataion, SpawnedProjectile;

    // End:0x111
    if(int(Role) == int(ROLE_Authority))
    {
        RealStartLoc = Mesh.GetBoneLocation(BoneName);
        qOrientataion = Mesh.GetBoneQuaternion(BoneName);
        rOrientataion = QuatToRotator(qOrientataion);
        AimDir = (0.8500000 * Normal(Target - RealStartLoc)) + (0.1500000 * vect(0.0000000, 0.0000000, 1.0000000));
        SpawnedProjectile = __NFUN_278__(mProjectileRockClass, self, 'Rock', RealStartLoc);
        // End:0x10B
        if((SpawnedProjectile != none) && !SpawnedProjectile.bDeleteMe)
        {
            SpawnedProjectile.Init(AimDir);
            TurokProjStalactiteNative(SpawnedProjectile).SetRotation(rOrientataion);
            TurokProjStalactiteNative(SpawnedProjectile).InitSpin();
        }
        return SpawnedProjectile;
    }
    return none;
    //return ReturnValue;    
}

simulated event @NULL StalactiteFire(@NULL Target, name BoneName)
{
    local @NULL AimDir, RealStartLoc, qOrientataion, rOrientataion, SpawnedProjectile;

    // End:0x111
    if(int(Role) == int(ROLE_Authority))
    {
        RealStartLoc = Mesh.GetBoneLocation(BoneName);
        qOrientataion = Mesh.GetBoneQuaternion(BoneName);
        rOrientataion = QuatToRotator(qOrientataion);
        AimDir = (0.8500000 * Normal(Target - RealStartLoc)) + (0.1500000 * vect(0.0000000, 0.0000000, 1.0000000));
        SpawnedProjectile = __NFUN_278__(mProjectileStalactiteClass, self, 'Rock', RealStartLoc);
        // End:0x10B
        if((SpawnedProjectile != none) && !SpawnedProjectile.bDeleteMe)
        {
            SpawnedProjectile.Init(AimDir);
            TurokProjStalactiteNative(SpawnedProjectile).SetRotation(rOrientataion);
            TurokProjStalactiteNative(SpawnedProjectile).InitSpin();
        }
        return SpawnedProjectile;
    }
    return none;
    //return ReturnValue;    
}

defaultproperties
{
    // Reference: TurokAISteer'Default__TurokPawnBossWaterNative.TurokAISteerComponent'
    begin object name=TurokAISteerComponent
    end object
    mSteer=TurokAISteerComponent
    // Reference: TurokAIPlanner'Default__TurokPawnBossWaterNative.TurokAIPlannerComponent'
    begin object name=TurokAIPlannerComponent
    end object
    mPlanner=TurokAIPlannerComponent
    // Reference: DynamicLightEnvironmentComponent'Default__TurokPawnBossWaterNative.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: TurokPathController'Default__TurokPawnBossWaterNative.TurokPathControllerComponent'
    begin object name=TurokPathControllerComponent
    end object
    mPathController=TurokPathControllerComponent
    // Reference: TurokTargetingSystem'Default__TurokPawnBossWaterNative.TurokTargetingSystemComponent'
    begin object name=TurokTargetingSystemComponent
    end object
    mTargetingSystem=TurokTargetingSystemComponent
    // Reference: TurokSoundController'Default__TurokPawnBossWaterNative.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent
    end object
    mSoundController=TurokSoundControllerComponent
    // Reference: TurokAnimLadderController'Default__TurokPawnBossWaterNative.ladderController'
    begin object name=ladderController
    end object
    mLadderController=ladderController
    // Reference: SkeletalMeshComponent'Default__TurokPawnBossWaterNative.TurokSkeletalMeshComponent'
    begin object name=TurokSkeletalMeshComponent
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokPawnBossWaterNative.MyLightEnvironment'
    end object
    Mesh=TurokSkeletalMeshComponent
    // Reference: CylinderComponent'Default__TurokPawnBossWaterNative.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    // Reference: ArrowComponent'Default__TurokPawnBossWaterNative.Arrow'
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