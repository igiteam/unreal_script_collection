/**
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAIAction_Defensive_GuardLocation extends NanoAIAction_DefensiveBase within NanoAI_Trooper;


static function int InternalGetUtility( NanoAIBase InAI )
{
	local int Retval;

	Retval = 0;
	// if the LD has set the AI to guard a specific location

// 	if( InAI.CurrentAIMood == AIMood_DefendingLocation )
// 	{
// 		Retval = default.UtilityStartVal + 50;
// 	}

// 	local array<int> StimulusIndices;
// 
// 	if( InAI.MultipleResultStimulusQuery( NanoAI_Trooper(InAI).DefensiveQuery, StimulusIndices ) > 0 )
// 	{
// 		Retval = default.UtilityStartVal + 60;
// 	}


	return Retval;
}






state GuardLocation
{

Begin:
	`AILog( GetStateName()@"Begin TAG" );
	if (PickDefensePoint() && !IsCloseEnoughToDefensePoint())
	{
		`AILog("Moving towards defense point");
		MoveToActor( CurrentDefensePoint );
	}
	Sleep(1.f);
	Goto('Begin');
}



defaultproperties
{
	StartingStateName="GuardLocation"
}