class TurokWeapFirebladeNative extends TurokWeapon
    native
    config(WeapFireblade)
    hidecategories(Navigation);

enum ETurokFireBlade3PAnimMode
{
    ETFBAM_None,                    // 0
    ETFBAM_FireIn,                  // 1
    ETFBAM_ContinueFiring,          // 2
    ETFBAM_FireOut,                 // 3
    ETFBAM_MountCanister,           // 4
    ETFBAM_ReloadFromCanister,      // 5
    ETFBAM_RemoveCanister,          // 6
    ETFBAM_FinishedReload,          // 7
    ETFBAM_MAX                      // 8
};

var(FirebladePressure) float mMaxPressure;
var(FirebladePressure) float mMinPressure;
var(FirebladePressure) float mDepressurizeRate;
var(FirebladePressure) float mPressurizeRate;
var(FirebladeAnims) float mRecoilInTime;
var(FirebladeAnims) float mRecoilOutTime;
var(FirebladeAnims) float mReloadAttachCanisterTime;
var(FirebladeAnims) float mReloadDetachCanisterTime;
var(FirebladeAnims) float mFillUpTime;
var(OldFireblade) bool mbClampProjectileRotation;
var(OldFireblade) bool mbUseClampedRotForDir;
var(FirebladeProjectile) bool mbUseNewTrajCalc;
var(FirebladeProjectile) bool mbUseStrafe;
var bool mbLinkProjectiles;
var bool mbOkToSpawnProjectile;
var bool mbStartedFireInAnim;
var bool mbOkToScanForHit;
var bool mbFiring;
var(FlameTrace) bool mbShowFlameTraceDebugLine;
var bool mBlink;
var(OldFireblade) float mLinkWeight;
var(OldFireblade) float mAimSensitivity;
var(OldFireblade) int mProjectileRotClamp;
var(FirebladeProjectile) int mMaxProjYaw;
var(FirebladeProjectile) int mMaxProjPitch;
var(FirebladeProjectile) float mRotationAdjustPct;
var(FirebladeProjectile) float mStrafeAdjustPct;
var(FirebladePilotlight) float mMinPilotlightBrightness;
var(FirebladePilotlight) float mMaxPilotlightBrightness;
var(FirebladePilotlight) @NULL mMaxPilotlightColor;
var(FirebladePilotlight) @NULL mMinPilotlightColor;
var(FirebladePilotlight) float mMinPilotlightRadius;
var(FirebladePilotlight) float mMaxPilotlightRadius;
var @NULL mPreviousProjectile;
var float mCurrentPressure;
var float fireVelocityScalar;
var int mProjectileCount;
var float mFiringRecoil;
var float mOldFiringRecoil;
var float mPressureGaugeInc;
var float mPressureGaugePercent;
var @NULL mFlameTraceEndPoint;
var @NULL mFlameTraceStartPoint;
var float mFlameTraceLength;
var byte mFlameTraceCount;
var(FlameTrace) config array mEndTraceOffsets;
var float mMaxFlameTraceLength;
var(FlameTrace) config float mPlayerMaxFlameTraceLength;
var(FlameTrace) config float mAIMaxFlameTraceLength;
var(FlameTrace) config float mDelayBeforeScanningForHit;
var name mPilotLightSocket;
var export editinline @NULL mPilotFlameLight;
var export editinline @NULL mPOVMuzzleFlashComponent;
var @NULL mPOVMuzzlePS;
var private @NULL mFuelPumpControl;
var private @NULL mPressureGaugeControl;
var @NULL mAmmoLightMI;
var @NULL mPilotLightMI;
var export editinline @NULL mFuelCellMesh;
var() name mFuelCellBoneName;
var(Animations) @NULL mAltReloadAnim;
var(Animations) @NULL mFireInAnim;
var(Animations) @NULL mFireOutAnim;
var(Animations) @NULL mFireIdleAnim;
var(Animations) @NULL mReloadAttachCanister;
var(Animations) @NULL mReloadDetachCanister;
var @NULL mFlameFlare;

simulated function ShowFuelCellMesh()
{
    mFuelCellMesh.SetHidden(false);
    mFuelCellMesh.SetLightEnvironment(mWeaponMesh.LightEnvironment);
    mWeaponMesh.AttachComponent(mFuelCellMesh, mFuelCellBoneName);
    //return;    
}

simulated function HideFuelCellMesh()
{
    mFuelCellMesh.SetHidden(true);
    mFuelCellMesh.SetLightEnvironment(none);
    mWeaponMesh.DetachComponent(mFuelCellMesh);
    //return;    
}

// Export UTurokWeapFirebladeNative::execSetWeaponVisibility(FFrame&, void* const)
native function SetWeaponVisibility(bool bVisible);

