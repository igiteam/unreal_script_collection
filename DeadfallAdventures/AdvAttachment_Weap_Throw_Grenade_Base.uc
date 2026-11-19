class AdvAttachment_Weap_Throw_Grenade_Base extends EvilAttachment_Weap_Melee_Base
    abstract
    hidecategories(Navigation);

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__AdvAttachment_Weap_Throw_Grenade_Base.SkeletalMeshComponent0'
    begin object name=SkeletalMeshComponent0
        // Reference: UDKAnimNodeSequence'Default__AdvAttachment_Weap_Throw_Grenade_Base.SkeletalMeshComponent0.MeshSequenceA'
        begin object name=MeshSequenceA
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    Mesh=SkeletalMeshComponent0
    WeaponClass=Class'AdvWeap_Throw_Grenade_Base'
}