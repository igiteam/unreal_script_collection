/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearAwardManager extends Object
	config(Award);
/** Class that manages the Award system */

`include(GearPlayerPersistentDataConstants.uci)

//Prefix prepended to all award names when constructing award objects
var string AwardPrefix;

/** Array of awards */
var transient array<GearAward> Awards;

/** Initialization structure used to read awards from the ini file */
struct AwardInit
{
	//Name of the award
	var name AwardName;
	//Class of the award; uses class'GearAward' if not specified
	var string AwardClassName;
	//Persistent Data Name for the award
	var name PersistentDataName;
	//Whether or not the award can be earned multiple times
	var EAwardRepeatType RepeatType;
	//Location of the image to show
	var string Icon;
	//Rank of the award, for determining crests / stars
	var int    Rank;
	//Name of the sound event to fire off in the alert screen
	var string EarnedSoundEvent;
	var string ProgressSoundEvent;
	//Stats that this award monitors, and what it is looking for
	var array<SpecificStat> StatsToMonitor;
	//The type of the award
	var EAwardType AwardType;
	//The amount of bonus EXP given when the award is earned, if any
	var int ExpBonus;
	//The amount of progress messages to show, if any
	var EAwardProgressType ProgressType;
	//How progress should be represented
	var EProgressRepresentation ProgressRepresentation;
	//Variable used in conjunction with the ProgressType
	var int ProgressArg;
	//The amount to subtract from this award's progress (as it would overlap with a previous, lesser award)
	var int ProgressMinimum;

	structdefaultproperties
	{
		Rank=-1
	}
};

/** Data from the ini file used to initialize the awards */
var config array<AwardInit> AwardInits;


/** Struct that just contains a list of award names */
struct AwardListStruct
{
	var array<name> AwardNames;
};

/** Config structs for controlling the order and grouping that are used to display awards */
var config array<AwardListStruct> MedalDisplayOrder;
var config array<AwardListStruct> RibbonDisplayOrder;

/** Reference to the PC that controls this AwardManager */
var transient GearPC PC;

/** Reference to the stat manager */
var transient GearStatManager StatManager;

/** Structure containing cached data to make data access for groups more efficient and easier to handle */
struct AwardGroupData
{
	/** Cached counts of how many awards of this type have been earned */
	var transient int NumAwardsEarned;
	/** Cached counts of how many of each type of award still needs viewed in the war journal */
	var transient int NumAwardsNeedingViewed;
	/** Indexes into the awards array where we can find each award filtered by the award type */
	var transient array<int> AwardIndexes;
};

/** List of group data for accessing data in an efficient and easier way */
var transient array<AwardGroupData> CachedGroupData;

/** Use AwardInit to create all Award objects and to populate Stats with the Award stats and link them back to Award objects
 *	@param StatManager The GearStatManager object for this controller
 */
function private ConstructAwards()
{
	local int ConfigIndex;
	local GearAward Award;
	local GearStat Stat;
	local AwardInit ConfigAward;
	local class<GearAward> AwardClass;

	for (ConfigIndex = 0; ConfigIndex < AwardInits.Length; ConfigIndex++)
	{
		ConfigAward = AwardInits[ConfigIndex];

		if (ConfigAward.AwardClassName == "")
		{
			// default to base class
			Award = new (self, AwardPrefix$ConfigAward.AwardName) class'GearAward';
		}
		else
		{
			AwardClass = class<GearAward>(FindObject(ConfigAward.AwardClassName, class'Class'));
			if ( AwardClass != None )
			{
				Award = new(self, AwardPrefix $ ConfigAward.AwardName) AwardClass;
			}
			else
			{
				`log("Award:"$ConfigAward.AwardName$" uses class "$ConfigAward.AwardClassName$" that cannot be found");
				break;
			}
		}

		Award.AwardName = ConfigAward.AwardName;
		if (ConfigAward.PersistentDataName == '')
		{
			`Log("-----------------------------AWARD ["$Award.AwardName$"] DOES NOT HAVE A PERSISTENT DATA ID-----------------");
		}
		Award.PersistentDataID = class'GearPlayerPersistentData'.static.FindDefaultProfileMappingIndexByName(ConfigAward.PersistentDataName);
		if (Award.PersistentDataID == -1)
		{
			`Log("-----------------------------AWARD ["$Award.AwardName$"] DOES NOT HAVE A PERSISTENT DATA ID FOR ["$ConfigAward.PersistentDataName$"]-----------------");
		}
		Award.RepeatType = ConfigAward.RepeatType;
		Award.MedalRank = ConfigAward.Rank;
		if (ConfigAward.Icon != "")
		{
			Award.IconPath = ConfigAward.Icon;
		}
		if (ConfigAward.EarnedSoundEvent != "")
		{
			Award.EarnedSoundEvent = ConfigAward.EarnedSoundEvent;
		}
		if (ConfigAward.ProgressSoundEvent != "")
		{
			Award.ProgressSoundEvent = ConfigAward.ProgressSoundEvent;
		}

		Award.StatsToMonitor = ConfigAward.StatsToMonitor;
		Award.AwardType = ConfigAward.AwardType;
		Award.ExpBonus = ConfigAward.ExpBonus;
		Award.ProgressType = ConfigAward.ProgressType;
		Award.ProgressArg = ConfigAward.ProgressArg;
		Award.ProgressMinimum = ConfigAward.ProgressMinimum;
		Award.ProgressRepresentation = ConfigAward.ProgressRepresentation;

		Stat = new(StatManager, StatManager.StatPrefix $ ConfigAward.AwardName) class'GearStat';
		Stat.StatName = Award.AwardName;
		Stat.PersistentDataID = Award.PersistentDataID;

		//We know there is only one period, and it is persistent..but we are recording for all periods now
		Stat.StatDataByPeriod.Length = GEARPERIOD_MAX;

		//Associated the stat with the award
		Award.AssociatedStat = Stat;

		Awards.AddItem(Award);
		StatManager.Stats.AddItem(Stat);
	}
}

