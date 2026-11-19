/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class BoidRule_TrooperRanged extends BoidMovementRule within NanoAI
	native(AI);


/** Distances for how far away to stand from a foe when using this boid rule **/
var float MaxDistanceToStandFromFoe;
var float MinDistanceToStandFromFoe;


/** Variables for determining of the Pawn has been standing around the same area for a while.  If they have been we will make them move. **/
var transient Vector LastLocationBeforeMove;
var float RadiusFromLastLocationToForceMove;
var transient float LastLocationBeforeMoveTime;
var float TimeAllowedToStandStill;

var float DistanceToTryAndStayAwayFromTeammates;

/** 
 *  So for guys with shields it is pretty cool to see them clumped together / with their friends providing cover / covering fire
 * so allow them to be a little closer  
 **/
var float DistanceToTryAndStayAwayFromTeammatesWhenUsingAShield;

cpptext
{
	virtual void ModifyPawnVelocity( ANanoPawnBase* P, FLOAT DeltaTime );
}



defaultproperties
{
	MaxDistanceToStandFromFoe=2048.0f
	MinDistanceToStandFromFoe=512.0f

	RadiusFromLastLocationToForceMove=128.0f
	TimeAllowedToStandStill=3.0f

	DistanceToTryAndStayAwayFromTeammates=256.0f
	DistanceToTryAndStayAwayFromTeammatesWhenUsingAShield=128.0f
}