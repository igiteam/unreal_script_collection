class TurokWeapSniperRifleNative extends TurokWeapon
    native
    config(WeapSniperRifle)
    hidecategories(Navigation);

var(SniperRifle) float mFireScopeDelay;
var(SniperRifle) config int mReturnToZoomLevelTimeout;
var(SniperRifle) @NULL mZoomedPovOffset;
var(SniperRifle) float mScopeToEyeTime;
var float mCurScopeTime;
var bool mRestoreZoom;
var bool mZoomIn;
var bool mbInScope;
var bool mbBlinkTopLight;
var bool mbScopeMeshVisible;
var @NULL mZoomInSndCue;
var @NULL mDisableZoomSndCue;
var @NULL mEnableZoomSndCue;
var @NULL mPlaybackMI;
var int mBlinkCount;
var int mLightToBlink;
var array mScopeCrosshairAnimNames;
var array mScopeCrosshairAnimSet;
var(ScopeMesh) export editinline @NULL mScopeMesh;
var(ScopeMesh) config array mZoomScopePosOffsets;
var(ScopeMesh) config array mScale3dOffsets;
var(ScopeMesh) config float mInScopePovArmsOffset;
var name mScopeBoneName;
var @NULL mScopeXHairPlaybackMI;
var @NULL mScopeZoomNumberPlaybackMI;
var @NULL mScopeFriendlyPlaybackMI;
var private byte mPrevZoomLevel;
var config float mLookSpeedZoomLevel1;
var config float mLookSpeedZoomLevel2;
var config float mLookSpeedZoomLevel3;

simulated event Tick(float DeltaTime)
{
    local @NULL TPC, newColor, newLinearColor;
    local int R, G, B;
    local bool bIsFriendly;

    super(Actor).Tick(DeltaTime);
    // End:0x1A9
    if(mbInScope && mScopeXHairPlaybackMI != none)
    {
        TPC = TurokPlayerController(Instigator.Controller);
        bIsFriendly = false;
        // End:0xFF
        if(TPC != none)
        {
            // End:0xE0
            if(TPC.mAimReticleTarget != none)
            {
                // End:0xBE
                if((TPC.mAimReticleTarget.Health <= 0) || Instigator.CanHurt(TPC.mAimReticleTarget))
                {
                    R = 255;
                    G = 0;
                    B = 0;                    
                }
                else
                {
                    R = 0;
                    G = 192;
                    B = 206;
                    bIsFriendly = true;
                }                
            }
            else
            {
                R = 0;
                G = 192;
                B = 206;
                bIsFriendly = false;
            }
        }
        newColor = MakeColor(byte(R), byte(G), byte(B));
        newLinearColor = ColorToLinearColor(newColor);
        mScopeXHairPlaybackMI.SetVectorParameterValue('VBarHue', newLinearColor);
        // End:0x177
        if(mScopeZoomNumberPlaybackMI != none)
        {
            mScopeZoomNumberPlaybackMI.SetVectorParameterValue('VHue', newLinearColor);
        }
        // End:0x1A9
        if(mScopeFriendlyPlaybackMI != none)
        {
            mScopeFriendlyPlaybackMI.SetScalarParameterValue('SFriendly', float(((bIsFriendly) ? 1 : 0)));
        }
    }
    //return;    
}

simulated function ShowScopeMesh()
{
    mScopeMesh.SetHidden(false);
    mScopeMesh.SetLightEnvironment(mWeaponMesh.LightEnvironment);
    AttachMeshComponentToPOVArms(mScopeMesh, mScopeBoneName);
    mbScopeMeshVisible = true;
    //return;    
}

simulated function HideScopeMesh()
{
    mScopeMesh.SetHidden(true);
    mScopeMesh.SetLightEnvironment(none);
    DetachMeshComponentFromPOVArms(mScopeMesh);
    mbScopeMeshVisible = false;
    //return;    
}

