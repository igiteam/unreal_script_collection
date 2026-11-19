/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class UIScene_WaveOptions extends UIScene_GameOver;

/** String that will be displayed in the subheader label, and should be appended with the wave score */
var localized string    WaveScoreString;

//==============================================================
// MoviePlayer functions
//==============================================================

/** 
 *  Initialized widget callback
 *  @return Returns true if the callback is handled at this level
 */
event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
	switch (WidgetName)
	{
		case 'lbl_MenuTitle':
			Title_Label = Widget;
			Title_Label.SetString("text", Title_String);
			break;
		case 'lbl_SubmenuTitle':
			Subtitle_Label = Widget;
			Subtitle_Label.SetString("text", WaveScoreString @ GetWaveScore());
			break;
		default:
			return Super.WidgetInitialized(WidgetName, WidgetPath, Widget);
	}

	return TRUE;
}

/** Override this, since this is now set to the wave score */
function SetFailureReason(string Reason)
{
}

/** Quit to the main menu */
function bool OnConfirm_ReturnToMenu(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
	// Make sure that Horde writes the stats in this case
	EndMatch(GetWorldInfo().Game);

	return Super.OnConfirm_ReturnToMenu(Sender, SelectedInputAlias, PlayerIndex);
}

//==============================================================
// Game interface functions
//==============================================================
/**
 * Accessor to get the total score for the team
 * 
 * @return The total score for this attempt
 */
function int GetWaveScore()
{
	local GearTeamInfo GTI;
	local GearGRI GRI;

	GRI = GetGRI();
	GTI = GearTeamInfo(GRI.Teams[IsSiegeGametype(GRI) ? 1 : 0]);
	return GTI.TotalScore;
}

/**
 * Has wave clean up properly before traveling
 *
 * @param Game the game object to wrap up
 */
function EndMatch(GameInfo Game)
{
	if (Game != None)
	{
		Game.WriteOnlinePlayerScores();
		Game.EndOnlineGame();
	}
}

defaultproperties
{
	PauseMenuOptions(0)=EPO_RestartWave
	PauseMenuOptions(1)=EPO_RestartGame
	PauseMenuOptions(2)=EPO_Options
	PauseMenuOptions(3)=EPO_ReturnToMainMenu
}
