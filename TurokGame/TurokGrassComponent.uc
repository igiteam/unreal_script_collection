class TurokGrassComponent extends StaticMeshComponent
    native
    editinlinenew
    hidecategories(Object,AdvancedLighting,Collision,Physics,PrimitiveComponent,Rendering,StaticMeshComponent)
    autoexpandcategories(Collision,Rendering,Lighting);

enum StealthVisibilityPreset
{
    STEALTH_VISIBILITY_PRESET_Low,  // 0
    STEALTH_VISIBILITY_PRESET_Medium,// 1
    STEALTH_VISIBILITY_PRESET_High, // 2
    STEALTH_VISIBILITY_PRESET_Manual,// 3
    STEALTH_VISIBILITY_PRESET_MAX   // 4
};

struct native GrassFieldSettings
{
    var() float mFieldWidth;
    var() float mFieldLength;
    var int mRandSeed;
    var() float mBladeDensity;
    var() @NULL mBladeHeightMap;
    var() float mBladeLengthMax;
    var() float mBladeLengthMin;
    var() @NULL mBladePlacement;
    var() float mBladeWidthMax;
    var() float mLightingSampleRadius;
    var() float mLightingInShadowScale;
    var() float mLightingInLightScale;
    var() float mLightingNormalScale;
    var() float mMaxDistanceFromCamera;
    var() float mDitherDistance;
    var() @NULL mTextureMaterial;
    var() int mTextureUDivisions;
    var() int mTextureVDivisions;
    var() @NULL mPhysicsGravity;
    var() float mPhysicsDamping;
    var() float mPhysicsStiffness;

    structdefaultproperties
    {
        mFieldWidth=250.0000000
        mFieldLength=250.0000000
        mRandSeed=-1
        mBladeDensity=0.0030000
        mBladeHeightMap=none
        mBladeLengthMax=95.0000000
        mBladeLengthMin=75.0000000
        mBladePlacement=(BSP=true,Terrain=true,Static=false)
        mBladeWidthMax=20.0000000
        mLightingSampleRadius=1.0000000
        mLightingInShadowScale=0.0000000
        mLightingInLightScale=1.0000000
        mLightingNormalScale=1.0000000
        mMaxDistanceFromCamera=7500.0000000
        mDitherDistance=2500.0000000
        mTextureMaterial=none
        mTextureUDivisions=1
        mTextureVDivisions=1
        mPhysicsGravity=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        mPhysicsDamping=0.9000000
        mPhysicsStiffness=1000.0000000
    }
};

var() @NULL mSettings;
var float LOD_StartLOD;
var float LOD_EndLOD;
var float LOD_StartDist;
var float LOD_EndDist;
var int LOD_MinQuads;
var int LOD_MaxQuads;
var(Stealth) float mStealthFactor;
var(Stealth) byte mStealthVisibilityPreset;
var float mStealthPresets[3];
var private int mSerializeVersion;
var private bool sDisplayFoliage;
var private const bool sEnableLOD;
var private bool mbDoMaulOcclusion;
var private @NULL mGrassManager;

// Export UTurokGrassComponent::execExplosion(FFrame&, void* const)
native simulated function Explosion(@NULL Center, float Damage);

// Export UTurokGrassComponent::execDrawCollisionVolumes(FFrame&, void* const)
native final function DrawCollisionVolumes(@NULL HUD);

// Export UTurokGrassComponent::execIsGrassValidForStealth(FFrame&, void* const)
native function bool IsGrassValidForStealth(@NULL TestLocation);

// Export UTurokGrassComponent::execIsOcclusionPreventionActive(FFrame&, void* const)
native simulated function bool IsOcclusionPreventionActive();

// Export UTurokGrassComponent::execGetGrassLengthAt(FFrame&, void* const)
native simulated function bool GetGrassLengthAt(out float Length, @NULL Position);

// Export UTurokGrassComponent::execIsPointInGrass(FFrame&, void* const)
native simulated function bool IsPointInGrass(@NULL Point);

// Export UTurokGrassComponent::execIntersectRay(FFrame&, void* const)
native simulated function bool IntersectRay(out @NULL HitLocation, @NULL rayStart, @NULL rayDirection);

// Export UTurokGrassComponent::execGetNumBlades(FFrame&, void* const)
native function int GetNumBlades();

// Export UTurokGrassComponent::execGetMemory(FFrame&, void* const)
native function int GetMemory();

// Export UTurokGrassComponent::execGetBladesRendered(FFrame&, void* const)
native function int GetBladesRendered();

// Export UTurokGrassComponent::execGetBladesUpdated(FFrame&, void* const)
native function int GetBladesUpdated();

// Export UTurokGrassComponent::execGetActiveColliders(FFrame&, void* const)
native function int GetActiveColliders();

simulated function float GetStealthFactor()
{
    local float stealthFactor;

    // End:0x1E
    if(int(mStealthVisibilityPreset) == int(3))
    {
        stealthFactor = mStealthFactor;        
    }
    else
    {
        stealthFactor = mStealthPresets[int(mStealthVisibilityPreset)];
    }
    return stealthFactor;
    //return ReturnValue;    
}

simulated function EnableOcclusionPrevention()
{
    mbDoMaulOcclusion = true;
    //return;    
}

simulated function DisableOcclusionPrevention()
{
    mbDoMaulOcclusion = false;
    //return;    
}

defaultproperties
{
    mSettings=(mFieldWidth=250.0000000,mFieldLength=250.0000000,mRandSeed=-1,mBladeDensity=0.0030000,mBladeHeightMap=none,mBladeLengthMax=95.0000000,mBladeLengthMin=75.0000000,mBladePlacement=(BSP=true,Terrain=true,Static=false),mBladeWidthMax=20.0000000,mLightingSampleRadius=1.0000000,mLightingInShadowScale=0.0000000,mLightingInLightScale=1.0000000,mLightingNormalScale=1.0000000,mMaxDistanceFromCamera=7500.0000000,mDitherDistance=2500.0000000,mTextureMaterial=none,mTextureUDivisions=1,mTextureVDivisions=1,mPhysicsGravity=(X=0.0000000,Y=0.0000000,Z=0.0000000),mPhysicsDamping=0.9000000,mPhysicsStiffness=1000.0000000)
    LOD_StartLOD=100.0000000
    LOD_EndLOD=100.0000000
    LOD_StartDist=2500.0000000
    LOD_EndDist=7500.0000000
    LOD_MinQuads=1
    LOD_MaxQuads=10000
    mStealthFactor=0.2500000
    mStealthVisibilityPreset=1
    mStealthPresets[0]=0.1500000
    mStealthPresets[1]=0.2500000
    mStealthPresets[2]=0.3500000
    mSerializeVersion=-1
    sDisplayFoliage=true
    sEnableLOD=true
    bAcceptsDecals=false
    bAcceptsDecalsDuringGameplay=false
    bForceDirectLightMap=true
    bCastDynamicShadow=false
    LightingChannels=(bInitialized=true,Static=true)
}