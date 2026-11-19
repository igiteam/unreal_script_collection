/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearAI_SiegeCOG_Gus extends GearAI_SiegeCOG;

function NotifyWeaponFired(Weapon W, byte FireMode)
{
	Super.NotifyWeaponFired(W, FireMode);

	// cole yells whenever he fires
	if (GearPawn_COGGear(Pawn) != None)
	{
		GearPawn_COGGear(Pawn).AnnounceShot();
	}
}

defaultproperties
{
	// cole doesn't need vehicles, he's got a rocket launcher
	bCheckForVehicles=false
}
