/**
 * Campaign "Game Over" screen
 *
 * Copyright 1998-2010 Epic Games, Inc. All Rights Reserved
 */
class UIScene_GameOver extends UIScene_Pause;

// --- Localized strings -------------------------------- 
var localized string            ObjectiveFailedString;

function Init(optional LocalPlayer Player)
{
	Super.Init(Player);

	// Begin the bloody post process override
	GetGearPC().StartPostProcessOverride(eGPP_Gameover);
}

event OnClose()
{
	local GearHUD_Base GearHUD;

	// Remove the reference to the game over screen from the HUD
	GearHUD = GearHUD_Base(GetPC().myHUD);
	if( GearHUD != None )
	{
		GearHUD.GameOverPlayer = None;
	}

	Super.OnClose();
}

/** Sets the label describing why the player failed */
function SetFailureReason(string Reason)
{
	Title_Label.SetText(ObjectiveFailedString);
	Subtitle_Label.SetText(Reason);
}

/**
 * Callback from actionscript when the scene has finished fading out.  This performs the latent action selected by the user
 */
function Callback_DoneFadingOut()
{
	// Handle the latent actions to be performed on close
	switch (SelectedOption)
	{
		case EPO_LoadCheckpoint:
			OnConfirm_LoadCheckpoint(None, 'GenericAccept', LocalPlayerOwnerIndex);
			break;
		default:
			break;
	}

	Super.Callback_DoneFadingOut();
}

/** Override this so that the pause menu closes automatically */
function bool ShouldClosePauseMenu( EPauseOptions Option )
{
	// Only the options menu should cause the pause menu to remain open
	return ((Option != EPO_Options) && 
			(Option != EPO_ReturnToMainMenu) &&
			(Option != EPO_RestartGame) &&
			(Option != EPO_RestartChapter));
}

/** Override this to NOT prompt the user to confirm, since they're already dead, and aren't going in */
function LoadCheckpoint()
{
}

defaultproperties
{
	PauseMenuOptions(0)=EPO_LoadCheckpoint
	PauseMenuOptions(1)=EPO_RestartChapter
	PauseMenuOptions(2)=EPO_Options
	PauseMenuOptions(3)=EPO_ReturnToMainMenu
}
