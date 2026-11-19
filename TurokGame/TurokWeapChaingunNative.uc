class TurokWeapChaingunNative extends TurokWeapon
    native
    config(WeapChaingun)
    hidecategories(Navigation);

enum eAmmoLightState
{
    ALS_Off,                        // 0
    ALS_Yellow,                     // 1
    ALS_Red,                        // 2
    ALS_MAX                         // 3
};

enum eTurretLightState
{
    TLS_Off,                        // 0
    TLS_Orange,                     // 1
    TLS_Blue,                       // 2
    TLS_Red,                        // 3
    TLS_MAX                         // 4
};

var @NULL mSpinController;
var float mFullSpeedSpin;
var float mCurrentSpinPer;
var private bool mbIsSpinningUp;
var private bool mbIsSpinningUpWithoutFiring;
var bool mBlinkState;
var bool mLastBlinkState;
var float mTurbineModulator;
var float mTurbineSndDelay;
var @NULL mAnimTreeTemplate;
var() float mAIRampUpTime;
var() float mRampUpTime;
var() float mRampDownTime;
var byte mAmmoLightState;
var byte mTurretLightState;
var float mBlinkRate;
var float mCurBlinkCount;
var() @NULL mChaingunTripodGraphSet;
var(Placement) config float mSweepRange;
var(Placement) config float mSweepHeight;
var(Placement) config float mMaxDropHeight;
var(Placement) config float mHorizSurfaceTolerance;
var @NULL mPlaybackMI;
var(Animations) @NULL mWindUpAnim;
var class<Class> mMiniGunAutoTurretClass;

simulated function AttachWeapon()
{
    super.AttachWeapon();
    // End:0x92
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
    }
    //return;    
}

// Export UTurokWeapChaingunNative::execIsAutoTurretMode(FFrame&, void* const)
native function bool IsAutoTurretMode();

simulated event Tick(float DeltaTime)
{
    // End:0x78
    if(IsActiveWeapon())
    {
        UpdateSpin(DeltaTime);
        UpdateAmmoLight(DeltaTime);
        // End:0x78
        if((((mCurrentSpinPer >= 1.0000000) && PendingFire(0)) && mCurrentClipAmmo > 0) && GetStateName() != 'ThrowGrenadeState')
        {
            GotoState('WeaponFiring');
        }
    }
    super(Actor).Tick(DeltaTime);
    //return;    
}

simulated function UpdateAmmoLight(float DeltaTime)
{
    local bool bUpdateLights;
    local int ammoLight, turretLight;
    local byte lightByte;
    local @NULL newColor, newLinearColor, tph;

    mCurBlinkCount += DeltaTime;
    bUpdateLights = false;
    // End:0x45
    if(mCurBlinkCount >= mBlinkRate)
    {
        mBlinkState = !mBlinkState;
        mCurBlinkCount = 0.0000000;
        bUpdateLights = true;
    }
    switch(mTurretLightState)
    {
        // End:0x5B
        case 1:
            turretLight = 1;
            // End:0x8D
            break;
        // End:0x6B
        case 2:
            turretLight = 2;
            // End:0x8D
            break;
        // End:0x7B
        case 3:
            turretLight = 3;
            // End:0x8D
            break;
        // End:0x8A
        case 0:
            turretLight = 0;
            // End:0x8D
            break;
        // End:0xFFFF
        default:
            break;
    }
    // End:0x190
    if((mBlinkState == true) && mLastBlinkState == false)
    {
        switch(mAmmoLightState)
        {
            // End:0xF5
            case 1:
                newColor.R = byte(255);
                newColor.G = 102;
                newColor.B = 0;
                ammoLight = 1;
                // End:0x185
                break;
            // End:0x13D
            case 2:
                newColor.R = byte(255);
                newColor.G = 0;
                newColor.B = 0;
                ammoLight = 2;
                // End:0x185
                break;
            // End:0x182
            case 0:
                newColor.R = 0;
                newColor.G = 0;
                newColor.B = 0;
                ammoLight = 0;
                // End:0x185
                break;
            // End:0xFFFF
            default:
                break;
        }
        mLastBlinkState = true;        
    }
    else
    {
        // End:0x218
        if((mBlinkState == false) && mLastBlinkState == true)
        {
            mLastBlinkState = false;
            // End:0x1DB
            if((int(mTurretLightState) == int(3)) || int(mTurretLightState) == int(0))
            {
                turretLight = 0;
            }
            ammoLight = 0;
            newColor.R = 0;
            newColor.G = 0;
            newColor.B = 0;
        }
    }
    // End:0x2E4
    if(bUpdateLights)
    {
        // End:0x299
        if(mPlaybackMI != none)
        {
            newLinearColor = ColorToLinearColor(newColor);
            newLinearColor.R *= float(3);
            newLinearColor.G *= float(3);
            newLinearColor.B *= float(3);
            mPlaybackMI.SetVectorParameterValue('VPlaybackHue', newLinearColor);
        }
        lightByte = byte((turretLight << 4) + ammoLight);
        tph = TurokPawnHuman(Instigator);
        // End:0x2E4
        if(tph != none)
        {
            tph.SetAttachmentChaingunLights(lightByte);
        }
    }
    //return;    
}

