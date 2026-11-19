class R6AttachmentsShotgunXM26LSS extends R6AttachmentsShotgun
    native
    notplaceable
    hidecategories(lighting);

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__R6AttachmentsShotgunXM26LSS.FPWeaponSkelMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6AttachmentsShotgun.FPWeaponSkelMesh'
    begin object name="FPWeaponSkelMesh"
        SkeletalMesh=SkeletalMesh'RS5Weapons.Shotgun.W_Shotgun_XM-26_LSS'
        PhysicsAsset=PhysicsAsset'RS5Weapons.Shotgun.W_Shotgun_XM-26_LSS_Physics'
        AnimSets[0]=AnimSet'Anims_Props_Weapons_1st2.05_Shotguns.XM26'
    end object
    m_WeaponMeshFP=FPWeaponSkelMesh
    // Reference: SkeletalMeshComponent'Default__R6AttachmentsShotgunXM26LSS.TPWeaponSkelMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6AttachmentsShotgun.TPWeaponSkelMesh'
    begin object name="TPWeaponSkelMesh"
        SkeletalMesh=SkeletalMesh'RS5Weapons.Shotgun.W_Shotgun_XM-26_LSS'
        PhysicsAsset=PhysicsAsset'RS5Weapons.Shotgun.W_Shotgun_XM-26_LSS_Physics'
        AnimSets[0]=AnimSet'Anims_Props_Weapons_3rd.MG'
    end object
    m_WeaponMeshTP=TPWeaponSkelMesh
    m_RightHandAttachSocketFP="R65_XM26_RHand"
    m_LeftHandAttachSocketFP="R65_XM26_LHand"
    // Reference: StaticMeshComponent'Default__R6AttachmentsShotgunXM26LSS.MagazineMeshComponentFP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6AttachmentsShotgun.MagazineMeshComponentFP'
    begin object name="MagazineMeshComponentFP"
        StaticMesh=StaticMesh'RS5Weapons.Magazines.W_Mag_XM-26_LSS'
    end object
    m_MagazineMeshFP=MagazineMeshComponentFP
    // Reference: StaticMeshComponent'Default__R6AttachmentsShotgunXM26LSS.MagazineMeshComponentTP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6AttachmentsShotgun.MagazineMeshComponentTP'
    begin object name="MagazineMeshComponentTP"
        StaticMesh=StaticMesh'RS5Weapons.Magazines.W_Mag_XM-26_LSS'
    end object
    m_MagazineMeshTP=MagazineMeshComponentTP
    m_ThrownMagazineMesh=MagazineMeshComponentTP
}