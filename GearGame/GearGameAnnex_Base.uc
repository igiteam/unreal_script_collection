/**
 * GearGameAnnex_Base
 * Gear Game Info for Annex Gametype
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearGameAnnex_Base extends GearGameRing_Base
	abstract
	native
	config(Game);


/************************************************************************/
/* Script functions                                                     */
/************************************************************************/

/**
 * Whether this is a weapon spawner we should consider in this gametype
 */
function bool WeaponSpawnerIsUsable(GearWeaponPickupFactory Factory)
{
	return !Factory.bMP_ExcludeAnnex;
}

/**
 * Set the game rules via the online game settings
 * @return - whether the game was able to set the rules via the gamesettings object
 */
function bool SetGameRules()
{
// 	local int IntValue;
// 	local GearVersusGameSettings MyGameSettings;
// 
// 	MyGameSettings = GetGameSettingsObject();
// 	if (MyGameSettings != None)
// 	{
// 		// Resource Goal
// 		if ( MyGameSettings.GetStringSettingValue(MyGameSettings.const.CONTEXT_ROUNDSCORE, IntValue) )
// 		{
// 			ResourceGoal = 120 + (IntValue * 60);
// 		}
// 		return Super.SetGameRules();
// 	}
	return FALSE;
}