class R6RadarPawnRepInfo extends R6RadarReplicationInfo
    native
    nativereplication
    notplaceable
    hidecategories(lighting);

struct HeatDeviceSpottedInfo
{
    var R6Pawn pInstigator;
    var float fSpottedTimeLeft;

    structdefaultproperties
    {
        pInstigator=none
        fSpottedTimeLeft=0.0000000
    }
};

var R6Pawn m_pPawn;
var array<HeatDeviceSpottedInfo> m_arrHeatSpotInfo;
var bool m_bIncapacitated;
var bool m_bNeutral;
var bool m_bVIP;

replication
{
    // Pos:0x000
    if(bNetInitial && int(Role) == int(ROLE_Authority))
        m_bNeutral, m_bVIP, 
        m_pPawn;

    // Pos:0x018
    if((bNetDirty && m_bIncapacitated) && int(Role) == int(ROLE_Authority))
        m_bIncapacitated;
}

// Export UR6RadarPawnRepInfo::execDied(FFrame&, void* const)
native function Died();

function Init(Actor pLinkedActor)
{
    m_pActor = pLinkedActor;
    m_pPawn = R6Pawn(pLinkedActor);
    // End:0x55
    if((m_pPawn != none) && m_pPawn.PlayerReplicationInfo != none)
    {
        m_pPlayerRepInfo = R6PlayerReplicationInfo(m_pPawn.PlayerReplicationInfo);
    }
    return;
}

function UnInit()
{
    m_pPawn = none;
    m_pPlayerRepInfo = none;
    m_pActor = none;
    return;
}
