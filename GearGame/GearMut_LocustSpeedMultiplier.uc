/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearMut_LocustSpeedMultiplier extends GearHordeExtendedMutator;

function ModifyPlayer(Pawn Other)
{
	local GearAI AI;

	AI = GearAI(Other.Controller);
	if (AI != None && AI.GetTeamNum() == 1)
	{
		AI.BasicMovementMultiplier = Multiplier;
	}

	Super.ModifyPlayer(Other);
}

defaultproperties
{
	MutatorIcon=Texture2D'Warfare_HUD.Horde_Enemies'
}