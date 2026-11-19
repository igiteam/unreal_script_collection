class TurokDoorOpenAction extends TurokContextAction
    native
    notplaceable
    hidecategories(Navigation);

var @NULL mController;

// Export UTurokDoorOpenAction::execIsRequirementsMet(FFrame&, void* const)
native function bool IsRequirementsMet();

// Export UTurokDoorOpenAction::execDrawHUD(FFrame&, void* const)
native simulated function DrawHUD(@NULL HUD);

// Export UTurokDoorOpenAction::execDrawActivationMessage(FFrame&, void* const)
native simulated function DrawActivationMessage(@NULL HUD);

defaultproperties
{
    mActivationMessageHash=1592820158
    mButtonImagePS3=Texture2D'TurokControllerButtons.PS3_Circle_0_HD'
    mButtonImageXBox360=Texture2D'TurokControllerButtons.HUD_360_B'
}