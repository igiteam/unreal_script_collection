class SeqVar_LocalPlayerController extends SeqVar_Player
    native
    hidecategories(Object);

function Object GetObjectValue()
{
    local PlayerController PC;

    PC = PlayerController(ObjValue);
    // End:0x43
    if(PC == none)
    {
        // End:0x42
        foreach GetWorldInfo().LocalPlayerControllers(PC)
        {
            ObjValue = PC;
            // End:0x42
            break;            
        }        
    }
    return PC;
    //return ReturnValue;    
}

defaultproperties
{
    ObjName="Local PlayerController"
}