/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearAI_Boomer_Shield extends GearAI_Boomer
	config(AI);

/** ground speed to apply to pawn when the shield is deployed */
var config float			ShieldOpenGroundSpeed;

/** Next time AI is allowed to move */
var	float	AllowedMoveTime;
/** Next time AI is alloewd to switch enemies because of damage */
var float	NextEnemySwitchTime;
/** Amount of damage Boomer will take before pausing movement */
var int		PauseDamageThreshold;

var AIReactCond_DmgThreshold PauseThresh;

function float GetFireDelay()
{
	// overridden to skip telegraph.  pawns handles it for mauler
	return 0.f;
}

event Possess(Pawn NewPawn, bool bVehicleTransition)
{
	Super.Possess( NewPawn, bVehicleTransition );

	PauseThresh = new(self) class'AIReactCond_DmgThreshold';
	PauseThresh.DamageThreshold = PauseDamageThreshold;
	PauseThresh.OutputFunction = PauseFromDamage;
	PauseThresh.Initialize();
}

function PauseFromDamage(Actor EventInstigator, AIReactChannel OrigChannel)
{
	//debug
	`AILog( GetFuncName()@EventInstigator@ShouldCharge()@Enemy@IsShortRange(Enemy.Location)@GetHealthPercentage()@IsUnderHeavyFire()@GearPawn(Enemy).IsReloadingWeapon() );

	// If not within melee + a bit or below 25% health, and we haven't paused recently
	if(!bDoingMeleeAttack && GetHealthPercentage() >= 0.25f)
	{
		// Only defend if we haven't recently defended, or they are far away
		if (WorldInfo.TimeSeconds > AllowedMoveTime + 2.0 || !IsShortRange(Enemy.Location))
		{		
			// Update the next time we are free to move toward enemy
			AllowedMoveTime = WorldInfo.TimeSeconds + 3.f;

			OpenShield( TRUE );
			StopFiring();
		}

		// If shot by a different enemy and we haven't switched recently
		if( EventInstigator != Enemy && WorldInfo.TimeSeconds > NextEnemySwitchTime )
		{
			// Update the enemy and the thrash timer
			NextEnemySwitchTime = WorldInfo.TimeSeconds + 1.f;
			SetEnemy( Pawn(EventInstigator) );
		}		
	}
}

final function bool ShouldCharge()
{
	// Don't charge if we raised shield recently
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
	if( GetHealthPercentage() < 0.25f )
	{
		return TRUE;
	}

	if( !IsUnderHeavyFire() )
	{
		return TRUE;
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

function DoMeleeAttack(optional Pawn NewEnemy, optional Actor InTarget)
{
	CloseShield();

	Super.DoMeleeAttack(NewEnemy, InTarget);
}

function float GetMoveTimeOutDuration(vector dest, bool bDontCare)
{
	return 2.f;
}

function OpenShield( optional bool bDoSpecialMove )
{
	MyGearPawn.OpenShield( TRUE, ShieldOpenGroundSpeed, bDoSpecialMove );
}

function CloseShield()
{
	MyGearPawn.CloseShield();
}

defaultproperties
{
	DefaultCommand=class'AICmd_Base_ShieldBoomer'
	AI_NearMissDistance=100.0

	PauseDamageThreshold=40
	bPreferMelee=TRUE
}
