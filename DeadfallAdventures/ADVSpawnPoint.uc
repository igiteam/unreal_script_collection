class ADVSpawnPoint extends EvilSpawnPoint
    hidecategories(Navigation,Lighting,LightColor,Force);

defaultproperties
{
    // Reference: CylinderComponent'Default__ADVSpawnPoint.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Components[1]=none
    Components[2]=none
    CollisionComponent=CollisionCylinder
}