simulated function NotifyZoomPressed()
{
    mbIsSpinningUpWithoutFiring = true;
    //return;    
}

simulated function ReleaseZoom()
{
    mbIsSpinningUpWithoutFiring = false;
    //return;    
}

simulated function UpdateSpin(float DeltaTime)
{
    local float incAmmount, rampUpTime;

    rampUpTime = mRampUpTime;
    // End:0x2F
    if(AIController(Instigator.Controller) != none)
    {
        rampUpTime = mAIRampUpTime;
    }
    // End:0x61
    if(mbIsSpinningUp)
    {
        mCurrentSpinPer += (DeltaTime / rampUpTime);
        mTurbineModulator += (DeltaTime / rampUpTime);        
    }
    else
    {
        mCurrentSpinPer -= (DeltaTime / mRampDownTime);
        mTurbineModulator -= (DeltaTime / (mRampDownTime + mTurbineSndDelay));
    }
    mCurrentSpinPer = FClamp(mCurrentSpinPer, 0.0000000, 1.0000000);
    mTurbineModulator = FClamp(mTurbineModulator, 0.0000000, 1.0000000);
    incAmmount = (mCurrentSpinPer * mFullSpeedSpin) * DeltaTime;
    // End:0x101
    if(mSpinController != none)
    {
        mSpinController.BoneRotation.Yaw += int(incAmmount);
    }
    // End:0x13C
    if(mAttachment != none)
    {
        mAttachment.UpdateChaingunBarrelAudio(mSpinController.BoneRotation.Yaw, mTurbineModulator);
    }
    //return;    
}

function SetAttachmentChaingunSpinStatus(bool IsSpinningUp)
{
    local @NULL tph;

    tph = TurokPawnHuman(Instigator);
    // End:0x34
    if(tph != none)
    {
        tph.SetAttachmentChaingunSpinStatus(IsSpinningUp);
    }
    //return;    
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    mWeaponMesh.SetAnimTreeTemplate(mAnimTreeTemplate);
    mSpinController = SkelControlSingleBone(mWeaponMesh.FindSkelControl('CtlBarrel'));
    mFullSpeedSpin = ((360.0000000 / 6.0000000) * (1.0000000 / FireInterval[0])) * 182.0000000;
    //return;    
}

simulated function AttachWeaponAttachment()
{
    super.AttachWeaponAttachment();
    //return;    
}

simulated function DetachWeaponAttachment()
{
    mTurbineModulator = 0.0000000;
    super.DetachWeaponAttachment();
    //return;    
}

simulated function float GetRandomBurstInterval()
{
    local int FiringMode;

    FiringMode = int(GetFiringMode());
    return (mAIRampUpTime + mBurstMinInterval[FiringMode]) + (FRand() * (mBurstMaxInterval[FiringMode] - mBurstMinInterval[FiringMode]));
    //return ReturnValue;    
}

function LimitAutoTurrets()
{
    local @NULL autoTurretPawn, farAutoTurret;
    local int turretCount;
    local float CurrentDistance, turretDistance;

    turretCount = 0;
    turretDistance = 0.0000000;
    // End:0x8F
    foreach WorldInfo.AllPawns(Class'TurokPawnMiniGunAutoTurretNative', autoTurretPawn)
    {
        CurrentDistance = VSize(autoTurretPawn.Location - Instigator.Location);
        // End:0x79
        if(CurrentDistance > turretDistance)
        {
            turretDistance = CurrentDistance;
            farAutoTurret = autoTurretPawn;
        }
        turretCount++;
        // End:0x8E
        if(turretCount > 1)
        {
            // End:0x8F
            break;
        }        
    }    
    // End:0xE2
    if(turretCount > 1)
    {
        farAutoTurret.TakeDamage(farAutoTurret.Health + 1, none, farAutoTurret.Location, vect(0.0000000, 0.0000000, 0.0000000), Class'Engine.DmgType_Crushed');
    }
    //return;    
}

reliable server function ServerStartFire(byte FireModeNum)
{
    // End:0x1C
    if(int(FireModeNum) == 0)
    {
        BeginFire(FireModeNum);
    }
    //return;    
}

simulated function BeginFire(byte FireModeNum)
{
    // End:0x1E
    if(int(FireModeNum) == 0)
    {
        SetPendingFire(int(FireModeNum));
    }
    //return;    
}

