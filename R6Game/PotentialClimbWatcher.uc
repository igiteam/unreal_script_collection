class PotentialClimbWatcher extends Info
    native
    notplaceable
    hidecategories(lighting,Movement,Collision);

simulated function Tick(float DeltaTime)
{
    local Rotator PawnRot;
    local LadderVolume L;
    local bool bFound;

    // End:0x40
    if(((Owner == none) || Owner.bDeleteMe) || !Pawn(Owner).CanGrabLadder())
    {
        Destroy();
        return;
    }
    PawnRot = Owner.Rotation;
    PawnRot.Pitch = 0;
    // End:0xDE
    foreach Owner.TouchingActors(Class'LadderVolume', L)
    {
        // End:0xDD
        if(L.Encompasses(Owner))
        {
            // End:0xD5
            if((Vector(PawnRot) Dot L.LookDir) > 0.9000000)
            {
                Pawn(Owner).ClimbLadder(L);
                Destroy();                
                return;
                // End:0xDD
                continue;
            }
            bFound = true;
        }        
    }    
    // End:0xED
    if(!bFound)
    {
        Destroy();
    }
    return;
}
