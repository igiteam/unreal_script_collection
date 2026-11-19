class TurokOnlineSubsystemPC extends OnlineSubsystem
    native
    config(Engine)
    implements(OnlinePlayerInterface,OnlineGameInterface);

struct native RVLoginDelegates
{
    var delegate<@NULL> Delegate;

    structdefaultproperties
    {
        Delegate=None
    }
};

var protected const config string RendezvousURL;
var protected const config int RendezvousPort;
var protected const config int RendezvousWellKnownPort;
var protected const config string RendezvousAccessKey;
var protected const config string RendezvousGuestPassword;
var protected const config int RendezvousLoginTimeout;
var protected const config int RendezvousPingTimeout;
var protected const config int RendezvousMaxInvites;
var protected const config int LanBeaconPort;
var protected const config float LanBeaconTimeout;
var protected const config array mLeaderboardNames;
var protected const config int MinGameplayAge;
var protected const byte mGameState;
var protected const byte mLoginPlayerNum;
var protected const byte mLoginPlayerStatus;
var protected const byte mFriendReadState;
var protected const @NULL mGameSettings;
var protected const @NULL mGameSearch;
var protected const @NULL mGameSearchResponder;
var protected native const transient @NULL mBeaconSocket;
var protected native const transient @NULL mSessionInfo;
var protected native const array mAsyncTasks;
var protected const array mRemotePlayers;
var protected const @NULL mLocalPlayerId;
var protected const float mFindGamesTimer;
var protected const float mFindGamesTimeout;
var protected const bool mInLobby;
var protected const bool mLoginInProgress;
var protected const bool mLogoutInProgress;
var protected native const transient @NULL mLoadingSync;
var protected native const transient @NULL mRendezvous;
var protected native const transient @NULL mCredentials;
var protected native const transient @NULL mNotifications;
var protected native const transient @NULL mMatchmaking;
var protected native const transient @NULL mCompetition;
var protected native const transient @NULL mTurokProtocol;
var protected native const transient @NULL mNatTraversal;
var protected native const transient @NULL mNatAdapter;
var protected native const transient @NULL mNatURL;
var init protected native const transient array mPendingSerializeTasks;
var protected const @NULL mLocalCachedProfile;
var protected const @NULL mLoginPlayerId;
var protected const string mLoginPlayerName;
var protected @NULL mLoginChangeDelegates[4];
var protected native const transient @NULL mGameSession;
var protected native const transient @NULL mGameGathering;
var init protected native const transient array mPendingInvites;
var init protected native const transient array mInvites;
var protected const array mPendingCancelledInvites;
var protected const int mSelectedInvite;
var protected const @NULL mOfflineInviteSearch;
var protected native const transient @NULL mLanBeaconSocket;
var protected const float mLanBeaconTimer;
var protected const @NULL mLanBeaconResponder;
var protected const array mNPFriends;
var protected const array mRVFriends;
var protected const @NULL mCurrentStatsRead;
var transient int GamePort;
var native transient @NULL GameSocket;
var native transient @NULL MatchAddr;
var native transient @NULL LocalAddr;
var native transient @NULL LocalPublicURL;
var native transient @NULL LocalPrivateURL;
//var delegate<@NULL> __OnLoginChange__Delegate;
//var delegate<@NULL> __OnLoginCancelled__Delegate;
//var delegate<@NULL> __OnReadProfileSettingsComplete__Delegate;
//var delegate<@NULL> __OnWriteProfileSettingsComplete__Delegate;
//var delegate<@NULL> __OnInviteReceived__Delegate;
//var delegate<@NULL> __OnFriendsChange__Delegate;
//var delegate<@NULL> __OnReadFriendsComplete__Delegate;
//var delegate<@NULL> __OnMutingChange__Delegate;
//var delegate<@NULL> __OnKeyboardInputComplete__Delegate;
//var delegate<@NULL> __OnReadAchievementsComplete__Delegate;
//var delegate<@NULL> __OnCreateOnlineGameComplete__Delegate;
//var delegate<@NULL> __OnPatchAvailable__Delegate;
//var delegate<@NULL> __OnPatchDownload__Delegate;
//var delegate<@NULL> __OnDestroyOnlineGameComplete__Delegate;
//var delegate<@NULL> __OnFindOnlineGamesComplete__Delegate;
//var delegate<@NULL> __OnJoinOnlineGameComplete__Delegate;
//var delegate<@NULL> __OnRegisterPlayerComplete__Delegate;
//var delegate<@NULL> __OnUnregisterPlayerComplete__Delegate;
//var delegate<@NULL> __OnStartOnlineGameComplete__Delegate;
//var delegate<@NULL> __OnEndOnlineGameComplete__Delegate;
//var delegate<@NULL> __OnArbitrationRegistrationComplete__Delegate;
//var delegate<@NULL> __OnGameInviteAccepted__Delegate;
//var delegate<@NULL> __OnMigrateHostComplete__Delegate;

