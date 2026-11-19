class AdvEmitterCamera_Blood extends EvilEmitterCamera_Base
    hidecategories(Navigation);

defaultproperties
{
    PS_CameraEffect=ParticleSystem'ps_Blood.Effects.P_CameraBlood'
    PS_CameraEffectNonExtremeContent=ParticleSystem'ps_Blood.Effects.P_CameraBlood'
    // Reference: ParticleSystemComponent'Default__AdvEmitterCamera_Blood.ParticleSystemComponent0'
    begin object name=ParticleSystemComponent0
        ReplacementPrimitive=none
    end object
    ParticleSystemComponent=ParticleSystemComponent0
    Components[0]=ParticleSystemComponent0
}