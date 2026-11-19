/**
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAIAction_Idle_PatrolARoute extends NanoAIAction_IdleBase within NanoAI;




var transient NanoAIBase MyAIB;



static function int InternalGetUtility( NanoAIBase InAI )
{
	local int Retval;

	local NanoPatrolPoint NPP;

	NPP = GetClosestUnClaimedPatrolPoint( InAI );

	// if we found one or we already are on a patrol route (keep patrolling)
	if( ( NPP != None ) || ( InAI.OrigPatrolPoint != None ) )
	{
		Retval = class'NanoAIAction_DefensiveBase'.default.UtilityStartVal + 55;
		`AILog_Ext( "NanoAIAction_Idle_PatrolARoute" @ `showvar(GetClosestUnClaimedPatrolPoint( InAI )),, InAI );
	}

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

	if( MyAIB.OrigPatrolPoint != None )
	{
		MyAIB.OrigPatrolPoint.UnClaimPatrolRoute();
	}

}



function static NanoPatrolPoint GetClosestUnClaimedPatrolPoint( NanoAIBase InAI )
{
	local NanoPatrolPoint NPP;
	local float Dist;
	local float BestDist;
	local NanoPatrolPoint BestPoint;


	BestDist = 99999999;

	foreach class'WorldInfo'.static.GetWorldInfo().AllActors( class'NanoPatrolPoint', NPP )
	{
		// check to see if this AI wants a specific route
		if( InAI.DesiredPatrolPointName != '' )
		{
			// if the NPP doesn't match then continue
			if( NPP.PatrolRouteName != InAI.DesiredPatrolPointName )
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
		if( CurrPatrolPoint == None )
		{
			FindAPatrolPointAndClaimIt();
		}
		else
		{
			Focus = MyAIB.CurrPatrolPoint;
			MoveToLocation( MyAIB.CurrPatrolPoint.Location );
			GetNextPatrolPoint();
		}


	}


	function FindAPatrolPointAndClaimIt()
	{
		local NanoPatrolPoint BestPoint;

		BestPoint = GetClosestUnClaimedPatrolPoint( Outer );

		if( BestPoint != None )
		{
			`AILog( "UnClaimedPatrolPoint Found" @ `showvar(BestPoint) );

			BestPoint.ClaimPatrolRoute( NanoPawnBase(Outer.Pawn) );

			MyAIB.OrigPatrolPoint = BestPoint;
			MyAIB.CurrPatrolPoint = MyAIB.OrigPatrolPoint;
		}
		else
		{
			`AILog( "No Unclaimed PatrolPoints found!" );
		}
	}


	function GetNextPatrolPoint()
	{
		// set the current node to the next node in the list
		`AILog( "Setting New Dest" @ `showvar(MyAIB.CurrPatrolPoint) @ "now is" @ `showvar(MyAIB.CurrPatrolPoint.NextNanoPatrolPoint) );
		MyAIB.CurrPatrolPoint = MyAIB.CurrPatrolPoint.NextNanoPatrolPoint;
	}


Begin:
	`AILog( GetStateName()@"Begin TAG" );

	Sleep(0.1f);

	PickNewAction();

	// we should have arrived at our Patrol point now.  So do Patrol Point based actions

	if( MyAIB.CurrPatrolPoint.SoundToPlayWhenReachedThisPoint != None )
	{
		Pawn.PlaySound( MyAIB.CurrPatrolPoint.SoundToPlayWhenReachedThisPoint );
	}

	if( MyAIB.CurrPatrolPoint.bIfStoppedFaceTheDirectionOfPatrolPoint == TRUE )
	{
		Pawn.SetRotation( MyAIB.CurrPatrolPoint.Rotation );
	}


	if( MyAIB.CurrPatrolPoint.DurationToPauseHere > 0.0f )
	{
		Sleep( MyAIB.CurrPatrolPoint.DurationToPauseHere );
	}

	Goto('Begin');

}




defaultproperties
{
	StartingStateName="Idle_Patrol"
}