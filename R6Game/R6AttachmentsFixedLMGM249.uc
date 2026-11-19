class R6AttachmentsFixedLMGM249 extends R6AttachmentsLMG
    notplaceable
    hidecategories(lighting);

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__R6AttachmentsFixedLMGM249.FPWeaponSkelMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6AttachmentsLMG.FPWeaponSkelMesh'
    begin object name="FPWeaponSkelMesh"
        SkeletalMesh=SkeletalMesh'RS5Weapons.LMG.W_LMG_M249Turret'
        PhysicsAsset=PhysicsAsset'RS5Weapons.LMG.W_LMG_M249Turret_Physics'
        AnimSets[0]=AnimSet'Anims_Props_Weapons_1st2.04_LMGs.21E'
    end object
    m_WeaponMeshFP=FPWeaponSkelMesh
    // Reference: SkeletalMeshComponent'Default__R6AttachmentsFixedLMGM249.TPWeaponSkelMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6AttachmentsLMG.TPWeaponSkelMesh'
    begin object name="TPWeaponSkelMesh"
        SkeletalMesh=SkeletalMesh'RS5Weapons.LMG.W_LMG_M249Turret'
        PhysicsAsset=PhysicsAsset'RS5Weapons.LMG.W_LMG_M249Turret_Physics'
        AnimSets[0]=AnimSet'Anims_Props_Weapons_3rd.MG'
        AnimSets[1]=AnimSet'Anims_Props_Weapons_3rd.FIXEDGUN.M249Turret'
    end object
    m_WeaponMeshTP=TPWeaponSkelMesh
    m_RightHandAttachSocketFP="R65_IKM_RH_Hold"
    m_LeftHandAttachSocketFP="R65_IKM_LH_Hold"
    m_RightHandAttachSocketTP="R65_IKM_RH_Hold"
    m_LeftHandAttachSocketTP="R65_IKM_LH_Hold"
    m_MuzzleFlashParticleSystemFP=ParticleSystem'Keller_SFX.muzzleFX_1st_person.AssaultRifle_Xflash_1st'
    m_MuzzleFlashParticleSystemTP=ParticleSystem'Keller_SFX.muzzleFX_1st_person.AssaultRifle_Xflash_1st'
    // Reference: SkeletalMeshComponent'Default__R6AttachmentsFixedLMGM249.MagazineSkelMeshComponentFP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6AttachmentsLMG.MagazineSkelMeshComponentFP'
    begin object name="MagazineSkelMeshComponentFP"
        SkeletalMesh=SkeletalMesh'RS5Weapons.Magazines.W_Mag_MK46'
        PhysicsAsset=PhysicsAsset'RS5Weapons.Magazines.W_Mag_MK46_Physics'
    end object
    m_MagazineMeshFP=MagazineSkelMeshComponentFP
    // Reference: SkeletalMeshComponent'Default__R6AttachmentsFixedLMGM249.MagazineSkelMeshComponentTP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6AttachmentsLMG.MagazineSkelMeshComponentTP'
    begin object name="MagazineSkelMeshComponentTP"
        SkeletalMesh=SkeletalMesh'RS5Weapons.Magazines.W_Mag_MK46'
        PhysicsAsset=PhysicsAsset'RS5Weapons.Magazines.W_Mag_MK46_Physics'
        AnimSets[0]=AnimSet'Anims_Props_Weapons_3rd.FIXEDGUN.M249TurretMag'
    end object
    m_MagazineMeshTP=MagazineSkelMeshComponentTP
    // Reference: StaticMeshComponent'Default__R6AttachmentsFixedLMGM249.ThrownMagazineMeshComponent'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6AttachmentsLMG.ThrownMagazineMeshComponent'
    begin object name="ThrownMagazineMeshComponent"
        StaticMesh=StaticMesh'RS5Weapons.Magazines.W_Mag_Mk46_SM'
    end object
    m_ThrownMagazineMesh=ThrownMagazineMeshComponent
    m_MagazinePawnHandSocketName="None"
}