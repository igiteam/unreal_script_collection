class R6AttachmentsSubP90 extends R6AttachmentsSMG
    notplaceable
    hidecategories(lighting);

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__R6AttachmentsSubP90.FPWeaponSkelMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6AttachmentsSMG.FPWeaponSkelMesh'
    begin object name="FPWeaponSkelMesh"
        SkeletalMesh=SkeletalMesh'RS5Weapons.SMG.W_SMG_P90'
        PhysicsAsset=PhysicsAsset'RS5Weapons.SMG.W_SMG_P90_Physics'
        AnimSets[0]=AnimSet'Anims_Props_Weapons_1st2.02_SMGs.P90'
    end object
    m_WeaponMeshFP=FPWeaponSkelMesh
    // Reference: SkeletalMeshComponent'Default__R6AttachmentsSubP90.TPWeaponSkelMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6AttachmentsSMG.TPWeaponSkelMesh'
    begin object name="TPWeaponSkelMesh"
        SkeletalMesh=SkeletalMesh'RS5Weapons.SMG.W_SMG_P90'
        PhysicsAsset=PhysicsAsset'RS5Weapons.SMG.W_SMG_P90_Physics'
        AnimSets[0]=AnimSet'Anims_Props_Weapons_3rd.MG'
        AnimSets[1]=AnimSet'Anims_Props_Weapons_3rd.02_SMGs.P90'
    end object
    m_WeaponMeshTP=TPWeaponSkelMesh
    m_RightHandAttachSocketFP="R65_P90_RHand"
    m_LeftHandAttachSocketFP="R65_P90_LHand"
    // Reference: SkeletalMeshComponent'Default__R6AttachmentsSubP90.MagazineSkelMeshComponentFP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="MagazineSkelMeshComponentFP" class=Class'Engine.SkeletalMeshComponent'
        SkeletalMesh=SkeletalMesh'RS5Weapons.Magazines.W_Mag_P90'
        AnimTreeTemplate=AnimTree'AnimTreeWeaponMag.AnimTreeMagP90'
        m_eComponentVisibility=1
    end object
    m_MagazineMeshFP=MagazineSkelMeshComponentFP
    // Reference: SkeletalMeshComponent'Default__R6AttachmentsSubP90.MagazineSkelMeshComponentTP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="MagazineSkelMeshComponentTP" class=Class'Engine.SkeletalMeshComponent'
        SkeletalMesh=SkeletalMesh'RS5Weapons.Magazines.W_Mag_P90'
        m_eComponentVisibility=2
    end object
    m_MagazineMeshTP=MagazineSkelMeshComponentTP
    // Reference: StaticMeshComponent'Default__R6AttachmentsSubP90.ThrownMagazineMeshComponent'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="ThrownMagazineMeshComponent" class=Class'Engine.StaticMeshComponent'
        StaticMesh=StaticMesh'RS5Weapons.Magazines.W_Mag_P90_SM'
    end object
    m_ThrownMagazineMesh=ThrownMagazineMeshComponent
    m_MagazinePawnHandSocketName="R65_P90Mag_LHand"
    m_BulletCaseParticleSystemFP=ParticleSystem'Keller_SFX.gun_discharge.9mmSMG_eject_PT'
    m_BulletCaseParticleSystemTP=ParticleSystem'Keller_SFX.gun_discharge.9mmSMG_eject_PT'
}