class TurokMoveObjectAction extends TurokContextAction
    native
    notplaceable
    hidecategories(Navigation);

var @NULL mController;

// Export UTurokMoveObjectAction::execIsRequirementsMet(FFrame&, void* const)
native function bool IsRequirementsMet();

// Export UTurokMoveObjectAction::execDrawHUD(FFrame&, void* const)
native simulated function DrawHUD(@NULL HUD);

// Export UTurokMoveObjectAction::execDrawActivationMessage(FFrame&, void* const)
native simulated function DrawActivationMessage(@NULL HUD);

defaultproperties
{
    mActivationMessageHash=-897614341
    mButtonImagePS3=Texture2D'TurokControllerButtons.PS3_Square_0_HD'
    mButtonImageXBox360=Texture2D'TurokControllerButtons.ButtonXAnim'
    mButtonImageFrames=2.0000000
    mButtonAnimLength=0.2500000
}