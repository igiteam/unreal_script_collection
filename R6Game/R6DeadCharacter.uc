class R6DeadCharacter extends R6SpawnableKAsset
    native
    hidecategories(lighting);

var() R6CharacterTemplate m_pCharacterTemplate;
var() /*0x10000000-0x00000000*/ name m_AnimSeqName;
var() editconst export editinline SkeletalMeshComponent m_pHeadMesh;
var() editconst export editinline SkeletalMeshComponent m_pLegsMesh;
var() editconst export editinline SkeletalMeshComponent m_pTorsoMesh;
var() editconst export editinline SkeletalMeshComponent m_pHairsMesh;
var bool m_bWasStable;

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__R6DeadCharacter.HeadMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="HeadMesh" class=Class'Engine.SkeletalMeshComponent'
        PhysicsWeight=1.0000000
        AnimSets[0]=AnimSet'Anims_Dead_Civilians.Death_Poses'
    end object
    m_pHeadMesh=HeadMesh
    // Reference: SkeletalMeshComponent'Default__R6DeadCharacter.LegsMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="LegsMesh" class=Class'Engine.SkeletalMeshComponent'
        ParentAnimComponent=SkeletalMeshComponent'Default__R6DeadCharacter.HeadMesh'
    end object
    m_pLegsMesh=LegsMesh
    // Reference: SkeletalMeshComponent'Default__R6DeadCharacter.TorsoMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="TorsoMesh" class=Class'Engine.SkeletalMeshComponent'
        ParentAnimComponent=SkeletalMeshComponent'Default__R6DeadCharacter.HeadMesh'
    end object
    m_pTorsoMesh=TorsoMesh
    // Reference: SkeletalMeshComponent'Default__R6DeadCharacter.HairsMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="HairsMesh" class=Class'Engine.SkeletalMeshComponent'
        ParentAnimComponent=SkeletalMeshComponent'Default__R6DeadCharacter.HeadMesh'
    end object
    m_pHairsMesh=HairsMesh
    SkeletalMeshComponent=HeadMesh
    bStasis=true
    Components[0]=HeadMesh
    Components[1]=TorsoMesh
    Components[2]=LegsMesh
    Components[3]=HairsMesh
    CollisionComponent=HeadMesh
}