class R6RadarObjectiveRepInfo extends R6RadarReplicationInfo
    native
    notplaceable
    hidecategories(lighting);

var R6GameEnums.ETEAMIDENTITY m_eTeamNumber;
var R6Radar.ERadarIcon m_eObjectiveType;
var R6CarriedObject m_pCarriableActor;

replication
{
    // Pos:0x000
    if(bNetInitial && int(Role) == int(ROLE_Authority))
        m_eObjectiveType;

    // Pos:0x018
    if(bNetDirty && int(Role) == int(ROLE_Authority))
        m_eTeamNumber;
}

function Init(Actor pLinkedActor)
{
    m_pActor = pLinkedActor;
    // End:0xB4
    if(m_pActor != none)
    {
        m_vLocation = m_pActor.Location;
        m_byYaw = byte(m_pActor.Rotation.Yaw >> 8);
        NetUpdateTime = WorldInfo.TimeSeconds - float(1);
        m_vReplicatedLocation = m_vLocation;
        m_byReplicatedYaw = m_byYaw;
        m_eTeamNumber = m_pActor.GetTeamNum();
        m_eObjectiveType = m_pActor.GetRadarIcon();
        m_pCarriableActor = R6CarriedObject(m_pActor);
    }
    return;
}

function AssignTeam(R6GameEnums.ETEAMIDENTITY eNewTeam)
{
    m_eTeamNumber = eNewTeam;
    NetUpdateTime = WorldInfo.TimeSeconds - float(1);
    return;
}

function SetObjectiveType(R6Radar.ERadarIcon eNewType)
{
    m_eObjectiveType = eNewType;
    NetUpdateTime = WorldInfo.TimeSeconds - float(1);
    return;
}

simulated function byte GetTeamNum()
{
    return m_eTeamNumber;
    return;
}

defaultproperties
{
    m_eTeamNumber=2
    m_eObjectiveType=7
}