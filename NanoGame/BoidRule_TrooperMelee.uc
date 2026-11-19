/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class BoidRule_TrooperMelee extends BoidMovementRule within NanoAI_Trooper
	native(AI)
	config(AI);

struct native RangeDatum
{
	/** Near/Far distance when actively attacking target */
	var config Vector2d AttackingRange;
	/** Near/Far distance when actively engaging target */
	var config Vector2d EngagedRange;
	/** Near/Far distance when waiting for turn to engage target */
	var config Vector2d StandbyRange;
	/** Near/Far distance when waiting for turn to spectate the battle. */
	var config Vector2d SpectatorRange;

	/** How far away an AI must maintain from their teammates **/
	var config float Attacking_NearTeammateDistance;
	var config float Engaged_NearTeammateDistance;
	var config float Standby_NearTeammateDistance;
	var config float Spectator_NearTeammateDistance;

};

var config array<RangeDatum> EngageRanges;


/** AI was outside/inside current range last frame */
var transient bool bWasOutsideRange;
var transient bool bWasInsideRange;

/** Considered outside camera if wasn't previously outside camera and dot product is less than this */
var config float OutsideCameraThreshold;
/** Considered outside camera if was previously outside camera and dot product is less than this */
var config float StillOutsideCameraThreshold;
/** Delay outside camera adjustment time */
var config float DelayOutsideCameraAdjustTime;

var transient bool bWasOutsideCamera;
var transient float LastTimeInsideCamera;




cpptext
{
	virtual void ModifyPawnVelocity( ANanoPawnBase* P, FLOAT DeltaTime );
}




native function Vector2D GetRangeFromTarget( NanoAI_Trooper AI, optional bool bCheckInsideOutside ) const;

native function float GetRangeFromTeammates( NanoAI_Trooper AI ) const;


function DrawDebugInfo( NanoHUD_Base H )
{
	local NanoGRI NGRI;
	local int CurrChaosTier;

	NGRI = NanoGRI(WorldInfo.GRI);
	CurrChaosTier = NGRI.AIBlackboard.CachedCurrChaosTier;

	DrawDebugCylinder( FireTarget.GetTargetedLocation(), FireTarget.GetTargetedLocation(), EngageRanges[CurrChaosTier].EngagedRange.X, 10, 255, 0, 0 );
	DrawDebugCylinder( FireTarget.GetTargetedLocation(), FireTarget.GetTargetedLocation(), EngageRanges[CurrChaosTier].EngagedRange.Y, 10, 255, 0, 0 );

	DrawDebugCylinder( FireTarget.GetTargetedLocation(), FireTarget.GetTargetedLocation(), EngageRanges[CurrChaosTier].StandbyRange.X, 10, 0, 0, 255 );
	DrawDebugCylinder( FireTarget.GetTargetedLocation(), FireTarget.GetTargetedLocation(), EngageRanges[CurrChaosTier].StandbyRange.Y, 10, 0, 0, 255 );
}

defaultproperties
{
}