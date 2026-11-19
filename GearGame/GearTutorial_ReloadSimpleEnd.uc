/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/

class GearTutorial_ReloadSimpleEnd extends GearTutorial_PCAction_Base
	config(Game);


/************************************************************************/
/* Member variables                                                     */
/************************************************************************/


/************************************************************************/
/* Script functions                                                     */
/************************************************************************/

/** Called when the tutorial gets added to the tutorial manager's list */
function OnTutorialAdded( GearTutorialManager TutMgr, SeqAct_ManageTutorials Action, bool IsKismetDriven  )
{
	Super.OnTutorialAdded( TutMgr, Action, IsKismetDriven );

	GearPC(Outer).AddGearEventDelegate( eGED_ActiveReloadSuccess, OnActiveReloadSuccess );
	GearPC(Outer).AddGearEventDelegate( eGED_ActiveReloadFailed, OnActiveReloadFailed );
	GearPC(Outer).AddGearEventDelegate( eGED_ReloadFinished, OnReloadFinished );
}

/** Called when the tutorial gets removed from the tutorial manager's list */
function OnTutorialRemoved()
{
	Super.OnTutorialRemoved();

	GearPC(Outer).ClearGearEventDelegate( eGED_ActiveReloadSuccess, OnActiveReloadSuccess );
	GearPC(Outer).ClearGearEventDelegate( eGED_ActiveReloadFailed, OnActiveReloadFailed );
	GearPC(Outer).ClearGearEventDelegate( eGED_ReloadFinished, OnReloadFinished );
}

/** Called when the tutorial has become the active tutorial by the tutorial manager */
function bool TutorialActivated()
{
	TutorialMgr.Outer.DisableInput( true, true, true );
	bGameplayIsFrozen = true;
	Super.TutorialActivated();
	return true;
}

/** Delegate fired when the player successfully active reloads */
simulated function OnActiveReloadSuccess()
{
	// Make sure this isn't fired when the tutorial has already completed
	if ( !bTutorialIsComplete )
	{
		OnTutorialCompleted();
	}
}

/** Delegate fired when the player fails active reload */
simulated function OnActiveReloadFailed()
{
	// Make sure this isn't fired when the tutorial has already completed
	if ( !bTutorialIsComplete )
	{
		GearPC(Outer).HandleTutorials(TutorialAction, eMTINPUT_RemoveTutorial);
	}
}

/** Delegate fired when the player finishes a reload */
simulated function OnReloadFinished()
{
	// Make sure this isn't fired when the tutorial has already completed
	if ( !bTutorialIsComplete )
	{
		GearPC(Outer).HandleTutorials(TutorialAction, eMTINPUT_RemoveTutorial);
	}
}

/** Called every tick so that the tutorial has a chance to update itself */
event Update()
{
	local GearPC PC;
	PC = GearPC(Outer);
	PC.MyGearHud.LastWeaponInfoTime = GearPC(Outer).WorldInfo.TimeSeconds;
	Super.Update();
}

/** Callback for closing the UIScene */
function HandleButtonInput_CloseScene(bool bPressed, optional bool bDblClickMove)
{
	if ( bPressed )
	{
		PerformPCInputAction( bPressed );
	}
}

/**
* Opportunity for the tutorial to override the filtering system for the input object handling this tutorial's input
*		@Param Filtered - whether this button should be filtered or not (non zero means true)
*		@Return - whether we've handled the filtering or not
*/
function bool FilterButtonInput( Name ButtonName, bool bPressed, int ButtonIdx, out int Filtered )
{
	// Have the tutorial's input handler handle this input
	if ( (ButtonName == InputHandler.InputButtonDataList[RemapGameButton(GB_RightBumper)].ButtonNameMapping) )
	{
		Filtered = 0;
	}
	else
	{
		Filtered = 1;
	}

	return true;
}

/** Action to perform on the player when this tutorial is completed - implemented by all subclasses */
function PerformPCInputAction( bool bPressed )
{
	local GearWeapon CurrWeapon;

	CurrWeapon = GearPawn(TutorialMgr.Outer.Pawn).MyGearWeapon;
	if (CurrWeapon != None)
	{
		CurrWeapon.HandleButtonPress('R1');
	}
}

/**
* Resets the timer for openeing the scene
* @Param bInstantOpen - whether to open the scene right away or to wait for the time lapse
*/
function ResetUISceneOpenTimer( bool bInstantOpen )
{
	// We will handle the opening closing by hand
	NextTimeForSceneOpen = TutorialMgr.Outer.WorldInfo.TimeSeconds + 99999;
}

/** Determine if we should open the UI scene or not */
function bool ShouldOpenUIScene()
{
	return false;
}


defaultproperties
{
	TutorialType=GEARTUT_ReloadSimpleEnd
	GameButtonType=GB_RightBumper
}
