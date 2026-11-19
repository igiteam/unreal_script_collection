class PathNode extends NavigationPoint
    native
    placeable
    hidecategories(lighting,lighting,LightColor,Force);

defaultproperties
{
    bStatic=false
    // Reference: SpriteComponent'Default__PathNode.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__NavigationPoint.Sprite'
    begin object name="Sprite"
        Sprite=Texture2D'EngineResources.S_Pickup'
    end object
    Components[0]=Sprite
    // Reference: CylinderComponent'Default__PathNode.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: CylinderComponent'Default__NavigationPoint.CollisionCylinder'
    begin object name="CollisionCylinder"
    end object
    Components[1]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__PathNode.PathRenderer'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: PathRenderingComponent'Default__NavigationPoint.PathRenderer'
    begin object name="PathRenderer"
    end object
    Components[2]=PathRenderer
    // Reference: ArrowComponent'Default__PathNode.ArrowNav'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="ArrowNav" class=Class'ArrowComponent'
    end object
    Components[3]=ArrowNav
}