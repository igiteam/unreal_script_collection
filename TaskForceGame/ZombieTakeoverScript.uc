class ZombieTakeoverScript extends ZombieScriptedSequence;

var() edfindable ZombiePawn				PawnToControl;		// Pawn to control - if set, this is the pawn that will be taken over when this script is triggered
var() edfindable ZombieSpawner			SpawnToControl;		// Spawn point to control - if set, the spawner will be notified of the Takeover script and will notify
															// the takeover script when the pawn is created.  Then pawn will be then stored in PawnToControl.

var() bool	bTakeOverOnlyOnce;	// flag telling if we want to use it only once
var	bool	bUsed;				// internal - tells us if this script has already taken someone over

var() name PawnTagToControl;	// Tag of pawn to take over
var() name SpawnTagToControl;	// Tag of spawner to hook up with

// internal - actual pawn to control when this takeover script is fired off
var ZombiePawn InternalPawnToControl;

// this function is called at PostBeginPlay
function FindControlTargets ( )
{
	local ZombiePawn	ThisPawn;
	local ZombieSpawner	ThisSpawner;
	
	// store the pawn if it's set
	if ( InternalPawnToControl == None )
		InternalPawnToControl = PawnToControl;
	
	// look up a pawn by tag
	if ( InternalPawnToControl == None && PawnTagToControl != '' )
	{
		foreach AllActors ( class'ZombiePawn', ThisPawn, PawnTagToControl )
		{
			// store
			InternalPawnToControl = ThisPawn;
			// clear!
			PawnTagToControl=''; 
		}
	}

	// look for spawner by tag
	if ( SpawnToControl == None && SpawnTagToControl != '' )
	{
		foreach AllActors ( class'ZombieSpawner', ThisSpawner, SpawnTagToControl )
		{
			// store
			SpawnToControl = ThisSpawner;
			// clear
			SpawnTagToControl = ''; 
		}
	}
}

function PostBeginPlay()
{
	// do our lookup
	FindControlTargets();

	// if we have a spawner - hook us up
	if ( SpawnToControl != None )
	{
		// insert at end of list
		SpawnToControl.ImpendingTakeover [ SpawnToControl.ImpendingTakeover.Length ] = Self;
	}

	// call the super
	Super.PostBeginPlay();
}


// When this trigger is activated, the bot specified in PawnToControl 
// will be taken over and forced to follow the scripted sequence defined.
function Trigger ( Actor Other, Pawn EventInstigator )
{
	// don't takeover more than once
	if ( bUsed )
		return;
	
	// should we really do this now? (YES, because we might be searching for pawns by tag)
	FindControlTargets ( );

	// make sure we have a pawn and he's alive
	if ( InternalPawnToControl != None && InternalPawnToControl.Health > 0)
	{
		// take him over
		TakeOver ( InternalPawnToControl );		
	}

	// make sure we don't try to take over again
	if ( bTakeOverOnlyOnce )
	{
		bUsed = true;
	}
}

