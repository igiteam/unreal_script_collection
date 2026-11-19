class TurokPawnSpiderTankNative extends TurokPawnHumanNpcNative
    native
    config(Pawn)
    hidecategories(Navigation);

var(Combat) config float mWeaponChargeTime;
var(Combat) config float mWeaponDelayTime;
var(Combat) config int mMaxFlares;
var(Combat) config float mWeaponAimTolerance;
var export editinline @NULL mExhaustEffect[2];
var @NULL mExhaustSystem;
var name mExhaustSocket[2];
var export editinline @NULL mDamageEffect;
var array mDamageEffectLevel;
var config array mDamageEffectThresholds;
var @NULL mFlareEffect;
var @NULL mFlareSoundCue;
var config float mFootHurtDamage;
var config float mFootHurtDamageRadius;
var config float mFootHurtMomentum;
var config float mFootHurtDuration;
var config bool mFootKnockDownEnable;
var bool mbPlayingTurretSound;
var export editinline @NULL mMeshDamaged[3];
var config float mMeshDamageRanges[3];
var int mNumTicksAtIdle;
var int mNumTicksForIdle;
var float mTurretMovementThresh;
var @NULL mLastTurretView;
var @NULL mStartTurretSndCue;
var @NULL mStopTurretSndCue;
var name mMuzzleSktName;

// Export UTurokPawnSpiderTankNative::execUpdateTurretSounds(FFrame&, void* const)
native simulated function UpdateTurretSounds();

simulated function PostBeginPlay()
{
    local @NULL emitterPool;
    local int I;

    super.PostBeginPlay();
    emitterPool = Class'TurokPlayerController'.static.GetLocalPlayerController().GetEmitterManager();
    mDamageEffect = emitterPool.ReserveParticleSystemComponent();
    // End:0x91
    if(mDamageEffect != none)
    {
        Mesh.AttachComponent(mDamageEffect, 'jt_Cog_C');
        mDamageEffect.DeactivateSystem();
        mDamageEffect.SetLightEnvironment(self.LightEnvironment);
    }
    I = 0;
    J0x98:

    // End:0x14D [Loop If]
    if(I < 2)
    {
        mExhaustEffect[I] = emitterPool.ReserveParticleSystemComponent();
        // End:0x143
        if(mExhaustEffect[I] != none)
        {
            mExhaustEffect[I].SetTemplate(mExhaustSystem);
            Mesh.AttachComponentToSocket(mExhaustEffect[I], mExhaustSocket[I]);
            mExhaustEffect[I].DeactivateSystem();
            mExhaustEffect[I].SetLightEnvironment(self.LightEnvironment);
        }
        I++;
        // [Loop Continue]
        goto J0x98;
    }
    mbUseDeadBodyManager = false;
    I = 0;
    J0x15C:

    // End:0x19F [Loop If]
    if(I < 3)
    {
        mMeshDamaged[I].SetHidden(true);
        mMeshDamaged[I].SetActorCollision(false, false);
        I++;
        // [Loop Continue]
        goto J0x15C;
    }
    //return;    
}

function bool IsFiring()
{
    return true;
    //return ReturnValue;    
}

function bool TooCloseToAttack(@NULL Other)
{
    return false;
    //return ReturnValue;    
}

function bool CanAttack(@NULL Other)
{
    return mCanAttackOverride == 1;
    //return ReturnValue;    
}

function StartPrefire()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x32 [Loop If]
    if(I < 2)
    {
        mExhaustEffect[I].ActivateSystem();
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function @NULL StartFlare()
{
    //return ReturnValue;    
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
    //return;    
}

function float GetRadiusDamageBufferDistance()
{
    return GetCollisionRadius();
    //return ReturnValue;    
}

function TakeDamage(int Damage, @NULL InstigatedBy, @NULL HitLocation, @NULL Momentum, class<Class> DamageType, optional @NULL pHitInfo, optional @NULL DamageCauser)
{
    local float healthPercent;
    local int Index;

    super(TurokPawnHuman).TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, pHitInfo);
    healthPercent = float(Health) / float(mDefaultHealth);
    // End:0xBE
    if(mDamageEffect != none)
    {
        Index = mDamageEffectThresholds.Length - 1;
        J0x57:

        // End:0xBE [Loop If]
        if(Index >= 0)
        {
            // End:0xB4
            if(healthPercent <= mDamageEffectThresholds[Index])
            {
                // End:0xB4
                if(mDamageEffectLevel[Index] != none)
                {
                    mDamageEffect.SetTemplate(mDamageEffectLevel[Index]);
                    mDamageEffect.ActivateSystem();
                    // [Explicit Break]
                    goto J0xBE;
                }
            }
            Index--;
            // [Loop Continue]
            goto J0x57;
        }
    }
    J0xBE:

    Index = 2;
    J0xC6:

    // End:0x191 [Loop If]
    if(Index >= 0)
    {
        // End:0x187
        if(healthPercent <= mMeshDamageRanges[Index])
        {
            Mesh.SetHidden(true);
            Mesh.SetActorCollision(false, false);
            mMeshDamaged[Index].SetHidden(false);
            mMeshDamaged[Index].SetActorCollision(true, true);
            Index = Index - 1;
            J0x142:

            // End:0x184 [Loop If]
            if(Index >= 0)
            {
                mMeshDamaged[Index].SetHidden(true);
                mMeshDamaged[Index].SetActorCollision(false, false);
                Index--;
                // [Loop Continue]
                goto J0x142;
            }
            // [Explicit Break]
            goto J0x191;
        }
        Index--;
        // [Loop Continue]
        goto J0xC6;
    }
    J0x191:

    //return;    
}

