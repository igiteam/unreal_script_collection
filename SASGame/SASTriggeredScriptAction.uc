class SASTriggeredScriptAction extends SASLatentScriptAction
	native
	abstract;

var bool						mbTriggered;		// Has condition been triggered.
var SASTriggeredScriptAction	mNext;				// Linked list of triggered actions

//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// Init
//
// Called when script is initialised at start of level.
function Init (
	SASScriptedSequence	aScript)
{
	Super.Init(aScript);

	// Store self in list of event triggered actions for this script
	aScript.AddTriggeredLatentAction(self);
}


///////////////////////////////////////////////////////////////////////////////
// NotifySpawned
//
// Event received when an SASPawn is spawned.
event NotifySpawned (
	SASPawn	aSpawned);


///////////////////////////////////////////////////////////////////////////////
// NotifyKill
//
// Event received when an SASPawn is killed.
event NotifyKill (
	SASPawn	aKilled,
	Actor	aKiller);


///////////////////////////////////////////////////////////////////////////////
// NotifyEventTriggered
//
// Event received when a general level event is triggered.
event NotifyEventTriggered (
	name	aEventTag);


///////////////////////////////////////////////////////////////////////////////
// NotifyEventUntriggered
//
// Event received when a general level event is untriggered.
event NotifyEventUntriggered (
	name	aEventTag);


///////////////////////////////////////////////////////////////////////////////
// NotifyCaptured
//
// Event received when a pawn is evacuated.
event NotifyCaptured (
	SASPawn	aCaptured );


///////////////////////////////////////////////////////////////////////////////
// NotifyEvacuated
//
// Event received when a pawn is evacuated.
event NotifyEvacuated (
	SASPawn	aEvacuated );


///////////////////////////////////////////////////////////////////////////////
// VolumeCleared
//
// Event received when an SASAssaultVolume is cleared.
event NotifyVolumeCleared (
	SASAssaultVolume	aCleared );




