/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * Holds the base configuration settings for an online coop game
 * NOTE: This class will normally be code generated
 */
class GearCoopGameSettings extends GearPartySlotGameSettings;

defaultproperties
{
	bAllowJoinInProgress=true
	bUsesArbitration=false
	// Invites are handled by party session
	bUsesPresence = false
	bAllowInvites = false
	bAllowJoinViaPresence = false

	// Enough space for 4 players
	NumPublicConnections=4
	DefaultTeamSize=4
	DefaultTeamCount=1

	// Coop game mode (const)
	LocalizedSettings(CONTEXT_GAME_MODE_INDEX)=(Id=CONTEXT_GAME_MODE,ValueIndex=CONTEXT_GAME_MODE_COOP,AdvertisementType=ODAT_OnlineServiceAndQoS)

	// Act number property
	PropertyMappings(0)=(Id=PROPERTY_ACTNUM,Name="ActNum")
	Properties(0)=(PropertyId=PROPERTY_ACTNUM,Data=(Type=SDT_Int32,Value1=1),AdvertisementType=ODAT_OnlineService)

	// Chapter number property
	PropertyMappings(1)=(Id=PROPERTY_CHAPTERNUM,Name="ChapterNum")
	Properties(1)=(PropertyId=PROPERTY_CHAPTERNUM,Data=(Type=SDT_Int32,Value1=1),AdvertisementType=ODAT_OnlineService)

	LocalizedSettings(7)=(Id=`CampCheckpointUsage,ValueIndex=eGEARCHECKPOINT_UseLast,AdvertisementType=ODAT_DontAdvertise)
	LocalizedSettingsMappings(7)=(Id=`CampCheckpointUsage,Name="RemoteCheckpointUsage",ValueMappings=((Id=eGEARCHECKPOINT_UseLast),(Id=eGEARCHECKPOINT_Restart)))

	LocalizedSettings(8)=(Id=`CAMP_MODE,ValueIndex=eGCM_LivePrivate,AdvertisementType=ODAT_DontAdvertise)
	LocalizedSettingsMappings(8)=(Id=`CAMP_MODE,Name="RemoteCampMode",ValueMappings=((Id=eGCM_LivePublic),(Id=eGCM_LivePrivate),(Id=eGCM_SystemLink)))
}
