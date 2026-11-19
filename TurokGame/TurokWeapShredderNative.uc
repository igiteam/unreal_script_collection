class TurokWeapShredderNative extends TurokWeapon
    native
    config(Weapon)
    hidecategories(Navigation);

var float mPower;
var(Shredder) float mMaxPowerBuildUp;
var(Shredder) float mPowerBuildUpRate;
var(Shredder) float mMandatoryCoolDownTime;
var(Shredder) float mRepairBeamRange;
var bool mOverCharged;
var bool mbCharging;
var bool mRepairBeamActivated;
var export editinline @NULL mPrimaryFireChargeBuildupFX;
var @NULL mChargeBuildupFxTemplate;
var export editinline @NULL mOverchargeFx;
var @NULL mOverchargeFxTemplate;
var name ChargeUpSocket;
var(Animations) @NULL mChargeUpAnim;
var export editinline @NULL mRepairBeamMesh;
var @NULL mRepairBeamFrontControl;
var @NULL mRepairBeamBackControl;
var @NULL mRepairBeamHitActor;

simulated event Tick(float DeltaTime)
{
    local @NULL startLoc, endLoc, Aim, fxMeshRotation;

    // End:0x5C
    if(PendingFire(0))
    {
        // End:0x25
        if(!mOverCharged)
        {
            mPower += mPowerBuildUpRate;
        }
        // End:0x5C
        if(mPower >= mMaxPowerBuildUp)
        {
            mOverCharged = true;
            mPower = 0.0000000;
            WeaponOvercharged();
            ClearPendingFire(0);
        }
    }
    // End:0x134
    if(mRepairBeamActivated)
    {
        startLoc = GetWeaponMuzzleLocation(1);
        Aim = GetAdjustedAim(startLoc);
        // End:0xB6
        if(mRepairBeamHitActor == none)
        {
            endLoc = startLoc + (Normal(Vector(Aim)) * mRepairBeamRange);            
        }
        else
        {
            endLoc = mRepairBeamHitActor.Location;
        }
        // End:0x115
        if(mRepairBeamFrontControl != none)
        {
            fxMeshRotation = Rotator(startLoc - endLoc);
            mRepairBeamMesh.SetRotation(fxMeshRotation);
            mRepairBeamFrontControl.BoneTranslation = startLoc;
        }
        // End:0x134
        if(mRepairBeamBackControl != none)
        {
            mRepairBeamBackControl.BoneTranslation = endLoc;
        }
    }
    super(Actor).Tick(DeltaTime);
    //return;    
}

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    mRepairBeamMesh.SetHidden(true);
    mRepairBeamFrontControl = SkelControlSingleBone(mRepairBeamMesh.FindSkelControl('RepairBeamRootBoneControl'));
    mRepairBeamBackControl = SkelControlSingleBone(mRepairBeamMesh.FindSkelControl('RepairBeamEndBoneControl'));
    //return;    
}

simulated function WeaponOvercharged()
{
    StartOverchargedFx();
    SetTimer(mMandatoryCoolDownTime, false, 'CoolDownTimer');
    //return;    
}

simulated function CoolDownTimer()
{
    mOverCharged = false;
    //return;    
}

// Export UTurokWeapShredderNative::execClearPendingFire(FFrame&, void* const)
native function ClearPendingFire(int FireMode);

// Export UTurokWeapShredderNative::execConsumeAmmo(FFrame&, void* const)
native function ConsumeAmmo(byte FireModeNum);

// Export UTurokWeapShredderNative::execHasAmmo(FFrame&, void* const)
native function bool HasAmmo(byte FireModeNum, optional int Amount);

simulated function bool IsClipFull()
{
    return mCurrentClipAmmo == mMaxClipAmmo;
    //return ReturnValue;    
}

simulated function bool HasAnyAmmo()
{
    return (mCurrentClipAmmo + mAmmoPoolCount) > 0;
    //return ReturnValue;    
}

simulated event RangeLimitedRayFiring()
{
    local @NULL StartTrace, EndTrace, HitLocation, HitNormal, Aim, HitInfo;

    // End:0xA7
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x2B
        if(!mRepairBeamActivated)
        {
            mRepairBeamMesh.SetHidden(false);
        }
        mRepairBeamActivated = true;
        StartTrace = GetWeaponMuzzleLocation(1);
        Aim = GetAdjustedAim(StartTrace);
        EndTrace = StartTrace + (Normal(Vector(Aim)) * mRepairBeamRange);
        mRepairBeamHitActor = Trace(HitLocation, HitNormal, EndTrace, StartTrace, true,, HitInfo);
        // End:0xA7
        if(mRepairBeamHitActor != none)
        {
        }
    }
    // End:0xC4
    if(int(mEquippedInHand) == int(1))
    {
        IncrementFlashCountLH();        
    }
    else
    {
        IncrementFlashCount();
    }
    //return;    
}

simulated event @NULL ProjectileFire()
{
    local @NULL StartTrace, EndTrace, RealStartLoc, AimDir, TestImpact, SpawnedProjectile;

    // End:0x11D
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
        SpawnedProjectile = __NFUN_278__(GetProjectileClass(), self,, RealStartLoc);
        // End:0x11D
        if((SpawnedProjectile != none) && !SpawnedProjectile.bDeleteMe)
        {
            SpawnedProjectile.Init(AimDir);
        }
    }
    // End:0x13A
    if(int(mEquippedInHand) == int(1))
    {
        IncrementFlashCountLH();        
    }
    else
    {
        IncrementFlashCount();
    }
    return SpawnedProjectile;
    //return ReturnValue;    
}

