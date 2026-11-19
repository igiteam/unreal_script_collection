class AdvAttachment_Weap_ThrowKnife_Base extends EvilAttachment_Weap_Base
    abstract
    hidecategories(Navigation);

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__AdvAttachment_Weap_ThrowKnife_Base.SkeletalMeshComponent0'
    begin object name=SkeletalMeshComponent0
        // Reference: UDKAnimNodeSequence'Default__AdvAttachment_Weap_ThrowKnife_Base.SkeletalMeshComponent0.MeshSequenceA'
        begin object name=MeshSequenceA
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    Mesh=SkeletalMeshComponent0
    WeaponClass=Class'AdvWeap_ThrowKnife_Base'
    EvilWeapAnimType=EEvilWeapAnimType.EEWAT_Crossbow
}