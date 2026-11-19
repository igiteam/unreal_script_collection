class EvilEmitterCamera_Base extends EmitterCameraLensEffectBase
    native(Particle)
    hidecategories(Navigation);

// Export UEvilEmitterCamera_Base::execUpdateLocation(FFrame&, void* const)
native simulated function UpdateLocation(const out Vector CamLoc, const out Rotator CamRot, float CamFOVDeg);

defaultproperties
{
    BaseFOV=75.0000000
    DistFromCamera=10.1000000
    bAllowMultipleInstances=true
    // Reference: ParticleSystemComponent'Default__EvilEmitterCamera_Base.ParticleSystemComponent0'
    begin object name=ParticleSystemComponent0
        ReplacementPrimitive=none
        DepthPriorityGroup=ESceneDepthPriorityGroup.SDPG_PostProcess
    end object
    ParticleSystemComponent=ParticleSystemComponent0
    Components[0]=ParticleSystemComponent0
}