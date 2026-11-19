class TurokWeapAttachFirebladeNative extends TurokWeaponAttachment
    native
    config(Weapon);

var name mPilotLightSocket;
var export editinline @NULL m3PFlameComponent;
var @NULL m3PFlamePS;
var bool mb3PFlameActive;
var bool mbFlameLightActive;
var bool bDisablePilotLight;
var export editinline @NULL mPilotFlameLight;
var(FlameLight) export editinline @NULL mFlameLight;
var export editinline @NULL mFuelCellMesh;
var name mFuelCellBoneName;
var(Animations) name m3PAltReloadAnim;
var(Animations) name m3PReloadAttachCanister;
var(Animations) name m3PReloadDetachCanister;
var protected name mFireInControllerName;
var(Animations) @NULL m3PFireInAsset;
var protected name mFireOutControllerName;
var(Animations) @NULL m3PFireOutAsset;
var @NULL mFireBladeFlameLoopSndCue;
var @NULL mCanisterFillSndCue;
var int mCanisterFillSndChannel;

// Export UTurokWeapAttachFirebladeNative::execRequestEnableWeaponLight(FFrame&, void* const)
native function RequestEnableWeaponLight(@NULL LightComponent, bool isPOVWeapon);

// Export UTurokWeapAttachFirebladeNative::execInitFireEffects(FFrame&, void* const)
native function InitFireEffects(@NULL MeshComponent, out array fireEffects);

// Export UTurokWeapAttachFirebladeNative::execSetAttachmentMeshVisibility(FFrame&, void* const)
native function SetAttachmentMeshVisibility(bool bIs3rdPerson, bool bVisibleIn3rdPerson);

simulated function Enable3pFlameLight(bool Enable)
{
    // End:0x24
    if(Enable)
    {
        RequestEnableWeaponLight(mFlameLight, false);
        mbFlameLightActive = true;        
    }
    else
    {
        mbFlameLightActive = false;
        DisableWeaponLight(mFlameLight);
    }
    //return;    
}

simulated function FlameLightTimer()
{
    // End:0x39
    if(mbFlameLightActive)
    {
        // End:0x36
        if(mFlameLight.Brightness < 2.2000000)
        {
            mFlameLight.Brightness += 0.1000000;
        }        
    }
    else
    {
        // End:0xA0
        if(mFlameLight.Brightness > 0.1000000)
        {
            mFlameLight.Brightness -= 0.1000000;
            // End:0xA0
            if(mFlameLight.Brightness < 0.1000000)
            {
                mFlameLight.Brightness = 0.1000000;
                DisableWeaponLight(mFlameLight);                
            }
        }
    }
    //return;    
}

simulated function PlayThirdPersonFireEffects()
{
    local byte FireMode;

    // End:0x0D
    if(mHumanOwner == none)
    {
        return;
    }
    // End:0xD7
    if(!mHumanOwner.IsFirstPerson())
    {
        FireMode = mHumanOwner.GetFiringMode();
        // End:0x56
        if(mFireMode3PFxOverride >= 0)
        {
            FireMode = byte(mFireMode3PFxOverride);
        }
        CauseFireEffects(FireMode, 1);
        PlayPreFiringSound(FireMode);
        PlayAmbience(mFireBladeFlameLoopSndCue);
        Play3PSpatialAnimUseTargetFn(mFireControllerName, 0.5000000, 1.0000000, 0.3000000);
        // End:0xC1
        if(!mb3PFlameActive)
        {
            m3PFlameComponent.ActivateSystem();
            mb3PFlameActive = true;
        }
        Enable3pFlameLight(true);
        DisableWeaponLight(mPilotFlameLight);
    }
    //return;    
}

simulated function ContinueThirdPersonFireAnim()
{
    //return;    
}

simulated function EndThirdPersonFireEffects()
{
    // End:0x87
    if(!mHumanOwner.IsFirstPerson())
    {
        m3PFlameComponent.DeactivateSystem();
        mb3PFlameActive = false;
        SetSecondaryBlendTarget(mFireControllerName, 0.0000000, 0.3000000);
        Enable3pFlameLight(false);
        RequestEnableWeaponLight(mPilotFlameLight, false);
        PlayPostFiringSound(mHumanOwner.GetFiringMode());
        PlayAmbience();
    }
    //return;    
}

