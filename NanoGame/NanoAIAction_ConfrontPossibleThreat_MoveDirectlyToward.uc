/**
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAIAction_ConfrontPossibleThreat_MoveDirectlyToward extends NanoAIAction_ConfrontPossibleThreatBase within NanoAI;

/**
 * The default is to move to the actor which will stop when you get within the cylinders of each.
 * Some AI (e.g. bullram) just want to go to the point and when they do so they end up smashing what ever is there (e.g. player!)
 **/
var bool bUseMoveToActor;


static function int InternalGetUtility( NanoAIBase InAI )
{
	local int Retval;
	local array<int> StimulusIndices;

	//`log( NanoAI_Trooper(InAI).ConfrontPossibleThreatQuery.bRequireCombative @ NanoAI_Trooper(InAI).ConfrontPossibleThreatQuery.MaxDist @ InAI.MultipleResultStimulusQuery( NanoAI_Trooper(InAI).ConfrontPossibleThreatQuery, StimulusIndices ) );

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
		Retval = default.UtilityStartVal + 50;
		//`log(  "ZOOP incrementing" @ `showvar(Retval) );
	}


	return Retval;
}



function Pushed()
{
	local NanoPC NPC;

	Super.Pushed();

	// if we are hanging out on the rooftops looking for players then try to do a line of sight check to them
	if( ConfrontationType == ECFT_RooftopSentinel )
	{
		foreach WorldInfo.AllControllers(class'NanoPC', NPC)
		{
			if( LineOfSightTo(NPC.Pawn) )
			{
				NanoGRI(WorldInfo.GRI).AttemptToPlayLine( EDLine_SightPlayerFromDistance, Pawn );
				break;
			}
		}
	}
}

/** Plays when we first move to a location / point **/
function DoMovementShoutOut();


state ConfrontPossibleThreat
{
	function PickNewAction()
	{
		local StimulusQuery Query;
		local array<int> StimulusIndices;
		local int Index, BestIndex;
		local float StimulusRating, BestStimulusRating;
		local float DotToStimulus, DistToStimulus;

		// @todo:  bad should turn this into a query
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
					if( bUseMoveToActor == TRUE )
					{
						MoveToActor( Stimuli[BestIndex].Actor, 5.f, TRUE );
					}
					else
					{
						MoveToLocation( Stimuli[BestIndex].Location, 5.f, TRUE );
					}

					// maybe a hut hut hut or a ROAR!
					DoMovementShoutOut();
				}
			}
		}
		else
		{
			Focus = FireTarget;
		}
	}


Begin:
	`AILog( GetStateName()@"Begin TAG" );
	//PossiblyTransitionTo('Combat',ShouldTransitionToCombat);
	//PossiblyTransitionTo('Idle',ShouldTransitionToIdle);
	PickNewAction();
	PossiblyPickFireTarget();
	Focus = FireTarget;
	Sleep(0.1f);
	Goto('Begin');

TurnTowardsFocus:
	Sleep(1.5);
	`AILog( GetStateName()@"TurnTowardsFocus TAG" );
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
 	Sleep(0.1);
// 	`AILog( GetStateName()@"TurnTowardsPoint TAG" );
// 	//SetFocalPoint(Alert_PendingFocalPoint);
// 	do 
// 	{
// 		Sleep(0.25f);
// 		`AILog("updated angle"@Normal(GetFocalPoint() - Pawn.Location) dot vector(Pawn.Rotation)@GetFocalPoint());
// 	} until (Normal(GetFocalPoint() - Pawn.Location) dot vector(Pawn.Rotation) > 0.3);
	Goto('Begin');

}



defaultproperties
{
	StartingStateName="ConfrontPossibleThreat"
	bUseMoveToActor=TRUE
}