// Export UTurokOnlineSubsystemPC::execVerifyRendezvousLogin(FFrame&, void* const)
native function bool VerifyRendezvousLogin(string Account, string Password, string Email);

// Export UTurokOnlineSubsystemPC::execVerifyRendezvousCreate(FFrame&, void* const)
native function bool VerifyRendezvousCreate(string Account, string Password, string Email);

// Export UTurokOnlineSubsystemPC::execInit(FFrame&, void* const)
native event bool Init();

// Export UTurokOnlineSubsystemPC::execHasLinkConnection(FFrame&, void* const)
native function bool HasLinkConnection();

// Export UTurokOnlineSubsystemPC::execGetNATType(FFrame&, void* const)
native function byte GetNATType();

delegate OnLoginChange()
{
    //return;    
}

function SetLoginChangeDelegate(delegate<@NULL> LoginDelegate, optional byte LocalUserNum = byte(255))
{
    // DebugMode: 0
    assert((int(LocalUserNum) >= 0) && int(LocalUserNum) < 4);
    mLoginChangeDelegates[int(LocalUserNum)].Delegate = LoginDelegate;
    //return;    
}

function ClearLoginChangeDelegate(delegate<@NULL> LoginDelegate, optional byte LocalUserNum = byte(255))
{
    // DebugMode: 0
    assert((int(LocalUserNum) >= 0) && int(LocalUserNum) < 4);
    mLoginChangeDelegates[int(LocalUserNum)].Delegate = None;
    //return;    
}

delegate OnLoginCancelled(byte resultCode)
{
    //return;    
}

function SetLoginCancelledDelegate(delegate<@NULL> CancelledDelegate)
{
    __OnLoginCancelled__Delegate = CancelledDelegate;
    //return;    
}

function ClearLoginCancelledDelegate(delegate<@NULL> CancelledDelegate)
{
    __OnLoginCancelled__Delegate = None;
    //return;    
}

// Export UTurokOnlineSubsystemPC::execShowLoginUI(FFrame&, void* const)
native function bool ShowLoginUI(byte LoginUserNum, optional bool bShowOnlineOnly);

// Export UTurokOnlineSubsystemPC::execLogoutOnline(FFrame&, void* const)
native function bool LogoutOnline(byte LocalUserNum);

// Export UTurokOnlineSubsystemPC::execGetLoginStatus(FFrame&, void* const)
native function byte GetLoginStatus(byte LocalUserNum);

// Export UTurokOnlineSubsystemPC::execGetUniquePlayerId(FFrame&, void* const)
native function bool GetUniquePlayerId(byte LocalUserNum, out @NULL PlayerID);

// Export UTurokOnlineSubsystemPC::execGetPlayerPlatformData(FFrame&, void* const)
native function bool GetPlayerPlatformData(byte LocalUserNum, out @NULL PlayerPlatformData);

// Export UTurokOnlineSubsystemPC::execGetPlayerNickname(FFrame&, void* const)
native function string GetPlayerNickname(byte LocalUserNum);

// Export UTurokOnlineSubsystemPC::execReadProfileSettings(FFrame&, void* const)
native function bool ReadProfileSettings(byte LocalUserNum, @NULL ProfileSettings);

