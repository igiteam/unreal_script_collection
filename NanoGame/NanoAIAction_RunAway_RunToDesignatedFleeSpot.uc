/**
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAIAction_RunAway_RunToDesignatedFleeSpot extends NanoAIAction_RunAwayBase within NanoAI
	config(AI);


var transient NanoAIBase MyAIB;


var config float PercentageOfHealthToFleeAt;


static function int InternalGetUtility( NanoAIBase InAI )
{
	local int Retval;

	local NanoDesignatedFleeSpot NDFS;



	// if we are damaged we want to run to a flee spot!
	if( InAI.Pawn.Health < (NanoPawn(InAI.Pawn).default.DefaultHealth * default.PercentageOfHealthToFleeAt) )
	{
		NDFS = GetClosestUnClaimedFleeSpot( InAI );

		`log( `showvar(NDFS) );

		if( NDFS != None )
		{
			Retval = 90;
		}
	}
	

	if( Retval > 0 )
	{
		Retval += default.UtilityStartVal;
	}


	//`log( `showvar(InAI.Pawn.Health) @ `showvar(NanoPawn(InAI.Pawn).default.DefaultHealth * 0.70f) @ `showvar(GetClosestUnClaimedFleeSpot( InAI ) ) @ `showvar(Retval) );


	return Retval;
}



function Pushed()
{
	Super.Pushed();

		MyAIB = Outer;
}


function Popped()
{ 
	Super.Popped();

	if( MyAIB.CurrFleeSpot != None )
	{
		MyAIB.CurrFleeSpot.UnClaimDesignatedFleeSpot();
	}

}





function static NanoDesignatedFleeSpot GetClosestUnClaimedFleeSpot( NanoAIBase InAI )
{
	local NanoDesignatedFleeSpot NPP;
	local float Dist;
	local float BestDist;
	local NanoDesignatedFleeSpot BestPoint;


	BestDist = 99999999;

	foreach class'WorldInfo'.static.GetWorldInfo().AllActors( class'NanoDesignatedFleeSpot', NPP )
	{
		// check to see if this AI wants a specific route
		if( InAI.DesiredFleeSpotName != '' )
		{
			// if the NPP doesn't match then continue
			if( NPP.DesignatedFleeSpotName != InAI.DesiredFleeSpotName )
			{
				continue;
			}
		}


		// if we are not claimed
		if( NPP.PawnThatHasClaimedThisRoute == None )
		{
			Dist = VSize( InAI.Pawn.Location - NPP.Location );
			if( Dist < BestDist )
			{
				BestDist = Dist;
				BestPoint = NPP;
			}
		}
	}

	return BestPoint;
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



state FleeToSpot
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
		if( MyAIB.CurrFleeSpot == None )
		{
			FindAPatrolPointAndClaimIt();
		}
		else
		{
			Focus = MyAIB.CurrFleeSpot;
			MoveToLocation( MyAIB.CurrFleeSpot.Location );
		}


	}


	function FindAPatrolPointAndClaimIt()
	{
		local NanoDesignatedFleeSpot BestPoint;

		BestPoint = GetClosestUnClaimedFleeSpot( Outer );

		if( BestPoint != None )
		{
			`AILog( "UnClaimedFleeSpot Found" @ `showvar(BestPoint) );

			BestPoint.ClaimDesignatedFleeSpot( NanoPawnBase(Outer.Pawn) );

			MyAIB.CurrFleeSpot = BestPoint;
		}
		else
		{
			`AILog( "No Unclaimed FleeSpots found!" );
		}
	}



Begin:
	`AILog( GetStateName()@"Begin TAG" );

	Sleep(0.1f);

	PickNewAction();

	// we should have arrived at our Patrol point now.  So do Patrol Point based actions

	if( MyAIB.CurrFleeSpot.SoundToPlayWhenReachedThisPoint != None )
	{
		Pawn.PlaySound( MyAIB.CurrFleeSpot.SoundToPlayWhenReachedThisPoint );
	}

	if( MyAIB.CurrFleeSpot.bIfStoppedFaceTheDirectionOfPatrolPoint == TRUE )
	{
		Pawn.SetRotation( MyAIB.CurrFleeSpot.Rotation );
	}


	if( MyAIB.CurrFleeSpot.DurationToPauseHere > 0.0f )
	{
		Sleep( MyAIB.CurrFleeSpot.DurationToPauseHere );
	}

	Goto('Begin');

}



defaultproperties
{
	StartingStateName="FleeToSpot"

}