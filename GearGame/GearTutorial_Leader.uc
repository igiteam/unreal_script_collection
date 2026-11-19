/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearTutorial_Leader extends GearTutorial_GenericPress_Base
	config(Game);

//The amount of time before the button becomes active
var config float TimeBeforeButton;

var bool bReadyToHandleButton;


/** Initializes the strings on the opened UI scene */
function InitializeUISceneLabels( optional bool bHideButtonText )
{
	local GearPC_MP PCMP;
	
	Super.InitializeUISceneLabels(true);
	//Don't show the button stuff just yet
	if ( SceneInstance != None )
	{
		SceneInstance.ShowButtonLabel(false);
	}
	
	PCMP = GearPC_MP(TutorialMgr.Outer);
	
	if (PCMP != None)
	{
		PCMP.LeaderTutorial = self;
		PCMP.SetTimer(TimeBeforeButton, false, nameof(PCMP.ReadyLeader));
	}
}

function ReadyButton()
{	
	if ( SceneInstance != None )
	{
		SceneInstance.ShowButtonLabel(true);
	}
	bReadyToHandleButton = true;
}


//Don't actually let it close the scene until the designated time has elapsed
function HandleButtonInput_CloseScene(bool bPressed, optional bool bDblClickMove)
{
	if (bReadyToHandleButton)
	{
		Super.HandleButtonInput_CloseScene(bPressed, bDblClickMove);
	}
}

defaultproperties
{
	TutorialType=GEARTUT_Leader
	GameButtonType=GB_A
	
	bSaveTutorialToProfile=false
	TutorialPriority=TUTORIAL_PRIORITY_IMMEDIATE
	
	bReadyToHandleButton=false;
}