// Export UTurokWeapChaingunNative::execSendToFiringState(FFrame&, void* const)
native function SendToFiringState(byte FireModeNum);

simulated function DetachWeapon()
{
    super.DetachWeapon();
    //return;    
}

// Export UTurokWeapChaingunNative::execHasAmmo(FFrame&, void* const)
native function bool HasAmmo(byte FireModeNum, optional int Amount);

function bool CanReload()
{
    return !TurokPawnHuman(Instigator).IsInState('PickupMiniGunSentry') && super.CanReload();
    //return ReturnValue;    
}

simulated function bool CanAutoReload()
{
    return !TurokPawnHuman(Instigator).IsInState('PickupMiniGunSentry') && super.CanAutoReload();
    //return ReturnValue;    
}

simulated state SpinningUp
{
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

    simulated function BeginState(name PreviousStateName)
    {
        PlayPOVCannedAnimation(mWindUpAnim, mAmbientIdleTime, mAmbientIdleTime * 0.0500000, true);
        mbIsSpinningUp = true;
        SetAttachmentChaingunSpinStatus(mbIsSpinningUp);
        //return;        
    }

    simulated function EndState(name NextState)
    {
        mbIsSpinningUp = false;
        SetAttachmentChaingunSpinStatus(mbIsSpinningUp);
        //return;        
    }

    simulated function ReleaseZoom()
    {
        global.ReleaseZoom();
        // End:0x28
        if(!PendingFire(0))
        {
            GotoState('Active');
        }
        //return;        
    }

    simulated function EndFire(byte FireModeNum)
    {
        super(Weapon).EndFire(FireModeNum);
        // End:0x24
        if(!mbIsSpinningUpWithoutFiring)
        {
            GotoState('Active');
        }
        //return;        
    }
    stop;    
}

simulated state WeaponPuttingDown
{
    simulated function WeaponIsDown()
    {
        super.WeaponIsDown();
        mCurrentSpinPer = 0.0000000;
        //return;        
    }
    stop;    
}

