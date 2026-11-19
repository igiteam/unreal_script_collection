class AdvTeamInfo extends EvilTeamInfo
    hidecategories(Navigation,Movement,Collision);

var int DesiredTeamSize;
var const localized string TeamColorNames[9];
var int RoundScore;
var int CapturedFlags;
var AdvWayPointMPBase TeamWayPoint;

replication
{
    // Pos:0x000
    if(bNetDirty
        CapturedFlags, RoundScore, 
        TeamWayPoint;
}

simulated function string GetHumanReadableName()
{
    // End:0x52
    if(TeamName == default.TeamName)
    {
        // End:0x3B
        if(TeamIndex < 4)
        {
            return TeamColorNames[TeamIndex];
        }
        return TeamName @ string(TeamIndex);
    }
    return TeamName;
    //return ReturnValue;    
}

simulated function Color GetHUDColor()
{
    return BaseTeamColor[TeamIndex];
    //return ReturnValue;    
}

function Reset()
{
    super(Actor).Reset();
    CapturedFlags = 0;
    // End:0x66
    if(!EvilGame(WorldInfo.Game).bTeamScoreRounds)
    {
        Score = 0.0000000;
    }
    //return;    
}

function bool AllBotsSpawned()
{
    return false;
    //return ReturnValue;    
}

function bool NeedsBotMoreThan(AdvTeamInfo T)
{
    return (DesiredTeamSize - Size) > (T.DesiredTeamSize - T.Size);
    //return ReturnValue;    
}

defaultproperties
{
    DesiredTeamSize=8
}