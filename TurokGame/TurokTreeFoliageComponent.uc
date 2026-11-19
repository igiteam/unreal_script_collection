class TurokTreeFoliageComponent extends StaticMeshComponent
    native
    editinlinenew
    hidecategories(Object,StaticMeshComponent)
    autoexpandcategories(Collision,Rendering,Lighting);

struct native TFCMaterialProperties
{
    var() @NULL mMaterial;
    var() int mNumLeaves;
    var() float mLeafWidthMin;
    var() float mLeafWidthMax;
    var() float mLeafLengthMin;
    var() float mLeafLengthMax;
    var() float mLeafRotationMin;
    var() float mLeafRotationMax;
    var() float mMaxDistanceFromCamera;
    var() int mTextureUDivisions;
    var() int mTextureVDivisions;
    var() bool mUniformTextureScaling;

    structdefaultproperties
    {
        mMaterial=none
        mNumLeaves=50
        mLeafWidthMin=10.0000000
        mLeafWidthMax=10.0000000
        mLeafLengthMin=10.0000000
        mLeafLengthMax=10.0000000
        mLeafRotationMin=0.0000000
        mLeafRotationMax=360.0000000
        mMaxDistanceFromCamera=7500.0000000
        mTextureUDivisions=1
        mTextureVDivisions=1
        mUniformTextureScaling=false
    }
};

var(Generation) @NULL mMaterial;
var(Generation) int mNumLeaves;
var(Generation) float mLeafWidthMin;
var(Generation) float mLeafWidthMax;
var(Generation) float mLeafLengthMin;
var(Generation) float mLeafLengthMax;
var(Generation) float mXLength;
var(Generation) float mYLength;
var(Generation) float mZLength;
var(Generation) float mLeafRotationMin;
var(Generation) float mLeafRotationMax;
var(Generation) int mTextureUDivisions;
var(Generation) int mTextureVDivisions;
var(Generation) bool mUniformTextureScaling;
var bool LOD_EnableRTSort;
var bool sDisplayTreeFoliage;
var const bool sEnableTreeFoliageLOD;
var(Generation) float mMaxDistanceFromCamera;
var(Generation) int mRandSeed;
var @NULL mLeafData;
var int mSerializeVersion;
var float LOD_StartLOD;
var float LOD_EndLOD;
var float LOD_StartDist;
var float LOD_EndDist;
var int LOD_MinQuads;
var int LOD_MaxQuads;
var(Generation_AdditionalMaterials) array mMaterials;

defaultproperties
{
    mNumLeaves=50
    mLeafWidthMin=10.0000000
    mLeafWidthMax=10.0000000
    mLeafLengthMin=10.0000000
    mLeafLengthMax=10.0000000
    mXLength=50.0000000
    mYLength=50.0000000
    mZLength=50.0000000
    mLeafRotationMax=360.0000000
    mTextureUDivisions=1
    mTextureVDivisions=1
    sDisplayTreeFoliage=true
    sEnableTreeFoliageLOD=true
    mMaxDistanceFromCamera=7500.0000000
    mRandSeed=-1
    mSerializeVersion=-1
    LOD_StartLOD=100.0000000
    LOD_EndLOD=100.0000000
    LOD_StartDist=2500.0000000
    LOD_EndDist=7500.0000000
    LOD_MinQuads=1
    LOD_MaxQuads=10000
    bAcceptsDecals=false
    bAcceptsDecalsDuringGameplay=false
    bForceDirectLightMap=true
    bCastDynamicShadow=false
    LightingChannels=(bInitialized=true,Static=true)
}