class TurokAIControllerBugScarab extends TurokAIControllerBugSoldier
    native
    hidecategories(Navigation);

// Export UTurokAIControllerBugScarab::execCalculateTargetThreatValue(FFrame&, void* const)
native function float CalculateTargetThreatValue(@NULL TargetPawn, bool bCanSee, optional float noiseLevel);

defaultproperties
{
    // Reference: SpriteComponent'Default__TurokAIControllerBugScarab.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
}