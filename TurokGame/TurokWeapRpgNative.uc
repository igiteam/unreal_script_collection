class TurokWeapRpgNative extends TurokWeapon
    native
    config(WeapRpg)
    hidecategories(Navigation);

var private bool mbLockOn;
var bool mbLockOnHUD;
var private bool mColorCubeOn;
var(Animations) float mEnableLockOnTime;
var(Animations) @NULL mLockOnEquipAnim;
var(Animations) @NULL mLockOnUnEquipAnim;
var(Stealth) float mStealthFootStepNoiseMultiplier;
var(Stealth) float mStealthFootStepVolumeMultiplier;
var export editinline @NULL mRocketMesh;
var() name mRocketBoneName;
var(LockOn) float mLockOnMaxAimAngleDegrees;
var(LockOn) float mLockOnUpdateTime;
var(LockOn) float mLockOnIncTime;
var(LockOn) float mLockOnDecTime;
var(LockOn) float mLockOnReloadDelay;
var(LockOn) int mLockOnStick;
var(LockOn) int mLockOnPull;
var(LockOn) int mLockOnVerticalStick;
var(LockOn) float mLockOnSpeedBonus;
var(LockOn) float mLockOnLookSpeedModifier;
var transient array mOrigBodyMaterials;
var transient array mOrigHeadMaterials;
var(LockOn) @NULL mFriendlyOutline;
var(LockOn) @NULL mEnemyOutline;
var(LockOn) @NULL mColorCube;
var private @NULL mPreviousColorCube;
var private float mPreviousColorCubeBlend;
var float mLockOnCounter;
var private @NULL mLockOnTarget;
var private @NULL mLockedActor;
var private @NULL mLockOnRotation;
var private float mLockOnIncRate;
var private float mLockOnDecRate;
var(RPG) @NULL mZoomedPovOffset;
var(RPG) float mScopeToEyeTime;
var private float mCurScopeTime;
var private @NULL mLastRocket;
var(forcefeedback) @NULL mLockOnFF;

reliable server function ServerRPGStartFireLockOn(@NULL LockOnTarget)
{
    mLockOnTarget = LockOnTarget;
    mLockOnCounter = 1.0000000;
    mbLockOn = true;
    BeginFire(0);
    //return;    
}

reliable server function ServerRPGActiveState(bool LockOn)
{
    local @NULL tpp, TPC, mgr, sentry;

    mbLockOn = LockOn;
    // End:0x29
    if(!LockOn)
    {
        GotoState('Active');        
    }
    else
    {
        tpp = TurokPawnPlayer(Instigator);
        // End:0xDD
        if(tpp != none)
        {
            TPC = TurokPlayerController(tpp.Controller);
            mgr = TurokInventoryManager(tpp.InvManager);
            // End:0x91
            if(TPC != none)
            {
                TPC.mPickupMiniGunSentry = none;
            }
            // End:0xDD
            if(mgr != none)
            {
                sentry = TurokPawnMiniGunAutoTurretNative(mgr.GetSwitchToWeaponPickupActor());
                // End:0xDD
                if(sentry != none)
                {
                    mgr.EndPromptToDropItem(sentry);
                }
            }
        }
    }
    //return;    
}

reliable client simulated function ClientRPGChangingLockOn()
{
    // End:0x20
    if(Instigator.IsLocallyControlled())
    {
        GotoState('ChangingLockOn');
    }
    //return;    
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    mbLockOn = false;
    mbLockOnHUD = false;
    //return;    
}

simulated function bool CanAutoReload()
{
    return (!mbLockOn && GetStateName() != 'Reloading') && super.CanAutoReload();
    //return ReturnValue;    
}

simulated event bool CanThrowGrenade()
{
    return ((!mbLockOn && GetStateName() != 'ChangingLockOn') && GetStateName() != 'Reloading') && super.CanThrowGrenade();
    //return ReturnValue;    
}

simulated function AttachWeapon()
{
    super.AttachWeapon();
    mWeaponMesh.AttachComponent(mRocketMesh, mRocketBoneName);
    // End:0x3D
    if(mCurrentClipAmmo == 0)
    {
        mRocketMesh.SetHidden(true);
    }
    // End:0x9B
    if((Instigator != none) && Instigator.IsLocallyControlled())
    {
        // End:0x9B
        if((mRocketMesh != none) && TurokPawn(Instigator) != none)
        {
            mRocketMesh.SetLightEnvironment(TurokPawn(Instigator).LightEnvironment);
        }
    }
    //return;    
}

