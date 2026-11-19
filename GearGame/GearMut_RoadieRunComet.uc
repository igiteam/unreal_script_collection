/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearMut_RoadieRunComet extends GearMutator;

function ModifyPlayer(Pawn Other)
{
	if (GearPawn(Other) != None && Other.IsHumanControlled())
	{
		GearPawn(Other).ActivateRoadieRunComet();
	}

	Super.ModifyPlayer(Other);
}
