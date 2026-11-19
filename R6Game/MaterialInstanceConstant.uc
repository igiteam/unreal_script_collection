class MaterialInstanceConstant extends MaterialInstance
    native
    collapsecategories
    hidecategories(Object);

struct VectorParameterValue
{
    var() name ParameterName;
    var() LinearColor ParameterValue;

    structdefaultproperties
    {
        ParameterName="None"
        ParameterValue=(R=0.0000000,G=0.0000000,B=0.0000000,A=0.0000000)
    }
};

struct ScalarParameterValue
{
    var() name ParameterName;
    var() float ParameterValue;

    structdefaultproperties
    {
        ParameterName="None"
        ParameterValue=0.0000000
    }
};

struct TextureParameterValue
{
    var() name ParameterName;
    var() Texture ParameterValue;

    structdefaultproperties
    {
        ParameterName="None"
        ParameterValue=none
    }
};

var() PhysicalMaterial PhysMaterial;
var() const MaterialInstance Parent;
var() bool UseOverrides;
var private native const bool ReentrantFlag;
var() const array<VectorParameterValue> VectorParameterValues;
var() const array<ScalarParameterValue> ScalarParameterValues;
var() const array<TextureParameterValue> TextureParameterValues;
var native const MaterialInstancePointer MaterialInstances[3];
var native const noexport Map_Mirror VectorValueMap;
var native const noexport Map_Mirror ScalarValueMap;
var native const noexport Map_Mirror TextureValueMap;

// Export UMaterialInstanceConstant::execSetParent(FFrame&, void* const)
native final function SetParent(MaterialInstance NewParent);

// Export UMaterialInstanceConstant::execSetVectorParameterValue(FFrame&, void* const)
native final function SetVectorParameterValue(name ParameterName, LinearColor Value);

// Export UMaterialInstanceConstant::execSetScalarParameterValue(FFrame&, void* const)
native final function SetScalarParameterValue(name ParameterName, float Value);

// Export UMaterialInstanceConstant::execSetTextureParameterValue(FFrame&, void* const)
native final function SetTextureParameterValue(name ParameterName, Texture Value);

// Export UMaterialInstanceConstant::execClearParameterValues(FFrame&, void* const)
native final function ClearParameterValues();

// Export UMaterialInstanceConstant::execPlay(FFrame&, void* const)
native final function Play(name ParamName);

// Export UMaterialInstanceConstant::execPause(FFrame&, void* const)
native final function Pause(name ParamName);

// Export UMaterialInstanceConstant::execStop(FFrame&, void* const)
native final function Stop(name ParamName);
