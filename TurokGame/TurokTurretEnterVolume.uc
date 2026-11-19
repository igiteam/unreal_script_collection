class TurokTurretEnterVolume extends TurokActionVolume
    native
    hidecategories(Navigation,Object,Movement,Display)
    autoexpandcategories(Multiplayer,ActionVolume);

// Export UTurokTurretEnterVolume::execGetActionObject(FFrame&, void* const)
native function @NULL GetActionObject(@NULL Controller);

defaultproperties
{
    mLookDirType=0
    // Reference: DrawSphereComponent'Default__TurokTurretEnterVolume.LookDirMarker'
    begin object name=LookDirMarker
    end object
    mLookDirMarker=LookDirMarker
    // Reference: BrushComponent'Default__TurokTurretEnterVolume.BrushComponent0'
    begin object name=BrushComponent0
    end object
    BrushComponent=BrushComponent0
    Components[0]=BrushComponent0
    Components[1]=LookDirMarker
    CollisionComponent=BrushComponent0
}