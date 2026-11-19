class TurokFEAudio extends Object
    native;

enum eTurokFESoundID
{
    eFESound_Up,                    // 0
    eFESound_Down,                  // 1
    eFESound_Left,                  // 2
    eFESound_Right,                 // 3
    eFESound_Reject,                // 4
    eFESound_Accept,                // 5
    eFESound_Back,                  // 6
    eFESound_Helpbar_In,            // 7
    eFESound_Helpbar_Out,           // 8
    eFESound_PopUp_In,              // 9
    eFESound_PopUp_Out,             // 10
    eFESound_Overlay_In,            // 11
    eFESound_Overlay_Out,           // 12
    eFESound_None,                  // 13
    eFESound_MAX                    // 14
};

enum eTurokFEMusicID
{
    eFEMusic_MainMenu,              // 0
    eFEMusic_MPMenu,                // 1
    eFEMusic_MAX                    // 2
};

struct native transient TurokFEMusicLevel
{
    var init array mChanLevels;

    structdefaultproperties
    {
        mChanLevels=none
    }
};

struct native transient TurokFESound
{
    var init byte mSoundID;
    var init @NULL mSoundCue;
    var init @NULL mDebugSoundCue;
    var init export editinline @NULL mAudioComponent;
    var init bool mIsPlaying;

    structdefaultproperties
    {
        mSoundID=13
        mSoundCue=none
        mDebugSoundCue=none
        mAudioComponent=none
        mIsPlaying=false
    }
};

var array mTurokFESounds;
var array mTurokFEMusicChannels;
var array mTurokFEMusicLevels;
var bool mbIsDebugSounds;

// Export UTurokFEAudio::execPlayFESound(FFrame&, void* const)
native function bool PlayFESound(byte eSoundID);

// Export UTurokFEAudio::execPlayFESoundDirect(FFrame&, void* const)
native function @NULL PlayFESoundDirect(@NULL sSound);

// Export UTurokFEAudio::execIsFESoundPlaying(FFrame&, void* const)
native function bool IsFESoundPlaying(byte eSoundID);

// Export UTurokFEAudio::execIsFESoundDirectPlaying(FFrame&, void* const)
native function bool IsFESoundDirectPlaying(@NULL acCheck);

// Export UTurokFEAudio::execPauseFESound(FFrame&, void* const)
native function PauseFESound();

// Export UTurokFEAudio::execResumeFESound(FFrame&, void* const)
native function ResumeFESound();

// Export UTurokFEAudio::execSetGlobalMusicVolume(FFrame&, void* const)
native function SetGlobalMusicVolume(float fValue);

// Export UTurokFEAudio::execGetGlobalMusicVolume(FFrame&, void* const)
native function float GetGlobalMusicVolume(optional bool bUseBaseSetting);

// Export UTurokFEAudio::execSetGlobalSFXVolume(FFrame&, void* const)
native function SetGlobalSFXVolume(float fValue);

// Export UTurokFEAudio::execGetGlobalSFXVolume(FFrame&, void* const)
native function float GetGlobalSFXVolume(optional bool bUseBaseSetting);

// Export UTurokFEAudio::execSetGlobalSpeechVolume(FFrame&, void* const)
native function SetGlobalSpeechVolume(float fValue);

// Export UTurokFEAudio::execGetGlobalSpeechVolume(FFrame&, void* const)
native function float GetGlobalSpeechVolume(optional bool bUseBaseSetting);

// Export UTurokFEAudio::execPlayFEMusic(FFrame&, void* const)
native function bool PlayFEMusic(byte eMusicID);

// Export UTurokFEAudio::execStopFEMusic(FFrame&, void* const)
native function bool StopFEMusic(byte eMusicID, optional float fFadeOutTime);

// Export UTurokFEAudio::execSetFEMusicDepth(FFrame&, void* const)
native function SetFEMusicDepth(byte eMusicID, int iDepth, const optional float kFadeTime);

// Export UTurokFEAudio::execIsMusicPlaying(FFrame&, void* const)
native function bool IsMusicPlaying(byte eMusicID);

// Export UTurokFEAudio::execSetFEMusicVolume(FFrame&, void* const)
native function bool SetFEMusicVolume(byte eMusicID, float Volume, optional float fFadeOutTime);

// Export UTurokFEAudio::execToggleDebugFEAudio(FFrame&, void* const)
native function ToggleDebugFEAudio();

defaultproperties
{
    mTurokFESounds=/* Array type was not detected. */
    mTurokFEMusicChannels=/* Array type was not detected. */
    mTurokFEMusicLevels=/* Array type was not detected. */
}