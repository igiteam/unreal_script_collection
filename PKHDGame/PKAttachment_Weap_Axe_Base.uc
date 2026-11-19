class PKAttachment_Weap_Axe_Base extends PainAttachment_Weap_Base
    abstract
    hidecategories(Navigation);

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__PKAttachment_Weap_Axe_Base.SkeletalMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'SkeletalMeshComponent0'
    // Archetype: SkeletalMeshComponent'Default__PainAttachment_Weap_Base.SkeletalMeshComponent0'
    begin object name="SkeletalMeshComponent0"
        // Reference: UDKAnimNodeSequence'Default__PKAttachment_Weap_Axe_Base.SkeletalMeshComponent0.MeshSequenceA'
        // Archetype: UDKAnimNodeSequence'Default__PainAttachment_Weap_Base.SkeletalMeshComponent0.MeshSequenceA'
        begin object name="MeshSequenceA"
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    Mesh=SkeletalMeshComponent0
    MuzzleFlashSocket="MuzzleFlashSocket"
    WeaponClass=Class'PKWeap_Axe_Base'
}