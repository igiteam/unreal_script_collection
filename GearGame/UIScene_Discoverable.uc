/**
 * The scene which pops up when you find a discoverable in game
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class UIScene_Discoverable extends GearGFxMoviePlayer;

// --- Widget References --------------------------------
/** The view that serves as an interface to the ActionScript side of the scene */
var private transient GFxObject     DiscoverableView;
var private transient GFxObject     lbl_Title;
var private transient GFxObject     lbl_Body;
var private transient GFxObject     ButtonBar;
var private transient GFxObject     BackgroundImage;

// --- Strings ------------------------------------------
var private transient string        TitleString;
var private transient string        BodyString;
var private transient string        ImagePath;

/** String containing the controller map for this scene */
var localized string                ButtonBarString;

// --- Misc. Variables ----------------------------------
/** The stinger to play when this scene is opening */
var SoundCue PickupStingerCueResource;
/** The music to play in the background while this scene is up */
var SoundCue BackgroundMusicCue;

/** AudioComponent to control playing the cog tag queue */
var private transient AudioComponent PickupStingerAC;

/** TRUE if the menu is animating out, FALSE if not */
var transient bool bIsFadingOut;

//=======================================================
// MoviePlayer overrides
//=======================================================

/** 
 *  This should be called when a new GearGFxMoviePlayer is initialized.
 *  Handles the setting up of the LocalPlayerIndex, as well as automatically starting / advancing the movie if desired 
 *  
 *  @param LocPlayer - Local player that is to be the owner of this scene
 */
function Init(optional LocalPlayer LocPlayer)
{
	local GearPC MyGearPC;
	local GearUIDataStore_GameResource GameResourceDS;
	
	MyGearPC = GetGearPC();

	// Locate the string values for the discoverable, and save them off to be set during widgetinit
	GameResourceDS = GetGameResourceDataStore();
	if ( (MyGearPC != None) && (GameResourceDS != None) )
	{
		if ( !GameResourceDS.GetDiscoverableDisplayStrings(MyGearPC.DiscoverType, TitleString, BodyString) )
		{
			`log(`location @ "failed to resolve title or description for discoverable" @ `showenum(EGearDiscoverableType,MyGearPC.DiscoverType));
		}

		if ( !GameResourceDS.GetDiscoverableBackgroundPath(MyGearPC.DiscoverType, ImagePath) )
		{
			`log(`location @ "failed to resolve background image pathname for discoverable" @ `showenum(EGearDiscoverableType,MyGearPC.DiscoverType));
		}
	}

	// If we are going to pause the game, do it and start the music
	if (ShouldPauseGame())
	{
		PauseGame();
		StartMusic();
	}

	Super.Init(LocPlayer);
}

/**
 * Called when the video is closed
 */
event OnClose()
{
	Super.OnClose();

	// Unregister this with the hud
	GearHUD_Base(GetPC().myHUD).DiscoverablePlayerInstance = None;

	// stop the music
	StopMusic();
	// Unpause game
	UnpauseGame();
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
		case 'DiscoverableView':
			DiscoverableView = Widget;
			ActionScript_FadeIn();
			break;
		case 'lbl_Title':
			lbl_Title = Widget;
			lbl_Title.SetString("htmlText", TitleString);
			break;
		case 'lbl_Body':
			lbl_Body = Widget;
			lbl_Body.SetString("htmlText", BodyString);
			break;
		case 'ButtonBar':
			ButtonBar = Widget;
			ButtonBar.SetString("htmlText", ButtonBarString);
			break;
		case 'BackgroundImage':
			BackgroundImage = Widget;
			BackgroundImage.SetString("source", "img://" $ ImagePath);
			break;
		default:
			return FALSE;
	}

	return TRUE;
}


/** Can be overridden to filter input to this movie.  Return TRUE to trap the input, FALSE to let it pass through to Gfx */
event bool FilterButtonInput(int ControllerId, name ButtonName, EInputEvent InputEvent)
{
	if( (ButtonName == 'XboxTypeS_B') && (InputEvent == IE_Pressed) )
	{
		FadeOut();
		return TRUE;
	}

	return FALSE;
}


//=======================================================
// ActionScript stubs and callbacks
//=======================================================
function ActionScript_FadeIn()
{
	DiscoverableView.ActionScriptVoid("FadeIn");
}

function ActionScript_FadeOut()
{
	DiscoverableView.ActionScriptVoid("FadeOut");
}

function Callback_DoneFadingOut()
{
	Close(TRUE);
}

//=======================================================
// Helper Functions
//=======================================================
/**
 * Called to fade out the scene.  Prevents multiple calls during animation
 */
function FadeOut()
{
	if( !bIsFadingOut )
	{
		bIsFadingOut = TRUE;
		ActionScript_FadeOut();
	}
}

/** Callback the server uses to determine if the unpause can happen */
function bool CanUnpause()
{
	return (bIsFadingOut || !ShouldPauseGame());
}

/** Whether we should pause the game or not */
function bool ShouldPauseGame()
{
	local WorldInfo WI;
	local GearPC PC;

	WI = GetWorldInfo();

	// Pause the game if there are no networked players
	if (WI.NetMode < NM_Client)
	{
		foreach WI.AllControllers(class'GearPC', PC)
		{
			if (!PC.IsLocalPlayerController())
			{
				// Found a networked player, bail
				return false;
			}
		}
		// I am the server and never found a networked player
		return true;
	}
	// I'm a networked client
	return false;
}

/** Pause the game */
function PauseGame()
{
	GetGearPC().SetPause(true, CanUnpause);
}

/** Unpause the game */
function UnpauseGame()
{
	GetGearPC().SetPause(false);
}

/** Start the background music */
function StartMusic()
{
	local GearPC MyGearPC;

	MyGearPC = GetGearPC();

	if( MyGearPC != None )
	{
		// Play the stinger
		if( PickupStingerCueResource != None )
		{
			MyGearPC.ClientPlaySound(PickupStingerCueResource);
		} 

		// Play the background music
		if (BackgroundMusicCue != None)
		{
			PickupStingerAC = MyGearPC.CreateAudioComponent(BackgroundMusicCue, false, true);
			if (PickupStingerAC != none)
			{
				PickupStingerAC.bAllowSpatialization = false;
				PickupStingerAC.bAutoDestroy = true;
				PickupStingerAC.Play();
			}
		}
	}
	
}

/** Stop the background music */
function StopMusic()
{
	if (PickupStingerAC != none)
	{
		PickupStingerAC.FadeOut(1.0f, 0.0f);
		PickupStingerAC = none;
	}
}

defaultproperties
{
	bCaptureInput=true

	CaptureKeys.Empty()
	CaptureKeys(0)=XboxTypeS_B
}
