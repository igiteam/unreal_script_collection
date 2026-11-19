//=============================================================================
// HK_MP5_Blank_Wpn.uc
//
// MP5-Blank Submachine Gun
// Lots of stuff should be inherited from the MP5
// Modes:
//			Single
//			Auto
//
// Secondary Fire:
//			None
//=============================================================================

class HK_MP5_Blank_Wpn extends HK_MP5_Wpn;


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mHandAnims=MeshAnimation'WpAn.HANDS_AK47'
    mFPWeaponMeshClass=Class'HK_MP5_Blank_FPGunMesh'
    mFireSounds=/* Array type was not detected. */
    mBurstFireSounds=/* Array type was not detected. */
    AmmoName=Class'HK_MP5_Blank_Ammo'
    AttachmentClass=Class'HK_MP5_Blank_WpnAttach'
    ItemName="MP5-10"
}