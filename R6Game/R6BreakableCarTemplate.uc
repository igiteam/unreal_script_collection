class R6BreakableCarTemplate extends R6_BreakableActorTemplate
    native;

var() editconstarray array<float> m_afWheelRestOffset;
var(BuildData) editconst array<int> m_aiWheelIndex;
var(BuildData) editconst int m_iChassisIndex;
var(BuildData) editconst array<int> m_aiDoorIndex;
var(BuildData) editconst array<int> m_aiGlassIndex;
var() float m_fDestroyChassisSpeed;
var() float m_fSpring;
var() float m_fDamping;
var() float m_fWheelHP;
var() float m_fDoorHP;
var() float m_fChassisHP;
var() editconstarray array<MaterialInstance> m_aDestroyMaterials;
var() MaterialInstance m_pShatteredGlassMaterial;
var() MaterialInstance m_pBrokenGlassMaterial;
var() ParticleSystem m_pBrokenGlassEffect;
var() ParticleSystem m_pBrokenDoorEffect;
var() ParticleSystem m_pBrokenWheelEffect;
var() ParticleSystem m_pDestroyEffect;
var() /*0x40000000-0x00000000*/ R6ExplosionParams m_pDestroyParams;
var(Sound) /*0x44000000-0x00000000*/ R6SoundExplosionParams m_pDestroySoundParams;
var(Sound) /*0x04000000-0x00000000*/ SoundCue m_pBrokenGlassSound;
var(Sound) /*0x04000000-0x00000000*/ SoundCue m_pChassisImpactSound;
var(Sound) /*0x04000000-0x00000000*/ SoundCue m_pShockAbsorberSound;
var(Sound) /*0x04000000-0x00000000*/ SoundCue m_pBrokenDoorSound;
var(Sound) /*0x04000000-0x00000000*/ SoundCue m_pDoorSmallImpactSound;
var(Sound) /*0x04000000-0x00000000*/ SoundCue m_pDoorBigImpactSound;
var(Sound) /*0x44000000-0x00000000*/ R6SoundMaterial m_pWheelSoundMaterial;

defaultproperties
{
    m_fDestroyChassisSpeed=500.0000000
    m_fSpring=50000.0000000
    m_fDamping=200.0000000
    m_fWheelHP=100.0000000
    m_fDoorHP=100.0000000
    m_fChassisHP=500.0000000
}