simulated function SetFireBladeAnimMode(byte mode)
{
    switch(mode)
    {
        // End:0x19
        case 1:
            PlayThirdPersonFireEffects();
            // End:0x90
            break;
        // End:0x2B
        case 2:
            ContinueThirdPersonFireAnim();
            // End:0x90
            break;
        // End:0x3D
        case 3:
            EndThirdPersonFireEffects();
            // End:0x90
            break;
        // End:0x54
        case 4:
            ThirdPersonReloadAttachCanister(1.3000000);
            // End:0x90
            break;
        // End:0x6B
        case 5:
            ThirdPersonReloadFillUpCanister(1.0000000);
            // End:0x90
            break;
        // End:0x82
        case 6:
            ThirdPersonReloadDetachCanister(1.0000000);
            // End:0x90
            break;
        // End:0x8A
        case 7:
            // End:0x90
            break;
        // End:0xFFFF
        default:
            // End:0x90
            break;
            break;
    }
    //return;    
}

event AttachAnimations()
{
    local editinline @NULL weaponMesh;
    local float alertWeight;

    weaponMesh = SkeletalMeshComponent(mAttachMesh);
    // End:0x13C
    if(weaponMesh != none)
    {
        // End:0x32
        if(mbAlertAim)
        {
            alertWeight = 1.0000000;            
        }
        else
        {
            alertWeight = 0.0000000;
        }
        weaponMesh.AnimSets = mWeaponAnimSets;
        InitBaseSpatialController(m3PAimAsset, true, true);
        InitSpatialController(mRelaxedAimControllerName, m3PRelaxedAimAsset, 'jt_SpineLower_C', 1.0000000, 1.0000000 - alertWeight, true, true);
        InitSpatialController(mFireInControllerName, m3PFireInAsset, 'jt_SpineLower_C', 1.0000000, 0.0000000, false, true);
        InitSpatialController(mFireOutControllerName, m3PFireOutAsset, 'jt_SpineLower_C', 1.0000000, 0.0000000, false, true);
        InitSpatialController(mFireControllerName, m3PFireAsset, 'jt_SpineLower_C', 1.0000000, 0.0000000, true, true);
        InitSpatialController(mAltFireControllerName, m3PAltFireAsset, 'jt_SpineLower_C', 1.0000000, 0.0000000, false, true);
        InitCannedController(mCannedControllerName, 'jt_SpineUpper_C', 1.0000000, 0.0000000);
    }
    //return;    
}

// Export UTurokWeapAttachFirebladeNative::execPlayImpactEffects(FFrame&, void* const)
native function PlayImpactEffects(@NULL HitLocation);

