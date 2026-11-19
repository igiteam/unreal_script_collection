class TurokLeaderboardReader extends Object
    native;

enum eLeaderboard
{
    LB_Deathmatch,                  // 0
    LB_TeamDeathmatch,              // 1
    LB_CTF,                         // 2
    LB_AssaultCTF,                  // 3
    LB_WarGames,                    // 4
    LB_KillsOverall,                // 5
    LB_KillsWeekly,                 // 6
    LB_WinsOverall,                 // 7
    LB_BattleRatingMonthly,         // 8
    LB_RankedSkill_FreeForAll,      // 9
    LB_RankedSkill_TeamGames,       // 10
    LB_MAX                          // 11
};

enum eColumnType
{
    ColType_Unknown,                // 0
    ColType_Locale,                 // 1
    ColType_GamesPlayed,            // 2
    ColType_MAX                     // 3
};

enum eLBState
{
    LBSTATE_Idle,                   // 0
    LBSTATE_ReadingLocalPlayer,     // 1
    LBSTATE_ReadingLeaderboard,     // 2
    LBSTATE_ReadingFriends,         // 3
    LBSTATE_ReadingTrueSkillRanks,  // 4
    LBSTATE_MAX                     // 5
};

enum eLeaderboardMode
{
    LBMODE_Rankings,                // 0
    LBMODE_Friends,                 // 1
    LBMODE_MAX                      // 2
};

struct native LeaderboardMetaData
{
    var int mType;
    var int Id;
    var class<Class> mReadClass;
    var int mTrueSkillViewID;

    structdefaultproperties
    {
        mType=0
        Id=0
        mReadClass=none
        mTrueSkillViewID=0
    }
};

struct native ColumnData
{
    var byte mType;
    var int Id;
    var int mValue;

    structdefaultproperties
    {
        mType=0
        Id=0
        mValue=0
    }
};

struct native LeaderboardStatsData
{
    var int mRank;
    var int mPosition;
    var string mPlayerName;
    var int mPoints;
    var int mGamesPlayed;
    var @NULL mNetId;
    var int Id;

    structdefaultproperties
    {
        mRank=0
        mPosition=0
        mPlayerName=""
        mPoints=0
        mGamesPlayed=0
        mNetId=(Uid=0,Uid[1]=0,Uid[2]=0,Uid[3]=0,Uid[4]=0,Uid[5]=0,Uid[6]=0,Uid[7]=0)
        Id=0
    }
};

var protected const @NULL mOS;
var private byte mState;
var private byte mLeaderboardMode;
var private bool mIsFullReadInProgress;
var private int mDefaultReadSize;
var private int mViewID;
var private @NULL mLocalPlayerStatsReadObject;
var private @NULL mLeaderboardStatsReadObject;
var private @NULL mTrueSkillStatsReadObject;
var private const array kLeaderboardMetaData;
//var delegate<@NULL> __OnReadComplete__Delegate;

// Export UTurokLeaderboardReader::execInitialize(FFrame&, void* const)
native function Initialize(int DefaultReadSize, delegate<@NULL> ReadCompleteDelegate);

// Export UTurokLeaderboardReader::execSetLeaderboard(FFrame&, void* const)
native function SetLeaderboard(byte Type);

// Export UTurokLeaderboardReader::execGetLeaderboard(FFrame&, void* const)
native function byte GetLeaderboard();

// Export UTurokLeaderboardReader::execSetLeaderboardMode(FFrame&, void* const)
native function SetLeaderboardMode(byte mode);

// Export UTurokLeaderboardReader::execGetLeaderboardMode(FFrame&, void* const)
native function byte GetLeaderboardMode();

// Export UTurokLeaderboardReader::execReadLocalPlayerData(FFrame&, void* const)
native function ReadLocalPlayerData();

// Export UTurokLeaderboardReader::execReadLeaderboardData(FFrame&, void* const)
native function ReadLeaderboardData(int StartingRank, int Num);

// Export UTurokLeaderboardReader::execReadFriendsData(FFrame&, void* const)
native function ReadFriendsData();

// Export UTurokLeaderboardReader::execReadAllData(FFrame&, void* const)
native function ReadAllData();

delegate OnReadComplete(bool success)
{
    //return;    
}

// Export UTurokLeaderboardReader::execGetLocalPlayerData(FFrame&, void* const)
native function GetLocalPlayerData(out @NULL LeaderboardData);

