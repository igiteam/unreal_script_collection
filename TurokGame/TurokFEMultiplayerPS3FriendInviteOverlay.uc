class TurokFEMultiplayerPS3FriendInviteOverlay extends TurokUISceneController
    native;

enum eInviteMode
{
    INVITE_Send,                    // 0
    INVITE_Receive,                 // 1
    INVITE_MAX                      // 2
};

var @NULL mFriendsList;
var @NULL mFriendsListHighlightImg;
var array mFriendIDs;
var array mInvitesCache;
var @NULL mModeMenu;
var @NULL mHelpText;
var byte mInviteMode;
var @NULL mOverlayEdges[2];

// Export UTurokFEMultiplayerPS3FriendInviteOverlay::execInitialize(FFrame&, void* const)
native function Initialize(@NULL pScene, @NULL pSceneClient);

// Export UTurokFEMultiplayerPS3FriendInviteOverlay::execTick(FFrame&, void* const)
native function Tick(float elapsed);

// Export UTurokFEMultiplayerPS3FriendInviteOverlay::execCloseMenu(FFrame&, void* const)
native function CloseMenu();

// Export UTurokFEMultiplayerPS3FriendInviteOverlay::execCleanUpOnExit(FFrame&, void* const)
native function CleanUpOnExit();

// Export UTurokFEMultiplayerPS3FriendInviteOverlay::execSetInviteMode(FFrame&, void* const)
native function SetInviteMode(byte mode);

// Export UTurokFEMultiplayerPS3FriendInviteOverlay::execInitInvites(FFrame&, void* const)
native function InitInvites();

// Export UTurokFEMultiplayerPS3FriendInviteOverlay::execGetNumInvites(FFrame&, void* const)
native function int GetNumInvites();

// Export UTurokFEMultiplayerPS3FriendInviteOverlay::execRefreshInviteList(FFrame&, void* const)
native function RefreshInviteList();

// Export UTurokFEMultiplayerPS3FriendInviteOverlay::execReadFriendsListData(FFrame&, void* const)
native function ReadFriendsListData();

// Export UTurokFEMultiplayerPS3FriendInviteOverlay::execFinishedReadingFriendsList(FFrame&, void* const)
native function FinishedReadingFriendsList(bool bWasSuccessful);

// Export UTurokFEMultiplayerPS3FriendInviteOverlay::execRefreshFriendsList(FFrame&, void* const)
native function RefreshFriendsList();

// Export UTurokFEMultiplayerPS3FriendInviteOverlay::execSendInvite(FFrame&, void* const)
native function SendInvite(int Index);

// Export UTurokFEMultiplayerPS3FriendInviteOverlay::execAcceptInvite(FFrame&, void* const)
native function AcceptInvite(int Index);

// Export UTurokFEMultiplayerPS3FriendInviteOverlay::execIsSendAllowed(FFrame&, void* const)
native function bool IsSendAllowed();

protected event RegisterReadDelegate(@NULL OS, byte Controller)
{
    // End:0x48
    if(NotEqual_InterfaceInterface(OS.PlayerInterface, OnlinePlayerInterface(none)))
    {
        OS.PlayerInterface.SetReadFriendsCompleteDelegate(Controller, FinishedReadingFriendsList);
    }
    //return;    
}

protected event UnRegisterReadDelegate(@NULL OS, byte Controller)
{
    // End:0x48
    if(NotEqual_InterfaceInterface(OS.PlayerInterface, OnlinePlayerInterface(none)))
    {
        OS.PlayerInterface.SetReadFriendsCompleteDelegate(Controller, None);
    }
    //return;    
}

function EmptyDelegate()
{
    //return;    
}

event SCCleanUpOnExit()
{
    CleanUpOnExit();
    //return;    
}

defaultproperties
{
    SceneName="TurokFEMultiplayer.PS3FriendInviteOverlay"
}