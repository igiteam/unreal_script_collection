//=============================================================================
// M1100_Wpn.uc
//
// M1100 Shotgun
//
// Modes:
//			Single
//
// Secondary Fire:
//			None
//=============================================================================

class M1100_Wpn extends SASShotgun;


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mHandAnims=MeshAnimation'WpAn.HANDS_SHOTGUN'
    mFPWeaponMeshClass=Class'M1100_FPGunMesh'
    mMagSize=7
    mAllowedFireModes=1
    mBreachingWeapon=true
    mbToggleSighted=true
    mSightedFovAdjust=-10.0000000
    mWeight=0.1500000
    mBaseStability=1.1000000
    mBaseCrouchStability=0.2000000
    mShotSpreadAngleCrouch=350.0000000
    mShotSpreadAnglePenaltyForMovement=2200
    mShotSpreadAnglePenaltyModForRotation=0.0256000
    mShotSpreadAnglePenaltyDecay=8000.0000000
    mShotSpreadAngleMax=2000.0000000
    mShotSpreadAngleMaxModForSprinting=1.1000000
    mLineartWeapon=Texture'HUDTx.Weapon_Lineart.HUD_WL_Mossberg'
    mNormalShotRiseMin=600.0000000
    mNormalShotRiseMax=800.0000000
    ShakeRate=12000.0000000
    ShakeIterations=1.0000000
    ShakeVert=(X=0.0000000,Y=100.0000000,Z=50.0000000)
    ShakeSpeed=(X=1000.0000000,Y=1000.0000000,Z=1000.0000000)
    mRoundsPerMinute=120.0000000
    mMuzzleFlashClass=Class'SASEffects.MuzzleFlash_MossbergWpn'
    mShellEmitterClass=Class'SASEffects.ShellEject_Shotgun'
    mFireSounds=/* Array type was not detected. */
    mPickupImpactSounds=/* Array type was not detected. */
    AmmoName=Class'M1100_Ammo'
    PickupAmmoCount=14
    mRoundsPerShot=11
    ShakeMag=120.5000000
    ShakeTime=5.0000000
    CrossHair=Texture'WpTx.Crosshairs.TempCHair1'
    DisplayFOV=50.0000000
    PlayerViewOffset=(X=-5.0000000,Y=3.5000000,Z=4.0000000)
    AttachmentClass=Class'M1100_WpnAttach'
    ItemName="Shotgun"
}