class R6AccuracyConfig extends R6Config
    native
    hidecategories(Object);

struct SAutoAimBone
{
    var() string m_szBoneName;
    var() float m_fWeight;

    structdefaultproperties
    {
        m_szBoneName=""
        m_fWeight=0.0000000
    }
};

struct SZoomModifier
{
    var const R6EngineEnums.EZoomType m_eZoomType;
    var() float m_fBulletSpreadModifier;
    var() float m_fAutoAimRadiusModifier;
    var() bool m_bShowReticle;
    var() bool m_bShowReticleInTakeCover;

    structdefaultproperties
    {
        m_eZoomType=0
        m_fBulletSpreadModifier=1.0000000
        m_fAutoAimRadiusModifier=1.0000000
        m_bShowReticle=true
        m_bShowReticleInTakeCover=true
    }
};

var(ZoomModifier) editconst array<SZoomModifier> m_ZoomModifiers;
var(AccuracyModifiers) float m_fOverallAccuracyModifier;
var(AccuracyModifiers) float m_fPlayerAccuracyModifierNormal;
var(AccuracyModifiers) float m_fPlayerAccuracyModifierVeteran;
var(AccuracyModifiers) float m_fPlayerAccuracyModifierElite;
var(AutoAim) SInterpParams m_magnetInterpParams;
var(AutoAim) /*0x20000000-0x00000000*/ int m_iInnerMagnetRange;
var(AutoAim) /*0x20000000-0x00000000*/ int m_iOuterMagnetRange;
var(AutoAim) array<SAutoAimBone> m_pawnAutoAimBones;
var(AutoAim) float m_fMaxAutoAimDistance;
var(BlindFireBulletSpread) float m_fBlindFireBulletSpreadInterpSpeed;
var(ShotgunLaser) float m_fShotgunWithLaserBulletSpreadMod;
var(Accuracy) float m_fAccuracyInterpSpeed;
var(MovementReticle) bool m_bReticleDisapearWhileMovingSP;
var(MovementReticle) bool m_bReticleDisapearWhileMovingMP;
var(MovementReticle) float m_fReticleDisapearMinVelocity;
var(MovementReticle) float m_fReticleDisapearMaxVelocity;
var(MovementReticle) float m_fReticleDisapearSmoothTime;

// Export UR6AccuracyConfig::execGetBulletSpreadModifierFor(FFrame&, void* const)
native final function float GetBulletSpreadModifierFor(R6EngineEnums.EZoomType eScope);

// Export UR6AccuracyConfig::execGetAutoAimRadiusModifierFor(FFrame&, void* const)
native final function float GetAutoAimRadiusModifierFor(R6EngineEnums.EZoomType eScope);

// Export UR6AccuracyConfig::execDoShowReticleFor(FFrame&, void* const)
native final function bool DoShowReticleFor(R6EngineEnums.EZoomType eScope, bool bInTakeCover);

defaultproperties
{
    m_ZoomModifiers[0]=(m_eZoomType=0,m_fBulletSpreadModifier=1.0000000,m_fAutoAimRadiusModifier=1.0000000,m_bShowReticle=true,m_bShowReticleInTakeCover=true)
    m_ZoomModifiers[1]=(m_eZoomType=1,m_fBulletSpreadModifier=1.0000000,m_fAutoAimRadiusModifier=1.0000000,m_bShowReticle=true,m_bShowReticleInTakeCover=true)
    m_ZoomModifiers[2]=(m_eZoomType=2,m_fBulletSpreadModifier=1.0000000,m_fAutoAimRadiusModifier=1.0000000,m_bShowReticle=true,m_bShowReticleInTakeCover=true)
    m_ZoomModifiers[3]=(m_eZoomType=3,m_fBulletSpreadModifier=1.0000000,m_fAutoAimRadiusModifier=1.0000000,m_bShowReticle=true,m_bShowReticleInTakeCover=true)
    m_ZoomModifiers[4]=(m_eZoomType=4,m_fBulletSpreadModifier=1.0000000,m_fAutoAimRadiusModifier=1.0000000,m_bShowReticle=true,m_bShowReticleInTakeCover=true)
    m_ZoomModifiers[5]=(m_eZoomType=5,m_fBulletSpreadModifier=1.0000000,m_fAutoAimRadiusModifier=1.0000000,m_bShowReticle=true,m_bShowReticleInTakeCover=true)
    m_fOverallAccuracyModifier=1.0000000
    m_fPlayerAccuracyModifierNormal=1.5000000
    m_fPlayerAccuracyModifierVeteran=1.0000000
    m_fPlayerAccuracyModifierElite=0.7500000
    m_magnetInterpParams=(m_eMode=1,m_fModifierA=1.0000000,m_fModifierB=4.0000000)
    m_iOuterMagnetRange=521
    m_pawnAutoAimBones[0]=(m_szBoneName="R65_BA_Spine",m_fWeight=1.0000000)
    m_fMaxAutoAimDistance=500000.0000000
    m_fBlindFireBulletSpreadInterpSpeed=5.0000000
    m_fShotgunWithLaserBulletSpreadMod=0.7000000
    m_fAccuracyInterpSpeed=5.0000000
    m_bReticleDisapearWhileMovingSP=true
    m_bReticleDisapearWhileMovingMP=true
    m_fReticleDisapearMinVelocity=100.0000000
    m_fReticleDisapearMaxVelocity=10.0000000
    m_fReticleDisapearSmoothTime=0.2000000
    m_szThumbnailTexture="KellerEditorMaterials.Accuracy"
    m_szDescription="Accuracy configuration"
}