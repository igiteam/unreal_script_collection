/**
 * Callout screen:  Used to manage in-game credits and location / setting / dramatic text display
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class UIScene_Callouts extends GearGFxMoviePlayer
	config(UI);

// --- Widget References ------------------------------
/** Reference to the container for the opening credits */
var transient GFxObject     OpeningCredits;

/** Reference to the container for the act / chapter display */
var transient GFxObject     ActChapterBanner;
/** Labels for the act / chapter display */
var transient GFxObject     lbl_ActName;
var transient GFxObject     lbl_ChapterName;

/** Labels for the location / time display */
var transient GFxObject     lbl_StoryLocation;
var transient GFxObject     lbl_StoryTime;

/** Reference to the container for the credits display */
var transient GFxObject     CreditContainer;
/** Labels for the credit names */
var transient array<GFxObject>  CreditLabels;

// --- State Tracking Variables -----------------------
/** TRUE if we're not hidden, FALSE if we are */
var transient bool          bIsVisible;

/** TRUE if we're drawing act / chapter name display (dramatic text), FALSE if not */
var transient bool          bIsDrawingDramaticText;

/** TRUE if we're drawing the credits, FALSE if not */
var transient bool          bIsDrawingCredits;

/** Queues credits to be displayed if the next set of credits is triggered before  */
var transient int           QueuedCreditCount;

/** Index into the credits array that we need to display next */
var transient int           CurrentCreditLineNumber;

// --- Misc. Variables --------------------------------
/** The time to display the credits per name in the list, in seconds */
var config float            TimeToDisplayPerName;

/** Time until we should fade out the credits again */
var transient float         TimeTillCreditFadeOut;

/** Time that we should display the act and chapter before fading out */
var config float            TimeToDisplayActAndChapter;

/** Time that we should display the date before fading out */
var config float            TimeToDisplayTime;

/** Time that we should display the location before fading out */
var config float            TimeToDisplayLoc;

/** If TRUE, the popup needs to display the date and time.  FALSE if it should fade out immediately */
var transient bool          bNeedsToShowDateAndTime;

/** Time until we should fade out the act / chapter / date / time display */
var transient float         TimeTillBannerFadeOut;

enum EChapterCalloutState
{
	ECCS_ActChapter,
	ECCS_Time,
	ECCS_Location
};
/** Current state of the act title callouts */
var transient EChapterCalloutState  CurrentCalloutState;

//=====================================================
// MoviePlayer Functions
//=====================================================

/**
 * Called when the scene is closed.  Cleans up references to this player instance.
 */
event OnClose()
{
	// Remove the reference in the HUD to the scene if we close for any reason
	GearHUD_Base(Outer).CalloutSceneInstance = None;

	Super.OnClose();
}

/**
 * Called whenever a new widget is initialized in the movie
 * 
 * @param   WidgetName      Flash instance name of the widget being initialized
 * @param   WidgetPath      Full path of the widget in the movie
 * @param   Widget          Reference to the widget that was initialized.  If this widget is bound via WidgetBindings, it will be of the appropriate subclass
 * 
 * @return  Whether or not this widget was handled
 */
event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
	local string WidgetString;
	local array<string> Splits;
	local int Idx;

	switch( WidgetName )
	{
		case 'ActChapterBag':
			ActChapterBanner = Widget;
			break;
		case 'lbl_ActName':
			lbl_ActName = Widget;
			break;
		case 'lbl_ChapterName':
			lbl_ChapterName = Widget;
			break;
		case 'lbl_StoryLocation':
			lbl_StoryLocation = Widget;
			break;
		case 'lbl_StoryTime':
			lbl_StoryTime = Widget;
			break;
		case 'CreditsList':
			CreditContainer = Widget;
			break;
		default:
			// Check for the credit name widgets
			WidgetString = string(WidgetPath);
			if( InStr(WidgetString, "CreditNameItem") != INDEX_NONE )
			{
				// Split up the path so we can grab the parent, which contains the index we're interested in
				Splits = SplitString(WidgetString, ".", TRUE);
				
				// Get the numerical portion of the name of the object's parent (contained in Splits[n-2])
				Idx = int( Mid(Splits[Splits.Length - 2], 14) );
				// Expand the array if necessary
				if( Idx > CreditLabels.Length - 1 )
				{
					CreditLabels.Length = Idx + 1;
				}
				// Insert the label into the array
				CreditLabels[Idx] = Widget;
			}
			return FALSE;
	}

	return TRUE;
}

//=====================================================
// Visibility Functions
//=====================================================

