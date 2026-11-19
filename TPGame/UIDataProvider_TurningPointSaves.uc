/**
 * This class is responsible for retrieving the list of available save games and displaying them to the user.
 */
class UIDataProvider_TurningPointSaves extends UIDataProvider_OnlinePlayerDataBase
	native
	implements(UIListElementCellProvider)
	dependson(OnlineSubsystem)
	transient;

/** Holds information about a player in a friends list */
struct native TurningPointSave
{
	/** Identifying name used by the XContent system to save/load games */
	var const string SaveFileName;

	/** Friendly displayable name to the player. */
	var const string FriendlyName;

	structcpptext
	{
		/**
		 * Zero-out constructor.
		 */
		FTurningPointSave()
		{
			appMemzero(this,sizeof(FTurningPointSave));
		}

		FTurningPointSave(const FString &InSaveFileName, const FString &InFriendlyName )
		{
			appMemzero(this,sizeof(FTurningPointSave));

			SaveFileName = InSaveFileName;
			FriendlyName = InFriendlyName;
		}
	}
};

/** A array of available XContent data that can be loaded by the user. */
var array<TurningPointSave> SaveGameList;

/** Current xenon device ID to load data from, UpdateCurrentDeviceID should be called prior to using this variable. */
var int DeviceID;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

/**
 * Retrieves all of the save games for a player.
 *
 * @param InDeviceID	Xenon Device ID to get save games from.
 * @param InPlayerID	Controller ID of the player to retrieve savegames for, must be 0-3.
 *
 * @return TRUE if the operation succeeded, FALSE otherwise.
 */
native final function bool GetSaveGames( int InDeviceID, int InPlayerID );

/**
 * Retrieves the current device id for a player.
 *
 * @param InPlayerID	Controller ID of the player to retrieve savegames for, must be 0-3.
 *
 * @return The Xenon device id to perform IO operations on.
 */
native final function int GetCurrentDeviceID( int InPlayerID );

/**
 * Retrieves the current device id for a player from the online subsystem.
 *
 * @param InPlayerID	Controller ID of the player to retrieve DeviceID for, must be 0-3.
 */
event UpdateCurrentDeviceID(int InPlayerID)
{
	local string DeviceName;
	local OnlineSubsystem OnlineSub;
	local OnlinePlayerInterfaceEx PlayerInterfaceEx;

	// Figure out if we have an online subsystem registered
	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if (OnlineSub != None)
	{
		// Grab the player interface to verify the subsystem supports it
		PlayerInterfaceEx = OnlineSub.PlayerInterfaceEx;
		if (PlayerInterfaceEx != None)
		{
			DeviceID = PlayerInterfaceEx.GetDeviceSelectionResults(Player.ControllerId, DeviceName);
		}
		else
		{
			;
		}
	}
	else
	{
		;
	}
}

/**
 * Binds the player to this provider.
 *
 * @param InPlayer the player that we are retrieving game saves for.
 */
event OnRegister(LocalPlayer InPlayer)
{
	local OnlineSubsystem OnlineSub;
	local OnlinePlayerInterface PlayerInterface;

	Super.OnRegister(InPlayer);

	// Figure out if we have an online subsystem registered
	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if (OnlineSub != None)
	{
		// Grab the player interface to verify the subsystem supports it
		PlayerInterface = OnlineSub.PlayerInterface;
		if (PlayerInterface != None)
		{
			// Register that we are interested in any sign in change for this player
			PlayerInterface.AddLoginChangeDelegate(OnLoginChange,Player.ControllerId);
		}
		else
		{
			;
		}
	}
	else
	{
		;
	}
}

/**
 * Clears our delegate for getting login change notifications
 */
event OnUnregister()
{
	local OnlineSubsystem OnlineSub;
	local OnlinePlayerInterface PlayerInterface;

	// Figure out if we have an online subsystem registered
	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if (OnlineSub != None)
	{
		// Grab the player interface to verify the subsystem supports it
		PlayerInterface = OnlineSub.PlayerInterface;
		if (PlayerInterface != None)
		{
			// Clear our delegate
			PlayerInterface.ClearLoginChangeDelegate(OnLoginChange,Player.ControllerId);
		}
	}

	Super.OnUnregister();
}

/**
 * Retrieves all of the save games for a player and notifies subscribers that a property has changed.
 *
 * @param InDeviceID	Xenon Device ID to get save games from.
 * @param InPlayerID	Controller ID of the player to retrieve savegames for, must be 0-3.
 */
event RefreshSaveGamesList(int InDeviceID, int InPlayerID)
{
	if(GetSaveGames(InDeviceID, InPlayerID) == false)
	{

	}

	NotifyPropertyChanged();
}

/**
 * Refetches save games if the currently logged in player changes.
 */
function OnLoginChange()
{
	UpdateCurrentDeviceID(Player.ControllerId);
	SaveGameList.Length = 0;

	// Start the blocking task
	if (GetSaveGames(DeviceID, Player.ControllerId) == false)
	{
		;
	}
}
