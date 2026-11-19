class R6SBActorRapelRopeChopper extends R6SBActorRapelRope
    native
    notplaceable
    hidecategories(lighting,Object,Object);

defaultproperties
{
    // Reference: R6SBComponentRapelRope'Default__R6SBActorRapelRopeChopper.R6SBComponentRapelRope0'
    // Archetype: R6SBComponentRapelRope'Default__R6SBActorRapelRope.R6SBComponentRapelRope0'
    begin object name="R6SBComponentRapelRope0"
    end object
    m_SoftBody=R6SBComponentRapelRope0
    // Reference: SpriteComponent'Default__R6SBActorRapelRopeChopper.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__R6SBActorRapelRope.Sprite'
    begin object name="Sprite"
    end object
    Components[0]=Sprite
    Components[1]=R6SBComponentRapelRope0
    CollisionComponent=R6SBComponentRapelRope0
}