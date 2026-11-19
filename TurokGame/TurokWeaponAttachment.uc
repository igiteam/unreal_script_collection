class TurokWeaponAttachment extends ActorComponent
    abstract
    native
    config(Weapon);

enum EFireEffectCameraMode
{
    FECM_THIRD,                     // 0
    FECM_FIRST,                     // 1
    FECM_BOTH,                      // 2
    FECM_MAX                        // 3
};

enum EWeaponStateBits
{
    EWSB_ThrowGrenadeAnim,          // 0
    EWSB_StartReloadAnim,           // 1
    EWSB_EndReloadAnim,             // 2
    EWSB_StartPhaseReloadAnim,      // 3
    EWSB_EndPhaseReloadAnim,        // 4
    EWSB_EquipAttachmentAnim,       // 5
    EWSB_UnEquipAttachmentAnim,     // 6
    EWSB_AttachmentVisible,         // 7
    EWSB_AttachmentHidden,          // 8
    EWSB_StartOverheatFX,           // 9
    EWSB_EndOverheatFX,             // 10
    EWSB_MAX                        // 11
};

struct native TurokMatImpactEffect
{
    var name mPhysMaterialName;
    var array mImpactSound;
    var @NULL mBounceSound;
    var @NULL mLandSound;
    var @NULL mImpactSystem;
    var byte mImpactSystemSortMethod;
    var @NULL mDecalMaterial;
    var float mDecalMinSize;
    var float mDecalMaxSize;
    var @NULL mOptimizedDecalMaterial;
    var float mOptimizedDecalScale;

    structdefaultproperties
    {
        mPhysMaterialName="None"
        mImpactSound=none
        mBounceSound=none
        mLandSound=none
        mImpactSystem=none
        mImpactSystemSortMethod=0
        mDecalMaterial=none
        mDecalMinSize=0.0000000
        mDecalMaxSize=0.0000000
        mOptimizedDecalMaterial=none
        mOptimizedDecalScale=0.0000000
    }
};

struct native TurokFireEffect
{
    var() name mSocket;
    var() @NULL mTemplate;
    var() bool mLoops;
    var() byte mMode;

    structdefaultproperties
    {
        mSocket="None"
        mTemplate=none
        mLoops=false
        mMode=2
    }
};

struct native TracerSettings
{
    var(Tracers) @NULL mTracerStartColor;
    var(Tracers) @NULL mTracerEndColor;
    var(Tracers) float mTracerSpeedMin;
    var(Tracers) float mTracerSpeedMax;
    var(Tracers) @NULL mTracerAccel;
    var(Tracers) @NULL mTracerSizeStartMin;
    var(Tracers) @NULL mTracerSizeStartMax;
    var(Tracers) @NULL mTracerSizeEndMin;
    var(Tracers) @NULL mTracerSizeEndMax;
    var(Tracers) float mTimeBetweenSpawnMin;
    var(Tracers) float mTimeBetweenSpawnMax;
    var(Tracers) float mTracerInheritVelocityScale;

    structdefaultproperties
    {
        mTracerStartColor=(R=0.0000000,G=0.0000000,B=0.0000000,A=1.0000000)
        mTracerEndColor=(R=0.0000000,G=0.0000000,B=0.0000000,A=1.0000000)
        mTracerSpeedMin=0.0000000
        mTracerSpeedMax=0.0000000
        mTracerAccel=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        mTracerSizeStartMin=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        mTracerSizeStartMax=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        mTracerSizeEndMin=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        mTracerSizeEndMax=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        mTimeBetweenSpawnMin=0.0000000
        mTimeBetweenSpawnMax=0.0000000
        mTracerInheritVelocityScale=0.0000000
    }
};

