/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearAI_SiegeCOG_Sam extends GearAI_SiegeCOG;

function bool WantsToThrowGrenade(GearWeap_GrenadeBase GrenadeWeap)
{
	// Sam is much more aggressive with her grenades
	return (`TimeSince(LastGrenadeTime) > GrenadeWeap.AI_TimeTweenGrenade * 0.5 && IsAtCover());
}
