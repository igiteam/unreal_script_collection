class PKEmit_BodyFlame extends UTEmit_HitEffect
    hidecategories(Navigation);

defaultproperties
{
    // Reference: ParticleSystemComponent'Default__PKEmit_BodyFlame.ParticleSystemComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ParticleSystemComponent0'
    // Archetype: ParticleSystemComponent'EvilGame.Default__UTEmit_HitEffect.ParticleSystemComponent0'
    begin object name="ParticleSystemComponent0"
        Template=ParticleSystem'ps_wp_SMG.Effects.ps_wp_FlameOnBody'
        ReplacementPrimitive=none
        bOwnerNoSee=true
    end object
    ParticleSystemComponent=ParticleSystemComponent0
    Components[0]=ParticleSystemComponent0
}