simulated function AttachWeapon()
{
    super.AttachWeapon();
    // End:0x1A0
    if((Instigator != none) && Instigator.IsLocallyControlled())
    {
        // End:0x92
        if(mWeaponMesh != none)
        {
            mPlaybackMI = new (none) Class'Engine.MaterialInstanceConstant';
            mPlaybackMI.SetParent(mWeaponMesh.GetMaterial(1));
            mWeaponMesh.SetMaterial(1, mPlaybackMI);
            SetMaterialDepth(mPlaybackMI, -0.5000000);
        }
        SetAmmoIndicatorLights();
        ProcessBlink();
        HideScopeMesh();
        mScopeXHairPlaybackMI = new (none) Class'Engine.MaterialInstanceConstant';
        mScopeXHairPlaybackMI.SetParent(mScopeMesh.GetMaterial(2));
        mScopeMesh.SetMaterial(2, mScopeXHairPlaybackMI);
        mScopeZoomNumberPlaybackMI = new (none) Class'Engine.MaterialInstanceConstant';
        mScopeZoomNumberPlaybackMI.SetParent(mScopeMesh.GetMaterial(5));
        mScopeMesh.SetMaterial(5, mScopeZoomNumberPlaybackMI);
        mScopeFriendlyPlaybackMI = new (none) Class'Engine.MaterialInstanceConstant';
        mScopeFriendlyPlaybackMI.SetParent(mScopeMesh.GetMaterial(3));
        mScopeMesh.SetMaterial(3, mScopeFriendlyPlaybackMI);
    }
    //return;    
}

simulated function DetachWeapon()
{
    mPlaybackMI = none;
    mScopeXHairPlaybackMI = none;
    mScopeZoomNumberPlaybackMI = none;
    mScopeFriendlyPlaybackMI = none;
    super.DetachWeapon();
    HideScopeMesh();
    //return;    
}

simulated event AdjustScopeCrosshairPlayback(byte zoomLevel)
{
    local @NULL newLinearColor;

    // End:0x188
    if(mScopeZoomNumberPlaybackMI != none)
    {
        newLinearColor.R = 0.0000000;
        newLinearColor.B = 0.0000000;
        // End:0x5B
        if(int(zoomLevel) == 3)
        {
            newLinearColor.G = 2.0000000;            
        }
        else
        {
            // End:0x81
            if(int(zoomLevel) == 2)
            {
                newLinearColor.G = 1.0000000;                
            }
            else
            {
                newLinearColor.G = 0.0000000;
            }
        }
        mScopeZoomNumberPlaybackMI.SetVectorParameterValue('VZoom', newLinearColor);
        // End:0x188
        if((int(mPrevZoomLevel) != int(zoomLevel)) && mbScopeMeshVisible == true)
        {
            // End:0x11A
            if((int(zoomLevel) == 2) && int(mPrevZoomLevel) <= 1)
            {
                PlayCannedAnimOnMeshComponent(mScopeMesh, mScopeCrosshairAnimNames[0], 0.3000000, 0.0000000, false, mScopeCrosshairAnimSet);                
            }
            else
            {
                // End:0x161
                if((int(zoomLevel) == 3) && int(mPrevZoomLevel) == 2)
                {
                    PlayCannedAnimOnMeshComponent(mScopeMesh, mScopeCrosshairAnimNames[1], 0.3000000, 0.0000000, false, mScopeCrosshairAnimSet);                    
                }
                else
                {
                    PlayCannedAnimOnMeshComponent(mScopeMesh, mScopeCrosshairAnimNames[2], 0.3000000, 0.0000000, false, mScopeCrosshairAnimSet);
                }
            }
        }
    }
    mPrevZoomLevel = zoomLevel;
    //return;    
}

