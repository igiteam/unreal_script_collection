/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearHordeObjective_Chainsaw extends GearHordeObjective_Executions;

static function bool CanBeSelected(GearGameHorde_Base InGame)
{
	local int i;
	local Pawn P;

	// don't allow if no one has either lancer
	for (i = 0; i < InGame.Teams[0].TeamMembers.length; i++)
	{
		P = InGame.Teams[0].TeamMembers[i].Pawn;
		if (P != None && (P.FindInventoryType(class'GearWeap_AssaultRifle', true) != None || P.FindInventoryType(class'GearWeap_RetroLancer', true) != None))
		{
			return true;
		}
	}

	return false;
}

function bool IsValidDamageType(class<DamageType> DamageType)
{
	return (DamageType == class'GDT_Chainsaw' || DamageType == class'GDT_Bayonet');
}
