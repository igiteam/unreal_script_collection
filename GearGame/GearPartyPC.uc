/**
 * This player controller class is used for the party lobby.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearPartyPC extends GearMenuPC;

/** Used to assign the gamertag as the player name for multiplayer matches */
event InitInputSystem()
{
	local LocalPlayer LocPlayer;

	Super.InitInputSystem();

	LocPlayer = LocalPlayer(Player);
	if (LocPlayer != None && OnlineSub != None && OnlineSub.PlayerInterface != None)
	{
		// See if this is a guest login and mark the PRI as being a guest
		if (OnlineSub.PlayerInterface.IsGuestLogin(LocPlayer.ControllerId))
		{
			ServerMaskAsGuest();
		}
	}
}

/** Used for a client to tell the server that the player is a guest */
reliable server function ServerMaskAsGuest()
{
	local GearPartyPRI PRI;

	PRI = GearPartyPRI(PlayerReplicationInfo);
	if (PRI != None)
	{
		PRI.bIsGuest = true;
	}
}

/** Allows a client to cancel matchmaking so they can leave */
reliable server function ServerCancelMatchmaking()
{
	local GearPartyGame_Base PartyGame;
	PartyGame = GearPartyGame_Base(WorldInfo.Game);
	if (PartyGame != None)
	{
		PartyGame.CancelPartyMatchmaking();
	}
}

/**
 * Displays a message when the physical network is lost during a networked game
 *
 * @param bIsConnected the new connection state
 */
function OnLinkStatusChange(bool bIsConnected)
{
	local GearUIManager UIManager;
	local array<name> ButtonAliases;

	// Ignore this change if standalone
	if (!bIsConnected && 
		WorldInfo.NetMode != NM_Standalone)
	{
		UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
		// Show the user why we kicked them back
		if (UIManager != None)
		{
			ButtonAliases.AddItem('GenericAccept');
			UIManager.ShowUIMessage('ConnectionError',
				Localize("MessageBoxErrorStrings","LostLink_Title","GearGameUI"),
				Localize("MessageBoxErrorStrings","LostLink_Message","GearGameUI"),
				ButtonAliases,
				OnRestartFrontEnd,
				LocalPlayer(Player),,,,,false);
		}
	}
}

/** Restarts the front end when the user dismisses the dialog */
function bool OnRestartFrontEnd(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
	// We are potentially in a bad place, so restart the front end
	RestartFrontEnd();
	return true;
}

/** Restarts the main menu */
function RestartFrontEnd()
{
	local GearMenuHUD GMH;

	// If we are the party host and are matchmaking, return to main menu (restart the game)
	GMH = GearMenuHUD(myHUD);
	if (GMH != None &&
		GMH.FrontEndMovie != None &&
		GMH.FrontEndMovie.IsMatchmaking(true) &&
		WorldInfo.NetMode != NM_Client)
	{
		ReturnToMainMenu(true);
		return;
	}

	// Else allow GearMenuPC handle it
	Super.RestartFrontEnd();
}
