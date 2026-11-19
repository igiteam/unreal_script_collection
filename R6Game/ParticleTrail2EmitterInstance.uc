class ParticleTrail2EmitterInstance extends ParticleEmitterInstance
    native
    editinlinenew
    collapsecategories
    noexport
    hidecategories(Object,Object);

var const ParticleSpriteEmitter SpriteTemplate;
var const ParticleModuleTypeDataTrail2 TrailTypeData;
var const ParticleModuleTrailSource TrailModule_Source;
var const int TrailModule_Source_Offset;
var const ParticleModuleTrailSpawn TrailModule_Spawn;
var const int TrailModule_Spawn_Offset;
var const ParticleModuleTrailTaper TrailModule_Taper;
var const int TrailModule_Taper_Offset;
var private const bool FirstEmission;
var private const int LastEmittedParticleIndex;
var private const int LastSelectedParticleIndex;
var private const int TickCount;
var private const int ForceSpawnCount;
var private const int VertexCount;
var private const int TriangleCount;
var int Tessellation;
var array<int> TextureTiles;
var int TrailCount;
var int MaxTrailCount;
var array<float> TrailSpawnTimes;
var array<Vector> SourcePosition;
var array<Vector> LastSourcePosition;
var array<Vector> CurrentSourcePosition;
var array<Vector> LastSpawnPosition;
var array<Vector> LastSpawnTangent;
var array<float> SourceDistanceTravelled;
var Actor SourceActor;
var array<Vector> SourceOffsets;
var ParticleEmitterInstance SourceEmitter;
var int ActuallySpawned;
var private const Pointer VertexBuffer;
var private const Pointer IndexBuffer;
var private const Pointer VertexFactory;
