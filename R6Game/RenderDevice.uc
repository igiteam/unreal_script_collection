class RenderDevice extends Subsystem
    abstract
    transient
    native
    config(Engine);

enum EMaterialPrecachingType
{
    EMPT_NoStatic,                  // 0
    EMPT_WithStatic,                // 1
    EMPT_Lightbeam,                 // 2
    EMPT_LightFunction,             // 3
    EMPT_Projector,                 // 4
    EMPT_MAX                        // 5
};

struct TextureLODGroup
{
    var int MinLODSize;
    var int MaxLODSize;
    var int LODBias;
    var bool bShouldAlwaysStream;
    var bool bInitialized;

    structdefaultproperties
    {
        MinLODSize=0
        MaxLODSize=0
        LODBias=0
        bShouldAlwaysStream=false
        bInitialized=false
    }
};

var config float MeshLODRange;
var config int UserMaxTextureSize;
var config int UserMinMipSize;
var int DeviceMaxTextureSize;
var config bool bForceCPUSkinning;
var config bool bUsePostProcessEffects;
var config bool bUseTextureLOD;
var bool m_bDrawDebug;
var bool m_bFreezeUpdateViewport;
var config array<config TextureLODGroup> TextureLODGroups;
var const PostProcessManager PostProcessManager;
var int m_iMovableInteractionStartIndex;
var float m_fVisionParameter1;
var float m_fVisionParameter2;
var float m_fGammaStep;

defaultproperties
{
    MeshLODRange=2000.0000000
    UserMaxTextureSize=4096
    bUsePostProcessEffects=true
    bUseTextureLOD=true
    m_fGammaStep=0.2500000
}