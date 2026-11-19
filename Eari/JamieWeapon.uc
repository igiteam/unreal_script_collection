class JamieWeapon extends UTWeap_LinkGun;


// Decompiled with UE Explorer.
defaultproperties
{
    // Reference: ParticleSystemComponent'Default__JamieWeapon.PoweredUpComponent'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'PoweredUpComponent'
    // Archetype: ParticleSystemComponent'UTGame.Default__UTWeap_LinkGun.PoweredUpComponent'
    begin object name="PoweredUpComponent"
        ReplacementPrimitive=none
    end object
    PoweredUpEffect=PoweredUpComponent
    // Reference: ForceFeedbackWaveform'Default__JamieWeapon.BeamForceFeedbackWaveform1'
    // Archetype: ForceFeedbackWaveform'UTGame.Default__UTWeap_LinkGun.BeamForceFeedbackWaveform1'
    begin object name="BeamForceFeedbackWaveform1"
    end object
    BeamWeaponFireWaveForm=BeamForceFeedbackWaveform1
    // Reference: ForceFeedbackWaveform'Default__JamieWeapon.ForceFeedbackWaveformShooting1'
    // Archetype: ForceFeedbackWaveform'UTGame.Default__UTWeap_LinkGun.ForceFeedbackWaveformShooting1'
    begin object name="ForceFeedbackWaveformShooting1"
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    AttachmentClass=Class'JamieAttachment'
    // Reference: UDKSkeletalMeshComponent'Default__JamieWeapon.FirstPersonMesh'
    // Archetype: UDKSkeletalMeshComponent'UTGame.Default__UTWeap_LinkGun.FirstPersonMesh'
    begin object name="FirstPersonMesh"
        // Reference: AnimNodeSequence'Default__JamieWeapon.FirstPersonMesh.MeshSequenceA'
        // Archetype: AnimNodeSequence'UTGame.Default__UTWeap_LinkGun.MeshSequenceA'
        begin object name="MeshSequenceA"
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    // Reference: SkeletalMeshComponent'Default__JamieWeapon.PickupMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'PickupMesh'
    // Archetype: SkeletalMeshComponent'UTGame.Default__UTWeap_LinkGun.PickupMesh'
    begin object name="PickupMesh"
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
}