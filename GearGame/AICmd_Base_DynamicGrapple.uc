/**
 * AI command to run to a grapple point and then go into the special move
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class AICmd_Base_DynamicGrapple extends AICommand_Base_Combat
	within GearAI_Cover;

var Vector GrapplingGroundMarkerLocation;
var Vector GrapplingGroundStartLocation;

/**
 * Disallow clearing the AI command
 *
 * @return FALSE if we're attempting to clear the AI command
 */
function bool AllowTransitionTo(class<GameAICommand> AttemptCommand)
{
	if( AttemptCommand == None )
	{
		return FALSE;
	}
	return Super.AllowTransitionTo( AttemptCommand );
}

/** Start the combat state and suppress reactions */
function Pushed()
{
	Super.Pushed();
	ReactionManager.SuppressAllChannels();
	GotoState( 'InCombat' );
}

/** Unsuppress the reactions */
function Popped()
{
	Super.Popped();
	ReactionManager.UnSuppressAllChannels();
	bPreciseDestination = FALSE;
}

function Vector GetGrapplingHookGroundMarker()
{
	local Vector Result;

	Result = MyGearPawn.CurrentGrapplingMarker.Location;
	Result.Z = Pawn.Location.Z;

	return Result;
}

state InCombat
{
	/** Leave cover */
	function BeginState(Name PreviousStateName)
	{
		Super.BeginState(PreviousStateName);

		InvalidateCover();
	}

Begin:
	//debug
	`AILog( "BEGIN TAG", 'State' );

	GrapplingGroundStartLocation = MyGearPawn.CurrentGrapplingStartPoint;
	if( !NavigationHandle.ComputeValidFinalDestination( GrapplingGroundStartLocation ) )
	{
`if(`notdefined(FINAL_RELEASE))
		DrawDebugBox( GrapplingGroundStartLocation, NavigationHandle.CachedPathParams.SearchExtent, 255, 0, 0, TRUE );
`endif

		`AILog( "FAILED TO FIND VALID MyGearPawn.CurrentGrapplingStartPoint" );
		Status = 'Failure';
		PopCommand( self );
	}

	GrapplingGroundMarkerLocation = GetGrapplingHookGroundMarker();
	if( !NavigationHandle.ComputeValidFinalDestination( GrapplingGroundMarkerLocation ) )
	{
`if(`notdefined(FINAL_RELEASE))
		DrawDebugBox( GrapplingGroundMarkerLocation, NavigationHandle.CachedPathParams.SearchExtent, 255, 0, 0, TRUE );
`endif

		`AILog( "FAILED TO FIND VALID GrapplingGroundMarkerLocation" );
		Status = 'Failure';
		PopCommand( self );
	}	

//	DrawDebugLine( GrapplingGroundStartLocation, MyGearPawn.Location, 255, 0, 0, TRUE );
//	DrawDebugLine( GrapplingGroundMarkerLocation, MyGearPawn.Location, 0, 255, 0, TRUE );

	while (!Pawn.ReachedPoint(GrapplingGroundStartLocation, None))
	{
		`AILog( "Moving to GrappleStartPoint" );

		SetMovePoint(GrapplingGroundStartLocation);

		// added to avoid infinite recursion
		Sleep(0.1f);
	}

	// Move directly underneath the marker so everything lines up
	while( !Pawn.ReachedPoint(GrapplingGroundMarkerLocation,None) )
	{
		`AILog( "Moving to GrappleGroundMarker" );

		bPreciseDestination = TRUE;
		SetMovePoint(GrapplingGroundMarkerLocation);
		bPreciseDestination = FALSE;

		// added to avoid infinite recursion
		Sleep(0.1f);
	}
	
	MyGearPawn.ServerDoSpecialMove(SM_GrapplingHook_DynamicClimb, TRUE);

	// At the grapple point, pop this command off the stack
	Status = 'Success';
	PopCommand(Self);
}