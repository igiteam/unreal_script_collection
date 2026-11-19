class TurokFEMPLanJoin extends Object
    native
    implements(TurokLobbyFrontEndInterface);

enum eLanJoinState
{
    OLJS_NONE,                      // 0
    OLJS_SEARCHING,                 // 1
    OLJS_NOTFOUND,                  // 2
    OLJS_WAITTOSTART,               // 3
    OLJS_HOSTDISCONNECTED,          // 4
    OLJS_ERROR,                     // 5
    OLJS_MAX                        // 6
};

var private native const noexport @NULL VfTable_ITurokLobbyFrontEndInterface;
var private @NULL mOS;
var private @NULL mLobby;
var private int mNumResults;
var private array mServerAddrs;
var private array mServerNames;
var private byte mLanJoinState;

// Export UTurokFEMPLanJoin::execInitialize(FFrame&, void* const)
native function Initialize();

// Export UTurokFEMPLanJoin::execDeinitialize(FFrame&, void* const)
native function Deinitialize();

// Export UTurokFEMPLanJoin::execGetServerName(FFrame&, void* const)
native function string GetServerName(int I);

// Export UTurokFEMPLanJoin::execGetServerAddr(FFrame&, void* const)
native function string GetServerAddr(int I);

// Export UTurokFEMPLanJoin::execOnLanJoinMenuSignInComplete(FFrame&, void* const)
native function OnLanJoinMenuSignInComplete(byte ControllerId, byte resultCode);

// Export UTurokFEMPLanJoin::execGetLanJoinState(FFrame&, void* const)
native function byte GetLanJoinState();

// Export UTurokFEMPLanJoin::execOnLobbyEvent(FFrame&, void* const)
native function OnLobbyEvent(@NULL Event);

// Export UTurokFEMPLanJoin::execOnFindGamesCompleted(FFrame&, void* const)
native function OnFindGamesCompleted(bool bSuccess);

function Reset()
{
    // End:0x15
    if(mLobby == none)
    {
        mLanJoinState = 5;
        return;
    }
    mLobby.CancelFindGame();
    mNumResults = 0;
    mServerNames.Remove(0, mServerNames.Length);
    mServerAddrs.Remove(0, mServerAddrs.Length);
    mLanJoinState = 0;
    //return;    
}

function SearchGames()
{
    local @NULL SearchSetting;

    Reset();
    SearchSetting.LanMatch = 1;
    SearchSetting.GamePlayMode = byte(255);
    mLobby.SetSearchSettings(SearchSetting);
    mLobby.FindGame(1);
    mLanJoinState = 1;
    //return;    
}

function int GetNumServers()
{
    return mNumResults;
    //return ReturnValue;    
}

function bool JoinGame(int Result)
{
    local bool bRet;
    local @NULL Search, SearchResult;

    // End:0x15
    if(mLobby == none)
    {
        mLanJoinState = 5;
        return false;
    }
    Search = mLobby.GetGameSearch();
    // End:0x5F
    if(((Search == none) || Result < 0) || Result >= Search.Results.Length)
    {
        return false;
    }
    SearchResult = Search.Results[Result];
    bRet = mLobby.super(TurokFEMPLanJoin).JoinGame(SearchResult);
    mLobby.CancelFindGame();
    return bRet;
    //return ReturnValue;    
}

function bool LeaveGame()
{
    // End:0x15
    if(mLobby == none)
    {
        mLanJoinState = 5;
        return false;
    }
    mLobby = none;
    Class'Engine.Engine'.static.GetTurokNet().DestroyLobby();
    mLanJoinState = 0;
    return true;
    //return ReturnValue;    
}
