class PanLeaderboardWriteBase extends OnlineStatsWrite
    native;

const PROPERTY_DEATHS = 0x1000000C;
const PROPERTY_GAMERSCORE = 0x1000000D;
const PROPERTY_GAMESLOST = 0x1000000E;
const PROPERTY_GAMESWON = 0x1000000F;
const PROPERTY_KILLCOUNT = 0x10000010;
const PROPERTY_PANGAMERATING = 0x20000004;

function SetKills(int Kills)
{
    SetIntStat(268435472, Kills);
    //return;    
}

function SetDeaths(int Deaths)
{
    SetIntStat(268435468, Deaths);
    //return;    
}

function SetMatchesWon(int Value)
{
    SetIntStat(268435471, Value);
    //return;    
}

function SetMatchesLost(int Value)
{
    SetIntStat(268435470, Value);
    //return;    
}

// Export UPanLeaderboardWriteBase::execUpdateFromPRI(FFrame&, void* const)
native function UpdateFromPRI(SPPlayerReplicationInfo PRI);

defaultproperties
{
    Properties=/* Array type was not detected. */
    RatingId=536870916
}