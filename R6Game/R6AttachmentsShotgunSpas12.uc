class R6AttachmentsShotgunSpas12 extends R6AttachmentsShotgun
    notplaceable
    hidecategories(lighting);

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__R6AttachmentsShotgunSpas12.FPWeaponSkelMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6AttachmentsShotgun.FPWeaponSkelMesh'
    begin object name="FPWeaponSkelMesh"
        SkeletalMesh=SkeletalMesh'RS5Weapons.Shotgun.W_Shotgun_Spas12'
        PhysicsAsset=PhysicsAsset'RS5Weapons.Shotgun.W_Shotgun_Spas12_Physics'
        AnimSets[0]=AnimSet'Anims_Props_Weapons_1st2.05_Shotguns.SPAS12'
    end object
    m_WeaponMeshFP=FPWeaponSkelMesh
    // Reference: SkeletalMeshComponent'Default__R6AttachmentsShotgunSpas12.TPWeaponSkelMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6AttachmentsShotgun.TPWeaponSkelMesh'
    begin object name="TPWeaponSkelMesh"
        SkeletalMesh=SkeletalMesh'RS5Weapons.Shotgun.W_Shotgun_Spas12'
        PhysicsAsset=PhysicsAsset'RS5Weapons.Shotgun.W_Shotgun_Spas12_Physics'
        AnimSets[0]=AnimSet'Anims_Props_Weapons_1st2.05_Shotguns.SPAS12'
        AnimSets[1]=AnimSet'Anims_Props_Weapons_3rd.MG'
    end object
    m_WeaponMeshTP=TPWeaponSkelMesh
    m_bEjectBulletCaseWithNotify=true
}