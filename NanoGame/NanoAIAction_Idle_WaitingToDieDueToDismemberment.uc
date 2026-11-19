/**
 * Oh no! I have had something dismembered and now I need to stand around and die.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAIAction_Idle_WaitingToDieDueToDismemberment extends NanoAIAction_IdleBase within NanoAI_Trooper;



static function int InternalGetUtility( NanoAIBase InAI )
{
	local int Retval;

	if( NanoPawn(InAI.Pawn).bDismemberedAndDying == TRUE )
	{
		Retval = class'NanoAIAction_RunAwayBase'.default.UtilityStartVal + 2000;
	}

	return Retval;
}


// once you get to this state you are dead and can't be interrupted
function bool CanOverrideMoveWith( Name NewMove )
{
	return FALSE;
}


function KillOffPawnDueToBleedOut()
{
	//`log( "KillOffPawnDueToBleedOut" @ Pawn.Health );
	Pawn.TakeDamage( 500, None, Pawn.Location, vect(0,0,0), class'NDT_BledOutDueToDismemberment' );
	//`log( "KillOffPawnDueToBleedOut" @ Pawn.Health );
}


state WaitingToDie
{
	function BeginState( Name PrevStateName )
	{
		Super.BeginState( PrevStateName );

		// stop him moving
		SetUseBoidMovement( FALSE );
		Pawn.ZeroMovementVariables();
		// set a timer here for this pawn to die
		SetTimer( 5.0f, FALSE, nameof(KillOffPawnDueToBleedOut), self );

		OverrideAnimNameToPlay = 'Orbitals_GetThemOffMe_Loop';
		NanoPawn(Pawn).DoSpecialMove( 'NSM_Trooper_Death_WaitingToDie' );
	}


Begin:
	`AILog( GetStateName()@"Begin TAG" );

	Sleep(1.f);
	Goto('Begin');
}



defaultproperties
{
	StartingStateName="WaitingToDie"
}