simulated event SetAmmoIndicatorLights()
{
    local @NULL newColor, newLinearColor, ammoCount;
    local int R, G, B;

    // End:0x14D
    if(mPlaybackMI != none)
    {
        mbBlinkTopLight = false;
        mBlinkCount = 0;
        // End:0x14D
        if(mPlaybackMI != none)
        {
            // End:0x49
            if(mCurrentClipAmmo == 1)
            {
                R = 236;
                G = 0;
                B = 0;                
            }
            else
            {
                // End:0x6F
                if(mCurrentClipAmmo == 2)
                {
                    R = 255;
                    G = 115;
                    B = 1;                    
                }
                else
                {
                    R = 87;
                    G = 212;
                    B = 212;
                }
            }
            newColor = MakeColor(byte(R), byte(G), byte(B));
            newLinearColor = ColorToLinearColor(newColor);
            mPlaybackMI.SetVectorParameterValue('VLightHue01', newLinearColor);
            ammoCount.R = 0.0000000;
            ammoCount.G = float(mCurrentClipAmmo + 1);
            ammoCount.B = 0.0000000;
            ammoCount.A = 0.0000000;
            mPlaybackMI.SetVectorParameterValue('VAmmoCounter', ammoCount);
        }
    }
    //return;    
}

simulated event ProcessBlink()
{
    local @NULL newColor, newLinearColor, ammoCount;
    local int R, G, B;

    // End:0x101
    if(!mbBlinkTopLight)
    {
        mbBlinkTopLight = true;
        mLightToBlink = mCurrentClipAmmo;
        R = 0;
        G = 0;
        B = 0;
        newColor = MakeColor(byte(R), byte(G), byte(B));
        newLinearColor = ColorToLinearColor(newColor);
        // End:0x101
        if(mPlaybackMI != none)
        {
            ammoCount.R = 0.0000000;
            ammoCount.G = float(mLightToBlink);
            ammoCount.B = 0.0000000;
            ammoCount.A = 0.0000000;
            mPlaybackMI.SetVectorParameterValue('VAmmoCounter', ammoCount);
            mPlaybackMI.SetVectorParameterValue('VLightHue00', newLinearColor);
        }
    }
    // End:0x123
    if(mBlinkCount < 12)
    {
        SetTimer(0.1000000, false, 'BlinkTimer');        
    }
    else
    {
        SetAmmoIndicatorLights();
        mBlinkCount = 0;
        mbBlinkTopLight = false;
    }
    //return;    
}

simulated function BlinkTimer()
{
    local @NULL newColor, newLinearColor;
    local int R, G, B;

    mBlinkCount++;
    // End:0x92
    if((float(mBlinkCount) % float(2)) == float(1))
    {
        R = 210;
        G = 210;
        B = 210;
        newColor = MakeColor(byte(R), byte(G), byte(B));
        newLinearColor = ColorToLinearColor(newColor);
        // End:0x8F
        if(mPlaybackMI != none)
        {
            mPlaybackMI.SetVectorParameterValue('VLightHue00', newLinearColor);
        }        
    }
    else
    {
        R = 0;
        G = 0;
        B = 0;
        newColor = MakeColor(byte(R), byte(G), byte(B));
        newLinearColor = ColorToLinearColor(newColor);
        // End:0x102
        if(mPlaybackMI != none)
        {
            mPlaybackMI.SetVectorParameterValue('VLightHue00', newLinearColor);
        }
    }
    ProcessBlink();
    //return;    
}

simulated function AdjustPOVArmsVertTranslation(float vertAdjustment)
{
    local @NULL tpPlayer, armTrans, armsMesh;

    armTrans = vect(0.0000000, 0.0000000, 0.0000000);
    tpPlayer = TurokPawnPlayer(Instigator);
    // End:0x8E
    if((tpPlayer != none) && tpPlayer.mPovArms != none)
    {
        armsMesh = tpPlayer.mPovArms.mPovArmsMesh;
        armTrans.Z = vertAdjustment;
        armsMesh.SetTranslation(armTrans);
    }
    //return;    
}

