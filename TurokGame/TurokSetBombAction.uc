class TurokSetBombAction extends TurokBombAction
    native
    notplaceable
    hidecategories(Navigation);

// Export UTurokSetBombAction::execIsRequirementsMet(FFrame&, void* const)
native function bool IsRequirementsMet();

// Export UTurokSetBombAction::execOnStart(FFrame&, void* const)
native function OnStart();

// Export UTurokSetBombAction::execOnComplete(FFrame&, void* const)
native function OnComplete();

// Export UTurokSetBombAction::execOnCancel(FFrame&, void* const)
native function OnCancel();

// Export UTurokSetBombAction::execOnInterrupt(FFrame&, void* const)
native function OnInterrupt();

event @NULL GetTransitionGraphSet()
{
    return mBomb.mSetBombGraphSet;
    //return ReturnValue;    
}

state Complete
{
    function NotifyGraphEndToLoco(@NULL graph, @NULL locoAsset, byte actorType)
    {
        local @NULL bombVolume, tph, out_HitLocation, out_HitNormal, bombLocation;

        bombVolume = TurokBombActionVolume(mVolume);
        // DebugMode: 0
        assert(bombVolume != none);
        tph = TurokPawnHuman(Controller(Owner).Pawn);
        // DebugMode: 0
        assert(tph != none);
        // DebugMode: 0
        assert(mBomb != none);
        tph.DetachInventory();
        tph.InvManager.RemoveFromInventory(mBomb);
        mBomb.Plant(tph);
        bombLocation = tph.Mesh.GetBoneLocation('jt_Aux1_C');
        tph.Trace(out_HitLocation, out_HitNormal, bombLocation - vect(0.0000000, 0.0000000, 100.0000000), bombLocation);
        bombLocation.Z = out_HitLocation.Z;
        mBomb.SetLocation(bombLocation);
        mBomb.SetRotation(tph.Rotation);
        bombVolume.OnBombPlanted(mBomb);
        mBomb = none;
        //return;        
    }
    stop;    
}

defaultproperties
{
    mActivationMessageHash=-1175636490
    mActivationMessageHash2=-815778986
}