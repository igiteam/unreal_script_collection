/**
 * Interface_AIVehicleWeaponTarget
 * Used to indicate that an actor (not necessarily a pawn) is a valid target for an AI in a vehicle turret
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
interface Interface_AIVehicleWeaponTarget;

/** Returns a base AI rating for this target */
function float GetVehicleWeaponAIRating();