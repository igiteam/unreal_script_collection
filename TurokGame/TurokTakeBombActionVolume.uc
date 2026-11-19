class TurokTakeBombActionVolume extends TurokActionVolume
    native
    hidecategories(Navigation,Object,Movement,Display)
    autoexpandcategories(Multiplayer,ActionVolume);

var(ActionVolume) @NULL mBombDispenser;

// Export UTurokTakeBombActionVolume::execGetActionObject(FFrame&, void* const)
native function @NULL GetActionObject(@NULL Controller);

defaultproperties
{
    // Reference: DrawSphereComponent'Default__TurokTakeBombActionVolume.LookDirMarker'
    begin object name=LookDirMarker
    end object
    mLookDirMarker=LookDirMarker
    // Reference: BrushComponent'Default__TurokTakeBombActionVolume.BrushComponent0'
    begin object name=BrushComponent0
    end object
    BrushComponent=BrushComponent0
    Components[0]=BrushComponent0
    Components[1]=LookDirMarker
    CollisionComponent=BrushComponent0
}