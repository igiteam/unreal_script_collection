//=============================================================================
// HK_MP5_LS_S_WpnAttach.uc 
//
// 3rd person weapon attachment for HK MP5 (laser + scope) Sub-machinegun
//=============================================================================

class HK_MP5_LS_S_WpnAttach extends SASWeaponAttachment;

//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    mWeaponDownAnimRateScalar=1.4000000
    mMuzzleFlashClass=Class'SASEffects.MuzzleFlash3P_MP5Wpn'
    mMuzzleEffectClass=Class'SASEffects.MuzzleFlash3PEmitter_MP5Wpn'
    mMuzzleEffectOffset=(X=28.0000000,Y=0.0000000,Z=6.0000000)
    StaticMesh=StaticMesh'WpSm.SubMachineGuns.WpSm_mp5_LS_S_Revised_LOD2'
}