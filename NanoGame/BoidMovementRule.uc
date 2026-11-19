/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class BoidMovementRule extends Object within NanoAI
	abstract
	native(AI)
	config(AI);

/** Rule is enabled or not */
var transient bool bActive;


/** This is how far we want to move before we stop the custom anim if there is one on our pawn. **/
var config float StopCustomAnimDelta;


/** Enemy location as of last update */
var transient vector LastEnemyLocation;
/** Min amount of distance the enemy location needs to change before considering an update */
var config float MinEnemyLocationChangeToUpdate;

/** We set this when we want the AI to move close to the player (e.g. grab / charge attacks )**/
var bool bUseMinEnemyLocationChangeToUpdate;


/**
 * When the AI is close to a border of ranges / or close to a target.  Then the boids will want to make 
 * small adjustments to have the pawn(boid) match at close as possible to where it "should be".
 * Thos small movements make the pawn play an animation which makes him look like he is on meth.
 * To actually move we need to have a movement that is larger than this delta.
 **/
var config float AntiTwitchDelta;
var config float AntiTwitchDistance;


var config bool bAvoidTeammates;


cpptext
{
	virtual void ModifyPawnVelocity( ANanoPawnBase* P, FLOAT DeltaTime ) {}
	virtual UBOOL IsActive( ANanoPawnBase* P ) { return bActive; }
}

static function bool AddRule( NanoAI AI, optional bool bStartActive = TRUE )
{
	local BoidMovementRule Rule;

	if( AI != None )
	{
		Rule = new(AI) Default.Class;
		if( Rule != None )
		{
			Rule.bActive = bStartActive;
			AI.BoidRules[AI.BoidRules.Length] = Rule;
			return TRUE;
		}
	}
	return FALSE;
}

function SetActive( bool bSet )
{
	bActive = bSet;
}

function DrawDebugInfo( NanoHUD_Base H );

defaultproperties
{
	bUseMinEnemyLocationChangeToUpdate=TRUE
}