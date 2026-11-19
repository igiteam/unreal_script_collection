class PKAttachment_Weap_SMG_Base extends PainAttachment_Weap_Base
    hidecategories(Navigation);

var name FlamerSocket;
var export editinline UTParticleSystemComponent FlamerPSC;
var export editinline UTParticleSystemComponent FlamerEffectComp;
var() ParticleSystem FlamerEffect;

simulated function ThirdPersonFireEffects(Vector HitLocation)
{
    super(EvilAttachment_Weap_Base).ThirdPersonFireEffects(HitLocation);
    // End:0x244
    if((int(Instigator.FiringMode) == int(1)) && FlamerEffect != none)
    {
        // End:0x15F
        if(FlamerEffectComp == none)
        {
            FlamerEffectComp = new (Outer) Class'EvilGame.UTParticleSystemComponent';
            FlamerEffectComp.SetTemplate(FlamerEffect);
            // End:0x10D
            if((Mesh != none) && Mesh.SkeletalMesh != none)
            {
                Mesh.AttachComponentToSocket(FlamerEffectComp, FlamerSocket);                
            }
            else
            {
                EvilPawn(Instigator).Mesh.AttachComponentToSocket(FlamerEffectComp, FlamerSocket);
            }            
        }
        else
        {
            FlamerEffectComp.ActivateSystem();
        }
        // End:0x211
        if(((FlamerEffectComp != none) && PKPlayerPawn(Instigator) != none) && PainPRI(Instigator.PlayerReplicationInfo).bHasWeaponModifier)
        {
            FlamerEffectComp.SetScale(1.2500000);            
        }
        else
        {
            // End:0x244
            if(FlamerEffectComp != none)
            {
                FlamerEffectComp.SetScale(1.0000000);
            }
        }
    }
    //return;    
}

simulated event StopThirdPersonFireEffects()
{
    super(EvilAttachment_Weap_Base).StopThirdPersonFireEffects();
    // End:0x38
    if(FlamerEffectComp != none)
    {
        FlamerEffectComp.DeactivateSystem();
    }
    //return;    
}

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__PKAttachment_Weap_SMG_Base.SkeletalMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'SkeletalMeshComponent0'
    // Archetype: SkeletalMeshComponent'Default__PainAttachment_Weap_Base.SkeletalMeshComponent0'
    begin object name="SkeletalMeshComponent0"
        // Reference: UDKAnimNodeSequence'Default__PKAttachment_Weap_SMG_Base.SkeletalMeshComponent0.MeshSequenceA'
        // Archetype: UDKAnimNodeSequence'Default__PainAttachment_Weap_Base.SkeletalMeshComponent0.MeshSequenceA'
        begin object name="MeshSequenceA"
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    Mesh=SkeletalMeshComponent0
    WeaponClass=Class'PKWeap_SMG_Base'
    EvilWeapAnimType=EEvilWeapAnimType.EEWAT_Vector
}