/**
 * This class is used in the pre-game lobbies.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearPreGamePC extends GearMenuPC;

/** Delayed so that the client has time to have the PRI replicate */
function DelayedSceneOpen()
{
	local GearPreGameLobbyPRI PRI;

	PRI = GearPreGameLobbyPRI(PlayerReplicationInfo);
	if (PRI != None)
	{
		if (!PRI.bLobbySceneOpened)
		{
			PRI.ServerNotifyLobbySceneOpened();
		}
		else
		{
			SetTimer(0.0,false,nameof(DelayedSceneOpen));
		}
	}
}


/** Delayed so that the client has time to have the PRI replicate */
function NotifyLobbySceneOpened()
{
	local GearPreGameLobbyPRI PRI;

	PRI = GearPreGameLobbyPRI(PlayerReplicationInfo);
	if (PRI != None)
	{
		if (!PRI.bLobbySceneOpened)
		{
			PRI.ServerNotifyLobbySceneOpened();
		}
		else
		{
			SetTimer(0.0,false,nameof(NotifyLobbySceneOpened));
		}
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

	if (!bIsConnected &&
		// Ignore this for local matches (matches without a party session)
		OnlineSub.GameInterface.GetGameSettings('Party') != None)
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
				None,
				LocalPlayer(Player),,,,,false);
		}
		ReturnToMainMenu(true);
	}
}

/**
 * Delegate called when a player's status changes but doesn't change profiles
 *
 * @param NewStatus the new login status for the user
 * @param NewId the new id to associate with the user
 */
function OnLoginStatusChange(ELoginStatus NewStatus,UniqueNetId NewId)
{
	Super(GearPC).OnLoginStatusChange(NewStatus,NewId);
	// If we signed out, then we need to go back
	if (NewStatus == LS_NotLoggedIn ||
		// Ignore this for local matches (matches without a party session)
		OnlineSub.GameInterface.GetGameSettings('Party') != None)
	{
		ShowLoginChangeError();
		ReturnToMainMenu(true);
	}
}

/**
 * Login changes mean we must go back to the main menu
 *
 * @param LocalUserNum the user that just logged in
 */
function OnLoginChange(byte LocalUserNum)
{
	local UniqueNetId NetId;

	NetId = PlayerReplicationInfo.UniqueId;
	Super(GearPC).OnLoginChange(LocalUserNum);
	// If we swapped profiles, throw away the saved state
	if (NetId != PlayerReplicationInfo.UniqueId &&
		!WorldInfo.IsMenuLevel())
	{
		ProfileSettings = None;
		PersistentData = None;
		StatManager = None;
	}
	ReturnToMainMenu(true);
}

/**
 * Tell this player to return to the main menu.  This version takes care of cleaning up the player's online sessions.
 *
 * @param bReturnToStartScreen if TRUE then return to the start screen instead of restoring menus via saved history
 */
simulated function ReturnToMainMenu(bool bReturnToStartScreen)
{
	local OnlineGameSettings GameSettings;
	local bool bShouldTravel;
	local GearLocalPlayer LP;
	local UniqueNetId RequestingPlayerId;

	bShouldTravel = true;
	bIsReturningFromMatch = true;
	bIgnoreNetworkMessages = true;
	
	LP = GearLocalPlayer(Player);
	if (LP != None)
	{
		LP.bIsFirstFrontEndLoad = bReturnToStartScreen;
	}

	if (OnlineSub != None && OnlineSub.GameInterface != None)
	{
		GameSettings = OnlineSub.GameInterface.GetGameSettings('Game');
		if (GameSettings != None && WorldInfo.NetMode == NM_Client)
		{
			// This is a connection loss in the pre-game lobby, so just return to party instead
			if (LP != None &&
				OnlineSub.PlayerInterface.GetLoginStatus(LP.ControllerId) == LS_LoggedIn &&
				GameSettings.bUsesArbitration)
			{
				// It's ok to clean up immediately
				OnlineSub.GameInterface.DestroyOnlineGame('Game');
				bShouldTravel = false;
				if (PlayerReplicationInfo != None)
				{
					RequestingPlayerId = PlayerReplicationInfo.UniqueId;
				}
				// Now return to party
				ClientReturnToParty(RequestingPlayerId);
			}
			else
			{
				// It's ok to clean up immediately
				OnlineSub.GameInterface.DestroyOnlineGame('Game');
				if (OnlineSub.GameInterface.GetGameSettings('Party') != None)
				{
					OnlineSub.GameInterface.DestroyOnlineGame('Party');
				}
			}
		}
		else
		{
			// It's ok to clean up immediately
			OnlineSub.GameInterface.DestroyOnlineGame('Game');
			if (OnlineSub.GameInterface.GetGameSettings('Party') != None)
			{
				OnlineSub.GameInterface.DestroyOnlineGame('Party');
			}
		}
	}

	if (bShouldTravel)
	{
		ClientTravel("?closed", TRAVEL_Absolute);
	}
}

defaultproperties
{

}
