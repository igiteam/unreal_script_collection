class AdvNavPOI extends EvilNavPoint
    hidecategories(Navigation,Object);

var() Actor LookAt;
var() float ExploreDuration;
var() bool bStayAtPoint;

defaultproperties
{
    ExploreDuration=5.0000000
    // Reference: EvilCoverRadiusComponent'Default__AdvNavPOI.CoverRadiusComponent0'
    begin object name=CoverRadiusComponent0
        ReplacementPrimitive=none
    end object
    CoverRadiusComponent=CoverRadiusComponent0
    // Reference: CylinderComponent'Default__AdvNavPOI.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    Components[0]=CollisionCylinder
    Components[1]=none
    Components[2]=none
    Components[3]=none
    Components[4]=CoverRadiusComponent0
    CollisionComponent=CollisionCylinder
}