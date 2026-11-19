//=============================================================================
// SigP226_Wpn.uc
//
// Sig Sauer P226 Pistol
// Copied from Browning
//
// Modes:
//			Single
//
// Secondary Fire:
//			None
//=============================================================================

class SigP226_Wpn extends SASWeapon;


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mCategory=1
    me3PAnimSet=2
    mHandAnims=MeshAnimation'WpAn.HANDS_SIG'
    mFPWeaponMeshClass=Class'SigP226_FPGunMesh'
    mCollisionPushBackMaxSighted=16.0000000
    mMagSize=15
    mAllowedFireModes=1
    mbToggleSighted=true
    mSightedFovAdjust=-10.0000000
    mWeight=0.0500000
    mBaseStability=0.0800000
    mBaseCrouchStability=0.0400000
    mShotSpreadAngleNormal=330.0000000
    mShotSpreadAngleCrouch=270.0000000
    mShotSpreadAngleModForSighted=0.5500000
    mShotSpreadAnglePenaltyForMovement=1560
    mShotSpreadAnglePenaltyModForRotation=0.0500000
    mShotSpreadAnglePenaltyDecay=4680.0000000
    mShotSpreadAngleMax=1200.0000000
    mShotSpreadAngleMaxModForSprinting=1.3000000
    mLineartWeapon=Texture'HUDTx.Weapon_Lineart.HUD_WL_SigP226'
    mAimedShotRiseMin=100.0000000
    mAimedShotRiseMax=152.0000000
    mAimedShotYawMin=-66.0000000
    mAimedShotYawMax=92.0000000
    mNormalShotRiseMin=150.0000000
    mNormalShotRiseMax=230.0000000
    mNormalShotYawMin=-100.0000000
    mNormalShotYawMax=140.0000000
    ShakeRate=12000.0000000
    ShakeIterations=1.0000000
    ShakeVert=(X=0.0000000,Y=100.0000000,Z=50.0000000)
    ShakeSpeed=(X=1000.0000000,Y=1000.0000000,Z=1000.0000000)
    mRoundsPerMinute=440.0000000
    mMuzzleFlashClass=Class'SASEffects.MuzzleFlash_MP5Wpn'
    mShellEmitterClass=Class'SASEffects.ShellEject_MP5Wpn'
    mFireSounds=/* Array type was not detected. */
    mPickupImpactSounds=/* Array type was not detected. */
    AmmoName=Class'SigP226_Ammo'
    PickupAmmoCount=45
    ShakeMag=120.5000000
    ShakeTime=5.0000000
    CrossHair=Texture'WpTx.Crosshairs.TempCHair1'
    DisplayFOV=50.0000000
    AttachmentClass=Class'SigP226_WpnAttach'
    ItemName="Sig Sauer P226"
}