/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearGFxMoviePlayer extends GFxMoviePlayer
	native(UI);

/************************************************************************/
/* Constants															*/
/************************************************************************/
//If you block on input, DO NOT give the scene a priority above GEAR_SCENE_PRIORITY_BLOCKASYNC
const GEAR_SCENE_PRIORITY_BLOCKASYNC	= 100;
const GEAR_SCENE_PRIORITY_NOTIFICATION	= 80;
const GEAR_SCENE_PRIORITY_MAXBLOCKING	= 79;
const GEAR_SCENE_PRIORITY_MESSAGEBOX	= 70;
const GEAR_SCENE_PRIORITY_STATS         = 68;
const GEAR_SCENE_PRIORITY_POSTGAME      = 67;
const GEAR_SCENE_PRIORITY_WHATSUP       = 66;
const GEAR_SCENE_PRIORITY_PAUSE     	= 65;
const GEAR_SCENE_PRIORITY_VERYHIGH		= 60;
const GEAR_SCENE_PRIORITY_HIGH			= 50;
const GEAR_SCENE_PRIORITY_GAMEOVER		= 30;
const GEAR_SCENE_PRIORITY_ELEVATED		= 25;
const GEAR_SCENE_PRIORITY_NORMAL		= 10;
const GEAR_SCENE_PRIORITY_COOPSPECTATE	= 9;
const GEAR_SCENE_PRIORITY_DISCOVERABLES = 7;
const GEAR_SCENE_PRIORITY_MPSCENE		= 5;
const GEAR_SCENE_PRIORITY_TUTORIAL		= 1;

/** If TRUE, when the scene is opened, MenuPostProcessSettings will override the owning player's postprocess */
var bool                    bEnableMenuPostProcess;
var PostProcessSettings     MenuPostProcessSettings;

/** If TRUE, menu post process will be applied to all local player's views */
var bool                    bPostProcessForAllLocalPlayers;

/************************************************************************/
/* Common localized strings variables                                   */
/************************************************************************/
/** Localized string for the title conjunction */
var localized string GameToMapConjunction;

/** Formatting strings for the two local players (includes special colouring information) */
var localized string LocalPlayer1FormatString;
var localized string LocalPlayer2FormatString;

/** Date formatting string so we can flip around month, day, and year.  Use *m, *d, and *y for month, day, and year, respectively, and they'll be replaced at runtime */
var localized string    DateFormat;

/** Same as above, except without the year */
var localized string    ShortDateFormat;

/** Date formatting string, as above, but for numeric dates (e.g. 01/01/2010) */
var localized string    NumericDateFormat;

/** Localized month abbreviations */
var localized string    MonthNames[12];

/************************************************************************/
/* Background music                                                     */
/************************************************************************/
/** If specified, this music will play in the background while the menu is up */
var const SoundCue  BackgroundMusic;
/** Audio component to use to play the background music */
var private transient AudioComponent AC_Background;

/************************************************************************/
/* Filter Support                                                       */
/************************************************************************/
struct native BlurFilter
{
	/** The movie clip to blur */
	var GFxObject   BlurClip;
	
	/** Amount of blur to apply in the x direction */
	var float       BlurX;
	/** Amount of blur to apply in the y direction */
	var float       BlurY;
	/** Sample quality of the blur */
	var float       BlurQuality;

	/** Blur values that the movie should be blending from */
	var float       Prev_BlurX, Prev_BlurY, Prev_BlurQuality;

	/** Duration to blend to the blur amount */
	var float       BlendTime;
	/** Time that the blur started */
	var float       BlurStartTime;
	/** Flag whether we need to be blending currently, or not. */
	var bool        bIsBlending;
};

/** Array of our currently active blur filters */
var transient array<BlurFilter> CurrentBlurs;

cpptext
{
	/** Overloaded to allow for proper handling of blur blending */
	void PostAdvance(FLOAT DeltaTime);
};

/** 
 *  This should be called when a new GearGFxMoviePlayer is initialized.
 *  Handles the setting up of the LocalPlayerIndex, as well as automatically starting / advancing the movie if desired 
 *  
 *  @param LocPlayer - Local player that is to be the owner of this scene
 */
function Init(optional LocalPlayer LocPlay)
{
	local GearPC PC;
	super.Init(LocPlay);

	PC = GetGearPC();
	if( PC != None && MovieInfo != None )
	{
		// Background music handling
		if( BackgroundMusic != None )
		{
			AC_Background = PC.CreateAudioComponent(BackgroundMusic, FALSE, TRUE);
			if( AC_Background != None )
			{
				AC_Background.bIsUISound = TRUE;
				AC_Background.bAllowSpatialization = FALSE;
				AC_Background.bAutoDestroy = TRUE;
				AC_Background.Play();
			}
		}
	}	
}

/**
 * Event triggered when focus is given to this MoviePlayer for a given LocalPlayer
 * 
 * @param LocalPlayerIndex - The index of the local player that is now focusing on this MoviePlayer
 */
event OnFocusGained(int LocalPlayerIndex)
{
	local GearPC PC;

	super.OnFocusGained(LocalPlayerIndex);
	
	PC = GetGearPC();
	if( PC != None && MovieInfo != None )
	{
		// Post-process handling
		if( bEnableMenuPostProcess )
		{
			// Start a post process if we want to begin one
			PC.SetMenuPostProcessSettings(MenuPostProcessSettings, bPostProcessForAllLocalPlayers);
		}
	}
}

/**
 * Event triggered when focus is removed from this MoviePlayer for a given LocalPlayer
 * 
 * @param LocalPlayerIndex - The index of the local player that is no longer focusing on this MoviePlayer
 */
event OnFocusLost(int LocalPlayerIndex)
{
	super.OnFocusLost(LocalPlayerIndex);
}

event OnClose()
{
	local GearPC PC;
	// Finish the post processing on the scene, if there is one
	PC = GetGearPC();
	if( (PC != None) && bEnableMenuPostProcess )
	{
		PC.StopPostProcessOverride(eGPP_Menu, 0.f);
	}

	// Fade out the music
	if( AC_Background != None )
	{
		AC_Background.FadeOut(1.0f, 0.0f);
		AC_Background = None;
	}
}

/** Sets the capture keys back to the default */
function ResetCaptureKeys()
{
	local int i;

	ClearCaptureKeys();

	for (i = 0; i < CaptureKeys.Length; i++)
	{
		AddCaptureKey(CaptureKeys[i]);
	}
}

//==============================================================
// Movie functions
//==============================================================

