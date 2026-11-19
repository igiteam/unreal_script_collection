/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * Holds the base configuration settings for CTL match.
 * NOTE: This class will normally be code generated
 */
class GearCTLSettings extends GearVersusGameSettings;

defaultproperties
{
	// CTL is the sub-game mode (const)	
	LocalizedSettings(CONTEXT_VERSUSMODES_INDEX)=(Id=CONTEXT_VERSUSMODES,ValueIndex=eGEARMP_CTL,AdvertisementType=ODAT_OnlineService)

	// CTL specific default values for inherited settings
	LocalizedSettings(CONTEXT_ROUNDSTOWIN_INDEX)=(Id=CONTEXT_ROUNDSTOWIN,ValueIndex=CONTEXT_ROUNDSTOWIN_TWO,AdvertisementType=ODAT_DontAdvertise)
}
