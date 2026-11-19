class Engine extends Subsystem
    abstract
    transient
    native
    config(Engine);

enum EType
{
    TYPE_NONE,                      // 0
    TYPE_INT,                       // 1
    TYPE_FLOAT,                     // 2
    TYPE_MAX                        // 3
};

enum ETransitionType
{
    TT_None,                        // 0
    TT_Paused,                      // 1
    TT_Loading,                     // 2
    TT_Saving,                      // 3
    TT_Connecting,                  // 4
    TT_Precaching,                  // 5
    TT_MAX                          // 6
};

struct TEditableProperty
{
    structcpptext
    {


        void Clean()
        {
           m_eType = TYPE_NONE;
           m_pData = NULL;
           m_pObject = NULL;
           m_pProperty = NULL;
        }

    
    }

    var Engine.EType m_eType;
    var native Pointer m_pData;
    var Object m_pObject;
    var Property m_pProperty;

    structdefaultproperties
    {
        m_eType=0
        m_pObject=none
        m_pProperty=none
    }
};

var Font TinyFont;
var Font SmallFont;
var Font MediumFont;
var Font LargeFont;
var class<Console> ConsoleClass;
var globalconfig string ConsoleClassName;
var class<GameViewportClient> GameViewportClientClass;
var globalconfig string GameViewportClientClassName;
var Texture2D DefaultTexture;
var TextureCube DefaultCubemap0;
var TextureCube DefaultCubemap1;
var class<LocalPlayer> LocalPlayerClass;
var config string LocalPlayerClassName;
var Material DefaultMaterial;
var globalconfig string DefaultMaterialName;
var Material WireframeMaterial;
var globalconfig string WireframeMaterialName;
var Material LightingOnlyMaterial;
var globalconfig string LightingOnlyMaterialName;
var Material SolidColorMaterial;
var globalconfig string SolidColorMaterialName;
var Material EmissiveTexturedMaterial;
var globalconfig string EmissiveTexturedMaterialName;
var Material ColoredNodeMaterial;
var globalconfig string ColoredNodeMaterialName;
var Material GeomMaterial;
var globalconfig string GeomMaterialName;
var Material TickMaterial;
var globalconfig string TickMaterialName;
var Material CrossMaterial;
var globalconfig string CrossMaterialName;
var Material MissingCollisionMaterial;
var globalconfig string MissingCollisionMaterialName;
var Material PerformanceColorationMaterialBest;
var globalconfig string PerformanceColorationMaterialBestName;
var Material PerformanceColorationMaterialMedium;
var globalconfig string PerformanceColorationMaterialMediumName;
var Material PerformanceColorationMaterialWorst;
var globalconfig string PerformanceColorationMaterialWorstName;
var globalconfig array<config Color> LightComplexityColors;
var Material EditorBrushMaterial;
var globalconfig string EditorBrushMaterialName;
var PhysicalMaterial DefaultPhysMaterial;
var globalconfig string DefaultPhysMaterialName;
var(Settings) config float TimeBetweenPurgingPendingKillObjects;
var const Client Client;
var const Client ClientDedicated;
var array<LocalPlayer> GamePlayers;
var const GameViewportClient GameViewport;
var array<string> DeferredCommands;
var int TickCycles;
var int GameCycles;
var int ClientCycles;
var(Settings) config bool UseSound;
var bool bPrecachingEnded;
var(Settings) config bool EnableCheat;
var(Settings) config bool UseStreaming;
var(Settings) config bool bStaticDecalsEnabled;
var(Settings) config bool bDynamicDecalsEnabled;
var(Settings) config int DeclareOutOfMemory;
var(Settings) config int StreamingLimitMemory;
var(Settings) config int MaxStreamedInMips;
var(Settings) config int MinStreamedInMips;
var const DebugManager DebugManager;
var native const transient Pointer m_StreamingDebugMaterials[8];
var(Colors) Color C_WorldBox;
var(Colors) Color C_BrushWire;
var(Colors) Color C_AddWire;
var(Colors) Color C_SubtractWire;
var(Colors) Color C_SemiSolidWire;
var(Colors) Color C_NonSolidWire;
var(Colors) Color C_WireBackground;
var(Colors) Color C_ScaleBoxHi;
var(Colors) Color C_OrthoBackground;
var(Colors) Color C_Volume;
var(Settings) float StreamingDistanceFactor;
var const config string ScoutClassName;
var Engine.ETransitionType TransitionType;
var string TransitionDescription;
var TEditableProperty m_EditProperty;
var int m_eCurrentMenu;
var transient bool m_bDrawBrushDimensions;
var Texture2D m_pVideoCamTex[4];
var int m_iCurrentVideoCamTex;
var Texture2D m_pSnapshotTex;
var float ChatFadeTime;

