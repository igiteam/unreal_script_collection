class R6MissionConfig extends Object
    native
    config(ServerOptions);

struct R6GameModeConfig
{
    var R6EngineEnums.EGameMode m_eGameMode;
    var config string m_szMissionType;
    var config int m_iMaxPlayers;
    var config int m_iMaxPlayersListenServer;
    var config int m_iRecommendedPlayers;
    var config int m_iMissionOrderId;

    structdefaultproperties
    {
        m_eGameMode=0
        m_szMissionType=""
        m_iMaxPlayers=0
        m_iMaxPlayersListenServer=0
        m_iRecommendedPlayers=0
        m_iMissionOrderId=0
    }
};

struct R6CheckpointSceneConfig
{
    var int m_iCheckPointId;
    var string m_strMapFile;
    var string m_strLocTitleId;
    var string m_strImageName;

    structdefaultproperties
    {
        m_iCheckPointId=0
        m_strMapFile=""
        m_strLocTitleId=""
        m_strImageName=""
    }
};

var config int m_iVersion;
var config int m_iID;
var config string m_fstrImage;
var config int m_iMaxPlayers;
var config int m_iMaxPlayersListenServer;
var config int m_iRecommendedPlayers;
var string m_fstrIniFile;
var string m_fstrFile;
var string m_fstrName;
var string m_fstrLocalizedName;
var string m_fstrLocalizedLocationName;
var string m_fstrDescription;
var string m_fstrDescriptionDedicated;
var string m_fstrLocalizeDescription;
var bool m_bCanBeLaunchOnXenon;
var bool m_bBinarizeSound;
var R6EngineEnums.EGameMode m_eSortByGameMode;
var config R6EngineEnums.EAward m_eAchievement;
var config int m_iAchievementID;
var config int m_iStatTime;
var config int m_iStatKills;
var config int m_iStatDeaths;
var config int m_iStatTimePart;
var config int m_iStatTimeTotal;
var config int m_iStatScorePart;
var config int m_iStatScoreTotal;
var config int m_iNumberOfParts;
var config int m_iCurrentPart;
var config int m_iCoopHuntID;
var config int m_iCoopStoryID;
var config int m_iFavMapLeaderboardID;
var config int m_iFavMapKillsID;
var config int m_iFavMapDeathsID;
var config int m_iFavMapTimeID;
var array<R6GameModeConfig> m_arGameModeConfigs;
var array<R6CheckpointSceneConfig> m_arCheckpointSceneConfigs;
