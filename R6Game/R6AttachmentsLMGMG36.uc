class R6AttachmentsLMGMG36 extends R6AttachmentsLMG
    notplaceable
    hidecategories(lighting);

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__R6AttachmentsLMGMG36.FPWeaponSkelMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6AttachmentsLMG.FPWeaponSkelMesh'
    begin object name="FPWeaponSkelMesh"
        SkeletalMesh=SkeletalMesh'RS5Weapons.LMG.W_LMG_MG36'
        PhysicsAsset=PhysicsAsset'RS5Weapons.LMG.W_LMG_MG36_Physics'
        AnimSets[0]=AnimSet'Anims_Props_Weapons_1st2.04_LMGs.MG36'
    end object
    m_WeaponMeshFP=FPWeaponSkelMesh
    // Reference: SkeletalMeshComponent'Default__R6AttachmentsLMGMG36.TPWeaponSkelMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6AttachmentsLMG.TPWeaponSkelMesh'
    begin object name="TPWeaponSkelMesh"
        SkeletalMesh=SkeletalMesh'RS5Weapons.LMG.W_LMG_MG36'
        PhysicsAsset=PhysicsAsset'RS5Weapons.LMG.W_LMG_MG36_Physics'
        AnimSets[0]=AnimSet'Anims_Props_Weapons_3rd.MG'
    end object
    m_WeaponMeshTP=TPWeaponSkelMesh
    m_RightHandAttachSocketFP="R65_MG36_RHand"
    m_LeftHandAttachSocketFP="R65_MG36_LHand"
    m_MuzzleFlashParticleSystemFP=ParticleSystem'Keller_SFX.muzzleFX_1st_person.AssaultRifle_HEXAflash_1st'
    m_MuzzleFlashParticleSystemTP=ParticleSystem'Keller_SFX.muzzleFX_1st_person.AssaultRifle_HEXAflash_1st'
    // Reference: StaticMeshComponent'Default__R6AttachmentsLMGMG36.MagazineMeshComponentFP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6AttachmentsLMG.MagazineMeshComponentFP'
    begin object name="MagazineMeshComponentFP"
        StaticMesh=StaticMesh'RS5Weapons.Magazines.W_Mag_MG36'
    end object
    m_MagazineMeshFP=MagazineMeshComponentFP
    // Reference: StaticMeshComponent'Default__R6AttachmentsLMGMG36.MagazineMeshComponentTP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6AttachmentsLMG.MagazineMeshComponentTP'
    begin object name="MagazineMeshComponentTP"
        StaticMesh=StaticMesh'RS5Weapons.Magazines.W_Mag_MG36'
    end object
    m_MagazineMeshTP=MagazineMeshComponentTP
    m_ThrownMagazineMesh=MagazineMeshComponentTP
}