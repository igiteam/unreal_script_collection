class SPKynapseLevelData extends Actor
    native
    notplaceable;

const SizeAITypes = 8;

enum KyVertexType
{
    KyVert_Kynapse,                 // 0
    KyVert_Wall,                    // 1
    KyVert_FlightPortal,            // 2
    KyVert_FlightAnchor,            // 3
    KyVert_FlightDiveStart,         // 4
    KyVert_Hover,                   // 5
    KyVert_UnrealGround,            // 6
    KyVert_UnrealCover,             // 7
    KyVert_MAX                      // 8
};

enum AITypes
{
    AI_Default,                     // 0
    AI_Griffon,                     // 1
    AI_Human,                       // 2
    AI_Werewolf,                    // 3
    AI_Firedrake,                   // 4
    AI_Nari,                        // 5
    AI_BloodTick,                   // 6
    AI_Minotaur,                    // 7
    AI_MAX                          // 8
};

struct native SPKynapseDataFile
{
    var array<byte> Data;
    var int FilePos;
    var string Filename;
    var bool Open;
    var bool Temp;

    structdefaultproperties
    {
        Data=none
        FilePos=-1
        Filename=""
        Open=false
        Temp=false
    }
};

struct native SPKyConfigData
{
    var SPKynapseDataFile XML;
    var SPKynapseDataFile ViewMapXML;
    var transient SPKynapseDataFile GenerateMapXML;

    structdefaultproperties
    {
        XML=(Data=none,FilePos=-1,Filename="",Open=false,Temp=false)
        ViewMapXML=(Data=none,FilePos=-1,Filename="",Open=false,Temp=false)
        GenerateMapXML=(Data=none,FilePos=-1,Filename="",Open=false,Temp=false)
    }
};

struct native atomicwhencooked immutablewhencooked SPKyVertex
{
    var int Id;
    var SPKynapseLevelData.KyVertexType Type;

    structdefaultproperties
    {
        Id=0
        Type=KyVert_Kynapse
    }
};

struct native atomicwhencooked immutablewhencooked SPKyEdge
{
    var int pathObjectUpdateMarker;
    var int reciprocalEdgeID;

    structdefaultproperties
    {
        pathObjectUpdateMarker=0
        reciprocalEdgeID=0
    }
};

struct native SPNeighborhoodLOSInfo
{
    var int LOSBitfield;

    structdefaultproperties
    {
        LOSBitfield=0
    }
};

struct native atomicwhencooked immutablewhencooked SPNeighborhoodEntry
{
    var int EntryData;

    structdefaultproperties
    {
        EntryData=0
    }
};

struct native atomicwhencooked immutablewhencooked SPSingleVertexNeighborhood
{
    var array<SPNeighborhoodEntry> NeighborhoodEntries;
    var int VertexGraphID;

    structdefaultproperties
    {
        NeighborhoodEntries=none
        VertexGraphID=0
    }
};

struct native SPNeighborhood
{
    var array<SPSingleVertexNeighborhood> NeighborhoodData;
    var array<int> VertexIDToNeighborhoodID;
    var int MapKeyBitShift;
    var native const map{VOID,VOID} VertexNeighborhoodIndexMap;

    structdefaultproperties
    {
        NeighborhoodData=none
        VertexIDToNeighborhoodID=none
        MapKeyBitShift=16
    }
};

struct native SPKyEntityData
{
    var SPKynapseDataFile AIMesh;
    var SPKynapseDataFile SpatialGraph;
    var SPKynapseDataFile FindNearestData;
    var transient SPKynapseDataFile DenseFDL;
    var transient SPKynapseDataFile DensePDL;
    var transient SPKynapseDataFile UDG;
    var array<SPKyVertex> Vertices;
    var transient SPKynapseDataFile SeedGraph;
    var transient SPKynapseDataFile DumpXML;
    var array<SPKyEdge> EdgeInfo;
    var SPNeighborhood Neighborhood;
    var native transient map{VOID,VOID} DefendAreaVerts;
    var transient int NumBitsToHoldLargestVertexID;

    structdefaultproperties
    {
        AIMesh=(Data=none,FilePos=-1,Filename="",Open=false,Temp=false)
        SpatialGraph=(Data=none,FilePos=-1,Filename="",Open=false,Temp=false)
        FindNearestData=(Data=none,FilePos=-1,Filename="",Open=false,Temp=false)
        DenseFDL=(Data=none,FilePos=-1,Filename="",Open=false,Temp=true)
        DensePDL=(Data=none,FilePos=-1,Filename="",Open=false,Temp=true)
        UDG=(Data=none,FilePos=-1,Filename="",Open=false,Temp=true)
        Vertices=none
        SeedGraph=(Data=none,FilePos=-1,Filename="",Open=false,Temp=true)
        DumpXML=(Data=none,FilePos=-1,Filename="",Open=false,Temp=true)
        EdgeInfo=none
        Neighborhood=(NeighborhoodData=none,VertexIDToNeighborhoodID=none,MapKeyBitShift=16)
        NumBitsToHoldLargestVertexID=0
    }
};

/** VARIABLE DECLARATIONS */
var(Kynapse) SPKyConfigData ConfigData;
var(Kynapse) SPKyEntityData EntityData[8];
