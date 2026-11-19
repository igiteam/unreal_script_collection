
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearAmmoPickup_AmmoPouch extends GearAmmoPickup_AmmoCase;

simulated event string GetDebugAbbrev()
{
	return "APPouch";
}

defaultproperties
{
	Begin Object Name=StaticMeshComponent0
		StaticMesh=StaticMesh'AmmoPickups.Ammopickup_Case'
		Scale=1.0
		Translation=(Z=-20)
	End Object
}
