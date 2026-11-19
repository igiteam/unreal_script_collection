/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * Holds the base configuration settings for TDM match.
 * NOTE: This class will normally be code generated
 */
class GearVersusGameSettings extends GearPartySlotGameSettings;

// Common fixed entry indices for localized settings.
// Use these defines when overriding localized settings in sub blasses.
const CONTEXT_VERSUSMODES_INDEX =	6;
const CONTEXT_MAPNAME_INDEX =		7;
const CONTEXT_FRIENDLYFIRE_INDEX =	8;
const CONTEXT_ROUNDTIME_INDEX =		9;
const CONTEXT_BLEEDOUTTIME_INDEX =	10;
const CONTEXT_WEAPONSWAP_INDEX =	11;
const CONTEXT_ROUNDSTOWIN_INDEX =	12;
const CONTEXT_BOTDIFFICULTY_INDEX =	13;
const CONTEXT_NUMBOTS_INDEX =		14;
const MAP_SELECTION_MODE_INDEX =	15;
const VERSUS_MATCH_MODE_INDEX =		16;
const VERSUS_PARTY_TYPE_INDEX =		17;

defaultproperties
{
	// Invites are handled by party session
	bUsesPresence = false
	bAllowInvites = false
	bAllowJoinViaPresence = false

	// Enough space for 2 teams of 5
	NumPublicConnections=10

	DefaultTeamSize=5
	DefaultTeamCount=2

	// The playlist id for this match
	Properties(0)=(PropertyId=PROPERTY_PLAYLISTID,Data=(Type=SDT_Int32,Value1=0),AdvertisementType=ODAT_OnlineService)
	PropertyMappings(0)=(Id=PROPERTY_PLAYLISTID,Name="PlaylistId")

	// The version of the downloaded playlist
	Properties(1)=(PropertyId=PROPERTY_PLAYLISTMANAGERVERSION,Data=(Type=SDT_Int32,Value1=0),AdvertisementType=ODAT_OnlineService)
	PropertyMappings(1)=(Id=PROPERTY_PLAYLISTMANAGERVERSION,Name="PlaylistManagerVersion")

	// The datacenter id for this match (-1 for non-dedicated searches)
	Properties(2)=(PropertyId=PROPERTY_DATACENTERID,Data=(Type=SDT_Int32,Value1=-1),AdvertisementType=ODAT_OnlineService)
	PropertyMappings(2)=(Id=PROPERTY_DATACENTERID,Name="DatacenterId")

	// The locale of the player hosting the match (not set for dedicated servers)
	Properties(3)=(PropertyId=PROPERTY_GAMERLOCALE,Data=(Type=SDT_Int32,Value1=0),AdvertisementType=ODAT_OnlineService)
	PropertyMappings(3)=(Id=PROPERTY_GAMERLOCALE,Name="GamerLocale")

	// Versus game mode (const)
	LocalizedSettings(CONTEXT_GAME_MODE_INDEX)=(Id=CONTEXT_GAME_MODE,ValueIndex=CONTEXT_GAME_MODE_VERSUS,AdvertisementType=ODAT_OnlineService)	

	// The sub-game mode (const and set in every derived class, only put here for clarity)
	LocalizedSettings(CONTEXT_VERSUSMODES_INDEX)=(Id=CONTEXT_VERSUSMODES,ValueIndex=eGEARMP_Warzone,AdvertisementType=ODAT_DontAdvertise)
	LocalizedSettingsMappings(CONTEXT_VERSUSMODES_INDEX)=(Id=CONTEXT_VERSUSMODES,Name="GearMPMode",ValueMappings=((Id=eGEARMP_Warzone),(Id=eGEARMP_Wingman),(Id=eGEARMP_Horde),(Id=eGEARMP_Siege),(Id=eGEARMP_Execution),(Id=eGEARMP_KOTH),(Id=eGEARMP_CTL),(Id=eGEARMP_Newbie)))

	// Common settings for all game modes that are only configurable in private matches
	// even though we don't use this one, don't comment it out as then its Id will be the same as CONTEXT_VERSUSMODES
	LocalizedSettings(CONTEXT_MAPNAME_INDEX)=(Id=CONTEXT_MAPNAME,ValueIndex=CONTEXT_MAPNAME_FLOOD,AdvertisementType=ODAT_DontAdvertise)
	LocalizedSettingsMappings(CONTEXT_MAPNAME_INDEX)=(Id=CONTEXT_MAPNAME,Name="MapName")

	LocalizedSettings(CONTEXT_FRIENDLYFIRE_INDEX)=(Id=CONTEXT_FRIENDLYFIRE,ValueIndex=CONTEXT_FRIENDLYFIRE_NO,AdvertisementType=ODAT_DontAdvertise)
	LocalizedSettingsMappings(CONTEXT_FRIENDLYFIRE_INDEX)=(Id=CONTEXT_FRIENDLYFIRE,Name="FriendlyFire",ValueMappings=((Id=CONTEXT_FRIENDLYFIRE_NO),(Id=CONTEXT_FRIENDLYFIRE_YES)))

	LocalizedSettings(CONTEXT_ROUNDTIME_INDEX)=(Id=CONTEXT_ROUNDTIME,ValueIndex=CONTEXT_ROUNDTIME_FIVE,AdvertisementType=ODAT_DontAdvertise)
	LocalizedSettingsMappings(CONTEXT_ROUNDTIME_INDEX)=(Id=CONTEXT_ROUNDTIME,Name="RoundTime",ValueMappings=((Id=CONTEXT_ROUNDTIME_ONE),(Id=CONTEXT_ROUNDTIME_TWO),(Id=CONTEXT_ROUNDTIME_THREE),(Id=CONTEXT_ROUNDTIME_FOUR),(Id=CONTEXT_ROUNDTIME_FIVE),(Id=CONTEXT_ROUNDTIME_SIX),(Id=CONTEXT_ROUNDTIME_SEVEN),(Id=CONTEXT_ROUNDTIME_EIGHT),(Id=CONTEXT_ROUNDTIME_NINE),(Id=CONTEXT_ROUNDTIME_TEN)))

	LocalizedSettings(CONTEXT_BLEEDOUTTIME_INDEX)=(Id=CONTEXT_BLEEDOUTTIME,ValueIndex=CONTEXT_BLEEDOUTTIME_FIFTEEN,AdvertisementType=ODAT_DontAdvertise)
	LocalizedSettingsMappings(CONTEXT_BLEEDOUTTIME_INDEX)=(Id=CONTEXT_BLEEDOUTTIME,Name="Bleedout",ValueMappings=((Id=CONTEXT_BLEEDOUTTIME_FIVE),(Id=CONTEXT_BLEEDOUTTIME_TEN),(Id=CONTEXT_BLEEDOUTTIME_FIFTEEN),(Id=CONTEXT_BLEEDOUTTIME_TWENTY),(Id=CONTEXT_BLEEDOUTTIME_THIRTY),(Id=CONTEXT_BLEEDOUTTIME_SIXTY)))

	LocalizedSettings(CONTEXT_WEAPONSWAP_INDEX)=(Id=CONTEXT_WEAPONSWAP,ValueIndex=CONTEXT_WEAPONSWAP_CYCLE,AdvertisementType=ODAT_DontAdvertise)
	LocalizedSettingsMappings(CONTEXT_WEAPONSWAP_INDEX)=(Id=CONTEXT_WEAPONSWAP,Name="WeaponSwap",ValueMappings=((Id=CONTEXT_WEAPONSWAP_CYCLE),(Id=CONTEXT_WEAPONSWAP_NORMAL),(Id=CONTEXT_WEAPONSWAP_CUSTOM)))

	LocalizedSettings(CONTEXT_ROUNDSTOWIN_INDEX)=(Id=CONTEXT_ROUNDSTOWIN,ValueIndex=CONTEXT_ROUNDSTOWIN_FIVE,AdvertisementType=ODAT_DontAdvertise)
	LocalizedSettingsMappings(CONTEXT_ROUNDSTOWIN_INDEX)=(Id=CONTEXT_ROUNDSTOWIN,Name="RoundsToWin",ValueMappings=((Id=CONTEXT_ROUNDSTOWIN_ONE),(Id=CONTEXT_ROUNDSTOWIN_TWO),(Id=CONTEXT_ROUNDSTOWIN_THREE),(Id=CONTEXT_ROUNDSTOWIN_FOUR),(Id=CONTEXT_ROUNDSTOWIN_FIVE),(Id=CONTEXT_ROUNDSTOWIN_SIX),(Id=CONTEXT_ROUNDSTOWIN_SEVEN),(Id=CONTEXT_ROUNDSTOWIN_EIGHT),(Id=CONTEXT_ROUNDSTOWIN_NINE),(Id=CONTEXT_ROUNDSTOWIN_TEN),(Id=CONTEXT_ROUNDSTOWIN_ELEVEN),(Id=CONTEXT_ROUNDSTOWIN_TWELVE),(Id=CONTEXT_ROUNDSTOWIN_THIRTEEN),(Id=CONTEXT_ROUNDSTOWIN_FOURTEEN),(Id=CONTEXT_ROUNDSTOWIN_FIFTEEN)))

	LocalizedSettings(CONTEXT_BOTDIFFICULTY_INDEX)=(Id=CONTEXT_BOTDIFFICULTY,ValueIndex=CONTEXT_AIDIFFICULTY_NORMAL,AdvertisementType=ODAT_DontAdvertise)
	LocalizedSettingsMappings(CONTEXT_BOTDIFFICULTY_INDEX)=(Id=CONTEXT_BOTDIFFICULTY,Name="BotDifficulty",ValueMappings=((Id=CONTEXT_AIDIFFICULTY_CASUAL),(Id=CONTEXT_AIDIFFICULTY_NORMAL),(Id=CONTEXT_AIDIFFICULTY_HARDCORE),(Id=CONTEXT_AIDIFFICULTY_INSANE)))

	LocalizedSettings(CONTEXT_NUMBOTS_INDEX)=(Id=CONTEXT_NUMBOTS,ValueIndex=CONTEXT_NUMBOTS_0,AdvertisementType=ODAT_DontAdvertise)
	LocalizedSettingsMappings(CONTEXT_NUMBOTS_INDEX)=(Id=CONTEXT_NUMBOTS,Name="NumBots",ValueMappings=((Id=CONTEXT_NUMBOTS_0),(Id=CONTEXT_NUMBOTS_1),(Id=CONTEXT_NUMBOTS_2),(Id=CONTEXT_NUMBOTS_3),(Id=CONTEXT_NUMBOTS_4),(Id=CONTEXT_NUMBOTS_5),(Id=CONTEXT_NUMBOTS_6),(Id=CONTEXT_NUMBOTS_7),(Id=CONTEXT_NUMBOTS_8),(Id=CONTEXT_NUMBOTS_9)))

	LocalizedSettings(MAP_SELECTION_MODE_INDEX)=(Id=`MAP_SELECTION_MODE,ValueIndex=eGEARMAPSELECT_VOTE,AdvertisementType=ODAT_DontAdvertise)
	LocalizedSettingsMappings(MAP_SELECTION_MODE_INDEX)=(Id=`MAP_SELECTION_MODE,Name="MapSelectionMode",ValueMappings=((Id=eGEARMAPSELECT_VOTE),(Id=eGEARMAPSELECT_HOSTSELECT)))

	LocalizedSettings(VERSUS_MATCH_MODE_INDEX)=(Id=`VERSUS_MATCH_MODE,ValueIndex=eGVMT_Custom,AdvertisementType=ODAT_QoS)
	LocalizedSettingsMappings(VERSUS_MATCH_MODE_INDEX)=(Id=`VERSUS_MATCH_MODE,Name="RemoteMatchMode",ValueMappings=((Id=eGVMT_Official),(Id=eGVMT_Player),(Id=eGVMT_Custom),(Id=eGVMT_SystemLink),(Id=eGVMT_Local)))

	//@todo sz1 - needed?
	LocalizedSettings(VERSUS_PARTY_TYPE_INDEX)=(Id=`VERSUS_PARTY_TYPE,ValueIndex=eGVPT_FriendsOnly,AdvertisementType=ODAT_DontAdvertise)
	LocalizedSettingsMappings(VERSUS_PARTY_TYPE_INDEX)=(Id=`VERSUS_PARTY_TYPE,Name="RemotePartyType",ValueMappings=((Id=eGVPT_InviteRequired),(Id=eGVPT_FriendsOnly),(Id=eGVPT_Public),(Id=eGVPT_SystemLink)))
}

