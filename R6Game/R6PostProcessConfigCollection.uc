class R6PostProcessConfigCollection extends R6Config
    native
    hidecategories(Object);

var(EditorPreview) R6PostProcessParam m_EditorPreview;
var(Health) R6PostProcessConfig m_HealthFull;
var(Health) R6PostProcessConfig m_HealthWounded;
var(Health) R6PostProcessConfig m_HealthCritical;
var(Health) R6PostProcessConfig m_HealthIncapacitated;
var(Health) R6PostProcessConfig m_HealthDead;
var(Hit) R6PostProcessParam m_Hit;
var(SnakeCam) R6PostProcessParam m_SnakeCam;
var(SnakeCam) R6PostProcessParam m_SnakeCamHeat;
var(SnakeCam) R6PostProcessParam m_SnakeCamNight;
var(Fog) float m_fFogInterpSpeed;
