/**
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAIAction_Idle_StandAround extends NanoAIAction_IdleBase within NanoAI;



static function int InternalGetUtility( NanoAIBase InAI )
{
	return default.UtilityStartVal + 20;
}



function CheckForStimuliAndTurnToFaceThem()
{
	local int Index, BestIndex;
	local array<int> StimulusIndices;
	local float StimulusRating, BestStimulusRating;

	BestIndex = -1;
	BestStimulusRating = 0.f;

	if( MultipleResultStimulusQuery( IdleQuery, StimulusIndices ) > 0 )
	{
		foreach StimulusIndices(Index)
		{
			StimulusRating = Stimuli[Index].Priority;
			if (BestIndex == -1 || StimulusRating > BestStimulusRating)
			{
				BestIndex = Index;
				BestStimulusRating = StimulusRating;
			}
		}

		Focus = Stimuli[Index].Actor;
	}
}


state Idle
{

Begin:
	`AILog( GetStateName()@"Begin TAG" );

	PossiblyPickFireTarget();
	CheckForStimuliAndTurnToFaceThem();

	Sleep(1.f);

	Goto('Begin');
}



defaultproperties
{
	StartingStateName="Idle"
}