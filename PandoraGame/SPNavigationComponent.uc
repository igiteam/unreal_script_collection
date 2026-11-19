class SPNavigationComponent extends ActorComponent
    native;

enum ESegmentType
{
    enstPathNode,                   // 0
    enstVolumePathNode,             // 1
    enstActor,                      // 2
    enstPoint,                      // 3
    ESegmentType_MAX                // 4
};

enum EObstacleType
{
    enotActor,                      // 0
    enotPoint,                      // 1
    EObstacleType_MAX               // 2
};

enum EObstacleInfluenceType
{
    eoitDirection,                  // 0
    eoitPoint,                      // 1
    EObstacleInfluenceType_MAX      // 2
};

struct native NavSegment
{
    var SPNavigationComponent.ESegmentType Type;
    var Vector StartLocation;
    var Vector EndLocation;
    var float Width;
    var float Top;
    var float Bottom;
    var float StartCapSize;
    var float EndCapSize;
    var ReachSpec ReachSpec;
    var Vector Delta;
    var Vector Dir;
    var float Distance;
    var Matrix Orientation;
    var Box Box;

    structdefaultproperties
    {
        Type=enstPathNode
        StartLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        EndLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Width=0.0000000
        Top=0.0000000
        Bottom=0.0000000
        StartCapSize=0.0000000
        EndCapSize=0.0000000
        ReachSpec=none
        Delta=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Dir=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Distance=0.0000000
        Orientation=(XPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),YPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),ZPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),WPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000))
        Box=(Min=(X=0.0000000,Y=0.0000000,Z=0.0000000),Max=(X=0.0000000,Y=0.0000000,Z=0.0000000),IsValid=0)
    }
};

struct native Influence
{
    var Vector V;

    structdefaultproperties
    {
        V=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

struct native ObstacleAvoidanceInfo
{
    var Vector Location;
    var Actor Actor;
    var Vector Extent;
    var SPNavigationComponent.EObstacleType Type;
    var Vector Normal;

    structdefaultproperties
    {
        Location=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Actor=none
        Extent=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Type=enotActor
        Normal=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

struct native ObstacleInfluences
{
    var Vector vec;
    var SPNavigationComponent.EObstacleInfluenceType Type;
    var float Duration;
    var Vector ToObstacle;
    var Actor Actor;
    var Vector Normal;
    var Vector HitLocation;

    structdefaultproperties
    {
        vec=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Type=eoitDirection
        Duration=0.0000000
        ToObstacle=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Actor=none
        Normal=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        HitLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

var array<NavSegment> m_navSegments;
var array<Influence> m_influences;
var array<ObstacleAvoidanceInfo> m_obstacleAvoidInfo;
var array<ObstacleInfluences> m_obstacleInfluences;
var int m_currentPathSegmentIdx;
var bool m_bFollowingPath;
var bool m_bAvoidObstacles;
var bool m_bAutoAvoidObstacles;
var bool m_bUseAerialPathSmoothing;
var bool m_bDebugPathFollowing;
var bool m_bDebugObstacleAvoidance;
var bool m_bDirtyInfluenceDestination;
var bool m_bDirtyObstacleAvoidanceDestination;
var Vector m_destination;
var Vector m_influenceDestination;
var Vector m_obstacleAvoidanceDestination;
var float m_lookAheadTime;
var float m_avoidObstacleTime;
var float m_avoidObstacleMaxLookAheadDistance;
var float m_maxDistanceFromPath;
var float m_seekPointNudgeDistance;
var Vector debugVec0;
var Vector debugVec1;
var Vector debugVec2;
var float debugFloat1;

// Export USPNavigationComponent::execClearPath(FFrame&, void* const)
native final function ClearPath();

// Export USPNavigationComponent::execAddPathSegment(FFrame&, void* const)
native final function AddPathSegment(SPNavigationComponent.ESegmentType Type, Vector StartLoc, Vector EndLoc, float Width, float Top, float Bottom, float StartCapRadius, float EndCapRadius, optional ReachSpec Reach);

// Export USPNavigationComponent::execAddInfluence(FFrame&, void* const)
native final function AddInfluence(Vector Loc);

// Export USPNavigationComponent::execIsActive(FFrame&, void* const)
native final function bool IsActive();

// Export USPNavigationComponent::execUpdate(FFrame&, void* const)
native final function Update(float DeltaTime);

// Export USPNavigationComponent::execActivatePathFollowing(FFrame&, void* const)
native final function ActivatePathFollowing(bool bOnOrOff);

// Export USPNavigationComponent::execActivateAvoidObstacles(FFrame&, void* const)
native final function ActivateAvoidObstacles(bool bOnOrOff);

// Export USPNavigationComponent::execGetDestination(FFrame&, void* const)
native final function Vector GetDestination();

// Export USPNavigationComponent::execAddActorObstacle(FFrame&, void* const)
native final function AddActorObstacle(Actor A);

// Export USPNavigationComponent::execAddPointObstacle(FFrame&, void* const)
native final function AddPointObstacle(Vector Location, Vector Extent, Vector Normal);

defaultproperties
{
    m_bDebugPathFollowing=true
    m_bDebugObstacleAvoidance=true
    m_lookAheadTime=1.0000000
    m_avoidObstacleTime=1.0000000
    m_maxDistanceFromPath=500.0000000
    m_seekPointNudgeDistance=200.0000000
}