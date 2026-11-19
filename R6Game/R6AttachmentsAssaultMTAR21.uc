class R6AttachmentsAssaultMTAR21 extends R6AttachmentsAssault
    notplaceable
    hidecategories(lighting);

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__R6AttachmentsAssaultMTAR21.FPWeaponSkelMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6AttachmentsAssault.FPWeaponSkelMesh'
    begin object name="FPWeaponSkelMesh"
        SkeletalMesh=SkeletalMesh'RS5Weapons.Assault.W_Assault_TAR21_Tavor'
        PhysicsAsset=PhysicsAsset'RS5Weapons.Assault.W_Assault_TAR21_Tavor_Physics'
        AnimSets[0]=AnimSet'Anims_Props_Weapons_1st2.03_AssaultRifles.TAR21'
    end object
    m_WeaponMeshFP=FPWeaponSkelMesh
    // Reference: SkeletalMeshComponent'Default__R6AttachmentsAssaultMTAR21.TPWeaponSkelMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6AttachmentsAssault.TPWeaponSkelMesh'
    begin object name="TPWeaponSkelMesh"
        SkeletalMesh=SkeletalMesh'RS5Weapons.Assault.W_Assault_TAR21_Tavor'
        PhysicsAsset=PhysicsAsset'RS5Weapons.Assault.W_Assault_TAR21_Tavor_Physics'
        AnimSets[0]=AnimSet'Anims_Props_Weapons_3rd.03_AssaultRifles.TAR21'
    end object
    m_WeaponMeshTP=TPWeaponSkelMesh
    m_RightHandAttachSocketFP="R65_TAR21_RHand"
    m_LeftHandAttachSocketFP="R65_TAR21_LHand"
    m_MuzzleFlashParticleSystemFP=ParticleSystem'Keller_SFX.muzzleFX_1st_person.AssaultRifle_Xflash_1st'
    m_MuzzleFlashParticleSystemTP=ParticleSystem'Keller_SFX.muzzleFX_1st_person.AssaultRifle_Xflash_1st'
    // Reference: StaticMeshComponent'Default__R6AttachmentsAssaultMTAR21.MagazineMeshComponentFP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6AttachmentsAssault.MagazineMeshComponentFP'
    begin object name="MagazineMeshComponentFP"
        StaticMesh=StaticMesh'RS5Weapons.Magazines.W_Mag_AK47'
    end object
    m_MagazineMeshFP=MagazineMeshComponentFP
    // Reference: StaticMeshComponent'Default__R6AttachmentsAssaultMTAR21.MagazineMeshComponentTP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6AttachmentsAssault.MagazineMeshComponentTP'
    begin object name="MagazineMeshComponentTP"
        StaticMesh=StaticMesh'RS5Weapons.Magazines.W_Mag_AK47'
    end object
    m_MagazineMeshTP=MagazineMeshComponentTP
    m_ThrownMagazineMesh=MagazineMeshComponentTP
}