simulated function AttachWeapon()
{
    super.AttachWeapon();
    // End:0x1BD
    if((Instigator != none) && Instigator.IsLocallyControlled())
    {
        // End:0x1BD
        if(mWeaponMesh != none)
        {
            mAmmoLightMI = new (none) Class'Engine.MaterialInstanceConstant';
            mAmmoLightMI.SetParent(mWeaponMesh.GetMaterial(4));
            mWeaponMesh.SetMaterial(4, mAmmoLightMI);
            SetAmmoIndicatorLightColor(mBlink);
            mPilotLightMI = new (none) Class'Engine.MaterialInstanceConstant';
            mPilotLightMI.SetParent(mWeaponMesh.GetMaterial(6));
            mWeaponMesh.SetMaterial(6, mPilotLightMI);
            // End:0x10E
            if(mFuelPumpControl == none)
            {
                mFuelPumpControl = TurokSkelControlProceduralTranslation(mWeaponMesh.FindSkelControl('FlamethrowerSkelControl'));
            }
            // End:0x13C
            if(mPressureGaugeControl == none)
            {
                mPressureGaugeControl = SkelControlSingleBone(mWeaponMesh.FindSkelControl('PressureGaugeControl'));
            }
            // End:0x160
            if(mFuelPumpControl != none)
            {
                mFuelPumpControl.SetSkelControlStrength(1.0000000, 0.0000000);
            }
            // End:0x1BD
            if(mPressureGaugeControl != none)
            {
                mPressureGaugePercent = 0.0000000;
                mPressureGaugeControl.SetSkelControlStrength(1.0000000, 0.0000000);
                mPressureGaugeControl.BoneRotation.Yaw = int((mPressureGaugePercent * 182.0444000) * -90.0000000);
            }
        }
    }
    // End:0x1DB
    if(TurokPawnPlayer(Instigator) != none)
    {
        mMaxFlameTraceLength = mPlayerMaxFlameTraceLength;        
    }
    else
    {
        mMaxFlameTraceLength = mAIMaxFlameTraceLength;
    }
    WeaponRange = mMaxFlameTraceLength;
    //return;    
}

simulated function TogglePilotLight(bool On)
{
    // End:0x38
    if(mPilotLightMI != none)
    {
        mPilotLightMI.SetScalarParameterValue('SLightVisability', ((On) ? 1.0000000 : 0.0000000));
    }
    //return;    
}

simulated function DetachWeapon()
{
    mAmmoLightMI = none;
    super.DetachWeapon();
    //return;    
}

simulated function PostBeginPlay()
{
    HideFuelCellMesh();
    super.PostBeginPlay();
    //return;    
}

simulated event SetAmmoIndicatorLightColor(bool forceBlack)
{
    local @NULL newColor, newLinearColor;
    local int R, G, B;
    local float clipAmmoPct;

    // End:0x199
    if(mAmmoLightMI != none)
    {
        clipAmmoPct = float(mCurrentClipAmmo) / float(mMaxClipAmmo);
        // End:0x49
        if(clipAmmoPct == 0.0000000)
        {
            R = 236;
            G = 0;
            B = 0;            
        }
        else
        {
            // End:0x6A
            if(forceBlack)
            {
                R = 1;
                G = 1;
                B = 1;                
            }
            else
            {
                // End:0x91
                if(clipAmmoPct > 0.2000000)
                {
                    R = 1;
                    G = 1;
                    B = 1;                    
                }
                else
                {
                    R = 236;
                    G = 0;
                    B = 0;
                }
            }
        }
        newColor = MakeColor(byte(R), byte(G), byte(B));
        newLinearColor = ColorToLinearColor(newColor);
        mAmmoLightMI.SetVectorParameterValue('VEmssHue', newLinearColor);
        // End:0x181
        if(clipAmmoPct > 0.0000000)
        {
            // End:0x142
            if((clipAmmoPct <= 0.2000000) && !IsTimerActive('AmmoBlinkTimer'))
            {
                SetTimer(0.2000000, true, 'AmmoBlinkTimer');                
            }
            else
            {
                // End:0x17E
                if((clipAmmoPct > 0.2000000) && IsTimerActive('AmmoBlinkTimer'))
                {
                    ClearTimer('AmmoBlinkTimer');
                    mBlink = false;
                }
            }            
        }
        else
        {
            ClearTimer('AmmoBlinkTimer');
            mBlink = false;
        }
    }
    //return;    
}

simulated function AmmoBlinkTimer()
{
    mBlink = !mBlink;
    SetAmmoIndicatorLightColor(mBlink);
    //return;    
}

simulated function InitFireEffects()
{
    local editinline @NULL sktMesh;

    sktMesh = mWeaponMesh;
    super.InitFireEffects();
    // End:0xB1
    if(sktMesh != none)
    {
        sktMesh.AttachComponentToSocket(mPilotFlameLight, mPilotLightSocket);
        mPOVMuzzleFlashComponent.SetTemplate(mPOVMuzzlePS);
        sktMesh.AttachComponentToSocket(mPOVMuzzleFlashComponent, mAttachment.GetMuzzleName());
        mPOVMuzzleFlashComponent.DeactivateSystem();
        // End:0xA5
        if(!Instigator.IsFirstPerson())
        {
            DisableWeaponLight(mPilotFlameLight);            
        }
        else
        {
            RequestEnableWeaponLight(mPilotFlameLight, true);
        }
    }
    //return;    
}

simulated function DestroyFireEffects()
{
    local editinline @NULL sktMesh;

    StopAllFiringEffectsImmediately();
    sktMesh = mWeaponMesh;
    // End:0x5E
    if(sktMesh != none)
    {
        // End:0x3F
        if(mPOVMuzzleFlashComponent != none)
        {
            sktMesh.DetachComponent(mPOVMuzzleFlashComponent);
        }
        // End:0x5E
        if(mPilotFlameLight != none)
        {
            sktMesh.DetachComponent(mPilotFlameLight);
        }
    }
    super.DestroyFireEffects();
    //return;    
}

simulated function StopAllFiringEffectsImmediately()
{
    mPOVMuzzleFlashComponent.DeactivateSystem();
    mPOVMuzzleFlashComponent.KillParticlesForced();
    super.StopAllFiringEffectsImmediately();
    //return;    
}

