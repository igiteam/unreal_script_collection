/**
 * Alert scene - the thing that pops out of the lower right side to display award/achievement status
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class UIScene_Alert extends GearGFxMoviePlayer
	dependson(GearAlertManager)
	config(UI);

/** The audio component used for each slot */
var transient array<AudioComponent> AudioComponents;

/** Sounds to play when an alert appears and disappears*/
var transient string MedalEntrySound;
var transient string MedalExitSound;
var transient string RibbonEntrySound;
var transient string RibbonExitSound;
var transient string LeaderboardEntrySound;
var transient string LeaderboardExitSound;

/** Amount of time to stay up after it has come in, before it goes away. */
//var config float HoldTime;

/** Array to keep track of which alerts are being used at the moment */
var array<bool> AlertsInProgress;

/** The total number of alerts that are available for use */
var config int NumTotalAlerts;

/** Whether or not we are ready to begin processing alerts */
var bool bReady;

/** Array of alert events that are pending due to either the movie not being ready or the maximum number of alerts being displayed already */
var array<AlertEvent> AlertQueue;

/** Maximum size of the alert queue */
var config int MaxQueueSize;

/** Enforce a minimum time between alerts so that they stagger in */
var config float MinTimeBetweenAlerts;

/** Countdown till the scene is ready for another alert */
var float TimeTillReady;

/** Time in milliseconds that an alert should stay up before transitioning out */
var config float AlertTimeToStayUp_MSEC;

/** Whether or not the alert scene is in personal progression mode
 *  While in personal progression mode all ribbon alerts and any non-progression medal alerts (actually earning the medal) will not show
 *  since the personal progression screen will handle that, in order to reduce clutter
 */
var bool bPersonalProgressionMode;

//Reference to the main bag
var GFxObject MainBag;

/** Initialized widget callback
 *  @return Returns true if the callback is handled at this level
 */
event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
	`log("AlertScene WidgetInitialized: "$WidgetName,,'GearsUI');
	switch (WidgetName)
	{
	case 'MainAnnouncements':
		MainBag = Widget;
		break;
	default:
		return false;
	}
	return true;
}

/**
 * Callback after all widgets have been initialized in a frame
 */
function PostWidgetInit()
{
	bReady = true;
	AudioComponents.Length = NumTotalAlerts;
	AlertsInProgress.Length = NumTotalAlerts;
	ProcessQueue();
}

function PushAlert( const out AlertEvent Event )
{
	if (AlertQueue.Length < MaxQueueSize)
	{
		AlertQueue.AddItem(Event);
		//`Log("Queued: " $ string(Event.type) $ "  Title: " $ Event.Title $ "; " $ string(AlertQueue.Length) $ " in Queue"  );
		ProcessQueue();
	}
}

/** Called when a movie is closed to allow cleanup and handling */
event OnClose()
{
}


/**
 * Get the oldest alert event in the queue to process. Remove that alert event.
 *
 * @param	OutEvent	The alert event to populate with the value from the tail of the queue.
 *
 * @return	True if the alert event was successfully removed; false if the queue is empty.
 */
function bool PopAlert(out AlertEvent OutEvent)
{
	if ( AlertQueue.Length > 0 )
	{
		OutEvent = AlertQueue[0];
		AlertQueue.Remove(0, 1);
		//`Log("Removed event;" $ string(AlertQueue.Length) $ " in Queue");
		return true;
	}
	else
	{
		return false;
	}
}

/**
 * Clear all of the alerts from the queue
 */ 
function ClearAlerts()
{
	if (AlertQueue.Length>0)
	{
		AlertQueue.Length = 0;
	}
}