/**
 * Called to unhide the callout.  Starts advancing the movie, and sets its visibility
 */
private function ShowCallouts()
{
	if( !bIsVisible )
	{
		// Unpause the scene, and make it visible
		SetPause(FALSE);
		GetVariableObject("_root").SetBool("_visible", TRUE);

		bIsVisible = TRUE;
	}
}

/**
 * Hides the callout.  Stops advancing the movie, and sets its visibility
 */
private function HideCallouts()
{
	// Pause the scene, and make it invisible
	if( bIsVisible && !IsDrawingText() && !IsDrawingCredits() )
	{
		SetPause(TRUE);
		GetVariableObject("_root").SetBool("_visible", TRUE);

		bIsVisible = FALSE;
	}
}

/**
 * Post-advance callback for the scene.  Called after every advance of the movie
 * 
 * @param   DeltaTime   Amount of time that the movie has advanced
 */
final function UpdateMovie(float DeltaTime)
{
	local string FrameToJump;

	// Decrement the credit fade clock, if needed
	if( TimeTillCreditFadeOut > 0.f )
	{
		TimeTillCreditFadeOut = FMax(0.f, TimeTillCreditFadeOut - DeltaTime);
		if( TimeTillCreditFadeOut == 0.f )
		{
			// We've hit the end, fade out the credits
			FadeOutCredits();
		}
	}

	// Decrement the banner fade clock, if needed
	if( TimeTillBannerFadeOut > 0.f )
	{
		TimeTillBannerFadeOut = FMax(0.f, TimeTillBannerFadeOut - DeltaTime);
		if( TimeTillBannerFadeOut == 0.f )
		{
			// Determine where to jump to, depending on our current state
			switch(CurrentCalloutState)
			{
				case ECCS_Location:
					FrameToJump = "LocationOut";
					break;
				case ECCS_Time:
					FrameToJump = "DateOff";
					break;
				case ECCS_ActChapter:
				default:
					FrameToJump = "fadeOut";
					break;
			}

			// Jump there!
			ActChapterBanner.GotoAndPlay(FrameToJump);
		}
	}
}

//=====================================================
// Ingame Credits Functions
//=====================================================

/**
 * Advances the credits to the next set of names
 */
function AdvanceCredits()
{
	local string CreditLine;
	local int Idx;

	// If this is not the primary player, don't show the credits so they don't overlap
	if( !GetGearPC().IsPrimaryPlayer() )
	{
		return;
	}

	// If there are no more credits to display, reset
	if( CurrentCreditLineNumber == INDEX_NONE )
	{
		HideCallouts();
		return;
	}

	// If we're already displaying credits, queue another set up
	if( IsDrawingCredits() )
	{
		QueuedCreditCount++;
		return;
	}

	TimeTillCreditFadeOut = 0.f;

	// Grab the next block of credits
	for( Idx = 0; Idx < CreditLabels.Length; Idx++ )
	{
		if( !NextLine(CreditLine) )
		{
			// If we failed to get a line, set the index we're done!
			CurrentCreditLineNumber = INDEX_NONE;

			// Hide the label so it doesn't get drawn with stale text
			CreditLabels[Idx].SetBool("_visible", FALSE);

		}
		else
		{
			// Set the widget with the appropriate credit line
			CreditLabels[Idx].SetString("htmlText", CreditLine);

			// Make sure we can see the label
			CreditLabels[Idx].SetBool("_visible", TRUE);

			// Add time for this label
			TimeTillCreditFadeOut += TimeToDisplayPerName;
		}
	}

	// Begin the animation
	ShowCallouts();
	CreditContainer.GotoAndPlay("fadeIn");
	bIsDrawingCredits = TRUE;
}

/**
 * Called after the wait time for displaying the credits has elapsed
 */
function FadeOutCredits()
{
	CreditContainer.GotoAndPlay("fadeOut");
}

/**
 * Tests a string to see if looks like something that the Data Store returns when it can't find an item.
 *
 * @param	TestMe	The string's first 5 character against ?int?
 * @return	        TRUE if the binding is OK, FALSE if failed
 */
function bool IsDataFound(string TestMe)
{
	return Left(TestMe, 1) != "?";
}

/**
 * Get the next line from the Credits.INT datastore.
 *
 * @param   OutCurrentLine  String to contain the current credit line when returning
 * @return  TRUE if we successfully read a line, FALSE otherwise
 */
