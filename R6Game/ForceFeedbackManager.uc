class ForceFeedbackManager extends Object within PlayerController
    abstract
    transient
    native;

var bool bAllowsForceFeedback;
var bool bIsPaused;
var ForceFeedbackWaveform FFWaveform;
var int CurrentSample;
var float ElapsedTime;
var float ScaleAllWaveformsBy;

// Export UForceFeedbackManager::execPlayForceFeedbackWaveform(FFrame&, void* const)
native simulated function PlayForceFeedbackWaveform(ForceFeedbackWaveform Waveform);

// Export UForceFeedbackManager::execStopForceFeedbackWaveform(FFrame&, void* const)
native simulated function StopForceFeedbackWaveform(optional ForceFeedbackWaveform Waveform);

// Export UForceFeedbackManager::execPauseWaveform(FFrame&, void* const)
native simulated function PauseWaveform(optional bool bPause, optional bool bPreventResume);

defaultproperties
{
    bAllowsForceFeedback=true
    ScaleAllWaveformsBy=1.0000000
}