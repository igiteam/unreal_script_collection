class AdvDynamicNavPoint extends EvilNavPoint
    hidecategories(Navigation,Object);

defaultproperties
{
    // Reference: EvilCoverRadiusComponent'Default__AdvDynamicNavPoint.CoverRadiusComponent0'
    begin object name=CoverRadiusComponent0
        ReplacementPrimitive=none
    end object
    CoverRadiusComponent=CoverRadiusComponent0
    // Reference: CylinderComponent'Default__AdvDynamicNavPoint.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    Components[0]=CollisionCylinder
    Components[1]=none
    Components[2]=none
    Components[3]=none
    Components[4]=CoverRadiusComponent0
    bStatic=false
    CollisionComponent=CollisionCylinder
}