delegate OnReadProfileSettingsComplete(bool bWasSuccessful)
{
    //return;    
}

function SetReadProfileSettingsCompleteDelegate(byte LocalUserNum, delegate<@NULL> ReadProfileSettingsCompleteDelegate)
{
    __OnReadProfileSettingsComplete__Delegate = ReadProfileSettingsCompleteDelegate;
    //return;    
}

function ClearReadProfileSettingsCompleteDelegate(byte LocalUserNum, delegate<@NULL> ReadProfileSettingsCompleteDelegate)
{
    __OnReadProfileSettingsComplete__Delegate = None;
    //return;    
}

// Export UTurokOnlineSubsystemPC::execWriteProfileSettings(FFrame&, void* const)
native function bool WriteProfileSettings(byte LocalUserNum, @NULL ProfileSettings);

delegate OnWriteProfileSettingsComplete(bool bWasSuccessful)
{
    //return;    
}

function SetWriteProfileSettingsCompleteDelegate(byte LocalUserNum, delegate<@NULL> WriteProfileSettingsCompleteDelegate)
{
    __OnWriteProfileSettingsComplete__Delegate = WriteProfileSettingsCompleteDelegate;
    //return;    
}

delegate OnInviteReceived(byte LocalUserNum)
{
    //return;    
}

function SetInviteReceivedDelegate(delegate<@NULL> InviteReceivedDelegate)
{
    __OnInviteReceived__Delegate = InviteReceivedDelegate;
    //return;    
}

// Export UTurokOnlineSubsystemPC::execGetInvitesReceived(FFrame&, void* const)
native function bool GetInvitesReceived(byte LocalUserNum, out array Invites);

// Export UTurokOnlineSubsystemPC::execSelectReceivedInvite(FFrame&, void* const)
native function bool SelectReceivedInvite(byte LocalUserNum, @NULL Invite);

// Export UTurokOnlineSubsystemPC::execRejectReceivedInvite(FFrame&, void* const)
native function bool RejectReceivedInvite(byte LocalUserNum, @NULL Invite);

// Export UTurokOnlineSubsystemPC::execCanPlayOnline(FFrame&, void* const)
native function byte CanPlayOnline(byte LocalUserNum);

// Export UTurokOnlineSubsystemPC::execCanCommunicate(FFrame&, void* const)
native function byte CanCommunicate(byte LocalUserNum);

// Export UTurokOnlineSubsystemPC::execCanDownloadUserContent(FFrame&, void* const)
native function byte CanDownloadUserContent(byte LocalUserNum);

// Export UTurokOnlineSubsystemPC::execCanPurchaseContent(FFrame&, void* const)
native function byte CanPurchaseContent(byte LocalUserNum);

// Export UTurokOnlineSubsystemPC::execCanViewPlayerProfiles(FFrame&, void* const)
native function byte CanViewPlayerProfiles(byte LocalUserNum);

// Export UTurokOnlineSubsystemPC::execCanShowPresenceInformation(FFrame&, void* const)
native function byte CanShowPresenceInformation(byte LocalUserNum);

// Export UTurokOnlineSubsystemPC::execIsFriend(FFrame&, void* const)
native function bool IsFriend(byte LocalUserNum, @NULL PlayerID);

// Export UTurokOnlineSubsystemPC::execAreAnyFriends(FFrame&, void* const)
native function bool AreAnyFriends(byte LocalUserNum, out array Query);

// Export UTurokOnlineSubsystemPC::execShowFriendsUI(FFrame&, void* const)
native function bool ShowFriendsUI(byte LocalUserNum);

// Export UTurokOnlineSubsystemPC::execShowFriendsInviteUI(FFrame&, void* const)
native function bool ShowFriendsInviteUI(byte LocalUserNum, @NULL PlayerID);

// Export UTurokOnlineSubsystemPC::execShowPlayersUI(FFrame&, void* const)
native function bool ShowPlayersUI(byte LocalUserNum);

