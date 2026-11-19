class UTLeaderboardRead extends OnlineStatsRead;

final function int GetScore(UniqueNetId Player)
{
    local int ReturnVal;

    GetIntStatValueForPlayer(Player, 0, ReturnVal);
    return ReturnVal;
    //return ReturnValue;    
}

defaultproperties
{
    ColumnIds=/* Array type was not detected. */
    ColumnMappings=/* Array type was not detected. */
    ViewName="Leaderboard"
}