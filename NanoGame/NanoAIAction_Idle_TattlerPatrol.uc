/**
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAIAction_Idle_TattlerPatrol extends NanoAIAction_IdleBase within NanoAI_SentryBot;




static function int InternalGetUtility( NanoAIBase InAI )
{
	local int Retval;

	Retval = default.UtilityStartVal + 250;

	return Retval;
}




state Idle_Patrol extends Idle
{
	function BeginState(Name PrevStateName)
	{
		Super.BeginState( PrevStateName );
	}

	function EndState(Name NextStateName)
	{
		Super.EndState( NextStateName );
	}

	function PickNewAction()
	{

	}

Begin:
	`AILog( GetStateName()@"Begin TAG" );

	Sleep(1.f);


	PickNewAction();

	GotoState('IdleTattler');

}




defaultproperties
{
	StartingStateName="Idle_Patrol"
}