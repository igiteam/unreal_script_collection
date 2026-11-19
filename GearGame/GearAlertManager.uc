/**
 * GearAlertManager
 *
 * Keeps track of how/when the player should be notified about their progress
 * with regard to achievements, collectibles, etc...
 *
 * When appropriate notifies the player that they have made progress.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearAlertManager extends Object
	config(Game)
	transient;

const ModuleName = "[GearAlertManager] ";

/** The GearLocalPlayer to which this GearAlertManager belongs. */
var transient GearLocalPlayer MyGLP;

/** The UI Scene which actually displays the popups. */
var transient UIScene_Alert AlertMovie;
var transient String AlertClassName;

/** If true, no further alerts will be displayed */
var transient bool bSuppressAlerts;

const MAX_FREQUENCIES = 10;
// - - - - - - - Config stuff - - - - - - -
/**
 * Stores data about how to notify the player about various progresses
 *  e.g. How often to notify about kill-total based acheivements
 */
struct ProgressInfo
{
	/** Which achievement */
	var EGearAchievement GoalId;
	/** Every time that we have achieved something N times and N is a multiple of Every, we should show a progress notification. If Every is -1 we should always show progress. */
	var int Every;
	/** Whenever we have achieved something N tmies, and N is in the At array we should show a progress notification */
	var int At[MAX_FREQUENCIES];
};

/** Config how to notify about achievement progress */
var config transient array<ProgressInfo> AchievementProgressInfo;


/** 
 *  The types of alerts that can be sent 
 *  THIS IS MIRRORED IN AlertView.as. MAKE SURE THEY STAY IN SYNCH.
 */
enum EAlertType
{
	eALERT_Friend,
	eALERT_Medal,
	eALERT_Ribbon,
	eALERT_Leaderboard,
};

/**
 * Represents an alert that the player will see.
 */
struct AlertEvent
{
	/** The kind of alert to show */
	var transient EAlertType Type;
	/** The title of this alert; should be an effective summary */
	var transient string Title;
	/** Optional custom text */
	var transient string MsgOne;
	var transient string MsgTwo;
	/** Optional numbers - used for progress, leaderboard score, and ribbon exp amongst other things */
	var transient int TopNum;
	var transient int BottomNum;
	/** An alternate icon to use instead of the default */
	var transient string	CustomIcon;
	/** If this is a medal event, the rank of the medal */
	var transient int       MedalRank;
	/** The sound event to play when this alert is earned, if any. Note, that this is the event name, from the alert sound theme, NOT a sound cue */
	var transient string  CustomSoundEvent;
	/** How the progress fraction should be represented */
	var transient EProgressRepresentation ProgressRepresentation;
};

/**
 * GearAlertManager needs to know its GearPC owner in order to handle
 * achievement progress notification.
 *
 * @param GLP - is the local player owner of this alert manager
 */
function InitGearAlertManager(GearLocalPlayer GLP)
{
	local class<UIScene_Alert> AlertMovieClass;

	MyGLP = GLP;
	if (AlertMovie == none)
	{
		AlertMovieClass = class<UIScene_Alert>(DynamicLoadObject(AlertClassName, class'Class'));
		if (AlertMovieClass != None)
		{
			AlertMovie = new(self) AlertMovieClass;
			AlertMovie.Init(GLP);
		}
	}
}

/** Queue in an alert
 *  @param Type - The type of alert to show
 *  @param Title - the localized title to be shown
 *  @param MsgOne - the first localized text to be shown
 *  @param MsgTwo - the second localized text to be shown
 *  @param TopNum - FRIEND = Not used, MEDAL = The number of things completed towards earning the medal, RIBBON = Exp earned, LEADERBOARD = The number shown on top (at least at first)
 *  @param BottomNum - FRIEND = Not used, MEDAL = The number of things total to be completed. If this is 0, we will not show the progress bar or the fraction text, RIBBON = Not used, LEADERBOARD = The number shown on bottom (at least at first), or not at all if it is not a compare
 *  @param ProgressRepresentation - How the progress fraction should be displayed
 *  @param CustomIcon - Path to a custom picture to be displayed
 *  @param MedalRank - Rank of the medal, if this is a medal alert
 *  @param CustomSoundEvent - Sound event to play when this alert is shown
 */
