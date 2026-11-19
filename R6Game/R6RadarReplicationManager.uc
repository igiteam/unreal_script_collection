class R6RadarReplicationManager extends Actor
    native
    nativereplication
    notplaceable
    hidecategories(lighting);

struct MotionSensorInfo
{
    var Actor m_pMotionSensor;
    var Actor m_pActorDetected;
    var Vector m_vLoc;
    var int m_iRotation;
    var int m_iID;
    var float m_fAliveTick;

    structdefaultproperties
    {
        m_pMotionSensor=none
        m_pActorDetected=none
        m_vLoc=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_iRotation=0
        m_iID=0
        m_fAliveTick=0.0000000
    }
};

struct PulseSensorInfo
{
    var Actor m_pSensor;
    var float m_fTime;
    var Actor m_pPawn;
    var int m_iRotation;
    var Vector m_vLocation;

    structdefaultproperties
    {
        m_pSensor=none
        m_fTime=0.0000000
        m_pPawn=none
        m_iRotation=0
        m_vLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

var array<R6RadarReplicationInfo> m_arrRadarInfo;
var int m_iIdCount;
var array<MotionSensorInfo> m_arrMotionSensorInfo;
var array<MotionSensorRepInfo> m_arrMotionSensorRepInfo;
var array<PulseSensorInfo> m_arrPulseSensorInfo;
var Actor m_pWaypointActor;
var float m_fRadarJamTime;
var bool m_bUpdateJamTime;
var R6PlayerController m_pPC;
var Vector m_vWaypointLoc;
var SoundCue m_RadarJamNoiseSound;
var SoundCue m_RadarJamNoiseStopSound;

replication
{
    // Pos:0x000
    if(bNetInitial && int(Role) == int(ROLE_Authority))
        m_pPC;

    // Pos:0x018
    if((bNetDirty && m_bUpdateJamTime) && int(Role) == int(ROLE_Authority))
        m_fRadarJamTime;

    // Pos:0x03B
    if(bNetDirty && int(Role) == int(ROLE_Authority))
        m_vWaypointLoc;
}

simulated function Init(R6PlayerController pPC)
{
    m_pPC = pPC;
    return;
}

function Reset()
{
    local Vector vTmp;

    // End:0x56
    if(((m_fRadarJamTime > 0.0000000) && m_pPC != none) && m_pPC.Pawn != none)
    {
        m_pPC.Pawn.PlaySound(m_RadarJamNoiseStopSound, 4, true, true, true);
    }
    m_fRadarJamTime = 0.0000000;
    m_bUpdateJamTime = false;
    m_pWaypointActor = none;
    m_vWaypointLoc = vTmp;
    return;
}

simulated function PostBeginPlay()
{
    local R6RadarReplicationInfo pRadarPRI;

    PostBeginPlay();
    // End:0x27
    foreach DynamicActors(Class'R6RadarReplicationInfo', pRadarPRI)
    {
        pRadarPRI.SubscribeInfo();        
    }    
    return;
}

simulated event AddRepInfo(R6RadarReplicationInfo PRepInfo)
{
    local int iIndex;

    iIndex = m_arrRadarInfo.Find(PRepInfo);
    // End:0x42
    if(iIndex == -1)
    {
        m_arrRadarInfo.Insert(m_arrRadarInfo.Length, 1);
        m_arrRadarInfo[m_arrRadarInfo.Length - 1] = PRepInfo;
    }
    return;
}

simulated event RemoveRepInfo(R6RadarReplicationInfo PRepInfo)
{
    local int iIndex;

    iIndex = m_arrRadarInfo.Find(PRepInfo);
    // End:0x2C
    if(iIndex != -1)
    {
        m_arrRadarInfo.Remove(iIndex, 1);
    }
    return;
}

event AddRadarJamEffect(float fEffectTime)
{
    // End:0x6A
    if(fEffectTime > m_fRadarJamTime)
    {
        // End:0x57
        if((m_fRadarJamTime == 0.0000000) && m_pPC.LocalPlayerController())
        {
            m_pPC.Pawn.PlaySound(m_RadarJamNoiseSound, 4, true, true, true);
        }
        m_fRadarJamTime = fEffectTime;
        m_bUpdateJamTime = true;
    }
    return;
}

simulated event AddPulseDetection(Actor pSensor, Actor pPawn, float fTime)
{
    local int iIndex;

    iIndex = 0;
    J0x07:

    // End:0x3E [Loop If]
    if(iIndex < m_arrPulseSensorInfo.Length)
    {
        // End:0x34
        if(m_arrPulseSensorInfo[iIndex].m_pPawn == pPawn)
        {
            // [Explicit Break]
            goto J0x3E;
        }
        ++iIndex;
        // [Loop Continue]
        goto J0x07;
    }
    J0x3E:

    // End:0xE0
    if(iIndex == m_arrPulseSensorInfo.Length)
    {
        m_arrPulseSensorInfo.Insert(m_arrPulseSensorInfo.Length, 1);
        m_arrPulseSensorInfo[iIndex].m_pSensor = pSensor;
        m_arrPulseSensorInfo[iIndex].m_fTime = fTime;
        m_arrPulseSensorInfo[iIndex].m_pPawn = pPawn;
        m_arrPulseSensorInfo[iIndex].m_vLocation = pPawn.Location;
        m_arrPulseSensorInfo[iIndex].m_iRotation = pPawn.Rotation.Yaw;
    }
    return;
}

event SetWaypoint(Actor Waypoint)
{
    local Vector vTmp;

    m_pWaypointActor = Waypoint;
    // End:0x2D
    if(m_pWaypointActor != none)
    {
        m_vWaypointLoc = m_pWaypointActor.Location;        
    }
    else
    {
        m_vWaypointLoc = vTmp;
    }
    return;
}

// Export UR6RadarReplicationManager::execAddMotionSensorDetection(FFrame&, void* const)
native final function AddMotionSensorDetection(Actor pMotionSensor, Actor pActorDetected);

defaultproperties
{
    m_RadarJamNoiseSound=SoundCue'Dare.Player.Play_Multi_RadarJammer_NoizeSound'
    m_RadarJamNoiseStopSound=SoundCue'Dare.Player.Stop_Multi_RadarJammer_NoizeSound_Go'
    bHidden=true
    bOnlyRelevantToOwner=true
    bAlwaysRelevant=true
    bReplicateMovement=false
    bSkipActorPropertyReplication=true
    m_bDeleteOnReset=false
    Components=none
    RemoteRole=1
    NetUpdateFrequency=0.5000000
}