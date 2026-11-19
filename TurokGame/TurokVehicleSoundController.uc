class TurokVehicleSoundController extends TurokSoundController
    native;

struct native EngineSound
{
    var() @NULL sc;
    var() float minRPM;
    var() float maxRPM;
    var() float transitionRange;

    structdefaultproperties
    {
        sc=none
        minRPM=0.0000000
        maxRPM=0.0000000
        transitionRange=0.0000000
    }
};

struct native WheelSound
{
    var name mPhysMaterialName;
    var @NULL mWheelSound;
    var int mPriority;
    var int mNumWheels;

    structdefaultproperties
    {
        mPhysMaterialName="None"
        mWheelSound=none
        mPriority=0
        mNumWheels=0
    }
};

var float mAudioRPM;
var(Sound) float mMaxAccelRPMSec;
var(Sound) float mMaxDeAccelRPMSec;
var(Sound) @NULL mEngineIdleSnd;
var(Sound) @NULL mEngineAccelSnd;
var(Sound) @NULL mEngineDeAccelSnd;
var(Sound) @NULL mEngineTopSpeedSnd;
var(Sound) @NULL mEngineStartSndCue;
var(Sound) @NULL mEngineStopSndCue;
var(Sound) @NULL mEngineTorqueSndCue;
var(Sound) @NULL mSuspensionSndCue;
var(Sound) @NULL mSuspensionLandSndCue;
var(Sound) @NULL mDeathSndCue;
var(Sound) @NULL mBurningVehicleSndCue;
var(Sound) @NULL mSmokingVehicleSndCue;
var array mWheelSounds;
var private int mEngineAccelSoundChannelIndex;
var private int mEngineDeAccelSoundChannelIndex;
var private int mEngineSoundChannelIndex;
var private int mIgnitionSoundChannelIndex;
var private int mEngineTorqueSoundChannelIndex;
var private int mVehicleSoundChannelIndex;
var private int mWheelSoundChannelIndex;
var private float mEngineAccelSoundChannelVolume;
var private float mEngineDeAccelSoundChannelVolume;
var private float mEngineSoundChannelVolume;
var private float mIgnitionSoundChannelVolume;

simulated function PlayEngineIdleSound()
{
    PlayAudioChannel(mEngineSoundChannelIndex);
    //return;    
}

simulated function StopEngineSound()
{
    StopAudioChannel(mEngineSoundChannelIndex);
    StopAudioChannel(mEngineAccelSoundChannelIndex);
    StopAudioChannel(mEngineDeAccelSoundChannelIndex);
    //return;    
}

simulated function PlayDyingSound()
{
    TryPlayLocalSound(mDeathSndCue);
    PlayVehicleSound('fire');
    //return;    
}

simulated function PlayVehicleSound(name Effect)
{
    local @NULL sc;

    // End:0x21
    if(Effect == 'lightsmoke')
    {
        sc = mSmokingVehicleSndCue;        
    }
    else
    {
        // End:0x42
        if(Effect == 'fire')
        {
            sc = mBurningVehicleSndCue;            
        }
        else
        {
            return;
        }
    }
    // End:0x6D
    if(mVehicleSoundChannelIndex == -1)
    {
        mVehicleSoundChannelIndex = CreateAudioChannel(sc, true, true);        
    }
    else
    {
        ChangeAudioChannel(mVehicleSoundChannelIndex, sc, true, true);
    }
    //return;    
}

simulated function StopVehicleSound()
{
    StopAudioChannel(mVehicleSoundChannelIndex);
    //return;    
}

simulated function PlayEnterVehicleSound()
{
    Init();
    // End:0x33
    if(mIgnitionSoundChannelIndex == -1)
    {
        mIgnitionSoundChannelIndex = CreateAudioChannel(mEngineStartSndCue, true, true);        
    }
    else
    {
        ChangeAudioChannel(mIgnitionSoundChannelIndex, mEngineStartSndCue, true, true);
    }
    //return;    
}

simulated function PlayExitVehicleSound()
{
    // End:0x29
    if(mIgnitionSoundChannelIndex == -1)
    {
        mIgnitionSoundChannelIndex = CreateAudioChannel(mEngineStopSndCue, true, true);        
    }
    else
    {
        ChangeAudioChannel(mIgnitionSoundChannelIndex, mEngineStopSndCue, true, true);
    }
    //return;    
}

simulated function PlaySuspensionSound(float volumeMult)
{
    TryPlayLocalSound(mSuspensionSndCue, true, volumeMult);
    //return;    
}

simulated function PlayLandSound(float volumeMult)
{
    TryPlayLocalSound(mSuspensionLandSndCue, true, volumeMult);
    //return;    
}

simulated function Init()
{
    // End:0x33
    if(mEngineSoundChannelIndex == -1)
    {
        mEngineSoundChannelIndex = CreateAudioChannel(mEngineIdleSnd.sc, false, true);        
    }
    else
    {
        ChangeAudioChannel(mEngineSoundChannelIndex, mEngineIdleSnd.sc, false, true);
    }
    // End:0x86
    if(mEngineAccelSoundChannelIndex == -1)
    {
        mEngineAccelSoundChannelIndex = CreateAudioChannel(mEngineAccelSnd.sc, false, true);        
    }
    else
    {
        ChangeAudioChannel(mEngineAccelSoundChannelIndex, mEngineAccelSnd.sc, false, true);
    }
    // End:0xD9
    if(mEngineDeAccelSoundChannelIndex == -1)
    {
        mEngineDeAccelSoundChannelIndex = CreateAudioChannel(mEngineDeAccelSnd.sc, false, true);        
    }
    else
    {
        ChangeAudioChannel(mEngineDeAccelSoundChannelIndex, mEngineDeAccelSnd.sc, false, true);
    }
    SetFloatParameter(mEngineAccelSoundChannelIndex, 'VolumeModulationParam', 0.0000000);
    SetFloatParameter(mEngineDeAccelSoundChannelIndex, 'VolumeModulationParam', 0.0000000);
    PlayAudioChannel(mEngineAccelSoundChannelIndex);
    PlayAudioChannel(mEngineDeAccelSoundChannelIndex);
    // End:0x177
    if(mEngineTorqueSoundChannelIndex == -1)
    {
        mEngineTorqueSoundChannelIndex = CreateAudioChannel(mEngineTorqueSndCue, false, true);
    }
    SetFloatParameter(mEngineTorqueSoundChannelIndex, 'VolumeModulationParam', 0.0000000);
    PlayAudioChannel(mEngineTorqueSoundChannelIndex);
    //return;    
}

defaultproperties
{
    mMaxAccelRPMSec=1000.0000000
    mMaxDeAccelRPMSec=500.0000000
    mEngineAccelSoundChannelIndex=-1
    mEngineDeAccelSoundChannelIndex=-1
    mEngineSoundChannelIndex=-1
    mIgnitionSoundChannelIndex=-1
    mEngineTorqueSoundChannelIndex=-1
    mVehicleSoundChannelIndex=-1
    mWheelSoundChannelIndex=-1
}