simulated event Tick(float DeltaTime)
{
    local float curClip, maxClip, fScale;

    // End:0x16B
    if(DeltaTime > 0.0000000)
    {
        mbOkToSpawnProjectile = true;
        mPilotFlameLight.LightColor.R = byte(float(mMinPilotlightColor.R) + (FRand() * float(int(mMaxPilotlightColor.R) - int(mMinPilotlightColor.R))));
        mPilotFlameLight.LightColor.G = byte(float(mMinPilotlightColor.G) + (FRand() * float(int(mMaxPilotlightColor.G) - int(mMinPilotlightColor.G))));
        mPilotFlameLight.LightColor.B = byte(float(mMinPilotlightColor.B) + (FRand() * float(int(mMaxPilotlightColor.B) - int(mMinPilotlightColor.B))));
        mPilotFlameLight.Radius = mMinPilotlightRadius + (FRand() * (mMaxPilotlightRadius - mMinPilotlightRadius));
        mPilotFlameLight.Brightness = mMinPilotlightBrightness + (FRand() * (mMaxPilotlightBrightness - mMinPilotlightBrightness));
    }
    // End:0x1CB
    if(mFuelPumpControl != none)
    {
        curClip = float(mCurrentClipAmmo);
        maxClip = float(mMaxClipAmmo);
        mFuelPumpControl.mBlend = 1.0000000 - (curClip / maxClip);
        mFuelPumpControl.SetSkelControlStrength(1.0000000, 0.0000000);
    }
    // End:0x2D3
    if(mPressureGaugeControl != none)
    {
        // End:0x232
        if(((HasAmmo(0)) && mbFiring) && mPressureGaugeInc <= float(0))
        {
            fScale = 1.0000000 - mPressureGaugePercent;
            mPressureGaugeInc = ((0.0100000 * 10.0000000) * fScale) * fScale;
        }
        mPressureGaugePercent += mPressureGaugeInc;
        // End:0x280
        if(mPressureGaugePercent >= 1.0000000)
        {
            mPressureGaugePercent = 1.0000000;
            mPressureGaugeInc = 0.0700000;
            mPressureGaugePercent = 0.9700000 - (float(Rand(8)) / 100.0000000);            
        }
        else
        {
            // End:0x2A5
            if(mPressureGaugePercent <= 0.0000000)
            {
                mPressureGaugePercent = 0.0000000;
                mPressureGaugeInc = 0.0000000;
            }
        }
        mPressureGaugeControl.BoneRotation.Yaw = int((mPressureGaugePercent * 182.0444000) * -90.0000000);
    }
    // End:0x31B
    if(mbShowFlameTraceDebugLine && mbOkToScanForHit)
    {
        DrawDebugLine(mFlameTraceStartPoint, mFlameTraceEndPoint, byte(255), 0, 0, false);
        DrawDebugSphere(mFlameTraceEndPoint, 16.0000000, 8, byte(255), 0, 0, false);
    }
    super(Actor).Tick(DeltaTime);
    //return;    
}

simulated function FlameTraceCalcTimer()
{
    local @NULL startLoc, AimDir, ViewRot;

    startLoc = GetPhysicalFireStartLoc();
    AimDir = Normal(Vector(GetAdjustedAim(startLoc)));
    ViewRot = Rotator(AimDir);
    mFlameTraceLength = mMaxFlameTraceLength * (mCurrentPressure / mMaxPressure);
    mFlameTraceEndPoint = (startLoc + (AimDir * mFlameTraceLength)) + (mEndTraceOffsets[int(mFlameTraceCount)] >> ViewRot);
    ViewRot.Pitch = 0;
    mFlameTraceStartPoint = startLoc + ((mEndTraceOffsets[int(mFlameTraceCount)] / 6.0000000) >> ViewRot);
    mFlameTraceCount++;
    // End:0xDB
    if(int(mFlameTraceCount) == mEndTraceOffsets.Length)
    {
        mFlameTraceCount = 0;
    }
    //return;    
}

simulated event RangeLimitedRayFiring()
{
    // End:0x20
    if(Instigator.IsFirstPerson())
    {
        SpawnFirebladeProjectile();
    }
    SetAmmoIndicatorLightColor(mBlink);
    // End:0x52
    if(!mbFiring)
    {
        mbFiring = true;
        mPOVMuzzleFlashComponent.ActivateSystem();
    }
    // End:0x6C
    if(int(Role) == int(ROLE_Authority))
    {
        ScanForHit();
    }
    //return;    
}

simulated function ScanForHitDelayTimer()
{
    mbOkToScanForHit = true;
    //return;    
}

