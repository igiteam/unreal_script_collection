class PKAttachment_Weap_ClownSpell_Base extends PainAttachment_Weap_Base
    abstract
    hidecategories(Navigation);

var export editinline ParticleSystemComponent HandEffectPSC;

simulated function AttachTo(UTPawn OwnerPawn, optional bool bLeftHand)
{
    super(EvilAttachment_Weap_Base).AttachTo(OwnerPawn, bLeftHand);
    // End:0x8C
    if((HandEffectPSC != none) && AttachmentSocket != 'None')
    {
        OwnerPawn.Mesh.AttachComponentToSocket(HandEffectPSC, AttachmentSocket);
    }
    //return;    
}

simulated function DetachFrom(SkeletalMeshComponent MeshCpnt)
{
    super(EvilAttachment_Weap_Base).DetachFrom(MeshCpnt);
    HandEffectPSC.DeactivateSystem();
    // End:0x69
    if(HandEffectPSC != none)
    {
        MeshCpnt.DetachComponent(HandEffectPSC);
    }
    //return;    
}

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__PKAttachment_Weap_ClownSpell_Base.SkeletalMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'SkeletalMeshComponent0'
    // Archetype: SkeletalMeshComponent'Default__PainAttachment_Weap_Base.SkeletalMeshComponent0'
    begin object name="SkeletalMeshComponent0"
        // Reference: UDKAnimNodeSequence'Default__PKAttachment_Weap_ClownSpell_Base.SkeletalMeshComponent0.MeshSequenceA'
        // Archetype: UDKAnimNodeSequence'Default__PainAttachment_Weap_Base.SkeletalMeshComponent0.MeshSequenceA'
        begin object name="MeshSequenceA"
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    Mesh=SkeletalMeshComponent0
    TracerChance=0.9000000
    WeaponClass=Class'PKWeap_ClownSpell_Base'
    WeapAnimType=EWeapAnimType.EWAT_Pistol
    EvilWeapAnimType=EEvilWeapAnimType.EEWAT_Pistol
}