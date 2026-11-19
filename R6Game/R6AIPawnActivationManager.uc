class R6AIPawnActivationManager extends Object
    native;

enum EPAMSteps
{
    EPAMSteps_BuildAreasAroundPlayers,// 0
    EPAMSteps_UpdatePriorities,     // 1
    EPAMSteps_UpdateTerroristStatus,// 2
    EPAMSteps_MAX                   // 3
};

struct R6PawnPriority
{
    structcpptext
    {

        FR6PawnPriority(class AR6Pawn* pPawn, FLOAT fPriority) : m_pPawn(pPawn), m_fPriority(fPriority) {}
    
    }

    var R6Pawn m_pPawn;
    var float m_fPriority;

    structdefaultproperties
    {
        m_pPawn=none
        m_fPriority=0.0000000
    }
};

var private native const noexport Pointer VfTable_FTickableObject;
var R6TeamManager m_pTeamManager;
var int m_iMaxAIPawnActive;
var int m_iNumAIPawnsSpawned;
var int m_iNumAIPawnsExist;
var int m_iNumAIPawnsActive;
var bool m_bIsActivated;
var int m_iNbZoneAway;
var int m_iNextStep;
var array<int> m_aCloseZoneList;
var array<R6PawnPriority> m_aActivePawnPriority;
var array<R6PawnPriority> m_aInactivePawnPriority;
var array<R6PawnPriority> m_aToDeactivatePawns;
var bool m_bDebugPAM;

defaultproperties
{
    m_bIsActivated=true
    m_iNbZoneAway=3
}