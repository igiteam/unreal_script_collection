class TerrainComponent extends PrimitiveComponent
    native
    noexport;

struct TerrainkDOPTree
{
    var private native const array<int> Nodes;
    var private native const array<int> Triangles;
};

var private const array<ShadowMap2D> ShadowMaps;
var const array<Guid> IrrelevantLights;
var native const Pointer TerrainObject;
var const int SectionBaseX;
var const int SectionBaseY;
var const int SectionSizeX;
var const int SectionSizeY;
var const LightMap2D LightMap;
var private native const array<int> PatchBounds;
var private native const array<int> PatchBatches;
var private native const array<int> BatchMaterials;
var private native const int FullBatch;
var private native const array<int> Lights;
var private native const Pointer PatchBatchOffsets;
var private native const Pointer WorkingOffsets;
var private native const Pointer PatchBatchTriangles;
var private native const Pointer PatchCachedTessellationValues;
var private native const Pointer TesselationLevels;
var private native const Pointer Batches;
var private native const TerrainkDOPTree BoxCheckTree;
var private native const array<int> CollisionVertices;
var private native const array<byte> CachedPhysTerrainData;
