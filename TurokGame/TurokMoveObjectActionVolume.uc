class TurokMoveObjectActionVolume extends TurokActionVolume
    native
    hidecategories(Navigation,Object,Movement,Display)
    autoexpandcategories(Multiplayer,ActionVolume);

// Export UTurokMoveObjectActionVolume::execGetActionObject(FFrame&, void* const)
native function @NULL GetActionObject(@NULL Controller);

defaultproperties
{
    // Reference: DrawSphereComponent'Default__TurokMoveObjectActionVolume.LookDirMarker'
    begin object name=LookDirMarker
    end object
    mLookDirMarker=LookDirMarker
    mMaxAllowedLookDirOffset=40.0000000
    // Reference: BrushComponent'Default__TurokMoveObjectActionVolume.BrushComponent0'
    begin object name=BrushComponent0
    end object
    BrushComponent=BrushComponent0
    Components[0]=BrushComponent0
    Components[1]=LookDirMarker
    CollisionComponent=BrushComponent0
}