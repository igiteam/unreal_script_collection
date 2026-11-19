/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_DBNO_DragEnemy extends NSM_DBNO_InteractionEnemyBase
	config(Pawn);


var transient bool bPlayingDragFwd;

var name DragMovingAnim;
var name DragIdleAnim;

var name VictimDragMovingAnim;
var name VictimDragIdleAnim;

var config float PercentageOfMaxSpeedWhileDragging;

var transient AudioComponent AC_DragLoop;


/**
 * Can a new special move override this one before it is finished?
 * This is only if CanDoSpecialMove() == TRUE && !bForce when starting it.
 */
function bool CanOverrideMoveWith( Name NewMove )
{
	if( NewMove == 'NSM_DBNO_Drag_ThrowFromLedge_Attempt' )
	{
		return TRUE;
	}

	if( NewMove == 'NSM_DBNO_Drag_ThrowFromLedge_Enemy' )
	{
		return TRUE;
	}


	//`log( GetFuncName() @ `showvar(NewMove) );

	return FALSE;
}




function SpecialMoveStarted( bool bForced, Name PrevMove )
{
	Super.SpecialMoveStarted( bForced, PrevMove );
}

function SpecialMoveEnded( Name PrevMove, Name NextMove )
{
	Super.SpecialMoveEnded( PrevMove, NextMove );

	DragStopAudio();
}


function DragStartAudio()
{
	Follower.PlaySound( Follower.DBNOAudio.DragBegin );

	AC_DragLoop = new(Follower) class'AudioComponent';

	if( AC_DragLoop != None )
	{
		AC_DragLoop.SoundCue = Follower.DBNOAudio.DragLoop;
		Follower.AttachComponent( AC_DragLoop );
		AC_DragLoop.FadeIn( 0.100f, 1.0f );
	}
}


function DragStopAudio()
{
	Follower.PlaySound( Follower.DBNOAudio.DragStop );

	if( AC_DragLoop != None )
	{
		AC_DragLoop.FadeOut( 0.100f, 0.0f );
		AC_DragLoop = None;
	}
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
			// drop
			PlayGrabReleaseAnimation( FALSE );
			Follower.TriggerEventClass( class'SeqEvt_NanoPawn_DBNO_Drag_Release', MyNP, 0 );
		}
		else if( ButtonName == 'B' )
		{
			// drop
			PlayGrabReleaseAnimation( FALSE );
			Follower.TriggerEventClass( class'SeqEvt_NanoPawn_DBNO_Drag_Release', MyNP, 0 );
		}
		else if( ButtonName == 'Y' )
		{
			// drop
			//PlayGrabReleaseAnimation( FALSE );
			// here need to transition to the next NSM :-\  or maybe just play the anim all in a row
			MyNP.DoSpecialMove( 'NSM_DBNO_Drag_ThrowFromLedge_Attempt', TRUE, Follower );
			//MyNP.PendingSpecialMoveStruct = MyNP.FillSpecialMoveStructFromParams( 'NSM_DBNO' );

		}
		else if( ButtonName == 'R1' )
		{
			// drop
			PlayGrabReleaseAnimation( FALSE );
			Follower.TriggerEventClass( class'SeqEvt_NanoPawn_DBNO_Drag_Release', MyNP, 0 );
			return FALSE; // we want to continue processing input so we dash
		}

		return TRUE;
	}


	return FALSE;
}

simulated function Tick( float DeltaTime )
{
	local bool bNewPlayingDragFwd;

	Super.Tick( DeltaTime );

	if( VSize(MyNP.Velocity) > 10.0f )
	{
		bNewPlayingDragFwd = TRUE;
		MyNP.Velocity *= PercentageOfMaxSpeedWhileDragging;
	}
	else
	{
		bNewPlayingDragFwd = FALSE;
	}


	if( bNewPlayingDragFwd != bPlayingDragFwd )
	{
		if( bNewPlayingDragFwd == TRUE )
		{
			MyNP.FullBodySlot.PlayCustomAnim( DragMovingAnim, GetSpeedModifier(), 0.2f, -1.f, TRUE, TRUE );
			Follower.FullBodySlot.PlayCustomAnim( VictimDragMovingAnim, GetSpeedModifier(), 0.2f, -1.f, TRUE, TRUE );

			DragStartAudio();
		}
		else
		{
			MyNP.FullBodySlot.PlayCustomAnim( DragIdleAnim, GetSpeedModifier(), 0.2f, -1.f, TRUE, TRUE );
			Follower.FullBodySlot.PlayCustomAnim( VictimDragIdleAnim, GetSpeedModifier(), 0.2f, -1.f, TRUE, TRUE );

			DragStopAudio();
		}

		// set our persistent var
		bPlayingDragFwd = bNewPlayingDragFwd;
	}


}




defaultproperties
{
	FollowerSpecialMoveName="NSM_DBNO_DragVictim"

	AttackerGrabSuccessStartAnim=""
	AttackerGrabSuccessLoopAnim="CTRL_Drag_Idle"
	AttackerGrabReleaseAnim=""
	AttackerGrabEscapeAnim=""

	DragMovingAnim="CTRL_Drag_Fwd"
	DragIdleAnim="CTRL_Drag_Idle"

	VictimDragMovingAnim="DBNO_Drag_Fwd"
	VictimDragIdleAnim="DBNO_Drag_Idle"

	SeqEvtClassToFire_OnStart=class'SeqEvt_NanoPawn_DBNO_Drag'
}
