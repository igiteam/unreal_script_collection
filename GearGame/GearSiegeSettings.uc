/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * Holds the base configuration settings for Siege match.
 * NOTE: This class will normally be code generated
 */
class GearSiegeSettings extends GearVersusGameSettings;

defaultproperties
{
	DefaultTeamSize=5
	DefaultTeamCount=1

	// Horde is the sub-game mode (const)
	LocalizedSettings(CONTEXT_VERSUSMODES_INDEX)=(Id=CONTEXT_VERSUSMODES,ValueIndex=eGEARMP_Siege,AdvertisementType=ODAT_OnlineService)

	// Horde settings that are only configurable in private matches
	LocalizedSettings.Add((Id=CONTEXT_SIEGE_ENEMYDIFFICULTY,ValueIndex=CONTEXT_AIDIFFICULTY_NORMAL,AdvertisementType=ODAT_DontAdvertise))
	LocalizedSettingsMappings.Add({
		(Id=CONTEXT_SIEGE_ENEMYDIFFICULTY,Name="SiegeEnemyDifficulty",ValueMappings=(
			(Id=CONTEXT_AIDIFFICULTY_CASUAL),
			(Id=CONTEXT_AIDIFFICULTY_NORMAL),
			(Id=CONTEXT_AIDIFFICULTY_HARDCORE),
			(Id=CONTEXT_AIDIFFICULTY_INSANE)))
		})

	LocalizedSettings.Add((Id=CONTEXT_SIEGE_WAVE,ValueIndex=CONTEXT_SIEGE_WAVE_0,AdvertisementType=ODAT_DontAdvertise))
	LocalizedSettingsMappings.Add((Id=CONTEXT_SIEGE_WAVE,Name="SiegeWave",ValueMappings=((Id=CONTEXT_SIEGE_WAVE_0),(Id=CONTEXT_SIEGE_WAVE_1),(Id=CONTEXT_SIEGE_WAVE_2),(Id=CONTEXT_SIEGE_WAVE_3),(Id=CONTEXT_SIEGE_WAVE_4),(Id=CONTEXT_SIEGE_WAVE_5),(Id=CONTEXT_SIEGE_WAVE_6),(Id=CONTEXT_SIEGE_WAVE_7),(Id=CONTEXT_SIEGE_WAVE_8),(Id=CONTEXT_SIEGE_WAVE_9),(Id=CONTEXT_SIEGE_WAVE_10),(Id=CONTEXT_SIEGE_WAVE_11))))
}
