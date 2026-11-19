class TurokFEMultiplayerLobby extends TurokFEMultiplayerGameSettingsScreen
    native;

const T_KickPlayer = 1957042376;
const M_KickPlayerQuestion = -1184364541;
const T_LeaveParty = 0;
const M_LeavePartyQuestion = -1815063647;
const M_PlayersNotReady = 1846005137;
const M_PlayersMissingMap = 1362785379;
const M_NoRankedCoop = -753963911;
const M_NoRankedParties = -1899260864;
const M_ExceedPartySizeLimit = -488662061;
const M_DownloadPackOutOfSync = -1084317356;

enum ScreenFocusElement
{
    SCREENFOCUSELEMENT_Menu,        // 0
    SCREENFOCUSELEMENT_PartyList,   // 1
    SCREENFOCUSELEMENT_MAX          // 2
};

enum BackgroundState
{
    BKGSTATE_Disabled,              // 0
    BKGSTATE_Initial,               // 1
    BKGSTATE_TipCycle,              // 2
    BKGSTATE_MAX                    // 3
};

struct native BusyBackground
{
    var byte mState;
    var const float kInitialDelay;
    var const float kTipDelay;
    var float mInitialCounter;
    var float mTipCounter;
    var int mCurrTipID;
    var @NULL mTurokLogo;
    var @NULL mTipLabel;

    structdefaultproperties
    {
        mState=0
        kInitialDelay=0.0000000
        kTipDelay=0.0000000
        mInitialCounter=0.0000000
        mTipCounter=0.0000000
        mCurrTipID=0
        mTurokLogo=none
        mTipLabel=none
    }
};

var @NULL mTitleLabel;
var @NULL mReadyLabel;
var @NULL mNotReadyLabel;
var @NULL mInstructions;
var @NULL mGamertag;
var @NULL mBusyBackground;
var byte mScreenFocusElement;
var byte mPendingLobbyMode;
var bool mInviteInProgress;
var bool mInitializingLobby;
var @NULL mPendingKickPlayerNetId;

event SCInitialized()
{
    super(TurokFEMultiplayerScreen).SCInitialized();
    //return;    
}

event HasFocus()
{
    super(TurokUISceneController).HasFocus();
    // End:0x2F
    if(Class'Engine.Engine'.static.GetTurokNet().GetLobby() != none)
    {
        RefreshHelpBar();
    }
    //return;    
}

event SCCleanUpOnExit()
{
    Class'TurokEngine.TurokUIHelpBar'.static.Instance().enableInput(true);
    super.SCCleanUpOnExit();
    mGamertag = none;
    mBusyBackground.mTurokLogo = none;
    mBusyBackground.mTipLabel = none;
    //return;    
}

// Export UTurokFEMultiplayerLobby::execSetPendingLobbyMode(FFrame&, void* const)
native final function SetPendingLobbyMode(byte LobbyMode);

// Export UTurokFEMultiplayerLobby::execInitPrivateGame(FFrame&, void* const)
native function InitPrivateGame();

// Export UTurokFEMultiplayerLobby::execInitPublicGame(FFrame&, void* const)
native function InitPublicGame(bool Ranked);

// Export UTurokFEMultiplayerLobby::execInitInvite(FFrame&, void* const)
native function InitInvite();

// Export UTurokFEMultiplayerLobby::execInitLanGame(FFrame&, void* const)
native function InitLanGame(bool Hosting);

// Export UTurokFEMultiplayerLobby::execEnterLobby(FFrame&, void* const)
protected native function EnterLobby();

// Export UTurokFEMultiplayerLobby::execInitLobbySettings(FFrame&, void* const)
protected native function InitLobbySettings();

// Export UTurokFEMultiplayerLobby::execStartPrivateGame(FFrame&, void* const)
protected native function StartPrivateGame();

// Export UTurokFEMultiplayerLobby::execStartPublicGame(FFrame&, void* const)
protected native function StartPublicGame();

// Export UTurokFEMultiplayerLobby::execRefreshGameSettings(FFrame&, void* const)
protected native function RefreshGameSettings();

// Export UTurokFEMultiplayerLobby::execRefreshPrivateGameSettings(FFrame&, void* const)
protected native function RefreshPrivateGameSettings();

// Export UTurokFEMultiplayerLobby::execRefreshLanGameSettings(FFrame&, void* const)
protected native function RefreshLanGameSettings();

// Export UTurokFEMultiplayerLobby::execRefreshPublicGameSettings(FFrame&, void* const)
protected native function RefreshPublicGameSettings();

// Export UTurokFEMultiplayerLobby::execRefreshPlayerInfo(FFrame&, void* const)
protected native function RefreshPlayerInfo();

// Export UTurokFEMultiplayerLobby::execRefreshHelpBar(FFrame&, void* const)
protected native function RefreshHelpBar();

// Export UTurokFEMultiplayerLobby::execRefreshReadyLabels(FFrame&, void* const)
protected native function RefreshReadyLabels(optional bool ForceHidden);

// Export UTurokFEMultiplayerLobby::execGoBackScreen(FFrame&, void* const)
protected native function GoBackScreen();

// Export UTurokFEMultiplayerLobby::execCheckStartPrivateGameConditions(FFrame&, void* const)
protected native function bool CheckStartPrivateGameConditions();

// Export UTurokFEMultiplayerLobby::execCheckStartPublicGameConditions(FFrame&, void* const)
protected native function bool CheckStartPublicGameConditions();

// Export UTurokFEMultiplayerLobby::execGetLocalPlayerTeam(FFrame&, void* const)
protected native function int GetLocalPlayerTeam();

// Export UTurokFEMultiplayerLobby::execSetLocalPlayerTeam(FFrame&, void* const)
protected native function SetLocalPlayerTeam(int TeamIndex);

