class TurokBlockingVolume extends Volume
    native
    hidecategories(Navigation,Object,Movement,Display);

var() bool bClampFluid;

defaultproperties
{
    bClampFluid=true
    mSetVolumeFlags=4
    // Reference: BrushComponent'Default__TurokBlockingVolume.BrushComponent0'
    begin object name=BrushComponent0
        BlockActors=true
        BlockRigidBody=true
    end object
    BrushComponent=BrushComponent0
    bWorldGeometry=true
    bBlockActors=true
    Components[0]=BrushComponent0
    CollisionComponent=BrushComponent0
}