simulated state Active
{
    simulated function BeginState(name PrevStateName)
    {
        // End:0x33
        if(mbIsSpinningUpWithoutFiring && HasAmmo(GetFiringMode()))
        {
            GotoState('SpinningUp');
            return;
        }
        // End:0x5F
        if(!bWeaponPutDown)
        {
            PlayPOVCannedAnimation(mAmbientIdleAnim, mAmbientIdleTime, mAmbientIdleTime * 0.0500000, true);
        }
        super.BeginState(PrevStateName);
        //return;        
    }

    simulated function NotifyZoomPressed()
    {
        global.NotifyZoomPressed();
        GotoState('SpinningUp');
        //return;        
    }

    simulated function BeginReload()
    {
        // End:0x10
        if(IsAutoTurretMode())
        {            
        }
        else
        {
            // End:0x4D
            if((!IsFiring() && !IsClipFull()) && HasAnyPoolAmmo())
            {
                GotoState('Reloading');
            }
        }
        //return;        
    }

    simulated function bool CanDeployMiniGunSentry(out @NULL outPos, out @NULL outRot)
    {
        local @NULL tg, pos, TraceStart, Rot;
        local float Radius;
        local @NULL HitLocation, HitNormal, hitLocSurface, HitLocation2, HitNormal2, vSweep,
	        vUpVec, vBehindGun, vInFrontGun, HitActor2, HitActor3;

        local float turretSurfaceDot;
        local @NULL sentry;
        local float X, Y;
        local bool bBlocked;
        local @NULL tpp;

        tpp = TurokPawnPlayer(Instigator);
        // End:0x4E0
        if((((((tpp != none) && int(tpp.Physics) == int(1)) && tpp.mIsOnFire == false) && !tpp.IsInState('PickupMiniGunSentry')) && tpp.Controller != none) && !tpp.Controller.IsInState('CinematicState'))
        {
            // End:0xC1
            if(TurokLadderVolume(tpp.PhysicsVolume) != none)
            {
                return false;
            }
            tg = mChaingunTripodGraphSet.FindGraph('equip');
            // End:0x4E0
            if((tg != none) && tg.GetWorldCannedContactPoint(tpp.Mesh, pos, Rot, Radius, 0))
            {
                // End:0x1CE
                foreach WorldInfo.AllPawns(Class'TurokPawnMiniGunAutoTurretNative', sentry)
                {
                    X = sentry.Location.X - pos.X;
                    Y = sentry.Location.Y - pos.Y;
                    // End:0x1CD
                    if(((X * X) + (Y * Y)) < (60.0000000 * 60.0000000))
                    {                        
                        return false;
                    }                    
                }                
                vBehindGun = pos + (vect(-50.0000000, 0.0000000, 0.0000000) >> tpp.Rotation);
                vBehindGun += vect(0.0000000, 0.0000000, 48.0000000);
                vInFrontGun = pos + (vect(50.0000000, 0.0000000, 0.0000000) >> tpp.Rotation);
                vInFrontGun += vect(0.0000000, 0.0000000, 48.0000000);
                HitActor2 = Trace(hitLocSurface, HitNormal, pos + vect(0.0000000, 0.0000000, 96.0000000), pos, false);
                HitActor3 = Trace(hitLocSurface, HitNormal, tpp.Location + vect(0.0000000, 0.0000000, 96.0000000), tpp.Location, false);
                // End:0x2DB
                if((HitActor2 != none) || HitActor3 != none)
                {
                    return false;
                }
                TraceStart = pos;
                TraceStart += vect(0.0000000, 0.0000000, 48.0000000);
                HitActor3 = Trace(hitLocSurface, HitNormal, pos + vect(0.0000000, 0.0000000, -500.0000000), TraceStart, false);
                // End:0x33D
                if(InterpActor(HitActor3) != none)
                {
                    return false;
                }
                vSweep = vect(0.0000000, 0.0000000, 0.0000000);
                vSweep.X = mSweepRange;
                vSweep.Y = mSweepRange;
                vSweep.Z = mSweepHeight;
                bBlocked = false;
                // End:0x403
                foreach TraceActors(Class'Engine.Actor', HitActor2, HitLocation2, HitNormal2, vBehindGun, vInFrontGun, vSweep)
                {
                    // End:0x402
                    if((HitActor2.bBlockActors || TurokLadderVolume(HitActor2) != none) || TurokMPTeamFlagBase(HitActor2) != none)
                    {
                        bBlocked = true;
                        // End:0x403
                        break;
                    }                    
                }                
                // End:0x423
                if(mAttachment != none)
                {
                    mAttachment.StopAmbience();
                }
                vUpVec = vect(0.0000000, 0.0000000, 1.0000000);
                turretSurfaceDot = HitNormal Dot vUpVec;
                // End:0x4E0
                if((((turretSurfaceDot > mHorizSurfaceTolerance) && !bBlocked) && Trace(HitLocation, HitNormal, hitLocSurface, tpp.Location, false) == none) && Abs(hitLocSurface.Z - tpp.Location.Z) < mMaxDropHeight)
                {
                    outPos = pos;
                    outRot = Rot;
                    return true;
                }
            }
        }
        return false;
        //return ReturnValue;        
    }

    simulated event StartFire(byte FireModeNum)
    {
        local @NULL tpp, R, P;

        switch(FireModeNum)
        {
            // End:0x37
            case 0:
                // End:0x28
                if(int(Role) < int(ROLE_Authority))
                {
                    ServerStartFire(ROLE_None);
                }
                BeginFire(ROLE_None);
                // End:0xF2
                break;
            // End:0xEF
            case ROLE_SimulatedProxy:
                // End:0xBD
                if(CanDeployMiniGunSentry(P, R))
                {
                    tpp = TurokPawnPlayer(Instigator);
                    tpp.ServerDeployMiniGunSentry(self, P, R);
                    // End:0xBA
                    if((int(Role) == int(ROLE_Authority)) && !WorldInfo.Game.bMultiplayerGame)
                    {
                        LimitAutoTurrets();
                    }                    
                }
                else
                {
                    TurokHud(TurokPlayerController(Instigator.Controller).myHUD).ShowNoPlacement();
                }
                // End:0xF2
                break;
            // End:0xFFFF
            default:
                break;
        }
        //return;        
    }
    stop;    
}

simulated state Reloading
{
    simulated function EndState(name PreviousStateName)
    {
        // End:0x15
        if(IsAutoTurretMode())
        {
            mTurretLightState = 1;
        }
        mAmmoLightState = 0;
        super.EndState(PreviousStateName);
        //return;        
    }
    stop;    
}

state WeaponFiring
{
    simulated function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        mbIsSpinningUp = true;
        SetAttachmentChaingunSpinStatus(mbIsSpinningUp);
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        mbIsSpinningUp = false;
        SetAttachmentChaingunSpinStatus(mbIsSpinningUp);
        super.EndState(NextStateName);
        //return;        
    }
    stop;    
}

defaultproperties
{
    mTurbineSndDelay=0.3000000
    mAIRampUpTime=0.5000000
    mRampUpTime=1.2000000
    mRampDownTime=3.0000000
    mBlinkRate=0.5000000
    // Reference: TurokZoomComponent'Default__TurokWeapChaingunNative.Zoom'
    begin object name=Zoom
    end object
    mZoomValues=Zoom
    FireInterval=/* Array type was not detected. */
}