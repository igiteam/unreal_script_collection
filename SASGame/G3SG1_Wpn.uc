//=============================================================================
// G3SG1_Wpn.uc
//
// G3 Assault Rifle
//
// Modes:
//			Single
//			Auto
//
// Secondary Fire:
//			None
//=============================================================================

class G3SG1_Wpn extends SASWeapon;


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mCategory=0
    me3PAnimSet=1
    mHandAnims=MeshAnimation'WpAn.HANDS_SG1'
    mFPWeaponMeshClass=Class'G3SG1_FPGunMesh'
    mCollisionPushBackMaxReloading=18.0000000
    mMagSize=20
    mAllowedFireModes=5
    mDiscardMagThreshold=7
    mBurstEmptyThreshold=3
    mbToggleSighted=true
    mSightedFovAdjust=-30.0000000
    mBaseStability=0.3000000
    mBaseCrouchStability=0.2000000
    mShotSpreadAngleNormal=180.0000000
    mShotSpreadAngleCrouch=90.0000000
    mShotSpreadAngleModForSighted=0.0800000
    mShotSpreadAnglePenaltyForMovement=3300
    mShotSpreadAnglePenaltyModForRotation=0.0250000
    mShotSpreadAnglePenaltyDecay=3300.0000000
    mShotSpreadAngleMax=2200.0000000
    mShotSpreadAngleMaxModForSprinting=1.5000000
    mLineartWeapon=Texture'HUDTx.Weapon_Lineart.HUD_WL_SG1'
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
    mRoundsPerMinute=500.0000000
    mMuzzleFlashClass=Class'SASEffects.MuzzleFlash_MP5Wpn'
    mMuzzleFlashScale=0.6000000
    mShellEmitterClass=Class'SASEffects.ShellEject_MP5Wpn'
    mScopeClass=Class'Scope_MP5_S'
    mFireSounds=/* Array type was not detected. */
    mPickupImpactSounds=/* Array type was not detected. */
    AmmoName=Class'G3SG1_Ammo'
    PickupAmmoCount=80
    ShakeMag=120.5000000
    ShakeTime=5.0000000
    CrossHair=Texture'WpTx.Crosshairs.TempCHair1'
    DisplayFOV=55.0000000
    AttachmentClass=Class'G3SG1_WpnAttach'
    ItemName="G3-SG1 Rifle"
}