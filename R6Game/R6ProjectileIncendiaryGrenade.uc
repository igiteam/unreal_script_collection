class R6ProjectileIncendiaryGrenade extends R6ProjectileGrenade
    native
    config(ProjectilesConfig)
    hidecategories(lighting);

defaultproperties
{
    m_explosionParams=R6ExplosionParams'KellerExplosions.GrenadeIncendiary'
    m_SoundExplosionParams=R6SoundExplosionParams'RS5Sound.E_IncendiaryExplosion'
    m_fPlayerDelayExplosion=1.5000000
    m_fTerroDelayExplosion=2.5000000
    m_fDampFactor=0.3500000
    m_fDampFactorParallel=0.6000000
    m_bExplodeOnFloor=true
    // Reference: StaticMeshComponent'Default__R6ProjectileIncendiaryGrenade.ProjectileMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6ProjectileGrenade.ProjectileMesh'
    begin object name="ProjectileMesh"
        StaticMesh=StaticMesh'RS5Weapons.Gadgets.Incendiary_Grenade'
    end object
    m_Mesh=ProjectileMesh
    m_projectileParams=R6ProjectileParams'ProjectileParams.IncendiaryProjectileParams'
    Speed=1300.0000000
    MyDamageType=Class'R6DmgTypeIncendiaryGrenade'
    // Reference: SpriteComponent'Default__R6ProjectileIncendiaryGrenade.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__R6ProjectileGrenade.Sprite'
    begin object name="Sprite"
    end object
    Components[0]=Sprite
    // Reference: CylinderComponent'Default__R6ProjectileIncendiaryGrenade.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: CylinderComponent'Default__R6ProjectileGrenade.CollisionCylinder'
    begin object name="CollisionCylinder"
    end object
    Components[1]=CollisionCylinder
    Components[2]=ProjectileMesh
}