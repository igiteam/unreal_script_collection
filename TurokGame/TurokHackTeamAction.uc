class TurokHackTeamAction extends TurokHackAction
    native
    notplaceable
    hidecategories(Navigation);

// Export UTurokHackTeamAction::execIsRequirementsMet(FFrame&, void* const)
native function bool IsRequirementsMet();

// Export UTurokHackTeamAction::execOnComplete(FFrame&, void* const)
native function OnComplete();

defaultproperties
{
    mActivationMessageHash=-1175636490
    mActivationMessageHash2=-262721309
}