class TurokCollectableVolume extends TurokActionVolume
    native
    hidecategories(Navigation,Object,Movement,Display)
    autoexpandcategories(Multiplayer,ActionVolume);

var bool mPickedUp;
var @NULL mOwnerActor;

// Export UTurokCollectableVolume::execGetActionObject(FFrame&, void* const)
native function @NULL GetActionObject(@NULL Controller);

defaultproperties
{
    // Reference: DrawSphereComponent'Default__TurokCollectableVolume.LookDirMarker'
    begin object name=LookDirMarker
    end object
    mLookDirMarker=LookDirMarker
    // Reference: BrushComponent'Default__TurokCollectableVolume.BrushComponent0'
    begin object name=BrushComponent0
    end object
    BrushComponent=BrushComponent0
    bLockLocation=true
    Components[0]=BrushComponent0
    Components[1]=LookDirMarker
    CollisionComponent=BrushComponent0
}