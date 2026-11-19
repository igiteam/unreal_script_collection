class R6Explosive extends Actor
    abstract
    native
    notplaceable
    hidecategories(lighting);

var export editinline MeshComponent m_Mesh;
var bool m_bExploded;
var Rotator m_rAdjustedRotation;
var Vector m_vAdjustedLocation;
var Vector m_vNormal;
var Actor m_pAdjustedOn;
var R6ExplosionParams m_explosionParams;
var R6SoundExplosionParams m_SoundExplosionParams;
var class<DamageType> m_damageType;
var R6GadgetExplosive m_pDetonator;
var R6RadarBombRepInfo m_RadarBombRepInfo;
var Controller m_pPlacedBy;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority))
        m_bExploded, m_pAdjustedOn, 
        m_pDetonator, m_rAdjustedRotation, 
        m_vAdjustedLocation, m_vNormal;
}

// Export UR6Explosive::execAdjustToWall(FFrame&, void* const)
native function AdjustToWall(Vector vHitNormal, Actor pWall, Vector vLocation);

// Export UR6Explosive::execBounce(FFrame&, void* const)
native final function Bounce(Vector vHitLocation, Vector vHitNormal);

simulated function PostBeginPlay()
{
    // End:0x7B
    if(IsExplosiveVisibleByBombSniffer())
    {
        // End:0x7B
        if(GetGameManager().IsMultiplayer())
        {
            // End:0x39
            if(int(WorldInfo.NetMode) == int(NM_Client))
            {
                return;
            }
            m_RadarBombRepInfo = __NFUN_278__(Class'R6RadarBombRepInfo');
            m_RadarBombRepInfo.Init(self);
            WorldInfo.m_ActorListManager.AddDetectableExplosives(m_RadarBombRepInfo);
        }
    }
    return;
}

simulated event Destroyed()
{
    // End:0x12
    if(!m_bExploded)
    {
        ResetDetonator();
    }
    // End:0x84
    if(IsExplosiveVisibleByBombSniffer())
    {
        // End:0x84
        if(GetGameManager().IsMultiplayer())
        {
            // End:0x4B
            if(int(WorldInfo.NetMode) == int(NM_Client))
            {
                return;
            }
            m_RadarBombRepInfo.UnInit();
            m_RadarBombRepInfo.Destroy();
            WorldInfo.m_ActorListManager.RemoveDetectableExplosives(m_RadarBombRepInfo);
        }
    }
    return;
}

simulated event ExplodeR6Explosive()
{
    local R6Explosion Explosion;

    m_bExploded = true;
    Explosion = __NFUN_278__(Class'Engine.R6Explosion',,, Location + (m_vNormal * 2.0000000));
    Explosion.Instigator = Instigator;
    Explosion.InitParams(m_explosionParams, m_vNormal, m_SoundExplosionParams, m_Mesh, m_damageType);
    Explosion.Explode(self);
    return;
}

event ResetDetonator()
{
    // End:0x1B
    if(m_pDetonator != none)
    {
        m_pDetonator.ExplosiveExploded();
    }
    return;
}

simulated function byte GetTeamNum()
{
    // End:0x1C
    if(m_pPlacedBy != none)
    {
        return m_pPlacedBy.GetTeamNum();
    }
    // End:0x38
    if(Instigator != none)
    {
        return Instigator.GetTeamNum();
    }
    return GetTeamNum();
    return;
}

event bool IsExplosiveVisibleByBombSniffer()
{
    return false;
    return;
}

defaultproperties
{
    // Reference: StaticMeshComponent'Default__R6Explosive.ExplosiveMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="ExplosiveMesh" class=Class'Engine.StaticMeshComponent'
    end object
    m_Mesh=ExplosiveMesh
    m_damageType=Class'Engine.R6DamageTypeExplosive'
    bReplicateInstigator=true
    bUpdateSimulatedPosition=true
    UsePawnLights=true
    bCollideActors=true
    // Reference: SpriteComponent'Default__R6Explosive.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Engine.Default__Actor.Sprite'
    begin object name="Sprite"
    end object
    Components[0]=Sprite
    Components[1]=ExplosiveMesh
    RemoteRole=1
    m_supportedExplosionEffects=/* Array type was not detected. */
    CollisionComponent=ExplosiveMesh
}