class PainAttachment_Weap_Base extends EvilAttachment_Weap_Base
    abstract
    hidecategories(Navigation);

simulated function bool IsDLC5()
{
    local PainGRI_SP GRISP;

    GRISP = PainGRI_SP(WorldInfo.GRI);
    // End:0x105
    if((GRISP != none) && ((((GRISP.ChapterNum == 29) || GRISP.ChapterNum == 30) || GRISP.ChapterNum == 32) || GRISP.ChapterNum == 28) || GRISP.ChapterNum == 31)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated function ParticleSystem TrySwapImpactParticleSystem(ParticleSystem InParticleSystem, PhysicalMaterial PhysMaterial, class<EvilDmgType_Base> EvilDamageType)
{
    // End:0x96
    if((IsDLC5()) && (PhysMaterial == PhysicalMaterial'pm_materials.PM_Stone') || PhysMaterial == PhysicalMaterial'pm_materials.PM_Default')
    {
        // End:0x6C
        if(EvilDamageType == Class'PKDmgType_Shotgun')
        {
            InParticleSystem = ParticleSystem'ps_wp_hiteffectsDLC5.Effects.ps_wp_HitEffectShotgun';            
        }
        else
        {
            // End:0x96
            if(EvilDamageType == Class'PKDmgType_Chaingun')
            {
                InParticleSystem = ParticleSystem'ps_wp_hiteffectsDLC5.Effects.ps_wp_HitEffectRock';
            }
        }
    }
    return InParticleSystem;
    //return ReturnValue;    
}

simulated function Projectile GetTracer(Vector TracerStartLoc)
{
    local EvilProjectile_Tracer_Base Tracer;

    Tracer = EvilProjectile_Tracer_Base(Spawn(TracerClass, self,, TracerStartLoc,,, true));
    return Tracer;
    //return ReturnValue;    
}

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__PainAttachment_Weap_Base.SkeletalMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'SkeletalMeshComponent0'
    // Archetype: SkeletalMeshComponent'EvilGame.Default__EvilAttachment_Weap_Base.SkeletalMeshComponent0'
    begin object name="SkeletalMeshComponent0"
        // Reference: UDKAnimNodeSequence'Default__PainAttachment_Weap_Base.SkeletalMeshComponent0.MeshSequenceA'
        // Archetype: UDKAnimNodeSequence'EvilGame.Default__EvilAttachment_Weap_Base.MeshSequenceA'
        begin object name="MeshSequenceA"
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    Mesh=SkeletalMeshComponent0
    TracerClass=Class'PKProjectile_Tracer'
}