//=============================================================================
// AK47_Wpn.uc
//
// AK47 Assault Rifle
//
// Modes:
//			Single
//			Auto
//
// Secondary Fire:
//			None
//=============================================================================

class AK47_Wpn extends SASWeapon;


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mCategory=0
    me3PAnimSet=1
    mHandAnims=MeshAnimation'WpAn.HANDS_AK47'
    mFPWeaponMeshClass=Class'AK47_FPGunMesh'
    mCollisionPushBackMaxSighted=15.0000000
    mCollisionPushBackMaxReloading=14.0000000
    mMagSize=30
    mAllowedFireModes=5
    mDiscardMagThreshold=10
    mBurstEmptyThreshold=3
    mbToggleSighted=true
    mSightedFovAdjust=-20.0000000
    mBaseStability=0.3000000
    mBaseCrouchStability=0.2000000
    mShotSpreadAngleNormal=180.0000000
    mShotSpreadAngleCrouch=90.0000000
    mShotSpreadAngleModForSighted=0.1500000
    mShotSpreadAnglePenaltyForMovement=3300
    mShotSpreadAnglePenaltyModForRotation=0.0250000
    mShotSpreadAnglePenaltyDecay=3300.0000000
    mShotSpreadAngleMax=2200.0000000
    mShotSpreadAngleMaxModForSprinting=1.5000000
    mLineartWeapon=Texture'HUDTx.Weapon_Lineart.HUD_WL_AK47'
    mAimedShotRiseMin=76.0000000
    mAimedShotRiseMax=120.0000000
    mAimedShotYawMin=-40.0000000
    mAimedShotYawMax=80.0000000
    mNormalShotRiseMin=115.0000000
    mNormalShotRiseMax=180.0000000
    mNormalShotYawMin=-60.0000000
    mNormalShotYawMax=120.0000000
    ShakeRate=12000.0000000
    ShakeIterations=1.0000000
    ShakeVert=(X=0.0000000,Y=100.0000000,Z=50.0000000)
    ShakeSpeed=(X=1000.0000000,Y=1000.0000000,Z=1000.0000000)
    mRoundsPerMinute=600.0000000
    mMuzzleFlashClass=Class'SASEffects.MuzzleFlash_MP5Wpn'
    mShellEmitterClass=Class'SASEffects.ShellEject_MP5Wpn'
    mFireSounds=/* Array type was not detected. */
    mPickupImpactSounds=/* Array type was not detected. */
    AmmoName=Class'AK47_Ammo'
    PickupAmmoCount=150
    ShakeMag=120.5000000
    ShakeTime=5.0000000
    CrossHair=Texture'WpTx.Crosshairs.TempCHair1'
    DisplayFOV=50.0000000
    PlayerViewOffset=(X=-7.0000000,Y=0.0000000,Z=5.0000000)
    AttachmentClass=Class'AK47_WpnAttach'
    ItemName="AK-47"
}