var protected const class<Class> WeaponClass;
var protected byte mEquippedInHand;
var protected bool mbIsDualWielded;
var(Animations) bool mbAlertAim;
var(Tracers) bool mbHasTracers;
var bool mbSpawnNewTracerInPreRender;
var bool mbCanPlayPOVTracers;
var bool mbHasOptimizedDecals;
var(Sound) bool bLoopFiringSound;
var(Attach) export editinline @NULL mAttachMesh;
var private transient @NULL mAttachMeshTree;
var private native const @NULL mHumanAnimController;
var private native const @NULL mWeaponController;
var(Attach) name mEquipBoneName;
var(Attach) name m3PWeaponBlendJoint;
var protected @NULL mHumanOwner;
var protected name mRelaxedAimControllerName;
var protected name mFireControllerName;
var protected name mAltFireControllerName;
var protected name mCannedControllerName;
var protected name mMuzzleName;
var(Animations) array mHumanAnimSets;
var(Animations) array mWeaponAnimSets;
var(Animations) @NULL m3PAimAsset;
var(Animations) @NULL m3PRelaxedAimAsset;
var(Animations) @NULL m3PFireAsset;
var(Animations) @NULL m3PAltFireAsset;
var(Animations) name m3PReloadAnim;
var(Animations) name m3PPutDownAnim;
var(Animations) name m3PEquipAnim;
var(Animations) name m3PDefaultAnim;
var(Animations) name m3PGrenadeAnim;
var(grenade) float m3PGrenadeAnimTime;
var protected float mMaxFireEffectDistance;
var protected float mMaxImpactEffectDistance;
var(Effects) array mFireEffects;
var(Effects) array mFireEffectIndex;
var(Effects) array mFireEffectAltIndex;
var private export editinline array mAttachFireEffectPSC;
var int mFireMode3PFxOverride;
var float mTime;
var(Tracers) config @NULL m1PTracerSettings;
var(Tracers) config @NULL m3PTracerSettings;
var float mTracerLastSpawnTime;
var float mTracerNextSpawnTime;
var int mNewTracerFireMode;
var array mNewTracerEndLocation;
var(Tracers) @NULL mBulletTrailPS;
var(Tracers) config float mBulletTrailMaxDistance;
var(Effects) int mShotsToWaitForNextEffect;
var(Effects) editinline array mImpactEffects;
var(Effects) editinline array mAltImpactEffects;
var(Effects) array mImpactEffectTemplate;
var int mShotCount;
var(Sound) @NULL mPreFireSndCue[2];
var(Sound) @NULL mAltPreFireSndCue[2];
var(Sound) @NULL mFireSndCue[2];
var(Sound) @NULL mAltFireSndCue[2];
var(Sound) @NULL mPostFireSndCue[2];
var(Sound) @NULL mAltPostFireSndCue[2];
var(Sound) @NULL mEquipSndCue;
var(Sound) @NULL mUnEquipSndCue;
var(Sound) @NULL mDryFireSndCue;
var(Sound) @NULL mReloadSndCue;
var(Sound) @NULL mDropSndCue;
var(Sound) @NULL mWeaponAmbientSndCue;
var(Sound) export editinline @NULL mWeaponAmbientComponent;
var(Sound) const int mMaxWeaponAC;
var(Sound) float mWindDownDelay;
var(Noise) config array mFiredNoiseLevel;
var(Noise) config array mImpactNoiseLevel;
var config int miMaxNumImpactEffects;

// Export UTurokWeaponAttachment::execAttach3rdPersonWeapon(FFrame&, void* const)
native final function bool Attach3rdPersonWeapon(name BoneName, @NULL pawnMesh);

// Export UTurokWeaponAttachment::execRemove3rdPersonWeapon(FFrame&, void* const)
native final function bool Remove3rdPersonWeapon(@NULL pawnMesh);

// Export UTurokWeaponAttachment::execSetAttachmentMeshVisibility(FFrame&, void* const)
native function SetAttachmentMeshVisibility(bool bIs3rdPerson, bool bVisibleIn3rdPerson);

// Export UTurokWeaponAttachment::execInit3PAnims(FFrame&, void* const)
native final function Init3PAnims(bool attachToGraph);

// Export UTurokWeaponAttachment::execPurge3PAnims(FFrame&, void* const)
native final function Purge3PAnims();

// Export UTurokWeaponAttachment::execInitBaseSpatialController(FFrame&, void* const)
native final function InitBaseSpatialController(@NULL asset, bool bLooping, bool bUpdateTarget);

// Export UTurokWeaponAttachment::execInitSpatialController(FFrame&, void* const)
native final function InitSpatialController(name NodeName, @NULL asset, name startBlendName, float increasePerBone, float blendWeight, bool bLooping, bool bUpdateTarget);

// Export UTurokWeaponAttachment::execInitCannedController(FFrame&, void* const)
native final function InitCannedController(name NodeName, name startBlendName, float increasePerBone, float blendWeight);

// Export UTurokWeaponAttachment::execPlay3PSpatialAnimation(FFrame&, void* const)
native final function Play3PSpatialAnimation(name NodeName, float Duration, float blendTime);

// Export UTurokWeaponAttachment::execPlay3PSpatialAnimUseTargetFn(FFrame&, void* const)
native final function Play3PSpatialAnimUseTargetFn(name NodeName, float Duration, float blendTarget, float blendTime);

// Export UTurokWeaponAttachment::execPlay3PCannedAnimation(FFrame&, void* const)
native final function Play3PCannedAnimation(name NodeName, name AnimName, float Duration, float blendIn, float blendOut, bool bStayBlendedIn);

// Export UTurokWeaponAttachment::execPlay3PAnimation(FFrame&, void* const)
native final function Play3PAnimation(name AnimName, float Duration, float blendIn, float blendOut, bool Looping);

// Export UTurokWeaponAttachment::execStop3PCannedAnimations(FFrame&, void* const)
native final function Stop3PCannedAnimations(name NodeName);

