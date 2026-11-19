//=============================================================================
// HK_MP5SD_LS_S_Wpn.uc
//
// MP5SD Submachine Gun with Laser sight and scope.
// Pretty much everything should be inherited from the HK_MP5SD
// Modes:
//			Single
//			Auto
//
// Secondary Fire:
//			None
//=============================================================================

class HK_MP5SD_LS_S_Wpn extends HK_MP5_SD_Wpn;


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mFPWeaponMeshClass=Class'HK_MP5SD_LS_S_FPGunMesh'
    mSightedFovAdjust=-40.0000000
    mShotSpreadAngleModForSighted=0.1500000
    mLineartWeapon=Texture'HUDTx.Weapon_Lineart.HUD_WL_MP5SDLSST'
    mScopeClass=Class'Scope_MP5_S'
    AttachmentClass=Class'HK_MP5SD_LS_S_WpnAttach'
    ItemName="HK MP5SD LS S"
}