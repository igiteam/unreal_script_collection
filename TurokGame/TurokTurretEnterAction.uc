class TurokTurretEnterAction extends TurokContextAction
    native
    notplaceable
    hidecategories(Navigation);

var @NULL mController;

// Export UTurokTurretEnterAction::execIsRequirementsMet(FFrame&, void* const)
native function bool IsRequirementsMet();

// Export UTurokTurretEnterAction::execDrawHUD(FFrame&, void* const)
native simulated function DrawHUD(@NULL HUD);

// Export UTurokTurretEnterAction::execDrawActivationMessage(FFrame&, void* const)
native simulated function DrawActivationMessage(@NULL HUD);

defaultproperties
{
    mActivationMessageHash=-1415076006
    mButtonImagePS3=Texture2D'TurokControllerButtons.PS3_Circle_0_HD'
    mButtonImageXBox360=Texture2D'TurokControllerButtons.HUD_360_B'
}