// Export UTurokWeaponAttachment::execSetSecondaryBlendTarget(FFrame&, void* const)
native final function SetSecondaryBlendTarget(name NodeName, float Target, float blendTime);

// Export UTurokWeaponAttachment::execSetSecondaryBlendTransient(FFrame&, void* const)
native final function SetSecondaryBlendTransient(name NodeName, float Duration, float BlendInTime, float BlendOutTime);

// Export UTurokWeaponAttachment::execPlay3PDefaultWeaponAnimation(FFrame&, void* const)
native final function Play3PDefaultWeaponAnimation(float blendIn);

// Export UTurokWeaponAttachment::execSetAlertState(FFrame&, void* const)
native final function SetAlertState(bool alert, float blendTime);

// Export UTurokWeaponAttachment::execIsAltFiringMode(FFrame&, void* const)
native final function bool IsAltFiringMode(byte FiringMode);

// Export UTurokWeaponAttachment::execRequestEnableWeaponLight(FFrame&, void* const)
native function RequestEnableWeaponLight(@NULL LightComponent, bool isPOVWeapon);

// Export UTurokWeaponAttachment::execDisableWeaponLight(FFrame&, void* const)
native final function DisableWeaponLight(@NULL LightComponent);

// Export UTurokWeaponAttachment::execCreateTracer(FFrame&, void* const)
native function CreateTracer(@NULL StartLocation, @NULL endLocation, @NULL Settings);

// Export UTurokWeaponAttachment::execAddTracer(FFrame&, void* const)
native function bool AddTracer(const @NULL StartColor, const @NULL EndColor, const @NULL startPos, const @NULL InVelocity, const @NULL InAccel, const @NULL StartSize, const @NULL EndSize, const float fDistance, const optional float fInheritVelocityScale);

// Export UTurokWeaponAttachment::execTriggerFireEffects(FFrame&, void* const)
native function TriggerFireEffects(@NULL MeshComponent, byte FireModeNum, array fireEffects, byte Flash3P);

// Export UTurokWeaponAttachment::execPlayImpactEffects(FFrame&, void* const)
native function PlayImpactEffects(@NULL HitLocation);

// Export UTurokWeaponAttachment::execForcePlayBulletTrail(FFrame&, void* const)
native function ForcePlayBulletTrail(@NULL MuzzleLoc, @NULL muzzleRot, optional float trailLength);

// Export UTurokWeaponAttachment::execGetImpactEffect(FFrame&, void* const)
protected native function @NULL GetImpactEffect(@NULL hitMaterial);

// Export UTurokWeaponAttachment::execPlayActorImpact(FFrame&, void* const)
protected native function PlayActorImpact(byte FireMode, @NULL HitActor, @NULL HitLocation, @NULL HitDir, @NULL HitInfo);

// Export UTurokWeaponAttachment::execAttachImpactPS(FFrame&, void* const)
native function AttachImpactPS(@NULL impactPS, @NULL NewOwner);

// Export UTurokWeaponAttachment::execDetachImpactPS(FFrame&, void* const)
native function DetachImpactPS(@NULL impactPS);

// Export UTurokWeaponAttachment::execUpdateGrassBulletSpreadForce(FFrame&, void* const)
native function UpdateGrassBulletSpreadForce(@NULL tph, const @NULL spreadSettings);

// Export UTurokWeaponAttachment::execToggleImpactFXForEnemies(FFrame&, void* const)
native static final function ToggleImpactFXForEnemies();

// Export UTurokWeaponAttachment::execToggleImpactFXSoundOptimization(FFrame&, void* const)
native static final function ToggleImpactFXSoundOptimization();

// Export UTurokWeaponAttachment::execToggleImpactFXOptimization(FFrame&, void* const)
native static final function ToggleImpactFXOptimization();

// Export UTurokWeaponAttachment::execSetMaxNumImpactEffects(FFrame&, void* const)
native static final function SetMaxNumImpactEffects(int numFX);

// Export UTurokWeaponAttachment::execPlayLimitedWeaponSound(FFrame&, void* const)
native final function PlayLimitedWeaponSound(@NULL sc, bool bReplicated);

event AttachAnimations()
{
    local editinline @NULL weaponMesh;
    local float alertWeight;

    weaponMesh = SkeletalMeshComponent(mAttachMesh);
    // End:0xFD
    if(weaponMesh != none)
    {
        weaponMesh.AnimSets = mWeaponAnimSets;
        // End:0x46
        if(mbAlertAim)
        {
            alertWeight = 1.0000000;            
        }
        else
        {
            alertWeight = 0.0000000;
        }
        InitBaseSpatialController(m3PAimAsset, true, true);
        InitSpatialController(mRelaxedAimControllerName, m3PRelaxedAimAsset, 'jt_SpineLower_C', 0.3300000, 1.0000000 - alertWeight, true, true);
        InitSpatialController(mFireControllerName, m3PFireAsset, 'jt_SpineLower_C', 1.0000000, 0.0000000, false, true);
        // End:0xDF
        if(m3PAltFireAsset != none)
        {
            InitSpatialController(mAltFireControllerName, m3PAltFireAsset, 'jt_SpineLower_C', 1.0000000, 0.0000000, false, true);
        }
        InitCannedController(mCannedControllerName, 'jt_SpineUpper_C', 1.0000000, 0.0000000);
    }
    //return;    
}

