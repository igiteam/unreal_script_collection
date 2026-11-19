/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * Used to find matches that a party can participate in
 */
class GearVersusGameSearch extends GearPartySlotGameSearch;

defaultproperties
{
	// Which server side query to execute
	Query=(ValueIndex=SESSION_MATCH_QUERY_VERSUS)

	// The class to use for any search results. Important for party matches!
	GameSettingsClass=class'GearGame.GearVersusGameSettings'

	// We only search based off of playlist id
	Properties(0)=(PropertyId=PROPERTY_PLAYLISTID,Data=(Type=SDT_Int32,Value1=0),AdvertisementType=ODAT_OnlineService)
	PropertyMappings(0)=(Id=PROPERTY_PLAYLISTID,Name="PlaylistId")

	// The version of the downloaded playlist
	Properties(1)=(PropertyId=PROPERTY_PLAYLISTMANAGERVERSION,Data=(Type=SDT_Int32,Value1=0),AdvertisementType=ODAT_OnlineService)
	PropertyMappings(1)=(Id=PROPERTY_PLAYLISTMANAGERVERSION,Name="PlaylistManagerVersion")

	// The datacenter id for this match (-1 for non-dedicated searches)
	Properties(2)=(PropertyId=PROPERTY_DATACENTERID,Data=(Type=SDT_Int32,Value1=-1),AdvertisementType=ODAT_OnlineService)
	PropertyMappings(2)=(Id=PROPERTY_DATACENTERID,Name="DatacenterId")

	// We are only searching for versus sessions
	LocalizedSettings(CONTEXT_GAME_MODE_INDEX)=(Id=CONTEXT_GAME_MODE,ValueIndex=CONTEXT_GAME_MODE_VERSUS,AdvertisementType=ODAT_OnlineService)

	// Sort in buckets of 0-49, 50-99, etc.
	PingBucketSize=50

	MaxSearchResults=50
}