simulated event AdjustLookSpeedMod(out float rotationModPct)
{
    local byte zoomLevel;

    // End:0x78
    if(mbInScope)
    {
        zoomLevel = byte(TurokPlayerController(Instigator.Controller).mZoomer.mCurToggle);
        // End:0x51
        if(int(zoomLevel) == 1)
        {
            rotationModPct = mLookSpeedZoomLevel1;            
        }
        else
        {
            // End:0x6D
            if(int(zoomLevel) == 2)
            {
                rotationModPct = mLookSpeedZoomLevel2;                
            }
            else
            {
                rotationModPct = mLookSpeedZoomLevel3;
            }
        }
    }
    //return;    
}

simulated event AdjustAimAssistStickHoriz(out float aimAssistSlowDownPct, bool bPS3)
{
    local float adjustedPct;
    local byte zoomLevel;

    // End:0xD0
    if((bPS3 && mbInScope) && mbIsMultiPlayer)
    {
        zoomLevel = byte(TurokPlayerController(Instigator.Controller).mZoomer.mCurToggle);
        adjustedPct = aimAssistSlowDownPct;
        // End:0x74
        if(int(zoomLevel) == 2)
        {
            adjustedPct *= 1.1500000;            
        }
        else
        {
            // End:0x91
            if(int(zoomLevel) == 2)
            {
                adjustedPct *= 1.2000000;                
            }
            else
            {
                // End:0xAB
                if(int(zoomLevel) > 2)
                {
                    adjustedPct *= 1.3000000;
                }
            }
        }
        // End:0xC5
        if(adjustedPct > 1.0000000)
        {
            adjustedPct = 1.0000000;
        }
        aimAssistSlowDownPct = adjustedPct;
    }
    //return;    
}

simulated function DeactivateWeaponBegin()
{
    // End:0x2D
    if(IsTimerActive('RestoreZoomLevelTimer'))
    {
        RestoreZoomLevelTimer();
        ClearTimer('RestoreZoomLevelTimer');
    }
    // End:0x65
    if(IsTimerActive('OutOfScopeTimer'))
    {
        // End:0x55
        if(!mRestoreZoom)
        {
            SnapOutOfZoom();
        }
        ClearTimer('OutOfScopeTimer');
    }
    //return;    
}

simulated function NotifyZoomPressed()
{
    // End:0x14
    if(!HasAmmo(0))
    {
        return;
    }
    super.NotifyZoomPressed();
    // End:0x7F
    if(TurokPlayerController(Instigator.Controller) != none)
    {
        // End:0x7F
        if(TurokPlayerController(Instigator.Controller).UsingFirstPersonCamera() || int(Role) == int(ROLE_Authority))
        {
            mZoomIn = true;
            GotoState('Zooming');
        }
    }
    //return;    
}

simulated function NotifyZoomReleased()
{
    super.NotifyZoomReleased();
    GotoState('Zooming');
    ClearTimer('RestoreZoomLevelTimer');
    SetTimer(float(mReturnToZoomLevelTimeout), false, 'RestoreZoomLevelTimer');
    //return;    
}

simulated function RestoreZoomLevelTimer()
{
    mPrevZoomLevel = 0;
    //return;    
}

simulated function ReleaseZoom()
{
    super.ReleaseZoom();
    mRestoreZoom = false;
    mZoomIn = false;
    // End:0x84
    if(TurokPlayerController(Instigator.Controller) != none)
    {
        TurokPlayerController(Instigator.Controller).mZoomer.EnableToggleZoom(false);
        TurokPlayerController(Instigator.Controller).mZoomer.ResetZoomLevel();
    }
    //return;    
}

simulated function EnableScope(bool bEnable)
{
    mbInScope = bEnable;
    mWeaponMesh.SetOwnerNoSee(bEnable);
    // End:0x3D
    if(bEnable)
    {
        AdjustPOVArmsVertTranslation(mInScopePovArmsOffset);        
    }
    else
    {
        AdjustPOVArmsVertTranslation(0.0000000);
    }
    //return;    
}

// Export UTurokWeapSniperRifleNative::execCalcWeaponVerticalLookOffset(FFrame&, void* const)
native function CalcWeaponVerticalLookOffset(out @NULL drawOffset, @NULL newRotator, @NULL Z);

