class SASScriptedController extends SASAIController
	native;


///////////////////////////////////////////////////////////////////////////////
// Possess
//
// Called by engine when controller possesses a pawn.
function Possess(
	Pawn	aPawn )		// Possessed pawn
{
	Super.Possess( aPawn );

	aPawn.SetPace( PACE_Walking );

	// No sight or hearing.
	SetSightFlags( 0 );
	Disable( 'SeePlayer' );
	SetHearingFlags( 0 ); 
	Disable( 'HearNoise' );

	// Step aside for all pawn types.
	SetStepAsidePawnTypes( PAWN_All );

	if ( Level.Game.bWaitingToStartMatch )
	{
		GotoState( 'WaitingToStart' );
	}
	else
	{
		EnterStartState();
	}
}


///////////////////////////////////////////////////////////////////////////////
// EnterStartState
//
function EnterStartState()
{
	GotoState( 'Idle' );
}


///////////////////////////////////////////////////////////////////////////////
// Possess
//
function ResumeObjective()
{
	if ( ResumeScripting() )
	{
		return;
	}

	GotoState( 'Idle' );
}


///////////////////////////////////////////////////////////////////////////////
// DoStunned
//
function DoStunned(
	float	aDuration );


///////////////////////////////////////////////////////////////////////////////
// DoGassed
//
function DoGassed(
	float	aDuration );


///////////////////////////////////////////////////////////////////////////////
// SeeGrenade
//
function SeeGrenade(
	SASGrenadeProjectile	aGrenade );


///////////////////////////////////////////////////////////////////////////////
// ReactToGrenade
//
function ReactToGrenade(
	SASGrenadeProjectile	aGrenade );


///////////////////////////////////////////////////////////////////////////////
// STATE Idle
//
auto state Idle
{
	ignores SeePlayer,
			HearNoise;

Begin:

	StopMoving();
	mSASPawn.ChangeAnimation();
}



///////////////////////////////////////////////////////////////////////////////
// STATE Scripting
//
state Scripting
{
	ignores SeePlayer;
}



// Decompiled with UE Explorer.
defaultproperties
{
    mType=5
}