/**
 * Blurs the root of the movie by adding a blur filter to the clip's filter array.  Note that this is destructive to any filter currently applied to the movie root, but does not touch any children
 * 
 * @param   ClipToBlur  Clip that we should add a blur filter to (NOTE:  Due to the way that GFx can have multiple objects pointing to the same clip, make sure you don't alias pointers!)
 * @param   BlurX       Amount of blur to apply in the x direction (NOTE:  Should be a power of 2 for best performance)
 * @param   BlurY       Amount of blur to apply in the y direction (NOTE:  Should be a power of 2 for best performance)
 * @param   Quality     Quality sampling factor for the blur
 * @param   BlendTime   Time to take to blend the clip to the specified blur
 */
function BlurMovie(GFxObject ClipToBlur, int BlurX, int BlurY, int Quality, float BlendTime)
{
	local int Index;
	local BlurFilter MyFilter;
	local GFxObject FilterArray, CurrentFlashBlur;

	// Bail early if there is no clip to blur
	if( ClipToBlur == None )
	{
		return;
	}

	// See if this clip is already blurred
	Index = CurrentBlurs.Find('BlurClip', ClipToBlur);

	if( Index != INDEX_NONE )
	{
		// If we found a blur, so update this filter
		MyFilter = CurrentBlurs[Index];
		FilterArray = ClipToBlur.GetObject("filters");
		CurrentFlashBlur = FilterArray.GetElementObject(0);

		// Get the current values, so we can blend from these values
		MyFilter.Prev_BlurX = CurrentFlashBlur.GetFloat("blurX");
		MyFilter.Prev_BlurY = CurrentFlashBlur.GetFloat("blurY");
		MyFilter.Prev_BlurQuality = CurrentFlashBlur.GetFloat("quality");
	}
	else
	{
		// Otherwise, establish this clip as being blurred, and start from 0.
		MyFilter.BlurClip = ClipToBlur;
		MyFilter.Prev_BlurX = 0.f;
		MyFilter.Prev_BlurY = 0.f;
		MyFilter.Prev_BlurQuality = 4.f;
	}

	// Set the values to blur to
	MyFilter.BlurX = BlurX;
	MyFilter.BlurY = BlurY;
	MyFilter.BlurQuality = Quality;
	MyFilter.BlendTime = BlendTime;

	MyFilter.BlurStartTime = GetWorldInfo().TimeSeconds;
	MyFilter.bIsBlending = TRUE;

	// Add the filter back into the array
	if( Index != INDEX_NONE )
	{
		CurrentBlurs[Index] = MyFilter;
	}
	else
	{
		CurrentBlurs.AddItem(MyFilter);
	}

}

/**
 * Checks to see if the outer of the scene is UIScene_FrontEnd, and if so, blurs the menu
 */
function TryBlurFrontEnd()
{
	local UIScene_FrontEnd FrontEnd;

	FrontEnd = UIScene_FrontEnd(Outer);
	if( FrontEnd != None )
	{
		FrontEnd.BlurMainMenu();
	}
}

/**
 * Checks to see if the outer of the scene is UIScene_FrontEnd, and if so, unblurs the menu
 */
function TryUnblurFrontEnd()
{
	local UIScene_FrontEnd FrontEnd;

	FrontEnd = UIScene_FrontEnd(Outer);
	if( FrontEnd != None )
	{
		FrontEnd.UnblurMainMenu();
	}
}

//==============================================================
// Sound Helper functions
//==============================================================
/** Plays a sound associated with an event from the specified sound theme.
 *  Can be used to manually fire off sounds from UnrealScript when it is inconvenient to fire them off from ActionScript 
 *  
 *  @param EventName - name of the sound event to play
 *  @param SoundThemeName - name of the theme to play the sound from. Defaults to 'default'
 **/
