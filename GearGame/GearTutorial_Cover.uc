/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearTutorial_Cover extends GearTutorial_Base
	config(Game);


/************************************************************************/
/* Script functions                                                     */
/************************************************************************/

/** Called when the tutorial gets added to the tutorial manager's list */
function OnTutorialAdded(GearTutorialManager TutMgr, SeqAct_ManageTutorials Action, bool IsKismetDriven)
{
	Super.OnTutorialAdded(TutMgr, Action, IsKismetDriven);

	// If already in cover, complete right away
	if (GearPC(Outer).IsInCoverState())
	{
		OnTutorialCompleted();
	}

	GearPC(Outer).AddGearEventDelegate(eGED_CoverAcquired, OnCoverAcquired);
}

/** Called when the tutorial gets removed from the tutorial manager's list */
function OnTutorialRemoved()
{
	Super.OnTutorialRemoved();

	GearPC(Outer).ClearGearEventDelegate(eGED_CoverAcquired, OnCoverAcquired);
}

/** Delegate fired when the player takes cover */
function OnCoverAcquired()
{
	// Make sure this isn't fired when the tutorial has already completed
	if (!bTutorialIsComplete)
	{
		OnTutorialCompleted();
	}
}


defaultproperties
{
	TutorialType=GEARTUT_Cover
}
