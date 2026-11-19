class TurokWeapSmgNative extends TurokWeapon
    native
    config(WeapSmg)
    hidecategories(Navigation);

enum ESMGAttackType
{
    SAT_Regular,                    // 0
    SAT_Silenced,                   // 1
    SAT_ChangeSilencer,             // 2
    SAT_MAX                         // 3
};

var bool mbSilenced;
var bool mBlink;
var(Animations) float mEnableSilencerTime;
var(Animations) @NULL mSilencerEquipAnim;
var(Animations) @NULL mSilencerUnEquipAnim;
var config float mStealthFootStepNoiseMultiplier;
var config float mStealthFootStepVolumeMultiplier;
var export editinline @NULL mSilencerMesh;
var() name mSilencerBoneName;
var @NULL mAmmoLightMI;
var @NULL mAmmoLightMIOther;

simulated function SetHidden(bool bNewHidden)
{
    super(Actor).SetHidden(bNewHidden);
    // End:0x2F
    if(!bNewHidden && mbSilenced)
    {
        ShowSilencer();        
    }
    else
    {
        HideSilencer();
    }
    //return;    
}

// Export UTurokWeapSmgNative::execSetWeaponVisibility(FFrame&, void* const)
native function SetWeaponVisibility(bool bVisible);

// Export UTurokWeapSmgNative::execShowSilencer(FFrame&, void* const)
native function ShowSilencer();

// Export UTurokWeapSmgNative::execHideSilencer(FFrame&, void* const)
native function HideSilencer();

simulated function AttachWeapon()
{
    super.AttachWeapon();
    // End:0x104
    if((Instigator != none) && Instigator.IsLocallyControlled())
    {
        // End:0xF4
        if(mWeaponMesh != none)
        {
            mAmmoLightMI = new (none) Class'Engine.MaterialInstanceConstant';
            mAmmoLightMI.SetParent(mWeaponMesh.GetMaterial(0));
            mWeaponMesh.SetMaterial(0, mAmmoLightMI);
            SetMaterialDepth(mAmmoLightMI, -0.5000000);
            mAmmoLightMIOther = new (none) Class'Engine.MaterialInstanceConstant';
            mAmmoLightMIOther.SetParent(mWeaponMesh.GetMaterial(1));
            mWeaponMesh.SetMaterial(1, mAmmoLightMIOther);
            SetMaterialDepth(mAmmoLightMIOther, -0.5000000);
        }
        SetAmmoIndicatorLightColor(mBlink);
    }
    //return;    
}

simulated function DetachWeapon()
{
    mAmmoLightMI = none;
    mAmmoLightMIOther = none;
    super.DetachWeapon();
    //return;    
}

// Export UTurokWeapSmgNative::execFireAmmunition(FFrame&, void* const)
native function FireAmmunition();

// Export UTurokWeapSmgNative::execHasAmmo(FFrame&, void* const)
native function bool HasAmmo(byte FireModeNum, optional int Amount);

// Export UTurokWeapSmgNative::execConsumeAmmo(FFrame&, void* const)
native function ConsumeAmmo(byte FireModeNum);

// Export UTurokWeapSmgNative::execSetAmmoIndicatorLightColor(FFrame&, void* const)
native function SetAmmoIndicatorLightColor(bool forceBlack);

simulated function AmmoBlinkTimer()
{
    mBlink = !mBlink;
    SetAmmoIndicatorLightColor(mBlink);
    //return;    
}

simulated function StopFire(byte FireModeNum)
{
    // End:0x18
    if(int(FireModeNum) == 0)
    {
        super.StopFire(FireModeNum);
    }
    //return;    
}

simulated function BeginFire(byte FireModeNum)
{
    // End:0x18
    if(int(FireModeNum) == 0)
    {
        super.BeginFire(FireModeNum);
    }
    //return;    
}

// Export UTurokWeapSmgNative::execGetFiringModeForFxIndex(FFrame&, void* const)
native function byte GetFiringModeForFxIndex();

simulated function DeactivateWeaponBegin()
{
    ClearTimer('ToggleSilenced');
    ClearTimer('DWShowHideSilencerMesh');
    //return;    
}

simulated function FinishPuttingDownWeapon()
{
    TurokPawnHuman(Instigator).WeaponSetSilencer(false, mEquippedInHand);
    super.FinishPuttingDownWeapon();
    //return;    
}

simulated event bool GetIsStealthWeapon()
{
    return mbSilenced;
    //return ReturnValue;    
}

simulated event float GetFootStepNoiseMultiplier()
{
    // End:0x12
    if(mbSilenced)
    {
        return mStealthFootStepNoiseMultiplier;        
    }
    else
    {
        return mFootStepNoiseMultiplier;
    }
    //return ReturnValue;    
}

simulated function float GetFootStepVolumeMultiplier()
{
    // End:0x12
    if(mbSilenced)
    {
        return mStealthFootStepVolumeMultiplier;        
    }
    else
    {
        return mFootStepVolumeMultiplier;
    }
    //return ReturnValue;    
}

