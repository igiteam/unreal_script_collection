//
// AmmoPickupAssaultrRifle
//
// Ammunition pickup class.  
// When/after being placed in a level, it must have its AmmunitionClass property 
// set to the right type (e.g. SniperRifleAmmo) to determine what kind of ammo 
// will be picked up from this pickup.
//

class AmmoPickupAssaultRifle extends AmmoPickup
	placeable;


//=============================================================================

// Decompiled with UE Explorer.
defaultproperties
{
    AmmunitionClass=Class'AssaultRifleAmmo'
    bPickupOnlyIfAlreadyHaveWeapon=false
    InventoryType=Class'AssaultRifleAmmo'
    PickupMessage="You picked up some assault rifle ammo."
}