class TurokUIPartyList extends TurokUIHighlightableTable
    native
    hidecategories(Object,UIRoot,Object);

const kMB_vs = 3687551881U;
const kMB_Ready = 3915855110U;
const kMB_Host = 1662590868U;
const kMB_Players = 3425425281U;

enum TeamIndex
{
    TEAMINDEX_RED,                  // 0
    TEAMINDEX_BLUE,                 // 1
    TEAMINDEX_MAX                   // 2
};

var protected array mPlayers;
var protected bool mShowHost;
var protected bool mShowSpeakingState;
var protected bool mShowReadyState;
var protected bool mShowTeams;
var private bool mPopulateWithDummyData;
var protected int mMaxNumPlayers;
var() private @NULL mBackgroundGradient;
var() private @NULL mReadyTexture;
var() private @NULL mMissingDLCTexture;
var() private @NULL mSpeakingTexture;
var() private @NULL mMutedTexture;
var() private @NULL mTeam0Texture;
var() private @NULL mTeam1Texture;
var @NULL mReadyIcon;
var @NULL mReadyCountLabel;
var @NULL mPlayerCount;
var @NULL mHostNameLabel;
var @NULL mRedCountLabel;
var @NULL mBlueCountLabel;
var @NULL mVersusLabel;
var @NULL mRedTeamImage;
var @NULL mBlueTeamImage;

// Export UTurokUIPartyList::execGetSelectedPlayer(FFrame&, void* const)
native function GetSelectedPlayer(out @NULL SelectedPlayer);

// Export UTurokUIPartyList::execIsLocalPlayerSelected(FFrame&, void* const)
native function bool IsLocalPlayerSelected();

// Export UTurokUIPartyList::execSetPlayerVoiceStatus(FFrame&, void* const)
native function SetPlayerVoiceStatus(@NULL PlayerID, bool IsTalking);

// Export UTurokUIPartyList::execSetShowHost(FFrame&, void* const)
native function SetShowHost(bool Enabled);

// Export UTurokUIPartyList::execSetShowSpeakingState(FFrame&, void* const)
native function SetShowSpeakingState(bool Enabled);

// Export UTurokUIPartyList::execSetShowReadyState(FFrame&, void* const)
native function SetShowReadyState(bool Enabled);

// Export UTurokUIPartyList::execSetShowTeams(FFrame&, void* const)
native function SetShowTeams(bool Enabled);

// Export UTurokUIPartyList::execSetMaxNumPlayers(FFrame&, void* const)
native function SetMaxNumPlayers(int MaxNumPlayers);

// Export UTurokUIPartyList::execProcessInput(FFrame&, void* const)
native function bool ProcessInput(int ControllerId, name Key, byte Event, optional float AmountDepressed);

// Export UTurokUIPartyList::execRefresh(FFrame&, void* const)
native function Refresh();

// Export UTurokUIPartyList::execAdjustHighlight(FFrame&, void* const)
native function AdjustHighlight();

// Export UTurokUIPartyList::execFocus(FFrame&, void* const)
native function Focus();

// Export UTurokUIPartyList::execUnFocus(FFrame&, void* const)
native function UnFocus();

// Export UTurokUIPartyList::execIsTeamGame(FFrame&, void* const)
native function bool IsTeamGame();

// Export UTurokUIPartyList::execIsPlayerMuted(FFrame&, void* const)
native function bool IsPlayerMuted(@NULL PlayerID);

// Export UTurokUIPartyList::execShowPlayerListBG(FFrame&, void* const)
native function ShowPlayerListBG(int NumPlayers);

defaultproperties
{
    mShowHost=true
    mShowSpeakingState=true
    mShowReadyState=true
    mShowTeams=true
    mMaxNumPlayers=1
    // Reference: UIComp_Event'Default__TurokUIPartyList.WidgetEventComponent'
    begin object name=WidgetEventComponent
    end object
    EventProvider=WidgetEventComponent
}