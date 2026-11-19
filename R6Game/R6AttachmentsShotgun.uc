class R6AttachmentsShotgun extends R6WeaponAttachments
    native
    notplaceable
    hidecategories(lighting);

simulated event StartBulletEjectEffect()
{
    return;
}

defaultproperties
{
    m_RightHandAttachSocketFP="R65_Shotgun_RHand"
    m_LeftHandAttachSocketFP="R65_Shotgun_LHand"
    m_MuzzleFlashParticleSystemFP=ParticleSystem'Keller_SFX.muzzleFX_1st_person.AssaultRifle_Shotgun_flash_1st'
    m_MuzzleFlashParticleSystemTP=ParticleSystem'Keller_SFX.muzzleFX_1st_person.AssaultRifle_Shotgun_flash_1st'
    // Reference: StaticMeshComponent'Default__R6AttachmentsShotgun.MagazineMeshComponentFP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6WeaponAttachments.MagazineMeshComponentFP'
    begin object name="MagazineMeshComponentFP"
        StaticMesh=StaticMesh'Keller_SFX.gun_discharge.12GAshell'
    end object
    m_MagazineMeshFP=MagazineMeshComponentFP
    // Reference: StaticMeshComponent'Default__R6AttachmentsShotgun.MagazineMeshComponentTP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6WeaponAttachments.MagazineMeshComponentTP'
    begin object name="MagazineMeshComponentTP"
        StaticMesh=StaticMesh'Keller_SFX.gun_discharge.12GAshell'
    end object
    m_MagazineMeshTP=MagazineMeshComponentTP
    m_ThrownMagazineMesh=MagazineMeshComponentTP
    m_BulletCaseParticleSystemFP=ParticleSystem'Keller_SFX.gun_discharge.12ga_eject_PT'
    m_BulletCaseParticleSystemTP=ParticleSystem'Keller_SFX.gun_discharge.12ga_eject_PT'
}