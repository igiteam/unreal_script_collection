class TurokScout extends Scout
    transient
    native
    config(Game)
    hidecategories(Navigation);

var private transient bool mMapCheck;

defaultproperties
{
    PathSizes=/* Array type was not detected. */
    // Reference: CylinderComponent'Default__TurokScout.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    mDefaultTraceSourceFlags=16384
    Components[0]=CollisionCylinder
    CollisionComponent=CollisionCylinder
}