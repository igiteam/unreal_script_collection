/**
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAIAction_Defensive_GuardDefensePoint extends NanoAIAction_DefensiveBase within NanoAI_Trooper;


static function int InternalGetUtility( NanoAIBase InAI )
{
	local int Retval;

	if( InAI.CurrNanoDefensivePoint != None )
	{
		Retval = default.UtilityStartVal + 40; 

		if( ( InAI.CurrNanoDefensivePoint.IsDefensePointValidForRunningTo() == TRUE )
			|| ( InAI.CurrNanoDefensivePoint.AreAllGuardPointsManned() == FALSE )
			)
		{
			Retval += 10; 
		}
	}


	//`log( "NanoAIAction_Defensive_GuardDefensePoint" @ Retval );
	return Retval;
}



function Pushed()
{ 
	Super.Pushed();

	// remove the queries that we won't have to reduce cpu cost
	ListOfAIActionsThisAICanDo.RemoveItem( class'NanoAIAction_Idle_WaitingForReinforcementWave' );


	SetAllQueriesbRequireDamaged( TRUE );
}


function Popped()
{ 
	Super.Popped();

	if( CurrNanoDefensivePoint.bUnderAttack == TRUE )
	{
		SetAllQueriesbRequireDamaged( FALSE );
	}

	if( CurrNanoDefensivePoint.IsPlayerWithinUnderDefendRadius() == TRUE )
	{
		CurrNanoDefensivePoint.UnderAttack();
	}

	CurrNanoDefensivePoint = None;
	

	if( CurrNanoGuardPoint != None )
	{
		CurrNanoGuardPoint.NumAIGuardedFromHere--;
		CurrNanoGuardPoint = None;
	}
}


state GuardDefensePoint
{
	/** This will look at the Defensive point and see if there are any remaining GuardPoints that we should head to. **/
	function Actor FindBestActorToGuard()
	{
		local NanoGuardPoint NGP;

		if( CurrNanoDefensivePoint.bUseGuardPoints == TRUE )
		{
			if( CurrNanoGuardPoint != None )
			{
				return CurrNanoGuardPoint;
			}

			foreach CurrNanoDefensivePoint.GuardPoints(NGP)
			{
				//`log( Outer @ `showvar(NGP) @ `showvar(NGP.NumAIGuardedFromHere) );

				if( NGP.NumAIGuardedFromHere == 0 )
				{
					NGP.NumAIGuardedFromHere++;
					CurrNanoGuardPoint = NGP;
					//`log( Outer @ "Claiming" @ CurrNanoGuardPoint );
					return NGP;
				}
			}
		}

		// else return the defensive point
		//`log( Outer @ "returning CurrNanoDefensivePoint" @ CurrNanoDefensivePoint );
		return CurrNanoDefensivePoint;
	}



Begin:

	`AILog( GetStateName()@"Begin TAG" @ `showvar(CurrNanoGuardPoint) );
	if( ( CurrNanoGuardPoint == None )
		&& ( IsCloseEnoughToDefensePoint() == FALSE )
		)
	{
		//`Log( Outer @ "Moving towards defense point" @ CurrNanoDefensivePoint @ VSize(Pawn.Location - CurrNanoDefensivePoint.Location) );
		MoveToActor( FindBestActorToGuard(), 1.0f, TRUE );
	}
// 	else
// 	{
// 		SetFocusBasedOnLocation();
// 	}

	SetFocusBasedOnLocation();


	Sleep(1.f);
	Goto('Begin');
}



defaultproperties
{
	StartingStateName="GuardDefensePoint"
}