/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */

/**
 * Specific derivation of UIDataStore_OnlineStats to expose the TDM leaderboards
 */
class TMDataStore_OnlineStats extends UIDataStore_OnlineStats
	native;










const GS_USERNAME_MAXLENGTH					 = 15;
const GS_PASSWORD_MAXLENGTH					 = 30;
const GS_MESSAGE_MAXLENGTH					 = 255;
const GS_EMAIL_MAXLENGTH					 = 50;
const GS_CDKEY_PART_MAXLENGTH				 = 4;


const CONTEXT_PRESENCE_MENUPRESENCE              = 0;

const CONTEXT_GAME_MODE							 = 0x0000800B;


const CONTEXT_GAME_MODE_DM                       = 0;
const CONTEXT_GAME_MODE_CTF                      = 1;
const CONTEXT_GAME_MODE_WAR                      = 2;
const CONTEXT_GAME_MODE_VCTF					 = 3;
const CONTEXT_GAME_MODE_TDM                      = 4;
const CONTEXT_GAME_MODE_DUEL                     = 5;
const CONTEXT_GAME_MODE_CUSTOM                   = 6;
const CONTEXT_GAME_MODE_CAMPAIGN                 = 7;

const CONTEXT_BOTSKILL                           = 0;
const CONTEXT_MAPNAME                            = 1;
const CONTEXT_PURESERVER                         = 6;
const CONTEXT_LOCKEDSERVER                       = 7;
const CONTEXT_VSBOTS                             = 8;
const CONTEXT_CAMPAIGN                           = 9;
const CONTEXT_FORCERESPAWN                       = 10;
const CONTEXT_ALLOWKEYBOARD                      = 11;
const CONTEXT_FULLSERVER                         = 12;
const CONTEXT_EMPTYSERVER                        = 13;
const CONTEXT_DEDICATEDSERVER                    = 14;


const CONTEXT_MAPNAME_CUSTOM                     = 0;



const CONTEXT_BOTSKILL_NOVICE                    = 0;
const CONTEXT_BOTSKILL_AVERAGE                   = 1;
const CONTEXT_BOTSKILL_EXPERIENCED               = 2;
const CONTEXT_BOTSKILL_SKILLED                   = 3;
const CONTEXT_BOTSKILL_ADEPT                     = 4;
const CONTEXT_BOTSKILL_MASTERFUL                 = 5;
const CONTEXT_BOTSKILL_INHUMAN                   = 6;
const CONTEXT_BOTSKILL_GODLIKE                   = 7;



const CONTEXT_GOALSCORE_5                        = 0;
const CONTEXT_GOALSCORE_10                       = 1;
const CONTEXT_GOALSCORE_15                       = 2;
const CONTEXT_GOALSCORE_20                       = 3;
const CONTEXT_GOALSCORE_30                       = 4;



const CONTEXT_NUMBOTS_0                          = 0;
const CONTEXT_NUMBOTS_1                          = 1;
const CONTEXT_NUMBOTS_2                          = 2;
const CONTEXT_NUMBOTS_3                          = 3;
const CONTEXT_NUMBOTS_4                          = 4;
const CONTEXT_NUMBOTS_5                          = 5;
const CONTEXT_NUMBOTS_6                          = 6;
const CONTEXT_NUMBOTS_7                          = 7;
const CONTEXT_NUMBOTS_8                          = 8;



const CONTEXT_TIMELIMIT_5                        = 0;
const CONTEXT_TIMELIMIT_10                       = 1;
const CONTEXT_TIMELIMIT_15                       = 2;
const CONTEXT_TIMELIMIT_20                       = 3;
const CONTEXT_TIMELIMIT_30                       = 4;



const CONTEXT_PURESERVER_NO                      = 0;
const CONTEXT_PURESERVER_YES                     = 1;
const CONTEXT_PURESERVER_ANY                     = 2;



const CONTEXT_LOCKEDSERVER_NO                    = 0;
const CONTEXT_LOCKEDSERVER_YES                   = 1;



