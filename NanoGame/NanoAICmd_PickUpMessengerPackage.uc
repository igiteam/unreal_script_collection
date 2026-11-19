/**
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAICmd_PickUpMessengerPackage extends NanoAICmd within NanoAI_Trooper;


/** This is the messenger we are picking up the package from **/
var protected NanoAI Messenger;


static function bool PickUpPackage( NanoAI_Trooper AI, NanoAI InMessenger, vector NewMoveLocation )
{
	local NanoAICmd_PickUpMessengerPackage Cmd;

	if( AI != None )
	{
		Cmd = new(AI) Default.Class;
		if( Cmd != None )
		{
			Cmd.Messenger = InMessenger;

			//Cmd.MoveLocation = NewMoveLocation;
			//Cmd.bFaceFocus = TRUE;

			AI.PushCommand(Cmd);
			return TRUE;
		}
	}

	return FALSE;
}



function Pushed()
{
	//bIsScripted = true; // WEAK
	super.Pushed();
}

function Popped()
{
	//bIsScripted = FALSE; // WEAK
	super.Popped();
}


/** 
 *  So we will push this onto the Stack and then only when it is is resumed 
 *  will we actually call for our friend to come and meet with us.
 *  
 **/
function Resumed( Name OldCommandName )
{
	Super.Resumed( OldCommandName );

	`log( "PickedUp!!!" );
	TellMessengerToHeadOffIntoCity();
	PopCommand( self ); // go back to normal
}


/** 
 * This will have the messenger run off into the city;
 *  
 **/
function TellMessengerToHeadOffIntoCity()
{
	`log( "sending messenger off into the city" );
	class'NanoAICmd_RunOffIntoTheCityTilUnseen'.static.RunOffIntoTheCity( Messenger );
	class'NanoAICmd_Pause'.static.Pause( Messenger, 3.0f ); // wait a bit
}



defaultproperties
{
}


