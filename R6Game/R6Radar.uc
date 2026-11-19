class R6Radar extends Object
    native;

const RadarOOB_Inbound = 0;
const RadarOOB_Horizontal = 1;
const RadarOOB_Higher = 2;
const RadarOOB_Lower = 4;

enum ERadarMode
{
    RadarMode_Minimap,              // 0
    RadarMode_PauseMenu,            // 1
    RadarMode_Tactical,             // 2
    RadarMode_MAX                   // 3
};

enum ERadarIcon
{
    RadarIcon_Player,               // 0
    RadarIcon_Pawn,                 // 1
    RadarIcon_Bomb,                 // 2
    RadarIcon_OrderHold,            // 3
    RadarIcon_OrderRegroup,         // 4
    RadarIcon_OrderEnemySpotted,    // 5
    RadarIcon_OrderClear,           // 6
    RadarIcon_Objective,            // 7
    RadarIcon_ObjBomb,              // 8
    RadarIcon_ObjCanister,          // 9
    RadarIcon_ObjTargetSpawnPoint,  // 10
    RadarIcon_ObjSatellite,         // 11
    RadarIcon_ObjEscortExtraction,  // 12
    RadarIcon_ObjBriefcase,         // 13
    RadarIcon_ObjHostage,           // 14
    RadarIcon_GoalArea,             // 15
    RadarIcon_ExtractionZone,       // 16
    RadarIcon_DepotStation,         // 17
    RadarIcon_PawnActive,           // 18
    RadarIcon_PawnIncapacitated,    // 19
    RadarIcon_TaggedPawn,           // 20
    RadarIcon_Door,                 // 21
    RadarIcon_Window,               // 22
    RadarIcon_Ladder,               // 23
    RadarIcon_FastRope,             // 24
    RadarIcon_MAX                   // 25
};

struct SpottedPawn
{
    var R6Pawn m_pR6Pawn;
    var float m_fLastSeen;

    structdefaultproperties
    {
        m_pR6Pawn=none
        m_fLastSeen=0.0000000
    }
};

struct RadarCorner
{
    var float fSlope;
    var int X1;
    var int Y1;
    var int X2;
    var int Y2;

    structdefaultproperties
    {
        fSlope=0.0000000
        X1=0
        Y1=0
        X2=0
        Y2=0
    }
};

var array<SpottedPawn> m_arrSpottedPawns;
var R6PlayerController m_pPC;
var bool m_bInit;
var bool m_bMagmaInit;
var Canvas m_Canvas;
var Vector2D m_ptTopLeft;
var Vector2D m_ptBottomRight;
var Vector2D m_ptMiddle;
var Vector2D m_ptMapHalfSize;
var Vector2D m_CurrentMapDistance;
var float m_fPlayerYawRad;
var private int m_iFlags;
var private int m_iFramesSinceHeatVision;
var byte m_iLastFloor;
var byte m_iCurrentPlayerFloor;
var R6Radar.ERadarIcon m_eMPBriefingIcon;
var int m_iLevelWithFloors;
var int m_iStencilRef;
var float m_fCurSnakeOffset;
var float m_fZoom;
var float m_fZoomTicks;
var array<Actor> m_aSpottedEntries;
var RadarCorner m_TopLeft;
var RadarCorner m_TopRight;
var RadarCorner m_BottomLeft;
var RadarCorner m_BottomRight;
var R6MPBriefing m_pMPBriefing;
var int m_iMPBriefingObjId;
var float m_fMPBriefingMapTime;
var float m_fMPBriefingMapTimer;
var float m_fMPBriefingMapRotation;
var Vector m_vMPBriefingMapLocation;
var Vector m_vMPBriefingMapTarget;
var Vector m_vMPBriefingMapDisplacement;

// Export UR6Radar::execDrawRadar(FFrame&, void* const)
native final function DrawRadar(Canvas pCanvas, int iStencilRef);

// Export UR6Radar::execTick(FFrame&, void* const)
native final function Tick(float fDelta);

// Export UR6Radar::execInit(FFrame&, void* const)
native final function Init(R6PlayerController pPC);

defaultproperties
{
    m_eMPBriefingIcon=25
}