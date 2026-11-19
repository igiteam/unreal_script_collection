class TurokDoorActionVolume extends TurokActionVolume
    native
    hidecategories(Navigation,Object,Movement,Display)
    autoexpandcategories(Multiplayer,ActionVolume);

var @NULL mDoorActor;

// Export UTurokDoorActionVolume::execGetActionObject(FFrame&, void* const)
native function @NULL GetActionObject(@NULL Controller);

defaultproperties
{
    // Reference: DrawSphereComponent'Default__TurokDoorActionVolume.LookDirMarker'
    begin object name=LookDirMarker
    end object
    mLookDirMarker=LookDirMarker
    mMaxAllowedLookDirOffset=65.0000000
    mSetVolumeFlags=4
    // Reference: BrushComponent'Default__TurokDoorActionVolume.BrushComponent0'
    begin object name=BrushComponent0
    end object
    BrushComponent=BrushComponent0
    Components[0]=BrushComponent0
    Components[1]=LookDirMarker
    CollisionComponent=BrushComponent0
}