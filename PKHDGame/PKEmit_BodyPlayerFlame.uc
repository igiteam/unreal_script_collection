class PKEmit_BodyPlayerFlame extends PKEmit_BodyFlame
    hidecategories(Navigation);

defaultproperties
{
    // Reference: ParticleSystemComponent'Default__PKEmit_BodyPlayerFlame.ParticleSystemComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ParticleSystemComponent0'
    // Archetype: ParticleSystemComponent'Default__PKEmit_BodyFlame.ParticleSystemComponent0'
    begin object name="ParticleSystemComponent0"
        Template=ParticleSystem'ps_FireEffects.Effects.ps_ch_BurningPlayer'
        ReplacementPrimitive=none
    end object
    ParticleSystemComponent=ParticleSystemComponent0
    Components[0]=ParticleSystemComponent0
}