/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * Holds the base configuration settings for KOTH match.
 * NOTE: This class will normally be code generated
 */
class GearKOTHSettings extends GearVersusGameSettings;

defaultproperties
{
	// KOTH is the sub-game mode (const)
	LocalizedSettings(CONTEXT_VERSUSMODES_INDEX)=(Id=CONTEXT_VERSUSMODES,ValueIndex=eGEARMP_KOTH,AdvertisementType=ODAT_OnlineService)

	// KOTH specific default values for inherited settings
	LocalizedSettings(CONTEXT_ROUNDSTOWIN_INDEX)=(Id=CONTEXT_ROUNDSTOWIN,ValueIndex=CONTEXT_ROUNDSTOWIN_TWO,AdvertisementType=ODAT_DontAdvertise)

	// KOTH settings that are only configurable in private matches
	LocalizedSettings.Add((Id=CONTEXT_ROUNDSCORE_KOTH,ValueIndex=CONTEXT_ROUNDSCORE_KOTH_170,AdvertisementType=ODAT_DontAdvertise))
	LocalizedSettingsMappings.Add({
		(Id=CONTEXT_ROUNDSCORE_KOTH,Name="KOTHRoundScore",ValueMappings=(
			(Id=CONTEXT_ROUNDSCORE_KOTH_50),
			(Id=CONTEXT_ROUNDSCORE_KOTH_80),
			(Id=CONTEXT_ROUNDSCORE_KOTH_110),
			(Id=CONTEXT_ROUNDSCORE_KOTH_140),
			(Id=CONTEXT_ROUNDSCORE_KOTH_170),
			(Id=CONTEXT_ROUNDSCORE_KOTH_200),
			(Id=CONTEXT_ROUNDSCORE_KOTH_230)))
		})
}
