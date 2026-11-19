class AdvGameHostMigrationManager extends Object;

struct PlayerPRIData
{
    var string PlayerName;
    var UniqueNetId UniqueId;
    var int PlayerSkill;
    var int PlayerLevel;
    var float Score;
    var int Deaths;
    var int Kills;
    var int Score_Kills;
    var int Score_Takedowns;
    var int Score_Revives;
    var int Score_Assists;
    var int Score_GameSpecific1;
    var int Score_GameSpecific2;
    var int Score_GameSpecific3;
    var int Score_GameSpecific4;
    var UniqueNetId PartyOwnerUniqueId;
    var int TeamID;
    var bool bIsPrimaryPlayer;
    var int KillStreak;
    var int MaxKillStreak;
    var int NumFirstKills;
    var int NumLastKills;
    var int NumExecutions;
    var int HeadshotHatTrick;
    var int NumHeadshots;
    var int NumTimesHeadshot;
    var int NumTimesRevived;
    var int NumSpottingKills;
    var float TotalTimeDBNO;
    var float TotalTimeInCover;
    var float DamageTaken;
    var int NumMeleeHits;
    var int NumBlindfireKills;
    var int NumGrenadeKills;
    var int NumPistolKills;
    var int NumChainsawsInARow;
    var int NumRetroChargesInARow;
    var int NumPerfectReloads;
    var int NumRoundsPlayed;
    var bool bWasFemaleThisMatch;
    var bool bHasViralAchievement;
    var int KillsAsLeader;
    var int LeaderSaves;
    var int NumTokens;
    var int WavePointsSpent;
    var bool bHasFailedAWave;
    var int MoneyGiven;
    var int CashSpent;

    structdefaultproperties
    {
        PlayerName=""
        UniqueId=(Uid=none)
        PlayerSkill=0
        PlayerLevel=0
        Score=0.0000000
        Deaths=0
        Kills=0
        Score_Kills=0
        Score_Takedowns=0
        Score_Revives=0
        Score_Assists=0
        Score_GameSpecific1=0
        Score_GameSpecific2=0
        Score_GameSpecific3=0
        Score_GameSpecific4=0
        PartyOwnerUniqueId=(Uid=none)
        TeamID=0
        bIsPrimaryPlayer=false
        KillStreak=0
        MaxKillStreak=0
        NumFirstKills=0
        NumLastKills=0
        NumExecutions=0
        HeadshotHatTrick=0
        NumHeadshots=0
        NumTimesHeadshot=0
        NumTimesRevived=0
        NumSpottingKills=0
        TotalTimeDBNO=0.0000000
        TotalTimeInCover=0.0000000
        DamageTaken=0.0000000
        NumMeleeHits=0
        NumBlindfireKills=0
        NumGrenadeKills=0
        NumPistolKills=0
        NumChainsawsInARow=0
        NumRetroChargesInARow=0
        NumPerfectReloads=0
        NumRoundsPlayed=0
        bWasFemaleThisMatch=false
        bHasViralAchievement=false
        KillsAsLeader=0
        LeaderSaves=0
        NumTokens=0
        WavePointsSpent=0
        bHasFailedAWave=false
        MoneyGiven=0
        CashSpent=0
    }
};

struct TeamData
{
    var int TeamID;
    var int TeamScore;
    var string PawnClassName;

    structdefaultproperties
    {
        TeamID=0
        TeamScore=0
        PawnClassName=""
    }
};

struct GRIData
{
    var int GoalScore;
    var int TimeLimit;
    var int RoundsToWin;
    var int ScoreForWin;
    var int XPForWin;
    var float RespawnTime;
    var bool bRealism;
    var bool bKillingSpree;
    var bool bOracle;
    var bool bTraps;
    var bool bTeamDamage;
    var string MapsList;

    structdefaultproperties
    {
        GoalScore=0
        TimeLimit=0
        RoundsToWin=0
        ScoreForWin=0
        XPForWin=0
        RespawnTime=0.0000000
        bRealism=false
        bKillingSpree=false
        bOracle=false
        bTraps=false
        bTeamDamage=false
        MapsList=""
    }
};

var bool bPreviousMatchEnded;
var transient array<PlayerPRIData> Players;
var transient array<TeamData> Teams;
var GRIData GameData;

function DumpGameSettings()
{
    //return;    
}

