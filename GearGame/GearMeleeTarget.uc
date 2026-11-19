
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearMeleeTarget extends Actor
	native
	abstract;

/** @return whether this object is currently valid for melee */
simulated function bool IsValidMeleeTarget(Pawn AskingPawn)
{
	return (bBlockActors || bProjTarget);
}
