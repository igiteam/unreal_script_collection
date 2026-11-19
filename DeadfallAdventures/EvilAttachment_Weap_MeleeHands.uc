class EvilAttachment_Weap_MeleeHands extends EvilAttachment_Weap_Melee_Base
    notplaceable
    hidecategories(Navigation);

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__EvilAttachment_Weap_MeleeHands.SkeletalMeshComponent0'
    begin object name=SkeletalMeshComponent0
        // Reference: UDKAnimNodeSequence'Default__EvilAttachment_Weap_MeleeHands.SkeletalMeshComponent0.MeshSequenceA'
        begin object name=MeshSequenceA
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    Mesh=SkeletalMeshComponent0
    WeaponClass=Class'EvilWeap_MeleeHands'
}