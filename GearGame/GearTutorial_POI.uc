/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearTutorial_POI extends GearTutorial_PCAction_Base
	config(Game);


/************************************************************************/
/* Script functions                                                     */
/************************************************************************/

/** Action to perform on the player when this tutorial is completed - implemented by all subclasses */
function PerformPCInputAction( bool bPressed )
{
	GearPlayerInput(InputHandler).HandleButtonInput_Y(bPressed);
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

/** Callback for closing the UIScene */
function HandleButtonInput_CloseScene(bool bPressed, optional bool bDblClickMove)
{
	Super.HandleButtonInput_CloseScene(bPressed, bDblClickMove);

	if (bPressed)
	{
		OnTutorialCompleted();
	}
}

defaultproperties
{
	TutorialType=GEARTUT_PointOfInterest
	GameButtonType=GB_Y
	InputHandlerClass=None
}
