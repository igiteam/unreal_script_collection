class R6AttachmentsPistol extends R6WeaponAttachments
    native
    notplaceable
    hidecategories(lighting);

defaultproperties
{
    m_RightHandAttachSocketFP="R65_Pistol_RHand"
    m_LeftHandAttachSocketFP="R65_Pistol_LHand"
    m_RightHandAttachSocketTP="R65_Pistol_RHand"
    m_LeftHandAttachSocketTP="R65_Pistol_LHand"
    m_MuzzleFlashParticleSystemFP=ParticleSystem'Keller_SFX.muzzleFX_1st_person.pistol_flash_1st'
    m_MuzzleFlashParticleSystemTP=ParticleSystem'Keller_SFX.muzzleFX_3rd_person.pistol_flash_3rd'
}