function AddPlayerData(AdvPRI PRI)
{
    local int Index;

    Index = Players.Find('UniqueId', PRI.UniqueId);    
    // End:0x7D
    if(Index == -1)
    {
        Index = Players.Length;
        Players.Length = Players.Length + 1;
    }
    Players[Index].PlayerName = PRI.PlayerName;
    Players[Index].UniqueId = PRI.UniqueId;
    Players[Index].PlayerSkill = PRI.PlayerSkill;
    Players[Index].PlayerLevel = PRI.PlayerLevel;
    // End:0x26F
    if(!bPreviousMatchEnded)
    {
        Players[Index].Score = PRI.Score;
        Players[Index].Deaths = PRI.Deaths;
        Players[Index].Kills = PRI.Kills;
    }
    Players[Index].PartyOwnerUniqueId = PRI.PartyOwnerUniqueId;
    // End:0x335
    if(PRI.Team != none)
    {
        Players[Index].TeamID = PRI.Team.TeamIndex;        
    }
    else
    {
        Players[Index].TeamID = 255;
    }
    //return;    
}

function AddTeamData(TeamInfo Team)
{
    local int Index;

    Index = Teams.Find('TeamID', Team.TeamIndex);    
    // End:0x7D
    if(Index == -1)
    {
        Index = Teams.Length;
        Teams.Length = Teams.Length + 1;
    }
    Teams[Index].TeamID = Team.TeamIndex;
    Teams[Index].TeamScore = int(Team.Score);
    Teams[Index].PawnClassName = "";
    //return;    
}

function AddGameData(AdvGRI GRI)
{
    local int TeamIdx;

    GameData.GoalScore = GRI.GoalScore;
    GameData.TimeLimit = GRI.TimeLimit;
    GameData.RoundsToWin = GRI.RoundsToWin;
    GameData.ScoreForWin = GRI.ScoreForWin;
    GameData.RespawnTime = GRI.RespawnTime;
    GameData.bRealism = GRI.bRealism;
    GameData.bKillingSpree = GRI.bKillingSpree;
    GameData.bOracle = GRI.bOracle;
    GameData.bTraps = GRI.bTraps;
    GameData.bTeamDamage = GRI.bTeamDamage;
    GameData.MapsList = GRI.MapsList;
    TeamIdx = 0;
    J0x29E:

    // End:0x37F [Loop If]
    if(TeamIdx < GRI.Teams.Length)
    {
        // End:0x371
        if((GRI.Teams[TeamIdx] != none) && GRI.Teams[TeamIdx].TeamIndex != 255)
        {
            AddTeamData(GRI.Teams[TeamIdx]);
        }
        TeamIdx++;
        // [Loop Continue]
        goto J0x29E;
    }
    //return;    
}

function bool UpdatePRI(AdvPRI PRI)
{
    local int Index;

    Index = Players.Find('UniqueId', PRI.UniqueId);    
    // End:0x236
    if(Index != -1)
    {
        PRI.PlayerName = Players[Index].PlayerName;
        PRI.PlayerSkill = Players[Index].PlayerSkill;
        PRI.PlayerLevel = Players[Index].PlayerLevel;
        PRI.Score = Players[Index].Score;
        PRI.Deaths = Players[Index].Deaths;
        PRI.Kills = Players[Index].Kills;
        PRI.PartyOwnerUniqueId = Players[Index].PartyOwnerUniqueId;
        return true;
    }
    return false;
    //return ReturnValue;    
}

function int GetTeamId(AdvPRI PRI)
{
    local int Index;

    Index = Players.Find('UniqueId', PRI.UniqueId);    
    // End:0x78
    if(Index != -1)
    {
        return Players[Index].TeamID;
    }
    return 255;
    //return ReturnValue;    
}

function int GetTeamScore(int TeamID)
{
    local int Index;

    Index = Teams.Find('TeamID', TeamID);    
    // End:0x63
    if(Index != -1)
    {
        return Teams[Index].TeamScore;
    }
    return 0;
    //return ReturnValue;    
}

function string GetTeamPawnClassName(int TeamID)
{
    local int Index;

    Index = Teams.Find('TeamID', TeamID);    
    // End:0x63
    if(Index != -1)
    {
        return Teams[Index].PawnClassName;
    }
    return "";
    //return ReturnValue;    
}

function UpdateGRI(AdvGRI GRI)
{
    GRI.GoalScore = GameData.GoalScore;
    GRI.TimeLimit = GameData.TimeLimit;
    GRI.RoundsToWin = GameData.RoundsToWin;
    GRI.ScoreForWin = GameData.ScoreForWin;
    GRI.XPForWin = GameData.XPForWin;
    GRI.RespawnTime = GameData.RespawnTime;
    GRI.bRealism = GameData.bRealism;
    GRI.bKillingSpree = GameData.bKillingSpree;
    GRI.bOracle = GameData.bOracle;
    GRI.bTraps = GameData.bTraps;
    GRI.bTeamDamage = GameData.bTeamDamage;
    GRI.MapsList = GameData.MapsList;
    //return;    
}

