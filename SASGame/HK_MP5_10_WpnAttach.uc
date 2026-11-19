//=============================================================================
// HK_MP5_10_WpnAttach.uc 
//
// 3rd person weapon attachment for MP5-10
//=============================================================================

class HK_MP5_10_WpnAttach extends SASWeaponAttachment;


//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    mWeaponDownAnimRateScalar=1.4000000
    mMuzzleFlashClass=Class'SASEffects.MuzzleFlash3P_MP5Wpn'
    mMuzzleEffectClass=Class'SASEffects.MuzzleFlash3PEmitter_MP5Wpn'
    mMuzzleEffectOffset=(X=26.0000000,Y=0.0000000,Z=6.0000000)
    StaticMesh=StaticMesh'WpSm.AssaultRifles .WpAr_AK47L2'
}