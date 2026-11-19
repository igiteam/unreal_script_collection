class PKAttachment_Weap_Uzi_Base extends PainAttachment_Weap_Base
    abstract
    hidecategories(Navigation);

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__PKAttachment_Weap_Uzi_Base.SkeletalMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'SkeletalMeshComponent0'
    // Archetype: SkeletalMeshComponent'Default__PainAttachment_Weap_Base.SkeletalMeshComponent0'
    begin object name="SkeletalMeshComponent0"
        // Reference: UDKAnimNodeSequence'Default__PKAttachment_Weap_Uzi_Base.SkeletalMeshComponent0.MeshSequenceA'
        // Archetype: UDKAnimNodeSequence'Default__PainAttachment_Weap_Base.SkeletalMeshComponent0.MeshSequenceA'
        begin object name="MeshSequenceA"
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    Mesh=SkeletalMeshComponent0
    TracerChance=0.9000000
    WeaponClass=Class'PKWeap_Uzi_Base'
    WeapAnimType=EWeapAnimType.EWAT_Pistol
    EvilWeapAnimType=EEvilWeapAnimType.EEWAT_Pistol
}