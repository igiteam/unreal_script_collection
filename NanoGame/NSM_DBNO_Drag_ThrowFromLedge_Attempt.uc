/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_DBNO_Drag_ThrowFromLedge_Attempt extends NSM_DBNO_InteractionAttemptBase;


/**
 * Can a new special move override this one before it is finished?
 * This is only if CanDoSpecialMove() == TRUE && !bForce when starting it.
 */
function bool CanOverrideMoveWith( Name NewMove )
{
	//`log( GetFuncName() @ `showvar(NewMove) );

	return FALSE;
}



// just straight up do the special move
function PlayGrabAttemptAnimation()
{
	`log( `showvar(MyNP.InteractionPawn) );

	MyNP.DoSpecialMove( SpecialMoveEnemyToDo, TRUE, MyNP.InteractionPawn );

}


// override to do nothing
function CheckAbortGrabAttempt();



defaultproperties
{
	SpecialMoveEnemyToDo="NSM_DBNO_Drag_ThrowFromLedge_Enemy"
}
