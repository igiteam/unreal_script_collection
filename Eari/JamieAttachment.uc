class JamieAttachment extends UTAttachment_LinkGun;


// Decompiled with UE Explorer.
defaultproperties
{
    // Reference: ParticleSystemComponent'Default__JamieAttachment.PoweredUpComponent'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'PoweredUpComponent'
    // Archetype: ParticleSystemComponent'UTGame.Default__UTAttachment_LinkGun.PoweredUpComponent'
    begin object name="PoweredUpComponent"
        ReplacementPrimitive=none
    end object
    PoweredUpEffect=PoweredUpComponent
    // Reference: SkeletalMeshComponent'Default__JamieAttachment.SkeletalMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'SkeletalMeshComponent0'
    // Archetype: SkeletalMeshComponent'UTGame.Default__UTAttachment_LinkGun.SkeletalMeshComponent0'
    begin object name="SkeletalMeshComponent0"
        SkeletalMesh=SkeletalMesh'ClarkePackage.Arm'
        // Reference: UTAnimNodeSequence'Default__JamieAttachment.SkeletalMeshComponent0.MeshSequenceA'
        // Archetype: UTAnimNodeSequence'UTGame.Default__UTAttachment_LinkGun.SkeletalMeshComponent0.MeshSequenceA'
        begin object name="MeshSequenceA"
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    Mesh=SkeletalMeshComponent0
}