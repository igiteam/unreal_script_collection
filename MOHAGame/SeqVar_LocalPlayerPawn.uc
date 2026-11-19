class SeqVar_LocalPlayerPawn extends SeqVar_Player
    native
    hidecategories(Object);

function Object GetObjectValue()
{
    local PlayerController PC;
    local Pawn P;

    P = Pawn(ObjValue);
    // End:0x57
    if(P == none)
    {
        // End:0x56
        foreach GetWorldInfo().LocalPlayerControllers(PC)
        {
            P = PC.Pawn;
            ObjValue = P;
            // End:0x56
            break;            
        }        
    }
    return P;
    //return ReturnValue;    
}

defaultproperties
{
    ObjName="Local Player's Pawn"
}