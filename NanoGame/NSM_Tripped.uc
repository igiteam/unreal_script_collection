/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_Tripped extends NSM_PlaySingleAnim_Base;

/** How long the trip should last. **/
var config float TripDuration;

var transient float TimeTripped;


function SpecialMoveStarted( bool bForced, Name PrevMove )
{
	Super.SpecialMoveStarted( bForced, PrevMove );

	TimeTripped = MyNP.WorldInfo.TimeSeconds;
}




function EndThisSpecialMove()
{
	// do not end the special move when the anim ends
}


function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	if( `TimeSinceEx( MyNP, TimeTripped) > TripDuration )
	{
		// so we are paused in the correct anim on the ground until this triggers then we EndSpecialMove
		MyNP.EndSpecialMove();
	}
}



DefaultProperties
{
	AnimName="NW_Sprint_Fwd_Jump_Land_Injured"
	// 0.72f is the point before the anim stands up
	EndTime=0.72f 

	bDisableMovement=TRUE
	RootMotionScaleFactor=0.0f

}
