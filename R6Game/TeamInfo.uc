class TeamInfo extends ReplicationInfo
    native
    nativereplication
    notplaceable
    hidecategories(lighting,Movement,Collision);

var const localized string TeamName;
var int Size;
var float Score;
var int TeamIndex;
var Color TeamColor;

replication
{
    // Pos:0x000
    if(bNetDirty && int(Role) == int(ROLE_Authority))
        Score;

    // Pos:0x018
    if(bNetInitial && int(Role) == int(ROLE_Authority))
        TeamIndex, TeamName;
}

function bool AddToTeam(Controller other)
{
    local Controller P;
    local bool bSuccess;

    // End:0x0D
    if(other == none)
    {
        return false;
    }
    // End:0x1F
    if(MessagingSpectator(other) != none)
    {
        return false;
    }
    Size++;
    other.PlayerReplicationInfo.Team = self;
    other.PlayerReplicationInfo.NetUpdateTime = WorldInfo.TimeSeconds - float(1);
    bSuccess = false;
    // End:0xA1
    if(other.IsA('PlayerController'))
    {
        other.PlayerReplicationInfo.TeamID = 0;        
    }
    else
    {
        other.PlayerReplicationInfo.TeamID = 1;
    }
    J0xBA:

    // End:0x1C3 [Loop If]
    if(!bSuccess)
    {
        bSuccess = true;
        // End:0x182
        foreach WorldInfo.AllControllers(Class'Controller', P)
        {
            // End:0x181
            if(((P.bIsPlayer && P != other) && P.PlayerReplicationInfo.Team == other.PlayerReplicationInfo.Team) && P.PlayerReplicationInfo.TeamID == other.PlayerReplicationInfo.TeamID)
            {
                bSuccess = false;
                // End:0x182
                break;
            }            
        }        
        // End:0x1C0
        if(!bSuccess)
        {
            other.PlayerReplicationInfo.TeamID = other.PlayerReplicationInfo.TeamID + 1;
        }
        // [Loop Continue]
        goto J0xBA;
    }
    return true;
    return;
}

function RemoveFromTeam(Controller other)
{
    Size--;
    return;
}

simulated function string GetHumanReadableName()
{
    return TeamName;
    return;
}

simulated function Color GetHUDColor()
{
    return TeamColor;
    return;
}

function Color GetTextColor()
{
    return TeamColor;
    return;
}

function bool ClaimMoveGoal(NavigationPoint Dest, Controller Bot)
{
    return true;
    return;
}

function bool ReleaseMoveGoal(NavigationPoint Dest, Controller Bot)
{
    return;
}

function bool IsUniqueFinalGoal(NavigationPoint Dest, Controller Bot)
{
    return true;
    return;
}

defaultproperties
{
    TeamName="Team"
    TeamColor=(R=255,G=64,B=64,A=255)
    TickGroup=1
    NetUpdateFrequency=2.0000000
}