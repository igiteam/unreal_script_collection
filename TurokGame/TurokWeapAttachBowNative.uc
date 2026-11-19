class TurokWeapAttachBowNative extends TurokWeaponAttachment
    native
    config(Weapon);

var @NULL mHitLocation;
var float mTension;
var bool mbIgnoreTension;
var protected name mTensionControllerName;
var(Animations) @NULL m3PTensionAsset;
var protected name mMaxAimControllerName;
var(Animations) @NULL m3PMaxAimAsset;
var(Sound) @NULL mBowIncreaseTensionSndCue;
var(Sound) @NULL mBowDecreaseTensionSndCue;
var(Sound) float mTensionSndThreshold;
var(Sound) float mLastTensionPlayed;

simulated function Play3pSpatialTensioningAnim(float tensionTime)
{
    //return;    
}

simulated function Play3pSpatialMaxTensionAnim()
{
    //return;    
}

simulated function StopFireSpatialAnim()
{
    //return;    
}

simulated function BowAttachmentAddTension(byte Tension)
{
    AddTension(Tension);
    //return;    
}

simulated function byte BowAttachmentGetTension()
{
    return byte(mTension);
    //return ReturnValue;    
}

simulated function UpdateBowSounds(byte Tension)
{
    // End:0x1F
    if(mTension == float(0))
    {
        PlayAmbience(SoundCue'SndWeapBowArrow.BowPullSndCue');        
    }
    else
    {
        // End:0x3C
        if(mTension == float(255))
        {
            PlayAmbience(SoundCue'SndWeapBowArrow.BowMaxTensionSndCue');
        }
    }
    // End:0xFA
    if((Abs(float(Tension) - mLastTensionPlayed) >= mTensionSndThreshold) || mLastTensionPlayed == float(0))
    {
        // End:0xAA
        if(float(Tension) > mLastTensionPlayed)
        {
            mHumanOwner.mSoundController.TryPlayLocalSound(mBowIncreaseTensionSndCue);
            mLastTensionPlayed = float(Tension);            
        }
        else
        {
            // End:0xEF
            if(float(Tension) > mLastTensionPlayed)
            {
                mHumanOwner.mSoundController.TryPlayLocalSound(mBowDecreaseTensionSndCue);
                mLastTensionPlayed = float(Tension);                
            }
            else
            {
                mLastTensionPlayed = 0.0000000;
            }
        }
    }
    //return;    
}

simulated function AddTension(byte Tension)
{
    local float maxWeight;

    maxWeight = float(Tension) / 255.0000000;
    // End:0x3C
    if(!mbIgnoreTension)
    {
        Play3PSpatialAnimUseTargetFn(mMaxAimControllerName, 0.1000000, maxWeight, 0.1000000);        
    }
    else
    {
        mbIgnoreTension = false;
    }
    mTension = float(Tension);
    //return;    
}

// Export UTurokWeapAttachBowNative::execPlaySpatialFireAnim(FFrame&, void* const)
native function PlaySpatialFireAnim(int FireMode, float fireTime);

event AttachAnimations()
{
    local editinline @NULL weaponMesh;

    weaponMesh = SkeletalMeshComponent(mAttachMesh);
    // End:0xC9
    if(weaponMesh != none)
    {
        weaponMesh.AnimSets = mWeaponAnimSets;
        InitBaseSpatialController(m3PAimAsset, true, true);
        InitSpatialController(mTensionControllerName, m3PTensionAsset, 'jt_SpineLower_C', 1.0000000, 0.0000000, false, true);
        InitSpatialController(mFireControllerName, m3PFireAsset, 'jt_SpineLower_C', 1.0000000, 0.0000000, false, true);
        InitSpatialController(mMaxAimControllerName, m3PMaxAimAsset, 'jt_SpineLower_C', 1.0000000, 0.0000000, true, true);
        InitCannedController(mCannedControllerName, 'jt_SpineUpper_C', 1.0000000, 0.0000000);
    }
    //return;    
}

// Export UTurokWeapAttachBowNative::execThirdPersonFireEffects(FFrame&, void* const)
native function ThirdPersonFireEffects(@NULL HitLocation);
