//=============================================================================
// HK_MP5SD_T_WpnAttach.uc 
//
// 3rd person weapon attachment for HK MP5SD (torch) Sub-machinegun
//=============================================================================

class HK_MP5SD_T_WpnAttach extends SASWeaponAttachment;

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