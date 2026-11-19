/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_Melee_BreakOut extends NSM_PlaySingleAnim_Base;


/**
 * Can this special move override InMove if it is currently playing?
 */
function bool CanOverrideSpecialMove( Name InMove )
{
	return TRUE;
}


function SpecialMoveStarted( bool bForced, Name PrevMove )
{
	Super.SpecialMoveStarted( bForced, PrevMove );
}


function SpecialMoveEnded( Name PrevMove, Name NextMove )
{
	Super.SpecialMoveEnded( PrevMove, NextMove );
}


defaultproperties
{
	AnimName="Shield_Bash"

	BlendInTime=0.1f
	BlendOutTime=0.1f

	bDisableMovement=TRUE
	bDisableAllBoids=TRUE
}