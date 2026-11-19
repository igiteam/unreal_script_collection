class MaterialInstance extends Object
    abstract
    native;

struct R6SoundSurface
{
    var() R6EngineEnums.ESoundSurfaceType m_eSurfaceType;
    var() R6EngineEnums.ESoundOccluderType m_eOccluderType;
    var R6EngineEnums.ESoundSurfaceType m_Padding[2];

    structdefaultproperties
    {
        m_eSurfaceType=9
        m_eOccluderType=0
        m_Padding[0]=0
        m_Padding[1]=0
    }
};

struct MaterialInstancePointer
{
    var native const Pointer P;
};

var(R6Params) /*0x40000000-0x00000000*/ R6MaterialGameParams m_gameParams;
var(R6Sound) /*0x04000000-0x00000000*/ array<R6SoundSurface> m_MaterialSoundInfo;
var(R6Sound) /*0x04000000-0x00000000*/ bool m_bStairsMaterial;

// Export UMaterialInstance::execGetMaterial(FFrame&, void* const)
native final function Material GetMaterial();

// Export UMaterialInstance::execGetPhysicalMaterial(FFrame&, void* const)
native final function PhysicalMaterial GetPhysicalMaterial();