simulated function DetachWeapon()
{
    // End:0x4E
    if((Instigator != none) && Instigator.IsLocallyControlled())
    {
        mWeaponMesh.DetachComponent(mRocketMesh);
        // End:0x4E
        if(mRocketMesh != none)
        {
            mRocketMesh.SetLightEnvironment(none);
        }
    }
    super.DetachWeapon();
    //return;    
}

simulated function SetHidden(bool bNewHidden)
{
    super(Actor).SetHidden(bNewHidden);
    // End:0x31
    if(!bNewHidden && mCurrentClipAmmo != 0)
    {
        ShowRocket();        
    }
    else
    {
        HideRocket();
    }
    //return;    
}

// Export UTurokWeapRpgNative::execSetWeaponVisibility(FFrame&, void* const)
native function SetWeaponVisibility(bool bVisible);

simulated function class<Class> GetProjectileClass()
{
    // End:0x16
    if(!mbLockOn)
    {
        return WeaponProjectiles[0];        
    }
    else
    {
        return WeaponProjectiles[1];
    }
    //return ReturnValue;    
}

private final simulated function LockOnAcquired(@NULL Target)
{
    local @NULL TP, tph;
    local int NumMaterials, I;
    local @NULL SwapMat;

    // End:0x232
    if(Target.IsA('TurokPawn'))
    {
        TP = TurokPawn(Target);
        mAttachment.StopAmbience();
        TP.mSoundController.TryPlayLocalSound(TurokWeapAttachRpgNative(mAttachment).mLockAcquiredSndCue);
        // End:0x232
        if(TP.Mesh.SkeletalMesh != none)
        {
            // End:0xB4
            if(Instigator.CanHurt(Target))
            {
                SwapMat = mEnemyOutline;                
            }
            else
            {
                SwapMat = mFriendlyOutline;
            }
            NumMaterials = TP.Mesh.SkeletalMesh.Materials.Length;
            I = 0;
            J0xED:

            // End:0x15B [Loop If]
            if(I < NumMaterials)
            {
                mOrigBodyMaterials[I] = TP.Mesh.GetMaterial(I);
                TP.Mesh.SetMaterial(I, SwapMat);
                I++;
                // [Loop Continue]
                goto J0xED;
            }
            // End:0x232
            if(Target.IsA('TurokPawnHuman'))
            {
                tph = TurokPawnHuman(Target);
                // End:0x232
                if(tph.mHeadMesh != none)
                {
                    NumMaterials = tph.mHeadMesh.SkeletalMesh.Materials.Length;
                    I = 0;
                    J0x1C4:

                    // End:0x232 [Loop If]
                    if(I < NumMaterials)
                    {
                        mOrigHeadMaterials[I] = tph.mHeadMesh.GetMaterial(I);
                        tph.mHeadMesh.SetMaterial(I, SwapMat);
                        I++;
                        // [Loop Continue]
                        goto J0x1C4;
                    }
                }
            }
        }
    }
    //return;    
}

private final simulated function LockOnLost(@NULL Target)
{
    local @NULL TP, tph;
    local int NumMaterials, I;
    local @NULL TPC;

    // End:0x1BD
    if(Target.IsA('TurokPawn'))
    {
        TPC = TurokPlayerController(Instigator.Controller);
        // End:0x53
        if(TPC != none)
        {
            TPC.TurokStopForceFeedbackWaveform(mLockOnFF);
        }
        TP = TurokPawn(Target);
        // End:0x1BD
        if(TP.Mesh.SkeletalMesh != none)
        {
            NumMaterials = TP.Mesh.SkeletalMesh.Materials.Length;
            I = 0;
            J0xAE:

            // End:0xF4 [Loop If]
            if(I < NumMaterials)
            {
                TP.Mesh.SetMaterial(I, mOrigBodyMaterials[I]);
                I++;
                // [Loop Continue]
                goto J0xAE;
            }
            mOrigBodyMaterials.Remove(0, mOrigBodyMaterials.Length);
            // End:0x1BD
            if(Target.IsA('TurokPawnHuman'))
            {
                tph = TurokPawnHuman(Target);
                // End:0x1BD
                if(tph.mHeadMesh != none)
                {
                    NumMaterials = tph.mHeadMesh.SkeletalMesh.Materials.Length;
                    I = 0;
                    J0x16A:

                    // End:0x1B0 [Loop If]
                    if(I < NumMaterials)
                    {
                        tph.mHeadMesh.SetMaterial(I, mOrigHeadMaterials[I]);
                        I++;
                        // [Loop Continue]
                        goto J0x16A;
                    }
                    mOrigHeadMaterials.Remove(0, mOrigHeadMaterials.Length);
                }
            }
        }
    }
    mAttachment.PlayAmbience();
    //return;    
}

