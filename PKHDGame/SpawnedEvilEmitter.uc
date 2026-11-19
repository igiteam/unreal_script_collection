class SpawnedEvilEmitter extends EvilEmitter
    hidecategories(Navigation);

final function HideBecauseFinished(ParticleSystemComponent FinishedComponent)
{
    HideSelf();
    //return;    
}

defaultproperties
{
    // Reference: ParticleSystemComponent'Default__SpawnedEvilEmitter.ParticleSystemComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ParticleSystemComponent0'
    // Archetype: ParticleSystemComponent'Default__EvilEmitter.ParticleSystemComponent0'
    begin object name="ParticleSystemComponent0"
        SecondsBeforeInactive=0.0000000
        ReplacementPrimitive=none
    end object
    ParticleSystemComponent=ParticleSystemComponent0
    Components[0]=ParticleSystemComponent0
    LifeSpan=30.0000000
}