simulated function ScanForHit()
{
    local @NULL HitInfo, StartTrace, EndTrace, HitLocation, HitNormal, HitActor;

    local float Damage;

    // End:0x35
    if(!mbOkToScanForHit)
    {
        // End:0x33
        if(!IsTimerActive('ScanForHitDelayTimer'))
        {
            SetTimer(mDelayBeforeScanningForHit, false, 'ScanForHitDelayTimer');
        }
        return;
    }
    // End:0x42
    if(Instigator == none)
    {
        return;
    }
    StartTrace = mFlameTraceStartPoint;
    EndTrace = mFlameTraceEndPoint;
    HitActor = Instigator.Trace(HitLocation, HitNormal, EndTrace, StartTrace, true,, HitInfo, mDefaultTraceTypeFlags | mDefaultTraceSourceFlags);
    // End:0x1ED
    if(HitActor != none)
    {
        // End:0x172
        if(TurokPawn(HitActor) != none)
        {
            // End:0x103
            if(Instigator.Controller.IsA('PlayerController'))
            {
                // End:0xF3
                if(mbIsMultiPlayer && !mbIsCoOpGame)
                {
                    Damage = MultiplayerHitDamage[0];                    
                }
                else
                {
                    Damage = InstantHitDamage[0];
                }                
            }
            else
            {
                Damage = 10.0000000;
            }
            // End:0x16F
            if(int(HitActor.Role) == int(ROLE_Authority))
            {
                HitActor.TakeDamage(int(Damage), Instigator.Controller, HitLocation, -InstantHitMomentum[0] * HitNormal, Class'TurokDamageTypeFlameThrower', HitInfo);
            }            
        }
        else
        {
            Damage = 10.0000000;
            // End:0x1DE
            if(int(HitActor.Role) == int(ROLE_Authority))
            {
                HitActor.TakeDamage(int(Damage), Instigator.Controller, HitLocation, -InstantHitMomentum[0] * HitNormal, Class'TurokDamageTypeFlameThrower', HitInfo);
            }
        }
        SetFlashLocation(HitLocation);
    }
    //return;    
}

// Export UTurokWeapFirebladeNative::execPlayFireEffects(FFrame&, void* const)
native function PlayFireEffects(byte FireModeNum, optional @NULL HitLocation);

simulated function AdjustProjectileTrajectory(@NULL SpawnedProjectile, @NULL RealStartLoc)
{
    local @NULL AimDir, linkRotation;
    local float rawJoyLR, maxJoyLR, rawJoyUD, maxJoyUD, rawJoyStrafe, yawAdjust,
	    pitchAdjust, strafeAdjust, moveDot;

    local @NULL pInput, tPawn, tpp;

    tPawn = TurokPawn(Instigator);
    // End:0x291
    if((SpawnedProjectile != none) && !SpawnedProjectile.bDeleteMe)
    {
        AimDir = Vector(GetAdjustedAim(RealStartLoc));
        moveDot = Normal(AimDir) Dot Normal(tPawn.Velocity);
        tpp = TurokPawnPlayer(Instigator);
        // End:0xA9
        if(tpp != none)
        {
            pInput = TurokPlayerInput(TurokPlayerController(tpp.Controller).PlayerInput);
        }
        // End:0x228
        if(pInput != none)
        {
            rawJoyLR = pInput.mAnalogInputData.rightThumbStickX;
            rawJoyUD = pInput.mAnalogInputData.rightThumbStickY;
            maxJoyLR = pInput.mMaxATurn;
            maxJoyUD = pInput.mMaxALookUp;
            yawAdjust = (rawJoyLR / maxJoyLR) * mRotationAdjustPct;
            pitchAdjust = (rawJoyUD / maxJoyUD) * mRotationAdjustPct;
            linkRotation.Yaw = mMaxProjYaw;
            linkRotation.Pitch = mMaxProjPitch;
            linkRotation.Yaw *= yawAdjust;
            linkRotation.Pitch *= -pitchAdjust;
            // End:0x203
            if(mbUseStrafe)
            {
                rawJoyStrafe = pInput.mAnalogInputData.leftThumbStickX;
                strafeAdjust = (rawJoyStrafe / maxJoyLR) * mStrafeAdjustPct;
                linkRotation.Yaw += int(strafeAdjust * float(mMaxProjYaw));
            }
            linkRotation = Rotator(AimDir) - linkRotation;
            AimDir = Vector(linkRotation);            
        }
        else
        {
            linkRotation = Rotator(AimDir);
        }
        SpawnedProjectile.SetRotation(linkRotation);
        SpawnedProjectile.Velocity = SpawnedProjectile.Speed * Normal(AimDir);
        SpawnedProjectile.Velocity += (tPawn.Velocity * moveDot);
    }
    //return;    
}

