class R6AIServiceManager extends Object
    native;

enum EPreliminaryReqRes
{
    EPreReqRes_NoResult,            // 0
    EPreReqRes_Partial,             // 1
    EPreReqRes_Full,                // 2
    EPRR_MAX,                       // 3
    EPreliminaryReqRes_MAX          // 4
};

struct CoverGroup
{
    var ENavMesh m_pNavMesh;
    var array<R6CoverZone_Ptr> m_aCoverZones;

    structdefaultproperties
    {
        m_pNavMesh=none
        m_aCoverZones=none
    }
};

struct CoverZoneRequest
{
    var int m_iLastProcessFrame;
    var bool m_bOnlyCoverZones;
    var bool m_bToCompute;
    var bool m_bKeepRefreshed;
    var bool m_bFirstComputed;
    var array<Vector> m_avThreatLocation;
    var Vector m_vPosition;
    var array<CoverGroup> m_aCoverGroup;
    var Actor m_pUser;
    var name m_TagID;

    structdefaultproperties
    {
        m_iLastProcessFrame=0
        m_bOnlyCoverZones=false
        m_bToCompute=false
        m_bKeepRefreshed=false
        m_bFirstComputed=false
        m_avThreatLocation=none
        m_vPosition=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_aCoverGroup=none
        m_pUser=none
        m_TagID="None"
    }
};

struct NavObstacleCache
{
    var Vector m_vPositionAgainst;
    var array<Actor> m_aActorList;
    var int m_iTickCreation;

    structdefaultproperties
    {
        m_vPositionAgainst=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_aActorList=none
        m_iTickCreation=0
    }
};

struct VisionCoverageMember
{
    var R6Pawn m_pPawn;
    var Vector m_vConeStart;
    var Vector m_vConeDir;
    var float m_fConeLength;
    var float m_fConeArc;
    var Vector m_vConeTopLeft;
    var Vector m_vConeTopRight;
    var Actor m_pNavObstacle;
    var ENavMesh m_pNavMesh;
    var int m_iZone;

    structdefaultproperties
    {
        m_pPawn=none
        m_vConeStart=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_vConeDir=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_fConeLength=0.0000000
        m_fConeArc=0.0000000
        m_vConeTopLeft=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_vConeTopRight=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_pNavObstacle=none
        m_pNavMesh=none
        m_iZone=0
    }
};

struct VisionCoverageTeam
{
    var bool m_bRainbowAffiliation;
    var array<VisionCoverageMember> m_aMembers;

    structdefaultproperties
    {
        m_bRainbowAffiliation=false
        m_aMembers=none
    }
};

struct AISmokeCoverage
{
    var Actor m_pGrenade;
    var R6Effect m_pEffect;
    var int m_iSmokeType;
    var float m_fRadius;
    var Vector m_vLocation;