const CONTEXT_CAMPAIGN_NO                        = 0;
const CONTEXT_CAMPAIGN_YES                       = 1;



const CONTEXT_FORCERESPAWN_NO                        = 0;
const CONTEXT_FORCERESPAWN_YES                       = 1;



const CONTEXT_ALLOWKEYBOARD_NO                        = 0;
const CONTEXT_ALLOWKEYBOARD_YES                       = 1;
const CONTEXT_ALLOWKEYBOARD_ANY						= 2;


const CONTEXT_FULLSERVER_NO						= 0;
const CONTEXT_FULLSERVER_YES					= 1;


const CONTEXT_EMPTYSERVER_NO					= 0;
const CONTEXT_EMPTYSERVER_YES					= 1;


const CONTEXT_DEDICATEDSERVER_NO                = 0;
const CONTEXT_DEDICATEDSERVER_YES               = 1;



const  CONTEXT_VSBOTS_NONE                       = 0;
const  CONTEXT_VSBOTS_1_TO_2                     = 1;
const  CONTEXT_VSBOTS_1_TO_1                     = 2;
const  CONTEXT_VSBOTS_3_TO_2					 = 3;
const  CONTEXT_VSBOTS_2_TO_1                     = 4;
const  CONTEXT_VSBOTS_3_TO_1                     = 5;
const  CONTEXT_VSBOTS_4_TO_1                     = 6;

const PROPERTY_NUMBOTS							 = 0x100000F7;
const PROPERTY_GOALSCORE						 = 0x100000F8;
const PROPERTY_TIMELIMIT				         = 0x100000F9;
const PROPERTY_LEADERBOARDRATING	             = 0x20000004;
const PROPERTY_EPICMUTATORS                      = 0x10000105;


const PROPERTY_CUSTOMMAPNAME                     = 0x40000001;
const PROPERTY_CUSTOMGAMEMODE                    = 0x40000002;
const PROPERTY_SERVERDESCRIPTION                 = 0x40000003;
const PROPERTY_CUSTOMMUTATORS                    = 0x40000004;


const QUERY_DM									 = 0;
const QUERY_TDM									 = 1;
const QUERY_CTF									 = 2;
const QUERY_VCTF								 = 3;
const QUERY_WAR									 = 4;
const QUERY_DUEL								 = 5;
const QUERY_CAMPAIGN							 = 6;



const STATS_VIEW_DM_PLAYER_ALLTIME                         = 1;
const STATS_VIEW_DM_RANKED_ALLTIME                         = 2;
const STATS_VIEW_DM_WEAPONS_ALLTIME                        = 3;
const STATS_VIEW_DM_VEHICLES_ALLTIME                       = 4;
const STATS_VIEW_DM_VEHICLEWEAPONS_ALLTIME                 = 5;
const STATS_VIEW_DM_VEHICLES_RANKED_ALLTIME                = 6;
const STATS_VIEW_DM_VEHICLEWEAPONS_RANKED_ALLTIME          = 7;
const STATS_VIEW_DM_WEAPONS_RANKED_ALLTIME                 = 8;

#linenumber 11

/** Different read types. */
enum EStatsDetailsReadType
{
	TMSR_GeneralAndRewards,
	TMSR_Weapons,
	TMSR_Vehicles,
	TMSR_VehicleWeapons,
};

var transient EStatsDetailsReadType	CurrentDetailsReadType;

/** Whether or not we are currently in a read. */
var transient bool bInRead;

/** Whether or not we are currently pumping the read queue. */
var transient bool bInQueuePump;

/** NetId of the player we are retrieving detailed stats on. */
var transient UniqueNetId	DetailsPlayerNetId;

/** Nick of the player we are retrieving detailed stats on. */
var transient string		DetailsPlayerNick;

/** Game mode we are currently displaying stats for */
var transient int		GameModeId;
/** Match Type we are currently displaying stats for */
var transient int		MatchTypeId;
/** Start index for this set of online stats currently being read */
var transient int		StatsReadObjectStartIndex;

