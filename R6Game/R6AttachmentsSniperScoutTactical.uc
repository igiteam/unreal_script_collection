class R6AttachmentsSniperScoutTactical extends R6AttachmentsSniper
    notplaceable
    hidecategories(lighting);

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__R6AttachmentsSniperScoutTactical.FPWeaponSkelMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6AttachmentsSniper.FPWeaponSkelMesh'
    begin object name="FPWeaponSkelMesh"
        SkeletalMesh=SkeletalMesh'RS5Weapons.Sniper.W_Sniper_ScoutTactical'
        PhysicsAsset=PhysicsAsset'RS5Weapons.Sniper.W_Sniper_ScoutTactical_Physics'
        AnimSets[0]=AnimSet'Anims_Props_Weapons_1st2.06_SniperRifles.ScoutTactical'
    end object
    m_WeaponMeshFP=FPWeaponSkelMesh
    // Reference: SkeletalMeshComponent'Default__R6AttachmentsSniperScoutTactical.TPWeaponSkelMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6AttachmentsSniper.TPWeaponSkelMesh'
    begin object name="TPWeaponSkelMesh"
        SkeletalMesh=SkeletalMesh'RS5Weapons.Sniper.W_Sniper_ScoutTactical'
        PhysicsAsset=PhysicsAsset'RS5Weapons.Sniper.W_Sniper_ScoutTactical_Physics'
        AnimSets[0]=AnimSet'Anims_Props_Weapons_1st2.06_SniperRifles.ScoutTactical'
        AnimSets[1]=AnimSet'Anims_Props_Weapons_3rd.Sniper'
        AnimSets[2]=AnimSet'Anims_Props_Weapons_3rd.MG'
    end object
    m_WeaponMeshTP=TPWeaponSkelMesh
    m_bEjectBulletCaseWithNotify=true
    m_RightHandAttachSocketFP="R65_ScoutTactical_RHand"
    m_LeftHandAttachSocketFP="R65_ScoutTactical_LHand"
    m_RightHandAttachSocketTP="R65_Sniper_RHand"
    // Reference: StaticMeshComponent'Default__R6AttachmentsSniperScoutTactical.MagazineMeshComponentFP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6AttachmentsSniper.MagazineMeshComponentFP'
    begin object name="MagazineMeshComponentFP"
        StaticMesh=StaticMesh'RS5Weapons.Magazines.W_Mag_ScoutTactical'
    end object
    m_MagazineMeshFP=MagazineMeshComponentFP
    // Reference: StaticMeshComponent'Default__R6AttachmentsSniperScoutTactical.MagazineMeshComponentTP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6AttachmentsSniper.MagazineMeshComponentTP'
    begin object name="MagazineMeshComponentTP"
        StaticMesh=StaticMesh'RS5Weapons.Magazines.W_Mag_ScoutTactical'
    end object
    m_MagazineMeshTP=MagazineMeshComponentTP
    m_ThrownMagazineMesh=MagazineMeshComponentTP
}