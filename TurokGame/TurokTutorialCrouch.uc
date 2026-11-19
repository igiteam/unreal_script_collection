class TurokTutorialCrouch extends TurokTutorialAction
    native
    notplaceable
    hidecategories(Navigation);

// Export UTurokTutorialCrouch::execIsFinished(FFrame&, void* const)
native function bool IsFinished();

defaultproperties
{
    mActivationMessageHash=-1759205330
    mButtonImagePS3=Texture2D'TurokControllerButtons.PS3_Triangle_0_HD'
    mButtonImageXBox360=Texture2D'TurokControllerButtons.HUD_360_Y'
}