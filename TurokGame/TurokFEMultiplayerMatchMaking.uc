class TurokFEMultiplayerMatchMaking extends TurokFEMultiplayerMatchDetails
    native;

var private bool mSuppressPopups;
var bool mIsExitFlow;
var private transient @NULL mSearch;
var private string mBusyText;
var float mFadeMusicDelay;
var float mFadeMusicDelayTimer;

event SCCleanUpOnExit()
{
    Class'Engine.TurokOnlineDashboard'.static.Instance().EndBusyTask();
    Class'TurokEngine.TurokFEBusyScreen'.static.Instance().SetAlignment(1);
    Class'Engine.Engine'.static.GetTurokNet().GetLobby().EnableLobbyEvents(true);
    super.SCCleanUpOnExit();
    //return;    
}

// Export UTurokFEMultiplayerMatchMaking::execStartMatchmaking(FFrame&, void* const)
protected native function StartMatchmaking();

// Export UTurokFEMultiplayerMatchMaking::execCancelMatchmaking(FFrame&, void* const)
protected native function CancelMatchmaking();

// Export UTurokFEMultiplayerMatchMaking::execRefreshGameSettings(FFrame&, void* const)
protected native function RefreshGameSettings();

// Export UTurokFEMultiplayerMatchMaking::execRefreshHelpBar(FFrame&, void* const)
protected native function RefreshHelpBar();

// Export UTurokFEMultiplayerMatchMaking::execLeaveParty(FFrame&, void* const)
protected native function LeaveParty();

// Export UTurokFEMultiplayerMatchMaking::execHasValidGameSession(FFrame&, void* const)
protected native function bool HasValidGameSession();

// Export UTurokFEMultiplayerMatchMaking::execGetMatchTypeHash(FFrame&, void* const)
protected native function int GetMatchTypeHash();

// Export UTurokFEMultiplayerMatchMaking::execOnConfirmLeavePartyClick(FFrame&, void* const)
native function OnConfirmLeavePartyClick();

// Export UTurokFEMultiplayerMatchMaking::execOnNoOpClick(FFrame&, void* const)
native function OnNoOpClick();

// Export UTurokFEMultiplayerMatchMaking::execOnLobbyEvent(FFrame&, void* const)
native function OnLobbyEvent(@NULL Event);

// Export UTurokFEMultiplayerMatchMaking::execOnGameStarted(FFrame&, void* const)
native function OnGameStarted(bool bSuccess);

// Export UTurokFEMultiplayerMatchMaking::execOnPartyMigrationStarted(FFrame&, void* const)
native function OnPartyMigrationStarted();

// Export UTurokFEMultiplayerMatchMaking::execOnGameMigrationStarted(FFrame&, void* const)
native function OnGameMigrationStarted();

// Export UTurokFEMultiplayerMatchMaking::execOnFindGamesCompleted(FFrame&, void* const)
native function OnFindGamesCompleted(bool success);

// Export UTurokFEMultiplayerMatchMaking::execOnGameJoined(FFrame&, void* const)
native function OnGameJoined(bool success);

// Export UTurokFEMultiplayerMatchMaking::execOnQuickMatchCompleted(FFrame&, void* const)
native function OnQuickMatchCompleted(byte Reason);

defaultproperties
{
    mBusyText=" "
    mFadeMusicDelay=0.5000000
}