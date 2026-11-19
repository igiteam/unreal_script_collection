/**
 * Gear calendar event data provider.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearCalendarEventProvider extends UIResourceDataProvider
	config(Calendar);

/** Title of the event */
var string EventTitle;

/** 
 * Description lines for the event.
 * Only the first event (primary) can handle all three lines.  All other events only use EventDescriptionLine1
 */
var string PrimaryEventDescription;
var string EventDescriptionLine1;
var string EventDescriptionLine2;
var string EventDescriptionLine3;

/** IF this is the primary (next) event, this will be used at the background.  Ignored for upcoming events */
var config string EventBackgroundImage;

/** Date that the event will begin */
var config int StartMonth;
var config int StartDay;
var config int StartYear;

/** Date that the event will end */
var config int EndMonth;
var config int EndDay;
var config int EndYear;

/** Whether or not this event is in progress (must be determined server side) */
var config bool bIsInProgress;

/** Whether we've done loc on this object or not */
var bool bHasBeenLoced;

/**
 * Localizes the data for this object from a different source than the package loc file
 */
function LocalizeEvent()
{
	local string LocSection;

	if (!bHasBeenLoced)
	{
		// Build the per object loc section name
		LocSection = Name $ " " $ Class.Name;
		// Read all of the properties by hand
		EventTitle = Localize(LocSection,"EventTitle","GearCalendar");
		PrimaryEventDescription = Localize(LocSection, "PrimaryEventDescription","GearCalendar");
		EventDescriptionLine1 = Localize(LocSection,"EventDescriptionLine1","GearCalendar");
		EventDescriptionLine2 = Localize(LocSection,"EventDescriptionLine2","GearCalendar");
		EventDescriptionLine3 = Localize(LocSection,"EventDescriptionLine3","GearCalendar");
		bHasBeenLoced = true;
	}
}
