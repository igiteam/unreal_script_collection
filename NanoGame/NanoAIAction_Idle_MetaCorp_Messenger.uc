/**
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAIAction_Idle_MetaCorp_Messenger extends NanoAIAction_IdleBase within NanoAI_MetaCorp_Messenger;




static function int InternalGetUtility( NanoAIBase InAI )
{
	return default.UtilityStartVal;
}

function Pushed()
{
	Super.Pushed();


}

state DeliveringTheMessage extends Idle
{
 	event BeginState(Name PreviousStateName)
 	{
  		Super.BeginState(PreviousStateName);
 	}


Begin:


	class'NanoAICmd_Pause'.static.Pause( Outer, 2.0f ); // wait a bit

	//class'NanoAICmd_CauseRabble'.static.CauseRabble( Outer );

}

defaultproperties
{
	StartingStateName="DeliveringTheMessage"
}
