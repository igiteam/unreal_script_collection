class VolumePathNode extends PathNode
    native
    placeable
    hidecategories(lighting,lighting,LightColor,Force);

defaultproperties
{
    bNoAutoConnect=true
    bNotBased=true
    bFlyingPreferred=true
    bVehicleDestination=true
    // Reference: CylinderComponent'Default__VolumePathNode.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: CylinderComponent'Default__PathNode.CollisionCylinder'
    begin object name="CollisionCylinder"
        CollisionHeight=2000.0000000
        CollisionRadius=2000.0000000
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__VolumePathNode.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__PathNode.Sprite'
    begin object name="Sprite"
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__VolumePathNode.PathRenderer'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: PathRenderingComponent'Default__PathNode.PathRenderer'
    begin object name="PathRenderer"
    end object
    Components[2]=PathRenderer
    // Reference: ArrowComponent'Default__VolumePathNode.ArrowNav'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: ArrowComponent'Default__PathNode.ArrowNav'
    begin object name="ArrowNav"
    end object
    Components[3]=ArrowNav
    CollisionComponent=CollisionCylinder
}