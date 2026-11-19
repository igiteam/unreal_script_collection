class R6AttachmentsLMG extends R6WeaponAttachments
    native
    notplaceable
    hidecategories(lighting);

var export editinline StaticMeshComponent m_StrapMesh;

// Export UR6AttachmentsLMG::execStrapOff(FFrame&, void* const)
native final function StrapOff(R6Pawn pPawn);

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__R6AttachmentsLMG.MagazineSkelMeshComponentFP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="MagazineSkelMeshComponentFP" class=Class'Engine.SkeletalMeshComponent'
        m_eComponentVisibility=1
    end object
    m_MagazineMeshFP=MagazineSkelMeshComponentFP
    // Reference: SkeletalMeshComponent'Default__R6AttachmentsLMG.MagazineSkelMeshComponentTP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="MagazineSkelMeshComponentTP" class=Class'Engine.SkeletalMeshComponent'
        m_eComponentVisibility=2
    end object
    m_MagazineMeshTP=MagazineSkelMeshComponentTP
    // Reference: StaticMeshComponent'Default__R6AttachmentsLMG.ThrownMagazineMeshComponent'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="ThrownMagazineMeshComponent" class=Class'Engine.StaticMeshComponent'
    end object
    m_ThrownMagazineMesh=ThrownMagazineMeshComponent
    m_BulletCaseParticleSystemFP=ParticleSystem'Keller_SFX.gun_discharge.LMG_eject_PT'
    m_BulletCaseParticleSystemTP=ParticleSystem'Keller_SFX.gun_discharge.LMG_eject_PT'
}