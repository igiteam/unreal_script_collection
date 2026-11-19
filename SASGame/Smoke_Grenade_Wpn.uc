//=============================================================================
// Smoke_Grenade_Wpn.uc
//
//
// Modes:
//			Single
//
// Secondary Fire:
//			None
//=============================================================================

class Smoke_Grenade_Wpn extends SASGrenadeWeapon;


// Decompiled with UE Explorer.
defaultproperties
{
    mGrenadeCategory=3
    mHandAnims=MeshAnimation'WpAn.Hands_Grenade'
    mFPWeaponMeshClass=Class'Smoke_Grenade_FPGrenadeMesh'
    mLineartWeapon=Texture'HUDTx.Weapon_Lineart.HUD_WL_MK4Smoke'
    AmmoName=Class'Smoke_Grenade_Ammo'
    PickupAmmoCount=9999
    AttachmentClass=Class'Smoke_Grenade_WpnAttach'
    ItemName="Smoke Grenade"
}