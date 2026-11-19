class TurokTutorialJump extends TurokTutorialAction
    native
    notplaceable
    hidecategories(Navigation);

// Export UTurokTutorialJump::execIsFinished(FFrame&, void* const)
native function bool IsFinished();

defaultproperties
{
    mActivationMessageHash=-2007310178
    mButtonImagePS3=Texture2D'TurokControllerButtons.PS3_X_0_HD'
    mButtonImageXBox360=Texture2D'TurokControllerButtons.HUD_360_A'
}