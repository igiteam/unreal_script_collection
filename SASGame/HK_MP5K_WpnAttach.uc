//=============================================================================
// HK_MP5K_WpnAttach.uc
//
// 3rd person weapon attachment for MP5K weapon.
//=============================================================================

class HK_MP5K_WpnAttach extends SASWeaponAttachment;

//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    mWeaponDownAnimRateScalar=1.4000000
    mMuzzleFlashClass=Class'SASEffects.MuzzleFlash3P_MP5Wpn'
    mMuzzleEffectClass=Class'SASEffects.MuzzleFlash3PEmitter_MP5Wpn'
    mMuzzleEffectOffset=(X=28.0000000,Y=0.0000000,Z=6.0000000)
    StaticMesh=StaticMesh'WpSm.SubMachineGuns.WpSm_MP5K_LOD2'
}