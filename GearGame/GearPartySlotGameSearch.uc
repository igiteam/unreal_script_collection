/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * Used to find matches that a party can participate in
 */
class GearPartySlotGameSearch extends OnlineGameSearch
	config(Game);

/** The max ping we will accept before discarding the match */
var config int MaxPing;

/** Value from 0 to 1 setting the minimum threshold on match quality */
var config float MinMatchQuality;

// Common fixed entry indices for localized settings.
// Use these defines when overriding localized settings in sub classes.
const CONTEXT_GAME_MODE_INDEX =		0;
const CONTEXT_PARTYSLOT_1_INDEX =	1;
const CONTEXT_PARTYSLOT_2_INDEX =	2;
const CONTEXT_PARTYSLOT_3_INDEX =	3;
const CONTEXT_PARTYSLOT_4_INDEX =	4;
const CONTEXT_PARTYSLOT_5_INDEX =	5;

defaultproperties
{
	// We are only searching for versus sessions
	LocalizedSettings(CONTEXT_GAME_MODE_INDEX)=(Id=CONTEXT_GAME_MODE,ValueIndex=CONTEXT_GAME_MODE_VERSUS,AdvertisementType=ODAT_OnlineService)
	LocalizedSettingsMappings(CONTEXT_GAME_MODE_INDEX)=(Id=CONTEXT_GAME_MODE,Name="GameMode",ValueMappings=((Id=CONTEXT_GAME_MODE_COOP),(Id=CONTEXT_GAME_MODE_VERSUS),(Id=CONTEXT_GAME_MODE_VERSUS_LOADBALANCE1),(Id=CONTEXT_GAME_MODE_VERSUS_LOADBALANCE2),(Id=CONTEXT_GAME_MODE_VERSUS_LOADBALANCE3),(Id=CONTEXT_GAME_MODE_VERSUS_LOADBALANCE4),(Id=CONTEXT_GAME_MODE_VERSUS_LOADBALANCE5),(Id=CONTEXT_GAME_MODE_VERSUS_LOADBALANCE6),(Id=CONTEXT_GAME_MODE_VERSUS_LOADBALANCE7),(Id=CONTEXT_GAME_MODE_VERSUS_LOADBALANCE8)))

	// Partial party matchmaking values
	LocalizedSettings(CONTEXT_PARTYSLOT_1_INDEX)=(Id=CONTEXT_PARTYSLOT_1,ValueIndex=CONTEXT_PARTYSLOT_ANY,AdvertisementType=ODAT_OnlineService)
	LocalizedSettingsMappings(CONTEXT_PARTYSLOT_1_INDEX)=(Id=CONTEXT_PARTYSLOT_1,Name="PartySlot_1",ValueMappings=((Id=CONTEXT_PARTYSLOT_BLOCKED),(Id=CONTEXT_PARTYSLOT_WANTS),(Id=CONTEXT_PARTYSLOT_NEEDS),(Id=CONTEXT_PARTYSLOT_ANY,bIsWildcard=true)))

	LocalizedSettings(CONTEXT_PARTYSLOT_2_INDEX)=(Id=CONTEXT_PARTYSLOT_2,ValueIndex=CONTEXT_PARTYSLOT_ANY,AdvertisementType=ODAT_OnlineService)
	LocalizedSettingsMappings(CONTEXT_PARTYSLOT_2_INDEX)=(Id=CONTEXT_PARTYSLOT_2,Name="PartySlot_2",ValueMappings=((Id=CONTEXT_PARTYSLOT_BLOCKED),(Id=CONTEXT_PARTYSLOT_WANTS),(Id=CONTEXT_PARTYSLOT_NEEDS),(Id=CONTEXT_PARTYSLOT_ANY,bIsWildcard=true)))

	LocalizedSettings(CONTEXT_PARTYSLOT_3_INDEX)=(Id=CONTEXT_PARTYSLOT_3,ValueIndex=CONTEXT_PARTYSLOT_ANY,AdvertisementType=ODAT_OnlineService)
	LocalizedSettingsMappings(CONTEXT_PARTYSLOT_3_INDEX)=(Id=CONTEXT_PARTYSLOT_3,Name="PartySlot_3",ValueMappings=((Id=CONTEXT_PARTYSLOT_BLOCKED),(Id=CONTEXT_PARTYSLOT_WANTS),(Id=CONTEXT_PARTYSLOT_NEEDS),(Id=CONTEXT_PARTYSLOT_ANY,bIsWildcard=true)))

	LocalizedSettings(CONTEXT_PARTYSLOT_4_INDEX)=(Id=CONTEXT_PARTYSLOT_4,ValueIndex=CONTEXT_PARTYSLOT_ANY,AdvertisementType=ODAT_OnlineService)
	LocalizedSettingsMappings(CONTEXT_PARTYSLOT_4_INDEX)=(Id=CONTEXT_PARTYSLOT_4,Name="PartySlot_4",ValueMappings=((Id=CONTEXT_PARTYSLOT_BLOCKED),(Id=CONTEXT_PARTYSLOT_WANTS),(Id=CONTEXT_PARTYSLOT_NEEDS),(Id=CONTEXT_PARTYSLOT_ANY,bIsWildcard=true)))

	LocalizedSettings(CONTEXT_PARTYSLOT_5_INDEX)=(Id=CONTEXT_PARTYSLOT_5,ValueIndex=CONTEXT_PARTYSLOT_ANY,AdvertisementType=ODAT_OnlineService)
	LocalizedSettingsMappings(CONTEXT_PARTYSLOT_5_INDEX)=(Id=CONTEXT_PARTYSLOT_5,Name="PartySlot_5",ValueMappings=((Id=CONTEXT_PARTYSLOT_BLOCKED),(Id=CONTEXT_PARTYSLOT_WANTS),(Id=CONTEXT_PARTYSLOT_NEEDS),(Id=CONTEXT_PARTYSLOT_ANY,bIsWildcard=true)))
	// End partial party matchmaking values
}
