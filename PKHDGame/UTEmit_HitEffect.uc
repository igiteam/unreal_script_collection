class UTEmit_HitEffect extends UTEmitter
    hidecategories(Navigation);

simulated function AttachTo(Pawn P, name NewBoneName)
{
    // End:0x29
    if(NewBoneName == 'None')
    {
        SetBase(P);        
    }
    else
    {
        SetBase(P,, P.Mesh, NewBoneName);
    }
    //return;    
}

simulated function PawnBaseDied()
{
    // End:0x2E
    if(ParticleSystemComponent != none)
    {
        ParticleSystemComponent.DeactivateSystem();
    }
    //return;    
}

defaultproperties
{
    // Reference: ParticleSystemComponent'Default__UTEmit_HitEffect.ParticleSystemComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ParticleSystemComponent0'
    // Archetype: ParticleSystemComponent'Default__UTEmitter.ParticleSystemComponent0'
    begin object name="ParticleSystemComponent0"
        ReplacementPrimitive=none
    end object
    ParticleSystemComponent=ParticleSystemComponent0
    Components[0]=ParticleSystemComponent0
}