simulated event CalcWeaponSwayOffset(out @NULL drawOffset, @NULL Y, @NULL Z)
{
    // End:0x20
    if(!mbInScope)
    {
        super.CalcWeaponSwayOffset(drawOffset, Y, Z);
    }
    //return;    
}

// Export UTurokWeapSniperRifleNative::execCalcMovementLag(FFrame&, void* const)
native function CalcMovementLag(@NULL Holder, out @NULL NewRotation, out @NULL movementOffset);

// Export UTurokWeapSniperRifleNative::execCalcWeaponClimbRotation(FFrame&, void* const)
native simulated function CalcWeaponClimbRotation();

// Export UTurokWeapSniperRifleNative::execGetAccuracy(FFrame&, void* const)
native simulated function float GetAccuracy();

simulated function SnapOutOfZoom()
{
    local @NULL InstigatorController;

    // End:0x68
    if(Instigator != none)
    {
        InstigatorController = TurokPlayerController(Instigator.Controller);
        // End:0x68
        if(InstigatorController != none)
        {
            InstigatorController.mZoomer.EnableToggleZoom(false);
            InstigatorController.mZoomer.ResetZoomLevel();
        }
    }
    mCurScopeTime = 0.0000000;
    EnableScope(false);
    HideScopeMesh();
    ClearTimer('RestoreZoomLevelTimer');
    SetTimer(float(mReturnToZoomLevelTimeout), false, 'RestoreZoomLevelTimer');
    //return;    
}

// Export UTurokWeapSniperRifleNative::execFireAmmunition(FFrame&, void* const)
native function FireAmmunition();

simulated function DoGrenadeTossPOV()
{
    // End:0x66
    if(Instigator.IsFirstPerson())
    {
        mRestoreZoom = mRestoreZoom || mbInScope;
        SnapOutOfZoom();
        PlayPOVAnimation(mGrenadeAnim, mGrenadeAnimTime, mGrenadeAnimTime * 0.1000000, mGrenadeAnimTime * 0.1000000, true, false);
    }
    //return;    
}

// Export UTurokWeapSniperRifleNative::execHasAmmo(FFrame&, void* const)
native function bool HasAmmo(byte FireModeNum, optional int Amount);

