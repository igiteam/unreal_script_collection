class MOHASingleShotReloadWeapon extends EALASmallArms
    abstract
    config(Weapon)
    hidecategories(Navigation);

var(Tuning_Animations) config name WeaponReloadAnimIn;
var(Tuning_Animations) config name WeaponReloadAnimOut;
var(Tuning_Animations) config float WeaponReloadInTiming;
var(Tuning_Animations) config float WeaponReloadOutTiming;
var int iBulletsAddedPerReload;

function int GetRandDesiredPosture()
{
    return 0;
    //return ReturnValue;    
}

function int GetDesiredPosture()
{
    return 0;
    //return ReturnValue;    
}

function bool PlayLoopingReload()
{
    return true;
    //return ReturnValue;    
}

state WeaponReload
{
    simulated function BeginState(name PreviousStateName)
    {
        local WeaponAttachment WeapAttachment;

        // End:0x2D
        if((true == bAlternateFireMode) || !PlayLoopingReload())
        {
            super.BeginState(PreviousStateName);
            return;            
        }
        else
        {
            // End:0xA9
            if(WeaponReloadAnimIn != 'None')
            {
                SetTimer(WeaponReloadInTiming, false, 'EndReloadInTimer');
                PlayWeaponAnimation(WeaponReloadAnimIn, WeaponReloadInTiming);
                // End:0xA6
                if((Instigator != none) && Instigator.IsA('MOHAPlayerPawn'))
                {
                    MOHAPlayerPawn(Instigator).Weapon_ReloadInEvent();
                }                
            }
            else
            {
                BeginReloadLoop();
            }
        }
        WeapAttachment = GetWeaponAttachment();
        // End:0xE1
        if(WeapAttachment != none)
        {
            WeapAttachment.WeaponBeingReloaded();
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        ClearTimer('EndReloadInTimer');
        ClearTimer('EndReloadOutTimer');
        ClearTimer('EndReloadLoopTimer');
        //return;        
    }

    simulated function EndReloadInTimer()
    {
        // End:0x2F
        if(Instigator.IsA('MOHAPlayerPawn'))
        {
            MOHAPlayerPawn(Instigator).ActivityDoneEvent();
        }
        BeginReloadLoop();
        //return;        
    }

    simulated function BeginReloadLoop()
    {
        SetTimer(GetReloadInterval(), false, 'EndReloadLoopTimer');
        PlayWeaponAnimation(WeaponReloadAnim[GetReloadMode()], GetReloadInterval());
        // End:0x6E
        if(Instigator.IsA('MOHAPlayerPawn'))
        {
            MOHAPlayerPawn(Instigator).Weapon_ReloadEvent();
        }
        //return;        
    }

    simulated function EndReloadLoopTimer()
    {
        local int I;

        AddAmmo(iBulletsAddedPerReload);
        // End:0x3E
        if(Instigator.IsA('MOHAPlayerPawn'))
        {
            MOHAPlayerPawn(Instigator).ActivityDoneEvent();
        }
        I = 0;
        J0x45:

        // End:0x119 [Loop If]
        if(I < InvManager.PendingFire.Length)
        {
            // End:0x10F
            if((PendingFire(I)) && HasAmmo(byte(I)))
            {
                // End:0x103
                if(WeaponReloadAnimOut != 'None')
                {
                    // End:0xD6
                    if((Instigator != none) && Instigator.IsA('MOHAPlayerPawn'))
                    {
                        MOHAPlayerPawn(Instigator).Weapon_ReloadOutEvent();
                    }
                    SetTimer(WeaponReloadOutTiming, false, 'EndReloadOutTimer');
                    PlayWeaponAnimation(WeaponReloadAnimOut, WeaponReloadOutTiming);                    
                }
                else
                {
                    SetNextState();
                }
                return;
            }
            I++;
            // [Loop Continue]
            goto J0x45;
        }
        // End:0x148
        if((MaxAmmoCount[0] > AmmoCount[0]) && HasReserveAmmo())
        {
            BeginReloadLoop();            
        }
        else
        {
            // End:0x1C4
            if(WeaponReloadAnimOut != 'None')
            {
                // End:0x197
                if((Instigator != none) && Instigator.IsA('MOHAPlayerPawn'))
                {
                    MOHAPlayerPawn(Instigator).Weapon_ReloadOutEvent();
                }
                SetTimer(WeaponReloadOutTiming, false, 'EndReloadOutTimer');
                PlayWeaponAnimation(WeaponReloadAnimOut, WeaponReloadOutTiming);                
            }
            else
            {
                SetNextState();
            }
        }
        //return;        
    }

    simulated function EndReloadOutTimer(name NextState)
    {
        // End:0x2F
        if(Instigator.IsA('MOHAPlayerPawn'))
        {
            MOHAPlayerPawn(Instigator).ActivityDoneEvent();
        }
        SetNextState();
        //return;        
    }

    simulated function SetNextState()
    {
        // End:0x30
        if((IronsightsButtonDown()) && int(IronsightsState) == int(0))
        {
            GotoState('IronsightsIn');            
        }
        else
        {
            GotoState('Active');
        }
        //return;        
    }

    simulated function BeginFire(byte FireModeNum)
    {
        // End:0x45
        if((IsMeleeFiringMode(int(FireModeNum))) || !bAlternateFireMode && HasAmmo(FireModeNum))
        {
            SmallArmsBeginFire(FireModeNum);
        }
        //return;        
    }
    stop;    
}

defaultproperties
{
    iBulletsAddedPerReload=1
    // Reference: WeaponAccuracyComponent'Default__MOHASingleShotReloadWeapon.WeaponAccuracy'
    begin object name=WeaponAccuracy
    end object
    AccuracyComponent=WeaponAccuracy
    // Reference: WeaponAccuracyComponent'Default__MOHASingleShotReloadWeapon.IronsightsWeaponAccuracy'
    begin object name=IronsightsWeaponAccuracy
    end object
    IronsightsAccuracyComponent=IronsightsWeaponAccuracy
    // Reference: WeaponKickComponent'Default__MOHASingleShotReloadWeapon.WeaponKick'
    begin object name=WeaponKick
    end object
    KickComponent=WeaponKick
    // Reference: WeaponKickComponent'Default__MOHASingleShotReloadWeapon.IronsightsWeaponKick'
    begin object name=IronsightsWeaponKick
    end object
    IronsightsKickComponent=IronsightsWeaponKick
    // Reference: WhizSenderComponent'Default__MOHASingleShotReloadWeapon.whiz'
    begin object name=whiz
    end object
    WhizComponent=whiz
    BulletImpactStimulusThreat=5.0000000
    AttachmentClass=Class'SingleShotReloadWeaponAttachment'
    NPCWeaponTypeIndex=2
    // Reference: MOHASkeletalMeshComponent'Default__MOHASingleShotReloadWeapon.PickupMesh'
    begin object name=PickupMesh
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=WeaponAccuracy
    Components[1]=IronsightsWeaponAccuracy
    Components[2]=WeaponKick
    Components[3]=IronsightsWeaponKick
}