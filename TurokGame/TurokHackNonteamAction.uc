class TurokHackNonteamAction extends TurokHackAction
    native
    notplaceable
    hidecategories(Navigation);

// Export UTurokHackNonteamAction::execIsRequirementsMet(FFrame&, void* const)
native function bool IsRequirementsMet();

// Export UTurokHackNonteamAction::execOnCancel(FFrame&, void* const)
native function OnCancel();

// Export UTurokHackNonteamAction::execOnInterrupt(FFrame&, void* const)
native function OnInterrupt();

// Export UTurokHackNonteamAction::execOnComplete(FFrame&, void* const)
native function OnComplete();

state Complete
{
    function BeginState(name PreviousState)
    {
        super.BeginState(PreviousState);
        //return;        
    }
    stop;    
}

defaultproperties
{
    mActivationMessageHash=-1175636490
    mActivationMessageHash2=-604043423
}