// Export UTurokOnlineSubsystemPC::execGetFriendsList(FFrame&, void* const)
native function byte GetFriendsList(byte LocalUserNum, out array Friends, optional int Count, optional int StartingAt);

// Export UTurokOnlineSubsystemPC::execReadFriendsList(FFrame&, void* const)
native function bool ReadFriendsList(byte LocalUserNum, optional int Count, optional int StartingAt);

delegate OnFriendsChange()
{
    //return;    
}

function SetFriendsChangeDelegate(delegate<@NULL> FriendsDelegate)
{
    __OnFriendsChange__Delegate = FriendsDelegate;
    //return;    
}

delegate OnReadFriendsComplete(bool bWasSuccessful)
{
    //return;    
}

function SetReadFriendsCompleteDelegate(byte LocalUserNum, delegate<@NULL> ReadFriendsCompleteDelegate)
{
    __OnReadFriendsComplete__Delegate = ReadFriendsCompleteDelegate;
    //return;    
}

// Export UTurokOnlineSubsystemPC::execIsMuted(FFrame&, void* const)
native function bool IsMuted(byte LocalUserNum, @NULL PlayerID);

delegate OnMutingChange()
{
    //return;    
}

function SetMutingChangeDelegate(delegate<@NULL> MutingDelegate)
{
    __OnMutingChange__Delegate = MutingDelegate;
    //return;    
}

function bool ShowKeyboardUI(byte LocalUserNum, string TitleText, string DescriptionText, optional bool bShouldValidate = true, optional string DefaultText, optional int MaxResultLength = 256)
{
    return false;
    //return ReturnValue;    
}

delegate OnKeyboardInputComplete(bool bWasSuccessful)
{
    //return;    
}

function SetKeyboardInputDoneDelegate(delegate<@NULL> InputDelegate)
{
    __OnKeyboardInputComplete__Delegate = InputDelegate;
    //return;    
}

function string GetKeyboardInputResults()
{
    return "";
    //return ReturnValue;    
}

// Export UTurokOnlineSubsystemPC::execUnlockAchievement(FFrame&, void* const)
native function bool UnlockAchievement(byte LocalUserNum, int AchievementId);

// Export UTurokOnlineSubsystemPC::execReadAchievements(FFrame&, void* const)
native function bool ReadAchievements(byte LocalUserNum);

function SetReadAchievementsDelegate(byte LocalUserNum, delegate<@NULL> ReadAchievementsCompleteDelegate)
{
    //return;    
}

delegate OnReadAchievementsComplete(bool bWasSuccessful)
{
    //return;    
}

// Export UTurokOnlineSubsystemPC::execGetAchievements(FFrame&, void* const)
native function byte GetAchievements(byte LocalUserNum, out array Achievements, optional int Count, optional int StartingAt);

// Export UTurokOnlineSubsystemPC::execShowGamerCardUI(FFrame&, void* const)
native function bool ShowGamerCardUI(byte LocalUserNum, @NULL PlayerID);

// Export UTurokOnlineSubsystemPC::execShowContentMarketplaceUI(FFrame&, void* const)
native function bool ShowContentMarketplaceUI(byte LocalUserNum);

// Export UTurokOnlineSubsystemPC::execAddPlayerToMetHistory(FFrame&, void* const)
native function AddPlayerToMetHistory(out @NULL PlayerPlatformData);

// Export UTurokOnlineSubsystemPC::execShowFeedbackUI(FFrame&, void* const)
native function bool ShowFeedbackUI(byte LocalUserNum, @NULL PlayerID);

// Export UTurokOnlineSubsystemPC::execCreateOnlineGame(FFrame&, void* const)
native function bool CreateOnlineGame(byte HostingPlayerNum, @NULL NewGameSettings);

delegate OnCreateOnlineGameComplete(bool bWasSuccessful)
{
    //return;    
}

delegate OnPatchAvailable(bool bIsAvailable)
{
    //return;    
}

function SetOnPatchAvailableDelegate(delegate<@NULL> OnPatchAvailableDelegate)
{
    __OnPatchAvailable__Delegate = OnPatchAvailableDelegate;
    //return;    
}