// Export UTurokLeaderboardReader::execGetLeaderboardDataAt(FFrame&, void* const)
native function GetLeaderboardDataAt(int Index, out @NULL LeaderboardData);

// Export UTurokLeaderboardReader::execGetNumLeaderboardRows(FFrame&, void* const)
native function int GetNumLeaderboardRows();

// Export UTurokLeaderboardReader::execGetPositionAtRow(FFrame&, void* const)
native function int GetPositionAtRow(int Index);

// Export UTurokLeaderboardReader::execGetHeadPosition(FFrame&, void* const)
native function int GetHeadPosition();

// Export UTurokLeaderboardReader::execGetTailPosition(FFrame&, void* const)
native function int GetTailPosition();

// Export UTurokLeaderboardReader::execGetListedPlayerIDs(FFrame&, void* const)
native function GetListedPlayerIDs(bool IncludeLocalPlayer, out array Players);

// Export UTurokLeaderboardReader::execDeinitialize(FFrame&, void* const)
native function Deinitialize();

// Export UTurokLeaderboardReader::execSetState(FFrame&, void* const)
protected native function SetState(byte State);

// Export UTurokLeaderboardReader::execGetTrueSkillForLeaderboard(FFrame&, void* const)
protected native function int GetTrueSkillForLeaderboard(int ViewId);

// Export UTurokLeaderboardReader::execReadTrueSkillData(FFrame&, void* const)
protected native function ReadTrueSkillData(array Players);

// Export UTurokLeaderboardReader::execSortLeaderboardData(FFrame&, void* const)
protected native function SortLeaderboardData();

// Export UTurokLeaderboardReader::execGetStatsReadClass(FFrame&, void* const)
protected native function class<Class> GetStatsReadClass(int ViewId);

// Export UTurokLeaderboardReader::execReadNextData(FFrame&, void* const)
protected native final function ReadNextData(bool success);

protected event RegisterDelegates()
{
    // End:0x43
    if(NotEqual_InterfaceInterface(mOS.StatsInterface, OnlineStatsInterface(none)))
    {
        mOS.StatsInterface.SetReadOnlineStatsCompleteDelegate(NotifyStatsReadComplete);
    }
    // End:0x100
    if(NotEqual_InterfaceInterface(mOS.PlayerInterface, OnlinePlayerInterface(none)))
    {
        mOS.PlayerInterface.SetReadFriendsCompleteDelegate(0, NotifyFriendsListReadComplete);
        mOS.PlayerInterface.SetReadFriendsCompleteDelegate(1, NotifyFriendsListReadComplete);
        mOS.PlayerInterface.SetReadFriendsCompleteDelegate(2, NotifyFriendsListReadComplete);
        mOS.PlayerInterface.SetReadFriendsCompleteDelegate(3, NotifyFriendsListReadComplete);
    }
    //return;    
}

protected event UnregisterDelegates()
{
    // End:0x43
    if(NotEqual_InterfaceInterface(mOS.StatsInterface, OnlineStatsInterface(none)))
    {
        mOS.StatsInterface.ClearReadOnlineStatsCompleteDelegate(NotifyStatsReadComplete);
    }
    // End:0x100
    if(NotEqual_InterfaceInterface(mOS.PlayerInterface, OnlinePlayerInterface(none)))
    {
        mOS.PlayerInterface.SetReadFriendsCompleteDelegate(0, None);
        mOS.PlayerInterface.SetReadFriendsCompleteDelegate(1, None);
        mOS.PlayerInterface.SetReadFriendsCompleteDelegate(2, None);
        mOS.PlayerInterface.SetReadFriendsCompleteDelegate(3, None);
    }
    __OnReadComplete__Delegate = None;
    //return;    
}

// Export UTurokLeaderboardReader::execNotifyStatsReadComplete(FFrame&, void* const)
protected native function NotifyStatsReadComplete(bool success);

// Export UTurokLeaderboardReader::execNotifyFriendsListReadComplete(FFrame&, void* const)
protected native function NotifyFriendsListReadComplete(bool success);

// Export UTurokLeaderboardReader::execDebugStatsReadComplete(FFrame&, void* const)
protected native function DebugStatsReadComplete(byte Stats);

defaultproperties
{
    mViewID=2
    kLeaderboardMetaData=/* Array type was not detected. */
}