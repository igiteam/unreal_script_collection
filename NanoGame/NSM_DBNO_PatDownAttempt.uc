/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_DBNO_PatDownAttempt extends NSM_DBNO_InteractionAttemptBase;


/**
 * Can a new special move override this one before it is finished?
 * This is only if CanDoSpecialMove() == TRUE && !bForce when starting it.
 */
function bool CanOverrideMoveWith( Name NewMove )
{
	if( NewMove == 'NSM_DBNO_PatDownEnemy' )
	{
		return TRUE;
	}

	if( NewMove == 'NSM_Melee_HitReaction' )
	{
		//`log( GetFuncName() @ "HitReaction!!" );
		return TRUE;
	}


	//`log( GetFuncName() @ `showvar(NewMove) );

	return FALSE;
}





defaultproperties
{
	AttackerGrabAttemptAnim="GrabAndBeat_Offense_Start"
	SpecialMoveEnemyToDo="NSM_DBNO_PatDownEnemy"
}
