class R6SoundZoneInfo extends ActorComponent
    native
    editinlinenew;

var(R6Sound) /*0x04000000-0x00000000*/ const array<SoundCue> m_StartingSounds;
var(R6Sound) /*0x04000000-0x00000000*/ const array<SoundCue> m_EnterSounds;
var(R6Sound) /*0x04000000-0x00000000*/ const array<SoundCue> m_ExitSounds;
var(R6Sound) /*0x04000000-0x00000000*/ byte m_SoundZone;
var(R6Sound) /*0x04000000-0x00000000*/ R6EngineEnums.ESoundSlot m_SlotToPlayAmbience;
var(R6Sound) /*0x04000000-0x00000000*/ const bool m_bInteriorZone;
var(R6Sound) /*0x04000000-0x00000000*/ const bool m_bIsNarrow;
var(R6Sound) /*0x04000000-0x00000000*/ bool m_bLoudVoices;
var(R6Sound) /*0x04000000-0x00000000*/ const bool m_bManualMusicVolumeControl;
var transient bool m_bAlreadyPlayMusic;
var(R6Sound) /*0x04000000-0x00000000*/ const SoundCue m_AmbianceCues[4];
var(R6Sound) /*0x04000000-0x00000000*/ const float m_fManualMusicVolumeFadeLength;
var(R6Sound) /*0x04000000-0x00000000*/ const float m_fManualMusicVolumeLevel;

// Export UR6SoundZoneInfo::execActorHasEntered(FFrame&, void* const)
native function ActorHasEntered(R6SoundZoneInfo pOtherZoneInfo);

// Export UR6SoundZoneInfo::execActorHasLeft(FFrame&, void* const)
native function ActorHasLeft(R6SoundZoneInfo pOtherZoneInfo);
