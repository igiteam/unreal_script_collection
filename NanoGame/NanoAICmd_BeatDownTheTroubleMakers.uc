/**
 * This should be more of a "roughing up" then beating down the rabble rouser to give Lyrik time
 * to intervene.
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAICmd_BeatDownTheTroubleMakers extends NanoAICmd within NanoAI_Trooper;


/** This is the name of the animation to use to "beat down the trouble maker" **/
var name BeatDownAnimName;

/** how long to beat the rabble down**/
var transient float TimeToDoTheBeating;


static final function BeatDownTheTroubleMakers( NanoAI_Trooper AI, const float InTimeToDoTheBeating )
{
	local NanoAICmd_BeatDownTheTroubleMakers Cmd;

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
	GotoState( 'DoBeatDownTheTroubleMakers' );
}


function StopTheBeatDown()
{
	`AILog( "stopping anim" );
	NanoPawn(Pawn).EndSpecialMove( 'NSM_StopAndPlayAnAnimationLooping' );
}


/** This will play an anim and then pop. **/
state DoBeatDownTheTroubleMakers
{
	Begin:
	`AILog( "Beating the dude" @ self );

	// we need to have a way to stop the looping anim so we have to use a timer as we can't pass params to the special moves
	MyNanoPawn.SetTimer( TimeToDoTheBeating, FALSE, nameof(StopTheBeatDown), self );

	OverrideAnimNameToPlay = BeatDownAnimName;
	NanoPawn(Pawn).DoSpecialMove( 'NSM_StopAndPlayAnAnimationLooping' );

}




defaultproperties
{
	BeatDownAnimName="Baton_Attack_Turtle_Break_Swing"
}

