//=============================================================================
// SASMPSquadManager.uc
//
// Squad management functions
//
//=============================================================================

class SASMPSquadManager extends SASSquadManager;


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


///////////////////////////////////////////////////////////////////////////////
// SwapStackUpSlots
//
// Swap allocated stacking up slots between 2 soldiers.
//::function SwapStackUpSlots(
//::	SASSoldier	aSoldier1,
//::	SASSoldier	aSoldier2 )
//::{
//::}


///////////////////////////////////////////////////////////////////////////////
// AssignWingmanFromStackUp
//
// Make closest AI member to front of the stack up slots the wingman.
//::function bool AssignWingmanFromStackUp ()
//::{
//::/*
//::	local int slot;
//::	local SASSoldierController	SC;
//::
//::	if ( mAssaultEP == None )
//::	{
//::		return;
//::	}
//::
//::	for ( slot = 0; slot < MAX_SQUAD_MEMBERS; ++slot )
//::	{
//::		if ( mStackUpOrder[slot] >= 0 )
//::		{
//::			SC = mSquadMembers[mStackUpOrder[slot]];
//::			SC.AssignWingman();
//::			mWingmen[mStackUpOrder[slot]] = SC;
//::		}
//::	}
//::*/
//::	return false;
//::}

//------------------------------------------------------------------------------
// PlayerChangedAssaultVolumes
//
// not used in multi-player game
function PlayerChangedAssaultVolumes (
	SASSoldier			aPlayerPawn,
	SASAssaultVolume	aPlayersPrevAV )
{
}

//::function LaunchAssault(
//::	SASEntryPoint	aStartEP )
//::{
//::	Log ( self $".LaunchAssault: should not have got here!" );
//::}

//------------------------------------------------------------------------------
// InitPawnScripts
//
// not used in multi-player game
//::function InitPawnScripts ( SASPawn aPawn, array<SASScriptTrigger> aScriptTriggers )
//::{
//::}

//-----------------------------------------------------------------------------
// Default properties

