class R6TeamInfo extends TeamInfo
    native
    nativereplication
    hidecategories(lighting,Movement,Collision);

var int m_iMaxSize;
var int m_iKills;
var int m_iObjects;

// Export UR6TeamInfo::execInit(FFrame&, void* const)
native function Init(int iTeamID, int iTeamPlayersCount);

// Export UR6TeamInfo::execGetTeamName(FFrame&, void* const)
native function string GetTeamName();

// Export UR6TeamInfo::execOnRemoveFromTeam(FFrame&, void* const)
native function OnRemoveFromTeam(PlayerReplicationInfo pPlayer);

function ResetStats()
{
    Score = 0.0000000;
    m_iKills = 0;
    m_iObjects = 0;
    return;
}

function bool AddToTeam(Controller other)
{
    // End:0x11
    if(Size >= m_iMaxSize)
    {
        return false;
    }
    return AddToTeam(other);
    return;
}

function RemoveFromTeam(Controller other)
{
    RemoveFromTeam(other);
    // End:0x42
    if((other != none) && other.PlayerReplicationInfo != none)
    {
        OnRemoveFromTeam(other.PlayerReplicationInfo);
    }
    return;
}

defaultproperties
{
    TeamName="RAINBOW TEAM"
    m_bDeleteOnReset=false
}