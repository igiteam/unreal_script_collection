class Texture extends Object
    abstract
    native
    noexport;

enum TextureCompressionSettings
{
    TC_Default,                     // 0
    TC_Normalmap,                   // 1
    TC_Displacementmap,             // 2
    TC_NormalmapAlpha,              // 3
    TC_Grayscale,                   // 4
    TC_HighDynamicRange,            // 5
    TC_MAX                          // 6
};

enum TextureFilter
{
    TF_Nearest,                     // 0
    TF_Linear,                      // 1
    TF_MAX                          // 2
};

enum TextureAddress
{
    TA_Wrap,                        // 0
    TA_Clamp,                       // 1
    TA_Mirror,                      // 2
    TA_MAX                          // 3
};

enum TextureGroup
{
    TEXTUREGROUP_World,             // 0
    TEXTUREGROUP_WorldNormalMap,    // 1
    TEXTUREGROUP_Character,         // 2
    TEXTUREGROUP_CharacterNormalMap,// 3
    TEXTUREGROUP_Weapon,            // 4
    TEXTUREGROUP_WeaponNormalMap,   // 5
    TEXTUREGROUP_Vehicle,           // 6
    TEXTUREGROUP_VehicleNormalMap,  // 7
    TEXTUREGROUP_Effects,           // 8
    TEXTUREGROUP_Skybox,            // 9
    TEXTUREGROUP_UI,                // 10
    TEXTUREGROUP_LightAndShadowMap, // 11
    TEXTUREGROUP_RenderTarget,      // 12
    TEXTUREGROUP_MAX                // 13
};

enum ETextureType
{
    TT_Automatic,                   // 0
    TT_Diffuse,                     // 1
    TT_Normal,                      // 2
    TT_Specular,                    // 3
    TT_LightMap,                    // 4
    TT_ShadowMap,                   // 5
    TT_Other,                       // 6
    TT_MAX                          // 7
};

var() bool SRGB;
var bool RGBE;
var float UnpackMin[4];
var float UnpackMax[4];
var native const LazyArray_Mirror SourceArt;
var bool CompressionNoAlpha;
var bool CompressionNone;
var() editconst bool CompressionNoMipmaps;
var bool CompressionFullDynamicRange;
var bool DeferCompression;
var() bool NeverStream;
var() bool HiResInPecHQ;
var bool bIgnoreLODBias;
var() Texture.ETextureType TextureType;
var() editconst Texture.TextureCompressionSettings CompressionSettings;
var() Texture.TextureFilter Filter;
var() int LODBias;
var() int LowResNbMips;
var() editconst string SourceFilePath;
var() editconst string SourceFileTimestamp;

defaultproperties
{
    SRGB=true
    UnpackMax[0]=1.0000000
    UnpackMax[1]=1.0000000
    UnpackMax[2]=1.0000000
    UnpackMax[3]=1.0000000
    Filter=1
    LowResNbMips=1
}