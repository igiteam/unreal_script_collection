class DecalComponent extends PrimitiveComponent
    native
    editinlinenew
    hidecategories(Collision,Object,Physics,PrimitiveComponent);

enum EFilterMode
{
    FM_None,                        // 0
    FM_Ignore,                      // 1
    FM_Affect,                      // 2
    FM_MAX                          // 3
};

var(Decal) MaterialInstance DecalMaterial;
var(Decal) float Width;
var(Decal) float Height;
var(Decal) float TileX;
var(Decal) float TileY;
var(Decal) float OffsetX;
var(Decal) float OffsetY;
var(Decal) float Thickness;
var float FieldOfView;
var(Decal) float NearPlane;
var(Decal) float FarPlane;
var Vector Location;
var Rotator Orientation;
var Vector HitLocation;
var Vector HitNormal;
var Vector HitTangent;
var Vector HitBinormal;
var(Decal) bool bNoClip;
var const bool bStaticDecal;
var(DecalFilter) bool bProjectOnBackfaces;
var(DecalFilter) bool bProjectOnBSP;
var(DecalFilter) bool bProjectOnStaticMeshes;
var(DecalFilter) bool bProjectOnSkeletalMeshes;
var(DecalFilter) bool bProjectOnTerrain;
var export editinline transient PrimitiveComponent HitComponent;
var DecalLifetimeData LifetimeData;
var private const export editinline array<export editinline PrimitiveComponent> Receivers;
var private native const array<MeshElementLightInfo> Lights;
var private native const array<Pointer> RenderData;
var private transient array<Plane> Planes;
var(DecalRender) float DepthBias;
var(DecalRender) float SlopeScaleDepthBias;
var(DecalFilter) DecalComponent.EFilterMode FilterMode;
var(DecalFilter) array<Actor> Filter;

// Export UDecalComponent::execSetDecalMaterial(FFrame&, void* const)
native function SetDecalMaterial(MaterialInstance Material);

// Export UDecalComponent::execFinalize(FFrame&, void* const)
native function Finalize();

// Export UDecalComponent::execDetachReceiver(FFrame&, void* const)
native function DetachReceiver(PrimitiveComponent Receiver);

// Export UDecalComponent::execDetachFromReceivers(FFrame&, void* const)
native function DetachFromReceivers();

// Export UDecalComponent::execGetManager(FFrame&, void* const)
native function DecalManager GetManager();

// Export UDecalComponent::execConnectToManager(FFrame&, void* const)
native function ConnectToManager();

// Export UDecalComponent::execDisconnectFromManager(FFrame&, void* const)
native function DisconnectFromManager();