simulated state Zooming
{
    simulated function BeginState(name PreviousStateName)
    {
        EnableScope(false);
        // End:0xBE
        if(TurokPlayerController(Instigator.Controller) != none)
        {
            TurokPlayerController(Instigator.Controller).mZoomer.ResetZoomLevel();
            // End:0xBE
            if(Instigator.IsLocallyControlled())
            {
                // End:0x95
                if(mZoomIn)
                {
                    TurokPawnHuman(Instigator).mSoundController.TryPlayLocalSound(mEnableZoomSndCue);                    
                }
                else
                {
                    TurokPawnHuman(Instigator).mSoundController.TryPlayLocalSound(mDisableZoomSndCue);
                }
            }
        }
        super(Object).BeginState(PreviousStateName);
        //return;        
    }

    simulated function EndState(name PreviousStateName)
    {
        mZoomIn = false;
        super(Object).EndState(PreviousStateName);
        //return;        
    }

    simulated event ModifyPOVOffset(out @NULL PovOffset)
    {
        local @NULL NewRotation, X, Y, Z, CamLocation, Offset,
	        pController;

        // End:0xA2
        if(TurokPawnPlayer(Instigator) != none)
        {
            pController = PlayerController(Instigator.Controller);
            // End:0xA2
            if(pController != none)
            {
                pController.GetPlayerViewPoint(CamLocation, NewRotation);
                GetAxes(NewRotation, X, Y, Z);
                CalcWeaponVerticalLookOffset(Offset, NewRotation, Z);
                Offset = QuatRotateVector(QuatInvert(QuatFromRotator(NewRotation)), Offset);
            }
        }
        PovOffset = VLerp(PovOffset, mZoomedPovOffset - Offset, mCurScopeTime / mScopeToEyeTime);
        //return;        
    }

    simulated event Tick(float DeltaTime)
    {
        local @NULL scopeTrans, scopeScale;
        local byte toggle, I;

        // End:0x18
        if(mZoomIn)
        {
            mCurScopeTime += DeltaTime;            
        }
        else
        {
            mCurScopeTime -= DeltaTime;
        }
        EnableScope(false);
        // End:0x1F7
        if(mCurScopeTime >= mScopeToEyeTime)
        {
            mCurScopeTime = mScopeToEyeTime;
            // End:0x5E
            if(!mbScopeMeshVisible)
            {
                ShowScopeMesh();
            }
            mRestoreZoom = false;
            EnableScope(true);
            GotoState('Active');
            // End:0x1F4
            if(TurokPlayerController(Instigator.Controller) != none)
            {
                TurokPlayerController(Instigator.Controller).mZoomer.EnableToggleZoom(true);
                // End:0xFD
                if(int(mPrevZoomLevel) == 0)
                {
                    TurokPlayerController(Instigator.Controller).mZoomer.ToggleZoom();                    
                }
                else
                {
                    I = 0;
                    J0x105:

                    // End:0x14C [Loop If]
                    if(int(I) < int(mPrevZoomLevel))
                    {
                        TurokPlayerController(Instigator.Controller).mZoomer.ToggleZoom();
                        ++I;
                        // [Loop Continue]
                        goto J0x105;
                    }
                }
                toggle = byte(TurokPlayerController(Instigator.Controller).mZoomer.mCurToggle);
                scopeTrans = mZoomScopePosOffsets[int(toggle)];
                scopeTrans.Z -= mInScopePovArmsOffset;
                mScopeMesh.SetTranslation(scopeTrans);
                scopeScale = mScale3dOffsets[int(toggle)];
                mScopeMesh.SetScale3D(scopeScale);
                AdjustScopeCrosshairPlayback(toggle);
            }            
        }
        else
        {
            // End:0x21D
            if(mCurScopeTime < float(0))
            {
                GotoState('Active');
                mCurScopeTime = 0.0000000;
            }
        }
        // End:0x241
        if(mbScopeMeshVisible && mCurScopeTime < mScopeToEyeTime)
        {
            HideScopeMesh();
        }
        //return;        
    }

    simulated function ReleaseZoom()
    {
        TurokPawnHuman(Instigator).mSoundController.TryPlayLocalSound(mDisableZoomSndCue);
        super(TurokWeapSniperRifleNative).ReleaseZoom();
        HideScopeMesh();
        //return;        
    }

    simulated function NotifyZoomPressed()
    {
        mZoomIn = true;
        //return;        
    }
    stop;    
}

simulated state WeaponFiring
{
    simulated function BeginState(name PreviousStateName)
    {
        mRestoreZoom = mRestoreZoom || mbInScope;
        // End:0x50
        if(int(GetFiringMode()) == 0)
        {
            SetTimer(0.0750000,, 'LightOffTimer');
            SetTimer(mFireScopeDelay,, 'OutOfScopeTimer');
        }
        super.BeginState(PreviousStateName);
        //return;        
    }

    simulated function RefireCheckTimer()
    {
        // End:0x25
        if(int(GetFiringMode()) == 0)
        {
            SetTimer(0.0750000,, 'LightOffTimer');
        }
        super.RefireCheckTimer();
        //return;        
    }

    simulated function LightOffTimer()
    {
        mAttachment.StopSingleFireEffect(0, 0, mPovFireEffectPSC);
        mAttachment.StopSingleFireEffect3P(0, 0);
        //return;        
    }

    simulated function OutOfScopeTimer()
    {
        // End:0x15
        if(!mRestoreZoom)
        {
            SnapOutOfZoom();
        }
        //return;        
    }

    simulated function NotifyZoomPressed()
    {
        mRestoreZoom = true;
        //return;        
    }

    simulated function NotifyZoomReleased()
    {
        mRestoreZoom = false;
        SnapOutOfZoom();
        //return;        
    }
    stop;    
}

