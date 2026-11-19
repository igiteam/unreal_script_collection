//=============================================================================
// M60_Wpn.uc
//
// M60 machinegun
//
// Modes:
//			Single
//			Auto
//
// Secondary Fire:
//			None
//=============================================================================

class M60_Wpn extends SASWeapon;

//-----------------------------------------------------------------------------
// Default Properties






// Decompiled with UE Explorer.
defaultproperties
{
    mCategory=0
    me3PAnimSet=1
    mSpecial3PReloadAnim="Stand_Reload_M60"
    mHandAnims=MeshAnimation'WpAn.HANDS_M60'
    mFPWeaponMeshClass=Class'M60_FPGunMesh'
    mCollisionPushBackMaxReloading=16.0000000
    mMagSize=100
    mFireMode=2
    mAllowedFireModes=5
    mDiscardMagThreshold=10
    mBurstEmptyThreshold=3
    mbToggleSighted=true
    mSightedFovAdjust=-30.0000000
    mWeight=0.3000000
    mBaseStability=0.5000000
    mBaseCrouchStability=0.1200000
    mShotSpreadAngleNormal=600.0000000
    mShotSpreadAngleCrouch=140.0000000
    mShotSpreadAngleModForSighted=0.3500000
    mShotSpreadAnglePenaltyForMovement=3750
    mShotSpreadAnglePenaltyModForRotation=0.0256000
    mShotSpreadAnglePenaltyDecay=1800.0000000
    mShotSpreadAngleMax=2500.0000000
    mShotSpreadAngleMaxModForSprinting=1.5000000
    mLineartWeapon=Texture'HUDTx.Weapon_Lineart.HUD_WL_M60'
    mAimedShotRiseMin=-45.0000000
    mAimedShotRiseMax=105.0000000
    mAimedShotYawMin=-45.0000000
    mAimedShotYawMax=120.0000000
    mNormalShotRiseMin=-65.0000000
    mNormalShotRiseMax=150.0000000
    mNormalShotYawMin=-65.0000000
    mNormalShotYawMax=180.0000000
    ShakeRate=12000.0000000
    ShakeIterations=1.0000000
    ShakeVert=(X=0.0000000,Y=100.0000000,Z=50.0000000)
    ShakeSpeed=(X=1000.0000000,Y=1000.0000000,Z=1000.0000000)
    mRoundsPerMinute=550.0000000
    mMuzzleFlashClass=Class'SASEffects.MuzzleFlash_M60Wpn'
    mShellEmitterClass=Class'SASEffects.ShellEject_MP5Wpn'
    mFireSounds=/* Array type was not detected. */
    mPickupImpactSounds=/* Array type was not detected. */
    AmmoName=Class'M60_Ammo'
    PickupAmmoCount=200
    ShakeMag=120.5000000
    ShakeTime=5.0000000
    CrossHair=Texture'WpTx.Crosshairs.TempCHair1'
    DisplayFOV=50.0000000
    PlayerViewOffset=(X=-6.0000000,Y=5.0000000,Z=0.5000000)
    AttachmentClass=Class'M60_WpnAttach'
    ItemName="M60"
}