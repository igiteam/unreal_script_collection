class R6SoundExplosionParams extends R6Config
    native
    hidecategories(Object);

var(R6Sound) /*0x04000000-0x00000000*/ array<SoundCue> m_ExplosionSoundMono;
var(R6Sound) /*0x04000000-0x00000000*/ SoundCue m_ExplosionSoundStereo;
var(R6Sound) /*0x04000000-0x00000000*/ SoundCue m_SpecialEffectSound;
var(R6Sound) /*0x04000000-0x00000000*/ SoundCue m_SpecialEffectStopSound;
var(R6Sound) /*0x04000000-0x00000000*/ float m_fMaxSpecialEffectSoundDuration;
var(R6Sound) /*0x04000000-0x00000000*/ SoundCue m_HitWallSound;
var(R6Sound) /*0x04000000-0x00000000*/ SoundCue m_HitGroundSound;

defaultproperties
{
    m_fMaxSpecialEffectSoundDuration=20.0000000
    m_HitWallSound=SoundCue'Dare.Player.Play_E_Grenades_WallImpact'
    m_HitGroundSound=SoundCue'Dare.Player.Play_E_Grenades_GroundImpact'
    m_szDescription="R6SoundExplosionParams"
}