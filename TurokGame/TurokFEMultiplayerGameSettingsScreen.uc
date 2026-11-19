class TurokFEMultiplayerGameSettingsScreen extends TurokFEMultiplayerScreen
    abstract
    native;

enum eLobbyMode
{
    LM_None,                        // 0
    LM_PublicUnranked,              // 1
    LM_PublicRanked,                // 2
    LM_Private,                     // 3
    LM_Invite,                      // 4
    LM_HostLan,                     // 5
    LM_JoinLan,                     // 6
    LM_MAX                          // 7
};

enum eCommonOption
{
    CO_GameStart,                   // 0
    CO_FindGame,                    // 1
    CO_MatchType,                   // 2
    CO_LobbyMode,                   // 3
    CO_Playlist,                    // 4
    CO_GameMode,                    // 5
    CO_AdvancedSettings,            // 6
    CO_RankedGame,                  // 7
    CO_MAX                          // 8
};

struct native CommonOptionMetaData
{
    var int mTitle;
    var int mDescription;
    var int mCenterOffset;
    var name mName;
    var byte Id;

    structdefaultproperties
    {
        mTitle=0
        mDescription=0
        mCenterOffset=0
        mName="None"
        Id=0
    }
};

var protected @NULL mSettingsList;
var protected int mSettingsInitialIndex;
var protected @NULL mPartyList;
var const int kLobbyModeStringHashes[7];
var @NULL mGameStartOption;
var @NULL mFindGameOption;
var @NULL mMatchTypeOption;
var @NULL mLobbyModeOption;
var @NULL mPlaylistOption;
var @NULL mGameModeOption;
var @NULL mAdvancedSettingsOption;

event SCCleanUpOnExit()
{
    mSettingsList.Deinitialize();
    mSettingsList = none;
    mPartyList.Deinitialize();
    mPartyList = none;
    mTurokTextImage1.ScriptCtrl = none;
    mTurokTextImage1 = none;
    mTurokTextImage2.ScriptCtrl = none;
    mTurokTextImage2 = none;
    super.SCCleanUpOnExit();
    //return;    
}

// Export UTurokFEMultiplayerGameSettingsScreen::execRefreshGameSettings(FFrame&, void* const)
protected native function RefreshGameSettings();

// Export UTurokFEMultiplayerGameSettingsScreen::execRefreshHelpBar(FFrame&, void* const)
protected native function RefreshHelpBar();

// Export UTurokFEMultiplayerGameSettingsScreen::execGetLobbyModeHash(FFrame&, void* const)
protected native function int GetLobbyModeHash(bool IsPrivate, bool IsRanked, bool IsLan);

// Export UTurokFEMultiplayerGameSettingsScreen::execIsHost(FFrame&, void* const)
protected native function bool IsHost();

// Export UTurokFEMultiplayerGameSettingsScreen::execIsRankedGame(FFrame&, void* const)
protected native function bool IsRankedGame();

// Export UTurokFEMultiplayerGameSettingsScreen::execShowScreenElements(FFrame&, void* const)
protected native function ShowScreenElements(bool Show);

// Export UTurokFEMultiplayerGameSettingsScreen::execOnLobbyEvent(FFrame&, void* const)
native function OnLobbyEvent(@NULL Event);

// Export UTurokFEMultiplayerGameSettingsScreen::execOnTalkingStateChanged(FFrame&, void* const)
native function OnTalkingStateChanged(bool bTalking, @NULL PlayerID);

// Export UTurokFEMultiplayerGameSettingsScreen::execOnMuteStateChanged(FFrame&, void* const)
native function OnMuteStateChanged();

defaultproperties
{
    kLobbyModeStringHashes[1]=-224550219
    kLobbyModeStringHashes[2]=-1860507977
    kLobbyModeStringHashes[3]=1255208464
    kLobbyModeStringHashes[5]=42103920
    kLobbyModeStringHashes[6]=85563548
    mGameStartOption=(mTitle=-874201586,mDescription=1541575142,mCenterOffset=5,mName="StartGame",Id=0)
    mFindGameOption=(mTitle=-127783084,mDescription=-1648798541,mCenterOffset=5,mName="FindGame",Id=1)
    mMatchTypeOption=(mTitle=1361792883,mDescription=887417269,mCenterOffset=5,mName="MatchType",Id=2)
    mLobbyModeOption=(mTitle=1732531469,mDescription=887417269,mCenterOffset=5,mName="LobbyMode",Id=3)
    mPlaylistOption=(mTitle=-2124636806,mDescription=-322111740,mCenterOffset=5,mName="Playlist",Id=4)
    mGameModeOption=(mTitle=246944170,mDescription=594817228,mCenterOffset=5,mName="GameMode",Id=5)
    mAdvancedSettingsOption=(mTitle=-464077805,mDescription=1517423248,mCenterOffset=5,mName="AdvancedOptions",Id=6)
}