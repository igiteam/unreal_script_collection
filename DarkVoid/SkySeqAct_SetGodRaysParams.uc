class SkySeqAct_SetGodRaysParams extends SeqAct_Latent
    native;

var() float Exposure;
var() float Decay;
var() float Weight;
var deprecated float Density;
var() float StartFadeAngle;
var() float FinishFadeAngle;
var() float MinDensityDistance;
var() float MinDensity;
var() float MaxDensityDistance;
var() float MaxDensity;
var() Vector SunPosition;
var() float SunRadius;
var() LinearColor SunColor;
var() float GaussianBlurRadius;
var() float FarOccluderDepth;
var() float CloseOccluderDepth;
var() bool bUseSceneSampling;
var() bool bResetToDefaults;
var() float InterpolateSeconds;
var float InterpolateElapsed;
