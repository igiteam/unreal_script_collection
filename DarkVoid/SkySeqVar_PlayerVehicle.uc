class SkySeqVar_PlayerVehicle extends SeqVar_Player
    native;

function Object GetObjectValue()
{
    local SkyVehicle Vehicle;
    local PlayerController PC;

    Vehicle = SkyVehicle(ObjValue);
    // End:0x63
    if(Vehicle == none)
    {
        // End:0x62
        foreach GetWorldInfo().AllControllers(Class'Engine.PlayerController', PC)
        {
            Vehicle = SkyVehicle(PC.Pawn);
            // End:0x61
            if(Vehicle != none)
            {
                // End:0x62
                break;
            }            
        }        
    }
    return Vehicle;
    //return ReturnValue;    
}