private final simulated function StartScreenEffect()
{
    local @NULL TPC;

    // End:0xC3
    if(Instigator.IsLocallyControlled())
    {
        TPC = TurokPlayerController(Instigator.Controller);
        mPreviousColorCube = TPC.TPP_GetTargetColorCubeTexture(0);
        mPreviousColorCubeBlend = TPC.TPP_GetTargetFloat(36);
        TPC.TPP_Begin();
        TPC.TPP_SetColorCubeTexture(0, mColorCube);
        TPC.TPP_SetFloatNative(36, 1.0000000);
        TPC.TPP_Apply();
        mColorCubeOn = true;
    }
    //return;    
}

simulated function EndScreenEffect()
{
    local @NULL TPC;

    // End:0xB4
    if((Instigator.IsLocallyControlled() && TurokPlayerController(Instigator.Controller) != none) && mColorCubeOn)
    {
        TPC = TurokPlayerController(Instigator.Controller);
        TPC.TPP_Begin();
        TPC.TPP_SetColorCubeTexture(0, mPreviousColorCube);
        TPC.TPP_SetFloatNative(36, mPreviousColorCubeBlend);
        TPC.TPP_Apply();
        mColorCubeOn = false;
    }
    //return;    
}

private final simulated function @NULL GetAimAssetTarget()
{
    local @NULL TargetActor;
    local float targetDist, ReticleDist, TempDist;
    local @NULL ReticleActor, PC, Aim;

    // End:0x180
    if(mbLockOn && Instigator.Controller != none)
    {
        PC = TurokPlayerController(Instigator.Controller);
        // End:0x180
        if(PC != none)
        {
            targetDist = 100000.0000000;
            ReticleDist = 100000.0000000;
            TargetActor = PC.GetAimAssistTarget(Location, Aim);
            // End:0xE6
            if(TargetActor != none)
            {
                TempDist = VSize(TargetActor.Location - Location);
                // End:0xDF
                if(Instigator.CanHurt(TargetActor) && TempDist > 500.0000000)
                {
                    targetDist = TempDist;                    
                }
                else
                {
                    TargetActor = none;
                }
            }
            ReticleActor = PC.mAimReticleTarget;
            // End:0x148
            if(ReticleActor != none)
            {
                // End:0x141
                if(Instigator.CanHurt(ReticleActor))
                {
                    ReticleDist = VSize(ReticleActor.Location - Location);                    
                }
                else
                {
                    ReticleActor = none;
                }
            }
            // End:0x162
            if((ReticleActor == none) && TargetActor == none)
            {
                return none;
            }
            // End:0x17A
            if(targetDist < ReticleDist)
            {
                return TargetActor;                
            }
            else
            {
                return ReticleActor;
            }
        }
    }
    return none;
    //return ReturnValue;    
}

simulated function ShowRocket()
{
    // End:0x42
    if(Instigator.IsFirstPerson())
    {
        mRocketMesh.SetHidden(false);
        mWeaponMesh.AttachComponent(mRocketMesh, mRocketBoneName);
    }
    TurokPawnHuman(Instigator).WeaponRPGRocketVisible(true);
    //return;    
}

simulated function HideRocket()
{
    mRocketMesh.SetHidden(true);
    mWeaponMesh.DetachComponent(mRocketMesh);
    TurokPawnHuman(Instigator).WeaponRPGRocketVisible(false);
    //return;    
}

function RocketExplodedCallback(@NULL rocket)
{
    // End:0x38
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x38
        if((mLastRocket == rocket) && mbLockOn)
        {
            GotoState('DelayedReload');
        }
    }
    //return;    
}

simulated function ReloadWeapon()
{
    // End:0x24
    if((GetStateName() != 'DelayedReload') && !mbLockOn)
    {
        super.ReloadWeapon();
    }
    //return;    
}