// Export UTurokWeaponAttachment::execFirstPersonFireEffects(FFrame&, void* const)
native function FirstPersonFireEffects(@NULL PawnWeapon, @NULL HitLocation);

simulated event StopFirstPersonFireEffects(@NULL PawnWeapon)
{
    local byte FireMode;

    // End:0x41
    if(PawnWeapon != none)
    {
        FireMode = TurokWeapon(PawnWeapon).GetFiringModeForFxIndex();
        PawnWeapon.StopFireEffects(FireMode);
    }
    mShotCount = 0;
    //return;    
}

// Export UTurokWeaponAttachment::execThirdPersonFireEffects(FFrame&, void* const)
native function ThirdPersonFireEffects(@NULL HitLocation);

// Export UTurokWeaponAttachment::execPlayThirdPersonFireAnim(FFrame&, void* const)
native function PlayThirdPersonFireAnim();

simulated event StopThirdPersonFireEffects()
{
    local byte FireMode;

    mShotCount = 0;
    // End:0x7E
    if(mHumanOwner != none)
    {
        // End:0x3E
        if(int(mEquippedInHand) == int(1))
        {
            FireMode = mHumanOwner.GetFiringModeLH();            
        }
        else
        {
            FireMode = mHumanOwner.GetFiringMode();
        }
        // End:0x6F
        if(mFireMode3PFxOverride >= 0)
        {
            FireMode = byte(mFireMode3PFxOverride);
        }
        StopFireEffects(FireMode);
    }
    //return;    
}

simulated event bool AttachMesh(@NULL OwnerMesh)
{
    return Attach3rdPersonWeapon(mEquipBoneName, OwnerMesh);
    //return ReturnValue;    
}

// Export UTurokWeaponAttachment::execPlaySpatialFireAnim(FFrame&, void* const)
native function PlaySpatialFireAnim(int FireMode, float fireTime);

simulated event ThirdPersonDoEquip()
{
    local float EquipTime;

    EquipTime = WeaponClass.default.EquipTime;
    Play3PCannedAnimation(mCannedControllerName, m3PEquipAnim, EquipTime, 0.0000000, EquipTime * 0.1000000, false);
    // End:0x4B
    if(SkipThirdPersonDoEquip())
    {
        return;
    }
    PlayLimitedWeaponSound(mEquipSndCue, false);
    //return;    
}

simulated event AttachComponentToBone(@NULL OwnerMesh, name BoneName)
{
    OwnerMesh.AttachComponent(mAttachMesh, BoneName);
    //return;    
}

// Export UTurokWeaponAttachment::execattachTo(FFrame&, void* const)
native function attachTo(@NULL OwnerMesh, byte EquipHand, bool bDualWielded);

simulated function DetachFrom(@NULL OwnerMesh)
{
    // DebugMode: 0
    assert(mHumanOwner != none);
    DestroyFireEffects(SkeletalMeshComponent(mAttachMesh), mAttachFireEffectPSC);
    // End:0x49
    if(!Remove3rdPersonWeapon(OwnerMesh))
    {
        OwnerMesh.DetachComponent(mAttachMesh);
    }
    // End:0x64
    if(mAttachMesh != none)
    {
        mAttachMesh.SetLightEnvironment(none);
    }
    StopAmbience();
    mShotCount = 0;
    mEquippedInHand = 2;
    mbIsDualWielded = false;
    mHumanOwner = none;
    //return;    
}

simulated function byte GetEquipHand()
{
    return mEquippedInHand;
    //return ReturnValue;    
}

simulated function bool SkipThirdPersonDoEquip(optional float MinAge = 1.0000000)
{
    return (TurokAIControllerHumanNpc(mHumanOwner.Controller) != none) && (mHumanOwner.WorldInfo.TimeSeconds - mHumanOwner.CreationTime) > MinAge;
    //return ReturnValue;    
}

simulated function ThirdPersonDoReload()
{
    local float ReloadTime;

    // End:0x10
    if(SkipThirdPersonDoEquip())
    {
        return;
    }
    // End:0x30
    if(mbIsDualWielded)
    {
        ReloadTime = WeaponClass.default.mDWReloadTime;        
    }
    else
    {
        ReloadTime = WeaponClass.default.mReloadStartTime;
    }
    Play3PCannedAnimation(mCannedControllerName, m3PReloadAnim, ReloadTime, ReloadTime * 0.1000000, ReloadTime * 0.1000000, false);
    //return;    
}

