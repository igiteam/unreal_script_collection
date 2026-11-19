//=============================================================================
// SOCOM_WpnAttach.uc 
//
// 3rd person weapon attachment for SOCOM pistol.
//=============================================================================

class SOCOM_WpnAttach extends SASWeaponAttachment;

//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    mWeaponUpAnimRateScalar=1.4000000
    mWeaponDownAnimRateScalar=1.4000000
    mMuzzleFlashClass=Class'SASEffects.MuzzleFlash3P_MP5Wpn'
    mMuzzleEffectClass=Class'SASEffects.MuzzleFlash3P_MP5SDWpn'
    mMuzzleEffectOffset=(X=24.0000000,Y=0.0000000,Z=6.0000000)
    StaticMesh=StaticMesh'WpSm.Pistols.WpPs_SOCOM_LOD2'
}