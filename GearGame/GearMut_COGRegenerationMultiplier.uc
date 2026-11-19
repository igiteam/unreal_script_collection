/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearMut_COGRegenerationMultiplier extends GearHordeExtendedMutator;

function SetMultiplier(float InMultiplier)
{
	local GearPawn GP;

	Super.SetMultiplier(InMultiplier);

	foreach WorldInfo.AllPawns(class'GearPawn', GP)
	{
		if (GP.GetTeamNum() == 0)
		{
			GP.HealthRechargePercentPerSecond *= Multiplier;
		}
	}
}

function ModifyPlayer(Pawn Other)
{
	local GearPawn GP;

	GP = GearPawn(Other);
	if (GP != None && GP.GetTeamNum() == 0)
	{
		GP.HealthRechargePercentPerSecond *= Multiplier;
	}

	Super.ModifyPlayer(Other);
}

defaultproperties
{
	MutatorIcon=Texture2D'Warfare_HUD.Horde_Health'
}