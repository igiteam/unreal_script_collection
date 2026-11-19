class R6AttachmentsSubMAC11 extends R6AttachmentsSMG
    notplaceable
    hidecategories(lighting);

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__R6AttachmentsSubMAC11.FPWeaponSkelMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6AttachmentsSMG.FPWeaponSkelMesh'
    begin object name="FPWeaponSkelMesh"
        SkeletalMesh=SkeletalMesh'RS5Weapons.SMG.W_SMG_MAC11'
        PhysicsAsset=PhysicsAsset'RS5Weapons.SMG.W_SMG_MAC11_Physics'
        AnimSets[0]=AnimSet'Anims_Props_Weapons_1st2.02_SMGs.MAC11'
    end object
    m_WeaponMeshFP=FPWeaponSkelMesh
    // Reference: SkeletalMeshComponent'Default__R6AttachmentsSubMAC11.TPWeaponSkelMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6AttachmentsSMG.TPWeaponSkelMesh'
    begin object name="TPWeaponSkelMesh"
        SkeletalMesh=SkeletalMesh'RS5Weapons.SMG.W_SMG_MAC11'
        PhysicsAsset=PhysicsAsset'RS5Weapons.SMG.W_SMG_MAC11_Physics'
        AnimSets[0]=AnimSet'Anims_Props_Weapons_3rd.MG'
        AnimSets[1]=AnimSet'Anims_Props_Weapons_3rd.02_SMGs.MAC11'
    end object
    m_WeaponMeshTP=TPWeaponSkelMesh
    m_RightHandAttachSocketFP="R65_MAC11_RHand"
    m_LeftHandAttachSocketFP="R65_MAC11_LHand"
    m_RightHandAttachSocketTP="R65_Pistol_RHand"
    m_LeftHandAttachSocketTP="R65_Pistol_LHand"
    // Reference: StaticMeshComponent'Default__R6AttachmentsSubMAC11.MagazineMeshComponentFP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6AttachmentsSMG.MagazineMeshComponentFP'
    begin object name="MagazineMeshComponentFP"
        StaticMesh=StaticMesh'RS5Weapons.Magazines.W_Mag_MAC11'
    end object
    m_MagazineMeshFP=MagazineMeshComponentFP
    // Reference: StaticMeshComponent'Default__R6AttachmentsSubMAC11.MagazineMeshComponentTP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6AttachmentsSMG.MagazineMeshComponentTP'
    begin object name="MagazineMeshComponentTP"
        StaticMesh=StaticMesh'RS5Weapons.Magazines.W_Mag_MAC11'
    end object
    m_MagazineMeshTP=MagazineMeshComponentTP
    m_ThrownMagazineMesh=MagazineMeshComponentTP
    m_BulletCaseParticleSystemFP=ParticleSystem'Keller_SFX.gun_discharge.9mmSMG_eject_PT'
    m_BulletCaseParticleSystemTP=ParticleSystem'Keller_SFX.gun_discharge.9mmSMG_eject_PT'
}