function UpdateGameSettings(OnlineGameSettings GameSettings)
{
    //return;    
}

function UpdateTeamData(AdvGRI GRI)
{
    local int TeamIndex;

    TeamIndex = 0;
    J0x0B:

    // End:0x99 [Loop If]
    if(TeamIndex < GRI.Teams.Length)
    {
        GRI.Teams[TeamIndex].Score = float(GetTeamScore(TeamIndex));
        TeamIndex++;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

function string GetGameDataAsURL()
{
    local string URL;

    URL = "?GoalScore=" $ string(GameData.GoalScore);    
    URL $= ("?TimeLimit=" $ string(GameData.TimeLimit));    
    URL $= ("?RoundsToWin=" $ string(GameData.RoundsToWin));    
    URL $= ("?ScoreForWin=" $ string(GameData.ScoreForWin));    
    URL $= ("?XPForWin=" $ string(GameData.XPForWin));    
    URL $= ("?RespawnTime=" $ string(GameData.RespawnTime));    
    URL $= ("?bRealism=" $ string(GameData.bRealism));    
    URL $= ("?bKillingSpree=" $ string(GameData.bKillingSpree));    
    URL $= ("?bOracle=" $ string(GameData.bOracle));    
    URL $= ("?bTraps=" $ string(GameData.bTraps));    
    URL $= ("?bTeamDamage=" $ string(GameData.bTeamDamage));    
    URL $= ("?MapsList=" $ GameData.MapsList);
    return URL;
    //return ReturnValue;    
}

function ResetForNewMatch()
{
    local int PlayerIdx, TeamIdx;

    bPreviousMatchEnded = true;
    PlayerIdx = 0;
    J0x17:

    // End:0x68F [Loop If]
    if(PlayerIdx < Players.Length)
    {
        Players[PlayerIdx].Score = 0.0000000;
        Players[PlayerIdx].Deaths = 0;
        Players[PlayerIdx].Kills = 0;
        Players[PlayerIdx].Score_Kills = 0;
        Players[PlayerIdx].Score_Takedowns = 0;
        Players[PlayerIdx].Score_Revives = 0;
        Players[PlayerIdx].Score_Assists = 0;
        Players[PlayerIdx].Score_GameSpecific1 = 0;
        Players[PlayerIdx].Score_GameSpecific2 = 0;
        Players[PlayerIdx].Score_GameSpecific3 = 0;
        Players[PlayerIdx].Score_GameSpecific4 = 0;
        Players[PlayerIdx].TotalTimeInCover = 0.0000000;
        Players[PlayerIdx].KillStreak = 0;
        Players[PlayerIdx].MaxKillStreak = 0;
        Players[PlayerIdx].NumFirstKills = 0;
        Players[PlayerIdx].NumLastKills = 0;
        Players[PlayerIdx].NumExecutions = 0;
        Players[PlayerIdx].HeadshotHatTrick = 0;
        Players[PlayerIdx].NumHeadshots = 0;
        Players[PlayerIdx].NumTimesHeadshot = 0;
        Players[PlayerIdx].NumTimesRevived = 0;
        Players[PlayerIdx].NumSpottingKills = 0;
        Players[PlayerIdx].TotalTimeDBNO = 0.0000000;
        Players[PlayerIdx].DamageTaken = 0.0000000;
        Players[PlayerIdx].NumMeleeHits = 0;
        Players[PlayerIdx].NumBlindfireKills = 0;
        Players[PlayerIdx].NumGrenadeKills = 0;
        Players[PlayerIdx].NumPistolKills = 0;
        Players[PlayerIdx].NumChainsawsInARow = 0;
        Players[PlayerIdx].NumRetroChargesInARow = 0;
        Players[PlayerIdx].NumPerfectReloads = 0;
        Players[PlayerIdx].NumRoundsPlayed = 0;
        Players[PlayerIdx].bWasFemaleThisMatch = false;
        Players[PlayerIdx].KillsAsLeader = 0;
        Players[PlayerIdx].LeaderSaves = 0;
        Players[PlayerIdx].NumTokens = 0;
        Players[PlayerIdx].WavePointsSpent = 0;
        Players[PlayerIdx].bHasFailedAWave = false;
        Players[PlayerIdx].MoneyGiven = 0;
        Players[PlayerIdx].CashSpent = 0;
        PlayerIdx++;
        // [Loop Continue]
        goto J0x17;
    }
    TeamIdx = 0;
    J0x69A:

    // End:0x6E8 [Loop If]
    if(TeamIdx < Teams.Length)
    {
        Teams[TeamIdx].TeamScore = 0;
        TeamIdx++;
        // [Loop Continue]
        goto J0x69A;
    }
    //return;    
}
