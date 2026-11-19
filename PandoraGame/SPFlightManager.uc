class SPFlightManager extends Actor
    native
    notplaceable;

enum SPAxis_Direction
{
    SPAxis_XPos,                    // 0
    SPAxis_XNeg,                    // 1
    SPAxis_YPos,                    // 2
    SPAxis_YNeg,                    // 3
    SPAxis_ZPos,                    // 4
    SPAxis_ZNeg,                    // 5
    SPAxis_Unknown,                 // 6
    SPAxis_MAX                      // 7
};

enum SP_FMVertexType
{
    SPFMVT_Unknown,                 // 0
    SPFMVT_Portal,                  // 1
    SPFMVT_StartAnchor,             // 2
    SPFMVT_EndAnchor,               // 3
    SPFMVT_PlacedPoint,             // 4
    SPFMVT_Dynamic,                 // 5
    SPFMVT_GndToAir,                // 6
    SPFMVT_AirToGnd,                // 7
    SPFMVT_MAX                      // 8
};

struct native SP_VertexGraphMemoryStats
{
    var int m_numVertices;
    var int m_numEdges;
    var int m_memVertices;
    var int m_memEdges;

    structdefaultproperties
    {
        m_numVertices=0
        m_numEdges=0
        m_memVertices=0
        m_memEdges=0
    }
};

struct native SP_FlightMemoryStats
{
    var int m_numFlightVolumes;
    var int m_numBlockedVolumes;
    var int m_numPortals;
    var int m_numOctreeNodesOpenSpace;
    var int m_numOctreeBlockedSpace;
    var int m_memFlightVolumes;
    var int m_memBlockedVolumes;
    var int m_memPortals;
    var int m_memOctreeNodesOpenSpace;
    var int m_memOctreeBlockedSpace;

    structdefaultproperties
    {
        m_numFlightVolumes=0
        m_numBlockedVolumes=0
        m_numPortals=0
        m_numOctreeNodesOpenSpace=0
        m_numOctreeBlockedSpace=0
        m_memFlightVolumes=0
        m_memBlockedVolumes=0
        m_memPortals=0
        m_memOctreeNodesOpenSpace=0
        m_memOctreeBlockedSpace=0
    }
};

struct native SP_FlightPortal
{
    var Box Bounds;
    var Vector Direction;
    var int FlightVolumeIdx;
    var int m_UID;
    var transient float Cost;
    var transient float Score;
    var private native transient Pointer Next;
    var private native transient Pointer Prev;
    var private native transient Pointer Child;
    var private native transient Pointer Parent;
    var private native transient Pointer InList;

    structdefaultproperties
    {
        Bounds=(Min=(X=0.0000000,Y=0.0000000,Z=0.0000000),Max=(X=0.0000000,Y=0.0000000,Z=0.0000000),IsValid=0)
        Direction=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        FlightVolumeIdx=0
        m_UID=0
        Cost=0.0000000
        Score=0.0000000
    }
};

struct native SP_PlacedPoint
{
    var Vector m_position;
    var Vector m_direction;
    var int m_flightVolumeIndex;
    var int m_UID;

    structdefaultproperties
    {
        m_position=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_direction=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_flightVolumeIndex=0
        m_UID=0
    }
};

struct native SP_GndToAir
{
    var Vector m_position;
    var Vector m_direction;
    var Vector m_groundPos;
    var int m_flightVolumeIndex;
    var int m_UID;

    structdefaultproperties
    {
        m_position=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_direction=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_groundPos=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_flightVolumeIndex=0
        m_UID=0
    }
};

struct native SP_AirToGnd
{
    var Vector m_position;
    var Vector m_direction;
    var Vector m_groundPos;
    var int m_flightVolumeIndex;
    var int m_UID;

    structdefaultproperties
    {
        m_position=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_direction=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_groundPos=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_flightVolumeIndex=0
        m_UID=0
    }
};

struct native SP_VertexRef
{
    var SPFlightManager.SP_FMVertexType m_type;
    var byte m_zone;
    var int m_flightVolIdx;
    var int m_portalIdx;

    structdefaultproperties
    {
        m_type=SPFMVT_Unknown
        m_zone=0
        m_flightVolIdx=0
        m_portalIdx=0
    }
};

