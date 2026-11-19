class PKNavPoint extends EvilNavPoint
    hidecategories(Navigation,Object);

defaultproperties
{
    // Reference: CylinderComponent'Default__PKNavPoint.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'EvilGame.Default__EvilNavPoint.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    Components[0]=CollisionCylinder
    Components[1]=none
    Components[2]=none
    CollisionComponent=CollisionCylinder
}