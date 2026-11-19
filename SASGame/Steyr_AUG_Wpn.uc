//=============================================================================
// Steyr_AUG_Wpn.uc
//
// Steyr AUG Assault Rifle
// Copied from MP5
//
// Modes:
//			Single
//			Auto
//
// Secondary Fire:
//			None
//=============================================================================

class Steyr_AUG_Wpn extends SASWeapon;


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mCategory=0
    me3PAnimSet=1
    mSpecial3PReloadAnim="Stand_Reload_Aug"
    mHandAnims=MeshAnimation'WpAn.HANDS_AUG'
    mFPWeaponMeshClass=Class'Steyr_Aug_FPGunMesh'
    mCollisionPushBackMaxReloading=16.0000000
    mMagSize=30
    mAllowedFireModes=5
    mDiscardMagThreshold=10
    mBurstEmptyThreshold=3
    mbToggleSighted=true
    mSightedFovAdjust=-45.0000000
    mBaseStability=0.2600000
    mBaseCrouchStability=0.1700000
    mShotSpreadAngleNormal=180.0000000
    mShotSpreadAngleCrouch=90.0000000
    mShotSpreadAngleModForSighted=0.0800000
    mShotSpreadAnglePenaltyForMovement=3300
    mShotSpreadAnglePenaltyModForRotation=0.0256000
    mShotSpreadAnglePenaltyDecay=3500.0000000
    mShotSpreadAngleMax=2200.0000000
    mShotSpreadAngleMaxModForSprinting=1.5000000
    mLineartWeapon=Texture'HUDTx.Weapon_Lineart.HUD_WL_AUG'
    mAimedShotRiseMin=53.0000000
    mAimedShotRiseMax=120.0000000
    mAimedShotYawMin=-40.0000000
    mAimedShotYawMax=106.0000000
    mNormalShotRiseMin=80.0000000
    mNormalShotRiseMax=180.0000000
    mNormalShotYawMin=-60.0000000
    mNormalShotYawMax=160.0000000
    ShakeRate=12000.0000000
    ShakeIterations=1.0000000
    ShakeVert=(X=0.0000000,Y=100.0000000,Z=50.0000000)
    ShakeSpeed=(X=1000.0000000,Y=1000.0000000,Z=1000.0000000)
    mRoundsPerMinute=600.0000000
    mMuzzleFlashClass=Class'SASEffects.MuzzleFlash_MP5Wpn'
    mShellEmitterClass=Class'SASEffects.ShellEject_MP5Wpn'
    mScopeClass=Class'Scope_Aug'
    mFireSounds=/* Array type was not detected. */
    mPickupImpactSounds=/* Array type was not detected. */
    AmmoName=Class'Steyr_AUG_Ammo'
    PickupAmmoCount=150
    ShakeMag=120.5000000
    ShakeTime=5.0000000
    CrossHair=Texture'WpTx.Crosshairs.TempCHair1'
    DisplayFOV=55.0000000
    PlayerViewOffset=(X=0.0000000,Y=1.5000000,Z=1.0000000)
    AttachmentClass=Class'Steyr_AUG_WpnAttach'
    ItemName="Steyr AUG Assault Rifle"
}