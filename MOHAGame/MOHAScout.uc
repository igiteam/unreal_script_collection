class MOHAScout extends Scout
    transient
    native
    config(Game)
    hidecategories(Navigation);

defaultproperties
{
    DefaultReachSpecClass=Class'MOHAReachSpec'
    // Reference: CylinderComponent'Default__MOHAScout.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    CollisionComponent=CollisionCylinder
}