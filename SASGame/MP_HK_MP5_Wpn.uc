//=============================================================================
// MP_HK_MP5_Wpn.uc
//
// Multiplayer HK MP5 Submachine Gun
// This is the base MP5 data, used for the vanilla gun.
// Lots of MP5 variants inherit from this class.
// Modes:
//			Single
//			Auto
//
// Secondary Fire:
//			None
//=============================================================================

class MP_HK_MP5_Wpn extends HK_MP5_Wpn;


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    AmmoName=Class'MP_HK_MP5_Ammo'
    PickupAmmoCount=60
}