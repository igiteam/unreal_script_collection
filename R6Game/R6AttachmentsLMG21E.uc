class R6AttachmentsLMG21E extends R6AttachmentsLMG
    notplaceable
    hidecategories(lighting);

defaultproperties
{
    // Reference: StaticMeshComponent'Default__R6AttachmentsLMG21E.StrapMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="StrapMesh" class=Class'Engine.StaticMeshComponent'
        StaticMesh=StaticMesh'RS5Weapons.Magazines.W_Mag_21E_Strap'
    end object
    m_StrapMesh=StrapMesh
    // Reference: SkeletalMeshComponent'Default__R6AttachmentsLMG21E.FPWeaponSkelMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6AttachmentsLMG.FPWeaponSkelMesh'
    begin object name="FPWeaponSkelMesh"
        SkeletalMesh=SkeletalMesh'RS5Weapons.LMG.W_LMG_21E'
        PhysicsAsset=PhysicsAsset'RS5Weapons.LMG.W_LMG_21E_Physics'
        AnimSets[0]=AnimSet'Anims_Props_Weapons_1st2.04_LMGs.21E'
    end object
    m_WeaponMeshFP=FPWeaponSkelMesh
    // Reference: SkeletalMeshComponent'Default__R6AttachmentsLMG21E.TPWeaponSkelMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6AttachmentsLMG.TPWeaponSkelMesh'
    begin object name="TPWeaponSkelMesh"
        SkeletalMesh=SkeletalMesh'RS5Weapons.LMG.W_LMG_21E'
        PhysicsAsset=PhysicsAsset'RS5Weapons.LMG.W_LMG_21E_Physics'
        AnimSets[0]=AnimSet'Anims_Props_Weapons_3rd.MG'
        AnimSets[1]=AnimSet'Anims_Props_Weapons_1st2.04_LMGs.21E'
    end object
    m_WeaponMeshTP=TPWeaponSkelMesh
    m_RightHandAttachSocketFP="R65_21E_RHand"
    m_LeftHandAttachSocketFP="R65_21E_LHand"
    m_MuzzleFlashParticleSystemFP=ParticleSystem'Keller_SFX.muzzleFX_1st_person.AssaultRifle_Xflash_1st'
    m_MuzzleFlashParticleSystemTP=ParticleSystem'Keller_SFX.muzzleFX_1st_person.AssaultRifle_Xflash_1st'
    // Reference: SkeletalMeshComponent'Default__R6AttachmentsLMG21E.MagazineSkelMeshComponentFP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6AttachmentsLMG.MagazineSkelMeshComponentFP'
    begin object name="MagazineSkelMeshComponentFP"
        SkeletalMesh=SkeletalMesh'RS5Weapons.Magazines.W_Mag_21E'
        AnimTreeTemplate=AnimTree'AnimTreeWeaponMag.AnimTreeMagLMG'
        PhysicsAsset=PhysicsAsset'RS5Weapons.Magazines.W_Mag_21E_Physics'
        AnimSets[0]=AnimSet'Anims_Props_Gadgets_1st2.Magazines.21EMag'
    end object
    m_MagazineMeshFP=MagazineSkelMeshComponentFP
    // Reference: SkeletalMeshComponent'Default__R6AttachmentsLMG21E.MagazineSkelMeshComponentTP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6AttachmentsLMG.MagazineSkelMeshComponentTP'
    begin object name="MagazineSkelMeshComponentTP"
        SkeletalMesh=SkeletalMesh'RS5Weapons.Magazines.W_Mag_21E'
        AnimTreeTemplate=AnimTree'AnimTreeWeaponMag.AnimTreeMagLMG'
        PhysicsAsset=PhysicsAsset'RS5Weapons.Magazines.W_Mag_21E_Physics'
        AnimSets[0]=AnimSet'Anims_Props_Gadgets_1st2.Magazines.21EMag'
    end object
    m_MagazineMeshTP=MagazineSkelMeshComponentTP
    // Reference: StaticMeshComponent'Default__R6AttachmentsLMG21E.ThrownMagazineMeshComponent'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6AttachmentsLMG.ThrownMagazineMeshComponent'
    begin object name="ThrownMagazineMeshComponent"
        StaticMesh=StaticMesh'RS5Weapons.Magazines.W_Mag_21E_SM'
    end object
    m_ThrownMagazineMesh=ThrownMagazineMeshComponent
    m_MagazinePawnHandSocketName="R65_21EAmmo_LHand"
}