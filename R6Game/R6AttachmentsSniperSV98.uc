class R6AttachmentsSniperSV98 extends R6AttachmentsSniper
    notplaceable
    hidecategories(lighting);

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__R6AttachmentsSniperSV98.FPWeaponSkelMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6AttachmentsSniper.FPWeaponSkelMesh'
    begin object name="FPWeaponSkelMesh"
        SkeletalMesh=SkeletalMesh'RS5Weapons.Sniper.W_Sniper_SV98'
        PhysicsAsset=PhysicsAsset'RS5Weapons.Sniper.W_Sniper_SV98_Physics'
        AnimSets[0]=AnimSet'Anims_Props_Weapons_1st2.06_SniperRifles.SV98'
    end object
    m_WeaponMeshFP=FPWeaponSkelMesh
    // Reference: SkeletalMeshComponent'Default__R6AttachmentsSniperSV98.TPWeaponSkelMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6AttachmentsSniper.TPWeaponSkelMesh'
    begin object name="TPWeaponSkelMesh"
        SkeletalMesh=SkeletalMesh'RS5Weapons.Sniper.W_Sniper_SV98'
        PhysicsAsset=PhysicsAsset'RS5Weapons.Sniper.W_Sniper_SV98_Physics'
        AnimSets[0]=AnimSet'Anims_Props_Weapons_1st2.06_SniperRifles.SV98'
        AnimSets[1]=AnimSet'Anims_Props_Weapons_3rd.Sniper'
        AnimSets[2]=AnimSet'Anims_Props_Weapons_3rd.MG'
    end object
    m_WeaponMeshTP=TPWeaponSkelMesh
    m_bEjectBulletCaseWithNotify=true
    m_RightHandAttachSocketFP="R65_SV98_RHand"
    m_LeftHandAttachSocketFP="R65_SV98_LHand"
    // Reference: StaticMeshComponent'Default__R6AttachmentsSniperSV98.MagazineMeshComponentFP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6AttachmentsSniper.MagazineMeshComponentFP'
    begin object name="MagazineMeshComponentFP"
        StaticMesh=StaticMesh'RS5Weapons.Magazines.W_Mag_PSG1'
    end object
    m_MagazineMeshFP=MagazineMeshComponentFP
    // Reference: StaticMeshComponent'Default__R6AttachmentsSniperSV98.MagazineMeshComponentTP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6AttachmentsSniper.MagazineMeshComponentTP'
    begin object name="MagazineMeshComponentTP"
        StaticMesh=StaticMesh'RS5Weapons.Magazines.W_Mag_PSG1'
    end object
    m_MagazineMeshTP=MagazineMeshComponentTP
    m_ThrownMagazineMesh=MagazineMeshComponentTP
}