delegate OnPatchDownload(bool bWasSuccessful)
{
    //return;    
}

function SetOnPatchDownloadDelegate(delegate<@NULL> OnPatchDownloadDelegate)
{
    __OnPatchDownload__Delegate = OnPatchDownloadDelegate;
    //return;    
}

function SetCreateOnlineGameCompleteDelegate(delegate<@NULL> CreateOnlineGameCompleteDelegate)
{
    __OnCreateOnlineGameComplete__Delegate = CreateOnlineGameCompleteDelegate;
    //return;    
}

// Export UTurokOnlineSubsystemPC::execGetGameSettings(FFrame&, void* const)
native function @NULL GetGameSettings();

// Export UTurokOnlineSubsystemPC::execDestroyOnlineGame(FFrame&, void* const)
native function bool DestroyOnlineGame(bool bAbnormalExit);

delegate OnDestroyOnlineGameComplete(bool bWasSuccessful)
{
    //return;    
}

function SetDestroyOnlineGameCompleteDelegate(delegate<@NULL> DestroyOnlineGameCompleteDelegate)
{
    __OnDestroyOnlineGameComplete__Delegate = DestroyOnlineGameCompleteDelegate;
    //return;    
}

// Export UTurokOnlineSubsystemPC::execModifyOnlineGamePublicSlots(FFrame&, void* const)
native function ModifyOnlineGamePublicSlots(byte HostingPlayerNum, byte NumPublicSlots);

// Export UTurokOnlineSubsystemPC::execFindOnlineGames(FFrame&, void* const)
native function bool FindOnlineGames(byte SearchingPlayerNum, byte NumOpenSlots, @NULL SearchSettings);

delegate OnFindOnlineGamesComplete(bool bWasSuccessful)
{
    //return;    
}

function SetFindOnlineGamesCompleteDelegate(delegate<@NULL> FindOnlineGamesCompleteDelegate)
{
    __OnFindOnlineGamesComplete__Delegate = FindOnlineGamesCompleteDelegate;
    //return;    
}

function ClearFindOnlineGamesCompleteDelegate(delegate<@NULL> FindOnlineGamesCompleteDelegate)
{
    __OnFindOnlineGamesComplete__Delegate = None;
    //return;    
}

// Export UTurokOnlineSubsystemPC::execGetGameSearch(FFrame&, void* const)
native function @NULL GetGameSearch();

// Export UTurokOnlineSubsystemPC::execFreeSearchResults(FFrame&, void* const)
native function FreeSearchResults();

// Export UTurokOnlineSubsystemPC::execJoinOnlineGame(FFrame&, void* const)
native function bool JoinOnlineGame(byte PlayerNum, const out @NULL DesiredGame);

delegate OnJoinOnlineGameComplete(bool bWasSuccessful)
{
    //return;    
}

function SetJoinOnlineGameCompleteDelegate(delegate<@NULL> JoinOnlineGameCompleteDelegate)
{
    __OnJoinOnlineGameComplete__Delegate = JoinOnlineGameCompleteDelegate;
    //return;    
}

// Export UTurokOnlineSubsystemPC::execGetResolvedConnectString(FFrame&, void* const)
native function bool GetResolvedConnectString(out string ConnectInfo);

// Export UTurokOnlineSubsystemPC::execRegisterPlayer(FFrame&, void* const)
native function bool RegisterPlayer(@NULL PlayerID, bool bWasInvited);

delegate OnRegisterPlayerComplete(bool bWasSuccessful, @NULL PlayerID)
{
    //return;    
}

function SetRegisterPlayerCompleteDelegate(delegate<@NULL> RegisterPlayerCompleteDelegate)
{
    __OnRegisterPlayerComplete__Delegate = RegisterPlayerCompleteDelegate;
    //return;    
}

// Export UTurokOnlineSubsystemPC::execUnregisterPlayer(FFrame&, void* const)
native function bool UnregisterPlayer(@NULL PlayerID);

