//
// AmmoPickupPistol
//
// Ammunition pickup class.  
// When/after being placed in a level, it must have its AmmunitionClass property 
// set to the right type (e.g. SniperRifleAmmo) to determine what kind of ammo 
// will be picked up from this pickup.
//

class AmmoPickupPistol extends AmmoPickup
	placeable;


//=============================================================================

// Decompiled with UE Explorer.
defaultproperties
{
    AmmunitionClass=Class'PistolAmmo'
    bPickupOnlyIfAlreadyHaveWeapon=false
    NominalProbability=0.3000000
    InventoryType=Class'PistolAmmo'
    PickupMessage="You picked up some pistol ammo."
}