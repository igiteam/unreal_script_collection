class R6Waypoint extends Trigger
    native
    placeable
    hidecategories(lighting);

var() bool m_bIsEnabled;
var() bool m_bIsVisited;

defaultproperties
{
    m_bIsEnabled=true
    // Reference: CylinderComponent'Default__R6Waypoint.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: CylinderComponent'Default__Trigger.CollisionCylinder'
    begin object name="CollisionCylinder"
        CollisionHeight=100.0000000
        CollisionRadius=500.0000000
    end object
    CylinderComponent=CollisionCylinder
    m_bIgnoreForNavMesh=true
    // Reference: SpriteComponent'Default__R6Waypoint.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__Trigger.Sprite'
    begin object name="Sprite"
        Sprite=Texture2D'AIIcons.Waypoint_Pic'
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    CollisionComponent=CollisionCylinder
}