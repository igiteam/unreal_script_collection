/**
 * This should probably be replaced with a special move eventually
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAICmd_BeatDownByTheRiotTroopers extends NanoAICmd within NanoAI;


/** This is the name of the animation to use to "beat down the trouble maker" **/
var name BeatDownAnimName;

/** how long to beat the rabble down**/
var transient float TimeToDoTheBeating;


static final function BeatDownByTheRiotTroopers ( NanoAI AI, const float InTimeToDoTheBeating )
{
	local NanoAICmd_BeatDownByTheRiotTroopers Cmd;

	if( AI != None )
	{
		Cmd = new(AI) default.class;
		if( Cmd != None )
		{
			Cmd.TimeToDoTheBeating = InTimeToDoTheBeating;

			AI.PushCommand(Cmd);
		}
	}
}


function Pushed()
{
	Super.Pushed();
	GotoState( 'DoBeatDownByTheRiotTroopers' );
}


/** This will play an anim and then pop. **/
state DoBeatDownByTheRiotTroopers 
{
	Begin:
	// wait for the beating to commence
	Sleep( TimeToDoTheBeating );
	NanoPawn(Pawn).FullBodySlot.PlayCustomAnim( BeatDownAnimName, 1.0f, 0.1f, 0.1f, TRUE );

	PopCommand( self );
}




defaultproperties
{
	BeatDownAnimName="Hit_React_Air_Dir_D_A_Land"
}

