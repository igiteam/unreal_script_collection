//=============================================================================
// SASScriptMgr.uc
//
// Class to hold list of all scripts in a level. Responsible for notifying
// scripts of events.
// One script manager object is spawned per level by the game info object.
//=============================================================================

class SASScriptMgr extends Actor
	native
	notplaceable;

// A header file named the same as the class is implicitly included as soon as it exists... hence removed the cpptext here.

//-----------------------------------------------------------------------------
// Member Vars

var const SASScriptedSequence	mScriptList;		// Linked list of scripts


//-----------------------------------------------------------------------------
// Native Functions

///////////////////////////////////////////////////////////////////////////////
// PawnSpawned
//
// Called when an SASPawn is spawned. Passes event notification onto each
// script.
native function PawnSpawned (
	SASPawn		aSpawned);


///////////////////////////////////////////////////////////////////////////////
// PawnSpawned
//
// Called when an SASPawn is damaged. Passes event notification onto each
// script. Only called by pawns which have a 'damaged' script condition
// relating to them.
native function PawnDamaged (	
	SASPawn		aDamaged);


///////////////////////////////////////////////////////////////////////////////
// PawnKilled
//
// Called when an SASPawn is killed. Passes event notification onto each
// script.
native function PawnKilled (
	SASPawn		aKilled,
	Actor		aKiller);


///////////////////////////////////////////////////////////////////////////////
// EventTriggered
//
// Called when an event is triggered in the level. Passes event notification 
// onto each script.
native function EventTriggered (
	name		aEventName);


///////////////////////////////////////////////////////////////////////////////
// EventUntriggered
//
// Called when an event is untriggered in the level. Passes event notification 
// onto each script.
native function EventUntriggered (
	name		aEventName);


///////////////////////////////////////////////////////////////////////////////
// PawnCaptured
//
// Called when an event is triggered in the level. Passes event notification 
// onto each script.
native function PawnCaptured (
	SASPawn		aCaptured );


///////////////////////////////////////////////////////////////////////////////
// PawnEvacuated
//
// Called when an event is triggered in the level. Passes event notification 
// onto each script.
native function PawnEvacuated (
	SASPawn		aEvacuated );


///////////////////////////////////////////////////////////////////////////////
// VolumeCleared
//
// Called when an event is triggered in the level. Passes event notification 
// onto each script.
native function VolumeCleared (
	SASAssaultVolume aCleared );


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    bHiddenInGame=true
}