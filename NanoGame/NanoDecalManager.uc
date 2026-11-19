/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoDecalManager extends DecalManager
	native;


/** abort spawning a new decal if it would be this distance or closer to any currently active decal */
var float MinDecalDistanceSq;


/** @return whether the specified location is too close to a decal that's already attached, so don't spawn a new one */
native final function bool IsTooCloseToActiveDecal( const out vector DecalLocation, const float InCanSpawnDistance );

/** gets a pooled decal with minimal setup - assumes the caller is going to take care of most of that itself */
final function NanoDecal SpawnDecalMinimal( const out vector DecalLocation, const float InDecalLifeSpan, const float InCanSpawnDistance )
{
	local NanoDecal Result;
	local ActiveDecalInfo DecalInfo;

	if( IsTooCloseToActiveDecal( DecalLocation, InCanSpawnDistance ) == FALSE )
	{
		Result = NanoDecal(GetPooledComponent());
		Result.Location = DecalLocation;
		if( Result.MITV_Decal == none )
		{
			Result.MITV_Decal = new(Result) class'MaterialInstanceTimeVarying';
		}

		// add to list to tick lifetime
		DecalInfo.Decal = Result;
		DecalInfo.LifetimeRemaining = InDecalLifeSpan;
		ActiveDecals.AddItem( DecalInfo );
	}

	return Result;
}

defaultproperties
{
	Begin Object Class=NanoDecal Name=BaseNanoDecal
	End Object
	DecalTemplate=BaseNanoDecal

}