class TurokGroundFoliageComponent extends StaticMeshComponent
    native
    editinlinenew
    hidecategories(Object,StaticMeshComponent)
    autoexpandcategories(Collision,Rendering,Lighting);

enum GFCHeightMapChannel
{
    GFCHMC_Red,                     // 0
    GFCHMC_Green,                   // 1
    GFCHMC_Blue,                    // 2
    GFCHMC_Alpha,                   // 3
    GFCHMC_MAX                      // 4
};

struct native GFCHeightMapProperties
{
    var() @NULL mTexture;
    var() byte mChannel;

    structdefaultproperties
    {
        mTexture=none
        mChannel=0
    }
};

struct native GFCPlacementTargets
{
    var() bool BSP;
    var() bool Terrain;
    var() bool Static;

    structdefaultproperties
    {
        BSP=true
        Terrain=true
        Static=false
    }
};

struct native GFCMaterialProperties
{
    var() @NULL mMaterial;
    var() int mNumBlades;
    var() float mBladeWidthMin;
    var() float mBladeWidthMax;
    var() float mBladeLengthMin;
    var() float mBladeLengthMax;
    var() float mTiltMinPitch;
    var() float mTiltMaxPitch;
    var() float mMaxDistanceFromCamera;
    var() float mDitherDistance;
    var() @NULL mHeightMap;
    var() int mTextureUDivisions;
    var() int mTextureVDivisions;
    var() bool mUniformTextureScaling;

    structdefaultproperties
    {
        mMaterial=none
        mNumBlades=100
        mBladeWidthMin=25.0000000
        mBladeWidthMax=45.0000000
        mBladeLengthMin=25.0000000
        mBladeLengthMax=45.0000000
        mTiltMinPitch=0.0000000
        mTiltMaxPitch=0.0000000
        mMaxDistanceFromCamera=7500.0000000
        mDitherDistance=2500.0000000
        mHeightMap=(mTexture=none,mChannel=0)
        mTextureUDivisions=1
        mTextureVDivisions=1
        mUniformTextureScaling=false
    }
};

var(Generation) float mWidth;
var(Generation) float mLength;
var(Generation) @NULL mMaterial;
var(Generation) int mNumBlades;
var(Generation) float mBladeWidthMin;
var(Generation) float mBladeWidthMax;
var(Generation) float mBladeLengthMin;
var(Generation) float mBladeLengthMax;
var(Generation) float mJitterMaxX;
var(Generation) float mJitterMaxY;
var(Generation) float mTiltMinPitch;
var(Generation) float mTiltMaxPitch;
var(Generation) float mMaxDistanceFromCamera;
var(Generation) float mDitherDistance;
var(Generation) @NULL mHeightMap;
var(Generation) int mTextureUDivisions;
var(Generation) int mTextureVDivisions;
var(Generation) @NULL mPlacement;
var(Generation) bool mUniformTextureScaling;
var bool sDisplayGroundFoliage;
var const bool sEnableGroundFoliageLOD;
var(Generation) int mRandSeed;
var(Generation) float mLightingSampleRadius;
var(Generation) float mLightingInShadowScale;
var(Generation) float mLightingInLightScale;
var(Generation) float mLightingNormalScale;
var @NULL mGrassData;
var int mSerializeVersion;
var(Generation_AdditionalMaterials) array mMaterials;
var float LOD_StartLOD;
var float LOD_EndLOD;
var float LOD_StartDist;
var float LOD_EndDist;
var int LOD_MinQuads;
var int LOD_MaxQuads;

defaultproperties
{
    mWidth=250.0000000
    mLength=250.0000000
    mNumBlades=100
    mBladeWidthMin=25.0000000
    mBladeWidthMax=45.0000000
    mBladeLengthMin=25.0000000
    mBladeLengthMax=45.0000000
    mJitterMaxX=20.0000000
    mJitterMaxY=20.0000000
    mMaxDistanceFromCamera=7500.0000000
    mDitherDistance=2500.0000000
    mTextureUDivisions=1
    mTextureVDivisions=1
    mPlacement=(BSP=true,Terrain=true,Static=false)
    sDisplayGroundFoliage=true
    sEnableGroundFoliageLOD=true
    mRandSeed=-1
    mLightingSampleRadius=1.0000000
    mLightingInLightScale=1.0000000
    mLightingNormalScale=1.0000000
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