/**
 * version of AIReactCond_EnemyCanBeMeleed modified for MP bot tactics
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AIReactCond_EnemyCanBeMeleed_MP extends AIReactCond_EnemyCanBeMeleed;

function bool ShouldMeleeCharge(Actor EventInstigator, float RangeToEnemy)
{
	local GearPawn GP;
	local float Chance;
	local GearPRI PRI;
	local GearGRI GRI;
	local int i;

	// never charge if we are the leader, since we are too important for that sort of thing
	PRI = GearPRI(PlayerReplicationInfo);
	if (PRI.bIsLeader)
	{
		return false;
	}
	GP = GearPawn(EventInstigator);
	if (GP == None)
	{
		return false;
	}
	// use default implementation when attacking human on Casual (which makes sure human can see enemy coming at him, etc)
	if (GP.IsHumanControlled() && PRI.Difficulty.default.DifficultyLevel == DL_Casual)
	{
		return Super.ShouldMeleeCharge(EventInstigator, RangeToEnemy);
	}
	// don't charge if we're being shot at
	if (WorldInfo.TimeSeconds - LastShotAtTime < 2.0)
	{
		return false;
	}
	// otherwise, scale our chance value by range to enemy, and roll the dice
	Chance = ChanceToMeleeMin + (ChanceToMeleeMax - ChanceToMeleeMin) * (1.0 - FClamp(RangeToEnemy / EnemyDistance_MeleeCharge, 0.0, 1.0));
	// double chance to charge if enemy is holding a meatbag, since we'll have a hard time killing him any other way
	if (GP.IsAKidnapper())
	{
		Chance *= 2.0;
	}
	if (FRand() < Chance)
	{
		// if they're knocked down, definitely yes because they can't resist us
		if (GP.Physics == PHYS_RigidBody)
		{
			return true;
		}
		// allow regardless of the rest if enemy is inside smoke volume so our charge would be obscured
		GRI = GearGRI(WorldInfo.GRI);
		for (i = 0; i < GRI.TargetingBlockingVolumes.length; i++)
		{
			if (PointCheckComponent(GRI.TargetingBlockingVolumes[i].CollisionComponent, GP.Location, GP.GetCollisionExtent()))
			{
				return true;
			}
		}
		// don't charge unless enemy has his back turned
		return ( (vector(GP.GetViewRotation()) dot Normal(GP.Location - MyGearPawn.Location)) > VisibleDotThresh &&
			FastTrace(GP.Location, MyGearPawn.GetPawnViewLocation()) );
	}
	else
	{
		return false;
	}
}

defaultproperties
{
	VisibleDotThresh=0.0
}
