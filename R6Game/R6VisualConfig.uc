class R6VisualConfig extends R6Config
    native
    hidecategories(Object);

struct R6VisualConfigNoise
{
    var() Texture2D m_Texture;
    var() bool m_bNoiseOnU;
    var() bool m_bNoiseOnV;
    var() float m_fScale;
    var() float m_fBrightness;
    var() float m_fSpeed;

    structdefaultproperties
    {
        m_Texture=none
        m_bNoiseOnU=true
        m_bNoiseOnV=true
        m_fScale=1.0000000
        m_fBrightness=1.0000000
        m_fSpeed=5.0000000
    }
};

var(NightVision) float m_fNightVisionAmbiantBoost;
var(NightVision) float m_fNightVisionSensitivity;
var(NightVision) float m_fNightVisionMaterialSensitivity;
var(HeatVision) float m_fHeatVisionDefaultValue;
var(HeatVision) float m_fHeatVisionFar;
var(HeatVision) float m_fHeatVisionPerturbation;
var(HeatVision) float m_fHeatVisionPlayerAttenuation;
var(HeatVision) float m_fHeatVisionTerroObstacleAttenuation;
var(HeatVision) float m_fHeatVisionConstantAttenuation;
var(HeatVision) Color m_HeatVisionReticuleColor;
var(HeatVisionCoolDown) float m_fCoolDownRate;
var(HeatVisionCoolDown) float m_fCoolDownMinHeat;
var(PIP_Texture) int m_iWidth;
var(PIP_Texture) int m_iHeight;
var(BulletTracer) MaterialInstance m_Material;
var(BulletTracer) MaterialInstance m_HeatMaterial;
var(BulletTracer) float m_fBulletTracersLength;
var(BulletTracer) float m_fBulletTracersHeight;
var(BulletTracer) float m_fBulletTracersSpeed;
var(BulletTracer) Color m_BulletTracersRainbowColor;
var(BulletTracer) Color m_BulletTracersTerroColor;
var(VisualEffect) float m_fMaxMotionBlurEffect;
var(VisualEffect) float m_fMaxGaussianBlurEffect;
var(VisualEffect) float m_fMaxFlashEffect;
var(VisualEffect) bool m_bEnableEyeAdaptation;
var(VisualEffect) float m_fEyeAdaptationTime;
var(VisualEffect) float m_fEyeAdaptationEffect;
var(VisualEffect) float m_fEyeAdaptationDarkCurve;
var(TextureQuality) int m_iGlobalTextureLODBias;
var(GasMask) float m_fFlashbangReduction;
var(GasMask) float m_fHinderedView;
var(ColorGel) float m_fFireFightColorGelMul;
var(ColorGel) float m_fDampFireFightGel;
var(ColorGel) int m_iNbTerroToStartFireFightGel;
var(ColorGel) int m_iNbTerroToStopFireFightGel;
var(Fog) float m_fFogInterpSpeed;
var(ColorGel) float m_fColorGelInterpSpeed;
var(PostProcess) float m_fInterLevelInterpSpeed;
var(MotionBlur) float m_fFirstPersonMotionBlurScale;
var(MotionBlur) float m_fThirdPersonMotionBlurScale;
var(Fire) ParticleSystem m_fireParticleSystem;
var(Fire) MaterialInstance m_fireBurnMaterial;
var(Reticule) LinearColor m_DefaultColor;
var(Reticule) LinearColor m_FriendsColor;
var(Reticule) LinearColor m_EnemiesColor;
var(Reticule) LinearColor m_FriendsHurtColor;
var(Reticule) float m_fSpreadPercentage;
var(Reticule) Texture2D m_SpreadLineTexture;
var(Reticule) Texture2D m_CircleTexture;
var(Reticule) Texture2D m_CircleLargeTexture;
var(Reticule) Texture2D m_CenterDotTexture;
var(Reticule) Texture2D m_BlindFireTexture;
var(Reticule) float m_fLargeTexThreshold;
var(Reticule) float m_fSecondCircleThreshold;
var(Reticule) int m_iArrowsPixelsInCircle;
var(Reticule) int m_iArrowsMinDistToCenter;
var(Reticule) Texture2D m_CenterFriendTexture;
var(HUD) float m_WeaponInfoShownTime;
var(BSP) MaterialInstance m_BSPSeeThroughMaterial;
var(BSP) MaterialInstance m_BSPPortalMaterial;
var(BSP) MaterialInstance m_BSPCaulkMaterial;
var(Gamma) float m_fGammaDefault;
var(Gamma) float m_fGammaDefaultXbox;
var(DeadBodies) float m_fDisappearTime;
var(DeadBodies) float m_fDisappearDistance;
var(WayPoint3D) StaticMesh m_3DWayPointStaticMesh;
var(Pickups) float m_fPickupDisappearTime;

defaultproperties
{
    m_fNightVisionSensitivity=1.0000000
    m_fHeatVisionPlayerAttenuation=0.5500000
    m_fHeatVisionTerroObstacleAttenuation=12.0000000
    m_fHeatVisionConstantAttenuation=0.7000000
    m_HeatVisionReticuleColor=(R=255,G=0,B=0,A=0)
    m_iWidth=128
    m_iHeight=128
    m_fMaxMotionBlurEffect=0.9000000
    m_fMaxGaussianBlurEffect=1.0000000
    m_fMaxFlashEffect=1.0000000
    m_fEyeAdaptationTime=2.0000000
    m_fEyeAdaptationEffect=1.0000000
    m_fEyeAdaptationDarkCurve=1.0000000
    m_fFlashbangReduction=80.0000000
    m_fHinderedView=25.0000000
    m_fFireFightColorGelMul=2.0000000
    m_fDampFireFightGel=0.5000000
    m_iNbTerroToStartFireFightGel=4
    m_iNbTerroToStopFireFightGel=2
    m_fFogInterpSpeed=3.0000000
    m_fColorGelInterpSpeed=3.0000000
    m_fFirstPersonMotionBlurScale=8.0000000
    m_fThirdPersonMotionBlurScale=10.0000000
    m_DefaultColor=(R=0.0000000,G=0.0000000,B=0.0000000,A=0.0000000)
    m_FriendsColor=(R=0.0000000,G=0.0000000,B=0.0000000,A=0.0000000)
    m_EnemiesColor=(R=0.0000000,G=0.0000000,B=0.0000000,A=0.0000000)
    m_FriendsHurtColor=(R=0.0000000,G=0.0000000,B=0.0000000,A=0.0000000)
    m_fSpreadPercentage=9.0000000
    m_fLargeTexThreshold=1.1500000
    m_fSecondCircleThreshold=1.2500000
    m_iArrowsPixelsInCircle=4
    m_iArrowsMinDistToCenter=5
    m_WeaponInfoShownTime=1.0000000
    m_fGammaDefault=1.8000000
    m_fGammaDefaultXbox=1.4700000
    m_fDisappearTime=5.0000000
    m_fDisappearDistance=2500.0000000
    m_fPickupDisappearTime=60.0000000
    m_szThumbnailTexture="KellerEditorMaterials.Visuals"
    m_szDescription="FX and Visual options"
}