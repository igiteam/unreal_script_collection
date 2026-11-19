class SkySeqAct_SetDOFParams extends SeqAct_Latent
    native;

var() bool bResetToDefaults;
var() float BlurKernelSize;
var deprecated array<float> FocusDistances;
var deprecated array<float> FocusBlurAmounts;
var() DOF_Distance NewFocusDistances;
var() DOF_BlurAmount NewFocusBlurAmounts;
var() float InterpolateSeconds;
var float InterpolateElapsed;
