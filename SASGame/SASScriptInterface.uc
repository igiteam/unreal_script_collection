//=============================================================================
// SASScriptInterface.uc
//
// Interface between a scripted sequence and the object executing the script.
// Script executing objects can be either level scripts or AI controllers.
//=============================================================================

class SASScriptInterface extends Object
	native;

//-----------------------------------------------------------------------------
// Constants

//-----------------------------------------------------------------------------
// Enums

//-----------------------------------------------------------------------------
// Structs

//-----------------------------------------------------------------------------
// Member Variables

var SASScriptedSequence		mScript;					// Script to execute on this controller
var int						mScriptActionNum;			// Current action at within script
var SASLatentScriptAction	mCurLatentScriptAction;		// Current latent action being executed

var SASScriptAction			mScriptAnimAction;			// Current animation action being executed
var int						mScriptAnimIterations;		// Number of iterations of current anim action remaining

var Actor					mScriptMoveTarget;			// Move target while scripting
var Vector					mScriptMoveTargetOfs;		// Local space offset from move target while scripting
var	Actor					mScriptFocus;				// Focus actor while scripting
var	vector					mScriptFocalDir;			// Focal direction while scripting
var bool					mbScriptWalking;			// Should pawn walk while doing move to script actions

var bool					mbScriptFiring;				// Flag to spcifying if should be firing
var int						mScriptFiringNumShots;		// Countdown of num shots to fire
var bool					mbEngageWhileScripting;

var Actor					mInterfaceActor;			// Ptr to actor (AIController or LevelScript) we belong to
var SASAIController			mAIController;				// Ptr to AIController we belong to, if any


//-----------------------------------------------------------------------------
// Native Functions

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
	aCanvas.DrawText( "AIScript "$mScript$" ActionNum "$mScriptActionNum );
	aYPos += aYL;
	aCanvas.SetPos( 4, aYPos );

	aCanvas.DrawText( "Script walking: "$mbScriptWalking );
	aYPos += aYL;
	aCanvas.SetPos( 4, aYPos );

	aCanvas.DrawText( "Script firing: "$mbScriptFiring );
	aYPos += aYL;
	aCanvas.SetPos( 4, aYPos );

	mCurLatentScriptAction.DisplayDebug( aCanvas, aYL, aYPos );
}


///////////////////////////////////////////////////////////////////////////////
// SetInterfaceActor
//
function SetInterfaceActor(
	Actor	aInterfaceActor )
{
	mInterfaceActor = aInterfaceActor;

	if ( SASAIController( aInterfaceActor ) != None )
	{
		mAIController = SASAIController( aInterfaceActor );
	}
	else
	{
		mAIController = None;
	}
}


///////////////////////////////////////////////////////////////////////////////
// SetNewScript
//
// Sets up controller ready to run specified script. Returns false if 
// scripting is currently disabled.
function bool SetNewScript(
	SASScriptedSequence	aNewScript )
{
	ClearScript();
	mScript = aNewScript;
	mScript.ExecuteActions( self );

	return true;
}


///////////////////////////////////////////////////////////////////////////////
// ExecuteScript
//
// Run script from current action.
function ExecuteScript()
{
	mScript.ExecuteActions( self );
}


///////////////////////////////////////////////////////////////////////////////
// FinishedScript
//
// Returns true if script has finished.
function bool FinishedScript()
{
	return (mCurLatentScriptAction == None);
}


///////////////////////////////////////////////////////////////////////////////
// ClearScript
//
function ClearScript()
{
	mScriptActionNum = 0;
	mCurLatentScriptAction = None;
	
	mScriptFocus = None;
	mScriptFocalDir = vect(0,0,0);
	mScriptMoveTarget = None;
	mScriptMoveTargetOfs = vect(0,0,0);
	mbScriptWalking = false;
	mbEngageWhileScripting = false;

	ClearScriptAnim( false );
	ClearScriptFiring();

	if ( mAIController != None )
	{
		mAIController.Pawn.RequestStance (STANCE_Standing);
	}
}


///////////////////////////////////////////////////////////////////////////////
// ClearScriptAnim
//
function ClearScriptAnim(
	bool	abChangeAnim )
{
	if ( mAIController == None )
	{
		return;
	}

	if ( mScriptAnimAction != None )
	{
		mScriptAnimAction = None;

		// Hand control back to the pawn
		mAIController.bControlAnimations = false;

		if ( (mAIController.Pawn != None) && (mAIController.Pawn.Physics == PHYS_RootMotion) )
		{
			mAIController.Pawn.SetPhysics( PHYS_Walking );
			//mAIController.Pawn.SetCollision( true, true, true );
			//mAIController.Pawn.bCollideWorld = true;
		}
	}

	mScriptAnimIterations = 0;
	
	if ( abChangeAnim && (mAIController.Pawn != None) )
	{
		mAIController.Pawn.ChangeAnimation();
	}
}


///////////////////////////////////////////////////////////////////////////////
// ClearScriptFiring
//
function ClearScriptFiring()
{
	mbScriptFiring			= false;
	mScriptFiringNumShots	= 0;

	if ( mAIController != None )
	{
		mAIController.StopFiring();
	}
}


///////////////////////////////////////////////////////////////////////////////
// SetControllerFocus
//
function bool SetControllerFocus()
{
	if ( mAIController != None )
	{
		if ( mScriptFocus != None )
		{
			mAIController.SetFocus( mScriptFocus );
			return true;
		}
		
		if ( mScriptFocalDir != vect(0,0,0) )
		{
			mAIController.Focus = None;
			mAIController.FocalPoint = mAIController.Pawn.Location + (1000 * mScriptFocalDir);

			return true;
		}
	}

	return false;
}


///////////////////////////////////////////////////////////////////////////////
// SetInterfaceActorTag
//
function SetInterfaceActorTag( 
	name	aNewTag )
{
	mInterfaceActor.Tag = aNewTag;
}


///////////////////////////////////////////////////////////////////////////////
// SetInterfaceActorTimer
//
function SetInterfaceActorTimer(
	float	aTime, byte whichleveltime )
{
	mInterfaceActor.SetTimer( aTime, false, whichleveltime );

	if ( mAIController != None && whichleveltime == 0 )
	{
		mAIController.mScriptTimerActionTimeToTrigger = mAIController.Level.TimeSeconds + aTime;
	}
}



//-----------------------------------------------------------------------------
// Default Properties