simulated event bool DoOverrideSpeedBonus()
{
    // End:0x0E
    if(mbIsMultiPlayer)
    {
        return true;        
    }
    else
    {
        return mbLockOn;
    }
    //return ReturnValue;    
}

simulated function DeactivateWeaponBegin()
{
    // End:0x23
    if(mbLockOn)
    {
        mbLockOn = false;
        mbLockOnHUD = false;
        EndScreenEffect();
    }
    //return;    
}

// Export UTurokWeapRpgNative::execCauseFireEffects(FFrame&, void* const)
native function CauseFireEffects(byte FireModeNum);

simulated function StickLockOn()
{
    //return;    
}

simulated function StickLockOff()
{
    //return;    
}

simulated function TurnLockOff()
{
    mLastRocket = none;
    EndScreenEffect();
    mbLockOnHUD = false;
    SetWeaponVisibility(true);
    // End:0x3F
    if(mCurrentClipAmmo != 0)
    {
        mRocketMesh.SetHidden(false);
    }
    // End:0x5E
    if(mAttachment != none)
    {
        mAttachment.StopAmbience();
    }
    StickLockOff();
    //return;    
}

simulated event @NULL ProjectileFire()
{
    local @NULL AimDir, RealStartLoc, PC, StartTrace, EndTrace, TestImpact;

    // End:0x226
    if(int(Role) == int(ROLE_Authority))
    {
        StartTrace = Instigator.GetWeaponStartTraceLocation();
        RealStartLoc = GetPhysicalFireStartLoc();
        // End:0xB0
        if(StartTrace != RealStartLoc)
        {
            EndTrace = StartTrace + (Vector(GetAdjustedAim(StartTrace)) * (GetTraceRange()));
            TestImpact = CalcWeaponFire(StartTrace, EndTrace);
            AimDir = Normal(TestImpact.HitLocation - RealStartLoc);            
        }
        else
        {
            AimDir = Vector(GetAdjustedAim(RealStartLoc));
        }
        mLastRocket = TurokProjRocketNative(__NFUN_278__(GetProjectileClass(), self, 'rocket', RealStartLoc,,, true));
        // End:0x226
        if((mLastRocket != none) && !mLastRocket.bDeleteMe)
        {
            mLastRocket.Init(AimDir);
            // End:0x19B
            if(mbLockOn && Instigator.Controller != none)
            {
                PC = TurokPlayerController(Instigator.Controller);
                // End:0x198
                if(PC != none)
                {
                    mLastRocket.SetLockOnTarget(mLockOnTarget);
                    mLockOnTarget = none;
                    mLockOnCounter = 0.0000000;
                }                
            }
            else
            {
                PC = TurokPlayerController(Instigator.Controller);
                // End:0x226
                if((PC != none) && PC.mAimAssistTarget != none)
                {
                    // End:0x226
                    if(TurokAIController(PC.mAimAssistTarget.Controller) != none)
                    {
                        TurokAIController(PC.mAimAssistTarget.Controller).NotifyIncomingRocket(mLastRocket);
                    }
                }
            }
        }
    }
    HideRocket();
    IncrementFlashCount();
    return mLastRocket;
    //return ReturnValue;    
}

simulated state DelayedReload
{
    simulated function BeginState(name PreviousStateName)
    {
        SetTimer(mLockOnReloadDelay, false, 'ReloadCallback');
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        ClearTimer('ReloadCallback');
        //return;        
    }

    simulated function ReloadCallback()
    {
        // End:0x1A
        if(int(Role) == int(ROLE_Authority))
        {
            ClientRPGChangingLockOn();
        }
        //return;        
    }

    simulated function bool DoOverrideNextWeapon()
    {
        return true;
        //return ReturnValue;        
    }

    simulated function bool DoOverridePrevWeapon()
    {
        return true;
        //return ReturnValue;        
    }
    stop;    
}

simulated state WeaponPuttingDown
{
    simulated function BeginState(name PreviousStateName)
    {
        mbLockOn = false;
        TurnLockOff();
        super.BeginState(PreviousStateName);
        //return;        
    }
    stop;    
}

simulated state WeaponEquipping
{
    simulated function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        // End:0x20
        if(mCurrentClipAmmo > 0)
        {
            ShowRocket();
        }
        //return;        
    }
    stop;    
}

