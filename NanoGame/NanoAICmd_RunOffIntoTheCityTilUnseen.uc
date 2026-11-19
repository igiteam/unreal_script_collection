/**
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAICmd_RunOffIntoTheCityTilUnseen extends NanoAICmd within NanoAI;



static function bool RunOffIntoTheCity( NanoAI AI )
{
	local NanoAICmd_RunOffIntoTheCityTilUnseen Cmd;

	if( AI != None )
	{
		Cmd = new(AI) Default.Class;
		if( Cmd != None )
		{
			AI.PushCommand(Cmd);
			return TRUE;
		}
	}

	return FALSE;
}



function Pushed()
{
	Super.Pushed();

	TellMessengerToHeadOffIntoCity();
}



function Resumed( Name OldCommandName )
{
	local NanoGRI NGRI;

	Super.Resumed( OldCommandName );

	NGRI = NanoGRI(WorldInfo.GRI);

	//`log( "NanoAICmd_RunOffIntoTheCityTilUnseen oh hi! I was resumed" );

	// if we can be see seen then we need to run off again
	if( NGRI.CanPlayerSeeThisLocation( Pawn.Location ) == TRUE )
	{
		`log( "Player can see me I am running off into the city more to lose them" );
		TellMessengerToHeadOffIntoCity();
	}
	else
	{
		//`log( "NanoAICmd_RunOffIntoTheCityTilUnseen  killing off the pawn" @ Outer @ Pawn );
		Pawn.Destroy();
		AbortCommand(self);
	}
}



/** 
 * This will have the messenger run off into the city;
 *  
 **/
function TellMessengerToHeadOffIntoCity()
{
	local Vector MessengerDestinationLoc;

	`log( "sending messenger off into the city" );

    MessengerDestinationLoc = NanoGRI(WorldInfo.GRI).NPES.FindLocation_MessengerDestination( class'NanoPawn_MetaCorp_Messenger', Pawn.Location );
	MoveToLocation( MessengerDestinationLoc );  // needs to be a command that runs off and checks to see if you are visible.  If so, keep pathing.  else kills self
	//`log( "  running to:" @ MessengerDestinationLoc );
	
	//class'WorldInfo'.static.GetWorldInfo().DrawDebugCoordinateSystem( MessengerDestinationLoc, rot(0,0,0), 10.0f, TRUE );
	//class'WorldInfo'.static.GetWorldInfo().DrawDebugLine( Pawn.Location, MessengerDestinationLoc, 255,255,255, TRUE );

}




defaultproperties
{
}


