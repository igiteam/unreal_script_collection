/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearMut_LocustRecharge extends GearMutator;

function bool AllowHealthRecharge(bool bGameResult, GearPawn Pawn)
{
	if (Pawn.GetTeamNum() == 1)
	{
		bGameResult = true;
	}
	return Super.AllowHealthRecharge(bGameResult, Pawn);
}
