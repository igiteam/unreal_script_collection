/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAI_FlyerHoverBase extends NanoAI
	dependson(NanoAutomatedDialogSystem)
	native(AI)
	abstract;


/** Altitude above nav meshes to cruise at */
var float CruisingAltitude;

/** Play this line when this ai dies **/
var EDialogueLine LineToPlayWhenKilled;

cpptext
{
	// Overridden to fly to the min height of the two polys joined by this edge
	virtual FVector GetEdgeZAdjust(FNavMeshEdgeBase* Edge);
}


function MoveToActor( Actor NewMoveActor, optional float MaxMoveTime, optional bool NewbFaceFocus = TRUE )
{
	class'NanoAICmd_Hover_MoveToGoal_Mesh'.static.HoverToGoal(self, NewMoveActor, 128.f, CruisingAltitude);
}

function MoveToLocation( vector NewMoveLocation, optional float MaxMoveTime, optional bool NewbFaceFocus = TRUE )
{
	class'NanoAICmd_Hover_MoveToGoal_Mesh'.static.HoverToPoint(self, NewMoveLocation, 128.f, CruisingAltitude);
}


function NotifyKilled(Controller Killer, Controller Killed, pawn KilledPawn, class<DamageType> damageType)
{
	if (KilledPawn == Pawn)
	{
		if( ClassIsChildOf( class'NDT_KilledByProceduralSpawner', damageType) == FALSE )
		{
			SetMood(AIMood_Killed);
			NanoGRI(WorldInfo.GRI).AttemptToPlayLine(LineToPlayWhenKilled,KilledPawn);
		}
	}
	else
	{
		if( Killer != None )
		{
			Enemy = Killer.Pawn;
		}
	}
	
	Super.NotifyKilled(Killer,Killed,KilledPawn,damageType);
}


function NanoVehicleSpline PickPatrolSpline( NanoVehicleSpline CurrentSpline, out vector GroundLocation )
{
	local NanoVehicleSpline TestSpline, BestSpline;
	local int i;
	local float DistSq, MinDistSq;

	if( CurrentSpline != None )
	{
		`AILog( "We are on" @ `showvar(CurrentSpline) @ " Attempting to pick connected location" );
		// If we're already on a spline, look for a connecting spline that maps to a ground nav mesh
		for( i = 0; i < CurrentSpline.Connections.Length; i++ )
		{
			TestSpline = NanoVehicleSpline(CurrentSpline.Connections[i].ConnectTo);
			if( GetSplineGroundLocation(TestSpline, GroundLocation) )		
			{
				//return TestSpline;
			}
		}
	}


	DistSq = VSizeSq(TestSpline.Location - Pawn.Location);

	// we often get spline locations that are like 12000+ units away that we never seem to be able to path to (bogus spline??)
    // madness
	if( DistSq < 6000 )
	{
		`AILog( "We are returning:" @ `showvar(TestSpline) @ `showvar(DistSq) );
		return TestSpline;
	}
	else
	{
		`AILog( "We are looking for closest spline" );

		// Otherwise, find the closest spline, and head towards that	
		foreach AllActors(class'NanoVehicleSpline', TestSpline)
		{
			if( TestSpline == CurrentSpline )
			{
				continue;
			}

			// Only consider flying vehicle splines
			if( !TestSpline.bFlyingVehiclesOnly )
			{
				continue;
			}

			DistSq = VSizeSq(TestSpline.Location - Pawn.Location);

			// Look for a spline that we can navigate to
			if( GetSplineGroundLocation(TestSpline, GroundLocation) && ((DistSq < MinDistSq) || (BestSpline == None)) )
			{
				BestSpline = TestSpline;
				MinDistSq = DistSq;

				`AILog( "Found a good spline!" @ `showvar(BestSpline) @ `showvar(MinDistSq) );
			}
		}

		// If we found a spline, make sure we have the up-to-date ground equivalent location
		if( BestSpline != None )
		{
			GetSplineGroundLocation(BestSpline, GroundLocation);
		}

		//`log( "Returning with " @ `showvar(BestSpline) );

		return BestSpline;
	}

	return None;
}

function bool GetSplineGroundLocation( NanoVehicleSpline NVS, out vector GroundLocation )
{
	local vector HitNormal;
	local actor HitActor;
	local vector TraceStart;
	local vector TraceEnd;

	// splines can be placed in the ground.  So we are going to raise trace distance up and then trace down
	TraceStart = NVS.Location + vect(0.0f,0.0f,128.0f);
	TraceEnd = NVS.Location + vect(0.f,0.f,-4096.f);

	// find the poly we're above	
	if( NavigationHandle.LineCheck(TraceStart, TraceEnd, vect(1.f,1.f,1.f), GroundLocation, HitNormal) )
	{
		// if we didn't hit the mesh for some reason, trace against geo
		HitActor = Trace(GroundLocation, HitNormal, TraceEnd, TraceStart, TRUE,,,TRACEFLAG_Blocking );
		if(HitActor == none)
		{
			//DrawDebugCoordinateSystem( TraceStart, rot(0,0,0), 10.0f, TRUE );
			//DrawDebugLine( TraceStart, TraceEnd, 128, 128, 0, TRUE );

			//`AILog( GetFuncName() @ "Target spline is not above a navmesh!" @ `showvar(NVS) );
			//ScriptTrace();
			return FALSE;
		}		
	}

	return TRUE;
}




defaultproperties
{
	LineToPlayWhenKilled=EDLine_PoliceCar_ShotDown
}