// Export UEngine::execGetCurrentWorldInfo(FFrame&, void* const)
native static final function WorldInfo GetCurrentWorldInfo();

// Export UEngine::execGetPostProcessManager(FFrame&, void* const)
native final function PostProcessManager GetPostProcessManager();

// Export UEngine::execGetR6PostProcessManager(FFrame&, void* const)
native final function R6PostProcessManager GetR6PostProcessManager();

defaultproperties
{
    TinyFont=Font'EngineFonts.TinyFont'
    SmallFont=Font'EngineFonts.SmallFont'
    MediumFont=Font'EngineFonts.MediumFont'
    LargeFont=Font'EngineFonts.LargeFont'
    ConsoleClassName="R6Game.R6Console"
    GameViewportClientClassName="Engine.GameViewportClient"
    DefaultTexture=Texture2D'KellerResource.DefaultTexture'
    DefaultCubemap0=TextureCube'KellerResource.DefaultCubemap0'
    DefaultCubemap1=TextureCube'KellerResource.DefaultCubemap1'
    LocalPlayerClassName="Engine.LocalPlayer"
    DefaultMaterialName="EngineMaterials.DefaultMaterial"
    WireframeMaterialName="EngineMaterials.WireframeMaterial"
    LightingOnlyMaterialName="EngineMaterials.LightingOnlyMaterial"
    SolidColorMaterialName="EngineMaterials.SolidColorMaterial"
    EmissiveTexturedMaterialName="EngineMaterials.EmissiveTexturedMaterial"
    ColoredNodeMaterialName="EngineMaterials.ColoredNodeMaterial"
    GeomMaterialName="EngineMaterials.GeomMaterial"
    TickMaterialName="EditorMaterials.Tick_Mat"
    CrossMaterialName="EditorMaterials.Cross_Mat"
    MissingCollisionMaterialName="EngineMaterials.MissingCollisionMaterial"
    PerformanceColorationMaterialBestName="EngineMaterials.PerformanceColorationMaterialBest"
    PerformanceColorationMaterialMediumName="EngineMaterials.PerformanceColorationMaterialMedium"
    PerformanceColorationMaterialWorstName="EngineMaterials.PerformanceColorationMaterialWorst"
    LightComplexityColors[0]=none
    LightComplexityColors[1]=none
    LightComplexityColors[2]=none
    LightComplexityColors[3]=none
    LightComplexityColors[4]=none
    LightComplexityColors[5]=none
    EditorBrushMaterialName="EngineMaterials.EditorBrushMaterial"
    DefaultPhysMaterialName="EngineMaterials.DefaultPhysicalMaterial"
    TimeBetweenPurgingPendingKillObjects=60.0000000
    UseSound=true
    bStaticDecalsEnabled=true
    bDynamicDecalsEnabled=true
    MaxStreamedInMips=14
    MinStreamedInMips=6
    C_WorldBox=(R=0,G=0,B=107,A=255)
    C_BrushWire=(R=192,G=0,B=0,A=255)
    C_AddWire=(R=127,G=127,B=255,A=255)
    C_SubtractWire=(R=255,G=192,B=63,A=255)
    C_SemiSolidWire=(R=127,G=255,B=0,A=255)
    C_NonSolidWire=(R=63,G=192,B=32,A=255)
    C_WireBackground=(R=0,G=0,B=0,A=255)
    C_ScaleBoxHi=(R=223,G=149,B=157,A=255)
    C_OrthoBackground=(R=163,G=163,B=163,A=255)
    C_Volume=(R=255,G=196,B=255,A=255)
    ScoutClassName="Engine.Scout"
    ChatFadeTime=1.0000000
}