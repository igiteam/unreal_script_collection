//=============================================================================
// SASTriggeredScriptCondition.uc
//
// Abstract base class of script conditions which are triggered to be True 
// on various types of events occuring in the level.
//=============================================================================

class SASTriggeredScriptCondition extends SASScriptCondition
	native
	abstract;

//-----------------------------------------------------------------------------
// Member Vars

var bool								mbTriggered;	// Has condition been triggered.
var const SASTriggeredScriptCondition	mNext;			// Linked list of triggered conditions within the same script or script trigger list.


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// InitScriptInternal
//
// Called when an associated script is initialised.
function InitScriptInternal (
	SASScriptedSequence	aOwnerScript)
{
	Super.InitScriptInternal(aOwnerScript);

	// Store self in list of event triggered conditions for this script
	aOwnerScript.AddTriggeredCondition(self);
}


///////////////////////////////////////////////////////////////////////////////
// InitScriptExternal
//
// Called when a pawn's list of script trigger conditions are initialised.
function InitScriptExternal (
	SASScriptTrigger	aOwnerTrigger)
{
	Super.InitScriptExternal(aOwnerTrigger);

	aOwnerTrigger.AddTriggeredCondition(self);
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
// NotifyIncapacitated
//
// Event received when an SASPawn is incapacitated.
event NotifyIncapacitated (
	SASPawn	aIncap);


///////////////////////////////////////////////////////////////////////////////
// NotifyKill
//
// Event received when an SASPawn is killed.
event NotifyCapturedKill (
	SASPawn	aKilled,
	Actor	aKiller);


///////////////////////////////////////////////////////////////////////////////
// NotifyDamaged 
//
// Event recieved when an SASPawn is damaged. Only occurs on SASPawns which
// have 'damage level' script conditions relating to them.
event NotifyDamaged (
	SASPawn	aDamaged);


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
// Event recieved when an SASPawn is captured.
event NotifyCaptured (
	SASPawn	aCaptured );


///////////////////////////////////////////////////////////////////////////////
// NotifyEvacuated
//
// Event recieved when an SASPawn is evacuated.
event NotifyEvacuated (
	SASPawn	aEvacuated );


///////////////////////////////////////////////////////////////////////////////
// VolumeCleared
//
// Event received when an SASAssaultVolume is cleared.
event NotifyVolumeCleared (
	SASAssaultVolume	aCleared );


///////////////////////////////////////////////////////////////////////////////
// Secondary Objective
//
// Event received when an SASAssaultVolume is cleared.
event NotifySecondaryObjectiveCompleted (
	SASSecondaryObjective	cCompleted );


///////////////////////////////////////////////////////////////////////////////
// Evaluate
//
// Evaluate the condition.
event bool Evaluate(
	SASAIController	aController )
{
	return CheckNotOperator ( mbTriggered );
}

///////////////////////////////////////////////////////////////////////////////
// getCompletionPercentage
//
// Returns completion state of this condition in range 0-1
function float getCompletionPercentage ( SASGRI gri )
{
	if ( mbTriggered )
	{
		return 1.0;
	} //if

	return 0.0;
} // getCompletionPercentage

///////////////////////////////////////////////////////////////////////////////
// getStatusString
//
// Returns context sensitive string indicating qualitative success
function string getStatusString ( SASGRI gri )
{
	return "";
} // getStatusString

///////////////////////////////////////////////////////////////////////////////
//
//
function String GetProgressString ( SASGRI gri )
{
	if ( mbTriggered )
	{
        return "True";
	}

	return "False";
}

///////////////////////////////////////////////////////////////////////////////
