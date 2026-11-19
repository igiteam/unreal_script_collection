class Material extends MaterialInstance
    native
    collapsecategories
    hidecategories(Object);

enum EBlendMode
{
    BLEND_Opaque,                   // 0
    BLEND_Masked,                   // 1
    BLEND_Translucent,              // 2
    BLEND_Additive,                 // 3
    BLEND_Modulate,                 // 4
    BLEND_MAX                       // 5
};

enum EMaterialLightingModel
{
    MLM_Phong,                      // 0
    MLM_NonDirectional,             // 1
    MLM_Unlit,                      // 2
    MLM_SHPRT,                      // 3
    MLM_Custom,                     // 4
    MLM_LitSpecial,                 // 5
    MLM_LitSpecialNonDirectional,   // 6
    MLM_MAX                         // 7
};

struct MaterialInput
{
    var MaterialExpression Expression;
    var MaterialExpression.EActiveComponent activeComponent;
    var float ConstantR;
    var float ConstantG;
    var float ConstantB;
    var float ConstantA;
    var int Mask;
    var int MaskR;
    var int MaskG;
    var int MaskB;
    var int MaskA;

    structdefaultproperties
    {
        Expression=none
        activeComponent=0
        ConstantR=0.0000000
        ConstantG=0.0000000
        ConstantB=0.0000000
        ConstantA=0.0000000
        Mask=0
        MaskR=0
        MaskG=0
        MaskB=0
        MaskA=0
    }
};

struct ColorMaterialInput extends MaterialInput
{
    var bool UseConstant;
    var() Color Constant;
};

struct ScalarMaterialInput extends MaterialInput
{
    var bool UseConstant;
    var() float Constant;
};

struct VectorMaterialInput extends MaterialInput
{
    var bool UseConstant;
    var() Vector Constant;
};

struct Vector2MaterialInput extends MaterialInput
{
    var bool UseConstant;
    var() float ConstantX;
    var() float ConstantY;
    var int GCC64_Padding2;
};

struct HeatMaterialInput extends ScalarMaterialInput
{
};

struct MaterialPointer
{
    var native const Pointer P;
};

struct TextureBasePointer
{
    var native const Pointer P;
};

var() PhysicalMaterial PhysMaterial;
var class<PhysicalMaterial> PhysicalMaterial;
var() ColorMaterialInput DiffuseColor;
var() ColorMaterialInput SpecularColor;
var() ScalarMaterialInput SpecularPower;
var() VectorMaterialInput Normal;
var() SphericalHarmonicMap SHM;
var() ColorMaterialInput EmissiveColor;
var() ScalarMaterialInput Opacity;
var() ScalarMaterialInput OpacityMask;
var() float OpacityMaskClipValue;
var() Vector2MaterialInput Distortion;
var() Material.EBlendMode BlendMode;
var() Material.EMaterialLightingModel LightingModel;
var ColorMaterialInput CustomLighting;
var ScalarMaterialInput TwoSidedLightingMask;
var ColorMaterialInput TwoSidedLightingColor;
var() bool TwoSided;
var() bool Wireframe;
var() bool m_bHeatVisionHidden;
var() bool m_bHeatVisionReticule;
var private deprecated bool Unlit;
var private deprecated bool NonDirectionalLighting;
var() HeatMaterialInput m_Heat;
var() VectorMaterialInput VertexDeformation;
var native const MaterialPointer MaterialResource;
var native const MaterialInstancePointer DefaultMaterialInstances[3];
var native const array<TextureBasePointer> StreamingTextures;
var Guid PersistentIds[2];
var int EditorX;
var int EditorY;
var int EditorPitch;
var int EditorYaw;
var array<MaterialExpression> EditorMaterialExpressions;

defaultproperties
{
    DiffuseColor=(UseConstant=false,Constant=(R=128,G=128,B=128,A=0),Expression=none,activeComponent=0,ConstantR=0.0000000,ConstantG=0.0000000,ConstantB=0.0000000,ConstantA=0.0000000,Mask=0,MaskR=0,MaskG=0,MaskB=0,MaskA=0)
    SpecularColor=(UseConstant=false,Constant=(R=128,G=128,B=128,A=0),Expression=none,activeComponent=0,ConstantR=0.0000000,ConstantG=0.0000000,ConstantB=0.0000000,ConstantA=0.0000000,Mask=0,MaskR=0,MaskG=0,MaskB=0,MaskA=0)
    SpecularPower=(UseConstant=false,Constant=15.0000000,Expression=none,activeComponent=0,ConstantR=0.0000000,ConstantG=0.0000000,ConstantB=0.0000000,ConstantA=0.0000000,Mask=0,MaskR=0,MaskG=0,MaskB=0,MaskA=0)
    Opacity=(UseConstant=false,Constant=1.0000000,Expression=none,activeComponent=0,ConstantR=0.0000000,ConstantG=0.0000000,ConstantB=0.0000000,ConstantA=0.0000000,Mask=0,MaskR=0,MaskG=0,MaskB=0,MaskA=0)
    OpacityMask=(UseConstant=false,Constant=1.0000000,Expression=none,activeComponent=0,ConstantR=0.0000000,ConstantG=0.0000000,ConstantB=0.0000000,ConstantA=0.0000000,Mask=0,MaskR=0,MaskG=0,MaskB=0,MaskA=0)
    OpacityMaskClipValue=0.5000000
    TwoSidedLightingColor=(UseConstant=false,Constant=(R=255,G=255,B=255,A=0),Expression=none,activeComponent=0,ConstantR=0.0000000,ConstantG=0.0000000,ConstantB=0.0000000,ConstantA=0.0000000,Mask=0,MaskR=0,MaskG=0,MaskB=0,MaskA=0)
}