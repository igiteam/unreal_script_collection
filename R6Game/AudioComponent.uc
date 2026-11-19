class AudioComponent extends ActorComponent
    native
    editinlinenew
    collapsecategories
    noexport
    hidecategories(Object,ActorComponent);

struct AudioComponentParam
{
    var() name ParamName;
    var() float FloatParam;

    structdefaultproperties
    {
        ParamName="None"
        FloatParam=0.0000000
    }
};

var() /*0x04000000-0x00000000*/ SoundCue SoundCue;
var native const SoundNode CueFirstNode;
var() editinline array<editinline AudioComponentParam> InstanceParameters;
var bool bUseOwnerLocation;
var bool bAutoPlay;
var bool bAutoDestroy;
var bool bStopWhenOwnerDestroyed;
var bool bFinished;
var bool bNonRealtime;
var bool bWasPlaying;
var bool bAllowSpatialization;
var bool bWasFlushed;
var bool bShouldRemainActiveIfDropped;
var bool bFadingIn;
var bool bFadingOut;
var native const Pointer WaveInstance;
var native const array<byte> SoundNodeData;
var native const map{VOID,VOID} SoundNodeOffsetMap;
var native const MultiMap_Mirror SoundNodeWaveMap;
var native const Pointer Listener;
var native const float PlaybackTime;
var native Vector Location;
var native const Vector ComponentLocation;
var float FadeTimeRemaining;
var float FadeInVolumeLevel;
var float FadeOutVolumeLevel;
var native const SoundNode CurrentNotifyBufferFinishedHook;
var native const Vector CurrentLocation;
var native const float CurrentDelay;
var native const float CurrentVolume;
var native const float CurrentPitch;
var native const bool CurrentUseSpatialization;
var native const int CurrentNodeIndex;
var native const float CurrentVolumeMultiplier;
var native const float CurrentPriorityMultiplier;
var native const float CurrentPitchMultiplier;
var() float VolumeMultiplier;
var() float PitchMultiplier;
var const export editinline DrawSoundRadiusComponent PreviewSoundRadius;
var bool m_bIsAStopSound;
var const bool m_bHasStopSound;
var const Pointer m_pSoundComponent;
var R6EngineEnums.ESoundOccluderType m_eOccluderType;
var R6EngineEnums.ESoundSurfaceType m_eSoundSurfaceType;
var const R6EngineEnums.ESoundSlot m_eSoundSlot;
var Vector m_vRelativeLocation;
var native int m_SourceTriangleIndex;
var native int m_SourceZoneIndex;
var native float m_fOcclusionFactor_Current;
var native float m_fOcclusionFactor_Target;
var native int m_iCacheTimeToLive;
var native Pointer m_pSoundSource;

// Export UAudioComponent::execPlay(FFrame&, void* const)
native function Play();

// Export UAudioComponent::execPause(FFrame&, void* const)
native function Pause();

// Export UAudioComponent::execStop(FFrame&, void* const)
native function Stop();

// Export UAudioComponent::execFadeIn(FFrame&, void* const)
native function FadeIn(float FadeTime, float fVolume, R6EngineEnums.EFadeCurve EFadeCurve);

// Export UAudioComponent::execFadeOut(FFrame&, void* const)
native function FadeOut(float FadeTime);

// Export UAudioComponent::execSetFloatParameter(FFrame&, void* const)
native function SetFloatParameter(name InName, float InFloat);
