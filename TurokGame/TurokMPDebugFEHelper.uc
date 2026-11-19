class TurokMPDebugFEHelper extends Object
    native
    implements(TurokLobbyFrontEndInterface);

var private native const noexport @NULL VfTable_ITurokLobbyFrontEndInterface;
var private @NULL mDebugOS;
var private @NULL mDebugLobby;
var private int mNumResults;
var private array mServerAddrs;
var private array mServerNames;

// Export UTurokMPDebugFEHelper::execInitMpHelper(FFrame&, void* const)
native function InitMpHelper();

// Export UTurokMPDebugFEHelper::execShutdownMpHelper(FFrame&, void* const)
native function ShutdownMpHelper();

// Export UTurokMPDebugFEHelper::execGetServerName(FFrame&, void* const)
native function string GetServerName(int I);

// Export UTurokMPDebugFEHelper::execGetServerAddr(FFrame&, void* const)
native function string GetServerAddr(int I);

// Export UTurokMPDebugFEHelper::execOnDebugMenuSignInComplete(FFrame&, void* const)
native function OnDebugMenuSignInComplete(byte ControllerId, byte resultCode);

// Export UTurokMPDebugFEHelper::execOnLobbyEvent(FFrame&, void* const)
native function OnLobbyEvent(@NULL Event);

// Export UTurokMPDebugFEHelper::execOnFindGamesCompleted(FFrame&, void* const)
native function OnFindGamesCompleted(bool bSuccess);

// Export UTurokMPDebugFEHelper::execOnGameCreated(FFrame&, void* const)
native function OnGameCreated(bool bSuccess);

function SearchGames(string GameName)
{
    local @NULL SearchSetting;

    // End:0x0D
    if(mDebugLobby == none)
    {
        return;
    }
    mDebugLobby.CancelFindGame();
    mNumResults = 0;
    mServerNames.Remove(0, mServerNames.Length);
    mServerAddrs.Remove(0, mServerAddrs.Length);
    SearchSetting.LanMatch = 1;
    SearchSetting.GamePlayMode = byte(Class'Engine.TurokOnlineGameSearch'.static.GetGamePlayModeByName(GameName));
    mDebugLobby.SetSearchSettings(SearchSetting);
    mDebugLobby.FindGame(1);
    //return;    
}

function int GetNumServers()
{
    return mNumResults;
    //return ReturnValue;    
}

function bool StartGame(string GameName, string MapName)
{
    local bool bRet;
    local @NULL GameSettings;

    // End:0x0D
    if(mDebugLobby == none)
    {
        return false;
    }
    mDebugLobby.CancelFindGame();
    // End:0x55
    if(int(mDebugLobby.GetGameState()) != int(0))
    {
        bRet = mDebugLobby.DestroyGame(0);
        return bRet;
    }
    GameSettings = new Class'Engine.TurokOnlineGameSettings';
    GameSettings.NumPrivateConnections = 0;
    GameSettings.NumPublicConnections = 16;
    GameSettings.bShouldAdvertise = true;
    GameSettings.bIsLanMatch = true;
    GameSettings.bUsesPresence = false;
    GameSettings.bAllowJoinInProgress = true;
    GameSettings.bAllowInvites = false;
    GameSettings.bAllowJoinViaPresence = false;
    GameSettings.bUsesStats = false;
    GameSettings.bUsesArbitration = false;
    GameSettings.SetGamePlayModeByName(GameName);
    GameSettings.SetToDefaults();
    GameSettings.SetMapByName(MapName);
    bRet = mDebugLobby.CreateGame(GameSettings);
    return bRet;
    //return ReturnValue;    
}

function bool JoinGame(int Result)
{
    local bool bRet;
    local @NULL Search, SearchResult;

    // End:0x0D
    if(mDebugLobby == none)
    {
        return false;
    }
    Search = mDebugLobby.GetGameSearch();
    // End:0x57
    if(((Search == none) || Result < 0) || Result >= Search.Results.Length)
    {
        return false;
    }
    SearchResult = Search.Results[Result];
    bRet = mDebugLobby.super(TurokMPDebugFEHelper).JoinGame(SearchResult);
    mDebugLobby.CancelFindGame();
    return bRet;
    //return ReturnValue;    
}

function bool LeaveGame()
{
    // End:0x0D
    if(mDebugLobby == none)
    {
        return false;
    }
    mDebugLobby = none;
    Class'Engine.Engine'.static.GetTurokNet().DestroyLobby();
    return true;
    //return ReturnValue;    
}