struct native SP_VertexLinkPath
{
    var array<SPBezierCurve> m_curve;
    var int m_refCount;
    var float m_length;

    structdefaultproperties
    {
        m_curve=none
        m_refCount=0
        m_length=0.0000000
    }
};

struct native SP_VertexPaths
{
    var array<SP_VertexLinkPath> m_path;

    structdefaultproperties
    {
        m_path=none
    }
};

struct native SP_VertexNeighbour
{
    var int m_UID;
    var int m_pathIndex;
    var bool m_bPathReversed;

    structdefaultproperties
    {
        m_UID=0
        m_pathIndex=0
        m_bPathReversed=false
    }
};

struct native SPF_KynapseData
{
    var int KyVertex;

    structdefaultproperties
    {
        KyVertex=0
    }
};

struct native SP_VertexLinks
{
    var SP_VertexRef m_vertexRef;
    var array<SP_VertexNeighbour> m_neighbours;
    var SPF_KynapseData kynapseData;

    structdefaultproperties
    {
        m_vertexRef=(m_type=SPFMVT_Unknown,m_zone=0,m_flightVolIdx=0,m_portalIdx=0)
        m_neighbours=none
        kynapseData=(KyVertex=0)
    }
};

struct native SPGroundConnectionInfo
{
    var int m_UID;
    var SPFlightManager.SP_FMVertexType m_type;
    var float m_cost;

    structdefaultproperties
    {
        m_UID=0
        m_type=SPFMVT_Unknown
        m_cost=0.0000000
    }
};

struct native SP_VertexGraph
{
    var private native transient Pointer m_internalUseOnly_flightMap;
    var private native transient Pointer m_internalUseOnly_planner;
    var SP_VertexPaths m_internalUseOnly_PathTable;
    var array<SP_VertexLinks> m_internalUseOnly_node;
    var int m_FirstStartAnchorUID;
    var int m_FirstEndAnchorUID;
    var int m_FirstGroundConnectionVertex;
    var int m_NumGroundConnectionVertices;
    var SPFEntityInfo m_entityInfo;

    structdefaultproperties
    {
        m_internalUseOnly_PathTable=(m_path=none)
        m_internalUseOnly_node=none
        m_FirstStartAnchorUID=0
        m_FirstEndAnchorUID=0
        m_FirstGroundConnectionVertex=0
        m_NumGroundConnectionVertices=0
        m_entityInfo=(m_speed=0.0000000,m_minTurnRadius=0.0000000,m_OneDivMinTurnRadius=0.0000000,m_maxCurvature=0.0000000,m_pawnBounds=(Min=(X=0.0000000,Y=0.0000000,Z=0.0000000),Max=(X=0.0000000,Y=0.0000000,Z=0.0000000),IsValid=0))
    }
};

struct native SP_FlightVolume
{
    var Box Bounds;
    var int m_UIDStarAnchor;
    var int m_UIDEndAnchor;
    var array<SP_FlightPortal> Portal;
    var array<SP_FlightPortal> BigPortal;

    structdefaultproperties
    {
        Bounds=(Min=(X=0.0000000,Y=0.0000000,Z=0.0000000),Max=(X=0.0000000,Y=0.0000000,Z=0.0000000),IsValid=0)
        m_UIDStarAnchor=0
        m_UIDEndAnchor=0
        Portal=none
        BigPortal=none
    }
};

struct native SP_FlightPortalList
{
    var private native const Pointer first;
};

struct native SP_BlockedVolume
{
    var Box Bounds;

    structdefaultproperties
    {
        Bounds=(Min=(X=0.0000000,Y=0.0000000,Z=0.0000000),Max=(X=0.0000000,Y=0.0000000,Z=0.0000000),IsValid=0)
    }
};

struct native SP_OctreeVolume
{
    var int Index;
    var Box Bounds;

    structdefaultproperties
    {
        Index=0
        Bounds=(Min=(X=0.0000000,Y=0.0000000,Z=0.0000000),Max=(X=0.0000000,Y=0.0000000,Z=0.0000000),IsValid=0)
    }
};

struct native SP_FlightVolumeOctreeNode
{
    var array<SP_OctreeVolume> Volume;
    var int Child[8];
    var Box Box;

