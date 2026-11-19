//=============================================================================
// AK47_WpnAttach.uc 
//
// 3rd person weapon attachment for AK47
//=============================================================================

class AK47_WpnAttach extends SASWeaponAttachment;


//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    mWeaponDownAnimRateScalar=1.4000000
    mMuzzleFlashClass=Class'SASEffects.MuzzleFlash3P_MP5Wpn'
    mMuzzleEffectClass=Class'SASEffects.MuzzleFlash3P_AK47Wpn'
    mMuzzleEffectOffset=(X=35.0000000,Y=0.0000000,Z=4.0000000)
    StaticMesh=StaticMesh'WpSm.AssaultRifles .WpAr_AK47L2'
}