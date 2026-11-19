/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearTutorial_Mantle1 extends GearTutorial_Base
	config(Game);


/**
 * Called when the tutorial manager wants this tutorial to deactivate itself, such as a death or a scripted event etc.
 * This will not remove or complete the tutorial, but just make it inactive until further notice.
 * @Param bReadyForActivation - whether the "ready for activation" flag should remain on or not
 */
function bool TutorialDeactivated( optional bool bReadyForActivation )
{
	local bool bReturnValue;

	bReturnValue = Super.TutorialDeactivated(bReadyForActivation);
	TotalWaitTimeBeforeTip = 0.0f;
	bSceneHasBeenOpened = false;

	return bReturnValue;
}


defaultproperties
{
	TutorialType=GEARTUT_Mantle1
}
