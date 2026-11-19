class ParticleSystem extends Object
    native
    hidecategories(Object);

enum EParticleSystemUpdateMode
{
    EPSUM_RealTime,                 // 0
    EPSUM_FixedTime,                // 1
    EPSUM_MAX                       // 2
};

var() ParticleSystem.EParticleSystemUpdateMode SystemUpdateMode;
var() float UpdateTime_FPS;
var float UpdateTime_Delta;
var() float WarmupTime;
var export editinline array<export editinline ParticleEmitter> Emitters;
var export editinline transient ParticleSystemComponent PreviewComponent;
var Rotator ThumbnailAngle;
var float ThumbnailDistance;
var() float ThumbnailWarmup;
var bool bLit;
var bool bUseFixedRelativeBoundingBox;
var bool bLitDynamic;
var(Performance) bool m_bSpawnWatchEnable;
var export InterpCurveEdSetup CurveEdSetup;
var int EditorLODSetting;
var deprecated int LODCount;
var deprecated int PreviewLODSetting;
var Box FixedRelativeBoundingBox;
var() float SecondsBeforeInactive;
var() name MulCoefName;
var(Performance) float m_fSpawnLocationThresold;
var(Performance) float m_fSpawnTimeThresold;
var Vector m_vLastSpawnLocation;
var float m_fLastSpawnTime;

// Export UParticleSystem::execSpawnAllowed(FFrame&, void* const)
native final function bool SpawnAllowed(Vector vLocation);

defaultproperties
{
    UpdateTime_FPS=60.0000000
    UpdateTime_Delta=1.0000000
    ThumbnailDistance=200.0000000
    ThumbnailWarmup=1.0000000
    bLit=true
    FixedRelativeBoundingBox=(Min=(X=0.0000000,Y=0.0000000,Z=0.0000000),Max=(X=0.0000000,Y=0.0000000,Z=-1.0000000),IsValid=None)
}