function PlaySoundFromTheme(name EventName, optional name SoundThemeName='default')
{
	local int ThemeIndex;
	local UISoundTheme Theme;

	`log("gfcProcessSound Callback - Sound Theme: "$SoundThemeName$" SoundEvent: "$EventName,,'DevGFxUI');

	ThemeIndex = SoundThemes.Find('ThemeName', SoundThemeName);

	if( ThemeIndex != INDEX_NONE )
	{
		Theme = SoundThemes[ThemeIndex].Theme;
		if( Theme != None )
		{
			Theme.ProcessSoundEvent(EventName, GetGearPC());
		}
		else
		{
			`log("Invalid theme binding for theme " $ SoundThemeName,, 'GearsUI');
		}
	}
	else
	{
		`log("Unable to find sound theme for movie " $ SoundThemeName,, 'GearsUI');
	}
}

//==============================================================
// Formatting Helper functions
//==============================================================
/** Takes an int and returns a string in the form HH:MM:SS */
static function string FormatTime( int TimeToFormat )
{
	local int Minutes, Hours, Seconds;
	local string Result;

	// Figure out how many seconds we are dealing with first, we'll format it later
	Seconds = TimeToFormat;

	// Calculate hours and start building the string if there are hours
	if( Seconds > 3600 )
	{
		Hours = Seconds / 3600;
		Seconds -= Hours * 3600;
		Result = string(Hours)$":";
	}

	// Calculate minutes
	Minutes = Seconds / 60;

	// Calculate seconds
	Seconds -= Minutes * 60;

	// Build the string for minutes
	if ( (Minutes < 10) && (Hours != 0) )
	{
		// If we have an hours string, but minutes is in the single digits, add an extra 0
		Result = Result$"0";
	}
	Result = Result$Minutes$":";

	// Build the string for seconds
	if ( Seconds < 10 )
	{
		Result = Result$"0";
	}
	Result = Result$Seconds;

	return Result;
}

/**
 * Helper function to return a nicely formatted date string for the current date, which respects localized date format
 */
function string GetCurrentDateString(optional bool bUseShortDate)
{
	local int Year, Month, DayOfWeek, Day, Hour, Min, Sec, MSec;

	// Grab the time from the system
	GetSystemTime(Year, Month, DayOfWeek, Day, Hour, Min, Sec, MSec);

	return GetDateString(Year, Month, Day, bUseShortDate);
}

/**
 * Helper function to format our date string nicely
 * 
 * @param   Year            Year of the date
 * @param   Month           Month of the date
 * @param   Day             Day of the date
 * @param   bUseShortDate   Whether or not to omit the year from the date string
 */
function string GetDateString(int Year, int Month, int Day, optional bool bUseShortDate)
{
	local string DateString;

	// Replace the entries in the date format string with the actual values
	DateString = Repl( (bUseShortDate ? ShortDateFormat : DateFormat), "*m", MonthNames[Month-1]);
	DateString = Repl( DateString, "*d", Day);
	DateString = Repl( DateString, "*y", Year);

	return DateString;
}

/**
 * Helper function to get a numeric (e.g. MM/DD/YYYY) string from the specified date
 * 
 * @param   Year            Year of the date
 * @param   Month           Month of the date
 * @param   Day             Day of the date
 */
function string GetNumericDateString(int Year, int Month, int Day)
{
	local string DateString;

	DateString = Repl( NumericDateFormat, "*y", Year);
	DateString = Repl( DateString, "*m", (Month < 10 ? "0" $ Month : string(Month)));

	return Repl( DateString, "*d", (Day < 10 ? "0" $ Day : string(Day)));
}

/**
 * Returns the string of a formatted time
 *
 * @param TimeInSeconds - time to format in seconds
 *
 * @return - formatted string in the form HH:MM
 */
final function String CreateTimeString( int TimeInSeconds )
{
	local int CurrTime, NumMinutes, NumHours;
	local String TimeString;

	CurrTime = TimeInSeconds;
	NumHours = CurrTime / 3600;
	CurrTime -= NumHours * 3600;
	NumMinutes = CurrTime / 60;
	CurrTime -= NumMinutes * 60;
	//NumSeconds = CurrTime;

	if ( NumHours <= 0 )
	{
		TimeString = "00:";
	}
	else if ( NumHours < 10 )
	{
		TimeString = "0"$NumHours$":";
	}
	else
	{
		TimeString = NumHours$":";
	}

	if ( NumMinutes <= 0 )
	{
		TimeString $= "00";
	}
	else if ( NumMinutes < 10 )
	{
		TimeString $= "0"$NumMinutes;
	}
	else
	{
		TimeString $= NumMinutes;
	}

	return TimeString;
}

/**
 * Takes the input string and creates a new string that contains commas between every three characters
 *
 * @param	InitialString	String that we want to add separators to
 *
 * @return	New string, which is the InitialString with thousand separators added
 */
static function string CreateThousandsSeparatedString(coerce string InitialString)
{
	local int StringIndex, StringLen;
	local string StringWithSeparators;
	local string Separator;

	StringLen = Len(InitialString);

	//@TODO: Get the language specific thousands separator
	Separator =  ",";

	StringIndex = 0;
	if (Left(InitialString,1) == "-")
	{
		StringWithSeparators = "-";
		InitialString = Right(InitialString,StringLen-1);
		StringLen--;
	}
	else
	{
		StringWithSeparators = "";
	}
	//Take the highest order triplet of digits, which can be anywhere from 1 to 3
	//Empty string will fall through the if's and the while.
	//1-2
	if (StringLen % 3 > 0)
	{
		StringWithSeparators $= Mid(InitialString, StringIndex, StringLen % 3);
		StringIndex += Len(InitialString) %3;
	}
	//3
	else if (StringLen >= 0)
	{
		StringWithSeparators $= Mid(InitialString, StringIndex, 3);
		StringIndex += 3;
	}
	//After the highest order, each grouping of ',123' following that
	while (StringIndex < StringLen)
	{
		StringWithSeparators $= Separator;
		StringWithSeparators $= Mid(InitialString, StringIndex, 3);
		StringIndex += 3;
	}

	return StringWithSeparators;
}

/**
 *  Returns a string formatted with appropriate colour information, based on if the passed in string is a local player or not
 *  
 *  @param  PlayerTest  Name of the player to check and potentially format
 *  @param  LocalPRI1   The first local PRI
 *  @param  LocalPRI2   The second local PRI
 *  @param  bIncludeControllerIcon  (optional) If TRUE, then the icon for the local player controller ring will be added to the name
 *  
 *  @return             A string formatting with the appropriate colour for the player
 */
static function string GetFormattedPlayerName( GearPRI PlayerTest, GearPRI LocalPRI1, GearPRI LocalPRI2, optional bool bIncludeControllerIcon = TRUE)
{
	if( PlayerTest == None )
	{
		return "";
	}
	if( PlayerTest == LocalPRI1 )
	{
		return (bIncludeControllerIcon ? GetControllerIcon(LocalPlayer(GearPC(PlayerTest.Owner).Player).ControllerId) : "") @ Repl( default.LocalPlayer1FormatString, "*p", PlayerTest.PlayerName);	
	}
	else if( PlayerTest == LocalPRI2 )
	{
		return (bIncludeControllerIcon ? GetControllerIcon(LocalPlayer(GearPC(PlayerTest.Owner).Player).ControllerId) : "") @ Repl( default.LocalPlayer2FormatString, "*p", PlayerTest.PlayerName);
	}
	else
	{
		return PlayerTest.PlayerName;
	}
}

/**
 * Formats the specified string, based on if the TestPRI is one of the two local PRIs 
 * 
 * @param   StringToFormat  The string to return formatted
 * @param   TestPRI         The PRI to determine whether this string should be converted to a local player colour
 * @param   LocalPRI1       The PRI of the first local player
 * @param   LocalPRI2       The PRI of the second local player
 * 
 * @return  A string, formatted with the proper colour tags corresponding to the player
 */
static function string GetFormattedLocalPlayerString( string StringToFormat, GearPRI TestPRI, GearPRI LocalPRI1, GearPRI LocalPRI2 )
{
	if( TestPRI == None )
	{
		return StringToFormat;
	}
	else if( TestPRI == LocalPRI1 )
	{
		return Repl( default.LocalPlayer1FormatString, "*p", StringToFormat);
	}
	else if( TestPRI == LocalPRI2 )
	{
		return Repl( default.LocalPlayer2FormatString, "*p", StringToFormat);
	}
	else
	{
		return StringToFormat;
	}
}

/**
 * Formats the specified string, based on if the TestNetId is one of the two local NetIds
 * 
 * @param   PlayerName      Name of the player to format
 * @param   TestNetId       The NetId to test
 * @param   LocalPRI1       PRI for local player 1
 * @param   LocalPRI2       PRI for local player 2
 * 
 * @return  A string formatted with the appropriate colour and player controller icon
 */
static function string GetFormattedPlayerStringFromNetId( string PlayerName, UniqueNetId TestNetId, GearPRI LocalPRI1, GearPRI LocalPRI2 )
{
	if( TestNetId == LocalPRI1.UniqueId )
	{
		PlayerName = GetControllerIcon(LocalPlayer(PlayerController(LocalPRI1.Owner).Player).ControllerId) @ PlayerName;
		return Repl( default.LocalPlayer1FormatString, "*p", PlayerName );
	}
	else if( TestNetId == LocalPRI2.UniqueId )
	{
		PlayerName = GetControllerIcon(LocalPlayer(PlayerController(LocalPRI2.Owner).Player).ControllerId) @ PlayerName;
		return Repl( default.LocalPlayer2FormatString, "*p", PlayerName );
	}
	else
	{
		return PlayerName;
	}
}


//==============================================================
// Engine / Game Helper functions
//==============================================================
/**
 * Returns the current WorldInfo
 */
static function WorldInfo GetWorldInfo()
{
	return class'WorldInfo'.static.GetWorldInfo();
}

/**
 * Returns the current GearGRI
 */
static function GearGRI GetGRI()
{
	return GearGRI(class'WorldInfo'.static.GetWorldInfo().GRI);
}

/**
 * Helper function to get the owning GearPC for this movie
 * 
 * @return The GearPC corresponding to the LocalPlayerIndex that owns this movie
 */
function GearPC GetGearPC()
{
	return GearPC(GetPC());
}

/**
 * Helper function to get a LocalPlayer from a specified controller id
 * 
 * @param   ControllerId    ID of the controller to grab the LocalPlayer for
 * 
 * @return  The local player associated with the controller, or none
 */
function LocalPlayer GetLPForControllerId( int ControllerId )
{
	local int Index;

	Index = class'UIInteraction'.static.GetPlayerIndex( ControllerId );
	return class'UIInteraction'.static.GetLocalPlayer( Index );
}

/**
 * Helper function to get a GearUIManager
 * 
 * @return The GearUIManager for the current UI
 */
function GearUIManager GetUIManager()
{
	return GearUIManager( class'GearUIManager'.static.GetUIManager() );
}

/**
 * @return	a reference to the gear-specific static game resource data store.
 */
static final function GearUIDataStore_GameResource GetGameResourceDataStore()
{
	return GearUIDataStore_GameResource(StaticResolveDataStore(class'GearUIDataStore_GameResource'.default.Tag));
}

static final function UIDataStore StaticResolveDataStore( name DataStoreTag, optional LocalPlayer InPlayerOwner )
{
	local UIDataStore Result;
	local DataStoreClient DSClient;

	DSClient = class'UIInteraction'.static.GetDataStoreClient();
	if ( DSClient != None )
	{
		Result = DSClient.FindDataStore(DataStoreTag, InPlayerOwner);
	}

	return Result;
}

/**
 * Saves the profile and updates the player controller with the new settings
 */
function bool SaveProfile(optional delegate<OnlinePlayerInterface.OnWriteProfileSettingsComplete> WriteProfileSettingsCompleteDelegate=OnProfileWriteComplete, optional GearPC PlayerToSave)
{
	local bool bResult;

	// If we have no override, use the PC associated with the scene
	if( PlayerToSave == None )
	{
		PlayerToSave = GetGearPC();
	}
	if (PlayerToSave != None)
	{
		// always hook into the profile write.
		PlayerToSave.SaveProfile(WriteProfileSettingsCompleteDelegate);
		PlayerToSave.UploadProfileToMCP();
		bResult = TRUE;
	}

	return bResult;
}

/** Called when the profile is done writing */
function OnProfileWriteComplete(byte LocalUserNum, bool bWasSuccessful)
{
	local OnlinePlayerInterface PlayerInt;

	PlayerInt = GetOnlinePlayerInterface();
	if ( PlayerInt != None )
	{
		PlayerInt.ClearWriteProfileSettingsCompleteDelegate(LocalUserNum,OnProfileWriteComplete);
	}
}

/**
 * Wrapper for getting a reference to the online subsystem's player interface.
 */
static final function OnlinePlayerInterface GetOnlinePlayerInterface()
{
	local OnlineSubsystem OnlineSub;
	local OnlinePlayerInterface Result;

	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if ( OnlineSub != None )
	{
		Result = OnlineSub.PlayerInterface;
	}
	else
	{
		`Log("GetOnlinePlayerInterfaceEx: Unable to find OnlineSubSystem!");
	}

	return Result;
}

