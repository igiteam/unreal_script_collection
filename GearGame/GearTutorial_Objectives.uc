/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearTutorial_Objectives extends GearTutorial_PCAction_Base
	config(Game);


/************************************************************************/
/* Script functions                                                     */
/************************************************************************/

/** Action to perform on the player when this tutorial is completed - implemented by all subclasses */
function PerformPCInputAction( bool bPressed )
{
	if (!GearPC(Outer).bAssessMode)
	{
		GearPlayerInput(InputHandler).HandleButtonInput_LeftBumper(bPressed);
	}
}

/** Called every tick so that the tutorial has a chance to update itself */
event Update()
{
	if (GearPC(Outer).bAssessMode)
	{
		OnTutorialCompleted();
	}

	Super.Update();
}

/** Called when the tutorial's scene is finished opening */
function OnTutorialSceneOpened()
{
	Super.OnTutorialSceneOpened();

	InputHandler = new(TutorialMgr.Outer) class'GearPlayerInputTutorialPC';
	if (InputHandler != None)
	{
		InitializeInputHandler();
		TutorialMgr.AddInputHandlerForSystem(InputHandler);
	}

	ToggleFreezeGameplay(true);
}

defaultproperties
{
	TutorialType=GEARTUT_Objectives
	GameButtonType=GB_LeftBumper
	InputHandlerClass=None
}
