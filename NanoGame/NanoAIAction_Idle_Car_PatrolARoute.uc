/**
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAIAction_Idle_Car_PatrolARoute extends NanoAIAction_IdleBase within NanoAI_PoliceCar;

/** Current destination for the car */
var transient NanoVehicleSpline CurrentSpline;
/** Actual location on the nav mesh to send the car to (since vehicle splines are usually far above the nav mesh limit) */
var transient Vector PatrolRouteDest;


static function int InternalGetUtility( NanoAIBase InAI )
{
	return default.UtilityStartVal;
}

function Pushed()
{
	Super.Pushed();

	SetMood(AIMood_Alert);

	MyCar.SetEngineSpeedSound(FALSE);
}

// don't destroy our weapon
function DestoryCurrentWeapon();

state Idle_Patrol extends Idle
{
 	event BeginState(Name PreviousStateName)
 	{
  		Super.BeginState(PreviousStateName);

 	}


Begin:
// 	// Pick a new route to head towards
// 	CurrentSpline = PickPatrolSpline( CurrentSpline, PatrolRouteDest );
// 
// 	`AILog( "Picked:" @ `showvar(CurrentSpline) @ `showvar(PatrolRouteDest) @ " Distance to:" @ VSize(PatrolRouteDest-Pawn.Location) );
// 
// 	//DrawDebugLine( CurrentSplineGroundLoc, Pawn.Location, 255, 0, 0, TRUE );
// 
// 
//  	if( CurrentSpline != None )
//  	{
// 		//NanoGRI(WorldInfo.GRI).AttemptToPlayLine(EDLine_PoliceCar_ReportIn, MyCar);
//  
//  		MoveToLocation( PatrolRouteDest );
//  	}




	// Pick a new route to head towards
	PatrolRouteDest = NanoGRI(WorldInfo.GRI).NPES.PickAPatrolLocation();

	`AILog( "Picked:" @ `showvar(PatrolRouteDest) @ " Distance to:" @ VSize(PatrolRouteDest-Pawn.Location) );

	//DrawDebugLine( PatrolRouteDest, Pawn.Location, 255, 0, 0, TRUE );


	if( VSize(PatrolRouteDest) > 0 )
	{
		//NanoGRI(WorldInfo.GRI).AttemptToPlayLine(EDLine_PoliceCar_ReportIn, MyCar);

		MoveToLocation( PatrolRouteDest );
	}


	//
	//`AILog("Couldn't find a new destination on patrol route!");
	//Status = 'Failure';
	//PopCommand(self);

	`AILog( "Starting Idle at location" );
	Sleep( 2.25f );
	`AILog( "Ending Idle at location" );
	Goto('Begin');
}

defaultproperties
{
	StartingStateName="Idle_Patrol"
}
