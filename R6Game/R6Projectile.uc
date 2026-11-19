class R6Projectile extends Projectile
    abstract
    native
    config(ProjectilesConfig)
    hidecategories(lighting);

var export editinline MeshComponent m_Mesh;
var R6ProjectileParams m_projectileParams;
var Emitter m_particleEmitter;
var R6RadarBombRepInfo m_RadarBombRepInfo;

// Export UR6Projectile::execGetEffectRotation(FFrame&, void* const)
native function Rotator GetEffectRotation(Vector vDirection);

event bool IsVisibleByBombSniffer()
{
    return false;
    return;
}

simulated function PostBeginPlay()
{
    // End:0x0D
    if(m_projectileParams == none)
    {
        return;
    }
    // End:0x64
    if(m_projectileParams.m_SpecialEffectParticleSystem != none)
    {
        m_particleEmitter = __NFUN_278__(Class'Engine.Emitter',,, Location, GetEffectRotation(Vector(Rotation)));
        m_particleEmitter.SetTemplate(m_projectileParams.m_SpecialEffectParticleSystem, true);
    }
    // End:0x93
    if(m_projectileParams.m_SpecialEffectSound != none)
    {
        PlaySound(m_projectileParams.m_SpecialEffectSound, 4, true,,, true);
    }
    // End:0x10E
    if(IsVisibleByBombSniffer())
    {
        // End:0x10E
        if(GetGameManager().IsMultiplayer())
        {
            // End:0xCC
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

event Destroyed()
{
    // End:0x72
    if(IsVisibleByBombSniffer())
    {
        // End:0x72
        if(GetGameManager().IsMultiplayer())
        {
            // End:0x39
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

defaultproperties
{
    // Reference: StaticMeshComponent'Default__R6Projectile.ProjectileMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="ProjectileMesh" class=Class'Engine.StaticMeshComponent'
    end object
    m_Mesh=ProjectileMesh
    MaxSpeed=0.0000000
    MyDamageType=Class'Engine.R6DamageTypeExplosive'
    // Reference: CylinderComponent'Default__R6Projectile.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: CylinderComponent'Engine.Default__Projectile.CollisionCylinder'
    begin object name="CollisionCylinder"
        CollisionHeight=3.5000000
        CollisionRadius=3.5000000
    end object
    CylinderComponent=CollisionCylinder
    bIgnoreOutOfWorld=true
    bBounce=true
    // Reference: SpriteComponent'Default__R6Projectile.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Engine.Default__Projectile.Sprite'
    begin object name="Sprite"
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    Components[2]=ProjectileMesh
    LifeSpan=0.0000000
    CollisionComponent=CollisionCylinder
}