class AdvFlashlight_GlowableMini_base extends AdvFlashlight_GlowableElement_base
    abstract
    hidecategories(Navigation);

simulated function SetLightAffectionFromFlashLight(bool bInLightCone, optional bool bBeamActive, optional Vector FlashSourceLocation)
{
    // End:0xD3
    if(bIsPuzzleActive && bInLightCone)
    {
        SetTimer(0.0000000, false, 'FlashlightBeamElsewhere_T');
        // End:0x4D
        if(bBeamActive)
        {
            bOnlyLighten = true;            
        }
        else
        {
            // End:0xBC
            if(!bIsLit)
            {
                bOnlyLighten = true;
                // End:0xBC
                if((LightSoundComponent != none) && !LightSoundComponent.IsPlaying())
                {
                    LightSoundComponent.Play();
                }
            }
        }
        SetTimer(DelayerThreshold, false, 'FlashlightBeamElsewhere_T');
    }
    //return;    
}

defaultproperties
{
    // Reference: AudioComponent'Default__AdvFlashlight_GlowableMini_base.LightAudioComponent0'
    begin object name=LightAudioComponent0
    end object
    LightSoundComponent=LightAudioComponent0
    // Reference: AudioComponent'Default__AdvFlashlight_GlowableMini_base.SizzleAudioComponent0'
    begin object name=SizzleAudioComponent0
    end object
    SizzleSoundComponent=SizzleAudioComponent0
    // Reference: ParticleSystemComponent'Default__AdvFlashlight_GlowableMini_base.FireParticles'
    begin object name=FireParticles
        ReplacementPrimitive=none
    end object
    Glow=FireParticles
    // Reference: StaticMeshComponent'Default__AdvFlashlight_GlowableMini_base.StaticMeshComponent0'
    begin object name=StaticMeshComponent0
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvFlashlight_GlowableMini_base.MyLightEnvironment'
    end object
    StaticMeshComponent=StaticMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__AdvFlashlight_GlowableMini_base.MyLightEnvironment'
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