/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_Trooper_IdleBreak extends NSM_PlaySingleAnim_Base
	abstract;

/** List of anims that the pawn can play for waiting to attack or other assundry things **/
var array<Name> WaitingToAttackAnimList;


protected function bool InternalCanDoSpecialMove()
{
	return TRUE;
}

function SpecialMoveStarted( bool bForced, Name PrevMove )
{
	Super.SpecialMoveStarted( bForced, PrevMove );

	MyNP.StopFiring();
	MyNP.ZeroMovementVariables();
}

function SpecialMoveEnded( Name PrevMove, Name NextMove )
{
	Super.SpecialMoveEnded( PrevMove, NextMove );
}

function Name GetAnimName()
{
	return ChooseWaitingToAttackAnim();
}

function Name ChooseWaitingToAttackAnim()
{
	if( MyAI.OverrideAnimNameToPlay != '' ) // this was broken when it was refactored
	{
		return MyAI.OverrideAnimNameToPlay;
	}
	else
	{
		return WaitingToAttackAnimList[ Rand(WaitingToAttackAnimList.Length) ];
	}
}

defaultproperties
{

}

