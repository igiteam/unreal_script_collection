class TurokVehicleActionVolume extends TurokActionVolume
    native
    hidecategories(Navigation,Object,Movement,Display)
    autoexpandcategories(Multiplayer,ActionVolume);

var @NULL mVehicle;
var(EntryType) bool mIsTurret;

// Export UTurokVehicleActionVolume::execGetActionObject(FFrame&, void* const)
native function @NULL GetActionObject(@NULL Controller);

defaultproperties
{
    // Reference: DrawSphereComponent'Default__TurokVehicleActionVolume.LookDirMarker'
    begin object name=LookDirMarker
    end object
    mLookDirMarker=LookDirMarker
    mMaxAllowedLookDirOffset=40.0000000
    // Reference: BrushComponent'Default__TurokVehicleActionVolume.BrushComponent0'
    begin object name=BrushComponent0
    end object
    BrushComponent=BrushComponent0
    Components[0]=BrushComponent0
    Components[1]=LookDirMarker
    CollisionComponent=BrushComponent0
}