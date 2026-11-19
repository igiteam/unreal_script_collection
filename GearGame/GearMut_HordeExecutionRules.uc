/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearMut_HordeExecutionRules extends GearHordeExtendedMutator;

function bool CheckReplacement(Actor Other)
{
	local GearPawn GP;

	// make them always go DBNO if they are able
	GP = GearPawn(Other);
	if (GP != None)
	{
		GP.LocustChanceToDBNO = 1.0;
	}
	return true;
}

function bool CanRangeKillDBNO(bool bGameResult, Pawn TestPawn, Pawn InstigatedBy, class<GearDamageType> TheDamageType)
{
	if (TestPawn.GetTeamNum() == 1 && !TheDamageType.static.ShouldIgnoreExecutionRules(TestPawn, InstigatedBy))
	{
		bGameResult = false;
	}
	return Super.CanRangeKillDBNO(bGameResult, TestPawn, InstigatedBy, TheDamageType);
}

function bool AutoReviveOnBleedOut(Pawn TestPawn)
{
	return true;
}

defaultproperties
{
	MutatorIcon=Texture2D'Warfare_HUD.Horde_Enemies'
	ShowMultiplier=false
}