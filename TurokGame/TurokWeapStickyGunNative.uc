class TurokWeapStickyGunNative extends TurokWeapon
    native
    nativereplication
    config(WeapStickyGun)
    hidecategories(Navigation);

enum ETurokStickyGrenadeState
{
    ETSGS_None,                     // 0
    ETSGS_Pending,                  // 1
    ETSGS_Ready,                    // 2
    ETSGS_MAX                       // 3
};

var config float mPrimaryDelayDetonateTime;
var config int mTriggerProjMax;
var private byte mPrimaryGrenadeState;
var private @NULL mPrimaryGrenade;
var private array mTriggerProj;
var private @NULL mPlaybackMI;
var private bool mbBlinkTopLight;
var private int mBlinkCount;
var private int mLightToBlink;

replication
{
    // Pos:0x000
    if(bNetDirty && bNetOwner
        mPrimaryGrenadeState;
}

simulated function RefireCheckTimer()
{
    ClearTimer('RefireCheckTimer');
    //return;    
}

simulated function AttachWeapon()
{
    super.AttachWeapon();
    // End:0x9C
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
    }
    //return;    
}

simulated function DetachWeapon()
{
    mPlaybackMI = none;
    super.DetachWeapon();
    //return;    
}

simulated event SetAmmoIndicatorLights()
{
    local @NULL newLinearColor, ammoCount;

    // End:0x14D
    if(mPlaybackMI != none)
    {
        mbBlinkTopLight = false;
        // End:0x61
        if(mCurrentClipAmmo <= 2)
        {
            newLinearColor.R = 3.0000000;
            newLinearColor.G = 0.2200000;
            newLinearColor.B = 0.0000000;            
        }
        else
        {
            newLinearColor.R = 3.0000000;
            newLinearColor.G = 1.2000000;
            newLinearColor.B = 0.0000000;
        }
        mPlaybackMI.SetVectorParameterValue('VLightHue01', newLinearColor);
        mPlaybackMI.SetVectorParameterValue('VLightHue00', newLinearColor);
        ammoCount.R = 0.0000000;
        ammoCount.G = float(mCurrentClipAmmo);
        ammoCount.B = 0.0000000;
        ammoCount.A = 0.0000000;
        mPlaybackMI.SetVectorParameterValue('VAmmoCounter', ammoCount);
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
        SetTimer(0.0800000, false, 'BlinkTimer');        
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
    // End:0x86
    if((float(mBlinkCount) % float(2)) == float(1))
    {
        newLinearColor.R = 3.0000000;
        newLinearColor.G = 0.2200000;
        newLinearColor.B = 0.0000000;
        // End:0x83
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
        // End:0xF6
        if(mPlaybackMI != none)
        {
            mPlaybackMI.SetVectorParameterValue('VLightHue00', newLinearColor);
        }
    }
    ProcessBlink();
    //return;    
}

simulated event Destroyed()
{
    super.Destroyed();
    TriggerProjCleanup();
    //return;    
}

function DropFrom(@NULL StartLocation, @NULL StartVelocity)
{
    super.DropFrom(StartLocation, StartVelocity);
    TriggerProjCleanup();
    //return;    
}

function DetonateGrenade()
{
    // End:0x4D
    if(int(Role) == int(ROLE_Authority))
    {
        ClearTimer('DetonateGrenade');
        // End:0x45
        if(mPrimaryGrenade != none)
        {
            mPrimaryGrenade.DetonateStickyProjectile();
            mPrimaryGrenade = none;
        }
        mPrimaryGrenadeState = 0;
    }
    //return;    
}

event TriggerProjCleanup()
{
    local int I;

    DetonateGrenade();
    I = 0;
    J0x11:

    // End:0x5E [Loop If]
    if(I < mTriggerProj.Length)
    {
        // End:0x54
        if(!mTriggerProj[I].bDeleteMe)
        {
            mTriggerProj[I].DetonateStickyProjectile();
        }
        I++;
        // [Loop Continue]
        goto J0x11;
    }
    mTriggerProj.Length = 0;
    //return;    
}

function SMDynamicActorMovedTriggerProjCleanup(@NULL Proj)
{
    local int I;

    // End:0x1C
    if(Proj == mPrimaryGrenade)
    {
        DetonateGrenade();        
    }
    else
    {
        I = 0;
        J0x23:

        // End:0x70 [Loop If]
        if(I < mTriggerProj.Length)
        {
            // End:0x66
            if(!mTriggerProj[I].bDeleteMe)
            {
                mTriggerProj[I].DetonateStickyProjectile();
            }
            I++;
            // [Loop Continue]
            goto J0x23;
        }
        mTriggerProj.Length = 0;
    }
    //return;    
}

function TriggerAddProj(@NULL Projectile)
{
    local int I, Slot;
    local float slottime;

    Slot = -1;
    // End:0xFD
    if(mTriggerProj.Length >= mTriggerProjMax)
    {
        slottime = -10.0000000;
        I = 0;
        J0x2D:

        // End:0xFD [Loop If]
        if(I < mTriggerProj.Length)
        {
            // End:0x79
            if(mTriggerProj[I].bDeleteMe || mTriggerProj[I] == none)
            {
                Slot = I;
                // [Explicit Break]
                goto J0xFD;
                // [Explicit Continue]
                goto J0xF3;
            }
            // End:0xB0
            if(slottime < 0.0000000)
            {
                Slot = I;
                slottime = mTriggerProj[I].CreationTime;
                // [Explicit Continue]
                goto J0xF3;
            }
            // End:0xF3
            if(slottime > mTriggerProj[I].CreationTime)
            {
                Slot = I;
                slottime = mTriggerProj[I].CreationTime;
            }
            J0xF3:

            I++;
            // [Loop Continue]
            goto J0x2D;
        }
    }
    J0xFD:

    // End:0x150
    if(Slot >= 0)
    {
        // End:0x13C
        if(mTriggerProj[Slot].bDeleteMe == false)
        {
            mTriggerProj[Slot].DetonateStickyProjectile();
        }
        mTriggerProj[Slot] = Projectile;        
    }
    else
    {
        mTriggerProj[mTriggerProj.Length] = Projectile;
    }
    //return;    
}

function PrimaryFirePause()
{
    // End:0x18
    if(int(mPrimaryGrenadeState) == int(1))
    {
        mPrimaryGrenadeState = 2;
    }
    //return;    
}

// Export UTurokWeapStickyGunNative::execCalcWeaponRecoil(FFrame&, void* const)
native simulated function CalcWeaponRecoil();

simulated event @NULL ProjectileFire()
{
    local @NULL StartTrace, EndTrace, RealStartLoc, AimDir, TestImpact, SpawnedProjectile;

    // End:0x75
    if(PendingFire(0))
    {
        // End:0x5D
        if(int(mPrimaryGrenadeState) == int(2))
        {
            mPrimaryGrenadeState = 0;
            TurokWeapAttachStickyGunNative(mAttachment).PlayDetonateSound();
            // End:0x58
            if(int(Role) == int(ROLE_Authority))
            {
                DetonateGrenade();
            }
            return none;            
        }
        else
        {
            // End:0x75
            if(int(mPrimaryGrenadeState) == int(0))
            {
                mPrimaryGrenadeState = 1;
            }
        }
    }
    // End:0x1E3
    if(int(Role) == int(ROLE_Authority))
    {
        StartTrace = Instigator.GetWeaponStartTraceLocation();
        RealStartLoc = GetPhysicalFireStartLoc();
        // End:0x125
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
        SpawnedProjectile = TurokProjStickyGunNative(__NFUN_278__(GetProjectileClass(), self,, RealStartLoc));
        // End:0x1E3
        if((SpawnedProjectile != none) && !SpawnedProjectile.bDeleteMe)
        {
            SpawnedProjectile.Init(AimDir);
            // End:0x1C6
            if(PendingFire(0))
            {
                mPrimaryGrenade = SpawnedProjectile;
                SetTimer(mPrimaryDelayDetonateTime, false, 'PrimaryFirePause');                
            }
            else
            {
                // End:0x1E3
                if(PendingFire(1))
                {
                    TriggerAddProj(SpawnedProjectile);
                }
            }
        }
    }
    // End:0x200
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

simulated function DeactivateWeaponBegin()
{
    // End:0x2D
    if(IsTimerActive('PrimaryFirePause'))
    {
        PrimaryFirePause();
        ClearTimer('PrimaryFirePause');
    }
    //return;    
}

// Export UTurokWeapStickyGunNative::execConsumeAmmo(FFrame&, void* const)
native function ConsumeAmmo(byte FireModeNum);

// Export UTurokWeapStickyGunNative::execHasAmmo(FFrame&, void* const)
native function bool HasAmmo(byte FireModeNum, optional int Amount);

// Export UTurokWeapStickyGunNative::execFireAmmunition(FFrame&, void* const)
native function FireAmmunition();

// Export UTurokWeapStickyGunNative::execRecordShotFired(FFrame&, void* const)
native function RecordShotFired();

simulated state Active
{
    simulated function BeginState(name PreviousStateName)
    {
        // End:0x16
        if(bWeaponPutDown)
        {
            PutDownWeapon();            
        }
        else
        {
            // End:0x3E
            if(PendingFire(0))
            {
                ClearPendingFire(0);
                BeginFire(0);                
            }
            else
            {
                // End:0x66
                if(PendingFire(1))
                {
                    ClearPendingFire(1);
                    BeginFire(1);                    
                }
                else
                {
                    // End:0x7B
                    if(mCurrentClipAmmo == 0)
                    {
                        WeaponEmpty();
                    }
                }
            }
        }
        //return;        
    }

    simulated function BeginReload()
    {
        // End:0x2F
        if((HasPoolAmmo(0)) && !IsClipFull())
        {
            GotoState('Reloading');
        }
        //return;        
    }

    simulated function BeginFire(byte FireModeNum)
    {
        local @NULL player_hud, tph;

        tph = TurokPawnHuman(Instigator);
        // End:0x1D6
        if((tph != none) && !bDeleteMe)
        {
            // End:0xE9
            if(HasAmmo(FireModeNum))
            {
                // End:0x8D
                if(int(FireModeNum) == 0)
                {
                    // End:0x8A
                    if((int(mPrimaryGrenadeState) == int(0)) || int(mPrimaryGrenadeState) == int(2))
                    {
                        SetPendingFire(int(FireModeNum));
                        SendToFiringState(FireModeNum);
                    }                    
                }
                else
                {
                    // End:0xBD
                    if(int(FireModeNum) == 1)
                    {
                        SetPendingFire(int(FireModeNum));
                        SendToFiringState(FireModeNum);                        
                    }
                    else
                    {
                        // End:0xE6
                        if((HasPoolAmmo(0)) && CanAutoReload())
                        {
                            WeaponEmpty();
                        }
                    }
                }                
            }
            else
            {
                // End:0x115
                if((HasPoolAmmo(0)) && CanAutoReload())
                {
                    WeaponEmpty();                    
                }
                else
                {
                    // End:0x1D6
                    if(mAttachment != none)
                    {
                        mAttachment.PlayDryFiringSound();
                        // End:0x1D6
                        if((tph != none) && TurokPlayerController(tph.Controller) != none)
                        {
                            player_hud = TurokHud(TurokPlayerController(tph.Controller).myHUD);
                            // End:0x1D6
                            if((player_hud != none) && player_hud.mAmmoDisplay != none)
                            {
                                player_hud.mAmmoDisplay.SetDryFire(self, FireModeNum);
                                player_hud.ResetFadeTimer();
                            }
                        }
                    }
                }
            }
        }
        //return;        
    }
    stop;    
}

auto state Inactive
{
    simulated function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        // End:0x28
        if(IsTimerActive('DetonateGrenade'))
        {
            DetonateGrenade();
        }
        //return;        
    }
    stop;    
}

simulated state Reloading
{
    simulated function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        SetTimer(1.0000000, false, 'ReloadAmmoLight');
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        ClearTimer('ReloadAmmoLight');
        SetAmmoIndicatorLights();
        super.EndState(NextStateName);
        //return;        
    }

    simulated function BeginFire(byte FireModeNum)
    {
        local @NULL TPC;

        // End:0x9F
        if((int(FireModeNum) == 0) && int(mPrimaryGrenadeState) == int(2))
        {
            mPrimaryGrenadeState = 0;
            TurokWeapAttachStickyGunNative(mAttachment).PlayDetonateSound();
            // End:0x59
            if(int(Role) == int(ROLE_Authority))
            {
                DetonateGrenade();
            }
            TPC = TurokPlayerController(Instigator.Controller);
            // End:0x9F
            if(TPC != none)
            {
                RecordShotFired();
                TPC.TurokPlayForceFeedbackWaveform(mPrimaryFireFF);
            }
        }
        //return;        
    }

    simulated function ReloadAmmoLight()
    {
        local @NULL newColor, newLinearColor, ammoCount;

        // End:0xCC
        if(mPlaybackMI != none)
        {
            mbBlinkTopLight = false;
            mBlinkCount = 0;
            newColor = MakeColor(0, 0, 0);
            newLinearColor = ColorToLinearColor(newColor);
            mPlaybackMI.SetVectorParameterValue('VLightHue01', newLinearColor);
            ammoCount.R = 0.0000000;
            ammoCount.G = 0.0000000;
            ammoCount.B = 0.0000000;
            ammoCount.A = 0.0000000;
            mPlaybackMI.SetVectorParameterValue('VAmmoCounter', ammoCount);
        }
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: TurokZoomComponent'Default__TurokWeapStickyGunNative.Zoom'
    begin object name=Zoom
    end object
    mZoomValues=Zoom
}