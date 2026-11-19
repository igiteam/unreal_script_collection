class TurokWeapHandgunNative extends TurokWeapon
    native
    config(WeapHandGun)
    hidecategories(Navigation);

var int mBurstFireCount;
var() int mBurstFireMax;
var() float mBurstFireRoundInterval;
var() float mBurstFireBurstInterval;
var private @NULL mPlayback;
var bool mBlink;

// Export UTurokWeapHandgunNative::execConsumeAmmo(FFrame&, void* const)
native function ConsumeAmmo(byte FireModeNum);

// Export UTurokWeapHandgunNative::execHasAmmo(FFrame&, void* const)
native function bool HasAmmo(byte FireModeNum, optional int Amount);

// Export UTurokWeapHandgunNative::execTimeWeaponFiring(FFrame&, void* const)
native function TimeWeaponFiring(byte FireModeNum);

// Export UTurokWeapHandgunNative::execRefreshPlayback(FFrame&, void* const)
native function RefreshPlayback();

simulated function AttachWeapon()
{
    super.AttachWeapon();
    // End:0xAF
    if((Instigator != none) && Instigator.IsLocallyControlled())
    {
        // End:0xA5
        if(mWeaponMesh != none)
        {
            SetTimer(0.2000000, true, 'AmmoBlinkTimer');
            mPlayback = new (none) Class'Engine.MaterialInstanceConstant';
            mPlayback.SetParent(mWeaponMesh.GetMaterial(1));
            mWeaponMesh.SetMaterial(1, mPlayback);
            SetMaterialDepth(mPlayback, -0.5000000);
        }
        RefreshPlayback();
    }
    //return;    
}

simulated function DetachWeapon()
{
    ClearTimer('AmmoBlinkTimer');
    mPlayback = none;
    super.DetachWeapon();
    //return;    
}

// Export UTurokWeapHandgunNative::execFireAmmunition(FFrame&, void* const)
native function FireAmmunition();

simulated function AmmoBlinkTimer()
{
    mBlink = !mBlink;
    RefreshPlayback();
    //return;    
}

simulated function DeactivateWeaponBegin()
{
    ClearTimer('BurstFireRoundIntervalTimer');
    //return;    
}

simulated state Reloading
{
    simulated function EndState(name NextStateName)
    {
        RefreshPlayback();
        super.EndState(NextStateName);
        //return;        
    }
    stop;    
}

simulated state WeaponFiring
{
    simulated function BeginBurstFire()
    {
        local editinline @NULL WeaponAttachment;

        WeaponAttachment = TurokWeapAttachHandgunNative(GetAttachment());
        // End:0xB3
        if(mCurrentClipAmmo > 0)
        {
            mBurstFireCount = mBurstFireMax;
            ClearTimer('RefireCheckTimer');
            WeaponAttachment.mAltFireSndIndex = mBurstFireMax - mBurstFireCount;
            // End:0x81
            if(mCurrentClipAmmo < mBurstFireCount)
            {
                WeaponAttachment.mAltFireSndIndex += (mBurstFireCount - mCurrentClipAmmo);
            }
            FireAmmunition();
            // End:0xB3
            if(!IsTimerActive('BurstFireRoundIntervalTimer'))
            {
                SetTimer(mBurstFireRoundInterval, true, 'BurstFireRoundIntervalTimer');
            }
        }
        //return;        
    }

    simulated function BurstFireRoundIntervalTimer()
    {
        local int currFireMode;
        local editinline @NULL WeaponAttachment;

        WeaponAttachment = TurokWeapAttachHandgunNative(GetAttachment());
        currFireMode = int(GetFiringMode());
        // End:0x92
        if((mCurrentClipAmmo > 0) && mBurstFireCount > 0)
        {
            WeaponAttachment.mAltFireSndIndex = mBurstFireMax - mBurstFireCount;
            // End:0x85
            if(mCurrentClipAmmo < mBurstFireCount)
            {
                WeaponAttachment.mAltFireSndIndex += (mBurstFireCount - mCurrentClipAmmo);
            }
            FireAmmunition();            
        }
        else
        {
            ClearTimer('BurstFireRoundIntervalTimer');
            // End:0xC8
            if(!IsTimerActive('RefireCheckTimer'))
            {
                TimeWeaponFiring(byte(currFireMode));
            }
        }
        //return;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        local int currFireMode;

        currFireMode = int(GetFiringMode());
        // End:0x2A
        if(currFireMode == 1)
        {
            BeginBurstFire();            
        }
        else
        {
            super.BeginState(PreviousStateName);
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        local editinline @NULL WeaponAttachment;

        WeaponAttachment = TurokWeapAttachHandgunNative(GetAttachment());
        WeaponAttachment.mAltFireSndIndex = 0;
        ClearTimer('BurstFireRoundIntervalTimer');
        super.EndState(NextStateName);
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: TurokZoomComponent'Default__TurokWeapHandgunNative.Zoom'
    begin object name=Zoom
    end object
    mZoomValues=Zoom
}