// Export UTurokFEMultiplayerLobby::execSwitchLocalPlayerTeams(FFrame&, void* const)
protected native function SwitchLocalPlayerTeams();

// Export UTurokFEMultiplayerLobby::execIsLocalPlayerReady(FFrame&, void* const)
protected native function bool IsLocalPlayerReady();

// Export UTurokFEMultiplayerLobby::execSetIsLocalPlayerReady(FFrame&, void* const)
protected native function SetIsLocalPlayerReady(bool isReady);

// Export UTurokFEMultiplayerLobby::execToggleLocalPlayerReady(FFrame&, void* const)
protected native function ToggleLocalPlayerReady();

// Export UTurokFEMultiplayerLobby::execShowInviteGUI(FFrame&, void* const)
protected native function ShowInviteGUI();

// Export UTurokFEMultiplayerLobby::execKickPlayer(FFrame&, void* const)
protected native function KickPlayer(const @NULL Player);

// Export UTurokFEMultiplayerLobby::execLeaveParty(FFrame&, void* const)
protected native function LeaveParty(bool ExitLobby);

// Export UTurokFEMultiplayerLobby::execWriteProfile(FFrame&, void* const)
protected native function WriteProfile();

// Export UTurokFEMultiplayerLobby::execEndInvite(FFrame&, void* const)
protected native function EndInvite();

// Export UTurokFEMultiplayerLobby::execSetFocus(FFrame&, void* const)
protected native function SetFocus(byte Element);

// Export UTurokFEMultiplayerLobby::execShowScreenElements(FFrame&, void* const)
protected native function ShowScreenElements(bool Show);

// Export UTurokFEMultiplayerLobby::execHasValidGameSession(FFrame&, void* const)
protected native function bool HasValidGameSession();

// Export UTurokFEMultiplayerLobby::execOnLoadImagesComplete(FFrame&, void* const)
protected native function OnLoadImagesComplete();

// Export UTurokFEMultiplayerLobby::execOnCommonOptionsClick(FFrame&, void* const)
native function OnCommonOptionsClick();

// Export UTurokFEMultiplayerLobby::execOnGameOptionsClick(FFrame&, void* const)
native function OnGameOptionsClick();

// Export UTurokFEMultiplayerLobby::execOnSelectTeamClick(FFrame&, void* const)
native function OnSelectTeamClick();

// Export UTurokFEMultiplayerLobby::execOnCancelClick(FFrame&, void* const)
native function OnCancelClick();

// Export UTurokFEMultiplayerLobby::execOnSettingItemHighlighted(FFrame&, void* const)
native function OnSettingItemHighlighted(int Index);

// Export UTurokFEMultiplayerLobby::execOnWriteProfileCompleted(FFrame&, void* const)
native function OnWriteProfileCompleted(byte ControllerId, bool success);

// Export UTurokFEMultiplayerLobby::execOnConfirmKickPlayerClick(FFrame&, void* const)
native function OnConfirmKickPlayerClick();

// Export UTurokFEMultiplayerLobby::execOnConfirmLeavePartyClick(FFrame&, void* const)
native function OnConfirmLeavePartyClick();

// Export UTurokFEMultiplayerLobby::execOnConfirmLeaveLobbyClick(FFrame&, void* const)
native function OnConfirmLeaveLobbyClick();

// Export UTurokFEMultiplayerLobby::execOnNoOpClick(FFrame&, void* const)
native function OnNoOpClick();

// Export UTurokFEMultiplayerLobby::execOnLobbyEvent(FFrame&, void* const)
native function OnLobbyEvent(@NULL Event);

// Export UTurokFEMultiplayerLobby::execOnPartyCreated(FFrame&, void* const)
native function OnPartyCreated(bool bSuccess);

// Export UTurokFEMultiplayerLobby::execOnPartyDestroyed(FFrame&, void* const)
native function OnPartyDestroyed(byte Reason);

// Export UTurokFEMultiplayerLobby::execOnPartyDestroyFailed(FFrame&, void* const)
native function OnPartyDestroyFailed(byte Reason);

// Export UTurokFEMultiplayerLobby::execOnGameCreated(FFrame&, void* const)
native function OnGameCreated(bool bSuccess);

// Export UTurokFEMultiplayerLobby::execOnGameDestroyed(FFrame&, void* const)
native function OnGameDestroyed(byte Reason);

// Export UTurokFEMultiplayerLobby::execOnGameDestroyFailed(FFrame&, void* const)
native function OnGameDestroyFailed(byte Reason);

// Export UTurokFEMultiplayerLobby::execOnGameStarted(FFrame&, void* const)
native function OnGameStarted(bool bSuccess);

// Export UTurokFEMultiplayerLobby::execOnJoinGamesCompleted(FFrame&, void* const)
native function OnJoinGamesCompleted(bool success);

// Export UTurokFEMultiplayerLobby::execOnQuickMatchStarted(FFrame&, void* const)
native function OnQuickMatchStarted();

// Export UTurokFEMultiplayerLobby::execOnPartyMigrationCompleted(FFrame&, void* const)
native function OnPartyMigrationCompleted(bool bSuccess, @NULL NewHost);

// Export UTurokFEMultiplayerLobby::execOnGameMigrationCompleted(FFrame&, void* const)
native function OnGameMigrationCompleted(bool bSuccess, @NULL NewHost);

defaultproperties
{
    mBusyBackground=(mState=0,kInitialDelay=5.0000000,kTipDelay=5.0000000,mInitialCounter=0.0000000,mTipCounter=0.0000000,mCurrTipID=0,mTurokLogo=none,mTipLabel=none)
    SceneName="TurokFEMultiplayer.Lobby"
}