/** Row index to use for detailed stats info */
var transient int	DetailedStatsRowIndex;

/** The class to load and instance */
var class<Settings> LeaderboardSettingsClass;

/** The set of settings that are to be exposed to the UI for filtering the leaderboards */
var Settings LeaderboardSettings;

/** The data provider that will expose the leaderboard settings to the ui */
var UIDataProvider_Settings SettingsProvider;

/** Reference to the dataprovider that will provide general stats details for a stats row. */
var transient TMUIDataProvider_StatsGeneral GeneralProvider;

/** Reference to the dataprovider that will provide weapons details for a stats row. */
var transient TMUIDataProvider_StatsWeapons WeaponsProvider;

/** Reference to the dataprovider that will provide Vehicle stats details for a stats row. */
var transient TMUIDataProvider_StatsVehicles VehiclesProvider;

/** Reference to the dataprovider that will provide Vehicle Weapons stats details for a stats row. */
var transient TMUIDataProvider_StatsVehicleWeapons VehicleWeaponsProvider;

/** Reference to the dataprovider that will provide rewards stats details for a stats row. */
var transient TMUIDataProvider_StatsRewards RewardsProvider;

/** Array of stat events to read in order. */
var transient array<OnlineStatsRead> ReadQueue;

/**
* Delegate used to notify the caller when stats read has completed
*/
delegate OnStatsReadComplete(bool bWasSuccessful);



// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

/** 
 * @param FieldName		Name of the field to return the provider for.
 *
 * @return Returns a stats element provider given its field name. 
 */
event TMUIDataProvider_StatsElementProvider GetElementProviderFromName(name FieldName)
{
	if(FieldName=='GeneralStats')
	{
		return GeneralProvider;
	}
	else if(FieldName=='WeaponStats')
	{
		return WeaponsProvider;
	}
	else if(FieldName=='VehicleStats')
	{
		return VehiclesProvider;
	}
	else if(FieldName=='VehicleWeaponStats')
	{
		return VehicleWeaponsProvider;
	}
	else if(FieldName=='RewardStats')
	{
		return RewardsProvider;
	}

	return None;
}

/**
 * Game specific function that figures out what type of search to do
 */
function SetStatsReadInfo()
{
	local int ObjectIndex;
	local int PlayerFilterType;

	// Figure out which set of leaderboards to use by gamemode
	LeaderboardSettings.GetStringSettingValue(LF_GameMode,GameModeId);
	LeaderboardSettings.GetStringSettingValue(LF_MatchType,MatchTypeId);

	ObjectIndex = 0;
	switch(MatchTypeId)
	{
	case MTS_Player:
		ObjectIndex += 0;
		break;
	case MTS_Ranked:
		ObjectIndex += 1;
		break;
	}

	//NumTables (4) * Mode (Ranked/NonRanked)
	StatsReadObjectStartIndex = (4 * ObjectIndex) % StatsReadObjects.length;

	// Choose the read object based upon which filter they selected
	StatsRead = StatsReadObjects[StatsReadObjectStartIndex];
	
	// Read the set of players they want to view
	LeaderboardSettings.GetStringSettingValue(LF_PlayerFilterType,PlayerFilterType);
	switch (PlayerFilterType)
	{
		case PFS_Player:
			CurrentReadType = SFT_Player;
			break;
		case PFS_CenteredOnPlayer:
			CurrentReadType = SFT_CenteredOnPlayer;
			break;
		case PFS_Friends:
			CurrentReadType = SFT_Friends;
			break;
		case PFS_TopRankings:
			CurrentReadType = SFT_TopRankings;
			break;
	}
}

/**
 * @param InStatsType	Type to use to determine which read object to return.
 * 
 * @return Returns a read object depending on the current match settings.
 */