simulated function ThirdPersonDoPhaseReloading(bool bBeginning)
{
    //return;    
}

simulated function FinishedThirdPersonReload()
{
    //return;    
}

// Export UTurokWeaponAttachment::execInitFireEffects(FFrame&, void* const)
native function InitFireEffects(@NULL MeshComponent, out array fireEffects);

simulated function DestroyFireEffects(@NULL MeshComponent, array fireEffects)
{
    local int Index;
    local editinline @NULL sktMesh, emitterPool, partSystemComp;

    sktMesh = SkeletalMeshComponent(MeshComponent);
    // End:0x1D
    if(sktMesh == none)
    {
        return;
    }
    emitterPool = Class'TurokPlayerController'.static.GetLocalPlayerController().GetEmitterManager();
    Index = 0;
    J0x47:

    // End:0xEF [Loop If]
    if(Index < fireEffects.Length)
    {
        // End:0xE5
        if(fireEffects[Index] != none)
        {
            partSystemComp = ParticleSystemComponent(fireEffects[Index]);
            // End:0xCB
            if(partSystemComp != none)
            {
                partSystemComp.DeactivateSystem();
                partSystemComp.KillParticlesForced();
                emitterPool.FreeReservedParticleSystemComponent(partSystemComp);
                partSystemComp.SetLightEnvironment(none);
            }
            sktMesh.DetachComponent(fireEffects[Index]);
        }
        ++Index;
        // [Loop Continue]
        goto J0x47;
    }
    //return;    
}

simulated function EndFireEffects(byte FireModeNum, array fireEffects)
{
    local int Index;

    // End:0xF4
    if(IsAltFiringMode(FireModeNum))
    {
        Index = 0;
        J0x15:

        // End:0xF1 [Loop If]
        if(Index < mFireEffectAltIndex.Length)
        {
            // End:0xE7
            if((fireEffects.Length > mFireEffectAltIndex[Index]) && fireEffects[mFireEffectAltIndex[Index]] != none)
            {
                // End:0xAF
                if(mFireEffects[mFireEffectAltIndex[Index]].mLoops)
                {
                    // End:0xAF
                    if(ParticleSystemComponent(fireEffects[mFireEffectAltIndex[Index]]) != none)
                    {
                        ParticleSystemComponent(fireEffects[mFireEffectAltIndex[Index]]).DeactivateSystem();
                    }
                }
                // End:0xE7
                if(TurokPointLightComponent(fireEffects[mFireEffectAltIndex[Index]]) != none)
                {
                    DisableWeaponLight(TurokPointLightComponent(fireEffects[mFireEffectAltIndex[Index]]));
                }
            }
            ++Index;
            // [Loop Continue]
            goto J0x15;
        }        
    }
    else
    {
        Index = 0;
        J0xFB:

        // End:0x1D7 [Loop If]
        if(Index < mFireEffectIndex.Length)
        {
            // End:0x1CD
            if((fireEffects.Length > mFireEffectIndex[Index]) && fireEffects[mFireEffectIndex[Index]] != none)
            {
                // End:0x195
                if(mFireEffects[mFireEffectIndex[Index]].mLoops)
                {
                    // End:0x195
                    if(ParticleSystemComponent(fireEffects[mFireEffectIndex[Index]]) != none)
                    {
                        ParticleSystemComponent(fireEffects[mFireEffectIndex[Index]]).DeactivateSystem();
                    }
                }
                // End:0x1CD
                if(TurokPointLightComponent(fireEffects[mFireEffectIndex[Index]]) != none)
                {
                    DisableWeaponLight(PointLightComponent(fireEffects[mFireEffectIndex[Index]]));
                }
            }
            ++Index;
            // [Loop Continue]
            goto J0xFB;
        }
    }
    //return;    
}

