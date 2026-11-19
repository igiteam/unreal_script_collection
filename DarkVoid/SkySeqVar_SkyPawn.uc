class SkySeqVar_SkyPawn extends SeqVar_Player
    native;

function Object GetObjectValue()
{
    local SkyPawn Pawn;
    local PlayerController PC;

    Pawn = SkyPawn(ObjValue);
    // End:0x63
    if(Pawn == none)
    {
        // End:0x62
        foreach GetWorldInfo().AllControllers(Class'Engine.PlayerController', PC)
        {
            Pawn = SkyPawn(PC.Pawn);
            // End:0x61
            if(Pawn != none)
            {
                // End:0x62
                break;
            }            
        }        
    }
    return Pawn;
    //return ReturnValue;    
}