simulated function SpawnFirebladeProjectile()
{
    local @NULL RealStartLoc, AimDir, linkAimDir, prevLoc, projDiff, linkAimRot,
	    AimRot, curRot, clampRot, tPawn, SpawnedProjectile;

    local float pressureDiff;
    local bool bRotatingRight;
    local int clampCheck;
    local float moveDot;
    local @NULL shakeMin, shakeMax, shakeRandVec, viewLoc, ViewRot;

    tPawn = TurokPawn(Instigator);
    // End:0x5AF
    if(mbOkToSpawnProjectile)
    {
        // End:0x2C
        if(!mbUseNewTrajCalc)
        {
            mbOkToSpawnProjectile = false;
        }
        RealStartLoc = GetPhysicalFireStartLoc();
        AimDir = Vector(GetAdjustedAim(RealStartLoc));
        AimDir *= mAimSensitivity;
        AimRot = Rotator(AimDir);
        pressureDiff = 1.0000000;
        SpawnedProjectile = TurokProjFirebladeNative(__NFUN_278__(GetProjectileClass(), self,, RealStartLoc,,, true));
        // End:0x5AF
        if((SpawnedProjectile != none) && !SpawnedProjectile.bDeleteMe)
        {
            mProjectileCount++;
            // End:0xE2
            if(mbUseNewTrajCalc)
            {
                AdjustProjectileTrajectory(SpawnedProjectile, RealStartLoc);                
            }
            else
            {
                // End:0x26E
                if(((mPreviousProjectile != none) && mbLinkProjectiles) && RealStartLoc != mPreviousProjectile.Location)
                {
                    prevLoc = mPreviousProjectile.Location;
                    projDiff = prevLoc - RealStartLoc;
                    linkAimDir = Normal(projDiff * pressureDiff);
                    linkAimRot = Rotator(linkAimDir);
                    bRotatingRight = ClockwiseFrom_IntInt(AimRot.Yaw, linkAimRot.Yaw);
                    // End:0x23F
                    if(mbClampProjectileRotation)
                    {
                        curRot = AimRot;
                        clampCheck = int(Abs((Abs(float(curRot.Yaw)) - Abs(float(linkAimRot.Yaw))) % float(32768)));
                        clampRot.Yaw = mProjectileRotClamp;
                        // End:0x23F
                        if(clampCheck > mProjectileRotClamp)
                        {
                            // End:0x216
                            if(bRotatingRight)
                            {
                                linkAimRot = curRot - clampRot;                                
                            }
                            else
                            {
                                linkAimRot = curRot + clampRot;
                            }
                            // End:0x23F
                            if(mbUseClampedRotForDir)
                            {
                                linkAimDir = Vector(linkAimRot);
                            }
                        }
                    }
                    SpawnedProjectile.SetRotation(linkAimRot);
                    AimDir = Normal(AimDir + (mLinkWeight * linkAimDir));                    
                }
                else
                {
                    SpawnedProjectile.SetRotation(Rotator(AimDir));
                }
                SpawnedProjectile.Velocity = (SpawnedProjectile.Speed * pressureDiff) * AimDir;
                moveDot = Normal(AimDir) Dot Normal(tPawn.Velocity);
                SpawnedProjectile.Velocity += (tPawn.Velocity * moveDot);
                SpawnedProjectile.Velocity *= fireVelocityScalar;
            }
            // End:0x31F
            if(mCurrentPressure < mMinPressure)
            {
                mCurrentPressure = mMinPressure;
            }
            // End:0x34E
            if(!IsTimerActive('recoilTimer'))
            {
                SetTimer(mRecoilInTime / 10.0000000, true, 'recoilTimer');
            }
            mPreviousProjectile = SpawnedProjectile;
            // End:0x3A2
            if(!tPawn.IsFirstPerson())
            {
                SpawnedProjectile.mFlameLight.SetEnabled(false);
                SpawnedProjectile.mPSComponent.DeactivateSystem();
            }
            // End:0x3D9
            if(((float(mProjectileCount) % float(8)) == float(0)) || mProjectileCount == 1)
            {
                RequestEnableWeaponLight(SpawnedProjectile.mFlameLight, true);
            }
            shakeMin = VLerp(mWorstAccuracyMinShake[0], mBestAccuracyMinShake[0], mAccuracyCurrent / 100.0000000);
            shakeMax = VLerp(mWorstAccuracyMaxShake[0], mBestAccuracyMaxShake[0], mAccuracyCurrent / 100.0000000);
            TurokPlayerController(Instigator.Controller).GetPlayerViewPoint(viewLoc, ViewRot);
            // End:0x493
            if(ViewRot.Pitch > mRecoilPitchLimit)
            {
                shakeMin.X = 0.0000000;
                shakeMax.X = 0.0000000;
            }
            shakeRandVec.X = shakeMin.X + (FRand() * (shakeMax.X - shakeMin.X));
            shakeRandVec.Y = shakeMin.Y + (FRand() * (shakeMax.Y - shakeMin.Y));
            shakeRandVec.Z = shakeMin.Z + (FRand() * (shakeMax.Z - shakeMin.Z));
            // End:0x5AF
            if(!TurokPawnHuman(Instigator).mWeaponMediator.IsDualWielding())
            {
                TurokPlayerController(Instigator.Controller).CauseWeaponViewShake(shakeRandVec);
            }
        }
    }
    //return;    
}

simulated function WeaponEmpty()
{
    local int freeAmmo;
    local byte FireMode;

    // End:0x1B
    if(IsFiring())
    {
        GotoState('Active');
    }
    // End:0xD5
    if(int(Role) == int(ROLE_Authority))
    {
        FireMode = GetFiringMode();
        // End:0x5B
        if(int(FireMode) == 0)
        {
            freeAmmo = GetAmmoPoolCount();            
        }
        else
        {
            freeAmmo = GetAltAmmoPoolCount();
        }
        // End:0xD5
        if(freeAmmo > 0)
        {
            // End:0xD5
            if(CanAutoReload())
            {
                GotoState('Reloading');
                ClientStartReload();
                // End:0xD5
                if(TurokAIControllerHumanNpc(Instigator.Controller) != none)
                {
                    TurokAIControllerHumanNpc(Instigator.Controller).NotifyWeaponStartReloading();
                }
            }
        }
    }
    //return;    
}

simulated function pressureTimer()
{
    mCurrentPressure += mPressurizeRate;
    // End:0x36
    if(mCurrentPressure >= mMaxPressure)
    {
        mCurrentPressure = mMaxPressure;
        ClearTimer('pressureTimer');
    }
    //return;    
}

simulated function recoilTimer()
{
    mOldFiringRecoil = mFiringRecoil;
    // End:0x66
    if(mbStartedFireInAnim)
    {
        // End:0x2F
        if(mFiringRecoil < 1.0000000)
        {
            mFiringRecoil += 0.1100000;
        }
        // End:0x63
        if(mFiringRecoil > 1.0000000)
        {
            mFiringRecoil = 1.0000000;
            TurokPawnHuman(Instigator).SetFireBladeAnimMode(2);
        }        
    }
    else
    {
        mFiringRecoil -= 0.1000000;
        // End:0x8C
        if(mFiringRecoil < 0.0000000)
        {
            mFiringRecoil = 0.0000000;
        }
    }
    //return;    
}

