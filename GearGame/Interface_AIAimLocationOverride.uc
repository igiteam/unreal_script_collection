/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
interface Interface_AIAimLocationOverride;

/**
 * Gives Aawn an opportunity to override the AI's default targeting scheme for
 * visible enemies for example, if only a specific area is vulnerable
 *
 * @param AimLoc (out) - the location to aim
 * @param StartLoc - starting location of weapons fire
 * @param ShooterAI - the AI that wants to shoot at this actor
 * @return - true if we are going to override the aim location
 */
function bool OverrideAimLocation(out vector AimLoc, vector StartLoc, GearAI ShooterAI);
