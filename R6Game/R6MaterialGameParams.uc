class R6MaterialGameParams extends R6Config
    native
    hidecategories(Object);

var(Damage) float m_fSolidity;
var(ImpactA) ParticleSystem m_bulletImpactEffect;
var(ImpactA) ParticleSystem m_bulletIneffectiveImpactEffect;
var(ImpactA) ParticleSystem m_bulletImpactExitEffect;
var(ImpactA) Rotator m_rEffectRandom;
var(ImpactA) bool m_bExitWithBulletDirection;
var(ImpactB) bool m_bExitWithBulletDirectionB;
var(ImpactB) float m_fEffectBProbability;
var(ImpactB) ParticleSystem m_bulletImpactEffectB;
var(ImpactB) ParticleSystem m_bulletIneffectiveImpactEffectB;
var(ImpactB) ParticleSystem m_bulletImpactExitEffectB;
var(ImpactB) Rotator m_rEffectRandomB;
var(ImpactMark) R6DecalCreationInfo m_ImpactDecal;

defaultproperties
{
    m_fSolidity=1000000.0000000
    m_rEffectRandom=(Pitch=1820,Yaw=1820,Roll=1820)
    m_bExitWithBulletDirection=true
    m_bExitWithBulletDirectionB=true
    m_rEffectRandomB=(Pitch=1820,Yaw=1820,Roll=1820)
    m_ImpactDecal=(m_iStart=(X=45,Y=4),m_iSize=(X=45,Y=4),m_fScale=0.0000000,m_fScaleJitter=1.2000000,m_fProjectionDistance=2.0000000)
    m_szDescription="R6MaterialGameParams"
}