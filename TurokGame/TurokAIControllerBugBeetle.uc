class TurokAIControllerBugBeetle extends TurokAIControllerBugSoldier
    native
    hidecategories(Navigation);

// Export UTurokAIControllerBugBeetle::execCalculateTargetThreatValue(FFrame&, void* const)
native function float CalculateTargetThreatValue(@NULL TargetPawn, bool bCanSee, optional float noiseLevel);

defaultproperties
{
    // Reference: SpriteComponent'Default__TurokAIControllerBugBeetle.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
}