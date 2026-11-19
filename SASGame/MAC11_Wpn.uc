//=============================================================================
// MAC11_Wpn.uc
//
// MAC11
//
// Modes:
//			Single
//			Auto
//
// Secondary Fire:
//			None
//=============================================================================

class MAC11_Wpn extends SASWeapon;

//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mCategory=0
    me3PAnimSet=2
    mSpecial3PReloadAnim="Stand_Reload_Mac11"
    mHandAnims=MeshAnimation'WpAn.HANDS_MAC11'
    mFPWeaponMeshClass=Class'MAC11_FPGunMesh'
    mMagSize=30
    mFireMode=2
    mAllowedFireModes=5
    mDiscardMagThreshold=10
    mBurstEmptyThreshold=3
    mbToggleSighted=true
    mSightedFovAdjust=-30.0000000
    mWeight=0.0500000
    mBaseStability=0.0800000
    mBaseCrouchStability=0.0400000
    mShotSpreadAngleNormal=315.0000000
    mShotSpreadAngleCrouch=180.0000000
    mShotSpreadAngleModForSighted=0.7500000
    mShotSpreadAnglePenaltyForMovement=2520
    mShotSpreadAnglePenaltyModForRotation=0.0260000
    mShotSpreadAnglePenaltyDecay=5040.0000000
    mShotSpreadAngleMax=1800.0000000
    mShotSpreadAngleMaxModForSprinting=1.5000000
    mLineartWeapon=Texture'HUDTx.Weapon_Lineart.HUD_WL_MAC11'
    mAimedShotRiseMin=120.0000000
    mAimedShotRiseMax=280.0000000
    mAimedShotYawMin=-33.0000000
    mAimedShotYawMax=66.0000000
    mNormalShotRiseMin=120.0000000
    mNormalShotRiseMax=280.0000000
    mNormalShotYawMin=-50.0000000
    mNormalShotYawMax=100.0000000
    ShakeRate=12000.0000000
    ShakeIterations=1.0000000
    ShakeVert=(X=0.0000000,Y=100.0000000,Z=50.0000000)
    ShakeSpeed=(X=1000.0000000,Y=1000.0000000,Z=1000.0000000)
    mRoundsPerMinute=700.0000000
    mMuzzleFlashClass=Class'SASEffects.MuzzleFlash_MP5Wpn'
    mShellEmitterClass=Class'SASEffects.ShellEject_MP5Wpn'
    mFireSounds=/* Array type was not detected. */
    mPickupImpactSounds=/* Array type was not detected. */
    AmmoName=Class'MAC11_Ammo'
    PickupAmmoCount=150
    ShakeMag=120.5000000
    ShakeTime=5.0000000
    CrossHair=Texture'WpTx.Crosshairs.TempCHair1'
    DisplayFOV=50.0000000
    PlayerViewOffset=(X=-2.0000000,Y=0.0000000,Z=0.0000000)
    AttachmentClass=Class'MAC11_WpnAttach'
    ItemName="MAC11"
}