/** Returns the MP game type being played */
final static function EGearMPTypes GetGearMPGameType(GearGRI GGRI)
{
	local name ClassName;

	if ( GGRI == None )
	{
		return eGEARMP_Warzone;
	}

	ClassName = GGRI.GameClass.Name;

	if ( ClassName == 'GearGameCTL' )
	{
		return eGEARMP_CTL;
	}
	else if ( ClassName == 'GearGameHorde' )
	{
		return eGEARMP_Horde;
	}
	else if ( ClassName == 'GearGameSiege' || ClassName == 'GearGameSiege_E3' )
	{
		return eGEARMP_Siege;
	}
	else if (ClassName == 'GearGameKOTH')
	{
		return eGEARMP_KOTH;
	}
	else if ( ClassName == 'GearGameWingman' )
	{
		return eGEARMP_Wingman;
	}
	else if (ClassName == 'GearGameTDM_Newb_Content' )
	{
		return eGEARMP_Newbie;
	}
	else
	{
		return (GGRI.bGameIsExecutionRules ? eGEARMP_Execution : eGEARMP_Warzone);
	}
}

/**
 * Returns the race of the PRI
 * 
 * @param   PlayerPRI   PRI of the player to check the race for
 * 
 * @return  The race of the player
 */
static final function EGearRaceTypes GetRaceUsingPRIOnly( GearPRI PlayerPRI )
{
	local string ClassNameString;

	// Use PRI to find the race of the character
	if ( PlayerPRI != None )
	{
		ClassNameString = string(PlayerPRI.PawnClass);

		if ( InStr(ClassNameString, "COG") != -1 )
		{
			return eGEARRACE_COG;
		}
		else if ( InStr(ClassNameString, "Locust") != -1 )
		{
			return eGEARRACE_Locust;
		}
	}

	return eGEARRACE_COG;
}

/** Sets the local player PRIs - (1) = First player (2) = Splitscreen player */
final function GetLocalPRIs( out GearPRI LocalPRI1, out GearPRI LocalPRI2 )
{
	local GearPC PlayerOwner, PC;
	
	PlayerOwner = GetGearPC();

	if (PlayerOwner != None )
	{
		foreach PlayerOwner.LocalPlayerControllers(class'GearPC', PC)
		{
			if (LocalPRI1 == None)
			{
				LocalPRI1 = GearPRI(PC.PlayerReplicationInfo);
			}
			else
			{
				LocalPRI2 = GearPRI(PC.PlayerReplicationInfo);
				break;
			}
		}
	}
}

/** Returns whether this PRI is a player in our party */
function bool PRIIsInMyParty(GearPRI TestPRI)
{
	local GearPRI LocalPRI1, LocalPRI2;
	local UniqueNetId PartyOwnerId;
	local UniqueNetId ZeroId;

	// Early out
	if (TestPRI == None)
	{
		return false;
	}

	// Local players are always in our party
	GetLocalPRIs(LocalPRI1, LocalPRI2);
	if (TestPRI == LocalPRI1 || TestPRI == LocalPRI2)
	{
		return true;
	}

	// Get the party owner's net id and make sure it's valid
	PartyOwnerId = GearPRI(GetPC().PlayerReplicationInfo).PartyOwnerUniqueId;
	return (PartyOwnerId != ZeroId &&
			PartyOwnerId == TestPRI.PartyOwnerUniqueId);
}

