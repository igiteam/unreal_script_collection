class R6AmbientSound extends R6SoundComponent
    native
    editinlinenew;

struct PlayStopSoundCues
{
    var() SoundCue PlayCue;
    var() SoundCue StopCue;
    var() SoundCue BreakCue;

    structdefaultproperties
    {
        PlayCue=none
        StopCue=none
        BreakCue=none
    }
};

var(R6Sound) /*0x04000000-0x00000000*/ array<PlayStopSoundCues> m_AmbientSounds;
var(R6Sound) /*0x04000000-0x00000000*/ float m_fSoundRadiusSaturation;
var(R6Sound) /*0x04000000-0x00000000*/ float m_fSoundRadiusActivation;
var(R6Sound) /*0x04000000-0x00000000*/ float m_fSoundRadiusLinearFadeDist;
