/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_Melee_Counter extends NSM_PlaySingleAnim_Base;


/**
 * Can this special move override InMove if it is currently playing?
 */
function bool CanOverrideSpecialMove( Name InMove )
{
	return TRUE;
}


function SpecialMoveStarted( bool bForced, Name PrevMove )
{
	local rotator AttackerDesiredRotation;

	Super.SpecialMoveStarted( bForced, PrevMove );

	AttackerDesiredRotation = Rotator(MyNP.Location - MyNP.InteractionPawn.Location);

	// here we want to snap the victim's pawn to face the attacker so we can play the "correct" hit anim
	MyNP.SetDesiredRotation( AttackerDesiredRotation, FALSE, FALSE, 0.1f );
	// Immediately snap to desired rotation when attack starts (update in tick afterward)
	MyNP.SetRotation( AttackerDesiredRotation );
}


function SpecialMoveEnded( Name PrevMove, Name NextMove )
{
	Super.SpecialMoveEnded( PrevMove, NextMove );
}


defaultproperties
{
	AnimName="Attack_High_BDisarm"

	BlendInTime=0.1f
	BlendOutTime=0.1f

	bDisableMovement=TRUE
	bDisableAllBoids=TRUE
}