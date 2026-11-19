class PKTeamInfo extends EvilTeamInfo
    hidecategories(Navigation,Movement,Collision);

var int DesiredTeamSize;
var const localized string TeamColorNames[9];

function bool AddToTeam(Controller Other)
{
    return super.AddToTeam(Other);
    //return ReturnValue;    
}

simulated function string GetHumanReadableName()
{
    // End:0xD3
    if(TeamName == default.TeamName)
    {
        // End:0x69
        if(TeamIndex == 0)
        {
            return Localize("PKGFxUI_Menu_MultiPlayerSettings", "RedTeam", "PKHDGame");            
        }
        else
        {
            // End:0xBC
            if(TeamIndex == 1)
            {
                return Localize("PKGFxUI_Menu_MultiPlayerSettings", "BlueTeam", "PKHDGame");                
            }
            else
            {
                return TeamName @ string(TeamIndex);
            }
        }
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
    // End:0x5B
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

function bool NeedsBotMoreThan(PKTeamInfo T)
{
    return (DesiredTeamSize - Size) > (T.DesiredTeamSize - T.Size);
    //return ReturnValue;    
}

defaultproperties
{
    DesiredTeamSize=8
}