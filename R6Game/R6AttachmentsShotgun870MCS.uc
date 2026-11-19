class R6AttachmentsShotgun870MCS extends R6AttachmentsShotgun
    notplaceable
    hidecategories(lighting);

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__R6AttachmentsShotgun870MCS.FPWeaponSkelMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6AttachmentsShotgun.FPWeaponSkelMesh'
    begin object name="FPWeaponSkelMesh"
        SkeletalMesh=SkeletalMesh'RS5Weapons.Shotgun.W_Shotgun_870_MCS'
        PhysicsAsset=PhysicsAsset'RS5Weapons.Shotgun.W_Shotgun_870_MCS_Physics'
        AnimSets[0]=AnimSet'Anims_Props_Weapons_1st2.05_Shotguns.870MCS'
    end object
    m_WeaponMeshFP=FPWeaponSkelMesh
    // Reference: SkeletalMeshComponent'Default__R6AttachmentsShotgun870MCS.TPWeaponSkelMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6AttachmentsShotgun.TPWeaponSkelMesh'
    begin object name="TPWeaponSkelMesh"
        SkeletalMesh=SkeletalMesh'RS5Weapons.Shotgun.W_Shotgun_870_MCS'
        PhysicsAsset=PhysicsAsset'RS5Weapons.Shotgun.W_Shotgun_870_MCS_Physics'
        AnimSets[0]=AnimSet'Anims_Props_Weapons_1st2.05_Shotguns.870MCS'
        AnimSets[1]=AnimSet'Anims_Props_Weapons_3rd.MG'
    end object
    m_WeaponMeshTP=TPWeaponSkelMesh
    m_bEjectBulletCaseWithNotify=true
}