class SkyParticleSystemComponent extends ParticleSystemComponent
    native
    editinlinenew;

var transient bool bSkyPoolActive;

// Export USkyParticleSystemComponent::execIsPoolAvailable(FFrame&, void* const)
native simulated function bool IsPoolAvailable();

// Export USkyParticleSystemComponent::execInitForPooling(FFrame&, void* const)
native simulated function InitForPooling(ParticleSystem PSC);

// Export USkyParticleSystemComponent::execDestroyFromPooling(FFrame&, void* const)
native simulated function DestroyFromPooling();

// Export USkyParticleSystemComponent::execInit(FFrame&, void* const)
native simulated function Init();

// Export USkyParticleSystemComponent::execReset(FFrame&, void* const)
native simulated function Reset();

// Export USkyParticleSystemComponent::execMyOnParticleSystemFinished(FFrame&, void* const)
native simulated function MyOnParticleSystemFinished(ParticleSystemComponent PSC);
