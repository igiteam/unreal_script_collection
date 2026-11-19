//=============================================================================
// M1100_WpnAttach.uc 
//
// 3rd person weapon attachment for M1100 shotgun
//=============================================================================

class M1100_WpnAttach extends SASWeaponAttachment;

//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    mWeaponDownAnimRateScalar=1.4000000
    mMuzzleFlashClass=Class'SASEffects.MuzzleFlash3P_MP5Wpn'
    mMuzzleEffectClass=Class'SASEffects.MuzzleFlash3P_AK47Wpn'
    mMuzzleEffectOffset=(X=28.0000000,Y=0.0000000,Z=4.0000000)
    StaticMesh=StaticMesh'WpSm.Shotguns.WpSg_Maruzen_LOD2'
}