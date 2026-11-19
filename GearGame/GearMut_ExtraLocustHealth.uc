/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearMut_ExtraLocustHealth extends GearHordeExtendedMutator;

function ModifyPlayer(Pawn Other)
{
	local GearPawn GP;

	GP = GearPawn(Other);
	if (GP != None && GP.GetTeamNum() == 1)
	{
		GP.ScaleDefaultHealth(Multiplier, true);
	}

	Super.ModifyPlayer(Other);
}

defaultproperties
{
	MutatorIcon=Texture2D'Warfare_HUD.Horde_Health'
}
