/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearDecalManager extends DecalManager
	native;

/** alternative lower values for MaxDecals during poor performance */
var int MaxDecals_DropDetail, MaxDecals_AggressiveLOD;
/** abort spawning a new decal if it would be this distance or closer to any currently active decal */
var float MinDecalDistanceSq;

cpptext
{
	virtual void TickSpecial(FLOAT DeltaTime);
}

protected function DecalComponent GetPooledComponent()
{
	local int i;
	local DecalComponent Result;

	// try to grab one from the pool
	// skip if we lowered the MaxActiveDecals and we already have too many active
	if (MaxActiveDecals <= 0 || ActiveDecals.length < MaxActiveDecals)
	{
		while (PoolDecals.length > 0)
		{
			i = PoolDecals.length - 1;
			Result = PoolDecals[i];
			PoolDecals.Remove(i, 1);
			if (Result != None && !Result.IsPendingKill())
			{
				break;
			}
			else
			{
				Result = None;
			}
		}
	}

	if (Result == None)
	{
		if (MaxActiveDecals > 0 && ActiveDecals.length >= MaxActiveDecals)
		{
			// overwrite oldest decal
			Result = ActiveDecals[0].Decal;
			Result.ResetToDefaults();
			ActiveDecals.Remove(0, 1);
		}
		else
		{
			Result = new(self) DecalTemplate.Class(DecalTemplate);
		}
	}

	return Result;
}

/** @return whether the specified location is too close to a decal that's already attached, so don't spawn a new one */
native final function bool TooCloseToActiveDecal(vector DecalLocation);

/** gets a pooled decal with minimal setup - assumes the caller is going to take care of most of that itself */
final function GearDecal SpawnDecalMinimal(vector DecalLocation, optional float InDecalLifeSpan = DecalLifeSpan, optional bool bForce)
{
	local GearDecal Result;
	local ActiveDecalInfo DecalInfo;

	if (bForce || !TooCloseToActiveDecal(DecalLocation))
	{
		Result = GearDecal(GetPooledComponent());
		Result.Location = DecalLocation;
		Result.MITV_Decal.SetDuration((InDecalLifeSpan > 0.0) ? InDecalLifeSpan : 10000000.0);

		// add to list to tick lifetime
		DecalInfo.Decal = Result;
		DecalInfo.LifetimeRemaining = InDecalLifeSpan;
		ActiveDecals.AddItem(DecalInfo);
	}

	return Result;
}

defaultproperties
{
	Begin Object Class=GearDecal Name=BaseGearDecal
	End Object
	DecalTemplate=BaseGearDecal

	MaxActiveDecals=200
	MaxDecals_DropDetail=150
	MaxDecals_AggressiveLOD=100
	MinDecalDistanceSq=25.0
}
