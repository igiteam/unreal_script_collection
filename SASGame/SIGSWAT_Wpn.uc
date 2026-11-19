//=============================================================================
// SIGSWAT_Wpn.uc
//
// Sig SWAT
//
// Modes:
//			Single
//			Auto
//
// Secondary Fire:
//			None
//=============================================================================

class SIGSWAT_Wpn extends SASWeapon;

//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mCategory=0
    me3PAnimSet=1
    mHandAnims=MeshAnimation'WpAn.HANDS_SIGswat'
    mFPWeaponMeshClass=Class'SIGSWAT_FPGunMesh'
    mCollisionPushBackMaxReloading=10.0000000
    mMagSize=30
    mAllowedFireModes=5
    mDiscardMagThreshold=10
    mBurstEmptyThreshold=3
    mbToggleSighted=true
    mSightedFovAdjust=-40.0000000
    mWeight=0.0900000
    mBaseStability=0.1200000
    mShotSpreadAngleNormal=175.0000000
    mShotSpreadAngleCrouch=100.0000000
    mShotSpreadAngleModForSighted=0.1500000
    mShotSpreadAnglePenaltyForMovement=3000
    mShotSpreadAnglePenaltyModForRotation=0.0160000
    mShotSpreadAnglePenaltyDecay=4500.0000000
    mShotSpreadAngleMax=2000.0000000
    mShotSpreadAngleMaxModForSprinting=1.5000000
    mLineartWeapon=Texture'HUDTx.Weapon_Lineart.HUD_WL_SWAT'
    mAimedShotRiseMin=66.0000000
    mAimedShotYawMin=-20.0000000
    mAimedShotYawMax=112.0000000
    mNormalShotRiseMin=100.0000000
    mNormalShotRiseMax=150.0000000
    mNormalShotYawMin=-30.0000000
    mNormalShotYawMax=170.0000000
    ShakeRate=12000.0000000
    ShakeIterations=1.0000000
    ShakeVert=(X=0.0000000,Y=100.0000000,Z=50.0000000)
    ShakeSpeed=(X=1000.0000000,Y=1000.0000000,Z=1000.0000000)
    mRoundsPerMinute=550.0000000
    mMuzzleFlashClass=Class'SASEffects.MuzzleFlash_MP5Wpn'
    mShellEmitterClass=Class'SASEffects.ShellEject_MP5Wpn'
    mScopeClass=Class'Scope_Aug'
    mFireSounds=/* Array type was not detected. */
    mPickupImpactSounds=/* Array type was not detected. */
    AmmoName=Class'SIGSWAT_Ammo'
    PickupAmmoCount=150
    ShakeMag=120.5000000
    ShakeTime=5.0000000
    CrossHair=Texture'WpTx.Crosshairs.TempCHair1'
    DisplayFOV=50.0000000
    PlayerViewOffset=(X=-2.0000000,Y=1.0000000,Z=3.0000000)
    AttachmentClass=Class'SIGSWAT_WpnAttach'
    ItemName="Sig SWAT"
}