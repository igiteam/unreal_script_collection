//=============================================================================
// HK_MP5_Blank_WpnAttach.uc
//
// 3rd person weapon attachment for MP5-Blank
//=============================================================================

class HK_MP5_Blank_WpnAttach extends SASWeaponAttachment;


//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    mMuzzleFlashClass=Class'SASEffects.MuzzleFlash3P_MP5Wpn'
    mMuzzleEffectClass=Class'SASEffects.MuzzleFlash3PEmitter_MP5Wpn'
    mMuzzleEffectOffset=(X=26.0000000,Y=0.0000000,Z=6.0000000)
    StaticMesh=StaticMesh'WpSm.SubMachineGuns.WpSm_mp5_BlankS_L2'
}