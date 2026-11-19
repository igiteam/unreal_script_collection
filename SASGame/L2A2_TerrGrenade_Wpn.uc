//=============================================================================
// L2A2_Grenade_Wpn.uc
//
// L2A2 Anit-Personnel hand-grenade weapon
//
// Modes:
//			Single
//
// Secondary Fire:
//			None
//=============================================================================

class L2A2_TerrGrenade_Wpn extends SASGrenadeWeapon;


//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    mGrenadeCategory=0
    mHandAnims=MeshAnimation'WpAn.Hands_Grenade'
    mFPWeaponMeshClass=Class'L2A2_FPGrenadeMesh'
    AmmoName=Class'L2A2_TerrGrenade_Ammo'
    PickupAmmoCount=2
    AttachmentClass=Class'L2A2_Grenade_WpnAttach'
    ItemName="L2A2 Hand Grenade"
}