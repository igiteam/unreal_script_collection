class R6InteractiveFastRopePlace extends R6InteractiveRopePlace
    native
    config(Game)
    placeable
    hidecategories(lighting);

defaultproperties
{
    m_bFastRope=true
    m_ActorName="Fast Rope Place"
    m_eInteractDesc=10
    // Reference: SpriteComponent'Default__R6InteractiveFastRopePlace.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__R6InteractiveRopePlace.Sprite'
    begin object name="Sprite"
        HiddenEditor=false
    end object
    Components[0]=Sprite
    // Reference: StaticMeshComponent'Default__R6InteractiveFastRopePlace.InteractiveActorMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6InteractiveRopePlace.InteractiveActorMesh'
    begin object name="InteractiveActorMesh"
    end object
    Components[1]=InteractiveActorMesh
    // Reference: CylinderComponent'Default__R6InteractiveFastRopePlace.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: CylinderComponent'Default__R6InteractiveRopePlace.CollisionCylinder'
    begin object name="CollisionCylinder"
    end object
    Components[2]=CollisionCylinder
    // Reference: ArrowComponent'Default__R6InteractiveFastRopePlace.Arrow'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: ArrowComponent'Default__R6InteractiveRopePlace.Arrow'
    begin object name="Arrow"
    end object
    Components[3]=Arrow
}