/**
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAIAction_ConfrontPossibleThreat_MoveToRoofTopInFrontOfPlayer extends NanoAIAction_ConfrontPossibleThreatBase within NanoAI_Trooper;


static function int InternalGetUtility( NanoAIBase InAI )
{
	local int Retval;
	local array<int> StimulusIndices;

	if( ( NanoAI(InAI).ConfrontationType == ECFT_RooftopSentinel )
		&& ( InAI.MultipleResultStimulusQuery( NanoAI_Trooper(InAI).ConfrontPossibleThreatQuery_Rooftop, StimulusIndices ) > 0 )
		)
	{
		Retval = default.UtilityStartVal + 150;
	}


	return Retval;
}






state ConfrontPossibleThreat
{
	// @todo:  this need to be changed to have some of the Goals/Contraints for the MoveLocation call
	//         so that we end up on the roof in front of the player
	function PickNewAction()
	{
		local StimulusQuery Query;
		local array<int> StimulusIndices;
		local int Index, BestIndex;
		local float StimulusRating, BestStimulusRating;
		local float DotToStimulus, DistToStimulus;

		Query.bAllowFriendly = FALSE;
		Query.bAllowNonFriendly = TRUE;
		Query.MinFOV = -1.f;
		Query.MaxFOV = -1.f;
		Query.MinPriority = 3;
		MultipleResultStimulusQuery(Query,StimulusIndices);
		BestIndex = -1;
		BestStimulusRating = 0.f;

		foreach StimulusIndices(Index)
		{
			StimulusRating = RateStimulusForAlertAction(Index);
			if (BestIndex == -1 || StimulusRating > BestStimulusRating)
			{
				BestIndex = Index;
				BestStimulusRating = StimulusRating;
			}
		}

		if( BestIndex >= 0 )
		{
			DotToStimulus = Normal(Stimuli[BestIndex].Location - Pawn.Location) DOT vector(Pawn.Rotation);

			//debug
			`AILog("Investigating stimulus - angle:"@DotToStimulus);
			DescribeStimulus( BestIndex );

			if( DotToStimulus < 0.3f )
			{
				//debug
				`AILog("-> turning towards stimulus location"@"["$Stimuli[BestIndex].Location$"]"@"["$GetFocalPoint()$"]");

				if( Stimuli[BestIndex].bVisible )
				{
					Alert_PendingFocus = Stimuli[BestIndex].Actor;
				}
				else
				{
					Alert_PendingFocalPoint = Stimuli[BestIndex].Location;
				}
				GotoState(GetStateName(),Focus!=None?'TurnTowardsFocus':'TurnTowardsPoint');
			}
			else
			{
				//debug
				`AILog( "-> move towards best stimulus"@Stimuli[BestIndex].Actor );

				DistToStimulus = VSize(Stimuli[BestIndex].Location-Pawn.Location);
				if( !Stimuli[BestIndex].bVisible || DistToStimulus > 512.f )
				{
					MoveToActor( Stimuli[BestIndex].Actor, 5.f, TRUE );
				}
			}
		}
		else
		{
			Focus = None;
		}
	}


Begin:
	`AILog( GetStateName()@"Begin TAG" );
	//PossiblyTransitionTo('Combat',ShouldTransitionToCombat);
	//PossiblyTransitionTo('Idle',ShouldTransitionToIdle);
	PossiblyPickFireTarget();
	PickNewAction();
	Sleep(0.1f);
	Goto('Begin');

TurnTowardsFocus:
	Sleep(1.5);
	`AILog( GetStateName()@"TurnTowardsFocus TAG" );
	Focus = Alert_PendingFocus;
	do
	{
		Sleep(0.25f);
		if( Focus == none )
		{
			break;
		}
	} until (Normal(Focus.Location - Pawn.Location) dot vector(Pawn.Rotation) > 0.3);
	Goto('Begin');

TurnTowardsPoint:
	Sleep(1.5);
	`AILog( GetStateName()@"TurnTowardsPoint TAG" );
	SetFocalPoint(Alert_PendingFocalPoint);
	do 
	{
		Sleep(0.25f);
		`AILog("updated angle"@Normal(GetFocalPoint() - Pawn.Location) dot vector(Pawn.Rotation)@GetFocalPoint());
	} until (Normal(GetFocalPoint() - Pawn.Location) dot vector(Pawn.Rotation) > 0.3);
	Goto('Begin');

}



defaultproperties
{
	StartingStateName="ConfrontPossibleThreat"
}