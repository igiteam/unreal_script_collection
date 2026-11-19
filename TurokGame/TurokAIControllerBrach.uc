class TurokAIControllerBrach extends TurokAIControllerHerbivore
    native
    hidecategories(Navigation);

defaultproperties
{
    mFleeMessage="BRACH_FleeEnemy"
    mFoodMessage="BRACH_FoundFood"
    // Reference: SpriteComponent'Default__TurokAIControllerBrach.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
}