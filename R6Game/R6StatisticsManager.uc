class R6StatisticsManager extends Object
    native;

struct WeaponStatistics
{
    var name m_WeaponName;
    var int m_iKills;
    var int m_iDeaths;
    var float m_fTime;

    structdefaultproperties
    {
        m_WeaponName="None"
        m_iKills=0
        m_iDeaths=0
        m_fTime=0.0000000
    }
};

struct GeneralStats
{
    var int m_iShots;
    var int m_iHits;
    var int m_iHeadShots;
    var int m_iKills;
    var int m_iDeaths;
    var int m_iKillingStreak;
    var int m_iDeathStreak;
    var float m_fTimePlayed;
    var int m_iBriefcases;
    var int m_iCanisters;
    var int m_iHostages;
    var int m_iBombs;
    var int m_iCoopScoreTotal;
    var int m_iCoopTimeTotal;
    var int m_iVIPs;
    var int m_iMRIs;

    structdefaultproperties
    {
        m_iShots=0
        m_iHits=0
        m_iHeadShots=0
        m_iKills=0
        m_iDeaths=0
        m_iKillingStreak=0
        m_iDeathStreak=0
        m_fTimePlayed=0.0000000
        m_iBriefcases=0
        m_iCanisters=0
        m_iHostages=0
        m_iBombs=0
        m_iCoopScoreTotal=0
        m_iCoopTimeTotal=0
        m_iVIPs=0
        m_iMRIs=0
    }
};

struct TrueSkillStats
{
    var int m_iRelativeScore;
    var int m_iTeam;

    structdefaultproperties
    {
        m_iRelativeScore=0
        m_iTeam=0
    }
};

struct CoopStats
{
    var int m_iTerroristsKilled;
    var int m_iCiviliansWounded;
    var int m_iCiviliansKilled;

    structdefaultproperties
    {
        m_iTerroristsKilled=0
        m_iCiviliansWounded=0
        m_iCiviliansKilled=0
    }
};

struct CoopScore
{
    var int m_iScoreTerroKilled;
    var int m_iScoreCiviliansWounded;
    var int m_iScoreCiviliansKilled;
    var int m_iScoreTimePlayed;
    var int m_iScoreDifficulty;
    var int m_iScoreTotalScore;

    structdefaultproperties
    {
        m_iScoreTerroKilled=0
        m_iScoreCiviliansWounded=0
        m_iScoreCiviliansKilled=0
        m_iScoreTimePlayed=0
        m_iScoreDifficulty=0
        m_iScoreTotalScore=0
    }
};

struct PlayerStats
{
    var int m_iStatID;
    var string m_strPlayerName;
    var string m_strXUID;
    var GeneralStats m_GeneralStats;
    var TrueSkillStats m_TrueSkillStats;
    var CoopStats m_CoopStats;
    var int m_iTempKillingStreak;
    var int m_iTempDeathStreak;
    var array<WeaponStatistics> m_aWeapons;
    var int m_iCurrentWeapon;
    var bool m_bRemoved;

    structdefaultproperties
    {
        m_iStatID=-1
        m_strPlayerName=""
        m_strXUID=""
        m_GeneralStats=(m_iShots=0,m_iHits=0,m_iHeadShots=0,m_iKills=0,m_iDeaths=0,m_iKillingStreak=0,m_iDeathStreak=0,m_fTimePlayed=0.0000000,m_iBriefcases=0,m_iCanisters=0,m_iHostages=0,m_iBombs=0,m_iCoopScoreTotal=0,m_iCoopTimeTotal=0,m_iVIPs=0,m_iMRIs=0)
        m_TrueSkillStats=(m_iRelativeScore=0,m_iTeam=0)
        m_CoopStats=(m_iTerroristsKilled=0,m_iCiviliansWounded=0,m_iCiviliansKilled=0)
        m_iTempKillingStreak=0
        m_iTempDeathStreak=0
        m_aWeapons=none
        m_iCurrentWeapon=-1
        m_bRemoved=false
    }
};

var array<PlayerStats> m_aPlayers;
var GeneralStats m_LocalPlayerStats;
var bool m_bRoundInProgress;

// Export UR6StatisticsManager::execIncrementShots(FFrame&, void* const)
native function IncrementShots(int iPlayerID);

// Export UR6StatisticsManager::execIncrementHits(FFrame&, void* const)
native function IncrementHits(int iPlayerID);

// Export UR6StatisticsManager::execIncrementHeadShots(FFrame&, void* const)
native function IncrementHeadShots(int iPlayerID);

// Export UR6StatisticsManager::execIncrementKills(FFrame&, void* const)
native function IncrementKills(int iPlayerID);

// Export UR6StatisticsManager::execIncrementDeaths(FFrame&, void* const)
native function IncrementDeaths(int iPlayerID);

// Export UR6StatisticsManager::execIncrementBriefcases(FFrame&, void* const)
native function IncrementBriefcases(int iPlayerID);

// Export UR6StatisticsManager::execIncrementBombs(FFrame&, void* const)
native function IncrementBombs(int iPlayerID);

// Export UR6StatisticsManager::execIncrementCanisters(FFrame&, void* const)
native function IncrementCanisters(int iPlayerID);

// Export UR6StatisticsManager::execIncrementHostages(FFrame&, void* const)
native function IncrementHostages(int iPlayerID);

// Export UR6StatisticsManager::execIncrementKillingStreak(FFrame&, void* const)
native function IncrementKillingStreak(int iPlayerID);

