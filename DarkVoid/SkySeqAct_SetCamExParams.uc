class SkySeqAct_SetCamExParams extends SeqAct_Latent
    native;

var() bool bResetToDefaults;
var() float TargetLuminance;
var() float AdaptationRate;
var() float MinimumLuminanceScale;
var() float MaximumLuminanceScale;
var() float InterpolateSeconds;
var float InterpolateElapsed;