simulated state Active
{
    simulated function BeginState(name PreviousStateName)
    {
        local int I, mode;

        // End:0x3B
        if(TurokPlayerController(Instigator.Controller) != none)
        {
            TurokPlayerController(Instigator.Controller).RequestSetPlayerCanPickupInventory(true);
        }
        // End:0x51
        if(bWeaponPutDown)
        {
            PutDownWeapon();            
        }
        else
        {
            // End:0x90
            if((mCurrentClipAmmo == 0) && int(GetFiringMode()) == 0)
            {
                // End:0x8D
                if(PreviousStateName != 'ChangingSilencer')
                {
                    WeaponEmpty();
                }                
            }
            else
            {
                I = 0;
                J0x97:

                // End:0x10D [Loop If]
                if(I < InvManager.PendingFire.Length)
                {
                    // End:0x103
                    if(PendingFire(I))
                    {
                        // End:0xE4
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
                        goto J0x10D;
                    }
                    I++;
                    // [Loop Continue]
                    goto J0x97;
                }
            }
        }
        J0x10D:

        //return;        
    }

    simulated function BeginFire(byte FireModeNum)
    {
        // End:0x1B
        if(int(FireModeNum) == 0)
        {
            super.BeginFire(FireModeNum);            
        }
        else
        {
            // End:0x36
            if(int(FireModeNum) == 1)
            {
                GotoState('ChangingSilencer');
            }
        }
        //return;        
    }
    stop;    
}

simulated state ChangingSilencer
{
    simulated event bool CanThrowGrenade()
    {
        return false;
        //return ReturnValue;        
    }

    simulated function InterruptWeaponAction()
    {
        GotoState('Active');
        //return;        
    }

    simulated function ToggleSilenced()
    {
        mbSilenced = !mbSilenced;
        // End:0x2F
        if(!mbIsDualWielding)
        {
            // End:0x2F
            if(!mbSilenced)
            {
                HideSilencer();
            }
        }
        // End:0x73
        if(TurokPlayerController(Instigator.Controller) != none)
        {
            TurokPlayerController(Instigator.Controller).mZoomer.EnableSlideZoom(true);
        }
        GotoState('Active');
        //return;        
    }

    simulated function DWShowHideSilencerMesh()
    {
        // End:0x16
        if(mbSilenced)
        {
            HideSilencer();            
        }
        else
        {
            ShowSilencer();
        }
        //return;        
    }

    simulated function bool TryPutDown()
    {
        bWeaponPutDown = true;
        GotoState('Active');
        return true;
        //return ReturnValue;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        local float toggleTime;
        local @NULL invMngr;

        HideReticle();
        // End:0x4F
        if(mbSilenced)
        {
            toggleTime = mDisableSilencerTime;
            PlayPOVAnimation(mSilencerUnEquipAnim, toggleTime, toggleTime * 0.1000000, toggleTime * 0.1000000, true, false);            
        }
        else
        {
            toggleTime = mEnableSilencerTime;
            // End:0x85
            if(!mbIsDualWielding)
            {
                // End:0x85
                if(Instigator.IsFirstPerson())
                {
                    ShowSilencer();
                }
            }
            PlayPOVAnimation(mSilencerEquipAnim, toggleTime, toggleTime * 0.1000000, toggleTime * 0.1000000, true, false);
        }
        TurokPawnHuman(Instigator).WeaponChangeSilencer(!mbSilenced, mEquippedInHand);
        // End:0x17A
        if(TurokPlayerController(Instigator.Controller) != none)
        {
            TurokPlayerController(Instigator.Controller).mZoomer.EnableSlideZoom(false);
            TurokPlayerController(Instigator.Controller).RequestSetPlayerCanPickupInventory(false);
            invMngr = TurokInventoryManager(TurokPawnHuman(Instigator).InvManager);
            // End:0x17A
            if(invMngr != none)
            {
                invMngr.CancelWeaponSwapping();
            }
        }
        SetTimer(toggleTime * 0.9000000, false, 'ToggleSilenced');
        // End:0x1B7
        if(mbIsDualWielding)
        {
            SetTimer(toggleTime / 2.0000000, false, 'DWShowHideSilencerMesh');
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        local @NULL Pickup;

        ShowReticle();
        ClearTimer('ToggleSilenced');
        ClearTimer('DWShowHideSilencerMesh');
        // End:0x10E
        if(TurokPlayerController(Instigator.Controller) != none)
        {
            TurokPlayerController(Instigator.Controller).mZoomer.EnableSlideZoom(true);
            TurokPlayerController(Instigator.Controller).RequestSetPlayerCanPickupInventory(true);
            // End:0x10D
            foreach Instigator.TouchingActors(Class'Engine.Actor', Pickup)
            {
                // End:0x10C
                if(Pickup.IsA('DroppedPickup') || Pickup.IsA('PickupFactory'))
                {
                    Pickup.Touch(Instigator, Instigator.Location, vect(0.0000000, 0.0000000, 1.0000000));
                }                
            }            
        }
        //return;        
    }
    stop;    
}

simulated state Reloading
{
    simulated function EndState(name NextStateName)
    {
        SetAmmoIndicatorLightColor(mBlink);
        super.EndState(NextStateName);
        //return;        
    }
    stop;    
}

simulated state WeaponEquipping
{
    simulated function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        TurokPawnHuman(Instigator).WeaponSetSilencer(mbSilenced, mEquippedInHand);
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: TurokZoomComponent'Default__TurokWeapSmgNative.Zoom'
    begin object name=Zoom
    end object
    mZoomValues=Zoom
}