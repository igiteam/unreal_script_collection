class InterpTrackSound extends InterpTrack
    native
    collapsecategories
    hidecategories(Object);

struct SoundTrackKey
{
    var /*0x04000000-0x00000000*/ float Time;
    var() /*0x04000000-0x00000000*/ SoundCue Sound;
    var /*0x04000000-0x00000000*/ R6EngineEnums.ESoundSlot m_eSoundSlot;

    structdefaultproperties
    {
        Time=0.0000000
        Sound=none
        m_eSoundSlot=0
    }
};

var array<SoundTrackKey> Sounds;
var() bool bContinueSoundOnMatineeEnd;
var bool m_bAddedThroughCommManager;

defaultproperties
{
    TrackInstClass=Class'InterpTrackInstSound'
    TrackTitle="Sound"
}