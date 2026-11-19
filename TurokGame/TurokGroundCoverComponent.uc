class TurokGroundCoverComponent extends StaticMeshComponent
    native
    editinlinenew
    hidecategories(Object,StaticMeshComponent)
    autoexpandcategories(Collision,Rendering,Lighting);

enum GCCHeightMapChannel
{
    GCCHMC_Red,                     // 0
    GCCHMC_Green,                   // 1
    GCCHMC_Blue,                    // 2
    GCCHMC_Alpha,                   // 3
    GCCHMC_MAX                      // 4
};

struct native GCCHeightMapProperties
{
    var() @NULL mTexture;
    var() byte mChannel;

    structdefaultproperties
    {
        mTexture=none
        mChannel=0
    }
};

struct native GCCPlacementTargets
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

struct native GCCMaterialProperties
{
    var() @NULL mMaterial;
    var() int mNumBlades;
    var() float mBladeWidthMin;
    var() float mBladeWidthMax;
    var() float mBladeLengthMin;
    var() float mBladeLengthMax;
    var() float mBladeHeightMin;
    var() float mBladeHeightMax;
    var() float mBladeRotationMin;
    var() float mBladeRotationMax;
    var() float mBladeTiltMin;
    var() float mBladeTiltMax;
    var() float mMaxDistanceFromCamera;
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
        mBladeHeightMin=25.0000000
        mBladeHeightMax=45.0000000
        mBladeRotationMin=0.0000000
        mBladeRotationMax=360.0000000
        mBladeTiltMin=0.0000000
        mBladeTiltMax=0.0000000
        mMaxDistanceFromCamera=7500.0000000
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
var(Generation) float mBladeHeightMin;
var(Generation) float mBladeHeightMax;
var(Generation) float mBladeRotationMin;
var(Generation) float mBladeRotationMax;
var(Generation) float mBladeTiltMin;
var(Generation) float mBladeTiltMax;
var(Generation) float mJitterMaxX;
var(Generation) float mJitterMaxY;
var(Generation) float mMaxDistanceFromCamera;
var(Generation) @NULL mHeightMap;
var(Generation) int mTextureUDivisions;
var(Generation) int mTextureVDivisions;
var(Generation) @NULL mPlacement;
var(Generation) bool mAlignToSurface;
var(Generation) bool mUniformTextureScaling;
var bool sDisplayGroundCover;
var const bool sEnableGroundCoverLOD;
var(Generation) int mRandSeed;
var @NULL mCoverData;
var int mSerializeVersion;
var(Generation_AdditionalMaterials) array mMaterials;

defaultproperties
{
    mWidth=250.0000000
    mLength=250.0000000
    mNumBlades=100
    mBladeWidthMin=25.0000000
    mBladeWidthMax=45.0000000
    mBladeLengthMin=25.0000000
    mBladeLengthMax=45.0000000
    mBladeHeightMin=25.0000000
    mBladeHeightMax=45.0000000
    mBladeRotationMax=360.0000000
    mJitterMaxX=20.0000000
    mJitterMaxY=20.0000000
    mMaxDistanceFromCamera=7500.0000000
    mTextureUDivisions=1
    mTextureVDivisions=1
    mPlacement=(BSP=true,Terrain=true,Static=false)
    mAlignToSurface=true
    sDisplayGroundCover=true
    sEnableGroundCoverLOD=true
    mRandSeed=-1
    mSerializeVersion=-1
    bAcceptsDecals=false
    bAcceptsDecalsDuringGameplay=false
    bForceDirectLightMap=true
    bCastDynamicShadow=false
    LightingChannels=(bInitialized=true,Static=true)
}