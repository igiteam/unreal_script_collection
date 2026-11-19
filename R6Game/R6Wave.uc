class R6Wave extends R6InfoPoint
    native
    hidecategories(lighting,Object,Actor,Advanced,Attachment,Collision,Display,Fire,Heat,CubemapSample,Reticule,Region,R6Sound,R6SoundPropagation);

enum R6WaveTriggerConditionStart
{
    WTCS_Scripted,                  // 0
    WTCS_RemainingInTeam,           // 1
    WTCS_MAX                        // 2
};

enum R6WaveTriggerConditionBackup
{
    WTCB_Scripted,                  // 0
    WTCB_RemainingInWave,           // 1
    WTCB_MAX                        // 2
};

var R6TeamManager m_pTeamManager;
var array<R6WavePoint> m_aWavePoints;
var array<R6ActionSpot> m_aSpotMember;
var array<string> m_aExternalSpotMember;
var bool m_bUsed;
var(WavePoint) int m_iMinTerrorists;
var(WavePoint) int m_iMaxTerrorists;
var(WavePoint) int m_iMinToSpawn;
var(WavePoint) int m_iMaxToSpawn;
var(WavePoint) int m_iMaxToTriggerSpawn;
var(WavePoint) int m_iMaxToTriggerSpawnForStart;
var(WavePoint) R6Wave.R6WaveTriggerConditionStart m_eTriggerConditionForStart;
var(WavePoint) R6Wave.R6WaveTriggerConditionBackup m_eTriggerConditionForBackup;
var int m_iNbLeftToSpawn;
var int m_iNbLeftToTriggerSpawn;
var int m_iNbSpawned;
var R6AreaOfOperation m_pAreaOfOperation;
var array<R6Pawn> m_aSpawnedMembers;

// Export UR6Wave::execStopWave(FFrame&, void* const)
native final function StopWave();

defaultproperties
{
    m_eTriggerConditionForBackup=1
    // Reference: SpriteComponent'Default__R6Wave.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Engine.Default__R6InfoPoint.Sprite'
    begin object name="Sprite"
        Sprite=Texture2D'AIIcons.Wave_Pic'
    end object
    Components[0]=Sprite
    SupportedEvents=/* Array type was not detected. */
}