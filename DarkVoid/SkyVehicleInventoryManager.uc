class SkyVehicleInventoryManager extends SkyBaseInventoryManager
    native
    config(Game);

var int PendingSecondaryFire;
var Weapon PendingSecondaryWeapon;
var Weapon LastAttemptedSwitchToSecondaryWeapon;
var transient bool bInstigatorCanHaveSecondary;

// Export USkyVehicleInventoryManager::execStopSecondaryFire(FFrame&, void* const)
native final function StopSecondaryFire(byte FireModeNum);

simulated function SetCurrentSecondaryWeapon(Weapon DesiredWeapon)
{
    local Weapon OldWeapon;

    OldWeapon = SkyVehicle(Instigator).SkySeats[0].SecondaryGun;
    OldWeapon.GotoState('Inactive');
    SkyVehicle(Instigator).SkySeats[0].SecondaryGun = SkyVWeap(DesiredWeapon);
    // End:0x9F
    if(DesiredWeapon != none)
    {
        DesiredWeapon.Instigator = Instigator;
        DesiredWeapon.Activate();
    }
    // End:0xF8
    if(Instigator.Controller != none)
    {
        Instigator.Controller.NotifyChangedWeapon(OldWeapon, SkyVehicle(Instigator).SkySeats[0].SecondaryGun);
    }
    //return;    
}

reliable server function ServerSetCurrentSecondaryWeapon(Weapon DesiredWeapon)
{
    SetPendingSecondaryWeapon(DesiredWeapon);
    //return;    
}

simulated function SetPendingSecondaryWeapon(Weapon DesiredWeapon)
{
    //return;    
}

simulated function ChangedSecondaryWeapon()
{
    //return;    
}

simulated function bool AddInventory(Inventory NewItem, optional bool bDoNotActivate)
{
    return super(InventoryManager).AddInventory(NewItem, bDoNotActivate);
    //return ReturnValue;    
}

reliable client simulated event SetCurrentWeapon(Weapon DesiredWeapon)
{
    local Weapon OldWeapon;

    OldWeapon = SkyVehicle(Instigator).Seats[0].Gun;
    OldWeapon.GotoState('Inactive');
    SkyVehicle(Instigator).Seats[0].Gun = SkyVWeap(DesiredWeapon);
    Instigator.Weapon = DesiredWeapon;
    // End:0xB4
    if(DesiredWeapon != none)
    {
        DesiredWeapon.Instigator = Instigator;
        DesiredWeapon.Activate();
    }
    // End:0x10D
    if(Instigator.Controller != none)
    {
        Instigator.Controller.NotifyChangedWeapon(OldWeapon, SkyVehicle(Instigator).Seats[0].Gun);
    }
    //return;    
}