simulated event PlayImpactEffectsOLD(@NULL HitLocation)
{
    local @NULL HitInfo, traceHitLocation, traceHitNormal, EndTrace, HitDir, HitActor,
	    traceStartLocation, impactEmitter, impactRot, ImpactEffect;

    local float decalSize;
    local editinline @NULL cachedDecal;
    local byte FireModeNum;
    local bool bTriggerImpactFX;
    local @NULL emitterPool;

    // End:0x3F4
    if(mHumanOwner != none)
    {
        // End:0x30
        if(!mHumanOwner.EffectIsRelevant(HitLocation, false, mMaxImpactEffectDistance))
        {
            return;
        }
        emitterPool = Class'TurokPlayerController'.static.GetLocalPlayerController().GetEmitterManager();
        bTriggerImpactFX = ((float(mShotCount) % float(mShotsToWaitForNextEffect)) == float(0)) || mShotCount == 1;
        FireModeNum = mHumanOwner.GetFiringMode();
        mNewTracerFireMode = int(FireModeNum);
        traceStartLocation = mHumanOwner.GetWeaponStartTraceLocation();
        HitDir = Normal(HitLocation - traceStartLocation);
        EndTrace = traceStartLocation + (HitDir * WeaponClass.default.WeaponRange);
        HitActor = mHumanOwner.Trace(traceHitLocation, traceHitNormal, EndTrace, traceStartLocation, true,, HitInfo, WeaponClass.default.mDefaultTraceTypeFlags | WeaponClass.default.mDefaultTraceSourceFlags, true);
        // End:0x3F4
        if(HitActor != none)
        {
            // End:0x188
            if(mHumanOwner.CanHurt(HitActor))
            {
                PlayActorImpact(FireModeNum, HitActor, HitLocation, HitDir, HitInfo);
            }
            // End:0x3F4
            if(bTriggerImpactFX)
            {
                ImpactEffect = mImpactEffects[0];
                // End:0x24A
                if(ImpactEffect.mImpactSystem != none)
                {
                    impactRot = Rotator(traceHitNormal);
                    impactRot.Pitch -= 16384;
                    impactEmitter = TurokEmitter(emitterPool.GetEmitter(ImpactEffect.mImpactSystem, mHumanOwner, traceHitLocation, impactRot));
                    // End:0x24A
                    if(mImpactNoiseLevel[int(FireModeNum)] > 0.0000000)
                    {
                        impactEmitter.MakeNoise(mImpactNoiseLevel[int(FireModeNum)], 'NOISE_WeaponImpact');
                    }
                }
                // End:0x283
                if(ImpactEffect.mImpactSound.Length > 0)
                {
                    PlayImpactSound(ImpactEffect.mImpactSound[0], traceHitLocation);                    
                }
                else
                {
                    // End:0x299
                    if(ImpactEffect.mImpactSound.Length == 0)
                    {
                    }
                }
                // End:0x3F4
                if((HitActor != none) && ImpactEffect.mDecalMaterial != none)
                {
                    impactRot = Rotator(-traceHitNormal);
                    impactRot.Roll = int(FRand() * float(65535));
                    decalSize = ImpactEffect.mDecalMinSize + ((ImpactEffect.mDecalMaxSize - ImpactEffect.mDecalMinSize) * FRand());
                    cachedDecal = emitterPool.GetDecal(traceHitLocation);
                    HitActor.AddDecal(ImpactEffect.mDecalMaterial, traceHitLocation, impactRot, 0.0000000, decalSize, decalSize, 10.0000000, false, HitInfo.HitComponent, none, false, false, cachedDecal);
                    // End:0x3F4
                    if((mHumanOwner.GetRightHandWeapon() != none) && mHumanOwner.GetRightHandWeapon().mbShowDebugDecals)
                    {
                        mHumanOwner.DrawDebugSphere(traceHitLocation, 2.0000000, 4, byte(255), 128, 128, true);
                    }
                }
            }
        }
    }
    //return;    
}

// Export UTurokWeapAttachFirebladeNative::execThirdPersonFireEffects(FFrame&, void* const)
native function ThirdPersonFireEffects(@NULL HitLocation);

simulated event StopThirdPersonFireEffects()
{
    super.StopThirdPersonFireEffects();
    m3PFlameComponent.DeactivateSystem();
    mb3PFlameActive = false;
    //return;    
}

simulated function Stop3rdPersonEffectsImmediately()
{
    super.Stop3rdPersonEffectsImmediately();
    m3PFlameComponent.DeactivateSystem();
    m3PFlameComponent.KillParticlesForced();
    mb3PFlameActive = false;
    //return;    
}

simulated function EndFireEffects(byte FireModeNum, array fireEffects)
{
    local int Index;

    // End:0xBC
    if(IsAltFiringMode(FireModeNum))
    {
        Index = 0;
        J0x15:

        // End:0xB9 [Loop If]
        if(Index < mFireEffectAltIndex.Length)
        {
            // End:0xAF
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
            }
            ++Index;
            // [Loop Continue]
            goto J0x15;
        }        
    }
    else
    {
        Index = 0;
        J0xC3:

        // End:0x167 [Loop If]
        if(Index < mFireEffectIndex.Length)
        {
            // End:0x15D
            if((fireEffects.Length > mFireEffectIndex[Index]) && fireEffects[mFireEffectIndex[Index]] != none)
            {
                // End:0x15D
                if(mFireEffects[mFireEffectIndex[Index]].mLoops)
                {
                    // End:0x15D
                    if(ParticleSystemComponent(fireEffects[mFireEffectIndex[Index]]) != none)
                    {
                        ParticleSystemComponent(fireEffects[mFireEffectIndex[Index]]).DeactivateSystem();
                    }
                }
            }
            ++Index;
            // [Loop Continue]
            goto J0xC3;
        }
    }
    //return;    
}

