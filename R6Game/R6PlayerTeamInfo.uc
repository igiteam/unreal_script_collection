class R6PlayerTeamInfo extends ReplicationInfo
    native
    nativereplication
    hidecategories(lighting,Movement,Collision);

var R6TeamSpawnZone m_SpawnZone;

replication
{
    // Pos:0x000
    if(bNetDirty && int(Role) == int(ROLE_Authority))
        m_SpawnZone;
}

// Export UR6PlayerTeamInfo::execResetInfo(FFrame&, void* const)
native function ResetInfo();

defaultproperties
{
    m_bDeleteOnReset=false
    TickGroup=1
}