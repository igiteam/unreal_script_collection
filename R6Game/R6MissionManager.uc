class R6MissionManager extends Object
    native
    config(Engine);

var array<R6MissionConfig> m_arMissionConfigs;
var int m_iHighestMissionId;
var config string m_fstrMissionsDir;

defaultproperties
{
    m_fstrMissionsDir="..\\KellerGame\\Content\\"
}