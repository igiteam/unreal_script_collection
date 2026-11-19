class MusicTrackDataStructures extends Object
    native;

struct MusicTrackParamStruct
{
    structcpptext
    {

	
    }

    var() float FadeInTime;
    var() float FadeInVolumeLevel;
    var() float DelayBetweenOldAndNewTrack;
    var() float FadeOutTime;
    var() float FadeOutVolumeLevel;

    structdefaultproperties
    {
        FadeInTime=5.0000000
        FadeInVolumeLevel=1.0000000
        DelayBetweenOldAndNewTrack=0.0000000
        FadeOutTime=5.0000000
        FadeOutVolumeLevel=0.0000000
    }
};

struct MusicTrackStruct
{
    var() /*0x04000000-0x00000000*/ MusicTrackParamStruct Params;
    var() /*0x04000000-0x00000000*/ name TrackType;
    var() /*0x04000000-0x00000000*/ SoundCue TheSoundCue;

    structdefaultproperties
    {
        Params=(FadeInTime=0.0000000,FadeInVolumeLevel=0.0000000,DelayBetweenOldAndNewTrack=0.0000000,FadeOutTime=0.0000000,FadeOutVolumeLevel=0.0000000)
        TrackType="None"
        TheSoundCue=none
    }
};
