//=============================================================================
// Browning_BDA_WpnAttach.uc 
//
// 3rd person weapon attachment for browning pistol
//=============================================================================

class Browning_BDA_WpnAttach extends SASWeaponAttachment;

//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    mWeaponUpAnimRateScalar=1.4000000
    mWeaponDownAnimRateScalar=1.4000000
    mMuzzleEffectClass=Class'SASEffects.MuzzleFlash3P_P226Wpn'
    mMuzzleEffectOffset=(X=15.0000000,Y=0.0000000,Z=3.0000000)
    StaticMesh=StaticMesh'WpSm.Pistols.WpPs_browningL2'
}