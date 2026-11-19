class R6ExplosiveDemolition extends R6Explosive
    native
    notplaceable
    hidecategories(lighting);

event Landed(Vector HitNormal, Actor FloorActor, Vector vLocation)
{
    Landed(HitNormal, FloorActor, vLocation);
    // End:0x28
    if(Pawn(FloorActor) != none)
    {
        return;
    }
    AdjustToWall(HitNormal, FloorActor, vLocation);
    return;
}

defaultproperties
{
    // Reference: StaticMeshComponent'Default__R6ExplosiveDemolition.ExplosiveMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6Explosive.ExplosiveMesh'
    begin object name="ExplosiveMesh"
        StaticMesh=StaticMesh'RS5Weapons.Gadgets.W_Gad_C4'
    end object
    m_Mesh=ExplosiveMesh
    m_explosionParams=R6ExplosionParams'KellerExplosions.ExplosiveC4'
    m_SoundExplosionParams=R6SoundExplosionParams'RS5Sound.E_M112_C4Explosion'
    m_damageType=Class'R6DamageTypeC4'
    bCollideWorld=true
    bBounce=true
    // Reference: SpriteComponent'Default__R6ExplosiveDemolition.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__R6Explosive.Sprite'
    begin object name="Sprite"
    end object
    Components[0]=Sprite
    Components[1]=ExplosiveMesh
    Physics=2
    CollisionComponent=ExplosiveMesh
}