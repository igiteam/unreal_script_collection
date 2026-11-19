class TurokDefuseBombAction extends TurokBombAction
    native
    notplaceable
    hidecategories(Navigation);

// Export UTurokDefuseBombAction::execIsRequirementsMet(FFrame&, void* const)
native function bool IsRequirementsMet();

// Export UTurokDefuseBombAction::execOnStart(FFrame&, void* const)
native function OnStart();

// Export UTurokDefuseBombAction::execOnComplete(FFrame&, void* const)
native function OnComplete();

// Export UTurokDefuseBombAction::execOnCancel(FFrame&, void* const)
native function OnCancel();

// Export UTurokDefuseBombAction::execOnInterrupt(FFrame&, void* const)
native function OnInterrupt();

simulated function EndPrematurely()
{
    local @NULL bombVolume;

    // End:0x4B
    if(!IsFinished() && mVolume != none)
    {
        bombVolume = TurokBombActionVolume(mVolume);
        // End:0x4B
        if(bombVolume != none)
        {
            bombVolume.OnSimulatedDefuseHideBomb(false);
        }
    }
    super.EndPrematurely();
    //return;    
}

event @NULL GetTransitionGraphSet()
{
    return mBomb.mDefuseBombGraphSet;
    //return ReturnValue;    
}

state Inert
{
    function NotifyGraphEndToLoco(@NULL graph, @NULL locoAsset, byte actorType)
    {
        local @NULL bombVolume;

        super(TurokContextAction).NotifyGraphEndToLoco(graph, locoAsset, actorType);
        bombVolume = TurokBombActionVolume(mVolume);
        bombVolume.OnSimulatedDefuseHideBomb(false);
        //return;        
    }
    stop;    
}

state Complete
{
    function BeginState(name PreviousStateName)
    {
        local @NULL bombVolume, tph;

        bombVolume = TurokBombActionVolume(mVolume);
        // DebugMode: 0
        assert(bombVolume != none);
        tph = TurokPawnHuman(Controller(Owner).Pawn);
        // DebugMode: 0
        assert(tph != none);
        // DebugMode: 0
        assert(mBomb != none);
        mBomb.Defuse(tph);
        bombVolume.OnBombDefused();
        mBomb = none;
        //return;        
    }
    stop;    
}

defaultproperties
{
    mActivationMessageHash=-1175636490
    mActivationMessageHash2=2050081351
}