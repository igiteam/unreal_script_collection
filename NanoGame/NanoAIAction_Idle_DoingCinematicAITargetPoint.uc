/**
 * BOOM insta do this and stay there for the time!   For now just do it.  We will make him respond to direct attacks next.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAIAction_Idle_DoingCinematicAITargetPoint extends NanoAIAction_IdleBase within NanoAI_Trooper;



static function int InternalGetUtility( NanoAIBase InAI )
{
	local int Retval;

	if( InAI.CurrCinematicAITargetPoint != none )
	{
		Retval = class'NanoAIAction_RunAwayBase'.default.UtilityStartVal + 1000;
	}

	return Retval;
}


function Pushed()
{
	Super.Pushed();

	//PossiblyPickFireTarget();
	//Focus = Enemy; // our focus for a melee target should always be our enemy

	// Pick the nearest player as the focus
	Focus = FindClosestPlayerPawn();
}


function Popped()
{
	Super.Popped();

	ClearTimer( nameof(DoWaitingToAttackSpecialMove) );
}


state Idle
{
	function BeginState( Name PrevStateName )
	{
		Super.BeginState( PrevStateName );

		if( CurrCinematicAITargetPoint.bPlayAnim == TRUE )
		{
			if( CurrCinematicAITargetPoint != none )
			{
				OverrideAnimNameToPlay = CurrCinematicAITargetPoint.OverrideAnimNameToPlay;
			}
		}

	}



Begin:
	`AILog( GetStateName()@"Begin TAG" );


	if( VSize(CurrCinematicAITargetPoint.Location - Pawn.Location) > 128.0f )
	{
		`AILog("Moving towards CinematicAITargetPoint");

		MoveToActor( CurrCinematicAITargetPoint, 1.0f, TRUE );
	}
// 	else
// 	{
// 		SetFocusBasedOnLocation();
// 	}

	SetFocusBasedOnLocation();

	if( IsTimerActive( nameof(DoWaitingToAttackSpecialMove), self ) == FALSE )
	{
		//`log( "setting time for DoWaitingToAttackSpecialMove" );
		SetTimer( (0.5f + (FRand() * 3.0f)), FALSE, nameof(DoWaitingToAttackSpecialMove), self );
	}



	//`log( `showvar(Focus) @ `showvar(Focus.Location) );

	Sleep(1.f);
	Goto('Begin');

}



defaultproperties
{
	StartingStateName="Idle"

	WaitingToAttackSpecialMoveName="NSM_Trooper_IdleBreak_Spectator"
}