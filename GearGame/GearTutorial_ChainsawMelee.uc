/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearTutorial_ChainsawMelee extends GearTutorial_Base
	config(Game);


/** Called when the tutorial gets added to the tutorial manager's list */
function OnTutorialAdded( GearTutorialManager TutMgr, SeqAct_ManageTutorials Action, bool IsKismetDriven  )
{
	Super.OnTutorialAdded( TutMgr, Action, IsKismetDriven );

	GearPC(Outer).AddGearEventDelegate(eGED_Chainsaw, OnMoveFinished);
	GearPC(Outer).AddGearEventDelegate(eGED_Melee, OnMoveFinished);
}

/** Called when the tutorial gets removed from the tutorial manager's list */
function OnTutorialRemoved()
{
	Super.OnTutorialRemoved();

	GearPC(Outer).ClearGearEventDelegate(eGED_Chainsaw, OnMoveFinished);
	GearPC(Outer).ClearGearEventDelegate(eGED_Melee, OnMoveFinished);
}

/** Delegate fired when the player melee/chainsaws */
function OnMoveFinished()
{
	// Make sure this isn't fired when the tutorial has already completed
	if ( !bTutorialIsComplete )
	{
		OnTutorialCompleted();
	}
}

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
	TutorialType=GEARTUT_ChainsawMelee
}
