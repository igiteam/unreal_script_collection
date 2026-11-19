/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearTutorial_ActiveReload extends GearTutorial_PCAction_Base
	config(Game);


/************************************************************************/
/* Member variables                                                     */
/************************************************************************/

/** Number of tries we will give them to active reload successfully */
var config int MaxTriesForSuccess;

/** Number of times the player has attempted the active reload */
var transient int NumActiveReloadAttempts;

/** Ready to force a reload */
var transient bool bForceReload;

/** Whether an active reload attempt was made this go around */
var transient bool bActiveReloadAttempted;

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

	NumActiveReloadAttempts++;
	GearPC(Outer).SetTimer(2.0f, false, nameof(ForceFailure), self);
}

/** Called when the tutorial gets removed from the tutorial manager's list */
function OnTutorialRemoved()
{
	Super.OnTutorialRemoved();

	GearPC(Outer).ClearGearEventDelegate( eGED_ActiveReloadSuccess, OnActiveReloadSuccess );
	GearPC(Outer).ClearGearEventDelegate( eGED_ActiveReloadFailed, OnActiveReloadFailed );
	GearPC(Outer).ClearGearEventDelegate( eGED_ReloadFinished, OnReloadFinished );
	GearPC(Outer).ClearTimer(nameof(ForceFailure), self);
}

/** Called when the tutorial has become the active tutorial by the tutorial manager */
function bool TutorialActivated()
{
	TutorialMgr.Outer.DisableInput( true, true, true );
	bGameplayIsFrozen = true;
	Super.TutorialActivated();
	return true;
}

/** Forces a failure for active reload */
function ForceFailure()
{
	local GearWeapon CurrWeapon;

	CurrWeapon = GearPawn(TutorialMgr.Outer.Pawn).MyGearWeapon;
	CurrWeapon.DetermineActiveReloadSuccessOrFailure();
}

/** Delegate fired when the player successfully active reloads */
simulated function OnActiveReloadSuccess()
{
	// Make sure this isn't fired when the tutorial has already completed
	if ( !bTutorialIsComplete )
	{
		bActiveReloadAttempted = true;
		OnTutorialCompleted();
		GearPC(Outer).ClearTimer(nameof(ForceFailure), self);
	}
}

/** Delegate fired when the player fails active reload */
simulated function OnActiveReloadFailed()
{
	// Make sure this isn't fired when the tutorial has already completed
	if ( !bTutorialIsComplete )
	{
		bActiveReloadAttempted = true;
		ResetActiveReload();
	}
}

/** Delegate fired when the player finishes a reload */
simulated function OnReloadFinished()
{
	// Make sure this isn't fired when the tutorial has already completed
	if ( !bTutorialIsComplete )
	{
		if (!bActiveReloadAttempted)
		{
			ResetActiveReload();
		}
		bActiveReloadAttempted = false;
	}
}

/** Forces another reload for another attempt at the active reload */
simulated function ResetActiveReload()
{
	if ( !bTutorialIsComplete && NumActiveReloadAttempts < MaxTriesForSuccess )
	{
		bForceReload = true;
		GearPC(Outer).ClearTimer(nameof(ForceFailure), self);
		GearPC(Outer).HandleTutorials(TutorialAction, eMTINPUT_AttemptFailure);
	}
	else
	{
		GearPC(Outer).HandleTutorials(TutorialAction, eMTINPUT_RemoveTutorial);
	}
}

/** Called every tick so that the tutorial has a chance to update itself */
event Update()
{
	local GearWeapon CurrWeapon;
	local GearPC PC;

	PC = GearPC(Outer);
	PC.MyGearHud.LastWeaponInfoTime = GearPC(Outer).WorldInfo.TimeSeconds;

	CurrWeapon = GearPawn(TutorialMgr.Outer.Pawn).MyGearWeapon;
	if (!bTutorialIsComplete && bForceReload && CurrWeapon != None && CurrWeapon.CurrentFireMode == CurrWeapon.DEFAULT_FIREMODE)
	{
		CurrWeapon.SpareAmmoCount += CurrWeapon.WeaponMagSize * 0.75f;
		CurrWeapon.AmmoUsedCount = CurrWeapon.WeaponMagSize * 0.75f;
		bForceReload = false;
		NumActiveReloadAttempts++;

		// Force the reload for the first 2 attempts
		if (NumActiveReloadAttempts < 3)
		{
			CurrWeapon.ForceReload();
			GearPC(Outer).SetTimer(2.0f, false, nameof(ForceFailure), self);
		}
		else
		{
			if (SceneInstance != none)
			{
				SceneInstance.ButtonLabel.SetString("htmlText",TutorialMgr.Localize("TUTORIALS", "TUT_ACTIVERELOAD_BUTTON1", "GearGame"));
			}
		}
	}

	Super.Update();
}

function InitializeUISceneLabels( optional bool bHideButtonText )
{
	Super.InitializeUISceneLabels( bHideButtonText );
	if (NumActiveReloadAttempts > 2)
	{
		if (SceneInstance != none)
		{
			SceneInstance.ButtonLabel.SetString("htmlText",TutorialMgr.Localize("TUTORIALS", "TUT_ACTIVERELOAD_BUTTON1", "GearGame"));
			SceneInstance.ShowButtonLabel(true);
		}
	}
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
		if (CurrWeapon.CurrentFireMode == CurrWeapon.DEFAULT_FIREMODE)
		{
			GearPC(Outer).SetTimer(2.0f, false, nameof(ForceFailure), self);
			GearPlayerInput(InputHandler).HandleButtonInput_RightBumper(bPressed);
			if (SceneInstance != none)
			{
				SceneInstance.ButtonLabel.SetString("text",TutorialMgr.Localize("TUTORIALS", "TUT_ACTIVERELOAD_BUTTON2", "GearGame"));
			}
		}
		else
		{
			CurrWeapon.HandleButtonPress('R1');
		}
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
	if ( bTutorialIsActive && bTutorialHasUIScene && !bSceneIsOpen )
	{
		return (NumActiveReloadAttempts > 1);
	}
	return false;
}

/** Determine if we should close the UI scene or not */
function bool ShouldCloseUIScene()
{
	// If the tutorial is active and the scene is currently open
	if ( bTutorialIsActive &&
		 bSceneIsOpen )
	{
		// If we want to display a tip and haven't shown it the number of times we are configured to do so
		if ( TipsAreActive() && NumActiveReloadAttempts > 2 )
		{
			return true;
		}
	}
	return false;
}


defaultproperties
{
	TutorialType=GEARTUT_ActiveReload
	GameButtonType=GB_RightBumper
}
