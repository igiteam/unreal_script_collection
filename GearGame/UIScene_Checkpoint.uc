/**
 * Checkpoint scene - the thing that pops out of the lower left side to display cogspin
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class UIScene_Checkpoint extends UIScene_Busy
	config(UI);

/** 
 *  Overridden to PASS INPUT THROUGH
 *  @param ControllerId - controller id of the input
 *  @param ButtonName - the button that was pressed
 *  @param InputEvent - the input event
 *  
 *  @return TRUE to consume the input, FALSE to allow others to respond to the input
 */
event bool FilterButtonInput(int ControllerId, name ButtonName, EInputEvent InputEvent)
{
	return false;
}

defaultproperties
{
 	MovieInfo=SwfMovie'UI_Common.UI_Checkpoint'
	bAllowInput=false
	bAllowFocus=false

	WaitingString="SavingContent_CheckpointTitle"
	ExplanationString="SavingContent_Message"
}
