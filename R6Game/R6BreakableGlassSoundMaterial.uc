class R6BreakableGlassSoundMaterial extends R6Config
    native
    hidecategories(Object);

var() /*0x04000000-0x00000000*/ SoundCue m_pBreakLarge;
var() /*0x04000000-0x00000000*/ SoundCue m_pBreakMedium;
var() /*0x04000000-0x00000000*/ SoundCue m_pBreakSmall;
var() /*0x04000000-0x00000000*/ SoundCue m_pCrackLarge;
var() /*0x04000000-0x00000000*/ SoundCue m_pCrackMedium;
var() /*0x04000000-0x00000000*/ SoundCue m_pCrackSmall;
var() /*0x04000000-0x00000000*/ SoundCue m_pExplodeLarge;
var() /*0x04000000-0x00000000*/ SoundCue m_pExplodeMedium;
var() /*0x04000000-0x00000000*/ SoundCue m_pExplodeSmall;
var() /*0x04000000-0x00000000*/ SoundCue m_pParticleLarge;
var() /*0x04000000-0x00000000*/ SoundCue m_pParticleMedium;
var() /*0x04000000-0x00000000*/ SoundCue m_pParticleSmall;
var() const int m_iParticleMediumNb;
var() const int m_iParticleLargeNb;
var() /*0x04000000-0x00000000*/ SoundCue m_pShardLarge;
var() /*0x04000000-0x00000000*/ SoundCue m_pShardMedium;
var() /*0x04000000-0x00000000*/ SoundCue m_pShardSmall;
var const float m_fShardMediumRatio;
var const float m_fShardLargeRatio;

defaultproperties
{
    m_iParticleMediumNb=5
    m_iParticleLargeNb=20
    m_fShardMediumRatio=0.1000000
    m_fShardLargeRatio=0.3000000
}