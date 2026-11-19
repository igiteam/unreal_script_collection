//=============================================================================
// L13A1_Gas_Grenade_Wpn.uc
//
// L13A1 CS Gas grenade weapon
//
// Modes:
//			Single
//
// Secondary Fire:
//			None
//=============================================================================

class L13A1_Gas_Grenade_Wpn extends SASGrenadeWeapon;


//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    mGrenadeCategory=2
    mHandAnims=MeshAnimation'WpAn.Hands_Grenade'
    mFPWeaponMeshClass=Class'L13A1_FPGrenadeMesh'
    mLineartWeapon=Texture'HUDTx.Weapon_Lineart.HUD_WL_CSGas'
    AmmoName=Class'L13A1_Gas_Grenade_Ammo'
    PickupAmmoCount=2
    AttachmentClass=Class'L13A1_Gas_Grenade_WpnAttach'
    ItemName="L13A1 CS Gas"
}