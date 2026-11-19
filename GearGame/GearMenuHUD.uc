/**
 * HUD class for the front-end.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearMenuHUD extends HUD
	config(Game);


/** The reference to the class of the front end movie object for "FrontEndMovie" (contains the art assets needed) */
var const class<UIScene_FrontEnd> FrontEndMovieClass;
/** The front end object that kick starts everything */
var UIScene_FrontEnd FrontEndMovie;

/** The reference to the class of the pregame lobby to spawn (contains the art assets needed) */
var const class<UIScene_PregameLobby> PregameLobbyClass;
/** Reference to the pregame lobby */
var UIScene_PregameLobby    PregameLobbyMovie;

/** The reference to the class of the credits movie to spawn (contains the art assets needed) */
var const class<UIScene_Credits> CreditsClass;
/** Reference to the credits movie */
var UIScene_Credits     CreditsMovie;

/** Reference to the background movie scene.  This is in the level, and opened by kismet.  The scene registers itself here */
var transient UIScene_Background  BackgroundMovie;

/** Whether we should load a movie or not */
var bool bStartedMovie;

/** Whether the front end history is ready for use */
var bool bCanUseFrontEndHistory;

/** cached reference to Actor that draws the overhead map, used when travelling but haven't received the game HUD from the server */
var OverheadMapPlacementActor OverheadMapActor;

// --- Misc. Variables -----------------------------------------

/** Color lookup table for post process blur effect for the client menu */
var Texture2D ClientBlurColorLUT;


/** The Main Draw loop for the HUD - we don't want it called */
function DrawHUD()
{
	// Determine if we should load a GFx menu, and if so, load and init the appropriate one
	//MUST BE PLAYER 0!
	if (class'Engine'.static.GetEngine().GamePlayers[0] == LocalPlayer(PlayerOwner.Player) && !bStartedMovie)
	{
		if (ShouldDisplayCredits())
		{
			// Check to see if this was a credits travel, and if so, play them
			InitializeCredits();

			// Mark movie as started
			bStartedMovie = true;

			// Clear the flag for displaying credits
			ClearLocalPlayerCreditsFlag();
		}
		// If the GRI has replicated and it is determined to be a pregame one
		else if (WorldInfo.GRI != None &&
			GearPreGameGRI(WorldInfo.GRI) != None)
		{
			// Handle pregame lobby UI initialization (do nothing until we is ready to put new one in)
			InitializePregameLobby();

			// Mark movie as started
			bStartedMovie = true;
		}
		// We are in the front end initialize it
		else if (WorldInfo.GRI != None ||
				 GearLocalPlayer(PlayerOwner.Player).bIsFirstFrontEndLoad)
		{
			InitializeFrontEnd();
			SetPartyMemberPostProcessingEffect();

			// Mark movie as started
			bStartedMovie = true;
		}
	}

	// draw the overhead map as a placeholder when travelling and haven't yet received a new HUD
	if (!WorldInfo.IsMenuLevel())
	{
		if (OverheadMapActor == None)
		{
			foreach AllActors(class'OverheadMapPlacementActor', OverheadMapActor)
			{
				break;
			}
		}
		if (OverheadMapActor != None)
		{
			OverheadMapActor.DrawOverheadMap(self);
		}
	}
}


simulated function SetPartyMemberPostProcessingEffect()
{
	if (WorldInfo.NetMode == NM_Client)
	{
		WorldInfo.DefaultPostProcessSettings.bEnableSceneEffect = true;
		WorldInfo.DefaultPostProcessSettings.bOverride_Scene_ColorGradingLUT = TRUE;
		WorldInfo.DefaultPostProcessSettings.ColorGrading_LookupTable = ClientBlurColorLUT;
		WorldInfo.DefaultPostProcessSettings.bEnableDOF = true;
		WorldInfo.DefaultPostProcessSettings.DOF_FocusInnerRadius = 0;
		WorldInfo.DefaultPostProcessSettings.DOF_MaxFarBlurAmount = 1.0;
		WorldInfo.DefaultPostProcessSettings.DOF_MaxNearBlurAmount = 1.0;
	}
}


