//=============================================================================
// HK_MP5K_Wpn.uc
//
// HK_MP5K
//
// Modes:
//			Single
//			Auto
//
// Secondary Fire:
//			None
//=============================================================================

class HK_MP5K_Wpn extends HK_MP5_Wpn;

//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mSpecial3PReloadAnim="Stand_Reload_MP5K"
    mHandAnims=MeshAnimation'WpAn.HANDS_MP5K'
    mFPWeaponMeshClass=Class'HK_MP5K_FPGunMesh'
    mWeight=0.1000000
    mBaseStability=0.1200000
    mBaseCrouchStability=0.0800000
    mShotSpreadAngleNormal=190.0000000
    mShotSpreadAngleCrouch=110.0000000
    mShotSpreadAngleBurst=190.0000000
    mShotSpreadAngleModForSighted=0.2500000
    mShotSpreadAnglePenaltyForMovement=2800
    mShotSpreadAnglePenaltyDecay=4200.0000000
    mShotSpreadAngleMaxModForSprinting=1.4000000
    mLineartWeapon=Texture'HUDTx.Weapon_Lineart.HUD_WL_MP5K'
    mAimedShotRiseMin=65.0000000
    mAimedShotRiseMax=85.0000000
    mAimedShotYawMin=26.0000000
    mAimedShotYawMax=48.0000000
    mNormalShotRiseMin=98.0000000
    mNormalShotRiseMax=128.0000000
    mNormalShotYawMin=40.0000000
    mNormalShotYawMax=72.0000000
    mBurstShotRiseMin=146.0000000
    mBurstShotRiseMax=194.0000000
    mBurstShotYawMin=60.0000000
    mBurstShotYawMax=108.0000000
    ShakeVert=(X=20.0000000,Y=20.0000000,Z=20.0000000)
    ShakeSpeed=(X=10000.0000000,Y=10000.0000000,Z=10000.0000000)
    mFireSounds=/* Array type was not detected. */
    mBurstFireSounds=/* Array type was not detected. */
    PlayerViewOffset=(X=0.0000000,Y=-0.0600000,Z=0.0000000)
    AttachmentClass=Class'HK_MP5K_WpnAttach'
    ItemName="MP5"
}