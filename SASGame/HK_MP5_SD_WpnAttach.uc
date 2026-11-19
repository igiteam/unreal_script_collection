//=============================================================================
// HK_MP5_SD_WpnAttach.uc
//
// 3rd person weapon attachment for MP5-SD
//=============================================================================

class HK_MP5_SD_WpnAttach extends SASWeaponAttachment;


//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    mWeaponDownAnimRateScalar=1.4000000
    mMuzzleFlashClass=Class'SASEffects.MuzzleFlash3P_MP5Wpn'
    mMuzzleEffectClass=Class'SASEffects.MuzzleFlash3P_MP5SDWpn'
    mMuzzleEffectOffset=(X=32.0000000,Y=0.0000000,Z=6.0000000)
    StaticMesh=StaticMesh'WpSm.SubMachineGuns.WpSm_mp5SD_T_Revised_LOD2'
}