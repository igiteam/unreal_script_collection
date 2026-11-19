//=============================================================================
// HK_MP5K_LS_S_Wpn.uc
//
// MP5K Submachine Gun with Laser sight and scope.
// Pretty much everything should be inherited from the MP5K
// Modes:
//			Single
//			Auto
//
// Secondary Fire:
//			None
//=============================================================================

class HK_MP5K_LS_S_Wpn extends HK_MP5K_Wpn;


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mFPWeaponMeshClass=Class'HK_MP5K_LS_S_FPGunMesh'
    mSightedFovAdjust=-40.0000000
    mShotSpreadAngleModForSighted=0.1500000
    mLineartWeapon=Texture'HUDTx.Weapon_Lineart.HUD_WL_MP5KLSS'
    ShakeVert=(X=0.0000000,Y=100.0000000,Z=50.0000000)
    ShakeSpeed=(X=1000.0000000,Y=1000.0000000,Z=1000.0000000)
    mScopeClass=Class'Scope_MP5_S'
    ShakeMag=90.0000000
    AttachmentClass=Class'HK_MP5K_LS_S_WpnAttach'
    ItemName="HK MP5K LS S"
}