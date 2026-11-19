class ParticleBeam2EmitterInstance extends ParticleEmitterInstance
    native
    editinlinenew
    collapsecategories
    noexport
    hidecategories(Object,Object);

var const ParticleSpriteEmitter SpriteTemplate;
var const ParticleModuleTypeDataBeam2 BeamTypeData;
var const ParticleModuleBeamSource BeamModule_Source;
var const ParticleModuleBeamTarget BeamModule_Target;
var const ParticleModuleBeamNoise BeamModule_Noise;
var private const bool FirstEmission;
var private const int LastEmittedParticleIndex;
var private const int TickCount;
var private const int ForceSpawnCount;
var int BeamMethod;
var array<int> TextureTiles;
var int BeamCount;
var Actor SourceActor;
var ParticleEmitterInstance SourceEmitter;
var array<Vector> UserSetSourceArray;
var array<Vector> UserSetSourceTangentArray;
var array<float> UserSetSourceStrengthArray;
var array<float> DistanceArray;
var array<Vector> TargetPointArray;
var array<Vector> TargetTangentArray;
var array<float> UserSetTargetStrengthArray;
var Actor TargetActor;
var ParticleEmitterInstance TargetEmitter;
var array<name> TargetPointSourceNames;
var array<Vector> UserSetTargetArray;
var array<Vector> UserSetTargetTangentArray;
var private const Pointer VertexBuffer;
var private const Pointer IndexBuffer;
var private const Pointer VertexFactory;

// Export UParticleBeam2EmitterInstance::execSetBeamType(FFrame&, void* const)
native function SetBeamType(int NewMethod);

// Export UParticleBeam2EmitterInstance::execSetTessellationFactor(FFrame&, void* const)
native function SetTessellationFactor(float NewFactor);

// Export UParticleBeam2EmitterInstance::execSetEndPoint(FFrame&, void* const)
native function SetEndPoint(Vector NewEndPoint);

// Export UParticleBeam2EmitterInstance::execSetDistance(FFrame&, void* const)
native function SetDistance(float Distance);

// Export UParticleBeam2EmitterInstance::execSetSourcePoint(FFrame&, void* const)
native function SetSourcePoint(Vector NewSourcePoint, int SourceIndex);

// Export UParticleBeam2EmitterInstance::execSetSourceTangent(FFrame&, void* const)
native function SetSourceTangent(Vector NewTangentPoint, int SourceIndex);

// Export UParticleBeam2EmitterInstance::execSetSourceStrength(FFrame&, void* const)
native function SetSourceStrength(float NewSourceStrength, int SourceIndex);

// Export UParticleBeam2EmitterInstance::execSetTargetPoint(FFrame&, void* const)
native function SetTargetPoint(Vector NewTargetPoint, int TargetIndex);

// Export UParticleBeam2EmitterInstance::execSetTargetTangent(FFrame&, void* const)
native function SetTargetTangent(Vector NewTangentPoint, int TargetIndex);

// Export UParticleBeam2EmitterInstance::execSetTargetStrength(FFrame&, void* const)
native function SetTargetStrength(float NewTargetStrength, int TargetIndex);
