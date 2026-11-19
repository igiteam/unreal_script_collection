class MOHACSASpawnable extends MOHACSA
    native
    hidecategories(Navigation);

defaultproperties
{
    // Reference: CylinderComponent'Default__MOHACSASpawnable.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__MOHACSASpawnable.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    bNoDelete=false
    CollisionComponent=CollisionCylinder
    CollisionType=0
}