// Export UTurokWeapShredderNative::execTimeWeaponFiring(FFrame&, void* const)
native function TimeWeaponFiring(byte FireModeNum);

simulated function InitChargeUpEffects()
{
    // End:0x5F
    if(mChargeBuildupFxTemplate != none)
    {
        mPrimaryFireChargeBuildupFX = new (Outer) Class'Engine.ParticleSystemComponent';
        mPrimaryFireChargeBuildupFX.DeactivateSystem();
        mPrimaryFireChargeBuildupFX.SetScale(1.0000000);
        mWeaponMesh.AttachComponentToSocket(mPrimaryFireChargeBuildupFX, ChargeUpSocket);
    }
    // End:0xBE
    if(mOverchargeFxTemplate != none)
    {
        mOverchargeFx = new (Outer) Class'Engine.ParticleSystemComponent';
        mOverchargeFx.DeactivateSystem();
        mOverchargeFx.SetScale(1.0000000);
        mWeaponMesh.AttachComponentToSocket(mOverchargeFx, ChargeUpSocket);
    }
    //return;    
}

simulated function ClearChargeUpEffects()
{
    // End:0x0D
    if(Instigator == none)
    {
        return;
    }
    // End:0x1A
    if(Mesh == none)
    {
        return;
    }
    // End:0x4C
    if(mPrimaryFireChargeBuildupFX != none)
    {
        StopChargeUpFx();
        Instigator.Mesh.DetachComponent(mPrimaryFireChargeBuildupFX);
    }
    // End:0x7E
    if(mOverchargeFx != none)
    {
        StopOverchargedFx();
        Instigator.Mesh.DetachComponent(mOverchargeFx);
    }
    //return;    
}

simulated event StopChargeUpFx()
{
    // End:0x1A
    if(mPrimaryFireChargeBuildupFX != none)
    {
        mPrimaryFireChargeBuildupFX.DeactivateSystem();
    }
    //return;    
}

simulated function StartChargeUpFx()
{
    // End:0x2E
    if(mPrimaryFireChargeBuildupFX != none)
    {
        mPrimaryFireChargeBuildupFX.SetTemplate(mChargeBuildupFxTemplate);
        mPrimaryFireChargeBuildupFX.ActivateSystem();
    }
    //return;    
}

simulated function StartOverchargedFx()
{
    // End:0x2E
    if(mOverchargeFx != none)
    {
        mOverchargeFx.SetTemplate(mOverchargeFxTemplate);
        mOverchargeFx.ActivateSystem();
    }
    //return;    
}

simulated function StopOverchargedFx()
{
    // End:0x1A
    if(mOverchargeFx != none)
    {
        mOverchargeFx.DeactivateSystem();
    }
    //return;    
}

simulated function StartChargeBuilding()
{
    mbCharging = true;
    StartChargeUpFx();
    PlayPOVAnimation(mChargeUpAnim, 1.0000000, 0.1000000, 0.1000000, true, true);
    //return;    
}

simulated function AttachWeapon()
{
    super.AttachWeapon();
    InitChargeUpEffects();
    //return;    
}

simulated function DetachWeapon()
{
    super.DetachWeapon();
    ClearChargeUpEffects();
    //return;    
}

simulated state Active
{
    simulated function BeginReload()
    {
        // End:0x3D
        if((!IsFiring() && !IsClipFull()) && HasAnyAmmo())
        {
            GotoState('Reloading');
        }
        //return;        
    }
    stop;    
}

simulated state WeaponFiring
{
    simulated function BeginState(name PreviousStateName)
    {
        local byte FireMode;

        FireMode = GetFiringMode();
        // End:0x39
        if(int(FireMode) == 1)
        {
            FireAmmunition();
            TimeWeaponFiring(FireMode);            
        }
        else
        {
            // End:0x50
            if(int(FireMode) == 0)
            {
                StartChargeBuilding();
            }
        }
        //return;        
    }

    simulated function RefireCheckTimer()
    {
        local byte FireMode;

        FireMode = GetFiringMode();
        // End:0x25
        if(bWeaponPutDown)
        {
            PutDownWeapon();
            return;
        }
        // End:0x4D
        if((int(FireMode) == 1) && ShouldRefire())
        {
            FireAmmunition();
            return;
        }
        GotoState('Active');
        // End:0x74
        if(!HasAnyAmmo())
        {
            WeaponEmpty();
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        // End:0x28
        if(mRepairBeamActivated)
        {
            mRepairBeamActivated = false;
            mRepairBeamHitActor = none;
            mRepairBeamMesh.SetHidden(true);
        }
        // End:0x4F
        if(int(mEquippedInHand) == int(1))
        {
            ClearFlashCountLH();
            ClearFlashLocationLH();            
        }
        else
        {
            ClearFlashCount();
            ClearFlashLocation();
        }
        ClearTimer('RefireCheckTimer');
        // End:0xB8
        if(AIController(Instigator.Controller) != none)
        {
            AIController(Instigator.Controller).NotifyWeaponFinishedFiring(self, GetFiringMode());
        }
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: TurokZoomComponent'Default__TurokWeapShredderNative.Zoom'
    begin object name=Zoom
    end object
    mZoomValues=Zoom
}