//=============================================================================
// SASDMSquadManager.uc
//
// Squad management functions
//
//=============================================================================

class SASDMSquadManager extends SASMPSquadManager;
/*
//-----------------------------------------------------------------------------
// Constants

//-----------------------------------------------------------------------------
// Enums

//-----------------------------------------------------------------------------
// Structs

//-----------------------------------------------------------------------------
// Member Vars

//-----------------------------------------------------------------------------
// Native Functions

//-----------------------------------------------------------------------------
// Exec Functions

//-----------------------------------------------------------------------------
// Functions
function KillSquad ()
{
}
simulated function DisplayDebug(
	Canvas		aCanvas, 
	out	float	aYL, 
	out float	aYPos )
{
}
function AddPlayerMember( 
	SASSoldier	aNewPlayer )
{
}
function PlayerDied(
	SASSoldier	aDeadPlayer )
{
}
function AddAISquadMember( 
	SASSoldier		aNewAIMember )
{
}
function AISquadMemberDied( 
	SASSoldier aDeadSoldier )
{
}
function AISquadMemberIncapacitated(
	SASSoldier	aIncapSoldier )
{
}
function SASSoldier GetWingmansPlayer( 
	SASSoldier aWingman )
{
	return None;
}
simulated function SASSoldier GetPlayersWingman( 
	SASSoldier aPlayerPawn )
{
	return None;
}
simulated function int GetPlayerSlotIdx( 
	SASSoldier	aPlayerPawn )
{
	return -1;
}
function int GetNumLiveSquadMembers ()
{
	return 4;
}
function InitSquad()
{
}
function SpawnAISquadMember( 
	SASSpawnPoint aSpawnPoint )
{
}
simulated function SASPawn GetPlayerMemberByIdx( 
	int aMemberIdx )
{
	return None;
}
simulated function SASSoldier GetAISquadMemberByIdx( 
	int aMemberIdx )
{
	return None;
}
////////////////////////////////////////////////////////////////////////////////
// IsAWingman 
//
function bool IsAWingman ( SASSoldier soldier )
{
	return false;
}
simulated function bool CanAllocateWingman(SASSoldier player)
{
	return false;
}
function AllocateWingman( 
	SASSoldier	aPlayerToAllocateTo,
	optional Vector positionToAllocate)
{
}
function UnallocateWingman( 
	SASSoldier	aPlayerToUnallocFrom )
{
}
event SASSoldier GetClosestPlayerToOther( 
	Actor aOther )
{
	return None;
}
function int GetClosestNonWingmanAISquadMemberToOther( 
	Actor	aOther )
{
	return -1;
}
function SASSoldier GetRandomSquadMember()
{
	return None;
}
function ReportXRaySighting( 
	Controller	aSASMember, 
	Vector		aXRayLocation )
{
}
function UpdateSquadThreatInfo(
	Actor		aOther,
	Controller	aDetectingMember )
{
}
function RefreshSquadThreatInfo()
{
}
function RemoveSquadThreatByIdx(
	INT		aRemoveIdx )
{
}
function Actor GetClosestVisibleThreat(
	SASSoldier	aSoldier,
	optional Actor exclude)
{
	return None;
}
function Actor GetMostRecentlySeenThreat()
{
	return None;
}
event ClearStackUpOrder()
{
}
function int GetStackUpSlotFor(
	SASSoldier	aSoldier )
{
	return STACKUPSLOT_Empty;
}
function bool GetStackUpLocation( 
	SASSoldier	aSoldier,
	out Vector	aStackUpLoc )
{
	return false;
}
function bool GetStackUpRotation( 
	SASSoldier		aSoldier,
	out Rotator		aStackUpRot )
{
	return false;
}
function bool PrepareAssault()
{
	return false;
}
function AbortPrepareAssault()
{
}
function EndPrepareAssault()
{
}
function SASSoldier SquadCanSeePawn (Pawn P, optional SASSoldier exclude)
{
	return None;
}
*/

//-----------------------------------------------------------------------------
// Default properties

