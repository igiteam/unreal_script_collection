/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_DBNO_Drag_ThrowFromLedge_Enemy extends NSM_DBNO_InteractionEnemyBase
	config(Pawn);

/**
 * Can a new special move override this one before it is finished?
 * This is only if CanDoSpecialMove() == TRUE && !bForce when starting it.
 */
function bool CanOverrideMoveWith( Name NewMove )
{
	//`log( GetFuncName() @ `showvar(NewMove) );

	return FALSE;
}


function SpecialMoveStarted( bool bForced, Name PrevMove )
{
	`log( "AHHHHHHHHHHHHHHHH" @ "NSM_DBNO_Drag_ThrowFromLedge_Enemy" );	`log( "AHHHHHHHHHHHHHHHH" @ "NSM_DBNO_Drag_ThrowFromLedge_Enemy" );	`log( "AHHHHHHHHHHHHHHHH" @ "NSM_DBNO_Drag_ThrowFromLedge_Enemy" );	`log( "AHHHHHHHHHHHHHHHH" @ "NSM_DBNO_Drag_ThrowFromLedge_Enemy" );	`log( "AHHHHHHHHHHHHHHHH" @ "NSM_DBNO_Drag_ThrowFromLedge_Enemy" );	`log( "AHHHHHHHHHHHHHHHH" @ "NSM_DBNO_Drag_ThrowFromLedge_Enemy" );

	Super.SpecialMoveStarted( bForced, PrevMove );
}

function SpecialMoveEnded( Name PrevMove, Name NextMove )
{
	Super.SpecialMoveEnded( PrevMove, NextMove );


}


/** Gives the special move a chance to intercept and trap input.  Returns TRUE if the input should NOT be passed on */
function bool FilterButtonInput(Name ButtonName,bool bPressed,int ButtonIdx)
{
	if( bPressed )
	{
		`log( `showvar(ButtonName) );

		// since we can't make up our minds on what is interact and what is "back"  we are just going to allow basically everything to
		// exit the drag
		if( ButtonName == 'A' )
		{
			`log( "DROP DROP DROP DRO DRPODPORPDRORDP" );
			// drop
			NSM_DBNO_InteractionVictimBase(Follower.ActiveSpecialMove).PlayGrabbedRelease();
			PlayGrabReleaseAnimation( FALSE );

			Follower.TriggerEventClass( class'SeqEvt_NanoPawn_DBNO_Drag_ThrowOffLedge_Thrown', MyNP, 0 );
		}


		return TRUE;
	}


	return FALSE;
}

simulated function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );
}




defaultproperties
{
	FollowerSpecialMoveName="NSM_DBNO_Drag_ThrowFromLedge_Victim"

	AttackerGrabSuccessStartAnim="CTRL_DragToEdge_Start"
	AttackerGrabSuccessLoopAnim="CTRL_DragToEdge_Loop"
	AttackerGrabReleaseAnim="CTRL_DragToEdge_End"
	AttackerGrabEscapeAnim="CTRL_DragToEdge_End"

	SeqEvtClassToFire_OnStart=class'SeqEvt_NanoPawn_DBNO_Drag_ThrowOffLedge_Start'
}
