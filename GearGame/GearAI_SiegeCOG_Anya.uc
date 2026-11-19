/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearAI_SiegeCOG_Anya extends GearAI_SiegeCOG;

event StartFiring(optional int InBurstsToFire = -1)
{
	Super.StartFiring(InBurstsToFire);

	SetTimer(0.25, true, nameof(CheckAnnounceShot));
}

function StopFiring()
{
	Super.StopFiring();

	ClearTimer(nameof(CheckAnnounceShot));
}

/** see if we're charging the mortar and if so, play a dialog line
 * should probably have a weapon callback when it starts charging, but it doesn't seem worth retrofitting all weapons for this right now
 */
function CheckAnnounceShot()
{
	if (MyGearPawn != None && IsFiringWeapon() && GearWeap_HeavyMortarBase(Pawn.Weapon) != None)
	{
		GearPawn_COGGear(MyGearPawn).AnnounceShot();
		ClearTimer(nameof(CheckAnnounceShot));
	}
}

defaultproperties
{
	bCanActivateFortifications=true
}
