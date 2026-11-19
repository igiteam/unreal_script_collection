class TerrainMaterial extends Object
    native
    hidecategories(Object);

enum ETerrainMappingType
{
    TMT_Auto,                       // 0
    TMT_XY,                         // 1
    TMT_XZ,                         // 2
    TMT_YZ,                         // 3
    TMT_MAX                         // 4
};

struct TerrainFoliageMesh
{
    var() StaticMesh StaticMesh;
    var() MaterialInstance Material;
    var() int Density;
    var() float MaxDrawRadius;
    var() float MinTransitionRadius;
    var() float MinScale;
    var() float MaxScale;
    var() int Seed;
    var() float SwayScale;
    var() bool StaticLighting;

    structdefaultproperties
    {
        StaticMesh=none
        Material=none
        Density=0
        MaxDrawRadius=1024.0000000
        MinTransitionRadius=0.0000000
        MinScale=1.0000000
        MaxScale=1.0000000
        Seed=0
        SwayScale=1.0000000
        StaticLighting=true
    }
};

var Matrix LocalToMapping;
var(Material) TerrainMaterial.ETerrainMappingType MappingType;
var(Material) float MappingScale;
var(Material) float MappingRotation;
var(Material) float MappingPanU;
var(Material) float MappingPanV;
var(Material) MaterialInstance Material;
var(Displacement) Texture2D DisplacementMap;
var(Displacement) float DisplacementScale;
var(Foliage) array<TerrainFoliageMesh> FoliageMeshes;

defaultproperties
{
    MappingScale=4.0000000
    DisplacementScale=0.2500000
}