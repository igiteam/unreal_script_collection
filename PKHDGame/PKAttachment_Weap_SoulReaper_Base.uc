class PKAttachment_Weap_SoulReaper_Base extends PainAttachment_Weap_Base
    abstract
    hidecategories(Navigation);

var export editinline UTParticleSystemComponent BeamEffectComp;
var() ParticleSystem BeamEffect;
var() name BeamEffectEndPointName;

simulated function ThirdPersonFireEffects(Vector HitLocation)
{
    super(EvilAttachment_Weap_Base).ThirdPersonFireEffects(HitLocation);
    // End:0x1DA
    if(((int(Instigator.FiringMode) == int(1)) && HitLocation != vect(0.0000000, 0.0000000, 0.0000000)) && EffectIsRelevant(HitLocation, false, MaxFireEffectDistance, MaxFireEffectDistance * 0.7500000))
    {
        // End:0x189
        if(BeamEffectComp == none)
        {
            BeamEffectComp = new (Outer) Class'EvilGame.UTParticleSystemComponent';
            BeamEffectComp.SetTemplate(BeamEffect);
            BeamEffectComp.SetTickGroup(3);
            BeamEffectComp.bUpdateComponentInTick = true;
            Mesh.AttachComponentToSocket(BeamEffectComp, MuzzleFlashSocket);
            BeamEffectComp.SetVectorParameter(BeamEffectEndPointName, HitLocation);            
        }
        else
        {
            BeamEffectComp.ActivateSystem();
            BeamEffectComp.SetVectorParameter(BeamEffectEndPointName, HitLocation);
        }
    }
    //return;    
}

simulated event StopThirdPersonFireEffects()
{
    super(EvilAttachment_Weap_Base).StopThirdPersonFireEffects();
    // End:0x38
    if(BeamEffectComp != none)
    {
        BeamEffectComp.DeactivateSystem();
    }
    //return;    
}

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__PKAttachment_Weap_SoulReaper_Base.SkeletalMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'SkeletalMeshComponent0'
    // Archetype: SkeletalMeshComponent'Default__PainAttachment_Weap_Base.SkeletalMeshComponent0'
    begin object name="SkeletalMeshComponent0"
        // Reference: UDKAnimNodeSequence'Default__PKAttachment_Weap_SoulReaper_Base.SkeletalMeshComponent0.MeshSequenceA'
        // Archetype: UDKAnimNodeSequence'Default__PainAttachment_Weap_Base.SkeletalMeshComponent0.MeshSequenceA'
        begin object name="MeshSequenceA"
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    Mesh=SkeletalMeshComponent0
    bSuppressSounds=true
    WeaponClass=Class'PKWeap_SoulReaper_Base'
}