/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
/** base class for mutators requiring Gears-specific hooks */
class GearMutator extends Mutator
	config(Game)
	abstract;

/** percent bonus (or penalty, if negative) XP to grant when using this mutator in Campaign modes */
var config float SPXPBonusPercent;

/** The localized name of this mutator  */
var localized string MutatorName;

/** The localized string for the descriptive info for this mutator  */
var localized string MutatorInfo;

/** The path to the icon that represents this mutator  */
var config string IconPath;

/** The name of the award required to play with this mutator */
var config string UnlockAwardName;

/** utility to get the next GearMutator in the mutator list, for hooks that aren't in the base engine */
function GearMutator GetNextGearMutator()
{
	local Mutator M;
	local GearMutator GMut;

	for (M = NextMutator; M != None; M = M.NextMutator)
	{
		GMut = GearMutator(M);
		if (GMut != None)
		{
			return GMut;
		}
	}

	return None;
}

/** hook to modify the AI's enemy distance thresholds */
function ModifyAIEnemyDistances(GearAI AI)
{
	local GearMutator GMut;

	GMut = GetNextGearMutator();
	if (GMut != None)
	{
		GMut.ModifyAIEnemyDistances(AI);
	}
}

/** allows mutators to force execution rules
 * ONLY CALLED FOR SP
 * @param bGameResult - the GameInfo's default ruling
 * @return whether the given Pawn can be killed from afar while DBNO
 */
function bool CanRangeKillDBNO(bool bGameResult, Pawn TestPawn, Pawn InstigatedBy, class<GearDamageType> TheDamageType)
{
	local GearMutator GMut;

	GMut = GetNextGearMutator();
	return (GMut == None) ? bGameResult : GMut.CanRangeKillDBNO(bGameResult, TestPawn, InstigatedBy, TheDamageType);
}

/** allows mutators to force revive on bleedout
 * ONLY CALLED FOR SP
 * @return whether to force the pawn to revive on bleedout
 */
function bool AutoReviveOnBleedOut(Pawn TestPawn)
{
	local GearMutator GMut;

	GMut = GetNextGearMutator();
	return (GMut != None && GMut.AutoReviveOnBleedOut(TestPawn));
}

/** allows mutator to force health recharge on the given Pawn
 * @param bGameResult - the GameInfo's default ruling
 * @return whether the given Pawn can recharge health
 */
function bool AllowHealthRecharge(bool bGameResult, GearPawn Pawn)
{
	local GearMutator GMut;

	GMut = GetNextGearMutator();
	return (GMut == None) ? bGameResult : GMut.AllowHealthRecharge(bGameResult, Pawn);
}

/** allows mutators to override/add on to the scoring system for dying
 * @return whether the behavior was overridden; i.e, if we return true here don't execute the default handling
 */
function bool OverrideDeathScoring(GearPRI KillerPRI, GearPRI DeadPRI, class<GearDamageType> KillType, EGearDeathType DeathType, optional int AdditionalPts)
{
	local GearMutator GMut;

	GMut = GetNextGearMutator();
	return (GMut != None && GMut.OverrideDeathScoring(KillerPRI, DeadPRI, KillType, DeathType, AdditionalPts));
}