function OnlineStatsRead GetReadObjectFromType(EStatsDetailsReadType InStatsType)
{
	local OnlineStatsRead Result;
	local bool bIsCached;

	bIsCached=false;
	Result = None;

	// Make sure that there isnt already a stats read object cached.
	switch(InStatsType)
	{
	case TMSR_Weapons:
		bIsCached = (WeaponsProvider.ReadObject!=None);
		break;
	case TMSR_Vehicles:
		bIsCached = (VehiclesProvider.ReadObject!=None);
		break;
	case TMSR_VehicleWeapons:
		bIsCached = (VehicleWeaponsProvider.ReadObject!=None);
		break;
	default:
		bIsCached=true;
		break;
	}

	if(bIsCached==false)
	{
		Result = StatsReadObjects[StatsReadObjectStartIndex + InStatsType];
	}

	return Result;
}

/** Sets the index for the current player, so we know which stats row to use for results. */
function SetDetailedStatsRowIndex(int InIndex)
{
	DetailedStatsRowIndex = InIndex;

	// Store the ID of the player that we are getting row info for
	DetailsPlayerNetId = StatsRead.Rows[InIndex].PlayerId;
	DetailsPlayerNick = StatsRead.Rows[InIndex].NickName;

	// Invalidate all existing detailed cached reads
	WeaponsProvider.ReadObject=None;
	VehiclesProvider.ReadObject=None;
	VehicleWeaponsProvider.ReadObject=None;

	// Clear the read queue
	ReadQueue.length = 0;
}

/**
 * Adds a read object to the queue of stuff to read.
 *
 * @param ReadObj	Object to add to queue.
 */
function AddToReadQueue(OnlineStatsRead ReadObj)
{
	ReadQueue.length = ReadQueue.length+1;
	ReadQueue[ReadQueue.length-1] = ReadObj;

	TryPumpingQueue();
}

/** Attempts to start a stats read using the queue. */
function TryPumpingQueue()
{
	local array<UniqueNetId> Players;

	if(bInRead==false && ReadQueue.length > 0)
	{
		bInRead = true;

		// Pop first element off the read queue
		StatsRead=ReadQueue[0];
		ReadQueue.Remove(0, 1);

		// Try to start a stats read
		Players[0] = DetailsPlayerNetId;
		if (StatsInterface.ReadOnlineStats(Players, StatsRead) == false)
		{
			;
			bInRead=false;
		}
	}
}

/** @return Returns the current read object index. */
function int GetReadObjectIndex()
{
	return StatsReadObjects.Find(StatsRead);
}

/**
 * Tells the online subsystem to re-read the stats data using the current read
 * mode and the current object to add the results to
 */
event bool RefreshStats(byte ControllerIndex)
{
	bInRead=true;
	return Super.RefreshStats(ControllerIndex);
}

/**
 * Called by the online subsystem when the stats read has completed
 *
 * @param bWasSuccessful whether the stats read was successful or not
 */
function OnReadComplete(bool bWasSuccessful)
{
	local EStatsDetailsReadType ReadType;

	// Clear in the InRead flag.
	bInRead=false;
	
	// Cache the results of the read in the appropriate provider(s) depending on what we just read.
	if(bWasSuccessful)
	{
		if (StatsRead != None)
		{
		ReadType = EStatsDetailsReadType(GetReadObjectIndex()%TMSR_MAX);
		switch(ReadType)
		{
		case TMSR_GeneralAndRewards:
			GeneralProvider.ReadObject=StatsRead;
			RewardsProvider.ReadObject=StatsRead;
			break;
		case TMSR_Weapons:
			WeaponsProvider.ReadObject=StatsRead;
			break;
		case TMSR_Vehicles:
			VehiclesProvider.ReadObject=StatsRead;
			break;
		case TMSR_VehicleWeapons:
			VehicleWeaponsProvider.ReadObject=StatsRead;
			break;
		}
		}

		// Try starting another stats read
		TryPumpingQueue();
	}
	else
	{
		;
	}

	Super.OnReadComplete(bWasSuccessful);
}

/** Resets the stats read object to use the general provider so that the data exposed to the UI is the full list of stats. */
function ResetToDefaultRead()
{
	if(GeneralProvider.ReadObject != None)
	{
		StatsRead=GeneralProvider.ReadObject;
	}
}

