class SkyItem_HealthPack extends SkySecondaryItem
    native
    config(Game);

var int HealthHealed;

simulated function bool IsFullHealth()
{
    return Instigator.Health == Instigator.Class.default.Health;
    //return ReturnValue;    
}

simulated function bool ShouldRefire()
{
    return !IsFullHealth();
    //return ReturnValue;    
}

simulated state WeaponFiring
{
    simulated function RefireCheckTimer()
    {
        // End:0x15
        if(bWeaponPutDown)
        {
            PutDownWeapon();
            return;
        }
        // End:0x2E
        if(ShouldRefire())
        {
            FireAmmunition();
            return;
        }
        GotoState('Active');
        // End:0x55
        if(!HasAnyAmmo())
        {
            WeaponEmpty();
        }
        //return;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        FireAmmunition();
        TimeWeaponFiring(CurrentFireMode);
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        ClearFlashCount();
        ClearFlashLocation();
        ClearTimer('RefireCheckTimer');
        //return;        
    }
    stop;    
}

simulated state Active
{
    simulated function BeginFire(byte FireModeNum)
    {
        // End:0x1C
        if((IsFullHealth()) || AmmoCount <= 0)
        {
            return;
        }
        super.BeginFire(FireModeNum);
        //return;        
    }
    stop;    
}
