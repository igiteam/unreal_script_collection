class R6ProjectileFlashbangGrenade extends R6ProjectileGrenade
    native
    config(ProjectilesConfig)
    hidecategories(lighting);

defaultproperties
{
    m_explosionParams=R6ExplosionParams'KellerExplosions.GrenadeFlashbang'
    m_SoundExplosionParams=R6SoundExplosionParams'RS5Sound.E_M84_FlashbangExplosion'
    m_fPlayerDelayExplosion=1.5000000
    m_fTerroDelayExplosion=2.5000000
    m_fDampFactor=0.3000000
    m_fDampFactorParallel=0.5000000
    // Reference: StaticMeshComponent'Default__R6ProjectileFlashbangGrenade.ProjectileMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6ProjectileGrenade.ProjectileMesh'
    begin object name="ProjectileMesh"
        StaticMesh=StaticMesh'RS5Weapons.Gadgets.Flashbang_Grenade'
    end object
    m_Mesh=ProjectileMesh
    m_projectileParams=R6ProjectileParams'ProjectileParams.FlashbangProjectileParams'
    Speed=1300.0000000
    MyDamageType=Class'R6DmgTypeFlashbangGrenade'
    // Reference: SpriteComponent'Default__R6ProjectileFlashbangGrenade.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__R6ProjectileGrenade.Sprite'
    begin object name="Sprite"
    end object
    Components[0]=Sprite
    // Reference: CylinderComponent'Default__R6ProjectileFlashbangGrenade.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: CylinderComponent'Default__R6ProjectileGrenade.CollisionCylinder'
    begin object name="CollisionCylinder"
    end object
    Components[1]=CollisionCylinder
    Components[2]=ProjectileMesh
}