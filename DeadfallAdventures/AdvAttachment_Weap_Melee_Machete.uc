class AdvAttachment_Weap_Melee_Machete extends EvilAttachment_Weap_Melee_Base
    hidecategories(Navigation);

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__AdvAttachment_Weap_Melee_Machete.SkeletalMeshComponent0'
    begin object name=SkeletalMeshComponent0
        SkeletalMesh=SkeletalMesh'sk_wp_machete_01.Mesh.sk_wp_machete_01_3p'
        // Reference: UDKAnimNodeSequence'Default__AdvAttachment_Weap_Melee_Machete.SkeletalMeshComponent0.MeshSequenceA'
        begin object name=MeshSequenceA
        end object
        Animations=MeshSequenceA
        AnimSets[0]=AnimSet'sk_wp_machete_01.Anim.as_wp_machete_01'
        ReplacementPrimitive=none
    end object
    Mesh=SkeletalMeshComponent0
    WeaponClass=Class'AdvWeap_Melee_Machete'
}