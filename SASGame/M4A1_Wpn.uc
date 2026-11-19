//=============================================================================
// M4A1_Wpn.uc
//
// M4A1
//
// Modes:
//			Single
//			Auto
//
// Secondary Fire:
//			None
//=============================================================================

class M4A1_Wpn extends SASWeapon;

//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mCategory=0
    me3PAnimSet=1
    mHandAnims=MeshAnimation'WpAn.HANDS_M4A1'
    mFPWeaponMeshClass=Class'M4A1_FPGunMesh'
    mCollisionPushBackMaxReloading=14.0000000
    mMagSize=30
    mAllowedFireModes=5
    mDiscardMagThreshold=10
    mBurstEmptyThreshold=3
    mbToggleSighted=true
    mSightedFovAdjust=-30.0000000
    mWeight=0.1000000
    mBaseStability=0.2000000
    mBaseCrouchStability=0.1500000
    mShotSpreadAngleNormal=166.0000000
    mShotSpreadAngleCrouch=95.0000000
    mShotSpreadAngleModForSighted=0.3000000
    mShotSpreadAnglePenaltyForMovement=3000
    mShotSpreadAnglePenaltyModForRotation=0.0156000
    mShotSpreadAnglePenaltyDecay=4200.0000000
    mShotSpreadAngleMax=2000.0000000
    mShotSpreadAngleMaxModForSprinting=1.5000000
    mLineartWeapon=Texture'HUDTx.Weapon_Lineart.HUD_WL_M4A1'
    mAimedShotRiseMin=66.0000000
    mAimedShotRiseMax=105.0000000
    mAimedShotYawMin=-20.0000000
    mAimedShotYawMax=100.0000000
    mNormalShotRiseMin=100.0000000
    mNormalShotRiseMax=160.0000000
    mNormalShotYawMin=-30.0000000
    mNormalShotYawMax=150.0000000
    ShakeRate=12000.0000000
    ShakeIterations=1.0000000
    ShakeVert=(X=0.0000000,Y=100.0000000,Z=50.0000000)
    ShakeSpeed=(X=1000.0000000,Y=1000.0000000,Z=1000.0000000)
    mRoundsPerMinute=600.0000000
    mMuzzleFlashClass=Class'SASEffects.MuzzleFlash_MP5Wpn'
    mShellEmitterClass=Class'SASEffects.ShellEject_MP5Wpn'
    mFireSounds=/* Array type was not detected. */
    mPickupImpactSounds=/* Array type was not detected. */
    AmmoName=Class'M4A1_Ammo'
    PickupAmmoCount=150
    ShakeMag=120.5000000
    ShakeTime=5.0000000
    CrossHair=Texture'WpTx.Crosshairs.TempCHair1'
    DisplayFOV=50.0000000
    PlayerViewOffset=(X=-1.0000000,Y=1.0000000,Z=2.0000000)
    AttachmentClass=Class'M4A1_WpnAttach'
    ItemName="M4A1"
}