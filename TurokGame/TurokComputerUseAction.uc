class TurokComputerUseAction extends TurokContextAction
    native
    notplaceable
    hidecategories(Navigation);

var @NULL mController;

// Export UTurokComputerUseAction::execIsRequirementsMet(FFrame&, void* const)
native function bool IsRequirementsMet();

// Export UTurokComputerUseAction::execDrawHUD(FFrame&, void* const)
native simulated function DrawHUD(@NULL HUD);

// Export UTurokComputerUseAction::execDrawActivationMessage(FFrame&, void* const)
native simulated function DrawActivationMessage(@NULL HUD);

defaultproperties
{
    mActivationMessageHash=-1419396269
    mButtonImagePS3=Texture2D'TurokControllerButtons.PS3_Circle_0_HD'
    mButtonImageXBox360=Texture2D'TurokControllerButtons.HUD_360_B'
}