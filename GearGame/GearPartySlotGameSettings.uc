/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * Holds the base configuration settings for TDM match.
 * NOTE: This class will normally be code generated
 */
class GearPartySlotGameSettings extends OnlineGameSettings;

`include(GearOnlineConstants.uci)

/** The overall session quality determined using our heuristic */
var float OverallMatchQuality;

/** Default team size for this game setting */
var int DefaultTeamSize;

/** Default team count for this game setting */
var int DefaultTeamCount;

// Common fixed entry indices for localized settings.
// Use these defines when overriding localized settings in sub classes.
const CONTEXT_GAME_MODE_INDEX =		0;
const CONTEXT_PARTYSLOT_1_INDEX =	1;
const CONTEXT_PARTYSLOT_2_INDEX =	2;
const CONTEXT_PARTYSLOT_3_INDEX =	3;
const CONTEXT_PARTYSLOT_4_INDEX =	4;
const CONTEXT_PARTYSLOT_5_INDEX =	5;

/**
 * Gets the localized setting name for a specified option id 
 * 
 * @param   OptionId    ID of the setting you want the name of (i.e. one of the consts above)
 */
function string GetSettingOptionName(int OptionId)
{
	local string KeyName;
	local int Index;

	Index = LocalizedSettingsMappings.Find('Id', OptionId);

	if( Index != INDEX_NONE )
	{
		KeyName = string(LocalizedSettingsMappings[Index].Name);
		return Localize("GameSettingsOptions", KeyName, "GearGame");
	}

	return "";
}

/**
 * Determine the load balanced versus game mode context based on a playlist id
 *
 * @param PlaylistMan playlist manager that can map from playlist id to load balance id
 * @param PlaylistId playlist id to convert to game mode
 *
 * @return load balanced versus game mode context id
 */
static function int GetGameModeFromPlaylistId(OnlinePlaylistManager PlaylistMan,int PlaylistId)
{
	local int LoadBalanceId;

	if (PlaylistMan != None)
	{
		PlaylistMan.GetLoadBalanceIdFromPlaylist(PlaylistId,LoadBalanceId);
	}
	switch (LoadBalanceId)
	{
	case 1:
		return CONTEXT_GAME_MODE_VERSUS_LOADBALANCE1;
	case 2:
		return CONTEXT_GAME_MODE_VERSUS_LOADBALANCE2;
	case 3:
		return CONTEXT_GAME_MODE_VERSUS_LOADBALANCE3;
	case 4:
		return CONTEXT_GAME_MODE_VERSUS_LOADBALANCE4;
	case 5:
		return CONTEXT_GAME_MODE_VERSUS_LOADBALANCE5;
	case 6:
		return CONTEXT_GAME_MODE_VERSUS_LOADBALANCE6;
	case 7:
		return CONTEXT_GAME_MODE_VERSUS_LOADBALANCE7;
	case 8:
		return CONTEXT_GAME_MODE_VERSUS_LOADBALANCE8;
	default:
		return CONTEXT_GAME_MODE_VERSUS;
	}
}

/**
 * Determine if the game mode is a player host versus type
 *
 * @param GameModeIdx game mode index to check
 */
static function bool IsVersusGameMode(int GameModeIdx)
{
	return GameModeIdx == CONTEXT_GAME_MODE_VERSUS ||
		GameModeIdx == CONTEXT_GAME_MODE_VERSUS_LOADBALANCE1 ||
		GameModeIdx == CONTEXT_GAME_MODE_VERSUS_LOADBALANCE2 ||
		GameModeIdx == CONTEXT_GAME_MODE_VERSUS_LOADBALANCE3 ||
		GameModeIdx == CONTEXT_GAME_MODE_VERSUS_LOADBALANCE4 ||
		GameModeIdx == CONTEXT_GAME_MODE_VERSUS_LOADBALANCE5 ||
		GameModeIdx == CONTEXT_GAME_MODE_VERSUS_LOADBALANCE6 ||
		GameModeIdx == CONTEXT_GAME_MODE_VERSUS_LOADBALANCE7 ||
		GameModeIdx == CONTEXT_GAME_MODE_VERSUS_LOADBALANCE8;
}

defaultproperties
{
	// Versus game mode (const)
	LocalizedSettings(CONTEXT_GAME_MODE_INDEX)=(Id=CONTEXT_GAME_MODE,ValueIndex=CONTEXT_GAME_MODE_VERSUS,AdvertisementType=ODAT_OnlineService)
	LocalizedSettingsMappings(CONTEXT_GAME_MODE_INDEX)=(Id=CONTEXT_GAME_MODE,Name="GameMode",ValueMappings=((Id=CONTEXT_GAME_MODE_COOP),(Id=CONTEXT_GAME_MODE_VERSUS),(Id=CONTEXT_GAME_MODE_VERSUS_LOADBALANCE1),(Id=CONTEXT_GAME_MODE_VERSUS_LOADBALANCE2),(Id=CONTEXT_GAME_MODE_VERSUS_LOADBALANCE3),(Id=CONTEXT_GAME_MODE_VERSUS_LOADBALANCE4),(Id=CONTEXT_GAME_MODE_VERSUS_LOADBALANCE5),(Id=CONTEXT_GAME_MODE_VERSUS_LOADBALANCE6),(Id=CONTEXT_GAME_MODE_VERSUS_LOADBALANCE7),(Id=CONTEXT_GAME_MODE_VERSUS_LOADBALANCE8)))

	// Partial party matchmaking values
	LocalizedSettings(CONTEXT_PARTYSLOT_1_INDEX)=(Id=CONTEXT_PARTYSLOT_1,ValueIndex=CONTEXT_PARTYSLOT_BLOCKED,AdvertisementType=ODAT_OnlineService)
	LocalizedSettingsMappings(CONTEXT_PARTYSLOT_1_INDEX)=(Id=CONTEXT_PARTYSLOT_1,Name="PartySlot_1",ValueMappings=((Id=CONTEXT_PARTYSLOT_BLOCKED),(Id=CONTEXT_PARTYSLOT_WANTS),(Id=CONTEXT_PARTYSLOT_NEEDS),(Id=CONTEXT_PARTYSLOT_ANY,bIsWildcard=true)))

	LocalizedSettings(CONTEXT_PARTYSLOT_2_INDEX)=(Id=CONTEXT_PARTYSLOT_2,ValueIndex=CONTEXT_PARTYSLOT_BLOCKED,AdvertisementType=ODAT_OnlineService)
	LocalizedSettingsMappings(CONTEXT_PARTYSLOT_2_INDEX)=(Id=CONTEXT_PARTYSLOT_2,Name="PartySlot_2",ValueMappings=((Id=CONTEXT_PARTYSLOT_BLOCKED),(Id=CONTEXT_PARTYSLOT_WANTS),(Id=CONTEXT_PARTYSLOT_NEEDS),(Id=CONTEXT_PARTYSLOT_ANY,bIsWildcard=true)))

	LocalizedSettings(CONTEXT_PARTYSLOT_3_INDEX)=(Id=CONTEXT_PARTYSLOT_3,ValueIndex=CONTEXT_PARTYSLOT_BLOCKED,AdvertisementType=ODAT_OnlineService)
	LocalizedSettingsMappings(CONTEXT_PARTYSLOT_3_INDEX)=(Id=CONTEXT_PARTYSLOT_3,Name="PartySlot_3",ValueMappings=((Id=CONTEXT_PARTYSLOT_BLOCKED),(Id=CONTEXT_PARTYSLOT_WANTS),(Id=CONTEXT_PARTYSLOT_NEEDS),(Id=CONTEXT_PARTYSLOT_ANY,bIsWildcard=true)))

	LocalizedSettings(CONTEXT_PARTYSLOT_4_INDEX)=(Id=CONTEXT_PARTYSLOT_4,ValueIndex=CONTEXT_PARTYSLOT_BLOCKED,AdvertisementType=ODAT_OnlineService)
	LocalizedSettingsMappings(CONTEXT_PARTYSLOT_4_INDEX)=(Id=CONTEXT_PARTYSLOT_4,Name="PartySlot_4",ValueMappings=((Id=CONTEXT_PARTYSLOT_BLOCKED),(Id=CONTEXT_PARTYSLOT_WANTS),(Id=CONTEXT_PARTYSLOT_NEEDS),(Id=CONTEXT_PARTYSLOT_ANY,bIsWildcard=true)))

	LocalizedSettings(CONTEXT_PARTYSLOT_5_INDEX)=(Id=CONTEXT_PARTYSLOT_5,ValueIndex=CONTEXT_PARTYSLOT_BLOCKED,AdvertisementType=ODAT_OnlineService)
	LocalizedSettingsMappings(CONTEXT_PARTYSLOT_5_INDEX)=(Id=CONTEXT_PARTYSLOT_5,Name="PartySlot_5",ValueMappings=((Id=CONTEXT_PARTYSLOT_BLOCKED),(Id=CONTEXT_PARTYSLOT_WANTS),(Id=CONTEXT_PARTYSLOT_NEEDS),(Id=CONTEXT_PARTYSLOT_ANY,bIsWildcard=true)))
	// End partial party matchmaking values	
}

