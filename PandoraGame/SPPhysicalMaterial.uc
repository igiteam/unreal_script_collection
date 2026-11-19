class SPPhysicalMaterial extends PhysicalMaterial
    native
    collapsecategories;

var const transient WorldInfo WorldInfo;
var() bool bCanReflectBullets;
var() bool bUseReflectedImpactSoundOnReflection;
var() bool bUseReflectedImpactDecalOnReflection;
var() bool bUseReflectedImpactParticlesOnReflection;

// Export USPPhysicalMaterial::execGetWorldInfo(FFrame&, void* const)
native function WorldInfo GetWorldInfo();

// Export USPPhysicalMaterial::execGetRotatorToAlignParticle(FFrame&, void* const)
native function Rotator GetRotatorToAlignParticle(const Vector Direction);

// Export USPPhysicalMaterial::execGetSoundCue(FFrame&, void* const)
native function SoundCue GetSoundCue(PawnSoundInfo soundInfo, SPPhysicalMaterialProperty.PawnSoundType soundCueType);

// Export USPPhysicalMaterial::execPlayPawnSound(FFrame&, void* const)
native function bool PlayPawnSound(SPPawn thePawn, SPPhysicalMaterialProperty.PawnSoundType soundCueType, optional float maxDist = 0.0000000);

// Export USPPhysicalMaterial::execFindBestSound(FFrame&, void* const)
native function SoundCue FindBestSound(class<Actor> ActorClass, SPPhysicalMaterialProperty.PawnSoundType soundCueType);

// Export USPPhysicalMaterial::execStartSingleFootStepParticleSystems(FFrame&, void* const)
native function bool StartSingleFootStepParticleSystems(Actor TheActor, SPPhysicalMaterialParicleSystemParams PsParams, optional FootStepParticleInfo DefaultParticles);

// Export USPPhysicalMaterial::execStartFootStepParticleSystems(FFrame&, void* const)
native function StartFootStepParticleSystems(Actor TheActor, array<SPPhysicalMaterialParicleSystemParams> PsParams, optional FootStepParticleInfo DefaultParticles);

// Export USPPhysicalMaterial::execPlayFootStepSound(FFrame&, void* const)
native function bool PlayFootStepSound(SPPawn thePawn, optional float maxDist = 0.0000000);

// Export USPPhysicalMaterial::execPlayFootScuffSound(FFrame&, void* const)
native function bool PlayFootScuffSound(SPPawn thePawn, optional float maxDist = 0.0000000);

// Export USPPhysicalMaterial::execPlayFootRunSound(FFrame&, void* const)
native function bool PlayFootRunSound(SPPawn thePawn, optional float maxDist = 0.0000000);

// Export USPPhysicalMaterial::execPlayJumpInitSound(FFrame&, void* const)
native function bool PlayJumpInitSound(SPPawn thePawn, optional float maxDist = 0.0000000);

// Export USPPhysicalMaterial::execPlayJumpLandSound(FFrame&, void* const)
native function bool PlayJumpLandSound(SPPawn thePawn, optional float maxDist = 0.0000000);

// Export USPPhysicalMaterial::execPlayBodyFallSound(FFrame&, void* const)
native function bool PlayBodyFallSound(SPPawn thePawn, optional float maxDist = 0.0000000);

// Export USPPhysicalMaterial::execPlayBodyFallSoftSound(FFrame&, void* const)
native function bool PlayBodyFallSoftSound(SPPawn thePawn, optional float maxDist = 0.0000000);

// Export USPPhysicalMaterial::execPlayCrouchDownSound(FFrame&, void* const)
native function bool PlayCrouchDownSound(SPPawn thePawn, optional float maxDist = 0.0000000);

// Export USPPhysicalMaterial::execPlayCrouchStepSound(FFrame&, void* const)
native function bool PlayCrouchStepSound(SPPawn thePawn, optional float maxDist = 0.0000000);

// Export USPPhysicalMaterial::execPlayCrouchUpSound(FFrame&, void* const)
native function bool PlayCrouchUpSound(SPPawn thePawn, optional float maxDist = 0.0000000);

