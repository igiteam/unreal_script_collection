class EvilAttachment_Weap_Melee_Dummy extends EvilAttachment_Weap_Melee_Base
    notplaceable
    hidecategories(Navigation);

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__EvilAttachment_Weap_Melee_Dummy.SkeletalMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'SkeletalMeshComponent0'
    // Archetype: SkeletalMeshComponent'Default__EvilAttachment_Weap_Melee_Base.SkeletalMeshComponent0'
    begin object name="SkeletalMeshComponent0"
        // Reference: UDKAnimNodeSequence'Default__EvilAttachment_Weap_Melee_Dummy.SkeletalMeshComponent0.MeshSequenceA'
        // Archetype: UDKAnimNodeSequence'Default__EvilAttachment_Weap_Melee_Base.SkeletalMeshComponent0.MeshSequenceA'
        begin object name="MeshSequenceA"
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    Mesh=SkeletalMeshComponent0
}