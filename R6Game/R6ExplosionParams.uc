class R6ExplosionParams extends R6Config
    native
    hidecategories(Object);

var(Explosion) editinline array<editinline R6Effect> m_effects;
var(Explosion) bool m_bFastExplosion;
var(Explosion) bool m_bDoExplosionDecal;
var(Explosion) float m_fSoundRadius;
var(Explosion) Actor.AIEventType m_eSoundEventType;
var(ExplosionVisual) ParticleSystem m_particleSystem;
var(ExplosionVisual) int m_iMaxParticlesThresold;

defaultproperties
{
    m_bFastExplosion=true
    m_fSoundRadius=1000.0000000
    m_eSoundEventType=24
    m_szDescription="R6ExplosionParams"
}