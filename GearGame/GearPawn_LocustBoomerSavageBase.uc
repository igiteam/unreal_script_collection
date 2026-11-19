/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 *
 */
class GearPawn_LocustBoomerSavageBase extends GearPawn_LocustBoomerBase
	abstract
	config(Pawn);

/** Only play telegraph half of the time */
var() protected const float TelegraphChance;

var protected const array<AnimSet> SavageAnimSets;

/** Attack telegraphs if we're holding a regular boomshot */
var protected const array<SoundCue>		BoomerAttackTelegraphDialogue_Boomshot;


/** Overloaded so we can remove the savage animset if he is about to equip the boomshot */
simulated function EquipingWeaponNotify(GearWeapon EquipWeapon)
{
	Super.EquipingWeaponNotify(EquipWeapon);

	// set animsets
	if (EquipWeapon.IsA('GearWeap_DiggerLauncher'))
	{
		AddLocalCustomAnimSets(SavageAnimSets);
	}
	else
	{
		RemoveLocalCustomAnimSets(SavageAnimSets);
	}

	// set correct telegraph audio
	if (EquipWeapon.IsA('GearWeap_BoomshotBase'))
	{
		BoomerAttackTelegraphDialogue = BoomerAttackTelegraphDialogue_Boomshot;
	}
	else
	{
		BoomerAttackTelegraphDialogue = default.BoomerAttackTelegraphDialogue;
	}
}

/**
 * Overloaded so we can dynamically decide whether we want the savage animset or not
 * based on whether we're equipped with the digger launcher
 */
simulated function BuildScriptAnimSetList()
{
	Super.BuildScriptAnimSetList();

	// Add the non-replicated custom animsets
	if (CustomAnimSets.length > 0)
	{
		AddAnimSets(CustomAnimSets);
	}
}

/** Swap lines with the boomer if we've been given the boomshot */
function TelegraphAttack()
{
	if (GearAI(Controller) == None || FRand() <= TelegraphChance)
	{
		Super.TelegraphAttack();
	}
}

defaultproperties
{

}
