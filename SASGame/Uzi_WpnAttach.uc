//=============================================================================
// Uzi_WpnAttach.uc
//
// 3rd person weapon attachment for uzi weapon.
//=============================================================================

class Uzi_WpnAttach extends SASWeaponAttachment;

//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    mWeaponUpAnimRateScalar=1.1000000
    mWeaponDownAnimRateScalar=1.4000000
    mMuzzleFlashClass=Class'SASEffects.MuzzleFlash3P_MP5Wpn'
    mMuzzleEffectClass=Class'SASEffects.MuzzleFlash3PEmitter_MP5Wpn'
    mMuzzleEffectOffset=(X=20.0000000,Y=0.0000000,Z=2.0000000)
    StaticMesh=StaticMesh'WpSm.SubMachineGuns.WpSm_UZI_Fol_Revised_LOD2'
}