function Alert(EAlertType Type, optional string Title="", optional string MsgOne="", optional string MsgTwo="", optional int TopNum, optional int BottomNum, optional EProgressRepresentation ProgressRepresentation, optional string CustomIcon="", optional int MedalRank=-1, optional string CustomSoundEvent="")
{
	local AlertEvent EventToPush;

	// If we are suppressing alerts, just quick exit out
	if (bSuppressAlerts)
	{
		return;
	}

	EventToPush.Type = Type;
	EventToPush.Title = Title;
	EventToPush.MsgOne = MsgOne;
	EventToPush.MsgTwo = MsgTwo;
	EventToPush.TopNum = TopNum;
	EventToPush.BottomNum = BottomNum;
	EventToPush.ProgressRepresentation = ProgressRepresentation;
	EventToPush.CustomIcon = CustomIcon;
	EventToPush.MedalRank = MedalRank;
	EventToPush.CustomSoundEvent = CustomSoundEvent;


	if (AlertMovie != none)
	{
		AlertMovie.PushAlert(EventToPush);
	}
}

/**
 * Notify the alert manager that progress has been made; we may or may not queue an alert.
 *
 * @param Type	Type of progress: e.g. ePROG_Collectible, ePROG_Achievement
 * @param GoalId	The specific goal towards which progress has been made; e.g. eGA_Seriously2
 */
function MadeProgress( EProgressType Type, int GoalId )
{
	local AlertEvent EventToPush;
	local AchievementDetails AchievDetails;
	local float Current, Max;
	local GearUIDataStore_GameResource GameResourceDS;
	local string DataDumpster; //Throw away data
	/** Guests do not get any achievements, unlocks or progress */
	local bool bIsGuest;
	local GearPC MyGearPC;

	MyGearPC = GetGPC();

	if ( MyGearPC != none && MyGearPC.OnlineSub != None )
	{
		bIsGuest = MyGearPC.OnlineSub.PlayerInterface.IsGuestLogin( MyGearPC.GetControllerId() );
	}

	if (!bIsGuest)
	{
		switch( Type )
		{
			case ePROG_Achievement:
				if ( !class'UIInteraction'.static.IsLoggedIn( MyGearPC.GetControllerId() ) )
				{
					// is user isn't signed into a profile, they cannot recieve achievements so don't show achievement progression
					return;
				}

				EventToPush.Type = eALERT_Medal;
				MyGearPC.OnlinePlayerData.AchievementsProvider.GetAchievementDetails(GoalId, AchievDetails);
				MyGearPC.GetAchievementProgression(GoalId, Current, Max);
				//`log( "GearAlertManager: " $ string(GoalId) $ " : " $ string(Current) $ " / " $ string(Max) );
				EventToPush.Title = AchievDetails.AchievementName;
				// Set the achievement's icon
				EventToPush.CustomIcon="UI_Art_Achievements.T_DefaultIcons_Icon";//MyGearPC.OnlinePlayerData.AchievementsProvider.GetAchievementIconPathName(GoalId);

				if ( int(Max) == 0 )
				{
					`warn( "GearAlertManager: THIS SHOULD NEVER HAPPEN! Showing because max is 0 : " @ string(GoalId) @ "(" $ string(Current) $ "/" $ string(Max) $ ")" );
					EventToPush.MsgOne = "Max == 0";
					EventToPush.MsgTwo = "";
					EventToPush.BottomNum = 0;
				}
				else
				{
					if ( !ShouldShowProgressionAlert( EGearAchievement(GoalId), int(Current), int(Max) ) )
					{
						// We don't need to actually show a progress alert.
						//`log( "GearAlertManager: Not showing: " @ string(GoalId) @ "(" $ string(Current) $ "/" $ string(Max) $ ")" );
						return;
					}

					EventToPush.MsgOne = "";
					EventToPush.MsgTwo = "";
					EventToPush.TopNum = Current;
					EventToPush.BottomNum = Max;
				}
				break;
			case ePROG_Collectible:
				EventToPush.Type = eALERT_Medal;
				GameResourceDS = class'GearUIManager'.static.GetGameResourceDataStore();
				GameResourceDS.GetDiscoverableDisplayStrings( EGearDiscoverableType(GoalId), EventToPush.Title, DataDumpster );
				break;
			case ePROG_Unlockable:
				EventToPush.Type = eALERT_Medal;
				GameResourceDS = class'GearUIManager'.static.GetGameResourceDataStore();
				GameResourceDS.GetUnlockableDisplayStrings(GoalId,eventToPush.MsgOne, DataDumpster);
				EventToPush.Title = Localize("AlertStrings", "UnlockTitle", "GearGameUI");
				break;
			default:
				`warn("GearAlertManager: Unsupported Progress Event Type.");
				break;
		}


		//`Log("Achievement Alert: " $ EventToPush.Type $ ", " $ EventToPush.Title $ ", " $ EventToPush.SubText $ ", " $ EventToPush.PercentComplete $ ", " $ EventToPush.CustomIcon $ ".")

		if (AlertMovie != none)
		{
			AlertMovie.PushAlert(EventToPush);
		}
	}
}


