/**
 *
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */
class TMDecalManager extends DecalManager;

function bool CanSpawnDecals()
{
	return (!class'Engine'.static.IsSplitScreen() && Super.CanSpawnDecals());
}

