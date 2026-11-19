/** 
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 * 
 * UIWidget_MenuHeader.uc
 * 
 * Supporting class for the menu header used in the frontend and pregame lobby.  Corresponds with the ActionScript class gears.controls.MenuHeader
 */

class UIWidget_MenuHeader extends GFxObject;

/** TRUE if the pregame timer is visible, FALSE if not */
var bool    bPregameTimeIsVisible;

/** TRUE if the spinning Cog is visible, FALSE if not */
var bool    bSpinningCogIsVisible;

/** Stores the last time displayed.  Will only update GFx if the new time is different than the last */
var int     LastUpdatedTime;

/**
 *  Sets a new value for the pregame time 
 * 
 *  @param  NewTime     Time, in seconds, which will be converted and formatted like 00:00
 */
function SetPregameTime( int NewTime )
{
	if( NewTime != LastUpdatedTime )
	{
		LastUpdatedTime = NewTime;
		SetString("PregameTime", class'GearGFxMoviePlayer'.static.FormatTime(NewTime));

		// Play a countdown sound to go along with the changing of the time
		if( bPregameTimeIsVisible && NewTime <= 3 )
		{
			GearGFxMoviePlayer(Outer).PlaySoundFromTheme(((NewTime == 0) ? 'CountdownEnd' : 'Countdown') );
		}
	}
}

/**
 * Shows and hides the pregame timer
 * 
 * @param   bNewVisible TRUE to show the pregame timer, FALSE to hide it
 */
function SetPregameTimerVisibility( bool bNewVisible )
{
	// Update the visiblity only if it has changed
	if( bPregameTimeIsVisible != bNewVisible )
	{
		GetObject("lbl_PreGameTime").SetBool("_visible", bNewVisible);
		bPregameTimeIsVisible = bNewVisible;
	}
}

/**
 * Shows and hides the spinning Cog at the right of the menu header.
 * 
 * @param   bNewVisible TRUE to show the spinning Cog timer, FALSE to hide it
 */
function SetSpinningCogVisibility( bool bNewVisible )
{
	local String AnimationLabel;

	// Update the visiblity only if it has changed
	if( bSpinningCogIsVisible != bNewVisible )
	{
		AnimationLabel = ( bNewVisible ) ? "on" : "off";
		GetObject("HeaderCog").GotoAndPlay(AnimationLabel);		
		bSpinningCogIsVisible = bNewVisible;
	}
}

/**
 * Sets the current title of the menu, without animation
 * 
 * @param  NewTitle	    New text to display
 */
function SetCurrentTitle( string NewTitle )
{
	SetString("CurrentTitle", NewTitle);
}

/**
 * Sets the previous title of the menu, without animation
 * 
 * @param  NewTitle	    New text to display
 */
function SetPreviousTitle( string NewTitle )
{
	SetString("PreviousTitle", NewTitle);
}

/**
 * Pushes a new title on to the stack, and causes a forward animation to play
 * 
 * @param   NewTitle    New text to display in the header
 */
function PushTitleOnStack( string NewTitle )
{
	ActionScript_PushTitleOnStack(NewTitle);
}

/**
 * Removes a title from the stack, and causes a backwards animation to occur
 * 
 * @return  The title that was removed from the stack
 */
function string PopTitleFromStack()
{
	return ActionScript_PopTitleFromStack();
}

/**
 * Changes the title and animates forward, without pushing the title onto the stack
 * 
 * @param   NewTitle    Title to display in the header
 */
function ChangeTitleForward( string NewTitle )
{
	ActionScript_ChangeTitleForward(NewTitle);
}

/**
 * Changes the title and animates backward, without pushing the title onto the stack
 * 
 * @param   NewTitle    Title to display in the header
 */
function ChangeTitleBackward( string NewTitle )
{
	ActionScript_ChangeTitleBackward( NewTitle );
}

//=============================================================
// ActionScript Stubs
//=============================================================

private function ActionScript_PushTitleOnStack(string NewTitle)
{
	ActionScriptVoid("PushTitleOnStack");
}

private function string ActionScript_PopTitleFromStack()
{
	return ActionScriptString("PopTitleFromStack");
}

private function ActionScript_ChangeTitleForward(string NewTitle)
{
	ActionScriptVoid("ChangeTitleForward");
}

private function ActionScript_ChangeTitleBackward(string NewTitle)
{
	ActionScriptVoid("ChangeTitleBackward");
}


defaultproperties
{
	bPregameTimeIsVisible=TRUE
	bSpinningCogIsVisible=FALSE
}
