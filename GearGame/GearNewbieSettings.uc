/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * Holds the base configuration settings for Assassination match.
 * NOTE: This class will normally be code generated
 */
class GearNewbieSettings extends GearVersusGameSettings;

defaultproperties
{
	// Newbie is the sub-game mode (const)
	LocalizedSettings(CONTEXT_VERSUSMODES_INDEX)=(Id=CONTEXT_VERSUSMODES,ValueIndex=eGEARMP_Newbie,AdvertisementType=ODAT_OnlineService)

	// Newbie specific default values for inherited settings
	LocalizedSettings(CONTEXT_ROUNDSTOWIN_INDEX)=(Id=CONTEXT_ROUNDSTOWIN,ValueIndex=CONTEXT_ROUNDSTOWIN_TWO,AdvertisementType=ODAT_DontAdvertise)

	// Newbie settings that are only configurable in private matches
	LocalizedSettings.Add((Id=CONTEXT_ROUNDSCORE_NEWB,ValueIndex=CONTEXT_ROUNDSCORE_NEWB_15,AdvertisementType=ODAT_DontAdvertise))
	LocalizedSettingsMappings.Add({
		(Id=CONTEXT_ROUNDSCORE_NEWB,Name="RoundScore",ValueMappings=(
			(Id=CONTEXT_ROUNDSCORE_NEWB_10),
			(Id=CONTEXT_ROUNDSCORE_NEWB_15),
			(Id=CONTEXT_ROUNDSCORE_NEWB_20),
			(Id=CONTEXT_ROUNDSCORE_NEWB_25),
			(Id=CONTEXT_ROUNDSCORE_NEWB_30),
			(Id=CONTEXT_ROUNDSCORE_NEWB_35)))
			})
}
