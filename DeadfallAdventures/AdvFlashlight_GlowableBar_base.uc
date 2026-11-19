class AdvFlashlight_GlowableBar_base extends AdvFlashlight_GlowableElement_base
    abstract
    hidecategories(Navigation);

defaultproperties
{
    // Reference: AudioComponent'Default__AdvFlashlight_GlowableBar_base.LightAudioComponent0'
    begin object name=LightAudioComponent0
    end object
    LightSoundComponent=LightAudioComponent0
    // Reference: AudioComponent'Default__AdvFlashlight_GlowableBar_base.SizzleAudioComponent0'
    begin object name=SizzleAudioComponent0
    end object
    SizzleSoundComponent=SizzleAudioComponent0
    // Reference: ParticleSystemComponent'Default__AdvFlashlight_GlowableBar_base.FireParticles'
    begin object name=FireParticles
        ReplacementPrimitive=none
    end object
    Glow=FireParticles
    // Reference: StaticMeshComponent'Default__AdvFlashlight_GlowableBar_base.StaticMeshComponent0'
    begin object name=StaticMeshComponent0
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvFlashlight_GlowableBar_base.MyLightEnvironment'
    end object
    StaticMeshComponent=StaticMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__AdvFlashlight_GlowableBar_base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=MyLightEnvironment
    Components[1]=StaticMeshComponent0
    Components[2]=FireParticles
    Components[3]=LightAudioComponent0
    Components[4]=SizzleAudioComponent0
    CollisionComponent=StaticMeshComponent0
}