/** Returns the number of players in this player's party, if they are in one */
function int GetNumPlayersInParty()
{
	local int Idx;
	local GearPRI CurrPRI;
	local GearGRI GRI;
	local UniqueNetId PartyOwnerId;
	local UniqueNetId ZeroId;
	local GearPC CurrPC;
	local GearPRI LocalPRI1, LocalPRI2;
	local int Count;
	local GearPC PlayerOwner;

	// First count all local players since they will count as "your party" even if you aren't in one
	PlayerOwner = GetGearPC();
	foreach PlayerOwner.LocalPlayerControllers(class'GearPC', CurrPC)
	{
		if (LocalPRI1 == None)
		{
			LocalPRI1 = GearPRI(CurrPC.PlayerReplicationInfo);
			Count++;
		}
		else
		{
			LocalPRI2 = GearPRI(CurrPC.PlayerReplicationInfo);
			Count++;
		}
	}

	// Get the party owner's net id and make sure it's valid
	PartyOwnerId = GearPRI(GetPC().PlayerReplicationInfo).PartyOwnerUniqueId;
	if (PartyOwnerId != ZeroId)
	{
		GRI = GetGRI();
		for (Idx = 0; Idx < GRI.PRIArray.Length; Idx++)
		{
			// Grab each PRI and make sure it's not a local PRI since we've already counted them
			CurrPRI = GearPRI(GRI.PRIArray[Idx]);
			if (CurrPRI != LocalPRI1 && CurrPRI != LocalPRI2)
			{
				if (CurrPRI.PartyOwnerUniqueId == PartyOwnerId)
				{
					Count++;
				}
			}
		}
	}

	return Count;
}

/** @return true if the game settings dictate that the match is arbitrated */
function bool IsArbitrated()
{
	local OnlineSubsystem OnlineSub;
	local OnlineGameSettings GameSettings;

	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if (OnlineSub != None && OnlineSub.GameInterface != None)
	{
		GameSettings = OnlineSub.GameInterface.GetGameSettings('Game');
	}

	// Don't let arbitrated matches quit
	return (GameSettings != None && GameSettings.bUsesArbitration);
}

/** @return true if the return to lobby button can be used in this pause menu */
function bool CanReturnToLobby()
{
	local WorldInfo WI;
	local GearGRI GRI;
	local bool bResult;
	local GearPC PC;

	WI = GetWorldInfo();
	GRI = GearGRI(WI.GRI);

	if (GRI != none)
	{
		PC = GetGearPC();

		// Multiplayer checks
		if (GRI.IsMultiPlayerGame())
		{
			// Don't let arbitrated matches know who the host is
			// Only the party host can trigger this
			if (!IsArbitrated() && PC.IsPartyLeader() &&
				(WI.NetMode == NM_Client || WI.NetMode == NM_ListenServer))
			{
				bResult = true;
			}
		}
		// Single player
		else
		{
			// If the player has a network connection and is the host
			if (WI.NetMode != NM_Client &&
				class'UIInteraction'.static.HasLinkConnection())
			{
				bResult = true;
			}
			else
			{
				// Check for splitscreen primary player
				//if (PlayerIndex == 0)
				//{
					if (PC != none &&
						PC.IsSplitscreenPlayer())
					{
						bResult = true;
					}
				//}
			}
		}
	}
	return bResult;
}

/** Gets the variable name of the game type in question for finding the localized string */
final function string GetGameModeVariableString( EGearMPTypes MPType )
{
	switch ( MPType )
	{
		case eGEARMP_Execution:		return "Execution";
		case eGEARMP_CTL:           return "CTL";
		case eGEARMP_Horde:			return "CT";
		case eGEARMP_Siege:			return "Siege";
		case eGEARMP_Wingman:       return "Wingman";
		case eGEARMP_KOTH:          return "KOTH";
		case eGEARMP_Newbie:        return "Newbie";
		default:					return "Warzone";
	}
}

/** Returns the localized string for the game type */
final function string GetGameModeString( EGearMPTypes MPType )
{
	local string ReturnString;

	ReturnString = Localize( "GearGFxMoviePlayer", GetGameModeVariableString(MPType), "GearGame" );
	return ReturnString;
}

/** Returns the localized string for the map name */
static final event string GetMapNameString( String MapName )
{
	local GearGameMapSummary MapProvider;

	if (MapName == "MP_Training")
	{
		MapName = "MP_DayOne";
	}

	MapProvider = class'GearUIDataStore_GameResource'.static.GetMapSummaryFromMapName(MapName);
	if (MapProvider != none)
	{
		return MapProvider.DisplayName;
	}
	return "";
}

/**
 * Sets a talking delegate so we can display chat icons
 *
 * @param bTrack - Whether to Start or Stop the tracking
 */
function TrackChat( bool bTrack )
{
	local OnlineSubSystem OnlineSub;

	OnlineSub = class'GameEngine'.static.GetOnlineSubSystem();
	if ( OnlineSub != none && OnLineSub.VoiceInterface != none )
	{
		if ( bTrack )
		{
			OnlineSub.VoiceInterface.AddPlayerTalkingDelegate(OnPlayerTalking);
		}
		else
		{
			OnlineSub.VoiceInterface.ClearPlayerTalkingDelegate(OnPlayerTalking);
		}
	}
}

/**
 * Callback for when a player has talked.
 *
 * @param TalkingPlayer		UniqueNetId for the player that just talked.
 * @param bIsTalking if true, the player is now talking, if false they are no longer talking
 */
function OnPlayerTalking(UniqueNetId TalkingPlayer,bool bIsTalking)
{
	Local GearPRI TalkerPRI;
	TalkerPRI = ResolveUniqueNetID(TalkingPlayer);
	if ( TalkerPRI != none )
	{
		TalkerPRI.bIsTalking = bIsTalking;
		TalkerPRI.LastTalkTime = GetWorldInfo().RealTimeSeconds;
	}
}

/**
 * Finds the PRI for the player with the NetId passed in.
 *
 * @param TestID		ID to search for.
 *
 * @return a PRI for the player with the provided NetId.
 */
function GearPRI ResolveUniqueNetID(UniqueNetId TestID)
{
	local GearGRI GRI;
	local int i;

	GRI = GearGRI(GetWorldInfo().GRI);
	if (GRI != none)
	{
		for (i=0;i<GRI.PRIArray.Length;i++)
		{
			if (GRI.PRIArray[i] != none && GRI.PRIArray[i].UniqueId == TestID)
			{
				return GearPRI(GRI.PRIArray[i]);
			}
		}
	}
	return none;
}

/**
 * Helper function to encapsulate whether a valid storage device is set or not
 *
 * @param PlayerIndex - PlayerIndex to the player to perform this check on
 *
 * @param CurrDeviceID - returns the DeviceID that is currently being used
 *
 * @return - whether the storage device is set properly or not
 */
