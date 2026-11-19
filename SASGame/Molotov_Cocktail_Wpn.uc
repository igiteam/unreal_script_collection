//=============================================================================
// Molotov_Cocktail_Wpn.uc
//
// Molotov cocktail hand-grenade weapon
//
// Modes:
//			Single
//
// Secondary Fire:
//			None
//=============================================================================

class Molotov_Cocktail_Wpn extends SASGrenadeWeapon;


//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    mGrenadeCategory=4
    mHandAnims=MeshAnimation'WpAn.Hands_Grenade'
    mFPWeaponMeshClass=Class'Molotov_Cocktail_FPGrenadeMesh'
    AmmoName=Class'Molotov_Cocktail_Ammo'
    PickupAmmoCount=9999
    AttachmentClass=Class'Molotov_Cocktail_WpnAttach'
    ItemName="Molotov Cocktail"
}