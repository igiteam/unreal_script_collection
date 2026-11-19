class R6AttachmentsAssaultAUGA3 extends R6AttachmentsAssault
    notplaceable
    hidecategories(lighting);

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__R6AttachmentsAssaultAUGA3.FPWeaponSkelMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6AttachmentsAssault.FPWeaponSkelMesh'
    begin object name="FPWeaponSkelMesh"
        SkeletalMesh=SkeletalMesh'RS5Weapons.Assault.W_Assault_AUGA3'
        PhysicsAsset=PhysicsAsset'RS5Weapons.Assault.W_Assault_AUGA3_Physics'
        AnimSets[0]=AnimSet'Anims_Props_Weapons_1st2.03_AssaultRifles.AUGA3'
    end object
    m_WeaponMeshFP=FPWeaponSkelMesh
    // Reference: SkeletalMeshComponent'Default__R6AttachmentsAssaultAUGA3.TPWeaponSkelMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6AttachmentsAssault.TPWeaponSkelMesh'
    begin object name="TPWeaponSkelMesh"
        SkeletalMesh=SkeletalMesh'RS5Weapons.Assault.W_Assault_AUGA3'
        PhysicsAsset=PhysicsAsset'RS5Weapons.Assault.W_Assault_AUGA3_Physics'
        AnimSets[0]=AnimSet'Anims_Props_Weapons_3rd.03_AssaultRifles.AUGA3'
    end object
    m_WeaponMeshTP=TPWeaponSkelMesh
    m_RightHandAttachSocketFP="R65_AUGA3_RHand"
    m_LeftHandAttachSocketFP="R65_AUGA3_LHand"
    m_MuzzleFlashParticleSystemFP=ParticleSystem'Keller_SFX.muzzleFX_1st_person.AssaultRifle_HEXAflash_1st'
    m_MuzzleFlashParticleSystemTP=ParticleSystem'Keller_SFX.muzzleFX_1st_person.AssaultRifle_HEXAflash_1st'
    // Reference: StaticMeshComponent'Default__R6AttachmentsAssaultAUGA3.MagazineMeshComponentFP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6AttachmentsAssault.MagazineMeshComponentFP'
    begin object name="MagazineMeshComponentFP"
        StaticMesh=StaticMesh'RS5Weapons.Magazines.W_Mag_552_Commando'
    end object
    m_MagazineMeshFP=MagazineMeshComponentFP
    // Reference: StaticMeshComponent'Default__R6AttachmentsAssaultAUGA3.MagazineMeshComponentTP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6AttachmentsAssault.MagazineMeshComponentTP'
    begin object name="MagazineMeshComponentTP"
        StaticMesh=StaticMesh'RS5Weapons.Magazines.W_Mag_552_Commando'
    end object
    m_MagazineMeshTP=MagazineMeshComponentTP
    m_ThrownMagazineMesh=MagazineMeshComponentTP
}