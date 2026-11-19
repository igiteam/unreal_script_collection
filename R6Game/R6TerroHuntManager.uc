class R6TerroHuntManager extends Object
    native;

var private native const noexport Pointer VfTable_FTickableObject;
var R6TeamManager m_pTeamManager;
var int m_iNumTerrosSpawned;
var int m_iNumTerrosExist;
var int m_iMaxTerrosExist;
var array<int> m_aiCloseZoneList;
var int m_iActivateFailSafeWave;
var R6ObjectiveTerroristHunt m_pTerroHuntObjective;
var bool m_bTHPDebug;
var array<R6TerroHuntPoint> m_aTHP;
var array<R6TerroHuntPoint> m_aHighPriorityTHP;

// Export UR6TerroHuntManager::execApplyTerroHuntPointDensity(FFrame&, void* const)
native final function ApplyTerroHuntPointDensity(array<R6TerroHuntPoint> arrTerroHuntPoints, int iTerroHuntPointsToActivate);

defaultproperties
{
    m_iMaxTerrosExist=8
}