simulated state Reloading
{
    simulated function BeginState(name PreviousStateName)
    {
        mRestoreZoom = mRestoreZoom || mbInScope;
        SnapOutOfZoom();
        super.BeginState(PreviousStateName);
        //return;        
    }

    simulated function NotifyZoomPressed()
    {
        mRestoreZoom = true;
        //return;        
    }

    simulated function NotifyZoomReleased()
    {
        mRestoreZoom = false;
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        SetAmmoIndicatorLights();
        super.EndState(NextStateName);
        //return;        
    }

    simulated function LightOffTimer()
    {
        mAttachment.StopSingleFireEffect(0, 0, mPovFireEffectPSC);
        mAttachment.StopSingleFireEffect3P(0, 0);
        //return;        
    }
    stop;    
}

simulated state Active
{
    simulated function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        // End:0x2B
        if(mRestoreZoom && !mbInScope)
        {
            NotifyZoomPressed();
        }
        // End:0x6F
        if(TurokPlayerController(Instigator.Controller) != none)
        {
            TurokPlayerController(Instigator.Controller).mZoomer.EnableSlideZoom(false);
        }
        //return;        
    }

    simulated function LightOffTimer()
    {
        mAttachment.StopSingleFireEffect(0, 0, mPovFireEffectPSC);
        mAttachment.StopSingleFireEffect3P(0, 0);
        //return;        
    }
    stop;    
}

simulated state WeaponPuttingDown
{
    simulated function BeginState(name PreviousStateName)
    {
        mbInScope = false;
        mZoomIn = false;
        SnapOutOfZoom();
        super.BeginState(PreviousStateName);
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        mbBlinkTopLight = false;
        mBlinkCount = 0;
        // End:0x53
        if(TurokPlayerController(Instigator.Controller) != none)
        {
            TurokPlayerController(Instigator.Controller).mZoomer.EnableSlideZoom(true);
        }
        super.EndState(NextStateName);
        //return;        
    }
    stop;    
}

simulated state WeaponEquipping
{
    simulated function BeginState(name PreviousStateName)
    {
        mbBlinkTopLight = false;
        mBlinkCount = 0;
        mPrevZoomLevel = 0;
        SetAmmoIndicatorLights();
        // End:0x8F
        if(TurokPlayerController(Instigator.Controller) != none)
        {
            TurokPlayerController(Instigator.Controller).mZoomer.ResetZoomLevel();
            TurokPlayerController(Instigator.Controller).mZoomer.EnableSlideZoom(false);
        }
        super.BeginState(PreviousStateName);
        //return;        
    }
    stop;    
}

auto simulated state Inactive
{
    simulated function BeginState(name PreviousStateName)
    {
        SnapOutOfZoom();
        mPrevZoomLevel = 0;
        ClearTimer('RestoreZoomLevelTimer');
        super.BeginState(PreviousStateName);
        //return;        
    }
    stop;    
}

simulated state WeaponLowering
{
    simulated function BeginState(name PreviousStateName)
    {
        SnapOutOfZoom();
        mPrevZoomLevel = 0;
        ClearTimer('RestoreZoomLevelTimer');
        super.BeginState(PreviousStateName);
        //return;        
    }
    stop;    
}

simulated state Deactivated
{
    simulated function BeginState(name PreviousStateName)
    {
        mbBlinkTopLight = false;
        mBlinkCount = 0;
        mLightToBlink = 0;
        mPrevZoomLevel = 0;
        ClearTimer('RestoreZoomLevelTimer');
        SnapOutOfZoom();
        super.BeginState(PreviousStateName);
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: TurokZoomComponent'Default__TurokWeapSniperRifleNative.Zoom'
    begin object name=Zoom
    end object
    mZoomValues=Zoom
}