class TurokSoundController extends ActorComponent
    native;

struct native LimitedSound
{
    var name Name;
    var float minDelay;
    var float lastPlayed;

    structdefaultproperties
    {
        Name="None"
        minDelay=0.0000000
        lastPlayed=0.0000000
    }
};

struct native ProxySound
{
    var @NULL Proxy;
    var @NULL Actual;

    structdefaultproperties
    {
        Proxy=none
        Actual=none
    }
};

struct native QueuedSound
{
    var @NULL sc;
    var bool bReplicated;
    var float timeCreated;
    var float expiryTime;

    structdefaultproperties
    {
        sc=none
        bReplicated=false
        timeCreated=0.0000000
        expiryTime=0.0000000
    }
};

var array mLimitedSounds;
var export editinline array mAudioChannels;
var float mVolumeModifier;
var float mPitchModifier;
var array mProxySounds;
var array mQueuedSounds;
var bool bCanPlayQueuedSound;
var int mQueuedSoundChannelIndex;
var @NULL ClimbHandVineSndCue;
var @NULL ClimbHandMetalSndCue;
var @NULL ClimbFootVineSndCue;
var @NULL ClimbFootMetalSndCue;

// Export UTurokSoundController::execCreateAudioChannel(FFrame&, void* const)
native event int CreateAudioChannel(@NULL sc, bool AutoPlay, bool stopWhenOwnerDestroyed);

// Export UTurokSoundController::execPlayAudioChannel(FFrame&, void* const)
native event bool PlayAudioChannel(int Index);

// Export UTurokSoundController::execGetSoundCue(FFrame&, void* const)
native event @NULL GetSoundCue(int Index);

// Export UTurokSoundController::execStopAudioChannel(FFrame&, void* const)
native event bool StopAudioChannel(int Index, optional float FadeTime);

// Export UTurokSoundController::execChangeAudioChannel(FFrame&, void* const)
native event bool ChangeAudioChannel(int Index, @NULL sc, bool AutoPlay, bool stopWhenOwnerDestroyed);

// Export UTurokSoundController::execFadeInAudioChannel(FFrame&, void* const)
native event bool FadeInAudioChannel(int Index, float FadeInTime, float FadeTargetVolume);

// Export UTurokSoundController::execFadeOutAudioChannel(FFrame&, void* const)
native event bool FadeOutAudioChannel(int Index, float FadeOutTime, float FadeTargetVolume);

// Export UTurokSoundController::execACWasPlaying(FFrame&, void* const)
native event bool ACWasPlaying(int Index);

// Export UTurokSoundController::execACIsFinished(FFrame&, void* const)
native event bool ACIsFinished(int Index);

// Export UTurokSoundController::execSetFloatParameter(FFrame&, void* const)
native event SetFloatParameter(int Index, name Param, float Value);

// Export UTurokSoundController::execIsValidChannel(FFrame&, void* const)
private native final function bool IsValidChannel(int Index);

// Export UTurokSoundController::execIsProxy(FFrame&, void* const)
private native final function bool IsProxy(@NULL Test);

// Export UTurokSoundController::execTryPlayLocalSound(FFrame&, void* const)
native function bool TryPlayLocalSound(@NULL sc, optional bool bStopWhenOwnerDestroyed, optional float Volume, optional float Pitch);

// Export UTurokSoundController::execTryPlayLocalSoundAt(FFrame&, void* const)
native function bool TryPlayLocalSoundAt(@NULL sc, @NULL pos, optional bool bStopWhenOwnerDestroyed, optional float Volume, optional float Pitch);

// Export UTurokSoundController::execGetActualCue(FFrame&, void* const)
native function @NULL GetActualCue(@NULL Proxy);

// Export UTurokSoundController::execPlayQueuedSound(FFrame&, void* const)
native function PlayQueuedSound(@NULL sc, optional float expiryTime);

// Export UTurokSoundController::execTickQueuedSounds(FFrame&, void* const)
native function TickQueuedSounds();

// Export UTurokSoundController::execTryPlayReplicatedSound(FFrame&, void* const)
native final function bool TryPlayReplicatedSound(@NULL sc, optional bool bNoRepToOwner, optional bool bStopWhenOwnerDestroyed, optional @NULL pos, optional float Volume);

// Export UTurokSoundController::execFindLimitedSound(FFrame&, void* const)
native final function int FindLimitedSound(name SoundName);

// Export UTurokSoundController::execTryPlayLimitedSound(FFrame&, void* const)
native final function bool TryPlayLimitedSound(name SoundName, @NULL sc, @NULL pos, optional bool bReplicated, optional bool bNoRepToOwner, optional bool bStopWhenOwnerDestroyed, optional float Volume);

// Export UTurokSoundController::execOwnerCanPlaySound(FFrame&, void* const)
native final function bool OwnerCanPlaySound(@NULL sc);

// Export UTurokSoundController::execTryPlayManagedSound(FFrame&, void* const)
native final function bool TryPlayManagedSound(@NULL AC, @NULL sc, optional @NULL pos);

simulated function float GetVolumeMultiplier()
{
    return mVolumeModifier;
    //return ReturnValue;    
}

simulated function float GetPitchMultiplier()
{
    return mPitchModifier;
    //return ReturnValue;    
}

simulated function AddLimitedSound(name SoundName, float minDelay)
{
    local int Index;

    Index = FindLimitedSound(SoundName);
    // End:0x84
    if(Index < 0)
    {
        Index = mLimitedSounds.Length;
        mLimitedSounds.Insert(0, 1);
        mLimitedSounds[Index].Name = SoundName;
        mLimitedSounds[Index].minDelay = minDelay;
        mLimitedSounds[Index].lastPlayed = 0.0000000;        
    }
    else
    {
        mLimitedSounds[Index].minDelay = minDelay;
    }
    //return;    
}

simulated function DeleteLimitedSound(name SoundName, float minDelay)
{
    local int Index;

    Index = FindLimitedSound(SoundName);
    // End:0x28
    if(Index >= 0)
    {
        mLimitedSounds.Remove(Index, 1);
    }
    //return;    
}

// Export UTurokSoundController::execCanPlayLimitedSound(FFrame&, void* const)
native function bool CanPlayLimitedSound(name SoundName);

defaultproperties
{
    mVolumeModifier=1.0000000
    bCanPlayQueuedSound=true
    mQueuedSoundChannelIndex=-1
    ClimbHandVineSndCue=SoundCue'SndProxy.SndProxy_ClimbHandVine'
    ClimbHandMetalSndCue=SoundCue'SndProxy.SndProxy_ClimbHandMetal'
    ClimbFootVineSndCue=SoundCue'SndProxy.SndProxy_ClimbFootVine'
    ClimbFootMetalSndCue=SoundCue'SndProxy.SndProxy_ClimbFootMetal'
    TickGroup=3
}