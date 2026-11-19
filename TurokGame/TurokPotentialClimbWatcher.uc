class TurokPotentialClimbWatcher extends PotentialClimbWatcher
    hidecategories(Navigation,Movement,Collision);

simulated function Tick(float DeltaTime)
{
    local @NULL npcController, TurokPawn, L;
    local bool bFound, bEncompasses;

    bFound = true;
    bEncompasses = false;
    TurokPawn = TurokPawn(Owner);
    // End:0x1BC
    if(((TurokPawn != none) && !TurokPawn.bDeleteMe) && !TurokPawn.IsInState('climbing'))
    {
        npcController = TurokAIController(TurokPawn.Controller);
        // End:0x19B
        if(npcController != none)
        {
            // End:0x19A
            foreach Owner.TouchingActors(Class'TurokLadderVolume', L)
            {
                TurokPawn.mLadderController.CacheAnimData(L);
                bEncompasses = L.Encompasses(TurokPawn);
                // End:0x173
                if(bEncompasses)
                {
                    // End:0x170
                    if(!TurokPawn.mLadderController.IsClimbing() && int(TurokPawn.Physics) != int(2))
                    {
                        // End:0x170
                        if(npcController.ShouldClimbLadder(L) && L.IsPawnAbleToClimb(TurokPawn))
                        {
                            TurokPawn.ClimbLadder(L);
                        }
                    }
                    // End:0x199
                    continue;
                }
                // End:0x199
                if(L.CompletelyOut(TurokPawn))
                {
                    bFound = false;
                    // End:0x19A
                    break;
                }                
            }            
        }
        // End:0x1BC
        if(TurokAIController(TurokPawn.Controller) == none)
        {
            bFound = false;
        }
    }
    // End:0x1CA
    if(!bFound)
    {
        Destroy();
    }
    //return;    
}

defaultproperties
{
    Components=none
}