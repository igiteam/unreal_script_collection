class R6AttachmentsSniperM40A1 extends R6AttachmentsSniper
    notplaceable
    hidecategories(lighting);

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__R6AttachmentsSniperM40A1.FPWeaponSkelMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6AttachmentsSniper.FPWeaponSkelMesh'
    begin object name="FPWeaponSkelMesh"
        SkeletalMesh=SkeletalMesh'RS5Weapons.Sniper.W_Sniper_M40A1'
        PhysicsAsset=PhysicsAsset'RS5Weapons.Sniper.W_Sniper_M40A1_Physics'
        AnimSets[0]=AnimSet'Anims_Props_Weapons_1st2.06_SniperRifles.M40A1'
    end object
    m_WeaponMeshFP=FPWeaponSkelMesh
    // Reference: SkeletalMeshComponent'Default__R6AttachmentsSniperM40A1.TPWeaponSkelMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6AttachmentsSniper.TPWeaponSkelMesh'
    begin object name="TPWeaponSkelMesh"
        SkeletalMesh=SkeletalMesh'RS5Weapons.Sniper.W_Sniper_M40A1'
        PhysicsAsset=PhysicsAsset'RS5Weapons.Sniper.W_Sniper_M40A1_Physics'
        AnimSets[0]=AnimSet'Anims_Props_Weapons_1st2.06_SniperRifles.M40A1'
        AnimSets[1]=AnimSet'Anims_Props_Weapons_3rd.Sniper'
        AnimSets[2]=AnimSet'Anims_Props_Weapons_3rd.MG'
    end object
    m_WeaponMeshTP=TPWeaponSkelMesh
    m_bEjectBulletCaseWithNotify=true
    m_RightHandAttachSocketFP="R65_M40A1_RHand"
    m_LeftHandAttachSocketFP="R65_M40A1_LHand"
    m_RightHandAttachSocketTP="R65_Sniper_RHand"
    // Reference: StaticMeshComponent'Default__R6AttachmentsSniperM40A1.MagazineMeshComponentFP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6AttachmentsSniper.MagazineMeshComponentFP'
    begin object name="MagazineMeshComponentFP"
        StaticMesh=StaticMesh'RS5Weapons.Magazines.W_Mag_M40A1'
    end object
    m_MagazineMeshFP=MagazineMeshComponentFP
    // Reference: StaticMeshComponent'Default__R6AttachmentsSniperM40A1.MagazineMeshComponentTP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6AttachmentsSniper.MagazineMeshComponentTP'
    begin object name="MagazineMeshComponentTP"
        StaticMesh=StaticMesh'RS5Weapons.Magazines.W_Mag_M40A1'
    end object
    m_MagazineMeshTP=MagazineMeshComponentTP
    m_ThrownMagazineMesh=MagazineMeshComponentTP
}