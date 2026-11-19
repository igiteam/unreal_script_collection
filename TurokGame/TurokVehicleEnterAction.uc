class TurokVehicleEnterAction extends TurokContextAction
    native
    notplaceable
    hidecategories(Navigation);

var @NULL mController;

// Export UTurokVehicleEnterAction::execIsRequirementsMet(FFrame&, void* const)
native function bool IsRequirementsMet();

// Export UTurokVehicleEnterAction::execDrawHUD(FFrame&, void* const)
native simulated function DrawHUD(@NULL HUD);

// Export UTurokVehicleEnterAction::execDrawActivationMessage(FFrame&, void* const)
native simulated function DrawActivationMessage(@NULL HUD);

defaultproperties
{
    mActivationMessageHash=-423610178
    mButtonImagePS3=Texture2D'TurokControllerButtons.PS3_Circle_0_HD'
    mButtonImageXBox360=Texture2D'TurokControllerButtons.HUD_360_B'
}