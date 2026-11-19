class R6AttachmentsShield extends R6WeaponAttachments
    native
    notplaceable
    hidecategories(lighting);

var int m_iMaxFeedbackPerHit;
var Rotator m_rFeedbackRotation;
var float m_fRecoverySpeed;
var R6Weapon m_FireableWeapon;

defaultproperties
{
    m_iMaxFeedbackPerHit=1000
    m_fRecoverySpeed=10.0000000
    // Reference: SkeletalMeshComponent'Default__R6AttachmentsShield.FPWeaponSkelMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6WeaponAttachments.FPWeaponSkelMesh'
    begin object name="FPWeaponSkelMesh"
        SkeletalMesh=SkeletalMesh'RS5Weapons.Gadgets.W_Gad_ShieldMedium'
        AnimTreeTemplate=none
        PhysicsAsset=PhysicsAsset'RS5Weapons.Gadgets.W_Gad_ShieldMedium_Physics'
    end object
    m_WeaponMeshFP=FPWeaponSkelMesh
    // Reference: SkeletalMeshComponent'Default__R6AttachmentsShield.TPWeaponSkelMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6WeaponAttachments.TPWeaponSkelMesh'
    begin object name="TPWeaponSkelMesh"
        SkeletalMesh=SkeletalMesh'RS5Weapons.Gadgets.W_Gad_ShieldMedium'
        AnimTreeTemplate=none
        PhysicsAsset=PhysicsAsset'RS5Weapons.Gadgets.W_Gad_ShieldMedium_Physics'
    end object
    m_WeaponMeshTP=TPWeaponSkelMesh
    m_bReversedHandWeaponFP=true
    m_bReversedHandWeaponTP=true
    m_bAttachmentShouldCollide=true
    m_RightHandAttachSocketFP="R65_Shield_RHand"
    m_LeftHandAttachSocketFP="R65_Shield_LHand"
    m_RightHandAttachSocketTP="R65_Shield_RHand"
    m_LeftHandAttachSocketTP="None"
    m_MuzzleFlashEffectFP=none
    m_MuzzleFlashEffectTP=none
    m_BulletCaseEmitterFP=none
    m_BulletCaseEmitterTP=none
}