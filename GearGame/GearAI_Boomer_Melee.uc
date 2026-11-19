/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearAI_Boomer_Melee extends GearAI_Boomer;

/** Next time AI is allowed to move */
var	float	AllowedMoveTime;
/** Amount of damage Boomer will take before pausing movement */
var int		PauseDamageThreshold;

var AIReactCond_DmgThreshold PauseThresh;

event Possess(Pawn NewPawn, bool bVehicleTransition)
{
	Super.Possess( NewPawn, bVehicleTransition );

	PauseThresh = new(self) class'AIReactCond_DmgThreshold';
	PauseThresh.DamageThreshold = PauseDamageThreshold;
	PauseThresh.OutputFunction = PauseFromDamage;
	PauseThresh.Initialize();
}
function FireFromOpen(optional int InBursts = 1, optional bool bAllowFireWhileMoving=true);

function PauseFromDamage(Actor EventInstigator, AIReactChannel OrigChannel)
{
	// If not within melee or below 50% health
	if(!bDoingMeleeAttack && GetHealthPercentage() >= 0.50f )
	{
		// Update the next time we are free to move toward enemy
		AllowedMoveTime = WorldInfo.TimeSeconds + 3.f;
	}
}

final function bool ShouldCharge()
{
	local GearPawn EnemyGP;

	// Don't charge if we were hit recently
	if (WorldInfo.TimeSeconds < AllowedMoveTime)
	{
		return FALSE;
	}

	// Charge if enemy is in close range
	if( IsShortRange(Enemy.Location) )
	{
		return TRUE;
	}

	// Charge if health is low
	if( GetHealthPercentage() < 0.50f )
	{
		return TRUE;
	}

	if( !IsUnderHeavyFire() )
	{
		EnemyGP = GearPawn(Enemy);
		return (EnemyGP != None && EnemyGP.IsReloadingWeapon());
	}

	return FALSE;
}

function bool ShouldRoadieRun()
{
	if( bShouldRoadieRun && !MyGearPawn.bIsWalking && WorldInfo.TimeSeconds >= AllowedMoveTime)
	{
		return TRUE;
	}
	return FALSE;
}

function float GetMoveTimeOutDuration(vector dest, bool bDontCare)
{
	return 2.f;
}

defaultproperties
{
	DefaultCommand=class'AICmd_Base_Boomer_Melee'	
	PauseDamageThreshold=40

	bPreferMelee=TRUE
}
