class OLGFxMoviePlayer extends GFxMoviePlayer;

/**
 * Helper function to get the owning GearPC for this movie
 *
 * @return The GearPC corresponding to the LocalPlayerIndex that owns this movie
 */
function OLPlayerController GetOLPC()
{
	return OLPlayerController(GetPC());
}

static function OLGame GetGame()
{
	local WorldInfo World;

	World = class'Engine'.static.GetCurrentWorldInfo();
	return OLGame(World.Game);
}

function MuteSoundThemes(bool bMute)
{
	local SoundThemeBinding SoundTheme;

	foreach SoundThemes(SoundTheme)
	{
		if (SoundTheme.Theme != None)
		{
			SoundTheme.Theme.bMuted = bMute;
		}
	}
}

/**
 * Wrapper for getting a reference to the online subsystem's player interface.
 */
static final function OnlinePlayerInterface GetOnlinePlayerInterface()
{
	local OnlineSubsystem OnlineSub;
	local OnlinePlayerInterface Result;

	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if ( OnlineSub != None )
	{
		Result = OnlineSub.PlayerInterface;
	}
	else
	{
		`Log("GetOnlinePlayerInterfaceEx: Unable to find OnlineSubSystem!");
	}

	return Result;
}

/**
 * Saves the profile and updates the player controller with the new settings
 */
function bool SaveProfile(optional delegate<OnlinePlayerInterface.OnWriteProfileSettingsComplete> WriteProfileSettingsCompleteDelegate=OnProfileWriteComplete, optional OLPlayerController PlayerToSave)
{
	local bool bResult;
	local OnlinePlayerInterface PlayerInt;

	// If we have no override, use the PC associated with the scene
	if( PlayerToSave == None )
	{
		PlayerToSave = GetOLPC();
	}
	if (PlayerToSave != None)
	{
		// always hook into the profile write.
		PlayerInt = GetOnlinePlayerInterface();
		if (PlayerInt != None)
		{
			PlayerInt.AddWriteProfileSettingsCompleteDelegate(LocalPlayer(PlayerToSave.Player).ControllerId,WriteProfileSettingsCompleteDelegate);
		}
		PlayerToSave.ClientSaveAllPlayerData(true);
		bResult = TRUE;
	}

	return bResult;
}

/** Called when the profile is done writing */
function OnProfileWriteComplete(byte LocalUserNum, bool bWasSuccessful)
{
	local OnlinePlayerInterface PlayerInt;

	PlayerInt = GetOnlinePlayerInterface();
	if ( PlayerInt != None )
	{
		PlayerInt.ClearWriteProfileSettingsCompleteDelegate(LocalUserNum,OnProfileWriteComplete);
	}
}