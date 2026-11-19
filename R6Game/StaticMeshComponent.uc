class StaticMeshComponent extends MeshComponent
    native
    editinlinenew
    noexport
    hidecategories(Object)
    autoexpandcategories(Collision,Rendering,lighting);

struct StaticMeshComponentLODInfo
{
    var private const array<ShadowMap2D> ShadowMaps;
    var private const LightMap LightMap;
    var private const array<Pointer> TrangleRasterizerMaps;
    var private const array<Pointer> m_RelevantLights;

    structdefaultproperties
    {
        ShadowMaps=none
        LightMap=none
        TrangleRasterizerMaps=none
        m_RelevantLights=none
    }
};

var int ForcedLodModel;
var int PreviousLODLevel;
var() const StaticMesh StaticMesh;
var() Color WireframeColor;
var const bool bIsOwnerAStaticMeshActor;
var() const bool bOverrideLightMapResolution;
var(Collision) const bool m_bForceSimpleCollisionForMovement;
var(Heat) bool m_bHiddenHeatVision;
var byte UpdateMTDataFlag;
var() const int OverriddenLightMapResolution;
var const array<Guid> IrrelevantLights;
var private native const array<MeshElementLightInfo> Lights;
var const int m_iUnlitImpactID;
var Pointer m_pSMMTCache[2];
var private const array<StaticMeshComponentLODInfo> LODData;
var private const array<LinearColor> m_R6SHCoefficient;
var private const bool m_bLightmapHasSomeContribution;
var native const array<int> m_PackedStaticLights;

// Export UStaticMeshComponent::execSetStaticMesh(FFrame&, void* const)
native final simulated function SetStaticMesh(StaticMesh NewMesh);

// Export UStaticMeshComponent::execGetTag(FFrame&, void* const)
native static final function bool GetTag(name TagName, out Vector Location, out Rotator InRotation);
