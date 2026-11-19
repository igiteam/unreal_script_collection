//=============================================================================
// SOCOM_Wpn.uc
//
// SOCOM pistol
//
// Modes:
//			Single
//
// Secondary Fire:
//			None
//=============================================================================

class SOCOM_Wpn extends SASWeapon;

//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mCategory=1
    me3PAnimSet=2
    mHandAnims=MeshAnimation'WpAn.HANDS_SIG'
    mFPWeaponMeshClass=Class'SOCOM_FPGunMesh'
    mCollisionPushBackMaxSighted=16.0000000
    mMagSize=12
    mAllowedFireModes=1
    mbToggleSighted=true
    mSightedFovAdjust=-10.0000000
    mWeight=0.0800000
    mBaseStability=0.0800000
    mBaseCrouchStability=0.0400000
    mShotSpreadAngleNormal=265.0000000
    mShotSpreadAngleCrouch=215.0000000
    mShotSpreadAngleModForSighted=0.4500000
    mShotSpreadAnglePenaltyForMovement=2100
    mShotSpreadAnglePenaltyModForRotation=0.0600000
    mShotSpreadAnglePenaltyDecay=5800.0000000
    mShotSpreadAngleMax=1500.0000000
    mShotSpreadAngleMaxModForSprinting=1.4000000
    mLineartWeapon=Texture'HUDTx.Weapon_Lineart.HUD_WL_SOCOM'
    mAimedShotRiseMin=165.0000000
    mAimedShotRiseMax=297.0000000
    mAimedShotYawMin=-46.0000000
    mAimedShotYawMax=145.0000000
    mNormalShotRiseMin=250.0000000
    mNormalShotRiseMax=450.0000000
    mNormalShotYawMin=-70.0000000
    mNormalShotYawMax=220.0000000
    ShakeRate=12000.0000000
    ShakeIterations=1.0000000
    ShakeVert=(X=0.0000000,Y=100.0000000,Z=50.0000000)
    ShakeSpeed=(X=1000.0000000,Y=1000.0000000,Z=1000.0000000)
    mRoundsPerMinute=440.0000000
    mMuzzleFlashClass=Class'SASEffects.MuzzleFlash_MP5SDWpn'
    mShellEmitterClass=Class'SASEffects.ShellEject_MP5Wpn'
    mFireSounds=/* Array type was not detected. */
    mPickupImpactSounds=/* Array type was not detected. */
    AmmoName=Class'SOCOM_Ammo'
    PickupAmmoCount=36
    ShakeMag=120.5000000
    ShakeTime=5.0000000
    CrossHair=Texture'WpTx.Crosshairs.TempCHair1'
    DisplayFOV=50.0000000
    AttachmentClass=Class'SOCOM_WpnAttach'
    ItemName="SOCOM"
}