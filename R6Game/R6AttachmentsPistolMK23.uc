class R6AttachmentsPistolMK23 extends R6AttachmentsPistol
    notplaceable
    hidecategories(lighting);

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__R6AttachmentsPistolMK23.FPWeaponSkelMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6AttachmentsPistol.FPWeaponSkelMesh'
    begin object name="FPWeaponSkelMesh"
        SkeletalMesh=SkeletalMesh'RS5Weapons.Pistol.W_Pistol_MK23'
        PhysicsAsset=PhysicsAsset'RS5Weapons.Pistol.W_Pistol_MK23_Physics'
        AnimSets[0]=AnimSet'Anims_Props_Weapons_1st2.01_Pistols.Mk23'
    end object
    m_WeaponMeshFP=FPWeaponSkelMesh
    // Reference: SkeletalMeshComponent'Default__R6AttachmentsPistolMK23.TPWeaponSkelMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6AttachmentsPistol.TPWeaponSkelMesh'
    begin object name="TPWeaponSkelMesh"
        SkeletalMesh=SkeletalMesh'RS5Weapons.Pistol.W_Pistol_MK23'
        PhysicsAsset=PhysicsAsset'RS5Weapons.Pistol.W_Pistol_MK23_Physics'
        AnimSets[0]=AnimSet'Anims_Props_Weapons_3rd.Pistol'
        AnimSets[1]=AnimSet'Anims_Props_Weapons_3rd.Shield'
        AnimSets[2]=AnimSet'Anims_Props_Weapons_3rd.01_Pistols.Mk23'
    end object
    m_WeaponMeshTP=TPWeaponSkelMesh
    // Reference: StaticMeshComponent'Default__R6AttachmentsPistolMK23.MagazineMeshComponentFP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6AttachmentsPistol.MagazineMeshComponentFP'
    begin object name="MagazineMeshComponentFP"
        StaticMesh=StaticMesh'RS5Weapons.Magazines.W_Mag_Mk23'
    end object
    m_MagazineMeshFP=MagazineMeshComponentFP
    // Reference: StaticMeshComponent'Default__R6AttachmentsPistolMK23.MagazineMeshComponentTP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6AttachmentsPistol.MagazineMeshComponentTP'
    begin object name="MagazineMeshComponentTP"
        StaticMesh=StaticMesh'RS5Weapons.Magazines.W_Mag_Mk23'
    end object
    m_MagazineMeshTP=MagazineMeshComponentTP
    m_ThrownMagazineMesh=MagazineMeshComponentTP
    m_BulletCaseParticleSystemFP=ParticleSystem'Keller_SFX.gun_discharge.45calSMG_eject_PT'
    m_BulletCaseParticleSystemTP=ParticleSystem'Keller_SFX.gun_discharge.45calSMG_eject_PT'
}