delegate OnUnregisterPlayerComplete(bool bWasSuccessful, @NULL PlayerID)
{
    //return;    
}

function SetUnregisterPlayerCompleteDelegate(delegate<@NULL> UnregisterPlayerCompleteDelegate)
{
    __OnUnregisterPlayerComplete__Delegate = UnregisterPlayerCompleteDelegate;
    //return;    
}

// Export UTurokOnlineSubsystemPC::execStartOnlineGame(FFrame&, void* const)
native function bool StartOnlineGame();

delegate OnStartOnlineGameComplete(bool bWasSuccessful)
{
    //return;    
}

function SetStartOnlineGameCompleteDelegate(delegate<@NULL> StartOnlineGameCompleteDelegate)
{
    __OnStartOnlineGameComplete__Delegate = StartOnlineGameCompleteDelegate;
    //return;    
}

// Export UTurokOnlineSubsystemPC::execEndOnlineGame(FFrame&, void* const)
native function bool EndOnlineGame();

delegate OnEndOnlineGameComplete(bool bWasSuccessful)
{
    //return;    
}

function SetEndOnlineGameCompleteDelegate(delegate<@NULL> EndOnlineGameCompleteDelegate)
{
    __OnEndOnlineGameComplete__Delegate = EndOnlineGameCompleteDelegate;
    //return;    
}

// Export UTurokOnlineSubsystemPC::execGetOnlineGameState(FFrame&, void* const)
native function byte GetOnlineGameState();

// Export UTurokOnlineSubsystemPC::execRegisterForArbitration(FFrame&, void* const)
native function bool RegisterForArbitration();

delegate OnArbitrationRegistrationComplete(bool bWasSuccessful)
{
    //return;    
}

function SetArbitrationRegistrationCompleteDelegate(delegate<@NULL> ArbitrationRegistrationCompleteDelegate)
{
    __OnArbitrationRegistrationComplete__Delegate = ArbitrationRegistrationCompleteDelegate;
    //return;    
}

// Export UTurokOnlineSubsystemPC::execGetArbitratedPlayers(FFrame&, void* const)
native function array GetArbitratedPlayers();

// Export UTurokOnlineSubsystemPC::execWriteArbitrationData(FFrame&, void* const)
native function bool WriteArbitrationData();

// Export UTurokOnlineSubsystemPC::execWriteArbitrationDataForPlayer(FFrame&, void* const)
native function bool WriteArbitrationDataForPlayer(@NULL PlayerResults, int Score);

delegate OnGameInviteAccepted(byte LocalUserNum, @NULL GameInviteSettings)
{
    //return;    
}

function SetGameInviteAcceptedDelegate(byte LocalUserNum, delegate<@NULL> GameInviteAcceptedDelegate)
{
    __OnGameInviteAccepted__Delegate = GameInviteAcceptedDelegate;
    //return;    
}

// Export UTurokOnlineSubsystemPC::execAcceptGameInvite(FFrame&, void* const)
native function bool AcceptGameInvite(byte LocalUserNum);

// Export UTurokOnlineSubsystemPC::execSendGameInvite(FFrame&, void* const)
native function bool SendGameInvite(byte LocalUserNum, @NULL InvitedPlayer);

// Export UTurokOnlineSubsystemPC::execGetInvitedGame(FFrame&, void* const)
native function bool GetInvitedGame(byte LocalUserNum, out @NULL InvitedGame);

// Export UTurokOnlineSubsystemPC::execWriteOnlineStats(FFrame&, void* const)
native function bool WriteOnlineStats(@NULL Player, @NULL StatsWrite);

// Export UTurokOnlineSubsystemPC::execReadOnlineStats(FFrame&, void* const)
native function bool ReadOnlineStats(array Players, @NULL StatsRead);

// Export UTurokOnlineSubsystemPC::execReadOnlineStatsByRank(FFrame&, void* const)
native function bool ReadOnlineStatsByRank(@NULL StatsRead, int StartIndex, int NumRows);