simulated function DestroyFireEffects(@NULL MeshComponent, array particleFireEffects)
{
    local editinline @NULL sktMesh;

    sktMesh = SkeletalMeshComponent(mAttachMesh);
    // End:0x90
    if(sktMesh != none)
    {
        // End:0x41
        if(mPilotFlameLight != none)
        {
            sktMesh.DetachComponent(mPilotFlameLight);
            mPilotFlameLight = none;
        }
        // End:0x67
        if(mFlameLight != none)
        {
            sktMesh.DetachComponent(mFlameLight);
            mFlameLight = none;
        }
        // End:0x90
        if(m3PFlameComponent != none)
        {
            m3PFlameComponent.DeactivateSystem();
            m3PFlameComponent.KillParticlesForced();
        }
    }
    super.DestroyFireEffects(MeshComponent, particleFireEffects);
    //return;    
}

simulated function Hide3PFuelCellCanister()
{
    mFuelCellMesh.SetHidden(true);
    SkeletalMeshComponent(mAttachMesh).DetachComponent(mFuelCellMesh);
    //return;    
}

simulated function Show3PFuelCellCanister()
{
    mFuelCellMesh.SetHidden(false);
    SkeletalMeshComponent(mAttachMesh).AttachComponent(mFuelCellMesh, mFuelCellBoneName);
    //return;    
}

simulated function ThirdPersonDoReload()
{
    local float ReloadTime;
    local byte FiringMode;
    local name ReloadAnim;

    FiringMode = mHumanOwner.GetFiringMode();
    // End:0x73
    if(int(FiringMode) == 1)
    {
        ReloadAnim = m3PAltReloadAnim;
        ReloadTime = WeaponClass.default.mAltReloadStartTime;
        Play3PCannedAnimation(mCannedControllerName, ReloadAnim, ReloadTime, ReloadTime * 0.1000000, ReloadTime * 0.1000000, false);
    }
    //return;    
}

simulated function ThirdPersonReloadAttachCanister(float animTime)
{
    Play3PCannedAnimation(mCannedControllerName, m3PReloadAttachCanister, animTime, animTime * 0.1000000, 0.0000000, true);
    //return;    
}

simulated function ThirdPersonReloadDetachCanister(float animTime)
{
    StopCanisterFillSound();
    Play3PCannedAnimation(mCannedControllerName, m3PReloadDetachCanister, animTime, 0.0000000, animTime * 0.1000000, false);
    //return;    
}

simulated function ThirdPersonReloadFillUpCanister(float animTime)
{
    Play3PCannedAnimation(mCannedControllerName, m3PReloadAnim, animTime, 0.0000000, 0.0000000, true);
    mHumanOwner.SetTimer(animTime, false, 'StartCanisterFillSoundTimed');
    //return;    
}

// Export UTurokWeapAttachFirebladeNative::execPlaySpatialFireAnim(FFrame&, void* const)
native function PlaySpatialFireAnim(int FireMode, float fireTime);

simulated function StartCanisterFillSound()
{
    // End:0x3B
    if(mCanisterFillSndChannel == -1)
    {
        mCanisterFillSndChannel = mHumanOwner.mSoundController.CreateAudioChannel(mCanisterFillSndCue, true, true);        
    }
    else
    {
        mHumanOwner.mSoundController.PlayAudioChannel(mCanisterFillSndChannel);
    }
    //return;    
}

simulated function StopCanisterFillSound()
{
    mHumanOwner.mSoundController.StopAudioChannel(mCanisterFillSndChannel);
    //return;    
}

simulated function OnReplicatedStateChanged(int State)
{
    // End:0x1C
    if((State & (1 << 7)) > 0)
    {
        Show3PFuelCellCanister();
    }
    // End:0x38
    if((State & (1 << 8)) > 0)
    {
        Hide3PFuelCellCanister();
    }
    super.OnReplicatedStateChanged(State);
    //return;    
}
