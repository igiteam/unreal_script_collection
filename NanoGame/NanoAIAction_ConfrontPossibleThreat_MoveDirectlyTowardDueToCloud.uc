/**
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAIAction_ConfrontPossibleThreat_MoveDirectlyTowardDueToCloud extends NanoAIAction_ConfrontPossibleThreatBase within NanoAI;


static function int InternalGetUtility( NanoAIBase InAI )
{
	local int Retval;

	local ChaosPacifismManager CM;
	local int ChaosLevel;


	CM = NanoGRI(InAI.WorldInfo.GRI).GetCurrentChaosManager();
	if( CM != none )
	{
		ChaosLevel = CM.GetChaosTier();
	}


	// hack for "always find the player and chase them down" 
	if( ( InAI.bSpawnedIntoTheResponseCloud == TRUE ) && ( ChaosLevel > 0 ) )
	{
		Retval += default.UtilityStartVal;
	}


	return Retval;
}



function Pushed()
{

	Super.Pushed();
}


state ConfrontPossibleThreat
{

Begin:
	`AILog( GetStateName()@"Begin TAG" );

	MoveToActor( NanoGRI(WorldInfo.GRI).GetPlayerPawn() );

	Sleep(1.f);

	Goto('Begin');

}



defaultproperties
{
	StartingStateName="ConfrontPossibleThreat"
}