/**
 * End of Game Credits Screen
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class UIScene_Credits extends GearGFxMoviePlayer
	config(UI);

// --- Widget References ------------------------------
/** Reference to the credits view, which serves as our interface to the credits widgets */
var transient GFxObject     CreditsView;

// --- State Tracking Variables -----------------------
/** Index into the credits array that we need to display next */
var transient int           CurrentCreditLineNumber;

/** Index into the quotes that we need to display next */
var transient int           CurrentQuoteNumber;

// --- Misc. Variables --------------------------------
/** Desired time for one line of credits to scroll all the way up the screen, in seconds */
var config float            CreditScrollTime;

/** Duration of time between sending lines of credits to ActionScript */
var transient float         CreditPollTime;

/** The last time we sent a credit line to the movie */
var transient float         LastPollTime;

/** Duration to keep up a set up quotes and images at the bottom of the screen */
var config float            QuoteDuration;

/** The last time we swapped out the portraits at the bottom of the screen */
var transient float         LastQuoteTime;

/** TRUE if the credits have finished scrolling, FALSE otherwise */
var transient bool          bScrollingCreditsDone;

/** TRUE if the quotes have finished fading in / out, FALSE otherwise */
var transient bool          bQuotesDone;


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
	switch( WidgetName )
	{
		case 'CreditsView':
			CreditsView = Widget;
			InitializeCredits();
			break;
		default:
			return FALSE;
	}

	return TRUE;
}

//=====================================================
// Credits Functions
//=====================================================

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

	OutCurrentLine = Localize( "credits", LineName, "Credits" );

	//`Log( "Credits: Looking for " $ LineName $ ". Found " $ OutCurrentLine $ "." );
	return IsDataFound(OutCurrentLine);
}

/**
 * Gets the next quote in the queue
 * 
 * @param   DevName Out param that will contain the name to display for the quote
 * @param   Quote   Out param that will contain the person's quote
 * @param   PathToPicture   Out param that will contain the path to the person's picture (e.g. "img://MyPackage.MyImage")
 * 
 * @return  TRUE if we got a quote, FALSE if no quote was available
 */
function bool NextQuote(out string DevName, out string Quote, out string PathToPicture)
{
	local string LineName, QuoteString;
	local int i;
	
	if (CurrentQuoteNumber < 10)
	{
		LineName = "Q00" $ CurrentQuoteNumber;
	}
	else if (CurrentQuoteNumber < 100)
	{
		LineName = "Q0" $ CurrentQuoteNumber;
	}
	else if (CurrentQuoteNumber < 1000)
	{
		LineName = "Q" $ CurrentQuoteNumber;
	}
	else
	{
		`Warn("Warning, you've exceeded the maximum number of quotes supported by credits.");
	}

	// Increment the count
	CurrentQuoteNumber++;

	// Grab the quote info from the credits
	QuoteString = Localize( "Quotes", LineName, "Credits" );

	if( IsDataFound(QuoteString) )
	{
		// Parse the current line out into the name, quote, and picture
		i = InStr(QuoteString, "\n");

		if( i != INDEX_NONE )
		{
			// Grab the name
			DevName = Left(QuoteString, i);

			// Grab the quote (everything after \n)
			Quote = Mid(QuoteString, i + 1);

			// Grab the image path, which is always the name, without spaces
			PathToPicture = "img://UI_Credits." $ Repl(DevName, " ", "");

			return TRUE;
		}
	}
	
	// Failed parsing or to find an entry for this line, return false.
	return FALSE;
	
}


/**
 * PostAdvance updater for the scene.  Controls when we send a new credit line to ActionScript
 * 
 * @param   DeltaTime   Time since the movie's last advance
 */
final function UpdateCredits(float DeltaTime)
{
	local float TimeSinceLastUpdate;
	local string CreditLine;
	local string N1, Q1, I1, N2, Q2, I2;    // Name, Quote, and Image, x2 for the quotes
	local bool bHadQuotes;

	// If we've initialized, CreditPollTime will be greater than 0
	if( !bScrollingCreditsDone && (CreditPollTime > 0.f) )
	{
		TimeSinceLastUpdate = `TimeSinceEx(GetPC(), LastPollTime);

		// See if we're due for an update
		if( TimeSinceLastUpdate >= CreditPollTime )
		{
			LastPollTime = GetPC().WorldInfo.TimeSeconds;

			// See if we have another line of credits to display
			if( NextLine(CreditLine) )
			{
				// If so, send it
				SendLine(CreditLine, TimeSinceLastUpdate - CreditPollTime);
			}
			else
			{
				// We're done with credits, stop
				bScrollingCreditsDone = TRUE;
			}
		}
	}

	// See if we need to swap to a new set of portraits
	if( !bQuotesDone && (QuoteDuration > 0.f) )
	{
		TimeSinceLastUpdate = `TimeSinceEx(GetPC(), LastQuoteTime);

		if( TimeSinceLastUpdate >= QuoteDuration )
		{
			LastQuoteTime = GetPC().WorldInfo.TimeSeconds;

			// Grab the next two quotes from the stack
			bHadQuotes = NextQuote(N1, Q1, I1);
			bHadQuotes = NextQuote(N2, Q2, I2) || bHadQuotes;

			if( bHadQuotes )
			{
				SendQuotes(N1, Q1, I1, N2, Q2, I2);
			}
			else
			{
				// No more quotes, fade everything out
				FadeOutQuotes();

				bQuotesDone = TRUE;
			}
		}
	}

	// If we're done with both...
	if( bScrollingCreditsDone && bQuotesDone )
	{
		Close();
	}
}

//=====================================================
// ActionScript Functions
//=====================================================

/**
 * Initializes the credits scrolling view, and gets the time between lines 
 */
function InitializeCredits()
{
	local array<ASValue> args;
	local ASValue RetVal;

	// Dummy param
	args.Length = 1;

	// Set up the credit scroll time to be pushed to actionscript
	args[0].Type = AS_Number;
	args[0].n = CreditScrollTime;

	// Initialize the credits window, and figure out what the time between credits should be
	RetVal = CreditsView.Invoke("Initialize", args);
	CreditPollTime = RetVal.n;
	LastPollTime = GetPC().WorldInfo.TimeSeconds;
}

/**
 * Sends a line of credit text to ActionScript, and starts it scrolling up the window
 *
 * @param   NewLine     Line of text to send to the credits
 * @param   StartDelay  Delay after the exact time that the clip was supposed to start that it is actually starting
 */
private function SendLine(string NewLine, float StartDelay)
{
	CreditsView.ActionScriptVoid("StartLine");
}

/**
 * Sends a batch of two pictures, names, and quotes to be used at the bottom of the screen.  This will cause a crossfade with the last quotes sent to ActionScript, if any
 * 
 * @param   FirstName   Name to put in the first quote slot
 * @param   FirstQuote  Quote to put in the first quote slot
 * @param   FirstImage  Path to an image resource to load in the first quote slot
 * @param   SecondName  Name to put in the second quote slot
 * @param   SecondQuote Quote to put in the second quote slot
 * @param   SecondImage Path to an image resource to load in the second quote slot
 */
private function SendQuotes(string FirstName, string FirstQuote, string FirstImage, string SecondName, string SecondQuote, string SecondImage)
{
	CreditsView.ActionScriptVoid("FadeInQuotes");
}

/**
 * Fades out the quotes when we have no more
 */
private function FadeOutQuotes()
{
	CreditsView.ActionScriptVoid("FadeOutQuotes");
}

defaultproperties
{
	CaptureKeys.Empty()

	OnPostAdvance=UpdateCredits
}
