/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
/** makes all one hit melee cause instant, gib-explosion death */
class GearMut_InstagibMelee extends GearMutator;

function bool CheckReplacement(Actor Other)
{
	local GearWeapon W;
	local GearPawn P;

	W = GearWeapon(Other);
	if (W != None)
	{
		W.InstantHitDamageTypes[class'GearWeapon'.const.MELEE_ATTACK_FIREMODE] = class'GDT_InstagibMelee';
		W.ShieldBashDamageType = class'GDT_InstagibMelee';
		W.MeleeKickDamageType = class'GDT_InstagibMelee';
	}
	else
	{
		P = GearPawn(Other);
		if (P != None && P.SpecialMoveClasses[SM_MantleKick] == class'GSM_MantleKick')
		{
			P.SpecialMoveClasses[SM_MantleKick] = class'GSM_MantleKick_InstagibMelee';
		}
	}

	return true;
}
