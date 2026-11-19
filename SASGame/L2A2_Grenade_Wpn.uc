//=============================================================================
// L2A2_Grenade_Wpn.uc
//
// L2A2 Anti-Personnel hand-grenade weapon
//
// Modes:
//			Single
//
// Secondary Fire:
//			None
//=============================================================================

class L2A2_Grenade_Wpn extends SASGrenadeWeapon;


//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    mGrenadeCategory=0
    mHandAnims=MeshAnimation'WpAn.Hands_Grenade'
    mFPWeaponMeshClass=Class'L2A2_FPGrenadeMesh'
    mLineartWeapon=Texture'HUDTx.Weapon_Lineart.HUD_WL_Frag'
    AmmoName=Class'L2A2_Grenade_Ammo'
    PickupAmmoCount=2
    AttachmentClass=Class'L2A2_Grenade_WpnAttach'
    ItemName="L2A2 Hand Grenade"
}