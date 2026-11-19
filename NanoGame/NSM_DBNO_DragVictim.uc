/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_DBNO_DragVictim extends NSM_DBNO_InteractionVictimBase;


/**
 * Can a new special move override this one before it is finished?
 * This is only if CanDoSpecialMove() == TRUE && !bForce when starting it.
 */
function bool CanOverrideMoveWith( Name NewMove )
{
	if( NewMove == 'NSM_DBNO_Drag_ThrowFromLedge_Victim' )
	{
		return TRUE;
	}

	//`log( GetFuncName() @ `showvar(NewMove) );

	return FALSE;
}




function SpecialMoveStarted( bool bForced, Name PrevMove )
{
	local Vector RelLoc;

	Super(NanoSpecialMove).SpecialMoveStarted( bForced, PrevMove );

	MyNP.StopFiring();
	MyNP.ZeroMovementVariables();

	MyNP.SetPhysics( PHYS_None );
	MyNP.SetRotation( MyNP.InteractionPawn.Rotation - rot(0,0,0) );
	MyNP.SetDesiredRotation( MyNP.InteractionPawn.Rotation - rot(0,0,0));
	MyNP.SetHardAttach( TRUE );
	MyNP.SetBase( MyNP.InteractionPawn,, MyNP.InteractionPawn.Mesh, 'b_MF_Attach' );

	RelLoc = MyNP.Location - MyNP.Mesh.GetBoneLocation( 'b_MF_Root' );
	MyNP.SetRelativeLocation( RelLoc );

	PlayGrabbedAnimation();
}

// we don't want to play any of the "ending" animations and other code when we end the special move so go back to DBNO if we end this
function SpecialMoveEnded( Name PrevMove, Name NextMove )
{
	MyNP.PendingSpecialMoveStruct = MyNP.FillSpecialMoveStructFromParams( 'NSM_DBNO' );
}


defaultproperties
{
	VictimGrabSuccessStartAnim=""
	VictimGrabSuccessLoopAnim="DBNO_Drag_Idle"
	VictimGrabReleaseAnim=""
	VictimGrabEscapeAnim=""
}
