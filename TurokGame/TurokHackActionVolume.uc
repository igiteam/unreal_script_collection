class TurokHackActionVolume extends TurokActionVolume
    native
    hidecategories(Navigation,Object,Movement,Display)
    autoexpandcategories(Multiplayer,ActionVolume);

var(Hacking) @NULL mTerminal;

// Export UTurokHackActionVolume::execGetActionObject(FFrame&, void* const)
native function @NULL GetActionObject(@NULL Controller);

// Export UTurokHackActionVolume::execIsValidActionController(FFrame&, void* const)
native function bool IsValidActionController(@NULL Controller);

// Export UTurokHackActionVolume::execIsLookingRightDirection(FFrame&, void* const)
native function bool IsLookingRightDirection(@NULL Controller);

defaultproperties
{
    // Reference: DrawSphereComponent'Default__TurokHackActionVolume.LookDirMarker'
    begin object name=LookDirMarker
    end object
    mLookDirMarker=LookDirMarker
    // Reference: BrushComponent'Default__TurokHackActionVolume.BrushComponent0'
    begin object name=BrushComponent0
    end object
    BrushComponent=BrushComponent0
    Components[0]=BrushComponent0
    Components[1]=LookDirMarker
    CollisionComponent=BrushComponent0
}