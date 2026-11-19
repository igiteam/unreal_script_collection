class R6PostProcessParam extends R6Config
    native
    hidecategories(Object);

enum EBlurMethod
{
    BM_Gaussian,                    // 0
    BM_Radial,                      // 1
    BM_MAX                          // 2
};

var(Distortion) float m_fDistortionStrength;
var(Distortion) float m_fDistortionScale;
var(Distortion) bool m_bDistortionAllowInEditor;
var(BlurCommon) bool m_bBlurRed;
var(BlurCommon) bool m_bBlurGreen;
var(BlurCommon) bool m_bBlurBlue;
var(BlurCommon) bool m_bBlurAlpha;
var(BlurCommon) bool m_bBlurAllowInEditor;
var(EdgeBlur) bool m_bEdgeBlurAllowInEditor;
var(DOF) bool m_bDOFAllowInEditor;
var(ColorGel) bool m_bColorGelAllowInEditor;
var(SceneAdjustment) bool m_bSceneAllowInEditor;
var(Noise) bool m_bNoiseAllowInEditor;
var(EyeAdaptation) bool m_bEyeAdaptationAllowInGame;
var transient bool m_bDistortionEnable;
var transient bool m_bBlurEnable;
var transient bool m_bBlurRadialEnable;
var transient bool m_bEdgeBlurEnable;
var transient bool m_bMotionBlurEnable;
var transient bool m_bMotionBlurSkipFrame;
var transient bool m_bDOFEnable;
var transient bool m_bNightVisionEnable;
var transient bool m_bHeatVisionEnable;
var transient bool m_bColorGelEnable;
var transient bool m_bSceneEnable;
var transient bool m_bNoiseEnable;
var transient bool m_bEyeAdaptationEnable;
var transient bool m_bRetinaImprintNegate;
var transient bool m_bRetinaImprintDesaturate;
var transient bool m_bRetinaImprintGrab;
var transient bool m_bRetinaImprintEnable;
var(BlurCommon) R6PostProcessParam.EBlurMethod m_eBlurMethod;
var(BlurGaussian) float m_fBlurAmount;
var(BlurRadial) int m_iBlurRadialNbIteration;
var(BlurRadial) float m_fBlurRadialStrength;
var(Bloom) float m_fGlowAmount;
var(Bloom) float m_fBlurScreenAmount;
var(Bloom) float m_fBlurScreenThresold;
var(EdgeBlur) float m_fEdgeBlurStrength;
var(EdgeBlur) Texture2D m_EdgeBlurMask;
var(EdgeBlur) Vector2D m_vEdgeBlurOffset;
var(EdgeBlur) Vector2D m_vEdgeBlurScale;
var(MotionBlur) float m_fMotionBlurMaxVelocity;
var(MotionBlur) float m_fMotionBlurBlurAmount;
var(DOF) float m_fDOFStrength;
var(DOF) float m_fDOFFocus;
var(DOF) float m_fDOFLength;
var(DOF) float m_fDOFFalloffDistance;
var(DOF) float m_fDOFFalloffStrength;
var(DOF) Color m_DOFColor;
var float m_fDOFTensor;
var(NightVision) Texture2D m_NightVisionMapping;
var(HeatVision) Texture2D m_HeatVisionMapping;
var(SceneAdjustment) Vector m_vSceneBrightness;
var(SceneAdjustment) Vector m_vSceneContrast;
var(SceneAdjustment) Vector m_vSceneSaturation;
var(Noise) Texture2D m_NoiseTexture;
var(Noise) float m_fNoiseScale;
var(Noise) float m_fNoiseBrightness;
var(Noise) float m_fNoiseSpeed;
var(EyeAdaptation) float m_fEyeAdaptationTime;
var(EyeAdaptation) float m_fEyeAdaptationStrength;
var(EyeAdaptation) float m_fEyeAdaptationDarkCurve;
var transient float m_fRetinaImprintOpacity;

defaultproperties
{
    m_fDistortionScale=1.0000000
    m_bDistortionAllowInEditor=true
    m_bBlurRed=true
    m_bBlurGreen=true
    m_bBlurBlue=true
    m_bBlurAllowInEditor=true
    m_bEdgeBlurAllowInEditor=true
    m_bDOFAllowInEditor=true
    m_bColorGelAllowInEditor=true
    m_bSceneAllowInEditor=true
    m_bNoiseAllowInEditor=true
    m_iBlurRadialNbIteration=5
    m_fBlurRadialStrength=1.0000000
    m_fGlowAmount=1.0000000
    m_fBlurScreenAmount=0.5000000
    m_fEdgeBlurStrength=1.0000000
    m_vEdgeBlurScale=(X=0.0000000,Y=0.0000000)
    m_fMotionBlurMaxVelocity=0.1500000
    m_fMotionBlurBlurAmount=0.0750000
    m_fDOFStrength=1.0000000
    m_fDOFFalloffDistance=0.5000000
    m_fDOFFalloffStrength=0.5000000
    m_DOFColor=(R=255,G=255,B=255,A=255)
    m_fDOFTensor=1.0000000
    m_vSceneBrightness=(X=1.0000000,Y=1.0000000,Z=1.0000000)
    m_vSceneContrast=(X=1.0000000,Y=1.0000000,Z=1.0000000)
    m_vSceneSaturation=(X=1.0000000,Y=1.0000000,Z=1.0000000)
    m_fNoiseScale=1.0000000
    m_fNoiseSpeed=1.0000000
    m_fEyeAdaptationTime=2.0000000
    m_fEyeAdaptationStrength=0.6000000
    m_fEyeAdaptationDarkCurve=0.6000000
}