simulated event bool CanAutoAimTo()
{
    return false;
    //return ReturnValue;    
}

function bool Died(@NULL Killer, class<Class> DamageType, @NULL HitLocation)
{
    // End:0x2A
    if(super(TurokPawnHuman).Died(Killer, DamageType, HitLocation))
    {
        RevealDamageTexture(0, DamageType);
        return true;
    }
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    mMuzzleSktName="MuzzleSkt"
    // Reference: TurokWeaponMediator'Default__TurokPawnSpiderTankNative.TurokWeaponMediatorComponent'
    begin object name=TurokWeaponMediatorComponent
    end object
    mWeaponMediator=TurokWeaponMediatorComponent
    // Reference: TurokMeleeMaulMeter'Default__TurokPawnSpiderTankNative.MeterComponent'
    begin object name=MeterComponent
    end object
    mMeleeMaulMeter=MeterComponent
    // Reference: TurokAnimKnockdownController'Default__TurokPawnSpiderTankNative.KnockdownComponent'
    begin object name=KnockdownComponent
    end object
    mKnockdownController=KnockdownComponent
    // Reference: TurokAISteer'Default__TurokPawnSpiderTankNative.TurokAISteerComponent'
    begin object name=TurokAISteerComponent
    end object
    mSteer=TurokAISteerComponent
    // Reference: TurokAIPlanner'Default__TurokPawnSpiderTankNative.TurokAIPlannerComponent'
    begin object name=TurokAIPlannerComponent
    end object
    mPlanner=TurokAIPlannerComponent
    // Reference: DynamicLightEnvironmentComponent'Default__TurokPawnSpiderTankNative.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    mbAllowDinoMelee=false
    // Reference: TurokPathController'Default__TurokPawnSpiderTankNative.TurokPathControllerComponent'
    begin object name=TurokPathControllerComponent
    end object
    mPathController=TurokPathControllerComponent
    // Reference: TurokTargetingSystem'Default__TurokPawnSpiderTankNative.TurokTargetingSystemComponent'
    begin object name=TurokTargetingSystemComponent
    end object
    mTargetingSystem=TurokTargetingSystemComponent
    // Reference: TurokSoundController'Default__TurokPawnSpiderTankNative.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent
    end object
    mSoundController=TurokSoundControllerComponent
    mDeathSndCue=none
    mExertionSndCue=none
    mGruntSndCue=none
    // Reference: TurokAnimLadderController'Default__TurokPawnSpiderTankNative.ladderController'
    begin object name=ladderController
    end object
    mLadderController=ladderController
    // Reference: SkeletalMeshComponent'Default__TurokPawnSpiderTankNative.TurokSkeletalMeshComponent'
    begin object name=TurokSkeletalMeshComponent
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokPawnSpiderTankNative.MyLightEnvironment'
    end object
    Mesh=TurokSkeletalMeshComponent
    // Reference: CylinderComponent'Default__TurokPawnSpiderTankNative.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    // Reference: ArrowComponent'Default__TurokPawnSpiderTankNative.Arrow'
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
    // Reference: SkeletalMeshComponent'Default__TurokPawnSpiderTankNative.TurokHeadSkeletalMeshComponent'
    begin object name=TurokHeadSkeletalMeshComponent
        ParentAnimComponent=SkeletalMeshComponent'Default__TurokPawnSpiderTankNative.TurokSkeletalMeshComponent'
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokPawnSpiderTankNative.MyLightEnvironment'
    end object
    Components[11]=TurokHeadSkeletalMeshComponent
    Components[12]=MeterComponent
    Components[13]=KnockdownComponent
    CollisionComponent=CollisionCylinder
}