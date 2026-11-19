
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearAmmoPickup_AmmoMagazine extends GearAmmoPickup_AmmoCase;

simulated event string GetDebugAbbrev()
{
	return "APMag";
}

defaultproperties
{
	Begin Object Name=StaticMeshComponent0
		StaticMesh=StaticMesh'AmmoPickups.Ammopickup_Magazine'
		Scale=1.0
		Translation=(Z=-20)
	End Object
}
