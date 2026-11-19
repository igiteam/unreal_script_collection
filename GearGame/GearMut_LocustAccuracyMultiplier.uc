/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearMut_LocustAccuracyMultiplier extends GearHordeExtendedMutator;

function ModifyPlayer(Pawn Other)
{
	local GearAI AI;

	AI = GearAI(Other.Controller);
	if (AI != None && AI.GetTeamNum() == 1)
	{
		AI.BaseAimError = AI.default.BaseAimError * (1.0 / Multiplier);
	}

	Super.ModifyPlayer(Other);
}

defaultproperties
{
	MutatorIcon=Texture2D'Warfare_HUD.Horde_Enemies'
}
