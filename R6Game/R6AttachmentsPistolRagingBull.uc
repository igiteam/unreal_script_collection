class R6AttachmentsPistolRagingBull extends R6AttachmentsPistol
    native
    notplaceable
    hidecategories(lighting);

enum ETRBullReloadSteps
{
    TRBULLRELOAD_BULLETS_ON_GUN,    // 0
    TRBULLRELOAD_DETTACH_BULLETS,   // 1
    TRBULLRELOAD_ATTACH_TO_HAND,    // 2
    TRBULLRELOAD_DETTACH_ALL,       // 3
    TRBULLRELOAD_MAX                // 4
};

var R6AttachmentsPistolRagingBull.ETRBullReloadSteps m_eReloadSteps;
var export editinline StaticMeshComponent m_EmptyMag1;
var export editinline StaticMeshComponent m_EmptyMag2;
var export editinline StaticMeshComponent m_EmptyMag3;
var export editinline StaticMeshComponent m_SpeedLoaderMagFP;
var export editinline StaticMeshComponent m_SpeedLoaderMagTP;

defaultproperties
{
    // Reference: StaticMeshComponent'Default__R6AttachmentsPistolRagingBull.EmptyMag1'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="EmptyMag1" class=Class'Engine.StaticMeshComponent'
        StaticMesh=StaticMesh'RS5Weapons.Magazines.W_Mag_TRBull44Empty01'
        bAcceptsDecalsDuringGameplay=false
        BlockActors=false
        m_eComponentVisibility=1
    end object
    m_EmptyMag1=EmptyMag1
    // Reference: StaticMeshComponent'Default__R6AttachmentsPistolRagingBull.EmptyMag2'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="EmptyMag2" class=Class'Engine.StaticMeshComponent'
        StaticMesh=StaticMesh'RS5Weapons.Magazines.W_Mag_TRBull44Empty02'
        bAcceptsDecalsDuringGameplay=false
        BlockActors=false
        m_eComponentVisibility=1
    end object
    m_EmptyMag2=EmptyMag2
    // Reference: StaticMeshComponent'Default__R6AttachmentsPistolRagingBull.EmptyMag3'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="EmptyMag3" class=Class'Engine.StaticMeshComponent'
        StaticMesh=StaticMesh'RS5Weapons.Magazines.W_Mag_TRBull44Empty03'
        bAcceptsDecalsDuringGameplay=false
        BlockActors=false
        m_eComponentVisibility=1
    end object
    m_EmptyMag3=EmptyMag3
    // Reference: StaticMeshComponent'Default__R6AttachmentsPistolRagingBull.SpeedLoaderMagFP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="SpeedLoaderMagFP" class=Class'Engine.StaticMeshComponent'
        StaticMesh=StaticMesh'RS5Weapons.Magazines.W_Mag_TRBull'
        bAcceptsDecalsDuringGameplay=false
        BlockActors=false
        m_eComponentVisibility=1
    end object
    m_SpeedLoaderMagFP=SpeedLoaderMagFP
    // Reference: StaticMeshComponent'Default__R6AttachmentsPistolRagingBull.SpeedLoaderMagTP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="SpeedLoaderMagTP" class=Class'Engine.StaticMeshComponent'
        StaticMesh=StaticMesh'RS5Weapons.Magazines.W_Mag_TRBull'
        bAcceptsDecalsDuringGameplay=false
        BlockActors=false
        m_eComponentVisibility=2
    end object
    m_SpeedLoaderMagTP=SpeedLoaderMagTP
    // Reference: SkeletalMeshComponent'Default__R6AttachmentsPistolRagingBull.FPWeaponSkelMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6AttachmentsPistol.FPWeaponSkelMesh'
    begin object name="FPWeaponSkelMesh"
        SkeletalMesh=SkeletalMesh'RS5Weapons.Pistol.W_Pistol_TRBull'
        PhysicsAsset=PhysicsAsset'RS5Weapons.Pistol.W_Pistol_TRBull_Physics'
        AnimSets[0]=AnimSet'Anims_Props_Weapons_1st2.01_Pistols.TRBull'
    end object
    m_WeaponMeshFP=FPWeaponSkelMesh
    // Reference: SkeletalMeshComponent'Default__R6AttachmentsPistolRagingBull.TPWeaponSkelMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6AttachmentsPistol.TPWeaponSkelMesh'
    begin object name="TPWeaponSkelMesh"
        SkeletalMesh=SkeletalMesh'RS5Weapons.Pistol.W_Pistol_TRBull'
        PhysicsAsset=PhysicsAsset'RS5Weapons.Pistol.W_Pistol_TRBull_Physics'
        AnimSets[0]=AnimSet'Anims_Props_Weapons_3rd.Pistol'
        AnimSets[1]=AnimSet'Anims_Props_Weapons_3rd.Shield'
        AnimSets[2]=AnimSet'Anims_Props_Weapons_1st2.01_Pistols.TRBull'
    end object
    m_WeaponMeshTP=TPWeaponSkelMesh
    m_bEjectBulletCaseWithNotify=true
    m_RightHandAttachSocketFP="R65_TRBull_RHand"
    m_LeftHandAttachSocketFP="R65_TRBull_LHand"
    // Reference: StaticMeshComponent'Default__R6AttachmentsPistolRagingBull.MagazineMeshComponentFP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6AttachmentsPistol.MagazineMeshComponentFP'
    begin object name="MagazineMeshComponentFP"
        StaticMesh=StaticMesh'RS5Weapons.Magazines.W_Mag_TRBull44Bullets'
    end object
    m_MagazineMeshFP=MagazineMeshComponentFP
    // Reference: StaticMeshComponent'Default__R6AttachmentsPistolRagingBull.MagazineMeshComponentTP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6AttachmentsPistol.MagazineMeshComponentTP'
    begin object name="MagazineMeshComponentTP"
        StaticMesh=StaticMesh'RS5Weapons.Magazines.W_Mag_TRBull44Bullets'
    end object
    m_MagazineMeshTP=MagazineMeshComponentTP
    m_ThrownMagazineMesh=MagazineMeshComponentTP
    m_MagazinePawnHandSocketName="R65_TRBullMag_LHand"
}