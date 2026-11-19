/**
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAIAction_Idle_Rebels_CauseRabble extends NanoAIAction_IdleBase within NanoAI_Rebels_RabbleRouser;




static function int InternalGetUtility( NanoAIBase InAI )
{
	return default.UtilityStartVal;
}

function Pushed()
{
	Super.Pushed();


}

state GoRabbleRouse extends Idle
{
 	event BeginState(Name PreviousStateName)
 	{
  		Super.BeginState(PreviousStateName);
 	}


Begin:


	DrawDebugLine( Outer.Pawn.Location, LocationToRabbleRouse, 255, 255, 255, TRUE );
	DrawDebugCoordinateSystem( LocationToRabbleRouse, rot(0,0,0), 10.0f, TRUE );


	do 
	{
		MoveToLocation( LocationToRabbleRouse );  // here we need to send them to the spawn location which the player can see		
		Sleep( 0.1f );
	} until( VSize( Pawn.Location - LocationToRabbleRouse ) < 256.0f );

	class'NanoAICmd_Pause'.static.Pause( Outer, 2.0f ); // wait a bit

	class'NanoAICmd_CauseRabble'.static.CauseRabble( Outer );

}

defaultproperties
{
	StartingStateName="GoRabbleRouse"
}