// Export USPPhysicalMaterial::execPlayImpactSound(FFrame&, void* const)
native function bool PlayImpactSound(class<DamageType> theDamageType, Actor dummyActor, Vector SoundPosition);

// Export USPPhysicalMaterial::execPlayReflectedImpactSound(FFrame&, void* const)
native function bool PlayReflectedImpactSound(class<DamageType> theDamageType, Actor dummyActor, Vector SoundPosition);

// Export USPPhysicalMaterial::execPlayVocalHitReactionSound(FFrame&, void* const)
native function bool PlayVocalHitReactionSound(class<DamageType> theDamageType, Actor dummyActor, Vector SoundPosition);

// Export USPPhysicalMaterial::execPlayImpactSoundHelper(FFrame&, void* const)
native function bool PlayImpactSoundHelper(class<DamageType> theDamageType, Actor dummyActor, Vector SoundPosition, out array<ImpactSoundInfo> soundInfoArray, int closestIndex);

// Export USPPhysicalMaterial::execPlayEffectLoopSound(FFrame&, void* const)
native function AudioComponent PlayEffectLoopSound(class<DamageType> theDamageType, Actor dummyActor, Vector SoundPosition, out SoundCue EndSound);

// Export USPPhysicalMaterial::execAddImpactDecal(FFrame&, void* const)
native function bool AddImpactDecal(class<DamageType> theDamageType, ImpactInfo Impact, optional ImpactDecalInfo DefaultDecal);

// Export USPPhysicalMaterial::execAddReflectedImpactDecal(FFrame&, void* const)
native function bool AddReflectedImpactDecal(class<DamageType> theDamageType, ImpactInfo Impact, optional ImpactDecalInfo DefaultDecal);

// Export USPPhysicalMaterial::execAddImpactDecalHelper(FFrame&, void* const)
native function bool AddImpactDecalHelper(class<DamageType> theDamageType, ImpactInfo Impact, out array<ImpactDecalInfo> decalInfoArray, int closestIndex);

// Export USPPhysicalMaterial::execAddImpactLight(FFrame&, void* const)
native function Light AddImpactLight(class<DamageType> theDamageType, ImpactInfo Impact);

// Export USPPhysicalMaterial::execAddReflectedImpactParticles(FFrame&, void* const)
native function SPEmitter AddReflectedImpactParticles(class<DamageType> theDamageType, ImpactInfo Impact, optional name attachedSocketName, optional out array<ParticleSystem> PSLevels, optional ImpactParticlesInfo DefaultParticles);

// Export USPPhysicalMaterial::execAddImpactParticles(FFrame&, void* const)
native function SPEmitter AddImpactParticles(class<DamageType> theDamageType, ImpactInfo Impact, optional name attachedSocketName, optional out array<ParticleSystem> PSLevels, optional ImpactParticlesInfo DefaultParticles);

// Export USPPhysicalMaterial::execAddImpactParticlesHelper(FFrame&, void* const)
native function SPEmitter AddImpactParticlesHelper(class<DamageType> theDamageType, ImpactInfo Impact, out array<ImpactParticlesInfo> particleInfoArray, int closestIndex, name attachedSocketName, optional out array<ParticleSystem> PSLevels);

// Export USPPhysicalMaterial::execAddImpactHurtRadius(FFrame&, void* const)
native function SPHurtRadius AddImpactHurtRadius(class<DamageType> theDamageType, ImpactInfo Impact);

function SPEmitter AddImpactParticlesOldVersion(class<DamageType> theDamageType, ImpactInfo Impact, optional name attachedSocketName, optional out ParticleSystem PSLevels[3], optional ImpactParticlesInfo DefaultParticles)
{
    local array<ParticleSystem> newPSLevel;

    newPSLevel.AddItem(PSLevels[0]);
    newPSLevel.AddItem(PSLevels[1]);
    newPSLevel.AddItem(PSLevels[2]);
    return AddImpactParticles(theDamageType, Impact, attachedSocketName, newPSLevel, DefaultParticles);
    //return ReturnValue;    
}
