/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearMut_BigHead extends GearMutator
	config(Game);

var config float HeadScale;

function bool CheckReplacement(Actor Other)
{
	if (Other.IsA('GearPawn'))
	{
		GearPawn(Other).SetHeadScale(HeadScale);
	}
	return true;
}
