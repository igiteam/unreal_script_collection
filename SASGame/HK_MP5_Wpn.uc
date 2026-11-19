//=============================================================================
// HK_MP5_Wpn.uc
//
// HK MP5 Submachine Gun
// This is the base MP5 data, used for the vanilla gun.
// Lots of MP5 variants inherit from this class.
// Modes:
//			Single
//			Auto
//
// Secondary Fire:
//			None
//=============================================================================

class HK_MP5_Wpn extends SASWeapon;


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mCategory=0
    mHandAnims=MeshAnimation'WpAn.HANDS_MP5'
    mFPWeaponMeshClass=Class'HK_MP5_FPGunMesh'
    mCollisionPushBackMaxSighted=12.0000000
    mMagSize=30
    mAllowedFireModes=7
    mbToggleSighted=true
    mSightedFovAdjust=-30.0000000
    mWeight=0.1200000
    mBaseStability=0.1500000
    mBaseCrouchStability=0.1000000
    mShotSpreadAngleNormal=175.0000000
    mShotSpreadAngleCrouch=100.0000000
    mShotSpreadAngleBurst=175.0000000
    mShotSpreadAngleModForSighted=0.3000000
    mShotSpreadAnglePenaltyForMovement=3000
    mShotSpreadAnglePenaltyModForRotation=0.0176000
    mShotSpreadAnglePenaltyDecay=4000.0000000
    mShotSpreadAngleMax=2000.0000000
    mShotSpreadAngleMaxModForSprinting=1.5000000
    mLineartWeapon=Texture'HUDTx.Weapon_Lineart.HUD_WL_MP5'
    mAimedShotRiseMin=80.0000000
    mAimedShotRiseMax=107.0000000
    mAimedShotYawMin=33.0000000
    mAimedShotYawMax=60.0000000
    mNormalShotRiseMin=122.0000000
    mNormalShotRiseMax=162.0000000
    mNormalShotYawMin=50.0000000
    mNormalShotYawMax=90.0000000
    mBurstShotRiseMin=183.0000000
    mBurstShotRiseMax=243.0000000
    mBurstShotYawMin=75.0000000
    mBurstShotYawMax=135.0000000
    ShakeRate=12000.0000000
    ShakeIterations=1.0000000
    ShakeVert=(X=0.0000000,Y=100.0000000,Z=50.0000000)
    ShakeSpeed=(X=1000.0000000,Y=1000.0000000,Z=1000.0000000)
    mRoundsPerMinute=600.0000000
    mBurstsPerMinuteBurstMode=150.0000000
    mBurstAutoSightedFireAnim="1st_Fire2"
    mBurstAutoFireAnim="1st_Fire2_Ported"
    mMuzzleFlashClass=Class'SASEffects.MuzzleFlash_MP5Wpn'
    mShellEmitterClass=Class'SASEffects.ShellEject_MP5Wpn'
    mbHasTorch=true
    mbHasLaser=true
    mFireSounds=/* Array type was not detected. */
    mPickupImpactSounds=/* Array type was not detected. */
    AmmoName=Class'HK_MP5_Ammo'
    PickupAmmoCount=150
    AutoSwitchPriority=100
    ShakeMag=120.5000000
    ShakeTime=5.0000000
    CrossHair=Texture'WpTx.Crosshairs.TempCHair1'
    DisplayFOV=60.0000000
    AttachmentClass=Class'HK_MP5_WpnAttach'
    ItemName="HK MP5"
}