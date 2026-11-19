//=============================================================================
// G3SG1_WpnAttach.uc
//
// 3rd person weapon attachment for HK G3SG1 Assault Rifle
//=============================================================================

class G3SG1_WpnAttach extends SASWeaponAttachment;

//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    mWeaponDownAnimRateScalar=1.4000000
    mMuzzleFlashClass=Class'SASEffects.MuzzleFlash3P_MP5Wpn'
    mMuzzleEffectClass=Class'SASEffects.MuzzleFlash3P_AK47Wpn'
    mMuzzleEffectOffset=(X=40.0000000,Y=0.0000000,Z=4.0000000)
    StaticMesh=StaticMesh'WpSm.AssaultRifles .WpAr_G3SG1_L2'
}