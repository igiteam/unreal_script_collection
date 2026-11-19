class TurokTakeBombAction extends TurokContextAction
    native
    notplaceable
    hidecategories(Navigation);

// Export UTurokTakeBombAction::execIsRequirementsMet(FFrame&, void* const)
native function bool IsRequirementsMet();

// Export UTurokTakeBombAction::execOnStart(FFrame&, void* const)
native function OnStart();

// Export UTurokTakeBombAction::execDrawHUD(FFrame&, void* const)
native simulated function DrawHUD(@NULL HUD);

defaultproperties
{
    mActivationMessageHash=-312249679
    mButtonImagePS3=Texture2D'TurokControllerButtons.PS3_Circle_0_HD'
    mButtonImageXBox360=Texture2D'TurokControllerButtons.HUD_360_B'
}