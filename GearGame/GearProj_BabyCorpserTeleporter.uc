
/**
 * GearProj_BabyCorpserTeleporter
 *
 * Projectile doing a bugs bunny trail,
 * but also testing world to find a safe spot to teleport corpser.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearProj_BabyCorpserTeleporter extends GearProj_BabyCorpserUndergroundBase
	native(Weapon);

/** Flag to check if the Corpser can emerge */
var transient bool bCheckForEmergence;

cpptext
{
protected:
	virtual UBOOL InternalDoTraces();
};

/** This is called when we failed to find a spot for the Corpser to emerge */
simulated protected function ExitGroundAndExplode()
{
	Super.ExitGroundAndExplode();

	// If we failed, just come out from our last safe location
	CorpserPawn.FoundSpotToEmerge(CorpserPawn.Location, CorpserPawn.Rotation);

	// Kill in one second.
	LifeSpan = 1.f;
	SetPhysics(PHYS_None);
}

/**
 *  Deny if in a volume that prevents Baby Corpser from moving to it.
 *  @return TRUE if next trace location is valid, FALSE otherwise.
 */
simulated event bool ValidateNextTraceLocation()
{
	return Super.ValidateNextTraceLocation()
		&& class'GearPawn_LocustCorpserLarvaUndergroundBase'.static.IsLocationBabyCorpserSafe(WorldInfo, LastTraceResultLoc);
}

event FoundSpotForCorpserToEmerge(vector EmergeLocation, rotator EmergeRotation)
{
	// Tell the good news to the Corpser!
	CorpserPawn.FoundSpotToEmerge(EmergeLocation, EmergeRotation);
}

/**
 * Just keep moving until we can emerge.
 */
protected function bool PawnDistanceCheck(Pawn InPawn, vector ToPawn, float Dist2D)
{
	// Favor coming out close to an enemy, so it is impressive
	// Also enforce digging underground for at least a little bit of time, so we can see the effects.
	if (VSize(Location - InPawn.Location) < EnemyAutoEmergeRadius && Lifespan <= (default.LifeSpan - 1.0))
	{
		bCheckForEmergence = true;
	}

	return false;
}

protected function ProcessBestSteeringTarget(Pawn BestPawn, float DeltaTime)
{
	// If no one around, emerge after 4 seconds so we don't dig too long.
	if (BestPawn == None && Lifespan <= (default.LifeSpan - 4.0))
	{
		bCheckForEmergence = true;
	}

	Super.ProcessBestSteeringTarget(BestPawn, DeltaTime);
}

defaultproperties
{
	EnemyAutoEmergeRadius=640
}
