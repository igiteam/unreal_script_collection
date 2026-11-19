/**
 * Backing class to support the frontend and transition backgrounds
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class UIScene_Background extends GearGFxMoviePlayer;

// --- Widget References --------------------------------
/** A reference to the clip that contains all the states we need to send the BG to */
var private transient GFxObject Background;

/** Transient reference to the kismet event in the world that triggers based off the background state  */
var private transient SeqEvent_Background   BackgroundEvent;

//=======================================================
// Movie Player Functions
//=======================================================

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
		case 'Background':
			Background = Widget;
			RegisterBackground();
			break;
		default:
			return FALSE;
	}

	return TRUE;
}

/**
 * Registers the background with the menu hud
 */
function RegisterBackground()
{
	local GearPC    GPC;
	local GearMenuHUD MenuHUD;
	local WorldInfo WI;
	local bool bFoundRegistrant;

	// Initialized, so notify kismet we're on attract
	NotifyKismetEvent(0);

	WI = class'WorldInfo'.static.GetWorldInfo();
	foreach WI.LocalPlayerControllers(class'GearPC', GPC)
	{
		MenuHUD = GearMenuHUD(GPC.myHUD);
		if( MenuHUD != None )
		{
			MenuHUD.RegisterBackgroundMovie(self);
			bFoundRegistrant = TRUE;
			break;
		}
	}

	// If we couldn't find a scene to register to, then jump to the menu
	if( !bFoundRegistrant )
	{
		JumpToMenu();
	}
}

//=======================================================
// State control
//=======================================================
/**
 * Send the background into attract mode
 */
function TransitionToAttract()
{
	if( Background != None )
	{
		Background.GotoAndPlay("attract");

		NotifyKismetEvent(0);
	}
}

/**
 * Transition the background into main menu mode
 */
function TransitionToMenu()
{
	if( Background != None )
	{
		Background.GotoAndPlay("transition");

		NotifyKismetEvent(1);
	}
}

/**
 * Send the background directly to main menu mode
 */
function JumpToMenu()
{
	if( Background != None )
	{
		Background.GotoAndPlay("main");

		NotifyKismetEvent(2);
	}
}

//======================================================
// Kismet Interface
//======================================================
/**
 * Called when a background movie control kismet action is fired on this movie
 * 
 * @param   Action  The action that was triggered
 */
function OnBackgroundMovieControl(SeqAct_BackgroundMovieControl Action)
{
	if( Action.InputLinks[0].bHasImpulse )
	{
		TransitionToAttract();
	}
	else if( Action.InputLinks[1].bHasImpulse )
	{
		TransitionToMenu();
	}
	else if( Action.InputLinks[2].bHasImpulse )
	{
		JumpToMenu();
	}
}

/**
 * Called to fire off notifications to kismet via SeqEvent_Background that we've changed states
 * 
 * @param   IndexToActivate     Output index on SeqEvent_Background to activate
 */
function NotifyKismetEvent(int IndexToActivate)
{
	local Sequence GameSeq;
	local array<SequenceObject> AllEvents;
	local int i;
	local array<int> IndicesToActivate;

	// See if we need to find a background event to call
	if( BackgroundEvent == None )
	{
		// Find any kismet events in the world that we need to notify
		GameSeq = class'WorldInfo'.static.GetWorldInfo().GetGameSequence();
		if( GameSeq != None )
		{
			GameSeq.FindSeqObjectsByClass(class'SeqEvent_Background', TRUE, AllEvents);

			// Take only the first background event we find
			for( i = 0; i < AllEvents.Length; i++ )
			{
				BackgroundEvent = SeqEvent_Background(AllEvents[i]);
				if( BackgroundEvent != None )
				{
					// Found one, we're done
					break;
				}
			}
		}
	}
	
	// Process the event, if we have one
	if( BackgroundEvent != None )
	{
		IndicesToActivate.AddItem(IndexToActivate);
		BackgroundEvent.CheckActivate(class'WorldInfo'.static.GetWorldInfo(), None, FALSE, IndicesToActivate);
	}
}

defaultproperties
{
}
