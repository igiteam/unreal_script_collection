class ParticleMeshEmitterInstance extends ParticleEmitterInstance
    native
    editinlinenew
    collapsecategories
    noexport
    hidecategories(Object,Object);

struct ParticleMeshInstance
{
    var Matrix m_LocalToWorld;
    var Matrix m_WorldToLocal;
    var float m_LocalToWorldDeterminant;
    var Pointer m_Materials;
    var int m_bValid;
    var BoxSphereBounds m_Bounds;

    structdefaultproperties
    {
        m_LocalToWorld=(XPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),YPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),ZPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),WPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000))
        m_WorldToLocal=(XPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),YPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),ZPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),WPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000))
        m_LocalToWorldDeterminant=0.0000000
        m_Materials=none
        m_bValid=0
        m_Bounds=(Origin=(X=0.0000000,Y=0.0000000,Z=0.0000000),BoxExtent=(X=0.0000000,Y=0.0000000,Z=0.0000000),SphereRadius=0.0000000)
    }
};

var const ParticleSpriteEmitter EmitterTemplate;
var const ParticleModuleTypeDataMesh MeshTypeData;
var private const Pointer LastScene;
var private const array<ParticleMeshInstance> MeshInstances;
var private const bool MeshRotationActive;
var private const int MeshRotationOffset;
var native const transient Pointer MTCacheMeshInstances[2];
