class R6ConfigsManager extends R6Config
    native
    hidecategories(Object);

var() R6CameraConfig m_CameraConfig;
var() R6ControlsConfig m_ControlsConfig;
var() R6TakeCoverConfig m_TakeCoverConfig;
var() R6MiscConfig m_MiscConfig;
var() R6HealthConfig m_HealthConfig;
var() R6VisualConfig m_VisualConfig;
var() R6WeaponsConfig m_WeaponsConfig;
var() R6AccuracyConfig m_AccuracyConfig;
var() R6DamageConfig m_DamageConfig;
var() R6PlayerOptionsManager m_PlayerOptionsManager;
var() R6ImpactConfig m_ImpactConfig;
var() R6RapellingConfig m_RapellingConfig;
var() R6HandSignalsConfig m_HandSignalsConfig;
var() R6RainbowConfig m_RainbowConfig;
var() R6AIConfig m_AIConfig;
var() R6InteractLocationsConfig m_InteractLocationsConfig;
var() R6GadgetsConfig m_GadgetsConfig;
var() R6InteractLengthsConfig m_InteractLengthsConfig;
var() R6FPPWalkthroughConfig m_FPPConfig;
var() R6RadarConfig m_RadarConfig;
var() /*0x04000000-0x00000000*/ R6SoundPriorityConfig m_SoundPriorityConfig;
var() R6MassiveConfig m_MassiveConfig;
var R6PostProcessConfig m_PostProcessConfig;
var() R6PostProcessConfigCollection m_PostProcessConfigCollection;
var() R6DifficultyConfig m_DifficultyConfig;

defaultproperties
{
    m_szThumbnailTexture="KellerEditorMaterials.Keller"
    m_szDescription="Keller's configurations"
}