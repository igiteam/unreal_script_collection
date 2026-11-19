class TurokHackDuelAction extends TurokHackAction
    native
    notplaceable
    hidecategories(Navigation);

// Export UTurokHackDuelAction::execIsRequirementsMet(FFrame&, void* const)
native function bool IsRequirementsMet();

// Export UTurokHackDuelAction::execOnComplete(FFrame&, void* const)
native function OnComplete();

defaultproperties
{
    mActivationMessageHash=-1175636490
    mActivationMessageHash2=1310422195
}