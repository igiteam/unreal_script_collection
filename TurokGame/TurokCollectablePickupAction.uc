class TurokCollectablePickupAction extends TurokContextAction
    native
    notplaceable
    hidecategories(Navigation);

// Export UTurokCollectablePickupAction::execIsRequirementsMet(FFrame&, void* const)
native function bool IsRequirementsMet();

// Export UTurokCollectablePickupAction::execIsFinished(FFrame&, void* const)
native function bool IsFinished();

// Export UTurokCollectablePickupAction::execDrawHUD(FFrame&, void* const)
native simulated function DrawHUD(@NULL HUD);

defaultproperties
{
    mButtonImagePS3=Texture2D'TurokControllerButtons.PS3_Circle_0_HD'
    mButtonImageXBox360=Texture2D'TurokControllerButtons.HUD_360_B'
}