class TurokFEMultiplayerMatchDetails extends TurokFEMultiplayerGameSettingsScreen
    abstract
    native;

var protected int mTickCounter;

event SCCleanUpOnExit()
{
    Class'TurokEngine.TurokUIHelpBar'.static.Instance().enableInput(true);
    super.SCCleanUpOnExit();
    //return;    
}

// Export UTurokFEMultiplayerMatchDetails::execLaunchGame(FFrame&, void* const)
protected native function LaunchGame(optional int TickDelay);

// Export UTurokFEMultiplayerMatchDetails::execRefreshGameSettings(FFrame&, void* const)
protected native function RefreshGameSettings();

// Export UTurokFEMultiplayerMatchDetails::execRefreshPlayerInfo(FFrame&, void* const)
protected native function RefreshPlayerInfo();

// Export UTurokFEMultiplayerMatchDetails::execOnLobbyEvent(FFrame&, void* const)
native function OnLobbyEvent(@NULL Event);

// Export UTurokFEMultiplayerMatchDetails::execOnPlayersChanged(FFrame&, void* const)
native function OnPlayersChanged();

defaultproperties
{
    mTickCounter=-1
    mSettingsInitialIndex=-1
    SceneName="TurokFEMultiplayer.MatchMaking"
}