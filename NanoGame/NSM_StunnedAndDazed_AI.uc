/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_StunnedAndDazed_AI extends NSM_StunnedAndDazed;


function SpecialMoveStarted( bool bForced, Name PrevMove )
{
	Super.SpecialMoveStarted( bForced, PrevMove );

	// we are assuming there is a HitReaction on the pawn that this was triggered from
	// if for some reason there was not, just use the default Duration.
	if( MyNP.HitReaction.PostHitReactionStunTime != 0.0f )
	{
		Duration = MyNP.HitReaction.PostHitReactionStunTime;
	}

	if( MyNP.HitReaction.PostHitReactionStunAnimName != '' )
	{
		AnimName = MyNP.HitReaction.PostHitReactionStunAnimName;
	}

	//`log( `showvar(Duration) @ `showvar(MyNP.HitReaction.PostHitReactionStunTime) );
}


function SpecialMoveEnded( Name PrevMove, Name NextMove )
{
	Super.SpecialMoveEnded( PrevMove, NextMove );

	MyNP.DoSpecialMove( 'NSM_ShakeItOff', TRUE );
}





DefaultProperties
{
	AnimName="Dizzy_Loop"
	bLooping=TRUE
	EndTime=0.0f

	bDisableMovement=TRUE
	RootMotionScaleFactor=0.0f
}
