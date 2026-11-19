/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * Used to find matches that a party can participate in
 */
class GearPlayerVersusGameSearch extends GearVersusGameSearch;

defaultproperties
{
	// The class to use for any search results. Important for party matches!
	GameSettingsClass=class'GearGame.GearPlayerVersusGameSettings'

	// All player versus searches are not ranked
	bUsesArbitration=false	
}
