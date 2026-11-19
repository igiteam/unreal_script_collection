/**
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAICmd_CauseRabble extends NanoAICmd within NanoAI;


var transient NanoPawn NP;

var Name RabbleAnimationToPlay;

static final function CauseRabble( NanoAI AI )
{
	local NanoAICmd_CauseRabble Cmd;

    if( AI != None )
	{
		Cmd = new(AI) class'NanoAICmd_CauseRabble';
		if( Cmd != None )
		{
			AI.PushCommand( Cmd );
		}
	}
}


function Pushed()
{
	NP = NanoPawn(Pawn);
	if( NP != None )
	{
		StopFiring();
		GotoState('CausingRabble');
	}
}


function Popped()
{
	class'NanoAICmd_RunOffIntoTheCityTilUnseen'.static.RunOffIntoTheCity( Outer );
}


state CausingRabble
{
Begin:

	OverrideAnimNameToPlay = RabbleAnimationToPlay;
	NanoPawn(Pawn).DoSpecialMove( 'NSM_StopAndPlayAnAnimationLooping' );

	// maybe disperse after a while?

}



defaultproperties
{
	RabbleAnimationToPlay="Orbitals_Swarm"
}