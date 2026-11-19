/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearAI_Hunter extends GearAI_Locust;

function SetupEnemyDistances(optional GearWeapon Wpn)
{
	Super.SetupEnemyDistances(Wpn);

	// don't mood scale short range so the hunters pull out the shotgun more when aggressive
	if( Wpn != None )
	{
		EnemyDistance_Short = Wpn.Range_Short;
		`AILog("- Overrode Short:"@EnemyDistance_Short);
	}
}

defaultproperties
{
}
