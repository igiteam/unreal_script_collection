
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearAI_SavageDroneUnderground extends GearAI
	config(AI);

/** Outer distance for roaming envelope */
var() config float RoamEnvelopeOuter;
/** Inner distance for roaming envelope */
var() config float RoamEnvelopeInner;
/** Maximum time to roam underground before spawning the pawns */
var() config float MaxRoamTime;

event Possess(Pawn inPawn, bool bVehicleTransition)
{
	Super.Possess(inPawn, bVehicleTransition);

	// Kick start AI, so it doesn't just sit there.
	AutoAcquireEnemy();
}

/** Never return to Idle, always stay in combat */
function bool ShouldReturnToIdle()
{
	return FALSE;
}

/** Never walk */
function bool ShouldAllowWalk()
{
	return FALSE;
}

/** Ignore Banzai behavior */
function BanzaiAttack();
/** No melee */
function DoMeleeAttack(optional Pawn NewEnemy, optional Actor InTarget);

defaultproperties
{
	DefaultCommand=class'AICmd_Base_SavageDroneUnderground'
 	DefaultReactConditions.Empty
 	DefaultReactConditionClasses.Empty

	bCanRevive=false
}
