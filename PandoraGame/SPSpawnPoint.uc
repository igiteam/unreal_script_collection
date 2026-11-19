class SPSpawnPoint extends SPPathNode
    native;

enum ESpPointGroup
{
    PointGroup_None,                // 0
    PointGroup_001,                 // 1
    PointGroup_002,                 // 2
    PointGroup_003,                 // 3
    PointGroup_004,                 // 4
    PointGroup_005,                 // 5
    PointGroup_006,                 // 6
    PointGroup_007,                 // 7
    PointGroup_008,                 // 8
    PointGroup_009,                 // 9
    PointGroup_010,                 // 10
    PointGroup_011,                 // 11
    PointGroup_012,                 // 12
    PointGroup_013,                 // 13
    PointGroup_014,                 // 14
    PointGroup_015,                 // 15
    PointGroup_016,                 // 16
    PointGroup_017,                 // 17
    PointGroup_018,                 // 18
    PointGroup_019,                 // 19
    PointGroup_020,                 // 20
    PointGroup_MAX                  // 21
};

/** VARIABLE DECLARATIONS */
var() bool bEnabled;
var() class<SPPawn> ValidPawnClass;
var() int MaxSpawnLimit;
var() /*0x80000000-0x00000000*/ array< class<Inventory> > InventoryList;
var() SPSpawnPoint.ESpPointGroup PointGroup;
var int SpawnedCount;