simulated state Active
{
    simulated function bool DoOverrideNextWeapon()
    {
        return mbLockOn;
        //return ReturnValue;        
    }

    simulated function bool DoOverridePrevWeapon()
    {
        return mbLockOn;
        //return ReturnValue;        
    }

    simulated function bool CanUseAction()
    {
        return !mbLockOn;
        //return ReturnValue;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        local int I, mode;

        // End:0x43
        if(((PreviousStateName == 'ReActivated') && mWeaponMesh.HiddenGame == true) && mbLockOn == false)
        {
            SetWeaponVisibility(true);
        }
        // End:0x6D
        if((PreviousStateName == 'ReActivated') && mCurrentClipAmmo == 1)
        {
            ShowRocket();
        }
        // End:0xCA
        if(mbLockOn)
        {
            mLockOnIncRate = mLockOnUpdateTime / mLockOnIncTime;
            mLockOnDecRate = mLockOnUpdateTime / mLockOnDecTime;
            mLockOnCounter = 0.0000000;
            // End:0xCA
            if(Instigator.IsLocallyControlled())
            {
                SetTimer(mLockOnUpdateTime, true, 'LockOnUpdateTimer');
            }
        }
        // End:0xE0
        if(bWeaponPutDown)
        {
            PutDownWeapon();            
        }
        else
        {
            // End:0x12E
            if(mCurrentClipAmmo == 0)
            {
                // End:0x12B
                if((Instigator.GetStateName() != 'PickupMiniGunSentry') && Instigator.GetStateName() != 'DeployMiniGunSentry')
                {
                    WeaponEmpty();
                }                
            }
            else
            {
                I = 0;
                J0x135:

                // End:0x1AB [Loop If]
                if(I < InvManager.PendingFire.Length)
                {
                    // End:0x1A1
                    if(PendingFire(I))
                    {
                        // End:0x182
                        if((I == 0) || I == 1)
                        {
                            mode = 0;                            
                        }
                        else
                        {
                            mode = I;
                        }
                        BeginFire(byte(mode));
                        // [Explicit Break]
                        goto J0x1AB;
                    }
                    I++;
                    // [Loop Continue]
                    goto J0x135;
                }
            }
        }
        J0x1AB:

        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        super(Object).EndState(NextStateName);
        SetTimer(0.0000000, false, 'LockOnUpdateTimer');
        // End:0x3B
        if(mbLockOn && Instigator.IsLocallyControlled())
        {
        }
        // End:0x58
        if(mLockedActor != none)
        {
            LockOnLost(mLockedActor);
            mLockedActor = none;
        }
        //return;        
    }

    simulated function LockOnUpdateTimer()
    {
        local @NULL CurrentTarget;
        local float DiffAngle, DecRate;
        local @NULL TPC;

        CurrentTarget = GetAimAssetTarget();
        // End:0xE8
        if((CurrentTarget != none) && mCurrentClipAmmo != 0)
        {
            mLockOnTarget = CurrentTarget;
            mLockOnRotation = Rotation;
            mLockOnCounter += mLockOnIncRate;
            // End:0xE5
            if(mLockOnCounter >= 1.0000000)
            {
                mLockOnCounter = 1.0000000;
                // End:0x79
                if(mLockedActor == none)
                {
                    LockOnAcquired(mLockOnTarget);                    
                }
                else
                {
                    // End:0x9E
                    if(mLockedActor != mLockOnTarget)
                    {
                        LockOnLost(mLockedActor);
                        LockOnAcquired(mLockOnTarget);
                    }
                }
                TPC = TurokPlayerController(Instigator.Controller);
                // End:0xDA
                if(TPC != none)
                {
                    TPC.TurokPlayForceFeedbackWaveform(mLockOnFF);
                }
                mLockedActor = mLockOnTarget;
            }            
        }
        else
        {
            // End:0x194
            if(mLockOnTarget != none)
            {
                DiffAngle = Normal(mLockOnTarget.Location - Location) Dot Vector(Rotation);
                DiffAngle = Acos(DiffAngle) * 57.2957800;
                // End:0x168
                if(DiffAngle < mLockOnMaxAimAngleDegrees)
                {
                    DecRate = DiffAngle / mLockOnMaxAimAngleDegrees;
                    mLockOnCounter -= (mLockOnDecRate * DecRate);                    
                }
                else
                {
                    mLockOnCounter = 0.0000000;
                }
                // End:0x194
                if(mLockOnCounter <= 0.0000000)
                {
                    mLockOnCounter = 0.0000000;
                    mLockOnTarget = none;
                }
            }
        }
        // End:0x1C2
        if((mLockedActor != none) && mLockOnCounter < 1.0000000)
        {
            LockOnLost(mLockedActor);
            mLockedActor = none;
        }
        //return;        
    }

    simulated function BeginFire(byte FireModeNum)
    {
        local @NULL InstigatorController;

        // End:0x59
        if(int(FireModeNum) == 0)
        {
            // End:0x4B
            if(mbLockOn)
            {
                // End:0x3D
                if((mLockOnCounter >= 1.0000000) && mLockOnTarget != none)
                {
                    super.BeginFire(FireModeNum);
                }
                mLockOnCounter = 0.0000000;                
            }
            else
            {
                super.BeginFire(FireModeNum);
            }            
        }
        else
        {
            // End:0xE3
            if((int(FireModeNum) == 1) && Instigator.IsLocallyControlled())
            {
                InstigatorController = TurokPlayerController(Instigator.Controller);
                // End:0xBF
                if(InstigatorController != none)
                {
                    // End:0xBF
                    if(InstigatorController.mZoomer.IsZoomed())
                    {
                        return;
                    }
                }
                // End:0xDB
                if(mCurrentClipAmmo > 0)
                {
                    GotoState('ChangingLockOn');                    
                }
                else
                {
                    super.BeginFire(1);
                }
            }
        }
        //return;        
    }

    simulated event StartFire(byte FireModeNum)
    {
        // End:0x56
        if(int(Role) != int(ROLE_Authority))
        {
            // End:0x56
            if((mbLockOn && mLockOnCounter >= 1.0000000) && int(FireModeNum) == 0)
            {
                ServerRPGStartFireLockOn(mLockOnTarget);
                BeginFire(0);
                return;
            }
        }
        // End:0xB5
        if((((mbLockOn && mLockOnCounter >= 1.0000000) && int(FireModeNum) == 0) || int(FireModeNum) == 1) || !mbLockOn && int(FireModeNum) == 0)
        {
            super(TurokWeapon).StartFire(FireModeNum);
        }
        //return;        
    }
    stop;    
}

