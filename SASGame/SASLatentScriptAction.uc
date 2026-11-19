//=============================================================================
// SASScriptAction.uc
//
// Abstract base class of script actions which take time to complete.
//=============================================================================

class SASLatentScriptAction extends SASScriptAction
	native
	abstract;

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
// DisplayDebug
//
function DisplayDebug(
	Canvas		aCanvas, 
	out float	aYL, 
	out float	aYPos )
{
	aCanvas.DrawText( "Action "$GetActionString(), false );
	aYPos += aYL;
	aCanvas.SetPos( 4, aYPos );
}


///////////////////////////////////////////////////////////////////////////////
// DoAction
//
// Latent actions return False to indicate action has not completed.
function bool DoAction(
	SASScriptInterface		aInterface)
{
	if ( aInterface != None )
	{
		aInterface.mCurLatentScriptAction = self;
	}
	return false;
}


///////////////////////////////////////////////////////////////////////////////
// ShouldSkipOnScriptResume
//
function bool ShouldSkipOnScriptResume()
{
	return false;
}



///////////////////////////////////////////////////////////////////////////////
// TimerAction
//
// Returns true if action uses a timer event in the controller running the script.
//::function bool TimerAction()
//::{
//::	return false;
//::}


///////////////////////////////////////////////////////////////////////////////
// TickedAction
//
// Returns true if action uses Tick event to move latent action forward.
function bool TickedAction()
{
	return false;
}


///////////////////////////////////////////////////////////////////////////////
// StillTicking
//
// Returnss true if action is a ticked action that is still in progress.
function bool StillTicking(
	SASScriptInterface	aInterface, 
	float				aDeltaTime )
{
	return false;
}


///////////////////////////////////////////////////////////////////////////////
// CompleteOnAnimEnd
//
// Returns true if action should complete on AnimEnd event in the controller
// running the script.
function bool CompleteOnAnimEnd(
	int		aChannel )
{
	return false;
}


///////////////////////////////////////////////////////////////////////////////
// CompleteWhenTimer
//
// Returns true if action should complete when timer event occurs in the 
// controller running the script.
function bool CompleteWhenTimer()
{
	return false;
}


///////////////////////////////////////////////////////////////////////////////
// CompleteWhenTriggered
//
// Returns true if action should complete when trigger event occurs in the 
// controller running the script.
function bool CompleteWhenTriggered()
{
	return false;
}


///////////////////////////////////////////////////////////////////////////////
// CompleteOnActorSpawned
//
// Returns true if action should complete when ActorSpawned event occurs
// in controller running the script.
function bool CompleteOnActorSpawned(
	Actor	aSpawned )
{
	return false;
}


///////////////////////////////////////////////////////////////////////////////
// CompleteOnEndFiring
//
function bool CompleteOnEndFiring()
{
	return false;
}


///////////////////////////////////////////////////////////////////////////////
// MoveToGoal
//
// Indicates that action is a latent move action.
function bool MoveToGoal()
{
	return false;
}


///////////////////////////////////////////////////////////////////////////////
// TurnToGoal
//
// Indicates that action is a latent rotate action.
function bool TurnToGoal()
{
	return false;
}


///////////////////////////////////////////////////////////////////////////////
// CanDoAvoidance
//
function bool CanDoAvoidance()
{
	return true;
}


//-----------------------------------------------------------------------------
// Default Properties

