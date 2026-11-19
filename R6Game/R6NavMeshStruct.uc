class R6NavMeshStruct extends Object
    native;

struct R6PathNode
{
    var int m_iTriangleIndex;
    var ENavMesh m_pNavMesh;

    structdefaultproperties
    {
        m_iTriangleIndex=0
        m_pNavMesh=none
    }
};

struct R6NMSmokeZone
{
    var float m_fRadius;
    var Vector m_vLocation;

    structdefaultproperties
    {
        m_fRadius=0.0000000
        m_vLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

struct R6NavObjectsAllowance
{
    var() bool m_bDoorNotAllowed;
    var() bool m_bRopeNotAllowed;
    var() bool m_bWindowNotAllowed;
    var() bool m_bLedgeNotAllowed;
    var() bool m_bRopeLedgeNotAllowed;
    var() bool m_bLadderNotAllowed;
    var array<Actor> m_aIllegalInteractiveActor;

    structdefaultproperties
    {
        m_bDoorNotAllowed=false
        m_bRopeNotAllowed=false
        m_bWindowNotAllowed=false
        m_bLedgeNotAllowed=false
        m_bRopeLedgeNotAllowed=false
        m_bLadderNotAllowed=false
        m_aIllegalInteractiveActor=none
    }
};

struct R6PathFindOptions
{
    var bool m_bAvoidPhysObstacles;
    var bool m_bAvoidSmoke;
    var bool m_bAvoidTearGas;
    var int m_iTeamCoverageRestriction;
    var bool m_bUsesObstacleAllowance;
    var R6NavObjectsAllowance m_NavObjAllowance;
    var array<R6NMSmokeZone> m_aSmokeZones;
    var array<R6NMSmokeZone> m_aTearGasZones;
    var Pawn m_pPawn;
    var float m_fAllowedPathCost;

    structdefaultproperties
    {
        m_bAvoidPhysObstacles=false
        m_bAvoidSmoke=false
        m_bAvoidTearGas=false
        m_iTeamCoverageRestriction=-1
        m_bUsesObstacleAllowance=false
        m_NavObjAllowance=(m_bDoorNotAllowed=false,m_bRopeNotAllowed=false,m_bWindowNotAllowed=false,m_bLedgeNotAllowed=false,m_bRopeLedgeNotAllowed=false,m_bLadderNotAllowed=false,m_aIllegalInteractiveActor=none)
        m_aSmokeZones=none
        m_aTearGasZones=none
        m_pPawn=none
        m_fAllowedPathCost=0.0000000
    }
};

var R6PathNode myNode;
