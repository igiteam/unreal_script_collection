class R6AttachmentsSniper extends R6WeaponAttachments
    native
    notplaceable
    hidecategories(lighting);

defaultproperties
{
    m_RightHandAttachSocketFP="R65_Sniper_RHand"
    m_LeftHandAttachSocketFP="R65_Sniper_LHand"
    m_MuzzleFlashParticleSystemFP=ParticleSystem'Keller_SFX.muzzleFX_1st_person.AssaultRifle_NoSide_flash_1st'
    m_MuzzleFlashParticleSystemTP=ParticleSystem'Keller_SFX.muzzleFX_1st_person.AssaultRifle_NoSide_flash_1st'
    m_BulletCaseParticleSystemFP=ParticleSystem'Keller_SFX.gun_discharge.Sniper_eject_PT'
    m_BulletCaseParticleSystemTP=ParticleSystem'Keller_SFX.gun_discharge.Sniper_eject_PT'
}