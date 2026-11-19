class ParticleBeamEmitterInstance extends ParticleEmitterInstance
    native
    editinlinenew
    collapsecategories
    noexport
    hidecategories(Object,Object);

var const ParticleSpriteEmitter SpriteTemplate;
var const ParticleModuleTypeDataBeam BeamTypeData;
var private const bool FirstEmission;
var private const int iLastEmittedParticleIndex;
var private const int uiTickCount;
var private const int uiForceSpawnCount;
var int iBeamMethod;
var float fDistance;
var int iBeamCount;
var array<Vector> EndPointArray;
var array<Vector> UserSetEndPointArray;
var int iTextureTile;
var private const Pointer VertexBuffer;
var private const Pointer VertexFactory;

// Export UParticleBeamEmitterInstance::execSetBeamType(FFrame&, void* const)
native function SetBeamType(int NewMethod);

// Export UParticleBeamEmitterInstance::execSetTessellationFactor(FFrame&, void* const)
native function SetTessellationFactor(float NewFactor);

// Export UParticleBeamEmitterInstance::execSetEndPoint(FFrame&, void* const)
native function SetEndPoint(Vector NewEndPoint);

// Export UParticleBeamEmitterInstance::execSetDistance(FFrame&, void* const)
native function SetDistance(float Distance);