// Export UR6StatisticsManager::execIncrementDeathStreak(FFrame&, void* const)
native function IncrementDeathStreak(int iPlayerID);

// Export UR6StatisticsManager::execIncrementTerroristsKilled(FFrame&, void* const)
native function IncrementTerroristsKilled(int iPlayerID);

// Export UR6StatisticsManager::execIncrementCiviliansWounded(FFrame&, void* const)
native function IncrementCiviliansWounded(int iPlayerID);

// Export UR6StatisticsManager::execIncrementCiviliansKilled(FFrame&, void* const)
native function IncrementCiviliansKilled(int iPlayerID);

// Export UR6StatisticsManager::execIncrementVIPSKilled(FFrame&, void* const)
native function IncrementVIPSKilled(int iPlayerID);

// Export UR6StatisticsManager::execIncrementMRICaptured(FFrame&, void* const)
native function IncrementMRICaptured(int iPlayerID);

// Export UR6StatisticsManager::execSetTrueSkill(FFrame&, void* const)
native function SetTrueSkill(int iPlayerID, int iRelativeScore, int iTeam);

// Export UR6StatisticsManager::execSetCoopScore(FFrame&, void* const)
native function SetCoopScore(int iPlayerID, int iScoreTotal, int iTimeTotal);

// Export UR6StatisticsManager::execDoesPlayerExist(FFrame&, void* const)
native function bool DoesPlayerExist(string strXUID);

// Export UR6StatisticsManager::execAddPlayer(FFrame&, void* const)
native function int AddPlayer(string strXUID, string strPlayerName);

// Export UR6StatisticsManager::execRemovePlayer(FFrame&, void* const)
native function RemovePlayer(int iPlayerID);

// Export UR6StatisticsManager::execIsRemovedPlayer(FFrame&, void* const)
native function bool IsRemovedPlayer(int iPlayerID);

// Export UR6StatisticsManager::execDeleteAllPlayers(FFrame&, void* const)
native function DeleteAllPlayers();

// Export UR6StatisticsManager::execChangedWeapon(FFrame&, void* const)
native function ChangedWeapon(int iPlayerID, Weapon NewWeapon);

// Export UR6StatisticsManager::execEndDeathStreak(FFrame&, void* const)
native function EndDeathStreak(int iPlayerID);

// Export UR6StatisticsManager::execEndKillingStreak(FFrame&, void* const)
native function EndKillingStreak(int iPlayerID);

// Export UR6StatisticsManager::execReceivedPlayerStatistics(FFrame&, void* const)
native function ReceivedPlayerStatistics(string strName, string strXUID, GeneralStats stStats, bool bLocalPlayer);

// Export UR6StatisticsManager::execReceivedTrueSkillStatistics(FFrame&, void* const)
native function ReceivedTrueSkillStatistics(string strXUID, TrueSkillStats stStats);

// Export UR6StatisticsManager::execReceivedWeaponStatistics(FFrame&, void* const)
native function ReceivedWeaponStatistics(string strXUID, WeaponStatistics stWeaponStats);

// Export UR6StatisticsManager::execReceivedPecRank(FFrame&, void* const)
native function ReceivedPecRank(string strXUID, int iPecRank, int iDay, int iMonth, int iYear);

// Export UR6StatisticsManager::execPrintStats(FFrame&, void* const)
native function PrintStats(string strName, string strXUID, GeneralStats stStats);

// Export UR6StatisticsManager::execPrintWeaponStats(FFrame&, void* const)
native function PrintWeaponStats(WeaponStatistics stStats);

// Export UR6StatisticsManager::execPrintCoopStats(FFrame&, void* const)
native function PrintCoopStats(CoopStats stStats);

// Export UR6StatisticsManager::execGetPlayerStats(FFrame&, void* const)
native function GetPlayerStats(int iPlayerID, out GeneralStats stGeneralStats);

// Export UR6StatisticsManager::execGetTrueSkillStats(FFrame&, void* const)
native function GetTrueSkillStats(int iPlayerID, out TrueSkillStats stTrueSkillStats);

// Export UR6StatisticsManager::execGetCoopStats(FFrame&, void* const)
native function GetCoopStats(int iPlayerID, out CoopStats stCoopStats);

// Export UR6StatisticsManager::execGetNumberOfWeaponStats(FFrame&, void* const)
native function int GetNumberOfWeaponStats(int iPlayerID);

// Export UR6StatisticsManager::execGetWeaponStats(FFrame&, void* const)
native function GetWeaponStats(int iPlayerID, int iWeapon, out WeaponStatistics stWeaponStatistics);

// Export UR6StatisticsManager::execGetRemovedPlayers(FFrame&, void* const)
native function GetRemovedPlayers(out array<PlayerStats> aPlayers);

// Export UR6StatisticsManager::execStartRound(FFrame&, void* const)
native function StartRound();

// Export UR6StatisticsManager::execEndRound(FFrame&, void* const)
native function EndRound();

// Export UR6StatisticsManager::execFetchPlayersCoopStats(FFrame&, void* const)
native function FetchPlayersCoopStats(string strXUID);

// Export UR6StatisticsManager::execRemovePlayersCoopStats(FFrame&, void* const)
native function RemovePlayersCoopStats(string strXUID);

// Export UR6StatisticsManager::execTick(FFrame&, void* const)
native function Tick(float fDeltaTime);

// Export UR6StatisticsManager::execUpdateWeaponTime(FFrame&, void* const)
native function UpdateWeaponTime(int iPlayerID, float DeltaTime);

// Export UR6StatisticsManager::execReset(FFrame&, void* const)
native function Reset();
