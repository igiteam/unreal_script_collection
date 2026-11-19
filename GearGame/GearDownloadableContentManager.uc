/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 *
 * This is the Gears specific downloadable content manager class. This handles
 * installing and removing content plus updating any dependent objects
 */
class GearDownloadableContentManager extends DownloadableContentManager
	native(Online);

/**
 * Installs a set of DLC bundles
 *
 * @param DLCBundles the set of bundles that are to be installed
 */
native function InstallDLCs(const out array<OnlineContent> DLCBundles);

/**
 * Delegate called when a player logs in/out, so we can clear/refresh DLC
 *
 * @param LocalUserNum the player that logged in/out
 */
function OnLoginChange(byte LocalUserNum)
{
	local OnlineSubsystem OnlineSub;
	local OnlinePlayerInterface PlayerInt;
	local ELoginStatus Status;
	local DownloadableContentEnumerator DLCEnumerator;
	local int DLCIndex;
	local bool bDlcOwnerSignedOut;

	// Skip this event if we don't have any DLC installed already
	if (InstalledDLC.Length > 0)
	{
		if (class'WorldInfo'.static.IsMenuLevel())
		{
			// It's safe to reload all DLC in the main menu
			RefreshDLC();
		}
		else
		{
			DLCEnumerator = class'GameEngine'.static.GetDLCEnumerator();
			OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
			if (DLCEnumerator != None &&
				OnlineSub != None)
			{
				PlayerInt = OnlineSub.PlayerInterface;
				if (PlayerInt != None)
				{
					Status = PlayerInt.GetLoginStatus(LocalUserNum);
					if (Status == LS_NotLoggedIn)
					{
						// See if the person that logged out owned any of the DLC
						for (DLCIndex = 0; DLCIndex < DLCEnumerator.DLCBundles.Length; DLCIndex++)
						{
							if (DLCEnumerator.DLCBundles[DLCIndex].UserIndex == LocalUserNum)
							{
								bDlcOwnerSignedOut = true;
								break;
							}
						}
						if (bDlcOwnerSignedOut)
						{
							// We're going to crash, so reboot
							RebootGame();
						}
					}
				}
			}
		}
	}
}

/**
 * Verifies that the device for all of the installed DLC is still valid and reboots the game if not
 */
function OnStorageDeviceChange()
{
	local OnlineSubsystem OnlineSub;
	local OnlinePlayerInterfaceEx PlayerInt;
	local DownloadableContentEnumerator DLCEnumerator;
	local int DLCIndex;
	local bool bDlcHasInvalidDevice;

	// Skip this event if we don't have any DLC installed already
	if (InstalledDLC.Length > 0)
	{
		if (class'WorldInfo'.static.IsMenuLevel())
		{
			// It's safe to reload all DLC in the main menu
			RefreshDLC();
		}
		else
		{
			DLCEnumerator = class'GameEngine'.static.GetDLCEnumerator();
			OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
			if (DLCEnumerator != None &&
				OnlineSub != None)
			{
				PlayerInt = OnlineSub.PlayerInterfaceEx;
				if (PlayerInt != None)
				{
					// See device that changed invalidated any of our DLC
					for (DLCIndex = 0; DLCIndex < DLCEnumerator.DLCBundles.Length; DLCIndex++)
					{
						if (!PlayerInt.IsDeviceValid(DLCEnumerator.DLCBundles[DLCIndex].DeviceId))
						{
							bDlcHasInvalidDevice = true;
							break;
						}
					}
					if (bDlcHasInvalidDevice)
					{
						// We're going to crash, so reboot
						RebootGame();
					}
				}
			}
		}
	}
}

/**
 * Does nothing if outside of the menu level, otherwise refreshes DLC
 */
function OnContentChange()
{
	// Skip this event if we don't have any DLC installed already
	if (InstalledDLC.Length > 0)
	{
		if (class'WorldInfo'.static.IsMenuLevel())
		{
			// It's safe to reload all DLC in the main menu
			RefreshDLC();
		}
	}
}

/**
 * Reboots the game when a non-recoverable DLC change happens
 */
native private function RebootGame();
