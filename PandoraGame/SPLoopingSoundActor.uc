class SPLoopingSoundActor extends Actor
    native
    notplaceable;

var bool bIsSoundPlaying;
var Actor SourceActor;
var export editinline AudioComponent LoopingSoundComponent;

// Export USPLoopingSoundActor::execStartSound(FFrame&, void* const)
native function StartSound(SoundCue TheSoundCue, Actor theSourceActor, optional bool bResetSoundIfAlreadyPlaying, optional float FadeInDuration, optional float fadeInVolume);

// Export USPLoopingSoundActor::execStopSound(FFrame&, void* const)
native function StopSound(optional float FadeOutDuration, optional float FadeVolumeLevel);

// Export USPLoopingSoundActor::execIsSoundPlaying(FFrame&, void* const)
native function bool IsSoundPlaying();
