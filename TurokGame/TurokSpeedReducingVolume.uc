class TurokSpeedReducingVolume extends PhysicsVolume
    native
    hidecategories(Navigation,Object,Movement,Display);

var() float mSpeedFraction;

defaultproperties
{
    mSpeedFraction=0.7500000
    // Reference: BrushComponent'Default__TurokSpeedReducingVolume.BrushComponent0'
    begin object name=BrushComponent0
    end object
    BrushComponent=BrushComponent0
    Components[0]=BrushComponent0
    CollisionComponent=BrushComponent0
}