class TurokPawnHelicopterNative extends TurokPawnMiniGunAutoTurretNative
    native
    config(Pawn)
    hidecategories(Navigation);

var(ParticleEffects) @NULL mDeadParticleSystem;
var(WindComponents) export editinline @NULL mTurokStrongWindComponent;
var(WindComponents) export editinline @NULL mTurokSlowWindComponent;

function bool NeedToTurn(@NULL targ)
{
    return false;
    //return ReturnValue;    
}

function TakeDamage(int Damage, @NULL InstigatedBy, @NULL HitLocation, @NULL Momentum, class<Class> DamageType, optional @NULL HitInfo, optional @NULL DamageCauser)
{
    local @NULL impactEmitter, emitterPool;

    // End:0x26
    if((float(Health) <= 0.0000000) || DamageType != Class'TurokDamageTypeRPG')
    {
        return;
    }
    // End:0xA1
    if(mDeadParticleSystem != none)
    {
        emitterPool = Class'TurokPlayerController'.static.GetLocalPlayerController().GetEmitterManager();
        impactEmitter = TurokEmitter(emitterPool.GetEmitter(mDeadParticleSystem, self, Location));
        impactEmitter.mSoundController.TryPlayLocalSound(mDeathSndCue);
    }
    super.TakeDamage(Health + 1, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    //return;    
}

function TossWeapon(@NULL TossVel)
{
    //return;    
}

// Export UTurokPawnHelicopterNative::execGetWeaponStartTraceLocation(FFrame&, void* const)
native simulated function @NULL GetWeaponStartTraceLocation(optional @NULL CurrentWeapon);

// Export UTurokPawnHelicopterNative::execGetPawnViewLocation(FFrame&, void* const)
native simulated function @NULL GetPawnViewLocation();

// Export UTurokPawnHelicopterNative::execGetViewRotation(FFrame&, void* const)
native simulated function @NULL GetViewRotation();

simulated function PostBeginPlay()
{
    PlayIdleSound();
    super.PostBeginPlay();
    //return;    
}

defaultproperties
{
    // Reference: TurokWeaponMediator'Default__TurokPawnHelicopterNative.TurokWeaponMediatorComponent'
    begin object name=TurokWeaponMediatorComponent
    end object
    mWeaponMediator=TurokWeaponMediatorComponent
    // Reference: TurokMeleeMaulMeter'Default__TurokPawnHelicopterNative.MeterComponent'
    begin object name=MeterComponent
    end object
    mMeleeMaulMeter=MeterComponent
    // Reference: TurokAnimKnockdownController'Default__TurokPawnHelicopterNative.KnockdownComponent'
    begin object name=KnockdownComponent
    end object
    mKnockdownController=KnockdownComponent
    // Reference: TurokAISteer'Default__TurokPawnHelicopterNative.TurokAISteerComponent'
    begin object name=TurokAISteerComponent
    end object
    mSteer=TurokAISteerComponent
    // Reference: TurokAIPlanner'Default__TurokPawnHelicopterNative.TurokAIPlannerComponent'
    begin object name=TurokAIPlannerComponent
    end object
    mPlanner=TurokAIPlannerComponent
    // Reference: DynamicLightEnvironmentComponent'Default__TurokPawnHelicopterNative.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: TurokPathController'Default__TurokPawnHelicopterNative.TurokPathControllerComponent'
    begin object name=TurokPathControllerComponent
    end object
    mPathController=TurokPathControllerComponent
    // Reference: TurokTargetingSystem'Default__TurokPawnHelicopterNative.TurokTargetingSystemComponent'
    begin object name=TurokTargetingSystemComponent
    end object
    mTargetingSystem=TurokTargetingSystemComponent
    // Reference: TurokSoundController'Default__TurokPawnHelicopterNative.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent
    end object
    mSoundController=TurokSoundControllerComponent
    // Reference: TurokAnimLadderController'Default__TurokPawnHelicopterNative.ladderController'
    begin object name=ladderController
    end object
    mLadderController=ladderController
    // Reference: SkeletalMeshComponent'Default__TurokPawnHelicopterNative.TurokSkeletalMeshComponent'
    begin object name=TurokSkeletalMeshComponent
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokPawnHelicopterNative.MyLightEnvironment'
    end object
    Mesh=TurokSkeletalMeshComponent
    // Reference: CylinderComponent'Default__TurokPawnHelicopterNative.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    // Reference: ArrowComponent'Default__TurokPawnHelicopterNative.Arrow'
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
    Components[10]=TurokWeaponMediatorComponent
    // Reference: SkeletalMeshComponent'Default__TurokPawnHelicopterNative.TurokHeadSkeletalMeshComponent'
    begin object name=TurokHeadSkeletalMeshComponent
        ParentAnimComponent=SkeletalMeshComponent'Default__TurokPawnHelicopterNative.TurokSkeletalMeshComponent'
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokPawnHelicopterNative.MyLightEnvironment'
    end object
    Components[11]=TurokHeadSkeletalMeshComponent
    Components[12]=MeterComponent
    Components[13]=KnockdownComponent
    CollisionComponent=CollisionCylinder
}