simulated function StopEffectsImmediately(array fireEffects)
{
    local int Index;

    Index = 0;
    J0x07:

    // End:0x6B [Loop If]
    if(Index < fireEffects.Length)
    {
        // End:0x61
        if(ParticleSystemComponent(fireEffects[Index]) != none)
        {
            ParticleSystemComponent(fireEffects[Index]).DeactivateSystem();
            ParticleSystemComponent(fireEffects[Index]).KillParticlesForced();
        }
        ++Index;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

simulated function Stop3rdPersonEffectsImmediately()
{
    StopEffectsImmediately(mAttachFireEffectPSC);
    //return;    
}

// Export UTurokWeaponAttachment::execCauseFireEffects(FFrame&, void* const)
protected native function CauseFireEffects(byte FireModeNum, byte Flash3P);

protected simulated function StopFireEffects(byte FireModeNum)
{
    EndFireEffects(FireModeNum, mAttachFireEffectPSC);
    //return;    
}

simulated function StopSingleFireEffect3P(byte FireModeNum, int EffectIndex)
{
    StopSingleFireEffect(FireModeNum, EffectIndex, mAttachFireEffectPSC);
    //return;    
}

simulated function StopSingleFireEffect(byte FireModeNum, int EffectIndex, array fireEffects)
{
    // End:0xA9
    if(IsAltFiringMode(FireModeNum))
    {
        // End:0xA6
        if((fireEffects.Length > EffectIndex) && fireEffects[EffectIndex] != none)
        {
            // End:0x7A
            if(mFireEffects[EffectIndex].mLoops)
            {
                // End:0x7A
                if(ParticleSystemComponent(fireEffects[EffectIndex]) != none)
                {
                    ParticleSystemComponent(fireEffects[EffectIndex]).DeactivateSystem();
                }
            }
            // End:0xA6
            if(TurokPointLightComponent(fireEffects[EffectIndex]) != none)
            {
                DisableWeaponLight(TurokPointLightComponent(fireEffects[EffectIndex]));
            }
        }        
    }
    else
    {
        // End:0x141
        if((fireEffects.Length > EffectIndex) && fireEffects[EffectIndex] != none)
        {
            // End:0x115
            if(mFireEffects[EffectIndex].mLoops)
            {
                // End:0x115
                if(ParticleSystemComponent(fireEffects[EffectIndex]) != none)
                {
                    ParticleSystemComponent(fireEffects[EffectIndex]).DeactivateSystem();
                }
            }
            // End:0x141
            if(TurokPointLightComponent(fireEffects[EffectIndex]) != none)
            {
                DisableWeaponLight(PointLightComponent(fireEffects[EffectIndex]));
            }
        }
    }
    //return;    
}

simulated function PlayWeaponSound(@NULL sc, bool bReplicated, optional float Volume = 1.0000000, optional float Pitch = 1.0000000)
{
    local @NULL SndSource;

    // End:0x1F
    if(sc == none)
    {
        return;
    }
    // End:0x2C
    if(mHumanOwner == none)
    {
        return;
    }
    // End:0x10A
    if(mHumanOwner.IsFirstPerson())
    {
        // End:0xA6
        if((int(mEquippedInHand) == int(0)) && mHumanOwner.GetRightHandWeapon() != none)
        {
            SndSource = mHumanOwner.GetRightHandWeapon().mWeaponMesh.GetBoneLocation('jt_Cog_C');            
        }
        else
        {
            // End:0x107
            if((int(mEquippedInHand) == int(1)) && mHumanOwner.GetLeftHandWeapon() != none)
            {
                SndSource = mHumanOwner.GetLeftHandWeapon().mWeaponMesh.GetBoneLocation('jt_Cog_C');
            }
        }        
    }
    else
    {
        SndSource = mHumanOwner.Location;
    }
    // End:0x15D
    if(!bReplicated)
    {
        mHumanOwner.mSoundController.TryPlayLocalSoundAt(sc, SndSource, true, Volume, Pitch);        
    }
    else
    {
        mHumanOwner.mSoundController.TryPlayReplicatedSound(sc, true, false, SndSource);
    }
    //return;    
}

// Export UTurokWeaponAttachment::execPlayFiringSound(FFrame&, void* const)
native function PlayFiringSound(byte FireModeNum);

// Export UTurokWeaponAttachment::execPlayPreFiringSound(FFrame&, void* const)
native function PlayPreFiringSound(byte FireModeNum);

simulated function PlayPostFiringSound(byte FireModeNum)
{
    local int FireModeIndex;
    local @NULL sc;

    // End:0x20
    if(mHumanOwner.IsFirstPerson())
    {
        FireModeIndex = 1;        
    }
    else
    {
        FireModeIndex = 0;
    }
    // End:0x4B
    if(!IsAltFiringMode(FireModeNum))
    {
        sc = mPostFireSndCue[FireModeIndex];        
    }
    else
    {
        sc = mAltPostFireSndCue[FireModeIndex];
    }
    // End:0x73
    if(sc != none)
    {
        PlayLimitedWeaponSound(sc, false);
    }
    //return;    
}

simulated function PlayDryFiringSound()
{
    PlayLimitedWeaponSound(mDryFireSndCue, true);
    //return;    
}

// Export UTurokWeaponAttachment::execPlayImpactSound(FFrame&, void* const)
native function PlayImpactSound(@NULL impactSoundCue, @NULL ImpactLocation);

simulated function int GetWeaponAmbienceAudioChannel()
{
    // End:0x1D
    if(mHumanOwner != none)
    {
        return mHumanOwner.mWeaponAmbientSndChannelIndex;        
    }
    else
    {
        return -1;
    }
    //return ReturnValue;    
}

simulated function bool WeaponAmbienceWasPlaying()
{
    // End:0x35
    if(mHumanOwner != none)
    {
        return mHumanOwner.mSoundController.ACWasPlaying(GetWeaponAmbienceAudioChannel());        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
}

simulated function PlayAmbience(optional @NULL sc)
{
    local int Channel;

    Channel = GetWeaponAmbienceAudioChannel();
    // End:0x1E
    if(mHumanOwner == none)
    {
        return;
    }
    // End:0x34
    if(sc == none)
    {
        sc = mWeaponAmbientSndCue;
    }
    // End:0x78
    if(Channel == -1)
    {
        mHumanOwner.mWeaponAmbientSndChannelIndex = mHumanOwner.mSoundController.CreateAudioChannel(sc, true, true);        
    }
    else
    {
        // End:0xD3
        if(mHumanOwner.mSoundController.mAudioChannels[Channel].SoundCue != sc)
        {
            mHumanOwner.mSoundController.ChangeAudioChannel(Channel, sc, true, true);            
        }
        else
        {
            // End:0x11A
            if(!mHumanOwner.mSoundController.ACWasPlaying(Channel))
            {
                mHumanOwner.mSoundController.PlayAudioChannel(Channel);
            }
        }
    }
    //return;    
}

simulated event StopAmbience(optional float FadeTime = 0.0000000)
{
    // End:0x44
    if((GetWeaponAmbienceAudioChannel()) >= 0)
    {
        mHumanOwner.mSoundController.StopAudioChannel(GetWeaponAmbienceAudioChannel(), FadeTime);
    }
    //return;    
}

simulated event float GetFootStepNoiseMultiplier()
{
    // End:0x14
    if(WeaponClass == none)
    {
        return 1.0000000;        
    }
    else
    {
        return WeaponClass.default.mFootStepNoiseMultiplier;
    }
    //return ReturnValue;    
}

simulated event float GetFootStepVolumeMultiplier()
{
    // End:0x14
    if(WeaponClass == none)
    {
        return 1.0000000;        
    }
    else
    {
        return WeaponClass.default.mFootStepVolumeMultiplier;
    }
    //return ReturnValue;    
}

simulated function byte GetFoleyType()
{
    // End:0x11
    if(WeaponClass == none)
    {
        return 0;        
    }
    else
    {
        return WeaponClass.default.mFoleyType;
    }
    //return ReturnValue;    
}

// Export UTurokWeaponAttachment::execGetWeapon(FFrame&, void* const)
native function @NULL GetWeapon();

simulated function name GetMuzzleName()
{
    return mMuzzleName;
    //return ReturnValue;    
}

// Export UTurokWeaponAttachment::execGetWeaponMuzzleLocation(FFrame&, void* const)
native simulated function @NULL GetWeaponMuzzleLocation(int FiringMode, optional @NULL MeshComponent);

// Export UTurokWeaponAttachment::execGetWeaponMuzzleRotation(FFrame&, void* const)
native function @NULL GetWeaponMuzzleRotation(int FiringMode, optional @NULL MeshComponent);

simulated function SpawnFirstPersonTracer()
{
    local @NULL MuzzleLocation;
    local int I;

    // End:0x0E
    if(mNewTracerEndLocation.Length <= 0)
    {
        return;
    }
    switch(mEquippedInHand)
    {
        // End:0x4E
        case 1:
            MuzzleLocation = GetWeaponMuzzleLocation(mNewTracerFireMode, mHumanOwner.GetLeftHandWeapon().mWeaponMesh);
            // End:0x8A
            break;
        // End:0x87
        case 0:
            MuzzleLocation = GetWeaponMuzzleLocation(mNewTracerFireMode, mHumanOwner.GetRightHandWeapon().mWeaponMesh);
            // End:0x8A
            break;
        // End:0xFFFF
        default:
            break;
    }
    I = 0;
    J0x91:

    // End:0xCA [Loop If]
    if(I < mNewTracerEndLocation.Length)
    {
        CreateTracer(MuzzleLocation, mNewTracerEndLocation[I], m1PTracerSettings);
        I++;
        // [Loop Continue]
        goto J0x91;
    }
    mbSpawnNewTracerInPreRender = false;
    mNewTracerEndLocation.Length = 0;
    //return;    
}

simulated function BowAttachmentAddTension(byte Tension)
{
    //return;    
}

simulated function byte BowAttachmentGetTension()
{
    //return ReturnValue;    
}

simulated function SMGAttachmentSetSilencerVisibility(bool visible)
{
    //return;    
}

simulated function SMGAttachmentThirdPersonDoEquipSilencer(bool equip)
{
    //return;    
}

simulated function SetNoiseLevel(bool silenced)
{
    //return;    
}

simulated function RPGAttachmentThirdPersonDoRocketVisible(bool bVisible)
{
    //return;    
}

simulated function RailgunAttachmentThirdPersonDoOverheat(bool isOverheating)
{
    //return;    
}

simulated function ChainGunAttachmentSetLights(byte Lights)
{
    //return;    
}

simulated function ChaingunAttachmentThirdPersonDoSteamEffect(bool isSteaming)
{
    //return;    
}

simulated function ChainGunAttachmentStartTripodIdle()
{
    //return;    
}

simulated function ChainGunAttachmentSetSpinRot(byte spin)
{
    //return;    
}

simulated function ChainGunAttachmentSetSpinStatus(bool SpinningUp)
{
    //return;    
}

simulated function UpdateChaingunBarrelAudio(int Yaw, float turbineModulator)
{
    //return;    
}

simulated function NotifyZoomPressed()
{
    //return;    
}

simulated function NotifyZoomReleased()
{
    //return;    
}

simulated function SetFireBladeAnimMode(byte mode)
{
    //return;    
}

simulated function DoGrenadeToss3P(bool bVisible)
{
    Play3PCannedAnimation(mCannedControllerName, m3PGrenadeAnim, m3PGrenadeAnimTime, m3PGrenadeAnimTime * 0.1000000, m3PGrenadeAnimTime * 0.1000000, false);
    //return;    
}

simulated function OnReplicatedStateChanged(int State)
{
    // End:0x1C
    if((State & (1 << 0)) > 0)
    {
        DoGrenadeToss3P(true);
    }
    // End:0x37
    if((State & (1 << 1)) > 0)
    {
        ThirdPersonDoReload();
    }
    // End:0x53
    if((State & (1 << 2)) > 0)
    {
        FinishedThirdPersonReload();
    }
    // End:0x70
    if((State & (1 << 3)) > 0)
    {
        ThirdPersonDoPhaseReloading(true);
    }
    // End:0x8D
    if((State & (1 << 4)) > 0)
    {
        ThirdPersonDoPhaseReloading(false);
    }
    //return;    
}

defaultproperties
{
    mEquippedInHand=2
    mbAlertAim=true
    mbCanPlayPOVTracers=true
    mEquipBoneName="jt_Wrist_R"
    m3PWeaponBlendJoint="jt_SpineLower_C"
    mRelaxedAimControllerName="RELAXEDAIMCONTROLLER"
    mFireControllerName="FIRECONTROLLER"
    mAltFireControllerName="ALTFIRECONTROLLER"
    mCannedControllerName="CANNEDCONTROLLER"
    mMuzzleName="MuzzleSkt"
    m3PGrenadeAnimTime=1.3000000
    mMaxFireEffectDistance=3200.0000000
    mMaxImpactEffectDistance=1600.0000000
    mFireMode3PFxOverride=-1
    m1PTracerSettings=(mTracerStartColor=(R=0.0000000,G=0.0000000,B=0.0000000,A=1.0000000),mTracerEndColor=(R=0.0000000,G=0.0000000,B=0.0000000,A=1.0000000),mTracerSpeedMin=0.0000000,mTracerSpeedMax=0.0000000,mTracerAccel=(X=0.0000000,Y=0.0000000,Z=0.0000000),mTracerSizeStartMin=(X=0.0000000,Y=0.0000000,Z=0.0000000),mTracerSizeStartMax=(X=0.0000000,Y=0.0000000,Z=0.0000000),mTracerSizeEndMin=(X=0.0000000,Y=0.0000000,Z=0.0000000),mTracerSizeEndMax=(X=0.0000000,Y=0.0000000,Z=0.0000000),mTimeBetweenSpawnMin=0.0000000,mTimeBetweenSpawnMax=0.0000000,mTracerInheritVelocityScale=0.0000000)
    m3PTracerSettings=(mTracerStartColor=(R=0.0000000,G=0.0000000,B=0.0000000,A=1.0000000),mTracerEndColor=(R=0.0000000,G=0.0000000,B=0.0000000,A=1.0000000),mTracerSpeedMin=0.0000000,mTracerSpeedMax=0.0000000,mTracerAccel=(X=0.0000000,Y=0.0000000,Z=0.0000000),mTracerSizeStartMin=(X=0.0000000,Y=0.0000000,Z=0.0000000),mTracerSizeStartMax=(X=0.0000000,Y=0.0000000,Z=0.0000000),mTracerSizeEndMin=(X=0.0000000,Y=0.0000000,Z=0.0000000),mTracerSizeEndMax=(X=0.0000000,Y=0.0000000,Z=0.0000000),mTimeBetweenSpawnMin=0.0000000,mTimeBetweenSpawnMax=0.0000000,mTracerInheritVelocityScale=0.0000000)
    mShotsToWaitForNextEffect=1
    mDryFireSndCue=SoundCue'SndWeapCommon.WeaponDryFireSndCue'
    mMaxWeaponAC=2
}