final static function bool StorageDeviceIsReady(int PlayerIndex, optional out int CurrDeviceID)
{
	local GearPC CurrGearPC;
	local OnlineSubsystem OnlineSub;
	local OnlinePlayerInterfaceEx PlayerIntEx;
	local bool bResult;

	CurrGearPC = GearPC(class'Engine'.static.GetEngine().GamePlayers[PlayerIndex].Actor);

	// Get the device id from the profile
	if (CurrGearPC != None)
	{
		CurrDeviceID = CurrGearPC.GetDeviceId();
		// Make sure this device is valid
		OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
		if ( OnlineSub != None )
		{
			PlayerIntEx = OnlineSub.PlayerInterfaceEx;
			if ( PlayerIntEx != None )
			{
				bResult = PlayerIntEx.IsDeviceValid( CurrDeviceID );
			}
		}
	}
	else
	{
		CurrDeviceID = -1;
	}
	return bResult;
}

/**
 * Delegate called after the CheckForMemoryDevice is finished (whether or not the selection is needed)
 *		1) It will be triggered after the player selects a device OR
 *		2) It will also be called if device selection can't happen or is not needed.
 *
 *  NOTE!!!  Make sure to clear this delegate when called by using ClearDeviceMemoryCheckCompleteDelegate!!!!
 */
delegate OnDeviceMemoryCheckComplete(bool bWasSuccessful);

/**
 * Checks to see if the profile has a valid device ID and will attempt to retrieve and store one if one does not exist
 *
 * bAlwaysShowUI - will always force the blade to show even when there is only 1 choice
 *
 */
