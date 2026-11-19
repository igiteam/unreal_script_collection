class TurokWeapTazerNative extends TurokWeapon
    native
    config(Weapon)
    hidecategories(Navigation);

var @NULL mActiveCanister;
var float mRechargePct;
var float mRechargePctIncrement;
var bool mbCanisterDetonated;
var(Tazer) float mRechargeTime;
var(Tazer) float mWaitBeforeDetonate;
var(Tazer) float mAutoDetonateTime;

// Export UTurokWeapTazerNative::execTimeWeaponFiring(FFrame&, void* const)
native function TimeWeaponFiring(byte FireModeNum);

simulated function RechargeTimer()
{
    mRechargePct += mRechargePctIncrement;
    // End:0x36
    if(mRechargePct >= 1.0000000)
    {
        ClearTimer('RecharegeTimer');
        mRechargePctIncrement = 0.0000000;
    }
    //return;    
}

simulated function CanisterAutoDetonateTimer()
{
    // End:0x5F
    if(mActiveCanister != none)
    {
        // End:0x5F
        if(int(Role) == int(ROLE_Authority))
        {
            // End:0x3D
            if(FRand() > 0.5000000)
            {
                mActiveCanister.ExplodeWithElectricalBolt();                
            }
            else
            {
                mActiveCanister.ExplodeWithFlashBang();
            }
            mActiveCanister = none;
            mbCanisterDetonated = true;
        }
    }
    //return;    
}

simulated event @NULL ProjectileFire()
{
    local @NULL StartTrace, EndTrace, RealStartLoc, AimDir, TestImpact, SpawnedProjectile;

    local byte FireMode;

    FireMode = GetFiringMode();
    // End:0x193
    if(mActiveCanister == none)
    {
        // End:0x163
        if(int(Role) == int(ROLE_Authority))
        {
            StartTrace = Instigator.GetWeaponStartTraceLocation();
            RealStartLoc = GetPhysicalFireStartLoc();
            // End:0xCB
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
            // End:0x163
            if((SpawnedProjectile != none) && !SpawnedProjectile.bDeleteMe)
            {
                SpawnedProjectile.Init(AimDir);
                mActiveCanister = TurokProjTazerNative(SpawnedProjectile);
                mbCanisterDetonated = false;
                SetTimer(mAutoDetonateTime, false, 'CanisterAutoDetonateTimer');
            }
        }
        // End:0x180
        if(int(mEquippedInHand) == int(1))
        {
            IncrementFlashCountLH();            
        }
        else
        {
            IncrementFlashCount();
        }
        return SpawnedProjectile;        
    }
    else
    {
        // End:0x210
        if(mActiveCanister != none)
        {
            // End:0x210
            if(int(Role) == int(ROLE_Authority))
            {
                // End:0x1D1
                if(int(FireMode) == 0)
                {
                    mActiveCanister.ExplodeWithElectricalBolt();                    
                }
                else
                {
                    // End:0x1F1
                    if(int(FireMode) == 1)
                    {
                        mActiveCanister.ExplodeWithFlashBang();
                    }
                }
                ClearTimer('CanisterAutoDetonateTimer');
                mActiveCanister = none;
                mbCanisterDetonated = true;
            }
        }
    }
    return none;
    //return ReturnValue;    
}

// Export UTurokWeapTazerNative::execConsumeAmmo(FFrame&, void* const)
native function ConsumeAmmo(byte FireModeNum);

// Export UTurokWeapTazerNative::execHasAmmo(FFrame&, void* const)
native function bool HasAmmo(byte FireModeNum, optional int Amount);

simulated state WeaponFiring
{
    simulated function BeginState(name PreviousStateName)
    {
        FireAmmunition();
        TimeWeaponFiring(GetFiringMode());
        //return;        
    }

    simulated function RefireCheckTimer()
    {
        // End:0x15
        if(bWeaponPutDown)
        {
            PutDownWeapon();
            return;
        }
        GotoState('Active');
        // End:0x4C
        if(!HasAmmo(0) && mActiveCanister == none)
        {
            WeaponEmpty();
        }
        //return;        
    }

    simulated function BeginFire(byte FireModeNum)
    {
        // End:0x33
        if(mActiveCanister != none)
        {
            SetCurrentFireMode(FireModeNum);
            FireAmmunition();
            TimeWeaponFiring(FireModeNum);
        }
        //return;        
    }

    simulated function BeginReload()
    {
        // End:0x2C
        if(!IsClipFull() && HasAnyAmmo())
        {
            GotoState('Reloading');
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        // End:0x31
        if(!HasAnyAmmo() && mActiveCanister == none)
        {
            WeaponEmpty();
        }
        //return;        
    }
    stop;    
}

simulated state Reloading
{    stop;    
}

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
            // End:0x42
            if(!HasAmmo(0) && mActiveCanister == none)
            {
                WeaponEmpty();                
            }
            else
            {
                // End:0x67
                if(PendingFire(0))
                {
                    ClearPendingFire(0);
                    BeginFire(0);
                }
                // End:0x8C
                if(PendingFire(1))
                {
                    ClearPendingFire(1);
                    BeginFire(1);
                }
            }
        }
        //return;        
    }

    simulated function BeginReload()
    {
        // End:0x3D
        if((!IsFiring() && !IsClipFull()) && HasAnyAmmo())
        {
            GotoState('Reloading');
        }
        //return;        
    }

    simulated function BeginFire(byte FireModeNum)
    {
        local @NULL player_hud, tph;

        tph = TurokPawnHuman(Instigator);
        // End:0x155
        if(!bDeleteMe && Instigator != none)
        {
            // End:0x75
            if((mActiveCanister != none) || (HasAmmo(0)) && mActiveCanister == none)
            {
                SetPendingFire(int(FireModeNum));
                SendToFiringState(FireModeNum);                
            }
            else
            {
                // End:0x155
                if(!HasAmmo(0) && mActiveCanister == none)
                {
                    // End:0x155
                    if(mAttachment != none)
                    {
                        mAttachment.PlayDryFiringSound();
                        // End:0x155
                        if((tph != none) && TurokPlayerController(tph.Controller) != none)
                        {
                            player_hud = TurokHud(TurokPlayerController(tph.Controller).myHUD);
                            // End:0x155
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
        // End:0x43
        if(IsTimerActive('CanisterAutoDetonateTimer'))
        {
            ClearTimer('CanisterAutoDetonateTimer');
            // End:0x43
            if(Instigator != none)
            {
                CanisterAutoDetonateTimer();
            }
        }
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: TurokZoomComponent'Default__TurokWeapTazerNative.Zoom'
    begin object name=Zoom
    end object
    mZoomValues=Zoom
}