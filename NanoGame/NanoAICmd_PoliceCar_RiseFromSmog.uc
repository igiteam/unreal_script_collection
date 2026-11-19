/**
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAICmd_PoliceCar_RiseFromSmog extends NanoAICmd within NanoAI_PoliceCar;



var transient NanoVehicleSpline CurrentSpline;

var transient Vector CurrentSplineGroundLoc;

static final function RiseFromSmog( NanoAI_PoliceCar AI )
{
	local NanoAICmd_PoliceCar_RiseFromSmog Cmd;

    if( AI != None )
	{
		Cmd = new(AI) Default.Class;
		if( Cmd != None )
		{
			AI.PushCommand( Cmd );
		}
	}
}


function Pushed()
{
	Super.Pushed();

	GotoState('RisingFromSmog');
}

function Popped()
{
	Super.Popped();
}


state RisingFromSmog
{

Begin:

	PickPatrolSpline( CurrentSpline, CurrentSplineGroundLoc );

	if( CurrentSpline != None )
	{
		MoveToLocation( CurrentSplineGroundLoc, 3.0f, TRUE );
	}

	
	Status = 'Success';
	PopCommand(self);
}

defaultproperties
{
	UtilityStartVal=1
	UtilityEndVal=100
}