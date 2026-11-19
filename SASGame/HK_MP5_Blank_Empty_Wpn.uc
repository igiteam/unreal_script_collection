//=============================================================================
// HK_MP5_Blank_Wpn.uc
//
// MP5-Blank Submachine Gun
// Lots of stuff should be inherited from the MP5
// Modes:
//			Single
//			Auto
//
// Secondary Fire:
//			None
//=============================================================================

class HK_MP5_Blank_Empty_Wpn extends HK_MP5_Wpn;


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mFPWeaponMeshClass=Class'HK_MP5_Blank_FPGunMesh'
    mBaseStability=0.5000000
    mBaseCrouchStability=0.2000000
    mShotSpreadAnglePenaltyDecay=2000.0000000
    mNormalShotRiseMin=546.0000000
    mNormalShotRiseMax=546.0000000
    mNormalShotYawMin=546.0000000
    mNormalShotYawMax=546.0000000
    mBurstShotRiseMin=280.0000000
    mBurstShotRiseMax=280.0000000
    mBurstShotYawMin=140.0000000
    mBurstShotYawMax=140.0000000
    mRoundsPerMinute=500.0000000
    mFireSounds=/* Array type was not detected. */
    mBurstFireSounds=/* Array type was not detected. */
    AmmoName=Class'HK_MP5_Blank_Empty_Ammo'
    PickupAmmoCount=0
    AttachmentClass=Class'HK_MP5_Blank_WpnAttach'
    ItemName="MP5-10"
}