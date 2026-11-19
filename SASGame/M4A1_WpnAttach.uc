//=============================================================================
// M4A1_WpnAttach.uc 
//
// 3rd person weapon attachment for M4A1 weapon.
//=============================================================================

class M4A1_WpnAttach extends SASWeaponAttachment;

//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    mWeaponDownAnimRateScalar=1.4000000
    mMuzzleFlashClass=Class'SASEffects.MuzzleFlash3P_MP5Wpn'
    mMuzzleEffectClass=Class'SASEffects.MuzzleFlash3P_AK47Wpn'
    mMuzzleEffectOffset=(X=34.0000000,Y=0.0000000,Z=6.0000000)
    StaticMesh=StaticMesh'WpSm.AssaultRifles .WpAr_M4A1_LOD2'
}