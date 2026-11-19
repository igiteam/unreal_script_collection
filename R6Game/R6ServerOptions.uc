class R6ServerOptions extends Object
    native
    config(ServerOptions);

var config string m_fstrSessionName;
var config string m_fstrSessionPassword;
var config int m_iChatDisplayDuration;
var config string m_fstrLANName;
var config string m_fstrAgoraSessionVersion;
var config string m_fstrGamePassword;
var config string m_fstrJoinPassword;
var config R6EngineEnums.EGameMode m_eGameMode;
var config R6EngineEnums.EGameTypeMP m_eGameType;
var config R6EngineEnums.EDedicatedServer m_eDedicatedServer;
var config R6EngineEnums.ELanguage m_eLanguage;
var config R6EngineEnums.EAllowVoiceMode m_eAllowVoice;
var config R6EngineEnums.EGameDifficulty m_eDifficulty;
var config R6EngineEnums.EGameHostileDensity m_eHostileDensity;
var config int m_iMap;
var config int m_iSelectedMaps[20];
var config int m_iTimeBetweenRound;
var config int m_iRoundCount;
var config int m_iRoundDuration;
var config int m_iMaxPlayers;
var config int m_iPrivateSlots;
var config int m_iMaxLives;
var config bool m_bRespawn;
var config bool m_bTeamRespawn;
var config bool m_bBalanceTeam;
var config bool m_bFriendlyFire;
var config bool m_bPrivateServer;
var config bool m_bLockTeams;
var config bool m_bPunishTeamKiller;
var config bool m_bAllowJoinInProgress;
var config bool m_bPunkBusterSv;
var config bool m_bPunkBusterCl;
var config int m_iAutoKickTeamKillers;
var config int m_iGamePointLimit;
var config int m_iConquestGamePointLimit;
var config int m_iLimitRespawns;
var config int m_iBriefingTimer;
var config int m_iRestrictedItems[5];

defaultproperties
{
    m_fstrSessionName="RS5 Server"
    m_iChatDisplayDuration=5
    m_fstrLANName="PLAYER1"
    m_eGameMode=1
    m_eGameType=1
    m_eDifficulty=1
    m_iMap=-1
    m_iSelectedMaps[0]=-1
    m_iSelectedMaps[1]=-1
    m_iSelectedMaps[2]=-1
    m_iSelectedMaps[3]=-1
    m_iSelectedMaps[4]=-1
    m_iSelectedMaps[5]=-1
    m_iSelectedMaps[6]=-1
    m_iSelectedMaps[7]=-1
    m_iSelectedMaps[8]=-1
    m_iSelectedMaps[9]=-1
    m_iSelectedMaps[10]=-1
    m_iSelectedMaps[11]=-1
    m_iSelectedMaps[12]=-1
    m_iSelectedMaps[13]=-1
    m_iSelectedMaps[14]=-1
    m_iSelectedMaps[15]=-1
    m_iSelectedMaps[16]=-1
    m_iSelectedMaps[17]=-1
    m_iSelectedMaps[18]=-1
    m_iSelectedMaps[19]=-1
    m_iTimeBetweenRound=180
    m_iRoundCount=3
    m_iRoundDuration=600
    m_iMaxPlayers=16
    m_iMaxLives=1
    m_bBalanceTeam=true
    m_bPunishTeamKiller=true
    m_bAllowJoinInProgress=true
    m_iAutoKickTeamKillers=5
    m_iConquestGamePointLimit=3000
    m_iBriefingTimer=5
    m_iRestrictedItems[0]=-1
    m_iRestrictedItems[1]=-1
    m_iRestrictedItems[2]=-1
    m_iRestrictedItems[3]=-1
    m_iRestrictedItems[4]=-1
}