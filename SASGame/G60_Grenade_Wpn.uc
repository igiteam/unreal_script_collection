//=============================================================================
// G60_Grenade_Wpn.uc
//
// G60 'Flash-bang' hand-grenade weapon
//
// Modes:
//			Single
//
// Secondary Fire:
//			None
//=============================================================================

class G60_Grenade_Wpn extends SASGrenadeWeapon;


//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    mGrenadeCategory=1
    mHandAnims=MeshAnimation'WpAn.HANDS_FLASHBANG'
    mFPWeaponMeshClass=Class'G60_Grenade_FPGrenadeMesh'
    mLineartWeapon=Texture'HUDTx.Weapon_Lineart.HUD_WL_Flashbang'
    AmmoName=Class'G60_Grenade_Ammo'
    PickupAmmoCount=4
    AttachmentClass=Class'G60_Grenade_WpnAttach'
    ItemName="G60 Flashbang"
}