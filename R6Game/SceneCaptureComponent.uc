class SceneCaptureComponent extends ActorComponent
    abstract
    native
    hidecategories(Object);

enum ESceneCaptureViewMode
{
    SceneCapView_Lit,               // 0
    SceneCapView_Unlit,             // 1
    SceneCapView_NightVision,       // 2
    SceneCapView_HeatVision,        // 3
    SceneCapView_Wire,              // 4
    SceneCapView_MAX                // 5
};

var(Capture) bool bEnablePostProcess;
var(Capture) bool bEnableFog;
var(Capture) bool m_bOnlyRainbows;
var(Capture) Color ClearColor;
var(Capture) array<StaticMeshActor> m_ForcedShowSMActors;
var(Capture) array<DynamicSMActor> m_ForcedShowDSMActors;
var(Capture) SceneCaptureComponent.ESceneCaptureViewMode ViewMode;
var(Capture) int SceneLOD;
var(Capture) float FrameRate;
var native const transient Pointer Probe;
var const transient float TimeSinceLastFrame;
