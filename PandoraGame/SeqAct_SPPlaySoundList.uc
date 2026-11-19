class SeqAct_SPPlaySoundList extends SeqAct_Latent
    native;

struct native SoundListAsset
{
    /** Sound cue to play on the targeted actor(s) */
    var() SoundCue mSoundCue;
    /** Volume multiplier propagated to audio component */
    var() float VolumeMultiplier;
    /** Pitch multiplier propagated to audio component */
    var() float PitchMultiplier;
    /** Time taken for sound to fade in when action is activated. */
    var() float FadeInTime;
    /** Time take for sound to fade out when Stop input is fired. */
    var() float FadeOutTime;
    /** Additional dead space to be applied before the sound is played */
    var() float PreDelay;
    var float PostDelay;
    var bool bSuppressSubtitles;
    var transient float StartTime;
    var transient bool IsPlaying;

    structdefaultproperties
    {
        mSoundCue=none
        VolumeMultiplier=1.0000000
        PitchMultiplier=1.0000000
        FadeInTime=0.0000000
        FadeOutTime=0.0000000
        PreDelay=0.0000000
        PostDelay=0.0000000
        bSuppressSubtitles=false
        StartTime=0.0000000
        IsPlaying=false
    }
};

var int nSoundsPlayed;
var bool IsDone;
var bool Override_with_Global_Settings;
var SoundListAsset Global_Settings;
/**  
 *Return the version number for this class.  Child classes should increment this method by calling Super then adding
 * a individual class version to the result.  When a class is first created, the number should be 0; each time one of the
 * link arrays is modified (VariableLinks, OutputLinks, InputLinks, etc.), the number that is added to the result of
 * Super.GetObjClassVersion() should be incremented by 1.
 * 
 * @returnthe version number for this specific class.
 */
var() array<SoundListAsset> SoundAssets;

static event int GetObjClassVersion()
{
    return super(SequenceObject).GetObjClassVersion() + 1;
    //return ReturnValue;    
}