    structdefaultproperties
    {
        Volume=none
        Child[0]=0
        Child[1]=0
        Child[2]=0
        Child[3]=0
        Child[4]=0
        Child[5]=0
        Child[6]=0
        Child[7]=0
        Box=(Min=(X=0.0000000,Y=0.0000000,Z=0.0000000),Max=(X=0.0000000,Y=0.0000000,Z=0.0000000),IsValid=0)
    }
};

struct native SP_FlightVolumeOctree
{
    var array<SP_FlightVolumeOctreeNode> Node;

    structdefaultproperties
    {
        Node=none
    }
};

struct native SP_FlightZone
{
    var Box Bounds;
    var array<SP_FlightVolume> FlightVolume;
    var array<SP_BlockedVolume> BlockedVolume;
    var array<SP_GndToAir> m_GndToAir;
    var array<SP_AirToGnd> m_AirToGnd;
    var array<SP_PlacedPoint> m_PlacedPoint;
    var SP_FlightVolumeOctree FlightVolumeOctree;
    var SP_FlightVolumeOctree BlockedVolumeOctree;

    structdefaultproperties
    {
        Bounds=(Min=(X=0.0000000,Y=0.0000000,Z=0.0000000),Max=(X=0.0000000,Y=0.0000000,Z=0.0000000),IsValid=0)
        FlightVolume=none
        BlockedVolume=none
        m_GndToAir=none
        m_AirToGnd=none
        m_PlacedPoint=none
        FlightVolumeOctree=(Node=none)
        BlockedVolumeOctree=(Node=none)
    }
};

struct native SP_FlightMap
{
    var int Version;
    var array<SP_FlightZone> zone;
    var int NumPortals;
    var SP_VertexGraph VertexGraph;
    var private transient SP_FlightPortalList OpenPortalList;
    var private transient SP_FlightPortalList ClosedPortalList;
    var transient Vector m_origin;
    var transient Vector m_originDirection;
    var transient Vector m_goal;
    var transient Vector m_goalDirection;
    var transient Vector m_extent;
    /** ----------------------------------------------------------------------- Container for all flight data for a map----------------------------------------------------------------------- */
    var() transient bool bShowOctree;

    structdefaultproperties
    {
        Version=0
        zone=none
        NumPortals=0
        VertexGraph=(m_internalUseOnly_PathTable=(m_path=none),m_internalUseOnly_node=none,m_FirstStartAnchorUID=0,m_FirstEndAnchorUID=0,m_FirstGroundConnectionVertex=0,m_NumGroundConnectionVertices=0,m_entityInfo=(m_speed=2000.0000000,m_minTurnRadius=256.0000000,m_OneDivMinTurnRadius=0.0000000,m_maxCurvature=0.0000000,m_pawnBounds=(Min=(X=-50.0000000,Y=-50.0000000,Z=-50.0000000),Max=(X=50.0000000,Y=50.0000000,Z=50.0000000),IsValid=0)))
        OpenPortalList=none
        ClosedPortalList=none
        m_origin=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_originDirection=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_goal=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_goalDirection=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_extent=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        bShowOctree=false
    }
};

var byte m_id[16];
var Vector m_origin;
var Vector m_originDirection;
var Vector m_goal;
var Vector m_goalDirection;
var Vector m_extent;
/** Do not access following directly. They will be changing. any points and paths completely outside a group of flight volumes; */
var() SP_FlightMap FlightMap;
var private Class OwnClass;
var private MaterialInterface FlightVolumeMaterial;
var private MaterialInterface BlockedVolumeMaterial;
var private MaterialInterface PortalMaterial;
var export editinline SPDirectFlightPlanner m_pathPlanner;
var export editinline SPFlightManagerRenderComponent RenderComponent;
var name LevelName;

// Export USPFlightManager::execGetWorldInfo(FFrame&, void* const)
native static final function WorldInfo GetWorldInfo();

// Export USPFlightManager::execGet(FFrame&, void* const)
native static final function SPFlightManager Get();

// Export USPFlightManager::execGetVertexPosition(FFrame&, void* const)
native final function Vector GetVertexPosition(int Uid);

// Export USPFlightManager::execGetVertexDirection(FFrame&, void* const)
native final function Vector GetVertexDirection(int Uid);

simulated function PostBeginPlay()
{
    SetPhysics(7);
    //return;    
}

event Destroyed()
{
    //return;    
}