    structdefaultproperties
    {
        m_pGrenade=none
        m_pEffect=none
        m_iSmokeType=0
        m_fRadius=0.0000000
        m_vLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

struct DataHolderInfo
{
    var Actor m_pUser;
    var array<R6ComputedData_Ptr> m_aDataHolder;
    var bool m_bToClean;

    structdefaultproperties
    {
        m_pUser=none
        m_aDataHolder=none
        m_bToClean=false
    }
};

struct R6CalculatedCoverLocation
{
    var R6CoverSeg_Ptr m_pCoverSeg;
    var R6TeamManager m_pCurrentTeam;
    var float m_fScoreLeft;
    var float m_fScoreRight;
    var float m_fDistanceToUserLeft;
    var float m_fDistanceToUserRight;
    var float m_fDistanceToTargetLeft;
    var float m_fDistanceToTargetRight;
    var bool m_bIsLeftValid;
    var bool m_bIsRightValid;
    var Vector m_vSafeLocation;

    structdefaultproperties
    {
        m_pCoverSeg=(I=none)
        m_pCurrentTeam=none
        m_fScoreLeft=0.0000000
        m_fScoreRight=0.0000000
        m_fDistanceToUserLeft=0.0000000
        m_fDistanceToUserRight=0.0000000
        m_fDistanceToTargetLeft=0.0000000
        m_fDistanceToTargetRight=0.0000000
        m_bIsLeftValid=false
        m_bIsRightValid=false
        m_vSafeLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

var private native const noexport Pointer VfTable_FTickableObject;
var array<R6RequestProc_Ptr> m_aRequestProcCover;
var array<R6RequestProc_Ptr> m_aRequestProcCorner;
var array<R6RequestProc_Ptr> m_aRequestProcPath;
var array<R6RequestProc_Ptr> m_aRequestProcAmbush;
var array<R6RequestProc_Ptr> m_aRequestProcSearch;
var array<R6RequestProc_Ptr> m_aRequestProcAdvance;
var array<R6RequestProc_Ptr> m_aRequestProcNavMeshPath;
var array<R6RequestProc_Ptr> m_aRecordedRequest;
var array<R6RequestProc_Ptr> m_aRequestProcNavMeshPath_NMT;
var array<int> m_aActorRequestingAbort;
var array<R6Pawn> m_aPawnCleanCoverSeg;
var EAIEvent m_pResultEvent;
var int m_iCoverComputed;
var int m_iCornerComputed;
var int m_iPathComputed;
var int m_iAmbushComputed;
var int m_iSearchComputed;
var int m_iAdvanceComputed;
var int m_iNavMeshPathComputed;
var int m_iNavMeshPathFindLoopsBudget;
var float m_fNMPFTriangleSubdivisionCost;
var array<R6CheckpointVolume> m_aPlayerCrossedCheckpoint;
var int m_iCoverInfoIdx;
var Actor m_pCurrentCoverActor;
var bool m_bMTRequest;
var array<CoverZoneRequest> m_aCoverZoneRequest;
var array<NavObstacleCache> m_aNavObstacleCache;
var array<VisionCoverageTeam> m_aVCoverageTeams;
var array<AISmokeCoverage> m_aAISmokeCoverage;
var array<DataHolderInfo> m_aDataHolderInfo;
var array<R6CalculatedCoverLocation> m_aCalculatedCoverLocation;
var bool m_bIncludeInvalidContour;
var int m_iMaxSpawningByFrame;
var int m_iMaxShowSelfByFrame;
var int m_iMaxRainbowShowSelfByFrame;
var array<R6TeamManager> m_aTeamManagers;
var float m_fLimitCoverZoneDist;
var bool m_bStartDebugGfx;
var bool m_bStartDebugGfx_adv;
var array<int> m_iInvalidOwnerPointers;
var float m_fTimeToCleanUpInvalidPointersList;

function LaunchAlgo(string algoName, R6AIController a_Ctrl)
{
    // End:0x20
    if(algoName == "Cover")
    {
        StartAlgoCover(a_Ctrl);        
    }
    else
    {
        // End:0x41
        if(algoName == "Search")
        {
            StartAlgoSearch(a_Ctrl);            
        }
        else
        {
            // End:0x63
            if(algoName == "Advance")
            {
                StartAlgoAdvance(a_Ctrl);                
            }
            else
            {
                // End:0x81
                if(algoName == "Ambush")
                {
                    StartAlgoAmbush(a_Ctrl);
                }
            }
        }
    }
    return;
}

// Export UR6AIServiceManager::execStartAlgoAdvance(FFrame&, void* const)
native function StartAlgoAdvance(R6AIController a_Ctrl);

// Export UR6AIServiceManager::execStartAlgoCover(FFrame&, void* const)
native function StartAlgoCover(R6AIController a_Ctrl);

// Export UR6AIServiceManager::execStartAlgoSearch(FFrame&, void* const)
native function StartAlgoSearch(R6AIController a_Ctrl);

// Export UR6AIServiceManager::execStartAlgoAmbush(FFrame&, void* const)
native function StartAlgoAmbush(R6AIController a_Ctrl);

defaultproperties
{
    m_iCoverComputed=2
    m_iCornerComputed=2
    m_iPathComputed=2
    m_iAmbushComputed=3
    m_iSearchComputed=2
    m_iAdvanceComputed=2
    m_iNavMeshPathComputed=5
    m_iNavMeshPathFindLoopsBudget=500
    m_fNMPFTriangleSubdivisionCost=1.0000000
    m_iMaxSpawningByFrame=1
    m_iMaxShowSelfByFrame=3
    m_iMaxRainbowShowSelfByFrame=1
    m_fLimitCoverZoneDist=12250000.0000000
}