/**
 * Checks the Frequencies for Achievement Progress Alerts and decides if this step
 * in the progression warrants an on-screen Alert.
 *
 * Meaning of the array:
 * The 'At' array should contain positive numbers in ascending order
 * followed by negative number in ascending order.
 *   e.g. {10, 20, 100, -100, -20, -5}
 * Positive numbers mean notify when the progress equals that number;
 * in the example above notify at 10, 20, 100, and 1000.
 * Negative numbers mean notify when the progress is MAX-abs(number);
 * if we're dealing with Seriously2 which required 100,000 kills we would
 * trigger at 99,900, at 99,980 and at 99,995.
 *
 * Every time Current is a multiple of 'Every' we also display a notification.
 *
 * @param GoalId	An EGearAchievement that player made progress in.
 * @param Current	The current progress value e.g. 20 kills or 5 executions
 * @param Max		The goal number to be achieved; e.g. 100,000 kills for Seriously2
 *
 * @return true if we this progression warrants a notification; false otherwise
 */
function bool ShouldShowProgressionAlert( EGearAchievement GoalId, int Current, int Max )
{
	local int CurIdx;
	local int ProgInfoIdx;
	local ProgressInfo ProgInfo;


	// We should not alert if the achievement has been achieved because a Live popup will appear.
	if ( Current < Max )
	{
		// Look for the structure describing this achievement's notification frequency...
		ProgInfoIdx = AchievementProgressInfo.Find( 'GoalId', GoalId );
		if ( ProgInfoIdx < 0 )
		{
			// If we cannot find it then always show the notification.
			`log( "GearAlertManager: Could not find frequency info for achievement " $ string( GoalId ) $ ". Displaying notification." );
			return false;
		}
		ProgInfo = AchievementProgressInfo[ProgInfoIdx];

		// If the Every field is set then check to see if we are currently on a multiple of it.
		if ( ProgInfo.Every != 0 && Current % ProgInfo.Every == 0 )
		{
			`log( "GearAlertManager: Achievement checkpoint for " $ string( GoalId ) $ " at " $ Current $ " / " $ Max $ ". (Every " $ ProgInfo.Every $ ".");
			return true;
		}

		// Iterate through all the positive numbers
		for (CurIdx=0; CurIdx < MAX_FREQUENCIES; CurIdx++)
		{
			if ( ( Current > 0 && Current == ProgInfo.At[CurIdx] ) ||
				 ( Current < 0 && Max-Current == ProgInfo.At[CurIdx]) )
			{
				`log( "GearAlertManager: Achievement checkpoint for " $ string( GoalId ) $ " at " $ Current $ " / " $ Max $ ". Displaying notification." );
				return true;
			}
		}

	}

	return false;
}

function GearPC GetGPC()
{
	return GearPC(MyGLP.Actor);
}

/**
 * Allows locking out Alerts so that they won't appear while recording video
 */
function ToggleAlertLockout()
{
	bSuppressAlerts = ! bSuppressAlerts;
	if (bSuppressAlerts)
	{
		AlertMovie.ClearAlerts();
	}
}


DefaultProperties
{
	AlertClassName = "GearGame.UIScene_Alert"
}
