/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_StunnedAndDazed extends NSM_PlaySingleAnim_Base;

/** How long the trip should last. **/
var config float Duration;

var transient float MoveStartTime;


/**
 * We want to have hit reactions be overrideable by other hit reactions.  So if you do a leg sweep you get the leg sweet anim
 * even if the foe is already doing a knockback anim.
 */
function bool CanOverrideMoveWith( Name NewMove )
{
	if( NewMove == 'NSM_Melee_HitReaction' )
	{
		return TRUE;
	}

	if( NewMove == 'NSM_ShakeItOff' )
	{
		return TRUE;
	}

	return Super.CanOverrideMoveWith( NewMove );
}


function SpecialMoveStarted( bool bForced, Name PrevMove )
{
	Super.SpecialMoveStarted( bForced, PrevMove );

	MoveStartTime = MyNP.WorldInfo.TimeSeconds;
}




function EndThisSpecialMove()
{
	// do not end the special move when the anim ends
}


function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	if( `TimeSinceEx( MyNP, MoveStartTime) > Duration )
	{
		// so we are paused in the correct anim on the ground until this triggers then we EndSpecialMove
		MyNP.EndSpecialMove();
	}
}



DefaultProperties
{
	AnimName="NW_Summon_SMG"
	// decent stopping point before the forge finishes
	EndTime=2.30f 

	bDisableMovement=TRUE
	RootMotionScaleFactor=0.0f

}