function bool NextLine( out string OutCurrentLine )
{
	local string LineName;
	
	if (CurrentCreditLineNumber < 10)
	{
		LineName = "line_0000" $ CurrentCreditLineNumber;
	}
	else if (CurrentCreditLineNumber < 100)
	{
		LineName = "line_000" $ CurrentCreditLineNumber;
	}
	else if (CurrentCreditLineNumber < 1000)
	{
		LineName = "line_00" $ CurrentCreditLineNumber;
	}
	else if (CurrentCreditLineNumber < 10000)
	{
		LineName = "line_0" $ CurrentCreditLineNumber;
	}
	else
	{
		`Warn("Warning, you've exceeded the maximum number of lines supported by credits.");
	}

	CurrentCreditLineNumber++;

	OutCurrentLine = Localize( "IngameCredits", LineName, "Credits" );

	//`Log( "Credits: Looking for " $ LineName $ ". Found " $ OutCurrentLine $ "." );
	return IsDataFound(OutCurrentLine);
}

/**
 * Called from ActionScript when a credit block has completed fading out
 */
function Callback_CreditsComplete()
{
	bIsDrawingCredits = FALSE;

	if( QueuedCreditCount > 0 )
	{
		// The next set has been triggered while we were in the credits.  Display another set
		QueuedCreditCount--;
		AdvanceCredits();
	}
	else
	{
		// Otherwise, we're done, close the scene
		HideCallouts();
	}
	
}

/**
 * Whether or not we're actually drawing the credits
 * 
 * @return  TRUE if we're drawing credits, FALSE if not
 */
function bool IsDrawingCredits()
{
	return bIsDrawingCredits;
}

//=====================================================
// Act / Chapter Functions
//=====================================================

/**
 * Sets and text on and then displays the act / chapter banner
 *
 * @param   ActText     Text to display for the act name
 * @param   ChapterText Text to display for the chapter name
 */
function SetActChapterText(string ActText, string ChapterText, optional string LocationDesc, optional string TimeDesc)
{
	if( lbl_ActName != None && lbl_ChapterName != None )
	{
		// Unhide the scene
		ShowCallouts();

		// Set the text
		lbl_ActName.SetString("htmlText", ActText);
		lbl_ChapterName.SetString("htmlText", ChapterText);

		// If a location and time are available, set those
		bNeedsToShowDateAndTime = (LocationDesc != "" && TimeDesc != "");
		if( bNeedsToShowDateAndTime )
		{
			lbl_StoryLocation.SetString("htmlText", LocationDesc);
			lbl_StoryTime.SetString("htmlText", TimeDesc);
		}

		// Begin the animation
		ActChapterBanner.GotoAndPlay("ActChapterShow");

		// Start the timer
		TimeTillBannerFadeOut = TimeToDisplayActAndChapter;
		CurrentCalloutState = ECCS_ActChapter;

		bIsDrawingDramaticText = TRUE;
	}
}

/**
 * Called to stop the display of dramatic text
 */
function StopActChapterText()
{
	ActChapterBanner.GotoAndPlay("off");
	bIsDrawingDramaticText = FALSE;
	HideCallouts();
}

/**
 * Whether or not we're drawing the dramatic text
 * 
 * @return  TRUE if we're drawing the dramatic text, FALSE otherwise
 */
function bool IsDrawingText()
{
	return bIsDrawingDramaticText;
}

/**
 * Called from ActionScript when a sequence is complete, and the callbacks can be hidden
 */
function Callback_ActChapterTextComplete()
{
	// If we don't need to show the date and time, then we're done
	if( !bNeedsToShowDateAndTime )
	{
		bIsDrawingDramaticText = FALSE;

		// Hide the movie, so it can stop advancing
		HideCallouts();
	}
	// If we do, fade in the time
	else
	{
		ActChapterBanner.GotoAndPlay("DateIn");
		
		// Start the timer
		CurrentCalloutState = ECCS_Time;
		TimeTillBannerFadeOut = TimeToDisplayTime;
	}
}

/**
 * Called when the time finishes fading out
 */
function Callback_TimeComplete()
{
	// Fade in the location, now that time is complete
	ActChapterBanner.GotoAndPlay("LocationIn");
	CurrentCalloutState = ECCS_Location;
	TimeTillBannerFadeOut = TimeToDisplayLoc;
}

/**
 * Called when the location finishes fading out
 */
function Callback_LocationComplete()
{
	bIsDrawingDramaticText = FALSE;

	// Hide the movie, so it can stop advancing
	HideCallouts();
}

defaultproperties
{
	CaptureKeys.Empty()

	OnPostAdvance=UpdateMovie

	TimingMode=TM_Game
}
