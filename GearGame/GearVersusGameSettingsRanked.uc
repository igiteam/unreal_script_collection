/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * Holds the base configuration settings for TDM match.
 * NOTE: This class will normally be code generated
 */
class GearVersusGameSettingsRanked extends GearVersusGameSettings;

defaultproperties
{
	// These are only joinable before the start of the game
	bAllowJoinInProgress = false
	// Ranked games will be arbitrated
	bUsesArbitration = true

	LocalizedSettings(VERSUS_MATCH_MODE_INDEX)=(Id=`VERSUS_MATCH_MODE,ValueIndex=eGVMT_Official,AdvertisementType=ODAT_QoS)
}

