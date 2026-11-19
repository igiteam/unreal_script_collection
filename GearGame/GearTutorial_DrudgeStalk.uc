/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearTutorial_DrudgeStalk extends GearTutorial_Base
	config(Game);


/** Called when the tutorial gets added to the tutorial manager's list */
function OnTutorialAdded( GearTutorialManager TutMgr, SeqAct_ManageTutorials Action, bool IsKismetDriven  )
{
	Super.OnTutorialAdded(TutMgr, Action, IsKismetDriven);
	GearPC(Outer).AddGearEventDelegate(eGED_KilledStalkPod, OnKilledStalkPod);
}

/** Called when the tutorial gets removed from the tutorial manager's list */
function OnTutorialRemoved()
{
	Super.OnTutorialRemoved();
	GearPC(Outer).ClearGearEventDelegate(eGED_KilledStalkPod, OnKilledStalkPod);
}

/** Delegate fired when the player cover slips */
function OnKilledStalkPod()
{
	// Make sure this isn't fired when the tutorial has already completed
	if (!bTutorialIsComplete)
	{
		OnTutorialCompleted();
	}
}


defaultproperties
{
	TutorialType=GEARTUT_DrudgeStalk
}