// Export UTurokWeapFirebladeNative::execTimeWeaponFiring(FFrame&, void* const)
native function TimeWeaponFiring(byte FireModeNum);

simulated function EndRecoilOutTimer()
{
    PlayPOVAnimation(mAmbientIdleAnim, mAmbientIdleTime, 0.0000000, 0.0000000, false, true);
    //return;    
}

simulated function EndRecoilInTimer()
{
    PlayPOVCannedAnimation(mFireIdleAnim, 1.0000000, 0.0000000, true);
    //return;    
}

simulated function AddSomeAmmo(int freeAmmo)
{
    local byte FiringMode;
    local int amountToLoad;

    FiringMode = GetFiringMode();
    // End:0xCC
    if(int(FiringMode) == 0)
    {
        // End:0xC9
        if((!IsClipFull() && freeAmmo > 0) || TurokInventoryManager(Instigator.InvManager).InfiniteAmmo())
        {
            amountToLoad = Min(mReloadAmount, freeAmmo);
            amountToLoad = Min(mMaxClipAmmo - mCurrentClipAmmo, amountToLoad);
            mCurrentClipAmmo = mCurrentClipAmmo + amountToLoad;
            TurokInventoryManager(Instigator.InvManager).AdjustAmmoPool(mAmmoPoolClass, -amountToLoad);
        }        
    }
    else
    {
        // End:0x178
        if((!IsAltClipFull() && freeAmmo > 0) || TurokInventoryManager(Instigator.InvManager).InfiniteAmmo())
        {
            amountToLoad = Min(mAltReloadAmount, freeAmmo);
            amountToLoad = Min(mMaxClipAltAmmo - mCurrentClipAltAmmo, amountToLoad);
            mCurrentClipAltAmmo = mCurrentClipAltAmmo + amountToLoad;
            TurokInventoryManager(Instigator.InvManager).AdjustAmmoPool(mAltAmmoClass, -amountToLoad);
        }
    }
    //return;    
}

function bool CanAttack(@NULL Other)
{
    local @NULL traceStartLocation;
    local int FiringMode;

    FiringMode = int(GetFiringMode());
    // End:0x72
    if(FiringMode == 0)
    {
        // End:0x6F
        if(HasAmmo(byte(FiringMode)))
        {
            traceStartLocation = Instigator.GetWeaponStartTraceLocation();
            // End:0x6F
            if(mFlameTraceLength >= VSize(Other.Location - traceStartLocation))
            {
                return true;
            }
        }        
    }
    else
    {
        return super.CanAttack(Other);
    }
    return false;
    //return ReturnValue;    
}

simulated function DeactivateWeaponBegin()
{
    // End:0x75
    if(IsTimerActive('detachCanisterTimer'))
    {
        PlayPOVAnimation(mAmbientIdleAnim, mAmbientIdleTime, 0.0000000, 0.0000000, false, true);
        TurokPawnHuman(Instigator).SetFireBladeAnimMode(7);
        TurokWeapAttachFirebladeNative(mAttachment).StopCanisterFillSound();
        ClearTimer('detachCanisterTimer');
    }
    //return;    
}

simulated function StartReloadCycleAnimTimer()
{
    TurokWeapAttachFirebladeNative(mAttachment).StartCanisterFillSound();
    PlayPOVAnimation(mReloadAnim, 1.0000000, 0.0000000, 0.0000000, false, true);
    //return;    
}

simulated state Active
{
    simulated function BeginState(name PreviousStateName)
    {
        local byte FireMode, I;

        FireMode = GetFiringMode();
        // End:0x26
        if(bWeaponPutDown)
        {
            PutDownWeapon();            
        }
        else
        {
            // End:0x82
            if((Instigator.GetStateName() != 'DeployMiniGunSentry') && (!HasAmmo(0) && HasPoolAmmo(0)) && int(FireMode) == 0)
            {
                WeaponEmpty();                
            }
            else
            {
                I = 0;
                J0x8A:

                // End:0xE6 [Loop If]
                if(int(I) < InvManager.PendingFire.Length)
                {
                    // End:0xDC
                    if(PendingFire(int(I)))
                    {
                        ClearPendingFire(int(I));
                        BeginFire(I);
                        // [Explicit Break]
                        goto J0xE6;
                    }
                    I++;
                    // [Loop Continue]
                    goto J0x8A;
                }
            }
        }
        J0xE6:

        mCurrentPressure = mMaxPressure;
        mAttachment.PlayAmbience();
        // End:0x132
        if(PreviousStateName == 'ThrowGrenadeState')
        {
            PlayPOVCannedAnimation(mAmbientIdleAnim, mAmbientIdleTime, 0.0000000, true);
        }
        // End:0x15A
        if(!IsTimerActive('FlameTraceCalcTimer'))
        {
            SetTimer(0.1000000, true, 'FlameTraceCalcTimer');
        }
        //return;        
    }

    simulated function BeginFire(byte FireModeNum)
    {
        SetCurrentFireMode(FireModeNum);
        super.BeginFire(FireModeNum);
        //return;        
    }

    simulated function BeginReload()
    {
        local byte FireMode;

        FireMode = GetFiringMode();
        // End:0x8D
        if(int(FireMode) == 0)
        {
            // End:0x4F
            if((HasPoolAmmo(0)) && !IsClipFull())
            {
                GotoState('Reloading');                
            }
            else
            {
                // End:0x8A
                if((HasPoolAmmo(1)) && !IsAltClipFull())
                {
                    SetCurrentFireMode(1);
                    GotoState('Reloading');
                }
            }            
        }
        else
        {
            // End:0xBF
            if((HasPoolAmmo(1)) && !IsAltClipFull())
            {
                GotoState('Reloading');                
            }
            else
            {
                // End:0xFA
                if((HasPoolAmmo(0)) && !IsClipFull())
                {
                    SetCurrentFireMode(0);
                    GotoState('Reloading');
                }
            }
        }
        //return;        
    }

    function bool CanReload()
    {
        local byte FireMode;

        FireMode = GetFiringMode();
        // End:0x53
        if(int(FireMode) == 0)
        {
            return (!IsFiring() && !IsClipFull()) && HasPoolAmmo(FireMode);            
        }
        else
        {
            return (!IsFiring() && !IsAltClipFull()) && HasPoolAmmo(FireMode);
        }
        //return ReturnValue;        
    }
    stop;    
}

