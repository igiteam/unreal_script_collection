class TurokMPTeamAndPlayerStatistics extends Object
    native;

const NUM_TEAMS = 2;

enum eMPStatsSortBy
{
    MPSTATS_SORTBY_SCORE,           // 0
    MPSTATS_SORTBY_POINTS,          // 1
    MPSTATS_SORTBY_MAX              // 2
};

struct native IndividualPlayerStatistics
{
    var bool is_disconnected;
    var bool is_dead;
    var int suicides;
    var int friendly;
    var int Rank;
    var int Team;
    var string player_name;
    var float battle_rating;
    var float Accuracy;
    var int shots_fired;
    var int shots_hit;
    var int total_kills;
    var int stealthKills;
    var int headShotKills;
    var int fragKills;
    var int assists;
    var int Deaths;
    var float kill_death_ratio;
    var int Score;
    var int killedByLocalPlayer;
    var int stealthKilledByLocalPlayer;
    var int killedLocalPlayer;
    var int stealthKilledLocalPlayer;
    var bool is_local_player;
    var int Id;
    var @NULL unique_net_id;
    var int flag_caps;
    var int act_count;
    var int act_score;

    structdefaultproperties
    {
        is_disconnected=false
        is_dead=false
        suicides=0
        friendly=0
        Rank=0
        Team=0
        player_name=""
        battle_rating=0.0000000
        Accuracy=0.0000000
        shots_fired=0
        shots_hit=0
        total_kills=0
        stealthKills=0
        headShotKills=0
        fragKills=0
        assists=0
        Deaths=0
        kill_death_ratio=0.0000000
        Score=0
        killedByLocalPlayer=0
        stealthKilledByLocalPlayer=0
        killedLocalPlayer=0
        stealthKilledLocalPlayer=0
        is_local_player=false
        Id=0
        unique_net_id=(Uid=0,Uid[1]=0,Uid[2]=0,Uid[3]=0,Uid[4]=0,Uid[5]=0,Uid[6]=0,Uid[7]=0)
        flag_caps=0
        act_count=0
        act_score=0
    }
};

var bool mbIsTeamBasedGame;
var array mIndividualPlayerStatistics;
var @NULL mTeamStatistics[2];
var int mNumTeamPlayers[2];

// Export UTurokMPTeamAndPlayerStatistics::execAddZeroed(FFrame&, void* const)
native function AddZeroed(const int kNum);

// Export UTurokMPTeamAndPlayerStatistics::execEmpty(FFrame&, void* const)
native function Empty();

// Export UTurokMPTeamAndPlayerStatistics::execNum(FFrame&, void* const)
native function int Num();

// Export UTurokMPTeamAndPlayerStatistics::execGetPlayerStats(FFrame&, void* const)
native function GetPlayerStats(const int kIndex, out @NULL stat);

// Export UTurokMPTeamAndPlayerStatistics::execGetTeamStats(FFrame&, void* const)
native function GetTeamStats(const int kIndex, out @NULL stat);

// Export UTurokMPTeamAndPlayerStatistics::execGetPlayersTeamStats(FFrame&, void* const)
native function GetPlayersTeamStats(const int kPlayerIndex, out @NULL stat);

// Export UTurokMPTeamAndPlayerStatistics::execRePopulate(FFrame&, void* const)
native function RePopulate();

// Export UTurokMPTeamAndPlayerStatistics::execSetPlayerStats(FFrame&, void* const)
native function SetPlayerStats(const int kIndex, @NULL PlayerResults);

// Export UTurokMPTeamAndPlayerStatistics::execSetPlayerKillStats(FFrame&, void* const)
native function SetPlayerKillStats(const int kIndex, @NULL KillStats);

// Export UTurokMPTeamAndPlayerStatistics::execInitTeamStats(FFrame&, void* const)
native function InitTeamStats(bool IsTeamGame);

// Export UTurokMPTeamAndPlayerStatistics::execAccumulateTeamStats(FFrame&, void* const)
native function AccumulateTeamStats();

// Export UTurokMPTeamAndPlayerStatistics::execSort(FFrame&, void* const)
native function Sort(byte sortBy);