function ProcessQueue()
{
	local AlertEvent CurrentEvent;
	local int SlotToUse;
	local string ImgPath;
	local string EntrySoundEvent, ExitSoundEvent;
	local bool bHaveValidEvent;

	//If we're not ready or we have no events, short circuit
	if (!bReady || AlertQueue.Length == 0)
	{
		return;
	}

	//Otherwise, do we have room in the scene?
	for (SlotToUse = 0; SlotToUse < NumTotalAlerts; SlotToUse++)
	{
		if (AlertsInProgress[SlotToUse] == false)
		{
			//Reserve the slot!
			AlertsInProgress[SlotToUse] = true;
			break;
		}
	}
	//If we went through the entire list without breaking, then we have no open slots, so return
	if (SlotToUse == NumTotalAlerts)
	{
		return;
	}

	//Now we're going to pop events from AlertQueue until we find a valid event
	while(!bHaveValidEvent && AlertQueue.Length > 0)
	{
		//Get the event to display
		if (!PopAlert(CurrentEvent))
		{
			//If pop fails after the alertqueue length check then something has gone horribly wrong
			return;
		}

		bHaveValidEvent = true;

		//If personal progression mode is on, eat all ribbon and medal earned alerts
		//Show everything else, including medal progression alerts
		if (bPersonalProgressionMode)
		{
			if (CurrentEvent.Type == eALERT_Ribbon)
			{
				bHaveValidEvent = false;
			}
			else if (CurrentEvent.Type == eALERT_Medal && CurrentEvent.BottomNum == 0)
			{
				bHaveValidEvent = false;
			}
		}
	}

	//We have no events!
	if (!bHaveValidEvent)
	{
		return;
	}

	//Change settings based on the type of event
	switch (CurrentEvent.Type)
	{
	case eALERT_Medal:
		EntrySoundEvent = MedalEntrySound;
		ExitSoundEvent = MedalExitSound;
		break;
	case eALERT_Ribbon:
		EntrySoundEvent = RibbonEntrySound;
		ExitSoundEvent = RibbonExitSound;
		break;
	case eALERT_Friend:
		EntrySoundEvent = MedalEntrySound;
		ExitSoundEvent = MedalExitSound;
		ImgPath = "UI_Art_Achievements.T_DefaultIcons_Mail";
		break;
	case eALERT_Leaderboard:
		EntrySoundEvent = LeaderboardEntrySound;
		ExitSoundEvent = LeaderboardExitSound;
		break;
	default:
		`log("UNKNOWN ALERT TYPE!!!! " $CurrentEvent.Type);
	}

	if (CurrentEvent.CustomSoundEvent != "")
	{
		EntrySoundEvent = CurrentEvent.CustomSoundEvent;
	}

	//If the event requested a specific icon, use that instead
	if (CurrentEvent.CustomIcon != "")
	{
		ImgPath = CurrentEvent.CustomIcon;
	}

	SetPause(false);
	TriggerAlert(SlotToUse, CurrentEvent.Type, ImgPath, CurrentEvent.MedalRank, CurrentEvent.Title, CurrentEvent.MsgOne, CurrentEvent.MsgTwo, CurrentEvent.TopNum, CurrentEvent.BottomNum, CurrentEvent.ProgressRepresentation, EntrySoundEvent, ExitSoundEvent);	
}

/** Function to tell the swf to play an alert
 *  @param SlotID - the id of the alert slot to be used
 *  @param AlertType - The type of alert
 *  @param ImagePath - the path to the texture to be used for the image
 *  @param MedalRank - If this is a medal alert, then this will be the rank of the medal to show
 *  @param Title - the localized title to be shown
 *  @param MsgOne - the first localized text to be shown
 *  @param MsgTwo - the second localized text to be shown
 *  @param TopNumber - FRIEND = Not used, MEDAL = The number of things completed towards earning the medal, RIBBON = Exp earned, LEADERBOARD = The number shown on top (at least at first)
 *  @param BottomNumber - FRIEND = Not used, MEDAL = The number of things total to be completed. If this is 0, we will not show the progress bar or the fraction text, RIBBON = Not used, LEADERBOARD = The number shown on bottom (at least at first), or not at all if it is not a compare
 *  @param ProgressRepresentation - How the progress fraction should be representated
 *  @param EntrySoundEvent - sound event to trigger upon alert entry
 *  @param ExitSoundEvent - sound event to trigger upon alert exit
 */
function TriggerAlert(int SlotID, EAlertType AlertType, string ImagePath, int MedalRank, string Title, string MsgOne, string MsgTwo, int TopNumber, int BottomNumber, EProgressRepresentation ProgressRepresentation, string EntrySoundEvent, string ExitSoundEvent)
{
	local array<ASValue> args;
	local ASValue ASVal;

	ASVal.Type = AS_Number;
	ASVal.n = SlotID;
	args.AddItem(ASVal);

	ASVal.n = AlertType;
	args.AddItem(ASVal);

	ASVal.Type = AS_String;
	ASVal.s = "img://"$ImagePath;
	args.AddItem(ASVal);

	ASVal.Type = AS_Number;
	ASVal.n = MedalRank;
	args.AddItem(ASVal);

	ASVal.Type = AS_String;
	ASVal.s = Title;
	args.AddItem(ASVal);

	ASVal.s = MsgOne;
	args.AddItem(ASVal);

	ASVal.s = MsgTwo;
	args.AddItem(ASVal);

	ASVal.Type = AS_Number;
	ASVal.n = TopNumber;
	args.AddItem(ASVal);

	ASVal.n = BottomNumber;
	args.AddItem(ASVal);

	ASVal.n = ProgressRepresentation;
	args.AddItem(ASVal);

	ASVal.Type = AS_String;
	ASVal.s = EntrySoundEvent;
	args.AddItem(ASVal);

	ASVal.s = ExitSoundEvent;
	args.AddItem(ASVal);

	ASVal.Type = AS_Number;
	ASVal.n = AlertTimeToStayUp_MSEC;
	args.AddItem(ASVal);

	MainBag.Invoke("TriggerAlert", args);

	//Block alerts until it is flipped again by the tick
	bReady = false;
	TimeTillReady = MinTimeBetweenAlerts;
}

/** Callback received from the movie when a slot has finished exiting
 *  @param ID - the id of the slot that has finished exiting
 */
function Callback_TransitionOutComplete(int ID)
{
	local int i;
	local bool bAlertInProgress;

	AlertsInProgress[ID] = false;
	ProcessQueue();

	for (i=0; i < AlertsInProgress.Length; i++)
	{
		if (AlertsInProgress[i])
		{
			bAlertInProgress = true;
			break;
		}
	}
	if (!bAlertInProgress)
	{
		SetPause(true);
	}
}

/**
 * Main update function for the alert screen
 * 
 * @param DeltaTime - Time since the last update
 */
final function UpdateAlerts(float DeltaTime)
{
	if (!bReady)
	{
		//Decrement the time till ready countdown if we have not yet reached it
		if (TimeTillReady > 0)
		{
			TimeTillReady -= DeltaTime;

			//If we've just reached the ready time, flip the ready bool and process the queue
			if (TimeTillReady <=0)
			{
				bReady = true;
				ProcessQueue();
			}
		}
	}
}

defaultproperties
{
	CaptureKeys.Empty()
 	MovieInfo=SwfMovie'UI_Common.UI_Alert'
	SoundThemes(0)=(ThemeName=default,Theme=UISoundTheme'UI_Sounds.Theme_Alerts')

	bAllowInput=false
	bAllowFocus=false
	Priority=GEAR_SCENE_PRIORITY_NOTIFICATION
	OnPostAdvance=UpdateAlerts

	bOnlyOwnerFocusable=true
	bCloseOnLevelChange=false

	MedalEntrySound="Alert_SquarePopUp"
	MedalExitSound="Alert_SquareLeave"

	RibbonEntrySound="Alert_RectanglePopUp"
	RibbonExitSound="Alert_RectangleLeave"

	LeaderboardEntrySound="Alert_LeaderboardPopUp"
	LeaderboardExitSound="Alert_LeaderboardLeave"
}
