/**
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAIAction_RunAway_CowerInFear extends NanoAIAction_RunAwayBase within NanoAI;


static function int InternalGetUtility( NanoAIBase InAI )
{
	local int Retval;

	local array<int> StimulusIndices;

	// if we see a hostile then we want to cower in fear!
	if( InAI.MultipleResultStimulusQuery( NanoAI(InAI).ConfrontPossibleThreatQuery, StimulusIndices ) > 0 )
	{
		Retval = 20;
	}
	

	if( Retval > 0 )
	{
		Retval += default.UtilityStartVal;
	}

	return Retval;
}



function Pushed()
{
	Super.Pushed();

	NanoPawn(Pawn).DoSpecialMove( 'NSM_CowerInFear', TRUE );
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

	CheckForStimuliAndTurnToFaceThem();

	Sleep(1.f);

	Goto('Begin');
}



defaultproperties
{
	StartingStateName="Idle"



}