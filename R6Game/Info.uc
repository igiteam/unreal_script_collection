class Info extends Actor
    abstract
    native
    notplaceable
    hidecategories(lighting,Movement,Collision);

struct KeyValuePair
{
    var() string Key;
    var() string Value;

    structdefaultproperties
    {
        Key=""
        Value=""
    }
};

struct PlayerResponseLine
{
    var() int PlayerNum;
    var() int PlayerID;
    var() string PlayerName;
    var() int Ping;
    var() int Score;
    var() int StatsID;
    var() array<KeyValuePair> PlayerInfo;

    structdefaultproperties
    {
        PlayerNum=0
        PlayerID=0
        PlayerName=""
        Ping=0
        Score=0
        StatsID=0
        PlayerInfo=none
    }
};

struct ServerResponseLine
{
    var() int ServerID;
    var() string IP;
    var() int Port;
    var() int QueryPort;
    var() string ServerName;
    var() string MapName;
    var() string GameType;
    var() int CurrentPlayers;
    var() int MaxPlayers;
    var() int Ping;
    var() array<KeyValuePair> ServerInfo;
    var() array<PlayerResponseLine> PlayerInfo;

    structdefaultproperties
    {
        ServerID=0
        IP=""
        Port=0
        QueryPort=0
        ServerName=""
        MapName=""
        GameType=""
        CurrentPlayers=0
        MaxPlayers=0
        Ping=0
        ServerInfo=none
        PlayerInfo=none
    }
};

defaultproperties
{
    bHidden=true
    bSkipActorPropertyReplication=true
    bOnlyDirtyReplication=true
    NetUpdateFrequency=10.0000000
}