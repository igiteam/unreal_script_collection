/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class UIWidget_Calendar extends GFxObject;

// --- Widget References ---------------------------------------
var transient GFxObject CalendarView;

// --- Localized Strings ---------------------------------------
var localized string    CalendarTitle;
var localized string    ButtonBarString;
var localized string    UpcomingEventsString;

// ---- Other Vars ---------------------------------------------
var transient string    CurrentEventHeaderString;

//==============================================================
// Interface
//==============================================================

/**
 * Opens up the calendar view
 */
function OpenCalendarView()
{
	// Open the calendar
	ActionScript_OpenCalendarView();

	// Populate the calendar with data
	InitializeEvents();

	// Blur the frontend
	UIScene_FrontEnd(Outer).BlurMainMenu();
}

/**
 * Closes the calendar view
 */
function CloseCalendarView()
{
	ActionScript_CloseCalendarView();

	// Unblur the frontend
	UIScene_FrontEnd(Outer).UnblurMainMenu();
}

/**
 * Returns whether or not we're currently animating in or out
 * 
 * @return TRUE if the scene is currently animating, FALSE otherwise
 */
function bool IsBusyAnimating()
{
	return GetBool("bIsAnimating");
}

/**
 * Gets the data for the current and upcoming events, and populates the widgets accordingly
 */
function InitializeEvents()
{
	local GFxObject DataProvider, EventObj, UpcomingEventList;
	local array<GearCalendarEventProvider> EventList;
	local GearCalendarEventProvider CurrentEvent;
	local int i;
	
	// Grab the events from the data store
	class'GearUIDataStore_GameResource'.static.GetCalendarEvents(EventList);

	// Fill the strings with their special INT file
	for (i = 0; i < EventList.Length; i++)
	{
		EventList[i].LocalizeEvent();
	}

	// Sort the list of events
	EventList.Sort(EventSort);

	DataProvider = CreateObject("Object");
	DataProvider.SetString("PageTitle", CalendarTitle);
	DataProvider.SetString("CurrentDate", GearGFxMoviePlayer(Outer).GetCurrentDateString());
	DataProvider.SetString("ControllerMap", ButtonBarString);
	DataProvider.SetString("UpcomingEventsTitle", UpcomingEventsString);

	// Handle the first event, if any
	if( EventList.Length > 0 )
	{
		// Special Case: get the primary event first
		CurrentEvent = EventList[0];

		DataProvider.SetBool("bPrimaryEventIsActive", CurrentEvent.bIsInProgress);
		DataProvider.SetString("PrimaryEventTitle", CurrentEvent.EventTitle);
		DataProvider.SetString("PrimaryEventDate", GetDurationStringForEvent(CurrentEvent));
		DataProvider.SetString("PrimaryEventDesc", CurrentEvent.PrimaryEventDescription);
		DataProvider.SetString("PrimaryEventBullet1", CurrentEvent.EventDescriptionLine1);
		DataProvider.SetString("PrimaryEventBullet2", CurrentEvent.EventDescriptionLine2);
		DataProvider.SetString("PrimaryEventBullet3", CurrentEvent.EventDescriptionLine3);
		if( CurrentEvent.EventBackgroundImage != "" )
		{
			DataProvider.SetString("PrimaryEventBackground", "img://" $ CurrentEvent.EventBackgroundImage);
		}

		// Iterate over remaining events (up to 4 additional events), and add their abbreviated descriptions
		// Add the upcoming event array to the provider only if there were events added
		if( EventList.Length > 1 )
		{
			UpcomingEventList = CreateArray();
			for( i = 1; i < EventList.Length; i++ )
			{
				CurrentEvent = EventList[i];

				EventObj = CreateObject("Object");
				EventObj.SetString("EventDate", GetDurationStringForEvent(CurrentEvent));
				EventObj.SetString("EventTitle", CurrentEvent.EventTitle);
				EventObj.SetString("EventDesc", CurrentEvent.EventDescriptionLine1);

				UpcomingEventList.SetElementObject(i-1, EventObj);
			}

		
			DataProvider.SetObject("UpcomingEvents", UpcomingEventList);
		}
	}

	ActionScript_SetDataProvider(DataProvider);
}

//==============================================================
// Helper functions
//==============================================================

/**
 * Whether or not the specified value is in the specified range
 * 
 * @param   TestVal     Value to test
 * @param   Min         Minimium value to test against
 * @param   Max         Maximum value to test against
 * 
 * @return              TRUE if the value is within the range, FALSE if not
 */
function bool IsInRange(int TestVal, int Min, int Max)
{
	return (TestVal >= Min) && (TestVal <= Max);
}

/**
 * Returns the number of days in the month, or -1 for an invalid month
 * 
 * @param   Month   Month to get the days for (note:  Feb (2) returns 29 to account for leap year
 * @return  The maximum number of days that can be in a specified month, or -1 if the month was invalid.
 */
function int GetDaysInMonth(int Month)
{
	// Test for out of bounds input
	if( !IsInRange(Month, 1, 12) )
	{
		return -1;
	}

	// Thirty days hath September...
	switch(Month)
	{
		case 2:
			return 29;
		case 4:
		case 6:
		case 9:
		case 11:
			return 30;
		default:
			return 31;
	}
}

function string GetDurationStringForEvent( GearCalendarEventProvider Event )
{
	// Simple case, check to see if the event starts and stops on the same day
	if( Event.StartYear == Event.EndYear 
		&& Event.StartMonth == Event.EndMonth 
		&& Event.StartDay == Event.EndDay )
	{
		return GearGFxMoviePlayer(Outer).GetDateString(Event.StartYear, Event.StartMonth, Event.StartDay, TRUE);
	}
	// Otherwise, format the start and end dates and enter a hyphen
	else
	{
		return GearGFxMoviePlayer(Outer).GetDateString(Event.StartYear, Event.StartMonth, Event.StartDay, TRUE) @ "-" @ GearGFxMoviePlayer(Outer).GetDateString(Event.EndYear, Event.EndMonth, Event.EndDay, TRUE);
	}

}

/**
 * Tests whether or not the specified event is a single-day event
 * 
 * @param   Event   Event to test
 * @return          TRUE if the event is a single day event, FALSE otherwise 
 */
function bool IsSingleDayEvent(GearCalendarEventProvider Event)
{
	return (Event.StartYear == Event.EndYear
			&& Event.StartMonth == Event.EndMonth 
			&& Event.StartDay == Event.EndDay );
}

/**
 * Sorting delegate for ordering GearCalendarEventProvider
 * 
 * @param   Event1  First event to check
 * @param   Event2  Second event to check
 * 
 * @return  Negative number if the two should be swapped, 0 if not
 */
final function int EventSort( GearCalendarEventProvider Event1, GearCalendarEventProvider Event2 )
{
	if( (Event1.StartYear < Event2.StartYear)
		|| (Event1.StartYear == Event2.StartYear && Event1.StartMonth < Event2.StartMonth)
		|| (Event1.StartYear == Event2.StartYear && Event1.StartMonth == Event2.StartMonth && Event1.StartDay <= Event2.StartDay) )
	{
		return 0;
	}
	else
	{
		return -1;
	}
}

//==============================================================
// ActionScript Stubs
//==============================================================

private function ActionScript_OpenCalendarView()
{
	ActionScriptVoid("OpenCalendarView");
}

private function ActionScript_CloseCalendarView()
{
	ActionScriptVoid("CloseCalendarView");
}

private function ActionScript_SetDataProvider(GFxObject UpcomingEventDP)
{
	ActionScriptVoid("SetDataProvider");
}

defaultproperties
{
}
