class AdvFinisherBlockingVolume extends Volume
    hidecategories(Navigation,Object,Movement,Display,Volume);

var() bool bEnabled;

defaultproperties
{
    bEnabled=true
    BrushColor=(R=255,G=0,B=255,A=255)
    bColored=true
    // Reference: BrushComponent'Default__AdvFinisherBlockingVolume.BrushComponent0'
    begin object name=BrushComponent0
        ReplacementPrimitive=none
    end object
    BrushComponent=BrushComponent0
    Components[0]=BrushComponent0
    CollisionComponent=BrushComponent0
}