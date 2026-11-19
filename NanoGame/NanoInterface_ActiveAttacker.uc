/**
 * Interface for actors that consume attack slots when engaging a target 
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
interface NanoInterface_ActiveAttacker extends Interface
	native;

/** Get the number of attack slots this attacker consumes */
function int GetActiveAttackSlots();

/** Notify the attacker that the target they were engaging is available */
function bool NotifyActiveAttackAvailable(NanoPawnBase AvailableTarget);

/** If this actor is allowed to attack current target */
function bool AllowedToActivelyAttackTarget();

/** Get a rating for this attacker */
function float RateAttacker( NanoPawnBase Targ, optional bool bSkipRandom );

/** Register/unregister functions */
function RegisterAsAttacker();
function UnregisterAsAttacker();
function RegisterAsActiveAttacker();
function UnregisterAsActiveAttacker();

/** This determines if this attacker is pushing forward to make the player respond / move **/
function bool IsPushingForward();

/** Returns attacker actor */
event Actor GetAttackActor();