//=============================================================================
// M60_WpnAttach.uc 
//
// 3rd person weapon attachment for M60 weapon.
//=============================================================================

class M60_WpnAttach extends SASWeaponAttachment;

//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    mWeaponUpAnimRateScalar=0.8000000
    mMuzzleFlashClass=Class'SASEffects.MuzzleFlash3P_MP5Wpn'
    mMuzzleEffectClass=Class'SASEffects.MuzzleFlash3P_M60Wpn'
    mMuzzleEffectOffset=(X=46.0000000,Y=0.0000000,Z=6.0000000)
    StaticMesh=StaticMesh'WpSm.MachineGuns.WpMg_M60_LOD2'
}