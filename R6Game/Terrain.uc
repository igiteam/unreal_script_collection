class Terrain extends Info
    native
    placeable
    hidecategories(lighting,Collision);

struct TerrainHeight
{
};

struct TerrainWeightedMaterial
{
};

struct TerrainLayer
{
    var() string Name;
    var() TerrainLayerSetup Setup;
    var int AlphaMapIndex;
    var() bool Highlighted;
    var() bool WireframeHighlighted;
    var() bool Hidden;
    var() Color HighlightColor;
    var() Color WireframeColor;
    var int MinX;
    var int MinY;
    var int MaxX;
    var int MaxY;

    structdefaultproperties
    {
        Name=""
        Setup=none
        AlphaMapIndex=-1
        Highlighted=false
        WireframeHighlighted=false
        Hidden=false
        HighlightColor=(R=0,G=0,B=0,A=0)
        WireframeColor=(R=0,G=0,B=0,A=0)
        MinX=0
        MinY=0
        MaxX=0
        MaxY=0
    }
};

struct AlphaMap
{
};

struct TerrainDecorationInstance
{
    var export editinline PrimitiveComponent Component;
    var float X;
    var float Y;
    var float Scale;
    var int Yaw;

    structdefaultproperties
    {
        Component=none
        X=0.0000000
        Y=0.0000000
        Scale=0.0000000
        Yaw=0
    }
};

struct TerrainDecoration
{
    var() editinline PrimitiveComponentFactory Factory;
    var() float MinScale;
    var() float MaxScale;
    var() float Density;
    var() float SlopeRotationBlend;
    var() int RandSeed;
    var array<TerrainDecorationInstance> Instances;

    structdefaultproperties
    {
        Factory=none
        MinScale=1.0000000
        MaxScale=1.0000000
        Density=0.0100000
        SlopeRotationBlend=0.0000000
        RandSeed=0
        Instances=none
    }
};

struct TerrainDecoLayer
{
    var() string Name;
    var() array<TerrainDecoration> Decorations;
    var int AlphaMapIndex;

    structdefaultproperties
    {
        Name=""
        Decorations=none
        AlphaMapIndex=-1
    }
};

struct TerrainMaterialResource
{
};

struct TerrainFoliageMeshResource
{
};

var private native const array<TerrainHeight> Heights;
var() const array<TerrainLayer> Layers;
var() const array<TerrainDecoLayer> DecoLayers;
var native const array<AlphaMap> AlphaMaps;
var nontransactional const export editinline array<export editinline TerrainComponent> TerrainComponents;
var const int NumSectionsX;
var const int NumSectionsY;
var const int SectionSize;
var private native const array<TerrainWeightedMaterial> WeightedMaterials;
var native const array<byte> CachedDisplacements;
var native const float MaxCollisionDisplacement;
var() int MaxTesselationLevel;
var() float TesselationDistanceScale;
var() int CollisionTesselationLevel;
var native const int CachedMaterialCount;
var native const Pointer CachedMaterials;
var const int NumVerticesX;
var const int NumVerticesY;
var() int NumPatchesX;
var() int NumPatchesY;
var() int MaxComponentSize;
var() int StaticLightingResolution;
var() bool bIsOverridingLightResolution;
var() bool bCastShadow;
var() const bool bForceDirectLightMap;
var() const bool bCastDynamicShadow;
var() const bool bBlockRigidBody;
var private native const map{VOID,VOID} FoliageMeshMap;

// Export UTerrain::execCalcLayerBounds(FFrame&, void* const)
native final function CalcLayerBounds();

simulated function PostBeginPlay()
{
    local int I;

    CalcLayerBounds();
    I = 0;
    J0x0D:

    // End:0x58 [Loop If]
    if(I < Layers.Length)
    {
        // End:0x4E
        if(Layers[I].Setup != none)
        {
            Layers[I].Setup.PostBeginPlay();
        }
        I++;
        // [Loop Continue]
        goto J0x0D;
    }
    return;
}

defaultproperties
{
    MaxTesselationLevel=4
    TesselationDistanceScale=1.0000000
    CollisionTesselationLevel=1
    StaticLightingResolution=4
    bCastShadow=true
    bCastDynamicShadow=true
    bBlockRigidBody=true
    bStatic=true
    bHidden=false
    bNoDelete=true
    bWorldGeometry=true
    bCollideActors=true
    bBlockActors=true
    bEdShouldSnap=true
    // Reference: SpriteComponent'Default__Terrain.SpriteComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="SpriteComponent0" class=Class'SpriteComponent'
        Sprite=Texture2D'EngineResources.S_Terrain'
        HiddenGame=true
    end object
    Components[0]=SpriteComponent0
    DrawScale3D=(X=512.0000000,Y=512.0000000,Z=512.0000000)
}