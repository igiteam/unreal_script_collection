/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * This class is responsible for handling player storage device selection customization
 */
class GearDataProvider_PlayerStorage extends UIDataProvider_OnlinePlayerStorage;

/** The local player this provider is for */
var GearLocalPlayer LocPlayer;

/**
 * Binds the player to this provider. Starts the async friends list gathering
 *
 * @param InPlayer the player that we are retrieving friends for
 */
event OnRegister(LocalPlayer InPlayer)
{
	// Cache this for later
	LocPlayer = GearLocalPlayer(InPlayer);

	Super.OnRegister(InPlayer);
}

/**
 * Reads this user's storage data from the online subsystem.
 */
function RefreshStorageData()
{
	local OnlineSubsystem OnlineSub;
	local bool bFoundCachedData;

	if (!bIsExternalUIOpen)
	{
		// Figure out if we have an online subsystem registered
		OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
		if (OnlineSub != None &&
			OnlineSub.PlayerInterface != None &&
			OnlineSub.PlayerInterfaceEx != None)
		{
			// If the player has decided to skip saves, then read without prompting for a device
			if (LocPlayer != None &&
				!LocPlayer.bWantsToSkipSaves)
			{
				// Determine if the cached data is present
				bFoundCachedData = GetData(OnlineSub.PlayerInterface,PlayerControllerId,Profile);
				if (!bFoundCachedData ||
					// If they have cached data and that device is valid, skip the prompt
					(bFoundCachedData &&
					// If they already have a valid device, don't prompt
					!OnlineSub.PlayerInterfaceEx.IsDeviceValid(Profile.DeviceId,DeviceStorageSizeNeeded)))
				{
					ShowDeviceSelection();
				}
			}
			else
			{
				ReadData(OnlineSub.PlayerInterface,PlayerControllerId,-1,Profile);
			}
		}
	}
	else
	{
		// Do the refresh when the UI closes
		bNeedsDeferredRefresh = true;
	}
}

/**
 * Called once the user has selected their device
 *
 * @param bWasSuccessful true if the async action completed without error, false if there was an error
 */
function OnDeviceSelectionComplete(bool bWasSuccessful)
{
	local OnlineSubsystem OnlineSub;
	local string Ignored;
	local GearUIManager UIManager;
	local array<name> ButtonAliases;

	// We know we have one, because this event was called
	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	OnlineSub.PlayerInterfaceEx.ClearDeviceSelectionDoneDelegate(PlayerControllerId,OnDeviceSelectionComplete);
	// Get the latest device id if this worked
	if (bWasSuccessful)
	{
		// Get the device that was selected
		Profile.DeviceId = OnlineSub.PlayerInterfaceEx.GetDeviceSelectionResults(PlayerControllerId,Ignored);
		`Log("OnDeviceSelectionComplete("$bWasSuccessful$") for ControllerId ("$PlayerControllerId$") with DeviceId ("$Profile.DeviceId$")",,'DevOnline');
		// Start the async task
		if (ReadData(OnlineSub.PlayerInterface,PlayerControllerId,Profile.DeviceId,Profile) == false)
		{
			// Notify any owner data stores that we have changed data
			NotifyPropertyChanged();
		}
	}
	else
	{
		UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
		// We need to always bail in this case
		if (UIManager != None &&
			OnlineSub.PlayerInterface.GetLoginStatus(PlayerControllerId) > LS_NotLoggedIn)
		{
			ButtonAliases.AddItem('AcceptSelectDevice');
			ButtonAliases.AddItem('CancelContinueAnyway');
			UIManager.ShowUIMessage('ConnectionError',
				Localize("MessageBoxErrorStrings","NoDeviceLoad_Title","GearGameUI"),
				Localize("MessageBoxErrorStrings","NoDeviceLoad_Message","GearGameUI"),
				ButtonAliases,
				OnSelectDeviceChosen,
				LocPlayer);
		}
	}
}

/**
 * Either shows the device selection again or marks the player as not saving
 *
 * @param Sender the message box that generated this call
 * @param SelectedInputAlias the alias of the button that the user selected
 * @param PlayerIndex the index of the player that selected the option
 *
 * @return TRUE to indicate that the message box should close itself
 */
function bool OnSelectDeviceChosen(UIScene_MessageBox Sender,Name SelectedInputAlias,int PlayerIndex)
{
	if (SelectedInputAlias == 'AcceptSelectDevice')
	{
		ShowDeviceSelection();
	}
	else if (SelectedInputAlias == 'CancelContinueAnyway')
	{
		if (LocPlayer != None)
		{
			LocPlayer.bWantsToSkipSaves = true;
		}
	}
	return true;
}

/**
 * Executes a refetching of the storage data when the login for this player changes
 *
 * @param LocalUserNum the player that logged in/out
 */
function OnLoginChange(byte LocalUserNum)
{
	local OnlineSubsystem OnlineSub;
	local ELoginStatus LoginStatus;

	if (LocalUserNum == PlayerControllerId)
	{
		if (LocPlayer != None)
		{
			LocPlayer.bWantsToSkipSaves = false;
		}
		// Figure out if we have an online subsystem registered
		OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
		if (OnlineSub != None)
		{
			// Grab the player interface to verify the subsystem supports it
			if (OnlineSub.PlayerInterface != None)
			{
				LoginStatus = OnlineSub.PlayerInterface.GetLoginStatus(PlayerControllerId);
				if (LoginStatus == LS_NotLoggedIn)
				{
					// Reset the profile only when they've signed out
					Profile.SetToDefaults();
					if (LocPlayer != None)
					{
						// Can't save for non-signed in players
						LocPlayer.bWantsToSkipSaves = true;
					}
				}
			}
		}
		RefreshStorageData();
	}
}

/**
 * Shows the device selection UI if possible
 */
function ShowDeviceSelection()
{
	local OnlineSubsystem OnlineSub;

	// Figure out if we have an online subsystem registered
	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if (OnlineSub != None &&
		OnlineSub.PlayerInterface != None &&
		OnlineSub.PlayerInterfaceEx != None)
	{
		if (OnlineSub.PlayerInterface.GetLoginStatus(PlayerControllerId) > LS_NotLoggedIn)
		{
			OnlineSub.PlayerInterfaceEx.AddDeviceSelectionDoneDelegate(PlayerControllerId,OnDeviceSelectionComplete);
			// Get the device that their data may be stored on locally
			OnlineSub.PlayerInterfaceEx.ShowDeviceSelectionUI(PlayerControllerId,DeviceStorageSizeNeeded);
		}
		else
		{
			// Device selection failed
			OnDeviceSelectionComplete(false);
		}
	}
}
