/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * Holds the base configuration settings for TDM match.
 * NOTE: This class will normally be code generated
 */
class GearPlayerVersusGameSettings extends GearVersusGameSettings;


defaultproperties
{
	// Player game will not be arbitrated
	bUsesArbitration = false
	// Allow join the game session after it has started
	bAllowJoinInProgress = true	

	LocalizedSettings(VERSUS_MATCH_MODE_INDEX)=(Id=`VERSUS_MATCH_MODE,ValueIndex=eGVMT_Player,AdvertisementType=ODAT_QoS)
}

