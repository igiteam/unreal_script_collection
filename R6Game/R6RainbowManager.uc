class R6RainbowManager extends R6TeamManager
    native
    notplaceable
    hidecategories(lighting);

struct SMemberInfo
{
    var int m_iLastZoneIndex;
    var ENavMesh m_pLastNavMesh;
    var Pawn m_pInfoOwner;
    var bool m_bHasZoneChanged;
    var array<int> m_aZonesAround;

    structdefaultproperties
    {
        m_iLastZoneIndex=0
        m_pLastNavMesh=none
        m_pInfoOwner=none
        m_bHasZoneChanged=false
        m_aZonesAround=none
    }
};

var int m_iNumRainbow;
var int m_iNumActiveRainbow;
var bool m_bTeamSpawned;
var bool m_bDebugGfxSenseAmbush;
var bool m_bAllowBloodStains;
var float m_fCountActiveRainbowMembersLastTime;
var float m_fCoverCalcTimer;
var float m_fPlayerIdleCounter;
var float m_fTeamIdleCounter;
var int m_iNbRestrictionZones;
var array<SMemberInfo> m_aMemberInfo;
var Actor m_pInteractSOLActor;

// Export UR6RainbowManager::execInitRainbowManager(FFrame&, void* const)
native final function InitRainbowManager();

// Export UR6RainbowManager::execSpawnTeamMembers(FFrame&, void* const)
native final function SpawnTeamMembers(R6PlayerStart pPlayerStart);

// Export UR6RainbowManager::execSpawnRainbowAroundPlayer(FFrame&, void* const)
native final function SpawnRainbowAroundPlayer();

// Export UR6RainbowManager::execIsTeamInFormation(FFrame&, void* const)
native final function bool IsTeamInFormation();

// Export UR6RainbowManager::execIsTeamOnNavObject(FFrame&, void* const)
native final function bool IsTeamOnNavObject();

// Export UR6RainbowManager::execIsTeamStandingBy(FFrame&, void* const)
native final function bool IsTeamStandingBy();

// Export UR6RainbowManager::execIsTeamEngaged(FFrame&, void* const)
native final function bool IsTeamEngaged(optional bool bIsFiring);

// Export UR6RainbowManager::execCanTeamRopeBreach(FFrame&, void* const)
native final function bool CanTeamRopeBreach();

// Export UR6RainbowManager::execCanTeamGoDown(FFrame&, void* const)
native final function bool CanTeamGoDown();

// Export UR6RainbowManager::execCanTeamGoUp(FFrame&, void* const)
native final function bool CanTeamGoUp();

// Export UR6RainbowManager::execPawnReachedWaypoint(FFrame&, void* const)
native function PawnReachedWaypoint(R6Pawn pPawn, R6Waypoint pWaypoint);

// Export UR6RainbowManager::execRemovePawnFromTeam(FFrame&, void* const)
native function RemovePawnFromTeam(R6Pawn pPawn, optional bool bObsolete);

// Export UR6RainbowManager::execIsDoorBreached(FFrame&, void* const)
native final function bool IsDoorBreached();

function CreateTeam()
{
    local NavigationPoint StartSpot;
    local Vector v1, v2, v3;
    local R6Pawn tempPawn;

    StartSpot = WorldInfo.Game.FindPlayerStart(none);
    GetAxes(StartSpot.Rotation, v1, v2, v3);
    // End:0xBE
    if(m_iNumRainbow >= 1)
    {
        tempPawn = __NFUN_278__(Class'R6RainbowPawn', self, 'Rainbow1', StartSpot.Location + (v2 * 150.0000000));
        m_aTeamMember[0] = tempPawn;
        // End:0xBE
        if(m_aTeamMember[0] != none)
        {
            m_aTeamMember[0].m_eAlliance = 2;
            m_aTeamMember[0].SpawnDefaultController();
        }
    }
    // End:0x13C
    if(m_iNumRainbow >= 2)
    {
        tempPawn = __NFUN_278__(Class'R6RainbowPawn', self, 'Rainbow2', StartSpot.Location + (v2 * 300.0000000));
        m_aTeamMember[1] = tempPawn;
        // End:0x13C
        if(m_aTeamMember[1] != none)
        {
            m_aTeamMember[1].m_eAlliance = 2;
            m_aTeamMember[1].SpawnDefaultController();
        }
    }
    // End:0x14D
    if(m_iNumRainbow > 0)
    {
        InitRainbowManager();
    }
    return;
}

defaultproperties
{
    m_fCountActiveRainbowMembersLastTime=1.0000000
    m_iNbRestrictionZones=-1
    m_bBroadcastVisionCoverage=true
}