simulated state ChangingLockOn
{
    simulated function ToggleLockOn()
    {
        // End:0x7D
        if(mbLockOn)
        {
            SetWeaponVisibility(false);
            mRocketMesh.SetHidden(true);
            // End:0x58
            if(Instigator.IsLocallyControlled())
            {
                TurokPawnPlayer(Instigator).mPovArms.SetMeshHidden(true);
            }
            mbLockOnHUD = true;
            StartScreenEffect();
            mAttachment.PlayAmbience();            
        }
        else
        {
            // End:0x9A
            if(Instigator.IsLocallyControlled())
            {
                ServerRPGActiveState(false);
            }
        }
        GotoState('Active');
        //return;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        local float toggleTime;
        local @NULL InstigatorController;

        HideReticle();
        mbLockOn = !mbLockOn;
        // End:0x11C
        if(!mbLockOn)
        {
            TurnLockOff();
            // End:0x62
            if(Instigator.IsLocallyControlled())
            {
                TurokPawnPlayer(Instigator).mPovArms.SetMeshHidden(false);
            }
            InstigatorController = TurokPlayerController(Instigator.Controller);
            // End:0xDC
            if(InstigatorController != none)
            {
                InstigatorController.mZoomer.EnableToggleZoom(false);
                InstigatorController.mZoomer.EnableSlideZoom(false);
                InstigatorController.mZoomer.ResetZoomLevel();
            }
            toggleTime = mDisableLockOnTime;
            PlayPOVAnimation(mLockOnUnEquipAnim, toggleTime, 0.0000000, toggleTime * 0.1000000, true, false);
            mCurScopeTime = 1.0000000;            
        }
        else
        {
            ServerRPGActiveState(true);
            toggleTime = mEnableLockOnTime;
            PlayPOVAnimation(mLockOnEquipAnim, toggleTime, toggleTime * 0.1000000, toggleTime * 0.1000000, true, false);
            mCurScopeTime = 0.0000000;
            StickLockOn();
        }
        mScopeToEyeTime = toggleTime * 0.8000000;
        SetTimer(toggleTime * 0.9000000, false, 'ToggleLockOn');
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        ShowReticle();
        SetTimer(0.0000000, false, 'ToggleLockOn');
        //return;        
    }

    simulated event ModifyPOVOffset(out @NULL PovOffset)
    {
        PovOffset = VLerp(mPovOffset, mZoomedPovOffset, mCurScopeTime / mScopeToEyeTime);
        //return;        
    }

    simulated event Tick(float DeltaTime)
    {
        // End:0x18
        if(mbLockOn)
        {
            mCurScopeTime += DeltaTime;            
        }
        else
        {
            mCurScopeTime -= DeltaTime;
        }
        // End:0x41
        if(mCurScopeTime >= mScopeToEyeTime)
        {
            mCurScopeTime = mScopeToEyeTime;            
        }
        else
        {
            // End:0x59
            if(mCurScopeTime < float(0))
            {
                mCurScopeTime = 0.0000000;
            }
        }
        //return;        
    }

    simulated function bool DoOverrideNextWeapon()
    {
        return true;
        //return ReturnValue;        
    }

    simulated function bool DoOverridePrevWeapon()
    {
        return true;
        //return ReturnValue;        
    }
    stop;    
}

