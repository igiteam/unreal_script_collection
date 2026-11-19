
class TPSpawnPoint extends TPPathNode
	placeable
	native;


//***********************************************************************
// STRUCT DECLARATIONS
//***********************************************************************

enum ESpPointGroup
{
	PointGroup_None,
	PointGroup_001,
	PointGroup_002,
	PointGroup_003,
	PointGroup_004,
	PointGroup_005,
	PointGroup_006,
	PointGroup_007,
	PointGroup_008,
	PointGroup_009,
	PointGroup_010,
	PointGroup_011,
	PointGroup_012,
	PointGroup_013,
	PointGroup_014,
	PointGroup_015,
	PointGroup_016,
	PointGroup_017,
	PointGroup_018,
	PointGroup_019,
	PointGroup_020,
};

//***********************************************************************
// VARIABLE DECLARATIONS
//***********************************************************************
var () bool bEnabled;
var () class<TPPawn>	ValidPawnClass;
var () int	MaxSpawnLimit;
var () nopersistentconv array<class<Inventory> >		InventoryList;
var () ESpPointGroup PointGroup;

var	int SpawnedCount;

//***********************************************************************
// CPP TEXT
//***********************************************************************
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

