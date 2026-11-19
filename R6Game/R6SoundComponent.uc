class R6SoundComponent extends ActorComponent
    abstract
    native;

var transient bool m_bIsActivated;
var transient bool m_bIsInRange;
var transient bool m_bToDelete;
var transient bool m_bDontActivate;
var Vector m_Location;
var(R6Sound) /*0x04000000-0x00000000*/ bool m_bPlayOnlyInSameZone;
var(R6Sound) /*0x04000000-0x00000000*/ bool m_bPlayOnlyOnce;
var(R6Sound) /*0x04000000-0x00000000*/ bool m_bHearableZones;
var(R6Sound) /*0x04000000-0x00000000*/ R6EngineEnums.ESoundSlot m_eAlternateSoundSlot;
var R6EngineEnums.ESoundInfoObjectType m_eType;
var(R6Sound) /*0x04000000-0x00000000*/ array<ZoneInfo> m_SoundZoneInfoList;
var(R6Sound) /*0x04000000-0x00000000*/ array<StreamingZoneOutside> m_StreamedSoundZoneInfoList;

// Export UR6SoundComponent::execKillSounds(FFrame&, void* const)
native final function KillSounds(Actor pOwner);
