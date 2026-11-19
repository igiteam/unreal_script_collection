class AdvEmitterCamera_RainDrops extends EmitterCameraLensEffectBase
    hidecategories(Navigation);

event Tick(float DeltaTime)
{
    local float F, Z;

    // End:0x13A
    if((Owner == none) || ((EvilPlayerController(BaseCamera.Owner) != none) && EvilPlayerController(BaseCamera.Owner).Pawn != none) && EvilPlayerController(BaseCamera.Owner).Pawn != Owner)
    {
        // End:0x13A
        if(EvilPlayerController(BaseCamera.Owner) != none)
        {
            SetOwner(EvilPlayerController(BaseCamera.Owner).Pawn);
        }
    }
    Z = Vector(BaseCamera.Owner.Rotation).Z;
    F = FClamp(FPctByRange(Z, -0.4000000, 0.7500000), 0.0000000, 1.0000000);
    // End:0x2C1
    if(((EvilPawn(Owner) != none) && AdvPlayerController(EvilPawn(Owner).Controller) != none) && AdvPlayerController(EvilPawn(Owner).Controller).WeatherEffect != none)
    {
        F *= AdvPlayerController(EvilPawn(Owner).Controller).WeatherEffect.Fader;
    }
    ParticleSystemComponent.SetFloatParameter('SpawnRate', F);
    ParticleSystemComponent.SetFloatParameter('Lifetime', 1.0000000 - F);
    F = FMax(0.0000000, Z);
    ParticleSystemComponent.SetFloatParameter('SpeedScale', FMin(1.0000000, ((-1.1000000 * F) * F) + 1.1000000));
    //return;    
}

defaultproperties
{
    PS_CameraEffect=ParticleSystem'adv_AtmosphericEffects.Effects.ps_ScreenWater_Droplets'
    PS_CameraEffectNonExtremeContent=ParticleSystem'adv_AtmosphericEffects.Effects.ps_ScreenWater_Droplets'
    bAllowMultipleInstances=true
    // Reference: ParticleSystemComponent'Default__AdvEmitterCamera_RainDrops.ParticleSystemComponent0'
    begin object name=ParticleSystemComponent0
        ReplacementPrimitive=none
        DepthPriorityGroup=ESceneDepthPriorityGroup.SDPG_PostProcess
    end object
    ParticleSystemComponent=ParticleSystemComponent0
    Components[0]=ParticleSystemComponent0
    LifeSpan=0.0000000
}