class R6SBActorRapelRope extends R6SBActor
    native
    notplaceable
    hidecategories(lighting,Object);

event ReplicateBulletHit(Vector vLocalImpulse, int Hit0, int Hit1)
{
    return;
}

// Export UR6SBActorRapelRope::execInit(FFrame&, void* const)
native final function Init(R6InteractiveRope Rope);

defaultproperties
{
    // Reference: R6SBComponentRapelRope'Default__R6SBActorRapelRope.R6SBComponentRapelRope0'
    begin object name="R6SBComponentRapelRope0" class=Class'R6SBComponentRapelRope'
    end object
    m_SoftBody=R6SBComponentRapelRope0
    bMovable=true
    bBlockActors=false
    // Reference: SpriteComponent'Default__R6SBActorRapelRope.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__R6SBActor.Sprite'
    begin object name="Sprite"
    end object
    Components[0]=Sprite
    Components[1]=R6SBComponentRapelRope0
    CollisionComponent=R6SBComponentRapelRope0
}