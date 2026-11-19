class R6RadarReplicationInfo extends Actor
    native
    nativereplication
    notplaceable
    hidecategories(lighting);

var Vector m_vLocation;
var byte m_byYaw;
var repnotify byte m_byReplicatedYaw;
var repnotify Vector m_vReplicatedLocation;
var float m_fAliveTick;
var R6PlayerReplicationInfo m_pPlayerRepInfo;
var float m_fTickUpdate;
var Actor m_pActor;

replication
{
    // Pos:0x000
    if(bNetDirty && int(Role) == int(ROLE_Authority))
        m_byReplicatedYaw, m_fAliveTick, 
        m_pActor, m_vReplicatedLocation;

    // Pos:0x018
    if(bNetInitial && int(Role) == int(ROLE_Authority))
        m_pPlayerRepInfo;
}

// Export UR6RadarReplicationInfo::execSubscribeInfo(FFrame&, void* const)
native final function SubscribeInfo();

// Export UR6RadarReplicationInfo::execUnsubscribeInfo(FFrame&, void* const)
native final function UnsubscribeInfo();

simulated event PostBeginPlay()
{
    PostBeginPlay();
    SubscribeInfo();
    return;
}

simulated event Destroyed()
{
    Destroyed();
    UnsubscribeInfo();
    return;
}

function Init(Actor pLinkedActor)
{
    return;
}

function UnInit()
{
    return;
}

// Export UR6RadarReplicationInfo::execGetRadarIconType(FFrame&, void* const)
native function R6Radar.ERadarIcon GetRadarIconType();

simulated function byte GetTeamNum()
{
    // End:0x1C
    if(m_pPlayerRepInfo != none)
    {
        return m_pPlayerRepInfo.GetTeamNum();
    }
    return byte(255);
    return;
}

defaultproperties
{
    bHidden=true
    bReplicateMovement=false
    bSkipActorPropertyReplication=true
    m_bDeleteOnReset=false
    Components=none
    RemoteRole=1
    NetUpdateFrequency=0.5000000
}