/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * Holds the base configuration settings for Wingman match.
 * NOTE: This class will normally be code generated
 */
class GearWingmanSettings extends GearVersusGameSettings;

defaultproperties
{
	DefaultTeamSize=2
	DefaultTeamCount=4

	// Wingman is the sub-game mode (const)
	LocalizedSettings(CONTEXT_VERSUSMODES_INDEX)=(Id=CONTEXT_VERSUSMODES,ValueIndex=eGEARMP_Wingman,AdvertisementType=ODAT_OnlineService)

	// Wingman specific default values for inherited settings
	LocalizedSettings(CONTEXT_BLEEDOUTTIME_INDEX)=(Id=CONTEXT_BLEEDOUTTIME,ValueIndex=CONTEXT_BLEEDOUTTIME_THIRTY,AdvertisementType=ODAT_DontAdvertise)
	LocalizedSettings(CONTEXT_ROUNDSTOWIN_INDEX)=(Id=CONTEXT_ROUNDSTOWIN,ValueIndex=CONTEXT_ROUNDSTOWIN_THREE,AdvertisementType=ODAT_DontAdvertise)

	// Wingman settings that are only configurable in private matches
	LocalizedSettings.Add((Id=CONTEXT_WINGMAN_SCOREGOAL,ValueIndex=CONTEXT_WINGMAN_SCOREGOAL_15,AdvertisementType=ODAT_DontAdvertise))
	LocalizedSettingsMappings.Add({
		(Id=CONTEXT_WINGMAN_SCOREGOAL,Name="WingmanScore",ValueMappings=(
			(Id=CONTEXT_WINGMAN_SCOREGOAL_10),
			(Id=CONTEXT_WINGMAN_SCOREGOAL_15),
			(Id=CONTEXT_WINGMAN_SCOREGOAL_20),
			(Id=CONTEXT_WINGMAN_SCOREGOAL_25),
			(Id=CONTEXT_WINGMAN_SCOREGOAL_30)))
		})
}
