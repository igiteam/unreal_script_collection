//=============================================================================
// MAC11_WpnAttach.uc 
//
// 3rd person weapon attachment for MAC11 weapon.
//=============================================================================

class MAC11_WpnAttach extends SASWeaponAttachment;

//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    mWeaponUpAnimRateScalar=1.1000000
    mWeaponDownAnimRateScalar=1.4000000
    mMuzzleFlashClass=Class'SASEffects.MuzzleFlash3P_MP5Wpn'
    mMuzzleEffectClass=Class'SASEffects.MuzzleFlash3PEmitter_MP5Wpn'
    mMuzzleEffectOffset=(X=16.0000000,Y=0.0000000,Z=3.0000000)
    StaticMesh=StaticMesh'WpSm.SubMachineGuns.WpSm_Mac11_LOD2'
}