/** Use AwardInit to connect Awards to the associated Stats
 *	@param StatManager The GearStatManager object for this controller
 */
function private ConnectAwardsToStats()
{
	local int AwardsIndex;
	local int StatsToMonitorIndex;
	local GearAward Award;

	for (AwardsIndex = 0; AwardsIndex < Awards.Length; AwardsIndex++)
	{
		Award = Awards[AwardsIndex];

		//For each stat to monitor, find its associated stat in the stats table
		for (StatsToMonitorIndex = 0; StatsToMonitorIndex < Award.StatsToMonitor.Length; StatsToMonitorIndex++)
		{
			Award.StatsToMonitor[StatsToMonitorIndex].Stat = StatManager.GetStatByName(Award.StatsToMonitor[StatsToMonitorIndex].StatName);
			if (Award.StatsToMonitor[StatsToMonitorIndex].Stat != None)
			{
				Award.StatsToMonitor[StatsToMonitorIndex].Stat.OnStatModifiedDelegates.AddItem(Award.OnStatModified);
			}
			else
			{
				//Didn't find the stat to monitor. Oh noes!
				`Log("Award("$Award.AwardName$") depends on Stat("$Award.StatsToMonitor[StatsToMonitorIndex].StatName$") which could not be found!");
			}
		}
	}
}

/** Caches needed by the war journal for things like numbers of awards earned and awards needing viewed */
final function CacheAwardDataByGroup()
{
	local int AwardIdx;
	local GearAward Award;

	// Wipe and reset the cached data for grouping
	CachedGroupData.Length = 0;
	CachedGroupData.Length = GEARAWARDTYPE_MAX;

	// Run through all awards
	for (AwardIdx = 0; AwardIdx < Awards.Length; AwardIdx++)
	{
		Award = Awards[AwardIdx];
		if (Award != None)
		{
			// Add the index of this award to the cached list
			CachedGroupData[Award.AwardType].AwardIndexes.AddItem(AwardIdx);

			// If it was earned
			if (HasEarnedAwardByName(Award.AwardName))
			{
				// Increase the cache count
				CachedGroupData[Award.AwardType].NumAwardsEarned++;
				// It's been earned, see if it still needs viewed
				if (AwardNeedsViewed(Award.PersistentDataID))
				{
					// Increase the cache count
					CachedGroupData[Award.AwardType].NumAwardsNeedingViewed++;
				}
			}
		}
	}
}

/** Initialize the manager from the config variables
 *  @param GPC The PC for this player
 *	@param StatManager The GearStatManager object for this controller
 */
function InitializeManager(GearPC GPC, GearStatManager StatMan)
{
	PC = GPC;
	StatManager = StatMan;
	//1. Wipe any existing data
	Awards.Length = 0;
	//2. Create all Award objects and populate Stats with the Award stats and link the Award objects to them
	ConstructAwards();
	//3. Connect Awards to the associated Stats
	ConnectAwardsToStats();
	// Cache award data based on group
	CacheAwardDataByGroup();
}

/** Actually award the award
 *	@param Award The award earned
 */
function AwardEarned(GearAward Award)
{
	local GearAlertManager GAM;
	local EAlertType AlertType;

	if (Award != None && Award.CanGiveAward())
	{
		//`Log("---------------------AWARD EARNED!!!! "$Award.AwardName);
		StatManager.RecordAwardEarned(Award);

		PC.ServerPlayerEarnedAward(Award.Name, Award.ExpBonus, Award.PersistentDataID);
		if (Award.AwardType == GEARAWARDTYPE_Fortification)
		{
			// awards affect unlocked fortifications so update that info
			PC.InitFortificationUpgradeLevels();
		}
		if (Award.AwardType != GEARAWARDTYPE_Ribbon)
		{
			// Send information to other people in the Xbox Live Party about the award
			PC.UpdatePartyWithAwardInfo(Award);
			AlertType = eALERT_Medal;
		}
		else
		{
			AlertType = eALERT_Ribbon;
		}

		GAM = GearLocalPlayer(PC.Player).AlertManager;
		if (GAM != none)
		{
			GAM.Alert(AlertType, Award.GetNameString(Award.AwardName), 
					Award.GetDescString(Award.AwardName), "" , Award.ExpBonus, 0, GEARAWARDPROGREP_Integer,
					Award.IconPath,Award.MedalRank,Award.EarnedSoundEvent);
		}

		// Store in the profile that this is the most recent challenge earned
		if (PC != None && PC.ProfileSettings != None)
		{
			// Not all award types are viewed as challenges in the war journal
			if (Award.AwardType == GEARAWARDTYPE_Ribbon ||
				Award.AwardType == GEARAWARDTYPE_WeaponSkin ||
				Award.AwardType == GEARAWARDTYPE_Character ||
				Award.AwardType == GEARAWARDTYPE_Mutator ||
				Award.AwardType == GEARAWARDTYPE_Execution ||
				Award.AwardType == GEARAWARDTYPE_AvatarItem)
			{
				// We only show the earned challenge in the challenge history of the WJ if this
				// is the first instance of earning it
				if (Award.GetNumTimesEarned() == 1)
				{
					PC.ProfileSettings.SetMostRecentlyEarnedChallenge(Award.PersistentDataID);
				}
			}
		}

		// Handles the cached data needed by the war journal
		UpdateCachedDataForWarJournal(Award);

		if (Award.AwardType == GEARAWARDTYPE_Medal)
		{
			if (InStr(string(Award.AwardName),"_4") != INDEX_NONE)
			{
				// @ACHIEVEMENT - Award Winning Tactics
				PC.ClientUnlockAchievement(eGA_AWARDWINNINGTACTICS);
			}
		}
	}
	else
	{
		`Log("Attempted to earn an invalid award, or attempted to earn an award that can only be given once.");	
	}
}

/** Removes the award from the player */
function ClearAward(name AwardName)
{
	if (AwardName != '' && StatManager != None)
	{
		//`Log("---------------------AWARD CLEARED!!!! "$Award.AwardName);
		StatManager.ModifyStat(AwardName, 0, GEARSTATMODTYPE_Set);
	}
}

/** Function that initializes the ProgressNumerator and ProgressDenominator for all awards */
function UpdateAwardProgress()
{
	local int i;

	for (i = 0; i < Awards.Length; i++) 
	{
		Awards[i].ComputeProgress();
	}
}

/** 
 * Gets the progress towards earning the next medal in the specified category
 * 
 * @param   Index               The position in the MedalDisplayOrder array that you are querying about
 * @param   CurrentProgress     (out) Current progress towards earning the award
 * @param   TotalProgress       (out) Total progress required to earn the award
 */
function GetProgressTowardsNextLevel(int Index, out int CurrentProgress, out int TotalProgress)
{
	local int i;
	local name AwardName, LastAwardName;
	local GearAward Award;

	// Initialize
	CurrentProgress = 0;
	TotalProgress = 0;

	// Make sure this is a valid index
	if( Index >= 0 && Index < MedalDisplayOrder.Length )
	{
		LastAwardName = MedalDisplayOrder[Index].AwardNames[0];

		// Iterate over awards in this category, and break on the first award that we have earned in the category
		for (i = 0; i < MedalDisplayOrder[Index].AwardNames.Length; i++)
		{
			AwardName = MedalDisplayOrder[Index].AwardNames[i];
			if (HasEarnedAwardByName(AwardName))
			{
				// Found the first earned award, so LastAwardName is the one we're working towards
				break;
			}
			
			LastAwardName = AwardName;
		}

		// LastAwardName will contain the last medal that has NOT been earned, so get progress towards it
		Award = GetAwardByName(LastAwardName);
		Award.GetProgress(CurrentProgress, TotalProgress);
	}

	return;
}

/**
 *  Function to look up an award by it's PersistentDataID
 *  NOTE: This is VERY SLOW compared to GetAwardByName
 *
 *	@param PersistentDataID - The unique identifier of this award in the persistent data store
 *	@return	The GearAward that matches the given PersistentDataID, or None if it cannot find an award that matches
 */
final function GearAward FindAwardByPersistentDataID(int PersistentDataID)
{
	local GearAward Award;

	foreach Awards(Award)
	{
		if (Award.PersistentDataID == PersistentDataID)
		{
			return Award;
		}
	}
	`Log("FindAwardByPersistentDataID unable to find award"@PersistentDataID);
	return None;
}

final function bool HasEarnedAwardByName(name AwardName, optional ERecordingPeriodType Period=GEARPERIOD_Persistent)
{
	return (StatManager.GetStatValueByName(AwardName, Period) > 0);
}

/**
 * The number of times the award has been earned for the specified time period
 *
 * @param AwardName the name of the award to look up
 * @param Period the time period that you are querying
 *
 * @return the earned count
 */
final function int GetAwardEarnedCountByName(name AwardName,optional ERecordingPeriodType Period=GEARPERIOD_Persistent)
{
	return StatManager.GetStatValueByName(AwardName, Period);
}

/** Returns the award using the name of the award as a key */
final function GearAward GetAwardByName(Name AwardName)
{
	//Searching for award '' is asking for none
	if (AwardName == '')
	{
		return none;
	}
	return GearAward(FindObject(PathName(self) $"."$ AwardPrefix $ string(AwardName), class'GearAward'));
}

/** Returns the index into the award list using the name of the award as a key */
final function int GetAwardIndex(GearAward GAward)
{
	return Awards.Find(GAward);
}

/**
 * Gets the Medal that should be shown for the given order position and whether or not that Medal has been earned yet
 *
 * @param OrderPosition - The position in the MedalDisplayOrder array that you are querying about
 * @param MedalName - the name of the Medal that should be show in the position specified
 *
 * @return Whether or not the Medal that should be shown has been earned yet.
 */
final function bool GetBestMedalForPosition(int OrderPosition, out name MedalName)
{
	return GetBestAwardForPosition(OrderPosition, MedalName, MedalDisplayOrder);
}

/**
 * Gets the Ribbon that should be shown for the given order position and whether or not that Ribbon has been earned yet
 *
 * @param OrderPosition - The position in the RibbonDisplayOrder array that you are querying about
 * @param RibbonName - the name of the Ribbon that should be show in the position specified
 *
 * @return Whether or not the Ribbon that should be shown has been earned yet.
 */
final function bool GetBestRibbonForPosition(int OrderPosition, out name RibbonName)
{
	return GetBestAwardForPosition(OrderPosition, RibbonName, RibbonDisplayOrder);
}


/**
 * Gets the award that should be shown for the given order position and whether or not that award has been earned yet
 *
 * @param OrderPosition - The position in the RibbonDisplayOrder array that you are querying about
 * @param AwardName - the name of the award that should be show in the position specified
 * @param AwardOrderArray - The array of award orders that should be used
 *
 * @return Whether or not the award that should be shown has been earned yet.
 */
final function bool GetBestAwardForPosition(int OrderPosition, out name AwardName, const out array<AwardListStruct> AwardOrderArray)
{
	local int i;
	local GearAward Award;

	for (i=0; i < AwardOrderArray[OrderPosition].AwardNames.Length; i++)
	{
		AwardName = AwardOrderArray[OrderPosition].AwardNames[i];
		if (HasEarnedAwardByName(AwardOrderArray[OrderPosition].AwardNames[i]))
		{
			return true;
		}
	}
	//HOWEVER, if the award is of type epic, and you havent earned it, then return nothing
	Award = GetAwardByName(AwardName);
	if (Award != none && Award.AwardType == GEARAWARDTYPE_Epic)
	{
		AwardName = '';
	}
	return false;
}

/** Whether a bit is set or not in a 32 bit integer */
final static function bool BitIsSet( int IntegerValue, int BitIndex )
{
	return (IntegerValue & (1<<BitIndex)) != 0;
}

/** How many bits are set in an integer */
final static function int NumBitsSet(int IntegerValue)
{
	local int TotalSet;
	local int Idx;

	for (Idx = 0; Idx < `NUM_BITS_PER_INT; Idx++)
	{
		TotalSet += ((IntegerValue & (1<<Idx)) != 0) ? 1 : 0;
	}

	return TotalSet;
}

/**
 * Returns how many awards of a given type exist in the war journal
 *
 * @param AwardType - the category of award we are inquiring about
 */
final function int GetNumTotalAwardsByType(EAwardType AwardType)
{
	return CachedGroupData[AwardType].AwardIndexes.Length;
}

/**
 * Returns how many awards of a given type have been earned for the war journal
 *
 * @param AwardType - the category of award we are inquiring about
 */
final function int GetNumAwardsEarnedByType(EAwardType AwardType)
{
	return CachedGroupData[AwardType].NumAwardsEarned;
}

/**
 * Returns how many awards of a given type need to be viewed in the war journal
 *
 * @param AwardType - the category of award we are inquiring about
 */
final function int GetNumAwardsNeedingViewedByType(EAwardType AwardType)
{
	return CachedGroupData[AwardType].NumAwardsNeedingViewed;
}

/**
 * Returns whether an award needs viewed in the war journal or not
 *
 * @param AwardPersId - the persistent id of the award in question
 */
final function bool AwardNeedsViewed(int AwardPersId)
{
	local int NeedsViewedDataID;
	local int ShiftValue;
	local int NeedsViewedValue;

	// Make sure we have a data storage
	if (PC != None && PC.PersistentData != None)
	{
		// Calculate the data id of the integer that this award's "needs viewed" flag would reside
		NeedsViewedDataID = `NeedsViewed_0 + AwardPersId / `NUM_BITS_PER_INT;
		// Calculate the bit shift value for this award within the integer it resides
		ShiftValue = AwardPersId % `NUM_BITS_PER_INT;

		// Get the value from the data storage
		NeedsViewedValue = PC.PersistentData.GetValue(NeedsViewedDataID);

		// Return whether the bit is set or not
		return BitIsSet(NeedsViewedValue, ShiftValue);
	}

	return false;
}

/**
 * Handles the cached data needed by the war journal, such as what's been earned and what needs viewed
 *
 * @param Award - the award that was just earned
 */
final function UpdateCachedDataForWarJournal(GearAward Award)
{
	// Increment the count for the things that have been earned
	CachedGroupData[Award.AwardType].NumAwardsEarned++;

	// Mark the flag that tells the UI that this needs to be viewed
	MarkAwardForViewing(Award);
}

/**
 * Marks an award as "needing to be viewed" by the war journal
 *
 * @param Award - the award to mark for viewing
 */
final function MarkAwardForViewing(GearAward Award)
{
	local int NeedsViewedDataID;
	local int ShiftValue;
	local int NeedsViewedValue;
	local int NewNeedsViewedValue;

	// Make sure we have a data storage
	if (PC != None && PC.PersistentData != None)
	{
		// Calculate the data id of the integer that this award's "needs viewed" flag would reside
		NeedsViewedDataID = `NeedsViewed_0 + Award.PersistentDataID / `NUM_BITS_PER_INT;
		// Calculate the bit shift value for this award within the integer it resides
		ShiftValue = Award.PersistentDataID % `NUM_BITS_PER_INT;

		// Get the value from the data storage
		NeedsViewedValue = PC.PersistentData.GetValue(NeedsViewedDataID);
		// Mark the bit to be set in the storage
		NewNeedsViewedValue = NeedsViewedValue | (1 << ShiftValue);

		if (NewNeedsViewedValue != NeedsViewedValue)
		{
			// Set the value in the data storage
			PC.PersistentData.SetValue(NeedsViewedDataID, NewNeedsViewedValue);
			// Fix the count for this award's type
			CachedGroupData[Award.AwardType].NumAwardsNeedingViewed++;
		}
	}
}

/**
 * Clears an award from "needing to be viewed" by the war journal
 *
 * @param Award - the award to clear the viewing from
 */
final function ClearAwardForViewing(GearAward Award)
{
	local int NeedsViewedDataID;
	local int ShiftValue;
	local int NeedsViewedValue;
	local int NewNeedsViewedValue;
	local int NegateMaskValue;

	// Make sure we have a data storage
	if (PC != None && PC.PersistentData != None)
	{
		// Calculate the data id of the integer that this award's "needs viewed" flag would reside
		NeedsViewedDataID = `NeedsViewed_0 + Award.PersistentDataID / `NUM_BITS_PER_INT;
		// Calculate the bit shift value for this award within the integer it resides
		ShiftValue = Award.PersistentDataID % `NUM_BITS_PER_INT;

		// Get the value from the data storage
		NeedsViewedValue = PC.PersistentData.GetValue(NeedsViewedDataID);
		// Clear the bit to be set in the storage
		NegateMaskValue = ~(1 << ShiftValue);
		NewNeedsViewedValue = NeedsViewedValue & NegateMaskValue;

		if (NewNeedsViewedValue != NeedsViewedValue)
		{
			// Set the value in the data storage
			PC.PersistentData.SetValue(NeedsViewedDataID, NewNeedsViewedValue);
			// Fix the count for this award's type
			CachedGroupData[Award.AwardType].NumAwardsNeedingViewed--;
		}
	}
}


defaultproperties
{
	AwardPrefix="GEARAWARD_"
}
