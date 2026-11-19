/**
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAIAction_Idle_WaitingForReinforcementWave extends NanoAIAction_IdleBase within NanoAI_Trooper;



static function int InternalGetUtility( NanoAIBase InAI )
{
	local int Retval;
	local NanoReinforcementPoint NRP;

	local bool bNumPointsForAWave;
	local bool bNotEnoughPeopleReadyToGo;
	local bool bInitialSpawnIsStillActive;

	local bool bWaitingForTimeForAWave;


	if( ( InAI.CurrNanoDefensivePoint != None ) && ( InAI.CurrNanoDefensivePoint.bUseWaveSpawning == TRUE ) )
	{
		bNumPointsForAWave = ( InAI.CurrNanoDefensivePoint.NumPointsForAWave > 0 );

		bNotEnoughPeopleReadyToGo = InAI.GetBlackBoard().GetCurrWaveWaiting(InAI.CurrNanoDefensivePoint); // ( InAI.GetBlackBoard().GetCurrWaveWaiting(InAI.CurrNanoDefensivePoint) < InAI.CurrNanoDefensivePoint.NumPointsForAWave );

		NRP = InAI.CurrNanoReinforcementPoint; // InAI.CurrNanoDefensivePoint.FindClosetReinforcmentPoint( InAI.Pawn.Location );

		bWaitingForTimeForAWave = ( ( NRP == none ) || `TimeSinceEx(InAI, NRP.LastWaveSentTime) < ( NRP.MinTimeBetweenSendingWaves ) );

		// so we are NOT waiting for a wave if we were spawned as an initial spawn point
		bInitialSpawnIsStillActive = InAI.bInitialSpawnOnDefensivePoint;
	}



	//`log( "------------------------------------------" );
	//`log( InAI @ InAI.CommandList );
	//if( InAI.CurrNanoDefensivePoint != none ) `log( "  " @ bNumPointsForAWave @ InAI.CurrNanoDefensivePoint.NumPointsForAWave );
	//`log( "  " @ `showvar(bNotEnoughPeopleReadyToGo) );
	//`log( "  " @ `showvar(bWaitingForTimeForAWave) );
	//`log( "  " @ `showvar(bInitialSpawnIsStillActive) );
	//`log( "  " @ ( InAI.IsCloseEnoughToDefensePoint() == FALSE ) );
	//if( NRP != None ) `log( "    " @ `TimeSinceEx(InAI, NRP.LastWaveSentTime) @ NRP.MinTimeBetweenSendingWaves @ `TimeSinceEx(InAI, NRP.LastWaveSentTime) - ( NRP.MinTimeBetweenSendingWaves ) );



	// if our CurrNanoDefensivePoint has a wave 
	if( ( InAI.CurrNanoDefensivePoint != None ) 
		&& bNumPointsForAWave
		&& ( bNotEnoughPeopleReadyToGo || bWaitingForTimeForAWave || bInitialSpawnIsStillActive )
		&& ( InAI.IsCloseEnoughToDefensePoint() == FALSE )
		)
	{
		//`log( "    " @ NRP );
		//`log( "    " @ InAI.CurrNanoDefensivePoint.IsDefensePointValidForRunningTo() );
		//`log( "    " @ InAI.GetBlackBoard().GetCurrWaveWaiting(InAI.CurrNanoDefensivePoint) @ InAI.CurrNanoDefensivePoint.NumPointsForAWave );
		//`log( "    " @ InAI.GetBlackBoard().GetCurrWaveWaiting(InAI.CurrNanoDefensivePoint) );// >= InAI.CurrNanoDefensivePoint.NumPointsForAWave ) ;


		// so if we have a valid place to run and we have full up wave let's not wait around!
		if( ( InAI.CurrNanoDefensivePoint.IsDefensePointValidForRunningTo() == TRUE )
			&& ( ( InAI.CurrNanoDefensivePoint.bUseWaveSpawning == TRUE ) && ( InAI.GetBlackBoard().GetCurrWaveWaiting(InAI.CurrNanoDefensivePoint) == TRUE )  )
			&& ( bWaitingForTimeForAWave == FALSE )
			&& ( ( NRP != none ) && ( ( NRP.LastWaveSentTime > 0 ) && ( `TimeSinceEx(InAI, NRP.LastWaveSentTime) - ( NRP.MinTimeBetweenSendingWaves ) > 0.0f ) ) )
			|| ( bInitialSpawnIsStillActive == TRUE )
			)
		{

			if( ( NRP != None ) && ( NRP.LastWaveSentTime > 0 ) && ( `TimeSinceEx(InAI, NRP.LastWaveSentTime) - ( NRP.MinTimeBetweenSendingWaves ) > 0.0f ) )
			{
				//`log( " == = = == = = = = FAIL SAFE!!!! ====== " );				`log( " == = = == = = = = FAIL SAFE!!!! ====== " );				`log( " == = = == = = = = FAIL SAFE!!!! ====== " );				`log( " == = = == = = = = FAIL SAFE!!!! ====== " );				`log( " == = = == = = = = FAIL SAFE!!!! ====== " );				`log( " == = = == = = = = FAIL SAFE!!!! ====== " );
			}

			// no utility++ other AIActions will cause this guy to run off
			//if( NRP != None ) `log( " aaaaaa " @ `showvar(NRP) @ `showvar(NRP.LastWaveSentTime) @ `showvar(NRP.MinTimeBetweenSendingWaves) );

		}
		else
		{
			Retval = class'NanoAIAction_DefensiveBase'.default.UtilityStartVal + 120;
			//`log( "    => " @ Retval @ InAI );
		}
	}
	else
	{
		//`log( " ======================  !!!! NO MORE REINFORCEMENT " );
	}


	return Retval;
}



function Pushed()
{ 
	Super.Pushed();

	// we should have been spawned near one
	if( CurrNanoReinforcementPoint == None ) 
	{
		CurrNanoReinforcementPoint = CurrNanoDefensivePoint.FindClosetReinforcmentPoint( Pawn.Location );
	}

	GetAIBlackboard().ModifyCurrWaveWaiting( CurrNanoDefensivePoint, 1 );

	SetAllQueriesbRequireDamaged( TRUE );
}


function Popped()
{ 
	local NanoAI AI;

	Super.Popped();
	GetAIBlackboard().ModifyCurrWaveWaiting( CurrNanoDefensivePoint, -1 );

	// hack for now.
	// since we popped our means our utility function which put is into this state is no longer valid
	// which should be due to the wave count being filled
	// so to stop the race condition (due to not having the two phase planner) we just remove the "wait for" action
	// from all of the waiting pawns!
	foreach Outer.WorldInfo.AllControllers( class'NanoAI', AI )
	{
		if( ( AI.CommandList.Class == default.Class )
			&& ( CurrNanoDefensivePoint == AI.CurrNanoDefensivePoint )
			)
		{
			if( ( CurrNanoDefensivePoint.bUseWaveSpawning == FALSE ) || ( AI.CurrNanoReinforcementPoint == CurrNanoReinforcementPoint ) )
			{
				//`log( "Removing ReinforcmentWave from: " @ AI );
				AI.ListOfAIActionsThisAICanDo.RemoveItem( default.Class );
			}
		}
	}

	if( CurrNanoReinforcementPoint != None )
	{
		CurrNanoReinforcementPoint.LastWaveSentTime = WorldInfo.TimeSeconds;
		//CurrNanoReinforcementPoint.SetTimer( CurrNanoReinforcementPoint.MinTimeBetweenSendingWaves, FALSE, nameof(CurrNanoReinforcementPoint.DecrementSpawnFrom) );
		CurrNanoReinforcementPoint.DecrementSpawnFrom();
	}



	if( ( CurrNanoDefensivePoint.bUseFormation == TRUE ) && ( CurrNanoDefensivePoint.Formation != None ) )
	{
		ListOfAIActionsThisAICanDo.AddItem( class'NanoAIAction_Defensive_MemberOfAFormation' );

		// Set up all of the Wall params that it needs.
		bInFormation = TRUE;
		CurrNanoDefensivePoint.Formation.AddMember(Outer);
	}
	//AI.MoveToActor( Pt ); // here we need to send them after the player

}




state Idle
{

Begin:
	`AILog( GetStateName()@"Begin TAG" );

	Sleep(1.f);
	Goto('Begin');
}



defaultproperties
{
	StartingStateName="Idle"
}