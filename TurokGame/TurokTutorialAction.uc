class TurokTutorialAction extends TurokContextAction
    abstract
    native
    notplaceable
    hidecategories(Navigation);

// Export UTurokTutorialAction::execIsRequirementsMet(FFrame&, void* const)
native function bool IsRequirementsMet();

// Export UTurokTutorialAction::execDrawHUD(FFrame&, void* const)
native simulated function DrawHUD(@NULL HUD);
