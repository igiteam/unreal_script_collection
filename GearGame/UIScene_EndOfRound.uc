/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class UIScene_EndOfRound extends GearGFxMoviePlayer;

/** TRUE if the scene has been been initialized with the new label content */
var transient bool      bEndOfRoundInitialized;

/** TRUE if the scene is waiting for the host to finish the round so it can close */
var transient bool      bIsPendingClose;

/** Reference to the GearGRI, so we can easily pull game data from it */
var transient GearGRI_MP   GRI;

/** The gamestatus of the game - used so we can determine if we JUST replicated the gamestatus from the GRI */
var transient EGameStatus PreviousGameStatus;

/** Overridden to set the GRI */
function Init(optional LocalPlayer Player)
{
	Super.Init(Player);

	// Store a reference to the game replication info, so we can reference it later when updating the widgets
	GRI = GearGRI_MP(class'WorldInfo'.static.GetWorldInfo().GRI);

	// Flush the player's input so that they stop doing whatever they were doing
	FlushPlayerInput(FALSE);
}

/** Called when a movie is closed to allow cleanup and handling */
event OnClose()
{
	local GearHUD_Base GearHUD;
	local PlayerController PC;

	Super.OnClose();

	PC = GetPC();
	// Remove the reference to us in the GearHUD, so that the movie player is no longer considered to be "open"
	if( PC != None )
	{
		GearHUD = GearHUD_Base(PC.myHUD);

		if( GearHUD != None )
		{
			GearHUD.EndRoundUIScenePlayerInstance = None;
		}
	}

	bIsPendingClose = FALSE;
}

/** Overridden to eat all input */
event bool FilterButtonInput(int ControllerId, name ButtonName, EInputEvent InputEvent)
{
	local GearPawn GP;
 	local GearPC PC;

	// If we're in CTL, allow neck breaks
	if( (ButtonName == 'XboxTypeS_X') && (GetGearMPGameType(GRI) == eGEARMP_CTL) )
	{
		PC = GearPC(GetLPForControllerId(ControllerId).Actor);
		GP = GearPawn(PC.Pawn);

		if( (GP != None) && GP.IsAKidnapper() &&
			(GP.InteractionPawn != None) && GearPRI(GP.InteractionPawn.PlayerReplicationInfo).bIsLeader )
		{
			GP.DoSpecialMove(SM_Kidnapper_Execution,TRUE,GP.InteractionPawn);
		}
	}
	
	// Eat everything, except for start
	return (ButtonName != 'XboxTypeS_Start');
}

/** Initializes the values for the movie */
function InitializeWidgetValues();

/** The "Tick" function for this UI scene */
function UpdateWidgetValues()
{
	if( !bEndOfRoundInitialized )
	{
		InitializeWidgetValues();
		bEndOfRoundInitialized = TRUE; 
	}
	else if( bEndOfRoundInitialized && PreviousGameStatus != GRI.GameStatus )
	{
		PreviousGameStatus = GRI.GameStatus;
	}

	if( bIsPendingClose )
	{
		// If we're waiting for the host to end the round, keep polling to see if we're ready
		AllDoneWaitTimeComplete();
	}
	else
	{
		// Allow the scoreboards to check for updates due to replication
		CheckForUpdates();
	}
}

/** Can be overloaded in child classes to check for updates due to replication, etc, and update as necessary */
function CheckForUpdates();

/** Called after all scoring events are finished.  Closes the scene, and starts the next wave on the host */
function AllDoneWaitTimeComplete()
{
	Close();
}

/** Whether the game we are playing is public */
final function bool IsPublicMatch()
{
	local OnlineSubsystem OnlineSub;
	local OnlineGameSettings OnlineSettings;

	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if (OnlineSub != None &&
		OnlineSub.GameInterface != None)
	{
		OnlineSettings = OnlineSub.GameInterface.GetGameSettings('Game');
		if (OnlineSettings != None &&
			OnlineSettings.bUsesArbitration)
		{
			return true;
		}
	}
	return false;
}

/** Finds the first valid PRI of a team indexed by TeamIdx */
final function GearPRI FindPRIOnTeam( int TeamIdx, GearGRI MyGRI )
{
	local int PRIIdx;

	if (MyGRI != None)
	{
		for ( PRIIdx = 0; PRIIdx < MyGRI.PRIArray.length; PRIIdx++ )
		{
			if ( (MyGRI.PRIArray[PRIIdx] != None) && (MyGRI.PRIArray[PRIIdx].GetTeamNum() == TeamIdx) )
			{
				return GearPRI(MyGRI.PRIArray[PRIIdx]);
			}
		}
	}

	return None;
}

defaultproperties
{
	bAutoPlay=TRUE
	bAllowInput=TRUE
	bAllowFocus=TRUE
	
	Priority=GEAR_SCENE_PRIORITY_MPSCENE

	CaptureKeys.Empty()
 	CaptureKeys(0)=XboxTypeS_A
 	CaptureKeys(1)=XboxTypeS_B
 	CaptureKeys(2)=XboxTypeS_X
 	CaptureKeys(3)=XboxTypeS_Y
 	CaptureKeys(4)=XboxTypeS_LeftShoulder
 	CaptureKeys(5)=XboxTypeS_RightShoulder
 	CaptureKeys(6)=XboxTypeS_LeftTrigger
 	CaptureKeys(7)=XboxTypeS_RightTrigger
 	CaptureKeys(8)=XboxTypeS_DPad_Up
 	CaptureKeys(9)=XboxTypeS_DPad_Down
 	CaptureKeys(10)=XboxTypeS_DPad_Right
 	CaptureKeys(11)=XboxTypeS_DPad_Left
 	CaptureKeys(12)=Gamepad_LeftStick_Up
 	CaptureKeys(13)=Gamepad_LeftStick_Down
 	CaptureKeys(14)=Gamepad_LeftStick_Right
 	CaptureKeys(15)=Gamepad_LeftStick_Left
 	CaptureKeys(16)=Gamepad_RightStick_Left
 	CaptureKeys(17)=Gamepad_RightStick_Right
 	CaptureKeys(18)=Gamepad_RightStick_Up
 	CaptureKeys(19)=Gamepad_RightStick_Down


	bEnableMenuPostProcess=TRUE
	bPostProcessForAllLocalPlayers=TRUE
}
