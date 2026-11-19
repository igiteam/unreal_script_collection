//=============================================================================
// Uzi_Wpn.uc
//
// Uzi sub-machinegun
//
// Modes:
//			Single
//			Auto
//
// Secondary Fire:
//			None
//=============================================================================

class Uzi_Wpn extends SASWeapon;

//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mCategory=0
    me3PAnimSet=2
    mSpecial3PReloadAnim="Stand_Reload_Uzi"
    mHandAnims=MeshAnimation'WpAn.HANDS_UZI9mm'
    mFPWeaponMeshClass=Class'Uzi_FPGunMesh'
    mCollisionPushBackMaxSighted=16.0000000
    mCollisionPushBackMaxReloading=16.0000000
    mMagSize=32
    mFireMode=2
    mAllowedFireModes=5
    mDiscardMagThreshold=10
    mBurstEmptyThreshold=3
    mbToggleSighted=true
    mSightedFovAdjust=-30.0000000
    mWeight=0.0800000
    mBaseCrouchStability=0.0500000
    mShotSpreadAngleNormal=300.0000000
    mShotSpreadAngleCrouch=175.0000000
    mShotSpreadAngleModForSighted=0.7000000
    mShotSpreadAnglePenaltyForMovement=2520
    mShotSpreadAnglePenaltyModForRotation=0.0220000
    mShotSpreadAnglePenaltyDecay=5040.0000000
    mShotSpreadAngleMax=1800.0000000
    mShotSpreadAngleMaxModForSprinting=1.4000000
    mLineartWeapon=Texture'HUDTx.Weapon_Lineart.HUD_WL_UZI9mm'
    mAimedShotRiseMin=120.0000000
    mAimedShotRiseMax=280.0000000
    mAimedShotYawMin=-33.0000000
    mAimedShotYawMax=53.0000000
    mNormalShotRiseMin=120.0000000
    mNormalShotRiseMax=280.0000000
    mNormalShotYawMin=-50.0000000
    mNormalShotYawMax=100.0000000
    ShakeRate=12000.0000000
    ShakeIterations=1.0000000
    ShakeVert=(X=0.0000000,Y=100.0000000,Z=50.0000000)
    ShakeSpeed=(X=1000.0000000,Y=1000.0000000,Z=1000.0000000)
    mRoundsPerMinute=650.0000000
    mMuzzleFlashClass=Class'SASEffects.MuzzleFlash_MP5Wpn'
    mShellEmitterClass=Class'SASEffects.ShellEject_MP5Wpn'
    mFireSounds=/* Array type was not detected. */
    mPickupImpactSounds=/* Array type was not detected. */
    AmmoName=Class'Uzi_Ammo'
    PickupAmmoCount=128
    ShakeMag=120.5000000
    ShakeTime=0.5000000
    CrossHair=Texture'WpTx.Crosshairs.TempCHair1'
    DisplayFOV=50.0000000
    PlayerViewOffset=(X=4.0000000,Y=0.0000000,Z=1.0000000)
    AttachmentClass=Class'Uzi_WpnAttach'
    ItemName="Uzi 9mm"
}