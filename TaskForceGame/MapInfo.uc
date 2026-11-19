class MapInfo extends Info
	hidecategories(Object,Display,Events,Sound,Advanced)
	collapsecategories
	editinlinenew
	native;
	
// MapInfo Interface

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

enum ECampaign
{
	EC_None,
	EC_Russia, 
	EC_Bosnia, 
	EC_Syria, 
	EC_Paris, 
	EC_Philippines, 
	EC_Demo
};

var Texture HandsTexture;

replication
{
// Functions client can call.
	reliable if( Role<ROLE_Authority )
        RestartPlayer;
}

// player respawns to the world
event RestartPlayer(Pawn aPawn) {}

// Called when PlayerView weapon is created
function PlayerViewWeapon(Weapon newWeapon) {}

event SetCheckpoint(int checkpointIndex) {}
event ClearCheckpoints() {}

function CachePlayerInvInfo(string URL) {}

function int GetCPI() {return -1;}	//retuns the check point index we should be looking for when restarting the player; -1 indicates none.

native function ClearLinkerTables(bool ClearNames);