/** Instance the front end object and load the movie */
simulated function InitializeFrontEnd()
{
	// Instance the front end if it hasn't been and if the history is ready or I'm the host
	// Also only if this is the primary player...there should be no frontend for anyone but the primary player
	if (class'Engine'.static.GetEngine().GamePlayers[0] == PlayerOwner.Player &&
		FrontEndMovie == None &&
		GearPreGameGRI(WorldInfo.GRI) == None &&
		(bCanUseFrontEndHistory || PlayerOwner.Role == ROLE_Authority))
	{
		if (FrontEndMovieClass != None)
		{
			FrontEndMovie = new(self) FrontEndMovieClass;
			FrontEndMovie.Init(LocalPlayer(PlayerOwner.Player));

			// Align the camera for normal main menu mode
			NotifyKismetCamera(0);
		}
		else
		{
			`log("Unable to initialize the front end due to not finding the GFxFrontEnd class to load!");
		}
	}
}

/** Closes any existing front end and reconstructs it */
simulated function RestartFrontEnd()
{
	if (FrontEndMovie != none)
	{
		FrontEndMovie.Close();
		FrontEndMovie = none;
	}
	GearLocalPlayer(PlayerOwner.Player).bIsFirstFrontEndLoad = true;
	InitializeFrontEnd();
}

/** Instance the pregame lobby object and load the movie */
simulated function InitializePregameLobby()
{
	// Instance the front end if it hasn't been
	if (FrontEndMovie == None)
	{
		if (PregameLobbyClass != None)
		{
			PregameLobbyMovie = new(self) PregameLobbyClass;
			PregameLobbyMovie.Init(LocalPlayer(PlayerOwner.Player));

			// Jump the background movie to the menu state
			if( BackgroundMovie != None )
			{
				BackgroundMovie.JumpToMenu();
			}

			// Align the camera for pregame lobby mode
			NotifyKismetCamera(1);
		}
		else
		{
			`log("Unable to initialize the pregame lobby due to not finding the GFx class to load!");
		}
	}
}

/** Whether the frontend should roll the credits at startup or not */
function bool ShouldDisplayCredits()
{
	local GearLocalPlayer LP;

	LP = GearLocalPlayer(PlayerOwner.Player);
	return (LP != None && LP.bDisplayCredits);
}

/** Clear the display credits flag for this local player */
function ClearLocalPlayerCreditsFlag()
{
	local GearLocalPlayer LP;

	LP = GearLocalPlayer(PlayerOwner.Player);
	LP.bDisplayCredits = false;
}

/** Instance the credits object, and load the movie */
simulated function InitializeCredits()
{
	if( FrontEndMovie == None )
	{
		if (CreditsClass != None)
		{
			CreditsMovie = new(self) CreditsClass;
			CreditsMovie.Init(LocalPlayer(PlayerOwner.Player));

			// Align the camera for normal main menu mode
			NotifyKismetCamera(0);
		}
		else
		{
			`log("Unable to initialize the pregame lobby due to not finding the GFx class to load!");
		}
	}
}

/**
 * Registers the background, which is opened via kismet in the level, with the menu HUD
 *
 * @param   NewBackground   Reference to the background UIScene
 */
simulated function RegisterBackgroundMovie(UIScene_Background NewBackground)
{
	// Save a reference to the background
	BackgroundMovie = NewBackground;

	// If the PGL is already up, go to the menu background
	if( PregameLobbyMovie != None || (FrontEndMovie != None && !FrontEndMovie.bOnTitleScreen) )
	{
		BackgroundMovie.JumpToMenu();
	}
}

/**
 * Called to fire off notifications to kismet via SeqEvent_MenuEntered that we've changed states
 * 
 * @param   IndexToActivate     Output index on SeqEvent_MenuEntered to activate
 */
function NotifyKismetCamera(int IndexToActivate)
{
	local Sequence GameSeq;
	local array<SequenceObject> AllEvents;
	local int i;
	local array<int> IndicesToActivate;
	local SeqEvent_MenuEntered MenuEvent;

	// Find any kismet events in the world that we need to notify
	GameSeq = class'WorldInfo'.static.GetWorldInfo().GetGameSequence();
	if( GameSeq != None )
	{
		GameSeq.FindSeqObjectsByClass(class'SeqEvent_MenuEntered', TRUE, AllEvents);

		// Take only the first background event we find
		for( i = 0; i < AllEvents.Length; i++ )
		{
			MenuEvent = SeqEvent_MenuEntered(AllEvents[i]);
			if( MenuEvent != None )
			{
				// Found one, we're done
				break;
			}
		}
	}
		
	// Process the event, if we have one
	if( MenuEvent != None )
	{
		IndicesToActivate.AddItem(IndexToActivate);
		MenuEvent.CheckActivate(class'WorldInfo'.static.GetWorldInfo(), None, FALSE, IndicesToActivate);
	}
}

DefaultProperties
{
	ClientBlurColorLUT=Texture2D'UI_Gearstart.lut.LUT_ClientView'
}
