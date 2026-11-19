class MPMapManager extends object
	native;

struct native export MPMapInfo
{
	var string	MapFileName;
	var byte	MapIdx;
	var int		AllowedGTs;	//bitflags using the EGameType enum
	var byte	MaxPlayers;
};

/*
GT_None					=0/1	//used to indicate SplitScreen only maps
GT_SinglePlayer			=1/2
GT_Deathmatch			=2/4
GT_TeamDeathmatch		=3/8
GT_KingOfTheHill		=4/16
GT_TeamKingOfTheHill	=5/32
GT_CTF					=6/64
GT_VIP					=7/128
GT_LastManStanding		=8/256
GT_TeamLastManStanding	=9/512
780 = DM + TDM + LMS + TLMS = STD
828 = STD + KOH + TKOH
844 = STD + CTF
908 = STD + VIP
1020 = ALL
*/

var MPMapInfo infos[NUM_MP_MAPS];

const NUM_TEST_MAPS=2;
var MPMapInfo testInfos[NUM_TEST_MAPS];

var bool UseTestMaps;

static event int GetNextMPMapIdx(Enums.EGameType gt, out int progress, bool isSS)
{
	local int gtInt;
	local int i;

	gtInt = gt;

	if (progress >= 0)
	{
		for (i=progress; i<NUM_MP_MAPS; ++i)
		{
			if (((default.infos[i].AllowedGTs & (1<<gtInt)) != 0) && (isSS || ((default.infos[i].AllowedGTs & 1) == 0)))
			{
				progress = i+1;
				return i;
			}
		}	
	}
	
	progress = -1;
	return -1;
}

static event int GetMapIdxFromFilename(string mapFilename)
{
	if (left(mapFilename, 1) != "M")
	{
		return -1;
	}
	
	return int(mid(mapFilename, 2, 2));
}

static event int GetMapIdxFromFriendlyName(string mapFriendlyName)
{
	local int i;
	
	for (i=0; i<NUM_MP_MAPS; ++i)
	{
		if (class'Strings'.default.MPFriendlyNames[i] ~= mapFriendlyName)
		{
			return i;
		}
	}
	
	return -1;
}

static event string FilenameToFriendlyName(string mapFilename)
{
	return GetMPMapFriendlyName(GetMapIdxFromFilename(mapFilename)-1);
}

static event string GetMPMapFriendlyName(int mapIdx)
{
	return class'Strings'.default.MPFriendlyNames[mapIdx];
}

static event string GetMPMapFilename(int mapIdx)
{
	return default.infos[mapIdx].MapFileName;
}

static event int GetMPMapMaxPlayers(int mapIdx)
{
	return default.infos[mapIdx].MaxPlayers;
}


// Decompiled with UE Explorer.
defaultproperties
{
    infos[0]=(MapFileName="M_01_VoodooVillage.cmf",MapIdx=0,AllowedGTs=956,MaxPlayers=16)
    infos[1]=(MapFileName="M_02_Ruins.cmf",MapIdx=1,AllowedGTs=1020,MaxPlayers=16)
    infos[2]=(MapFileName="M_03_TheShaft.cmf",MapIdx=2,AllowedGTs=1020,MaxPlayers=16)
    infos[3]=(MapFileName="M_04_OilRig.cmf",MapIdx=3,AllowedGTs=828,MaxPlayers=16)
    infos[4]=(MapFileName="M_05_Refinement.cmf",MapIdx=4,AllowedGTs=956,MaxPlayers=16)
    infos[5]=(MapFileName="M_06_ShantyTown.cmf",MapIdx=5,AllowedGTs=1020,MaxPlayers=16)
    infos[6]=(MapFileName="M_07_TheWorks.cmf",MapIdx=6,AllowedGTs=1020,MaxPlayers=16)
    infos[7]=(MapFileName="M_08_WitheringHeights.cmf",MapIdx=7,AllowedGTs=892,MaxPlayers=16)
    infos[8]=(MapFileName="M_09_Courtyard.cmf",MapIdx=8,AllowedGTs=893,MaxPlayers=16)
    infos[9]=(MapFileName="M_10_JobSite.cmf",MapIdx=9,AllowedGTs=781,MaxPlayers=16)
    infos[10]=(MapFileName="M_11_PitFight.cmf",MapIdx=10,AllowedGTs=1020,MaxPlayers=16)
    infos[11]=(MapFileName="M_12_Camp.cmf",MapIdx=11,AllowedGTs=781,MaxPlayers=16)
    infos[12]=(MapFileName="M_13_OfficeSpace.cmf",MapIdx=12,AllowedGTs=781,MaxPlayers=16)
}