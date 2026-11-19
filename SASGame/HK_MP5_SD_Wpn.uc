//=============================================================================
// HK_MP5_SD_Wpn.uc
//
// MP5-SD Submachine Gun
// Lots of stuff should be inherited from the MP5
// Modes:
//			Single
//			Auto
//
// Secondary Fire:
//			None
//=============================================================================

class HK_MP5_SD_Wpn extends HK_MP5_Wpn;


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mHandAnims=MeshAnimation'WpAn.HANDS_MP5SD'
    mFPWeaponMeshClass=Class'HK_MP5_SD_FPGunMesh'
    mLineartWeapon=Texture'HUDTx.Weapon_Lineart.HUD_WL_MP5SDT'
    ShakeVert=(X=0.0000000,Y=90.0000000,Z=40.0000000)
    mMuzzleFlashClass=Class'SASEffects.MuzzleFlash_MP5SDWpn'
    mFireSounds=/* Array type was not detected. */
    mBurstFireSounds=/* Array type was not detected. */
    AmmoName=Class'HK_MP5_SD_Ammo'
    ShakeMag=110.5000000
    AttachmentClass=Class'HK_MP5_SD_WpnAttach'
    ItemName="MP5-SD"
}