simulated state Reloading
{
    simulated function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        SetTimer(0.4360000, false, 'ShowRocketTimer');
        SetTimer(1.2500000, false, 'LoadAmmoTimer');
        // End:0x9B
        if(mbLockOn)
        {
            SetWeaponVisibility(true);
            mRocketMesh.SetHidden(false);
            // End:0x89
            if(Instigator.IsLocallyControlled())
            {
                TurokPawnPlayer(Instigator).mPovArms.SetMeshHidden(false);
            }
            mbLockOnHUD = false;
            EndScreenEffect();
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        // End:0x19
        if(!IsClipFull())
        {
            HideRocket();
        }
        ClearTimer('ShowRocketTimer');
        ClearTimer('LoadAmmoTimer');
        // End:0x92
        if(((NextStateName == 'Deactivated') || NextStateName == 'ReActivated') && Instigator.GetStateName() == 'DefenderMaulAnimation')
        {
            // End:0x92
            if(mCurrentClipAmmo == 0)
            {
                LoadAmmoTimer();
            }
        }
        // End:0xF8
        if(((NextStateName == 'Deactivated') && Instigator.GetStateName() == 'KnockdownAnimation') && mCurrentClipAmmo == 0)
        {
            // End:0xF8
            if(HasPoolAmmo(0))
            {
                // End:0xF8
                if(int(Role) == int(ROLE_Authority))
                {
                    LoadAmmoTimer();
                }
            }
        }
        // End:0x15E
        if(mbLockOn)
        {
            SetWeaponVisibility(false);
            mRocketMesh.SetHidden(true);
            // End:0x150
            if(Instigator.IsLocallyControlled())
            {
                TurokPawnPlayer(Instigator).mPovArms.SetMeshHidden(true);
            }
            mbLockOnHUD = true;
            StartScreenEffect();
        }
        super.EndState(NextStateName);
        //return;        
    }

    simulated function LoadAmmoTimer()
    {
        local int amountToLoad, freeAmmo;

        freeAmmo = GetAmmoPoolCount();
        // End:0x96
        if(!IsClipFull() && freeAmmo > 0)
        {
            amountToLoad = Min(mReloadAmount, freeAmmo);
            amountToLoad = Min(mMaxClipAmmo - mCurrentClipAmmo, amountToLoad);
            mCurrentClipAmmo = mCurrentClipAmmo + amountToLoad;
            TurokInventoryManager(Instigator.InvManager).AdjustAmmoPool(mAmmoPoolClass, -amountToLoad);
        }
        freeAmmo = GetAmmoPoolCount();
        // End:0xDB
        if((IsClipFull()) || freeAmmo == 0)
        {
            // End:0xD8
            if(mReloadEndTime > float(0))
            {
                SetTimer(mReloadEndTime, false);
            }            
        }
        else
        {
            // End:0xF6
            if(mReloadTime > float(0))
            {
                SetTimer(mReloadTime, false);                
            }
            else
            {
                SetTimer(0.0100000, false);
            }
        }
        //return;        
    }

    simulated function ShowRocketTimer()
    {
        ShowRocket();
        //return;        
    }
    stop;    
}

state Inactive
{
    simulated function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        TurnLockOff();
        mbLockOnHUD = false;
        mbLockOn = false;
        ClearTimer('ShowRocketTimer');
        HideRocket();
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: TurokZoomComponent'Default__TurokWeapRpgNative.Zoom'
    begin object name=Zoom
    end object
    mZoomValues=Zoom
}