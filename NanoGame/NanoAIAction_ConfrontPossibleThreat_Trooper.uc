/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAIAction_ConfrontPossibleThreat_Trooper extends NanoAIAction_ConfrontPossibleThreatBase within NanoAI_Trooper;

static function int InternalGetUtility( NanoAIBase InAI )
{
	local int Retval;
	local array<int> StimulusIndices;

	`warn( InAI @ "do not use this AIAction" );
	return 0;

	if( NanoAI(InAI).ConfrontationType == ECFT_RooftopSentinel && 
		InAI.MultipleResultStimulusQuery( NanoAI_Trooper(InAI).ConfrontPossibleThreatQuery_Rooftop, StimulusIndices ) > 0 )
	{
		Retval = default.UtilityStartVal + 50;
	}
	else if( InAI.MultipleResultStimulusQuery( NanoAI(InAI).ConfrontPossibleThreatQuery, StimulusIndices ) > 0 )
	{
		Retval = default.UtilityStartVal + 50;
	}

	if( InAI.CurrentAIMood == AIMood_Aggressive )
	{
		Retval += 20;
	}

	if( static.ChaosIsHighAndThereAreFoesNearby( NanoAI(InAI) ) == TRUE )
	{
		Retval += 50;
	}

	return Retval;
}




defaultproperties
{
	// Confront (close the gap)
	ListOfCmdsCanDo.Add( class'NanoAIAction_ConfrontPossibleThreat_MoveDirectlyToward' )
	ListOfCmdsCanDo.Add( class'NanoAIAction_ConfrontPossibleThreat_MoveToRoofTopInFrontOfPlayer' )

	// Command
	//ListOfCmdsCanDo.Add( class'NanoAIAction_IssueCommand_Trooper_Compliance' )
	//ListOfCmdsCanDo.Add( class'NanoAIAction_IssueCommand_Trooper_RequestBackup' )

	// Attack
	ListOfCmdsCanDo.Add( class'NanoAIAction_EngageThreat_Trooper_Ranged' )
	ListOfCmdsCanDo.Add( class'NanoAIAction_EngageThreat_Trooper_Melee' )
}
