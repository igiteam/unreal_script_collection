class SkySeqAct_InteractiveMusic extends SequenceAction
    native;

enum InteractiveMusicTrackType
{
    IMTT_ADAPT,                     // 0
    IMTT_LOOP,                      // 1
    IMTT_MAX                        // 2
};

struct native InteractiveMusicChunk
{
    var() SoundCue Main;
    var() array<SoundCue> Alternates;

    structdefaultproperties
    {
        Main=none
        Alternates=none
    }
};

struct native InteractiveMusicTrackInfo
{
    var() string TrackName;
    var() SkySeqAct_InteractiveMusic.InteractiveMusicTrackType Type;
    var() SoundCue Intro;
    var() array<SoundCue> IntroAlt;
    var() SoundCue Outro;
    var() array<SoundCue> OutroAlt;
    var() array<InteractiveMusicChunk> Chunks;
    var() float TransitionTime;
    var() bool bFirstPlaythroughInSequence;
    var() float TrackVolumeMultiplier;

    structdefaultproperties
    {
        TrackName="Track Name"
        Type=IMTT_ADAPT
        Intro=none
        IntroAlt=none
        Outro=none
        OutroAlt=none
        Chunks=none
        TransitionTime=0.5000000
        bFirstPlaythroughInSequence=false
        TrackVolumeMultiplier=-1.0000000
    }
};

struct native InteractiveMusicPlaybackIndex
{
    var int Chunk;
    var int Alt;

    structdefaultproperties
    {
        Chunk=0
        Alt=0
    }
};

struct native RandomMusicSelection
{
    var int Chunk;
    var int Alt;
    var SoundCue Cue;

    structdefaultproperties
    {
        Chunk=0
        Alt=0
        Cue=none
    }
};

var() array<InteractiveMusicTrackInfo> Tracks;
var array<InteractiveMusicPlaybackIndex> PlaybackIndices;
var int ActiveTrackIndex;
var int ActiveAltIndex;
var int ActiveTrackOffset;
var bool bPlayingInOrderOnce;
var bool bIsRequestingStop;
var bool bIsRequestingKill;
var bool bPlayingIntro;
var bool bPlayingOutro;
var int PendingTrackIndex;
var int PendingAltIndex;
var() float VolumeMultiplier;

// Export USkySeqAct_InteractiveMusic::execGetAltCountForTrack(FFrame&, void* const)
native function int GetAltCountForTrack(int TrackIndex);

// Export USkySeqAct_InteractiveMusic::execGetTrackAndAltFromInput(FFrame&, void* const)
native function GetTrackAndAltFromInput(int InputIndex, out int TrackIndex, out int AltIndex);

// Export USkySeqAct_InteractiveMusic::execGetInputName(FFrame&, void* const)
native function string GetInputName(int TrackIndex, int AltIndex);

// Export USkySeqAct_InteractiveMusic::execGetNextCue(FFrame&, void* const)
native function SoundCue GetNextCue();

// Export USkySeqAct_InteractiveMusic::execGetTimeToNextChange(FFrame&, void* const)
native function float GetTimeToNextChange();

// Export USkySeqAct_InteractiveMusic::execShuffleCurrentTrack(FFrame&, void* const)
native function ShuffleCurrentTrack();

// Export USkySeqAct_InteractiveMusic::execPlayNextCue(FFrame&, void* const)
native function PlayNextCue();

static event int GetObjClassVersion()
{
    return super(SequenceObject).GetObjClassVersion() + 2;
    //return ReturnValue;    
}