// Export UTurokOnlineSubsystemPC::execReadOnlineStatsForFriends(FFrame&, void* const)
native function bool ReadOnlineStatsForFriends(byte LocalUserNum, @NULL StatsRead);

// Export UTurokOnlineSubsystemPC::execReadOnlineStatsByRankAroundPlayer(FFrame&, void* const)
native function bool ReadOnlineStatsByRankAroundPlayer(byte LocalUserNum, @NULL StatsRead, optional int NumRows);

// Export UTurokOnlineSubsystemPC::execFreeSearchResult(FFrame&, void* const)
native function FreeSearchResult(out @NULL R);

// Export UTurokOnlineSubsystemPC::execGetGameSettingsFlags(FFrame&, void* const)
native function int GetGameSettingsFlags(@NULL SessionSettings);

// Export UTurokOnlineSubsystemPC::execParseGameSettingsFlags(FFrame&, void* const)
native function ParseGameSettingsFlags(int Flags, @NULL SessionSettings);

// Export UTurokOnlineSubsystemPC::execModifyOnlineGameSettings(FFrame&, void* const)
native function bool ModifyOnlineGameSettings();

// Export UTurokOnlineSubsystemPC::execResumeEndedOnlineGame(FFrame&, void* const)
native function bool ResumeEndedOnlineGame();

// Export UTurokOnlineSubsystemPC::execMigrateHost(FFrame&, void* const)
native function bool MigrateHost(int LocalUserIndex, @NULL NewSessionInfo);

delegate OnMigrateHostComplete(bool bWasSuccessful)
{
    //return;    
}

function SetMigrateHostCompleteDelegate(delegate<@NULL> OnMigrateHostCompleteDelegate)
{
    __OnMigrateHostComplete__Delegate = OnMigrateHostCompleteDelegate;
    //return;    
}

// Export UTurokOnlineSubsystemPC::execRegisterLocalTalker(FFrame&, void* const)
native function bool RegisterLocalTalker(byte LocalUserNum);

// Export UTurokOnlineSubsystemPC::execUnregisterLocalTalker(FFrame&, void* const)
native function bool UnregisterLocalTalker(byte LocalUserNum);

// Export UTurokOnlineSubsystemPC::execRegisterRemoteTalker(FFrame&, void* const)
native function bool RegisterRemoteTalker(@NULL PlayerID);

// Export UTurokOnlineSubsystemPC::execUnregisterRemoteTalker(FFrame&, void* const)
native function bool UnregisterRemoteTalker(@NULL PlayerID);

// Export UTurokOnlineSubsystemPC::execIsLocalPlayerTalking(FFrame&, void* const)
native function bool IsLocalPlayerTalking(byte LocalUserNum);

// Export UTurokOnlineSubsystemPC::execIsRemotePlayerTalking(FFrame&, void* const)
native function bool IsRemotePlayerTalking(@NULL PlayerID);

// Export UTurokOnlineSubsystemPC::execIsHeadsetPresent(FFrame&, void* const)
native function bool IsHeadsetPresent(byte LocalUserNum);

// Export UTurokOnlineSubsystemPC::execSetRemoteTalkerPriority(FFrame&, void* const)
native function bool SetRemoteTalkerPriority(byte LocalUserNum, @NULL PlayerID, int Priority);

// Export UTurokOnlineSubsystemPC::execMuteRemoteTalker(FFrame&, void* const)
native function bool MuteRemoteTalker(byte LocalUserNum, @NULL PlayerID);

// Export UTurokOnlineSubsystemPC::execUnmuteRemoteTalker(FFrame&, void* const)
native function bool UnmuteRemoteTalker(byte LocalUserNum, @NULL PlayerID);

// Export UTurokOnlineSubsystemPC::execPauseVoice(FFrame&, void* const)
native function bool PauseVoice();

// Export UTurokOnlineSubsystemPC::execResumeVoice(FFrame&, void* const)
native function bool ResumeVoice(array RemotePlayers);

defaultproperties
{
    mLoginPlayerNum=255
    mLoginPlayerStatus=1
    mFindGamesTimeout=1.0000000
    mSelectedInvite=-1
}