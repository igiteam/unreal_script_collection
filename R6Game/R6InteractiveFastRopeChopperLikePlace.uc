class R6InteractiveFastRopeChopperLikePlace extends R6InteractiveFastRopePlace
    native
    config(Game)
    placeable
    hidecategories(lighting);

defaultproperties
{
    m_bChopperLike=true
    // Reference: SpriteComponent'Default__R6InteractiveFastRopeChopperLikePlace.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__R6InteractiveFastRopePlace.Sprite'
    begin object name="Sprite"
    end object
    Components[0]=Sprite
    // Reference: StaticMeshComponent'Default__R6InteractiveFastRopeChopperLikePlace.InteractiveActorMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6InteractiveFastRopePlace.InteractiveActorMesh'
    begin object name="InteractiveActorMesh"
    end object
    Components[1]=InteractiveActorMesh
    // Reference: ArrowComponent'Default__R6InteractiveFastRopeChopperLikePlace.Arrow'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: ArrowComponent'Default__R6InteractiveFastRopePlace.Arrow'
    begin object name="Arrow"
    end object
    Components[2]=Arrow
    CollisionComponent=none
}