auto state Inactive
{
    simulated function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        bStasis = true;
        ClearTimer('FlameTraceCalcTimer');
        ClearTimer('recoilTimer');
        ClearTimer('ScanForHitDelayTimer');
        ClearTimer('EndRecoilOutTimer');
        ClearTimer('EndRecoilInTimer');
        mbOkToScanForHit = false;
        mFiringRecoil = 0.0000000;
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        bStasis = false;
        super.EndState(NextStateName);
        //return;        
    }
    stop;    
}

state Deactivated
{
    simulated function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        ClearTimer('FlameTraceCalcTimer');
        ClearTimer('recoilTimer');
        ClearTimer('ScanForHitDelayTimer');
        ClearTimer('EndRecoilOutTimer');
        ClearTimer('EndRecoilInTimer');
        mFiringRecoil = 0.0000000;
        mbLinkProjectiles = false;
        mPreviousProjectile = none;
        mProjectileCount = 0;
        mbStartedFireInAnim = false;
        mbOkToScanForHit = false;
        mPressureGaugeInc = -0.0700000;
        //return;        
    }
    stop;    
}

simulated state WeaponFiring
{
    simulated function FireProjFlameFlare()
    {
        local @NULL RealStartLoc;

        // End:0x9D
        if(int(Role) == int(ROLE_Authority))
        {
            RealStartLoc = GetPhysicalFireStartLoc();
            // End:0x9D
            if((mFlameFlare == none) || mFlameFlare.bDeleteMe)
            {
                mFlameFlare = __NFUN_278__(Class'TurokProjFlameFlare', self,, RealStartLoc);
                // End:0x9D
                if((mFlameFlare != none) && !mFlameFlare.bDeleteMe)
                {
                    mFlameFlare.Init(Vector(GetAdjustedAim(RealStartLoc)));
                }
            }
        }
        //return;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        local byte FireModeNum;

        FireModeNum = GetFiringMode();
        FireAmmunition();
        TimeWeaponFiring(GetFiringMode());
        // End:0xD3
        if(int(FireModeNum) == 0)
        {
            // End:0xD0
            if(!mbStartedFireInAnim)
            {
                PlayPOVAnimation(mFireInAnim, mRecoilInTime, mRecoilInTime * 0.0500000, mRecoilInTime * 0.0500000, true, false);
                SetTimer(mRecoilInTime - 0.1000000, false, 'EndRecoilInTimer');
                mbStartedFireInAnim = true;
                TogglePilotLight(false);
                DisableWeaponLight(mPilotFlameLight);
                TurokPawnHuman(Instigator).SetFireBladeAnimMode(1);
                FireProjFlameFlare();
            }            
        }
        else
        {
            PlayPOVAnimation(mFireAnims[int(FireModeNum)], mFireAnimTimes[int(FireModeNum)], mFireAnimTimes[int(FireModeNum)] * 0.1000000, mFireAnimTimes[int(FireModeNum)] * 0.1000000, true, false);
        }
        //return;        
    }

    simulated function RefireCheckTimer()
    {
        local int currFireMode;

        currFireMode = int(GetFiringMode());
        mbLinkProjectiles = ShouldRefire();
        // End:0x51
        if((currFireMode == 1) && HasPoolAmmo(1))
        {
            GotoState('Reloading');            
        }
        else
        {
            // End:0x70
            if(mSemiAutoFire[currFireMode])
            {
                GotoState('Active');                
            }
            else
            {
                super.RefireCheckTimer();
            }
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        ClearFlashCount();
        ClearFlashLocation();
        ClearTimer('RefireCheckTimer');
        ClearTimer('ScanForHitDelayTimer');
        mbLinkProjectiles = false;
        mPreviousProjectile = none;
        mProjectileCount = 0;
        mbStartedFireInAnim = false;
        mbOkToScanForHit = false;
        mPressureGaugeInc = -0.0700000;
        mbFiring = false;
        mPOVMuzzleFlashComponent.DeactivateSystem();
        PlayPOVAnimation(mFireOutAnim, mRecoilOutTime, 0.0000000, 0.0000000, true, false);
        SetTimer(mRecoilOutTime - 0.1000000, false, 'EndRecoilOutTimer');
        TogglePilotLight(true);
        RequestEnableWeaponLight(mPilotFlameLight, true);
        TurokPawnHuman(Instigator).SetFireBladeAnimMode(3);
        // End:0x12C
        if(AIController(Instigator.Controller) != none)
        {
            AIController(Instigator.Controller).NotifyWeaponFinishedFiring(self, GetFiringMode());
        }
        //return;        
    }
    stop;    
}

simulated state Reloading
{
    simulated function BeginState(name PreviousStateName)
    {
        local byte FireMode;
        local float reloadStartTime;

        HideReticle();
        // End:0x48
        if((Instigator == none) || (Instigator != none) && Instigator.GetStateName() != 'DeployMiniGunSentry')
        {
            ShowFuelCellMesh();
        }
        FireMode = GetFiringMode();
        // End:0x73
        if(int(FireMode) == 0)
        {
            reloadStartTime = mReloadAttachCanisterTime;            
        }
        else
        {
            // End:0x8E
            if(int(FireMode) == 1)
            {
                reloadStartTime = mAltReloadStartTime;                
            }
            else
            {
                reloadStartTime = 0.0000000;
            }
        }
        // End:0x165
        if(reloadStartTime > float(0))
        {
            TurokPawnHuman(Instigator).WeaponReloading(1, mEquippedInHand);
            // End:0x129
            if(int(FireMode) == 0)
            {
                PlayPOVAnimation(mReloadAttachCanister, reloadStartTime, 0.0000000, 0.0000000, true, false);
                SetTimer(reloadStartTime - 0.1000000, false, 'StartReloadCycleAnimTimer');
                TurokPawnHuman(Instigator).SetFireBladeAnimMode(4);                
            }
            else
            {
                PlayPOVAnimation(mAltReloadAnim, reloadStartTime, reloadStartTime * 0.1000000, reloadStartTime * 0.1000000, true, false);
            }
            SetTimer(reloadStartTime, false);            
        }
        else
        {
            SetTimer(0.0100000, false);
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        ShowReticle();
        TurokWeapAttachFirebladeNative(mAttachment).StopCanisterFillSound();
        TurokPawnHuman(Instigator).WeaponReloading(0, mEquippedInHand);
        SetAmmoIndicatorLightColor(mBlink);
        ClearTimer('detachCanisterTimer');
        ClearTimer('StartReloadCycleAnimTimer');
        HideFuelCellMesh();
        // End:0x122
        if(NextStateName == 'WeaponPuttingDown')
        {
            ClearTimer('FlameTraceCalcTimer');
            ClearTimer('recoilTimer');
            ClearTimer('ScanForHitDelayTimer');
            ClearTimer('EndRecoilOutTimer');
            ClearTimer('EndRecoilInTimer');
            ClearTimer();
            mFiringRecoil = 0.0000000;
            mbLinkProjectiles = false;
            mPreviousProjectile = none;
            mProjectileCount = 0;
            mbStartedFireInAnim = false;
            mbOkToScanForHit = false;
            mPressureGaugeInc = -0.0700000;
        }
        //return;        
    }

    simulated function BeginFire(byte FireModeNum)
    {
        // End:0x18
        if(int(FireModeNum) == 0)
        {
            SetPendingFire(0);
        }
        //return;        
    }

    simulated function Timer()
    {
        local int freeAmmo;
        local byte FireMode;

        FireMode = GetFiringMode();
        // End:0x30
        if(int(FireMode) == 0)
        {
            freeAmmo = GetAmmoPoolCount();            
        }
        else
        {
            freeAmmo = GetAltAmmoPoolCount();
        }
        // End:0xC6
        if(bWeaponPutDown)
        {
            // End:0xA6
            if(int(FireMode) == 0)
            {
                SetTimer(mReloadDetachCanisterTime, false, 'detachCanisterTimer');
                PlayPOVAnimation(mReloadDetachCanister, mReloadDetachCanisterTime, 0.0000000, 0.0000000, true, false);
                TurokPawnHuman(Instigator).SetFireBladeAnimMode(6);                
            }
            else
            {
                GotoState('WeaponPuttingDown');
            }
            AddSomeAmmo(freeAmmo);            
        }
        else
        {
            AddSomeAmmo(freeAmmo);
            // End:0x1AD
            if(int(FireMode) == 0)
            {
                // End:0x16A
                if((IsClipFull()) || freeAmmo == 0)
                {
                    // End:0x159
                    if(mReloadDetachCanisterTime > float(0))
                    {
                        SetTimer(mReloadDetachCanisterTime, false, 'detachCanisterTimer');
                        PlayPOVAnimation(mReloadDetachCanister, mReloadDetachCanisterTime, 0.0000000, 0.0000000, true, false);
                        TurokPawnHuman(Instigator).SetFireBladeAnimMode(6);                        
                    }
                    else
                    {
                        GotoState('Active');
                    }                    
                }
                else
                {
                    // End:0x19F
                    if(mFillUpTime > float(0))
                    {
                        SetTimer(mFillUpTime, false);
                        TurokPawnHuman(Instigator).SetFireBladeAnimMode(5);                        
                    }
                    else
                    {
                        SetTimer(0.0100000, false);
                    }
                }                
            }
            else
            {
                GotoState('Active');
            }
        }
        //return;        
    }

    simulated function detachCanisterTimer()
    {
        PlayPOVAnimation(mAmbientIdleAnim, mAmbientIdleTime, 0.0000000, 0.0000000, false, true);
        TurokPawnHuman(Instigator).SetFireBladeAnimMode(7);
        TurokWeapAttachFirebladeNative(mAttachment).StopCanisterFillSound();
        // End:0x6C
        if(bWeaponPutDown)
        {
            GotoState('WeaponPuttingDown');            
        }
        else
        {
            GotoState('Active');
        }
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: TurokZoomComponent'Default__TurokWeapFirebladeNative.Zoom'
    begin object name=Zoom
    end object
    mZoomValues=Zoom
}