/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearAI_Gunker extends GearAI_Boomer;

/** Reference to the second most important enemy (after Enemy) */
var Pawn OtherEnemy;

/** The distance delta that describes the range the Gunker can do the chop attack from the normal attack position */
var config float ChopRangeDelta;

/** The distance delta that describes the range the Gunker can do the short-ranged shoot attack from the normal attack position */
var config float ShootRangeDelta;

/** Min distance for doing the lob gunk attack */
var config float EnemyDistance_MinLobAttack;


/** Overloaded to use our special melee */
function DoMeleeAttack(optional Pawn NewEnemy, optional Actor InTarget);

/** Overloaded so we can determine the second most important enemy to be used when attacking more than one enemy at a time */
function bool SelectEnemy()
{
	local bool bResult;

	// Call the super first so the prioritized list has already been created
	bResult = Super.SelectEnemy();

	// Attempt to set the other enemy
	if (bResult == TRUE &&
		LocalEnemyList.length > 1 &&
		LocalEnemyList[1].Rating > -1)
	{
		OtherEnemy = LocalEnemyList[1].Pawn;
	}
	else
	{
		OtherEnemy = None;
	}

	return bResult;
}

/** True if performing any of the special attacks so that the current enemy isn't changed */
function bool IsFiringWeapon()
{
	local GearPawn_LocustGunkerBase GunkerPawn;

	GunkerPawn = GearPawn_LocustGunkerBase(Pawn);
	return (GunkerPawn != None &&
			(GunkerPawn.IsDoingSpecialMove(GSM_Gunker_MeleeFar) ||
			 GunkerPawn.IsDoingSpecialMove(GSM_Gunker_MeleeClose) ||
			 GunkerPawn.IsDoingSpecialMove(GSM_Gunker_Lob) ||
			 GunkerPawn.IsDoingSpecialMove(GSM_Gunker_Shoot)));
}

/** Overloaded to not go to banzai mode */
function BanzaiAttack()
{
	GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_TransToKamikazeAI, Pawn);
	AutoAcquireEnemy();
}

/** @return the location to hit with the far melee attack */
function vector GetEnemyLocationForFarMelee()
{
	return Enemy.Location;
}

defaultproperties
{
	DefaultCommand=class'AICmd_Base_Gunker'
}
