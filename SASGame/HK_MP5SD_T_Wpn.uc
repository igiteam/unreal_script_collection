//=============================================================================
// HK_MP5SD_T_Wpn.uc
//
// MP5SD Submachine Gun with torch.
//
// Modes:
//			Single
//			Auto
//
// Secondary Fire:
//			None
//=============================================================================

class HK_MP5SD_T_Wpn extends HK_MP5_SD_Wpn;


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mFPWeaponMeshClass=Class'HK_MP5SD_T_FPGunMesh'
    ShakeVert=(X=0.0000000,Y=100.0000000,Z=50.0000000)
    ShakeMag=60.0000000
    AttachmentClass=Class'HK_MP5SD_T_WpnAttach'
    ItemName="HK MP5SD T"
}