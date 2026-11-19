//=============================================================================
// SASLevelScript.uc
//
// Self-running script object. 
//=============================================================================

class SASLevelScript extends SASScriptedSequence
	native
	hidecategories(Actor,Advanced,Collision,Force,Karma,LightColor,Lighting,Sound,Movement,Display);

//-----------------------------------------------------------------------------
// Constants

//-----------------------------------------------------------------------------
// Enums

//-----------------------------------------------------------------------------
// Structs

//-----------------------------------------------------------------------------
// Member Variables

var(Conditions) export editinline SASScriptTrigger mScriptTrigger;	// Trigger condition(s) for this script

var float				mActivationDelayTimer;		// Timer to control delayed triggering
var bool				mbScriptLaunched;			// Flags to specify if script has been triggered
var SASScriptInterface	mScriptInterface;			// Script interface object

//-----------------------------------------------------------------------------
// Native Functions

//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// PostBeginPlay
//
event PostBeginPlay()
{
	Super.PostBeginPlay();

	// Init script interface object
	if ( mScriptInterface == None )
	{
		mScriptInterface = new() class'SASScriptInterface';
		mScriptInterface.SetInterfaceActor( self );
	}

	// Init our triggering conditions
	if ( mScriptTrigger != None )
	{
		mScriptTrigger.mScript = self;
		mScriptTrigger.Init();
	}
}


///////////////////////////////////////////////////////////////////////////////
// RunScript
//
// Start script running.
event RunScript()
{
	mbScriptLaunched = true;

	if ( mScriptInterface.SetNewScript( self ) )
	{
		if ( mbLatent )
		{
			StartScripting();
		}
	}
}


///////////////////////////////////////////////////////////////////////////////
// StartScripting
//
function StartScripting()
{
	GotoState( 'Scripting' );
}


///////////////////////////////////////////////////////////////////////////////
// LeaveScripting
//
function LeaveScripting()
{
	mScriptInterface.ClearScript();
	mScriptInterface.mScript = None;

	GotoState( '' );
}

function AbortScript();
function MoveToNextAction();
event PawnSpawned( SASPawn aSpawned );
function CompleteLatentAction();


//-----------------------------------------------------------------------------
// States

///////////////////////////////////////////////////////////////////////////////
// STATE Scripting
//
state Scripting
{

	///////////////////////////////////////////////////////////////////////////////
	// BeginState
	//
	function BeginState()
	{
		Disable( 'Tick' );
		MoveToNextAction();
	}

	///////////////////////////////////////////////////////////////////////////////
	// AbortScript
	//
	function AbortScript()
	{
		Warn( self$": Script aborted" );
		LeaveScripting();
	}


	///////////////////////////////////////////////////////////////////////////////
	// MoveToNextAction
	//
	function MoveToNextAction()
	{
		mScriptInterface.ExecuteScript();

		// If a latent action is not pending then script has completed
		if ( mScriptInterface.FinishedScript() )
		{
			LeaveScripting();
			return;
		}

		// Enable Tick for tick dependant actions.
		if ( mScriptInterface.mCurLatentScriptAction.TickedAction() )
		{
			Enable( 'Tick' );
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// Trigger
	//
	// Recieves trigger events with same tag as the controller
	function Trigger( 
		Actor	aOther, 
		Pawn	aEventInstigator )
	{
		if ( mScriptInterface.mCurLatentScriptAction.CompleteWhenTriggered() )
		{
			CompleteLatentAction();
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// Timer
	//
	event Timer()
	{
		if ( mScriptInterface.mCurLatentScriptAction.CompleteWhenTimer() )
		{
			CompleteLatentAction();
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// Tick
	//
	event Tick(
		float	aDeltaTime )
	{
		if ( (mScriptInterface.mCurLatentScriptAction == None) 
			|| !mScriptInterface.mCurLatentScriptAction.StillTicking( mScriptInterface, aDeltaTime ) )
		{
			Disable( 'Tick' );
			CompleteLatentAction();
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// PawnSpawned
	//
	event PawnSpawned(
		SASPawn	aSpawned )
	{
		if ( mScriptInterface.mCurLatentScriptAction.CompleteOnActorSpawned( aSpawned ) )
		{
			CompleteLatentAction();
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// CompleteLatentAction
	//
	function CompleteLatentAction()
	{
		mScriptInterface.mScriptActionNum++;
		MoveToNextAction();
	}
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    Texture=Texture'EditorTx.S_LvlScript'
    bStatic=false
}