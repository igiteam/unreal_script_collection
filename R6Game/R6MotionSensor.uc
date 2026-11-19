class R6MotionSensor extends R6Explosive
    native
    config(ExplosivesConfig)
    notplaceable
    hidecategories(lighting);

var R6LaserTripWire m_LaserTripWire;
var float m_fLaserLength;
var config float m_fLaserTimer;
var config float m_fLaserMaxLength;
var bool m_bLaserActive;
var bool m_bLaserDestroyed;
var float m_fLaserLastUpdate;
var SoundCue m_ActivationSound;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority))
        m_bLaserActive, m_bLaserDestroyed;
}

// Export UR6MotionSensor::execTurnLaserOn(FFrame&, void* const)
native final function TurnLaserOn();

event Landed(Vector HitNormal, Actor FloorActor, Vector vLocation)
{
    Landed(HitNormal, FloorActor, vLocation);
    // End:0x28
    if(Pawn(FloorActor) != none)
    {
        return;
    }
    AdjustToWall(HitNormal, FloorActor, vLocation);
    SetTimer(m_fLaserTimer, false, 'TurnLaserOn');
    return;
}

simulated event ExplodeR6Explosive()
{
    return;
}

event LaserTriggered(Actor pTriggerer)
{
    local R6PlayerController pPC;
    local R6PlayerPawn pPlayer;

    // End:0x1B
    if(int(WorldInfo.NetMode) == int(NM_Client))
    {
        return;
    }
    pPlayer = R6PlayerPawn(pTriggerer);
    // End:0xD9
    if(((pPlayer != none) && m_pPlacedBy != none) && pPlayer.Controller != none)
    {
        // End:0xD9
        if((WorldInfo.GRI != none) && !WorldInfo.GRI.OnSameTeam(m_pPlacedBy, pPlayer.Controller))
        {
            pPC = R6PlayerController(m_pPlacedBy);
            // End:0xD9
            if(pPC != none)
            {
                pPC.m_RadarReplicationManager.AddMotionSensorDetection(self, pTriggerer);
            }
        }
    }
    return;
}

defaultproperties
{
    m_fLaserTimer=3.0000000
    m_fLaserMaxLength=10000.0000000
    m_fLaserLastUpdate=0.5000000
    m_ActivationSound=SoundCue'Dare.Player.Play_Multi_MotionSensor_LaserActivationSound'
    // Reference: StaticMeshComponent'Default__R6MotionSensor.ExplosiveMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6Explosive.ExplosiveMesh'
    begin object name="ExplosiveMesh"
        StaticMesh=StaticMesh'RS5Weapons.Gadgets.Motion_Sensor'
    end object
    m_Mesh=ExplosiveMesh
    m_explosionParams=R6ExplosionParams'KellerExplosions.ExplosiveTripWire'
    m_SoundExplosionParams=R6SoundExplosionParams'RS5Sound.E_TripWireExplosion'
    // Reference: SpriteComponent'Default__R6MotionSensor.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__R6Explosive.Sprite'
    begin object name="Sprite"
    end object
    Components[0]=Sprite
    Components[1]=ExplosiveMesh
    CollisionComponent=ExplosiveMesh
}