final function CheckForMemoryDevice(delegate<OnDeviceMemoryCheckComplete> CheckCompleteCallback, optional bool bAlwaysShowUI, optional bool bManageStorage)
{
	local OnlineSubsystem OnlineSub;
	local OnlinePlayerInterfaceEx PlayerIntEx;
	local int PlayerIndex;
	local int DeviceID;
	local int ControllerId;

	PlayerIndex = 0;
	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if (OnlineSub != None)
	{
		PlayerIntEx = OnlineSub.PlayerInterfaceEx;
		if (PlayerIntEx != None)
		{
			// See if there's a valid device
			if (bAlwaysShowUI ||
				bManageStorage ||
				!StorageDeviceIsReady(PlayerIndex, DeviceID))
			{
				// Register our callback
				ControllerId = class'UIInteraction'.static.GetPlayerControllerId(PlayerIndex);
				if (class'UIInteraction'.static.IsLoggedIn(ControllerId))
				{
					PlayerIntEx.AddDeviceSelectionDoneDelegate(ControllerId, OnDeviceSelectionComplete);
					if (CheckCompleteCallback != None)
					{
						PlayerIntEx.AddDeviceSelectionDoneDelegate(ControllerId, CheckCompleteCallback);
					}

					// Show the UI
					if (!PlayerIntEx.ShowDeviceSelectionUI(ControllerId, class'GearEngine'.const.MAX_DATASIZE_FOR_ALL_CHECKPOINTS, bManageStorage))
					{
						// Don't wait if there was an error
						`Log("Error occurred while trying to display device selection UI");
						PlayerIntEx.ClearDeviceSelectionDoneDelegate(ControllerId, OnDeviceSelectionComplete);
						if (CheckCompleteCallback != None)
						{
							PlayerIntEx.ClearDeviceSelectionDoneDelegate(ControllerId, CheckCompleteCallback);
						}
					}

					// Return so that the callbacks system can take over
					return;
				}
				else
				{
					`log(`location @ "player" @ PlayerIndex @ "isn't signed in so not showing device selection UI!");
				}
			}
		}
		else
		{
			`Log("No OnlinePlayerInterfaceEx present to display the device selection UI");
		}
	}

	if (CheckCompleteCallback != None)
	{
		CheckCompleteCallback(true);
	}
}

/**
 * Reads the results of the user's device choice
 *
 * @param bWasSuccessful true if the action completed without error, false if there was an error
 */
function OnDeviceSelectionComplete(bool bWasSuccessful)
{
	local OnlineSubsystem OnlineSub;
	local OnlinePlayerInterfaceEx PlayerIntEx;
	local string DeviceName;
	local int DeviceID;
	local GearPC CurrGearPC;
	local int PlayerIndex;

	PlayerIndex = 0;
	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if (OnlineSub != None)
	{
		PlayerIntEx = OnlineSub.PlayerInterfaceEx;
		if (PlayerIntEx != None)
		{
			// Unregister our callback
			PlayerIntEx.ClearDeviceSelectionDoneDelegate(class'UIInteraction'.static.GetPlayerControllerId(PlayerIndex),OnDeviceSelectionComplete);
			// Don't read the information unless it was successful
			if (bWasSuccessful)
			{
				// Read the per user results
				DeviceID = PlayerIntEx.GetDeviceSelectionResults(class'UIInteraction'.static.GetPlayerControllerId(PlayerIndex),DeviceName);
			}
		}
	}

	// If they selected a device
	CurrGearPC = GearPC(GetPC());
	if (CurrGearPC != None)
	{
		// Set device id in the profile
		CurrGearPC.SetDeviceId(DeviceID);
	}
}

/**
 * Determines whether the specified player is the leader of the party.
 *
 * @param	PlayerIndex		the index of the player that generated this event
 */
function bool IsPartyLeader()
{
	local GearPC GearPO;
	local bool bResult;
	local OnlineGameSettings PartySettings;
	local OnlineSubsystem OnlineSub;

	// the current party session should be the most authoritative, so try that one first
	GearPO = GearPC(GetPC());
	if (GearPO != None)
	{
		bResult = GearPO.IsPartyLeader();

		// If false, we have to check for a local party
		if (!bResult)
		{
			// First see that there is a proper profile
			if (GearPO.ProfileSettings != None)
			{
				// If there is a game object we are on the server
				if (GetWorldInfo().Game != None)
				{
					OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
					if (OnlineSub != None &&
						OnlineSub.GameInterface != None)
					{
						// If there is NOT a party settings object we SHOULD be the leader of a local party
						// If not there is an issue
						PartySettings = OnlineSub.GameInterface.GetGameSettings('Party');
						if (PartySettings == None)
						{
							bResult = true;
						}
					}
				}
			}
		}
	}
	return bResult;
}

/** Returns the party game that we are in */
function GearPartyGame_Base GetPartyGame()
{
	local WorldInfo WInfo;
	WInfo = class'WorldInfo'.static.GetWorldInfo();
	return (WInfo != None) ? GearPartyGame_Base(WInfo.Game) : None;
}

/** Determines whether the specified player is allowed to create a game session */
function bool IsAllowedToCreateMatch()
{
	local GearPartyGame_Base PartyGame;

	if (IsPartyLeader())
	{
		PartyGame = GetPartyGame();
		// if we have all required players in our one party, then we can create a match
		// or the configured match type is not public
		return ((!PartyGame.IsOfficialMatch() && !PartyGame.IsPlayerMatch()) ||
				(GearPartyGRI(GetGRI()).TeamCount == 1 && PartyGame.GetPartyTeamSize() == PartyGame.GetNumValidPRIs()));
	}
	return false;
}

/** Return a reference to the gear-specific online game settings data store */
static final function UIDataStore_OnlineGameSettings GetGameSettingsDataStore()
{
	local GameReplicationInfo GRI;

	GRI = class'WorldInfo'.static.GetWorldInfo().GRI;
	if (GearGRI_SP(GRI) != None)
	{
		return UIDataStore_OnlineGameSettings(StaticResolveDataStore(class'GearUIDataStore_CoopGameSettings'.default.Tag));
	}
	else
	{
		return UIDataStore_OnlineGameSettings(StaticResolveDataStore(class'GearUIDataStore_GameSettings'.default.Tag));
	}
}

/** Wrapper for grabbing the game settings object for the currently selected gametype */
static final function OnlineGameSettings GetCurrentGameSettings()
{
	local UIDataStore_OnlineGameSettings GameSettingsDS;
	local OnlineGameSettings Result;

	GameSettingsDS = GetGameSettingsDataStore();
	if (GameSettingsDS != None)
	{
		Result = GameSettingsDS.GetCurrentGameSettings();
	}
	return Result;
}

/** Wrapper for grabbing the controller ids that are logged in */
static final function GetLoggedInControllerIds(out array<int> ControllerIds, optional bool bRequireOnlineLogin, optional int MaxPlayersToCheck=4)
{
	local int ControllerId;

	// Don't check beyond the platforms limits
	MaxPlayersToCheck = Min(class'OnlineSubsystem'.static.GetNumSupportedLogins(),MaxPlayersToCheck);

	ControllerIds.Length = 0;
	for (ControllerId = 0; ControllerId < MaxPlayersToCheck; ControllerId++)
	{
		if (class'UIInteraction'.static.IsLoggedIn(ControllerId, bRequireOnlineLogin))
		{
			ControllerIds.AddItem(ControllerId);
		}
	}
}

/** Wrapper for getting the number of signed in players */
static final function int GetLoggedInPlayerCount( optional bool bRequireOnlineLogin, optional int MaxPlayersToCheck=4)
{
	local array<int> IDs;
	GetLoggedInControllerIds(Ids, bRequireOnlineLogin, MaxPlayersToCheck);
	return Ids.Length;
}

/** Returns the controller icon based on the controller id that is passed */
static final function String GetControllerIcon(int LocalControllerId)
{
	switch (LocalControllerId)
	{
		case 0:
			return class'GFxObject'.static.TranslateString(Localize("ControllerFont", "Controller_Player1", "GearGameUI"));
		case 1:
			return class'GFxObject'.static.TranslateString(Localize("ControllerFont", "Controller_Player2", "GearGameUI"));
		case 2:
			return class'GFxObject'.static.TranslateString(Localize("ControllerFont", "Controller_Player3", "GearGameUI"));
		case 3:
			return class'GFxObject'.static.TranslateString(Localize("ControllerFont", "Controller_Player4", "GearGameUI"));
	}
	return "";
}

/** Returns the number of teams we need to display */
function GetNumTeamsToDisplay(out int NumTeams, out int NumPlayerPerTeam)
{
	local OnlinePlaylistManager PlaylistMan;
	local OnlineSubsystem OnlineSub;
	local GearGRI GRI;
	local int MaxPartySize;

	GRI = GetGRI();

	// If this is a playlist match mode, get the numbers from the playlist
	if (IsOfficialMatch() ||
		IsPlayerMatch())
	{
		NumTeams = 2;
		NumPlayerPerTeam = 5;
		if (GRI != None)
		{
			OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
			if (OnlineSub != None)
			{
				PlaylistMan = OnlinePlaylistManager(OnlineSub.GetNamedInterface('PlaylistManager'));
				if (PlaylistMan != None)
				{
					PlaylistMan.GetTeamInfoFromPlaylist(GRI.PlaylistId, NumPlayerPerTeam, NumTeams,MaxPartySize);
				}
			}
		}
	}
	// Else it's a custom match
	else
	{
		if (IsInSingleTeamGame())
		{
			NumTeams = 1;
			NumPlayerPerTeam = 5;
		}
		else if (IsWingmanGametype(GRI))
		{
			NumTeams = 4;
			NumPlayerPerTeam = 2;
		}
		else if (IsHordeGametype(GRI))
		{
			NumTeams = 1;
			NumPlayerPerTeam = 5;
		}
		else
		{
			NumTeams = 2;
			NumPlayerPerTeam = 5;
		}
	}
}

/** Whether we are currently in a game that requires us to have 1 team and a maximum of 5 players */
function bool IsInSingleTeamGame()
{
	local GearGRI GRI;

	GRI = GetGRI();
	if (GearGRI_SP(GRI) != None)
	{
		return true;
	}
	else if ( IsHordeGametype(GetGRI()) )
	{
		return true;
	}
	return false;
}

/** Wrapper for determining whether the match is configured as an official public match */
static function bool IsOfficialMatch()
{
	local OnlineGameSettings CurrentSettings;
	local int SelectedMatchType;

	CurrentSettings = GetCurrentGameSettings();
	if (CurrentSettings != None &&
		CurrentSettings.GetStringSettingValue(`VERSUS_MATCH_MODE, SelectedMatchType) &&
		SelectedMatchType == eGVMT_Official)
	{
		return true;
	}

	return false;
}

/** Wrapper for determining whether the match is configured as an open public match */
static function bool IsPlayerMatch()
{
	local OnlineGameSettings CurrentSettings;
	local int SelectedMatchType;

	CurrentSettings = GetCurrentGameSettings();
	if (CurrentSettings != None &&
		CurrentSettings.GetStringSettingValue(`VERSUS_MATCH_MODE, SelectedMatchType) &&
		SelectedMatchType == eGVMT_Player)
	{
		return true;
	}

	return false;
}

/** Wrapper for determining whether the match is configured as a private live match */
static function bool IsCustomMatch()
{
	local OnlineGameSettings CurrentSettings;
	local int SelectedMatchType;

	CurrentSettings = GetCurrentGameSettings();
	if (CurrentSettings != None &&
		CurrentSettings.GetStringSettingValue(`VERSUS_MATCH_MODE, SelectedMatchType) &&
		SelectedMatchType == eGVMT_Custom)
	{
		return true;
	}

	return false;
}

/** Wrapper for determining whether the match is configured as local match */
static function bool IsLocalMatch()
{
	local OnlineGameSettings CurrentSettings;
	local int SelectedMatchType;

	CurrentSettings = GetCurrentGameSettings();
	if (CurrentSettings != None &&
		CurrentSettings.GetStringSettingValue(`VERSUS_MATCH_MODE, SelectedMatchType) &&
		SelectedMatchType == eGVMT_Local)
	{
		return true;
	}

	return false;
}

/** Accessor for determining whether the currently selected gametype is wingman */
final static function bool IsWingmanGametype( GearGRI GRI )
{
	local int ValueId;
	local OnlineGameSettings GameSettings;
	local bool bIsRanked;

	bIsRanked = IsOfficialMatch();
	// If this is a playlist match mode
	if (bIsRanked ||
		IsPlayerMatch())
	{
		if (GRI != None)
		{
			return class'GearPartyGame_Base'.static.PlaylistContainsGameType(GRI.PlaylistId, eGEARMP_Wingman, bIsRanked);
		}
	}
	else
	{
		GameSettings = GetCurrentGameSettings();
		if (GameSettings != None &&
			GameSettings.GetStringSettingValue(class'GearVersusGameSettings'.const.CONTEXT_VERSUSMODES, ValueId) &&
			ValueId == eGEARMP_Wingman)
		{
			return true;
		}
	}

	return false;
}

/** Returns the number of bots that the server has selected for this game */
final function int GetNumBots()
{
	local OnlineGameSettings GameSettings;
	local int IntValue;
	local int NumTeams;
	local int NumPlayerPerTeam;
	local GearGRI GRI;

	if (IsPlayerMatch())
	{
		GRI = GetGRI();
		GetNumTeamsToDisplay(NumTeams, NumPlayerPerTeam);
		IntValue = Max((NumTeams * NumPlayerPerTeam) - GRI.PRIArray.length, 0);
	}
	else if (!IsOfficialMatch())
	{
		GameSettings = GetCurrentGameSettings();
		GameSettings.GetStringSettingValue(class'GearVersusGameSettings'.const.CONTEXT_NUMBOTS, IntValue);
	}
	else
	{
		IntValue = 0;
	}
	return IntValue;
}

/** Accessor for determining whether the currently selected gametype is guardian */
static final function bool IsGuardianGametype( GearGRI GRI )
{
	local int ValueId;
	local OnlineGameSettings GameSettings;
	local bool bIsRanked;

	bIsRanked = IsOfficialMatch();
	// If this is a playlist match mode
	if (bIsRanked ||
		IsPlayerMatch())
	{
		if (GRI != None)
		{
			return class'GearPartyGame_Base'.static.PlaylistContainsGameType(GRI.PlaylistId, eGEARMP_CTL, bIsRanked);
		}
	}
	else
	{
		GameSettings = GetCurrentGameSettings();
		if (GameSettings != None &&
			GameSettings.GetStringSettingValue(class'GearVersusGameSettings'.const.CONTEXT_VERSUSMODES, ValueId) &&
			ValueId == eGEARMP_CTL)
		{
			return true;
		}
	}

	return false;
}

/** Accessor for determining whether the currently selected gametype is horde OR siege */
static final function bool IsHordeGametype( GearGRI GRI )
{
	local int ValueId;
	local OnlineGameSettings GameSettings;
	local bool bIsRanked;

	bIsRanked = IsOfficialMatch();
	// If this is a playlist match mode
	if (bIsRanked ||
		IsPlayerMatch())
	{
		if (GRI != None)
		{
			return (class'GearPartyGame_Base'.static.PlaylistContainsGameType(GRI.PlaylistId, eGEARMP_Horde, bIsRanked) ||
			class'GearPartyGame_Base'.static.PlaylistContainsGameType(GRI.PlaylistId, eGEARMP_Siege, bIsRanked));
		}
	}
	else
	{
		GameSettings = GetCurrentGameSettings();
		if (GameSettings != None &&
			GameSettings.GetStringSettingValue(class'GearVersusGameSettings'.const.CONTEXT_VERSUSMODES, ValueId) &&
			(ValueId == eGEARMP_Horde || ValueId == eGEARMP_Siege))
		{
			return true;
		}
	}

	return false;
}

/** Accessor for determining whether the currently selected gametype is siege */
static final function bool IsSiegeGametype( GearGRI GRI )
{
	local int ValueId;
	local OnlineGameSettings GameSettings;
	local bool bIsRanked;

	bIsRanked = IsOfficialMatch();
	// If this is a playlist match mode
	if (bIsRanked ||
		IsPlayerMatch())
	{
		if (GRI != None)
		{
			return class'GearPartyGame_Base'.static.PlaylistContainsGameType(GRI.PlaylistId, eGEARMP_Siege, bIsRanked);
		}
	}
	else
	{
		GameSettings = GetCurrentGameSettings();
		if (GameSettings != None &&
			GameSettings.GetStringSettingValue(class'GearVersusGameSettings'.const.CONTEXT_VERSUSMODES, ValueId) &&
			(ValueId == eGEARMP_Siege))
		{
			return true;
		}
	}

	return false;
}

defaultproperties
{
	bAutoPlay=TRUE
	bEnableGammaCorrection=FALSE
	TimingMode=TM_Real
	Priority=GEAR_SCENE_PRIORITY_NORMAL

	// Default post process for Gears UI scenes
	MenuPostProcessSettings={(  bEnableBloom=FALSE,
								bEnableDOF=TRUE,
								bEnableMotionBlur=FALSE,
								bEnableSceneEffect=FALSE,

								DOF_InterpolationDuration=0.f,
								DOF_FocusInnerRadius=0.f,
								DOF_MaxNearBlurAmount=6,
								DOF_MaxFarBlurAmount=6, 
				
								bOverride_EnableBloom=FALSE,
								bOverride_EnableDOF=TRUE,
								bOverride_EnableMotionBlur=FALSE,
								bOverride_EnableSceneEffect=FALSE,
								bOverride_AllowAmbientOcclusion=FALSE,
								bOverride_OverrideRimShaderColor=FALSE,

								bOverride_Bloom_Scale=FALSE,
								bOverride_Bloom_Threshold=FALSE,
								bOverride_Bloom_Tint=FALSE,
								bOverride_Bloom_ScreenBlendThreshold=FALSE,
								bOverride_Bloom_InterpolationDuration=FALSE,

								bOverride_DOF_FalloffExponent=FALSE,
								bOverride_DOF_BlurKernelSize=FALSE,
								bOverride_DOF_BlurBloomKernelSize=FALSE,
								bOverride_DOF_MaxNearBlurAmount=TRUE,
								bOverride_DOF_MaxFarBlurAmount=TRUE,
								bOverride_DOF_ModulateBlurColor=FALSE,
								bOverride_DOF_FocusType=FALSE,
								bOverride_DOF_FocusInnerRadius=TRUE,
								bOverride_DOF_FocusDistance=FALSE,
								bOverride_DOF_FocusPosition=FALSE,
								bOverride_DOF_InterpolationDuration=TRUE )}


}
