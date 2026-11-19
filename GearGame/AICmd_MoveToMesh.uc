/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 *
 * Correct the AI back onto the navmesh if they are off of it
 */
class AICmd_MoveToMesh extends AICommand
    within GearAI
	native(AI);

var bool bSavedIgnoreStepAside;

var array<Vector> ValidPositionOnMesh;
var Vector BestValidPosition;
var float ValidSearchRadius;

/** Simple constructor that pushes a new instance of the command for the AI */
static function bool MoveToMesh( GearAI AI )
{
	local AICmd_MoveToMesh Cmd;

	if( AI != None )
	{
		Cmd = new(AI) class'AICmd_MoveToMesh';
		if( Cmd != None )
		{
			AI.PushCommand( Cmd );
			return TRUE;
		}
	}

	return FALSE;
}

/** Build debug string */
event String GetDumpString()
{
	return Super.GetDumpString()@"Point:"@BestValidPosition;
}

function Pushed()
{
	local int ValidPosIdx;
	local bool bHasValidPos;

	Super.Pushed();

	// If we're in PHYS_NavMeshWalking, temporarily switch to PHYS_Walking until we get back on the navmesh
	if( MyGearPawn.Physics == PHYS_NavMeshWalking )
	{
		MyGearPawn.SetPhysics(PHYS_Walking);
	}

	// call outer's function to notify it we're now in a movement state
	StartingMovement();

	bSavedIgnoreStepAside = bIgnoreStepAside;
	bIgnoreStepAside = TRUE;

	// Try to get some valid positions for this Pawn
	NavigationHandle.GetValidPositionsForBox( Pawn.Location, ValidSearchRadius+Pawn.GetCollisionRadius(), Pawn.GetCollisionExtent(), FALSE, ValidPositionOnMesh, 4 );
	for( ValidPosIdx = 0; ValidPosIdx < ValidPositionOnMesh.length; ++ValidPosIdx )
	{
		// Make sure we can actually get to one of the valid positions from our current location
		if( PointReachable(ValidPositionOnMesh[ValidPosIdx]) )
		{
			BestValidPosition = ValidPositionOnMesh[ValidPosIdx];
			bHasValidPos = true;
			break;
		}
	}

	if( !bHasValidPos )
	{
		`AILog("ABORTING! Failed to find any valid positions within radius"@ValidSearchRadius+Pawn.GetCollisionRadius() );
		GotoState('DelayFailure');
	}
	else
	{
		// Set flag that says we are moving and MoveGoal info is valid
		bMovingToGoal		= TRUE;
		bReevaluatePath		= FALSE;

		Outer.MoveGoal      = None;
		Vect2BP(Outer.MovePosition, vect(0,0,0));
		MoveTarget			= None;

		// Start the move
		GotoState( 'MovingToMesh' );
	}
}

function Popped()
{
	Super.Popped();

	// No longer moving to a goal
	bMovingToGoal = FALSE;

	// call outer's function to notify it we're no longer in a movement state
	StoppingMovement();

	// Reset movement physics
	MyGearPawn.SetMovementPhysics();

	// explicitly clear velocity/accel as they aren't necessarily
	// cleared by the physics code
	if( Pawn != None )
	{
		Pawn.ZeroMovementVariables();
		Pawn.DestinationOffset = 0.f;
	}
	MoveTarget = None;

	if( MyGearPawn != None )
	{
		MyGearPawn.SetTargetingMode(FALSE);
		MyGearPawn.Acceleration = vect(0,0,0);
	}

	bIgnoreStepAside = bSavedIgnoreStepAside;
}

/** Check if AI has successfully reached the given goal */
function bool HasReachedGoal()
{
	if( Pawn == None )
	{
		return TRUE;
	}

	return Pawn.ReachedPoint( BestValidPosition, None );
}

state MovingToMesh `DEBUGSTATE
{
Begin:
	//debug
	`AILog( "--"@GetStateName()$":"$Class@"-- BEGIN TAG CurLoc: "@Pawn.Location@"Dest"@BestValidPosition@NavigationHandle );

	MoveTo( BestValidPosition );
	
	if( HasReachedGoal() )
	{
		Status = 'Success';
		PopCommand( self );
	}
	else
	{
		// If we couldn't make it to a valid position, try teleporting
		`AILog( "--"@GetStateName()$":"$Class@"-- Failed to move to mesh from"@Pawn.Location@"teleporting to BestValidPosition:"@BestValidPosition, 'error');
		Pawn.SetLocation(BestValidPosition);
		Status = 'Failure';
		GotoState('DelayFailure');
		Stop;
	}
}

event DrawDebug( HUD H, Name Category )
{
	Super.DrawDebug( H, Category );

	if( Category != 'Pathing' )
	{
		return;
	}

	if( ValidPositionOnMesh.Length > 0 )
	{
		// BLUE
		DrawDebugLine( Pawn.Location, BestValidPosition, 0, 0, 255 );
	}
}

defaultproperties
{
	ValidSearchRadius=256.f
}