class R6SoundMaterial extends R6Config
    native
    hidecategories(Object);

var() /*0x04000000-0x00000000*/ SoundCue m_pSmallImpactSound;
var() /*0x04000000-0x00000000*/ SoundCue m_pMediumImpactSound;
var() /*0x04000000-0x00000000*/ SoundCue m_pBigImpactSound;
var() /*0x04000000-0x00000000*/ SoundCue m_pRollSound;
var() /*0x04000000-0x00000000*/ SoundCue m_pRollStopSound;
var() /*0x04000000-0x00000000*/ SoundCue m_pSlideSound;
var() /*0x04000000-0x00000000*/ SoundCue m_pSlideStopSound;
var const float m_fNoImpactSpeed;
var const float m_fMediumImpactSpeed;
var const float m_fBigImpactSpeed;

defaultproperties
{
    m_fNoImpactSpeed=5.0000000
    m_fMediumImpactSpeed=10.0000000
    m_fBigImpactSpeed=20.0000000
    m_szDescription="Sound Material"
}